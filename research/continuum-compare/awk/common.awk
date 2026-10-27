# SPDX-License-Identifier: AGPL-3.0-only
# common.awk -- shared awk functions (POSIX awk subset; developed/run on mawk 1.3.4).
# Charter: no Python/JS/TS; awk + bash + od only. Never invent numbers.

function abs(x) { return x < 0 ? -x : x }

# finite decimal/exponent number test on the *string* (mawk/gawk both parse "nan"/"inf"
# inconsistently, so finiteness is decided textually, before any arithmetic).
function isfin(s) {
  return (s ~ /^[-+]?([0-9]+\.?[0-9]*|\.[0-9]+)([eE][-+]?[0-9]+)?$/)
}

# erf: Abramowitz & Stegun (1964) eq. 7.1.26, max |error| = 1.5e-7.
function erf(x,   s, t, y) {
  s = 1; if (x < 0) { s = -1; x = -x }
  t = 1.0 / (1.0 + 0.3275911 * x)
  y = 1.0 - (((((1.061405429 * t - 1.453152027) * t) + 1.421413741) * t - 0.284496736) * t + 0.254829592) * t * exp(-x * x)
  return s * y
}
function Phi(u) { return 0.5 * (1.0 + erf(u * 0.70710678118654752)) }

# erf by Maclaurin series (slow, accurate); used only by test.sh as an independent reference.
function erf_series(x,   n, term, sum) {
  term = x; sum = x
  for (n = 1; n < 80; n++) { term = -term * x * x / n; sum += term / (2 * n + 1) }
  return 1.1283791670955126 * sum
}

# median of a[1..n] (copy + insertion sort; n is small)
function median(a, n,   i, j, v, b) {
  for (i = 1; i <= n; i++) b[i] = a[i]
  for (i = 2; i <= n; i++) { v = b[i]; j = i - 1; while (j >= 1 && b[j] > v) { b[j+1] = b[j]; j-- } b[j+1] = v }
  if (n % 2) return b[(n + 1) / 2]
  return 0.5 * (b[n / 2] + b[n / 2 + 1])
}

# Edlen (1966)/Morton (1991, ApJS 77, 119) refractivity of standard air as function of the VACUUM
# wavenumber s = 1e4/lambda_vac[A] (um^-1):  n-1 = 8.34254e-5 + 2.406147e-2/(130-s^2) + 1.5998e-4/(38.9-s^2)
# air2vac(): lambda_vac = lambda_air * n(lambda_vac), solved by fixed-point iteration.
function air2vac(la,   lv, k, s2, n) {
  lv = la
  for (k = 0; k < 8; k++) {
    s2 = (1e4 / lv) ^ 2
    n = 1 + 8.34254e-5 + 2.406147e-2 / (130 - s2) + 1.5998e-4 / (38.9 - s2)
    lv = la * n
  }
  return lv
}

# Gauss-Jordan solve of M*p = b (m x m) with partial pivoting; global arrays GM[i,j], Gb[i], Gp[i].
# returns 0 on success, 1 if singular.
function gsolve(m,   i, j, k, piv, pr, f, t) {
  for (i = 1; i <= m; i++) {
    pr = i; piv = abs(GM[i,i])
    for (k = i + 1; k <= m; k++) if (abs(GM[k,i]) > piv) { piv = abs(GM[k,i]); pr = k }
    if (piv < 1e-300) return 1
    if (pr != i) {
      for (j = 1; j <= m; j++) { t = GM[i,j]; GM[i,j] = GM[pr,j]; GM[pr,j] = t }
      t = Gb[i]; Gb[i] = Gb[pr]; Gb[pr] = t
    }
    for (k = 1; k <= m; k++) if (k != i) {
      f = GM[k,i] / GM[i,i]
      if (f != 0) { for (j = i; j <= m; j++) GM[k,j] -= f * GM[i,j]; Gb[k] -= f * Gb[i] }
    }
  }
  for (i = 1; i <= m; i++) Gp[i] = Gb[i] / GM[i,i]
  return 0
}

# Box-Muller standard normal (uses awk rand(); seed with srand(SEED) in caller)
function gauss(   u1, u2) {
  u1 = rand(); while (u1 < 1e-12) u1 = rand()
  u2 = rand()
  return sqrt(-2 * log(u1)) * cos(6.283185307179586 * u2)
}

# in-place insertion sort a[1..n] (n small)
function isort(a, n,   i, j, v) {
  for (i = 2; i <= n; i++) { v = a[i]; j = i - 1; while (j >= 1 && a[j] > v) { a[j+1] = a[j]; j-- } a[j+1] = v }
}

# rest-wavelength set selector.  Returns vacuum-Angstrom-or-as-labelled rest wavelength for line index L=1..4
#  1 Hbeta, 2 [OIII]4959, 3 [OIII]5007, 4 Halpha
#  set A: values exactly as specified in the task ("4861.35, 4958.9, 5006.8, 6562.8"); these are the standard AIR wavelengths
#  set B: NIST ASD v5.12 Ritz VACUUM wavelengths, same values as fortran/src/lrd_lines.f90 line_vac_ang
#  set C: set A converted air->vacuum with air2vac() (Edlen/Morton)
function restwl(set, L) {
  if (set == "A") { if (L==1) return 4861.35; if (L==2) return 4958.9; if (L==3) return 5006.8; return 6562.8 }
  if (set == "B") { if (L==1) return 4862.691; if (L==2) return 4960.295; if (L==3) return 5008.240; return 6564.632 }
  if (set == "C") { return air2vac(restwl("A", L)) }
  return -1
}
function linename(L) { return (L==1) ? "Hbeta" : (L==2) ? "OIII4959" : (L==3) ? "OIII5007" : "Halpha" }
