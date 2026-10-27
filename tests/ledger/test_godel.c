/* Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 * Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
 * SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
 *
 * TASK 004 tests: LRD-REC-v1 canonical records and the Goedel prime ledger.
 * Prints one line per test: "PASS <name>" or "FAIL <name> <why>"; INFO lines go to stderr.
 * Exit 1 iff any FAIL. usage: test_godel [TESTS_DIR]  (TESTS_DIR holds primes_first1000.txt)
 */
#define _POSIX_C_SOURCE 200809L
#include "lrd_rec.h"
#include "lrd_godel.h"

#include <openssl/evp.h>
#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int fails;
static void report(const char *name, int ok, const char *why) {
  if (ok) printf("PASS %s\n", name);
  else { printf("FAIL %s %s\n", name, why ? why : "assertion"); fails++; }
}
#define CHECK(c, msg) do { if (!(c)) { why = (msg); goto done; } } while (0)

static lrd_bytes_t B(const char *s, size_t n) { lrd_bytes_t b = { (unsigned char *)s, n }; return b; }

/* ---------------------------------------------------------------- primes */
static void t_primes(void) {
  const char *why = NULL;
  enum { N = 1000, LIM = 10000 };
  char *comp = calloc(LIM, 1);
  size_t k = 0;
  CHECK(comp, "oom");
  for (size_t i = 2; i < LIM; i++) {           /* independent sieve of Eratosthenes */
    if (comp[i]) continue;
    for (size_t j = i * i; j < LIM; j += i) comp[j] = 1;
    if (k < N) { k++; CHECK(lrd_prime(k) == i, "trial-division table != sieve"); }
  }
  CHECK(k == N, "sieve too small");
  CHECK(lrd_prime(1) == 2 && lrd_prime(2) == 3, "p1/p2");
done:
  free(comp);
  report("godel_primes_match_sieve_first_1000", why == NULL, why);
}

/* ---------------------------------------------------------------- bijective base-256 */
static void t_bij_shortlex(void) {
  /* Bijective numeration enumerates strings in shortlex order: "", 00..ff, 0000..ffff.
   * Assert e(s) == rank_shortlex(s) + 1 for every string of length <= 2 and that decode
   * inverts it. This proves the map is a bijection onto {1..65793} on that domain. */
  const char *why = NULL;
  mpz_t e; mpz_init(e);
  unsigned long rank = 0;
  for (size_t len = 0; len <= 2; len++) {
    unsigned long count = len == 0 ? 1 : len == 1 ? 256 : 65536;
    for (unsigned long v = 0; v < count; v++, rank++) {
      unsigned char s[2] = { (unsigned char)(len == 2 ? v >> 8 : v), (unsigned char)v };
      lrd_bij256_encode(e, s, len);
      CHECK(mpz_cmp_ui(e, rank + 1) == 0, "e != shortlex rank + 1");
      unsigned char *d; size_t dk;
      CHECK(lrd_bij256_decode(e, &d, &dk) == 0, "decode failed");
      int ok = dk == len && (len == 0 || memcmp(d, s, len) == 0);
      free(d);
      CHECK(ok, "decode(encode(s)) != s");
    }
  }
  CHECK(rank == 65793, "rank count");
  mpz_set_ui(e, 0);
  { unsigned char *d = NULL; size_t dk; CHECK(lrd_bij256_decode(e, &d, &dk) == -1, "e=0 must not decode"); }
done:
  mpz_clear(e);
  report("godel_bij256_shortlex_bijection_len_le_2", why == NULL, why);
}

static void t_bij_long(void) {
  const char *why = NULL;
  mpz_t e, e2; mpz_init(e); mpz_init(e2);
  unsigned long x = 12345;   /* fixed LCG seed => deterministic test strings */
  unsigned char s[300];
  for (int t = 0; t < 2000; t++) {
    size_t len = 3 + (size_t)(t % 297);
    for (size_t i = 0; i < len; i++) { x = x * 6364136223846793005UL + 1442695040888963407UL; s[i] = (unsigned char)(x >> 56); }
    if (t % 7 == 0) s[0] = 0;   /* leading zero bytes must survive */
    if (t % 11 == 0) { s[0] = 0; s[1] = 0; }
    lrd_bij256_encode(e, s, len);
    unsigned char *d; size_t dk;
    CHECK(lrd_bij256_decode(e, &d, &dk) == 0, "decode failed");
    int ok = dk == len && memcmp(d, s, len) == 0;
    lrd_bij256_encode(e2, d, dk);
    free(d);
    CHECK(ok && mpz_cmp(e, e2) == 0, "round trip");
  }
done:
  mpz_clear(e); mpz_clear(e2);
  report("godel_bij256_roundtrip_len_3_to_299", why == NULL, why);
}

/* ---------------------------------------------------------------- LRD-REC-v1 */
static int parse_str(const char *s, size_t n, const char **why) {
  lrd_rec_t r; lrd_rec_init(&r);
  int rc = lrd_rec_parse((const unsigned char *)s, n, &r, why);
  lrd_rec_free(&r);
  return rc;
}
#define PS(lit, w) parse_str(lit, sizeof(lit) - 1, w)

