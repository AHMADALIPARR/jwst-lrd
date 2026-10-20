/* SPDX-License-Identifier: AGPL-3.0-only
 * Additional terms: SnapKitty Opaque License (SNAPKITTY_OPAQUE_LICENSE.md, repository root).
 * Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 *
 * Unit + integration tests for the AIR/STARK subsystem. Prints one line per test:
 *   PASS <name> | FAIL <name> <why>
 * Usage: test_air <synthetic_arr_base>
 */
#include "air/arr.h"
#include "air/crypto.h"
#include "air/field.h"
#include "air/poly.h"
#include "air/rec.h"
#include "air/stark.h"
#include "air/state.h"
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int g_fail = 0;
static char g_why[512];
#define CHECK(c, ...) do { if (!(c)) { snprintf(g_why, sizeof g_why, __VA_ARGS__); return 0; } } while (0)
static void report(const char *name, int ok) {
  if (ok) printf("PASS %s\n", name);
  else { printf("FAIL %s %s\n", name, g_why); g_fail = 1; }
  fflush(stdout);
}

static uint64_t rng_state = 0x9E3779B97F4A7C15ull;
static uint64_t rnd(void) { /* xorshift64* (test data only) */
  rng_state ^= rng_state >> 12; rng_state ^= rng_state << 25; rng_state ^= rng_state >> 27;
  return rng_state * 0x2545F4914F6CDD1Dull;
}
static fp rnd_fp(void) { return rnd() % FP_P; }

/* ---------------- SHA-256: FIPS 180-4 / NIST CSRC example vectors */
static int t_sha256(void) {
  static const struct { const char *msg; const char *hex; } v[] = {
    {"abc", "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad"},
    {"", "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"},
    {"abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq",
     "248d6a61d20638b8e5c026930c3e6039a33ce45964ff2167f6ecedd419db06c1"},
  };
  uint8_t d[32];
  char h[65];
  for (size_t i = 0; i < 3; i++) {
    sha256(v[i].msg, strlen(v[i].msg), d);
    hex_encode(d, 32, h);
    CHECK(!strcmp(h, v[i].hex), "vector %zu got %s", i, h);
  }
  /* one million 'a', also exercising the incremental interface */
  char blk[1000];
  memset(blk, 'a', sizeof blk);
  sha256_ctx *c = sha256_new();
  for (int i = 0; i < 1000; i++) sha256_update(c, blk, sizeof blk);
  sha256_final_free(c, d);
  hex_encode(d, 32, h);
  CHECK(!strcmp(h, "cdc76e5c9914fb9281a1c7e284d73e67f1809a48a497200e046d39ccc7112cd0"), "1M a got %s", h);
  return 1;
}

