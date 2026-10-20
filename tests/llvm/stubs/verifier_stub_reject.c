/* SPDX-License-Identifier: AGPL-3.0-only
 * Also licensed under the SnapKitty Opaque License; see LICENSE and
 * SNAPKITTY_OPAQUE_LICENSE.md at the repository root.
 * Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 *
 * TEST STUB ONLY - NOT A VERIFIER. Always REJECTs with reason=bad_proof.
 */
#include <stdio.h>

int main(void) {
  char buf[4096];
  while (fread(buf, 1, sizeof buf, stdin) > 0) {}
  fputs("LRD-REC-v1\n8:decision6:REJECT\n6:reason9:bad_proof\n", stdout);
  return 0;
}
