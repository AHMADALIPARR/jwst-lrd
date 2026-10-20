#!/bin/sh
# SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
set -eu
ROOT=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
sh "$ROOT/tests/morphic/proofs.sh"
if [ -z "${SELF_BIN:-}" ] || [ -z "${SELF_OBJECTS:-}" ]; then
  echo 'UNAVAILABLE morphic_self set_SELF_BIN_and_SELF_OBJECTS'; exit 0
fi
mkdir -p "$ROOT/tests/morphic/evidence"
TMP=$(mktemp -d /tmp/lrd-model.XXXXXX)
cp -R "$ROOT/self" "$ROOT/fixtures" "$ROOT/tests/morphic" "$TMP/"
LOG="$ROOT/tests/morphic/evidence/model.log"
(cd "$SELF_OBJECTS" && LRD_ROOT="$TMP" timeout -k 5 120 "$SELF_BIN" \
  -f worldBuilder.self -b . -o none -f2 "$TMP/morphic/model.self" < /dev/null) > "$LOG" 2>&1
grep -aE '^(PASS|FAIL) ' "$LOG" || true
if ! grep -aq LRD_MODEL_DONE "$LOG" || grep -aqE '^FAIL |error --|Self VM error:' "$LOG"; then
  echo 'FAIL morphic_self_execution'; tail -20 "$LOG"; exit 1
fi
grep -aE '^(PASS|FAIL) ' "$LOG" > "$ROOT/tests/morphic/evidence/model-results.txt"
if command -v Xvfb >/dev/null && command -v import >/dev/null; then
  sh "$ROOT/tests/morphic/gui.sh"
else
  echo 'UNAVAILABLE morphic_gui missing_Xvfb_or_ImageMagick'
fi
