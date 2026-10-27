<!-- SPDX-License-Identifier: AGPL-3.0-only -->
# PREREG — continuum-model comparison for the QSO1 redshift (written BEFORE any fit in this directory was run)

Written 2026-10-26 (America/Los_Angeles), before `octave/*.m` fitting code was executed. Its sha256 is stored in
`PREREG.sha256` and re-checked by `run.sh` and `test.sh` at run time (a changed file => the run aborts / the test FAILs).

**Disclosure (no blind claim).** Before writing this file I had read (a) the awk-sp RESULTS.md and the Fortran STATUS.md numbers
(centroid 7.04221, matched filter 7.04028, 27 variants 7.039347–7.043317, Hα pixel-420 deficit) and (b) the raw flux / flux_error
columns of pixels 395–420. So the criteria below are NOT blind to those numbers; they are fixed before the code of THIS
directory ran. Anything not listed here and added later is labelled EXPLORATORY in RESULTS.md.

## 0. Data and rest wavelengths
- Fixture: sha256 `c0b878576d7d7ec723c5ee526d29715fb672d81e45bc8ba4e02598ce8b9c5ee7` (obsid 230168921, NIRSpec PRISM x1d), read-only via `lib/prep.sh`
  (verifies sha256 of raw FITS and of the three `.f64` arrays, exports with `od`). Raw arrays are never edited; every mask/trim is a new column/file.
- Rest wavelengths are VACUUM, NIST ASD v5.12 Ritz (Kramida, Ralchenko, Reader & NIST ASD Team), same as `fortran/src/lrd_lines.f90`:
  Hβ 4862.691 Å, Hα 6564.632 Å (the only two lines fitted). Air values (6562.8 / 4861.35) are NOT used.
- Base mask (explicit, logged, identical for all models): pixel masked iff wavelength, flux or flux_error non-finite or flux_error <= 0 (expect 21 masked, 408 valid, 429 total).

## 1. Common treatment (identical for every model)
- Same wavelength grid and the same pixel set per scenario (section 3). Pixels independent, weights 1/σ² with σ = x1d FLUX_ERROR converted to F_λ (1e-20 erg/s/cm²/Å). No error inflation inside the fit.
- Line template: unit-area Gaussian integrated over each pixel (edges at midpoints of adjacent grid wavelengths, edge pixels use the neighbour in the full grid even if that neighbour is masked), mean R(1+z), σ² = σ_LSF² + (σ_int·R(1+z)/c)²,
  σ_LSF = 2.2 px FWHM /2.35482 × (pixel width at the window-centre pixel). Amplitudes constrained >= 0.
- σ_int is PROFILED (minimised over a grid at every z), never fixed: single Gaussian per line: σ_int ∈ {0,100,…,4000} km/s (Hβ and Hα). Two-component Hα: narrow σ_n ∈ {0,100,…,600}, broad σ_b ∈ {900,1000,…,3000} km/s, shared centroid z, amplitudes >= 0 each; Hβ stays a single Gaussian. One shared z for Hβ and Hα (joint fit); per-line z also reported.
- z grid 7.020–7.065 step 1e-5; best z = grid minimum refined by a 3-point parabola; errors = Δχ²=1 crossings of the profile (σ_int, β, continuum parameters all profiled), linear interpolation; rescaled errors (×sqrt(max(χ²_red,1))) also reported.
- Fit regions (pixel indices of the 429-pixel array): centre pixel = nearest pixel to rest×(1+7.0422). Hβ: centre−12 … centre+6 (the +6 limit keeps [OIII]4960/5008 out). Hα: centre−BW … last valid pixel after the red-edge treatment; BW = 12 primary, BW = 8 and 6 only as sensitivity.

## 2. Models (continuum shape; x = (λ − λ_centre)/pixel width, per window)
- RM6, RM12, RM20: iterative 3σ-clipped running median (one-sided clip, 6 iterations, half-width 6/12/20 valid pixels, truncated windows at the ends of the valid list, algorithm of awk/continuum.awk), computed on the valid pixel list of the scenario and SUBTRACTED; no continuum parameters in the fit.
- P0, P1, P2, P3: polynomial of order 0–3 per window, fitted simultaneously with the lines.
- PL: power law A_i(λ/λ_c)^β_i per window (β_i profiled, grid −10…10 step 0.1, A_i linear).
- PLLIN ("power-law + Balmer-break-free local linear"; my interpretation, stated because the phrase is ambiguous): per window A_i(λ/λ_c)^β + c_i·x with ONE spectral index β shared by the two windows (grid −10…10 step 0.1), A_i and tilt c_i free per window, no Balmer-break term. Per-line (single-window) fits of PLLIN profile β inside that window.
- SPL: natural cubic regression spline per window (4 basis functions: 1, x, two natural-cubic terms), knots at the pixel positions at 0, 1/3, 2/3, 1 of the window's valid pixel list.
- Each of the 10 continuum models is run with 1C (single Gaussian per line) and 2C (narrow+broad Hα) => 20 models.

