#!/usr/bin/env bash
# SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
# Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited. Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
#
# Test runner for the causal track (TASK 006), research/CONTRACTS.md test convention.
# Prints one line per check:
#   PASS <name> | FAIL <name> <why> | UNAVAILABLE <name> <reason>
# Informational lines start with "# ". Exits nonzero only if a FAIL was printed.
#
# What it does:
#   1. builds the Fortran causal library and the 7 Fortran test programs (make -C fortran/causal all);
#   2. creates tests/causal/out/ (git-ignored) and runs the 7 Fortran programs in tests/causal/;
#      they write the SYNTHETIC fixture out/SYNTHETIC_causal_fixture.lrdrec;
#   3. Curry (curry/causal/TestCausalGraph.curry), only if a PAKCS of the required version
#      runs here; otherwise UNAVAILABLE with the reason. The Curry sources are copied to
#      out/curry-run/ first, so PAKCS cache files are never written into curry/causal/;
#   4. Self (self/causal/testCausalGraph.self), only if a Self VM and a world snapshot, or a
#      Self VM with its objects directory, exist; otherwise UNAVAILABLE with the reason.
# Curry and Self read the fixture the Fortran step wrote. If the fixture is missing they are
# reported UNAVAILABLE (the Fortran step reports its own FAIL in that case).
#
# Environment (all optional):
#   LRD_PAKCS, PAKCS     a pakcs executable (or an install dir with bin/pakcs), tried first; PAKCSHOME/bin/pakcs next
#   LRD_PAKCS_VERSION    required PAKCS --numeric-version (default 3.10.0)
#   LRD_SHARED_TOOLS     extra tool directory searched for pakcs-<ver>/ and self-src/ (as build/toolchain.sh)
#   LRD_SELF_VM, SELF_VM, SELF_VM_PATH   a Self VM (or a dir holding Self), tried first
#   LRD_SELF_WORLD, SELF_WORLD           a morphic world snapshot (.snap) for that VM
#   After the variables: PATH, then the build/tools, LRD_SHARED_TOOLS and /workspace/_*tools locations.
set -u
HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/../.." && pwd)"
FDIR="$ROOT/fortran/causal"
OUT="$HERE/out"
BLD="$FDIR/build"
REQ_PAKCS="${LRD_PAKCS_VERSION:-3.10.0}"
SHARED="${LRD_SHARED_TOOLS:-/workspace/jwst-lrd/build/tools}"
FIXTURE="$OUT/SYNTHETIC_causal_fixture.lrdrec"
TESTS="test_units_interval test_classify test_edges test_dag test_boost test_serial test_fixture"

np=0; nf=0; nu=0
pass() { echo "PASS $1"; np=$((np + 1)); }
fail() { echo "FAIL $1 $2"; nf=$((nf + 1)); }
unav() { echo "UNAVAILABLE $1 $2"; nu=$((nu + 1)); }
info() { echo "# $*"; }

mkdir -p "$OUT" || { echo "FAIL runner.out_dir cannot create $OUT"; exit 1; }

# relay <file>: copy PASS/FAIL/UNAVAILABLE lines of a child program to stdout and count them.
# Prints informational '# ' lines too. Returns nothing; sets RELAY_P/RELAY_F.
relay() {
  RELAY_P=0; RELAY_F=0
  while IFS= read -r l; do
    case "$l" in
      PASS\ *)  echo "$l"; RELAY_P=$((RELAY_P + 1)); np=$((np + 1)) ;;
      FAIL\ *)  echo "$l"; RELAY_F=$((RELAY_F + 1)); nf=$((nf + 1)) ;;
      UNAVAILABLE\ *) echo "$l"; nu=$((nu + 1)) ;;
      '#'*)     echo "$l" ;;
    esac
  done < "$1"
}

# ---- 1. Fortran build ---------------------------------------------------------------------
BUILD_OK=0
if ! command -v gfortran >/dev/null 2>&1 && [ ! -x /usr/bin/gfortran ]; then
  unav fortran.build "gfortran not found (fortran/causal/Makefile uses /usr/bin/gfortran)"
elif make -C "$FDIR" all >"$OUT/fortran-build.log" 2>&1; then
  pass fortran.build
  BUILD_OK=1
else
  fail fortran.build "make -C fortran/causal all failed; see tests/causal/out/fortran-build.log"
fi

# ---- 2. Fortran tests ---------------------------------------------------------------------
if [ "$BUILD_OK" = 1 ]; then
  rm -f "$FIXTURE" "$FIXTURE.commit"      # a stale fixture must never satisfy Curry or Self
  for t in $TESTS; do
    ( cd "$HERE" && "$BLD/$t" ) >"$OUT/$t.stdout" 2>"$OUT/$t.stderr"
    rc=$?
    relay "$OUT/$t.stdout"
    if ! grep -q "^# $t: [0-9]* passed, [0-9]* failed" "$OUT/$t.stdout"; then
      fail "fortran.$t.completed" "no summary line (exit $rc); see tests/causal/out/$t.stderr"
    elif [ "$rc" -ne 0 ] && [ "$RELAY_F" -eq 0 ]; then
      fail "fortran.$t.exit" "exit $rc without a FAIL line; see tests/causal/out/$t.stderr"
    fi
  done
