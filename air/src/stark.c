/* SPDX-License-Identifier: AGPL-3.0-only
 * Additional terms: SnapKitty Opaque License (SNAPKITTY_OPAQUE_LICENSE.md, repository root).
 * Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 */
#include "air/stark.h"
#include "air/poly.h"
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define FAIL(code, msg) do { if (why) *why = (msg); rc = (code); goto done; } while (0)

static void *xcalloc(size_t n, size_t s) {
  void *p = calloc(n ? n : 1, s);
  if (!p) abort();
  return p;
}

air_params air_policy_params(uint32_t log_trace_len) {
  air_params p = {log_trace_len, AIR_POLICY_LOG_BLOWUP, AIR_POLICY_QUERIES, AIR_POLICY_GRINDING,
                  AIR_POLICY_LOG_REMAINDER};
  return p;
}
uint32_t air_trace_log_for_inputs(size_t n) {
  uint32_t k = AIR_MIN_LOG_TRACE;
  while (((size_t)1 << k) < n + 1) k++;
  return k <= AIR_MAX_LOG_TRACE ? k : 0;
}
uint32_t air_num_folds(const air_params *p) { return p->log_trace_len - p->log_remainder; }
size_t air_query_path_count(const air_params *p) {
  size_t d0 = p->log_trace_len + p->log_blowup - 1, r = air_num_folds(p), c = 2 * d0;
  for (size_t l = 1; l < r; l++) c += d0 - l;
  return c;
}
void air_proof_free(air_proof *pf) {
  if (pf->q) for (uint32_t i = 0; i < pf->prm.num_queries; i++) free(pf->q[i].paths);
  free(pf->q);
  free(pf->rem);
  pf->q = NULL;
  pf->rem = NULL;
}

static void fp2_put(uint8_t *b, fp2 v) { put_u64le(b, v.c0); put_u64le(b + 8, v.c1); }
static void leaf_trace(fp x0, fp a0, fp x1, fp a1, digest *d) {
  uint8_t b[32];
  put_u64le(b, x0); put_u64le(b + 8, a0); put_u64le(b + 16, x1); put_u64le(b + 24, a1);
  merkle_leaf_hash(b, sizeof b, d);
}
static void leaf_fp2(fp2 v0, fp2 v1, digest *d) {
  uint8_t b[32];
  fp2_put(b, v0); fp2_put(b + 16, v1);
  merkle_leaf_hash(b, sizeof b, d);
}

/* strict decimal u64 (no sign, no leading zeros) */
static int parse_u64(const char *s, uint64_t *v) {
  if (!s || !*s) return -1;
  if (s[0] == '0' && s[1]) return -1;
  uint64_t r = 0;
  for (; *s; s++) {
    if (*s < '0' || *s > '9') return -1;
    uint64_t d = (uint64_t)(*s - '0');
    if (r > (UINT64_MAX - d) / 10) return -1;
    r = r * 10 + d;
  }
  *v = r;
  return 0;
}
static int is_hex64(const char *s) {
  if (!s || strlen(s) != 64) return 0;
  for (; *s; s++) if (!((*s >= '0' && *s <= '9') || (*s >= 'a' && *s <= 'f'))) return 0;
  return 1;
}
static uint64_t gcd_u64(uint64_t a, uint64_t b) { while (b) { uint64_t t = a % b; a = b; b = t; } return a; }

int air_inputs_sha256(const int64_t *q, size_t n, char out[65]) {
  sha256_ctx *c = sha256_new();
  for (size_t i = 0; i < n; i++) {
    uint8_t b[8];
    put_u64le(b, (uint64_t)q[i]);
    sha256_update(c, b, 8);
  }
  uint8_t d[32];
  sha256_final_free(c, d);
  hex_encode(d, 32, out);
  return 0;
}
int air_execute(const int64_t *q, size_t n, uint64_t *output) {
  if (!air_trace_log_for_inputs(n)) return -1;
  unsigned __int128 s = 0;
  for (size_t i = 0; i < n; i++) {
    if (q[i] > AIR_MAX_ABS_INPUT || q[i] < -AIR_MAX_ABS_INPUT) return -1;
    s += (unsigned __int128)((__int128)q[i] * q[i]);
  }
  if (s >= FP_P) return -1; /* cannot happen within the bounds; kept as a guard */
  *output = (uint64_t)s;
  return 0;
}
static void rational_str(uint64_t num, int64_t scale, char *buf, size_t len) {
  uint64_t den = (uint64_t)scale * (uint64_t)scale;
  uint64_t g = gcd_u64(num, den);
  if (num == 0) { snprintf(buf, len, "0/1"); return; }
  snprintf(buf, len, "%" PRIu64 "/%" PRIu64, num / g, den / g);
}

