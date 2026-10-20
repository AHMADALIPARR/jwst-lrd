#!/bin/sh
# SPDX-License-Identifier: AGPL-3.0-only
# Also subject to the SnapKitty Opaque License; see LICENSE and
# SNAPKITTY_OPAQUE_LICENSE.md at the repository root.
#
# tests/futhark/run.sh -- builds and tests the Futhark subsystem.
# Output (research/CONTRACTS.md): one line per test
#   PASS <name> | FAIL <name> <why> | UNAVAILABLE <name> <reason>
# then a SUMMARY line.  Exit status 1 iff any FAIL.
# Environment: LRD_SHARED (shared checkout, read-only; default
# /workspace/jwst-lrd), KEEP_WORK=1 keeps the scratch directory.
set -u
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
SHARED=${LRD_SHARED:-/workspace/jwst-lrd}
FUT=$ROOT/futhark/lrd-fut
FREF_SRC=$ROOT/tests/futhark/fortran-ref
W=$(mktemp -d "${TMPDIR:-/tmp}/lrd-futhark-test.XXXXXX")
[ "${KEEP_WORK:-0}" = 1 ] || trap 'rm -rf "$W"' EXIT INT TERM
NP=0; NF=0; NU=0
pass() { echo "PASS $1"; NP=$((NP + 1)); }
fail() { n=$1; shift; echo "FAIL $n $*"; NF=$((NF + 1)); }
unav() { n=$1; shift; echo "UNAVAILABLE $n $*"; NU=$((NU + 1)); }
oneline() { tr '\n' ' ' < "$1" | cut -c1-200; }

# ---------------------------------------------------------------- build
CBIN=$ROOT/futhark/build/lrd-c
if make -C "$ROOT/futhark" all > "$W/build-c.log" 2>&1 && [ -x "$CBIN" ]; then
  pass futhark-build-c
else
  fail futhark-build-c "$(tail -n 3 "$W/build-c.log" | tr '\n' ' ')"
  echo "SUMMARY pass=$NP fail=$NF unavailable=$NU"; exit 1
fi

# ------------------------------------------------- analytic unit tests
mkdir -p "$W/src/futhark" "$W/src/tests/futhark"
cp "$ROOT/futhark/lrd.fut" "$W/src/futhark/"
cp "$ROOT/tests/futhark/unit.fut" "$W/src/tests/futhark/"
UNIT=$W/unit
if futhark c -o "$UNIT" "$W/src/tests/futhark/unit.fut" > "$W/unit-build.log" 2>&1; then
  for e in $(sed -n 's/^entry t_\([a-z0-9_]*\) .*/\1/p' "$ROOT/tests/futhark/unit.fut"); do
    r=$(echo 0i64 | "$UNIT" -e "t_$e" 2>&1)
    m=$(echo 0i64 | "$UNIT" -e "m_$e" 2>&1 | tr '\n' ' ')
    if [ "$r" = true ]; then pass "unit-$e"; else fail "unit-$e" "metric,tol=$m out=$r"; fi
  done
else
  fail unit-build "$(tail -n 3 "$W/unit-build.log" | tr '\n' ' ')"
fi
if (cd "$W/src/tests/futhark" && futhark test --backend=c unit.fut) > "$W/futhark-test.log" 2>&1 \
   && grep -q '^1/1 passed' "$W/futhark-test.log"; then
  pass futhark-test-unit
else
  fail futhark-test-unit "$(oneline "$W/futhark-test.log")"
fi

# ------------------------------------------------------------ ABI tests
cd "$W" || exit 1
if "$FUT" mk SYNTHETIC_abi um 1.5 0.6 5.3 -2.25e-300 > abi.log 2>&1 \
   && . "$ROOT/futhark/lrdarr.sh" \
   && lrd_to_fut SYNTHETIC_abi > abi.fut \
   && [ "$(od -An -tx1 -N 15 abi.fut | tr -d ' \n')" = 620201206636340400000000000000 ] \
   && lrd_from_fut abi.fut SYNTHETIC_abi2:um \
   && cmp -s SYNTHETIC_abi.f64 SYNTHETIC_abi2.f64 \
   && [ "$(lrd_hdr_get SYNTHETIC_abi2 format)" = LRD-ARR-v1 ] \
   && [ "$(lrd_hdr_get SYNTHETIC_abi2 length)" = 4 ] \
   && [ "$(lrd_hdr_get SYNTHETIC_abi2 unit)" = um ] \
   && [ "$(od -An -tx1 -N 8 SYNTHETIC_abi.f64 | tr -d ' \n')" = 000000000000f83f ]; then
  pass abi-roundtrip
