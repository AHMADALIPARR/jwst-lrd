/* Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 * Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
 * SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
 *
 * TASK 004 -- Goedel prime ledger implementation. See include/lrd_godel.h and ledger/SPEC.md.
 */
#include "lrd_godel.h"
#include "lrd_rec.h"
#include "lrd_env.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static lrd_godel_err_t pos_check_quotient(const mpz_t Lp, const mpz_t L, const lrd_godel_cfg_t *cfg);
static lrd_godel_err_t pos_decode(const mpz_t L, const lrd_godel_cfg_t *cfg,
                                  lrd_bytes_t **items, size_t *n, size_t *stream_len);

const char *lrd_godel_strerror(lrd_godel_err_t e) {
  switch (e) {
    case LRD_GODEL_OK: return "ok";
    case LRD_GODEL_E_NOTPOS: return "not_positive";
    case LRD_GODEL_E_GAP: return "gap";
    case LRD_GODEL_E_EXTRA: return "extra_factor";
    case LRD_GODEL_E_NONCANON: return "non_canonical_exponent";
    case LRD_GODEL_E_TOOBIG: return "too_big";
    case LRD_GODEL_E_MISMATCH: return "mismatch";
    case LRD_GODEL_E_ARG: return "bad_argument";
    case LRD_GODEL_E_NOMEM: return "out_of_memory";
    case LRD_GODEL_E_ZEROEXP: return "zero_exponent_in_stream";
    case LRD_GODEL_E_EXPRANGE: return "exponent_above_256";
    case LRD_GODEL_E_FRAMING: return "bad_framing";
    case LRD_GODEL_E_MODE: return "mode_mismatch";
    case LRD_GODEL_E_LEN: return "too_many_items";
    case LRD_GODEL_E_PRIMECAP: return "prime_index_above_cap";
  }
  return "unknown";
}

const char *lrd_godel_mode_name(lrd_godel_mode_t m) {
  switch (m) {
    case LRD_GODEL_BIJ256_BYTES: return "bij256-bytes";
    case LRD_GODEL_BIJ256_RECORDS: return "bij256-records";
    case LRD_GODEL_POSITIONAL: return "positional";
  }
  return NULL;
}

lrd_godel_cfg_t lrd_godel_default_cfg(lrd_godel_mode_t mode) {
  lrd_godel_cfg_t c = { mode, mode == LRD_GODEL_POSITIONAL ? LRD_GODEL_POSITIONAL_DEFAULT_MAX_BITS
                                                           : LRD_GODEL_BIJ256_DEFAULT_MAX_BITS, 64 };
  return c;
}

/* ------------------------------------------------------------ deterministic prime table */
static uint64_t *ptab; static size_t pn, pcap;

uint64_t lrd_prime(size_t i) {
  if (i == 0 || i > LRD_PRIME_MAX_INDEX) return 0;
  while (pn < i) {
    if (pn == pcap) {
      size_t nc = pcap ? 2 * pcap : 256;
      uint64_t *t = realloc(ptab, nc * sizeof *t);
      if (!t) return 0;
      ptab = t; pcap = nc;
    }
    if (pn == 0) { ptab[pn++] = 2; continue; }
    uint64_t c = ptab[pn - 1] + 1;
    for (;; c++) {            /* exact trial division by all known primes <= sqrt(c) */
      int isp = 1;
      for (size_t j = 0; j < pn && ptab[j] * ptab[j] <= c; j++)
        if (c % ptab[j] == 0) { isp = 0; break; }
      if (isp) break;
    }
    ptab[pn++] = c;
  }
  return ptab[i - 1];
}

/* error to report when lrd_prime(i) returned 0 */
static lrd_godel_err_t prime_err(size_t i) {
  return (i == 0 || i > LRD_PRIME_MAX_INDEX) ? LRD_GODEL_E_PRIMECAP : LRD_GODEL_E_NOMEM;
}

/* ------------------------------------------------------------ bijective base-256 */
static void rep256(mpz_t r, size_t k) {   /* r = (256^k - 1)/255 = sum_{j<k} 256^j */
  mpz_ui_pow_ui(r, 256, k);
  mpz_sub_ui(r, r, 1);
  mpz_divexact_ui(r, r, 255);
}

void lrd_bij256_encode(mpz_t e, const unsigned char *s, size_t k) {
  mpz_t r; mpz_init(r);
  if (k) mpz_import(e, k, 1, 1, 1, 0, s); else mpz_set_ui(e, 0);
  rep256(r, k);
  mpz_add(e, e, r);
  mpz_add_ui(e, e, 1);
  mpz_clear(r);
}

int lrd_bij256_decode(const mpz_t e, unsigned char **s, size_t *k) {
  if (mpz_cmp_ui(e, 1) < 0) return -1;
  mpz_t n, r; mpz_init(n); mpz_init(r);
  mpz_sub_ui(n, e, 1);
  size_t len = 0;
  if (mpz_sgn(n) > 0) {
    size_t sz = mpz_sizeinbase(n, 256);
    rep256(r, sz);
    len = (mpz_cmp(r, n) <= 0) ? sz : sz - 1;
    rep256(r, len);
    mpz_sub(n, n, r);          /* 0 <= n < 256^len */
  }
  unsigned char *b = malloc(len ? len : 1);
  if (!b) { mpz_clear(n); mpz_clear(r); return -1; }
  memset(b, 0, len ? len : 1);
  if (len && mpz_sgn(n) > 0) {
    size_t cnt = 0, need = mpz_sizeinbase(n, 256);
    mpz_export(b + (len - need), &cnt, 1, 1, 1, 0, n);
    (void)cnt;
  }
  *s = b; *k = len;
  mpz_clear(n); mpz_clear(r);
  return 0;
}

