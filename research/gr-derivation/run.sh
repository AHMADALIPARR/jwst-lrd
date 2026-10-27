#!/usr/bin/env bash
# SPDX-License-Identifier: AGPL-3.0-only
# Runs every independent check, prints PASS/FAIL lines and exact counts, writes results.txt.
# Tools used: Maxima (symbolic), GNU Octave (numeric; NOT MATLAB), gfortran (Fortran 2018), bc, awk (mawk).
# No Python/JS/TS is used. Lean/Agda/Coq were NOT used (no formal proof is claimed).
cd "$(dirname "$0")"
OUT="$PWD/results.txt"
: > "$OUT"
say() { echo "$@" | tee -a "$OUT"; }

say "== GR derivation checks: $(date -Is) =="
say "Scope: mathematical derivation of a model - not empirical evidence about QSO1 and not an explanation of the z=7.04221 vs 7.0451 discrepancy."

# ---- locate Maxima -------------------------------------------------------------------------
MAXIMA=""
if command -v maxima >/dev/null 2>&1; then
  MAXIMA="$(command -v maxima)"
elif [ -x "$HOME/tools/maxroot/usr/bin/maxima" ]; then
  export MAXIMA_PREFIX="$HOME/tools/maxroot/usr"
  MAXIMA="$MAXIMA_PREFIX/bin/maxima"
fi
have() { command -v "$1" >/dev/null 2>&1; }
say "tool maxima : ${MAXIMA:-UNAVAILABLE (run ./bootstrap_maxima.sh)} $( [ -n "$MAXIMA" ] && "$MAXIMA" --version 2>/dev/null | head -1 )"
say "tool octave : $(have octave && octave --version | head -1 || echo UNAVAILABLE)"
say "tool gfortran: $(have gfortran && gfortran --version | head -1 || echo UNAVAILABLE)"
say "tool bc     : $(have bc && echo available || echo UNAVAILABLE)"
say "tool awk    : $(have awk && (awk -W version 2>&1 | head -1) || echo UNAVAILABLE)"
say "tool lean/agda/coq: NOT USED (no formal proof attempted or claimed)"
say "tool sympy/python: NOT USED (forbidden)"
say ""

run() { # run <label> <command...>; appends output (PASS/FAIL and informational lines) to results
  say "-- $1"
  shift
  "$@" 2>&1 | grep -vE "SIMPLE-WARNING|CL-INFO|^$|^\(Details" | grep -E "^(PASS|FAIL)|^   |^  [A-Za-z]|rror|rs\(1|rho=|M=1e|z_grav|c\*z|rho_|^ +r=" | tee -a "$OUT"
}

if [ -n "$MAXIMA" ]; then
  for f in checks/maxima/0[1-6]_*.mac; do
    ( cd checks/maxima && run "maxima $(basename "$f")" "$MAXIMA" --very-quiet --batch="$(basename "$f")" )
  done
else
  say "FAIL  maxima symbolic checks : UNAVAILABLE (0 run)"
fi

have octave && ( cd checks/octave && run "octave numeric_kruskal.m" octave -q numeric_kruskal.m ) || say "FAIL  octave : UNAVAILABLE"
if have gfortran; then
  ( cd checks/fortran && gfortran -std=f2018 -Wall -Wextra -O1 -o redshift_er redshift_er.f90 && run "fortran redshift_er.f90" ./redshift_er )
else
  say "FAIL  fortran : UNAVAILABLE"
fi
if have bc; then ( cd checks/arith && say "-- bc redshift_table.bc (informational values, arbitrary precision)" && BC_LINE_LENGTH=0 bc -l redshift_table.bc 2>&1 | tee -a "$OUT" ); fi
have awk && ( cd checks/arith && run "awk redshift_check.awk" awk -f redshift_check.awk )

# ---- tally ---------------------------------------------------------------------------------
say ""
NP=$(grep -c '^PASS' "$OUT"); NF=$(grep -c '^FAIL' "$OUT")
SUMS=$(grep -E '^(PASS|FAIL)' "$OUT" | sed -E 's/.* : ([0-9]+)\/([0-9]+)$/\1 \2/' | awk '{a+=$1; b+=$2} END{print a" of "b}')
say "SUMMARY: ${NP} PASS lines, ${NF} FAIL lines; individual checks passed: ${SUMS}"
[ "$NF" -eq 0 ] && [ "$NP" -gt 0 ]
