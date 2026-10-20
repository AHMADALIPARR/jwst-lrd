// SPDX-License-Identifier: AGPL-3.0-or-later OR LicenseRef-SnapKitty-Opaque
// Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
// Dual-licensed (intentionally): GNU AGPL-3.0-or-later plus the SnapKitty Opaque License.
//! lrd-authority: the independent verifier process.
//!   lrd-authority init  --dir D --modulus FILE
//!   lrd-authority serve --dir D --sock WORKER_SOCK [--admin-sock ADMIN_SOCK (default D/admin.sock)]
//!   lrd-authority admin --admin-sock S <ISSUE scope=.. ttl=.. | REVOKE cap_id=.. | STATUS>
//!   lrd-authority selftest-modexp BASE_HEX EXP_HEX MOD_HEX     (prints result hex; openssl cross-check)
//!   lrd-authority selftest-h2p DOMAIN DATA                       (prints hash-to-prime hex)
use lrd_capability::authority::Authority;
use lrd_capability::bigint::BigUint;
use lrd_capability::prime::hash_to_prime;
use lrd_capability::proto::{call, MAX_LINE};
use lrd_capability::rec::Rec;
use std::io::{BufRead, BufReader, Read, Write};
use std::os::unix::fs::PermissionsExt;
use std::os::unix::net::{UnixListener, UnixStream};
use std::path::{Path, PathBuf};
use std::sync::{Arc, Mutex};

fn arg(args: &[String], name: &str) -> Option<String> {
    args.iter().position(|a| a == name).and_then(|i| args.get(i + 1).cloned())
}
fn die(m: &str) -> ! {
    eprintln!("lrd-authority: {}", m);
    std::process::exit(2)
}

fn serve_conn(a: &Arc<Mutex<Authority>>, s: UnixStream, admin: bool) {
    let mut w = match s.try_clone() {
        Ok(w) => w,
        Err(_) => return,
    };
    let reader = BufReader::new(s.take(MAX_LINE as u64 * 16));
    for line in reader.lines() {
        let line = match line {
            Ok(l) => l,
            Err(_) => return,
        };
        if line.len() > MAX_LINE {
            return;
        }
        let resp = match Rec::from_line(&line) {
            Err(e) => {
                eprintln!("[authority] malformed request: {}", e);
                Rec::new().with("decision", "REJECT").with("reason", "malformed")
            }
            Ok(r) => {
                let mut g = a.lock().unwrap_or_else(|p| p.into_inner());
                if admin {
                    if r.get("op") == Some("SHUTDOWN") {
                        eprintln!("[authority] SHUTDOWN requested on admin socket");
                        let _ = w.write_all(b"result=ok\n");
                        std::process::exit(0);
                    }
                    g.dispatch_admin(&r)
                } else {
                    g.dispatch_worker(&r)
                }
            }
        };
        if w.write_all(format!("{}\n", resp.to_line()).as_bytes()).is_err() {
            return;
        }
    }
}

fn listen(path: &Path) -> UnixListener {
    let _ = std::fs::remove_file(path);
    let l = UnixListener::bind(path).unwrap_or_else(|e| die(&format!("bind {}: {}", path.display(), e)));
    let _ = std::fs::set_permissions(path, std::fs::Permissions::from_mode(0o600));
    l
}

fn main() {
    let args: Vec<String> = std::env::args().collect();
    match args.get(1).map(|s| s.as_str()) {
        Some("init") => {
            let dir = arg(&args, "--dir").unwrap_or_else(|| die("--dir required"));
            let m = arg(&args, "--modulus").unwrap_or_else(|| die("--modulus required"));
            match Authority::init(Path::new(&dir), Path::new(&m)) {
                Ok(h) => println!("genesis_commit={}", h),
                Err(e) => die(&e),
            }
        }
        Some("serve") => {
            let dir = PathBuf::from(arg(&args, "--dir").unwrap_or_else(|| die("--dir required")));
            let sock = PathBuf::from(arg(&args, "--sock").unwrap_or_else(|| die("--sock required")));
            let admin = arg(&args, "--admin-sock").map(PathBuf::from).unwrap_or_else(|| dir.join("admin.sock"));
            let a = Authority::load(&dir).unwrap_or_else(|e| die(&e));
            eprintln!(
                "[authority] pid={} loaded counter={} head={} worker_sock={} admin_sock={}",
                std::process::id(),
                a.head_seq(),
                a.head_commit(),
                sock.display(),
                admin.display()
            );
            let a = Arc::new(Mutex::new(a));
            let la = listen(&admin);
            let lw = listen(&sock);
            let a2 = a.clone();
            std::thread::spawn(move || {
                for s in la.incoming().flatten() {
                    serve_conn(&a2, s, true);
                }
            });
            eprintln!("[authority] ready");
            for s in lw.incoming().flatten() {
                serve_conn(&a, s, false);
            }
        }
        Some("admin") => {
            let s = arg(&args, "--admin-sock").unwrap_or_else(|| die("--admin-sock required"));
            let i = args.iter().position(|a| a == "--admin-sock").unwrap() + 2;
            let op = args.get(i).unwrap_or_else(|| die("op required"));
            let mut r = Rec::new().with("op", op.clone());
            for kv in &args[i + 1..] {
                let (k, v) = kv.split_once('=').unwrap_or_else(|| die("k=v expected"));
                r.set(k, v);
            }
            match call(Path::new(&s), &r) {
                Ok(resp) => {
                    println!("{}", resp.to_line());
                    if resp.get("result") != Some("ok") {
                        std::process::exit(1);
                    }
                }
                Err(e) => die(&e),
            }
        }
        Some("selftest-modexp") => {
            let p = |i: usize| BigUint::from_hex(args.get(i).unwrap_or_else(|| die("3 hex args"))).unwrap_or_else(|| die("bad hex"));
            println!("{}", p(2).modpow(&p(3), &p(4)).to_hex());
        }
        Some("selftest-h2p") => {
            let (p, ctr) = hash_to_prime(&args[2], args[3].as_bytes());
            println!("{} ctr={}", p.to_hex(), ctr);
        }
        _ => die("usage: init|serve|admin|selftest-modexp|selftest-h2p (see source header)"),
    }
}