/* ------------------------------------------------------------ canonical-record helpers */
static int rec_canonical(const unsigned char *s, size_t n) {
  lrd_rec_t r; lrd_rec_init(&r);
  int ok = lrd_rec_parse(s, n, &r, NULL) == 0;
  lrd_rec_free(&r);
  return ok;
}

static int item_ok(const unsigned char *s, size_t k, const lrd_godel_cfg_t *cfg) {
  if (cfg->mode == LRD_GODEL_BIJ256_BYTES) return 1;
  unsigned char *full = malloc(LRD_REC_MAGIC_LEN + k);
  if (!full) return 0;
  memcpy(full, LRD_REC_MAGIC, LRD_REC_MAGIC_LEN);
  if (k) memcpy(full + LRD_REC_MAGIC_LEN, s, k);
  int ok = rec_canonical(full, LRD_REC_MAGIC_LEN + k);
  free(full);
  return ok;
}

/* In RECORD mode the caller passes the FULL canonical serialization; strip the magic. */
static lrd_godel_err_t item_body(const unsigned char *item, size_t len, const lrd_godel_cfg_t *cfg,
                                 const unsigned char **body, size_t *blen) {
  if (cfg->mode == LRD_GODEL_BIJ256_BYTES) { *body = item; *blen = len; return LRD_GODEL_OK; }
  if (!rec_canonical(item, len)) return LRD_GODEL_E_ARG;
  *body = item + LRD_REC_MAGIC_LEN; *blen = len - LRD_REC_MAGIC_LEN;
  return LRD_GODEL_OK;
}

/* ------------------------------------------------------------ ledger lifecycle */
void lrd_godel_init(lrd_godel_t *g, lrd_godel_mode_t mode) {
  mpz_init_set_ui(g->L, 1);    /* genesis: seq 0 is the empty ledger, L = 1 */
  g->n = 0; g->mode = mode; g->stream_len = 0;
}
void lrd_godel_clear(lrd_godel_t *g) { mpz_clear(g->L); g->n = 0; g->stream_len = 0; }
size_t lrd_godel_seq(const lrd_godel_t *g) { return g->n; }

void lrd_bytes_free(lrd_bytes_t *items, size_t n) {
  if (!items) return;
  for (size_t i = 0; i < n; i++) free(items[i].b);
  free(items);
}

/* ------------------------------------------------------------ bij256 append / decode */
static lrd_godel_err_t bij_append(lrd_godel_t *g, const unsigned char *item, size_t len,
                                  const lrd_godel_cfg_t *cfg) {
  const unsigned char *body; size_t blen;
  lrd_godel_err_t er = item_body(item, len, cfg, &body, &blen);
  if (er) return er;
  /* e >= 256^blen: a body longer than 8 bytes can never fit an unsigned long exponent. */
  if (blen > 8) return LRD_GODEL_E_TOOBIG;
  uint64_t p = lrd_prime(g->n + 1);
  if (!p) return prime_err(g->n + 1);
  mpz_t e, f; mpz_init(e); mpz_init(f);
  lrd_bij256_encode(e, body, blen);
  lrd_godel_err_t rc = LRD_GODEL_OK;
  size_t pbits = 0; for (uint64_t t = p; t; t >>= 1) pbits++;
  if (!mpz_fits_ulong_p(e)) { rc = LRD_GODEL_E_TOOBIG; goto out; }
  unsigned long eu = mpz_get_ui(e);
  if (eu > cfg->max_bits / (pbits - 1)) {   /* p >= 2^(pbits-1) => bits(p^e) > e*(pbits-1) */
    rc = LRD_GODEL_E_TOOBIG; goto out;
  }
  mpz_ui_pow_ui(f, p, eu);
  if (mpz_sizeinbase(f, 2) + mpz_sizeinbase(g->L, 2) > cfg->max_bits) { rc = LRD_GODEL_E_TOOBIG; goto out; }
  mpz_mul(g->L, g->L, f);
  g->n++;
out:
  mpz_clear(e); mpz_clear(f);
  return rc;
}

