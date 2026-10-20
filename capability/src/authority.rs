// SPDX-License-Identifier: AGPL-3.0-or-later OR LicenseRef-SnapKitty-Opaque
// Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
// Dual-licensed (intentionally): GNU AGPL-3.0-or-later plus the SnapKitty Opaque License.
//! The independent monotonic-state authority (verifier). Owns:
//!   - K_auth (authority.key), the MAC key for capabilities;
//!   - the monotonic counter + head commitment + accepted-state history + capability table
//!     (authority.state, persisted atomically: write temp, fsync, rename, fsync dir);
//!   - two RSA accumulators: accepted state commitments and retired capability ids.
//! All of it lives in a directory the worker is not given. See SECURITY.md for what this does
//! and does NOT protect against.
use crate::abi;
use crate::accumulator::{verify_witness, Accumulator, Params, DOMAIN_RETIRED, DOMAIN_STATE};
use crate::bigint::BigUint;
use crate::cap::{Cap, Scope};
use crate::rec::{is_hex256, parse_nat, Rec};
use crate::rng::random32;
use crate::sha256::{hex, unhex};
use std::fs::{self, File, OpenOptions};
use std::io::{Read, Write};
use std::os::unix::fs::{OpenOptionsExt, PermissionsExt};
use std::path::{Path, PathBuf};
use std::time::{SystemTime, UNIX_EPOCH};

pub const STATE_FILE: &str = "authority.state";
pub const KEY_FILE: &str = "authority.key";
pub const MODULUS_FILE: &str = "modulus.hex";
pub const STATE_FORMAT: &str = "LRD-AUTH-STATE-v1";

pub fn now() -> u64 {
    SystemTime::now().duration_since(UNIX_EPOCH).unwrap().as_secs()
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum CapStatus {
    Issued,
    Consumed,
    Revoked,
}
impl CapStatus {
    fn token(self) -> &'static str {
        match self {
            CapStatus::Issued => "issued",
            CapStatus::Consumed => "consumed",
            CapStatus::Revoked => "revoked",
        }
    }
    fn parse(s: &str) -> Option<Self> {
        match s {
            "issued" => Some(CapStatus::Issued),
            "consumed" => Some(CapStatus::Consumed),
            "revoked" => Some(CapStatus::Revoked),
            _ => None,
        }
    }
}

/// An accepted LRD-STATE-v1 state of kind `capability`.
#[derive(Clone, Debug)]
pub struct StateRec {
    pub seq: u64,
    pub prev: String, // `commit` field of LRD-STATE-v1: commitment of the previous state
    pub payload_sha256: String,
    pub nonce: String, // kind-specific field `cap_nonce` (authority CSPRNG nonce)
}

impl StateRec {
    /// LRD-REC-v1 state record: {cap_nonce, commit, kind=capability, payload_sha256, seq}.
    /// Its commitment realizes commit = H(seq || prev_commit || state_hash || nonce).
    pub fn rec(&self) -> Rec {
        Rec::new()
            .with("cap_nonce", self.nonce.clone())
            .with("commit", self.prev.clone())
            .with("kind", abi::kind_token(abi::KIND_CAPABILITY).expect("header kind token"))
            .with("payload_sha256", self.payload_sha256.clone())
            .with("seq", self.seq.to_string())
    }
    pub fn commitment(&self) -> String {
        self.rec().commitment()
    }
}

pub struct Authority {
    pub dir: PathBuf,
    key: Vec<u8>,
    pub params: Params,
    pub states: Vec<StateRec>, // index == seq
    pub caps: Vec<(Cap, CapStatus)>,
    pub retired_order: Vec<String>, // cap ids in order added to the retired accumulator
    pub acc_states: Accumulator,
    pub acc_retired: Accumulator,
    pub persisted_seq: u64,
    pub log: Box<dyn FnMut(&str) + Send>,
}

fn write_atomic(dir: &Path, name: &str, data: &[u8], mode: u32) -> std::io::Result<()> {
    let tmp = dir.join(format!("{}.tmp", name));
    {
        let mut f = OpenOptions::new().write(true).create(true).truncate(true).mode(mode).open(&tmp)?;
        f.write_all(data)?;
        f.sync_all()?;
    }
    fs::rename(&tmp, dir.join(name))?;
    File::open(dir)?.sync_all()?; // persist the rename
    Ok(())
}