/* ---------------- field */
static int t_field_arith(void) {
  for (int i = 0; i < 200000; i++) {
    fp a = rnd_fp(), b = rnd_fp();
    if (i < 4) { a = FP_P - 1 - (fp)i; b = FP_P - 1; }
    unsigned __int128 P = FP_P;
    CHECK(fp_mul(a, b) == (fp)(((unsigned __int128)a * b) % P), "mul %" PRIu64 " %" PRIu64, a, b);
    CHECK(fp_add(a, b) == (fp)(((unsigned __int128)a + b) % P), "add");
    CHECK(fp_sub(a, b) == (fp)(((unsigned __int128)a + P - b) % P), "sub");
    if (a) CHECK(fp_mul(a, fp_inv(a)) == 1, "inv");
  }
  /* full 128-bit reduction edge: (p-1)^2 = 1 */
  CHECK(fp_mul(FP_P - 1, FP_P - 1) == 1, "(p-1)^2");
  CHECK(fp_reduce128(~(unsigned __int128)0) == (fp)((~(unsigned __int128)0) % FP_P), "reduce max");
  CHECK(fp_from_i64(-1) == FP_P - 1 && fp_from_i64(INT64_MIN) == fp_neg((fp)((uint64_t)1 << 63)), "from_i64");
  CHECK(fp_pow(3, FP_P - 1) == 1, "fermat");
  return 1;
}
static int t_field_roots(void) {
  CHECK(fp_pow(FP_GEN, (FP_P - 1) / 2) == FP_P - 1, "7 is not a quadratic non-residue");
  CHECK(fp_pow(2, 96) == FP_P - 1, "2^96 != -1");
  CHECK(fp_pow(8, 32) == FP_P - 1 && fp_pow(8, 64) == 1, "8 is not a primitive 64th root");
  for (unsigned k = 1; k <= 32; k++) {
    fp w = fp_root_of_unity(k);
    CHECK(fp_pow(w, (uint64_t)1 << k) == 1, "w_2^%u^n != 1", k);
    CHECK(fp_pow(w, (uint64_t)1 << (k - 1)) == FP_P - 1, "w_2^%u not primitive", k);
  }
  CHECK(fp_sqr(fp_root_of_unity(6)) == fp_root_of_unity(5), "root tower");
  return 1;
}
static int t_fp2(void) {
  fp2 u = fp2_make(0, 1);
  CHECK(fp2_eq(fp2_mul(u, u), fp2_from_fp(7)), "u^2 != 7");
  for (int i = 0; i < 2000; i++) {
    fp2 a = fp2_make(rnd_fp(), rnd_fp()), b = fp2_make(rnd_fp(), rnd_fp()), c = fp2_make(rnd_fp(), rnd_fp());
    CHECK(fp2_eq(fp2_mul(fp2_mul(a, b), c), fp2_mul(a, fp2_mul(b, c))), "assoc");
    CHECK(fp2_eq(fp2_mul(a, fp2_add(b, c)), fp2_add(fp2_mul(a, b), fp2_mul(a, c))), "distrib");
    if (!fp2_is_zero(a)) CHECK(fp2_eq(fp2_mul(a, fp2_inv(a)), fp2_from_fp(1)), "inv");
  }
  /* |Fp2^*| = p^2 - 1: a^(p^2-1) = 1 computed as (a^(p-1))^(p+1) */
  fp2 a = fp2_make(rnd_fp(), rnd_fp());
  CHECK(fp2_eq(fp2_pow(fp2_pow(a, FP_P - 1), FP_P + 1), fp2_from_fp(1)), "group order");
  return 1;
}
/* ---------------- NTT / interpolation / LDE */
static int t_ntt(void) {
  size_t n = 1024;
  fp *a = malloc(n * sizeof *a), *b = malloc(n * sizeof *b);
  for (size_t i = 0; i < n; i++) a[i] = b[i] = rnd_fp();
  fp_ntt(b, n); fp_intt(b, n);
  int ok = !memcmp(a, b, n * sizeof *a);
  /* forward NTT equals naive evaluation f(w^i) */
  size_t m = 16;
  memcpy(b, a, m * sizeof *a);
  fp_ntt(b, m);
  fp w = fp_root_of_unity(4), x = 1;
  for (size_t i = 0; i < m; i++, x = fp_mul(x, w)) if (b[i] != fp_poly_eval(a, m, x)) ok = 0;
  free(a); free(b);
  CHECK(ok, "ntt round trip / naive mismatch");
  CHECK(fp_ntt(NULL, 3) != 0, "non power of two accepted");
  return 1;
}
static int t_lde(void) {
  size_t n = 64, B = 8, M = n * B;
  fp *ev = malloc(n * sizeof *ev), *co = malloc(n * sizeof *co), *l = malloc(M * sizeof *l);
  for (size_t i = 0; i < n; i++) ev[i] = rnd_fp();
  memcpy(co, ev, n * sizeof *ev);
  fp_intt(co, n); /* interpolation */
  fp w = fp_root_of_unity(6), x = 1;
  int ok = 1;
  for (size_t i = 0; i < n; i++, x = fp_mul(x, w)) if (fp_poly_eval(co, n, x) != ev[i]) ok = 0;
  fp_lde(ev, n, B, FP_GEN, l);
  fp wM = fp_root_of_unity(9);
  x = FP_GEN;
  for (size_t i = 0; i < M; i++, x = fp_mul(x, wM)) if (fp_poly_eval(co, n, x) != l[i]) ok = 0;
  fp_coset_intt(l, M, FP_GEN);
  for (size_t i = n; i < M; i++) if (l[i]) ok = 0;
  for (size_t i = 0; i < n; i++) if (l[i] != co[i]) ok = 0;
  free(ev); free(co); free(l);
  CHECK(ok, "interpolation/LDE mismatch");
  return 1;
}
/* ---------------- Merkle */
static int t_merkle(void) {
  digest lv[16];
  for (int i = 0; i < 16; i++) { uint8_t b = (uint8_t)i; merkle_leaf_hash(&b, 1, &lv[i]); }
  merkle_tree t;
  CHECK(!merkle_build(&t, lv, 16), "build");
  digest root = merkle_root(&t), path[4];
  int ok = 1;
  for (size_t i = 0; i < 16; i++) {
    merkle_path(&t, i, path);
    if (!merkle_verify(&root, &lv[i], i, 4, path)) ok = 0;
    if (merkle_verify(&root, &lv[i], (i + 1) % 16, 4, path)) ok = 0;
    if (merkle_verify(&root, &lv[i], i + 16, 4, path)) ok = 0;
    path[2].b[5] ^= 1;
    if (merkle_verify(&root, &lv[i], i, 4, path)) ok = 0;
  }
  /* independent recomputation of the root for 2 leaves */
  merkle_tree t2;
  merkle_build(&t2, lv, 2);
  uint8_t buf[65];
  buf[0] = 1; memcpy(buf + 1, lv[0].b, 32); memcpy(buf + 33, lv[1].b, 32);
  uint8_t r2[32];
  sha256(buf, 65, r2);
  if (memcmp(r2, merkle_root(&t2).b, 32)) ok = 0;
  merkle_free(&t); merkle_free(&t2);
  CHECK(ok, "merkle path verification");
  return 1;
}
/* ---------------- LRD-REC-v1 */
static int t_rec(void) {
  lrd_rec r, p;
  rec_init(&r);
  CHECK(!rec_set(&r, "b", "2") && !rec_set(&r, "a", "hello") && rec_set(&r, "a", "x") && rec_set(&r, "c", "x\ny"),
        "set semantics");
  size_t n;
  unsigned char *s = rec_serialize(&r, &n);
  const char *want = "LRD-REC-v1\n1:a5:hello\n1:b1:2\n";
  CHECK(n == strlen(want) && !memcmp(s, want, n), "serialization bytes");
  CHECK(!rec_parse(&p, s, n) && p.n == 2 && !strcmp(rec_get(&p, "a"), "hello"), "parse");
  const char *bad = "LRD-REC-v1\n1:b1:2\n1:a5:hello\n";
  CHECK(rec_parse(&p, (const unsigned char *)bad, strlen(bad)), "unsorted accepted");
  const char *bad2 = "LRD-REC-v1\n01:a1:2\n";
  CHECK(rec_parse(&p, (const unsigned char *)bad2, strlen(bad2)), "leading zero accepted");
  char c[65], c2[65];
  rec_commit(&r, c);
  unsigned char pre[64];
  memcpy(pre, "LRD-COMMIT-v1\0", 14);
  memcpy(pre + 14, want, strlen(want));
  uint8_t d[32];
  sha256(pre, 14 + strlen(want), d);
  hex_encode(d, 32, c2);
  CHECK(!strcmp(c, c2), "commitment");
  free(s);
  return 1;
}

