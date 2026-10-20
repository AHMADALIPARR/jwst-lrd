/* SPDX-License-Identifier: AGPL-3.0-only
 * Additional terms: SnapKitty Opaque License (SNAPKITTY_OPAQUE_LICENSE.md, repository root).
 * Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 *
 * Proof serialization, format LRDAIRP1 version 1 (all integers little-endian):
 *   header (40 B): "LRDAIRP1" | u32 version=1 | u32 field_id=1 (Goldilocks, Fp2 u^2=7) |
 *                  u32 hash_id=1 (SHA-256) | u32 log_trace_len | u32 log_blowup |
 *                  u32 num_queries | u32 grinding_bits | u32 log_remainder
 *   trace_root (32) | comp_root (32) | 5 x Fp2 OOD values (16 each)
 *   u32 n_fri_roots | n_fri_roots x 32 | u32 n_rem | n_rem x Fp2 | u64 nonce
 *   num_queries x { 4 x Fp trace | 2 x Fp2 comp | (r-1) x 2 x Fp2 FRI | paths x 32 }
 * Fp = u64 canonical (< p), Fp2 = c0 then c1. Deserializer: every read is bounds-checked,
 * every field element must be canonical, counts must match the header parameters, and the
 * buffer must be consumed exactly.
 */
#include "air/stark.h"
#include <math.h>
#include <stdlib.h>
#include <string.h>

#define AIR_PROOF_VERSION 1u
#define AIR_FIELD_ID 1u
#define AIR_HASH_ID 1u

static void put_u32(uint8_t *p, uint32_t v) { for (int i = 0; i < 4; i++) p[i] = (uint8_t)(v >> (8 * i)); }
static uint32_t get_u32(const uint8_t *p) { return (uint32_t)p[0] | (uint32_t)p[1] << 8 | (uint32_t)p[2] << 16 | (uint32_t)p[3] << 24; }

void air_header_bytes(const air_params *p, uint8_t out[AIR_HEADER_LEN]) {
  memcpy(out, "LRDAIRP1", 8);
  put_u32(out + 8, AIR_PROOF_VERSION);
  put_u32(out + 12, AIR_FIELD_ID);
  put_u32(out + 16, AIR_HASH_ID);
  put_u32(out + 20, p->log_trace_len);
  put_u32(out + 24, p->log_blowup);
  put_u32(out + 28, p->num_queries);
  put_u32(out + 32, p->grinding_bits);
  put_u32(out + 36, p->log_remainder);
}

typedef struct { uint8_t *b; size_t n, cap; } wbuf;
static void w_bytes(wbuf *w, const void *d, size_t n) {
  if (w->n + n > w->cap) {
    size_t c = w->cap ? w->cap : 4096;
    while (c < w->n + n) c *= 2;
    uint8_t *nb = realloc(w->b, c);
    if (!nb) abort();
    w->b = nb; w->cap = c;
  }
  memcpy(w->b + w->n, d, n);
  w->n += n;
}
static void w_u32(wbuf *w, uint32_t v) { uint8_t b[4]; put_u32(b, v); w_bytes(w, b, 4); }
static void w_u64(wbuf *w, uint64_t v) { uint8_t b[8]; put_u64le(b, v); w_bytes(w, b, 8); }
static void w_fp2(wbuf *w, fp2 v) { w_u64(w, v.c0); w_u64(w, v.c1); }

uint8_t *air_proof_serialize(const air_proof *pf, size_t *len) {
  wbuf w = {0};
  uint8_t h[AIR_HEADER_LEN];
  air_header_bytes(&pf->prm, h);
  w_bytes(&w, h, sizeof h);
  w_bytes(&w, pf->trace_root.b, 32);
  w_bytes(&w, pf->comp_root.b, 32);
  for (int i = 0; i < 5; i++) w_fp2(&w, pf->ood[i]);
  w_u32(&w, pf->n_fri_roots);
  for (uint32_t i = 0; i < pf->n_fri_roots; i++) w_bytes(&w, pf->fri_roots[i].b, 32);
  w_u32(&w, pf->n_rem);
  for (uint32_t i = 0; i < pf->n_rem; i++) w_fp2(&w, pf->rem[i]);
  w_u64(&w, pf->nonce);
  uint32_t r = air_num_folds(&pf->prm);
  size_t np = air_query_path_count(&pf->prm);
  for (uint32_t i = 0; i < pf->prm.num_queries; i++) {
    const air_query *q = &pf->q[i];
    w_u64(&w, q->trace[0][0]); w_u64(&w, q->trace[0][1]);
    w_u64(&w, q->trace[1][0]); w_u64(&w, q->trace[1][1]);
    w_fp2(&w, q->comp[0]); w_fp2(&w, q->comp[1]);
    for (uint32_t l = 1; l < r; l++) { w_fp2(&w, q->fri[l][0]); w_fp2(&w, q->fri[l][1]); }
    for (size_t k = 0; k < np; k++) w_bytes(&w, q->paths[k].b, 32);
  }
  *len = w.n;
  return w.b;
}

