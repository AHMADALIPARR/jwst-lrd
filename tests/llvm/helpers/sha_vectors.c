/* SPDX-License-Identifier: AGPL-3.0-only
 * Also licensed under the SnapKitty Opaque License; see LICENSE and
 * SNAPKITTY_OPAQUE_LICENSE.md at the repository root.
 * Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 *
 * sha_vectors: prints the runtime SHA-256 of a vector, one per invocation:
 *   sha_vectors abc | empty | 448 | million | file PATH
 * The expected digests are compared in tests/llvm/run.sh (FIPS 180-2 values
 * and sha256sum).
 */
#include "../../../llvm/runtime/lrd_sha256.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char **argv) {
  char hex[65];
  if (argc < 2) return 2;
  if (!strcmp(argv[1], "abc")) lrd_sha256_hex("abc", 3, hex);
  else if (!strcmp(argv[1], "empty")) lrd_sha256_hex("", 0, hex);
  else if (!strcmp(argv[1], "448")) lrd_sha256_hex("abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq", 56, hex);
  else if (!strcmp(argv[1], "million")) {
    char *m = malloc(1000000);
    memset(m, 'a', 1000000);
    lrd_sha256_hex(m, 1000000, hex);
    free(m);
  } else if (!strcmp(argv[1], "file") && argc == 3) {
    FILE *f = fopen(argv[2], "rb");
    lrd_sha256_ctx c;
    unsigned char buf[65536], d[32];
    size_t k;
    if (!f) return 2;
    lrd_sha256_init(&c);
    while ((k = fread(buf, 1, sizeof buf, f)) > 0) lrd_sha256_update(&c, buf, k);
    fclose(f);
    lrd_sha256_final(&c, d);
    lrd_hex32(d, hex);
  } else return 2;
  printf("%s\n", hex);
  return 0;
}