pub fn load_modulus(path: &Path) -> Result<BigUint, String> {
    let s = fs::read_to_string(path).map_err(|e| format!("read {}: {}", path.display(), e))?;
    let s = s.trim().trim_start_matches("Modulus=").to_ascii_lowercase();
    BigUint::from_hex(&s).ok_or_else(|| "bad modulus hex".to_string())
}

impl Authority {
    /// Create a fresh authority directory (fails if it already holds state: no silent reset).
    pub fn init(dir: &Path, modulus_path: &Path) -> Result<String, String> {
        fs::create_dir_all(dir).map_err(|e| e.to_string())?;
        fs::set_permissions(dir, fs::Permissions::from_mode(0o700)).map_err(|e| e.to_string())?;
        if dir.join(STATE_FILE).exists() || dir.join(KEY_FILE).exists() {
            return Err("authority directory already initialized; refusing to reset the counter".into());
        }
        let n = load_modulus(modulus_path)?;
        Params::new(n.clone())?;
        write_atomic(dir, MODULUS_FILE, format!("{}\n", n.to_hex()).as_bytes(), 0o644).map_err(|e| e.to_string())?;
        let key = random32();
        write_atomic(dir, KEY_FILE, format!("{}\n", hex(&key)).as_bytes(), 0o600).map_err(|e| e.to_string())?;
        let genesis = StateRec {
            seq: 0,
            prev: abi::genesis_commit(),
            payload_sha256: hex(&crate::sha256::sha256(b"")),
            nonce: hex(&random32()),
        };
        let mut a = Self::assemble(dir, key.to_vec(), Params::new(n)?, vec![genesis], vec![], vec![])?;
        a.persisted_seq = 0;
        a.persist_inner(true)?;
        Ok(a.head_commit())
    }

    fn assemble(
        dir: &Path,
        key: Vec<u8>,
        params: Params,
        states: Vec<StateRec>,
        caps: Vec<(Cap, CapStatus)>,
        retired_order: Vec<String>,
    ) -> Result<Self, String> {
        let mut acc_states = Accumulator::new(params.clone(), DOMAIN_STATE);
        for s in &states {
            acc_states.add(s.commitment().as_bytes());
        }
        let mut acc_retired = Accumulator::new(params.clone(), DOMAIN_RETIRED);
        for id in &retired_order {
            acc_retired.add(id.as_bytes());
        }
        Ok(Authority {
            dir: dir.to_path_buf(),
            key,
            params,
            states,
            caps,
            retired_order,
            acc_states,
            acc_retired,
            persisted_seq: 0,
            log: Box::new(|m| eprintln!("[authority] {}", m)),
        })
    }

    pub fn load(dir: &Path) -> Result<Self, String> {
        let key_hex = fs::read_to_string(dir.join(KEY_FILE)).map_err(|e| format!("key: {}", e))?;
        let key = unhex(key_hex.trim()).ok_or("bad key file")?;
        let n = load_modulus(&dir.join(MODULUS_FILE))?;
        let mut text = String::new();
        File::open(dir.join(STATE_FILE))
            .map_err(|e| format!("state file missing ({}); refusing to start with a reset counter", e))?
            .read_to_string(&mut text)
            .map_err(|e| e.to_string())?;
        let mut lines = text.lines();
        let hdr = Rec::from_line(lines.next().ok_or("empty state")?)?;
        if hdr.get("format") != Some(STATE_FORMAT) {
            return Err("bad state format".into());
        }
        let counter = parse_nat(hdr.get("seq").ok_or("no seq")?).ok_or("bad seq")?;
        let mut states = vec![];
        let mut caps = vec![];
        let mut retired = vec![];
        for l in lines {
            let r = Rec::from_line(l)?;
            match r.get("t") {
                Some("state") => states.push(StateRec {
                    seq: parse_nat(r.get("seq").ok_or("seq")?).ok_or("seq")?,
                    prev: r.get("commit").ok_or("commit")?.into(),
                    payload_sha256: r.get("payload_sha256").ok_or("payload")?.into(),
                    nonce: r.get("cap_nonce").ok_or("nonce")?.into(),
                }),
                Some("cap") => caps.push((
                    Cap::from_rec(&r).map_err(|e| e.to_string())?,
                    CapStatus::parse(r.get("status").ok_or("status")?).ok_or("status")?,
                )),
                Some("retired") => retired.push(r.get("cap_id").ok_or("cap_id")?.to_string()),
                _ => return Err(format!("unknown state line {:?}", l)),
            }
        }
        // integrity of the chain as stored
        for (i, s) in states.iter().enumerate() {
            if s.seq != i as u64 || (i > 0 && s.prev != states[i - 1].commitment()) {
                return Err(format!("stored chain broken at seq {}", i));
            }
        }
        if states.len() as u64 != counter + 1 {
            return Err("counter does not match stored chain".into());
        }
        let mut a = Self::assemble(dir, key, Params::new(n)?, states, caps, retired)?;
        if hdr.get("head") != Some(a.head_commit().as_str())
            || hdr.get("acc_states") != Some(a.acc_states.value.to_hex().as_str())
            || hdr.get("acc_retired") != Some(a.acc_retired.value.to_hex().as_str())
        {
            return Err("stored head/accumulator values do not match recomputation".into());
        }
        a.persisted_seq = counter;
        Ok(a)
    }