int air_build_public(lrd_rec *rec, const char obs[65], const char prev[65], uint64_t seq,
                     int64_t scale, const char *input_name, const int64_t *q, size_t n,
                     uint64_t output, const air_params *p) {
  char ih[65], rat[64];
  if (!is_hex64(obs) || !is_hex64(prev) || scale <= 0 || scale > ((int64_t)1 << 31)) return -1;
  air_inputs_sha256(q, n, ih);
  rational_str(output, scale, rat, sizeof rat);
  rec_init(rec);
  int e = 0;
  e |= rec_set(rec, "air", AIR_NAME);
  e |= rec_set_u64(rec, "blowup", (uint64_t)1 << p->log_blowup);
  e |= rec_set(rec, "field", "goldilocks_p=2^64-2^32+1;challenges=fp2(u^2=7)");
  e |= rec_set_u64(rec, "fri_folding", 2);
  e |= rec_set_u64(rec, "fri_remainder_coeffs", (uint64_t)1 << p->log_remainder);
  e |= rec_set_u64(rec, "grinding_bits", p->grinding_bits);
  e |= rec_set(rec, "hash", "sha256");
  e |= rec_set_u64(rec, "input_count", n);
  e |= rec_set(rec, "input_name", input_name);
  e |= rec_set(rec, "inputs_sha256", ih);
  e |= rec_set(rec, "ledger_prev_commit", prev);
  e |= rec_set_u64(rec, "ledger_seq", seq);
  e |= rec_set(rec, "observation_sha256", obs);
  e |= rec_set_u64(rec, "output", output);
  e |= rec_set(rec, "output_rational", rat);
  e |= rec_set_u64(rec, "queries", p->num_queries);
  e |= rec_set_u64(rec, "scale", (uint64_t)scale);
  e |= rec_set_u64(rec, "trace_length", (uint64_t)1 << p->log_trace_len);
  return e ? -1 : 0;
}

/* Validate the public record against the inputs and the policy; return claimed output. */
static int check_public(const lrd_rec *pub, const int64_t *q, size_t n, const air_params *P,
                        uint64_t *out, const char **why) {
#define PCHK(c, m) do { if (!(c)) { if (why) *why = (m); return -1; } } while (0)
  uint64_t v, scale;
  const char *s;
  char ih[65], rat[64];
  PCHK((s = rec_get(pub, "air")) && !strcmp(s, AIR_NAME), "pub_air_name");
  PCHK(!parse_u64(rec_get(pub, "blowup"), &v) && v == (1ull << P->log_blowup), "pub_blowup");
  PCHK((s = rec_get(pub, "field")) && !strcmp(s, "goldilocks_p=2^64-2^32+1;challenges=fp2(u^2=7)"), "pub_field");
  PCHK(!parse_u64(rec_get(pub, "fri_folding"), &v) && v == 2, "pub_fri_folding");
  PCHK(!parse_u64(rec_get(pub, "fri_remainder_coeffs"), &v) && v == (1ull << P->log_remainder), "pub_remainder");
  PCHK(!parse_u64(rec_get(pub, "grinding_bits"), &v) && v == P->grinding_bits, "pub_grinding");
  PCHK((s = rec_get(pub, "hash")) && !strcmp(s, "sha256"), "pub_hash");
  PCHK(!parse_u64(rec_get(pub, "input_count"), &v) && v == n, "pub_input_count");
  PCHK(rec_get(pub, "input_name") != NULL, "pub_input_name");
  air_inputs_sha256(q, n, ih);
  PCHK((s = rec_get(pub, "inputs_sha256")) && !strcmp(s, ih), "pub_inputs_sha256");
  PCHK(is_hex64(rec_get(pub, "ledger_prev_commit")), "pub_ledger_prev_commit");
  PCHK(!parse_u64(rec_get(pub, "ledger_seq"), &v), "pub_ledger_seq");
  PCHK(is_hex64(rec_get(pub, "observation_sha256")), "pub_observation_sha256");
  PCHK(!parse_u64(rec_get(pub, "output"), out) && *out < FP_P, "pub_output");
  PCHK(!parse_u64(rec_get(pub, "scale"), &scale) && scale > 0 && scale <= (1ull << 31), "pub_scale");
  rational_str(*out, (int64_t)scale, rat, sizeof rat);
  PCHK((s = rec_get(pub, "output_rational")) && !strcmp(s, rat), "pub_output_rational");
  PCHK(!parse_u64(rec_get(pub, "queries"), &v) && v == P->num_queries, "pub_queries");
  PCHK(!parse_u64(rec_get(pub, "trace_length"), &v) && v == (1ull << P->log_trace_len), "pub_trace_length");
  PCHK(pub->n == 18, "pub_unexpected_fields");
  for (size_t i = 0; i < n; i++)
    PCHK(q[i] <= AIR_MAX_ABS_INPUT && q[i] >= -AIR_MAX_ABS_INPUT, "input_out_of_bounds");
  return 0;
#undef PCHK
}

