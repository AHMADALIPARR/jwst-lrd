-- SPDX-License-Identifier: AGPL-3.0-only
-- Also subject to the SnapKitty Opaque License; see LICENSE and
-- SNAPKITTY_OPAQUE_LICENSE.md at the repository root.
--
-- JWST-LRD Futhark kernels (all f64).  Units and formulas are documented
-- in futhark/README.md and futhark/ABI.md.

-- ---------------------------------------------------------------------
-- 1. Wavelength conversion
-- ---------------------------------------------------------------------
-- Vacuum -> air: refractive index of Morton (2000, ApJS 130, 403), the IAU
-- standard, derived from Birch & Downs (1994, Metrologia 31, 315); dry air,
-- 1 atm, 15 C, 0.045% CO2.  As published in the VALD3 documentation
-- (https://www.astro.uu.se/valdwiki/Air-to-vacuum%20conversion):
--   s = 1e4 / lambda_vac   (lambda_vac in Angstrom)
--   n = 1 + 0.0000834254 + 0.02406147 / (130 - s^2) + 0.00015998 / (38.9 - s^2)
--   lambda_air = lambda_vac / n
-- Air -> vacuum: inverse formula derived by N. Piskunov (same VALD page):
--   s = 1e4 / lambda_air
--   n = 1 + 0.00008336624212083 + 0.02408926869968 / (130.1065924522 - s^2)
--         + 0.0001599740894897 / (38.92568793293 - s^2)
--   lambda_vac = lambda_air * n
-- Domain: following VALD, conversion is only applied for wavelengths
-- >= 2000 Angstrom; shorter wavelengths are returned unchanged (the
-- formula has poles near 877 A and 1603 A).

def air_vac_min_A : f64 = 2000.0

def morton_n (lam_vac_A: f64) : f64 =
  let s = 1.0e4 / lam_vac_A
  let s2 = s * s
  in 1.0 + 0.0000834254 + 0.02406147 / (130.0 - s2) + 0.00015998 / (38.9 - s2)

def piskunov_n (lam_air_A: f64) : f64 =
  let s = 1.0e4 / lam_air_A
  let s2 = s * s
  in 1.0 + 0.00008336624212083 + 0.02408926869968 / (130.1065924522 - s2)
     + 0.0001599740894897 / (38.92568793293 - s2)

def vac2air (l: f64) : f64 = if l < air_vac_min_A then l else l / morton_n l
def air2vac (l: f64) : f64 = if l < air_vac_min_A then l else l * piskunov_n l

-- 1 micron = 1e4 Angstrom (exact).
def um_per_A : f64 = 1.0e-4
def A_per_um : f64 = 1.0e4

entry vac_to_air [n] (lam_vac_A: [n]f64) : [n]f64 = map vac2air lam_vac_A
entry air_to_vac [n] (lam_air_A: [n]f64) : [n]f64 = map air2vac lam_air_A
entry um_to_angstrom [n] (lam_um: [n]f64) : [n]f64 = map (* A_per_um) lam_um
entry angstrom_to_um [n] (lam_A: [n]f64) : [n]f64 = map (/ A_per_um) lam_A

-- ---------------------------------------------------------------------
-- 2. Rest-frame shift: lambda_rest = lambda_obs / (1 + z)
-- ---------------------------------------------------------------------
entry rest_frame [n] (z: f64) (lam_obs: [n]f64) : [n]f64 =
  map (\l -> l / (1.0 + z)) lam_obs

entry obs_frame [n] (z: f64) (lam_rest: [n]f64) : [n]f64 =
  map (\l -> l * (1.0 + z)) lam_rest

-- ---------------------------------------------------------------------
-- 3. f_nu <-> f_lambda with first-order uncertainty propagation
-- ---------------------------------------------------------------------
-- c = 299792458 m/s (exact, SI) = 2.99792458e18 Angstrom/s.
-- lambda in Angstrom, f_lambda in erg s^-1 cm^-2 A^-1, f_nu in
-- erg s^-1 cm^-2 Hz^-1.
--   f_nu = f_lambda * lambda^2 / c
--   sigma_fnu^2 = (lambda^2/c * sigma_flam)^2 + (2 f_lambda lambda / c * sigma_lam)^2
--   f_lambda = f_nu * c / lambda^2
--   sigma_flam^2 = (c/lambda^2 * sigma_fnu)^2 + (2 f_nu c / lambda^3 * sigma_lam)^2
-- Assumption: flux and wavelength errors are independent (no covariance);
-- pass sigma_lam = 0 when no wavelength uncertainty is available.
def c_A_per_s : f64 = 2.99792458e18

def flam2fnu1 (l: f64) (sl: f64) (f: f64) (sf: f64) : (f64, f64) =
  let a = l * l / c_A_per_s
  let t1 = a * sf
  let t2 = 2.0 * f * l / c_A_per_s * sl
  in (f * a, f64.sqrt (t1 * t1 + t2 * t2))

def fnu2flam1 (l: f64) (sl: f64) (f: f64) (sf: f64) : (f64, f64) =
  let a = c_A_per_s / (l * l)
  let t1 = a * sf
  let t2 = 2.0 * f * a / l * sl
  in (f * a, f64.sqrt (t1 * t1 + t2 * t2))

entry flam_to_fnu [n] (lam_A: [n]f64) (sig_lam_A: [n]f64)
                      (flam: [n]f64) (sig_flam: [n]f64) : ([n]f64, [n]f64) =
  unzip (map4 flam2fnu1 lam_A sig_lam_A flam sig_flam)

entry fnu_to_flam [n] (lam_A: [n]f64) (sig_lam_A: [n]f64)
                      (fnu: [n]f64) (sig_fnu: [n]f64) : ([n]f64, [n]f64) =
  unzip (map4 fnu2flam1 lam_A sig_lam_A fnu sig_fnu)

-- Jy -> f_lambda: 1 Jy = 1e-23 erg s^-1 cm^-2 Hz^-1 (exact by definition).
-- f_lambda = 1e-23 f_Jy c / lambda^2  [erg s^-1 cm^-2 A^-1], lambda in A;
-- sigma propagated exactly as fnu_to_flam (independent flux and
-- wavelength errors; sigma_lam = 0 when unknown):
--   sigma_flam^2 = (1e-23 c/lambda^2 sigma_Jy)^2 + (2e-23 f_Jy c/lambda^3 sigma_lam)^2
def jy_cgs : f64 = 1.0e-23

entry jy_to_flam [n] (lam_A: [n]f64) (sig_lam_A: [n]f64)
                     (f_jy: [n]f64) (sig_jy: [n]f64) : ([n]f64, [n]f64) =
  unzip (map4 (\l sl f sf -> fnu2flam1 l sl (jy_cgs * f) (jy_cgs * sf))
              lam_A sig_lam_A f_jy sig_jy)

-- ---------------------------------------------------------------------
-- 4. Residuals and chi-square
-- ---------------------------------------------------------------------
-- residual = data - model; chi2 = sum((data - model)^2 / sigma^2).
-- Pixels with sigma <= 0 or any non-finite input get weight 0 (masked).
def isfin (x: f64) : bool = !(f64.isnan x || f64.isinf x)

def valid (d: f64) (m: f64) (s: f64) : bool =
  s > 0.0 && isfin s && isfin d && isfin m

entry residuals [n] (data: [n]f64) (model: [n]f64) : [n]f64 =
  map2 (-) data model

entry chi2 [n] (data: [n]f64) (model: [n]f64) (sigma: [n]f64) : f64 =
  f64.sum (map3 (\d m s -> if valid d m s then let r = (d - m) / s in r * r
                           else 0.0) data model sigma)

-- ---------------------------------------------------------------------
-- 5. Gaussian line profile and batched redshift grid search
-- ---------------------------------------------------------------------
-- g(x) = cont + amp * exp(-0.5 * ((x - center)/sigma)^2)
-- Integral of the line part over the real line: amp * sigma * sqrt(2 pi).
def gauss1 (amp: f64) (center: f64) (sigma: f64) (x: f64) : f64 =
  let u = (x - center) / sigma
  in amp * f64.exp (-0.5 * u * u)

entry gauss_model [n] (amp: f64) (center: f64) (sigma: f64) (cont: f64)
                      (lam: [n]f64) : [n]f64 =
  map (\x -> cont + gauss1 amp center sigma x) lam

-- Basis function j at redshift z: j < k is line j with unit amplitude,
-- observed center centers[j]*(1+z) and observed width widths[j]*(1+z);
-- j == k is the constant continuum (1 if fit_cont, else 0).
def basis [k] (fit_cont: bool) (centers: [k]f64) (widths: [k]f64)
              (z: f64) (x: f64) (j: i64) : f64 =
  if j < k then gauss1 1.0 (centers[j] * (1.0 + z)) (widths[j] * (1.0 + z)) x
  else if fit_cont then 1.0 else 0.0

-- Gauss-Jordan elimination without pivoting on the symmetric positive
-- semi-definite normal matrix.  A column whose eliminated pivot is
-- <= 1e-12 * its original diagonal (or whose diagonal is 0) is treated as
-- degenerate: its parameter is fixed to 0 and its row/column zeroed.
def solve_spd [p] (A0: [p][p]f64) (b0: [p]f64) : [p]f64 =
  let diag0 = map (\i -> A0[i, i]) (iota p)
  let (_, b) =
    loop (A, b) = (copy A0, copy b0) for c < p do
      let piv = A[c, c]
      in if !(piv > 1.0e-12 * diag0[c]) || !(diag0[c] > 0.0) then
           let A' = map2 (\i row ->
                            if i == c then map (\j -> if j == c then 1.0 else 0.0) (iota p)
                            else map2 (\j v -> if j == c then 0.0 else v) (iota p) row)
                         (iota p) A
           let b' = map2 (\i v -> if i == c then 0.0 else v) (iota p) b
           in (A', b')
         else
           let rowc = map (/ piv) A[c]
           let bc = b[c] / piv
           let b' = map2 (\i v -> if i == c then bc else v - A[i, c] * bc) (iota p) b
           let A' = map2 (\i row ->
                            if i == c then rowc
                            else let f = row[c] in map2 (\v rc -> v - f * rc) row rowc)
                         (iota p) A
           in (A', b')
  in b

