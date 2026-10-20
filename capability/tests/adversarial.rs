// SPDX-License-Identifier: AGPL-3.0-or-later OR LicenseRef-SnapKitty-Opaque
// Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
// Dual-licensed (intentionally): GNU AGPL-3.0-or-later plus the SnapKitty Opaque License.
//! Adversarial multi-process tests. Each test starts a SEPARATE `lrd-authority serve` process
//! (own state directory, never passed to the worker) and drives the UNTRUSTED `lrd-worker`
//! binary as a separate process, including `--attack` modes where the worker corrupts its own
//! memory/state file. The test harness plays the operator (admin socket) only.
use lrd_capability::cap::{Cap, Scope};
use lrd_capability::proto::{call, call_raw};
use lrd_capability::rec::Rec;
use std::fs;
use std::path::{Path, PathBuf};
use std::process::{Child, Command, Stdio};
use std::time::{Duration, Instant};

const AUTH: &str = env!("CARGO_BIN_EXE_lrd-authority");
const WORKER: &str = env!("CARGO_BIN_EXE_lrd-worker");

struct Env {
    root: PathBuf,
    adir: PathBuf, // authority-only directory
    wdir: PathBuf, // worker directory
    sock: PathBuf,
    admin: PathBuf,
    modulus: PathBuf, // public copy given to the worker
    child: Option<Child>,
    ncap: usize,
}

fn gen_modulus(out: &Path) {
    let key = out.with_extension("pem");
    let st = Command::new("openssl").args(["genrsa", "-out"]).arg(&key).arg("2048").stderr(Stdio::null()).status().expect("openssl");
    assert!(st.success());
    let o = Command::new("openssl").args(["rsa", "-noout", "-modulus", "-in"]).arg(&key).output().unwrap();
    fs::remove_file(&key).unwrap(); // trusted-setup stand-in: factorization discarded
    fs::write(out, String::from_utf8(o.stdout).unwrap().trim().trim_start_matches("Modulus=")).unwrap();
}

impl Env {
    fn new(name: &str) -> Env {
        let root = PathBuf::from(format!("/tmp/lrdcap-{}-{}", name, std::process::id()));
        let _ = fs::remove_dir_all(&root);
        let adir = root.join("authority");
        let wdir = root.join("worker");
        fs::create_dir_all(&wdir).unwrap();
        let modulus = wdir.join("modulus.hex");
        gen_modulus(&modulus);
        let o = Command::new(AUTH).args(["init", "--dir"]).arg(&adir).arg("--modulus").arg(&modulus).output().unwrap();
        assert!(o.status.success(), "init failed: {}", String::from_utf8_lossy(&o.stderr));
        let mut e = Env { sock: root.join("w.sock"), admin: adir.join("admin.sock"), root, adir, wdir, modulus, child: None, ncap: 0 };
        e.start();
        e
    }
    fn log_path(&self) -> PathBuf {
        self.root.join("authority.log")
    }
    fn start(&mut self) {
        let _ = fs::remove_file(&self.sock);
        let log = fs::OpenOptions::new().create(true).append(true).open(self.log_path()).unwrap();
        let c = Command::new(AUTH)
            .args(["serve", "--dir"])
            .arg(&self.adir)
            .arg("--sock")
            .arg(&self.sock)
            .stderr(log)
            .spawn()
            .unwrap();
        self.child = Some(c);
        let t = Instant::now();
        while !(self.sock.exists() && call(&self.admin, &Rec::new().with("op", "STATUS")).is_ok()) {
            assert!(t.elapsed() < Duration::from_secs(20), "authority did not start");
            std::thread::sleep(Duration::from_millis(20));
        }
    }
    fn stop(&mut self) {
        if let Some(mut c) = self.child.take() {
            let _ = c.kill();
            let _ = c.wait();
        }
    }
    fn restart(&mut self) {
        self.stop();
        self.start();
    }
    fn status(&self) -> Rec {
        call(&self.admin, &Rec::new().with("op", "STATUS")).unwrap()
    }
    /// Operator issues a capability and hands it to the worker as a file.
    fn issue(&mut self, scope: &str, ttl: u64) -> PathBuf {
        let r = call(&self.admin, &Rec::new().with("op", "ISSUE").with("scope", scope).with("ttl", ttl.to_string())).unwrap();
        assert_eq!(r.get("result"), Some("ok"), "{:?}", r);
        self.ncap += 1;
        let p = self.wdir.join(format!("cap{}-{}.rec", self.ncap, scope));
        fs::write(&p, r.to_line()).unwrap();
        p
    }
    fn state(&self) -> PathBuf {
        self.wdir.join("worker.state")
    }
    fn worker(&self, args: &[&str]) -> (bool, Rec, String) {
        let o = Command::new(WORKER)
            .arg("--sock")
            .arg(&self.sock)
            .arg("--state")
            .arg(self.state())
            .arg("--modulus")
            .arg(&self.modulus)
            .args(args)
            .output()
            .unwrap();
        let out = String::from_utf8_lossy(&o.stdout).to_string();
        let err = String::from_utf8_lossy(&o.stderr).to_string();
        let rec = Rec::from_line(out.lines().last().unwrap_or("")).unwrap_or_default();
        (o.status.success(), rec, err)
    }
    fn sync(&mut self) {
        let c = self.issue("read", 60);
        let (ok, r, e) = self.worker(&["sync", "--cap", c.to_str().unwrap()]);
        assert!(ok, "sync failed {:?} {}", r, e);
    }
    fn transition(&mut self, payload: &str, attack: &str) -> (bool, Rec, String) {
        let c = self.issue("transition", 60);
        self.worker(&["transition", "--cap", c.to_str().unwrap(), "--payload", payload, "--attack", attack])
    }
    fn log(&self) -> String {
        fs::read_to_string(self.log_path()).unwrap_or_default()
    }
    fn seq(&self) -> String {
        self.status().get("seq").unwrap().to_string()
    }
}
impl Drop for Env {
    fn drop(&mut self) {
        self.stop();
        if std::env::var("LRDCAP_KEEP").is_err() {
            let _ = fs::remove_dir_all(&self.root);
        }
    }
}

