# SPDX-License-Identifier: AGPL-3.0-only
# matched.awk -- inverse-variance matched filter / chi^2 profile of Gaussian line templates vs z.
# run: awk -f common.awk -f matched.awk -v SET=B ... work/masked.tsv     (input = continuum.awk output)
# Model per line L (window of up to 2*HW+1 valid pixels about the strongest pixel in the line's z-band):
#     d_k = P(x_k) + A * t_k(z, sigma_int)      A >= 0 (emission only), weights w_k = 1/e_k^2
#   ORD <  0 : "RM" estimator. d = flam - running-median continuum; P = 0 (pure matched filter, closed form).
#   ORD >= 0 : "POLY" estimator. d = flam (no continuum subtraction); P = polynomial of order ORD in x=(lam-lam_ip)/pw_ip,
#              fitted simultaneously with A (weighted linear LSQ, normal equations).
# t_k = pixel-integrated unit-area Gaussian (erf over pixel edges) / pixel width, mean at R*(1+z),
#       sigma^2 = sigma_LSF^2 + (sigma_int/c * R(1+z))^2,  sigma_LSF = LSFPX * pw_ip / 2.35482 (prism LSF FWHM in pixels).
# Profile over sigma_int = 0..SMAX km/s step SSTEP (per line, per z): chi^2(z) = min_sigma chi^2(z,sigma).
# Peak z = argmin chi^2 on grid ZMIN..ZMAX step DZ (coarse), then a fine grid (FDZ) of +-FSPAN about the coarse peak.
# Interval: Delta chi^2 = 1 crossings (linear interpolation on the fine grid) AND the same rescaled by chi2_red when >1.
# Parameters (-v): SET(A|B|C) ORD HW LSFPX SMAX SSTEP ZMIN ZMAX DZ FDZ FSPAN LINES JALL BOOT SEED DROPRED TAG
BEGIN {
  OFS = "\t"
  if (SET == "") SET = "B"; if (ORD == "") ORD = -1; if (HW == "") HW = 5; if (LSFPX == "") LSFPX = 2.2
  if (SMAX == "") SMAX = 4000; if (SSTEP == "") SSTEP = 100
  if (ZMIN == "") ZMIN = 7.00; if (ZMAX == "") ZMAX = 7.08; if (DZ == "") DZ = 1e-4
  if (FDZ == "") FDZ = 1e-5; if (FSPAN == "") FSPAN = 0.006
  if (LINES == "") LINES = "1 2 3 4"; if (JALL == "") JALL = 1; if (BOOT == "") BOOT = 0; if (SEED == "") SEED = 12345
  if (DROPRED == "") DROPRED = 0
  if (TAG == "") TAG = "-"
  if (DETTHR == "") DETTHR = 25; if (PLF == "") PLF = 1
  NP = (ORD < 0) ? 0 : ORD + 1
  CKMS = 299792.458; FW2S = 2.3548200450309493
  nsg = int(SMAX / SSTEP + 0.5) + 1
  nl = split(LINES, LL, " ")
  n = 0; nv = 0; TGTD = 1
}
{ n++; LAM[n] = $2; FL[n] = $3; ER[n] = $4; OK[n] = $5; CT[n] = $6; IDX[n] = $1
  if ($5 == 1) { nv++; VL[nv] = n } }

# build window arrays for line L
function setupline(L,   p, lo, hi, best, bsn, sn, k, q) {
  R[L] = restwl(SET, L)
  lo = R[L] * (1 + ZMIN); hi = R[L] * (1 + ZMAX)
  best = 0; bsn = -1e30
  for (p = 1; p <= n; p++) if (OKW[p] == 1 && LAM[p] >= lo && LAM[p] <= hi) {
    sn = (FL[p] - CT[p]) / ER[p]; if (sn > bsn) { bsn = sn; best = p }
  }
  IP[L] = best; PSN[L] = bsn
  q = best
  PWI[L] = (LAM[q+1] - LAM[q-1]) / 2
  k = 0
  for (p = q - HW; p <= q + HW; p++) {
    if (p < 2 || p >= n) continue
    if (OKW[p] != 1) continue
    k++
    DDR[L,k] = (ORD < 0) ? FL[p] - CT[p] : FL[p]
    WW[L,k] = 1 / (ER[p] * ER[p])
    PWK[L,k] = (LAM[p+1] - LAM[p-1]) / 2
    WLO[L,k] = (LAM[p-1] + LAM[p]) / 2
    WHI[L,k] = (LAM[p] + LAM[p+1]) / 2
    WX[L,k] = (LAM[p] - LAM[q]) / PWI[L]
    EK[L,k] = ER[p]
  }
  WN[L] = k
  resetdata(L)
}
function resetdata(L,   k) { for (k = 1; k <= WN[L]; k++) { KI[L,k] = k; DDW[L,k] = DDR[L,k] } prepline(L) }