static void transcript_start(transcript *ts, const lrd_rec *pub, const air_params *P) {
  size_t len;
  unsigned char *s = rec_serialize(pub, &len);
  if (!s) abort();
  ts_init(ts);
  ts_absorb(ts, s, len); /* public-input record FIRST */
  free(s);
  uint8_t h[AIR_HEADER_LEN];
  air_header_bytes(P, h);
  ts_absorb(ts, h, sizeof h);
}
static fp2 draw_ood_point(transcript *ts) {
  for (;;) {
    fp2 z = ts_draw_fp2(ts);
    if (z.c1 != 0) return z; /* z in Fp2 \ Fp: never in the trace domain or the LDE coset */
  }
}
static void absorb_fp2s(transcript *ts, const fp2 *v, size_t n) {
  uint8_t *b = xcalloc(n, 16);
  for (size_t i = 0; i < n; i++) fp2_put(b + 16 * i, v[i]);
  ts_absorb(ts, b, 16 * n);
  free(b);
}
/* Draw num_queries DISTINCT pair indices in [0, half) (duplicates are re-drawn). */
static void draw_queries(transcript *ts, size_t half, uint32_t nq, size_t *out) {
  for (uint32_t i = 0; i < nq;) {
    size_t j = (size_t)(ts_draw_u64(ts) & (half - 1));
    int dup = 0;
    for (uint32_t k = 0; k < i; k++) if (out[k] == j) dup = 1;
    if (!dup) out[i++] = j;
  }
}
static fp2 fold_pair(fp2 lo, fp2 hi, fp2 beta, fp x) {
  fp inv2 = (FP_P + 1) / 2;
  fp2 even = fp2_mul_fp(fp2_add(lo, hi), inv2);
  fp2 odd = fp2_mul_fp(fp2_sub(lo, hi), fp_mul(inv2, fp_inv(x)));
  return fp2_add(even, fp2_mul(beta, odd));
}
/* sum_k alpha_k * C_k / Z_k given values at a point X (generic over Fp2) */
static fp2 composition_at(const fp2 alpha[4], fp2 X, fp2 a, fp2 x, fp2 a_next, fp2 ix, fp2 out,
                          fp wlast, size_t N) {
  fp2 one = fp2_from_fp(1);
  fp2 zh = fp2_sub(fp2_pow(X, N), one);
  fp2 xl = fp2_sub(X, fp2_from_fp(wlast));
  fp2 zhi = fp2_inv(zh);
  fp2 t = fp2_mul(fp2_mul(fp2_sub(fp2_sub(a_next, a), fp2_mul(x, x)), xl), zhi);
  fp2 b0 = fp2_mul(a, fp2_inv(fp2_sub(X, one)));
  fp2 b1 = fp2_mul(fp2_sub(a, out), fp2_inv(xl));
  fp2 in = fp2_mul(fp2_sub(x, ix), zhi);
  fp2 r = fp2_mul(alpha[0], t);
  r = fp2_add(r, fp2_mul(alpha[1], b0));
  r = fp2_add(r, fp2_mul(alpha[2], b1));
  return fp2_add(r, fp2_mul(alpha[3], in));
}
/* DEEP composition value at an LDE point */
static fp2 deep_at(const fp2 gam[5], const fp2 ood[5], fp X, fp xv, fp av, fp2 hv, fp2 z, fp2 wz) {
  fp2 Xe = fp2_from_fp(X);
  fp2 iz = fp2_inv(fp2_sub(Xe, z)), iwz = fp2_inv(fp2_sub(Xe, wz));
  fp2 A = fp2_from_fp(av), Xv = fp2_from_fp(xv);
  fp2 r = fp2_mul(gam[0], fp2_mul(fp2_sub(A, ood[0]), iz));
  r = fp2_add(r, fp2_mul(gam[1], fp2_mul(fp2_sub(Xv, ood[1]), iz)));
  r = fp2_add(r, fp2_mul(gam[2], fp2_mul(fp2_sub(A, ood[2]), iwz)));
  r = fp2_add(r, fp2_mul(gam[3], fp2_mul(fp2_sub(Xv, ood[3]), iwz)));
  return fp2_add(r, fp2_mul(gam[4], fp2_mul(fp2_sub(hv, ood[4]), iz)));
}
static int fp2_coset_intt(fp2 *v, size_t m, fp offset) {
  fp *c0 = xcalloc(m, sizeof *c0), *c1 = xcalloc(m, sizeof *c1);
  for (size_t i = 0; i < m; i++) { c0[i] = v[i].c0; c1[i] = v[i].c1; }
  int e = fp_coset_intt(c0, m, offset) | fp_coset_intt(c1, m, offset);
  for (size_t i = 0; i < m; i++) v[i] = fp2_make(c0[i], c1[i]);
  free(c0); free(c1);
  return e;
}