else
  fail abi-roundtrip "$(oneline abi.log)"
fi
cp SYNTHETIC_abi.f64 bad.f64; sed 's/^length=4/length=5/' SYNTHETIC_abi.hdr > bad.hdr
if "$FUT" um2a bad badout > /dev/null 2>&1; then fail abi-reject-bad-length "accepted wrong length"
else pass abi-reject-bad-length; fi
sed 's/^unit=um/unit=Angstrom/' SYNTHETIC_abi.hdr > wrongu.hdr; cp SYNTHETIC_abi.f64 wrongu.f64
if "$FUT" um2a wrongu wout > /dev/null 2>&1; then fail abi-reject-unit "accepted Angstrom input for um2a"
else pass abi-reject-unit; fi

# ------------------------------------------- Fortran reference (ours)
FB=$W/fortran-build
REF=$FB/lrdref
if make -C "$FREF_SRC" B="$FB" all > "$W/fortran-build.log" 2>&1 && [ -x "$REF" ]; then
  pass fortran-ref-build
  "$FB/test_lrd_kernels" > "$W/fortran-unit.log" 2>&1
  while IFS= read -r line; do
    case "$line" in
      PASS\ *) pass "${line#PASS }" ;;
      FAIL\ *) l=${line#FAIL }; fail "${l%% *}" "${l#* }" ;;
    esac
  done < "$W/fortran-unit.log"
  grep -q '^PASS fortran-ref-unit-' "$W/fortran-unit.log" || fail fortran-ref-unit "$(oneline "$W/fortran-unit.log")"
else
  fail fortran-ref-build "$(tail -n 3 "$W/fortran-build.log" | tr '\n' ' ')"
  REF=
fi

# diffcase NAME ATOL RTOL "fut-args" "ref-args" OUTSUFFIX...
#   runs the same kernel through lrd-fut (prefix F_) and lrdref (prefix R_)
DIFF_OK=1
diffcase() {
  name=$1; atol=$2; rtol=$3; fa=$4; ra=$5; shift 5
  # shellcheck disable=SC2086
  if ! "$FUT" $fa > "$W/$name.fut.log" 2>&1; then
    fail "$name" "futhark run: $(oneline "$W/$name.fut.log")"; DIFF_OK=0; return; fi
  # shellcheck disable=SC2086
  if ! "$REF" $ra > "$W/$name.ref.log" 2>&1; then
    fail "$name" "fortran run: $(oneline "$W/$name.ref.log")"; DIFF_OK=0; return; fi
  why=
  for s in "$@"; do
    if ! r=$("$FUT" cmp "$atol" "$rtol" "F_$s" "R_$s" 2>&1); then why="$why $s:[$r]"; fi
    if ! cmp -s "F_$s.hdr" "R_$s.hdr" 2>/dev/null; then
      for k in format length unit; do
        [ "$(lrd_hdr_get "F_$s" $k)" = "$(lrd_hdr_get "R_$s" $k)" ] || why="$why $s:hdr-$k"
      done
    fi
  done
  if [ -z "$why" ]; then pass "$name"; else fail "$name" "atol=$atol rtol=$rtol$why"; DIFF_OK=0; fi
}

run_diffs() { # TAG LAM_A LAM_UM FLUX SIGMA  (all LRD-ARR-v1 prefixes in $W); z grid = $ZG
  t=$1; la=$2; lu=$3; fl=$4; sg=$5
  diffcase "fortran-ref-diff-$t-um2a" 0 1e-15 "um2a $lu F_${t}_um2a" "um2a $lu R_${t}_um2a" "${t}_um2a"
  diffcase "fortran-ref-diff-$t-a2um" 0 1e-15 "a2um $la F_${t}_a2um" "a2um $la R_${t}_a2um" "${t}_a2um"
  diffcase "fortran-ref-diff-$t-vac2air" 0 1e-15 "vac2air $la F_${t}_v2a" "vac2air $la R_${t}_v2a" "${t}_v2a"
  diffcase "fortran-ref-diff-$t-air2vac" 0 1e-15 "air2vac $la F_${t}_a2v" "air2vac $la R_${t}_a2v" "${t}_a2v"
  diffcase "fortran-ref-diff-$t-rest" 0 1e-15 "rest 6.123 $la F_${t}_rest" "rest 6.123 $la R_${t}_rest" "${t}_rest"
  diffcase "fortran-ref-diff-$t-obs" 0 1e-15 "obs 6.123 $la F_${t}_obs" "obs 6.123 $la R_${t}_obs" "${t}_obs"
  diffcase "fortran-ref-diff-$t-flam2fnu" 0 1e-14 "flam2fnu $la ${t}_siglam $fl $sg F_${t}_fnu" \
    "flam2fnu $la ${t}_siglam $fl $sg R_${t}_fnu" "${t}_fnu" "${t}_fnu_sigma"
  diffcase "fortran-ref-diff-$t-flam2fnu-nolamerr" 0 1e-14 "flam2fnu $la - $fl $sg F_${t}_fnu0" \
    "flam2fnu $la - $fl $sg R_${t}_fnu0" "${t}_fnu0" "${t}_fnu0_sigma"
  diffcase "fortran-ref-diff-$t-fnu2flam" 0 1e-14 "fnu2flam $la ${t}_siglam $fl $sg F_${t}_flam" \
    "fnu2flam $la ${t}_siglam $fl $sg R_${t}_flam" "${t}_flam" "${t}_flam_sigma"
  diffcase "fortran-ref-diff-$t-gauss" 0 1e-14 "gauss 2.5 46777.4 21.3 1.0 $la F_${t}_g" \
    "gauss 2.5 46777.4 21.3 1.0 $la R_${t}_g" "${t}_g"
  diffcase "fortran-ref-diff-$t-resid" 0 1e-15 "resid $fl F_${t}_g F_${t}_res" "resid $fl R_${t}_g R_${t}_res" "${t}_res"
  diffcase "fortran-ref-diff-$t-chi2" 0 1e-12 "chi2 $fl F_${t}_g $sg F_${t}_chi2" "chi2 $fl R_${t}_g $sg R_${t}_chi2" "${t}_chi2"
  diffcase "fortran-ref-diff-$t-zgrid" 1e-12 1e-9 \
    "zgrid $la $fl $sg SYNTHETIC_lc SYNTHETIC_lw 1 $ZG F_${t}_z" \
    "zgrid $la $fl $sg SYNTHETIC_lc SYNTHETIC_lw 1 $ZG R_${t}_z" "${t}_z_chi2" "${t}_z_params"
  diffcase "fortran-ref-diff-$t-zgrid-best" 0 0 \
    "zgrid $la $fl $sg SYNTHETIC_lc SYNTHETIC_lw 0 $ZG F_${t}_y" \
    "zgrid $la $fl $sg SYNTHETIC_lc SYNTHETIC_lw 0 $ZG R_${t}_y" "${t}_y_best"
}

if [ -n "$REF" ]; then
  # SYNTHETIC inputs (deterministic generator in futhark/lrd.fut)
  "$FUT" mk SYNTHETIC_lc Angstrom 6564.61 5008.24 4862.68 > gen.log 2>&1 &&
  "$FUT" mk SYNTHETIC_lw Angstrom 3.0 3.0 3.0 >> gen.log 2>&1 &&
  "$FUT" mk SYNTHETIC_la arbitrary 5.0 2.0 1.0 >> gen.log 2>&1 &&
  "$FUT" mk SYNTHETIC_z0 1 0.0 >> gen.log 2>&1 &&
  "$FUT" mk SYNTHETIC_zg 1 $(i=0; while [ $i -le 400 ]; do printf '%s ' "$(echo "5 + $i * 0.005" | bc -l)"; i=$((i + 1)); done) >> gen.log 2>&1 &&
  "$FUT" synth 3000 30000.0 53000.0 6.123 SYNTHETIC_lc SYNTHETIC_lw SYNTHETIC_la 1.0 0.5 11 SYNTHETIC_spec >> gen.log 2>&1 &&
  "$FUT" a2um SYNTHETIC_spec_lam SYNTHETIC_spec_um >> gen.log 2>&1 &&
  "$FUT" gauss 0 0 1 1.5 SYNTHETIC_spec_lam syn_siglam_tmp >> gen.log 2>&1 &&
  sed 's/^unit=.*/unit=Angstrom/' syn_siglam_tmp.hdr > syn_siglam.hdr && cp syn_siglam_tmp.f64 syn_siglam.f64
  if [ $? -eq 0 ]; then
    ZG=SYNTHETIC_zg run_diffs syn SYNTHETIC_spec_lam SYNTHETIC_spec_um SYNTHETIC_spec_flux SYNTHETIC_spec_sigma
    # masked variant: NaN flux (pixels 10, 500), NaN wavelength (700), sigma 0 (20)
    for q in lam flux sigma; do cp SYNTHETIC_spec_$q.f64 SYNTHETIC_mask_$q.f64
      sed "s/^name=.*/name=SYNTHETIC_mask_$q/" SYNTHETIC_spec_$q.hdr > SYNTHETIC_mask_$q.hdr; done
    nan8() { printf '\000\000\000\000\000\000\370\177' | dd of="$1" bs=8 seek="$2" conv=notrunc 2>/dev/null; }
    nan8 SYNTHETIC_mask_flux.f64 10; nan8 SYNTHETIC_mask_flux.f64 500; nan8 SYNTHETIC_mask_lam.f64 700
    head -c 8 /dev/zero | dd of=SYNTHETIC_mask_sigma.f64 bs=8 seek=20 conv=notrunc 2>/dev/null
    diffcase fortran-ref-diff-syn-zgrid-masked 1e-12 1e-9 \
      "zgrid SYNTHETIC_mask_lam SYNTHETIC_mask_flux SYNTHETIC_mask_sigma SYNTHETIC_lc SYNTHETIC_lw 1 SYNTHETIC_zg F_m_z" \
      "zgrid SYNTHETIC_mask_lam SYNTHETIC_mask_flux SYNTHETIC_mask_sigma SYNTHETIC_lc SYNTHETIC_lw 1 SYNTHETIC_zg R_m_z" \
      m_z_chi2 m_z_params m_z_best
    diffcase fortran-ref-diff-syn-chi2-masked 0 1e-12 "chi2 SYNTHETIC_mask_flux F_syn_g SYNTHETIC_mask_sigma F_m_c2" \
      "chi2 SYNTHETIC_mask_flux R_syn_g SYNTHETIC_mask_sigma R_m_c2" m_c2
    if [ $DIFF_OK = 1 ]; then pass fortran-ref-diff; else fail fortran-ref-diff "see fortran-ref-diff-* lines"; fi
  else
    fail fortran-ref-diff "synthetic input generation failed: $(oneline gen.log)"
  fi
else
  fail fortran-ref-diff "fortran reference not built"
fi

# Real JWST x1d fixture (shared checkout, read-only): needs LRD-ARR-v1
# wavelength (unit um), flux and flux-error arrays exported by ingest.
X1D=
if [ -d "$SHARED/fixtures" ]; then
  for h in $(find "$SHARED/fixtures" -name '*.hdr' 2>/dev/null | sort); do
    grep -qx 'format=LRD-ARR-v1' "$h" || continue
    p=${h%.hdr}; b=$(basename "$p" | tr 'A-Z' 'a-z')
    case "$b" in *wave*) grep -qx 'unit=um' "$h" && XW=$p;; *err*) XE=$p;; *flux*) XF=$p;; esac
  done
  [ -n "${XW:-}" ] && [ -n "${XF:-}" ] && [ -n "${XE:-}" ] && X1D=1
