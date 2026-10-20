/* SPDX-License-Identifier: AGPL-3.0-only
 * Also licensed under the SnapKitty Opaque License; see LICENSE and
 * SNAPKITTY_OPAQUE_LICENSE.md at the repository root.
 * Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 *
 * rec_tool: exercise the runtime LRD-REC-v1 code.
 *   rec_tool ser key=value...     write canonical serialization to stdout
 *   rec_tool commit key=value...  print commitment hex
 *   rec_tool parse FILE           exit 0 and print "ok N" if FILE is a valid
 *                                 LRD-REC-v1 serialization, else "error: ..." exit 1
 */
#define _POSIX_C_SOURCE 200809L
#include "../../../llvm/runtime/lrd_rec.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char **argv) {
  int i;
  if (argc >= 2 && (!strcmp(argv[1], "ser") || !strcmp(argv[1], "commit"))) {
    lrd_rec *r = lrd_rec_new();
    for (i = 2; i < argc; i++) {
      char *eq = strchr(argv[i], '=');
      if (!eq) return 2;
      *eq = 0;
      if (lrd_rec_set(r, argv[i], eq + 1)) { fprintf(stderr, "rec_tool: duplicate or invalid key %s\n", argv[i]); return 1; }
    }
    if (argv[1][0] == 's') { size_t n; char *s = lrd_rec_serialize(r, &n); fwrite(s, 1, n, stdout); free(s); }
    else { char hex[65]; lrd_rec_commit(r, hex); printf("%s\n", hex); }
    lrd_rec_free(r);
    return 0;
  }
  if (argc == 3 && !strcmp(argv[1], "parse")) {
    FILE *f = fopen(argv[2], "rb");
    static char buf[1 << 16];
    size_t n;
    char err[256];
    lrd_rec *r;
    if (!f) return 2;
    n = fread(buf, 1, sizeof buf, f);
    fclose(f);
    r = lrd_rec_parse(buf, n, err, sizeof err);
    if (!r) { printf("error: %s\n", err); return 1; }
    printf("ok %zu\n", r->n);
    lrd_rec_free(r);
    return 0;
  }
  return 2;
}