static void t_rec(void) {
  const char *why = NULL, *w2 = NULL;
  lrd_rec_t r, q; lrd_rec_init(&r); lrd_rec_init(&q);
  unsigned char *ser = NULL; size_t sl;
  CHECK(lrd_rec_set(&r, "seq", "12") == 0, "set");
  CHECK(lrd_rec_set(&r, "kind", "observation") == 0, "set");
  CHECK(lrd_rec_set(&r, "z", "1/3") == 0, "set");
  CHECK(lrd_rec_set(&r, "Kind", "\xc3\xa9") == 0, "set utf8");
  CHECK(lrd_rec_set(&r, "kind", "x") == -1, "duplicate key accepted");
  CHECK(lrd_rec_set(&r, "a", "x\ny") == -1, "newline accepted");
  CHECK(lrd_rec_set(&r, "a", "\xc0\x80") == -1, "overlong utf8 accepted");
  CHECK(lrd_rec_set(&r, "", "x") == -1, "empty key accepted");
  CHECK(lrd_rec_serialize(&r, &ser, &sl) == 0, "serialize");
  {
    const char exp[] = "LRD-REC-v1\n4:Kind2:\xc3\xa9\n4:kind11:observation\n3:seq2:12\n1:z3:1/3\n";
    CHECK(sl == sizeof exp - 1 && memcmp(ser, exp, sl) == 0, "serialization bytes differ from hand-derived expectation");
  }
  CHECK(lrd_rec_parse(ser, sl, &q, &w2) == 0, "canonical parse failed");
  CHECK(q.n == 4 && strcmp(lrd_rec_get(&q, "seq"), "12") == 0, "parsed contents");
  CHECK(PS("LRD-REC-v1\n", NULL) == 0, "empty record must parse");
  CHECK(PS("LRD-REC-v2\n", NULL) == -1, "bad magic accepted");
  CHECK(PS("LRD-REC-v1\n1:b1:x\n1:a1:y\n", NULL) == -1, "unsorted accepted");
  CHECK(PS("LRD-REC-v1\n1:a1:x\n1:a1:y\n", NULL) == -1, "duplicate accepted");
  CHECK(PS("LRD-REC-v1\n01:a1:x\n", NULL) == -1, "leading-zero length accepted");
  CHECK(PS("LRD-REC-v1\n1:a2:x\n", NULL) == -1, "length mismatch accepted");
  CHECK(PS("LRD-REC-v1\n1:a1:x", NULL) == -1, "missing newline accepted");
  CHECK(PS("LRD-REC-v1\n1:a1:x\nJ", NULL) == -1, "trailing garbage accepted");
  CHECK(PS("LRD-REC-v1\n1:a1:\xff\n", NULL) == -1, "invalid utf8 accepted");
  CHECK(PS("LRD-REC-v1\n0:1:x\n", NULL) == -1, "empty key accepted by parser");
  CHECK(PS("LRD-REC-v1\n1:a0:\n", NULL) == 0, "empty value must parse");
done:
  free(ser); lrd_rec_free(&r); lrd_rec_free(&q);
  report("rec_v1_canonical_serialize_and_strict_parse", why == NULL, why);
}

/* ---------------------------------------------------------------- Goedel ledger (bytes) */
static const lrd_bytes_t *items6(void) {
  static lrd_bytes_t it[6];
  it[0] = B("", 0); it[1] = B("a", 1); it[2] = B("\0", 1);
  it[3] = B("\xff\xff", 2); it[4] = B("zz", 2); it[5] = B("\0\0", 2);
  return it;
}

static void build(lrd_godel_t *g, const lrd_bytes_t *it, size_t n, const lrd_godel_cfg_t *c) {
  lrd_godel_init(g, c->mode);
  for (size_t i = 0; i < n; i++) lrd_godel_append(g, it[i].b, it[i].n, c);
}

static void t_append_decode(void) {
  const char *why = NULL;
  lrd_godel_cfg_t c = lrd_godel_default_cfg(LRD_GODEL_BYTES);
  const lrd_bytes_t *it = items6();
  lrd_godel_t g; lrd_godel_init(&g, LRD_GODEL_BYTES);
  mpz_t ref, prev, t, e; mpz_init_set_ui(ref, 1); mpz_init(prev); mpz_init(t); mpz_init(e);
  const unsigned long pr[6] = { 2, 3, 5, 7, 11, 13 };
  lrd_bytes_t *d = NULL; size_t dn = 0;
  for (size_t i = 0; i < 6; i++) {
    mpz_set(prev, g.L);
    CHECK(lrd_godel_append(&g, it[i].b, it[i].n, &c) == LRD_GODEL_OK, "append failed");
    /* independent reference: L = prod pr[i]^(bij256(s_i)+1) computed directly */
    lrd_bij256_encode(e, it[i].b, it[i].n);
    mpz_ui_pow_ui(t, pr[i], mpz_get_ui(e));
    mpz_mul(ref, ref, t);
    CHECK(mpz_cmp(g.L, ref) == 0, "L != independent product");
    mpz_mul(t, prev, t);
    CHECK(mpz_cmp(g.L, t) == 0, "L' != L * p^e (multiplicative append)");
    CHECK(mpz_divisible_p(g.L, prev), "previous L does not divide L'");
  }
  CHECK(g.n == 6, "count");
  CHECK(lrd_godel_decode(g.L, &c, &d, &dn) == LRD_GODEL_OK, "decode failed");
  CHECK(dn == 6, "decoded count");
  for (size_t i = 0; i < 6; i++)
    CHECK(d[i].n == it[i].n && memcmp(d[i].b, it[i].b, it[i].n) == 0, "decoded item differs");
  fprintf(stderr, "INFO godel_append_decode: n=6 bits(L)=%zu\n", mpz_sizeinbase(g.L, 2));
done:
  lrd_bytes_free(d, dn);
  lrd_godel_clear(&g); mpz_clear(ref); mpz_clear(prev); mpz_clear(t); mpz_clear(e);
  report("godel_append_multiplicative_and_full_decode", why == NULL, why);
}

