/* Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 * Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
 * SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
 *
 * TASK 004 tests for the POSITIONAL Goedel ledger mode (blocker (a)).
 * usage: test_godel_pos [SOURCE_KV]
 *   SOURCE_KV: a key=value manifest (read only). It is converted to an LRD-REC-v1 record. If it
 *   is absent or cannot be represented, a clearly labelled SYNTHETIC ~1 KB record is used.
 *   Records 2 and 3 of test (b) are always SYNTHETIC (about 250 bytes, labelled in every field),
 *   to keep the suite fast; record 1 is the real manifest when given.
 * Output: "PASS <name>" / "FAIL <name> <why>" lines and "INFO ..." measurement lines.
 */
#define _POSIX_C_SOURCE 200809L
#include "lrd_rec.h"
#include "lrd_godel.h"

#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

static int fails;
static void report(const char *name, const char *why) {
  if (!why) printf("PASS %s\n", name);
  else { printf("FAIL %s %s\n", name, why); fails++; }
}
#define CHECK(c, msg) do { if (!(c)) { why = (msg); goto done; } } while (0)

static double now_ms(void) {
  struct timespec ts; clock_gettime(CLOCK_MONOTONIC, &ts);
  return ts.tv_sec * 1e3 + ts.tv_nsec / 1e6;
}

static unsigned char *slurp(const char *path, size_t *n) {
  FILE *f = fopen(path, "rb");
  if (!f) return NULL;
  size_t cap = 4096, len = 0; unsigned char *b = malloc(cap);
  while (b) {
    size_t r = fread(b + len, 1, cap - len, f); len += r;
    if (r == 0) break;
    if (len == cap) { unsigned char *t = realloc(b, cap * 2); if (!t) { free(b); b = NULL; } else { b = t; cap *= 2; } }
  }
  fclose(f);
  if (b) *n = len;
  return b;
}

/* key=value lines -> canonical LRD-REC-v1 serialization. NULL if not representable. */
static unsigned char *kv_to_rec(const char *path, size_t *outlen, const char **why) {
  size_t n; unsigned char *b = slurp(path, &n);
  if (!b) { *why = "file_not_readable"; return NULL; }
  lrd_rec_t r; lrd_rec_init(&r);
  size_t i = 0; int bad = 0;
  while (i < n && !bad) {
    unsigned char *nl = memchr(b + i, '\n', n - i);
    size_t ll = nl ? (size_t)(nl - (b + i)) : n - i;
    if (ll) {
      unsigned char *eq = memchr(b + i, '=', ll);
      if (!eq || lrd_rec_setn(&r, (char *)b + i, (size_t)(eq - (b + i)), (char *)eq + 1, ll - (size_t)(eq - (b + i)) - 1))
        bad = 1;
    }
    i += ll + 1;
  }
  free(b);
  unsigned char *s = NULL;
  if (bad || r.n == 0) *why = "line_not_representable_as_LRD-REC-v1";
  else if (lrd_rec_serialize(&r, &s, outlen)) { *why = "oom"; s = NULL; }
  lrd_rec_free(&r);
  return s;
}

/* SYNTHETIC record of about `target` bytes; every field says SYNTHETIC. */
static unsigned char *synthetic(const char *tag, size_t target, size_t *outlen) {
  lrd_rec_t r; lrd_rec_init(&r);
  lrd_rec_set(&r, "SYNTHETIC", "SYNTHETIC test record, not observational data");
  lrd_rec_set(&r, "synthetic.tag", tag);
  char k[32], v[80];
  for (int i = 0; ; i++) {
    unsigned char *s; size_t sl;
    lrd_rec_serialize(&r, &s, &sl); free(s);
    if (sl >= target) break;
    snprintf(k, sizeof k, "synthetic.field%03d", i);
    snprintf(v, sizeof v, "SYNTHETIC value %d of a deterministic filler sequence for %s", i * 7919 % 1000, tag);
    lrd_rec_set(&r, k, v);
  }
  unsigned char *s; lrd_rec_serialize(&r, &s, outlen);
  lrd_rec_free(&r);
  return s;
}

