// SPDX-License-Identifier: AGPL-3.0-or-later OR LicenseRef-SnapKitty-Opaque
// Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
// Dual-licensed (intentionally): GNU AGPL-3.0-or-later plus the SnapKitty Opaque License.
//! Minimal vendored arbitrary-precision unsigned integers (u64 limbs, little-endian):
//! add, sub, mul, Knuth algorithm-D division, modexp. NOT constant-time: only used on
//! public values (modulus, accumulator, witnesses, primes). Cross-checked against openssl
//! in tests/capability/run.sh (RSA raw public/private operations).
use std::cmp::Ordering;

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct BigUint {
    l: Vec<u64>, // normalized: no trailing zero limbs; zero = empty
}

impl BigUint {
    pub fn zero() -> Self {
        BigUint { l: vec![] }
    }
    pub fn from_u64(x: u64) -> Self {
        let mut b = BigUint { l: vec![x] };
        b.norm();
        b
    }
    fn norm(&mut self) {
        while self.l.last() == Some(&0) {
            self.l.pop();
        }
    }
    pub fn is_zero(&self) -> bool {
        self.l.is_empty()
    }
    pub fn is_odd(&self) -> bool {
        self.l.first().map_or(false, |x| x & 1 == 1)
    }
    pub fn bits(&self) -> usize {
        match self.l.last() {
            None => 0,
            Some(&t) => self.l.len() * 64 - t.leading_zeros() as usize,
        }
    }
    pub fn bit(&self, i: usize) -> bool {
        self.l.get(i / 64).map_or(false, |x| (x >> (i % 64)) & 1 == 1)
    }
    pub fn from_bytes_be(b: &[u8]) -> Self {
        let mut l = vec![0u64; b.len().div_ceil(8)];
        for (i, &byte) in b.iter().rev().enumerate() {
            l[i / 8] |= (byte as u64) << (8 * (i % 8));
        }
        let mut r = BigUint { l };
        r.norm();
        r
    }
    pub fn to_bytes_be(&self) -> Vec<u8> {
        let mut v: Vec<u8> = Vec::new();
        for x in self.l.iter().rev() {
            v.extend_from_slice(&x.to_be_bytes());
        }
        let first = v.iter().position(|&c| c != 0).unwrap_or(v.len());
        v.drain(..first);
        v
    }
    /// Accepts upper/lower hex (openssl prints uppercase). Rejects empty/invalid.
    pub fn from_hex(s: &str) -> Option<Self> {
        let s = s.trim();
        if s.is_empty() {
            return None;
        }
        let mut l = vec![0u64; s.len().div_ceil(16)];
        for (i, c) in s.bytes().rev().enumerate() {
            let d = (c as char).to_digit(16)? as u64;
            l[i / 16] |= d << (4 * (i % 16));
        }
        let mut r = BigUint { l };
        r.norm();
        Some(r)
    }
    /// Canonical lowercase hex, no leading zeros ("0" for zero).
    pub fn to_hex(&self) -> String {
        if self.is_zero() {
            return "0".into();
        }
        let mut s = format!("{:x}", self.l.last().unwrap());
        for x in self.l.iter().rev().skip(1) {
            s.push_str(&format!("{:016x}", x));
        }
        s
    }
    /// Strict parser for wire values: canonical lowercase hex only.
    pub fn from_hex_canonical(s: &str) -> Option<Self> {
        if !s.bytes().all(|c| c.is_ascii_digit() || (b'a'..=b'f').contains(&c)) {
            return None;
        }
        let v = Self::from_hex(s)?;
        if v.to_hex() != s {
            return None;
        }
        Some(v)
    }

