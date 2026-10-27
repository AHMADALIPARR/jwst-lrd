#!/bin/sh
# SPDX-License-Identifier: AGPL-3.0-only
# Also subject to SNAPKITTY_OPAQUE_LICENSE.md (dual license, see repository root).
#
# tests/fortran: kernel unit tests (analytic + cited values) and the real-spectrum reference run.
# Prints PASS/FAIL/UNAVAILABLE lines (CONTRACTS.md); exits nonzero iff a FAIL occurred.
SELF=$(cd "$(dirname "$0")" && pwd)/$(basename "$0")
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
cd "$ROOT" || exit 2
BIN="$ROOT/build/out/bin"
T=$(mktemp -d "${TMPDIR:-/tmp}/lrd-fortran-test.XXXXXX")
trap 'rm -rf "$T"' EXIT
FAILS=0
pass() { echo "PASS $1"; }
fail() { echo "FAIL $1 $2"; FAILS=$((FAILS+1)); }
unav() { echo "UNAVAILABLE $1 $2"; }
if ! command -v gfortran >/dev/null 2>&1; then echo "UNAVAILABLE fortran_kernel gfortran not installed"; exit 0; fi
if make -s ingest >"$T/b.log" 2>&1 && make -s -C fortran >>"$T/b.log" 2>&1; then pass build_fortran_kernel
else fail build_fortran_kernel "$(tail -1 "$T/b.log")"; exit 1; fi

# Unit tests (each line already PASS/FAIL). Run in a scratch dir (writes SYNTHETIC_* files).
(cd "$T" && "$BIN/lrd_ftest") > "$T/unit.out" 2>"$T/unit.err"; r=$?
grep -E '^(PASS|FAIL) ' "$T/unit.out"
FAILS=$((FAILS + $(grep -c '^FAIL ' "$T/unit.out")))
[ $r -ne 0 ] && ! grep -q '^FAIL ' "$T/unit.out" && fail fortran_unit_runner "exit $r without FAIL line"
# Declared number of kernel unit-test PASS lines (baseline measured on origin/main db089a3: 36). A different
# count (a test dropped or added without re-baselining) fails.
EXP_UNIT=36
got=$(grep -c '^PASS ' "$T/unit.out")
[ "$got" = "$EXP_UNIT" ] && pass "fortran_unit_count expected=$EXP_UNIT got=$got" || fail fortran_unit_count "expected=$EXP_UNIT got=$got"

