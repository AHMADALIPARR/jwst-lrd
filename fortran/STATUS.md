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
- No LRD-STATE-v1 transition is emitted yet. The ledger ABI header `ledger/abi/lrd_state.h` is not in the repo.