static lrd_godel_err_t bij_decode(const mpz_t L0, const lrd_godel_cfg_t *cfg,
                                  lrd_bytes_t **items_out, size_t *n_out) {
  *items_out = NULL; *n_out = 0;
  if (mpz_sgn(L0) <= 0) return LRD_GODEL_E_NOTPOS;
  if (mpz_sizeinbase(L0, 2) > cfg->max_bits) return LRD_GODEL_E_TOOBIG;
  lrd_godel_err_t rc = LRD_GODEL_OK;
  mpz_t L, P, e; mpz_init_set(L, L0); mpz_init(P); mpz_init(e);
  lrd_bytes_t *items = NULL; size_t n = 0, cap = 0;
  for (size_t i = 1; mpz_cmp_ui(L, 1) != 0; i++) {
    uint64_t p = lrd_prime(i);
    if (!p) {                                   /* cofactor left but the prime table is exhausted */
      rc = prime_err(i) == LRD_GODEL_E_PRIMECAP ? LRD_GODEL_E_EXTRA : LRD_GODEL_E_NOMEM;
      goto fail;
    }
    mpz_set_ui(P, (unsigned long)p);
    mp_bitcnt_t mult = mpz_remove(L, L, P);
    if (mult == 0) {
      /* p_i absent but L > 1: a gap if some later sequence prime divides, else extra factor. */
      rc = LRD_GODEL_E_EXTRA;
      for (size_t j = 1; j <= cfg->gap_lookahead; j++) {
        uint64_t q = lrd_prime(i + j);
        if (q && mpz_divisible_ui_p(L, (unsigned long)q)) { rc = LRD_GODEL_E_GAP; break; }
      }
      goto fail;
    }
    if (n == LRD_GODEL_MAX_LEN) { rc = LRD_GODEL_E_LEN; goto fail; }
    mpz_set_ui(e, (unsigned long)mult);
    unsigned char *s; size_t k;
    if (lrd_bij256_decode(e, &s, &k)) { rc = LRD_GODEL_E_NOMEM; goto fail; }
    if (!item_ok(s, k, cfg)) { free(s); rc = LRD_GODEL_E_NONCANON; goto fail; }
    if (n == cap) {
      size_t nc = cap ? 2 * cap : 16;
      lrd_bytes_t *t = realloc(items, nc * sizeof *t);
      if (!t) { free(s); rc = LRD_GODEL_E_NOMEM; goto fail; }
      items = t; cap = nc;
    }
    if (cfg->mode == LRD_GODEL_BIJ256_RECORDS) {      /* return the full canonical serialization */
      unsigned char *full = malloc(LRD_REC_MAGIC_LEN + k);
      if (!full) { free(s); rc = LRD_GODEL_E_NOMEM; goto fail; }
      memcpy(full, LRD_REC_MAGIC, LRD_REC_MAGIC_LEN);
      if (k) memcpy(full + LRD_REC_MAGIC_LEN, s, k);
      free(s); s = full; k += LRD_REC_MAGIC_LEN;
    }
    items[n].b = s; items[n].n = k; n++;
  }
  mpz_clear(L); mpz_clear(P); mpz_clear(e);
  *items_out = items; *n_out = n;
  return LRD_GODEL_OK;
fail:
  lrd_bytes_free(items, n);
  mpz_clear(L); mpz_clear(P); mpz_clear(e);
  return rc;
}

/* ============================================================ positional mode */

static size_t bitlen_u64(uint64_t p) { size_t b = 0; while (p) { b++; p >>= 1; } return b; }

/* Product of p_{start+k}^(s[k]+1), k = 0..n-1, via a balanced product tree. Refuses (before
 * building any power) if a lower bound on the result already exceeds cfg->max_bits. */
static lrd_godel_err_t pos_product(mpz_t out, const unsigned char *s, size_t n, size_t start,
                                   const lrd_godel_cfg_t *cfg, size_t already_bits) {
  if (n == 0) { mpz_set_ui(out, 1); return LRD_GODEL_OK; }
  if (start == 0) return LRD_GODEL_E_ARG;
  if (n > LRD_PRIME_MAX_INDEX || start > LRD_PRIME_MAX_INDEX - n + 1) return LRD_GODEL_E_PRIMECAP;
  /* p >= 2^(bitlen-1) => bits(p^e) > e*(bitlen-1) */
  size_t lb = already_bits;
  for (size_t k = 0; k < n; k++) {
    uint64_t p = lrd_prime(start + k);
    if (!p) return prime_err(start + k);
    lb += (size_t)(s[k] + 1u) * (bitlen_u64(p) - 1);
    if (lb > cfg->max_bits) return LRD_GODEL_E_TOOBIG;
  }
  mpz_t *t = malloc(n * sizeof *t);
  if (!t) return LRD_GODEL_E_NOMEM;
  for (size_t k = 0; k < n; k++) {
    mpz_init(t[k]);
    mpz_ui_pow_ui(t[k], (unsigned long)lrd_prime(start + k), (unsigned long)s[k] + 1);
  }
  for (size_t m = n; m > 1; m = (m + 1) / 2) {
    for (size_t i = 0; i < m / 2; i++) mpz_mul(t[i], t[2 * i], t[2 * i + 1]);
    if (m & 1) mpz_swap(t[m / 2], t[m - 1]);
  }
  mpz_swap(out, t[0]);
  for (size_t k = 0; k < n; k++) mpz_clear(t[k]);
  free(t);
  if (mpz_sizeinbase(out, 2) + already_bits > cfg->max_bits) return LRD_GODEL_E_TOOBIG;
  return LRD_GODEL_OK;
}

lrd_godel_err_t lrd_godel_pos_from_stream(mpz_t L, const unsigned char *s, size_t n,
                                          size_t start_index, const lrd_godel_cfg_t *cfg) {
  if (start_index == 0) return LRD_GODEL_E_ARG;
  return pos_product(L, s, n, start_index, cfg, 0);
}

