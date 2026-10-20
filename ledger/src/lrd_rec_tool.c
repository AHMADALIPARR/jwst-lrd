/* Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 * Dual-licensed: AGPL-3.0-or-later plus SnapKitty Opaque License.
 * SPDX-License-Identifier: AGPL-3.0-or-later AND LicenseRef-SnapKitty-Opaque
 *
 * lrd-rec: small LRD-REC-v1 utility.
 *   lrd-rec make key=value ...   write the canonical serialization to stdout
 *   lrd-rec commit FILE          strict-parse FILE, print its LRD-COMMIT-v1 commitment
 *   lrd-rec check FILE           strict-parse FILE; exit 0 iff canonical
 * Exit codes: 0 ok, 1 rejected input, 2 usage/IO error.
 */
#include "lrd_rec.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static unsigned char *slurp(const char *path, size_t *n) {
  FILE *f = fopen(path, "rb");
  if (!f) return NULL;
  size_t cap = 4096, len = 0; unsigned char *b = malloc(cap);
  for (;;) {
    if (!b) { fclose(f); return NULL; }
    size_t r = fread(b + len, 1, cap - len, f); len += r;
    if (r == 0) break;
    if (len == cap) { cap *= 2; unsigned char *t = realloc(b, cap); if (!t) { free(b); b = NULL; } else b = t; }
  }
  fclose(f); *n = len; return b;
}

int main(int argc, char **argv) {
  if (argc < 2) goto usage;
  if (strcmp(argv[1], "make") == 0) {
    lrd_rec_t r; lrd_rec_init(&r);
    for (int i = 2; i < argc; i++) {
      char *eq = strchr(argv[i], '=');
      if (!eq || lrd_rec_setn(&r, argv[i], (size_t)(eq - argv[i]), eq + 1, strlen(eq + 1))) {
        fprintf(stderr, "lrd-rec: bad field '%s'\n", argv[i]); lrd_rec_free(&r); return 1;
      }
    }
    unsigned char *s; size_t n;
    if (lrd_rec_serialize(&r, &s, &n)) return 2;
    fwrite(s, 1, n, stdout); free(s); lrd_rec_free(&r);
    return 0;
  }
  if ((strcmp(argv[1], "commit") == 0 || strcmp(argv[1], "check") == 0) && argc == 3) {
    size_t n; unsigned char *b = slurp(argv[2], &n);
    if (!b) { perror(argv[2]); return 2; }
    lrd_rec_t r; lrd_rec_init(&r); const char *why = NULL;
    int rc = lrd_rec_parse(b, n, &r, &why); free(b);
    if (rc) { printf("REJECT %s\n", why); return 1; }
    if (argv[1][1] == 'o') { char h[LRD_HEX256_BUF]; lrd_rec_commit_hex(&r, h); printf("%s\n", h); }
    else printf("OK\n");
    lrd_rec_free(&r);
    return 0;
  }
usage:
  fprintf(stderr, "usage: lrd-rec make k=v ... | lrd-rec commit FILE | lrd-rec check FILE\n");
  return 2;
}
