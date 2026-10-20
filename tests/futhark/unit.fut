-- SPDX-License-Identifier: AGPL-3.0-only
-- Also subject to the SnapKitty Opaque License; see LICENSE and
-- SNAPKITTY_OPAQUE_LICENSE.md at the repository root.
--
-- Analytic unit tests for futhark/lrd.fut.  Every test entry returns
-- (pass, metric, tolerance); `futhark test` checks pass == true and
-- run.sh prints PASS/FAIL per entry with the metric on failure.

import "../../futhark/lrd"

def relerr (a: f64) (b: f64) : f64 = f64.abs (a - b) / f64.abs b
def maxrel [n] (a: [n]f64) (b: [n]f64) : f64 = f64.maximum (map2 relerr a b)
def linspace (n: i64) (a: f64) (b: f64) : [n]f64 =
  map (\i -> a + (b - a) * f64.i64 i / f64.i64 (n - 1)) (iota n)
def trapz [n] (x: [n]f64) (y: [n]f64) : f64 =
  f64.sum (map (\i -> 0.5 * (x[i+1] - x[i]) * (y[i+1] + y[i])) (iota (n - 1)))
def res (m: f64) (tol: f64) : (bool, f64, f64) = (m <= tol, m, tol)

-- Integral of the line part over +-33 sigma, trapezoid with step sigma/300:
-- exact value amp*sigma*sqrt(2 pi).  Tolerance 1e-10 relative.
-- ==
-- entry: t_gauss_integral
-- input { 0i64 } output { true }
def d_gauss_integral (_: i64) : (bool, f64, f64) =
  let (amp, c, s) = (2.5, 5000.0, 3.0)
  let x = linspace 20001 4900.0 5100.0
  let y = gauss_model amp c s 0.0 x
  let exact = amp * s * f64.sqrt (2.0 * f64.pi)
  in res (relerr (trapz x y) exact) 1.0e-10

-- With continuum: integral of (model - cont) is unchanged.  Tol 1e-10 rel.
-- ==
-- entry: t_gauss_integral_cont
-- input { 0i64 } output { true }
def d_gauss_integral_cont (_: i64) : (bool, f64, f64) =
  let (amp, c, s, k) = (0.7, 20000.0, 12.5, 3.25)
  let x = linspace 40001 19000.0 21000.0
  let y = map (\v -> v - k) (gauss_model amp c s k x)
  in res (relerr (trapz x y) (amp * s * f64.sqrt (2.0 * f64.pi))) 1.0e-10

-- Peak value equals cont + amp exactly; value at center+sigma equals
-- cont + amp*exp(-1/2).  Tolerance 0 (peak) and 1e-15 rel.
-- ==
-- entry: t_gauss_peak
-- input { 0i64 } output { true }
def d_gauss_peak (_: i64) : (bool, f64, f64) =
  let v = gauss_model 4.0 6563.0 2.0 1.5 [6563.0, 6565.0]
  let e0 = f64.abs (v[0] - 5.5)
  let e1 = relerr v[1] (1.5 + 4.0 * f64.exp (-0.5))
  in (e0 == 0.0 && e1 <= 1.0e-15, f64.max e0 e1, 1.0e-15)

-- chi2 of the exact model is exactly 0; residuals exactly 0.
-- ==
-- entry: t_chi2_exact_model
-- input { 0i64 } output { true }
def d_chi2_exact_model (_: i64) : (bool, f64, f64) =
  let x = linspace 1000 40000.0 50000.0
  let m = gauss_model 3.0 45000.0 20.0 1.0 x
  let s = map (\v -> 0.1 + 0.001 * v) x
  let c = chi2 m m s
  let r = f64.maximum (map f64.abs (residuals m m))
  in (c == 0.0 && r == 0.0, f64.max c r, 0.0)

-- data = model + 2*sigma at every pixel -> chi2 = 4 n, residual = 2 sigma.
-- Tolerance 1e-12 relative.
-- ==
-- entry: t_chi2_known
-- input { 0i64 } output { true }
def d_chi2_known (_: i64) : (bool, f64, f64) =
  let n = 1000
  let x = linspace n 40000.0 50000.0
  let m = gauss_model 3.0 45000.0 20.0 1.0 x
  let s = map (\v -> 0.25 + 1.0e-5 * v) x
  let d = map2 (\mi si -> mi + 2.0 * si) m s
  let e1 = relerr (chi2 d m s) (4.0 * f64.i64 n)
  let e2 = maxrel (residuals d m) (map (* 2.0) s)
  in res (f64.max e1 e2) 1.0e-12