    pub fn head(&self) -> &StateRec {
        self.states.last().expect("genesis exists")
    }
    pub fn head_seq(&self) -> u64 {
        self.head().seq
    }
    pub fn head_commit(&self) -> String {
        self.head().commitment()
    }

    fn serialize_state(&self) -> String {
        let mut out = String::new();
        let hdr = Rec::new()
            .with("format", STATE_FORMAT)
            .with("seq", self.head_seq().to_string())
            .with("head", self.head_commit())
            .with("acc_states", self.acc_states.value.to_hex())
            .with("acc_retired", self.acc_retired.value.to_hex());
        out.push_str(&hdr.to_line());
        out.push('\n');
        for s in &self.states {
            out.push_str(&s.rec().with("t", "state").to_line());
            out.push('\n');
        }
        for (c, st) in &self.caps {
            out.push_str(&c.to_rec().with("t", "cap").with("status", st.token()).to_line());
            out.push('\n');
        }
        for id in &self.retired_order {
            out.push_str(&Rec::new().with("t", "retired").with("cap_id", id.clone()).to_line());
            out.push('\n');
        }
        out
    }

    /// Atomic persist with a monotonicity guard: the counter on disk never decreases.
    fn persist_inner(&mut self, initial: bool) -> Result<(), String> {
        let new_seq = self.head_seq();
        if !initial {
            if new_seq < self.persisted_seq {
                return Err(format!("monotonicity violation: {} < {}", new_seq, self.persisted_seq));
            }
            // re-read the on-disk counter too (detects a second authority instance racing us)
            let disk = fs::read_to_string(self.dir.join(STATE_FILE)).map_err(|e| e.to_string())?;
            let hdr = Rec::from_line(disk.lines().next().unwrap_or(""))?;
            let disk_seq = hdr.get("seq").and_then(parse_nat).ok_or("bad on-disk counter")?;
            if new_seq < disk_seq {
                return Err(format!("monotonicity violation vs disk: {} < {}", new_seq, disk_seq));
            }
        }
        write_atomic(&self.dir, STATE_FILE, self.serialize_state().as_bytes(), 0o600).map_err(|e| e.to_string())?;
        self.persisted_seq = new_seq;
        Ok(())
    }
    fn persist(&mut self) -> Result<(), String> {
        self.persist_inner(false)
    }

    fn find_cap(&self, id: &str) -> Option<usize> {
        self.caps.iter().position(|(c, _)| c.id == id)
    }

    fn retire(&mut self, idx: usize, status: CapStatus) {
        self.caps[idx].1 = status;
        let id = self.caps[idx].0.id.clone();
        if !self.retired_order.contains(&id) {
            self.acc_retired.add(id.as_bytes());
            self.retired_order.push(id);
        }
    }

