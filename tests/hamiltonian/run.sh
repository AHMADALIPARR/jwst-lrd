#!/usr/bin/env bash
# Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
# Dual-licensed: AGPL-3.0-or-later plus SnapKitty Opaque License (see LICENSE, SNAPKITTY_OPAQUE_LICENSE.md).
# SPDX-License-Identifier: AGPL-3.0-or-later AND LicenseRef-SnapKitty-Opaque
#
# CONTRACTS.md test runner for the hamiltonian module (TASK 008).
# Prints "PASS <name>" | "FAIL <name> <why>" | "UNAVAILABLE <name> <reason>";
# informational lines start with "# ". Exits nonzero only if there is a FAIL.
# Full output is also written to tests/hamiltonian/logs/<timestamp>.log.
set -u
HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/../.." && pwd)"
HAM="$ROOT/hamiltonian"
mkdir -p "$HERE/logs"
TS="$(date +%Y%m%dT%H%M%S%z)"
LOG="$HERE/logs/$TS.log"
exec > >(tee "$LOG") 2>&1

fails=0
pass() { echo "PASS $1"; }
fail() { echo "FAIL $1 $2"; fails=$((fails+1)); }
unav() { echo "UNAVAILABLE $1 $2"; }
indent() { sed 's/^/#   /'; }

echo "# hamiltonian run.sh  log=$LOG"
echo "# date: $(date '+%Y-%m-%d %H:%M:%S %Z')"
echo "# git: $(git -C "$ROOT" rev-parse --abbrev-ref HEAD 2>/dev/null) $(git -C "$ROOT" rev-parse HEAD 2>/dev/null)"
echo "# gcc: $(gcc --version 2>/dev/null | head -1)"
echo "# clang: $(clang --version 2>/dev/null | head -1)"
echo "# make: $(make --version 2>/dev/null | head -1)"
echo "# valgrind: $(valgrind --version 2>/dev/null || echo none)"
echo "# gmp: $(dpkg-query -W -f='${Package} ${Version}' libgmp-dev 2>/dev/null || echo unknown)"
if [ -f "$ROOT/ledger/abi/lrd_state.h" ]; then
  echo "# abi header: ledger/abi/lrd_state.h sha256=$(sha256sum "$ROOT/ledger/abi/lrd_state.h" | cut -d" " -f1) last-commit=$(git -C "$ROOT" log -1 --format=%h -- ledger/abi/lrd_state.h)"
  if [ -e "$HAM/abi/lrd_state.h" ]; then fail ledger_abi_header "a forked copy exists under hamiltonian/abi"; else pass ledger_abi_header; fi
else
  fail ledger_abi_header "ledger/abi/lrd_state.h missing (rebase on main >= 627fda7)"
fi

# independent cross-check value for the LRD-COMMIT-v1 implementation
GOLDEN="$(printf 'LRD-COMMIT-v1\0LRD-REC-v1\n1:a2:xy\n1:b1:2\n' | sha256sum | cut -d' ' -f1)"

# --- static checks on the engine sources ---
if grep -nE '\b(float|double|long double|fabs|sqrt|pow|math\.h)\b' "$HAM"/src/*.c "$HAM"/include/*.h >/dev/null; then
  fail no_float_in_engine "floating point token found in hamiltonian/src or include"
else
  pass no_float_in_engine
fi
if find "$HAM" "$HERE" \( -name '*.py' -o -name '*.js' -o -name '*.ts' -o -name '*.mjs' -o -name '*.tsx' \) | grep -q .; then
  fail no_py_ts_js "forbidden language file present"
else
  pass no_py_ts_js
fi

# --- gcc -std=c17 -Wall -Wextra -Werror ---
make -C "$HAM" clean >/dev/null
if make -C "$HAM" std >"$HERE/logs/.build_std.txt" 2>&1; then
  pass build_gcc_c17_werror
  "$HAM/build/std/test_ham" "$GOLDEN"
  rc=$?
  [ $rc -eq 0 ] || fails=$((fails+1))
else
  indent < "$HERE/logs/.build_std.txt"
  fail build_gcc_c17_werror "see log"
fi

# helper: run a suite variant quietly, summarise
suite() { # name cmd...
  local name="$1"; shift
  local out; out="$("$@" 2>&1)"; local rc=$?
  echo "$out" | indent
  local p f; p=$(echo "$out" | grep -c '^PASS ') ; f=$(echo "$out" | grep -c '^FAIL ')
  if [ $rc -eq 0 ] && [ "$f" -eq 0 ] && ! echo "$out" | grep -qE 'runtime error|AddressSanitizer|LeakSanitizer|UndefinedBehaviorSanitizer'; then
    pass "$name"
    echo "# $name: $p tests passed, 0 failed, exit $rc"
  else
    fail "$name" "exit=$rc pass=$p fail=$f (see log)"
  fi
}

# --- clang -Werror ---
if command -v clang >/dev/null; then
  if make -C "$HAM" clang >"$HERE/logs/.build_clang.txt" 2>&1; then
    pass build_clang_c17_werror
    suite clang_suite "$HAM/build/clang/test_ham" "$GOLDEN"
  else
    indent < "$HERE/logs/.build_clang.txt"; fail build_clang_c17_werror "see log"
  fi
else
  unav build_clang_c17_werror "clang not installed"
fi

# --- ASan + UBSan ---
if make -C "$HAM" asan >"$HERE/logs/.build_asan.txt" 2>&1; then
  pass build_asan_ubsan
  ASAN_OPTIONS=detect_leaks=1 UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1 \
    suite asan_ubsan_suite "$HAM/build/asan/test_ham" "$GOLDEN"
else
  indent < "$HERE/logs/.build_asan.txt"; fail build_asan_ubsan "see log"
fi

# --- valgrind memcheck ---
if command -v valgrind >/dev/null && [ -x "$HAM/build/std/test_ham" ]; then
  vout="$(valgrind --error-exitcode=99 --leak-check=full --show-leak-kinds=definite,indirect \
          --errors-for-leak-kinds=definite,indirect --track-origins=yes \
          "$HAM/build/std/test_ham" "$GOLDEN" 2>&1)"; vrc=$?
  echo "$vout" | grep -E '^==[0-9]+== (ERROR SUMMARY|.*definitely lost|.*indirectly lost|.*All heap blocks)|^SUMMARY' | indent
  if [ $vrc -eq 0 ]; then pass valgrind_memcheck; else fail valgrind_memcheck "exit=$vrc"; fi
else
  unav valgrind_memcheck "valgrind not installed or std build missing"
fi
rm -f "$HERE"/logs/.build_*.txt

echo "# runner: fails=$fails"
[ $fails -eq 0 ]