fn reason(r: &Rec) -> &str {
    r.get("reason").unwrap_or("")
}
fn excerpt(log: &str, n: usize) -> String {
    let l: Vec<&str> = log.lines().collect();
    l[l.len().saturating_sub(n)..].join("\n")
}

#[test]
fn positive_control_honest_transitions_accepted() {
    let mut e = Env::new("pos");
    e.sync();
    for i in 1..=3 {
        let (ok, r, err) = e.transition(&format!("observation-{}", i), "none");
        assert!(ok, "honest transition {} rejected: {:?} {}", i, r, err);
        assert_eq!(r.get("decision"), Some("ACCEPT"));
        assert_eq!(r.get("seq"), Some(i.to_string().as_str()));
        assert!(err.contains("recomputed locally, witness verified"));
    }
    assert_eq!(e.seq(), "3");
    println!("POSITIVE CONTROL authority log:\n{}", excerpt(&e.log(), 8));
}

#[test]
fn acceptance_corrupted_worker_memory_is_refused_by_independent_authority() {
    let mut e = Env::new("accept");
    e.sync();
    let (ok, r1, _) = e.transition("honest-1", "none");
    assert!(ok);
    let honest_head = r1.get("new_commit").unwrap().to_string();
    let before = e.status();

    // (a1) worker mutates its in-memory state struct AND its state file to a valid-format but
    //      forged commitment, then submits with a fresh, valid transition capability.
    let (ok, r, werr) = e.transition("forged-payload", "corrupt-memory");
    assert!(!ok);
    assert_eq!(r.get("decision"), Some("REJECT"));
    assert_eq!(reason(&r), "bad_prev");
    assert!(r.get("new_commit").is_none(), "REJECT must not carry new_commit");
    let file = fs::read_to_string(e.state()).unwrap();
    assert!(!file.contains(&honest_head), "worker file really was corrupted");
    let after = e.status();
    assert_eq!(before.get("seq"), after.get("seq"), "authority counter unchanged");
    assert_eq!(before.get("head"), after.get("head"), "authority head unchanged");
    assert_eq!(after.get("head"), Some(honest_head.as_str()));
    assert!(e.log().contains("REJECT reason=bad_prev"));

    // (a2) worker claims a forged NEW commitment for an otherwise honest proposal
    e.sync();
    let (ok, r, _) = e.transition("x", "claim-forged");
    assert!(!ok);
    assert_eq!(reason(&r), "bad_commit");
    assert_eq!(e.status().get("head"), Some(honest_head.as_str()));

    // (a3) the forged commitment is not a member of the accepted-state accumulator
    let forged = Rec::from_line(&file).unwrap().get("head_commit").unwrap().to_string();
    let w = Rec::from_line(&file).unwrap().get("witness").unwrap().to_string();
    let v = call(&e.sock, &Rec::new().with("op", "VERIFY").with("acc", "state").with("element", forged).with("witness", w)).unwrap();
    assert_eq!(reason(&v), "bad_witness");

    // positive control after the attack: resync from the authority and continue honestly
    e.sync();
    let (ok, r, err) = e.transition("honest-2", "none");
    assert!(ok, "{:?} {}", r, err);
    assert_eq!(e.seq(), "2");
    println!("ACCEPTANCE worker stderr (attack run):\n{}", werr.trim_end());
    println!("ACCEPTANCE authority log excerpt:\n{}", excerpt(&e.log(), 12));
}