    // ------------------------------------------------------------------ admin operations
    pub fn issue(&mut self, scope: Scope, ttl: u64) -> Result<Rec, String> {
        let mut id;
        loop {
            id = hex(&random32()[..16]);
            if self.find_cap(&id).is_none() {
                break;
            }
        }
        let mut nonce;
        loop {
            nonce = hex(&random32());
            let used = self.states.iter().any(|s| s.nonce == nonce) || self.caps.iter().any(|(c, _)| c.nonce == nonce);
            if !used {
                break;
            }
        }
        let seq = match scope {
            Scope::Transition => self.head_seq().checked_add(1).ok_or("counter exhausted")?,
            _ => self.head_seq(),
        };
        let cap = Cap { id, scope, seq, prev: self.head_commit(), nonce, expiry: now() + ttl, mac: String::new() }
            .sign(&self.key);
        self.caps.push((cap.clone(), CapStatus::Issued));
        self.persist()?;
        (self.log)(&format!("ISSUE cap_id={} scope={} cap_seq={} expiry={}", cap.id, scope.token(), cap.seq, cap.expiry));
        Ok(cap.to_rec())
    }

    pub fn revoke(&mut self, id: &str) -> Rec {
        match self.find_cap(id) {
            None => Rec::new().with("result", "unknown_cap"),
            Some(i) => {
                if self.caps[i].1 == CapStatus::Issued {
                    self.retire(i, CapStatus::Revoked);
                    if let Err(e) = self.persist() {
                        return Rec::new().with("result", "persist_failed").with("detail", e.replace(' ', "_"));
                    }
                }
                (self.log)(&format!("REVOKE cap_id={} status={}", id, self.caps[i].1.token()));
                Rec::new().with("result", "ok").with("status", self.caps[i].1.token())
            }
        }
    }

