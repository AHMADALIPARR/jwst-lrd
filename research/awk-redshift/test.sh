#!/usr/bin/env bash
# SPDX-License-Identifier: AGPL-3.0-only
# test.sh -- PASS/FAIL tests with explicit counts. Run after run.sh (needs work/*.tsv and work/primary.out) or standalone after lib/prep.sh.
# Tolerances/criteria below were fixed BEFORE the tests were run; a FAIL is reported, not tuned away.
# Everything labelled SYNTHETIC or CONTROL is not real data and says nothing about the real redshift.
set -u
cd "$(dirname "$0")"
AWK=${AWK:-mawk}
C="$AWK -f awk/common.awk"
M="$C -f awk/matched.awk"
SHA=c0b878576d7d7ec723c5ee526d29715fb672d81e45bc8ba4e02598ce8b9c5ee7
. lib/fixtures.sh
NP=0; NF=0
t() { # name, ok(0/1), detail
  if [ "$2" = 1 ]; then NP=$((NP+1)); echo "PASS  $1 :: $3"; else NF=$((NF+1)); echo "FAIL  $1 :: $3"; fi
}
num() { $AWK -v a="$1" -v b="$2" -v tol="$3" 'BEGIN{d=a-b; if(d<0)d=-d; print (d<=tol)?1:0}'; }
kvget() { $AWK -v key="$2" '{for(i=1;i<=NF;i++){p=index($i,"="); if(p>0&&substr($i,1,p-1)==key){print substr($i,p+1); exit}}}' <<<"$1"; }
mkdir -p work
echo "=== test.sh $(date '+%Y-%m-%d %H:%M:%S %Z')"
echo "--- A. data integrity (real data)"
got=$(sha256sum "$SRC/raw/$SHA.fits" | cut -d' ' -f1)
t "A1 raw FITS sha256" $([ "$got" = "$SHA" ] && echo 1 || echo 0) "got=$got"
for a in wavelength flux flux_error; do
  n=$(wc -l < work/$a.txt); t "A2 $a.txt rows" $([ "$n" -eq 429 ] && echo 1 || echo 0) "rows=$n expected=429"
  want=$($AWK -F= -v k="arr.$a.sha256" '$1==k{print $2}' "$SRC/ingest/$SHA/manifest.kv"); g=$(sha256sum "$SRC/ingest/$SHA/$a.f64" | cut -d' ' -f1)
  t "A3 $a.f64 sha256 vs manifest.kv" $([ "$g" = "$want" ] && echo 1 || echo 0) "got=${g:0:16}.. want=${want:0:16}.."