static void sha_hex(const unsigned char *b, size_t n, char out[65]) { lrd_sha256_hex(b, n, out); }

/* Independent reference: build the stream by hand and multiply prime powers one at a time. */
static void reference_L(mpz_t L, const lrd_bytes_t *recs, size_t nrec) {
  size_t cap = 64, n = 0; unsigned char *s = malloc(cap);
  #define PUSH(c) do { if (n == cap) { cap *= 2; s = realloc(s, cap); } s[n++] = (unsigned char)(c); } while (0)
  for (size_t r = 0; r < nrec; r++) {
    size_t bl = recs[r].n - 11;
    PUSH(bl >> 24); PUSH(bl >> 16); PUSH(bl >> 8); PUSH(bl);
    for (size_t j = 0; j < bl; j++) PUSH(recs[r].b[11 + j]);
  }
  mpz_t t; mpz_init(t); mpz_set_ui(L, 1);
  for (size_t k = 0; k < n; k++) { mpz_ui_pow_ui(t, (unsigned long)lrd_prime(k + 1), (unsigned long)s[k] + 1); mpz_mul(L, L, t); }
  mpz_clear(t); free(s);
}

static lrd_bytes_t R[3];        /* records for (a)/(b) */
static const char *R_src[3];

/* ---------------------------------------------------------------- (a) real-size record */
static void t_real_record(void) {
  const char *why = NULL;
  lrd_godel_cfg_t c = lrd_godel_default_cfg(LRD_GODEL_POSITIONAL);
  lrd_godel_t g; lrd_godel_init(&g, LRD_GODEL_POSITIONAL);
  lrd_bytes_t *d = NULL; size_t dn = 0;
  mpz_t ref; mpz_init(ref);
  unsigned char *ex = NULL; size_t exl;
  lrd_godel_t g2; int g2_init = 0;
  double t0 = now_ms();
  lrd_godel_err_t rc = lrd_godel_append(&g, R[0].b, R[0].n, &c);
  double t1 = now_ms();
  CHECK(rc == LRD_GODEL_OK, lrd_godel_strerror(rc));
  CHECK(R[0].n >= 1000, "test record shorter than ~1 KB");
  CHECK(g.n == 1 && lrd_godel_seq(&g) == 1, "first append must give seq 1");
  CHECK(mpz_sizeinbase(g.L, 2) <= c.max_bits, "bits(L) exceeds max_bits");
  double t2 = now_ms();
  rc = lrd_godel_decode(g.L, &c, &d, &dn);
  double t3 = now_ms();
  CHECK(rc == LRD_GODEL_OK, lrd_godel_strerror(rc));
  CHECK(dn == 1 && d[0].n == R[0].n && memcmp(d[0].b, R[0].b, R[0].n) == 0, "decoded record not byte-exact");
  reference_L(ref, R, 1);
  CHECK(mpz_cmp(ref, g.L) == 0, "L differs from independent sequential reference product");
  {
    unsigned char *sf = NULL, *sn = NULL; size_t nf = 0, nn = 0;
    double u0 = now_ms();
    lrd_godel_err_t r1 = lrd_godel_pos_to_stream(g.L, &c, &sf, &nf);
    double u1 = now_ms();
    lrd_godel_err_t r2 = lrd_godel_pos_to_stream_naive(g.L, &c, &sn, &nn);
    double u2 = now_ms();
    int same = r1 == LRD_GODEL_OK && r2 == LRD_GODEL_OK && nf == nn && memcmp(sf, sn, nf) == 0;
    free(sf); free(sn);
    printf("INFO godel_pos_a fast_vs_reference_decoder stream_ms=%.3f reference_per_prime_ms=%.3f identical=%s\n", u1 - u0, u2 - u1, same ? "yes" : "no");
    CHECK(same, "fast decoder differs from per-prime reference decoder");
  }
  CHECK(g.stream_len == 4 + R[0].n - 11, "stream length");
  CHECK(lrd_godel_export(&g, &ex, &exl) == 0, "export");
  rc = lrd_godel_import(&g2, ex, exl, &c); g2_init = rc == LRD_GODEL_OK;
  CHECK(rc == LRD_GODEL_OK && mpz_cmp(g2.L, g.L) == 0 && g2.n == 1 && g2.mode == LRD_GODEL_POSITIONAL &&
        g2.stream_len == g.stream_len, "export/import round trip");
  printf("INFO godel_pos_a record=%s record_bytes=%zu stream_bytes=%zu largest_prime=%llu log2_L_bits=%zu max_bits=%zu append_ms=%.3f decode_ms=%.3f\n",
         R_src[0], R[0].n, g.stream_len, (unsigned long long)lrd_prime(g.stream_len),
         mpz_sizeinbase(g.L, 2), c.max_bits, t1 - t0, t3 - t2);
done:
  if (g2_init) lrd_godel_clear(&g2);
  free(ex); lrd_bytes_free(d, dn); mpz_clear(ref); lrd_godel_clear(&g);
  report("godel_pos_realsize_record_append_decode_byte_exact", why);
}