#[test]
fn state_file_tampered_externally_is_refused() {
    let mut e = Env::new("file");
    e.sync();
    assert!(e.transition("h1", "none").0);
    let s = fs::read_to_string(e.state()).unwrap();
    let r = Rec::from_line(&s).unwrap();
    let forged = format!("{}{}", &r.get("head_commit").unwrap()[..63], if s.contains("head_commit=0") { "1" } else { "0" });
    let mut r2 = r.clone();
    r2.set("head_commit", if forged == r.get("head_commit").unwrap() { "f".repeat(64) } else { forged });
    fs::write(e.state(), r2.to_line()).unwrap();
    let (ok, d, _) = e.transition("forged", "none");
    assert!(!ok);
    assert_eq!(reason(&d), "bad_prev");
    assert_eq!(e.seq(), "1");
}

#[test]
fn replay_of_consumed_capability_rejected() {
    let mut e = Env::new("replay");
    e.sync();
    assert!(e.transition("p1", "none").0);
    let last = e.state().with_extension("last_proposal");
    let (ok, r, _) = e.worker(&["raw", "--file", last.to_str().unwrap()]);
    assert!(!ok);
    assert_eq!(reason(&r), "replay");
    // same capability, honest worker, second use
    let c = e.issue("transition", 60);
    assert!(e.worker(&["transition", "--cap", c.to_str().unwrap(), "--payload", "p2"]).0);
    let (ok, r, _) = e.worker(&["transition", "--cap", c.to_str().unwrap(), "--payload", "p3"]);
    assert!(!ok);
    assert_eq!(reason(&r), "replay");
    assert_eq!(e.seq(), "2");
}

#[test]
fn rollback_rejected() {
    let mut e = Env::new("rollback");
    e.sync();
    assert!(e.transition("p1", "none").0);
    let old = fs::read_to_string(e.state()).unwrap();
    assert!(e.transition("p2", "none").0);
    // restore the older worker state (seq=1, old head) and try to build on it
    fs::write(e.state(), &old).unwrap();
    let (ok, r, _) = e.transition("fork", "none");
    assert!(!ok);
    assert_eq!(reason(&r), "stale_seq");
    // claim current seq but old prev_commit
    let mut o = Rec::from_line(&old).unwrap();
    o.set("seq", "2");
    fs::write(e.state(), o.to_line()).unwrap();
    let (ok, r, _) = e.transition("fork2", "none");
    assert!(!ok);
    assert_eq!(reason(&r), "bad_prev");
    // decrement own seq in memory
    e.sync();
    let (ok, r, _) = e.transition("fork3", "rollback-seq");
    assert!(!ok);
    assert_eq!(reason(&r), "stale_seq");
    assert_eq!(e.seq(), "2");
}