# z-independent normal-equation pieces (recomputed whenever DDW/KI change: bootstrap)
function prepline(L,   k, kk, i, j, w, d, xi, xj) {
  SDD[L] = 0
  for (i = 1; i <= NP; i++) { PD[L,i] = 0; for (j = 1; j <= NP; j++) PP[L,i,j] = 0 }
  for (k = 1; k <= WN[L]; k++) {
    kk = KI[L,k]; w = WW[L,kk]; d = DDW[L,kk]
    SDD[L] += w * d * d
    for (i = 1; i <= NP; i++) {
      xi = (i == 1) ? 1 : WX[L,kk] ^ (i - 1)
      PD[L,i] += w * xi * d
      for (j = 1; j <= NP; j++) { xj = (j == 1) ? 1 : WX[L,kk] ^ (j - 1); PP[L,i,j] += w * xi * xj }
    }
  }
  if (NP == 0) C0[L] = SDD[L]
  else {
    for (i = 1; i <= NP; i++) { Gb[i] = PD[L,i]; for (j = 1; j <= NP; j++) GM[i,j] = PP[L,i,j] }
    gsolve(NP); C0[L] = SDD[L]; for (i = 1; i <= NP; i++) C0[L] -= Gp[i] * PD[L,i]
  }
}

# chi^2 of line L at observed centre mu and total Gaussian sigma s (A>=0). sets ACUR.
function chi2(L, mu, s,   k, kk, t, w, d, stt, sdt, i, j, xi, m, spt) {
  stt = 0; sdt = 0
  for (i = 1; i <= NP; i++) spt[i] = 0
  for (k = 1; k <= WN[L]; k++) {
    kk = KI[L,k]
    t = (Phi((WHI[L,kk] - mu) / s) - Phi((WLO[L,kk] - mu) / s)) / PWK[L,kk]
    w = WW[L,kk]; d = DDW[L,kk]
    stt += w * t * t; sdt += w * d * t
    for (i = 1; i <= NP; i++) { xi = (i == 1) ? 1 : WX[L,kk] ^ (i - 1); spt[i] += w * xi * t }
  }
  if (stt <= 0) { ACUR = 0; return C0[L] }
  if (NP == 0) {
    ACUR = sdt / stt
    if (ACUR <= 0) { ACUR = 0; return C0[L] }
    return SDD[L] - sdt * sdt / stt
  }
  m = NP + 1
  for (i = 1; i <= NP; i++) { for (j = 1; j <= NP; j++) GM[i,j] = PP[L,i,j]; GM[i,m] = spt[i]; GM[m,i] = spt[i]; Gb[i] = PD[L,i] }
  GM[m,m] = stt; Gb[m] = sdt
  if (gsolve(m)) { ACUR = 0; return C0[L] }
  if (Gp[m] <= 0) { ACUR = 0; return C0[L] }
  ACUR = Gp[m]
  return chi2_direct(L, mu, s)
}
# chi^2 evaluated directly at the solved parameters Gp[] (robust to in-place reduction inside gsolve)
function chi2_direct(L, mu, s,   k, kk, t, mdl, i, d, tot) {
  tot = 0
  for (k = 1; k <= WN[L]; k++) {
    kk = KI[L,k]
    t = (Phi((WHI[L,kk] - mu) / s) - Phi((WLO[L,kk] - mu) / s)) / PWK[L,kk]
    mdl = Gp[NP+1] * t
    for (i = 1; i <= NP; i++) mdl += Gp[i] * ((i == 1) ? 1 : WX[L,kk] ^ (i - 1))
    d = DDW[L,kk] - mdl; tot += WW[L,kk] * d * d
  }
  return tot
}

# profile over sigma_int at redshift z; returns min chi^2; sets BSIG, BAMP
function prof(L, z,   mu, sl, g, sg, si, s, c, cm) {
  mu = R[L] * (1 + z)
  sl = LSFPX * PWI[L] / FW2S
  cm = 1e300
  for (g = 0; g < nsg; g++) {
    sg = g * SSTEP; si = sg / CKMS * mu
    s = sqrt(sl * sl + si * si)
    c = chi2(L, mu, s)
    if (c < cm) { cm = c; BSIG = sg; BAMP = ACUR }
  }
  return cm
}
function scan(S, L, z0, dz, nz,   g, c) {
  for (g = 1; g <= nz; g++) { c = prof(L, z0 + (g - 1) * dz); CC[S,L,g] = c; CS[S,L,g] = BSIG; CA[S,L,g] = BAMP }
}