typedef struct { const uint8_t *b; size_t n, o; int bad; } rbuf;
static const uint8_t *r_take(rbuf *r, size_t n) {
  if (r->bad || r->n - r->o < n) { r->bad = 1; return NULL; }
  const uint8_t *p = r->b + r->o;
  r->o += n;
  return p;
}
static uint32_t r_u32(rbuf *r) { const uint8_t *p = r_take(r, 4); return p ? get_u32(p) : 0; }
static uint64_t r_u64(rbuf *r) { const uint8_t *p = r_take(r, 8); return p ? get_u64le(p) : 0; }
static fp r_fp(rbuf *r) {
  uint64_t v = r_u64(r);
  if (v >= FP_P) r->bad = 1;
  return v;
}
static fp2 r_fp2(rbuf *r) { fp a = r_fp(r); fp b = r_fp(r); return fp2_make(a, b); }
static void r_digest(rbuf *r, digest *d) { const uint8_t *p = r_take(r, 32); if (p) memcpy(d->b, p, 32); }

int air_proof_deserialize(const uint8_t *buf, size_t len, air_proof *pf, const char **why) {
#define DCHK(c, m) do { if (!(c)) { if (why) *why = (m); air_proof_free(pf); return -1; } } while (0)
  memset(pf, 0, sizeof *pf);
  rbuf r = {buf, len, 0, 0};
  const uint8_t *h = r_take(&r, AIR_HEADER_LEN);
  DCHK(h, "truncated_header");
  DCHK(!memcmp(h, "LRDAIRP1", 8), "bad_magic");
  DCHK(get_u32(h + 8) == AIR_PROOF_VERSION, "bad_version");
  DCHK(get_u32(h + 12) == AIR_FIELD_ID, "bad_field_id");
  DCHK(get_u32(h + 16) == AIR_HASH_ID, "bad_hash_id");
  air_params *P = &pf->prm;
  P->log_trace_len = get_u32(h + 20);
  P->log_blowup = get_u32(h + 24);
  P->num_queries = get_u32(h + 28);
  P->grinding_bits = get_u32(h + 32);
  P->log_remainder = get_u32(h + 36);
  DCHK(P->log_trace_len >= AIR_MIN_LOG_TRACE && P->log_trace_len <= AIR_MAX_LOG_TRACE, "bad_log_trace_len");
  DCHK(P->log_blowup >= 1 && P->log_blowup <= 6, "bad_log_blowup");
  DCHK(P->num_queries >= 1 && P->num_queries <= 256, "bad_num_queries");
  DCHK(P->grinding_bits <= 32, "bad_grinding_bits");
  DCHK(P->log_remainder < P->log_trace_len, "bad_log_remainder");
  uint32_t rr = air_num_folds(P);
  DCHK(rr >= 1 && rr - 1 <= AIR_MAX_FRI, "bad_fri_layers");
  r_digest(&r, &pf->trace_root);
  r_digest(&r, &pf->comp_root);
  for (int i = 0; i < 5; i++) pf->ood[i] = r_fp2(&r);
  pf->n_fri_roots = r_u32(&r);
  DCHK(!r.bad && pf->n_fri_roots == rr - 1, "bad_fri_root_count");
  for (uint32_t i = 0; i < pf->n_fri_roots; i++) r_digest(&r, &pf->fri_roots[i]);
  pf->n_rem = r_u32(&r);
  DCHK(!r.bad && pf->n_rem == (1u << P->log_remainder), "bad_remainder_count");
  pf->rem = calloc(pf->n_rem, sizeof(fp2));
  DCHK(pf->rem, "oom");
  for (uint32_t i = 0; i < pf->n_rem; i++) pf->rem[i] = r_fp2(&r);
  pf->nonce = r_u64(&r);
  DCHK(!r.bad, "truncated_or_noncanonical");
  size_t np = air_query_path_count(P);
  pf->q = calloc(P->num_queries, sizeof *pf->q);
  DCHK(pf->q, "oom");
  for (uint32_t i = 0; i < P->num_queries; i++) {
    air_query *q = &pf->q[i];
    q->trace[0][0] = r_fp(&r); q->trace[0][1] = r_fp(&r);
    q->trace[1][0] = r_fp(&r); q->trace[1][1] = r_fp(&r);
    q->comp[0] = r_fp2(&r); q->comp[1] = r_fp2(&r);
    for (uint32_t l = 1; l < rr; l++) { q->fri[l][0] = r_fp2(&r); q->fri[l][1] = r_fp2(&r); }
    DCHK(!r.bad, "truncated_or_noncanonical");
    q->paths = calloc(np, sizeof(digest));
    DCHK(q->paths, "oom");
    for (size_t k = 0; k < np; k++) r_digest(&r, &q->paths[k]);
    DCHK(!r.bad, "truncated_paths");
  }
  DCHK(r.o == len, "trailing_bytes");
  if (why) *why = "ok";
  return 0;
#undef DCHK
}