/* ---------------- STARK fixtures */
static lrd_arr g_arr;
static int64_t *g_q;
static size_t g_n;
static lrd_state_t g_cur;
static char g_cur_commit[65];
static lrd_rec g_pub;
static uint8_t *g_proof;
static size_t g_plen;
static const int64_t SCALE = 65536;

static int build_pub(lrd_rec *pub, uint64_t output, const char *obs, const char *prev) {
  air_params P = air_policy_params(air_trace_log_for_inputs(g_n));
  return air_build_public(pub, obs, prev, g_cur.seq + 1, SCALE, g_arr.name, g_q, g_n, output, &P);
}
static int verify_bytes(const lrd_rec *pub, const uint8_t *b, size_t n, const char **why) {
  air_proof pf;
  if (air_proof_deserialize(b, n, &pf, why)) return 0;
  int ok = air_verify(pub, g_q, g_n, &pf, why);
  air_proof_free(&pf);
  return ok;
}
static int verify_bytes_diag(const lrd_rec *pub, const uint8_t *b, size_t n, const char **why) {
  air_proof pf;
  if (air_proof_deserialize(b, n, &pf, why)) return 0;
  int ok = air_verify_diag(pub, g_q, g_n, &pf, AIR_DIAG_SKIP_GRINDING, why);
  air_proof_free(&pf);
  return ok;
}
static int is_fri_reason(const char *w) { return w && !strncmp(w, "fri_", 4); }
static int setup(const char *base) {
  const char *why;
  if (arr_load(base, &g_arr, &why)) { fprintf(stderr, "load: %s\n", why); return -1; }
  if (!g_arr.synthetic) { fprintf(stderr, "expected a SYNTHETIC fixture\n"); return -1; }
  g_n = g_arr.length;
  g_q = calloc(g_n, sizeof *g_q);
  if (fixed_encode(g_arr.v, g_n, SCALE, g_q, &why)) { fprintf(stderr, "encode: %s\n", why); return -1; }
  memset(&g_cur, 0, sizeof g_cur);
  memcpy(g_cur.commit, LRD_GENESIS_COMMIT, 65);
  g_cur.kind = LRD_KIND_OBSERVATION;
  memcpy(g_cur.payload_sha256, g_arr.f64_sha256, 65);
  lrd_rec sr;
  air_state_to_rec(&g_cur, &sr);
  rec_commit(&sr, g_cur_commit);
  return 0;
}
static int t_fixed_point(void) {
  /* independent check of the kernel's numerical result against a direct double computation */
  uint64_t out;
  CHECK(!air_execute(g_q, g_n, &out), "execute");
  long double s = 0;
  for (size_t i = 0; i < g_n; i++) s += (long double)g_q[i] * (long double)g_q[i];
  CHECK((long double)out == s, "integer sum mismatch");
  for (size_t i = 0; i < g_n; i++) {
    double back = (double)g_q[i] / (double)SCALE;
    double diff = back - g_arr.v[i];
    CHECK(diff <= 0.5 / SCALE && diff >= -0.5 / SCALE, "rounding error > 1/2 ulp of scale at %zu", i);
  }
  int64_t q1;
  double big = 300.0;
  const char *why;
  CHECK(fixed_encode(&big, 1, SCALE, &q1, &why) != 0, "out-of-range input accepted");
  return 1;
}
static int t_honest(void) {
  uint64_t out;
  const char *why = NULL;
  CHECK(!air_execute(g_q, g_n, &out), "execute");
  CHECK(!build_pub(&g_pub, out, g_arr.f64_sha256, g_cur_commit), "pub");
  air_proof pf;
  CHECK(!air_prove(&g_pub, g_q, g_n, NULL, &pf, &why), "prove: %s", why);
  g_proof = air_proof_serialize(&pf, &g_plen);
  int ok = air_verify(&g_pub, g_q, g_n, &pf, &why);
  air_proof_free(&pf);
  CHECK(ok, "verify: %s", why);
  printf("# honest proof: n=%zu output=%" PRIu64 " (%s) proof_bytes=%zu\n", g_n, out,
         rec_get(&g_pub, "output_rational"), g_plen);
  return 1;
}
static int t_deterministic(void) {
  air_proof pf;
  const char *why;
  CHECK(!air_prove(&g_pub, g_q, g_n, NULL, &pf, &why), "prove");
  size_t n;
  uint8_t *b = air_proof_serialize(&pf, &n);
  air_proof_free(&pf);
  int same = n == g_plen && !memcmp(b, g_proof, n);
  free(b);
  CHECK(same, "two proofs differ");
  return 1;
}
static int t_roundtrip(void) {
  air_proof pf;
  const char *why;
  CHECK(!air_proof_deserialize(g_proof, g_plen, &pf, &why), "deserialize: %s", why);
  size_t n;
  uint8_t *b = air_proof_serialize(&pf, &n);
  int same = n == g_plen && !memcmp(b, g_proof, n);
  int ok = air_verify(&g_pub, g_q, g_n, &pf, &why);
  free(b);
  air_proof_free(&pf);
  CHECK(same, "re-serialization differs");
  CHECK(ok, "deserialized proof rejected: %s", why);
  return 1;
}
static int t_tamper_bytes(void) {
  uint8_t *b = malloc(g_plen + 1);
  size_t accepted = 0, tried = 0;
  const char *why;
  size_t stride = 1;
  const char *se = getenv("AIR_TAMPER_STRIDE");
  if (se && atoi(se) > 0) stride = (size_t)atoi(se);
  for (size_t i = 0; i < g_plen; i += stride) { /* every stride-th byte position (default: all) */
    memcpy(b, g_proof, g_plen);
    b[i] ^= (uint8_t)(1u << (i % 8));
    tried++;
    if (verify_bytes(&g_pub, b, g_plen, &why)) { accepted++; if (accepted < 4) fprintf(stderr, "accepted flip at %zu\n", i); }
  }
  memcpy(b, g_proof, g_plen);
  int trunc = verify_bytes(&g_pub, b, g_plen - 1, &why);
  b[g_plen] = 0;
  int trail = verify_bytes(&g_pub, b, g_plen + 1, &why);
  free(b);
  printf("# tampered proof: %zu/%zu single-bit flips rejected (one flip per byte position, stride %zu)\n", tried - accepted, tried, stride);
  CHECK(!accepted, "%zu of %zu byte flips accepted", accepted, tried);
  CHECK(!trunc && !trail, "truncated/trailing proof accepted");
  return 1;
}
static int corrupted(size_t row, unsigned col) {
  air_proof pf;
  const char *why = NULL;
  air_prove_opts o = {0};
  o.corrupt = 1; o.corrupt_row = row; o.corrupt_col = col; o.corrupt_delta = 1;
  CHECK(air_prove(&g_pub, g_q, g_n, &o, &pf, &why) != 0, "honest prover accepted corrupted trace");
  const char *self = why;
  o.force = 1;
  CHECK(!air_prove(&g_pub, g_q, g_n, &o, &pf, &why), "forced prove failed: %s", why);
  int ok = air_verify(&g_pub, g_q, g_n, &pf, &why);
  air_proof_free(&pf);
  CHECK(!ok, "corrupted trace (row %zu col %u) ACCEPTED", row, col);
  printf("# corrupted cell row=%zu col=%s: prover self-check '%s'; forced proof rejected by verifier: %s\n",
         row, col ? "acc" : "x", self, why);
  o.cheat_ood = 1;
  CHECK(!air_prove(&g_pub, g_q, g_n, &o, &pf, &why), "forced cheat_ood prove failed: %s", why);
  ok = air_verify(&g_pub, g_q, g_n, &pf, &why);
  air_proof_free(&pf);
  CHECK(!ok && is_fri_reason(why), "OOD-consistent corrupted proof: ok=%d reason=%s", ok, why);
  printf("#   same corruption with OOD-consistent lie about H(z): rejected by FRI: %s\n", why);
  return 1;
}
static int t_corrupt(void) {
  if (!corrupted(37, 1)) return 0;
  if (!corrupted(5, 0)) return 0;
  size_t N = (size_t)1 << air_trace_log_for_inputs(g_n);
  if (!corrupted(N - 1, 1)) return 0;
  if (!corrupted(N - 1, 0)) return 0;
  return 1;
}
static int t_fabricated_output(void) {
  uint64_t out;
  air_execute(g_q, g_n, &out);
  lrd_rec fake;
  const char *why = NULL;
  CHECK(!build_pub(&fake, out + 1, g_arr.f64_sha256, g_cur_commit), "pub");
  air_proof pf;
  CHECK(air_prove(&fake, g_q, g_n, NULL, &pf, &why) != 0, "honest prover proved a fabricated output");
  air_prove_opts o = {0};
  o.force = 1;
  CHECK(!air_prove(&fake, g_q, g_n, &o, &pf, &why), "forced prove failed: %s", why);
  int ok = air_verify(&fake, g_q, g_n, &pf, &why);
  air_proof_free(&pf);
  CHECK(!ok, "fabricated output ACCEPTED");
  printf("# fabricated output %" PRIu64 " (true %" PRIu64 "): forced proof rejected: %s\n", out + 1, out, why);
  o.cheat_ood = 1;
  CHECK(!air_prove(&fake, g_q, g_n, &o, &pf, &why), "forced cheat_ood prove failed: %s", why);
  ok = air_verify(&fake, g_q, g_n, &pf, &why);
  air_proof_free(&pf);
  CHECK(!ok && is_fri_reason(why), "OOD-consistent fabricated output: ok=%d reason=%s", ok, why);
  printf("#   fabricated output with OOD-consistent lie about H(z): rejected by FRI: %s\n", why);
  /* honest proof re-labelled with a different claimed output */
  CHECK(!verify_bytes(&fake, g_proof, g_plen, &why), "honest proof accepted for fabricated output");
  printf("# honest proof presented with fabricated output: rejected: %s\n", why);
  CHECK(!verify_bytes_diag(&fake, g_proof, g_plen, &why), "diag verifier accepted fabricated output");
  printf("#   (diagnostic verifier with grinding check skipped also rejects: %s)\n", why);
  return 1;
}
static int t_mismatch_obs(void) {
  uint64_t out;
  air_execute(g_q, g_n, &out);
  char obs[65];
  memcpy(obs, g_arr.f64_sha256, 65);
  obs[0] = obs[0] == '0' ? '1' : '0';
  lrd_rec alt;
  const char *why;
  CHECK(!build_pub(&alt, out, obs, g_cur_commit), "pub");
  CHECK(!verify_bytes(&alt, g_proof, g_plen, &why), "proof accepted with different observation_sha256");
  printf("# different observation_sha256 at verify time: rejected: %s\n", why);
  CHECK(!verify_bytes_diag(&alt, g_proof, g_plen, &why), "diag verifier accepted");
  printf("#   (diagnostic verifier with grinding check skipped also rejects: %s)\n", why);
  return 1;
}
static int t_mismatch_ledger(void) {
  uint64_t out;
  air_execute(g_q, g_n, &out);
  char prev[65];
  memcpy(prev, g_cur_commit, 65);
  prev[63] = prev[63] == 'a' ? 'b' : 'a';
  lrd_rec alt;
  const char *why;
  CHECK(!build_pub(&alt, out, g_arr.f64_sha256, prev), "pub");
  CHECK(!verify_bytes(&alt, g_proof, g_plen, &why), "proof accepted with different ledger commit");
  printf("# different ledger_prev_commit at verify time: rejected: %s\n", why);
  CHECK(!verify_bytes_diag(&alt, g_proof, g_plen, &why), "diag verifier accepted");
  printf("#   (diagnostic verifier with grinding check skipped also rejects: %s)\n", why);
  return 1;
}
static int t_state(void) {
  air_proposal_buf pb;
  lrd_decision_t d;
  lrd_state_t next;
  const char *detail;
  CHECK(!air_make_proposal(&g_cur, &g_pub, g_proof, g_plen, &pb), "proposal");
  lrd_rec pr, pr2;
  air_proposal_buf back;
  CHECK(!air_proposal_to_rec(&pb.prop, &pr) && !air_proposal_from_rec(&pr, &back) &&
        !air_proposal_to_rec(&back.prop, &pr2), "proposal record round trip");
  char c1[65], c2[65];
  rec_commit(&pr, c1); rec_commit(&pr2, c2);
  CHECK(!strcmp(c1, c2) && !strcmp(rec_get(&pr, "kind"), "air_proof"), "proposal record");
  CHECK(air_transition(&g_cur, &back.prop, &g_pub, g_q, g_n, g_proof, g_plen, &d, &next, &detail) == LRD_DECISION_ACCEPT,
        "honest REJECT %s %s", d.reason, detail);
  CHECK(!strcmp(d.reason, "ok") && strlen(d.new_commit) == 64 && next.seq == 1, "accept fields");
  lrd_rec dr;
  air_decision_to_rec(&d, &dr);
  printf("# decision: decision=%s reason=%s new_commit=%s\n", rec_get(&dr, "decision"), rec_get(&dr, "reason"),
         rec_get(&dr, "new_commit"));
  /* replay against the new state: stale */
  lrd_decision_t d2;
  memset(&d2, 0, sizeof d2);
  CHECK(air_transition(&next, &back.prop, &g_pub, g_q, g_n, g_proof, g_plen, &d2, NULL, &detail) == LRD_DECISION_REJECT &&
        !strcmp(d2.reason, "stale_seq") && d2.new_commit[0] == 0, "replay not stale_seq: %s", d2.reason);
  /* wrong previous commit */
  air_proposal_buf bad = back;
  bad.prop.prev_commit[0] = bad.prop.prev_commit[0] == '0' ? '1' : '0';
  air_transition(&g_cur, &bad.prop, &g_pub, g_q, g_n, g_proof, g_plen, &d2, NULL, &detail);
  CHECK(d2.decision == LRD_DECISION_REJECT && !strcmp(d2.reason, "bad_prev"), "bad_prev: %s", d2.reason);
  /* proof bound to another ledger commit, attacker rewrites public record + proposal consistently */
  uint64_t out;
  air_execute(g_q, g_n, &out);
  char other[65];
  memcpy(other, g_cur_commit, 65);
  other[10] = other[10] == 'f' ? 'e' : 'f';
  lrd_rec opub;
  build_pub(&opub, out, g_arr.f64_sha256, other);
  air_proof pf;
  const char *why;
  CHECK(!air_prove(&opub, g_q, g_n, NULL, &pf, &why), "prove other");
  size_t on;
  uint8_t *ob = air_proof_serialize(&pf, &on);
  air_proof_free(&pf);
  air_proposal_buf ap;
  air_make_proposal(&g_cur, &g_pub, ob, on, &ap); /* g_pub names the true ledger commit */
  air_transition(&g_cur, &ap.prop, &g_pub, g_q, g_n, ob, on, &d2, NULL, &detail);
  int r1 = d2.decision == LRD_DECISION_REJECT && !strcmp(d2.reason, "bad_proof");
  printf("# proof made for another ledger commit, relabelled to current: decision=REJECT reason=%s detail=%s\n", d2.reason, detail);
  /* unrelabelled: public record names another commit than the proposal */
  air_make_proposal(&g_cur, &opub, ob, on, &ap);
  air_transition(&g_cur, &ap.prop, &opub, g_q, g_n, ob, on, &d2, NULL, &detail);
  int r2 = d2.decision == LRD_DECISION_REJECT && !strcmp(d2.reason, "bad_public_input");
  /* tampered proof bytes with recomputed payload hash */
  uint8_t *tb = malloc(g_plen);
  memcpy(tb, g_proof, g_plen);
  tb[g_plen / 3] ^= 0x10;
  air_make_proposal(&g_cur, &g_pub, tb, g_plen, &ap);
  air_transition(&g_cur, &ap.prop, &g_pub, g_q, g_n, tb, g_plen, &d2, NULL, &detail);
  int r3 = d2.decision == LRD_DECISION_REJECT && !strcmp(d2.reason, "bad_proof") && d2.new_commit[0] == 0;
  free(ob); free(tb);
  CHECK(r1 && r2 && r3, "rejections r1=%d r2=%d r3=%d", r1, r2, r3);
  return 1;
}
static int t_security_params(void) {
  air_params P = air_policy_params(air_trace_log_for_inputs(g_n));
  unsigned cs = air_conjectured_security_bits(&P);
  printf("# params: trace_length=%u blowup=%u queries=%u grinding_bits=%u conjectured_bits=%u proven_udr_bits=%u proven_ldr_bits=%u\n",
         1u << P.log_trace_len, 1u << P.log_blowup, P.num_queries, P.grinding_bits, cs,
         air_proven_security_udr_bits(&P), air_proven_security_ldr_bits(&P));
  /* cross-check of the C port against winterfell's own unit-test expectations
   * (security.rs tests: unique_decoding_folding_factor_effect -> 116 for these options;
   *  get_100_bits_security -> udr 100, ldr 69) */
  air_params w1 = {8, 3, 123, 16, 3};
  CHECK(air_proven_security_udr_bits(&w1) == 116, "udr port mismatch: %u", air_proven_security_udr_bits(&w1));
  air_params w2 = {20, 2, 119, 20, 7};
  CHECK(air_proven_security_udr_bits(&w2) == 100, "udr port mismatch 2: %u", air_proven_security_udr_bits(&w2));
  CHECK(air_proven_security_ldr_bits(&w2) == 69, "ldr port mismatch: %u", air_proven_security_ldr_bits(&w2));
  return 1;
}