    pub fn add(&self, o: &Self) -> Self {
        let n = self.l.len().max(o.l.len());
        let mut r = Vec::with_capacity(n + 1);
        let mut c = 0u128;
        for i in 0..n {
            let s = *self.l.get(i).unwrap_or(&0) as u128 + *o.l.get(i).unwrap_or(&0) as u128 + c;
            r.push(s as u64);
            c = s >> 64;
        }
        r.push(c as u64);
        let mut b = BigUint { l: r };
        b.norm();
        b
    }
    /// self - o; panics if o > self.
    pub fn sub(&self, o: &Self) -> Self {
        assert!(self.cmp(o) != Ordering::Less, "BigUint underflow");
        let mut r = Vec::with_capacity(self.l.len());
        let mut borrow = 0u64;
        for i in 0..self.l.len() {
            let (d1, b1) = self.l[i].overflowing_sub(*o.l.get(i).unwrap_or(&0));
            let (d2, b2) = d1.overflowing_sub(borrow);
            r.push(d2);
            borrow = (b1 || b2) as u64;
        }
        let mut b = BigUint { l: r };
        b.norm();
        b
    }
    pub fn mul(&self, o: &Self) -> Self {
        if self.is_zero() || o.is_zero() {
            return Self::zero();
        }
        let mut r = vec![0u64; self.l.len() + o.l.len()];
        for (i, &a) in self.l.iter().enumerate() {
            let mut c = 0u128;
            for (j, &b) in o.l.iter().enumerate() {
                let t = a as u128 * b as u128 + r[i + j] as u128 + c;
                r[i + j] = t as u64;
                c = t >> 64;
            }
            r[i + o.l.len()] = c as u64;
        }
        let mut b = BigUint { l: r };
        b.norm();
        b
    }
    pub fn rem_u64(&self, d: u64) -> u64 {
        let mut r = 0u128;
        for &x in self.l.iter().rev() {
            r = ((r << 64) | x as u128) % d as u128;
        }
        r as u64
    }
    fn shl_limbs(l: &[u64], s: u32, extra: bool) -> Vec<u64> {
        let mut r = Vec::with_capacity(l.len() + 1);
        if s == 0 {
            r.extend_from_slice(l);
            if extra {
                r.push(0);
            }
            return r;
        }
        let mut carry = 0u64;
        for &x in l {
            r.push((x << s) | carry);
            carry = x >> (64 - s);
        }
        if extra {
            r.push(carry);
        } else {
            debug_assert_eq!(carry, 0);
        }
        r
    }
    /// Knuth TAOCP vol.2 4.3.1 algorithm D (as in Hacker's Delight divmnu, 64-bit limbs).
    pub fn divrem(&self, v: &Self) -> (Self, Self) {
        assert!(!v.is_zero(), "division by zero");
        if self.cmp(v) == Ordering::Less {
            return (Self::zero(), self.clone());
        }
        if v.l.len() == 1 {
            let d = v.l[0] as u128;
            let mut q = vec![0u64; self.l.len()];
            let mut r = 0u128;
            for i in (0..self.l.len()).rev() {
                let cur = (r << 64) | self.l[i] as u128;
                q[i] = (cur / d) as u64;
                r = cur % d;
            }
            let mut qb = BigUint { l: q };
            qb.norm();
            return (qb, Self::from_u64(r as u64));
        }
        let n = v.l.len();
        let m = self.l.len() - n;
        let s = v.l[n - 1].leading_zeros();
        let vn = Self::shl_limbs(&v.l, s, false);
        let mut un = Self::shl_limbs(&self.l, s, true);
        let mut q = vec![0u64; m + 1];
        const B: u128 = 1u128 << 64;
        for j in (0..=m).rev() {
            let num = ((un[j + n] as u128) << 64) | un[j + n - 1] as u128;
            let mut qhat = num / vn[n - 1] as u128;
            let mut rhat = num % vn[n - 1] as u128;
            while qhat >= B || qhat * vn[n - 2] as u128 > ((rhat << 64) | un[j + n - 2] as u128) {
                qhat -= 1;
                rhat += vn[n - 1] as u128;
                if rhat >= B {
                    break;
                }
            }
            let mut k: i128 = 0;
            for i in 0..n {
                let p = qhat * vn[i] as u128;
                let t: i128 = un[i + j] as i128 - k - (p & 0xffff_ffff_ffff_ffff) as i128;
                un[i + j] = t as u64;
                k = (p >> 64) as i128 - (t >> 64);
            }
            let t: i128 = un[j + n] as i128 - k;
            un[j + n] = t as u64;
            if t < 0 {
                qhat -= 1;
                let mut c = 0u128;
                for i in 0..n {
                    let t2 = un[i + j] as u128 + vn[i] as u128 + c;
                    un[i + j] = t2 as u64;
                    c = t2 >> 64;
                }
                un[j + n] = un[j + n].wrapping_add(c as u64);
            }
            q[j] = qhat as u64;
        }
        // remainder = un[0..n] >> s
        let mut r = vec![0u64; n];
        for i in 0..n {
            r[i] = if s == 0 { un[i] } else { (un[i] >> s) | (un[i + 1] << (64 - s)) };
        }
        let mut qb = BigUint { l: q };
        qb.norm();
        let mut rb = BigUint { l: r };
        rb.norm();
        (qb, rb)
    }
    pub fn rem(&self, m: &Self) -> Self {
        self.divrem(m).1
    }
    pub fn mulmod(&self, o: &Self, m: &Self) -> Self {
        self.mul(o).rem(m)
    }
    /// base^exp mod m (left-to-right square-and-multiply). m must be nonzero.
    pub fn modpow(&self, exp: &Self, m: &Self) -> Self {
        if m.l == [1] {
            return Self::zero();
        }
        let b = self.rem(m);
        let mut r = Self::from_u64(1);
        for i in (0..exp.bits()).rev() {
            r = r.mulmod(&r, m);
            if exp.bit(i) {
                r = r.mulmod(&b, m);
            }
        }
        r
    }
}