# analyse curve JJ[key,g], g=1..nz on grid (z0,dz): sets PKG, PKZ (parabolic), CMIN, LOZ, HIZ (crossing of CMIN+TGTD)
function analyse(key, z0, dz, nz,   g, gm, cm, v, a, b, c, den, tgt, f) {
  cm = 1e300; gm = 1
  for (g = 1; g <= nz; g++) { v = JJ[key, g]; if (v < cm) { cm = v; gm = g } }
  PKG = gm; CMIN = cm
  PKZ = z0 + (gm - 1) * dz
  if (gm > 1 && gm < nz) {
    a = JJ[key, gm-1]; b = JJ[key, gm]; c = JJ[key, gm+1]; den = a - 2 * b + c
    if (den > 0) PKZ = PKZ - 0.5 * dz * (c - a) / den
  }
  EDGE = (gm == 1 || gm == nz) ? 1 : 0
  tgt = cm + TGTD
  LOZ = "NA"; HIZ = "NA"
  for (g = gm; g >= 2; g--) if (JJ[key, g-1] > tgt) { f = (tgt - JJ[key, g]) / (JJ[key, g-1] - JJ[key, g]); LOZ = z0 + (g - 1 - f) * dz; break }
  for (g = gm; g <= nz - 1; g++) if (JJ[key, g+1] > tgt) { f = (tgt - JJ[key, g]) / (JJ[key, g+1] - JJ[key, g]); HIZ = z0 + (g - 1 + f) * dz; break }
}
function fz(x) { return (x == "NA") ? "NA" : sprintf("%.6f", x) }
function hw_(lo, hi) { return (lo == "NA" || hi == "NA") ? "NA" : sprintf("%.6f", (hi - lo) / 2) }

END {
  if (n == 0) { print "matched.awk: no input" > "/dev/stderr"; exit 1 }
  # optional red-end pixel drop (sensitivity): drop the last DROPRED valid pixels from every window
  for (p = 1; p <= n; p++) OKW[p] = OK[p]
  for (j = nv - DROPRED + 1; j <= nv; j++) if (DROPRED > 0 && j >= 1) OKW[VL[j]] = 0
  nz = int((ZMAX - ZMIN) / DZ + 0.5) + 1
  for (i = 1; i <= nl; i++) setupline(LL[i])
  hdr = sprintf("set=%s est=%s ord=%d hw=%d lsfpx=%g smax=%g dropred=%d tag=%s", SET, (ORD < 0 ? "RM" : "POLY"), ORD, HW, LSFPX, SMAX, DROPRED, TAG)
  nfz = int(2 * FSPAN / FDZ + 0.5) + 1
  for (i = 1; i <= nl; i++) scan(0, LL[i], ZMIN, DZ, nz)
  for (i = 1; i <= nl; i++) {
    L = LL[i]
    for (g = 1; g <= nz; g++) JJ["c" L, g] = CC[0,L,g]
    TGTD = 1; analyse("c" L, ZMIN, DZ, nz); cz = PKZ; cedge = EDGE
    dchi_c = C0[L] - CMIN
    det = (dchi_c >= DETTHR && !cedge) ? 1 : 0
    if (!det) {
      printf "MF %s line=%s rest=%.4f ip=%d lam_ip=%.2f nwin=%d snr_peakpix=%.2f NOT_DETECTED dchi2_vs_A0(coarse)=%.3f (<%g or peak at grid edge) coarse_z=%.5f%s (no fine fit/interval reported)\n", hdr, linename(L), R[L], IP[L], LAM[IP[L]], WN[L], PSN[L], dchi_c, DETTHR, cz, (cedge ? "(EDGE)" : "")
      continue
    }
    if (PLF == 0) { printf "MF %s line=%s rest=%.4f ip=%d nwin=%d coarse_z=%.5f dchi2_vs_A0(coarse)=%.3f (per-line fine scan skipped, PLF=0)\n", hdr, linename(L), R[L], IP[L], WN[L], cz, dchi_c; continue }
    f0 = PKZ - FSPAN
    scan(L, L, f0, FDZ, nfz)
    for (g = 1; g <= nfz; g++) JJ["f" L, g] = CC[L,L,g]
    TGTD = 1; analyse("f" L, f0, FDZ, nfz)
    dchi = C0[L] - CMIN; lo1 = LOZ; hi1 = HIZ; zpk = PKZ; gpk = PKG
    dof = WN[L] - NP - 3; red = (dof > 0) ? CMIN / dof : 1
    TGTD = (red > 1) ? red : 1; analyse("f" L, f0, FDZ, nfz); lo2 = LOZ; hi2 = HIZ
    TGTD = 1
    FZ[L] = zpk; FHW[L] = (lo1 == "NA" || hi1 == "NA") ? "NA" : (hi1 - lo1) / 2
    SIGB[L] = CS[L,L,gpk]; AMPB[L] = CA[L,L,gpk]
    printf "MF %s line=%s rest=%.4f ip=%d lam_ip=%.2f nwin=%d snr_peakpix=%.2f coarse_z=%.5f fine_z=%.6f dz1_lo=%s dz1_hi=%s dz1_halfwidth=%s chi2min=%.3f dof=%d chi2red=%.3f scaled_lo=%s scaled_hi=%s scaled_halfwidth=%s sigma_int_kms=%g A=%.5g dchi2_vs_A0=%.3f\n", hdr, linename(L), R[L], IP[L], LAM[IP[L]], WN[L], PSN[L], cz, zpk, fz(lo1), fz(hi1), hw_(lo1, hi1), CMIN, dof, red, fz(lo2), fz(hi2), hw_(lo2, hi2), SIGB[L], AMPB[L], dchi
  }
  hasHb = 0; hasHa = 0; for (i = 1; i <= nl; i++) { if (LL[i] == 1) hasHb = 1; if (LL[i] == 4) hasHa = 1 }
  if (hasHb && hasHa) dojoint("HbHa", "1 4")
  if (JALL && nl == 4) dojoint("ALL4", "1 2 3 4")
  if (BOOT > 0 && ORD < 0 && hasHb && hasHa) boot()
}

