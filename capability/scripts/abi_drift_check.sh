#!/usr/bin/env bash
# SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
# Dual-licensed (intentionally): AGPL-3.0-only plus the SnapKitty Opaque License.
# Fails if the vendored lrd_state.h drifts from the ledger track's t004-ledger branch.
# Prints one PASS/FAIL/UNAVAILABLE line.
set -uo pipefail
HERE="$(cd "$(dirname "$0")/.." && pwd)"
vend="$HERE/abi/vendor/lrd_state.h"
want=$(sed -n 's/^sha256=//p' "$HERE/abi/vendor/SOURCE")
have=$(sha256sum "$vend" | cut -d' ' -f1)
if [ "$want" != "$have" ]; then echo "FAIL abi_vendored_header_integrity vendored copy edited (sha256 $have != SOURCE $want)"; exit 1; fi
upstream=$(git -C "$HERE" show t004-ledger:ledger/abi/lrd_state.h 2>/dev/null | sha256sum | cut -d' ' -f1)
if ! git -C "$HERE" rev-parse --verify -q t004-ledger >/dev/null 2>&1; then
  echo "UNAVAILABLE abi_header_drift_vs_t004_ledger branch t004-ledger not present in this repository"; exit 0; fi
if [ "$upstream" = "$have" ]; then
  echo "PASS abi_header_drift_vs_t004_ledger (t004-ledger@$(git -C "$HERE" rev-parse --short t004-ledger) sha256=$have)"
else
  echo "FAIL abi_header_drift_vs_t004_ledger t004-ledger header sha256=$upstream differs from vendored $have; re-vendor (see abi/vendor/SOURCE)"; exit 1
fi