/* ---------------------------------------------------------------- (b) three records */
static void t_three(void) {
  const char *why = NULL;
  lrd_godel_cfg_t c = lrd_godel_default_cfg(LRD_GODEL_POSITIONAL);
  lrd_godel_t g; lrd_godel_init(&g, LRD_GODEL_POSITIONAL);
  mpz_t L0, L1, L2, L3, ref; mpz_init_set(L0, g.L); mpz_init(L1); mpz_init(L2); mpz_init(L3); mpz_init(ref);
  lrd_godel_t ga; lrd_godel_init(&ga, LRD_GODEL_POSITIONAL);
  unsigned char *alt = NULL;
  double ta = 0;
  for (int i = 0; i < 3; i++) {
    double t0 = now_ms();
    lrd_godel_err_t rc = lrd_godel_append(&g, R[i].b, R[i].n, &c);
    ta += now_ms() - t0;
    CHECK(rc == LRD_GODEL_OK, lrd_godel_strerror(rc));
    CHECK(g.n == (size_t)i + 1, "seq must increase by exactly 1 per append");
    mpz_set(i == 0 ? L1 : i == 1 ? L2 : L3, g.L);
  }
  reference_L(ref, R, 3);
  CHECK(mpz_cmp(ref, L3) == 0, "L3 differs from independent reference");
  CHECK(mpz_divisible_p(L2, L1) && mpz_divisible_p(L3, L2) && mpz_divisible_p(L1, L0), "multiplicative append: L_k must divide L_{k+1}");
  double t0 = now_ms();
  lrd_godel_err_t rc = lrd_godel_verify_sequence(L3, &c, R, 3);
  double tv = now_ms() - t0;
  CHECK(rc == LRD_GODEL_OK, "valid sequence rejected");
  CHECK(lrd_godel_verify_sequence(L3, &c, R, 2) == LRD_GODEL_E_MISMATCH, "short sequence accepted");
  CHECK(lrd_godel_verify_sequence(L2, &c, R, 3) == LRD_GODEL_E_MISMATCH, "long sequence accepted");
  { lrd_bytes_t sw[3] = { R[1], R[0], R[2] };
    CHECK(lrd_godel_verify_sequence(L3, &c, sw, 3) == LRD_GODEL_E_MISMATCH, "reordered sequence accepted"); }
  for (size_t k = 0; k <= 3; k += 1) CHECK(lrd_godel_verify_prefix(L3, &c, R, k) == LRD_GODEL_OK, "valid prefix rejected");
  CHECK(lrd_godel_verify_prefix(L1, &c, R, 2) == LRD_GODEL_E_MISMATCH, "too-long prefix accepted");
  CHECK(lrd_godel_verify_prefix_code(L0, L3, &c) == LRD_GODEL_OK, "genesis (L=1) not a prefix");
  CHECK(lrd_godel_verify_prefix_code(L1, L3, &c) == LRD_GODEL_OK, "L1 not accepted as prefix of L3");
  CHECK(lrd_godel_verify_prefix_code(L2, L3, &c) == LRD_GODEL_OK, "L2 not accepted as prefix of L3");
  CHECK(lrd_godel_verify_prefix_code(L3, L2, &c) == LRD_GODEL_E_MISMATCH, "L3 accepted as prefix of L2");
  { lrd_bytes_t h; CHECK(lrd_godel_history(L3, &c, 1, &h) == LRD_GODEL_OK, "history");
    int ok = h.n == R[1].n && memcmp(h.b, R[1].b, h.n) == 0; free(h.b);
    CHECK(ok, "historical record differs"); }
  /* divisible-but-not-prefix: record 1 with one value byte LOWERED (still canonical): every
   * exponent of L(alt) is <= that of L3, so L(alt) | L3, yet it is not a prefix. */
  alt = malloc(R[0].n); memcpy(alt, R[0].b, R[0].n);
  size_t pos = R[0].n;
  for (size_t j = R[0].n - 2; j > 11; j--) if (alt[j] >= 'b' && alt[j] <= 'z') { pos = j; break; }
  CHECK(pos < R[0].n, "no lowerable byte found");
  alt[pos] = (unsigned char)(alt[pos] - 1);
  CHECK(lrd_godel_append(&ga, alt, R[0].n, &c) == LRD_GODEL_OK, "alt append");
  CHECK(mpz_divisible_p(L3, ga.L), "precondition: L(alt) | L3");
  CHECK(lrd_godel_verify_prefix_code(ga.L, L3, &c) == LRD_GODEL_E_MISMATCH, "divisible non-prefix accepted");
  printf("INFO godel_pos_b records=%s|%s|%s record_bytes=%zu,%zu,%zu stream_bytes=%zu largest_prime=%llu log2_L_bits=%zu (L1=%zu L2=%zu) append_total_ms=%.3f verify_sequence_ms=%.3f\n",
         R_src[0], R_src[1], R_src[2], R[0].n, R[1].n, R[2].n, g.stream_len,
         (unsigned long long)lrd_prime(g.stream_len), mpz_sizeinbase(L3, 2), mpz_sizeinbase(L1, 2),
         mpz_sizeinbase(L2, 2), ta, tv);
done:
  free(alt);
  mpz_clear(L0); mpz_clear(L1); mpz_clear(L2); mpz_clear(L3); mpz_clear(ref);
  lrd_godel_clear(&g); lrd_godel_clear(&ga);
  report("godel_pos_three_records_prefix_and_sequence_verification", why);
}

