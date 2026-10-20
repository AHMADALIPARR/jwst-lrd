/* SPDX-License-Identifier: AGPL-3.0-only
 * Also licensed under the SnapKitty Opaque License; see LICENSE and
 * SNAPKITTY_OPAQUE_LICENSE.md at the repository root.
 * Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 *
 * TEST STUB ONLY - NOT A VERIFIER. Always ACCEPTs: reads the proposal from
 * stdin and answers decision=ACCEPT, reason=ok, new_commit = SHA-256 of
 * "LRD-COMMIT-v1\0" || <proposal bytes as received>. Checks nothing else.
 */
#include "../../../llvm/runtime/lrd_sha256.h"
#include <stdio.h>
#include <string.h>

int main(void) {
  static unsigned char buf[1 << 16];
  size_t n = fread(buf, 1, sizeof buf, stdin);
  lrd_sha256_ctx c;
  unsigned char d[32];
  char hex[65];
  if (n < 11 || memcmp(buf, "LRD-REC-v1\n", 11)) return 1;
  lrd_sha256_init(&c);
  lrd_sha256_update(&c, "LRD-COMMIT-v1", 14);
  lrd_sha256_update(&c, buf, n);
  lrd_sha256_final(&c, d);
  lrd_hex32(d, hex);
  printf("LRD-REC-v1\n8:decision6:ACCEPT\n10:new_commit64:%s\n6:reason2:ok\n", hex);
  return 0;
}