else
  info "Fortran tests not run: build did not succeed"
fi

# ---- 3. Curry -----------------------------------------------------------------------------
# Discovery order (first usable wins; the explicit environment variables come first, then the
# repository/tool-directory paths that earlier versions of this runner used):
#   LRD_PAKCS, PAKCS (a pakcs executable, or an install directory holding bin/pakcs),
#   PAKCSHOME/bin/pakcs, `pakcs` on PATH, $ROOT/build/tools/pakcs-<ver>/bin/pakcs,
#   $LRD_SHARED_TOOLS/pakcs-<ver>/bin/pakcs, /workspace/_causal_tools/pakcs-<ver>/bin/pakcs.
# A candidate must (a) be executable, (b) exit 0 from --numeric-version and print $REQ_PAKCS,
# (c) evaluate 1+1. (b) is version-matched; (c) catches an installed PAKCS whose saved Prolog
# state does not match the Prolog system (the repo-tracked build/tools PAKCS fails like this).
# Each probe runs in its own subshell with stdout and stderr in files under out/ and the
# shell job messages (the bare "Aborted" an incompatible PAKCS provokes under sh) discarded:
# the "; exit $?" makes the subshell report the death itself, to /dev/null, instead of the runner.
# Nothing is hidden: the exit status and the first line of the probe's own output go into the
# reason, which becomes the UNAVAILABLE text when no candidate works, and a candidate that was
# skipped before a later one worked is printed as an informational "# curry: skipped" line.
ENV_PAKCS="${PAKCS:-}"
PAKCS_BIN=""
WHY=""; LASTWHY=""
sigtxt() { # sigtxt <rc>: say so when the status means "killed by a signal"
  if [ "$1" -gt 128 ]; then echo "exit $1 (signal $(($1 - 128)))"; else echo "exit $1"; fi
}
firstline() { head -c 200 "$1" 2>/dev/null | tr '\n\t' '  '; }
try_pakcs() {
  local c="$1" v prc w
  [ -n "$c" ] || return 1
  [ -d "$c" ] && c="$c/bin/pakcs"
  if [ ! -x "$c" ]; then w="$c: not executable"; WHY="$WHY; $w"; LASTWHY="$w"; return 1; fi
  ( "$c" --numeric-version </dev/null >"$OUT/pakcs-probe.out" 2>"$OUT/pakcs-probe.err"; exit $? ) 2>/dev/null
  prc=$?
  v=$(head -n 1 "$OUT/pakcs-probe.out")
  if [ "$prc" -ne 0 ] || [ "$v" != "$REQ_PAKCS" ]; then
    w="$c: --numeric-version gave '${v:-none}', $(sigtxt "$prc"), stderr: $(firstline "$OUT/pakcs-probe.err")"
    WHY="$WHY; $w"; LASTWHY="$w"; return 1
  fi
  ( "$c" -q :eval "1+1" :quit </dev/null >"$OUT/pakcs-probe.out" 2>&1; exit $? ) 2>/dev/null
  prc=$?
  if ! head -n 5 "$OUT/pakcs-probe.out" | grep -q '^2$'; then
    w="$c: cannot evaluate 1+1, $(sigtxt "$prc"), output: $(firstline "$OUT/pakcs-probe.out")"
    WHY="$WHY; $w"; LASTWHY="$w"; return 1
  fi
  return 0
}
for c in "${LRD_PAKCS:-}" "$ENV_PAKCS" "${PAKCSHOME:+$PAKCSHOME/bin/pakcs}" \
         "$(command -v pakcs 2>/dev/null || true)" \
         "$ROOT/build/tools/pakcs-$REQ_PAKCS/bin/pakcs" \
         "$SHARED/pakcs-$REQ_PAKCS/bin/pakcs" \
         "/workspace/_causal_tools/pakcs-$REQ_PAKCS/bin/pakcs"; do
  [ -n "$c" ] || continue
  if try_pakcs "$c"; then
    PAKCS_BIN="$c"; [ -d "$c" ] && PAKCS_BIN="$c/bin/pakcs"; break
  else
    [ -e "$c" ] && info "curry: skipped candidate $LASTWHY"
  fi
done

if [ -z "$PAKCS_BIN" ]; then
  unav curry.causal_graph "no usable PAKCS $REQ_PAKCS (nothing was run)${WHY}"
elif [ ! -f "$FIXTURE" ]; then
  unav curry.causal_graph "fixture $FIXTURE not produced by the Fortran step (nothing was run)"