-- Masking: sigma <= 0 or NaN data contribute nothing.
-- ==
-- entry: t_chi2_mask
-- input { 0i64 } output { true }
def d_chi2_mask (_: i64) : (bool, f64, f64) =
  let c = chi2 [1.0, 5.0, f64.nan, 3.0] [0.0, 0.0, 0.0, 1.0] [1.0, 0.0, 1.0, 2.0]
  in res (f64.abs (c - 2.0)) 0.0

-- obs_frame(rest_frame(x)) == x, z in {0, 0.5, 6.123, 12}.  Tol 1e-15 rel.
-- ==
-- entry: t_rest_inverse
-- input { 0i64 } output { true }
def d_rest_inverse (_: i64) : (bool, f64, f64) =
  let x = linspace 5000 6000.0 53000.0
  let e = f64.maximum (map (\z -> maxrel (obs_frame z (rest_frame z x)) x)
                           [0.0, 0.5, 6.123, 12.0])
  let e2 = relerr (rest_frame 6.0 [49000.0])[0] 7000.0
  in res (f64.max e e2) 1.0e-15

-- micron -> Angstrom -> micron round trip; 1 um = 1e4 A.  Tol 1e-15 rel.
-- ==
-- entry: t_um_angstrom
-- input { 0i64 } output { true }
def d_um_angstrom (_: i64) : (bool, f64, f64) =
  let x = linspace 10000 0.6 5.3
  let e = maxrel (angstrom_to_um (um_to_angstrom x)) x
  let e2 = f64.abs ((um_to_angstrom [1.0])[0] - 10000.0)
  in res (f64.max e e2) 1.0e-15

-- vacuum -> air -> vacuum (Morton 2000 then Piskunov inverse) over
-- 2001..100000 A (vacuum side starts at 2001 A so the air value stays
-- >= 2000 A, inside the converted domain).  Declared tolerance 1e-9 relative;
-- the VALD page shows the two formulas agree closely but gives no number,
-- so 1e-9 is our declared bound (see README for the measured value).
-- ==
-- entry: t_vac_air_roundtrip
-- input { 0i64 } output { true }
def d_vac_air_roundtrip (_: i64) : (bool, f64, f64) =
  let x = linspace 98000 2001.0 100000.0
  let e1 = maxrel (air_to_vac (vac_to_air x)) x
  let e2 = maxrel (vac_to_air (air_to_vac x)) x
  in res (f64.max e1 e2) 1.0e-9

-- Below 2000 A both directions are the identity (VALD convention).
-- ==
-- entry: t_vac_air_passthrough
-- input { 0i64 } output { true }
def d_vac_air_passthrough (_: i64) : (bool, f64, f64) =
  let x = [900.0, 1215.67, 1608.0, 1999.999]
  let e = f64.maximum (map2 (\a b -> f64.abs (a - b)) (vac_to_air x) x)
          `f64.max` f64.maximum (map2 (\a b -> f64.abs (a - b)) (air_to_vac x) x)
  in res e 0.0

-- Direct evaluation of the published Morton formula at 5000 A, written
-- out independently of the kernel: s = 1e4/5000 = 2, s^2 = 4, so
-- n = 1 + 0.0000834254 + 0.02406147/126 + 0.00015998/34.9.  Tol 1e-15 rel; air < vac.
-- ==
-- entry: t_vac_air_formula
-- input { 0i64 } output { true }
def d_vac_air_formula (_: i64) : (bool, f64, f64) =
  let n = 1.0 + 0.0000834254 + 0.02406147 / 126.0 + 0.00015998 / 34.9
  let a = (vac_to_air [5000.0])[0]
  in (a < 5000.0 && relerr a (5000.0 / n) <= 1.0e-15, relerr a (5000.0 / n), 1.0e-15)