-- Weighted linear least-squares fit of the line amplitudes (and the
-- continuum) at one redshift.  Pixels with sigma <= 0 or non-finite
-- sigma, flux or wavelength are masked (weight 0).  Returns (chi2, params) with params of
-- length k+1: k line amplitudes followed by the continuum level.
def fit_at_z [n][k] (lam: [n]f64) (flux: [n]f64) (sigma: [n]f64)
                    (centers: [k]f64) (widths: [k]f64) (fit_cont: bool)
                    (z: f64) : (f64, [k+1]f64) =
  let p = k + 1
  let w = map3 (\d s x -> if s > 0.0 && isfin s && isfin d && isfin x
                         then 1.0 / (s * s) else 0.0) flux sigma lam
  -- masked pixels: flux and wavelength replaced by 0 so no NaN leaks in
  let y = map2 (\d wi -> if wi > 0.0 then d else 0.0) flux w
  let xs = map2 (\x wi -> if wi > 0.0 then x else 0.0) lam w
  let B = map (\x -> map (basis fit_cont centers widths z x) (iota p)) xs
  let M = map (\i -> map (\j -> f64.sum (map2 (\bx wi -> wi * bx[i] * bx[j]) B w))
                         (iota p)) (iota p)
  let r = map (\i -> f64.sum (map3 (\bx wi yi -> wi * bx[i] * yi) B w y)) (iota p)
  let a = solve_spd M r
  let c2 = f64.sum (map3 (\bx wi yi ->
                            let m = f64.sum (map2 (*) bx a)
                            let d = yi - m
                            in wi * d * d) B w y)
  in (c2, a)