else
  info "curry: PAKCS $REQ_PAKCS at $PAKCS_BIN"
  CR="$OUT/curry-run"
  rm -rf "$CR"; mkdir -p "$CR/out"
  cp "$ROOT"/curry/causal/*.curry "$CR/"
  cp "$FIXTURE" "$CR/out/"
  ( cd "$CR" && timeout "${LRD_CURRY_TIMEOUT:-900}" "$PAKCS_BIN" -q :load TestCausalGraph :eval main :quit </dev/null ) \
     >"$OUT/curry.stdout" 2>"$OUT/curry.stderr"
  rc=$?
  relay "$OUT/curry.stdout"
  if ! grep -q '^# curry: [0-9]* passed, [0-9]* failed' "$OUT/curry.stdout"; then
    fail curry.completed "no summary line (pakcs exit $rc); see tests/causal/out/curry.stderr"
  elif [ "$rc" -ne 0 ] && [ "$RELAY_F" -eq 0 ]; then
    fail curry.exit "pakcs exit $rc without a FAIL line; see tests/causal/out/curry.stderr"
  fi
fi

# ---- 4. Self ------------------------------------------------------------------------------
# Discovery order (first usable wins): LRD_SELF_VM, SELF_VM, SELF_VM_PATH (a Self executable, or
# a directory holding one named Self), `Self` on PATH, then $ROOT/build/tools/self-src/build32/vm/Self,
# $LRD_SHARED_TOOLS/self-src/build32/vm/Self, /workspace/_self_tools/build/vm/Self,
# /workspace/_causal_tools/self-src/build32/vm/Self.
# World snapshot: LRD_SELF_WORLD, SELF_WORLD, then /workspace/_self_tools/world/morphic.snap;
# without any snapshot the world is built from the objects/ directory next to the VM's source.
ENV_SELF_VM="${SELF_VM:-}"; ENV_SELF_WORLD="${SELF_WORLD:-}"
SELF_BIN=""; SELF_WLD=""; SELF_OBJ=""; SWHY=""
for c in "${LRD_SELF_VM:-}" "$ENV_SELF_VM" "${SELF_VM_PATH:-}" \
         "$(command -v Self 2>/dev/null || true)" \
         "$ROOT/build/tools/self-src/build32/vm/Self" "$SHARED/self-src/build32/vm/Self" \
         /workspace/_self_tools/build/vm/Self /workspace/_causal_tools/self-src/build32/vm/Self; do
  [ -n "$c" ] || continue
  [ -d "$c" ] && c="$c/Self"
  if [ -f "$c" ] && [ -x "$c" ]; then SELF_BIN="$c"; break; else SWHY="$SWHY; $c: not an executable file"; fi
done
if [ -n "$SELF_BIN" ]; then
  for w in "${LRD_SELF_WORLD:-}" "$ENV_SELF_WORLD" /workspace/_self_tools/world/morphic.snap; do
    [ -n "$w" ] && [ -f "$w" ] && { SELF_WLD="$w"; break; }
  done
  o="$(cd "$(dirname "$SELF_BIN")/../../objects" 2>/dev/null && pwd)"
  [ -n "$o" ] && [ -f "$o/worldBuilder.self" ] && SELF_OBJ="$o"
fi
if [ -z "$SELF_BIN" ]; then
  unav self.causal_graph "no Self VM found (nothing was run)${SWHY}"
elif [ -z "$SELF_WLD" ] && [ -z "$SELF_OBJ" ]; then
  unav self.causal_graph "Self VM $SELF_BIN found, but neither a morphic world snapshot nor its objects/worldBuilder.self (nothing was run)"
elif [ ! -f "$FIXTURE" ]; then
  unav self.causal_graph "fixture $FIXTURE not produced by the Fortran step (nothing was run)"
else
  export CAUSAL_SELF_DIR="$ROOT/self/causal" CAUSAL_FIXTURE="$FIXTURE"
  if [ -n "$SELF_WLD" ]; then
    info "self: VM $SELF_BIN, snapshot $SELF_WLD"
    timeout "${LRD_SELF_TIMEOUT:-300}" "$SELF_BIN" -s "$SELF_WLD" -f "$ROOT/self/causal/testCausalGraph.self" \
      </dev/null >"$OUT/self.stdout" 2>&1
    rc=$?
  else
    info "self: VM $SELF_BIN, world built from $SELF_OBJ (no snapshot)"
    ( cd "$SELF_OBJ" && timeout "${LRD_SELF_TIMEOUT:-300}" "$SELF_BIN" -f worldBuilder.self -b . -o morphic \
        -f2 "$ROOT/self/causal/testCausalGraph.self" </dev/null ) >"$OUT/self.stdout" 2>&1
    rc=$?
  fi
  relay "$OUT/self.stdout"
  if ! grep -q '^# self: [0-9]* passed, [0-9]* failed' "$OUT/self.stdout"; then
    fail self.completed "no summary line (exit $rc); see tests/causal/out/self.stdout (stdout and stderr merged)"
  elif [ "$rc" -ne 0 ] && [ "$RELAY_F" -eq 0 ]; then
    fail self.exit "Self exit $rc without a FAIL line; see tests/causal/out/self.stdout"
  fi
fi

echo "# summary: $np PASS, $nf FAIL, $nu UNAVAILABLE"
[ "$nf" -eq 0 ]
