#!/bin/sh
# SPDX-License-Identifier: AGPL-3.0-only
# Also subject to SNAPKITTY_OPAQUE_LICENSE.md (dual license, see repository root).
#
# QSO1 growth track tests (Mission QSO1-DCBH-001 roles 04/07/08/10).
# Prints PASS / FAIL / UNAVAILABLE lines (research/CONTRACTS.md).
# Sections: Fortran solver + benchmark + sweep dataset, commitment
# (independent coreutils check), Curry classification, Agda certificate,
# Self/Morphic front end (headless; GUI when Xvfb + import are present).
set -u
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
HERE="$ROOT/tests/growth"
EVD="$HERE/evidence"
mkdir -p "$EVD" "$ROOT/fixtures/growth"
BIN="$ROOT/build/out/bin/lrd_growth_sweep"
CSV="$ROOT/fixtures/growth/feasible_grid.csv"
REC="$ROOT/fixtures/growth/feasible_grid.rec"
NFAIL=0
pass() { echo "PASS $1"; }
fail() { echo "FAIL $1 $2"; NFAIL=$((NFAIL + 1)); }
unav() { echo "UNAVAILABLE $1 $2"; }
inrange() { awk -v v="$1" -v lo="$2" -v hi="$3" 'BEGIN { exit !(v >= lo && v <= hi) }'; }
getval() { grep "^$1=" "$2" | cut -d= -f2 | tr -d ' '; }

# ---------------------------------------------------------------- Fortran
if ! command -v gfortran >/dev/null 2>&1; then
  unav growth_fortran "no gfortran on PATH"
else
  if ( cd "$ROOT/fortran/growth" && make FC=gfortran > "$EVD/fortran_build.log" 2>&1 ); then
    pass growth_build_fortran
  else
    fail growth_build_fortran "make failed, see tests/growth/evidence/fortran_build.log"
  fi
  if [ -x "$BIN" ]; then
    "$BIN" benchmark > "$EVD/benchmark.txt" 2>&1
    B="$EVD/benchmark.txt"
    inrange "$(getval t_edd_myr "$B")" 449 452 \
      && pass growth_t_edd_near_450myr || fail growth_t_edd_near_450myr "t_edd=$(getval t_edd_myr "$B")"
    inrange "$(getval dt_myr "$B")" 570 582 \
      && pass growth_dt_near_576myr || fail growth_dt_near_576myr "dt=$(getval dt_myr "$B")"
    inrange "$(getval min_seed_msun "$B")" 480 525 \
      && pass growth_min_seed_near_497 || fail growth_min_seed_near_497 "seed=$(getval min_seed_msun "$B")"
    inrange "$(getval required_lambda_seed100 "$B")" 1.128 1.150 \
      && pass growth_required_lambda_near_1139 || fail growth_required_lambda_near_1139 "lam=$(getval required_lambda_seed100 "$B")"
    awk -v v="$(getval mdot_edd_benchmark "$B")" 'BEGIN { exit !(v == 10) }' \
      && pass growth_mdot_is_lam_over_eps || fail growth_mdot_is_lam_over_eps "mdot=$(getval mdot_edd_benchmark "$B")"
    "$BIN" selfcheck > "$EVD/selfcheck.txt" 2>&1
    S="$EVD/selfcheck.txt"
    awk -v v="$(getval rk4_rel_diff "$S")" 'BEGIN { exit !(v < 1e-6) }' \
      && pass growth_rk4_matches_stepped || fail growth_rk4_matches_stepped "rk4=$(getval rk4_rel_diff "$S")"
    awk -v v="$(getval step_rel_diff "$S")" 'BEGIN { exit !(v < 1e-4) }' \
      && pass growth_step_converged || fail growth_step_converged "step=$(getval step_rel_diff "$S")"
    awk -v v="$(getval sat_ratio_lam3 "$S")" 'BEGIN { exit !(v < 1) }' \
      && pass growth_saturation_slower_superedd || fail growth_saturation_slower_superedd "ratio=$(getval sat_ratio_lam3 "$S")"
    awk -v v="$(getval sat_ratio_lam05 "$S")" 'BEGIN { exit !(v == 1) }' \
      && pass growth_saturation_identity_subedd || fail growth_saturation_identity_subedd "ratio=$(getval sat_ratio_lam05 "$S")"
    # sweep dataset
    "$BIN" sweep "$CSV" "$REC" > "$EVD/sweep.txt" 2>&1
    ROWS=$(awk 'END { print NR - 1 }' "$CSV")
    [ "$ROWS" = "1200" ] && pass growth_sweep_1200_rows || fail growth_sweep_1200_rows "rows=$ROWS"
    FS=$(awk -F, 'NR > 1 { s += $11 } END { print s }' "$CSV")
    FT=$(awk -F, 'NR > 1 { s += $12 } END { print s }' "$CSV")
    [ "$FS" = "464" ] && pass growth_feasible_simple_464 || fail growth_feasible_simple_464 "count=$FS"
    [ "$FT" = "382" ] && pass growth_feasible_sat_382 || fail growth_feasible_sat_382 "count=$FT"
    # commitment, recomputed independently with coreutils sha256sum
    WANT=$(cat "$REC.commit")
    GOT=$((printf 'LRD-COMMIT-v1\0'; cat "$REC") | sha256sum | cut -d' ' -f1)
    [ "$GOT" = "$WANT" ] && pass growth_rec_commitment_sha256 || fail growth_rec_commitment_sha256 "got=$GOT want=$WANT"
  fi