/* REFERENCE decoder: one mpz_remove per prime, in prime order (simple, O(n * |L|); slow for
 * KB streams). Kept as an independent cross-check of the fast decoder below. Same contract:
 * on E_GAP the partial stream (bytes before the missing prime) is returned in (*s_out, *n_out). */
static lrd_godel_err_t pos_extract_naive(const mpz_t L0, const lrd_godel_cfg_t *cfg,
                                         unsigned char **s_out, size_t *n_out) {
  *s_out = NULL; *n_out = 0;
  if (mpz_sgn(L0) <= 0) return LRD_GODEL_E_NOTPOS;
  if (mpz_sizeinbase(L0, 2) > cfg->max_bits) return LRD_GODEL_E_TOOBIG;
  lrd_godel_err_t rc = LRD_GODEL_OK;
  mpz_t L, P; mpz_init_set(L, L0); mpz_init(P);
  size_t cap = 1024, n = 0;
  unsigned char *s = malloc(cap);
  if (!s) { rc = LRD_GODEL_E_NOMEM; goto out; }
  for (size_t i = 1; mpz_cmp_ui(L, 1) != 0; i++) {
    uint64_t p = lrd_prime(i);
    if (!p) { rc = prime_err(i) == LRD_GODEL_E_PRIMECAP ? LRD_GODEL_E_EXTRA : LRD_GODEL_E_NOMEM; goto out; }
    mpz_set_ui(P, (unsigned long)p);
    mp_bitcnt_t mult = mpz_remove(L, L, P);
    if (mult == 0) {
      rc = LRD_GODEL_E_EXTRA;
      for (size_t j = 1; j <= cfg->gap_lookahead; j++) {
        uint64_t q = lrd_prime(i + j);
        if (q && mpz_divisible_ui_p(L, (unsigned long)q)) { rc = LRD_GODEL_E_GAP; break; }
      }
      goto out;
    }
    if (mult > 256) { rc = LRD_GODEL_E_EXPRANGE; goto out; }
    if (n == cap) {
      unsigned char *t = realloc(s, cap * 2);
      if (!t) { rc = LRD_GODEL_E_NOMEM; goto out; }
      s = t; cap *= 2;
    }
    s[n++] = (unsigned char)(mult - 1);
  }
out:
  mpz_clear(L); mpz_clear(P);
  if (rc == LRD_GODEL_OK || rc == LRD_GODEL_E_GAP) { *s_out = s; *n_out = n; }
  else free(s);
  return rc;
}

/* prod_{k=a}^{b-1} p_k^257 (balanced product tree). */
static void prod257(mpz_t out, size_t a, size_t b) {
  if (b - a == 1) { mpz_ui_pow_ui(out, (unsigned long)lrd_prime(a), 257); return; }
  size_t m = a + (b - a) / 2;
  mpz_t r; mpz_init(r);
  prod257(out, a, m); prod257(r, m, b);
  mpz_mul(out, out, r);
  mpz_clear(r);
}

/* v[k-a] = min(v_{p_k}(L), 257) for k in [a,b), given r = L mod prod_{k in [a,b)} p_k^257.
 * Since p_k^257 divides the modulus, r mod p_k^257 = L mod p_k^257, whose p_k-valuation equals
 * v_{p_k}(L) when that is < 257, and which is 0 iff v_{p_k}(L) >= 257 (remainder tree). */
static void vals257(const mpz_t r, size_t a, size_t b, unsigned *v) {
  if (b - a <= 8) {
    mpz_t q, t; mpz_init(q); mpz_init(t);
    for (size_t k = a; k < b; k++) {
      mpz_ui_pow_ui(q, (unsigned long)lrd_prime(k), 257);
      mpz_mod(t, r, q);
      if (mpz_sgn(t) == 0) { v[k - a] = 257; continue; }
      mpz_set_ui(q, (unsigned long)lrd_prime(k));
      v[k - a] = (unsigned)mpz_remove(t, t, q);
    }
    mpz_clear(q); mpz_clear(t);
    return;
  }
  size_t m = a + (b - a) / 2;
  mpz_t M, rr; mpz_init(M); mpz_init(rr);
  prod257(M, a, m); mpz_mod(rr, r, M); vals257(rr, a, m, v);
  prod257(M, m, b); mpz_mod(rr, r, M); vals257(rr, m, b, v + (m - a));
  mpz_clear(M); mpz_clear(rr);
}

/* FAST decoder (used by every public operation): exact division in prime order, BLOCKWISE.
 * For the next block of consecutive primes p_s..p_{s+B-1}, read the valuations from
 * L mod prod p_k^257 with a remainder tree, take the longest leading run with exponents in
 * 1..256, divide L EXACTLY by that run's prime powers, and continue (B doubles up to 4096).
 * The first prime whose exponent is 0 or >= 257 stops the scan, exactly as in the per-prime
 * reference decoder. On E_GAP the partial stream (bytes before the missing prime) is returned
 * in (*s_out, *n_out) so the caller can classify gap vs zero-exponent-in-record. */