done
nan=$($AWK -F= '$1=="col.FLUX.nan_count"{print $2}' "$SRC/ingest/$SHA/header.kv")
nm=$(wc -l < work/mask.log); nv=$($AWK -F'\t' '$5==1' work/masked0.tsv | wc -l)
t "A4 masked count equals header.kv col.FLUX.nan_count" $([ "$nm" -eq "$nan" ] && echo 1 || echo 0) "masked=$nm header_nan_count=$nan"
t "A5 valid pixel count" $([ "$nv" -eq 408 ] && echo 1 || echo 0) "valid=$nv expected=408 (429-21)"
bad=$($AWK -F'\t' '$5==1 && ($4<=0 || $3=="nan" || $3=="inf" || $3=="-nan" || $3=="-inf")' work/masked0.tsv | wc -l)
t "A6 no valid pixel has non-positive sigma or non-finite flux" $([ "$bad" -eq 0 ] && echo 1 || echo 0) "violations=$bad"
echo "--- B. unit tests of the awk building blocks (tiny hand-made inputs)"
r=$($AWK -f awk/common.awk -f /dev/stdin <<'AWKEOF'
BEGIN { mx = 0; n = 0; for (x = -3; x <= 3.0001; x += 0.05) { d = abs(erf(x) - erf_series(x)); if (d > mx) mx = d; n++ } printf "%d %.3e", n, mx }
AWKEOF
)
set -- $r; ok=$($AWK -v m="$2" 'BEGIN{print (m<=2e-7)?1:0}')
t "B1 erf (A&S 7.1.26) vs Maclaurin series, x in [-3,3]" $ok "points=$1 max|diff|=$2 tol=2e-7 (A&S bound 1.5e-7)"
r=$($AWK -f awk/common.awk -f /dev/stdin <<'AWKEOF'
BEGIN { a[1]=5; a[2]=1; a[3]=3; m1 = median(a, 3); b[1]=4; b[2]=1; b[3]=3; b[4]=2; m2 = median(b, 4); c[1]=2; c[2]=2; c[3]=2; c[4]=9; c[5]=1; m3 = median(c, 5); printf "%s %s %s", m1, m2, m3 }
AWKEOF
)
t "B2 median odd/even/duplicates" $([ "$r" = "3 2.5 2" ] && echo 1 || echo 0) "got='$r' expected='3 2.5 2'"
r=$($AWK -f awk/common.awk -f /dev/stdin <<'AWKEOF'
BEGIN { printf "%.3f", air2vac(6562.8) }
AWKEOF
)
t "B3 air2vac(6562.8) vs NIST ASD vacuum Halpha 6564.632 (tol 0.05 A)" $(num $r 6564.632 0.05) "got=$r NIST=6564.632"
# mask unit test: 8 rows -> expect masked 5 (nan flux, inf flux, err=0, err<0, nan wl), valid 3 (incl. one negative flux)
printf '1\t1.0\t1.0\t0.1\n2\t1.1\tnan\t0.1\n3\t1.2\tinf\t0.1\n4\t1.3\t1.0\t0\n5\t1.4\t1.0\t-0.2\n6\tnan\t1.0\t0.1\n7\t1.6\t-0.5\t0.1\n8\t1.7\t2.0\t0.1\n' > work/ut_mask_in.tsv
r=$($AWK -f awk/common.awk -f awk/mask.awk -v OUT=work/ut_mask_out.tsv -v MASKLOG=work/ut_mask.log work/ut_mask_in.tsv | head -1)
t "B4 mask.awk on 8-row hand-made input (CONTROL, not real)" $([ "$r" = "MASK pixels_total=8 valid=3 masked=5" ] && echo 1 || echo 0) "got='$r' expected='MASK pixels_total=8 valid=3 masked=5'"
# continuum unit test: constant 5 + linear 0.01*i, no outliers -> running median reproduces interior exactly
$AWK 'BEGIN{for(i=1;i<=100;i++) printf "%d\t%d\t%.6f\t0.1\t1\n", i, 1000+i*10, 5+0.01*i}' > work/ut_cont_in.tsv
$C -f awk/continuum.awk -v OUT=work/ut_cont_out.tsv work/ut_cont_in.tsv >/dev/null
r=$($AWK -F'\t' '$1>=13 && $1<=88 {d=$6-$3; if(d<0)d=-d; if(d>m)m=d; n++} END{printf "%d %.2e", n, m+0}' work/ut_cont_out.tsv)
set -- $r; t "B5 running median reproduces a linear continuum (interior px 13-88, CONTROL)" $($AWK -v m="$2" 'BEGIN{print (m<=1e-5)?1:0}') "pixels=$1 max|cont-true|=$2 tol=1e-5"
echo "--- C. SYNTHETIC injection-recovery, noise-free (NOT REAL DATA; flat-F_nu continuum + Gaussian lines on the real grid/mask)"
if [ ! -s work/primary.out ]; then t "C0 primary fit available" 0 "work/primary.out missing (run run.sh first)"; INJ=""; else
INJ=$($AWK '/^MF / { ln = ($0 ~ /line=Hbeta/) ? 1 : (($0 ~ /line=Halpha/) ? 4 : 0); if (!ln) next; a = ""; s = ""; for (i = 1; i <= NF; i++) { if ($i ~ /^A=/) a = substr($i, 3); if ($i ~ /^sigma_int_kms=/) s = substr($i, 15) } if (a != "") out = out (out == "" ? "" : " ") ln ":" a ":" s } END { print out }' work/primary.out)
echo "SYNTHETIC injection spec from the real primary fit (line:A:sigma_int_kms): $INJ"
for zt in 7.0451 7.0300 7.0600; do
  $C -f awk/synth.awk -v MODE=inject -v NOISE=0 -v ZTRUE=$zt -v SET=B -v INJ="$INJ" -v OUT=work/t_syn.tsv work/masked.tsv 2>/dev/null
  $C -f awk/continuum.awk -v OUT=work/t_sync.tsv work/t_syn.tsv >/dev/null
  for est in "RM:-1" "POLY1:1"; do
    nm=${est%%:*}; ord=${est##*:}
    out=$($M -v SET=B -v ORD=$ord -v LINES="1 4" -v JALL=0 work/t_sync.tsv)
    zj=$(kvget "$(grep '^MFJ' <<<"$out")" fine_z)
    zh=$(grep 'line=Halpha' <<<"$out" | $AWK '{for(i=1;i<=NF;i++){if($i~/^fine_z=/)print substr($i,8)}}')
    zb=$(grep 'line=Hbeta' <<<"$out" | $AWK '{for(i=1;i<=NF;i++){if($i~/^fine_z=/)print substr($i,8)}}')
    t "C1 SYNTHETIC noise-free joint recovery z_true=$zt est=$nm" $(num "${zj:-0}" $zt 2e-4) "z_joint=${zj:-none} |dz|=$($AWK -v a="${zj:-0}" -v b=$zt 'BEGIN{d=a-b;if(d<0)d=-d;printf "%.2e",d}') tol=2e-4"
    t "C2 SYNTHETIC noise-free Halpha-only recovery z_true=$zt est=$nm" $(num "${zh:-0}" $zt 2e-4) "z_Ha=${zh:-none} |dz|=$($AWK -v a="${zh:-0}" -v b=$zt 'BEGIN{d=a-b;if(d<0)d=-d;printf "%.2e",d}') tol=2e-4"
    echo "INFO  SYNTHETIC noise-free Hbeta-only est=$nm z_true=$zt: z_Hb=${zb:-none} (no pass criterion; RM continuum partly absorbs the weaker line, bias is reported not hidden)"
  done
done
echo "--- D. SYNTHETIC noisy recovery (NOT REAL DATA): N=40 realisations, noise = NOISE x N(0, real per-pixel sigma), z_true=7.0451"
for est in "RM:-1" "POLY1:1"; do
  nm=${est%%:*}; ord=${est##*:}; : > work/trials_$nm.txt
  for s in $(seq 1 40); do
    $C -f awk/synth.awk -v MODE=inject -v NOISE=1 -v SEED=$s -v ZTRUE=7.0451 -v SET=B -v INJ="$INJ" -v OUT=work/t_syn.tsv work/masked.tsv 2>/dev/null
    $C -f awk/continuum.awk -v OUT=work/t_sync.tsv work/t_syn.tsv >/dev/null
    $M -v SET=B -v ORD=$ord -v LINES="1 4" -v PLF=0 work/t_sync.tsv | grep '^MFJ' | $AWK -v s=$s '{for(i=1;i<=NF;i++){if($i~/^fine_z=/)z=substr($i,8); if($i~/^dz1_halfwidth=/)h=substr($i,16)} print s, z, h}' >> work/trials_$nm.txt
  done
  $AWK -v nm=$nm 'NF==3 {n++; d=$2-7.0451; s+=d; ss+=d*d; if (d<0) d=-d; if (d<=$3) cov++} END { m=s/n; sd=sqrt((ss-n*m*m)/(n-1)); printf "%d %.6f %.6f %d %.4f %.6f\n", n, m, sd, cov, cov/n, sd/sqrt(n) }' work/trials_$nm.txt > work/trialstat_$nm.txt
  set -- $(cat work/trialstat_$nm.txt)
  t "D1 SYNTHETIC joint fits obtained, est=$nm" $([ "$1" -eq 40 ] && echo 1 || echo 0) "n_joint_fits=$1 of 40"
  t "D2 SYNTHETIC mean bias consistent with 0 (|mean|<=3*sd/sqrt(N)), est=$nm" $($AWK -v m="$2" -v e="${6}" 'BEGIN{if(m<0)m=-m; print (m<=3*e)?1:0}') "mean(z-ztrue)=$2 sd=$3 sd/sqrtN=$6"
  t "D3 SYNTHETIC coverage of dchi2=1 interval in [0.45,0.90] (binomial 3-sigma around 0.68 for N=40), est=$nm" $($AWK -v c="$5" 'BEGIN{print (c>=0.45&&c<=0.90)?1:0}') "covered=$4 of $1 fraction=$5"
done
fi
echo "--- E. negative controls (NOT REAL DATA unless stated)"
if [ -s work/primary.out ]; then
  : > work/null_noise.txt
  for s in $(seq 101 140); do
    $C -f awk/synth.awk -v MODE=noise -v NOISE=1 -v SEED=$s -v SET=B -v OUT=work/t_syn.tsv work/masked.tsv 2>/dev/null
    $C -f awk/continuum.awk -v OUT=work/t_sync.tsv work/t_syn.tsv >/dev/null
    $M -v SET=B -v LINES="1 4" -v JALL=0 -v PLF=0 work/t_sync.tsv | $AWK -v s=$s '/^MF /{ l = ($0 ~ /line=Hbeta/) ? "Hb" : "Ha"; for(i=1;i<=NF;i++) if ($i ~ /^dchi2_vs_A0\(coarse\)=/) d = substr($i, 21); print s, l, d, ($0 ~ /NOT_DETECTED/) ? 0 : 1 }' >> work/null_noise.txt
  done
  for l in Hb Ha; do
    r=$($AWK -v l=$l '$2==l{n++; if($4==1)f++; if($3>mx)mx=$3} END{printf "%d %d %.2f", n, f+0, mx+0}' work/null_noise.txt); set -- $r
    t "E1 CONTROL noise-only (continuum+noise, no line): false detections at dchi2>=25, line=$l (criterion <=1 of 40)" $([ "$2" -le 1 ] && [ "$1" -eq 40 ] && echo 1 || echo 0) "trials=$1 false_detections=$2 max_dchi2=$3"
  done
  realHb=$(grep 'line=Hbeta' work/primary.out | $AWK '{for(i=1;i<=NF;i++) if($i ~ /^dchi2_vs_A0=/) print substr($i,13)}')
  realHa=$(grep 'line=Halpha' work/primary.out | $AWK '{for(i=1;i<=NF;i++) if($i ~ /^dchi2_vs_A0=/) print substr($i,13)}')
  : > work/null_shuf.txt
  for s in $(seq 201 240); do
    $C -f awk/synth.awk -v MODE=shuffle -v SEED=$s -v RANGES="246-270 405-429" -v OUT=work/t_syn.tsv work/masked.tsv 2>/dev/null
    $C -f awk/continuum.awk -v OUT=work/t_sync.tsv work/t_syn.tsv >/dev/null
    $M -v SET=B -v LINES="1 4" -v JALL=0 -v PLF=0 work/t_sync.tsv | $AWK -v s=$s '/^MF /{ l = ($0 ~ /line=Hbeta/) ? "Hb" : "Ha"; for(i=1;i<=NF;i++) if ($i ~ /^dchi2_vs_A0\(coarse\)=/) d = substr($i, 21); print s, l, d }' >> work/null_shuf.txt
  done
  for l in Hb Ha; do
    real=$([ $l = Hb ] && echo $realHb || echo $realHa)
    r=$($AWK -v l=$l -v real=$real '$2==l{n++; if($3>=real)ge++; v[n]=$3} END{ for(i=1;i<=n;i++)for(j=i+1;j<=n;j++) if(v[j]<v[i]){t=v[i];v[i]=v[j];v[j]=t}; printf "%d %d %.2f %.2f", n, ge+0, v[int((n+1)/2)], v[n] }' work/null_shuf.txt); set -- $r
    t "E2 CONTROL within-window pixel permutation (REAL pixel values, order destroyed): shuffled dchi2 >= real ($real) never, line=$l" $([ "$2" -eq 0 ] && [ "$1" -eq 40 ] && echo 1 || echo 0) "permutations=$1 n_ge_real=$2 median_shuffled=$3 max_shuffled=$4 => permutation p < $($AWK 'BEGIN{printf "%.3f",1/41}')"
  done
fi
echo "=== SUMMARY: PASS=$NP FAIL=$NF total=$((NP+NF))"
[ "$NF" -eq 0 ]