#[test]
fn forged_mac_rejected() {
    let mut e = Env::new("mac");
    e.sync();
    let (ok, r, _) = e.transition("p", "forge-mac");
    assert!(!ok);
    assert_eq!(reason(&r), "bad_mac");
    // worker edits the capability's bound seq without the key
    let c = e.issue("transition", 60);
    let mut rec = Rec::from_line(&fs::read_to_string(&c).unwrap()).unwrap();
    rec.set("cap_expiry", "4000000000");
    fs::write(&c, rec.to_line()).unwrap();
    let (ok, r, _) = e.worker(&["transition", "--cap", c.to_str().unwrap(), "--payload", "p"]);
    assert!(!ok);
    assert_eq!(reason(&r), "bad_mac");
    // fully self-minted capability with a guessed key
    let cap = Cap {
        id: "0123456789abcdef0123456789abcdef".into(),
        scope: Scope::Transition,
        seq: 1,
        prev: Rec::from_line(&fs::read_to_string(e.state()).unwrap()).unwrap().get("head_commit").unwrap().into(),
        nonce: "11".repeat(32),
        expiry: 4_000_000_000,
        mac: String::new(),
    }
    .sign(b"guessed-key");
    let f = e.wdir.join("selfmint.rec");
    fs::write(&f, cap.to_rec().to_line()).unwrap();
    let (ok, r, _) = e.worker(&["transition", "--cap", f.to_str().unwrap(), "--payload", "p"]);
    assert!(!ok);
    assert_eq!(reason(&r), "bad_mac");
    // the worker socket does not offer issuance
    let r = call(&e.sock, &Rec::new().with("op", "ISSUE").with("scope", "transition")).unwrap();
    assert_eq!(reason(&r), "bad_op");
    assert_eq!(e.seq(), "0");
}

#[test]
fn historical_read_cannot_transition() {
    let mut e = Env::new("hist");
    e.sync();
    assert!(e.transition("p1", "none").0);
    assert!(e.transition("p2", "none").0);
    let h = e.issue("historical_read", 60);
    let hs = h.to_str().unwrap().to_string();
    // reading past states works and the witness verifies locally
    for k in ["0", "1", "2"] {
        let (ok, r, err) = e.worker(&["history", "--cap", &hs, "--seq", k]);
        assert!(ok, "{:?}", r);
        assert!(err.contains("local_witness_check=true"), "{}", err);
    }
    // ... and is reusable (not consumed by reads)
    assert!(e.worker(&["history", "--cap", &hs, "--seq", "1"]).0);
    // ... but cannot transition
    let (ok, r, _) = e.worker(&["transition", "--cap", &hs, "--payload", "p3"]);
    assert!(!ok);
    assert_eq!(reason(&r), "bad_scope");
    // ... and relabelling its scope breaks the MAC
    let mut rec = Rec::from_line(&fs::read_to_string(&h).unwrap()).unwrap();
    rec.set("cap_scope", "transition");
    rec.set("cap_seq", "3");
    let f = e.wdir.join("relabel.rec");
    fs::write(&f, rec.to_line()).unwrap();
    let (ok, r, _) = e.worker(&["transition", "--cap", f.to_str().unwrap(), "--payload", "p3"]);
    assert!(!ok);
    assert_eq!(reason(&r), "bad_mac");
    // historical read cap can't read beyond its bound
    assert!(e.transition("p3", "none").0);
    let (ok, r, _) = e.worker(&["history", "--cap", &hs, "--seq", "3"]);
    assert!(!ok);
    assert_eq!(reason(&r), "out_of_range");
    // a transition cap is not a read cap
    let t = e.issue("transition", 60);
    let (ok, r, _) = e.worker(&["history", "--cap", t.to_str().unwrap(), "--seq", "0"]);
    assert!(!ok);
    assert_eq!(reason(&r), "bad_scope");
    assert_eq!(e.seq(), "3");
}

#[test]
fn consumed_capability_rejected_after_authority_restart() {
    let mut e = Env::new("restart");
    e.sync();
    assert!(e.transition("p1", "none").0);
    let last = e.state().with_extension("last_proposal");
    // a capability burned by a rejected attempt (one-time even on failure)
    let c = e.issue("transition", 60);
    let (ok, _, _) = e.worker(&["transition", "--cap", c.to_str().unwrap(), "--payload", "x", "--attack", "bad-witness"]);
    assert!(!ok);
    e.restart();
    assert_eq!(e.seq(), "1", "counter persisted across restart");
    let cid = Rec::from_line(&fs::read_to_string(&c).unwrap()).unwrap().get("cap_id").unwrap().to_string();
    let st = fs::read_to_string(e.adir.join("authority.state")).unwrap();
    assert!(st.lines().any(|l| l.contains(&cid) && l.contains("status=consumed")), "burned cap persisted as consumed");
    assert!(st.lines().any(|l| l.starts_with("cap_id=") && l.contains(&cid) && l.contains("t=retired")), "burned cap in retired accumulator list");
    let (ok, r, _) = e.worker(&["raw", "--file", last.to_str().unwrap()]);
    assert!(!ok);
    assert_eq!(reason(&r), "replay");
    let (ok, r, _) = e.worker(&["transition", "--cap", c.to_str().unwrap(), "--payload", "x"]);
    assert!(!ok);
    assert_eq!(reason(&r), "replay");
    // honest progress still possible after restart
    assert!(e.transition("p2", "none").0);
    e.restart();
    assert_eq!(e.seq(), "2");
    assert!(e.log().matches("loaded counter=").count() >= 3);
}

