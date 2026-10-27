/* Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 * Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
 * SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
 *
 * TASK 004 -- Goedel prime ledger (GMP integers). Two encodings, selected EXPLICITLY by
 * lrd_godel_mode_t, recorded in the ledger object (g->mode) and in the exported form.
 * Full specification: ledger/SPEC.md.
 *
 * Primes: p_1 = 2, p_2 = 3, ... from lrd_prime(i), an exact, deterministic incremental
 * trial-division table (no probabilistic test). Supported indices: 1..LRD_PRIME_MAX_INDEX.
 * lrd_prime(0) and lrd_prime(i > LRD_PRIME_MAX_INDEX) return 0; ledger operations that would need
 * such a prime return LRD_GODEL_E_PRIMECAP (see lrd_godel_pos_from_stream) or, when decoding a
 * cofactor that is not made of the supported primes, LRD_GODEL_E_EXTRA.
 *
 * Genesis (both modes): seq 0 is the EMPTY ledger, L = 1, n = 0, no primes used. The first
 * successful append yields seq 1 (n = 1); seq equals the number of appended records, one record
 * per seq, in ingestion order.
 *
 * ---- BIJ256 modes (LRD_GODEL_BIJ256_BYTES / LRD_GODEL_BIJ256_RECORDS) -- TINY ITEMS ONLY
 *   L = prod_{i=1..n} p_i ^ e_i, one prime per ITEM, e_i = bij256(s_i) + 1, where bij256 is
 *   bijective base-256 numeration (digit of byte b is b+1, digits 1..256, most significant first):
 *        bij256(b_1..b_k) = sum_{j=1..k} (b_j + 1) * 256^(k-j),   bij256(empty) = 0,
 *   a bijection {byte strings} -> N (closed form: int_be(s) + (256^k - 1)/255).
 *   RECORDS: s_i is the canonical LRD-REC-v1 serialization with the constant 11-byte magic
 *   "LRD-REC-v1\n" stripped; decode re-prepends it and strict-parses (else E_NONCANON).
 *   SIZE: log2 L ~ sum_i e_i log2 p_i with e_i ~ 2^(8 len_i): EXPONENTIAL in item length.
 *   Only items <= 2 bytes (and the empty record) fit under the default cap of 2^23 bits; the
 *   smallest one-field record body ("1:a1:b\n") has a 54-bit exponent (measured). Kept for
 *   backward compatibility; NOT suitable for real records.
 *
 * ---- POSITIONAL mode (LRD_GODEL_POSITIONAL) -- real-size records
 *   The whole ledger is ONE byte stream
 *        S = for each record r, in order:  be32(len(body_r)) || body_r
 *   where body_r is the canonical LRD-REC-v1 serialization of r with the 11-byte magic
 *   stripped (decode restores it byte-exact). Byte k of S (0-based) is carried by the
 *   (k+1)-th prime with exponent b_k + 1 in 1..256:
 *        L = prod_{k=0..|S|-1} p_{k+1} ^ (S[k] + 1).          (empty stream: L = 1)
 *   Append multiplies L by the new bytes' prime powers, continuing at index |S|+1.
 *   Decode is exact division in prime order, then strict framing + canonical-record parsing.
 *   SIZE: log2 L = sum_k (S[k]+1) log2 p_{k+1} <= 256 * sum_k log2 p_{k+1} ~ 256 |S| log2 p_|S|, i.e.
 *   O(|S| log |S|) with constant 256 in the worst case (all bytes 0xff) and ~ 128 |S| log2 p_|S| for uniformly random bytes:
 *   n log n growth in the stream length, not exponential. Default cap 2^26 bits (8 MiB).
 *
 * The integer L carries no mode tag: the same integer can be a valid ledger in both modes with
 * different meanings (e.g. 210 = 2*3*5*7 is four empty records in bij256-records mode and one
 * empty record in positional mode). The mode is therefore explicit in the API (cfg->mode must
 * equal g->mode, else LRD_GODEL_E_MODE) and recorded in the exported LRD-REC-v1 form.
 */
#ifndef LRD_GODEL_H
#define LRD_GODEL_H

#include <stddef.h>
#include <stdint.h>
#include <gmp.h>