/* ---------------------------------------------------------------- (c) malformed L */
static lrd_godel_t B;           /* base ledger: record R[0] */
static size_t BN;               /* stream length of B */
static unsigned char *BS;       /* stream of B */
static lrd_godel_cfg_t PC;

static void expect(const char *name, const mpz_t L, lrd_godel_err_t want) {
  lrd_bytes_t *d = NULL; size_t dn = 0;
  lrd_godel_err_t got = lrd_godel_decode(L, &PC, &d, &dn);
  lrd_bytes_free(d, dn);
  /* the malformed L must also fail sequence verification against the honest record */
  lrd_godel_err_t sv = lrd_godel_verify_sequence(L, &PC, R, 1);
  static char buf[160];
  if (got == want && sv != LRD_GODEL_OK) report(name, NULL);
  else { snprintf(buf, sizeof buf, "decode=%s(want %s) verify_sequence=%s", lrd_godel_strerror(got),
                  lrd_godel_strerror(want), lrd_godel_strerror(sv)); report(name, buf); }
}

static void stream_L(mpz_t L, const unsigned char *s, size_t n) {
  lrd_godel_err_t rc = lrd_godel_pos_from_stream(L, s, n, 1, &PC);
  if (rc) { fprintf(stderr, "stream_L: %s\n", lrd_godel_strerror(rc)); mpz_set_ui(L, 0); }
}