fi
if [ -z "$X1D" ]; then
  nf=$(find "$SHARED/fixtures" -iname '*x1d*.fits' 2>/dev/null | wc -l | tr -d ' ')
  unav fortran-ref-diff-x1d "no LRD-ARR-v1 x1d wavelength/flux/error arrays under $SHARED/fixtures (x1d FITS files found: $nf; waiting on ingest export)"
elif [ -z "$REF" ]; then
  fail fortran-ref-diff-x1d "fortran reference not built"
else
  for q in "$XW:x1d_um" "$XF:x1d_flux" "$XE:x1d_err"; do
    cp "${q%%:*}.f64" "${q#*:}.f64"; cp "${q%%:*}.hdr" "${q#*:}.hdr"
  done
  "$FUT" um2a x1d_um x1d_A > x1d.log 2>&1
  "$FUT" gauss 0 0 1 0 x1d_A x1d_siglam_tmp >> x1d.log 2>&1
  sed 's/^unit=.*/unit=Angstrom/' x1d_siglam_tmp.hdr > x1d_siglam.hdr; cp x1d_siglam_tmp.f64 x1d_siglam.f64
  # z grid 4.000..9.000 step 0.002 for the real spectrum (differential only)
  "$FUT" mk zgrid_x1d 1 $(i=0; while [ $i -le 2500 ]; do printf '%s ' "$(echo "4 + $i * 0.002" | bc -l)"; i=$((i + 1)); done) >> x1d.log 2>&1
  DIFF_OK=1
  ZG=zgrid_x1d run_diffs x1d x1d_A x1d_um x1d_flux x1d_err
  if [ $DIFF_OK = 1 ]; then pass fortran-ref-diff-x1d; else fail fortran-ref-diff-x1d "see fortran-ref-diff-x1d-* lines (inputs: $XW $XF $XE)"; fi