int air_prove(const lrd_rec *pub, const int64_t *q, size_t n, const air_prove_opts *opt,
              air_proof *pf, const char **why) {
  air_prove_opts dflt = {0};
  if (!opt) opt = &dflt;
  memset(pf, 0, sizeof *pf);
  int rc = 0;
  uint32_t logN = air_trace_log_for_inputs(n);
  fp *x = NULL, *a = NULL, *iv = NULL, *xc = NULL, *ac = NULL, *xl = NULL, *al = NULL, *il = NULL;
  fp *xs = NULL, *dzh = NULL, *d1 = NULL, *dl = NULL;
  fp2 *hl = NULL, *hcoef = NULL, *inz = NULL, *inwz = NULL, *layers[AIR_MAX_FRI + 1] = {0};
  digest *lh = NULL;
  merkle_tree tt = {0}, ct = {0}, ft[AIR_MAX_FRI] = {{0}};
  if (!logN) { if (why) *why = "too_many_inputs"; return -1; }
  air_params P = air_policy_params(logN);
  pf->prm = P;
  uint64_t out;
  if (check_public(pub, q, n, &P, &out, why)) return -1;
  size_t N = (size_t)1 << logN, B = (size_t)1 << P.log_blowup, M = N * B, half = M / 2;
  uint32_t r = air_num_folds(&P);

  /* 1. execution trace */
  x = xcalloc(N, sizeof *x); a = xcalloc(N, sizeof *a); iv = xcalloc(N, sizeof *iv);
  for (size_t i = 0; i < n; i++) x[i] = iv[i] = fp_from_i64(q[i]);
  for (size_t i = 0; i + 1 < N; i++) a[i + 1] = fp_add(a[i], fp_sqr(x[i]));
  if (!opt->force && a[N - 1] != out) FAIL(-2, "claimed_output_differs_from_execution");
  if (opt->corrupt) {
    if (opt->corrupt_row >= N || opt->corrupt_col > 1) FAIL(-3, "bad_corruption_spec");
    fp *col = opt->corrupt_col ? a : x;
    col[opt->corrupt_row] = fp_add(col[opt->corrupt_row], opt->corrupt_delta);
  }
  /* 2. interpolation + low-degree extension on coset 7*<w_M> */
  xc = xcalloc(N, sizeof *xc); ac = xcalloc(N, sizeof *ac);
  memcpy(xc, x, N * sizeof *x); memcpy(ac, a, N * sizeof *a);
  fp_intt(xc, N); fp_intt(ac, N);
  xl = xcalloc(M, sizeof *xl); al = xcalloc(M, sizeof *al); il = xcalloc(M, sizeof *il);
  fp_lde(x, N, B, FP_GEN, xl); fp_lde(a, N, B, FP_GEN, al); fp_lde(iv, N, B, FP_GEN, il);

  transcript ts;
  transcript_start(&ts, pub, &P);
  /* 3. trace commitment */
  lh = xcalloc(half, sizeof *lh);
  for (size_t j = 0; j < half; j++) leaf_trace(xl[j], al[j], xl[j + half], al[j + half], &lh[j]);
  if (merkle_build(&tt, lh, half)) FAIL(-4, "merkle");
  pf->trace_root = merkle_root(&tt);
  ts_absorb(&ts, pf->trace_root.b, 32);
  fp2 alpha[4];
  for (int k = 0; k < 4; k++) alpha[k] = ts_draw_fp2(&ts);

  /* 4. composition polynomial evaluations on the LDE coset */
  fp wM = fp_root_of_unity(logN + P.log_blowup), wN = fp_root_of_unity(logN), wlast = fp_inv(wN);
  xs = xcalloc(M, sizeof *xs); dzh = xcalloc(M, sizeof *dzh); d1 = xcalloc(M, sizeof *d1); dl = xcalloc(M, sizeof *dl);
  {
    fp X = FP_GEN;
    for (size_t k = 0; k < M; k++) {
      xs[k] = X;
      dzh[k] = fp_sub(fp_pow(X, N), 1);
      d1[k] = fp_sub(X, 1);
      dl[k] = fp_sub(X, wlast);
      X = fp_mul(X, wM);
    }
  }
  fp_batch_inv(dzh, M); fp_batch_inv(d1, M); fp_batch_inv(dl, M);
  hl = xcalloc(M, sizeof *hl);
  for (size_t k = 0; k < M; k++) {
    size_t kn = (k + B) & (M - 1);
    fp t = fp_sub(fp_sub(al[kn], al[k]), fp_sqr(xl[k]));
    t = fp_mul(fp_mul(t, fp_sub(xs[k], wlast)), dzh[k]);
    fp b0 = fp_mul(al[k], d1[k]);
    fp b1 = fp_mul(fp_sub(al[k], out), dl[k]);
    fp in = fp_mul(fp_sub(xl[k], il[k]), dzh[k]);
    fp2 h = fp2_mul_fp(alpha[0], t);
    h = fp2_add(h, fp2_mul_fp(alpha[1], b0));
    h = fp2_add(h, fp2_mul_fp(alpha[2], b1));
    hl[k] = fp2_add(h, fp2_mul_fp(alpha[3], in));
  }
  hcoef = xcalloc(M, sizeof *hcoef);
  memcpy(hcoef, hl, M * sizeof *hl);
  fp2_coset_intt(hcoef, M, FP_GEN);
  if (!opt->force)
    for (size_t k = N; k < M; k++)
      if (!fp2_is_zero(hcoef[k])) FAIL(-5, "composition_not_low_degree(trace violates constraints)");
  for (size_t j = 0; j < half; j++) leaf_fp2(hl[j], hl[j + half], &lh[j]);
  if (merkle_build(&ct, lh, half)) FAIL(-4, "merkle");
  pf->comp_root = merkle_root(&ct);
  ts_absorb(&ts, pf->comp_root.b, 32);

  /* 5. out-of-domain evaluation (DEEP) */
  fp2 z = draw_ood_point(&ts), wz = fp2_mul_fp(z, wN);
  pf->ood[0] = fp_poly_eval_ext(ac, N, z);
  pf->ood[1] = fp_poly_eval_ext(xc, N, z);
  pf->ood[2] = fp_poly_eval_ext(ac, N, wz);
  pf->ood[3] = fp_poly_eval_ext(xc, N, wz);
  pf->ood[4] = fp2_poly_eval(hcoef, M, z);
  if (opt->force && opt->cheat_ood) {
    fp *icf = xcalloc(N, sizeof *icf);
    memcpy(icf, iv, N * sizeof *iv);
    fp_intt(icf, N);
    fp2 izv = fp_poly_eval_ext(icf, N, z);
    free(icf);
    pf->ood[4] = composition_at(alpha, z, pf->ood[0], pf->ood[1], pf->ood[2], izv, fp2_from_fp(out), wlast, N);
  }
  absorb_fp2s(&ts, pf->ood, 5);
  fp2 gam[5];
  for (int k = 0; k < 5; k++) gam[k] = ts_draw_fp2(&ts);
  inz = xcalloc(M, sizeof *inz); inwz = xcalloc(M, sizeof *inwz);
  for (size_t k = 0; k < M; k++) {
    inz[k] = fp2_sub(fp2_from_fp(xs[k]), z);
    inwz[k] = fp2_sub(fp2_from_fp(xs[k]), wz);
  }
  fp2_batch_inv(inz, M); fp2_batch_inv(inwz, M);
  layers[0] = xcalloc(M, sizeof(fp2));
  for (size_t k = 0; k < M; k++) {
    fp2 A = fp2_from_fp(al[k]), Xv = fp2_from_fp(xl[k]);
    fp2 d = fp2_mul(gam[0], fp2_mul(fp2_sub(A, pf->ood[0]), inz[k]));
    d = fp2_add(d, fp2_mul(gam[1], fp2_mul(fp2_sub(Xv, pf->ood[1]), inz[k])));
    d = fp2_add(d, fp2_mul(gam[2], fp2_mul(fp2_sub(A, pf->ood[2]), inwz[k])));
    d = fp2_add(d, fp2_mul(gam[3], fp2_mul(fp2_sub(Xv, pf->ood[3]), inwz[k])));
    layers[0][k] = fp2_add(d, fp2_mul(gam[4], fp2_mul(fp2_sub(hl[k], pf->ood[4]), inz[k])));
  }

  /* 6. FRI commit phase (fold factor 2) */
  {
    size_t m = M;
    fp s = FP_GEN, w = wM;
    for (uint32_t l = 0; l < r; l++) {
      if (l >= 1) {
        for (size_t j = 0; j < m / 2; j++) leaf_fp2(layers[l][j], layers[l][j + m / 2], &lh[j]);
        if (merkle_build(&ft[l], lh, m / 2)) FAIL(-4, "merkle");
        pf->fri_roots[l - 1] = merkle_root(&ft[l]);
        ts_absorb(&ts, pf->fri_roots[l - 1].b, 32);
      }
      fp2 beta = ts_draw_fp2(&ts);
      layers[l + 1] = xcalloc(m / 2, sizeof(fp2));
      fp xv = s;
      for (size_t j = 0; j < m / 2; j++) {
        layers[l + 1][j] = fold_pair(layers[l][j], layers[l][j + m / 2], beta, xv);
        xv = fp_mul(xv, w);
      }
      m /= 2; s = fp_sqr(s); w = fp_sqr(w);
    }
    pf->n_fri_roots = r - 1;
    /* remainder polynomial */
    fp2_coset_intt(layers[r], m, s);
    size_t nrem = (size_t)1 << P.log_remainder;
    if (!opt->force)
      for (size_t k = nrem; k < m; k++)
        if (!fp2_is_zero(layers[r][k])) FAIL(-6, "fri_remainder_not_low_degree");
    pf->n_rem = (uint32_t)nrem;
    pf->rem = xcalloc(nrem, sizeof(fp2));
    memcpy(pf->rem, layers[r], nrem * sizeof(fp2));
    absorb_fp2s(&ts, pf->rem, nrem);
  }
  /* 7. grinding */
  pf->nonce = ts_grind(&ts, P.grinding_bits);
  { uint8_t nb[8]; put_u64le(nb, pf->nonce); ts_absorb(&ts, nb, 8); }
  /* 8. query phase */
  pf->q = xcalloc(P.num_queries, sizeof *pf->q);
  {
    size_t qidx[256];
    if (P.num_queries > 256 || P.num_queries > half) FAIL(-7, "too_many_queries");
    draw_queries(&ts, half, P.num_queries, qidx);
    size_t d0 = logN + P.log_blowup - 1, np = air_query_path_count(&P);
    for (uint32_t i = 0; i < P.num_queries; i++) {
      air_query *Q = &pf->q[i];
      size_t j = qidx[i];
      Q->paths = xcalloc(np, sizeof(digest));
      Q->trace[0][0] = xl[j]; Q->trace[0][1] = al[j];
      Q->trace[1][0] = xl[j + half]; Q->trace[1][1] = al[j + half];
      Q->comp[0] = hl[j]; Q->comp[1] = hl[j + half];
      digest *pp = Q->paths;
      merkle_path(&tt, j, pp); pp += d0;
      merkle_path(&ct, j, pp); pp += d0;
      for (uint32_t l = 1; l < r; l++) {
        size_t ml = M >> l, jl = j & (ml / 2 - 1);
        Q->fri[l][0] = layers[l][jl]; Q->fri[l][1] = layers[l][jl + ml / 2];
        merkle_path(&ft[l], jl, pp); pp += d0 - l;
      }
    }
  }
done:
  free(x); free(a); free(iv); free(xc); free(ac); free(xl); free(al); free(il);
  free(xs); free(dzh); free(d1); free(dl); free(hl); free(hcoef); free(inz); free(inwz); free(lh);
  for (uint32_t l = 0; l <= AIR_MAX_FRI; l++) free(layers[l]);
  merkle_free(&tt); merkle_free(&ct);
  for (uint32_t l = 0; l < AIR_MAX_FRI; l++) merkle_free(&ft[l]);
  if (rc) air_proof_free(pf);
  return rc;
}

