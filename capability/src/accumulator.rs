// SPDX-License-Identifier: AGPL-3.0-or-later OR LicenseRef-SnapKitty-Opaque
// Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
// Dual-licensed (intentionally): GNU AGPL-3.0-or-later plus the SnapKitty Opaque License.
//! RSA accumulator (Benaloh-de Mare / Baric-Pfitzmann style, membership only).
//!   A_0 = g,  add(x): A <- A^{H_prime(x)} mod N,  witness(x) = g^{prod_{y != x} H_prime(y)},
//!   verify(A, x, w): w in [1, N) and w^{H_prime(x)} == A (mod N).
//! TRUSTED SETUP ASSUMPTION: N's factorization must be unknown to every party. Whoever knows
//! phi(N) can compute H_prime(x)-th roots and forge witnesses for non-members. Test moduli are
//! generated with `openssl genrsa` and the private key file is deleted (scripts/gen_modulus.sh);
//! that is a test convenience, NOT a trustworthy ceremony.
//! Soundness of `verify` relies on the strong RSA assumption plus hash-to-prime (see SECURITY.md).
//! CONTRACT (referenced by obligations.json "AccumulatorWitnessSound"): `verify_witness`.
//! NOTE: ledger/ (t004) and t005-rsaacc had no canonical accumulator when this was written;
//! if one lands, it should replace this module behind the same `verify_witness` contract.
use crate::bigint::BigUint;
use crate::prime::hash_to_prime;

pub const DOMAIN_STATE: &str = "LRD-ACC-STATE-v1";
pub const DOMAIN_RETIRED: &str = "LRD-ACC-RETIRED-v1";

#[derive(Clone, Debug)]
pub struct Params {
    pub n: BigUint,
    pub g: BigUint,
}

impl Params {
    /// g = 4 (a quadratic residue, standard choice); N must be >= 1024 bits.
    pub fn new(n: BigUint) -> Result<Self, String> {
        if n.bits() < 1024 || !n.is_odd() {
            return Err(format!("modulus must be odd and >= 1024 bits, got {} bits", n.bits()));
        }
        Ok(Params { n, g: BigUint::from_u64(4) })
    }
}

#[derive(Clone, Debug)]
pub struct Accumulator {
    pub params: Params,
    pub domain: &'static str,
    pub primes: Vec<BigUint>,
    pub value: BigUint,
}

pub fn element_prime(domain: &str, data: &[u8]) -> BigUint {
    hash_to_prime(domain, data).0
}

impl Accumulator {
    pub fn new(params: Params, domain: &'static str) -> Self {
        let value = params.g.clone();
        Accumulator { params, domain, primes: vec![], value }
    }
    /// Adds an element; returns its index. Duplicate elements are rejected by the caller.
    pub fn add(&mut self, data: &[u8]) -> usize {
        let p = element_prime(self.domain, data);
        self.value = self.value.modpow(&p, &self.params.n);
        self.primes.push(p);
        self.primes.len() - 1
    }
    /// Witness for element at index i, recomputed from g (O(k) modexps).
    pub fn witness(&self, i: usize) -> BigUint {
        let mut w = self.params.g.clone();
        for (j, p) in self.primes.iter().enumerate() {
            if j != i {
                w = w.modpow(p, &self.params.n);
            }
        }
        w
    }
    pub fn index_of(&self, data: &[u8]) -> Option<usize> {
        let p = element_prime(self.domain, data);
        self.primes.iter().position(|q| *q == p)
    }
}

/// THE witness-verification contract. The verifier recomputes the prime from the element
/// itself (a prover never supplies the prime).
pub fn verify_witness(params: &Params, domain: &str, acc_value: &BigUint, data: &[u8], w: &BigUint) -> bool {
    if w.is_zero() || *w >= params.n || *acc_value >= params.n {
        return false;
    }
    let p = element_prime(domain, data);
    w.modpow(&p, &params.n) == *acc_value
}

#[cfg(test)]
mod tests {
    use super::*;
    // SYNTHETIC 1024-bit modulus generated once by `openssl genrsa 1024`; private key deleted
    // immediately (fixtures/SYNTHETIC_unit_modulus_1024.hex). Functional tests only.
    const RSA1024: &str = include_str!("../fixtures/SYNTHETIC_unit_modulus_1024.hex");
    fn params() -> Params {
        Params::new(BigUint::from_hex(RSA1024.trim()).unwrap()).unwrap()
    }
    #[test]
    fn membership_roundtrip_and_tamper() {
        let mut a = Accumulator::new(params(), DOMAIN_STATE);
        for e in [b"alpha".as_ref(), b"beta", b"gamma"] {
            a.add(e);
        }
        for (i, e) in [b"alpha".as_ref(), b"beta", b"gamma"].iter().enumerate() {
            let w = a.witness(i);
            assert!(verify_witness(&a.params, DOMAIN_STATE, &a.value, e, &w));
            // witness for one element does not verify another
            assert!(!verify_witness(&a.params, DOMAIN_STATE, &a.value, b"delta", &w));
            // wrong domain
            assert!(!verify_witness(&a.params, DOMAIN_RETIRED, &a.value, e, &w));
            // tampered witness
            let bad = w.add(&BigUint::from_u64(1));
            assert!(!verify_witness(&a.params, DOMAIN_STATE, &a.value, e, &bad));
        }
        assert!(!verify_witness(&a.params, DOMAIN_STATE, &a.value, b"alpha", &BigUint::zero()));
        assert!(!verify_witness(&a.params, DOMAIN_STATE, &a.value, b"alpha", &a.params.n));
    }
    #[test]
    fn rejects_small_modulus() {
        assert!(Params::new(BigUint::from_u64(15)).is_err());
    }
}