static void t_history_prefix_sequence(void) {
  const char *why = NULL;
  lrd_godel_cfg_t c = lrd_godel_default_cfg(LRD_GODEL_BYTES);
  const lrd_bytes_t *it = items6();
  lrd_godel_t g, g3, gx; build(&g, it, 6, &c); build(&g3, it, 3, &c);
  lrd_bytes_t alt[6]; memcpy(alt, it, sizeof alt); alt[1] = B("b", 1);
  build(&gx, alt, 3, &c);
  for (size_t i = 0; i < 6; i++) {
    lrd_bytes_t h;
    CHECK(lrd_godel_history(g.L, &c, i, &h) == LRD_GODEL_OK, "history read");
    int ok = h.n == it[i].n && memcmp(h.b, it[i].b, h.n) == 0; free(h.b);
    CHECK(ok, "historical item differs");
  }
  { lrd_bytes_t h; CHECK(lrd_godel_history(g.L, &c, 6, &h) == LRD_GODEL_E_ARG, "out-of-range history"); }
  CHECK(lrd_godel_verify_sequence(g.L, &c, it, 6) == LRD_GODEL_OK, "valid sequence rejected");
  CHECK(lrd_godel_verify_sequence(g.L, &c, it, 5) == LRD_GODEL_E_MISMATCH, "short sequence accepted");
  CHECK(lrd_godel_verify_sequence(g3.L, &c, it, 4) == LRD_GODEL_E_MISMATCH, "long sequence accepted");
  CHECK(lrd_godel_verify_sequence(g.L, &c, alt, 6) == LRD_GODEL_E_MISMATCH, "altered sequence accepted");
  {
    lrd_bytes_t sw[6]; memcpy(sw, it, sizeof sw); sw[3] = it[4]; sw[4] = it[3];
    CHECK(lrd_godel_verify_sequence(g.L, &c, sw, 6) == LRD_GODEL_E_MISMATCH, "reordered sequence accepted");
  }
  for (size_t k = 0; k <= 6; k++)
    CHECK(lrd_godel_verify_prefix(g.L, &c, it, k) == LRD_GODEL_OK, "valid prefix rejected");
  CHECK(lrd_godel_verify_prefix(g3.L, &c, it, 4) == LRD_GODEL_E_MISMATCH, "too-long prefix accepted");
  CHECK(lrd_godel_verify_prefix(g.L, &c, alt, 2) == LRD_GODEL_E_MISMATCH, "wrong prefix accepted");
  CHECK(lrd_godel_verify_prefix_code(g3.L, g.L, &c) == LRD_GODEL_OK, "code prefix rejected");
  CHECK(lrd_godel_verify_prefix_code(g.L, g3.L, &c) == LRD_GODEL_E_MISMATCH, "longer code accepted as prefix");
  CHECK(lrd_godel_verify_prefix_code(gx.L, g.L, &c) == LRD_GODEL_E_MISMATCH, "foreign code accepted as prefix");
done:
  lrd_godel_clear(&g); lrd_godel_clear(&g3); lrd_godel_clear(&gx);
  report("godel_history_prefix_and_sequence_verification", why == NULL, why);
}

static void t_malformed(void) {
  const char *why = NULL;
  lrd_godel_cfg_t c = lrd_godel_default_cfg(LRD_GODEL_BYTES);
  const lrd_bytes_t *it = items6();
  lrd_godel_t g; build(&g, it, 4, &c);
  mpz_t L, t; mpz_init(L); mpz_init(t);
  lrd_bytes_t *d = NULL; size_t dn = 0;
  /* gap: 2^5 * 5^7 (p_2 = 3 missing) */
  mpz_ui_pow_ui(L, 2, 5); mpz_ui_pow_ui(t, 5, 7); mpz_mul(L, L, t);
  CHECK(lrd_godel_decode(L, &c, &d, &dn) == LRD_GODEL_E_GAP, "gap 2^5*5^7 not rejected as gap");
  /* gap: p_1 missing entirely */
  mpz_ui_pow_ui(L, 3, 9);
  CHECK(lrd_godel_decode(L, &c, &d, &dn) == LRD_GODEL_E_GAP, "3^9 not rejected as gap");
  /* gap at the end of a valid ledger: skip p_5 = 11, use p_6 = 13 */
  mpz_mul_ui(L, g.L, 13);
  CHECK(lrd_godel_decode(L, &c, &d, &dn) == LRD_GODEL_E_GAP, "L*13 (p5 skipped) not rejected as gap");
  /* extra factor: a prime far outside the lookahead window */
  mpz_mul_ui(L, g.L, 1000003UL);
  CHECK(lrd_godel_decode(L, &c, &d, &dn) == LRD_GODEL_E_EXTRA, "L*1000003 not rejected as extra factor");
  /* extra factor: composite unknown cofactor */
  mpz_set_ui(t, 1000003UL); mpz_mul_ui(t, t, 1000033UL); mpz_mul(L, g.L, t);
  CHECK(lrd_godel_decode(L, &c, &d, &dn) == LRD_GODEL_E_EXTRA, "composite cofactor not rejected");
  /* non-positive codes */
  mpz_set_ui(L, 0);
  CHECK(lrd_godel_decode(L, &c, &d, &dn) == LRD_GODEL_E_NOTPOS, "0 accepted");
  mpz_neg(L, g.L);
  CHECK(lrd_godel_decode(L, &c, &d, &dn) == LRD_GODEL_E_NOTPOS, "negative accepted");
  /* L = 1 is the empty ledger */
  mpz_set_ui(L, 1);
  CHECK(lrd_godel_decode(L, &c, &d, &dn) == LRD_GODEL_OK && dn == 0, "L=1 must be the empty ledger");
  /* multiplying by 2 alters record 1 => decodes, but sequence verification must reject */
  mpz_mul_ui(L, g.L, 2);
  CHECK(lrd_godel_verify_sequence(L, &c, it, 4) == LRD_GODEL_E_MISMATCH, "L*2 verified as original");
done:
  lrd_bytes_free(d, dn);
  mpz_clear(L); mpz_clear(t); lrd_godel_clear(&g);
  report("godel_reject_gaps_extra_factors_nonpositive", why == NULL, why);
}

