// SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
// Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
// Dual-licensed (intentionally): GNU AGPL-3.0-only plus the SnapKitty Opaque License.
//! lrd-worker: UNTRUSTED state-transition worker. It holds its own writable state file and
//! in-memory state; nothing it holds is trusted by the authority. `--attack` modes make it a
//! privileged adversary over its own memory and files (for the adversarial test-suite).
//!   lrd-worker --sock S --state F --modulus M sync --cap CAPFILE
//!   lrd-worker --sock S --state F --modulus M transition --cap CAPFILE --payload TEXT [--attack MODE]
//!       MODE: none | corrupt-memory | forge-mac | bad-witness | claim-forged | rollback-seq
//!   lrd-worker --sock S --modulus M history --cap CAPFILE --seq K
//!   lrd-worker --sock S raw --file LINEFILE
use lrd_capability::accumulator::{verify_witness, Params, DOMAIN_STATE};
use lrd_capability::authority::{hex256, load_modulus, StateRec};
use lrd_capability::bigint::BigUint;
use lrd_capability::proto::{call, call_raw};
use lrd_capability::rec::{parse_nat, Rec};
use lrd_capability::sha256::{hex, sha256};
use std::fs;
use std::path::{Path, PathBuf};

fn arg(args: &[String], name: &str) -> Option<String> {
    args.iter().position(|a| a == name).and_then(|i| args.get(i + 1).cloned())
}
fn die(m: &str) -> ! {
    eprintln!("[worker] error: {}", m);
    std::process::exit(2)
}

/// The worker's in-memory state (writable by the worker, i.e. by the adversary).
#[derive(Debug, Clone)]
struct WorkerState {
    seq: u64,
    head_commit: String,
    witness: String,
}

impl WorkerState {
    fn load(p: &Path) -> WorkerState {
        let r = Rec::from_line(&fs::read_to_string(p).unwrap_or_else(|e| die(&format!("state file: {}", e))))
            .unwrap_or_else(|e| die(&e));
        WorkerState {
            seq: r.get("seq").and_then(parse_nat).unwrap_or_else(|| die("state seq")),
            head_commit: r.get("head_commit").unwrap_or_else(|| die("state head_commit")).into(),
            witness: r.get("witness").unwrap_or_else(|| die("state witness")).into(),
        }
    }
    fn save(&self, p: &Path) {
        let r = Rec::new()
            .with("seq", self.seq.to_string())
            .with("head_commit", self.head_commit.clone())
            .with("witness", self.witness.clone());
        let tmp = p.with_extension("tmp");
        fs::write(&tmp, format!("{}\n", r.to_line())).unwrap_or_else(|e| die(&e.to_string()));
        fs::rename(&tmp, p).unwrap_or_else(|e| die(&e.to_string()));
    }
}

fn read_cap(p: &str) -> Rec {
    let mut r = Rec::from_line(&fs::read_to_string(p).unwrap_or_else(|e| die(&format!("cap file: {}", e))))
        .unwrap_or_else(|e| die(&e));
    r.remove("result");
    r
}

fn report(resp: &Rec) -> ! {
    println!("{}", resp.to_line());
    std::process::exit(if resp.get("decision") == Some("ACCEPT") { 0 } else { 1 })
}

