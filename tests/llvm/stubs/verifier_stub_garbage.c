/* SPDX-License-Identifier: AGPL-3.0-only
 * Also licensed under the SnapKitty Opaque License; see LICENSE and
 * SNAPKITTY_OPAQUE_LICENSE.md at the repository root.
 * Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 *
 * TEST STUB ONLY - NOT A VERIFIER. Emits output that is not an LRD-REC-v1
 * record, to test that the proof gate refuses malformed decisions.
 */
#include <stdio.h>

int main(void) {
  char buf[4096];
  while (fread(buf, 1, sizeof buf, stdin) > 0) {}
  fputs("decision=ACCEPT\nreason=ok\n", stdout);
  return 0;
}