/* ---------------------------------------------------------------- Goedel ledger (records) */
static void t_records(void) {
  const char *why = NULL;
  lrd_godel_cfg_t c = lrd_godel_default_cfg(LRD_GODEL_RECORDS);
  lrd_godel_t g; lrd_godel_init(&g, LRD_GODEL_RECORDS);
  mpz_t L, e, t; mpz_init(L); mpz_init(e); mpz_init(t);
  lrd_bytes_t *d = NULL; size_t dn = 0;
  const char empty[] = "LRD-REC-v1\n";
  for (int i = 0; i < 3; i++)
    CHECK(lrd_godel_append(&g, (const unsigned char *)empty, sizeof empty - 1, &c) == LRD_GODEL_OK, "append empty record");
  CHECK(mpz_cmp_ui(g.L, 30) == 0, "three empty records must give L = 2*3*5 = 30");
  CHECK(lrd_godel_decode(g.L, &c, &d, &dn) == LRD_GODEL_OK && dn == 3, "decode record ledger");
  for (size_t i = 0; i < dn; i++) CHECK(d[i].n == 11 && memcmp(d[i].b, empty, 11) == 0, "decoded record");
  /* non-canonical exponents: bodies "x", "0:" , "\n\n" are not canonical LRD-REC-v1 bodies */
  {
    const char *bad[3] = { "x", "0:", "\n\n" }; size_t bl[3] = { 1, 2, 2 };
    for (int i = 0; i < 3; i++) {
      lrd_bij256_encode(e, (const unsigned char *)bad[i], bl[i]);
      mpz_ui_pow_ui(t, 7, mpz_get_ui(e));      /* append at p_4 = 7 after the 3 valid records */
      mpz_mul(L, g.L, t);
      CHECK(lrd_godel_decode(L, &c, &d, &dn) == LRD_GODEL_E_NONCANON, "non-canonical exponent accepted");
    }
  }
  /* a non-canonical record passed to append is refused */
  CHECK(lrd_godel_append(&g, (const unsigned char *)"LRD-REC-v1\n01:a1:b\n", 19, &c) == LRD_GODEL_E_ARG, "bad record appended");
  /* practical size limit: the smallest one-field record is refused, L unchanged */
  {
    mpz_set(t, g.L);
    const char one[] = "LRD-REC-v1\n1:a1:b\n";
    lrd_bij256_encode(e, (const unsigned char *)one + 11, sizeof one - 1 - 11);
    lrd_godel_err_t rc = lrd_godel_append(&g, (const unsigned char *)one, sizeof one - 1, &c);
    fprintf(stderr, "INFO godel_records: exponent for body \"1:a1:b\\n\" has %zu bits; cap max_bits=%zu; append -> %s\n",
           mpz_sizeinbase(e, 2), c.max_bits, lrd_godel_strerror(rc));
    CHECK(rc == LRD_GODEL_E_TOOBIG, "oversized record not refused");
    CHECK(mpz_cmp(g.L, t) == 0 && g.n == 3, "refused append changed the ledger");
  }
done:
  lrd_bytes_free(d, dn);
  mpz_clear(L); mpz_clear(e); mpz_clear(t); lrd_godel_clear(&g);
  report("godel_records_mode_noncanonical_and_size_limit", why == NULL, why);
}

static void t_record_exponent_roundtrip(void) {
  /* Full-size LRD-REC-v1 records cannot be put into L (size limit), but the exponent mapping
   * itself is exact for them: record -> body -> e -> body -> strict parse -> same bytes. */
  const char *why = NULL;
  lrd_rec_t r, q; lrd_rec_init(&r); lrd_rec_init(&q);
  unsigned char *ser = NULL, *d = NULL; size_t sl, dk;
  mpz_t e; mpz_init(e);
  lrd_rec_set(&r, "kind", "observation");
  lrd_rec_set(&r, "prev_commit", LRD_GENESIS_COMMIT);
  lrd_rec_set(&r, "seq", "1");
  lrd_rec_set(&r, "payload_sha256", "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855");
  lrd_rec_set(&r, "z_ratio", "-7/3");
  CHECK(lrd_rec_serialize(&r, &ser, &sl) == 0, "serialize");
  lrd_bij256_encode(e, ser + 11, sl - 11);
  CHECK(lrd_bij256_decode(e, &d, &dk) == 0, "decode");
  CHECK(dk == sl - 11 && memcmp(d, ser + 11, dk) == 0, "body round trip");
  {
    unsigned char *full = malloc(dk + 11); memcpy(full, LRD_REC_MAGIC, 11); memcpy(full + 11, d, dk);
    int ok = lrd_rec_parse(full, dk + 11, &q, NULL) == 0; free(full);
    CHECK(ok && q.n == 5, "strict parse of decoded body");
  }
  fprintf(stderr, "INFO godel_record_exponent: %zu-byte body -> exponent of %zu bits (L would need ~2^%zu bits)\n",
         sl - 11, mpz_sizeinbase(e, 2), mpz_sizeinbase(e, 2) - 1);
done:
  free(ser); free(d); mpz_clear(e); lrd_rec_free(&r); lrd_rec_free(&q);
  report("godel_record_exponent_roundtrip_full_record", why == NULL, why);
}
/* ================================================================ blocker (a) tests */

static double now_ms(void) {
  struct timespec ts; clock_gettime(CLOCK_MONOTONIC, &ts);
  return ts.tv_sec * 1e3 + ts.tv_nsec / 1e6;
}

