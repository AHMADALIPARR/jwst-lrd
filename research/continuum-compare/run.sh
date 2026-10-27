#!/usr/bin/env bash
# SPDX-License-Identifier: AGPL-3.0-only
# run.sh -- controlled continuum-model comparison for the QSO1 (Abell 2744-QSO1) redshift. Scratch tree; read-only on the fixture.
# Tools: mawk (data prep/mask/export), GNU Octave (fitting engine), gfortran -std=f2018 (independent cross-check). No Python/JS/TS. Maxima is not installed (not used).
# usage: ./run.sh   (NPAR=8 parallel Octave jobs; fixtures: $SRC > <repo root>/fixtures > $LRD_SHARED/fixtures)
set -u
cd "$(dirname "$0")"
NPAR=${NPAR:-8}
# --- pre-registration check: abort if PREREG.md changed after its hash was recorded
if ! sha256sum -c PREREG.sha256 >/dev/null 2>&1; then echo "FATAL: PREREG.md does not match PREREG.sha256"; exit 2; fi
mkdir -p results/jobs work; rm -f work/* results/jobs/* results/run.log
LOG=results/run.log
main() {
echo "=== run.sh started $(date '+%Y-%m-%d %H:%M:%S %Z') host=$(hostname)"
echo "=== PREREG hash verified: $(cat PREREG.sha256)"
echo "=== tool versions"
mawk -W version 2>&1 | head -1; octave --version | head -1; gfortran --version | head -1
echo "maxima: $(command -v maxima || echo 'NOT INSTALLED (not used)')"
echo "=== script sha256"
sha256sum run.sh test.sh PREREG.md lib/*.sh awk/*.awk octave/*.m fortran/xcheck.f90
echo
echo "=== 0. data verification and export (lib/prep.sh, mask.awk, export.awk)"
bash lib/prep.sh || { echo "FATAL: prep failed"; exit 1; }
C="mawk -f awk/common.awk"
$C -f awk/mask.awk -v OUT=work/masked0.tsv -v MASKLOG=work/mask.log work/spectrum.tsv
echo "--- work/mask.log (verbatim)"; cat work/mask.log
mawk -f awk/export.awk work/spectrum.tsv work/masked0.tsv > work/cc_input.tsv
echo "rows(cc_input.tsv)=$(wc -l < work/cc_input.tsv)  sha256=$(sha256sum work/cc_input.tsv | cut -d' ' -f1)"
$C -f awk/continuum.awk -v OUT=work/cont12.tsv work/masked0.tsv | tail -3
echo
echo "=== 1. build independent Fortran cross-check"
( cd fortran && gfortran -std=f2018 -O2 -Wall -Wextra -o xcheck xcheck.f90 ) 2>&1 && echo "xcheck built"
echo
echo "=== 2. engine validation (Octave vs awk-sp numbers, vs continuum.awk)"
octave -q --no-gui --eval "addpath('octave'); cc_validate()" 2>&1
echo
echo "=== 3. Fortran xcheck: polynomial orders 0..3, red-edge drops D0..D4"
for d in 0 1 2 3 4; do for o in 0 1 2 3; do ./fortran/xcheck work/cc_input.tsv $o $d | head -1; done; done
echo
echo "=== 4. job list"
: > work/jobs.txt
add() { echo "$1|$2" >> work/jobs.txt; }
MN=(0 RM6 RM12 RM20 P0 P1 P2 P3 PL PLLIN SPL)
for mi in 1 2 3 4 5 6 7 8 9 10; do for comp in 1 2; do
  for sc in D0 D1 D2 D3 D4 ERRALL ERREDGE; do add "fit_${MN[$mi]}_${comp}C_$sc" "cc_job($mi,$comp,'$sc',12)"; done
  for bw in 8 6; do add "fit_${MN[$mi]}_${comp}C_BW$bw" "cc_job($mi,$comp,'D0',$bw)"; done
  add "loo_${MN[$mi]}_${comp}C" "cc_loo($mi,$comp)"
  add "syn_noisefree_${MN[$mi]}_${comp}C" "cc_syn('noisefree',$mi,$comp)"
  add "syn_edge_${MN[$mi]}_${comp}C" "cc_syn('edge',$mi,$comp)"
done; done
for mi in 2 5 6 10; do add "syn_noisy_${MN[$mi]}_1C" "cc_syn('noisy',$mi,1,30)"; done
echo "jobs: $(wc -l < work/jobs.txt)  parallel: $NPAR"
# longest first (2C jobs, noisy) for load balance
sort -r work/jobs.txt > work/jobs.sorted
T0=$(date +%s)
xargs -d '\n' -n 1 -P "$NPAR" bash lib/job.sh < work/jobs.sorted
echo "jobs finished in $(( $(date +%s) - T0 )) s; failed jobs (exit!=0): $(grep -L '^exit=0$' results/jobs/*.out | wc -l)"
grep -L '^exit=0$' results/jobs/*.out
echo
echo "=== 5. verbatim FIT records (all models x scenarios)"
cat results/jobs/fit_*.out | grep -v "^exit=" | grep -v "^MASKLOG"
echo "--- mask logs (verbatim, one per scenario)"
grep -h "^MASKLOG" results/jobs/fit_RM6_1C_*.out | sort -u
echo
echo "=== 6. Halpha leave-one-out (D0)"
cat results/jobs/loo_*.out | grep -v '^exit='
echo
echo "=== 7. SYNTHETIC controls (NOT data)"
cat results/jobs/syn_noisefree_*.out results/jobs/syn_edge_*.out | grep -v '^exit=' | grep -v 'SYNTHETIC setup' 
grep -h 'SYNTHETIC setup' results/jobs/syn_noisefree_P1_1C.out
cat results/jobs/syn_noisy_*.out | grep -h 'SUMMARY'
echo
echo "=== 8. existing Fortran reference lines (verbatim copy of lines from fixtures/reference/<sha>/zinvest.kv, read-only)"
. lib/fixtures.sh; ZK="$SRC"/reference/c0b878576d7d7ec723c5ee526d29715fb672d81e45bc8ba4e02598ce8b9c5ee7/zinvest.kv
if [ -r "$ZK" ]; then sha256sum "$ZK"; grep -E '^(source_sha256|a\.lsf\.joint|a\.centroid|a\.point\.joint)' "$ZK"; else echo "zinvest.kv not found"; fi
echo
echo "=== 8b. sigma-grid boundary tally (awk/gridtally.awk)"
cat results/jobs/fit_*.out | mawk -f awk/gridtally.awk
echo
echo "=== 8c. PREREG range R3 over exactly the 7 scenarios (awk/r3strict.awk)"
cat results/jobs/fit_*.out | mawk -f awk/r3strict.awk
echo
echo "=== 9. analysis (PREREG criteria applied by octave/cc_report.m)"
octave -q --no-gui --eval "addpath('octave'); cc_report()" 2>&1
echo "=== run.sh finished $(date '+%Y-%m-%d %H:%M:%S %Z')"
}
main 2>&1 | tee "$LOG"
