#!/bin/sh
# SPDX-License-Identifier: AGPL-3.0-only
# Also subject to SNAPKITTY_OPAQUE_LICENSE.md (dual license, see repository root).
#
# tests/fortran: kernel unit tests (analytic + cited values) and the real-spectrum reference run.
# Prints PASS/FAIL/UNAVAILABLE lines (CONTRACTS.md); exits nonzero iff a FAIL occurred.
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
cd "$ROOT" || exit 2
BIN="$ROOT/build/out/bin"
T=$(mktemp -d "${TMPDIR:-/tmp}/lrd-fortran-test.XXXXXX")
trap 'rm -rf "$T"' EXIT
FAILS=0
pass() { echo "PASS $1"; }
fail() { echo "FAIL $1 $2"; FAILS=$((FAILS+1)); }
if ! command -v gfortran >/dev/null 2>&1; then echo "UNAVAILABLE fortran_kernel gfortran not installed"; exit 0; fi
if make -s ingest >"$T/b.log" 2>&1 && make -s -C fortran >>"$T/b.log" 2>&1; then pass build_fortran_kernel
else fail build_fortran_kernel "$(tail -1 "$T/b.log")"; exit 1; fi

# Unit tests (each line already PASS/FAIL). Run in a scratch dir (writes SYNTHETIC_* files).
(cd "$T" && "$BIN/lrd_ftest") > "$T/unit.out" 2>"$T/unit.err"; r=$?
grep -E '^(PASS|FAIL) ' "$T/unit.out"
FAILS=$((FAILS + $(grep -c '^FAIL ' "$T/unit.out")))
[ $r -ne 0 ] && ! grep -q '^FAIL ' "$T/unit.out" && fail fortran_unit_runner "exit $r without FAIL line"

# Real spectrum reference run: reproducible bytewise vs the committed fixtures/reference/<sha>/.
SHA=$(cat fixtures/ingest/CURRENT)
REF="fixtures/reference/$SHA"
if sh fortran/run_reference.sh "$T/ref" >/dev/null 2>"$T/ref.err"; then
  pass reference_run_real_spectrum
  ok=1; why=""
  for f in "$REF"/*; do
    b=$(basename "$f"); cmp -s "$f" "$T/ref/$b" || { ok=0; why="$why $b"; }
  done
  [ $ok = 1 ] && pass reference_outputs_reproducible || fail reference_outputs_reproducible "differs:$why"
  # Redshift vs Furtak et al. 2024, Nature 628, 57 (arXiv:2308.05735): z_spec = 7.0451 +- 0.0005.
  # Declared tolerance: one prism pixel at H-alpha expressed in z (pixel_ang / lambda_rest);
  # the formal centroid error is far smaller and does not include wavelength-calibration systematics.
  z=$(sed -n 's/^z.weighted_mean=//p' "$T/ref/reference.kv")
  pxa=$(sed -n 's/^line.Halpha.pixel_ang=//p' "$T/ref/reference.kv")
  v=$(awk -v z="$z" -v p="$pxa" 'BEGIN{t=p/6564.632; d=z-7.0451; if (d<0) d=-d; printf "%s %.6f %.6f", (d<=t?"OK":"OUT"), d, t}')
  set -- $v
  [ "$1" = OK ] && pass "redshift_vs_furtak2024_dz=$2_tol=$3" || fail redshift_vs_furtak2024 "dz=$2 > tol=$3"
  for a in wavelength_ang flam flam_err mask model_Hbeta resid_Hbeta model_Halpha resid_Halpha; do
    h="$T/ref/$a.hdr"
    grep -qx 'format=LRD-ARR-v1' "$h" && grep -q '^unit=' "$h" && grep -qx "source_sha256=$SHA" "$h" \
      && [ $(( $(sed -n 's/^length=//p' "$h") * 8 )) = "$(wc -c < "$T/ref/$a.f64" | tr -d ' ')" ] \
      || { fail "reference_lrd_arr_$a" "bad LRD-ARR-v1"; continue; }
  done
  pass reference_lrd_arr_v1_headers
else
  fail reference_run_real_spectrum "$(tail -1 "$T/ref.err")"
fi
[ "$FAILS" -eq 0 ]
