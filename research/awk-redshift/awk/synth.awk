# SPDX-License-Identifier: AGPL-3.0-only
# synth.awk -- SYNTHETIC / CONTROL spectra built on the REAL wavelength grid, mask and error array.
#   *** OUTPUT OF THIS SCRIPT IS NOT REAL DATA. Every output file header in the logs says SYNTHETIC. ***
# in : work/masked.tsv  (idx wl_A flam eflam ok cont clipped)         out: -v OUT=file (idx wl_A flam eflam ok; mask.awk layout)
# MODE=inject : flam = K/lam^2 (flat-F_nu continuum, K = median(cont*lam^2) over valid pixels with lam>35000 A)
#               + sum_j A_j * t_j(z_true)  [pixel-integrated Gaussians, same LSF rule as matched.awk] + NOISE*N(0, eflam)
#               -v INJ="1:101.3:600 4:965.5:500"  (line:A[1e-20 erg/s/cm2]:sigma_int[km/s]),  -v ZTRUE  -v SET  -v LSFPX
# MODE=noise  : continuum only + NOISE*N(0,eflam)   (negative control: no line)
# MODE=shuffle: the REAL flam/eflam pairs permuted (seeded Fisher-Yates) inside -v RANGES="a-b c-d" (pixel idx ranges, valid pixels only)
#               (permutation control: destroys line coherence, keeps the pixel values/errors)
BEGIN {
  OFS = "\t"; if (SET == "") SET = "B"; if (LSFPX == "") LSFPX = 2.2; if (NOISE == "") NOISE = 1; if (SEED == "") SEED = 1
  if (MODE == "") MODE = "inject"; if (ZTRUE == "") ZTRUE = 7.0451
  CKMS = 299792.458; FW2S = 2.3548200450309493; srand(SEED); n = 0; m = 0
}
{ n++; I[n] = $1; LAM[n] = $2; F[n] = $3; E[n] = $4; OK[n] = $5; CT[n] = $6
  if ($5 == 1 && $2 > 35000) { m++; kk[m] = $6 * $2 * $2 } }
END {
  K = median(kk, m)
  printf "SYNTH-NOTE SYNTHETIC mode=%s seed=%d noise_scale=%g z_true=%s set=%s (NOT REAL DATA); K=median(cont*lam^2, lam>35000A)=%.6g from %d px\n", MODE, SEED, NOISE, ZTRUE, SET, K, m > "/dev/stderr"
  if (MODE == "shuffle") {
    nr = split(RANGES, RG, " ")
    for (p = 1; p <= n; p++) { OF[p] = F[p]; OE[p] = E[p] }
    for (r = 1; r <= nr; r++) {
      split(RG[r], ab, "-"); a = ab[1]; b = ab[2]; k = 0
      for (p = a; p <= b; p++) if (OK[p] == 1) { k++; PX[k] = p }
      for (j = k; j >= 2; j--) { u = 1 + int(rand() * j); t = PX[j]; PX[j] = PX[u]; PX[u] = t }  # PX = permutation of valid pixels in range
      q = 0
      for (p = a; p <= b; p++) if (OK[p] == 1) { q++; F[p] = OF[PX[q]]; E[p] = OE[PX[q]] }
      printf "SYNTH-NOTE SHUFFLE range=%s valid_px_permuted=%d\n", RG[r], k > "/dev/stderr"
    }
    for (p = 1; p <= n; p++) printf "%d\t%s\t%s\t%s\t%d\n", I[p], LAM[p], F[p], E[p], OK[p] > OUT
    exit
  }
  nj = (MODE == "inject") ? split(INJ, JJ, " ") : 0
  for (j = 1; j <= nj; j++) { split(JJ[j], qq, ":"); JL[j] = qq[1]; JA[j] = qq[2]; JS[j] = qq[3] }
  for (p = 1; p <= n; p++) {
    if (OK[p] != 1) { printf "%d\t%s\t0\t0\t0\n", I[p], LAM[p] > OUT; continue }
    pw = (p > 1 && p < n) ? (LAM[p+1] - LAM[p-1]) / 2 : 0
    f = K / (LAM[p] * LAM[p])
    for (j = 1; j <= nj; j++) {
      L = JL[j]; R = restwl(SET, L); mu = R * (1 + ZTRUE)
      # LSF sigma uses the pixel width at the pixel nearest the line centre (as matched.awk uses pw at its window-centre pixel)
      best = 1; bd = 1e30
      for (u = 2; u < n; u++) if (OK[u] == 1) { dd = abs(LAM[u] - mu); if (dd < bd) { bd = dd; best = u } }
      pwc = (LAM[best+1] - LAM[best-1]) / 2
      sl = LSFPX * pwc / FW2S; s = sqrt(sl * sl + (JS[j] / CKMS * mu) ^ 2)
      lo = (LAM[p-1] + LAM[p]) / 2; hi = (LAM[p] + LAM[p+1]) / 2
      f += JA[j] * (Phi((hi - mu) / s) - Phi((lo - mu) / s)) / pw
    }
    if (NOISE != 0) f += NOISE * E[p] * gauss()
    printf "%d\t%s\t%.10g\t%s\t1\n", I[p], LAM[p], f, E[p] > OUT
  }
}