fi

# ---------------------------------------------------------------- Curry
PAKCS=""
for CAND in "$ROOT/build/tools/pakcs-3.10.0/bin/pakcs" "$(command -v pakcs 2>/dev/null)"; do
  if [ -n "$CAND" ] && [ -x "$CAND" ]; then PAKCS="$CAND"; break; fi
done
if [ -z "$PAKCS" ]; then
  unav growth_curry "no PAKCS (build/install-curry-self.sh)"
elif [ ! -f "$REC" ]; then
  unav growth_curry "growth record missing (Fortran section did not run)"
else
  ( cd "$ROOT" && timeout 1200 "$PAKCS" -q \
      :load curry/growth/TestGrowthClassify.curry \
      :eval "mainAt \"$REC\"" :quit ) \
    > "$EVD/curry_run.log" 2>&1
  if grep -qE '^(PASS|FAIL) curry\.' "$EVD/curry_run.log"; then
    grep -E '^(PASS|FAIL) ' "$EVD/curry_run.log" || true
    NFAIL=$((NFAIL + $(grep -c '^FAIL ' "$EVD/curry_run.log")))
    grep -q CURRY_GROWTH_DONE "$EVD/curry_run.log" \
      && pass growth_curry_completed || fail growth_curry_completed "see evidence/curry_run.log"
  else
    fail growth_curry_build "pakcs did not run the classifier, see evidence/curry_run.log"
  fi
fi

# ---------------------------------------------------------------- Agda
if ! command -v agda >/dev/null 2>&1; then
  unav growth_agda "no agda on PATH"
else
  STDLIB_INC=""
  [ -d /usr/share/agda-stdlib ] && STDLIB_INC="-i/usr/share/agda-stdlib"
  if [ -n "$STDLIB_INC" ]; then
    ( cd "$ROOT/agda/growth" && LC_ALL=C.UTF-8 timeout 1200 agda -i. $STDLIB_INC Growth.agda ) \
      > "$EVD/agda.log" 2>&1
    [ $? -eq 0 ] && pass growth_agda_typechecks \
      || fail growth_agda_typechecks "see evidence/agda.log"
  else
    unav growth_agda "agda-stdlib not found under /usr/share/agda-stdlib"
  fi
fi

# ---------------------------------------------------------------- Self
SELFBIN=""
for CAND in "$ROOT/build/tools/self-src/build32/vm/Self" /workspace/_topology_tools/self-src/build32/vm/Self /workspace/_causal_tools/self-src/build32/vm/Self; do
  if [ -x "$CAND" ]; then SELFBIN="$CAND"; break; fi
done
if [ -z "$SELFBIN" ]; then
  unav growth_self_headless "no built Self VM (build/install-curry-self.sh)"
  unav growth_self_gui "no built Self VM"
elif [ ! -f "$REC" ]; then
  unav growth_self_headless "growth record missing (Fortran section did not run)"
  unav growth_self_gui "growth record missing"
