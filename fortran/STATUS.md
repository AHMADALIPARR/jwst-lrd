<!-- SPDX-License-Identifier: AGPL-3.0-only. Also subject to SNAPKITTY_OPAQUE_LICENSE.md (dual license). -->
# fortran/STATUS.md — TASK 003 (Fortran 2018 kernel)

## What built
- `fortran/src/*.f90` (Fortran 2018, `gfortran -std=f2018 -fimplicit-none`, 0 warnings) and
  `fortran/src/lrd_fits_shim.c`: the only code that touches CFITSIO. It exposes flat C functions
  (`lrd_fits_nrows`, `lrd_fits_read_dcol`, `lrd_fits_read_key`) bound with `bind(C)` /
  ISO_C_BINDING in `lrd_fits.f90`. No CFITSIO types cross the boundary.
- Modules: `lrd_const` (only exact/defined constants: c, IAU au/pc, Julian year, Jy),
  `lrd_units` (vac↔air via the Edlén 1966 formula as given by Morton 2000, ApJS 130, 403;
  µm→Å; Jy→erg s⁻¹ cm⁻² Å⁻¹), `lrd_cosmo` (flat or curved matter+Λ cosmic time, Gauss–Legendre after
  a = u² substitution; radiation neglected), `lrd_stats` (residuals, χ², Gaussian lnL, weighted linear
  LSQ with covariance, AIC, BIC, likelihood ratio), `lrd_lines` (side-band continuum, centroid +
  integrated flux with propagated errors, peak finding, line-identification by redshift voting),
  `lrd_arr` (LRD-ARR-v1 read/write, little-endian enforced).
- `fortran/app/lrd_reference.f90` + `fortran/run_reference.sh`: reference analysis of the real spectrum.
- `fortran/causal/` is not touched (owned by HCALC Alloy). `tests/futhark/fortran-ref/` is not touched.

## Cited inputs
- Rest wavelengths: NIST Atomic Spectra Database ver. 5.12 (Kramida, Ralchenko, Reader & NIST ASD Team),
  Ritz vacuum (and air) values, queried 2026-10-19; raw CSV in `fortran/data/nist/`.
  Hγ 4341.691, Hβ 4862.691, [O III] 4960.295, 5008.240, Hα 6564.632 Å (vacuum).
- Cosmology: Planck Collaboration 2020, A&A 641, A6 (arXiv:1807.06209), Table 2, TT,TE,EE+lowE+lensing:
  H0 = 67.36, Ωm = 0.3153, ΩΛ = 0.6847, age = 13.797 ± 0.023 Gyr.
- Redshift: Furtak et al. 2024, Nature 628, 57 (arXiv:2308.05735): z_spec = 7.0451 ± 0.0005.

## Unit tests and declared tolerances (tests/fortran/run.sh)
- Unit conversion: 1 Jy at 1 µm = 2.99792458e−13 erg s⁻¹ cm⁻² Å⁻¹ (exact), round trips.
- Vacuum→air reproduces the NIST air values for 5 lines to ≤ 0.01 Å; air↔vac round trip 1e−8 Å.
- Einstein–de Sitter t0 = 2/(3H0) and t(z) = t0(1+z)^−3/2, flat ΛCDM asinh closed form, open
  matter-only acosh closed form: relative 1e−10.
- Planck 2018 age 13.797 Gyr: tolerance 0.046 Gyr (2σ; model omits radiation/neutrino detail).
  The kernel gives 13.8007 Gyr.
- LSQ/χ²/lnL/AIC/BIC: analytic values to 1e−12. Gaussian line flux A·σ·√(2π) and centroid to 1e−6 on
  a SYNTHETIC noiseless spectrum; identification recovers z = 7 on SYNTHETIC lines.
- Real data: |z − 7.0451| must be ≤ one prism pixel at Hα in z units (pixel/λ_rest ≈ 0.0113).

## Real-spectrum results (primary product)
Source: `fixtures/raw/c0b878576d7d7ec723c5ee526d29715fb672d81e45bc8ba4e02598ce8b9c5ee7.fits` (jw02561-o006_s000024175_nirspec_clear-prism_x1d.fits). 408 of 429 rows are valid (finite, error > 0).

| quantity | value |
|---|---|
| identified lines (score) | 3: Hγ, Hβ, Hα; [O III] 4960/5008 not detected as peaks (S/N ≥ 5) |
| Hgamma centroid z | 7.0733576359782759E+000 ± 9.9667851605153828E-003 (flux 2.9552926771415643E-019 ± 8.1923433558393922E-020 erg s⁻¹ cm⁻²) |
| Hbeta centroid z | 7.0384610482954617E+000 ± 2.2071956042647141E-003 (flux 9.4073463777765846E-019 ± 7.9779709995366343E-020 erg s⁻¹ cm⁻²) |
| Halpha centroid z | 7.0422624283202122E+000 ± 2.7135090540068017E-004 (flux 7.4714776133343182E-018 ± 1.7556379266506058E-019 erg s⁻¹ cm⁻²) |
| weighted-mean z (lines with flux S/N ≥ 5: 2) | 7.0422058295032448E+000 ± 2.6932325536070884E-004 (formal, statistical only) |
| cosmic time at that z (Planck 2018 params) | 7.5513873485540006E-001 Gyr; lookback 1.3045585960243399E+001 Gyr |
| Hβ: Δχ² (continuum → continuum+Gaussian) | 2.1174004800550443E+002; ΔAIC 205.74; ΔBIC 202.21 (n=24) |
| Hα: Δχ² | 3.1674077276189228E+003; ΔAIC 3161.41; ΔBIC 3159.09 (n=16) |
| Hβ / Hα Gaussian FWHM (not corrected for instrumental resolution) | 2.4056268134353800E+003 / 1.4887615668108563E+003 km/s |

