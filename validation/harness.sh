#!/bin/bash
# SPDX-License-Identifier: AGPL-3.0-only
# Also licensed under the SnapKitty Opaque License; see LICENSE and
# SNAPKITTY_OPAQUE_LICENSE.md at the repository root.
#
# validation/harness.sh - cross-language differential harness (sh + C).
# Compares LRD-ARR-v1 outputs of lrdc-compiled LRD-IR programs against reference
# outputs from other tracks, using the per-op tolerances in validation/tolerances.tsv
# (mirrors validation/FP_POLICY.md) via validation/lrdcmp.c.
# Prints PASS <name> | FAIL <name> <why> | UNAVAILABLE <name> <reason>; exit 1 only on FAIL.
#
# References (consumed, never edited):
#   fortran_t001   fortran/ on branch t001-ingest-fortran (Foundry J Spec)  [acceptance]
#   futhark        futhark/ committed on branch agent2-futhark (git archive -> temp build)
#   fortran_fut    tests/futhark/fortran-ref committed on agent2-futhark (gfortran, temp build)
#   matlab, sas    licensed toolchains
set -u
ROOT=$(cd "$(dirname "$0")/.." && pwd)
V=$ROOT/validation
TOL=$V/tolerances.tsv
REPO=${LRD_REPO:-/workspace/jwst-lrd}
T=$(mktemp -d "${TMPDIR:-/tmp}/lrd-val.XXXXXX")
trap 'rm -rf "$T"' EXIT
NFAIL=0
pass() { echo "PASS $1"; }
fail() { echo "FAIL $1 $2"; NFAIL=$((NFAIL + 1)); }
unav() { echo "UNAVAILABLE $1 $2"; }
oneline() { tr '\n' ' ' | cut -c1-300; }

# ------------------------------------------------------------------ toolchains
if ! "$ROOT/llvm/check_toolchain.sh" > "$T/pin.txt"; then
  cat "$T/pin.txt"; unav validation_suite "LLVM toolchain does not match llvm/toolchain.pin"; exit 0
fi
pass toolchain_llvm_pinned
for t in gfortran futhark matlab sas; do
  p=$(command -v "$t" 2>/dev/null)
  if [ -n "$p" ]; then pass "tool_present_$t"
  else
    case $t in
      matlab) unav tool_present_matlab "matlab not on PATH (licensed MathWorks product, not installed; GNU Octave $(command -v octave >/dev/null && echo 'is present but is not MATLAB' || echo 'also absent'))";;
      sas) unav tool_present_sas "sas not on PATH (licensed SAS Institute product, not installed)";;
      *) unav "tool_present_$t" "$t not on PATH";;
    esac
  fi
done

# ------------------------------------------------------------------ build lrdc + helpers
CC=/usr/bin/clang
CF="-std=c17 -O2 -Wall -Wextra -Werror -ffp-contract=off -fno-fast-math"
B=$T/build; mkdir -p "$B" "$T/d" "$T/o"
if out=$(make -s -C "$ROOT/llvm" OUT="$B" 2>&1); then pass build_lrdc; else fail build_lrdc "$(echo "$out" | oneline)"; exit 1; fi
LRDC=$B/lrdc
for h in "lrdcmp $V/lrdcmp.c $ROOT/abi/lrd_num_abi.c" "gen_synth $ROOT/tests/llvm/helpers/gen_synth.c" "fp_probe $V/fp_probe.c"; do
  set -- $h; n=$1; shift
  out=$($CC $CF -o "$B/$n" "$@" -lm 2>&1) || { fail "build_$n" "$(echo "$out" | oneline)"; exit 1; }
done
pass build_harness_helpers