fi

# ------------------------------------------------ multicore backend
MBIN=$ROOT/futhark/build/lrd-multicore
if make -C "$ROOT/futhark" multicore > "$W/build-mc.log" 2>&1 && [ -x "$MBIN" ]; then
  pass futhark-build-multicore
  if [ -f F_syn_z_chi2.f64 ] && LRD_FUT_BIN=$MBIN "$FUT" zgrid SYNTHETIC_spec_lam SYNTHETIC_spec_flux \
       SYNTHETIC_spec_sigma SYNTHETIC_lc SYNTHETIC_lw 1 SYNTHETIC_zg M_syn_z > mc.log 2>&1; then
    why=
    for s in chi2 params; do
      "$FUT" cmp 1e-12 1e-9 "M_syn_z_$s" "F_syn_z_$s" > /dev/null 2>&1 || why="$why $s"
    done
    "$FUT" cmp 0 0 M_syn_z_best F_syn_z_best > /dev/null 2>&1 || why="$why best"
    if [ -z "$why" ]; then pass multicore-vs-c-zgrid; else fail multicore-vs-c-zgrid "differs:$why"; fi
  else
    fail multicore-vs-c-zgrid "run failed: $(oneline mc.log)"
  fi
else
  fail futhark-build-multicore "$(tail -n 3 "$W/build-mc.log" | tr '\n' ' ')"
fi

# ---------------------------- differential vs the fortran/ track outputs
NREF=$(find "$SHARED/fortran" -name '*.hdr' 2>/dev/null | xargs -r grep -lx 'format=LRD-ARR-v1' 2>/dev/null | wc -l | tr -d ' ')
if [ "$NREF" = 0 ]; then
  unav fortran-diff "waiting on fortran reference"
else
  unav fortran-diff "found $NREF LRD-ARR-v1 outputs under $SHARED/fortran but no agreed kernel/input mapping yet (see futhark/STATUS.md)"
fi

echo "SUMMARY pass=$NP fail=$NF unavailable=$NU"
[ "$NF" -eq 0 ]