The measured z is 0.0029 below Furtak et al. 2024. That is inside the declared one-pixel tolerance but
about 10× the formal error, so the formal error does not cover the systematics. Likely contributors, none
of which I have verified: Hα is 5.28 µm, next to the prism's red cutoff (the rows above 5.30 µm are
invalid, which can truncate the window), prism wavelength calibration, and the
coarse ±2.5 px centroid window. The FWHMs are raw Gaussian widths at prism resolution. Do not compare them
with the published 2800 km/s Hβ FWHM without deconvolving the instrumental resolution.

## Reference outputs for other tracks (Futhark, Octave, LLVM)
`fixtures/reference/<sha>/` (LRD-ARR-v1, all length 429, `source_sha256` set):
`wavelength_ang` [Angstrom], `flam`, `flam_err` [erg s-1 cm-2 Angstrom-1; NaN where masked], `mask` [1],
`model_Hbeta`, `resid_Hbeta`, `model_Halpha`, `resid_Halpha` (NaN outside the fit window), and
`reference.kv` → `reference.rec` (LRD-REC-v1) + `reference.commit`.
Regenerate with `make build && sh fortran/run_reference.sh`. The test checks bytewise reproducibility.

## What ran (verbatim, from `make test`)
```
== fortran (tests/fortran/run.sh)
PASS build_fortran_kernel
PASS units_jy_to_flam_1um
PASS units_flam_roundtrip
PASS units_um_to_ang
PASS units_hubble_time_h100
PASS vacair_OIII5008_nist
PASS vacair_OIII4960_nist
PASS vacair_Halpha_nist
PASS vacair_Hbeta_nist
PASS vacair_Hgamma_nist
PASS vacair_roundtrip_20000A
PASS vacair_index_gt_1
PASS cosmo_eds_t0
PASS cosmo_eds_tz7
PASS cosmo_flat_lcdm_t0_analytic
PASS cosmo_flat_lcdm_tz7_analytic
PASS cosmo_open_matter_t0_analytic
PASS cosmo_planck2018_age
PASS stats_wlsq_intercept
PASS stats_wlsq_slope
PASS stats_wlsq_slope_var
PASS stats_chi2_zero
PASS stats_lnl_analytic
PASS stats_chi2_4
PASS stats_lnl_shift
PASS stats_aic
PASS stats_bic
PASS stats_residuals
PASS lines_measure_info
PASS lines_flux_gaussian
PASS lines_centroid_gaussian
PASS lines_flux_err_lower_bound
PASS lines_redshift_from_centroid
PASS lines_identify_score
PASS lines_identify_z
PASS arr_roundtrip
PASS arr_little_endian_bytes
PASS reference_run_real_spectrum
PASS reference_outputs_reproducible
PASS redshift_vs_furtak2024_dz=0.002894_tol=0.011295
PASS reference_lrd_arr_v1_headers
```

## Assumptions / blockers
- Radiation is neglected in t(z), which matters at the ~0.1% level for age.
- Peak finding uses S/N ≥ 5 against a local linear continuum (inner 3, outer 10 px). Identification tolerance is 1.5 px.
- Pixel errors are treated as independent. The x1d gives no covariance.
- The kernel analyses only the primary product. o002 is excluded because its FLUX is inverted (see ingest/STATUS.md).
- LRD-STATE-v1 observation transitions are emitted by the ingest track (see ingest/STATUS.md, fixtures/state/observation/). The kernel itself emits none.

## OPEN: redshift discrepancy vs Furtak et al. 2024
Status: **OPEN, cause not identified.** The kernel gives z = 7.04221 ± 0.00027 (inverse-variance mean of the
Hβ and Hα centroids). Furtak et al. 2024 (Nature 628, 57) publish z = 7.0451 ± 0.0005. Every estimator below
lands below the published value. Mechanisms (b) and (c) below do not explain the offset under the models tested.

Tool: `fortran/app/lrd_zinvest.f90`, run with `fortran/run_zinvest.sh`. Output:
`fixtures/reference/<sha>/zinvest.{kv,rec,commit}`. The commitment is in zinvest.commit.
- Input: the primary x1d (sha256 c0b87857…, CAL_VER 3.0.0, image A only).
- Fitting method: profile χ²(z) on a 1e-5 grid over z = 7.020–7.065, with σ_int profiled over 0–4000 km/s in
  50 km/s steps. Each z gets a linear continuum plus line flux by weighted LSQ. Intervals are Δχ² = 1.