## 3. Scenarios (red-edge handling; the SAME trimmed pixel list for all 20 models)
- D0 (baseline), D1, D2, D3, D4: drop the last D valid pixels of the whole spectrum (pixels 420; 419–420; …).
- ERRALL: additionally mask every valid pixel with flux_error[Jy] > 1.5 × median flux_error[Jy] of valid pixels 380–404 (a quiet region before both lines).
- ERREDGE: mask only the CONTIGUOUS run of pixels at the red end of the valid list that exceed the same threshold (1.5×), stopping at the first pixel below it.
- +1 pixel at the red edge cannot be tested (pixels 421–429 have NaN flux and err), so "±1 pixel" is operationalised as D1 versus D0 only; this is stated as a limitation.
- Sensitivity only (not used for selection): BW = 8, 6 at D0.

## 4. Model selection
- Statistics per model and scenario: joint χ²_min over n = (pixels in both windows) data points; k = number of free parameters = nonlinear (z, σ's, β's) + linear (continuum coefficients, line amplitudes). RM: continuum parameters counted as k_eff = Σ_windows ceil(N_window/(2H+1)) (an effective-parameter convention, stated because the running median has no explicit parameters; a k_cont=0 BIC is also printed, EXPLORATORY).
- AIC = χ² + 2k; BIC = χ² + k·ln n; χ²_red = χ²/(n−k) (NA if n−k <= 0).
- Selection at D0 by lowest BIC. ΔBIC to the runner-up >= 6: "selected"; 2 <= ΔBIC < 6: "weakly selected"; < 2: "not distinguishable", and the whole set within ΔBIC < 2 is the indistinguishable set. Admissible set = ΔBIC <= 10 from the best.
- Secondary (reported, EXPLORATORY for decision): QBIC = χ²/ĉ + k ln n with ĉ = smallest χ²_red among the 20 models (quasi-likelihood for under-estimated errors). If primary BIC and QBIC pick different models, the selection is called "not robust".
- Selection persistence: the selected model is recomputed at D1; if it differs from D0, "not persistent".

## 5. Stability criterion
A model's z is STABLE iff |z_joint(D1) − z_joint(D0)| < σ_joint(D0) (Δχ²=1 half-width, unscaled, same model). Also reported (not criteria): D2…D4, ERRALL, ERREDGE shifts in units of σ.
"Any model-selected z is stable" is TRUE only if the (weakly) selected model(s) at D0 pass this test; if no unique selection, the statement is made for the indistinguishable set (all members must pass).

## 6. Gap to the published value
Published z = 7.0451 (Furtak et al. 2024, Nature 628, 57); Fortran centroid z = 7.04221 ± 0.00027 (a centroid estimator, not a profile fit; kept as reference only). Δz = 7.0451 − 7.04221 = 0.00289 (≈ 108 km/s: c·Δz/(1+z) = 107.7).
Reported ranges: R1 = [min, max] of joint z over the 20 models at D0; R2 = same over the admissible set at D0; R3 = over all 20 models × all 7 scenarios. The gap is "within the model-systematic range" iff 7.0451 ∈ R (stated separately for R1, R2, R3), and the distance to the nearest edge of each R is printed in units of the model's own σ.

## 7. Pixel influence (Hα, D0)
Leave-one-out: remove each valid Hα-window pixel, refit (Hβ window unchanged), Δz_i = z_(−i) − z_full. Pixel i "influential" for a model if |Δz_i| >= 0.5 σ_joint (that model). Jackknife SD = sqrt((m−1)/m Σ(z_(−i) − mean)²), m = number of Hα-window pixels (caveat: neighbouring pixels are correlated, so this is only a spread indicator). The "driver" is the pixel with largest |Δz_i| in the largest number of models.

## 8. Controls and tests (test.sh prints PASS/FAIL counts; thresholds fixed here)
- Engine validation: Octave P1/RM12 with the awk-sp window rule (q±5 valid pixels, 2.2 px LSF, σ grid 0–4000 step 100, no-drop) must reproduce awk-sp joint z (7.041836 for POLY1, 7.040280 for RM; taken from awk-sp/results/run.log) within 2e-5. Octave RM12 continuum must equal awk/continuum.awk output (max |Δ| <= 1e-6). Independent Fortran 2018 polynomial-order 0–3 joint fit (fortran/xcheck.f90, own grid code) must agree with Octave to within 2e-5 for D0 and D1.
- SYNTHETIC (clearly labelled, not data): (a) noise-free injection of the P1-model best-fit lines+continuum with z_true = 7.0451 on the real grid and mask; every model that contains the generating continuum family must recover z_true within 3e-5; the others' biases are reported, not required to pass. (b) SYNTHETIC edge-deficit control: same injection with the pixel-420 flux replaced by continuum only; the induced shift per model is reported. (c) noisy injection–recovery, N = 30 per model for RM12, P1, P2, SPL, seed fixed; mean bias, SD and Δχ²=1 coverage reported.
- Unit tests: Gaussian template sums to 1 over a wide grid; χ² vectorised vs brute-force direct evaluation at a random (z, σ); NaN/inf handling.
- No physical cause is claimed from any of these results. PASS counts validate computation, not a physical explanation.