-- Batched grid search over z (map over the z grid).
-- LIMITATION: no LSF, fixed line widths, test kernel, not a redshift
-- measurement.  Line widths are fixed inputs (no instrumental line-spread
-- function, no width fit); only linear amplitudes and continuum are fitted.
-- Returns (chi2 per z, [best_z, best_index_as_f64], best params [k+1]).
-- Ties are broken towards the lowest index; NaN chi2 never wins.
entry zgrid_search [n][k][m] (lam: [n]f64) (flux: [n]f64) (sigma: [n]f64)
                             (centers: [k]f64) (widths: [k]f64)
                             (fit_cont: bool) (zgrid: [m]f64)
                           : ([m]f64, [2]f64, [k+1]f64) =
  let fits = map (fit_at_z lam flux sigma centers widths fit_cont) zgrid
  let chis = map (.0) fits
  let better (c1: f64, i1: i64) (c2: f64, i2: i64) =
    if i1 < 0 then (c2, i2) else if i2 < 0 then (c1, i1)
    else if f64.isnan c2 then (c1, i1) else if f64.isnan c1 then (c2, i2)
    else if c2 < c1 || (c2 == c1 && i2 < i1) then (c2, i2) else (c1, i1)
  let (_, bi) = reduce_comm better (f64.inf, -1) (zip chis (iota m))
  let bz = if bi >= 0 then zgrid[bi] else f64.nan
  let params = if bi >= 0 then fits[bi].1 else replicate (k + 1) f64.nan
  in (chis, [bz, f64.i64 bi], params)