static void t_malformed(void) {
  mpz_t L, t; mpz_init(L); mpz_init(t);
  size_t mid = 4 + (BN - 4) / 2;                 /* a byte in the middle of the record body */
  unsigned long pm = (unsigned long)lrd_prime(mid + 1), em = (unsigned long)BS[mid] + 1;
  /* gap: skip p_{N+1}, include p_{N+2} */
  mpz_mul_ui(L, B.L, (unsigned long)lrd_prime(BN + 2));
  expect("godel_pos_reject_gap", L, LRD_GODEL_E_GAP);
  /* extra factor: a prime outside the table */
  mpz_mul_ui(L, B.L, 1000003UL);
  expect("godel_pos_reject_extra_factor", L, LRD_GODEL_E_EXTRA);
  /* exponent 0 inside the stream: remove p_mid entirely */
  mpz_ui_pow_ui(t, pm, em); mpz_divexact(L, B.L, t);
  expect("godel_pos_reject_zero_exponent_in_stream", L, LRD_GODEL_E_ZEROEXP);
  /* exponent 257 at p_mid */
  mpz_ui_pow_ui(t, pm, 257 - em); mpz_mul(L, B.L, t);
  expect("godel_pos_reject_exponent_257", L, LRD_GODEL_E_EXPRANGE);
  /* truncated framing: (1) drop the last byte, (2) length prefix runs 5 past the end,
   * (3) only 2 bytes of a length prefix, (4) 5 stream bytes of a long frame */
  {
    int ok = 1; lrd_bytes_t *d; size_t dn;
    mpz_ui_pow_ui(t, (unsigned long)lrd_prime(BN), (unsigned long)BS[BN - 1] + 1); mpz_divexact(L, B.L, t);
    ok &= lrd_godel_decode(L, &PC, &d, &dn) == LRD_GODEL_E_FRAMING;
    unsigned char *s2 = malloc(BN); memcpy(s2, BS, BN);
    size_t bl = BN - 4 + 5;
    s2[0] = (unsigned char)(bl >> 24); s2[1] = (unsigned char)(bl >> 16); s2[2] = (unsigned char)(bl >> 8); s2[3] = (unsigned char)bl;
    stream_L(L, s2, BN);
    ok &= lrd_godel_decode(L, &PC, &d, &dn) == LRD_GODEL_E_FRAMING;
    stream_L(L, BS, 2);
    ok &= lrd_godel_decode(L, &PC, &d, &dn) == LRD_GODEL_E_FRAMING;
    stream_L(L, BS, 5);
    ok &= lrd_godel_decode(L, &PC, &d, &dn) == LRD_GODEL_E_FRAMING;
    free(s2);
    report("godel_pos_reject_truncated_framing", ok ? NULL : "truncated framing / overlong length accepted");
  }
  /* non-canonical record inside a well-framed stream: unsorted keys; bad UTF-8; leading zero */
  {
    const char *bodies[3] = { "1:b1:x\n1:a1:y\n", "1:a1:\xff\n", "01:a1:x\n" };
    int ok = 1;
    for (int i = 0; i < 3; i++) {
      size_t bl = strlen(bodies[i]);
      unsigned char s[64];
      s[0] = 0; s[1] = 0; s[2] = 0; s[3] = (unsigned char)bl; memcpy(s + 4, bodies[i], bl);
      stream_L(L, s, 4 + bl);
      lrd_bytes_t *d; size_t dn;
      ok &= lrd_godel_decode(L, &PC, &d, &dn) == LRD_GODEL_E_NONCANON;
    }
    /* append refuses a non-canonical record and leaves L unchanged */
    lrd_godel_t g; lrd_godel_init(&g, LRD_GODEL_POSITIONAL); mpz_set(t, g.L);
    ok &= lrd_godel_append(&g, (const unsigned char *)"LRD-REC-v1\n1:b1:x\n1:a1:y\n", 25, &PC) == LRD_GODEL_E_ARG;
    ok &= mpz_cmp(g.L, t) == 0 && g.n == 0;
    lrd_godel_clear(&g);
    report("godel_pos_reject_noncanonical_record", ok ? NULL : "non-canonical record accepted");
  }
  /* L <= 0 and exponent 0 at the very first prime */
  {
    int ok = 1; lrd_bytes_t *d; size_t dn;
    mpz_set_ui(L, 0); ok &= lrd_godel_decode(L, &PC, &d, &dn) == LRD_GODEL_E_NOTPOS;
    mpz_neg(L, B.L);  ok &= lrd_godel_decode(L, &PC, &d, &dn) == LRD_GODEL_E_NOTPOS;
    mpz_ui_pow_ui(t, 2, (unsigned long)BS[0] + 1); mpz_divexact(L, B.L, t);
    ok &= lrd_godel_decode(L, &PC, &d, &dn) == LRD_GODEL_E_GAP;   /* p_1 absent at a record boundary: gap */
    mpz_ui_pow_ui(L, 2, 5000);
    ok &= lrd_godel_decode(L, &PC, &d, &dn) == LRD_GODEL_E_EXPRANGE;
    report("godel_pos_reject_nonpositive_and_first_prime_cases", ok ? NULL : "non-positive L or first-prime case accepted");
  }
  mpz_clear(L); mpz_clear(t);
}