static lrd_godel_err_t pos_extract(const mpz_t L0, const lrd_godel_cfg_t *cfg,
                                   unsigned char **s_out, size_t *n_out) {
  *s_out = NULL; *n_out = 0;
  if (mpz_sgn(L0) <= 0) return LRD_GODEL_E_NOTPOS;
  if (mpz_sizeinbase(L0, 2) > cfg->max_bits) return LRD_GODEL_E_TOOBIG;
  lrd_godel_err_t rc = LRD_GODEL_OK;
  mpz_t L, M, r, D; mpz_init_set(L, L0); mpz_init(M); mpz_init(r); mpz_init(D);
  size_t cap = 1024, n = 0, s = 1, B = 64;
  unsigned char *buf = malloc(cap);
  unsigned *v = malloc(4096 * sizeof *v);
  if (!buf || !v) { rc = LRD_GODEL_E_NOMEM; goto out; }
  while (mpz_cmp_ui(L, 1) != 0) {
    if (s > LRD_PRIME_MAX_INDEX) { rc = LRD_GODEL_E_EXTRA; goto out; }   /* cofactor beyond the table */
    if (B > LRD_PRIME_MAX_INDEX - s + 1) B = LRD_PRIME_MAX_INDEX - s + 1;
    if (!lrd_prime(s + B - 1)) { rc = prime_err(s + B - 1); goto out; }
    prod257(M, s, s + B);
    mpz_mod(r, L, M);
    vals257(r, s, s + B, v);
    size_t run = 0;
    while (run < B && v[run] >= 1 && v[run] <= 256) run++;
    if (n + run > cap) {
      while (n + run > cap) cap *= 2;
      unsigned char *t = realloc(buf, cap);
      if (!t) { rc = LRD_GODEL_E_NOMEM; goto out; }
      buf = t;
    }
    for (size_t k = 0; k < run; k++) buf[n + k] = (unsigned char)(v[k] - 1);
    if (run) {
      lrd_godel_cfg_t big = *cfg; big.max_bits = (size_t)-1;
      if ((rc = pos_product(D, buf + n, run, s, &big, 0)) != LRD_GODEL_OK) goto out;
      mpz_divexact(L, L, D);
      n += run;
    }
    if (run < B) {
      size_t k = s + run;               /* first prime not carrying a stream byte */
      if (v[run] >= 257) { rc = LRD_GODEL_E_EXPRANGE; goto out; }
      if (mpz_cmp_ui(L, 1) == 0) break; /* stream ended exactly here */
      rc = LRD_GODEL_E_EXTRA;
      for (size_t j = 1; j <= cfg->gap_lookahead; j++) {
        uint64_t q = lrd_prime(k + j);
        if (q && mpz_divisible_ui_p(L, (unsigned long)q)) { rc = LRD_GODEL_E_GAP; break; }
      }
      goto out;
    }
    s += B;
    if (B < 4096) B *= 2;
  }
out:
  free(v);
  mpz_clear(L); mpz_clear(M); mpz_clear(r); mpz_clear(D);
  if (rc == LRD_GODEL_OK || rc == LRD_GODEL_E_GAP) { *s_out = buf; *n_out = n; }
  else free(buf);
  return rc;
}

lrd_godel_err_t lrd_godel_pos_to_stream(const mpz_t L, const lrd_godel_cfg_t *cfg,
                                        unsigned char **s, size_t *n) {
  lrd_godel_err_t rc = pos_extract(L, cfg, s, n);
  if (rc == LRD_GODEL_E_GAP) { free(*s); *s = NULL; *n = 0; }
  return rc;
}

lrd_godel_err_t lrd_godel_pos_to_stream_naive(const mpz_t L, const lrd_godel_cfg_t *cfg,
                                              unsigned char **s, size_t *n) {
  lrd_godel_err_t rc = pos_extract_naive(L, cfg, s, n);
  if (rc == LRD_GODEL_E_GAP) { free(*s); *s = NULL; *n = 0; }
  return rc;
}

/* Strict framing + canonical record check; also enforces <= LRD_GODEL_MAX_LEN records.
 * items_out may be NULL (validate only). */
static lrd_godel_err_t pos_parse(const unsigned char *s, size_t n,
                                 lrd_bytes_t **items_out, size_t *n_out) {
  if (items_out) { *items_out = NULL; *n_out = 0; }
  lrd_bytes_t *items = NULL; size_t cnt = 0, cap = 0;
  lrd_godel_err_t rc = LRD_GODEL_OK;
  size_t pos = 0;
  while (pos < n) {
    if (n - pos < 4) { rc = LRD_GODEL_E_FRAMING; break; }
    size_t len = ((size_t)s[pos] << 24) | ((size_t)s[pos + 1] << 16) | ((size_t)s[pos + 2] << 8) | s[pos + 3];
    pos += 4;
    if (len > n - pos) { rc = LRD_GODEL_E_FRAMING; break; }
    if (cnt == LRD_GODEL_MAX_LEN) { rc = LRD_GODEL_E_LEN; break; }
    unsigned char *full = malloc(LRD_REC_MAGIC_LEN + len);
    if (!full) { rc = LRD_GODEL_E_NOMEM; break; }
    memcpy(full, LRD_REC_MAGIC, LRD_REC_MAGIC_LEN);
    if (len) memcpy(full + LRD_REC_MAGIC_LEN, s + pos, len);
    if (!rec_canonical(full, LRD_REC_MAGIC_LEN + len)) { free(full); rc = LRD_GODEL_E_NONCANON; break; }
    pos += len;
    if (!items_out) { free(full); cnt++; continue; }
    if (cnt == cap) {
      size_t nc = cap ? 2 * cap : 8;
      lrd_bytes_t *t = realloc(items, nc * sizeof *t);
      if (!t) { free(full); rc = LRD_GODEL_E_NOMEM; break; }
      items = t; cap = nc;
    }
    items[cnt].b = full; items[cnt].n = LRD_REC_MAGIC_LEN + len; cnt++;
  }
  if (rc != LRD_GODEL_OK) { lrd_bytes_free(items, cnt); return rc; }
  if (items_out) { *items_out = items; *n_out = cnt; }
  return LRD_GODEL_OK;
}