int main(int argc, char **argv) {
  report("sha256_fips180_4_vectors", t_sha256());
  report("field_goldilocks_arith", t_field_arith());
  report("field_roots_of_unity", t_field_roots());
  report("field_fp2_extension", t_fp2());
  report("ntt_roundtrip_and_naive", t_ntt());
  report("interpolation_and_lde", t_lde());
  report("merkle_sha256", t_merkle());
  report("lrd_rec_v1_serialization", t_rec());
  if (argc != 2 || setup(argv[1])) {
    printf("FAIL stark_setup cannot load SYNTHETIC fixture\n");
    return 1;
  }
  report("fixed_point_encoding", t_fixed_point());
  report("security_estimate_port", t_security_params());
  int h = t_honest();
  report("honest_proof_verifies", h);
  if (!h) return 1;
  report("proof_deterministic", t_deterministic());
  report("proof_serialization_roundtrip", t_roundtrip());
  report("tampered_proof_bytes_rejected", t_tamper_bytes());
  report("corrupted_trace_cell_rejected", t_corrupt());
  report("fabricated_output_rejected", t_fabricated_output());
  report("mismatched_observation_sha256_rejected", t_mismatch_obs());
  report("mismatched_ledger_commit_rejected", t_mismatch_ledger());
  report("lrd_state_air_proof_transition", t_state());
  free(g_proof); free(g_q); arr_free(&g_arr);
  return g_fail;
}
