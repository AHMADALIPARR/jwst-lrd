#!/bin/sh
# SPDX-License-Identifier: AGPL-3.0-only
# Also subject to SNAPKITTY_OPAQUE_LICENSE.md (dual license, see repository root).
#
# Aggregate test runner: runs every tests/*/run.sh (CONTRACTS.md test convention),
# echoes their PASS/FAIL/UNAVAILABLE lines, and exits nonzero iff any FAIL occurred.
ROOT=$(cd "$(dirname "$0")/.." && pwd)
cd "$ROOT" || exit 2
mkdir -p build/out
pass=0; fail=0; unav=0; rc=0
for t in tests/*/run.sh; do
  [ -f "$t" ] || continue
  mod=$(basename "$(dirname "$t")")
  echo "== $mod ($t)"
  out=$(sh "$t" 2>"$ROOT/build/out/test-$mod.stderr"); r=$?
  printf '%s\n' "$out"
  p=$(printf '%s\n' "$out" | grep -c '^PASS ')
  f=$(printf '%s\n' "$out" | grep -c '^FAIL ')
  u=$(printf '%s\n' "$out" | grep -c '^UNAVAILABLE ')
  pass=$((pass+p)); fail=$((fail+f)); unav=$((unav+u))
  if [ $r -ne 0 ] && [ "$f" -eq 0 ]; then
    echo "FAIL $mod/run.sh exited $r without a FAIL line (see build/out/test-$mod.stderr)"
    fail=$((fail+1))
  fi
done
echo "== TOTAL: $pass PASS, $fail FAIL, $unav UNAVAILABLE"
[ $fail -eq 0 ]
