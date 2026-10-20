/* SPDX-License-Identifier: AGPL-3.0-only
 * Also licensed under the SnapKitty Opaque License; see LICENSE and
 * SNAPKITTY_OPAQUE_LICENSE.md at the repository root.
 * Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 *
 * Self-test for abi/lrd_num_abi.{h,c}. Usage: test_lrd_num_abi TMPDIR
 * Prints PASS/FAIL lines (tests/<module>/run.sh convention); exit 1 on any FAIL.
 * The arrays written here are SYNTHETIC test vectors (file names contain SYNTHETIC).
 */
#include "lrd_num_abi.h"

#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int nfail;
static char dir[2048];

static void result(const char *name, int ok, const char *why) {
  if (ok) printf("PASS %s\n", name);
  else { printf("FAIL %s %s\n", name, why); nfail++; }
}

static void put(const char *rel, const char *bytes, size_t n) {
  char p[4096];
  FILE *f;
  snprintf(p, sizeof p, "%s/%s", dir, rel);
  f = fopen(p, "wb");
  if (!f) { perror(p); exit(2); }
  fwrite(bytes, 1, n, f);
  fclose(f);
}

static void expect_err(const char *name, const char *rel, const char *unit, int code, const char *needle) {
  char p[4096], err[512], why[1024];
  lrd_arr_t a;
  int rc;
  snprintf(p, sizeof p, "%s/%s", dir, rel);
  rc = lrd_arr_read(p, unit, &a, err, sizeof err);
  snprintf(why, sizeof why, "rc=%d want=%d err='%s' want-substring='%s'", rc, code, rc ? err : "", needle);
  result(name, rc == code && strstr(err, needle) != NULL && a.data == NULL, why);
  lrd_arr_free(&a);
}