-- f_lambda -> f_nu -> f_lambda round trip (values and sigmas, sigma_lam=0).
-- Tol 1e-14 rel.
-- ==
-- entry: t_fnu_flam_roundtrip
-- input { 0i64 } output { true }
def d_fnu_flam_roundtrip (_: i64) : (bool, f64, f64) =
  let n = 2000
  let l = linspace n 6000.0 53000.0
  let f = map (\x -> 1.0e-18 * (1.0 + f64.sin (x / 1000.0) * 0.5)) l
  let s = map (* 0.05) f
  let z = replicate n 0.0
  let (fn, sn) = flam_to_fnu l z f s
  let (f2, s2) = fnu_to_flam l z fn sn
  in res (f64.max (maxrel f2 f) (maxrel s2 s)) 1.0e-14

-- Known case: lambda = 1e4 A, f_lambda = 1 -> f_nu = 1e8 / 2.99792458e18.
-- sigma_lam = 0: sigma_fnu = sigma_flam * lambda^2 / c.  Tol 1e-15 rel.
-- ==
-- entry: t_fnu_known
-- input { 0i64 } output { true }
def d_fnu_known (_: i64) : (bool, f64, f64) =
  let (fn, sn) = flam_to_fnu [1.0e4] [0.0] [1.0] [0.1]
  in res (f64.max (relerr fn[0] (1.0e8 / 2.99792458e18))
                  (relerr sn[0] (0.1 * 1.0e8 / 2.99792458e18))) 1.0e-15

-- Lambda-only error: sigma_fnu = |d f_nu/d lambda| * sigma_lam, checked
-- against a central finite difference (h = 1e-3 A).  Tol 1e-8 rel.
-- ==
-- entry: t_fnu_lambda_error
-- input { 0i64 } output { true }
def d_fnu_lambda_error (_: i64) : (bool, f64, f64) =
  let (l, f, sl, h) = (35000.0, 2.0e-19, 1.5, 1.0e-3)
  let (_, sn) = flam_to_fnu [l] [sl] [f] [0.0]
  let (fp, _) = flam_to_fnu [l + h] [0.0] [f] [0.0]
  let (fm, _) = flam_to_fnu [l - h] [0.0] [f] [0.0]
  let fd = f64.abs ((fp[0] - fm[0]) / (2.0 * h)) * sl
  let (_, sl2) = fnu_to_flam [l] [sl] [f] [0.0]
  let (gp, _) = fnu_to_flam [l + h] [0.0] [f] [0.0]
  let (gm, _) = fnu_to_flam [l - h] [0.0] [f] [0.0]
  let gd = f64.abs ((gp[0] - gm[0]) / (2.0 * h)) * sl
  in res (f64.max (relerr sn[0] fd) (relerr sl2[0] gd)) 1.0e-8

-- Combined: choose sigma_flam = 2 f sigma_lam / lambda so the two terms
-- are equal; then sigma_fnu = sqrt(2) * sigma_flam * lambda^2 / c.
-- Tol 1e-15 rel.
-- ==
-- entry: t_fnu_combined_error
-- input { 0i64 } output { true }
def d_fnu_combined_error (_: i64) : (bool, f64, f64) =
  let (l, f, sl) = (20000.0, 4.0e-19, 2.0)
  let sf = 2.0 * f * sl / l
  let (_, sn) = flam_to_fnu [l] [sl] [f] [sf]
  in res (relerr sn[0] (f64.sqrt 2.0 * sf * l * l / 2.99792458e18)) 1.0e-15

-- Grid search recovers an injected redshift on SYNTHETIC noisy data:
-- z_true = 6.123 (Halpha 6564.61 A, [OIII] 5008.24 A vacuum rest), grid
-- 5.000..7.000 step 0.001.  Pass if |z_best - z_true| <= 1e-3 and the
-- fitted Halpha amplitude is within 10% of the injected 5.0.
-- ==
-- entry: t_zgrid_recover
-- input { 0i64 } output { true }
def d_zgrid_recover (_: i64) : (bool, f64, f64) =
  let cs = [6564.61, 5008.24]
  let ws = [3.0, 3.0]
  let (l, f, s) = synth_spectrum 3000 30000.0 53000.0 6.123 cs ws [5.0, 2.0] 1.0 0.5 7
  let zg = linspace 2001 5.0 7.0
  let (_, best, p) = zgrid_search l f s cs ws true zg
  let e = f64.abs (best[0] - 6.123)
  in (e <= 1.0e-3 + 1.0e-12 && relerr p[0] 5.0 <= 0.1, e, 1.0e-3)

