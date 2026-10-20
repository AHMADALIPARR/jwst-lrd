/* SPDX-License-Identifier: AGPL-3.0-only
 * Also subject to SNAPKITTY_OPAQUE_LICENSE.md (dual license, see repository root).
 *
 * lrd_sha256 <file> [expected-hex]
 * Prints "<hex>  <size>" ; with expected-hex, exits 1 loudly on mismatch.
 */
#include <stdio.h>
#include <string.h>
int lrd_sha256_file(const char *path, char hex[65], long long *size_out);
int main(int argc, char **argv) {
    if (argc < 2) { fprintf(stderr, "usage: lrd_sha256 <file> [expected]\n"); return 2; }
    char hex[65]; long long sz;
    if (lrd_sha256_file(argv[1], hex, &sz) != 0) { perror(argv[1]); return 1; }
    printf("%s  %lld\n", hex, sz);
    if (argc > 2 && strcmp(hex, argv[2]) != 0) {
        fprintf(stderr, "CHECKSUM MISMATCH: %s\n  expected %s\n  actual   %s\n", argv[1], argv[2], hex);
        return 1;
    }
    return 0;
}