int main(int argc, char **argv) {
  char p[4096], err[512], why[1024];
  double v[8];
  uint64_t nanbits = 0x7ff8000000000123ull;
  lrd_arr_t a;
  int rc, i, ok;
  if (argc != 2) { fprintf(stderr, "usage: %s TMPDIR\n", argv[0]); return 2; }
  snprintf(dir, sizeof dir, "%s", argv[1]);

  result("abi_version", lrd_num_abi_version() == LRD_NUM_ABI_VERSION && LRD_NUM_ABI_VERSION == 1, "version mismatch");

  /* round trip, bit exact, including signed zero, subnormal, inf and a NaN payload */
  v[0] = 1.0; v[1] = -0.0; v[2] = 4.9406564584124654e-324; v[3] = 1.7976931348623157e308;
  v[4] = INFINITY; v[5] = -INFINITY; memcpy(&v[6], &nanbits, 8); v[7] = 0.1;
  snprintf(p, sizeof p, "%s/SYNTHETIC_abi_rt", dir);
  rc = lrd_arr_write(p, "SYNTHETIC_abi_rt", "um", v, 8, "note=SYNTHETIC abi round-trip vector\n", err, sizeof err);
  ok = rc == 0;
  if (ok) rc = lrd_arr_read(p, "um", &a, err, sizeof err), ok = rc == 0;
  if (ok) {
    ok = a.length == 8 && !strcmp(a.name, "SYNTHETIC_abi_rt") && !strcmp(a.unit, "um") &&
         !strcmp(a.extra, "note=SYNTHETIC abi round-trip vector\n");
    for (i = 0; ok && i < 8; i++) ok = memcmp(&a.data[i], &v[i], 8) == 0;
    lrd_arr_free(&a);
  }
  snprintf(why, sizeof why, "rc=%d err=%s", rc, rc ? err : "content differs");
  result("abi_roundtrip_bitexact", ok, why);

  /* explicit little-endian layout: 1.0 = 00 00 00 00 00 00 f0 3f */
  {
    FILE *f;
    unsigned char b[8];
    snprintf(p, sizeof p, "%s/SYNTHETIC_abi_rt.f64", dir);
    f = fopen(p, "rb");
    ok = f && fread(b, 1, 8, f) == 8;
    if (f) fclose(f);
    ok = ok && b[0] == 0 && b[5] == 0 && b[6] == 0xf0 && b[7] == 0x3f;
    result("abi_little_endian_layout", ok, "first 8 bytes are not 00..f03f");
  }

  /* zero length */
  snprintf(p, sizeof p, "%s/SYNTHETIC_abi_empty", dir);
  rc = lrd_arr_write(p, "SYNTHETIC_abi_empty", "1", NULL, 0, NULL, err, sizeof err);
  if (!rc) rc = lrd_arr_read(p, NULL, &a, err, sizeof err);
  result("abi_zero_length", rc == 0 && a.length == 0 && a.data == NULL, err);
  lrd_arr_free(&a);

  /* bad headers */
  {
    static const char d16[16] = {0};
    put("SYNTHETIC_badfmt.f64", d16, 16);
    put("SYNTHETIC_badfmt.hdr", "format=LRD-ARR-v2\nname=x\nlength=2\nunit=um\n", 41);
    expect_err("abi_bad_header_format", "SYNTHETIC_badfmt", NULL, LRD_ARR_E_FORMAT, "format is 'LRD-ARR-v2'");
    put("SYNTHETIC_nounit.f64", d16, 16);
    put("SYNTHETIC_nounit.hdr", "format=LRD-ARR-v1\nname=x\nlength=2\n", 34);
    expect_err("abi_bad_header_missing_unit", "SYNTHETIC_nounit", NULL, LRD_ARR_E_HEADER, "missing required key 'unit'");
    put("SYNTHETIC_dup.f64", d16, 16);
    put("SYNTHETIC_dup.hdr", "format=LRD-ARR-v1\nname=x\nlength=2\nlength=2\nunit=um\n", 51);
    expect_err("abi_bad_header_duplicate_key", "SYNTHETIC_dup", NULL, LRD_ARR_E_HEADER, "duplicate key 'length'");
    put("SYNTHETIC_lz.f64", d16, 16);
    put("SYNTHETIC_lz.hdr", "format=LRD-ARR-v1\nname=x\nlength=02\nunit=um\n", 43);
    expect_err("abi_bad_header_leading_zero", "SYNTHETIC_lz", NULL, LRD_ARR_E_HEADER, "bad length '02'");
    put("SYNTHETIC_noeq.f64", d16, 16);
    put("SYNTHETIC_noeq.hdr", "format=LRD-ARR-v1\nname=x\nlength=2\nunit=um\ngarbage\n", 50);
    expect_err("abi_bad_header_no_equals", "SYNTHETIC_noeq", NULL, LRD_ARR_E_HEADER, "line without '='");
    /* length mismatch: header says 3, file has 2 values */
    put("SYNTHETIC_len.f64", d16, 16);
    put("SYNTHETIC_len.hdr", "format=LRD-ARR-v1\nname=x\nlength=3\nunit=um\n", 42);
    expect_err("abi_length_mismatch", "SYNTHETIC_len", NULL, LRD_ARR_E_LENGTH, "length mismatch: header length=3 needs 24 bytes, file has 16");
    /* trailing partial value */
    put("SYNTHETIC_part.f64", d16, 12);
    put("SYNTHETIC_part.hdr", "format=LRD-ARR-v1\nname=x\nlength=2\nunit=um\n", 42);
    expect_err("abi_length_partial_value", "SYNTHETIC_part", NULL, LRD_ARR_E_LENGTH, "file has 12");
    /* unit mismatch */
    expect_err("abi_unit_mismatch", "SYNTHETIC_abi_rt", "Angstrom", LRD_ARR_E_UNIT, "unit is 'um', expected 'Angstrom'");
    expect_err("abi_missing_file", "SYNTHETIC_does_not_exist", NULL, LRD_ARR_E_IO, "cannot open");
  }
  return nfail ? 1 : 0;
}
