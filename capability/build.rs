// SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
// Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
// Dual-licensed (intentionally): GNU AGPL-3.0-only plus the SnapKitty Opaque License.
//! Compiles abi/lrd_abi_shim.c against the ledger track's lrd_state.h (no external crates).
//! Header directory: $LRD_STATE_H_DIR if set (e.g. a t004-ledger worktree's ledger/abi),
//! else the read-only vendored copy in abi/vendor (provenance in abi/vendor/SOURCE).
use std::env;
use std::path::PathBuf;
use std::process::Command;

fn main() {
    let out = PathBuf::from(env::var("OUT_DIR").unwrap());
    let hdr_dir = env::var("LRD_STATE_H_DIR").unwrap_or_else(|_| "abi/vendor".to_string());
    println!("cargo:rerun-if-changed=abi/lrd_abi_shim.c");
    println!("cargo:rerun-if-changed={}/lrd_state.h", hdr_dir);
    println!("cargo:rerun-if-env-changed=LRD_STATE_H_DIR");
    let cc = env::var("CC").unwrap_or_else(|_| "cc".to_string());
    let obj = out.join("lrd_abi_shim.o");
    let st = Command::new(&cc)
        .args(["-std=c17", "-O2", "-fPIC", "-Wall", "-Wextra", "-Werror", "-c", "abi/lrd_abi_shim.c", "-I"])
        .arg(&hdr_dir)
        .arg("-o")
        .arg(&obj)
        .status()
        .expect("failed to run C compiler");
    assert!(st.success(), "C compile of ABI shim against {}/lrd_state.h failed", hdr_dir);
    let lib = out.join("liblrd_abi_shim.a");
    let _ = std::fs::remove_file(&lib);
    let st = Command::new("ar").arg("crs").arg(&lib).arg(&obj).status().expect("ar");
    assert!(st.success());
    println!("cargo:rustc-link-search=native={}", out.display());
    println!("cargo:rustc-link-lib=static=lrd_abi_shim");
}