/* independent SHA-256 of "LRD-COMMIT-v1\0" || bytes, straight from libcrypto EVP */
static int independent_commit(const unsigned char *b, size_t n, char out[65]) {
  unsigned char d[32]; unsigned dl = 0;
  EVP_MD_CTX *c = EVP_MD_CTX_new();
  if (!c) return -1;
  int ok = EVP_DigestInit_ex(c, EVP_sha256(), NULL) == 1 &&
           EVP_DigestUpdate(c, "LRD-COMMIT-v1\0", 14) == 1 &&
           EVP_DigestUpdate(c, b, n) == 1 && EVP_DigestFinal_ex(c, d, &dl) == 1 && dl == 32;
  EVP_MD_CTX_free(c);
  if (!ok) return -1;
  for (int i = 0; i < 32; i++) sprintf(out + 2 * i, "%02x", d[i]);
  return 0;
}

static int sha256_file_hex(const char *path, char out[65]) {
  FILE *f = fopen(path, "rb");
  if (!f) return -1;
  EVP_MD_CTX *c = EVP_MD_CTX_new();
  unsigned char buf[4096], d[32]; unsigned dl = 0; size_t r;
  int ok = c && EVP_DigestInit_ex(c, EVP_sha256(), NULL) == 1;
  while (ok && (r = fread(buf, 1, sizeof buf, f)) > 0) ok = EVP_DigestUpdate(c, buf, r) == 1;
  ok = ok && EVP_DigestFinal_ex(c, d, &dl) == 1;
  EVP_MD_CTX_free(c); fclose(f);
  if (!ok) return -1;
  for (int i = 0; i < 32; i++) sprintf(out + 2 * i, "%02x", d[i]);
  return 0;
}

/* sha256 of tests/ledger/primes_first1000.txt, also recorded in ledger/README.md + ledger/SPEC.md */
#define PRIMES_TABLE_SHA256 "22db001956f3a84aa74fcb0bce32118f0ba802dff771f5db94aba7ba5748af0a"

static const char *tests_dir;

static void t_prime_table(void) {
  const char *why = NULL;
  char path[600], h[65], line[512];
  FILE *f = NULL;
  if (!tests_dir) { printf("UNAVAILABLE godel_primes_match_checked_in_table no_tests_dir_argument\n"); return; }
  snprintf(path, sizeof path, "%s/primes_first1000.txt", tests_dir);
  CHECK(sha256_file_hex(path, h) == 0, "table file unreadable");
  CHECK(strcmp(h, PRIMES_TABLE_SHA256) == 0, "table sha256 differs from the recorded value");
  f = fopen(path, "r");
  CHECK(f, "table file unreadable");
  size_t k = 0;
  while (fgets(line, sizeof line, f)) {
    if (line[0] == '#') continue;
    k++;
    CHECK(k <= 1000, "table has more than 1000 entries");
    CHECK(strtoull(line, NULL, 10) == lrd_prime(k), "lrd_prime(k) differs from the checked-in table");
  }
  CHECK(k == 1000, "table does not have exactly 1000 entries");
  CHECK(lrd_prime(1000) == 7919, "p_1000");
  fprintf(stderr, "INFO godel_primes_table sha256=%s entries=%zu p_1=%llu p_1000=%llu\n", h, k,
          (unsigned long long)lrd_prime(1), (unsigned long long)lrd_prime(1000));
done:
  if (f) fclose(f);
  report("godel_primes_match_checked_in_table", why == NULL, why);
}

static void t_prime_cap(void) {
  const char *why = NULL;
  enum { LIM = 1000000 };
  char *comp = calloc(LIM, 1);
  lrd_godel_cfg_t c = lrd_godel_default_cfg(LRD_GODEL_POSITIONAL);
  mpz_t L; mpz_init(L);
  unsigned char one = 0;
  CHECK(comp, "oom");
  size_t k = 0; unsigned long last = 0;
  for (unsigned long i = 2; i < LIM && k < LRD_PRIME_MAX_INDEX; i++) {   /* sieve of Eratosthenes */
    if (comp[i]) continue;
    for (unsigned long j = i * i; j < LIM; j += i) comp[j] = 1;
    k++; last = i;
  }
  CHECK(k == LRD_PRIME_MAX_INDEX, "sieve limit too small");
  CHECK(lrd_prime(LRD_PRIME_MAX_INDEX) == last, "p_MAX differs from sieve");
  CHECK(last == 821641, "p_65536 is not the documented 821641");
  CHECK(lrd_prime(LRD_PRIME_MAX_INDEX + 1) == 0, "index beyond the cap must return 0");
  CHECK(lrd_prime(0) == 0, "index 0 must return 0");
  CHECK(lrd_godel_pos_from_stream(L, &one, 1, LRD_PRIME_MAX_INDEX, &c) == LRD_GODEL_OK, "last supported index refused");
  CHECK(mpz_cmp_ui(L, last) == 0, "L at the last supported index is not p_MAX^1");
  CHECK(lrd_godel_pos_from_stream(L, &one, 1, LRD_PRIME_MAX_INDEX + 1, &c) == LRD_GODEL_E_PRIMECAP, "index MAX+1 not refused with prime_index_above_cap");
  { unsigned char two[2] = { 0, 0 };
    CHECK(lrd_godel_pos_from_stream(L, two, 2, LRD_PRIME_MAX_INDEX, &c) == LRD_GODEL_E_PRIMECAP, "stream running past the cap not refused"); }
  CHECK(lrd_godel_pos_from_stream(L, &one, 1, 0, &c) == LRD_GODEL_E_ARG, "index 0 not refused");
  fprintf(stderr, "INFO godel_prime_cap LRD_PRIME_MAX_INDEX=%u p_MAX=%lu token=lrd_prime()==0 / %s\n",
          LRD_PRIME_MAX_INDEX, last, lrd_godel_strerror(LRD_GODEL_E_PRIMECAP));
done:
  free(comp); mpz_clear(L);
  report("godel_prime_cap_documented_error", why == NULL, why);
}