/* ---- Security estimates: C port of winterfell air/src/proof/security.rs (fetched 2026-10-19
 * from github.com/facebook/winterfell main). Linear batching for constraints and DEEP
 * (independent random coefficients), fold factor 2, base field bits 64 (winterfell's
 * MODULUS_BITS convention for Goldilocks), extension degree 2, collision resistance 128. */
#define SEC_BASE_FIELD_BITS 64u
#define SEC_EXT_DEGREE 2u
#define SEC_COLLISION 128u
static uint64_t f2u(double v) { return v <= 0 ? 0 : (uint64_t)v; } /* Rust `as u64` saturation */

unsigned air_conjectured_security_bits(const air_params *p) {
  unsigned field_security = SEC_BASE_FIELD_BITS * SEC_EXT_DEGREE;
  unsigned query_security = p->log_blowup * p->num_queries;
  if (query_security >= 80) query_security += p->grinding_bits; /* GRINDING_CONTRIBUTION_FLOOR */
  unsigned m = field_security < query_security ? field_security : query_security;
  m -= 1;
  return m < SEC_COLLISION ? m : SEC_COLLISION;
}
unsigned air_proven_security_udr_bits(const air_params *p) {
  double ext = SEC_BASE_FIELD_BITS * SEC_EXT_DEGREE, Q = p->num_queries;
  double h = ldexp(1.0, (int)p->log_trace_len), B = ldexp(1.0, (int)p->log_blowup), lde = h * B;
  double rho_plus = (h + 2.0) / lde, alpha = (1.0 + rho_plus) * 0.5, max_deg = B + 1.0;
  double e = ext;                                                     /* eps_1, linear batching */
  double e2 = -log2(max_deg * (h + 2.0 - 1.0) + (h - 1.0)) + ext;     /* eps_2 */
  double e3 = ext - log2(lde);                                        /* eps_3 */
  double ei = ext - log2(1.0 * (lde + 1.0));                          /* eps_i, fold factor 2 */
  double ek = p->grinding_bits - log2(pow(alpha, Q));                 /* query phase */
  if (e2 < e) e = e2;
  if (e3 < e) e = e3;
  if (ei < e) e = ei;
  if (ek < e) e = ek;
  uint64_t u = f2u(e);
  return (unsigned)(u < SEC_COLLISION ? u : SEC_COLLISION);
}
static uint64_t ldr_for_m(const air_params *p, double m) {
  double ext = SEC_BASE_FIELD_BITS * SEC_EXT_DEGREE, Q = p->num_queries;
  double h = ldexp(1.0, (int)p->log_trace_len), B = ldexp(1.0, (int)p->log_blowup), lde = h * B;
  double rho = 1.0 / B, alpha = (1.0 + 0.5 / m) * sqrt(rho), max_deg = B + 1.0;
  double l = m / (rho - (2.0 * m / lde));
  double e = -log2(l) - log2(1.0) + ext;
  double e2 = -log2(l * l * (max_deg * (h + 2.0 - 1.0) + (h - 1.0))) + ext;
  double e3 = ext - log2((pow(m + 0.5, 7.0) / (3.0 * pow(rho, 1.5))) * pow(lde, 2.0) * 1.0);
  double ek = p->grinding_bits - log2(pow(alpha, Q));
  if (e2 < e) e = e2;
  if (e3 < e) e = e3;
  if (ek < e) e = ek;
  return f2u(e);
}
unsigned air_proven_security_ldr_bits(const air_params *p) {
  double h = ldexp(1.0, (int)p->log_trace_len);
  double m_max = ceil(1.0 / (2.0 * (sqrt((h + 2.0) / h) - 1.0)));
  if (m_max > 1000.0) m_max = 1000.0;
  uint64_t best = 0;
  for (unsigned m = 3; (double)m < m_max; m++) {
    uint64_t v = ldr_for_m(p, (double)m);
    if (v >= best) best = v;
  }
  return (unsigned)(best < SEC_COLLISION ? best : SEC_COLLISION);
}