typedef enum lrd_godel_err {
  LRD_GODEL_OK = 0,
  LRD_GODEL_E_NOTPOS,    /* L <= 0, or a parsed exponent <= 0 / sign on a parsed L */
  LRD_GODEL_E_GAP,       /* some prime p_j absent while a later sequence prime divides L
                            (positional: the missing prime sits between whole records) */
  LRD_GODEL_E_EXTRA,     /* cofactor not made of the next sequence primes (unknown factor) */
  LRD_GODEL_E_NONCANON,  /* exponent/body does not decode to a canonical LRD-REC-v1 record */
  LRD_GODEL_E_TOOBIG,    /* exceeds cfg.max_bits */
  LRD_GODEL_E_MISMATCH,  /* verification: decoded sequence differs from the claimed one */
  LRD_GODEL_E_ARG,       /* bad argument / bad item (e.g. not a canonical record) */
  LRD_GODEL_E_NOMEM,
  LRD_GODEL_E_ZEROEXP,   /* positional: exponent 0 (missing prime) INSIDE a record frame */
  LRD_GODEL_E_EXPRANGE,  /* positional: exponent > 256 */
  LRD_GODEL_E_FRAMING,   /* positional: truncated length prefix / length runs past the end */
  LRD_GODEL_E_MODE,      /* cfg->mode differs from the ledger's recorded mode */
  LRD_GODEL_E_LEN,       /* more than LRD_GODEL_MAX_LEN items */
  LRD_GODEL_E_PRIMECAP   /* a prime index above LRD_PRIME_MAX_INDEX is required */
} lrd_godel_err_t;

typedef enum lrd_godel_mode {
  LRD_GODEL_BIJ256_BYTES   = 0,
  LRD_GODEL_BIJ256_RECORDS = 1,
  LRD_GODEL_POSITIONAL     = 2
} lrd_godel_mode_t;
/* Backward-compatible names (bij256). */
#define LRD_GODEL_BYTES   LRD_GODEL_BIJ256_BYTES
#define LRD_GODEL_RECORDS LRD_GODEL_BIJ256_RECORDS

/* Maximum number of items (records) in one ledger, i.e. the maximum seq. Appending item
 * LRD_GODEL_MAX_LEN + 1 returns LRD_GODEL_E_LEN before any parsing or allocation. */
#define LRD_GODEL_MAX_LEN 1024u
/* Largest prime index supported by lrd_prime (p_65536 = 821641). */
#define LRD_PRIME_MAX_INDEX 65536u

#define LRD_GODEL_BIJ256_DEFAULT_MAX_BITS     ((size_t)1 << 23)   /* 1 MiB of L   */
#define LRD_GODEL_POSITIONAL_DEFAULT_MAX_BITS ((size_t)1 << 26)   /* 8 MiB of L   */

typedef struct lrd_godel_cfg {
  lrd_godel_mode_t mode;
  size_t max_bits;        /* hard cap on bit length of L (defaults above, per mode) */
  size_t gap_lookahead;   /* how many later sequence primes to test to classify GAP vs EXTRA */
} lrd_godel_cfg_t;

typedef struct lrd_bytes { unsigned char *b; size_t n; } lrd_bytes_t;

typedef struct lrd_godel {
  mpz_t            L;
  size_t           n;           /* number of items == seq (0 = genesis) */
  lrd_godel_mode_t mode;        /* recorded at init; every operation checks it */
  size_t           stream_len;  /* positional: |S| (bytes = primes used) */
} lrd_godel_t;

const char *lrd_godel_strerror(lrd_godel_err_t e);
const char *lrd_godel_mode_name(lrd_godel_mode_t m);   /* "bij256-bytes" | "bij256-records" | "positional" */
lrd_godel_cfg_t lrd_godel_default_cfg(lrd_godel_mode_t mode);

/* i-th prime, 1-based (p_1 = 2), 1 <= i <= LRD_PRIME_MAX_INDEX; 0 otherwise (or on allocation
 * failure). Not thread-safe. */
uint64_t lrd_prime(size_t i);

/* bij256 exponent mapping. */
void lrd_bij256_encode(mpz_t e, const unsigned char *s, size_t k);          /* e = bij256(s)+1 */
int  lrd_bij256_decode(const mpz_t e, unsigned char **s, size_t *k);        /* -1 if e < 1 */

/* Genesis ledger in the given mode: L = 1, seq 0. */
void lrd_godel_init(lrd_godel_t *g, lrd_godel_mode_t mode);
void lrd_godel_clear(lrd_godel_t *g);
size_t lrd_godel_seq(const lrd_godel_t *g);    /* 0 at genesis; +1 per successful append */
/* Multiplicative append. bij256: L' = L * p_{n+1}^{e(item)}; positional: L' = L * prod of the
 * new frame's prime powers. In RECORD/POSITIONAL modes `item` is the FULL canonical LRD-REC-v1
 * serialization. Order of checks: mode (E_MODE), item count (E_LEN, before the item is read or
 * anything is allocated), canonical record (E_ARG), size (E_TOOBIG). On error g is unchanged. */