/* A record whose BODY (serialization without the 11-byte magic) is exactly body_len bytes:
 * one field "k" = 'x' * v, body = "1:k" + "<v>:" + v + "\n". */
static unsigned char *rec_body_len(size_t v, size_t *outlen) {
  char *val = malloc(v + 1); memset(val, 'x', v); val[v] = 0;
  lrd_rec_t r; lrd_rec_init(&r); lrd_rec_set(&r, "k", val); free(val);
  unsigned char *s = NULL; lrd_rec_serialize(&r, &s, outlen); lrd_rec_free(&r);
  return s;
}

static void t_roundtrip_gt2bytes(void) {
  const char *why = NULL;
  lrd_godel_cfg_t c = lrd_godel_default_cfg(LRD_GODEL_POSITIONAL);
  lrd_godel_cfg_t bc = lrd_godel_default_cfg(LRD_GODEL_BIJ256_RECORDS);
  lrd_godel_t g, gb; lrd_godel_init(&g, LRD_GODEL_POSITIONAL); lrd_godel_init(&gb, LRD_GODEL_BIJ256_RECORDS);
  const unsigned char small[] = "LRD-REC-v1\n1:a1:b\n";           /* 7-byte body */
  size_t smalln = sizeof small - 1, bign = 0;
  unsigned char *big = rec_body_len(57, &bign);                   /* 64-byte body, 75 bytes total */
  const unsigned char *rec[2]; size_t recn[2];
  lrd_bytes_t *d = NULL; size_t dn = 0;
  CHECK(big && bign - LRD_REC_MAGIC_LEN == 64, "could not build the 64-byte-body record");
  rec[0] = small; recn[0] = smalln; rec[1] = big; recn[1] = bign;
  CHECK(smalln - LRD_REC_MAGIC_LEN == 7, "small record body is not 7 bytes");
  CHECK(lrd_godel_append(&gb, small, smalln, &bc) == LRD_GODEL_E_TOOBIG, "bij256 must refuse a 7-byte-body record (tiny records only)");
  double ta = 0;
  for (int i = 0; i < 2; i++) {
    double t0 = now_ms();
    lrd_godel_err_t rc = lrd_godel_append(&g, rec[i], recn[i], &c);
    ta += now_ms() - t0;
    CHECK(rc == LRD_GODEL_OK, lrd_godel_strerror(rc));
    CHECK(mpz_sizeinbase(g.L, 2) <= c.max_bits, "bits(L) exceeds max_bits");
    CHECK(g.n == (size_t)i + 1, "seq");
  }
  double t1 = now_ms();
  lrd_godel_err_t rc = lrd_godel_decode(g.L, &c, &d, &dn);
  double td = now_ms() - t1;
  CHECK(rc == LRD_GODEL_OK, lrd_godel_strerror(rc));
  CHECK(dn == 2, "decoded item count");
  for (int i = 0; i < 2; i++) {
    CHECK(d[i].n == recn[i] && memcmp(d[i].b, rec[i], recn[i]) == 0, "decoded record not byte-identical");
    lrd_rec_t r; lrd_rec_init(&r);
    CHECK(lrd_rec_parse(d[i].b, d[i].n, &r, NULL) == 0, "decoded record does not parse");
    unsigned char *re = NULL; size_t rl = 0;
    int ok = lrd_rec_serialize(&r, &re, &rl) == 0 && rl == recn[i] && memcmp(re, rec[i], rl) == 0;
    char hi[65], hc[65];
    ok = ok && lrd_rec_commit_hex(&r, hc) == 0 && independent_commit(rec[i], recn[i], hi) == 0;
    free(re); lrd_rec_free(&r);
    CHECK(ok, "re-serialization differs from the canonical bytes");
    CHECK(strcmp(hc, hi) == 0, "commit differs from the independently computed sha256");
  }
  fprintf(stderr, "INFO godel_record_roundtrip_gt2bytes body_bytes=7,64 log2_L_bits=%zu max_bits=%zu append_total_ms=%.3f decode_ms=%.3f\n",
          mpz_sizeinbase(g.L, 2), c.max_bits, ta, td);
done:
  lrd_bytes_free(d, dn); free(big); lrd_godel_clear(&g); lrd_godel_clear(&gb);
  report("godel_record_roundtrip_gt2bytes", why == NULL, why);
}

