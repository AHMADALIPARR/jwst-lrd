// SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
// Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
// Dual-licensed (intentionally): GNU AGPL-3.0-only plus the SnapKitty Opaque License.
//! Miller-Rabin and deterministic hash-to-prime (256-bit primes) for the RSA accumulator.
use crate::bigint::BigUint;
use crate::sha256::Sha256;

const SMALL_PRIMES_LIMIT: u64 = 2000;

fn small_primes() -> Vec<u64> {
    (2..SMALL_PRIMES_LIMIT).filter(|&n| (2..n).take_while(|d| d * d <= n).all(|d| n % d != 0)).collect()
}

/// Miller-Rabin with `rounds` bases derived by hashing n (deterministic, reproducible by any
/// verifier). Error probability <= 4^-rounds for adversarially chosen n.
pub fn is_probable_prime(n: &BigUint, rounds: u32) -> bool {
    let two = BigUint::from_u64(2);
    if *n < two {
        return false;
    }
    for p in small_primes() {
        if n.rem_u64(p) == 0 {
            return *n == BigUint::from_u64(p);
        }
    }
    let one = BigUint::from_u64(1);
    let nm1 = n.sub(&one);
    let mut s = 0usize;
    while !nm1.bit(s) {
        s += 1;
    }
    // d = (n-1) >> s
    let mut d = nm1.clone();
    for _ in 0..s {
        d = d.divrem(&two).0;
    }
    let nm3 = n.sub(&BigUint::from_u64(3));
    'outer: for i in 0..rounds {
        let mut hs = Sha256::new();
        hs.update(b"LRD-MR-BASE-v1\0");
        hs.update(&n.to_bytes_be());
        hs.update(&i.to_be_bytes());
        let a = BigUint::from_bytes_be(&hs.finalize()).rem(&nm3).add(&two); // a in [2, n-2]
        let mut x = a.modpow(&d, n);
        if x == one || x == nm1 {
            continue;
        }
        for _ in 1..s {
            x = x.mulmod(&x, n);
            if x == nm1 {
                continue 'outer;
            }
        }
        return false;
    }
    true
}

/// H_prime(domain, data): first ctr >= 0 such that SHA256(domain || 0x00 || data || ctr_be64),
/// with the top and bottom bits forced to 1, is a probable prime. Returns (prime, ctr).
pub fn hash_to_prime(domain: &str, data: &[u8]) -> (BigUint, u64) {
    let mut ctr = 0u64;
    loop {
        let mut h = Sha256::new();
        h.update(domain.as_bytes());
        h.update(&[0]);
        h.update(data);
        h.update(&ctr.to_be_bytes());
        let mut d = h.finalize();
        d[0] |= 0x80;
        d[31] |= 1;
        let c = BigUint::from_bytes_be(&d);
        if is_probable_prime(&c, 40) {
            return (c, ctr);
        }
        ctr += 1;
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn known_primes_and_composites() {
        let mp127 = BigUint::from_hex("7fffffffffffffffffffffffffffffff").unwrap();
        assert!(is_probable_prime(&mp127, 40));
        // 2^128+1 is composite (= 59649589127497217 * 5704689200685129054721)
        let f7 = BigUint::from_hex("100000000000000000000000000000001").unwrap();
        assert!(!is_probable_prime(&f7, 40));
        // Carmichael number 561, and 3215031751 (strong pseudoprime to bases 2,3,5,7)
        assert!(!is_probable_prime(&BigUint::from_u64(561), 40));
        assert!(!is_probable_prime(&BigUint::from_u64(3215031751), 40));
        assert!(is_probable_prime(&BigUint::from_u64(1_000_000_007), 40));
        // 2^61-1 prime
        assert!(is_probable_prime(&BigUint::from_u64((1u64 << 61) - 1), 40));
    }
    #[test]
    fn hash_to_prime_deterministic_256bit() {
        let (p1, c1) = hash_to_prime("LRD-TEST", b"x");
        let (p2, c2) = hash_to_prime("LRD-TEST", b"x");
        assert_eq!((p1.clone(), c1), (p2, c2));
        assert_eq!(p1.bits(), 256);
        let (p3, _) = hash_to_prime("LRD-TEST", b"y");
        assert_ne!(p1, p3);
    }
}