else
  SELFOBJ="$(cd "$(dirname "$SELFBIN")/../../objects" && pwd)"
  ( cd "$SELFOBJ" && GROWTH_SELF_DIR="$ROOT/self/growth" GROWTH_TOPO_DIR="$ROOT/self/topology" \
      GROWTH_REC="$REC" timeout 300 "$SELFBIN" -f worldBuilder.self -b . -o none \
      -f2 "$HERE/self_headless_growth.self" < /dev/null ) > "$EVD/self_headless_full.log" 2>&1
  SRC=$?
  [ $SRC -eq 0 ] && pass growth_self_headless_exit || fail growth_self_headless_exit "exit $SRC, see evidence/self_headless_full.log"
  grep -E '^(PASS|FAIL|SELF) ' "$EVD/self_headless_full.log" > "$EVD/self_headless.log" || true
  grep -E '^(PASS|FAIL) ' "$EVD/self_headless.log" || true
  NFAIL=$((NFAIL + $(grep -c '^FAIL ' "$EVD/self_headless.log")))
  grep -q SELF_GROWTH_DONE "$EVD/self_headless_full.log" \
    && pass growth_self_headless_completed || fail growth_self_headless_completed "see evidence/self_headless_full.log"
  # Self-read counts must equal the CSV counts (cross-implementation check)
  SLINE=$(grep '^SELF GROWTH ' "$EVD/self_headless.log" | head -1)
  SFS=$(echo "$SLINE" | sed 's/.*feasible_simple=\([0-9]*\).*/\1/')
  SFT=$(echo "$SLINE" | sed 's/.*feasible_sat=\([0-9]*\).*/\1/')
  if [ -n "$FS" ] && [ "$SFS" = "$FS" ] && [ "$SFT" = "$FT" ]; then
    pass growth_self_counts_equal_fortran
  else
    fail growth_self_counts_equal_fortran "self=$SFS/$SFT csv=$FS/$FT"
  fi
  # GUI under Xvfb (pattern from tests/topology/run.sh)
  if command -v Xvfb >/dev/null && command -v import >/dev/null; then
    DNUM=""
    for D in $(seq 160 179); do
      if [ ! -e "/tmp/.X$D-lock" ]; then DNUM=":$D"; break; fi
    done
    if [ -n "$DNUM" ]; then
      Xvfb "$DNUM" -screen 0 560x620x24 > "$EVD/xvfb.log" 2>&1 &
      XPID=$!
      sleep 2
      FIFO="$HERE/build_gui.fifo"; rm -f "$FIFO"; mkfifo "$FIFO"
      ( cd "$SELFOBJ" && DISPLAY="$DNUM" GROWTH_SELF_DIR="$ROOT/self/growth" \
          GROWTH_TOPO_DIR="$ROOT/self/topology" GROWTH_REC="$REC" \
          exec timeout 300 "$SELFBIN" -f worldBuilder.self -b . -o morphic \
          -f2 "$ROOT/self/growth/gui_demo_growth.self" < "$FIFO" ) > "$EVD/self_gui_full.log" 2>&1 &
      SPID=$!
      exec 7>"$FIFO"
      for _ in $(seq 1 100); do sleep 2; grep -q "Scheduler started" "$EVD/self_gui_full.log" && break; done
      sleep 2; echo "growthGuiDemo run" >&7
      for _ in $(seq 1 40); do sleep 2; grep -q "GUI_GROWTH_DONE" "$EVD/self_gui_full.log" && break; done
      sleep 5
      DISPLAY="$DNUM" import -window root "$EVD/self_morphic_growth.png" > /dev/null 2>&1
      exec 7>&-
      kill "$SPID" 2>/dev/null; kill "$XPID" 2>/dev/null
      rm -f "$FIFO"
      grep -q GUI_GROWTH_DONE "$EVD/self_gui_full.log" \
        && pass growth_self_gui_demo || fail growth_self_gui_demo "see evidence/self_gui_full.log"
      [ -s "$EVD/self_morphic_growth.png" ] \
        && pass growth_self_gui_screenshot || fail growth_self_gui_screenshot "no screenshot captured"
    else
      unav growth_self_gui "no free X display in :160-:179"
    fi
  else
    unav growth_self_gui "no Xvfb or ImageMagick import"
  fi
fi

echo "growth: failures=$NFAIL"
[ "$NFAIL" -eq 0 ]
