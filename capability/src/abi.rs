// SPDX-License-Identifier: AGPL-3.0-or-later OR LicenseRef-SnapKitty-Opaque
// Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
// Dual-licensed (intentionally): GNU AGPL-3.0-or-later plus the SnapKitty Opaque License.
//! Rust mirror of ledger/abi/lrd_state.h (LRD-STATE-v1), owned by the ledger track.
//! The header is compiled UNMODIFIED into abi/lrd_abi_shim.c (see build.rs); this module
//! binds its helpers via FFI and mirrors its structs with #[repr(C)]. The `abi_conformance`
//! tests check the mirror's layout against the C compiler's view of the header.
use std::ffi::{CStr, CString};
use std::os::raw::{c_char, c_int, c_uint};

pub const KIND_CAPABILITY: c_int = 4; // LRD_KIND_CAPABILITY
pub const DECISION_REJECT: c_int = 0;
pub const DECISION_ACCEPT: c_int = 1;

#[repr(C)]
#[derive(Clone, Copy)]
pub struct LrdState {
    pub seq: u64,
    pub commit: [u8; 65],
    pub kind: c_int,
    pub payload_sha256: [u8; 65],
}

#[repr(C)]
#[derive(Clone, Copy)]
pub struct LrdDecision {
    pub decision: c_int,
    pub reason: [u8; 64],
    pub new_commit: [u8; 65],
}

#[repr(C)]
pub struct LrdField {
    pub key: *const c_char,
    pub key_len: usize,
    pub value: *const c_char,
    pub value_len: usize,
}

#[repr(C)]
pub struct LrdProposal {
    pub kind: c_int,
    pub prev_commit: [u8; 65],
    pub seq: u64,
    pub payload_sha256: [u8; 65],
    pub extra: *const LrdField,
    pub n_extra: usize,
}

extern "C" {
    fn lrdcap_kind_token(k: c_int) -> *const c_char;
    fn lrdcap_kind_from_token(s: *const c_char, n: usize) -> c_int;
    fn lrdcap_is_hex256(s: *const c_char) -> c_int;
    fn lrdcap_decision_reject(d: *mut LrdDecision, reason: *const c_char);
    fn lrdcap_abi_version() -> c_uint;
    fn lrdcap_rec_magic() -> *const c_char;
    fn lrdcap_commit_domain() -> *const c_char;
    fn lrdcap_commit_domain_len() -> usize;
    fn lrdcap_genesis_commit() -> *const c_char;
    fn lrdcap_reason_max() -> usize;
    fn lrdcap_layout(i: c_int) -> usize;
}

fn cstr(p: *const c_char) -> String {
    unsafe { CStr::from_ptr(p) }.to_string_lossy().into_owned()
}

pub fn kind_token(k: c_int) -> Option<String> {
    let p = unsafe { lrdcap_kind_token(k) };
    if p.is_null() {
        None
    } else {
        Some(cstr(p))
    }
}
pub fn kind_from_token(s: &str) -> c_int {
    unsafe { lrdcap_kind_from_token(s.as_ptr() as *const c_char, s.len()) }
}
/// Header's lrd_is_hex256 (exactly 64 lowercase hex chars).
pub fn is_hex256(s: &str) -> bool {
    match CString::new(s) {
        Ok(c) if s.len() == 64 => unsafe { lrdcap_is_hex256(c.as_ptr()) == 1 },
        _ => false,
    }
}
pub fn abi_version() -> u32 {
    unsafe { lrdcap_abi_version() }
}
pub fn rec_magic() -> String {
    cstr(unsafe { lrdcap_rec_magic() })
}
pub fn commit_domain() -> (String, usize) {
    (cstr(unsafe { lrdcap_commit_domain() }), unsafe { lrdcap_commit_domain_len() })
}
pub fn genesis_commit() -> String {
    cstr(unsafe { lrdcap_genesis_commit() })
}
pub fn reason_max() -> usize {
    unsafe { lrdcap_reason_max() }
}
pub fn c_layout(i: c_int) -> usize {
    unsafe { lrdcap_layout(i) }
}

/// Build a REJECT decision through the header's own helper (never touches state).
pub fn decision_reject(reason: &str) -> LrdDecision {
    let mut d = LrdDecision { decision: DECISION_ACCEPT, reason: [0; 64], new_commit: [b'x'; 65] };
    let c = CString::new(reason).expect("reason token has no NUL");
    unsafe { lrdcap_decision_reject(&mut d, c.as_ptr()) };
    d
}
pub fn decision_accept(new_commit: &str) -> LrdDecision {
    let mut d = LrdDecision { decision: DECISION_ACCEPT, reason: [0; 64], new_commit: [0; 65] };
    d.reason[..2].copy_from_slice(b"ok");
    d.new_commit[..64].copy_from_slice(new_commit.as_bytes());
    d
}
pub fn buf_str(b: &[u8]) -> String {
    let n = b.iter().position(|&c| c == 0).unwrap_or(b.len());
    String::from_utf8_lossy(&b[..n]).into_owned()
}
pub fn hex_buf(s: &str) -> [u8; 65] {
    let mut b = [0u8; 65];
    let n = s.len().min(64);
    b[..n].copy_from_slice(&s.as_bytes()[..n]);
    b
}

#[cfg(test)]
mod abi_conformance {
    use super::*;
    use std::mem::{offset_of, size_of};
    #[test]
    fn layout_matches_c_header() {
        let rust = [
            size_of::<LrdState>(),
            offset_of!(LrdState, seq),
            offset_of!(LrdState, commit),
            offset_of!(LrdState, kind),
            offset_of!(LrdState, payload_sha256),
            size_of::<LrdDecision>(),
            offset_of!(LrdDecision, decision),
            offset_of!(LrdDecision, reason),
            offset_of!(LrdDecision, new_commit),
            size_of::<c_int>(),
            size_of::<LrdProposal>(),
            offset_of!(LrdProposal, prev_commit),
            offset_of!(LrdProposal, seq),
            offset_of!(LrdProposal, payload_sha256),
            offset_of!(LrdProposal, extra),
            offset_of!(LrdProposal, n_extra),
            size_of::<LrdField>(),
        ];
        for (i, r) in rust.iter().enumerate() {
            assert_eq!(*r, c_layout(i as c_int), "layout entry {} differs", i);
        }
    }
    #[test]
    fn constants_match_contract() {
        assert_eq!(abi_version(), 1 << 16);
        assert_eq!(rec_magic(), "LRD-REC-v1\n");
        assert_eq!(commit_domain(), ("LRD-COMMIT-v1".to_string(), 14));
        assert_eq!(genesis_commit(), "0".repeat(64));
        assert_eq!(reason_max(), 63);
        assert_eq!(kind_token(KIND_CAPABILITY).as_deref(), Some("capability"));
        assert_eq!(kind_from_token("capability"), KIND_CAPABILITY);
        assert_eq!(kind_from_token("capabilityx"), 0);
        assert!(is_hex256(&"a".repeat(64)));
        assert!(!is_hex256(&"A".repeat(64)));
        assert!(!is_hex256(&"a".repeat(63)));
    }
    #[test]
    fn reject_helper_clears_new_commit() {
        let d = decision_reject("bad_mac");
        assert_eq!(d.decision, DECISION_REJECT);
        assert_eq!(buf_str(&d.reason), "bad_mac");
        assert_eq!(d.new_commit[0], 0);
    }
}