static void t_max_len_boundary(void) {
  const char *why = NULL;
  const unsigned char empty[] = "LRD-REC-v1\n";
  lrd_godel_mode_t modes[2] = { LRD_GODEL_POSITIONAL, LRD_GODEL_BIJ256_RECORDS };
  lrd_bytes_t *d = NULL; size_t dn = 0;
  mpz_t keep; mpz_init(keep);
  CHECK(LRD_GODEL_MAX_LEN == 1024u, "documented LRD_GODEL_MAX_LEN is 1024");
  for (int m = 0; m < 2; m++) {
    lrd_godel_cfg_t c = lrd_godel_default_cfg(modes[m]);
    lrd_godel_t g; lrd_godel_init(&g, modes[m]);
    double t0 = now_ms();
    for (size_t i = 0; i < LRD_GODEL_MAX_LEN; i++) {
      lrd_godel_err_t rc = lrd_godel_append(&g, empty, sizeof empty - 1, &c);
      if (rc) { lrd_godel_clear(&g); CHECK(0, "append up to MAX_LEN failed"); }
    }
    double t1 = now_ms();
    if (g.n != LRD_GODEL_MAX_LEN) { lrd_godel_clear(&g); CHECK(0, "MAX_LEN-th append did not succeed"); }
    mpz_set(keep, g.L);
    /* item MAX_LEN+1: refused BEFORE the item is read or anything is allocated: a NULL item with
     * a huge length and an invalid item both give E_LEN, not E_ARG/E_TOOBIG/crash */
    lrd_godel_err_t r1 = lrd_godel_append(&g, empty, sizeof empty - 1, &c);
    lrd_godel_err_t r2 = lrd_godel_append(&g, NULL, (size_t)-1, &c);
    lrd_godel_err_t r3 = lrd_godel_append(&g, (const unsigned char *)"not a record", 12, &c);
    int unchanged = mpz_cmp(keep, g.L) == 0 && g.n == LRD_GODEL_MAX_LEN;
    lrd_godel_err_t rd = lrd_godel_decode(g.L, &c, &d, &dn);
    int dec_ok = rd == LRD_GODEL_OK && dn == LRD_GODEL_MAX_LEN;
    lrd_bytes_free(d, dn); d = NULL; dn = 0;
    fprintf(stderr, "INFO godel_max_len_boundary mode=%s items=%u log2_L_bits=%zu append_%u_items_ms=%.3f\n",
            lrd_godel_mode_name(modes[m]), LRD_GODEL_MAX_LEN, mpz_sizeinbase(g.L, 2), LRD_GODEL_MAX_LEN, t1 - t0);
    lrd_godel_clear(&g);
    CHECK(r1 == LRD_GODEL_E_LEN, "item MAX_LEN+1 not refused with too_many_items");
    CHECK(r2 == LRD_GODEL_E_LEN && r3 == LRD_GODEL_E_LEN, "length check does not come before parsing/allocation");
    CHECK(unchanged, "refused append changed the ledger");
    CHECK(dec_ok, "MAX_LEN-item ledger does not decode");
  }
  /* decode refuses MAX_LEN+1 items: bij256-records with MAX_LEN+1 empty records, built by hand */
  {
    lrd_godel_cfg_t c = lrd_godel_default_cfg(LRD_GODEL_BIJ256_RECORDS);
    mpz_t L; mpz_init_set_ui(L, 1);
    for (size_t i = 1; i <= LRD_GODEL_MAX_LEN + 1; i++) mpz_mul_ui(L, L, (unsigned long)lrd_prime(i));
    lrd_godel_err_t rc = lrd_godel_decode(L, &c, &d, &dn);
    mpz_clear(L);
    CHECK(rc == LRD_GODEL_E_LEN, "decode accepted MAX_LEN+1 items");
  }
done:
  mpz_clear(keep);
  report("godel_max_len_boundary", why == NULL, why);
}

static void t_genesis_seq0(void) {
  const char *why = NULL;
  const unsigned char empty[] = "LRD-REC-v1\n";
  lrd_godel_mode_t modes[3] = { LRD_GODEL_BIJ256_BYTES, LRD_GODEL_BIJ256_RECORDS, LRD_GODEL_POSITIONAL };
  lrd_bytes_t *d = NULL; size_t dn = 0;
  /* the genesis commit of the ABI is 64 zeros (compared with an independently built string) */
  char zeros[65]; memset(zeros, '0', 64); zeros[64] = 0;
  CHECK(strcmp(LRD_GENESIS_COMMIT, zeros) == 0, "LRD_GENESIS_COMMIT is not 64 zeros");
  for (int m = 0; m < 3; m++) {
    lrd_godel_cfg_t c = lrd_godel_default_cfg(modes[m]);
    lrd_godel_t g; lrd_godel_init(&g, modes[m]);
    int ok0 = lrd_godel_seq(&g) == 0 && g.n == 0 && mpz_cmp_ui(g.L, 1) == 0 && g.stream_len == 0;
    lrd_godel_err_t rd = lrd_godel_decode(g.L, &c, &d, &dn);
    int dec0 = rd == LRD_GODEL_OK && dn == 0;
    lrd_bytes_free(d, dn); d = NULL; dn = 0;
    int ver0 = lrd_godel_verify_sequence(g.L, &c, NULL, 0) == LRD_GODEL_OK;
    lrd_godel_err_t ra = lrd_godel_append(&g, modes[m] == LRD_GODEL_BIJ256_BYTES ? (const unsigned char *)"" : empty,
                                          modes[m] == LRD_GODEL_BIJ256_BYTES ? 0 : sizeof empty - 1, &c);
    int ok1 = ra == LRD_GODEL_OK && lrd_godel_seq(&g) == 1 && mpz_cmp_ui(g.L, 1) > 0;
    /* seq k <-> k-th appended item: history(i) is item seq i+1; one append per seq */
    lrd_godel_err_t rd1 = lrd_godel_decode(g.L, &c, &d, &dn);
    int dec1 = rd1 == LRD_GODEL_OK && dn == 1;
    lrd_bytes_free(d, dn); d = NULL; dn = 0;
    lrd_godel_clear(&g);
    CHECK(ok0, "seq 0 is not the empty ledger L = 1");
    CHECK(dec0 && ver0, "the empty ledger (L = 1) does not decode to zero items");
    CHECK(ok1, "first append does not yield seq 1");
    CHECK(dec1, "after one append the ledger does not hold exactly one item");
  }
  { lrd_godel_t g; lrd_godel_init(&g, LRD_GODEL_POSITIONAL);
    lrd_godel_cfg_t c = lrd_godel_default_cfg(LRD_GODEL_POSITIONAL);
    for (size_t i = 1; i <= 5; i++) {
      lrd_godel_append(&g, empty, sizeof empty - 1, &c);
      if (lrd_godel_seq(&g) != i) { lrd_godel_clear(&g); CHECK(0, "seq is not one per append in ingestion order"); }
    }
    lrd_godel_clear(&g); }
done:
  report("godel_genesis_seq0_convention", why == NULL, why);
}