static lrd_godel_err_t pos_decode(const mpz_t L, const lrd_godel_cfg_t *cfg,
                                  lrd_bytes_t **items, size_t *n, size_t *stream_len) {
  unsigned char *s; size_t sn;
  lrd_godel_err_t rc = pos_extract(L, cfg, &s, &sn);
  if (rc == LRD_GODEL_E_GAP) {
    /* Missing prime followed by later sequence primes. If the bytes before it form whole
     * frames, it is a gap between frames; if it falls inside a frame, it is an exponent 0
     * inside the stream. Both are rejections. */
    lrd_godel_err_t pr = pos_parse(s, sn, NULL, NULL);
    free(s);
    if (pr == LRD_GODEL_OK) return LRD_GODEL_E_GAP;
    if (pr == LRD_GODEL_E_FRAMING) return LRD_GODEL_E_ZEROEXP;
    return pr;
  }
  if (rc) return rc;
  rc = pos_parse(s, sn, items, n);
  if (rc == LRD_GODEL_OK && stream_len) *stream_len = sn;
  free(s);
  return rc;
}

/* Lp | L and L/Lp == prod_{k=|Sp|..|S|-1} p_{k+1}^(S[k]+1) exactly. */
static lrd_godel_err_t pos_check_quotient(const mpz_t Lp, const mpz_t L, const lrd_godel_cfg_t *cfg) {
  unsigned char *sp, *s; size_t np, n;
  lrd_godel_err_t rc = lrd_godel_pos_to_stream(Lp, cfg, &sp, &np);
  if (rc) return rc;
  rc = lrd_godel_pos_to_stream(L, cfg, &s, &n);
  if (rc) { free(sp); return rc; }
  if (np > n || memcmp(sp, s, np) != 0) rc = LRD_GODEL_E_MISMATCH;
  mpz_t Q, E; mpz_init(Q); mpz_init(E);
  if (rc == LRD_GODEL_OK) {
    if (!mpz_divisible_p(L, Lp)) rc = LRD_GODEL_E_MISMATCH;
    else {
      mpz_divexact(Q, L, Lp);
      rc = pos_product(E, s + np, n - np, np + 1, cfg, 0);
      if (rc == LRD_GODEL_OK && mpz_cmp(Q, E) != 0) rc = LRD_GODEL_E_MISMATCH;
    }
  }
  mpz_clear(Q); mpz_clear(E); free(sp); free(s);
  return rc;
}

static lrd_godel_err_t pos_append(lrd_godel_t *g, const unsigned char *item, size_t len,
                                  const lrd_godel_cfg_t *cfg) {
  if (len < LRD_REC_MAGIC_LEN || !rec_canonical(item, len)) return LRD_GODEL_E_ARG;
  size_t blen = len - LRD_REC_MAGIC_LEN;
  if (blen > 0xFFFFFFFFu) return LRD_GODEL_E_TOOBIG;
  /* every stream byte contributes >= 1 bit: refuse before allocating the frame */
  size_t have = mpz_sizeinbase(g->L, 2);
  if (have > cfg->max_bits || blen + 4 > cfg->max_bits - have) return LRD_GODEL_E_TOOBIG;
  unsigned char *frame = malloc(4 + blen);
  if (!frame) return LRD_GODEL_E_NOMEM;
  frame[0] = (unsigned char)(blen >> 24); frame[1] = (unsigned char)(blen >> 16);
  frame[2] = (unsigned char)(blen >> 8);  frame[3] = (unsigned char)blen;
  if (blen) memcpy(frame + 4, item + LRD_REC_MAGIC_LEN, blen);
  mpz_t F; mpz_init(F);
  lrd_godel_err_t rc = pos_product(F, frame, 4 + blen, g->stream_len + 1, cfg, have);
  free(frame);
  if (rc == LRD_GODEL_OK) {
    mpz_mul(g->L, g->L, F);
    g->n++; g->stream_len += 4 + blen;
  }
  mpz_clear(F);
  return rc;
}

/* ============================================================ mode dispatch */

lrd_godel_err_t lrd_godel_append(lrd_godel_t *g, const unsigned char *item, size_t len,
                                 const lrd_godel_cfg_t *cfg) {
  if (cfg->mode != g->mode) return LRD_GODEL_E_MODE;
  if (g->n >= LRD_GODEL_MAX_LEN) return LRD_GODEL_E_LEN;   /* before item is read or anything allocated */
  if (g->mode == LRD_GODEL_POSITIONAL) return pos_append(g, item, len, cfg);
  return bij_append(g, item, len, cfg);
}