# ------------------------------------------------------------------ FP policy enforcement
r=$("$B/fp_probe"); if [ "$r" = ok ]; then pass fp_policy_env_binary64_rne; else fail fp_policy_env_binary64_rne "$r"; fi
bad=""
for p in "$ROOT"/tests/llvm/programs/*.lrd "$V"/programs/*.lrd; do
  n=$(basename "$p" .lrd)
  "$LRDC" -S -o "$T/o/fp_$n.ll" "$p" 2>"$T/o/fp_$n.err" || { bad="$bad $n(compile:$(oneline < "$T/o/fp_$n.err"))"; continue; }
  grep -nEw 'fast|contract|reassoc|nnan|ninf|nsz|arcp|afn' "$T/o/fp_$n.ll" > "$T/o/fp_$n.hits" && bad="$bad $n:$(head -n 1 "$T/o/fp_$n.hits")"
done
if [ -z "$bad" ]; then pass fp_policy_ll_no_fastmath_or_contract_flags; else fail fp_policy_ll_no_fastmath_or_contract_flags "$bad"; fi
cfl=$(make -s -C "$ROOT/llvm" print-cflags)
cfl_stripped=$(echo " $cfl " | sed 's/ -fno-fast-math / /g')
if [ "${cfl#*-ffp-contract=off}" = "$cfl" ]; then fail fp_policy_build_flags "-ffp-contract=off missing from: $cfl"
elif echo "$cfl_stripped" | grep -qE 'fast-math|Ofast|finite-math|unsafe-math|ffp-contract=(on|fast)'; then fail fp_policy_build_flags "forbidden flag in: $cfl"
else pass fp_policy_build_flags; fi
if grep -aq -- '--fp-contract=off' "$LRDC" && grep -aq -- '-ffp-contract=off' "$LRDC" && grep -aq -- '-fno-fast-math' "$LRDC"; then
  pass fp_policy_lrdc_invokes_llc_clang_contract_off
else fail fp_policy_lrdc_invokes_llc_clang_contract_off "lrdc binary lacks the llc/clang fp-contract=off arguments"; fi
"$LRDC" -o "$T/o/fp_full" "$ROOT/tests/llvm/programs/full.lrd" >/dev/null 2>&1
nf=$( { objdump -d "$B/liblrdrt.a"; objdump -d "$T/o/fp_full"; } 2>/dev/null | grep -cE '\svfn?m(add|sub)[0-9]*[sp]d' )
if [ -s "$T/o/fp_full" ] && [ "$nf" = 0 ]; then pass fp_policy_no_fma_instructions; else fail fp_policy_no_fma_instructions "found $nf FMA instructions (or build failed)"; fi
# table in FP_POLICY.md must equal tolerances.tsv (the file the harness uses)
awk -F'|' '/^\| *[a-z_0-9]+ *\| *[0-9.e+-]+ *\| *[0-9.e+-]+ *\|/ {gsub(/ /,"",$2);gsub(/ /,"",$3);gsub(/ /,"",$4); print $2"\t"$3"\t"$4}' "$V/FP_POLICY.md" | sort > "$T/tol_md"
grep -v '^#' "$TOL" | awk 'NF==3{print $1"\t"$2"\t"$3}' | sort > "$T/tol_tsv"
if [ -s "$T/tol_md" ] && cmp -s "$T/tol_md" "$T/tol_tsv"; then pass fp_policy_table_matches_tolerances_tsv
else fail fp_policy_table_matches_tolerances_tsv "FP_POLICY.md table and tolerances.tsv differ: $(diff "$T/tol_md" "$T/tol_tsv" | oneline)"; fi

# ------------------------------------------------------------------ inputs
D=$T/d; O=$T/o
"$B/gen_synth" "$D" || { fail gen_synth "failed"; exit 1; }
BR1=t001-ingest-fortran
h1=$(git -C "$REPO" rev-parse --short "$BR1" 2>/dev/null)
cur=$(git -C "$REPO" show "$BR1:fixtures/ingest/CURRENT" 2>/dev/null | head -n 1)
REAL=""
if [ -n "$cur" ] && git -C "$REPO" show "$BR1:fixtures/ingest/$cur/wavelength.hdr" > "$D/REAL_wavelength.hdr" 2>/dev/null &&
   git -C "$REPO" show "$BR1:fixtures/ingest/$cur/wavelength.f64" > "$D/REAL_wavelength.f64" 2>/dev/null &&
   grep -qx 'unit=um' "$D/REAL_wavelength.hdr"; then
  REAL=$D/REAL_wavelength
  pass input_real_jwst_wavelength
else
  unav input_real_jwst_wavelength "no committed fixtures/ingest/CURRENT wavelength (unit um) on $BR1"
fi

# ------------------------------------------------------------------ lrdc outputs
for p in restframe convert residuals chi2; do
  "$LRDC" -o "$B/v_$p" "$V/programs/v_$p.lrd" > "$O/c_$p.txt" 2>&1 || { fail "compile_v_$p" "$(oneline < "$O/c_$p.txt")"; exit 1; }
done
pass compile_validation_programs
# cases: name op lrdc-args... ; references are invoked with the same CLI (lrd-fut / lrdref)
lrdc_run() { # case
  case $1 in
    restframe_synth) "$B/v_restframe" "$D/SYNTHETIC_lam_um" "$O/lrdc_$1";;
    convert_synth)   "$B/v_convert" "$D/SYNTHETIC_lam_um" "$O/lrdc_$1";;
    residuals_synth) "$B/v_residuals" "$D/SYNTHETIC_flux" "$D/SYNTHETIC_model" "$O/lrdc_$1";;
    chi2_synth)      "$B/v_chi2" "$D/SYNTHETIC_flux" "$D/SYNTHETIC_model" "$D/SYNTHETIC_sigma" "$O/lrdc_$1";;
    restframe_real)  "$B/v_restframe" "$REAL" "$O/lrdc_$1";;
    convert_real)    "$B/v_convert" "$REAL" "$O/lrdc_$1";;
  esac
}
ref_run() { # tool case outprefix
  local x=$1
  case $2 in
    restframe_synth) "$x" rest 5.0 "$D/SYNTHETIC_lam_um" "$3";;
    convert_synth)   "$x" um2a "$D/SYNTHETIC_lam_um" "$3";;
    residuals_synth) "$x" resid "$D/SYNTHETIC_flux" "$D/SYNTHETIC_model" "$3";;
    chi2_synth)      "$x" chi2 "$D/SYNTHETIC_flux" "$D/SYNTHETIC_model" "$D/SYNTHETIC_sigma" "$3";;
    restframe_real)  "$x" rest 5.0 "$REAL" "$3";;
    convert_real)    "$x" um2a "$REAL" "$3";;
  esac
}
CASES="restframe_synth convert_synth residuals_synth chi2_synth"
[ -n "$REAL" ] && CASES="$CASES restframe_real convert_real"
for c in $CASES; do
  lrdc_run "$c" > "$O/lr_$c.txt" 2>&1 || fail "lrdc_$c" "$(oneline < "$O/lr_$c.txt")"
done

compare_ref() { # refname tool
  local rn=$1 tool=$2 c op r
  for c in $CASES; do
    op=${c%_*}
    if ! ref_run "$tool" "$c" "$O/${rn}_$c" > "$O/${rn}_$c.txt" 2>&1; then
      unav "${rn}_vs_lrdc_$c" "reference run failed: $(oneline < "$O/${rn}_$c.txt")"; continue
    fi
    if r=$("$B/lrdcmp" --require-finite --tol-file "$TOL" --op "$op" "$O/lrdc_$c" "$O/${rn}_$c" 2>&1); then pass "${rn}_vs_lrdc_$c"
    else fail "${rn}_vs_lrdc_$c" "$r"; fi
  done
}

# ------------------------------------------------------------------ reference: Fortran (t001, acceptance)
# Foundry J Spec's committed reference outputs fixtures/reference/<CURRENT>/ on t001-ingest-fortran
# (fortran/app/lrd_reference.f90). Read with git show (committed objects only).
FW=/workspace/jwst-lrd-t001
"$LRDC" -o "$B/v_residuals_flam" "$V/programs/v_residuals_flam.lrd" > "$O/c_rf.txt" 2>&1 || { fail compile_v_residuals_flam "$(oneline < "$O/c_rf.txt")"; exit 1; }
FR=$T/fref_t001; mkdir -p "$FR"
fmiss=""
for f in wavelength_ang flam model_Halpha resid_Halpha model_Hbeta resid_Hbeta; do
  if [ -n "$cur" ] && git -C "$REPO" show "$BR1:fixtures/reference/$cur/$f.hdr" > "$FR/$f.hdr" 2>/dev/null &&
     git -C "$REPO" show "$BR1:fixtures/reference/$cur/$f.f64" > "$FR/$f.f64" 2>/dev/null; then :; else
    fmiss="${fmiss:+$fmiss, }$f"
  fi
done
if [ -z "$REAL" ] || [ -n "$fmiss" ]; then
  why="Fortran reference outputs missing on $BR1 (head $h1): fixtures/reference/${cur:-<CURRENT>}/{${fmiss:-?}} not committed${REAL:+}${REAL:-; real ingest wavelength missing}"
  [ -n "$(command -v gfortran)" ] || why="$why; gfortran missing"
  unav acceptance_lrdc_vs_fortran "$why"
else
  NF0=$NFAIL
  "$B/v_convert" "$REAL" "$O/acc_wlA" > "$O/acc1.txt" 2>&1 || fail fortran_t001_vs_lrdc_convert_real "$(oneline < "$O/acc1.txt")"
  if r=$("$B/lrdcmp" --require-finite --tol-file "$TOL" --op convert "$O/acc_wlA" "$FR/wavelength_ang" 2>&1); then pass fortran_t001_vs_lrdc_convert_real
  else fail fortran_t001_vs_lrdc_convert_real "$r"; fi
  for L in Halpha Hbeta; do
    "$B/v_residuals_flam" "$FR/flam" "$FR/model_$L" "$O/acc_r_$L" > "$O/acc_$L.txt" 2>&1 || fail "fortran_t001_vs_lrdc_residuals_$L" "$(oneline < "$O/acc_$L.txt")"
    if r=$("$B/lrdcmp" --require-finite --tol-file "$TOL" --op residuals "$O/acc_r_$L" "$FR/resid_$L" 2>&1); then pass "fortran_t001_vs_lrdc_residuals_$L"
    else fail "fortran_t001_vs_lrdc_residuals_$L" "$r"; fi
  done
  if [ $NFAIL -eq $NF0 ]; then pass acceptance_lrdc_vs_fortran; else fail acceptance_lrdc_vs_fortran "$((NFAIL - NF0)) Fortran comparison(s) failed"; fi
fi
for c in restframe_synth convert_synth residuals_synth chi2_synth restframe_real; do
  unav "fortran_t001_vs_lrdc_$c" "t001 Fortran publishes only fixed real-product outputs (fixtures/reference/<sha>); it has no CLI for these inputs and no rest-frame/chi2 output arrays"
done

# ------------------------------------------------------------------ reference: Futhark + its Fortran ref (agent2-futhark, committed)
BR2=agent2-futhark
h2=$(git -C "$REPO" rev-parse --short "$BR2" 2>/dev/null)
X=$T/xl; mkdir -p "$X"
if [ -z "$h2" ]; then
  unav futhark_reference "branch $BR2 not found"; unav fortran_fut_reference "branch $BR2 not found"
else
  git -C "$REPO" archive "$BR2" futhark tests/futhark | tar -x -C "$X" 2>/dev/null
  if [ ! -f "$X/futhark/lrd.fut" ] || [ ! -f "$X/futhark/lrd-fut" ]; then
    unav futhark_reference "futhark/lrd.fut or futhark/lrd-fut not committed on $BR2 ($h2)"
  elif [ -z "$(command -v futhark)" ]; then
    unav futhark_reference "futhark compiler not on PATH"
  elif ! out=$(cd "$X/futhark" && mkdir -p build && futhark c --safe -o build/lrd-c lrd.fut 2>&1); then
    unav futhark_reference "futhark build of $BR2 ($h2) failed: $(echo "$out" | oneline)"
  else
    pass "build_futhark_reference_${h2}"
    chmod +x "$X/futhark/lrd-fut"
    compare_ref futhark "$X/futhark/lrd-fut"
  fi
  if [ ! -f "$X/tests/futhark/fortran-ref/lrdref.f90" ]; then
    unav fortran_fut_reference "tests/futhark/fortran-ref not committed on $BR2 ($h2)"
  elif [ -z "$(command -v gfortran)" ]; then
    unav fortran_fut_reference "gfortran not on PATH"
  elif ! out=$(make -s -C "$X/tests/futhark/fortran-ref" FC=gfortran B="$X/fref" "$X/fref/lrdref" 2>&1); then
    unav fortran_fut_reference "gfortran build of $BR2 ($h2) tests/futhark/fortran-ref failed: $(echo "$out" | oneline)"
  else
    pass "build_fortran_fut_reference_${h2}"
    compare_ref fortran_fut "$X/fref/lrdref"
  fi
fi

# ------------------------------------------------------------------ reference: MATLAB, SAS
for L in matlab sas; do
  outs=$(find "$REPO/$L" /workspace/jwst-lrd-*/"$L" -name '*.hdr' 2>/dev/null | head -n 1)
  tool=$(command -v "$L" 2>/dev/null)
  if [ -z "$tool" ]; then
    unav "${L}_reference" "$L not installed (licensed software); ${outs:+outputs found at $outs but cannot be regenerated/verified here}${outs:-no $L/ reference outputs in any worktree}"
  elif [ -z "$outs" ]; then
    unav "${L}_reference" "$L present at $tool but no $L/ reference outputs exist yet"
  else
    unav "${L}_reference" "$L outputs found ($outs) but no documented output contract to map them"
  fi
done

[ $NFAIL -eq 0 ] || exit 1
exit 0
