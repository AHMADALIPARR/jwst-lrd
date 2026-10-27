# SPDX-License-Identifier: AGPL-3.0-only
# centroid.awk -- FFT-free flux-weighted centroid redshift per line with observed-frame half-window scan.
# run: awk -f common.awk -f centroid.awk -v SET=B -v WLIST="100 150 ... 400" work/masked.tsv   (input = continuum.awk output)
# d_i = flam_i - running-median continuum_i over valid pixels with |lam_i - c| <= W (observed Angstrom half-window).
# c = sum(lam d)/sum(d).  FIXED: window centred on the strongest S/N pixel of the line's z-band (no re-centring).
# ITER : window re-centred on c until |dc|<0.01 A (max 50 its); NONCONV if it fails to settle.
# sigma_c^2 = sum((lam_i - c)^2 e_i^2)/(sum d)^2  (normalisation held fixed; approximate).
# z = c/R - 1, R from restwl(SET,L).   -v LINES="1 4" (default)   -v DROPRED=N drops last N valid pixels
# A centroid with fewer than MINPIX (default 3) pixels in the window is reported NA (its error would be 0/undefined).
BEGIN {
  OFS = "\t"
  if (SET == "") SET = "B"; if (LINES == "") LINES = "1 4"; if (DROPRED == "") DROPRED = 0
  if (WLIST == "") WLIST = "100 125 150 175 200 225 250 275 300 325 350 375 400"
  if (ZMIN == "") ZMIN = 7.00; if (ZMAX == "") ZMAX = 7.08; if (TAG == "") TAG = "-"
  if (MINPIX == "") MINPIX = 3
  nl = split(LINES, LL, " "); nw = split(WLIST, WL, " ")
  n = 0; nv = 0
}
{ n++; LAM[n] = $2; FL[n] = $3; ER[n] = $4; OK[n] = $5; CT[n] = $6
  if ($5 == 1) { nv++; VL[nv] = n } }
function cen(c0, W, st,   p, sd, s, se, m) {
  sd = 0; s = 0; m = 0
  for (p = 1; p <= n; p++) if (OKW[p] == 1 && LAM[p] >= c0 - W && LAM[p] <= c0 + W) { d = FL[p] - CT[p]; sd += d; s += LAM[p] * d; m++ }
  CN = m; if (m < MINPIX || sd <= 0) { CC_ = "NA"; return }
  CC_ = s / sd
  se = 0
  for (p = 1; p <= n; p++) if (OKW[p] == 1 && LAM[p] >= c0 - W && LAM[p] <= c0 + W) se += (LAM[p] - CC_) ^ 2 * ER[p] * ER[p]
  CE = sqrt(se) / abs(sd)
}
END {
  for (p = 1; p <= n; p++) OKW[p] = OK[p]
  for (j = nv - DROPRED + 1; j <= nv; j++) if (DROPRED > 0 && j >= 1) OKW[VL[j]] = 0
  for (i = 1; i <= nl; i++) {
    L = LL[i]; R = restwl(SET, L)
    lo = R * (1 + ZMIN); hi = R * (1 + ZMAX); best = 0; bsn = -1e30
    for (p = 1; p <= n; p++) if (OKW[p] == 1 && LAM[p] >= lo && LAM[p] <= hi) { sn = (FL[p] - CT[p]) / ER[p]; if (sn > bsn) { bsn = sn; best = p } }
    c0 = LAM[best]
    for (w = 1; w <= nw; w++) {
      W = WL[w]
      cen(c0, W); zf = "NA"; zfe = "NA"; nf = CN
      if (CC_ != "NA") { zf = CC_ / R - 1; zfe = CE / R }
      # iterated
      c = c0; st = "ok"; zi = "NA"; zie = "NA"; ni = 0
      for (it = 1; it <= 50; it++) {
        cen(c, W)
        if (CC_ == "NA") { st = "FAIL(npix<MINPIX_or_nonpositive_sum)"; break }
        dcc = CC_ - c; c = CC_; ni = it
        if (abs(dcc) < 0.01) break
        if (it == 50) st = "NONCONV"
      }
      if (st != "FAIL(npix<MINPIX_or_nonpositive_sum)") { zi = c / R - 1; zie = CE / R }
      ZF[L,w] = zf; ZFE[L,w] = zfe; ZI[L,w] = zi; ZIE[L,w] = zie
      printf "CEN set=%s dropred=%d tag=%s line=%s W_obsA=%d npix_fixed=%d z_fixed=%s z_err=%s z_iter=%s iters=%d iter_status=%s\n", SET, DROPRED, TAG, linename(L), W, nf, (zf == "NA" ? "NA" : sprintf("%.6f", zf)), (zfe == "NA" ? "NA" : sprintf("%.6f", zfe)), (zi == "NA" ? "NA" : sprintf("%.6f", zi)), ni, st
    }
  }
  # window-sensitivity summary + joint
  for (i = 1; i <= nl; i++) {
    L = LL[i]
    for (m = 0; m < 2; m++) {
      mn = 1e9; mx = -1e9; s = 0; ss = 0; k = 0
      for (w = 1; w <= nw; w++) { v = (m == 0) ? ZF[L,w] : ZI[L,w]; if (v == "NA") continue; k++; s += v; ss += v * v; if (v < mn) mn = v; if (v > mx) mx = v }
      if (k > 1) printf "CENSUM set=%s dropred=%d tag=%s line=%s kind=%s nW=%d min=%.6f max=%.6f range=%.6f mean=%.6f sd_over_windows=%.6f\n", SET, DROPRED, TAG, linename(L), (m == 0 ? "fixed" : "iter"), k, mn, mx, mx - mn, s / k, sqrt((ss - k * (s / k) ^ 2) / (k - 1))
    }
  }
  if (nl == 2) for (w = 1; w <= nw; w++) for (m = 0; m < 2; m++) {
    a = (m == 0) ? ZF[LL[1],w] : ZI[LL[1],w]; ae = (m == 0) ? ZFE[LL[1],w] : ZIE[LL[1],w]
    b = (m == 0) ? ZF[LL[2],w] : ZI[LL[2],w]; be = (m == 0) ? ZFE[LL[2],w] : ZIE[LL[2],w]
    if (a == "NA" || b == "NA") continue
    wa = 1 / (ae * ae); wb = 1 / (be * be); zj = (wa * a + wb * b) / (wa + wb); ej = 1 / sqrt(wa + wb)
    printf "CENJ set=%s dropred=%d tag=%s kind=%s W_obsA=%d z_joint_ivmean=%.6f err=%.6f\n", SET, DROPRED, TAG, (m == 0 ? "fixed" : "iter"), WL[w], zj, ej
  }
}