function dojoint(name, ls,   la, nlin, i, g, f0, nfj, s, c0sum, zc, jedge, sg, am, dofj, redj, lo1, hi1, lo2, hi2, zpk, gpk, cmin) {
  nlin = split(ls, la, " ")
  for (g = 1; g <= nz; g++) { s = 0; for (i = 1; i <= nlin; i++) s += CC[0, la[i], g]; JJ["jc", g] = s }
  TGTD = 1; analyse("jc", ZMIN, DZ, nz); zc = PKZ; jedge = EDGE
  f0 = PKZ - 0.004; nfj = int(2 * 0.004 / FDZ + 0.5) + 1
  for (i = 1; i <= nlin; i++) scan(10 + i, la[i], f0, FDZ, nfj)
  for (g = 1; g <= nfj; g++) { s = 0; for (i = 1; i <= nlin; i++) s += CC[10 + i, la[i], g]; JJ["jf", g] = s }
  TGTD = 1; analyse("jf", f0, FDZ, nfj)
  zpk = PKZ; gpk = PKG; cmin = CMIN; lo1 = LOZ; hi1 = HIZ
  c0sum = 0; dofj = 0
  for (i = 1; i <= nlin; i++) { c0sum += C0[la[i]]; dofj += WN[la[i]] - NP - 2 }
  dofj -= 1   # one shared z
  redj = (dofj > 0) ? cmin / dofj : 1
  TGTD = (redj > 1) ? redj : 1; analyse("jf", f0, FDZ, nfj); lo2 = LOZ; hi2 = HIZ; TGTD = 1
  sg = ""; am = ""
  for (i = 1; i <= nlin; i++) { sg = sg (i > 1 ? "," : "") CS[10 + i, la[i], gpk]; am = am (i > 1 ? "," : "") sprintf("%.4g", CA[10 + i, la[i], gpk]) }
  printf "MFJ %s joint=%s coarse_z=%.5f%s fine_z=%.6f dz1_lo=%s dz1_hi=%s dz1_halfwidth=%s chi2min=%.3f dof=%d chi2red=%.3f scaled_lo=%s scaled_hi=%s scaled_halfwidth=%s sigma_int_kms=[%s] A=[%s] dchi2_vs_A0=%.3f\n", hdr, name, zc, (jedge ? "(EDGE)" : ""), zpk, fz(lo1), fz(hi1), hw_(lo1, hi1), cmin, dofj, redj, fz(lo2), fz(hi2), hw_(lo2, hi2), sg, am, c0sum - cmin
  if (name == "HbHa") { JZ = zpk; JSIG1 = CS[11, 1, gpk]; JSIG4 = CS[12, 4, gpk]; JA1 = CA[11, 1, gpk]; JA4 = CA[12, 4, gpk] }
}