lrd_godel_err_t lrd_godel_decode(const mpz_t L, const lrd_godel_cfg_t *cfg,
                                 lrd_bytes_t **items, size_t *n) {
  if (cfg->mode == LRD_GODEL_POSITIONAL) {
    *items = NULL; *n = 0;
    return pos_decode(L, cfg, items, n, NULL);
  }
  if (cfg->mode != LRD_GODEL_BIJ256_BYTES && cfg->mode != LRD_GODEL_BIJ256_RECORDS) return LRD_GODEL_E_MODE;
  return bij_decode(L, cfg, items, n);
}

/* ============================================================ history / verification */

lrd_godel_err_t lrd_godel_history(const mpz_t L, const lrd_godel_cfg_t *cfg, size_t i,
                                  lrd_bytes_t *out) {
  lrd_bytes_t *it; size_t n;
  lrd_godel_err_t rc = lrd_godel_decode(L, cfg, &it, &n);
  if (rc) return rc;
  if (i >= n) { lrd_bytes_free(it, n); return LRD_GODEL_E_ARG; }
  *out = it[i]; it[i].b = NULL;
  lrd_bytes_free(it, n);
  return LRD_GODEL_OK;
}

static int same(const lrd_bytes_t *a, const lrd_bytes_t *b) {
  return a->n == b->n && (a->n == 0 || memcmp(a->b, b->b, a->n) == 0);
}

static lrd_godel_err_t verify_k(const mpz_t L, const lrd_godel_cfg_t *cfg,
                                const lrd_bytes_t *items, size_t k, int exact) {
  lrd_bytes_t *it; size_t n;
  lrd_godel_err_t rc = lrd_godel_decode(L, cfg, &it, &n);
  if (rc) return rc;
  rc = LRD_GODEL_OK;
  if (exact ? (n != k) : (k > n)) rc = LRD_GODEL_E_MISMATCH;
  for (size_t i = 0; rc == LRD_GODEL_OK && i < k; i++)
    if (!same(&it[i], &items[i])) rc = LRD_GODEL_E_MISMATCH;
  lrd_bytes_free(it, n);
  return rc;
}

lrd_godel_err_t lrd_godel_verify_sequence(const mpz_t L, const lrd_godel_cfg_t *cfg,
                                          const lrd_bytes_t *items, size_t n) {
  return verify_k(L, cfg, items, n, 1);
}

lrd_godel_err_t lrd_godel_verify_prefix(const mpz_t L, const lrd_godel_cfg_t *cfg,
                                        const lrd_bytes_t *items, size_t k) {
  return verify_k(L, cfg, items, k, 0);
}

lrd_godel_err_t lrd_godel_verify_prefix_code(const mpz_t Lp, const mpz_t L,
                                             const lrd_godel_cfg_t *cfg) {
  lrd_bytes_t *a; size_t na;
  lrd_godel_err_t rc = lrd_godel_decode(Lp, cfg, &a, &na);
  if (rc) return rc;
  if (!mpz_divisible_p(L, Lp)) { lrd_bytes_free(a, na); return LRD_GODEL_E_MISMATCH; }
  rc = verify_k(L, cfg, a, na, 0);
  lrd_bytes_free(a, na);
  if (rc == LRD_GODEL_OK && cfg->mode == LRD_GODEL_POSITIONAL) rc = pos_check_quotient(Lp, L, cfg);
  return rc;
}

/* ============================================================ parsing of external L */

lrd_godel_err_t lrd_godel_parse_hex(mpz_t L, const char *hex) {
  if (!hex || !*hex) return LRD_GODEL_E_ARG;
  if (hex[0] == '-' || hex[0] == '+') return LRD_GODEL_E_NOTPOS;
  for (const char *c = hex; *c; c++)
    if (!((*c >= '0' && *c <= '9') || (*c >= 'a' && *c <= 'f') || (*c >= 'A' && *c <= 'F'))) return LRD_GODEL_E_ARG;
  mpz_t t; mpz_init(t);
  if (mpz_set_str(t, hex, 16) != 0) { mpz_clear(t); return LRD_GODEL_E_ARG; }
  if (mpz_sgn(t) <= 0) { mpz_clear(t); return LRD_GODEL_E_NOTPOS; }
  mpz_swap(L, t); mpz_clear(t);
  return LRD_GODEL_OK;
}

static int small_prime(unsigned long p) {
  if (p < 2) return 0;
  for (unsigned long d = 2; d <= p / d; d++) if (p % d == 0) return 0;
  return 1;
}

