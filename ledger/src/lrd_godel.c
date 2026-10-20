/* Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 * Dual-licensed: AGPL-3.0-or-later plus SnapKitty Opaque License.
 * SPDX-License-Identifier: AGPL-3.0-or-later AND LicenseRef-SnapKitty-Opaque
 *
 * TASK 004 -- Goedel prime ledger implementation. See include/lrd_godel.h.
 */
#include "lrd_godel.h"
#include "lrd_rec.h"

#include <stdlib.h>
#include <string.h>

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
  }
  return "unknown";
}

lrd_godel_cfg_t lrd_godel_default_cfg(lrd_godel_mode_t mode) {
  lrd_godel_cfg_t c = { mode, (size_t)1 << 23, 64 };
  return c;
}

/* ------------------------------------------------------------ deterministic prime table */
static uint64_t *ptab; static size_t pn, pcap;

uint64_t lrd_prime(size_t i) {
  if (i == 0) return 0;
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

/* ------------------------------------------------------------ item validation */
static int item_ok(const unsigned char *s, size_t k, const lrd_godel_cfg_t *cfg) {
  if (cfg->mode == LRD_GODEL_BYTES) return 1;
  unsigned char *full = malloc(LRD_REC_MAGIC_LEN + k);
  if (!full) return 0;
  memcpy(full, LRD_REC_MAGIC, LRD_REC_MAGIC_LEN);
  if (k) memcpy(full + LRD_REC_MAGIC_LEN, s, k);
  lrd_rec_t r; lrd_rec_init(&r);
  int ok = lrd_rec_parse(full, LRD_REC_MAGIC_LEN + k, &r, NULL) == 0;
  lrd_rec_free(&r); free(full);
  return ok;
}

/* In RECORD mode the caller passes the FULL canonical serialization; strip the magic. */
static lrd_godel_err_t item_body(const unsigned char *item, size_t len, const lrd_godel_cfg_t *cfg,
                                 const unsigned char **body, size_t *blen) {
  if (cfg->mode == LRD_GODEL_BYTES) { *body = item; *blen = len; return LRD_GODEL_OK; }
  lrd_rec_t r; lrd_rec_init(&r);
  int ok = lrd_rec_parse(item, len, &r, NULL) == 0;
  lrd_rec_free(&r);
  if (!ok) return LRD_GODEL_E_ARG;
  *body = item + LRD_REC_MAGIC_LEN; *blen = len - LRD_REC_MAGIC_LEN;
  return LRD_GODEL_OK;
}

/* ------------------------------------------------------------ ledger */
void lrd_godel_init(lrd_godel_t *g) { mpz_init_set_ui(g->L, 1); g->n = 0; }
void lrd_godel_clear(lrd_godel_t *g) { mpz_clear(g->L); g->n = 0; }

lrd_godel_err_t lrd_godel_append(lrd_godel_t *g, const unsigned char *item, size_t len,
                                 const lrd_godel_cfg_t *cfg) {
  const unsigned char *body; size_t blen;
  lrd_godel_err_t er = item_body(item, len, cfg, &body, &blen);
  if (er) return er;
  /* e >= 256^blen: a body longer than 8 bytes can never fit an unsigned long exponent. */
  if (blen > 8) return LRD_GODEL_E_TOOBIG;
  uint64_t p = lrd_prime(g->n + 1);
  if (!p) return LRD_GODEL_E_NOMEM;
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

void lrd_bytes_free(lrd_bytes_t *items, size_t n) {
  if (!items) return;
  for (size_t i = 0; i < n; i++) free(items[i].b);
  free(items);
}

lrd_godel_err_t lrd_godel_decode(const mpz_t L0, const lrd_godel_cfg_t *cfg,
                                 lrd_bytes_t **items_out, size_t *n_out) {
  *items_out = NULL; *n_out = 0;
  if (mpz_sgn(L0) <= 0) return LRD_GODEL_E_NOTPOS;
  if (mpz_sizeinbase(L0, 2) > cfg->max_bits) return LRD_GODEL_E_TOOBIG;
  lrd_godel_err_t rc = LRD_GODEL_OK;
  mpz_t L, P, e; mpz_init_set(L, L0); mpz_init(P); mpz_init(e);
  lrd_bytes_t *items = NULL; size_t n = 0, cap = 0;
  for (size_t i = 1; mpz_cmp_ui(L, 1) != 0; i++) {
    uint64_t p = lrd_prime(i);
    if (!p) { rc = LRD_GODEL_E_NOMEM; goto fail; }
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
    if (cfg->mode == LRD_GODEL_RECORDS) {      /* return the full canonical serialization */
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
  return rc;
}
