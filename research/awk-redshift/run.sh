#!/usr/bin/env bash
# SPDX-License-Identifier: AGPL-3.0-only
# run.sh -- end-to-end awk signal-processing redshift cross-check for Abell 2744-QSO1 (JWST NIRSpec prism, obsid 230168921).
# Read-only on the data; writes only inside this directory.  Usage: ./run.sh   (override: AWK=gawk SRC=/path/to/fixtures)
set -u
cd "$(dirname "$0")"
AWK=${AWK:-mawk}; export AWK
mkdir -p results work; rm -f work/* results/run.log   # scratch dir only: start from a clean state so no stale file can be used
LOG=results/run.log
main() {
C="$AWK -f awk/common.awk"
M="$C -f awk/matched.awk"
echo "=== awk-sp run.sh  started $(date '+%Y-%m-%d %H:%M:%S %Z')  host=$(hostname)  awk=$AWK ($($AWK -W version 2>&1 | head -1))"
echo "=== script sha256 (ties this log to the code that produced it)"
sha256sum run.sh test.sh lib/prep.sh awk/*.awk
echo
echo "=== 0. data verification and export -> text (lib/prep.sh)"
bash lib/prep.sh || { echo "FATAL: prep failed"; exit 1; }
echo
echo "=== 1. rest wavelengths (stated and cited; see NOTE on air vs vacuum)"
$C -f awk/restwl_report.awk </dev/null
echo
echo "=== 2. masking (explicit mask file work/mask.log + work/masked0.tsv)"
$C -f awk/mask.awk -v OUT=work/masked0.tsv -v MASKLOG=work/mask.log work/spectrum.tsv
echo "--- work/mask.log (verbatim)"; cat work/mask.log
echo
echo "=== 3. continuum: iterative sigma-clipped running median"
$C -f awk/continuum.awk -v OUT=work/masked.tsv work/masked0.tsv
PXHA=$($AWK -F'\t' '$1==416{a=$2} $1==418{b=$2} END{printf "%.3f",(b-a)/2}' work/masked.tsv)
echo "pixel width at Halpha pixel 417 (A): $PXHA"
echo
echo "=== 4. matched filter, z grid 7.00-7.08 step 1e-4 (then 1e-5 refinement), inverse-variance weights"
echo "--- 4a PRIMARY: rest set B (NIST vacuum), running-median continuum (RM), HW=5 px, LSF FWHM 2.2 px, sigma_int profiled 0-4000 km/s, bootstrap N=200 seed 12345"
$M -v SET=B -v TAG=primary -v BOOT=200 -v SEED=12345 work/masked.tsv | tee work/primary.out
echo "--- 4b LSF-only (sigma_int=0)"
$M -v SET=B -v TAG=lsfonly -v SMAX=0 -v LINES="1 4" work/masked.tsv
echo "--- 4c rest set A (values as given in the task; they are AIR wavelengths) and set C (A converted to vacuum)"
$M -v SET=A -v TAG=setA -v LINES="1 4" work/masked.tsv
$M -v SET=C -v TAG=setC -v LINES="1 4" work/masked.tsv
echo "--- 4d continuum-estimator sensitivity: simultaneous polynomial continuum + line (POLY), order 1 and 2"
$M -v SET=B -v TAG=poly1 -v ORD=1 -v LINES="1 4" work/masked.tsv
$M -v SET=B -v TAG=poly2 -v ORD=2 -v LINES="1 4" work/masked.tsv
echo "--- 4e fit half-window scan HW (px); HW>=8 lets the Hbeta window overlap [OIII]4959/5007 and the Halpha window reach the red edge"
for hw in 3 4 6 8 10 12; do $M -v SET=B -v TAG=rm_hw$hw -v HW=$hw -v LINES="1 4" work/masked.tsv; done
for hw in 4 6 8; do $M -v SET=B -v TAG=poly1_hw$hw -v ORD=1 -v HW=$hw -v LINES="1 4" work/masked.tsv; done
echo "--- 4f prism-LSF-width scan: FWHM = LSFPX x pixel width, sigma_int=0 (isolates the instrumental-width assumption)"
for l in 1.6 1.8 2.0 2.2 2.4 2.6 2.8 3.0; do $M -v SET=B -v TAG=lsf$l -v LSFPX=$l -v SMAX=0 -v LINES="1 4" work/masked.tsv; done
echo "--- 4g red-edge test: drop the last N valid pixels (pixel 420 sits below its running-median continuum)"
for d in 1 2 3; do
  $M -v SET=B -v TAG=rm_drop$d -v DROPRED=$d -v LINES="1 4" work/masked.tsv
  $M -v SET=B -v TAG=poly1_drop$d -v ORD=1 -v DROPRED=$d -v LINES="1 4" work/masked.tsv
done
echo
echo "=== 5. FFT-free flux-weighted centroid vs observed-frame half-window W (100-400 A); CENSUM = spread across windows"
for s in B A; do $C -f awk/centroid.awk -v SET=$s -v TAG=cen_$s work/masked.tsv; done
echo "--- centroid with the last valid pixel dropped (set B)"
$C -f awk/centroid.awk -v SET=B -v TAG=cen_B_drop1 -v DROPRED=1 work/masked.tsv
echo
echo "=== 6. SYNTHETIC (NOT REAL DATA) centroid-window bias: noise-free injection at z_true=7.0451 on the real grid/mask, amplitudes+widths = the real primary fit"
INJ=$($AWK '/^MF / { ln = ($0 ~ /line=Hbeta/) ? 1 : (($0 ~ /line=Halpha/) ? 4 : 0); if (!ln) next; a = ""; s = ""; for (i = 1; i <= NF; i++) { if ($i ~ /^A=/) a = substr($i, 3); if ($i ~ /^sigma_int_kms=/) s = substr($i, 15) } if (a != "") out = out (out == "" ? "" : " ") ln ":" a ":" s } END { print out }' work/primary.out)
echo "synthetic injection spec (line:A[1e-20 cgs]:sigma_int[km/s], parsed from primary real-data fit): $INJ"
$C -f awk/synth.awk -v MODE=inject -v NOISE=0 -v ZTRUE=7.0451 -v SET=B -v INJ="$INJ" -v OUT=work/syn0.tsv work/masked.tsv 2>&1
$C -f awk/continuum.awk -v OUT=work/syn0c.tsv work/syn0.tsv >/dev/null
$C -f awk/centroid.awk -v SET=B -v TAG=SYNTHETIC work/syn0c.tsv | $AWK -f awk/bias.awk -v ZTRUE=7.0451
echo "--- SYNTHETIC matched-filter recovery, noise-free, z_true=7.0451 (RM and POLY1)"
$M -v SET=B -v TAG=SYNTHETIC_rm -v LINES="1 4" work/syn0c.tsv
$M -v SET=B -v TAG=SYNTHETIC_poly1 -v ORD=1 -v LINES="1 4" work/syn0c.tsv
echo
echo "=== 7. comparison table (parsed from this log; ZF=Fortran 7.04221+-0.00027, ZP=published 7.0451+-0.0005)"
sleep 1; grep -E '^(MF|MFJ) ' $LOG_TMP | grep -v SYNTHETIC | $AWK -f awk/compare.awk -v PXHA=$PXHA
echo
echo "=== 8. test script (test.sh)"
bash test.sh
echo "=== finished $(date '+%Y-%m-%d %H:%M:%S %Z')"
}
LOG_TMP=work/log.tmp; export LOG_TMP
main 2>&1 | tee $LOG_TMP | tee $LOG