- Default window: −12/+12 px around the line (fewer pixels where the mask cuts it).
- Because of the grid, z values are quantised at 1e-5 and σ_int at 50 km/s.

LSF source: JDox `jwst_nirspec_prism_disp.fits`, sha256 58f9330440c50af624313e70f3e5b9f58a6b22d06af094e0085ed66408d0d937.
Its R(λ) is based on Jakobsen et al. 2022, A&A 661, A80, and assumes a 2.2-px resolution element. Provenance is in
`fortran/data/jdox/SOURCE.md`. The LSF is a Gaussian with FWHM λ/R(λ), integrated over each pixel with erf.
- Interpolated R: 171.84 at observed Hβ and 320.56 at observed Hα.
- FWHM: 1744.6 km/s (Hβ) and 935.2 km/s (Hα).
- From the x1d pixel widths (102.45 Å and 74.21 Å), FWHM = 2.221 px and 2.219 px. This matches the 2.2-px
  element stated by JDox.

(a) Per-line and joint fits, z with its Δχ²=1 interval:
| estimator | Hβ alone | Hα alone | Hβ+Hα joint |
|---|---|---|---|
| LSF-binned Gaussian | 7.03795 [7.03565, 7.04025] | 7.04053 [7.04026, 7.04080] | 7.04050 [7.04022, 7.04077] |
| point-sampled Gaussian (no LSF binning) | 7.03798 [7.03567, 7.04031] | 7.04053 [7.04026, 7.04081] | 7.04050 [7.04023, 7.04077] |
| kernel centroid (±2.5 px) | 7.03846 ± 0.00221 | 7.04226 ± 0.00027 | 7.04221 ± 0.00027 (weighted mean) |

Hα dominates. Against 7.0451:
- The joint LSF fit gives Δz = −0.00460, which is −171 km/s, or −30.2 Å observed at Hα (−0.41 px).
- The kernel centroid gives Δz = −0.00289, which is −106 km/s, or −0.25 px.
- Hβ alone is consistent with Hα alone within its ±0.0023 interval.

(b) Hα at the red edge:
- The Hα peak pixel is at 5.28161 µm. Only 3 valid pixels lie redward of the peak (S/N 37.1, 25.6, 5.2). The last
  valid pixel is at 5.30382 µm, and the pixels after it are masked.
- Centroid half-width scan, with z at hw = 1.5/2.0/2.5/3.0/3.5/4.0 px:
  7.04316 / 7.04452 / 7.04226 / 7.02165 / 7.03533 / 7.03533.
  So the centroid is not stable against window choice.
- LSF-fit window scan for Hα, ±6/±9/±12 px: 7.04189 / 7.04106 / 7.04053.
- Red truncation, keeping 1 or 0 pixels beyond the peak: 7.04007 and 7.04323.
- Every variant stays below 7.0451. The largest value, 7.04452 (centroid at hw = 2.0 px), is still 0.0006 low.

(c) Injection–recovery (SYNTHETIC, noise-free):
- Setup: the fitted continuum plus an LSF-binned Gaussian at z_true = 7.0451, placed on the real wavelength grid
  and mask.
- LSF fit: recovers z_true with an error of 0 (Hβ) and 0 (Hα), within the 1e-5 grid.
- Point-sampled fit: errors of +2e-5 (Hβ) and 0 (Hα).
- Centroid bias for hw = 1.5…4.0 px:
  - Hβ: −3.10e-3, +2.03e-3, −1.11e-3, +5.2e-4, −2.1e-4, +7e-5.
  - Hα: −1.6e-4, +1.62e-3, −5.4e-4, −2.07e-3, −4.3e-4, −4.3e-4.
- What this shows:
  - Undersampling, LSF binning, the red-edge mask and the window do not bias the Gaussian fits enough to matter.
  - For the kernel centroid at hw = 2.5 px, the Hα bias is −5.4e-4. That is about 19% of the −0.00289 offset.
  - The centroid estimator is window-sensitive at the ±2e-3 level. The kernel's centroid z sits closer to the
    published value than the fits do, and that should not be read as confirmation.

Not explained, so the item stays OPEN. Candidates not tested here:
- Wavelength-calibration differences between CAL_VER 3.0.0 and the reduction used by Furtak et al. (2023 data,
  all three lensed images stacked).
- Intrinsic line asymmetry or non-Gaussian profiles.
- Source position and compactness in the shutter. The JDox curve assumes a 2.2-px element; a compact source may
  have a narrower LSF (not tested here).

Numerical sensitivity check, not a claim about the published analysis: using air rather than vacuum rest wavelengths
(Edlén/Morton conversion) would move the fitted values from 7.04053 to 7.04275 (Hα) and from 7.03795 to 7.04020 (Hβ).
Hα and Hβ would then disagree by 0.0026.

Tests (tests/fortran/run.sh):
- zinvest_reproducible
- zinvest_lsf_file_sha256
- zinvest_lsf_fwhm_2p2pix
- zinvest_injection_fit_unbiased
