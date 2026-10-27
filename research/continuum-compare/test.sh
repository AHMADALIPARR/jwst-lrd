#!/usr/bin/env bash
# SPDX-License-Identifier: AGPL-3.0-only
# test.sh -- PASS/FAIL counts for the continuum-model comparison. Run AFTER ./run.sh (reads results/run.log, results/jobs/*.out).
# Tools: bash, mawk, GNU Octave (not MATLAB), gfortran xcheck. SYNTHETIC controls are labelled SYNTHETIC and are not data.
set -u
cd "$(dirname "$0")"
P=0; F=0
ok()   { P=$((P+1)); echo "PASS  $1"; }
bad()  { F=$((F+1)); echo "FAIL  $1"; }
chk()  { if [ "$1" = 1 ]; then ok "$2"; else bad "$2"; fi; }
info() { echo "INFO  $1"; }
# numeric helper: |a-b| < tol  -> 1
near() { mawk -v a="$1" -v b="$2" -v t="$3" 'BEGIN{d=a-b; if(d<0)d=-d; print (d<t)?1:0}'; }
field() { mawk -v k="$2" '{for(i=1;i<=NF;i++){split($i,a,"="); if(a[1]==k){print a[2]; exit}}}' <<<"$1"; }
LOG=results/run.log
echo "== T1 pre-registration"
chk $(sha256sum -c PREREG.sha256 >/dev/null 2>&1 && echo 1 || echo 0) "PREREG.md matches PREREG.sha256"
echo "== T2 fixture and pixel counts"
chk $(grep -c '^SHA-OK   raw.fits c0b878576d7d7ec723c5ee526d29715fb672d81e45bc8ba4e02598ce8b9c5ee7' $LOG) "fixture sha256 c0b87857... verified in run.log"
n=$(mawk 'END{print NR}' work/cc_input.tsv); v=$(mawk '$5==1{c++} END{print c+0}' work/cc_input.tsv)
chk $([ "$n" = 429 ] && [ "$v" = 408 ] && echo 1 || echo 0) "429 pixels, 408 valid, $((n-v)) masked (got n=$n valid=$v)"
echo "== T3 engine validation (Octave vs awk-sp reference numbers; PREREG s8: 2e-5; runmed 1e-6)"
while read -r m ref; do
  l=$(grep "^VAL awkwindow model=$m " $LOG | head -1); z=$(field "$l" zJ)
  chk $([ -n "$z" ] && near "$z" "$ref" 2e-5 || echo 0) "awk-sp window z, $m: Octave $z vs reference $ref"
done <<'REF'
RM12 7.040280
P1 7.041836
P2 7.042200
REF
d=$(grep '^VAL runmed12' $LOG | sed 's/.*maxabsdiff=\([^ ]*\).*/\1/')
chk $([ -n "$d" ] && mawk -v d="$d" 'BEGIN{print (d<1e-6)?1:0}' || echo 0) "running median Octave vs continuum.awk max|diff|=$d (< 1e-6)"
echo "== T4 independent Fortran 2018 cross-check vs Octave (polynomial, 1C, joint z)"
for sc in 0 1 2 3 4; do for o in 0 1 2 3; do
  fz=$(./fortran/xcheck work/cc_input.tsv $o $sc | head -1 | sed 's/.*zJ= *\([0-9.]*\).*/\1/')
  l=$(grep -h "^FIT model=P$o comp=1C scen=D$sc " results/jobs/fit_P${o}_1C_D$sc.out 2>/dev/null | head -1); oz=$(field "$l" zJ)
  if [ "$sc" -le 1 ]; then chk $([ -n "$oz" ] && near "$fz" "$oz" 2e-5 || echo 0) "P$o D$sc Fortran $fz vs Octave $oz"
  else info "P$o D$sc Fortran $fz vs Octave $oz diff=$(mawk -v a=$fz -v b="${oz:-0}" 'BEGIN{printf "%.2e",a-b}') (not asserted: PREREG s8 asserts D0,D1 only)"; fi
done; done
echo "== T5 Octave unit tests (cc_unit)"
UT=$(octave -q --no-gui --eval "addpath('octave'); cc_unit()" 2>&1)
echo "$UT" | grep '^UT ' | cut -c1-160
up=$(echo "$UT" | grep -c '^UT PASS'); uf=$(echo "$UT" | grep -c '^UT FAIL')
P=$((P+up)); F=$((F+uf)); echo "unit tests: PASS=$up FAIL=$uf"
echo "== T6 SYNTHETIC noise-free injection-recovery, z_true=7.0451 (SYNTHETIC; NOT data). Asserted only where the generating family is contained (PREREG s8, tol 3e-5)"
for m in P1 P2 P3 SPL PLLIN; do for c in 1C 2C; do
  l=$(grep -h '^SYNTHETIC kind=noisefree' results/jobs/syn_noisefree_${m}_$c.out 2>/dev/null | head -1); b=$(field "$l" bias)
  chk $([ -n "$b" ] && mawk -v b="$b" 'BEGIN{print (b<3e-5 && b>-3e-5)?1:0}' || echo 0) "SYNTHETIC noise-free recovery $m/$c bias=$b"
done; done
for m in RM6 RM12 RM20 P0 PL; do for c in 1C 2C; do
  l=$(grep -h '^SYNTHETIC kind=noisefree' results/jobs/syn_noisefree_${m}_$c.out 2>/dev/null | head -1); info "SYNTHETIC noise-free $m/$c (family not contained; not asserted) bias=$(field "$l" bias)"
done; done
for f in results/jobs/syn_edge_*.out; do grep -h '^SYNTHETIC kind=edge' $f | sed 's/^/INFO  /'; done
grep -h 'SYNTHETIC SUMMARY' results/jobs/syn_noisy_*.out | sed 's/^/INFO  /'
echo "== T7 job completion and report parsing"
nj=$(ls results/jobs/*.out 2>/dev/null | wc -l); nf=$(grep -L '^exit=0$' results/jobs/*.out 2>/dev/null | wc -l)
chk $([ "$nj" = 244 ] && echo 1 || echo 0) "244 job outputs present (got $nj)"
chk $([ "$nf" = 0 ] && echo 1 || echo 0) "no failed jobs (exit!=0): $nf"
nfit=$(cat results/jobs/fit_*.out | grep -c '^FIT ')
chk $([ "$nfit" = 180 ] && echo 1 || echo 0) "180 FIT records (10 models x 2 comps x 9 scenarios; got $nfit)"
chk $(grep -q 'REPORT records parsed: 180' $LOG && echo 1 || echo 0) "cc_report parsed 180 records"
echo "== T8 housekeeping"
miss=$(grep -L 'SPDX-License-Identifier: AGPL-3.0-only' $(find . -type f \( -name '*.sh' -o -name '*.awk' -o -name '*.m' -o -name '*.f90' -o -name '*.md' \) -not -path './work/*' -not -path './results/*') 2>/dev/null)
chk $([ -z "$miss" ] && echo 1 || echo 0) "AGPL-3.0-only SPDX header in every source file ${miss:+(missing: $miss)}"
bp=$(find . -type f \( -name '*.py' -o -name '*.js' -o -name '*.ts' \) | wc -l)
chk $([ "$bp" = 0 ] && echo 1 || echo 0) "no .py/.js/.ts files ($bp found)"
echo
echo "TOTAL PASS=$P FAIL=$F"
[ "$F" = 0 ]
