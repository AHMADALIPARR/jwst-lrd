#!/usr/bin/env bash
# SPDX-License-Identifier: AGPL-3.0-only
# mkresults.sh -- assemble RESULTS.md: narrative (numbers copied from results/run.log, section 9 and 8b/8c) + verbatim logs appended.
set -u
cd "$(dirname "$0")/.."
{
cat <<'EOF'
<!-- SPDX-License-Identifier: AGPL-3.0-only -->
# RESULTS — continuum-model comparison for the QSO1 (Abell 2744-QSO1) redshift

Fixture sha256 `c0b878576d7d7ec723c5ee526d29715fb672d81e45bc8ba4e02598ce8b9c5ee7` (obsid 230168921, NIRSpec PRISM x1d): 429 pixels, 408 valid, 21 masked (verified in run.log §0).
PREREG.md sha256 `0d5740378eb901e0d862176b69e1b64f91282308b8b8a91a7ea7725924cc99d2`, written 2026-10-26 20:26 PDT before any fit here; it discloses that I had seen the awk-sp/Fortran numbers and pixels 395–420 beforehand (not blind). Criteria were not changed after the runs. Final full run: 2026-10-26 21:01–21:09 PDT (`./run.sh`, 244 jobs, 0 failed); `./test.sh`: **PASS=42 FAIL=0**.
Tools: mawk 1.3.4, GNU Octave 9.4.0 (engine), gfortran 14.2 `-std=f2018` (independent polynomial cross-check). No Python/JS/TS. Maxima is not installed and was not used.
Everything below is a computation on the raw arrays with the same grid, mask and σ for all models. All passing checks validate arithmetic, not a physical explanation. No physical cause is claimed.

## Plain statements (numbers from the verbatim sections below)

1. **Is any model-selected z stable?** Pre-registered BIC selection at D0 (n=35 points) picks **SPL_2C** (spline continuum + two-component Hα), z = **7.040158**, σ_J(Δχ²=1) = 0.000497 (χ²_red-scaled 0.000643), BIC 86.848, ΔBIC = 13.40 to runner-up P2_2C ("selected", ≥6); QBIC (EXPLORATORY) picks the same model. By the pre-registered criterion |z(D1)−z(D0)| < σ_J(D0): 7.040254 vs 7.040158, shift +0.19σ → **stable**. Caveats, all visible in the log: (a) the selection is **not persistent** — at D1 (last valid pixel 420 dropped) the lowest-BIC model is P0_2C (BIC 62.653), z = 7.040923; (b) SPL_2C has k=15 parameters for n=35 points, its narrow Hα σ is 0 and its broad σ is 1500 (D0), 1100 (D1), 1400 (D2), 1300 (D3), 1400 (D4); (c) post-hoc, not criteria: SPL_2C shifts are +1.85σ (D2, z=7.041078), −2.26σ (D3, 7.039035), −2.57σ (D4, 7.038881), −2.97σ (ERRALL/ERREDGE), with σ_J growing to 0.00098–0.00195 at D2–D4. Over all 20 models only 4/20 pass the stability test (RM20_1C, PL_1C, PL_2C, SPL_2C); the 1C polynomial models P0–P3 and spline move by 1–6σ under the one-pixel drop.
2. **Is the gap to 7.0451 within the model-systematic range?** Gap from the Fortran centroid 7.04221: Δz = 0.00289 (107.7 km/s). **7.0451 is outside every pre-registered range**: R1 (20 models, D0) = [7.038408, 7.042329], nearest edge 0.002771 away (10.1 × median σ_J(D0)=0.000275); R2 (admissible set ΔBIC≤10 = {SPL_2C} only) = [7.040158, 7.040158], 0.004942 away (18.0×; ≈184 km/s); R3 (20 models × the 7 scenarios D0–D4, ERRALL, ERREDGE; §8c) = [7.035841 (P3_1C D3), 7.044288 (PL_1C D4)], 0.000812 away (3.0×). The widths of R1 (0.003921) and R3 (0.008447) exceed the gap size, i.e. model/edge choices move z by more than 0.00289, but mostly *downward/around* 7.0405–7.0423; the highest D0 value is SPL_1C 7.042329 (6.65σ below 7.0451) and no D0 model is within 3σ_J of 7.0451. The Fortran centroid 7.04221 lies inside R1. (`cc_report` section D prints its R3 over scenarios + BW8/BW6 sensitivity runs; its edge distances are the same here; the strict 7-scenario R3 is §8c.)
3. **Red-edge sensitivity.** Hα leave-one-out (D0): jackknife SD 0.00083–0.0035 (3.1–11.9σ_J) depending on model; pixel 415 is the largest-|Δz| pixel in 9/20 fits, 418 in 7, 420 in 4. The pre-registered "+1 pixel" side of the ±1 test is untestable (pixels 421–429 are NaN), so only D1 vs D0 was tested. The flux-error rule (threshold 5.443e-8 Jy = 1.5 × median err of pixels 380–404) masks pixels 415–420, i.e. the Hα **core**, not just the edge; ERRALL = ERREDGE; it tracks line S/N and is not an edge-only test.
4. **Grid limits of the 2C fits (EXPLORATORY caveat).** Of 90 2C fit records the broad-component σ sits on the lower grid bound (900) in 56 and on the upper bound (3000) in 1; the narrow σ sits at 0 in 11 and at 600 in 16 (run.log §8b). The 2C results are therefore weakly constrained by 35 points.
5. **SYNTHETIC controls (generated from the P1/1C fit with z_true = 7.0451; not data).** Noise-free recovery for the models containing the generating family (P1, P2, P3, SPL, PLLIN; 1C and 2C): all |bias| ≤ 2.3e-6 (tolerance 3e-5) → the engine is consistent. Non-family models: RM6 −3.1e-3, RM12 −1.6e-5, RM20 +2.6e-6, P0 −3.8e-5, PL −3.0e-6 (1C). SYNTHETIC pixel-420 edge-deficit (line flux at 420 replaced by continuum): z bias −5.1e-4 (P0) … +2.06e-3 (SPL_1C), −3.0e-3 (RM6), i.e. a single deficient edge pixel can move z by amounts comparable to the 0.00289 gap, in either direction depending on the continuum model. Noisy N=30 (SYNTHETIC): Δχ²=1 1σ coverage P1 14/30, P2 19/30, RM12 23/30, SPL 24/30; this says the quoted formal errors can be too small for flexible models. These show sensitivity, not that the real spectrum has such a deficit.
6. **Engine cross-checks.** Octave reproduces awk-sp: RM12 7.040280 (hw 0.000268), P1 7.041836, P2 7.042200 (VAL lines); Octave running median equals continuum.awk to 5e-11; the independent Fortran 2018 polynomial fit equals Octave for P0–P3 at D0–D4 (D0,D1 asserted within 2e-5; diff printed as 0.00e+00 at the printed precision for D2–D4). Note: the existing Fortran reference joint value is a.lsf.joint.z = 7.0405 (Δχ²=1: 7.04022–7.04077); the 7.04221 ± 0.00027 quoted in the brief corresponds to the Hα *centroid* (a.centroid.Halpha.z = 7.04226243 ± 0.00027135), a different estimator.

## Not tested — instrument configuration and calibration
The pipeline cannot test, and these results say nothing about: (1) the red-edge flux calibration and throughput near 5.3 µm (needs the calibration reference files/CRDS context and a flat-field/standard-star check at the edge); (2) the wavelength-dependent LSF/dispersion (fits assume a constant 2.2 px FWHM; needs the pipeline's dispersion reference file and a line-width test); (3) the wavelength-calibration version and any pixel-grid offset (needs the same target reprocessed with other pipeline/CRDS versions, and an independent line to anchor the scale); (4) pixel covariance from resampling in the x1d (errors treated as independent; needs the s2d/cal products or the covariance); (5) the error floor/underestimate at the edge (χ²_red 1.7–4.4 at D0 for most models); (6) other gratings/exposures, slit-loss and background subtraction near the edge; (7) the vacuum-vs-air convention is fixed to vacuum (an air value would shift z by +2.2e-3). Needed: the raw/uncal or rate products, the cal/x1d/s2d at several pipeline versions, and the CRDS context in force.

## Limits
Single object, 35 data points per fit; 2C and SPL models are close to over-parameterised; selection by BIC depends on the k convention (RM k_eff, stated in PREREG; k_cont=0 RM BIC is printed EXPLORATORY); Hβ is always a single Gaussian; Δχ²=1 errors profile z with σ, β profiled; the jackknife ignores pixel correlation.

---
# Appendix A — verbatim results/test.log (`./test.sh`)
```text
EOF
cat results/test.log
echo '```'
echo
echo '# Appendix B — verbatim results/run.log (`./run.sh`; §5 holds every FIT record, §6 LOO, §7 SYNTHETIC, §9 PREREG report)'
echo '```text'
cat results/run.log
echo '```'
} > RESULTS.md