/* ---------------------------------------------------------------- mode explicit / not confusable */
static void t_mode_confusion(void) {
  const char *why = NULL;
  lrd_godel_cfg_t pc = lrd_godel_default_cfg(LRD_GODEL_POSITIONAL), rc2 = lrd_godel_default_cfg(LRD_GODEL_BIJ256_RECORDS);
  lrd_godel_t g; lrd_godel_init(&g, LRD_GODEL_POSITIONAL);
  lrd_godel_t g2; int g2_init = 0;
  unsigned char *ex = NULL; size_t exl;
  lrd_bytes_t *d = NULL; size_t dn = 0;
  mpz_t L, keep; mpz_init(L); mpz_init(keep);
  CHECK(lrd_godel_append(&g, R[1].b, R[1].n, &rc2) == LRD_GODEL_E_MODE, "append with a mismatched cfg mode accepted");
  CHECK(g.n == 0 && mpz_cmp_ui(g.L, 1) == 0, "refused append changed ledger");
  CHECK(lrd_godel_append(&g, R[1].b, R[1].n, &pc) == LRD_GODEL_OK, "positional append");
  CHECK(lrd_godel_export(&g, &ex, &exl) == 0, "export");
  CHECK(strstr((const char *)ex, "mode") && strstr((const char *)ex, "positional"), "export does not record the mode");
  CHECK(lrd_godel_import(&g2, ex, exl, &rc2) == LRD_GODEL_E_MODE, "import under another mode accepted");
  CHECK(lrd_godel_import(&g2, ex, exl, &pc) == LRD_GODEL_OK, "import under the recorded mode failed");
  g2_init = 1;
  CHECK(mpz_cmp(g2.L, g.L) == 0 && g2.n == 1 && g2.stream_len == g.stream_len, "import changed the ledger");
  /* the integer carries no tag: 210 = 2*3*5*7 decodes in BOTH modes, with different meaning */
  mpz_set_ui(L, 210);
  CHECK(lrd_godel_decode(L, &pc, &d, &dn) == LRD_GODEL_OK && dn == 1 && d[0].n == 11, "210 as positional: one empty record");
  lrd_bytes_free(d, dn); d = NULL;
  CHECK(lrd_godel_decode(L, &rc2, &d, &dn) == LRD_GODEL_OK && dn == 4, "210 as bij256-records: four empty records");
  printf("INFO godel_pos_mode L=210 decodes_in_both_modes=yes positional_items=1 bij256_records_items=4 (mode must come from the API/export, not from L)\n");
done:
  lrd_bytes_free(d, dn); free(ex); mpz_clear(L); mpz_clear(keep);
  if (g2_init) lrd_godel_clear(&g2);
  lrd_godel_clear(&g);
  report("godel_pos_mode_explicit_and_recorded", why);
}

