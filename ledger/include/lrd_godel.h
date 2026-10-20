/* Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 * Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
 * SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
 *
 * TASK 004 -- Goedel prime ledger.  L = prod_{i=1..n} p_i ^ e_i  (GMP integers).
 *
 *  - p_i: the i-th prime, p_1 = 2, p_2 = 3, ... produced by an exact, deterministic
 *    incremental trial-division table (lrd_prime). No probabilistic test is used.
 *  - e_i = bij256(s_i) + 1, where s_i is the byte string of item i and bij256 is bijective
 *    base-256 numeration (digit value of byte b is b+1, digits 1..256, most significant first):
 *        bij256(b_1..b_k) = sum_{j=1..k} (b_j + 1) * 256^(k-j),   bij256(empty) = 0.
 *    bij256 is a bijection {byte strings} -> N, hence e is a bijection {byte strings} -> N+ =
 *    {1,2,...}; every positive exponent decodes to exactly one byte string and back.
 *    Closed form used: bij256(s) = int_be(s) + (256^k - 1)/255.
 *  - RECORD mode: item i is an LRD-REC-v1 record; s_i is its canonical serialization WITH THE
 *    CONSTANT 11-BYTE MAGIC "LRD-REC-v1\n" STRIPPED (it is implicit and identical for every
 *    record, so stripping it keeps the map injective). Decoding re-prepends it and runs the
 *    strict canonical parser; an exponent whose bytes are not a canonical record is rejected
 *    as LRD_GODEL_E_NONCANON.
 *  - BYTES mode: items are arbitrary byte strings (every positive exponent is canonical).
 *
 * PRACTICAL SIZE LIMIT (honest): log2(L) ~ sum_i e_i * log2(p_i) and e_i ~ 256^len(s_i), so the
 * bit length of L is EXPONENTIAL in record length. A 2-byte item already needs ~65k * log2(p)
 * bits; the 7-byte body of the smallest one-field record ("1:a1:b\n") gives a 54-bit exponent
 * (measured by tests/ledger/test_godel.c), so L would need ~2^53 bits.
 * Every operation therefore enforces cfg.max_bits on L and refuses (LRD_GODEL_E_TOOBIG) before
 * allocating. Only very small items are feasible.
 */
#ifndef LRD_GODEL_H
#define LRD_GODEL_H

#include <stddef.h>
#include <stdint.h>
#include <gmp.h>

typedef enum lrd_godel_err {
  LRD_GODEL_OK = 0,
  LRD_GODEL_E_NOTPOS,    /* L <= 0 */
  LRD_GODEL_E_GAP,       /* some prime p_j absent while a later sequence prime divides L */
  LRD_GODEL_E_EXTRA,     /* cofactor not made of the next sequence primes (unknown factor) */
  LRD_GODEL_E_NONCANON,  /* exponent does not decode to a canonical item (record mode) */
  LRD_GODEL_E_TOOBIG,    /* exceeds cfg.max_bits */
  LRD_GODEL_E_MISMATCH,  /* verification: decoded sequence differs from the claimed one */
  LRD_GODEL_E_ARG,       /* bad argument / bad item (e.g. not a canonical record) */
  LRD_GODEL_E_NOMEM
} lrd_godel_err_t;

typedef enum lrd_godel_mode { LRD_GODEL_BYTES = 0, LRD_GODEL_RECORDS = 1 } lrd_godel_mode_t;

typedef struct lrd_godel_cfg {
  lrd_godel_mode_t mode;
  size_t max_bits;        /* hard cap on bit length of L (default 1<<23) */
  size_t gap_lookahead;   /* how many later sequence primes to test to classify GAP vs EXTRA */
} lrd_godel_cfg_t;

typedef struct lrd_bytes { unsigned char *b; size_t n; } lrd_bytes_t;

typedef struct lrd_godel {
  mpz_t  L;
  size_t n;               /* number of items */
} lrd_godel_t;

const char *lrd_godel_strerror(lrd_godel_err_t e);
lrd_godel_cfg_t lrd_godel_default_cfg(lrd_godel_mode_t mode);

/* i-th prime, 1-based (p_1 = 2). Returns 0 on allocation failure. Not thread-safe. */
uint64_t lrd_prime(size_t i);

/* Exponent mapping. */
void lrd_bij256_encode(mpz_t e, const unsigned char *s, size_t k);          /* e = bij256(s)+1 */
int  lrd_bij256_decode(const mpz_t e, unsigned char **s, size_t *k);        /* -1 if e < 1 */

void lrd_godel_init(lrd_godel_t *g);         /* empty ledger, L = 1 */
void lrd_godel_clear(lrd_godel_t *g);
/* Multiplicative append: L' = L * p_{n+1}^{e(item)}. On error, g is unchanged. */
lrd_godel_err_t lrd_godel_append(lrd_godel_t *g, const unsigned char *item, size_t len,
                                 const lrd_godel_cfg_t *cfg);
/* Historical decode: factor L by the known prime sequence; recover every item. */
lrd_godel_err_t lrd_godel_decode(const mpz_t L, const lrd_godel_cfg_t *cfg,
                                 lrd_bytes_t **items, size_t *n);
void lrd_bytes_free(lrd_bytes_t *items, size_t n);
/* Item i (0-based) of the history encoded by L. */
lrd_godel_err_t lrd_godel_history(const mpz_t L, const lrd_godel_cfg_t *cfg, size_t i,
                                  lrd_bytes_t *out);
/* Sequence verification: L encodes exactly items[0..n). */
lrd_godel_err_t lrd_godel_verify_sequence(const mpz_t L, const lrd_godel_cfg_t *cfg,
                                          const lrd_bytes_t *items, size_t n);
/* Prefix verification: items[0..k) is a prefix of the history encoded by L. */
lrd_godel_err_t lrd_godel_verify_prefix(const mpz_t L, const lrd_godel_cfg_t *cfg,
                                        const lrd_bytes_t *items, size_t k);
/* Code-level prefix: Lp is a well-formed ledger whose history is a prefix of L's history
 * (checks both divisibility Lp | L and decoded-sequence prefix). */
lrd_godel_err_t lrd_godel_verify_prefix_code(const mpz_t Lp, const mpz_t L,
                                             const lrd_godel_cfg_t *cfg);

#endif