impl PartialOrd for BigUint {
    fn partial_cmp(&self, o: &Self) -> Option<Ordering> {
        Some(self.cmp(o))
    }
}
impl Ord for BigUint {
    fn cmp(&self, o: &Self) -> Ordering {
        if self.l.len() != o.l.len() {
            return self.l.len().cmp(&o.l.len());
        }
        for i in (0..self.l.len()).rev() {
            match self.l[i].cmp(&o.l[i]) {
                Ordering::Equal => continue,
                x => return x,
            }
        }
        Ordering::Equal
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::sha256::sha256;
    fn h(s: &str) -> BigUint {
        BigUint::from_hex(s).unwrap()
    }
    // deterministic pseudo-random big numbers from SHA-256 chains
    fn prand(seed: u32, bytes: usize) -> BigUint {
        let mut v = Vec::new();
        let mut c = 0u32;
        while v.len() < bytes {
            let mut inp = seed.to_be_bytes().to_vec();
            inp.extend_from_slice(&c.to_be_bytes());
            v.extend_from_slice(&sha256(&inp));
            c += 1;
        }
        v.truncate(bytes);
        BigUint::from_bytes_be(&v)
    }
    #[test]
    fn hex_and_bytes_roundtrip() {
        let x = h("1234567890abcdef1234567890abcdef00ff");
        assert_eq!(x.to_hex(), "1234567890abcdef1234567890abcdef00ff");
        assert_eq!(BigUint::from_bytes_be(&x.to_bytes_be()), x);
        assert_eq!(BigUint::zero().to_hex(), "0");
        assert!(BigUint::from_hex_canonical("00ab").is_none());
        assert!(BigUint::from_hex_canonical("AB").is_none());
    }
    #[test]
    fn small_known_values() {
        // 2^127-1 squared, checked by hand identity (a+1)^2 = a^2 + 2a + 1
        let a = h("7fffffffffffffffffffffffffffffff");
        let one = BigUint::from_u64(1);
        let lhs = a.add(&one).mul(&a.add(&one));
        let rhs = a.mul(&a).add(&a).add(&a).add(&one);
        assert_eq!(lhs, rhs);
        assert_eq!(BigUint::from_u64(4).modpow(&BigUint::from_u64(13), &BigUint::from_u64(497)), BigUint::from_u64(445));
        // Fermat: 3^(p-1) = 1 mod p for p = 2^127-1 (Mersenne prime)
        let p = a.clone();
        assert_eq!(BigUint::from_u64(3).modpow(&p.sub(&one), &p), one);
    }
    #[test]
    fn division_identity_randomized() {
        for seed in 0..300u32 {
            let a = prand(seed, 1 + (seed as usize * 13) % 300);
            let b = prand(seed + 10_000, 1 + (seed as usize * 7) % 160);
            if b.is_zero() {
                continue;
            }
            let (q, r) = a.divrem(&b);
            assert!(r < b, "remainder not reduced (seed {})", seed);
            assert_eq!(q.mul(&b).add(&r), a, "q*b+r != a (seed {})", seed);
        }
    }
    #[test]
    fn division_edge_cases() {
        // Cases that exercise qhat correction / add-back: divisor top limb all ones etc.
        let b = h("ffffffffffffffff0000000000000001");
        let a = h("fffffffffffffffeffffffffffffffff0000000000000000ffffffffffffffff");
        let (q, r) = a.divrem(&b);
        assert_eq!(q.mul(&b).add(&r), a);
        assert!(r < b);
        let b = h("8000000000000000000000000000000000000000000000000000000000000001");
        let a = b.mul(&b).sub(&BigUint::from_u64(1));
        let (q, r) = a.divrem(&b);
        assert_eq!(q.mul(&b).add(&r), a);
        assert!(r < b);
    }
}
