#!/bin/sh
# SPDX-License-Identifier: AGPL-3.0-only
# Also subject to SNAPKITTY_OPAQUE_LICENSE.md (dual license, see repository root).
#
# Aggregate test runner: runs every <tests>/*/run.sh (CONTRACTS.md test convention), echoes
# their PASS/FAIL/UNAVAILABLE lines, and exits nonzero iff any FAIL occurred.
# Each suite is executed directly so its shebang is honoured (bash suites stay bash). If a
# run.sh is not executable, the interpreter named on its shebang line is used; only a file
# without a shebang falls back to sh.
# A suite that prints no PASS/FAIL/UNAVAILABLE line, or exits nonzero without a FAIL line,
# is reported as FAIL <suite>/run.sh.
# OPEN lines ("OPEN <name> ..." and "FAIL-EXPECTED/OPEN <name> ...") mark known-unresolved items: they are counted
# separately in the TOTAL line and neither count as PASS nor make the run fail.
# LRD_TESTS_DIR overrides the tests directory (used by tests/runner to test this runner).
ROOT=$(cd "$(dirname "$0")/.." && pwd)
cd "$ROOT" || exit 2
TD=${LRD_TESTS_DIR:-$ROOT/tests}
LOGD=${LRD_TEST_LOGS:-$ROOT/build/out}
mkdir -p "$LOGD"
pass=0; fail=0; unav=0; open=0
for t in "$TD"/*/run.sh; do
  [ -f "$t" ] || continue
  mod=$(basename "$(dirname "$t")")
  echo "== $mod ($t)"
  if [ -x "$t" ]; then
    out=$("$t" 2>"$LOGD/test-$mod.stderr"); r=$?
  else
    shebang=$(head -n 1 "$t")
    case "$shebang" in
      '#!'*) interp=${shebang#\#!}
             # shellcheck disable=SC2086  (interpreter line may carry arguments, e.g. /usr/bin/env bash)
             out=$($interp "$t" 2>"$LOGD/test-$mod.stderr"); r=$? ;;
      *)     out=$(sh "$t" 2>"$LOGD/test-$mod.stderr"); r=$? ;;
    esac
  fi
  [ -n "$out" ] && printf '%s\n' "$out"
  p=$(printf '%s\n' "$out" | grep -c '^PASS ')
  f=$(printf '%s\n' "$out" | grep -c '^FAIL ')
  u=$(printf '%s\n' "$out" | grep -c '^UNAVAILABLE ')
  o=$(printf '%s\n' "$out" | grep -c '^OPEN \|^FAIL-EXPECTED/OPEN ')
  pass=$((pass+p)); fail=$((fail+f)); unav=$((unav+u)); open=$((open+o))
  if [ $((p+f+u)) -eq 0 ]; then
    echo "FAIL $mod/run.sh printed no PASS/FAIL/UNAVAILABLE line (exit $r; see $LOGD/test-$mod.stderr)"
    fail=$((fail+1))
  elif [ $r -ne 0 ] && [ "$f" -eq 0 ]; then
    echo "FAIL $mod/run.sh exited $r without a FAIL line (see $LOGD/test-$mod.stderr)"
    fail=$((fail+1))
  fi
done
echo "== TOTAL: $pass PASS, $fail FAIL, $unav UNAVAILABLE, $open OPEN"
[ $fail -eq 0 ]
