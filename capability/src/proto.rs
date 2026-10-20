// SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
// Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
// Dual-licensed (intentionally): GNU AGPL-3.0-only plus the SnapKitty Opaque License.
//! Line protocol over Unix stream sockets (documented in PROTOCOL.md).
//! Request: one line, LRD wire record `op=<OP> k=v ...\n`. Response: one line record.
use crate::rec::Rec;
use std::io::{BufRead, BufReader, Write};
use std::os::unix::net::UnixStream;
use std::path::Path;

pub const MAX_LINE: usize = 64 * 1024;

pub fn call(sock: &Path, req: &Rec) -> Result<Rec, String> {
    call_raw(sock, &req.to_line())
}

pub fn call_raw(sock: &Path, line: &str) -> Result<Rec, String> {
    let mut s = UnixStream::connect(sock).map_err(|e| format!("connect {}: {}", sock.display(), e))?;
    s.write_all(line.trim_end().as_bytes()).map_err(|e| e.to_string())?;
    s.write_all(b"\n").map_err(|e| e.to_string())?;
    let mut r = BufReader::new(s);
    let mut resp = String::new();
    r.read_line(&mut resp).map_err(|e| e.to_string())?;
    Rec::from_line(&resp)
}
