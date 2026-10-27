#!/bin/sh
# SPDX-License-Identifier: AGPL-3.0-only
# Also subject to SNAPKITTY_OPAQUE_LICENSE.md (dual license, see repository root).
#
# Mutation gate for JWST-LRD blocker (b): order of the ham_decide checks
# epoch_exhausted (row 8) / infeasible (row 9).
#
# Copies only the sources and the unit suite into a temp directory, applies
# hamiltonian/mutants/swap_8_9.patch THERE (the working tree is never modified),
# builds with the module Makefile (gcc, -std=c17 -Werror) and runs the unit suite.
#   KILLED swap_8_9     the suite reports fail >= 1 against the mutant   (exit 0)
#   SURVIVED swap_8_9   the suite reports fail = 0 against the mutant    (exit 1)
#   ERROR ...           patch/build/tool problem, or the UNMUTATED copy does not
#                       pass cleanly, so no verdict is given              (exit 2)
# POSIX sh; works under bash and dash.
set -u
HERE=$(cd "$(dirname "$0")" && pwd)
ROOT=$(cd "$HERE/../.." && pwd)
NAME=swap_8_9
PATCH_FILE="$HERE/$NAME.patch"

err() { echo "ERROR $NAME $*"; exit 2; }
command -v patch >/dev/null 2>&1 || err "UNAVAILABLE: patch(1) not installed"
command -v make  >/dev/null 2>&1 || err "UNAVAILABLE: make not installed"
command -v gcc   >/dev/null 2>&1 || err "UNAVAILABLE: gcc not installed"
[ -f "$PATCH_FILE" ] || err "missing $PATCH_FILE"

TMP=$(mktemp -d "${TMPDIR:-/tmp}/lrd-mutant.XXXXXX") || err "mktemp failed"
trap 'rm -rf "$TMP"' EXIT INT TERM

# same cross-check value run.sh passes to the suite (independent sha256sum)
GOLDEN=$(printf 'LRD-COMMIT-v1\0LRD-REC-v1\n1:a2:xy\n1:b1:2\n' | sha256sum | cut -d' ' -f1)

# fresh_copy <dir>: sources + unit suite + shared ABI header, no build products
fresh_copy() {
  mkdir -p "$1/hamiltonian" "$1/tests/hamiltonian" "$1/ledger" || return 1
  cp -R "$ROOT/hamiltonian/include" "$ROOT/hamiltonian/src" "$ROOT/hamiltonian/Makefile" "$1/hamiltonian/" &&
  cp "$ROOT/tests/hamiltonian/test_ham.c" "$1/tests/hamiltonian/" &&
  cp -R "$ROOT/ledger/abi" "$1/ledger/"
}

# build_and_run <dir> <label>: sets SUMMARY, RC; echoes failing lines
build_and_run() {
  if ! make -C "$1/hamiltonian" clean std >"$1/build.log" 2>&1; then
    sed 's/^/#   /' "$1/build.log"; err "$2: build failed"
  fi
  "$1/hamiltonian/build/std/test_ham" "$GOLDEN" >"$1/suite.out" 2>&1
  RC=$?
  grep -E '^(FAIL|UNAVAILABLE) ' "$1/suite.out" | sed 's/^/#   /'
  SUMMARY=$(grep '^# SUMMARY ' "$1/suite.out" | tail -n 1)
  [ -n "$SUMMARY" ] || err "$2: suite printed no '# SUMMARY' line (exit $RC)"
  echo "# $2: ${SUMMARY#\# SUMMARY } exit=$RC"
}
field_of() { echo "$1" | sed -n "s/.*$2=\\([0-9][0-9]*\\).*/\\1/p"; }

# 1. unmutated copy must be clean, otherwise "fail>=1" says nothing about the mutant
fresh_copy "$TMP/base" || err "copy failed"
build_and_run "$TMP/base" "unmutated"
[ "$RC" -eq 0 ] && [ "$(field_of "$SUMMARY" fail)" = 0 ] || err "unmutated copy does not pass cleanly; no verdict"

# 2. mutant: patch applied to the temp copy only
fresh_copy "$TMP/mut" || err "copy failed"
(cd "$TMP/mut" && patch -p1 -s <"$PATCH_FILE") || err "patch does not apply to hamiltonian/src/ham_engine.c"
build_and_run "$TMP/mut" "mutant $NAME"
NFAIL=$(field_of "$SUMMARY" fail)
[ -n "$NFAIL" ] || err "could not read fail count from: $SUMMARY"
if [ "$NFAIL" -ge 1 ] && [ "$RC" -ne 0 ]; then
  echo "KILLED $NAME"; exit 0
fi
echo "SURVIVED $NAME"; exit 1