# Hb+Ha joint z fit with sigma_int fixed at the joint best-fit values, on the CURRENT data arrays; returns parabolic peak or "EDGE"
function zfit_fixed(zb,   i, L, g, nzb, z0, dzb, sg, mu, sl, s, best, gb, tot, a, b, cc, den, arr, z, zz) {
  nzb = 401; dzb = 4e-5; z0 = zb - 0.008
  best = 1e300; gb = 1
  for (g = 1; g <= nzb; g++) {
    tot = 0; z = z0 + (g - 1) * dzb
    for (i = 1; i <= 2; i++) {
      L = (i == 1) ? 1 : 4; sg = (i == 1) ? JSIG1 : JSIG4
      mu = R[L] * (1 + z); sl = LSFPX * PWI[L] / FW2S; s = sqrt(sl * sl + (sg / CKMS * mu) ^ 2)
      tot += chi2(L, mu, s)
    }
    arr[g] = tot; if (tot < best) { best = tot; gb = g }
  }
  if (gb == 1 || gb == nzb) return "EDGE"
  a = arr[gb-1]; b = arr[gb]; cc = arr[gb+1]; den = a - 2 * b + cc
  zz = z0 + (gb - 1) * dzb
  if (den > 0) zz -= 0.5 * dzb * (cc - a) / den
  return zz
}

function boot(   r, i, L, k, t, mu, sl, s, sg, amp, zr, nok, vals, sum, ssq, nfail) {
  srand(SEED)
  zb = JZ
  # ---- parametric bootstrap: model(best fit) + N(0, e_k) noise; sigma_int fixed at best fit
  nok = 0; nfail = 0; sum = 0; ssq = 0
  for (r = 1; r <= BOOT; r++) {
    for (i = 1; i <= 2; i++) {
      L = (i == 1) ? 1 : 4; sg = (i == 1) ? JSIG1 : JSIG4; amp = (i == 1) ? JA1 : JA4
      mu = R[L] * (1 + zb); sl = LSFPX * PWI[L] / FW2S; s = sqrt(sl * sl + (sg / CKMS * mu) ^ 2)
      for (k = 1; k <= WN[L]; k++) {
        t = (Phi((WHI[L,k] - mu) / s) - Phi((WLO[L,k] - mu) / s)) / PWK[L,k]
        DDW[L,k] = amp * t + EK[L,k] * gauss(); KI[L,k] = k
      }
      prepline(L)
    }
    zr = zfit_fixed(zb)
    if (zr == "EDGE") { nfail++; continue }
    nok++; vals[nok] = zr; sum += zr; ssq += zr * zr
  }
  bootreport("param", nok, nfail, vals, sum, ssq)
  # ---- case bootstrap: resample window pixels (with replacement) of the REAL data
  for (i = 1; i <= 2; i++) resetdata((i == 1) ? 1 : 4)
  nok = 0; nfail = 0; sum = 0; ssq = 0
  for (r = 1; r <= BOOT; r++) {
    for (i = 1; i <= 2; i++) {
      L = (i == 1) ? 1 : 4
      for (k = 1; k <= WN[L]; k++) KI[L,k] = 1 + int(rand() * WN[L])
      prepline(L)
    }
    zr = zfit_fixed(zb)
    if (zr == "EDGE") { nfail++; continue }
    nok++; vals[nok] = zr; sum += zr; ssq += zr * zr
  }
  bootreport("case", nok, nfail, vals, sum, ssq)
  for (i = 1; i <= 2; i++) resetdata((i == 1) ? 1 : 4)
}
function bootreport(kind, nok, nfail, vals, sum, ssq,   mean, sd, p16, p50, p84) {
  if (nok < 2) { printf "BOOT %s kind=%s N=%d ok=%d edge_fail=%d (too few)\n", hdr, kind, BOOT, nok, nfail; return }
  mean = sum / nok; sd = sqrt((ssq - nok * mean * mean) / (nok - 1))
  isort(vals, nok)
  p16 = vals[int(0.16 * nok) + 1]; p50 = vals[int(0.5 * nok) + 1]; p84 = vals[int(0.84 * nok) + 1]
  printf "BOOT %s kind=%s joint=HbHa N=%d ok=%d edge_fail=%d seed=%d z_mean=%.6f z_sd=%.6f p16=%.6f p50=%.6f p84=%.6f (sigma_int fixed at best fit)\n", hdr, kind, BOOT, nok, nfail, SEED, mean, sd, p16, p50, p84
}