static void t_parse_nonpositive(void) {
  const char *why = NULL;
  lrd_godel_cfg_t c = lrd_godel_default_cfg(LRD_GODEL_BIJ256_BYTES);
  lrd_godel_cfg_t pc = lrd_godel_default_cfg(LRD_GODEL_POSITIONAL);
  mpz_t L, w; mpz_init(L); mpz_init_set_ui(w, 77);
  lrd_bytes_t *d = NULL; size_t dn = 0;
  /* L <= 0 rejected at parse; the output is not modified */
  CHECK(lrd_godel_parse_hex(L, "-1") == LRD_GODEL_E_NOTPOS, "hex '-1' accepted");
  CHECK(lrd_godel_parse_hex(L, "-0") == LRD_GODEL_E_NOTPOS, "hex '-0' accepted");
  CHECK(lrd_godel_parse_hex(L, "+5") == LRD_GODEL_E_NOTPOS, "hex '+5' accepted");
  CHECK(lrd_godel_parse_hex(L, "0") == LRD_GODEL_E_NOTPOS && lrd_godel_parse_hex(L, "000") == LRD_GODEL_E_NOTPOS, "hex zero accepted");
  CHECK(lrd_godel_parse_hex(L, "") == LRD_GODEL_E_ARG && lrd_godel_parse_hex(L, "1/2") == LRD_GODEL_E_ARG &&
        lrd_godel_parse_hex(L, "12.5") == LRD_GODEL_E_ARG && lrd_godel_parse_hex(L, "0x10") == LRD_GODEL_E_ARG, "non-integer text accepted");
  mpz_set(L, w);
  CHECK(lrd_godel_parse_hex(L, "d2") == LRD_GODEL_OK && mpz_cmp_ui(L, 210) == 0, "hex 'd2' != 210");
  /* exponent <= 0 rejected at parse */
  CHECK(lrd_godel_parse_factored(L, "2^-1", &c) == LRD_GODEL_E_NOTPOS, "negative exponent accepted");
  CHECK(lrd_godel_parse_factored(L, "2^1 3^-4 5^1", &c) == LRD_GODEL_E_NOTPOS, "negative exponent among valid ones accepted");
  CHECK(lrd_godel_parse_factored(L, "2^0", &c) == LRD_GODEL_E_NOTPOS, "exponent 0 accepted");
  CHECK(lrd_godel_parse_factored(L, "2^1 3^0 5^1", &c) == LRD_GODEL_E_NOTPOS, "exponent 0 among valid ones accepted");
  CHECK(lrd_godel_parse_factored(L, "4^1", &c) == LRD_GODEL_E_ARG, "composite base accepted");
  CHECK(lrd_godel_parse_factored(L, "-2^1", &c) == LRD_GODEL_E_ARG, "negative base accepted");
  CHECK(lrd_godel_parse_factored(L, "2^100000000", &c) == LRD_GODEL_E_TOOBIG, "over-cap factored input not refused before computing");
  CHECK(lrd_godel_parse_factored(L, "", &c) == LRD_GODEL_E_ARG, "empty factored input accepted");
  mpz_set(L, w);
  CHECK(lrd_godel_parse_factored(L, "2^1 3^2 5^1", &c) == LRD_GODEL_OK && mpz_cmp_ui(L, 90) == 0, "valid factored input mis-parsed");
  /* decode refuses a non-positive mpz L in every mode */
  mpz_set_ui(L, 0);
  CHECK(lrd_godel_decode(L, &c, &d, &dn) == LRD_GODEL_E_NOTPOS && lrd_godel_decode(L, &pc, &d, &dn) == LRD_GODEL_E_NOTPOS, "L = 0 decoded");
  mpz_set_si(L, -210);
  CHECK(lrd_godel_decode(L, &c, &d, &dn) == LRD_GODEL_E_NOTPOS && lrd_godel_decode(L, &pc, &d, &dn) == LRD_GODEL_E_NOTPOS, "L < 0 decoded");
  /* exponent 0 / unknown factor / gap in bij256 and exponent 257 / 0 in positional (parsed from text) */
  CHECK(lrd_godel_parse_factored(L, "2^1 5^1", &c) == LRD_GODEL_OK, "parse 2^1 5^1");
  CHECK(lrd_godel_decode(L, &c, &d, &dn) == LRD_GODEL_E_GAP, "missing p_2 (exponent 0) not a gap");
  CHECK(lrd_godel_parse_factored(L, "2^1 3^1 1000003^1", &c) == LRD_GODEL_OK, "parse unknown factor");
  CHECK(lrd_godel_decode(L, &c, &d, &dn) == LRD_GODEL_E_EXTRA, "unknown factor accepted");
  CHECK(lrd_godel_parse_factored(L, "2^257", &pc) == LRD_GODEL_OK, "parse 2^257");
  CHECK(lrd_godel_decode(L, &pc, &d, &dn) == LRD_GODEL_E_EXPRANGE, "exponent 257 accepted");
  CHECK(lrd_godel_parse_factored(L, "2^1 3^1 5^1 7^1 11^1 13^1", &pc) == LRD_GODEL_OK, "parse");
  CHECK(lrd_godel_decode(L, &pc, &d, &dn) == LRD_GODEL_E_FRAMING, "stream 00 00 00 00 00 00 (trailing partial frame) accepted");
done:
  mpz_clear(L); mpz_clear(w);
  report("godel_parse_rejects_nonpositive_l_and_exponents", why == NULL, why);
}

int main(int argc, char **argv) {
  tests_dir = argc > 1 ? argv[1] : NULL;
  t_primes();
  t_bij_shortlex();
  t_bij_long();
  t_rec();
  t_append_decode();
  t_history_prefix_sequence();
  t_malformed();
  t_records();
  t_record_exponent_roundtrip();
  t_prime_table();
  t_prime_cap();
  t_roundtrip_gt2bytes();
  t_max_len_boundary();
  t_genesis_seq0();
  t_parse_nonpositive();
  return fails ? 1 : 0;
}
