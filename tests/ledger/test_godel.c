/* Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 * Dual-licensed: AGPL-3.0-or-later plus SnapKitty Opaque License.
 * SPDX-License-Identifier: AGPL-3.0-or-later AND LicenseRef-SnapKitty-Opaque
 *
 * TASK 004 tests: LRD-REC-v1 canonical records and the Goedel prime ledger.
 * Prints one line per test: "PASS <name>" or "FAIL <name> <why>". Exit 1 iff any FAIL.
 */
#include "lrd_rec.h"
#include "lrd_godel.h"

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
  lrd_godel_init(g);
  for (size_t i = 0; i < n; i++) lrd_godel_append(g, it[i].b, it[i].n, c);
}

static void t_append_decode(void) {
  const char *why = NULL;
  lrd_godel_cfg_t c = lrd_godel_default_cfg(LRD_GODEL_BYTES);
  const lrd_bytes_t *it = items6();
  lrd_godel_t g; lrd_godel_init(&g);
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
  lrd_godel_t g; lrd_godel_init(&g);
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

int main(void) {
  t_primes();
  t_bij_shortlex();
  t_bij_long();
  t_rec();
  t_append_decode();
  t_history_prefix_sequence();
  t_malformed();
  t_records();
  t_record_exponent_roundtrip();
  return fails ? 1 : 0;
}