#[test]
fn capability_bound_to_exactly_one_slot() {
    let mut e = Env::new("slot");
    e.sync();
    let early = e.issue("transition", 60); // addresses slot (seq=1, prev=genesis)
    assert!(e.transition("p1", "none").0); // slot 1 filled with a different capability
    let (ok, r, _) = e.worker(&["transition", "--cap", early.to_str().unwrap(), "--payload", "p2"]);
    assert!(!ok);
    assert_eq!(reason(&r), "cap_binding");
    assert_eq!(e.seq(), "1");
}

#[test]
fn bad_accumulator_witness_rejected() {
    let mut e = Env::new("witness");
    e.sync();
    let (ok, r, _) = e.transition("p", "bad-witness");
    assert!(!ok);
    assert_eq!(reason(&r), "bad_witness");
    // missing witness
    let c = e.issue("transition", 60);
    let mut prop = Rec::from_line(&fs::read_to_string(&c).unwrap()).unwrap();
    prop.remove("result");
    let st = Rec::from_line(&fs::read_to_string(e.state()).unwrap()).unwrap();
    prop.set("op", "SUBMIT").set("kind", "capability").set("seq", "1").set("prev_commit", st.get("head_commit").unwrap()).set("payload_sha256", "ab".repeat(32));
    let r = call_raw(&e.sock, &prop.to_line()).unwrap();
    assert_eq!(reason(&r), "bad_witness");
    assert_eq!(e.seq(), "0");
}

#[test]
fn expiry_and_revocation() {
    let mut e = Env::new("expire");
    e.sync();
    let c = e.issue("transition", 0);
    std::thread::sleep(Duration::from_millis(2100));
    let (ok, r, _) = e.worker(&["transition", "--cap", c.to_str().unwrap(), "--payload", "p"]);
    assert!(!ok);
    assert_eq!(reason(&r), "expired");
    let c = e.issue("transition", 60);
    let id = Rec::from_line(&fs::read_to_string(&c).unwrap()).unwrap().get("cap_id").unwrap().to_string();
    let rv = call(&e.admin, &Rec::new().with("op", "REVOKE").with("cap_id", id.clone())).unwrap();
    assert_eq!(rv.get("status"), Some("revoked"));
    let (ok, r, _) = e.worker(&["transition", "--cap", c.to_str().unwrap(), "--payload", "p"]);
    assert!(!ok);
    assert_eq!(reason(&r), "retired");
    // retirement is provable from the retired-capability accumulator
    let p = call(&e.sock, &Rec::new().with("op", "RETIRED_PROOF").with("cap_id", id.clone())).unwrap();
    assert_eq!(p.get("decision"), Some("ACCEPT"));
    let v = call(&e.sock, &Rec::new().with("op", "VERIFY").with("acc", "retired").with("element", id).with("witness", p.get("witness").unwrap())).unwrap();
    assert_eq!(v.get("decision"), Some("ACCEPT"));
    assert_eq!(e.seq(), "0");
}