fn main() {
    let args: Vec<String> = std::env::args().collect();
    let sock = PathBuf::from(arg(&args, "--sock").unwrap_or_else(|| die("--sock required")));
    let state_path = arg(&args, "--state").map(PathBuf::from);
    let params = arg(&args, "--modulus").map(|m| Params::new(load_modulus(Path::new(&m)).unwrap_or_else(|e| die(&e))).unwrap_or_else(|e| die(&e)));
    let cmd = ["sync", "transition", "history", "raw"]
        .iter()
        .find(|c| args.iter().any(|a| a == **c))
        .unwrap_or_else(|| die("command required"));
    match *cmd {
        "sync" => {
            let cap = read_cap(&arg(&args, "--cap").unwrap_or_else(|| die("--cap")));
            let resp = call(&sock, &cap.with("op", "HEAD")).unwrap_or_else(|e| die(&e));
            if resp.get("decision") != Some("ACCEPT") {
                report(&resp);
            }
            let st = WorkerState {
                seq: resp.get("seq").and_then(parse_nat).unwrap(),
                head_commit: resp.get("state_commit").unwrap().into(),
                witness: resp.get("witness").unwrap().into(),
            };
            st.save(state_path.as_ref().unwrap_or_else(|| die("--state")));
            eprintln!("[worker] synced seq={} head={}", st.seq, st.head_commit);
            report(&resp);
        }
        "transition" => {
            let sp = state_path.unwrap_or_else(|| die("--state"));
            let params = params.unwrap_or_else(|| die("--modulus"));
            let cap = read_cap(&arg(&args, "--cap").unwrap_or_else(|| die("--cap")));
            let payload = arg(&args, "--payload").unwrap_or_default();
            let attack = arg(&args, "--attack").unwrap_or_else(|| "none".into());
            let mut st = WorkerState::load(&sp); // from the worker's own writable file
            eprintln!("[worker] pid={} loaded state seq={} head={}", std::process::id(), st.seq, st.head_commit);
            let mut prop = Rec::new();
            for (k, v) in &cap.0 {
                prop.set(k, v.clone());
            }
            match attack.as_str() {
                "corrupt-memory" => {
                    // Privileged adversary: overwrite the in-memory state struct AND the state
                    // file with a well-formed but forged commitment (and a witness copied from the
                    // honest state, the best the worker has).
                    let forged = hex(&sha256(format!("FORGED-STATE:{}:{}", st.seq, st.head_commit).as_bytes()));
                    eprintln!("[worker] ATTACK corrupt-memory: in-memory head_commit {} -> {}", st.head_commit, forged);
                    st.head_commit = forged;
                    st.save(&sp);
                    eprintln!("[worker] ATTACK corrupt-memory: state file {} rewritten with forged commit", sp.display());
                }
                "rollback-seq" => {
                    st.seq = st.seq.saturating_sub(1);
                    eprintln!("[worker] ATTACK rollback-seq: claiming seq={}", st.seq);
                }
                _ => {}
            }
            let seq = st.seq + 1;
            prop.set("kind", "capability")
                .set("prev_commit", st.head_commit.clone())
                .set("seq", seq.to_string())
                .set("payload_sha256", hex(&sha256(payload.as_bytes())))
                .set("prev_witness", st.witness.clone());
            match attack.as_str() {
                "forge-mac" => {
                    // flip the last nibble of the MAC (the worker does not know K_auth)
                    let m = prop.get("cap_mac").unwrap().to_string();
                    let last = if m.ends_with('0') { '1' } else { '0' };
                    let forged = format!("{}{}", &m[..63], last);
                    eprintln!("[worker] ATTACK forge-mac: cap_mac -> {}", forged);
                    prop.set("cap_mac", forged);
                }
                "bad-witness" => {
                    let w = BigUint::from_hex(&st.witness).unwrap().add(&BigUint::from_u64(2));
                    eprintln!("[worker] ATTACK bad-witness: prev_witness altered");
                    prop.set("prev_witness", w.to_hex());
                }
                "claim-forged" => {
                    let forged = hex(&sha256(b"claimed-forged-new-state"));
                    eprintln!("[worker] ATTACK claim-forged: claimed_commit={}", forged);
                    prop.set("claimed_commit", forged);
                }
                _ => {}
            }
            let line = prop.clone().with("op", "SUBMIT").to_line();
            let _ = fs::write(sp.with_extension("last_proposal"), format!("{}\n", line));
            let resp = call_raw(&sock, &line).unwrap_or_else(|e| die(&e));
            if resp.get("decision") == Some("ACCEPT") {
                // honest worker double-checks the authority's answer before adopting it
                let mine = StateRec {
                    seq,
                    prev: st.head_commit.clone(),
                    payload_sha256: hex(&sha256(payload.as_bytes())),
                    nonce: resp.get("cap_nonce").unwrap().into(),
                }
                .commitment();
                let nc = resp.get("new_commit").unwrap();
                if mine != nc || !hex256(nc) {
                    die("authority returned a commitment I cannot reproduce");
                }
                let acc = BigUint::from_hex(resp.get("acc_states").unwrap()).unwrap();
                let w = BigUint::from_hex(resp.get("new_witness").unwrap()).unwrap();
                if !verify_witness(&params, DOMAIN_STATE, &acc, nc.as_bytes(), &w) {
                    die("authority returned a witness that does not verify");
                }
                WorkerState { seq, head_commit: nc.into(), witness: w.to_hex() }.save(&sp);
                eprintln!("[worker] ACCEPT seq={} new_commit={} (recomputed locally, witness verified)", seq, nc);
            } else {
                eprintln!("[worker] authority REJECTED: reason={}", resp.get("reason").unwrap_or("?"));
            }
            report(&resp);
        }
        "history" => {
            let cap = read_cap(&arg(&args, "--cap").unwrap_or_else(|| die("--cap")));
            let seq = arg(&args, "--seq").unwrap_or_else(|| die("--seq"));
            let resp = call(&sock, &cap.with("op", "HISTORY").with("seq", seq)).unwrap_or_else(|e| die(&e));
            if resp.get("decision") == Some("ACCEPT") {
                if let Some(p) = params {
                    let acc = BigUint::from_hex(resp.get("acc_states").unwrap()).unwrap();
                    let w = BigUint::from_hex(resp.get("witness").unwrap()).unwrap();
                    let c = resp.get("state_commit").unwrap();
                    let ok = verify_witness(&p, DOMAIN_STATE, &acc, c.as_bytes(), &w);
                    eprintln!("[worker] history seq={} commit={} local_witness_check={}", resp.get("seq").unwrap(), c, ok);
                }
            }
            report(&resp);
        }
        "raw" => {
            let f = arg(&args, "--file").unwrap_or_else(|| die("--file"));
            let line = fs::read_to_string(&f).unwrap_or_else(|e| die(&e.to_string()));
            eprintln!("[worker] RAW resend of {}", f);
            report(&call_raw(&sock, &line).unwrap_or_else(|e| die(&e)));
        }
        _ => unreachable!(),
    }
}
