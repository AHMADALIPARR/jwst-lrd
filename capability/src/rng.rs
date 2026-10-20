// SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
// Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
// Dual-licensed (intentionally): GNU AGPL-3.0-only plus the SnapKitty Opaque License.
//! OS CSPRNG: reads /dev/urandom (Linux kernel CSPRNG, same pool as getrandom(2)).
use std::fs::File;
use std::io::Read;

pub fn random_bytes(n: usize) -> std::io::Result<Vec<u8>> {
    let mut f = File::open("/dev/urandom")?;
    let mut v = vec![0u8; n];
    f.read_exact(&mut v)?;
    Ok(v)
}

pub fn random32() -> [u8; 32] {
    let v = random_bytes(32).expect("OS CSPRNG /dev/urandom unavailable");
    let mut a = [0u8; 32];
    a.copy_from_slice(&v);
    a
}
