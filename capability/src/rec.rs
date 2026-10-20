// SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
// Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
// Dual-licensed (intentionally): GNU AGPL-3.0-only plus the SnapKitty Opaque License.
//! LRD-REC-v1 canonical records (research/CONTRACTS.md) and the LRD-COMMIT-v1 commitment.
//! Wire form used on the socket: one line, fields `key=value` separated by single spaces.
//! Keys are [a-z0-9_]+, values must not contain space, newline, or be empty (hex, decimal, tokens).
use crate::sha256::{hex, Sha256};
use std::collections::BTreeMap;

#[derive(Clone, Debug, Default, PartialEq, Eq)]
pub struct Rec(pub BTreeMap<String, String>); // BTreeMap<String> = bytewise key order

impl Rec {
    pub fn new() -> Self {
        Rec(BTreeMap::new())
    }
    pub fn set(&mut self, k: &str, v: impl Into<String>) -> &mut Self {
        self.0.insert(k.to_string(), v.into());
        self
    }
    pub fn with(mut self, k: &str, v: impl Into<String>) -> Self {
        self.set(k, v);
        self
    }
    pub fn get(&self, k: &str) -> Option<&str> {
        self.0.get(k).map(|s| s.as_str())
    }
    pub fn remove(&mut self, k: &str) -> Option<String> {
        self.0.remove(k)
    }
    /// LRD-REC-v1 serialization: "LRD-REC-v1\n" then `<len(k)>:<k><len(v)>:<v>\n` per field.
    pub fn serialize(&self) -> Vec<u8> {
        let mut out = b"LRD-REC-v1\n".to_vec();
        for (k, v) in &self.0 {
            out.extend_from_slice(format!("{}:{}{}:{}\n", k.len(), k, v.len(), v).as_bytes());
        }
        out
    }
    /// SHA-256("LRD-COMMIT-v1\0" || serialization), lowercase hex.
    pub fn commitment(&self) -> String {
        let mut h = Sha256::new();
        h.update(b"LRD-COMMIT-v1\0");
        h.update(&self.serialize());
        hex(&h.finalize())
    }
    pub fn to_line(&self) -> String {
        self.0.iter().map(|(k, v)| format!("{}={}", k, v)).collect::<Vec<_>>().join(" ")
    }
    pub fn from_line(line: &str) -> Result<Rec, String> {
        let mut r = Rec::new();
        for tok in line.trim_end_matches(['\n', '\r']).split(' ').filter(|t| !t.is_empty()) {
            let (k, v) = tok.split_once('=').ok_or_else(|| format!("malformed field {:?}", tok))?;
            if k.is_empty() || !k.bytes().all(|c| c.is_ascii_lowercase() || c.is_ascii_digit() || c == b'_') {
                return Err(format!("bad key {:?}", k));
            }
            if v.is_empty() {
                return Err(format!("empty value for {}", k));
            }
            if r.0.insert(k.to_string(), v.to_string()).is_some() {
                return Err(format!("duplicate key {}", k));
            }
        }
        Ok(r)
    }
}

/// Canonical natural number: base-10, no leading zeros, fits u64.
pub fn parse_nat(s: &str) -> Option<u64> {
    if s.is_empty() || !s.bytes().all(|c| c.is_ascii_digit()) || (s.len() > 1 && s.starts_with('0')) {
        return None;
    }
    s.parse().ok()
}

pub fn is_hex256(s: &str) -> bool {
    s.len() == 64 && s.bytes().all(|c| c.is_ascii_digit() || (b'a'..=b'f').contains(&c))
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn serialization_is_sorted_and_length_prefixed() {
        let r = Rec::new().with("seq", "1").with("kind", "capability").with("commit", "ab");
        assert_eq!(
            String::from_utf8(r.serialize()).unwrap(),
            "LRD-REC-v1\n6:commit2:ab\n4:kind10:capability\n3:seq1:1\n"
        );
    }
    #[test]
    fn line_roundtrip_and_rejects() {
        let r = Rec::new().with("a", "1").with("b_2", "x=y");
        assert_eq!(Rec::from_line(&r.to_line()).unwrap(), r);
        assert!(Rec::from_line("a=1 a=2").is_err());
        assert!(Rec::from_line("A=1").is_err());
        assert!(Rec::from_line("a=").is_err());
    }
    #[test]
    fn nat_canonical() {
        assert_eq!(parse_nat("0"), Some(0));
        assert_eq!(parse_nat("10"), Some(10));
        assert_eq!(parse_nat("01"), None);
        assert_eq!(parse_nat("-1"), None);
        assert_eq!(parse_nat("18446744073709551616"), None);
    }
}
