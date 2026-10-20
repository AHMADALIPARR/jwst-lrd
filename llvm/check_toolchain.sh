#!/bin/bash
# SPDX-License-Identifier: AGPL-3.0-only
# Also licensed under the SnapKitty Opaque License; see LICENSE and
# SNAPKITTY_OPAQUE_LICENSE.md at the repository root.
#
# Verifies every tool in llvm/toolchain.pin. Prints one line per tool:
#   PASS toolchain_<tool> | UNAVAILABLE toolchain_<tool> <reason>
# Exit 0 iff all pins match; exit 3 otherwise (callers treat 3 as UNAVAILABLE).
here=$(cd "$(dirname "$0")" && pwd)
rc=0
while IFS='|' read -r tool cmd want; do
  case "$tool" in ''|\#*) continue;; esac
  bin=${cmd%% *}
  if [ ! -x "$bin" ]; then
    echo "UNAVAILABLE toolchain_$tool $bin not found"; rc=3; continue
  fi
  got=$($cmd 2>/dev/null | head -n 1)
  if [ "$got" = "$want" ]; then
    echo "PASS toolchain_$tool"
  else
    echo "UNAVAILABLE toolchain_$tool version mismatch: got '$got', pinned '$want'"; rc=3
  fi
done < "$here/toolchain.pin"
exit $rc