-- ---------------------------------------------------------------------
-- Helpers used by the test harness (not science kernels)
-- ---------------------------------------------------------------------
-- Deterministic SYNTHETIC spectrum: linear wavelength grid [l0,l1], lines
-- at centers*(1+z) with widths*(1+z), amplitudes amps, constant cont, and
-- pseudo-random Gaussian noise of standard deviation noise (splitmix64 +
-- Box-Muller).  Returns (lam, flux, sigma) with sigma = noise everywhere.
def splitmix (x: u64) : u64 =
  let z = x + 0x9E3779B97F4A7C15
  let z = (z ^ (z >> 30)) * 0xBF58476D1CE4E5B9
  let z = (z ^ (z >> 27)) * 0x94D049BB133111EB
  in z ^ (z >> 31)

def unif (x: u64) : f64 = (f64.u64 (x >> 11) + 0.5) * (1.0 / 9007199254740992.0)

entry synth_spectrum [k] (n: i64) (l0: f64) (l1: f64) (z: f64)
                         (centers: [k]f64) (widths: [k]f64) (amps: [k]f64)
                         (cont: f64) (noise: f64) (seed: i64)
                       : ([n]f64, [n]f64, [n]f64) =
  let lam = map (\i -> l0 + (l1 - l0) * f64.i64 i / f64.i64 (n - 1)) (iota n)
  let clean = map (\x -> cont + f64.sum (map3 (\c w a -> gauss1 a (c * (1.0 + z)) (w * (1.0 + z)) x)
                                              centers widths amps)) lam
  let eps = map (\i -> let h1 = splitmix (u64.i64 seed * 0x100000001B3 + u64.i64 (2 * i))
                       let h2 = splitmix (h1 + u64.i64 (2 * i + 1))
                       let u1 = unif h1
                       let u2 = unif h2
                       in f64.sqrt (-2.0 * f64.log u1) * f64.cos (2.0 * f64.pi * u2)) (iota n)
  let flux = map2 (\c e -> c + noise * e) clean eps
  in (lam, flux, replicate n noise)

-- Element-wise comparison: ok iff |a-b| <= atol + rtol*|b| for all i,
-- with NaN == NaN accepted (both masked identically); exact equality
-- always passes (so atol = rtol = 0 demands bit-for-bit agreement).
-- Returns [ok (1/0), max |a-b|, max |a-b|/(atol + rtol*|b|)].
entry compare_arrays [n] (atol: f64) (rtol: f64) (a: [n]f64) (b: [n]f64) : [3]f64 =
  let d = map2 (\x y -> if f64.isnan x && f64.isnan y then 0.0 else f64.abs (x - y)) a b
  let q = map2 (\di y -> if di == 0.0 then 0.0 else di / (atol + rtol * f64.abs y)) d b
  let ok = all (\qi -> qi <= 1.0) q
  in [if ok then 1.0 else 0.0, f64.maximum d, f64.maximum q]

-- Identity on f64 arrays: used to turn decimal text into binary (mk) and
-- binary into text (dump).
entry ident [n] (a: [n]f64) : [n]f64 = a