/* ---------------------------------------------------------------- too_big */
static void t_too_big(void) {
  const char *why = NULL;
  lrd_godel_cfg_t c = lrd_godel_default_cfg(LRD_GODEL_POSITIONAL);
  lrd_godel_t g; lrd_godel_init(&g, LRD_GODEL_POSITIONAL);
  mpz_t keep; mpz_init(keep);
  lrd_bytes_t *d = NULL; size_t dn = 0;
  c.max_bits = 5000;                       /* far below the ~1.1M bits this record needs */
  CHECK(lrd_godel_append(&g, R[0].b, R[0].n, &c) == LRD_GODEL_E_TOOBIG, "over-cap append not refused");
  CHECK(g.n == 0 && mpz_cmp_ui(g.L, 1) == 0 && g.stream_len == 0, "refused append changed ledger");
  c = lrd_godel_default_cfg(LRD_GODEL_POSITIONAL);
  CHECK(lrd_godel_append(&g, R[0].b, R[0].n, &c) == LRD_GODEL_OK, "append under default cap");
  c.max_bits = 5000;
  CHECK(lrd_godel_decode(g.L, &c, &d, &dn) == LRD_GODEL_E_TOOBIG, "decode of an over-cap L not refused");
done:
  mpz_clear(keep); lrd_godel_clear(&g);
  report("godel_pos_too_big_refused_ledger_unchanged", why);
}

static void info_capacity(void) {
  /* Upper bound on log2 L for a stream of S bytes: 256 * sum_{k<=S} log2 p_k (all bytes 0xff).
   * Largest S whose bound fits the default cap. Computed, not assumed. */
  double cap = (double)LRD_GODEL_POSITIONAL_DEFAULT_MAX_BITS, sum = 0;
  size_t S = 0;
  for (size_t k = 1; k <= LRD_PRIME_MAX_INDEX; k++) {
    double next = sum + 256.0 * log2((double)lrd_prime(k));
    if (next > cap) break;
    sum = next; S = k;
  }
  printf("INFO godel_pos_capacity default_max_bits=%zu worst_case_stream_bytes_fitting=%zu (bound 256*sum log2 p_k; typical text is far smaller per byte)\n",
         (size_t)LRD_GODEL_POSITIONAL_DEFAULT_MAX_BITS, S);
}

int main(int argc, char **argv) {
  setvbuf(stdout, NULL, _IOLBF, 0);
  const char *src = argc > 1 ? argv[1] : NULL;
  const char *why = "no_path_given";
  static char srcdesc[3][800];
  if (src) R[0].b = kv_to_rec(src, &R[0].n, &why);
  if (R[0].b) {
    size_t n; unsigned char *raw = slurp(src, &n); char h[65]; sha_hex(raw, n, h); free(raw);
    snprintf(srcdesc[0], sizeof srcdesc[0], "REAL:%s(sha256=%s)", src, h);
  } else {
    R[0].b = synthetic("record-a", 1024, &R[0].n);
    snprintf(srcdesc[0], sizeof srcdesc[0], "SYNTHETIC(reason=%s)", why);
  }
  R[1].b = synthetic("record-b", 250, &R[1].n); snprintf(srcdesc[1], sizeof srcdesc[1], "SYNTHETIC");
  R[2].b = synthetic("record-c", 250, &R[2].n); snprintf(srcdesc[2], sizeof srcdesc[2], "SYNTHETIC");
  for (int i = 0; i < 3; i++) R_src[i] = srcdesc[i];

  PC = lrd_godel_default_cfg(LRD_GODEL_POSITIONAL);
  lrd_godel_init(&B, LRD_GODEL_POSITIONAL);
  if (lrd_godel_append(&B, R[0].b, R[0].n, &PC) != LRD_GODEL_OK ||
      lrd_godel_pos_to_stream(B.L, &PC, &BS, &BN) != LRD_GODEL_OK) {
    printf("FAIL godel_pos_setup base ledger could not be built\n");
    return 1;
  }
  t_real_record();
  t_three();
  t_malformed();
  t_mode_confusion();
  t_too_big();
  info_capacity();
  free(BS); lrd_godel_clear(&B);
  for (int i = 0; i < 3; i++) free(R[i].b);
  return fails ? 1 : 0;
}