-- Noiseless SYNTHETIC data with z on the grid: chi2 at the true z <= 1e-16
-- (sigma = 1), best z exactly the injected grid value, amplitudes and
-- continuum recovered to 1e-9 rel.
-- ==
-- entry: t_zgrid_noiseless
-- input { 0i64 } output { true }
def d_zgrid_noiseless (_: i64) : (bool, f64, f64) =
  let cs = [6564.61, 4862.68, 5008.24]
  let ws = [2.5, 2.5, 2.5]
  let zg = linspace 401 4.0 8.0     -- step 0.01, contains 6.25
  let zt = zg[225]
  let (l, f, _) = synth_spectrum 4000 25000.0 53000.0 zt cs ws [3.0, 1.0, 2.0] 0.4 0.0 1
  let s = replicate 4000 1.0
  let (chis, best, p) = zgrid_search l f s cs ws true zg
  let e = f64.maximum [relerr p[0] 3.0, relerr p[1] 1.0, relerr p[2] 2.0, relerr p[3] 0.4]
  in (best[0] == zt && best[1] == 225.0 && chis[225] <= 1.0e-16 && e <= 1.0e-9,
      f64.max chis[225] e, 1.0e-9)

-- A line outside the spectral coverage is degenerate: its amplitude is
-- fixed to 0, no NaN appears, and continuum-free fit (fit_cont=false)
-- gives continuum parameter 0.
-- ==
-- entry: t_zgrid_degenerate
-- input { 0i64 } output { true }
def d_zgrid_degenerate (_: i64) : (bool, f64, f64) =
  let cs = [6564.61, 1215.67]   -- Ly-alpha falls far blueward of coverage
  let ws = [3.0, 3.0]
  let (l, f, s) = synth_spectrum 2000 40000.0 50000.0 6.0 cs ws [5.0, 0.0] 0.0 0.1 3
  let (chis, best, p) = zgrid_search l f s cs ws false [5.9, 6.0, 6.1]
  let finite = all (\c -> !(f64.isnan c)) chis && all (\v -> !(f64.isnan v)) p
  in (finite && best[0] == 6.0 && p[1] == 0.0 && p[2] == 0.0 && relerr p[0] 5.0 <= 0.05,
      relerr p[0] 5.0, 0.05)

-- Masking in the grid search: NaN flux, NaN wavelength and sigma <= 0
-- pixels give the same chi2 curve and parameters as deleting them.
-- Tolerance 1e-12 relative (summation order differs).
-- ==
-- entry: t_zgrid_mask
-- input { 0i64 } output { true }
def d_zgrid_mask (_: i64) : (bool, f64, f64) =
  let cs = [6564.61, 5008.24]
  let ws = [3.0, 3.0]
  let (l, f, s) = synth_spectrum 1500 40000.0 50000.0 6.0 cs ws [5.0, 2.0] 1.0 0.3 9
  let bad i = i % 7 == 3 || i % 11 == 5 || i % 13 == 1
  let l2 = map2 (\i x -> if i % 11 == 5 then f64.nan else x) (iota 1500) l
  let f2 = map2 (\i x -> if i % 7 == 3 then f64.nan else x) (iota 1500) f
  let s2 = map2 (\i x -> if i % 13 == 1 then 0.0 else x) (iota 1500) s
  let keep = filter (\i -> !(bad i)) (iota 1500)
  let pick a = map (\i -> a[i]) keep
  let zg = [5.9, 5.95, 6.0, 6.05, 6.1]
  let (c1, b1, p1) = zgrid_search l2 f2 s2 cs ws true zg
  let (c2, b2, p2) = zgrid_search (pick l) (pick f) (pick s) cs ws true zg
  let e = f64.max (maxrel c1 c2) (maxrel p1 p2)
  in (b1[0] == b2[0] && b1[0] == 6.0 && e <= 1.0e-12, e, 1.0e-12)