lrd_godel_err_t lrd_godel_append(lrd_godel_t *g, const unsigned char *item, size_t len,
                                 const lrd_godel_cfg_t *cfg);
/* Historical decode in cfg->mode; recover every item (records returned with magic). */
lrd_godel_err_t lrd_godel_decode(const mpz_t L, const lrd_godel_cfg_t *cfg,
                                 lrd_bytes_t **items, size_t *n);
void lrd_bytes_free(lrd_bytes_t *items, size_t n);
lrd_godel_err_t lrd_godel_history(const mpz_t L, const lrd_godel_cfg_t *cfg, size_t i,
                                  lrd_bytes_t *out);
lrd_godel_err_t lrd_godel_verify_sequence(const mpz_t L, const lrd_godel_cfg_t *cfg,
                                          const lrd_bytes_t *items, size_t n);
lrd_godel_err_t lrd_godel_verify_prefix(const mpz_t L, const lrd_godel_cfg_t *cfg,
                                        const lrd_bytes_t *items, size_t k);
/* Code-level prefix: both decode cleanly, Lp | L, Lp's history is a prefix of L's, and (in
 * positional mode) the quotient L/Lp equals exactly prod_{k=|Sp|..|S|-1} p_{k+1}^(S[k]+1), i.e.
 * its factors are exactly the next primes with exponents in 1..256. */
lrd_godel_err_t lrd_godel_verify_prefix_code(const mpz_t Lp, const mpz_t L,
                                             const lrd_godel_cfg_t *cfg);

/* Positional low level. Raw stream -> L (NO framing/canonical validation; for tests/tooling),
 * and L -> raw stream (exact division in prime order with gap/extra/exponent-range checks, no
 * framing check). start_index is the 1-based index of the prime carrying s[0]; if
 * start_index + n - 1 > LRD_PRIME_MAX_INDEX the result is LRD_GODEL_E_PRIMECAP. */
lrd_godel_err_t lrd_godel_pos_from_stream(mpz_t L, const unsigned char *s, size_t n,
                                          size_t start_index, const lrd_godel_cfg_t *cfg);
lrd_godel_err_t lrd_godel_pos_to_stream(const mpz_t L, const lrd_godel_cfg_t *cfg,
                                        unsigned char **s, size_t *n);
/* Reference (per-prime mpz_remove) decoder with the same contract; slow, for cross-checks. */
lrd_godel_err_t lrd_godel_pos_to_stream_naive(const mpz_t L, const lrd_godel_cfg_t *cfg,
                                              unsigned char **s, size_t *n);

/* Parsing of externally supplied L (never decoded unless it parses):
 *  - lrd_godel_parse_hex: lowercase/uppercase hex digits only. "" -> E_ARG; a leading '-' or
 *    '+', or a value of 0 -> E_NOTPOS (so a non-positive L is rejected at parse).
 *  - lrd_godel_parse_factored: text "p^e p^e ..." (space separated, decimal). Any exponent <= 0
 *    (including "-3" and "0") -> E_NOTPOS; a base that is not prime -> E_ARG; a result that
 *    would exceed cfg->max_bits -> E_TOOBIG (checked before computing). Bases need not be
 *    sequence primes: unknown ones parse and are then refused by decode as E_EXTRA/E_GAP. */
lrd_godel_err_t lrd_godel_parse_hex(mpz_t L, const char *hex);
lrd_godel_err_t lrd_godel_parse_factored(mpz_t L, const char *text, const lrd_godel_cfg_t *cfg);

/* Exported form: LRD-REC-v1 record {format=LRD-GODEL-v1, L=<lowercase hex>, mode=<name>,
 * n=<items>}. Import parses L (lrd_godel_parse_hex), re-decodes it in the recorded mode and
 * checks n. */
int lrd_godel_export(const lrd_godel_t *g, unsigned char **out, size_t *len);
lrd_godel_err_t lrd_godel_import(lrd_godel_t *g, const unsigned char *rec, size_t len,
                                 const lrd_godel_cfg_t *cfg);

/* Envelope-aware append (recovery P0-A, unchanged behaviour: appends a zero-length marker item
 * in bij256-bytes mode; it does NOT encode the payload. Requires g->mode == BIJ256_BYTES,
 * else E_MODE). The payload is bound only through the caller-held envelope SHA-256. */
lrd_godel_err_t lrd_godel_append_envelope(lrd_godel_t *g,
                                          const unsigned char *payload, size_t plen,
                                          uint8_t flags,
                                          const lrd_godel_cfg_t *cfg);

#endif
