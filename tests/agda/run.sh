#!/usr/bin/env bash
# Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
# Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
# SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
#
# TASK 011: Agda verified core. Follows research/CONTRACTS.md: one line per test,
#   PASS <name> | FAIL <name> <why> | UNAVAILABLE <name> <reason>
# and exits nonzero iff some test FAILs.
set -u
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
AGDA_ROOT="$ROOT/agda"
CORE="$AGDA_ROOT/Core"
export AGDA_DIR="$AGDA_ROOT/agda-dir"
PRAGMA='{-# OPTIONS --safe --without-K #-}'
fails=0
pass() { echo "PASS $1"; }
fail() { echo "FAIL $1 $2"; fails=$((fails+1)); }
unavail() { echo "UNAVAILABLE $1 $2"; }
pin() { sed -n "s/^$1=//p" "$AGDA_ROOT/VERSIONS"; }

shopt -s nullglob
files=("$CORE"/*.agda)
if [ ${#files[@]} -eq 0 ]; then fail agda-core-present "no files in agda/Core"; else pass agda-core-present; fi

# --- static checks (need no toolchain) -------------------------------------
bad=""
for f in "${files[@]}"; do
  [ "$(head -n 1 "$f")" = "$PRAGMA" ] || bad="$bad $(basename "$f")"
done
[ -z "$bad" ] && pass agda-options-header || fail agda-options-header "first line is not '$PRAGMA' in:$bad"

hits=$(grep -n 'OPTIONS' "${files[@]}" | grep -vF "$PRAGMA" || true)
[ -z "$hits" ] && pass agda-no-extra-options || fail agda-no-extra-options "$(echo "$hits" | head -n 1)"

WEAK='--type-in-type|--no-positivity-check|--no-termination-check|--allow-unsolved-metas|--allow-incomplete-matches|--no-universe-check|--omega-in-omega|--injective-type-constructors|--with-K|--rewriting|--cumulativity|--guardedness|--sized-types|--erased-matches|--experimental-irrelevance|--no-safe|TERMINATING|NON_TERMINATING|NO_POSITIVITY_CHECK|NON_COVERING|NO_UNIVERSE_CHECK|INJECTIVE|BUILTIN REWRITE|primTrustMe|trustMe'
hits=$(grep -nE -- "$WEAK" "${files[@]}" "$AGDA_ROOT/jwst-lrd-core.agda-lib" || true)
[ -z "$hits" ] && pass agda-no-weakening-options || fail agda-no-weakening-options "$(echo "$hits" | head -n 1)"

hits=$(grep -nw 'postulate' "${files[@]}" || true)
[ -z "$hits" ] && pass agda-no-postulate || fail agda-no-postulate "$(echo "$hits" | head -n 1)"

hits=$(grep -nE '\{!|(^|[[:space:](){};])\?([[:space:](){};]|$)' "${files[@]}" || true)
[ -z "$hits" ] && pass agda-no-holes || fail agda-no-holes "$(echo "$hits" | head -n 1)"

missing=""
for f in "${files[@]}"; do
  m="Core.$(basename "$f" .agda)"
  [ "$m" = "Core.All" ] && continue
  grep -qE "^(open )?import $m( |$)" "$CORE/All.agda" || missing="$missing $m"
done
[ -z "$missing" ] && pass agda-all-imports-every-module || fail agda-all-imports-every-module "not imported by Core/All.agda:$missing"

# --- toolchain ---------------------------------------------------------------
if ! command -v agda >/dev/null 2>&1; then
  unavail agda-version-pin "agda not on PATH"
  unavail agda-stdlib-pin "agda not on PATH"
  unavail agda-typecheck-all "agda not on PATH"
  [ $fails -eq 0 ]; exit $?
fi

want=$(pin agda_version); have=$(agda --version 2>/dev/null | sed -n 's/^Agda version //p')
[ "$have" = "$want" ] && pass agda-version-pin || fail agda-version-pin "installed '$have', pinned '$want'"

lib=$(pin stdlib_agda_lib); wantname=$(pin stdlib_name); wanthash=$(pin stdlib_src_tree_sha256)
if [ ! -f "$lib" ]; then
  fail agda-stdlib-pin "missing $lib"
else
  libdir=$(dirname "$lib")
  havename=$(sed -n 's/^name:[[:space:]]*//p' "$lib")
  havehash=$(cd "$libdir" && find src -name '*.agda' -type f | LC_ALL=C sort | xargs sha256sum | sha256sum | cut -d' ' -f1)
  if [ "$havename" != "$wantname" ]; then fail agda-stdlib-pin "library name '$havename', pinned '$wantname'"
  elif [ "$havehash" != "$wanthash" ]; then fail agda-stdlib-pin "stdlib source tree hash $havehash != pinned $wanthash"
  elif ! grep -qxF "$lib" "$AGDA_DIR/libraries"; then fail agda-stdlib-pin "$AGDA_DIR/libraries does not register $lib"
  else pass agda-stdlib-pin; fi
fi

# Clean type-check of the core (project interface files are discarded first).
log="$AGDA_ROOT/_build/run-sh-typecheck.log"
rm -rf "$AGDA_ROOT/_build"; mkdir -p "$AGDA_ROOT/_build"
( cd "$AGDA_ROOT" && agda Core/All.agda ) >"$log" 2>&1
rc=$?
if [ $rc -ne 0 ]; then
  fail agda-typecheck-all "agda exited $rc: $(grep -v '^ *Checking' "$log" | head -n 2 | tr '\n' ' ')"
elif grep -qiE 'unsolved|error|warning' "$log"; then
  fail agda-typecheck-all "agda output mentions unsolved/error/warning (see $log)"
else

  pass agda-typecheck-all
fi

[ $fails -eq 0 ]