-- Generated wrappers: t_<name> -> pass flag (for futhark test);
-- m_<name> -> (metric, tolerance) (printed by run.sh).
entry t_gauss_integral (x: i64) : bool = (d_gauss_integral x).0
entry m_gauss_integral (x: i64) : (f64, f64) = let (_, m, t) = d_gauss_integral x in (m, t)
entry t_gauss_integral_cont (x: i64) : bool = (d_gauss_integral_cont x).0
entry m_gauss_integral_cont (x: i64) : (f64, f64) = let (_, m, t) = d_gauss_integral_cont x in (m, t)
entry t_gauss_peak (x: i64) : bool = (d_gauss_peak x).0
entry m_gauss_peak (x: i64) : (f64, f64) = let (_, m, t) = d_gauss_peak x in (m, t)
entry t_chi2_exact_model (x: i64) : bool = (d_chi2_exact_model x).0
entry m_chi2_exact_model (x: i64) : (f64, f64) = let (_, m, t) = d_chi2_exact_model x in (m, t)
entry t_chi2_known (x: i64) : bool = (d_chi2_known x).0
entry m_chi2_known (x: i64) : (f64, f64) = let (_, m, t) = d_chi2_known x in (m, t)
entry t_chi2_mask (x: i64) : bool = (d_chi2_mask x).0
entry m_chi2_mask (x: i64) : (f64, f64) = let (_, m, t) = d_chi2_mask x in (m, t)
entry t_rest_inverse (x: i64) : bool = (d_rest_inverse x).0
entry m_rest_inverse (x: i64) : (f64, f64) = let (_, m, t) = d_rest_inverse x in (m, t)
entry t_um_angstrom (x: i64) : bool = (d_um_angstrom x).0
entry m_um_angstrom (x: i64) : (f64, f64) = let (_, m, t) = d_um_angstrom x in (m, t)
entry t_vac_air_roundtrip (x: i64) : bool = (d_vac_air_roundtrip x).0
entry m_vac_air_roundtrip (x: i64) : (f64, f64) = let (_, m, t) = d_vac_air_roundtrip x in (m, t)
entry t_vac_air_passthrough (x: i64) : bool = (d_vac_air_passthrough x).0
entry m_vac_air_passthrough (x: i64) : (f64, f64) = let (_, m, t) = d_vac_air_passthrough x in (m, t)
entry t_vac_air_formula (x: i64) : bool = (d_vac_air_formula x).0
entry m_vac_air_formula (x: i64) : (f64, f64) = let (_, m, t) = d_vac_air_formula x in (m, t)
entry t_fnu_flam_roundtrip (x: i64) : bool = (d_fnu_flam_roundtrip x).0
entry m_fnu_flam_roundtrip (x: i64) : (f64, f64) = let (_, m, t) = d_fnu_flam_roundtrip x in (m, t)
entry t_fnu_known (x: i64) : bool = (d_fnu_known x).0
entry m_fnu_known (x: i64) : (f64, f64) = let (_, m, t) = d_fnu_known x in (m, t)
entry t_fnu_lambda_error (x: i64) : bool = (d_fnu_lambda_error x).0
entry m_fnu_lambda_error (x: i64) : (f64, f64) = let (_, m, t) = d_fnu_lambda_error x in (m, t)
entry t_fnu_combined_error (x: i64) : bool = (d_fnu_combined_error x).0
entry m_fnu_combined_error (x: i64) : (f64, f64) = let (_, m, t) = d_fnu_combined_error x in (m, t)
entry t_zgrid_recover (x: i64) : bool = (d_zgrid_recover x).0
entry m_zgrid_recover (x: i64) : (f64, f64) = let (_, m, t) = d_zgrid_recover x in (m, t)
entry t_zgrid_noiseless (x: i64) : bool = (d_zgrid_noiseless x).0
entry m_zgrid_noiseless (x: i64) : (f64, f64) = let (_, m, t) = d_zgrid_noiseless x in (m, t)
entry t_zgrid_degenerate (x: i64) : bool = (d_zgrid_degenerate x).0
entry m_zgrid_degenerate (x: i64) : (f64, f64) = let (_, m, t) = d_zgrid_degenerate x in (m, t)
entry t_zgrid_mask (x: i64) : bool = (d_zgrid_mask x).0
entry m_zgrid_mask (x: i64) : (f64, f64) = let (_, m, t) = d_zgrid_mask x in (m, t)