    // ------------------------------------------------------------------ capability checks
    /// Authenticate a presented capability: MAC, known, not revoked/consumed, not expired.
    fn check_cap(&self, r: &Rec) -> Result<(usize, Cap), &'static str> {
        let cap = Cap::from_rec(r)?;
        if !cap.mac_ok(&self.key) {
            return Err("bad_mac");
        }
        let idx = self.find_cap(&cap.id).ok_or("unknown_cap")?;
        if self.caps[idx].0 != cap {
            return Err("bad_mac");
        }
        match self.caps[idx].1 {
            CapStatus::Consumed => return Err("replay"),
            CapStatus::Revoked => return Err("retired"),
            CapStatus::Issued => {}
        }
        if now() > cap.expiry {
            return Err("expired");
        }
        Ok((idx, cap))
    }

    fn reject(&mut self, op: &str, reason: &str, extra: &str) -> Rec {
        // Built with the ledger header's own lrd_decision_reject helper; no state is created.
        let d = abi::decision_reject(reason);
        debug_assert_eq!(d.decision, abi::DECISION_REJECT);
        (self.log)(&format!("{} -> REJECT reason={} {}", op, abi::buf_str(&d.reason), extra));
        Rec::new()
            .with("decision", "REJECT")
            .with("reason", abi::buf_str(&d.reason))
            .with("head_seq", self.head_seq().to_string())
    }

    /// LRD-STATE-v1 transition gate for kind=capability. See SECURITY.md for the check order.
    pub fn submit(&mut self, p: &Rec) -> Rec {
        let tag = format!("SUBMIT seq={} prev={}", p.get("seq").unwrap_or("?"), p.get("prev_commit").unwrap_or("?"));
        // 1. shape (kind token and hex fields checked with the ledger header's helpers)
        if p.get("kind").map(abi::kind_from_token) != Some(abi::KIND_CAPABILITY) {
            return self.reject(&tag, "bad_kind", "");
        }
        let prev = p.get("prev_commit").unwrap_or("");
        let payload = p.get("payload_sha256").unwrap_or("");
        let seq = p.get("seq").and_then(parse_nat);
        if !abi::is_hex256(prev) || !abi::is_hex256(payload) || seq.is_none() {
            return self.reject(&tag, "malformed", "");
        }
        let seq = seq.unwrap();
        // 2. capability authentication & one-time status
        let (idx, cap) = match self.check_cap(p) {
            Ok(x) => x,
            Err(e) => return self.reject(&tag, e, ""),
        };
        if cap.scope != Scope::Transition {
            return self.reject(&tag, "bad_scope", &format!("cap_scope={}", cap.scope.token()));
        }
        if self.states.iter().any(|s| s.nonce == cap.nonce) {
            return self.reject(&tag, "replay", "nonce_already_committed");
        }
        // 3. CONSUME on first authenticated use, persisted before any further decision.
        self.retire(idx, CapStatus::Consumed);
        if let Err(e) = self.persist() {
            return self.reject(&tag, "persist_failed", &e);
        }
        // 4. sequence / rollback checks against the authority's own counter & head
        let head_seq = self.head_seq();
        if seq <= head_seq {
            return self.reject(&tag, "stale_seq", &format!("authority_seq={}", head_seq));
        }
        if head_seq == u64::MAX || seq != head_seq + 1 {
            return self.reject(&tag, "seq_gap", &format!("authority_seq={}", head_seq));
        }
        let head = self.head_commit();
        if prev != head {
            return self.reject(&tag, "bad_prev", &format!("authority_head={}", head));
        }
        // 5. linear addressing: the capability was issued for exactly this slot
        if cap.seq != seq || cap.prev != prev {
            return self.reject(&tag, "cap_binding", &format!("cap_seq={}", cap.seq));
        }
        // 6. proof gate: membership witness for prev_commit in the accepted-state accumulator
        let w = match p.get("prev_witness").and_then(BigUint::from_hex_canonical) {
            Some(w) => w,
            None => return self.reject(&tag, "bad_witness", "missing_or_noncanonical"),
        };
        if !verify_witness(&self.params, DOMAIN_STATE, &self.acc_states.value, prev.as_bytes(), &w) {
            return self.reject(&tag, "bad_witness", "");
        }
        // 7. the authority computes the new commitment itself
        let st = StateRec { seq, prev: prev.to_string(), payload_sha256: payload.to_string(), nonce: cap.nonce.clone() };
        let new_commit = st.commitment();
        if let Some(claim) = p.get("claimed_commit") {
            if claim != new_commit {
                return self.reject(&tag, "bad_commit", &format!("claimed={}", claim));
            }
        }
        // 8. ACCEPT: extend chain, bump counter, accumulate, persist atomically
        self.states.push(st);
        let i = self.acc_states.add(new_commit.as_bytes());
        if let Err(e) = self.persist() {
            // roll back in-memory only; disk still holds the previous (consistent) state
            self.states.pop();
            self.acc_states.primes.pop();
            let v = self.acc_states.witness(usize::MAX); // g^{prod of remaining primes}
            self.acc_states.value = v;
            return self.reject(&tag, "persist_failed", &e);
        }
        let d = abi::decision_accept(&new_commit);
        (self.log)(&format!("{} -> ACCEPT reason=ok new_commit={} counter={}", tag, new_commit, seq));
        Rec::new()
            .with("decision", "ACCEPT")
            .with("reason", abi::buf_str(&d.reason))
            .with("new_commit", abi::buf_str(&d.new_commit))
            .with("seq", seq.to_string())
            .with("cap_nonce", cap.nonce)
            .with("new_witness", self.acc_states.witness(i).to_hex())
            .with("acc_states", self.acc_states.value.to_hex())
    }

    fn state_reply(&self, s: &StateRec) -> Rec {
        let c = s.commitment();
        let i = self.acc_states.index_of(c.as_bytes()).expect("accepted state is accumulated");
        s.rec()
            .with("decision", "ACCEPT")
            .with("reason", "ok")
            .with("state_commit", c)
            .with("witness", self.acc_states.witness(i).to_hex())
            .with("acc_states", self.acc_states.value.to_hex())
            .with("head_seq", self.head_seq().to_string())
    }

    /// HEAD: needs a read or historical_read capability (never consumed).
    pub fn head_op(&mut self, r: &Rec) -> Rec {
        match self.check_cap(r) {
            Err(e) => self.reject("HEAD", e, ""),
            Ok((_, c)) if c.scope == Scope::Transition => self.reject("HEAD", "bad_scope", ""),
            Ok(_) => {
                let h = self.head().clone();
                self.state_reply(&h)
            }
        }
    }

    /// HISTORY: read a past committed state; requires historical_read; grants no transition right.
    pub fn history(&mut self, r: &Rec) -> Rec {
        let tag = format!("HISTORY seq={}", r.get("seq").unwrap_or("?"));
        let cap = match self.check_cap(r) {
            Err(e) => return self.reject(&tag, e, ""),
            Ok((_, c)) => c,
        };
        if cap.scope != Scope::HistoricalRead {
            return self.reject(&tag, "bad_scope", "");
        }
        let seq = match r.get("seq").and_then(parse_nat) {
            Some(s) => s,
            None => return self.reject(&tag, "malformed", ""),
        };
        if seq > cap.seq || seq > self.head_seq() {
            return self.reject(&tag, "out_of_range", &format!("cap_max_seq={}", cap.seq));
        }
        let s = self.states[seq as usize].clone();
        (self.log)(&format!("{} -> ACCEPT reason=ok (read-only)", tag));
        self.state_reply(&s)
    }

    /// VERIFY: public witness check against the authority's current accumulator values.
    pub fn verify(&mut self, r: &Rec) -> Rec {
        let (domain, acc) = match r.get("acc") {
            Some("state") => (DOMAIN_STATE, self.acc_states.value.clone()),
            Some("retired") => (DOMAIN_RETIRED, self.acc_retired.value.clone()),
            _ => return self.reject("VERIFY", "malformed", ""),
        };
        let el = r.get("element").unwrap_or("");
        let ok = match r.get("witness").and_then(BigUint::from_hex_canonical) {
            Some(w) => verify_witness(&self.params, domain, &acc, el.as_bytes(), &w),
            None => false,
        };
        if ok {
            (self.log)(&format!("VERIFY acc={} element={} -> ACCEPT", r.get("acc").unwrap(), el));
            Rec::new().with("decision", "ACCEPT").with("reason", "ok")
        } else {
            self.reject("VERIFY", "bad_witness", &format!("element={}", el))
        }
    }

    /// RETIRED_PROOF: membership witness that a capability id is retired (consumed/revoked).
    pub fn retired_proof(&mut self, r: &Rec) -> Rec {
        let id = r.get("cap_id").unwrap_or("");
        match self.retired_order.iter().position(|x| x == id) {
            None => self.reject("RETIRED_PROOF", "not_retired", id),
            Some(i) => Rec::new()
                .with("decision", "ACCEPT")
                .with("reason", "ok")
                .with("witness", self.acc_retired.witness(i).to_hex())
                .with("acc_retired", self.acc_retired.value.to_hex()),
        }
    }

    pub fn dispatch_worker(&mut self, r: &Rec) -> Rec {
        match r.get("op") {
            Some("SUBMIT") => {
                let mut p = r.clone();
                p.remove("op");
                self.submit(&p)
            }
            Some("HEAD") => self.head_op(r),
            Some("HISTORY") => self.history(r),
            Some("VERIFY") => self.verify(r),
            Some("RETIRED_PROOF") => self.retired_proof(r),
            Some("PARAMS") => Rec::new().with("decision", "ACCEPT").with("reason", "ok").with("modulus", self.params.n.to_hex()),
            _ => self.reject("?", "bad_op", ""),
        }
    }

    pub fn dispatch_admin(&mut self, r: &Rec) -> Rec {
        match r.get("op") {
            Some("ISSUE") => {
                let scope = match r.get("scope").and_then(Scope::parse) {
                    Some(s) => s,
                    None => return Rec::new().with("result", "bad_scope"),
                };
                let ttl = r.get("ttl").and_then(parse_nat).unwrap_or(300);
                match self.issue(scope, ttl) {
                    Ok(c) => c.with("result", "ok"),
                    Err(e) => Rec::new().with("result", "error").with("detail", e.replace(' ', "_")),
                }
            }
            Some("REVOKE") => self.revoke(r.get("cap_id").unwrap_or("")),
            Some("STATUS") => Rec::new()
                .with("result", "ok")
                .with("seq", self.head_seq().to_string())
                .with("head", self.head_commit())
                .with("persisted_seq", self.persisted_seq.to_string()),
            _ => Rec::new().with("result", "bad_op"),
        }
    }
}

/// Validate a 64-hex string (used by the worker; mirrors header helper).
pub fn hex256(s: &str) -> bool {
    is_hex256(s) && abi::is_hex256(s)
}