# Real spectrum reference run: reproducible bytewise vs the committed fixtures/reference/<sha>/.
SHA=$(cat fixtures/ingest/CURRENT)
REF="fixtures/reference/$SHA"
# Declared expectations for the c0b87857 fixture (research/BLOCKERS.md (d) criterion 1). Every count
# assertion prints expected=<n> got=<m> in its PASS and FAIL line.
EXP_ARRAYS=8; EXP_PIXELS=429; EXP_VALID=408; EXP_MASKED=21
count_eq() { # name expected got
  if [ "$3" = "$2" ]; then pass "$1 expected=$2 got=$3"; else fail "$1" "expected=$2 got=$3"; fi
}
# Independent read of one big-endian binary64 from the raw FITS (od, not CFITSIO/Fortran); prints %.17g text.
od_f8() { od -An -v -t f8 --endian="$1" -j "$2" -N 8 "$3" | tr -d ' \n'; }
if sh fortran/run_reference.sh "$T/ref" >/dev/null 2>"$T/ref.err"; then
  pass reference_run_real_spectrum
  ok=1; why=""
  for f in "$REF"/*; do
    b=$(basename "$f"); case $b in zinvest.*) continue;; esac; cmp -s "$f" "$T/ref/$b" || { ok=0; why="$why $b"; }
  done
  [ $ok = 1 ] && pass reference_outputs_reproducible || fail reference_outputs_reproducible "differs:$why"

  # Count assertions (BLOCKERS.md (d) criterion 1).
  if [ "$SHA" = c0b878576d7d7ec723c5ee526d29715fb672d81e45bc8ba4e02598ce8b9c5ee7 ]; then
    got=$(grep -lx 'format=LRD-ARR-v1' "$T/ref"/*.hdr 2>/dev/null | wc -l | tr -d ' ')
    count_eq reference_array_count "$EXP_ARRAYS" "$got"
    count_eq reference_pixel_count "$EXP_PIXELS" "$(sed -n 's/^n_rows=//p' "$T/ref/reference.kv")"
    count_eq reference_valid_count "$EXP_VALID" "$(sed -n 's/^n_valid=//p' "$T/ref/reference.kv")"
    # masked = zeros in mask.f64, counted with od (not taken from reference.kv)
    got=$(od -An -v -t f8 --endian=little -w8 "$T/ref/mask.f64" | awk '$1+0==0{n++} END{print n+0}')
    count_eq reference_masked_count "$EXP_MASKED" "$got"
  else
    unav reference_counts "no declared expected counts for $SHA"
  fi

  # Redshift vs Furtak et al. 2024, Nature 628, 57 (arXiv:2308.05735): z_spec = 7.0451 +- 0.0005.
  # Declared (loose) tolerance: one prism pixel at H-alpha expressed in z (pixel_ang / lambda_rest).
  # It is inside that tolerance but the offset is ~10x the formal error, so it is reported as OPEN,
  # never PASS (BLOCKERS.md (d) criterion 4); OPEN lines do not count as PASS or FAIL.
  z=$(sed -n 's/^z.weighted_mean=//p' "$T/ref/reference.kv")
  ez=$(sed -n 's/^z.weighted_mean_err=//p' "$T/ref/reference.kv")
  pxa=$(sed -n 's/^line.Halpha.pixel_ang=//p' "$T/ref/reference.kv")
  set -- $(awk -v z="$z" -v e="$ez" -v p="$pxa" 'BEGIN{t=p/6564.632; d=z-7.0451; if (d<0) d=-d;
    printf "%s %.4f %.4f %.1f %.6f %s", (d<=t?"IN":"OUT"), d, t, d/e, 3*e, (d>3*e?"GT":"LE")}')
  zin=$1; zdz=$2; ztol=$3; zratio=$4; z3e=$5; zstrict=$6
  if [ "$zin" = IN ]; then
    echo "OPEN redshift_vs_furtak2024 dz=$zdz tol=$ztol (inside declared tolerance; $zdz = ${zratio}x formal error; unresolved)"
  else
    fail redshift_vs_furtak2024 "dz=$zdz > tol=$ztol (outside the declared one-pixel tolerance)"
  fi
  if [ "$zstrict" = GT ]; then
    echo "FAIL-EXPECTED/OPEN redshift_strict dz=$zdz > 3*formal_err=$z3e (formal_err=$ez)"
  else
    pass "redshift_strict dz=$zdz <= 3*formal_err=$z3e"
  fi

  # Independent sigma check (BLOCKERS.md (d) criterion 3). sigma(FLUX_ERROR) is re-read straight from the raw
  # FITS binary table with od+awk (no CFITSIO, no Fortran) and compared with
  #   (i)  fixtures/ingest/<sha>/flux_error.f64   (C/CFITSIO path, lrd_fitsx), and
  #   (ii) reference flam_err.f64                 (Fortran path) after the same Jy -> F_lambda conversion
  # over all valid pixels; pass = max relative difference <= 1e-12. Invalid pixels must be NaN in flam_err
  # and masked (0) in mask.f64.
  RAW="fixtures/raw/$SHA.fits"
  hdr=$(head -c 57600 "$RAW" | fold -w 80)
  ends=$(printf '%s\n' "$hdr" | grep -an '^END  ' | cut -d: -f1 | tr '\n' ' '); set -- $ends
  dataoff=$(( ( ($2 * 80 + 2879) / 2880 ) * 2880 ))
  rowlen=$(printf '%s\n' "$hdr" | grep -a '^NAXIS1  =' | sed -n '1p' | sed 's/^[^=]*= *//; s/ .*//')
  nrow=$(printf '%s\n' "$hdr" | grep -a '^NAXIS2  =' | sed -n '1p' | sed 's/^[^=]*= *//; s/ .*//')
  # byte offsets of WAVELENGTH, FLUX, FLUX_ERROR in a row, from the TTYPEn/TFORMn cards (each must be 'D', 1 element)
  offs=$(printf '%s\n' "$hdr" | awk '
    /^TTYPE[0-9]+ *=/ { n=$1; sub(/^TTYPE/,"",n); v=$0; sub(/^[^=]*= *\047/,"",v); sub(/\047.*/,"",v); gsub(/ /,"",v); nm[n+0]=v }
    /^TFORM[0-9]+ *=/ { n=$1; sub(/^TFORM/,"",n); v=$0; sub(/^[^=]*= *\047/,"",v); sub(/\047.*/,"",v); gsub(/ /,"",v); fm[n+0]=v }
    END { o=0; for (i=1; fm[i]!=""; i++) { if (nm[i]=="WAVELENGTH"||nm[i]=="FLUX"||nm[i]=="FLUX_ERROR") { printf "%s=%d:%s ", nm[i], o, fm[i] }
            f=fm[i]; sz=(f=="D"||f=="K")?8:((f=="E"||f=="J")?4:-1); if (sz<0) { printf "UNSUPPORTED=%s ", f; exit } o+=sz } }')
  ow=; of=; oe=; badoffs=0
  for kv in $offs; do case $kv in
    WAVELENGTH=*:D) ow=${kv#*=}; ow=${ow%:*};; FLUX=*:D) of=${kv#*=}; of=${of%:*};; FLUX_ERROR=*:D) oe=${kv#*=}; oe=${oe%:*};; *) badoffs=1;; esac; done
  if [ -n "$dataoff" ] && [ -n "$nrow" ] && [ -n "$rowlen" ] && [ -n "$ow" ] && [ -n "$of" ] && [ -n "$oe" ] && [ $badoffs = 0 ]; then
    : > "$T/raw3.txt"
    r=0
    while [ $r -lt "$nrow" ]; do
      b=$((dataoff + r * rowlen))
      echo "$(od_f8 big $((b+ow)) "$RAW") $(od_f8 big $((b+of)) "$RAW") $(od_f8 big $((b+oe)) "$RAW")" >> "$T/raw3.txt"
      r=$((r+1))
    done
    od -An -v -t f8 --endian=little -w8 "fixtures/ingest/$SHA/flux_error.f64" | tr -d ' ' > "$T/ing_e.txt"
    od -An -v -t f8 --endian=little -w8 "$T/ref/flam_err.f64" | tr -d ' ' > "$T/ref_e.txt"
    od -An -v -t f8 --endian=little -w8 "$T/ref/mask.f64" | tr -d ' ' > "$T/ref_m.txt"
    res=$(paste -d' ' "$T/raw3.txt" "$T/ing_e.txt" "$T/ref_e.txt" "$T/ref_m.txt" | awk '
      function fin(s) { return s !~ /[nN][aA][nN]|[iI][nN][fF]/ }
      function rel(a, b,   d) { d = a - b; if (d < 0) d = -d; if (a < 0) a = -a; return d / a }
      { rows++; w=$1; f=$2; e=$3; ing=$4; fl=$5; m=$6
        valid = fin(w) && fin(f) && fin(e) && (e + 0 > 0)
        if (!valid) { masked++; if (fin(fl) || m + 0 != 0) badinv++; if (fin(ing) != fin(e)) badinv++; next }
        n++
        if (m + 0 != 1) badinv++
        r1 = rel(e + 0, ing + 0); if (r1 > m1) m1 = r1
        want = (e + 0) * 1e-23 * (299792458 * 1e10) / ((w * 1e4) * (w * 1e4))
        r2 = rel(want, fl + 0); if (r2 > m2) m2 = r2 }
      END { printf "rows=%d n=%d masked=%d badinv=%d max_rel_ingest=%.3e max_rel_flam=%.3e", rows, n, masked, badinv+0, m1+0, m2+0 }')
    eval "$(printf '%s\n' "$res" | tr ' ' '\n' | sed 's/^/s_/')"
    okt=$(awk -v a="$s_max_rel_ingest" -v b="$s_max_rel_flam" 'BEGIN{print (a<=1e-12 && b<=1e-12)?"OK":"BAD"}')
    if [ "$s_rows" = "$EXP_PIXELS" ] && [ "$s_n" = "$EXP_VALID" ] && [ "$s_masked" = "$EXP_MASKED" ] \
       && [ "$s_badinv" = 0 ] && [ "$okt" = OK ]; then
      pass "reference_sigma_independent n=$s_n expected=$EXP_VALID masked=$s_masked rows=$s_rows max_rel_ingest=$s_max_rel_ingest max_rel_flam=$s_max_rel_flam tol=1e-12"
    else
      fail reference_sigma_independent "n=$s_n expected=$EXP_VALID masked=$s_masked expected_masked=$EXP_MASKED rows=$s_rows expected_rows=$EXP_PIXELS badinv=$s_badinv max_rel_ingest=$s_max_rel_ingest max_rel_flam=$s_max_rel_flam tol=1e-12"
    fi
  else
    fail reference_sigma_independent "could not locate FITS table layout (dataoff=$dataoff nrow=$nrow rowlen=$rowlen offs=$offs)"
  fi

  # LRD-ARR-v1 headers. The extra name in LRD_TEST_EXTRA_ARRAY is the negative-test injection hook
  # (BLOCKERS.md (d) criterion 2): a name that does not exist must FAIL and suppress the summary PASS.
  arrays="wavelength_ang flam flam_err mask model_Hbeta resid_Hbeta model_Halpha resid_Halpha"
  [ -n "${LRD_TEST_EXTRA_ARRAY:-}" ] && arrays="$arrays $LRD_TEST_EXTRA_ARRAY"
  narr=0; narr_ok=0
  for a in $arrays; do
    narr=$((narr+1))
    h="$T/ref/$a.hdr"
    if [ -f "$h" ] && [ -f "$T/ref/$a.f64" ] && grep -qx 'format=LRD-ARR-v1' "$h" && grep -q '^unit=' "$h" && grep -qx "source_sha256=$SHA" "$h" \
      && [ $(( $(sed -n 's/^length=//p' "$h") * 8 )) = "$(wc -c < "$T/ref/$a.f64" | tr -d ' ')" ]; then
      narr_ok=$((narr_ok+1))
    else
      fail "reference_lrd_arr_$a" "bad or missing LRD-ARR-v1"
    fi
  done
  if [ "$narr_ok" = "$narr" ]; then pass "reference_lrd_arr_v1_headers expected=$narr got=$narr_ok"
  else echo "# reference_lrd_arr_v1_headers not asserted: expected=$narr got=$narr_ok"; fi

  if [ -n "${LRD_TEST_ARRAYS_ONLY:-}" ]; then [ "$FAILS" -eq 0 ]; exit $?; fi

  # Negative test for the above: a bogus array name must FAIL, must NOT yield PASS reference_lrd_arr_v1_headers,
  # and must make the suite exit non-zero. Run in a child so its FAIL lines do not count in this run.
  LRD_TEST_ARRAYS_ONLY=1 LRD_TEST_EXTRA_ARRAY=bogus_array sh "$SELF" >"$T/neg.out" 2>"$T/neg.err"; negrc=$?
  if [ $negrc -ne 0 ] && grep -q '^FAIL reference_lrd_arr_bogus_array ' "$T/neg.out" \
     && ! grep -q '^PASS reference_lrd_arr_v1_headers' "$T/neg.out"; then
    pass "negative_injection_bogus_array_detected child_exit=$negrc"
  else
    fail negative_injection_bogus_array_detected "child_exit=$negrc; bogus FAIL line: $(grep -c '^FAIL reference_lrd_arr_bogus_array ' "$T/neg.out"); stray PASS headers line: $(grep -c '^PASS reference_lrd_arr_v1_headers' "$T/neg.out")"
  fi
else
  fail reference_run_real_spectrum "$(tail -1 "$T/ref.err")"
fi

# Redshift-discrepancy investigation (OPEN item, fortran/STATUS.md). LSF: JDox jwst_nirspec_prism_disp.fits.
LSF_SHA=58f9330440c50af624313e70f3e5b9f58a6b22d06af094e0085ed66408d0d937
got=$(openssl dgst -sha256 -r fortran/data/jdox/jwst_nirspec_prism_disp.fits 2>/dev/null | cut -d' ' -f1)
[ "$got" = "$LSF_SHA" ] && pass zinvest_lsf_file_sha256 || fail zinvest_lsf_file_sha256 "got $got"
if sh fortran/run_zinvest.sh "$T/zi" >/dev/null 2>"$T/zi.err"; then
  ok=1; for b in zinvest.kv zinvest.rec zinvest.commit; do cmp -s "$REF/$b" "$T/zi/$b" || ok=0; done
  [ $ok = 1 ] && pass zinvest_reproducible || fail zinvest_reproducible "differs from $REF/zinvest.*"
  # JDox states R assumes a 2.2-pixel resolution element; FWHM in x1d pixels must agree within 0.05 px.
  v=$(awk -F= '/^lsf.fwhm_pix_at_H(alpha|beta)=/{d=$2-2.2; if(d<0)d=-d; if(d>0.05)bad=bad" "$1"="$2} END{print bad==""?"OK":bad}' "$T/zi/zinvest.kv")
  [ "$v" = OK ] && pass zinvest_lsf_fwhm_2p2pix || fail zinvest_lsf_fwhm_2p2pix "$v"
  # Noise-free SYNTHETIC injection: Gaussian fits must recover z_true within 3 grid steps (3e-5).
  v=$(awk -F= '/^inj\..*\.(lsf|point)_fit\.z_minus_true=/{n++; d=$2; if(d<0)d=-d; if(d>3e-5)bad=bad" "$1"="$2} END{print (n==4&&bad=="")?"OK":"n="n bad}' "$T/zi/zinvest.kv")
  [ "$v" = OK ] && pass zinvest_injection_fit_unbiased || fail zinvest_injection_fit_unbiased "$v"
else
  fail zinvest_run "$(tail -1 "$T/zi.err")"
fi
[ "$FAILS" -eq 0 ]
