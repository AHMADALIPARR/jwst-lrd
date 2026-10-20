/* Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 * Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
 * SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
 *
 * Tests for LRD-ENV-v1 length-delimited envelope (recovery P0-A).
 */
#include "../../ledger/include/lrd_env.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

static int failures = 0;
#define CHECK(cond, msg) do { if (!(cond)) { fprintf(stderr, "FAIL %s\n", msg); failures++; } } while (0)

static void test_sizes(void) {
  size_t sizes[] = {0, 1, 2, 3, 255, 256, 1024, 65535};
  size_t ns = sizeof sizes / sizeof sizes[0];
  for (size_t i = 0; i < ns; i++) {
    size_t n = sizes[i];
    unsigned char *pay = n ? malloc(n) : NULL;
    if (n) memset(pay, (unsigned char)(i + 1), n);
    lrd_env_t e;
    int rc = lrd_env_build(&e, 0, pay, n);
    CHECK(rc == 0, "build");
    CHECK(e.serialized_len == LRD_ENV_HEADER_LEN + n, "length");
    lrd_env_t p;
    rc = lrd_env_parse(e.serialized, e.serialized_len, &p);
    CHECK(rc == 0, "parse");
    CHECK(p.payload_len == n, "payload len");
    if (n) CHECK(memcmp(p.payload, pay, n) == 0, "payload bytes");
    CHECK(memcmp(p.sha256, e.sha256, 32) == 0, "hash");
    /* truncated */
    if (e.serialized_len > 1) {
      lrd_env_t bad;
      CHECK(lrd_env_parse(e.serialized, e.serialized_len - 1, &bad) != 0, "truncated rejected");
    }
    /* trailing garbage */
    unsigned char *extra = malloc(e.serialized_len + 1);
    memcpy(extra, e.serialized, e.serialized_len);
    extra[e.serialized_len] = 0xFF;
    lrd_env_t bad2;
    CHECK(lrd_env_parse(extra, e.serialized_len + 1, &bad2) != 0, "trailing rejected");
    free(extra);
    lrd_env_free(&e);
    lrd_env_free(&p);
    free(pay);
    printf("PASS env_size_%zu\n", n);
  }
}

static void test_oversized(void) {
  /* Request larger than LRD_ENV_MAX_PAYLOAD must fail. */
  lrd_env_t e;
  int rc = lrd_env_build(&e, 0, NULL, LRD_ENV_MAX_PAYLOAD + 1);
  CHECK(rc != 0, "oversized refused");
  printf("PASS env_oversized_refused\n");
}

static void test_legacy_detect(void) {
  const unsigned char leg[] = "LRD-REC-v1\n1:a1:b\n";
  CHECK(lrd_env_is_legacy_rec(leg, sizeof leg - 1), "legacy detected");
  const unsigned char envmagic[] = "LRD-ENV-v1\n";
  CHECK(!lrd_env_is_legacy_rec(envmagic, sizeof envmagic - 1), "env not legacy");
  printf("PASS env_legacy_detect\n");
}

int main(void) {
  test_sizes();
  test_oversized();
  test_legacy_detect();
  if (failures) {
    fprintf(stderr, "%d failures\n", failures);
    return 1;
  }
  printf("ALL ENV TESTS PASSED\n");
  return 0;
}