#[test]
fn counter_monotonic_and_no_silent_reset() {
    let mut e = Env::new("mono");
    e.sync();
    let mut seen = vec![];
    for i in 0..4 {
        let _ = e.transition(&format!("p{}", i), if i == 2 { "corrupt-memory" } else { "none" });
        if i == 2 {
            e.sync();
        }
        let hdr = Rec::from_line(fs::read_to_string(e.adir.join("authority.state")).unwrap().lines().next().unwrap()).unwrap();
        seen.push(hdr.get("seq").unwrap().parse::<u64>().unwrap());
    }
    assert!(seen.windows(2).all(|w| w[0] <= w[1]), "on-disk counter decreased: {:?}", seen);
    assert_eq!(seen, vec![1, 2, 2, 3]);
    assert!(!e.adir.join("authority.state.tmp").exists());
    // re-init refuses to reset an existing authority
    let o = Command::new(AUTH).args(["init", "--dir"]).arg(&e.adir).arg("--modulus").arg(&e.modulus).output().unwrap();
    assert!(!o.status.success());
    // a deleted state file is not silently replaced by a fresh counter
    e.stop();
    fs::rename(e.adir.join("authority.state"), e.root.join("moved.state")).unwrap();
    let o = Command::new(AUTH).args(["serve", "--dir"]).arg(&e.adir).arg("--sock").arg(e.root.join("x.sock")).output().unwrap();
    assert!(!o.status.success());
    assert!(String::from_utf8_lossy(&o.stderr).contains("refusing to start"));
    fs::rename(e.root.join("moved.state"), e.adir.join("authority.state")).unwrap();
    e.start();
    assert_eq!(e.seq(), "3");
}

// ---------------------------------------------------------------------------------------
// OUT OF SCOPE BY ASSUMPTION. These tests DEMONSTRATE THE STATED LIMIT: an attacker who can
// read or modify the authority's key/counter store (its trust anchor) defeats the scheme.
// They pass when the forgery SUCCEEDS, documenting that no protection is claimed here.
// ---------------------------------------------------------------------------------------

#[test]
fn out_of_scope_store_write_allows_rollback_and_replay() {
    let mut e = Env::new("oos-key");
    e.sync();
    let key_hex = fs::read_to_string(e.adir.join("authority.key")).unwrap();
    let key = lrd_capability::sha256::unhex(key_hex.trim()).unwrap();
    // The attacker cannot insert a self-minted cap into the authority's table, so it re-signs
    // a legitimately issued cap with altered fields (extended expiry): MAC check passes, but the
    // table comparison still catches it ...
    let c = e.issue("transition", 60);
    let mut cap = Cap::from_rec(&Rec::from_line(&fs::read_to_string(&c).unwrap()).unwrap()).unwrap();
    cap.expiry += 10_000;
    let cap = cap.sign(&key);
    let f = e.wdir.join("stolen-key.rec");
    fs::write(&f, cap.to_rec().to_line()).unwrap();
    let (ok, r, _) = e.worker(&["transition", "--cap", f.to_str().unwrap(), "--payload", "p"]);
    assert!(!ok && reason(&r) == "bad_mac");
    // ... but with WRITE access to the store as well, the attacker edits the table and
    // forges freely. We emulate by restoring a pre-consumption copy of authority.state.
    let c = e.issue("transition", 60);
    let snap = fs::read(e.adir.join("authority.state")).unwrap();
    assert!(e.worker(&["transition", "--cap", c.to_str().unwrap(), "--payload", "p1"]).0);
    e.stop();
    fs::write(e.adir.join("authority.state"), snap).unwrap(); // store rollback by the attacker
    e.start();
    assert_eq!(e.seq(), "0", "counter rolled back: the trust anchor was compromised");
    let last = e.state().with_extension("last_proposal");
    let (ok, r, _) = e.worker(&["raw", "--file", last.to_str().unwrap()]);
    assert!(ok, "OUT-OF-SCOPE: replay succeeds once the counter store is rolled back: {:?}", r);
    println!("OUT_OF_SCOPE demonstrated: store rollback + replay accepted (decision={:?})", r.get("decision"));
}

#[test]
fn out_of_scope_key_read_allows_mac_forgery() {
    let mut e = Env::new("oos-mac");
    e.sync();
    let key_hex = fs::read_to_string(e.adir.join("authority.key")).unwrap();
    let key = lrd_capability::sha256::unhex(key_hex.trim()).unwrap();
    let c = e.issue("transition", 60);
    let cap = Cap::from_rec(&Rec::from_line(&fs::read_to_string(&c).unwrap()).unwrap()).unwrap();
    // With the key, any MAC verifies: the authority cannot distinguish a stolen-key MAC.
    let re = cap.clone().sign(&key);
    assert_eq!(re.mac, cap.mac);
    let other = Cap { id: "ffffffffffffffffffffffffffffffff".into(), ..cap }.sign(&key);
    assert!(other.mac_ok(&key));
    println!("OUT_OF_SCOPE demonstrated: attacker holding authority.key computes valid MACs");
}