lrd_godel_err_t lrd_godel_parse_factored(mpz_t L, const char *text, const lrd_godel_cfg_t *cfg) {
  if (!text) return LRD_GODEL_E_ARG;
  mpz_t acc, f; mpz_init_set_ui(acc, 1); mpz_init(f);
  lrd_godel_err_t rc = LRD_GODEL_OK;
  const char *p = text; int any = 0;
  while (*p) {
    while (*p == ' ') p++;
    if (!*p) break;
    char *end;
    if (*p == '-' || *p == '+') { rc = LRD_GODEL_E_ARG; goto out; }          /* base sign */
    unsigned long long base = strtoull(p, &end, 10);
    if (end == p || *end != '^' || base > 0xFFFFFFFFull) { rc = LRD_GODEL_E_ARG; goto out; }
    p = end + 1;
    int neg = (*p == '-');
    if (*p == '-' || *p == '+') p++;
    if (*p < '0' || *p > '9') { rc = LRD_GODEL_E_ARG; goto out; }
    unsigned long long e = strtoull(p, &end, 10);
    if (*end != ' ' && *end != 0) { rc = LRD_GODEL_E_ARG; goto out; }
    p = end;
    if (neg || e == 0) { rc = LRD_GODEL_E_NOTPOS; goto out; }               /* exponent <= 0 */
    if (!small_prime((unsigned long)base)) { rc = LRD_GODEL_E_ARG; goto out; }
    size_t bb = bitlen_u64(base);
    if (e > cfg->max_bits / (bb - 1 ? bb - 1 : 1) || mpz_sizeinbase(acc, 2) + (size_t)e * (bb - 1) > cfg->max_bits) {
      rc = LRD_GODEL_E_TOOBIG; goto out;
    }
    mpz_ui_pow_ui(f, (unsigned long)base, (unsigned long)e);
    mpz_mul(acc, acc, f);
    any = 1;
  }
  if (!any) { rc = LRD_GODEL_E_ARG; goto out; }
  mpz_swap(L, acc);
out:
  mpz_clear(acc); mpz_clear(f);
  return rc;
}

/* ============================================================ export / import */

int lrd_godel_export(const lrd_godel_t *g, unsigned char **out, size_t *len) {
  const char *mn = lrd_godel_mode_name(g->mode);
  if (!mn) return -1;
  char *hex = mpz_get_str(NULL, 16, g->L);
  char nb[24]; snprintf(nb, sizeof nb, "%zu", g->n);
  lrd_rec_t r; lrd_rec_init(&r);
  int rc = lrd_rec_set(&r, "L", hex) | lrd_rec_set(&r, "format", "LRD-GODEL-v1") |
           lrd_rec_set(&r, "mode", mn) | lrd_rec_set(&r, "n", nb);
  void (*freefn)(void *, size_t); mp_get_memory_functions(NULL, NULL, &freefn);
  freefn(hex, strlen(hex) + 1);
  if (!rc) rc = lrd_rec_serialize(&r, out, len);
  lrd_rec_free(&r);
  return rc ? -1 : 0;
}

lrd_godel_err_t lrd_godel_import(lrd_godel_t *g, const unsigned char *rec, size_t len,
                                 const lrd_godel_cfg_t *cfg) {
  lrd_rec_t r; lrd_rec_init(&r);
  if (lrd_rec_parse(rec, len, &r, NULL)) return LRD_GODEL_E_ARG;
  const char *f = lrd_rec_get(&r, "format"), *m = lrd_rec_get(&r, "mode"),
             *hx = lrd_rec_get(&r, "L"), *ns = lrd_rec_get(&r, "n");
  lrd_godel_err_t rc = LRD_GODEL_OK;
  if (r.n != 4 || !f || !m || !hx || !ns || strcmp(f, "LRD-GODEL-v1")) { rc = LRD_GODEL_E_ARG; goto out; }
  if (strcmp(m, lrd_godel_mode_name(cfg->mode)) != 0) { rc = LRD_GODEL_E_MODE; goto out; }
  lrd_godel_init(g, cfg->mode);
  if ((rc = lrd_godel_parse_hex(g->L, hx)) != LRD_GODEL_OK) { lrd_godel_clear(g); goto out; }
  lrd_bytes_t *it; size_t cnt, sl = 0;
  if (cfg->mode == LRD_GODEL_POSITIONAL) rc = pos_decode(g->L, cfg, &it, &cnt, &sl);
  else rc = bij_decode(g->L, cfg, &it, &cnt);
  if (rc) { lrd_godel_clear(g); goto out; }
  lrd_bytes_free(it, cnt);
  char nb[24]; snprintf(nb, sizeof nb, "%zu", cnt);
  if (strcmp(nb, ns) != 0) { lrd_godel_clear(g); rc = LRD_GODEL_E_MISMATCH; goto out; }
  g->n = cnt; g->stream_len = sl;
out:
  lrd_rec_free(&r);
  return rc;
}

/* ============================================================ envelope (recovery P0-A) */

/* Envelope append: builds LRD-ENV-v1, computes its SHA-256, and appends a
 * zero-length marker item so the Goedel product remains within max_bits.
 * The caller is responsible for placing env.sha256 into the state record's
 * payload_sha256; the commitment therefore binds the full canonical bytes.
 * Legacy small records continue to use the ordinary lrd_godel_append path.
 * Historical L values are never rewritten. (Behaviour unchanged by blocker (a).) */
lrd_godel_err_t lrd_godel_append_envelope(lrd_godel_t *g,
                                          const unsigned char *payload, size_t plen,
                                          uint8_t flags,
                                          const lrd_godel_cfg_t *cfg) {
  if (!g || !cfg) return LRD_GODEL_E_ARG;
  lrd_env_t env;
  if (lrd_env_build(&env, flags, payload, plen) != 0) {
    return LRD_GODEL_E_ARG;
  }
  /* Zero-length marker keeps the exponent = 1, so p^1 is tiny. */
  lrd_godel_cfg_t c = *cfg;
  c.mode = LRD_GODEL_BYTES;
  lrd_godel_err_t rc = lrd_godel_append(g, (const unsigned char *)"", 0, &c);
  lrd_env_free(&env);
  return rc;
}