static int verify_impl(const lrd_rec *pub, const int64_t *q, size_t n, const air_proof *pf, unsigned flags,
                       const char **why) {
  int rc = 1;
  fp *ic = NULL;
  uint32_t logN = air_trace_log_for_inputs(n);
  if (!logN) { if (why) *why = "too_many_inputs"; return 0; }
  air_params P = air_policy_params(logN);
  if (memcmp(&P, &pf->prm, sizeof P)) { if (why) *why = "params_not_policy"; return 0; }
  uint64_t out;
  if (check_public(pub, q, n, &P, &out, why)) return 0;
  size_t N = (size_t)1 << logN, B = (size_t)1 << P.log_blowup, M = N * B, half = M / 2;
  uint32_t r = air_num_folds(&P);
  size_t d0 = logN + P.log_blowup - 1;
  if (pf->n_fri_roots != r - 1 || pf->n_rem != (1u << P.log_remainder) || !pf->q || !pf->rem) {
    if (why) *why = "proof_shape";
    return 0;
  }
  fp wM = fp_root_of_unity(logN + P.log_blowup), wN = fp_root_of_unity(logN), wlast = fp_inv(wN);

  transcript ts;
  transcript_start(&ts, pub, &P);
  ts_absorb(&ts, pf->trace_root.b, 32);
  fp2 alpha[4];
  for (int k = 0; k < 4; k++) alpha[k] = ts_draw_fp2(&ts);
  ts_absorb(&ts, pf->comp_root.b, 32);
  fp2 z = draw_ood_point(&ts), wz = fp2_mul_fp(z, wN);
  absorb_fp2s(&ts, pf->ood, 5);
  fp2 gam[5];
  for (int k = 0; k < 5; k++) gam[k] = ts_draw_fp2(&ts);
  fp2 beta[AIR_MAX_FRI];
  for (uint32_t l = 0; l < r; l++) {
    if (l >= 1) ts_absorb(&ts, pf->fri_roots[l - 1].b, 32);
    beta[l] = ts_draw_fp2(&ts);
  }
  absorb_fp2s(&ts, pf->rem, pf->n_rem);
  if (!(flags & AIR_DIAG_SKIP_GRINDING) && !ts_grind_ok(&ts, pf->nonce, P.grinding_bits)) FAIL(0, "grinding_nonce_invalid");
  { uint8_t nb[8]; put_u64le(nb, pf->nonce); ts_absorb(&ts, nb, 8); }

  /* out-of-domain consistency: H(z) == sum alpha_k C_k(z)/Z_k(z) */
  ic = xcalloc(N, sizeof *ic);
  for (size_t i = 0; i < n; i++) ic[i] = fp_from_i64(q[i]);
  fp_intt(ic, N);
  fp2 iz = fp_poly_eval_ext(ic, N, z);
  fp2 hz = composition_at(alpha, z, pf->ood[0], pf->ood[1], pf->ood[2], iz, fp2_from_fp(out), wlast, N);
  if (!fp2_eq(hz, pf->ood[4])) FAIL(0, "ood_constraint_mismatch");

  size_t qidx[256];
  if (P.num_queries > 256 || P.num_queries > half) FAIL(0, "too_many_queries");
  draw_queries(&ts, half, P.num_queries, qidx);
  for (uint32_t i = 0; i < P.num_queries; i++) {
    const air_query *Q = &pf->q[i];
    size_t j = qidx[i];
    const digest *pp = Q->paths;
    digest lh;
    leaf_trace(Q->trace[0][0], Q->trace[0][1], Q->trace[1][0], Q->trace[1][1], &lh);
    if (!merkle_verify(&pf->trace_root, &lh, j, (unsigned)d0, pp)) FAIL(0, "trace_merkle_path");
    pp += d0;
    leaf_fp2(Q->comp[0], Q->comp[1], &lh);
    if (!merkle_verify(&pf->comp_root, &lh, j, (unsigned)d0, pp)) FAIL(0, "composition_merkle_path");
    pp += d0;
    fp X0 = fp_mul(FP_GEN, fp_pow(wM, j)), X1 = fp_neg(X0);
    fp2 D0 = deep_at(gam, pf->ood, X0, Q->trace[0][0], Q->trace[0][1], Q->comp[0], z, wz);
    fp2 D1 = deep_at(gam, pf->ood, X1, Q->trace[1][0], Q->trace[1][1], Q->comp[1], z, wz);
    fp2 v = fold_pair(D0, D1, beta[0], X0);
    fp s = fp_sqr(FP_GEN), w = fp_sqr(wM);
    for (uint32_t l = 1; l < r; l++) {
      size_t ml = M >> l, pl = j & (ml - 1), jl = pl & (ml / 2 - 1);
      leaf_fp2(Q->fri[l][0], Q->fri[l][1], &lh);
      if (!merkle_verify(&pf->fri_roots[l - 1], &lh, jl, (unsigned)(d0 - l), pp)) FAIL(0, "fri_merkle_path");
      pp += d0 - l;
      if (!fp2_eq(v, Q->fri[l][pl >= ml / 2])) FAIL(0, "fri_fold_mismatch");
      v = fold_pair(Q->fri[l][0], Q->fri[l][1], beta[l], fp_mul(s, fp_pow(w, jl)));
      s = fp_sqr(s); w = fp_sqr(w);
    }
    size_t mr = M >> r, pr = j & (mr - 1);
    fp xr = fp_mul(s, fp_pow(w, pr));
    if (!fp2_eq(v, fp2_poly_eval(pf->rem, pf->n_rem, fp2_from_fp(xr)))) FAIL(0, "fri_remainder_mismatch");
  }
  if (why) *why = "ok";
done:
  free(ic);
  return rc;
}
int air_verify(const lrd_rec *pub, const int64_t *q, size_t n, const air_proof *pf, const char **why) {
  return verify_impl(pub, q, n, pf, 0, why);
}
int air_verify_diag(const lrd_rec *pub, const int64_t *q, size_t n, const air_proof *pf, unsigned flags,
                    const char **why) {
  return verify_impl(pub, q, n, pf, flags, why);
}
