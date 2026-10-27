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
== T1 pre-registration
PASS  PREREG.md matches PREREG.sha256
== T2 fixture and pixel counts
PASS  fixture sha256 c0b87857... verified in run.log
PASS  429 pixels, 408 valid, 21 masked (got n=429 valid=408)
== T3 engine validation (Octave vs awk-sp reference numbers; PREREG s8: 2e-5; runmed 1e-6)
PASS  awk-sp window z, RM12: Octave 7.040280 vs reference 7.040280
PASS  awk-sp window z, P1: Octave 7.041836 vs reference 7.041836
PASS  awk-sp window z, P2: Octave 7.042200 vs reference 7.042200
PASS  running median Octave vs continuum.awk max|diff|=5.000e-11 (< 1e-6)
== T4 independent Fortran 2018 cross-check vs Octave (polynomial, 1C, joint z)
PASS  P0 D0 Fortran 7.040445 vs Octave 7.040445
PASS  P1 D0 Fortran 7.040487 vs Octave 7.040487
PASS  P2 D0 Fortran 7.041442 vs Octave 7.041442
PASS  P3 D0 Fortran 7.041922 vs Octave 7.041922
PASS  P0 D1 Fortran 7.040737 vs Octave 7.040737
PASS  P1 D1 Fortran 7.040199 vs Octave 7.040199
PASS  P2 D1 Fortran 7.039781 vs Octave 7.039781
PASS  P3 D1 Fortran 7.040057 vs Octave 7.040057
INFO  P0 D2 Fortran 7.040441 vs Octave 7.040441 diff=0.00e+00 (not asserted: PREREG s8 asserts D0,D1 only)
INFO  P1 D2 Fortran 7.040026 vs Octave 7.040026 diff=0.00e+00 (not asserted: PREREG s8 asserts D0,D1 only)
INFO  P2 D2 Fortran 7.038958 vs Octave 7.038958 diff=0.00e+00 (not asserted: PREREG s8 asserts D0,D1 only)
INFO  P3 D2 Fortran 7.040635 vs Octave 7.040635 diff=0.00e+00 (not asserted: PREREG s8 asserts D0,D1 only)
INFO  P0 D3 Fortran 7.043472 vs Octave 7.043472 diff=0.00e+00 (not asserted: PREREG s8 asserts D0,D1 only)
INFO  P1 D3 Fortran 7.042017 vs Octave 7.042017 diff=0.00e+00 (not asserted: PREREG s8 asserts D0,D1 only)
INFO  P2 D3 Fortran 7.040639 vs Octave 7.040639 diff=0.00e+00 (not asserted: PREREG s8 asserts D0,D1 only)
INFO  P3 D3 Fortran 7.035841 vs Octave 7.035841 diff=0.00e+00 (not asserted: PREREG s8 asserts D0,D1 only)
INFO  P0 D4 Fortran 7.043832 vs Octave 7.043832 diff=0.00e+00 (not asserted: PREREG s8 asserts D0,D1 only)
INFO  P1 D4 Fortran 7.041990 vs Octave 7.041990 diff=0.00e+00 (not asserted: PREREG s8 asserts D0,D1 only)
INFO  P2 D4 Fortran 7.040740 vs Octave 7.040740 diff=0.00e+00 (not asserted: PREREG s8 asserts D0,D1 only)
INFO  P3 D4 Fortran 7.037793 vs Octave 7.037793 diff=0.00e+00 (not asserted: PREREG s8 asserts D0,D1 only)
== T5 Octave unit tests (cc_unit)
UT PASS template_unit_area_sig0 integral=1.000000000000
UT PASS template_unit_area_sig500 integral=1.000000000000
UT PASS template_unit_area_sig2000 integral=1.000000000000
UT PASS vectorised_vs_bruteforce_chi2 30 cases, max|diff|=1.48e-07
UT PASS finite_on_valid_pixels valid=408
UT PASS export_has_no_nan_inf n=429
UT PASS pixel_counts_429_408_21 n=429 valid=408 masked=21
UT PASS drop_last_pixels D1/D3 counts
UT PASS spline_contains_linear resid=6.0e-15
UT PASS beta_grid_contains_zero 
UT PASS amplitude_nonnegative_constraint A_unconstrained=-48.11 A_constrained=0 chi2_con=9.4783 chi2_unc=1.6956
unit tests: PASS=11 FAIL=0
== T6 SYNTHETIC noise-free injection-recovery, z_true=7.0451 (SYNTHETIC; NOT data). Asserted only where the generating family is contained (PREREG s8, tol 3e-5)
PASS  SYNTHETIC noise-free recovery P1/1C bias=-3.189e-10
PASS  SYNTHETIC noise-free recovery P1/2C bias=+1.765e-06
PASS  SYNTHETIC noise-free recovery P2/1C bias=-4.208e-10
PASS  SYNTHETIC noise-free recovery P2/2C bias=+1.392e-06
PASS  SYNTHETIC noise-free recovery P3/1C bias=+1.069e-09
PASS  SYNTHETIC noise-free recovery P3/2C bias=+2.240e-06
PASS  SYNTHETIC noise-free recovery SPL/1C bias=+1.001e-09
PASS  SYNTHETIC noise-free recovery SPL/2C bias=-1.272e-06
PASS  SYNTHETIC noise-free recovery PLLIN/1C bias=-1.028e-08
PASS  SYNTHETIC noise-free recovery PLLIN/2C bias=+1.748e-06
INFO  SYNTHETIC noise-free RM6/1C (family not contained; not asserted) bias=-3.108e-03
INFO  SYNTHETIC noise-free RM6/2C (family not contained; not asserted) bias=-3.108e-03
INFO  SYNTHETIC noise-free RM12/1C (family not contained; not asserted) bias=-1.584e-05
INFO  SYNTHETIC noise-free RM12/2C (family not contained; not asserted) bias=-1.584e-05
INFO  SYNTHETIC noise-free RM20/1C (family not contained; not asserted) bias=+2.646e-06
INFO  SYNTHETIC noise-free RM20/2C (family not contained; not asserted) bias=+2.646e-06
INFO  SYNTHETIC noise-free P0/1C (family not contained; not asserted) bias=-3.848e-05
INFO  SYNTHETIC noise-free P0/2C (family not contained; not asserted) bias=-3.848e-05
INFO  SYNTHETIC noise-free PL/1C (family not contained; not asserted) bias=-3.037e-06
INFO  SYNTHETIC noise-free PL/2C (family not contained; not asserted) bias=+5.763e-07
INFO  SYNTHETIC kind=edge model=P0 comp=1C z_true=7.04510 zJ=7.044586 bias=-5.142e-04 hwJ=0.000269 chi2=58.6663 zHb=7.045652 zHa=7.044571
INFO  SYNTHETIC kind=edge model=P0 comp=2C z_true=7.04510 zJ=7.044586 bias=-5.142e-04 hwJ=0.000285 chi2=58.6663 zHb=7.045652 zHa=7.044571
INFO  SYNTHETIC kind=edge model=P1 comp=1C z_true=7.04510 zJ=7.044847 bias=-2.532e-04 hwJ=0.000267 chi2=35.7022 zHb=7.045100 zHa=7.044843
INFO  SYNTHETIC kind=edge model=P1 comp=2C z_true=7.04510 zJ=7.046179 bias=+1.079e-03 hwJ=0.000397 chi2=10.4513 zHb=7.045100 zHa=7.047453
INFO  SYNTHETIC kind=edge model=P2 comp=1C z_true=7.04510 zJ=7.046790 bias=+1.690e-03 hwJ=0.000339 chi2=6.6807 zHb=7.045100 zHa=7.046824
INFO  SYNTHETIC kind=edge model=P2 comp=2C z_true=7.04510 zJ=7.047140 bias=+2.040e-03 hwJ=0.000431 chi2=4.8547 zHb=7.045100 zHa=7.047208
INFO  SYNTHETIC kind=edge model=P3 comp=1C z_true=7.04510 zJ=7.047110 bias=+2.010e-03 hwJ=0.000418 chi2=4.8212 zHb=7.045100 zHa=7.047173
INFO  SYNTHETIC kind=edge model=P3 comp=2C z_true=7.04510 zJ=7.047110 bias=+2.010e-03 hwJ=0.000625 chi2=4.8212 zHb=7.045100 zHa=7.047173
INFO  SYNTHETIC kind=edge model=PLLIN comp=1C z_true=7.04510 zJ=7.044847 bias=-2.532e-04 hwJ=0.000267 chi2=35.7015 zHb=7.045100 zHa=7.044843
INFO  SYNTHETIC kind=edge model=PLLIN comp=2C z_true=7.04510 zJ=7.046179 bias=+1.079e-03 hwJ=0.000397 chi2=10.4511 zHb=7.045100 zHa=7.047457
INFO  SYNTHETIC kind=edge model=PL comp=1C z_true=7.04510 zJ=7.044659 bias=-4.407e-04 hwJ=0.000267 chi2=45.7316 zHb=7.045088 zHa=7.044653
INFO  SYNTHETIC kind=edge model=PL comp=2C z_true=7.04510 zJ=7.044659 bias=-4.407e-04 hwJ=0.000267 chi2=45.7316 zHb=7.045088 zHa=7.044653
INFO  SYNTHETIC kind=edge model=RM12 comp=1C z_true=7.04510 zJ=7.044629 bias=-4.708e-04 hwJ=0.000271 chi2=60.4627 zHb=7.044737 zHa=7.044628
INFO  SYNTHETIC kind=edge model=RM12 comp=2C z_true=7.04510 zJ=7.044665 bias=-4.351e-04 hwJ=0.000265 chi2=57.9246 zHb=7.044737 zHa=7.044664
INFO  SYNTHETIC kind=edge model=RM20 comp=1C z_true=7.04510 zJ=7.044643 bias=-4.570e-04 hwJ=0.000271 chi2=64.9329 zHb=7.044737 zHa=7.044642
INFO  SYNTHETIC kind=edge model=RM20 comp=2C z_true=7.04510 zJ=7.044672 bias=-4.282e-04 hwJ=0.000264 chi2=60.5970 zHb=7.044737 zHa=7.044671
INFO  SYNTHETIC kind=edge model=RM6 comp=1C z_true=7.04510 zJ=7.042095 bias=-3.005e-03 hwJ=0.000232 chi2=859.0418 zHb=7.044737 zHa=7.042069
INFO  SYNTHETIC kind=edge model=RM6 comp=2C z_true=7.04510 zJ=7.042095 bias=-3.005e-03 hwJ=0.000232 chi2=859.0418 zHb=7.044737 zHa=7.042069
INFO  SYNTHETIC kind=edge model=SPL comp=1C z_true=7.04510 zJ=7.047155 bias=+2.055e-03 hwJ=0.000477 chi2=4.7877 zHb=7.045100 zHa=7.047238
INFO  SYNTHETIC kind=edge model=SPL comp=2C z_true=7.04510 zJ=7.045879 bias=+7.788e-04 hwJ=0.000627 chi2=3.3986 zHb=7.045100 zHa=7.045924
INFO  SYNTHETIC SUMMARY kind=noisy model=P1 comp=1C N=30 z_true=7.04510 mean_bias=+3.786e-05 sd=3.334e-04 mean_hw=2.787e-04 coverage_1sigma=14/30
INFO  SYNTHETIC SUMMARY kind=noisy model=P2 comp=1C N=30 z_true=7.04510 mean_bias=+7.147e-05 sd=4.116e-04 mean_hw=3.394e-04 coverage_1sigma=19/30
INFO  SYNTHETIC SUMMARY kind=noisy model=RM12 comp=1C N=30 z_true=7.04510 mean_bias=+2.886e-05 sd=2.299e-04 mean_hw=2.759e-04 coverage_1sigma=23/30
INFO  SYNTHETIC SUMMARY kind=noisy model=SPL comp=1C N=30 z_true=7.04510 mean_bias=+6.059e-06 sd=3.651e-04 mean_hw=4.456e-04 coverage_1sigma=24/30
== T7 job completion and report parsing
PASS  244 job outputs present (got 244)
PASS  no failed jobs (exit!=0): 0
PASS  180 FIT records (10 models x 2 comps x 9 scenarios; got 180)
PASS  cc_report parsed 180 records
== T8 housekeeping
PASS  AGPL-3.0-only SPDX header in every source file 
PASS  no .py/.js/.ts files (0 found)

TOTAL PASS=42 FAIL=0
```

# Appendix B — verbatim results/run.log (`./run.sh`; §5 holds every FIT record, §6 LOO, §7 SYNTHETIC, §9 PREREG report)
```text
=== run.sh started 2026-10-26 21:01:25 PDT host=grok-bot-vm-450106434
=== PREREG hash verified: 0d5740378eb901e0d862176b69e1b64f91282308b8b8a91a7ea7725924cc99d2  PREREG.md
=== tool versions
mawk 1.3.4 20250131
GNU Octave, version 9.4.0
GNU Fortran (Debian 14.2.0-19) 14.2.0
maxima: NOT INSTALLED (not used)
=== script sha256
0f2002ca9a0a2b22d2b2367129b926ac112d41aa1cff0ef3226855a46b761a67  run.sh
9c5f9c425f7b44b7f66ed275f5668039419fdf3884ca7c0394572792b035608f  test.sh
0d5740378eb901e0d862176b69e1b64f91282308b8b8a91a7ea7725924cc99d2  PREREG.md
14b71fdb8dba46946aae41c6b20119dd5ec87ad493068161e58760c405bb128a  lib/job.sh
bc2c42c31628037ac2557a2f36f833980ae77e1ab6354eb2e5c72cadd6f3a7b7  lib/prep.sh
b9a18d068d7fad6fdc3d8ac5d4f75769e37f0f765c061a7f4665bba997e2844f  awk/common.awk
e4135079e8b9ab95b9a0e8f2e87d694be8f7bfabeb59c48535d2be85036ba641  awk/continuum.awk
29f195ea441f3d009acbdb156b74600b57b06fc9852ab5d90244e5be3dba095c  awk/export.awk
ba8bcf8120a00baa73902afc60cc01b9a342891698283505d3389038305d942d  awk/gridtally.awk
c6cd79c55236ee759d3b067481741d768e6fafcf292eed9bd10db33146ed143d  awk/mask.awk
1d454cdcab18827194092b0c9610b82401020a4ed5cfb60f3b904a799104f9ef  awk/r3strict.awk
eb9498440cb2ad425f9dcee633c2d5432b61ee673b9dd875fd3a98b920c17e04  octave/cc_basis.m
c6b3b9da78e0867421eeb48c6166d654380abda97297e8cf620a5fc70714b0a6  octave/cc_const.m
609fa46b014dc87f34d2b8fc4598aec8a824e09d51d8ceea8dbd4e01033819f4  octave/cc_direct.m
907781de6ad55addc7e07fe956fae56481f27389b475a89a89ca7dc37f16dd9c  octave/cc_fit.m
09c1f58dace3718cf3b812780d637cdb4aa72cd2fea00949c889efee5857ed39  octave/cc_job.m
a058e48563b4a381d927fb589fe2af35747c60fd87c3ae598dfa9113acaf2cc7  octave/cc_line.m
3b9604216636fd7782cbc7eb40d349aa871740f0bc0e2fcc503bdd93c334c92f  octave/cc_load.m
e51b3e4fee3f44ce90e71f877d7b40fef477fe5dbe09a3b1e3c0077ca2e32783  octave/cc_loo.m
a938c623de8417829032a38d3b0e48e34cfcad51d81146bbb73e9f10691ab0b5  octave/cc_models.m
8d2a8abd9462d0624546638b13dc65f378eba6085bd9070c9188b28e1918bf3c  octave/cc_parse.m
6b3fbf563affc8ca3c815b8b84e93a8f8a1d494dd97f748948230142980483d0  octave/cc_peak.m
38354abe45455dc259db0e3d29e3ac0018f9e2a43f90771b9e267d5314bb2ba9  octave/cc_report.m
674bc558e1982a490879c6f7a4caf2563f91e31064b11dc2bab95a6eee1d2a15  octave/cc_runmed.m
a2ada1aa1832b79f45991515ed2679831280c7d0b46d4fe5fc472a2f365607a5  octave/cc_scen.m
d820c11491e381901089fb8411c392bc1716497da93e703b4ea0b12624d18ff2  octave/cc_syn.m
cc56ca4a954fb393740730f3337af982588ac9ff9046f75a722a997e909fcf98  octave/cc_synth.m
ad860279e50ab001f4e88f5b20a7c5b8947806ab1be3112aacc5aef1fe93be91  octave/cc_tmpl.m
9bf55f7f3bb208b64e85ac98f75226dd08adbd91573349fa88989b9d2d53cf6d  octave/cc_unit.m
c3986a4f7503538a342237856c72b7c54144ef37a7d498e73f073c7473115ef1  octave/cc_validate.m
f30f03fe2b9387b457cd615f37f89b860c4b63287ba81da1fe24020849b41e44  octave/cc_wchi2.m
1cedb54167b42fe955a28efb03b99d114924613c585f3253ec23f8567ec8c5d6  octave/cc_win.m
93bd126144a88322366a0e7ddac4e6076704e720be34d4fde142493a4802a3b5  fortran/xcheck.f90

=== 0. data verification and export (lib/prep.sh, mask.awk, export.awk)
prep: SRC=/workspace/verify-main/repo/fixtures
SHA-OK   ingest/CURRENT c0b878576d7d7ec723c5ee526d29715fb672d81e45bc8ba4e02598ce8b9c5ee7
SHA-OK   raw.fits c0b878576d7d7ec723c5ee526d29715fb672d81e45bc8ba4e02598ce8b9c5ee7
SHA-OK   wavelength.f64 349b11d7be59344b2812433983fbb41215dffb868a0a74be667f7d04e8444d9e
HDR wavelength format=LRD-ARR-v1 length=429 unit=um bytes=3432 (expect 3432) source_sha256_matches=yes
SHA-OK   flux.f64 594d5e4c4778f71b8d3ba0b5e294a3c5368a253ea7f64d4d905031d235c3ee63
HDR flux format=LRD-ARR-v1 length=429 unit=Jy bytes=3432 (expect 3432) source_sha256_matches=yes
SHA-OK   flux_error.f64 ed7e63c559e0f8cb2ce2bdb4cecd7cf9193344ddc007587717bb8b14792b4711
HDR flux_error format=LRD-ARR-v1 length=429 unit=Jy bytes=3432 (expect 3432) source_sha256_matches=yes
prep: wrote /workspace/continuum-compare/work/spectrum.tsv rows=429
prep: sha256(work/spectrum.tsv)=9fa5e07ff6286dd32103d954b147a58761520ce604cd9bf9e70e7cfe11430ddd
MASK pixels_total=429 valid=408 masked=21
MASK reason_counts: wl_nonfinite=0 flux_nonfinite=21 err_nonfinite=0 err_nonpositive=21 (a pixel may carry >1 reason)
MASK valid_pixels_with_negative_flux_kept=28 (not masked; noise)
MASK log written: work/mask.log
--- work/mask.log (verbatim)
1	0.5537876486778259	flux_nonfinite;err_nonpositive;
2	0.5572157502174377	flux_nonfinite;err_nonpositive;
3	0.5606940984725952	flux_nonfinite;err_nonpositive;
4	0.5642468333244324	flux_nonfinite;err_nonpositive;
5	0.5678717494010925	flux_nonfinite;err_nonpositive;
6	0.5715553760528564	flux_nonfinite;err_nonpositive;
7	0.5753014087677002	flux_nonfinite;err_nonpositive;
8	0.5791358947753906	flux_nonfinite;err_nonpositive;
9	0.5830442905426025	flux_nonfinite;err_nonpositive;
10	0.5870235562324524	flux_nonfinite;err_nonpositive;
11	0.5910772681236267	flux_nonfinite;err_nonpositive;
12	0.595209002494812	flux_nonfinite;err_nonpositive;
421	5.311203479766846	flux_nonfinite;err_nonpositive;
422	5.318572044372559	flux_nonfinite;err_nonpositive;
423	5.325930118560791	flux_nonfinite;err_nonpositive;
424	5.333276271820068	flux_nonfinite;err_nonpositive;
425	5.340611457824707	flux_nonfinite;err_nonpositive;
426	5.347935199737549	flux_nonfinite;err_nonpositive;
427	5.355247974395752	flux_nonfinite;err_nonpositive;
428	5.362549304962158	flux_nonfinite;err_nonpositive;
429	5.369840145111084	flux_nonfinite;err_nonpositive;
rows(cc_input.tsv)=429  sha256=313f797f4e95622262095e9a68cbc643ce1733b74b34416b981a815f1714e30f
CONT final clipped pixel idx: 61 69 220 256 257 258 259 412 413 414 415 416 417 418 419
CONT params HALF=12 (window 25 valid px) CLIP=3 NITER=6; valid=408; truncated_edge_windows=24
CONT last valid pixel idx=420 wl_A=53038.230 window_px=13 cont=0.478519 flam=0.335348

=== 1. build independent Fortran cross-check
xcheck built

=== 2. engine validation (Octave vs awk-sp numbers, vs continuum.awk)
VAL awkwindow model=RM12 zJ=7.040280 hwJ=0.000268 chi2=97.989 zHb=7.038287 zHa=7.040306 nHb=11 nHa=9
VAL awkwindow model=P1 zJ=7.041836 hwJ=0.000336 chi2=49.032 zHb=7.038520 zHa=7.041892 nHb=11 nHa=9
VAL awkwindow model=P2 zJ=7.042200 hwJ=0.000402 chi2=39.819 zHb=7.038641 zHa=7.042295 nHb=11 nHa=9
VAL runmed12 octave-vs-awk(continuum.awk) maxabsdiff=5.000e-11 over 408 valid pixels

=== 3. Fortran xcheck: polynomial orders 0..3, red-edge drops D0..D4
XCHECK order=0 ndrop=0 nHb=19 nHa=16 zJ=  7.040445 lo= 7.040175 hi= 7.040714 chi2= 115.2614
XCHECK order=1 ndrop=0 nHb=19 nHa=16 zJ=  7.040487 lo= 7.040211 hi= 7.040763 chi2= 113.3115
XCHECK order=2 ndrop=0 nHb=19 nHa=16 zJ=  7.041442 lo= 7.041118 hi= 7.041766 chi2=  80.0436
XCHECK order=3 ndrop=0 nHb=19 nHa=16 zJ=  7.041922 lo= 7.041554 hi= 7.042295 chi2=  69.1668
XCHECK order=0 ndrop=1 nHb=19 nHa=15 zJ=  7.040737 lo= 7.040459 hi= 7.041015 chi2=  74.3927
XCHECK order=1 ndrop=1 nHb=19 nHa=15 zJ=  7.040199 lo= 7.039912 hi= 7.040485 chi2=  54.1856
XCHECK order=2 ndrop=1 nHb=19 nHa=15 zJ=  7.039781 lo= 7.039433 hi= 7.040128 chi2=  46.5181
XCHECK order=3 ndrop=1 nHb=19 nHa=15 zJ=  7.040057 lo= 7.039241 hi= 7.040470 chi2=  44.5618
XCHECK order=0 ndrop=2 nHb=19 nHa=14 zJ=  7.040441 lo= 7.040137 hi= 7.040747 chi2=  69.3498
XCHECK order=1 ndrop=2 nHb=19 nHa=14 zJ=  7.040026 lo= 7.039731 hi= 7.040321 chi2=  50.6236
XCHECK order=2 ndrop=2 nHb=19 nHa=14 zJ=  7.038958 lo= 7.038598 hi= 7.039312 chi2=  45.7047
XCHECK order=3 ndrop=2 nHb=19 nHa=14 zJ=  7.040635 lo= 7.040097 hi= 7.041166 chi2=  41.9419
XCHECK order=0 ndrop=3 nHb=19 nHa=13 zJ=  7.043472 lo= 7.042983 hi= 7.043967 chi2=  50.0303
XCHECK order=1 ndrop=3 nHb=19 nHa=13 zJ=  7.042017 lo= 7.041541 hi= 7.042503 chi2=  39.8069
XCHECK order=2 ndrop=3 nHb=19 nHa=13 zJ=  7.040639 lo= 7.040167 hi= 7.041123 chi2=  32.3951
XCHECK order=3 ndrop=3 nHb=19 nHa=13 zJ=  7.035841 lo= 7.035064 hi= 7.036736 chi2=  21.5983
XCHECK order=0 ndrop=4 nHb=19 nHa=12 zJ=  7.043832 lo= 7.042992 hi= 7.044745 chi2=  49.7539
XCHECK order=1 ndrop=4 nHb=19 nHa=12 zJ=  7.041990 lo= 7.041113 hi= 7.042898 chi2=  39.8056
XCHECK order=2 ndrop=4 nHb=19 nHa=12 zJ=  7.040740 lo= 7.039739 hi= 7.041807 chi2=  32.3827
XCHECK order=3 ndrop=4 nHb=19 nHa=12 zJ=  7.037793 lo= 7.036151 hi= 7.040207 chi2=  18.2647

=== 4. job list
jobs: 244  parallel: 8
jobs finished in 435 s; failed jobs (exit!=0): 0

=== 5. verbatim FIT records (all models x scenarios)
FIT model=P0 comp=1C scen=D0 BW=6 n=29 nHb=19 nHa=10 k=7 dof=22 zJ=7.040479 hwJ=0.000273 lo=7.040207 hi=7.040752 hwJscaled=0.000600 chi2=106.5942 chi2red=4.8452 aic=120.5942 bic=130.1653 bic_k0=130.1653 zHb=7.038601 hwHb=0.002314 chi2Hb=18.3725 zHa=7.040506 hwHa=0.000275 chi2Ha=87.5556 sigHb=700 sigHa=500 sigHaB=NaN edge=0
FIT model=P0 comp=1C scen=D0 BW=8 n=31 nHb=19 nHa=12 k=7 dof=24 zJ=7.040458 hwJ=0.000271 lo=7.040187 hi=7.040729 hwJscaled=0.000584 chi2=111.3318 chi2red=4.6388 aic=125.3318 bic=135.3697 bic_k0=135.3697 zHb=7.038601 hwHb=0.002314 chi2Hb=18.3725 zHa=7.040483 hwHa=0.000273 chi2Ha=92.3084 sigHb=700 sigHa=500 sigHaB=NaN edge=0
FIT model=P0 comp=1C scen=D0 BW=12 n=35 nHb=19 nHa=16 k=7 dof=28 zJ=7.040445 hwJ=0.000270 lo=7.040175 hi=7.040714 hwJscaled=0.000547 chi2=115.2614 chi2red=4.1165 aic=129.2614 bic=140.1489 bic_k0=140.1489 zHb=7.038601 hwHb=0.002314 chi2Hb=18.3725 zHa=7.040470 hwHa=0.000272 chi2Ha=96.2473 sigHb=700 sigHa=500 sigHaB=NaN edge=0
FIT model=P0 comp=1C scen=D1 BW=12 n=34 nHb=19 nHa=15 k=7 dof=27 zJ=7.040737 hwJ=0.000278 lo=7.040459 hi=7.041015 hwJscaled=0.000462 chi2=74.3927 chi2red=2.7553 aic=88.3927 bic=99.0772 bic_k0=99.0772 zHb=7.038601 hwHb=0.002314 chi2Hb=18.3725 zHa=7.040768 hwHa=0.000280 chi2Ha=55.1591 sigHb=700 sigHa=500 sigHaB=NaN edge=0
FIT model=P0 comp=1C scen=D2 BW=12 n=33 nHb=19 nHa=14 k=7 dof=26 zJ=7.040441 hwJ=0.000305 lo=7.040137 hi=7.040747 hwJscaled=0.000498 chi2=69.3498 chi2red=2.6673 aic=83.3498 bic=93.8254 bic_k0=93.8254 zHb=7.038601 hwHb=0.002314 chi2Hb=18.3725 zHa=7.040474 hwHa=0.000308 chi2Ha=50.3355 sigHb=700 sigHa=500 sigHaB=NaN edge=0
FIT model=P0 comp=1C scen=D3 BW=12 n=32 nHb=19 nHa=13 k=7 dof=25 zJ=7.043472 hwJ=0.000492 lo=7.042983 hi=7.043967 hwJscaled=0.000696 chi2=50.0303 chi2red=2.0012 aic=64.0303 bic=74.2904 bic_k0=74.2904 zHb=7.038601 hwHb=0.002314 chi2Hb=18.3725 zHa=7.043695 hwHa=0.000506 chi2Ha=27.1101 sigHb=700 sigHa=600 sigHaB=NaN edge=0
FIT model=P0 comp=1C scen=D4 BW=12 n=31 nHb=19 nHa=12 k=7 dof=24 zJ=7.043832 hwJ=0.000876 lo=7.042992 hi=7.044745 hwJscaled=0.001262 chi2=49.7539 chi2red=2.0731 aic=63.7539 bic=73.7918 bic_k0=73.7918 zHb=7.038601 hwHb=0.002314 chi2Hb=18.3725 zHa=7.061627 hwHa=0.001579 chi2Ha=10.5457 sigHb=700 sigHa=600 sigHaB=NaN edge=0
FIT model=P0 comp=1C scen=ERRALL BW=12 n=29 nHb=19 nHa=10 k=7 dof=22 zJ=7.038793 hwJ=0.002086 lo=7.036721 hi=7.040893 hwJscaled=0.002194 chi2=24.3381 chi2red=1.1063 aic=38.3381 bic=47.9092 bic_k0=47.9092 zHb=7.038601 hwHb=0.002314 chi2Hb=18.3725 zHa=7.026763 hwHa=NaN chi2Ha=5.6089 sigHb=700 sigHa=800 sigHaB=NaN edge=0
FIT model=P0 comp=1C scen=ERREDGE BW=12 n=29 nHb=19 nHa=10 k=7 dof=22 zJ=7.038793 hwJ=0.002086 lo=7.036721 hi=7.040893 hwJscaled=0.002194 chi2=24.3381 chi2red=1.1063 aic=38.3381 bic=47.9092 bic_k0=47.9092 zHb=7.038601 hwHb=0.002314 chi2Hb=18.3725 zHa=7.026763 hwHa=NaN chi2Ha=5.6089 sigHb=700 sigHa=800 sigHaB=NaN edge=0
FIT model=P0 comp=2C scen=D0 BW=6 n=29 nHb=19 nHa=10 k=9 dof=20 zJ=7.040513 hwJ=0.000270 lo=7.040243 hi=7.040783 hwJscaled=0.000597 chi2=97.5987 chi2red=4.8799 aic=115.5987 bic=127.9044 bic_k0=127.9044 zHb=7.038601 hwHb=0.002314 chi2Hb=18.3725 zHa=7.040539 hwHa=0.000272 chi2Ha=78.5364 sigHb=700 sigHa=400 sigHaB=1000 edge=0
FIT model=P0 comp=2C scen=D0 BW=8 n=31 nHb=19 nHa=12 k=9 dof=22 zJ=7.040485 hwJ=0.000277 lo=7.040216 hi=7.040770 hwJscaled=0.000594 chi2=101.2463 chi2red=4.6021 aic=119.2463 bic=132.1521 bic_k0=132.1521 zHb=7.038601 hwHb=0.002314 chi2Hb=18.3725 zHa=7.040511 hwHa=0.000280 chi2Ha=82.2037 sigHb=700 sigHa=300 sigHaB=900 edge=0
FIT model=P0 comp=2C scen=D0 BW=12 n=35 nHb=19 nHa=16 k=9 dof=26 zJ=7.040508 hwJ=0.000271 lo=7.040236 hi=7.040777 hwJscaled=0.000541 chi2=103.9027 chi2red=3.9963 aic=121.9027 bic=135.9009 bic_k0=135.9009 zHb=7.038601 hwHb=0.002314 chi2Hb=18.3725 zHa=7.040534 hwHa=0.000272 chi2Ha=84.8441 sigHb=700 sigHa=400 sigHaB=1100 edge=0
FIT model=P0 comp=2C scen=D1 BW=12 n=34 nHb=19 nHa=15 k=9 dof=25 zJ=7.040923 hwJ=0.000283 lo=7.040641 hi=7.041207 hwJscaled=0.000315 chi2=30.9158 chi2red=1.2366 aic=48.9158 bic=62.6530 bic_k0=62.6530 zHb=7.038601 hwHb=0.002314 chi2Hb=18.3725 zHa=7.040958 hwHa=0.000285 chi2Ha=11.5261 sigHb=700 sigHa=100 sigHaB=900 edge=0
FIT model=P0 comp=2C scen=D2 BW=12 n=33 nHb=19 nHa=14 k=9 dof=24 zJ=7.040628 hwJ=0.000304 lo=7.040325 hi=7.040934 hwJscaled=0.000323 chi2=27.0435 chi2red=1.1268 aic=45.0435 bic=58.5121 bic_k0=58.5121 zHb=7.038601 hwHb=0.002314 chi2Hb=18.3725 zHa=7.040663 hwHa=0.000308 chi2Ha=7.8932 sigHb=700 sigHa=200 sigHaB=900 edge=0
FIT model=P0 comp=2C scen=D3 BW=12 n=32 nHb=19 nHa=13 k=9 dof=23 zJ=7.040932 hwJ=0.000526 lo=7.040424 hi=7.041477 hwJscaled=0.000565 chi2=26.4899 chi2red=1.1517 aic=44.4899 bic=57.6815 bic_k0=57.6815 zHb=7.038601 hwHb=0.002314 chi2Hb=18.3725 zHa=7.041061 hwHa=0.000737 chi2Ha=7.0522 sigHb=700 sigHa=200 sigHaB=900 edge=0
FIT model=P0 comp=2C scen=D4 BW=12 n=31 nHb=19 nHa=12 k=9 dof=22 zJ=7.038748 hwJ=0.001887 lo=7.037342 hi=7.041116 hwJscaled=0.002036 chi2=25.6084 chi2red=1.1640 aic=43.6084 bic=56.5143 bic_k0=56.5143 zHb=7.038601 hwHb=0.002314 chi2Hb=18.3725 zHa=7.040543 hwHa=0.008423 chi2Ha=6.9764 sigHb=700 sigHa=100 sigHaB=900 edge=0
FIT model=P0 comp=2C scen=ERRALL BW=12 n=29 nHb=19 nHa=10 k=9 dof=20 zJ=7.038556 hwJ=0.002344 lo=7.036217 hi=7.040905 hwJscaled=0.002603 chi2=24.6644 chi2red=1.2332 aic=42.6644 bic=54.9700 bic_k0=54.9700 zHb=7.038601 hwHb=0.002314 chi2Hb=18.3725 zHa=7.023124 hwHa=NaN chi2Ha=5.1767 sigHb=700 sigHa=600 sigHaB=900 edge=0
FIT model=P0 comp=2C scen=ERREDGE BW=12 n=29 nHb=19 nHa=10 k=9 dof=20 zJ=7.038556 hwJ=0.002344 lo=7.036217 hi=7.040905 hwJscaled=0.002603 chi2=24.6644 chi2red=1.2332 aic=42.6644 bic=54.9700 bic_k0=54.9700 zHb=7.038601 hwHb=0.002314 chi2Hb=18.3725 zHa=7.023124 hwHa=NaN chi2Ha=5.1767 sigHb=700 sigHa=600 sigHaB=900 edge=0
FIT model=P1 comp=1C scen=D0 BW=6 n=29 nHb=19 nHa=10 k=9 dof=20 zJ=7.041407 hwJ=0.000313 lo=7.041093 hi=7.041719 hwJscaled=0.000609 chi2=75.5960 chi2red=3.7798 aic=93.5960 bic=105.9017 bic_k0=105.9017 zHb=7.037940 hwHb=0.002315 chi2Hb=16.5238 zHa=7.041464 hwHa=0.000315 chi2Ha=56.8736 sigHb=700 sigHa=500 sigHaB=NaN edge=0
FIT model=P1 comp=1C scen=D0 BW=8 n=31 nHb=19 nHa=12 k=9 dof=22 zJ=7.040832 hwJ=0.000292 lo=7.040537 hi=7.041122 hwJscaled=0.000623 chi2=99.9168 chi2red=4.5417 aic=117.9168 bic=130.8227 bic_k0=130.8227 zHb=7.037940 hwHb=0.002315 chi2Hb=16.5238 zHa=7.040873 hwHa=0.000292 chi2Ha=81.8175 sigHb=700 sigHa=500 sigHaB=NaN edge=0
FIT model=P1 comp=1C scen=D0 BW=12 n=35 nHb=19 nHa=16 k=9 dof=26 zJ=7.040487 hwJ=0.000276 lo=7.040211 hi=7.040763 hwJscaled=0.000577 chi2=113.3115 chi2red=4.3581 aic=131.3115 bic=145.3097 bic_k0=145.3097 zHb=7.037940 hwHb=0.002315 chi2Hb=16.5238 zHa=7.040524 hwHa=0.000278 chi2Ha=95.5609 sigHb=600 sigHa=500 sigHaB=NaN edge=0
FIT model=P1 comp=1C scen=D1 BW=12 n=34 nHb=19 nHa=15 k=9 dof=25 zJ=7.040199 hwJ=0.000286 lo=7.039912 hi=7.040485 hwJscaled=0.000422 chi2=54.1856 chi2red=2.1674 aic=72.1856 bic=85.9229 bic_k0=85.9229 zHb=7.037940 hwHb=0.002315 chi2Hb=16.5238 zHa=7.040234 hwHa=0.000288 chi2Ha=36.6951 sigHb=600 sigHa=400 sigHaB=NaN edge=0
FIT model=P1 comp=1C scen=D2 BW=12 n=33 nHb=19 nHa=14 k=9 dof=24 zJ=7.040026 hwJ=0.000295 lo=7.039731 hi=7.040321 hwJscaled=0.000429 chi2=50.6236 chi2red=2.1093 aic=68.6236 bic=82.0921 bic_k0=82.0921 zHb=7.037940 hwHb=0.002315 chi2Hb=16.5238 zHa=7.040060 hwHa=0.000298 chi2Ha=33.2747 sigHb=600 sigHa=400 sigHaB=NaN edge=0
FIT model=P1 comp=1C scen=D3 BW=12 n=32 nHb=19 nHa=13 k=9 dof=23 zJ=7.042017 hwJ=0.000481 lo=7.041541 hi=7.042503 hwJscaled=0.000633 chi2=39.8069 chi2red=1.7307 aic=57.8069 bic=70.9985 bic_k0=70.9985 zHb=7.037940 hwHb=0.002315 chi2Hb=16.5238 zHa=7.042184 hwHa=0.000497 chi2Ha=20.2323 sigHb=700 sigHa=500 sigHaB=NaN edge=0
FIT model=P1 comp=1C scen=D4 BW=12 n=31 nHb=19 nHa=12 k=9 dof=22 zJ=7.041990 hwJ=0.000892 lo=7.041113 hi=7.042898 hwJscaled=0.001200 chi2=39.8056 chi2red=1.8093 aic=57.8056 bic=70.7115 bic_k0=70.7115 zHb=7.037940 hwHb=0.002315 chi2Hb=16.5238 zHa=7.063457 hwHa=NaN chi2Ha=8.4615 sigHb=700 sigHa=500 sigHaB=NaN edge=0
FIT model=P1 comp=1C scen=ERRALL BW=12 n=29 nHb=19 nHa=10 k=9 dof=20 zJ=7.037449 hwJ=0.002543 lo=7.035272 hi=7.040358 hwJscaled=0.002694 chi2=22.4357 chi2red=1.1218 aic=40.4357 bic=52.7414 bic_k0=52.7414 zHb=7.037940 hwHb=0.002315 chi2Hb=16.5238 zHa=7.023212 hwHa=NaN chi2Ha=5.1556 sigHb=600 sigHa=700 sigHaB=NaN edge=0
FIT model=P1 comp=1C scen=ERREDGE BW=12 n=29 nHb=19 nHa=10 k=9 dof=20 zJ=7.037449 hwJ=0.002543 lo=7.035272 hi=7.040358 hwJscaled=0.002694 chi2=22.4357 chi2red=1.1218 aic=40.4357 bic=52.7414 bic_k0=52.7414 zHb=7.037940 hwHb=0.002315 chi2Hb=16.5238 zHa=7.023212 hwHa=NaN chi2Ha=5.1556 sigHb=600 sigHa=700 sigHaB=NaN edge=0
FIT model=P1 comp=2C scen=D0 BW=6 n=29 nHb=19 nHa=10 k=11 dof=18 zJ=7.042147 hwJ=0.000398 lo=7.041756 hi=7.042551 hwJscaled=0.000677 chi2=52.1574 chi2red=2.8976 aic=74.1574 bic=89.1977 bic_k0=89.1977 zHb=7.037940 hwHb=0.002315 chi2Hb=16.5238 zHa=7.042261 hwHa=0.000415 chi2Ha=32.4362 sigHb=700 sigHa=200 sigHaB=900 edge=0
FIT model=P1 comp=2C scen=D0 BW=8 n=31 nHb=19 nHa=12 k=11 dof=20 zJ=7.042140 hwJ=0.000451 lo=7.041637 hi=7.042539 hwJscaled=0.000751 chi2=55.5668 chi2red=2.7783 aic=77.5668 bic=93.3407 bic_k0=93.3407 zHb=7.037940 hwHb=0.002315 chi2Hb=16.5238 zHa=7.042241 hwHa=0.000451 chi2Ha=35.8642 sigHb=700 sigHa=200 sigHaB=1000 edge=0
FIT model=P1 comp=2C scen=D0 BW=12 n=35 nHb=19 nHa=16 k=11 dof=24 zJ=7.042072 hwJ=0.000394 lo=7.041673 hi=7.042460 hwJscaled=0.000682 chi2=72.0080 chi2red=3.0003 aic=94.0080 bic=111.1168 bic_k0=111.1168 zHb=7.037940 hwHb=0.002315 chi2Hb=16.5238 zHa=7.042179 hwHa=0.000398 chi2Ha=52.3975 sigHb=700 sigHa=500 sigHaB=2400 edge=0
FIT model=P1 comp=2C scen=D1 BW=12 n=34 nHb=19 nHa=15 k=11 dof=23 zJ=7.040835 hwJ=0.000344 lo=7.040525 hi=7.041214 hwJscaled=0.000391 chi2=29.6781 chi2red=1.2904 aic=51.6781 bic=68.4681 bic_k0=68.4681 zHb=7.037940 hwHb=0.002315 chi2Hb=16.5238 zHa=7.040961 hwHa=0.000343 chi2Ha=11.5255 sigHb=700 sigHa=200 sigHaB=900 edge=0
FIT model=P1 comp=2C scen=D2 BW=12 n=33 nHb=19 nHa=14 k=11 dof=22 zJ=7.040615 hwJ=0.000318 lo=7.040304 hi=7.040940 hwJscaled=0.000344 chi2=25.7747 chi2red=1.1716 aic=47.7747 bic=64.2363 bic_k0=64.2363 zHb=7.037940 hwHb=0.002315 chi2Hb=16.5238 zHa=7.040665 hwHa=0.000331 chi2Ha=7.8926 sigHb=600 sigHa=200 sigHaB=900 edge=0
FIT model=P1 comp=2C scen=D3 BW=12 n=32 nHb=19 nHa=13 k=11 dof=21 zJ=7.040920 hwJ=0.000544 lo=7.040389 hi=7.041477 hwJscaled=0.000596 chi2=25.2809 chi2red=1.2039 aic=47.2809 bic=63.4040 bic_k0=63.4040 zHb=7.037940 hwHb=0.002315 chi2Hb=16.5238 zHa=7.041075 hwHa=0.000750 chi2Ha=7.0398 sigHb=700 sigHa=200 sigHaB=900 edge=0
FIT model=P1 comp=2C scen=D4 BW=12 n=31 nHb=19 nHa=12 k=11 dof=20 zJ=7.038632 hwJ=0.001702 lo=7.037175 hi=7.040580 hwJscaled=0.001857 chi2=23.7949 chi2red=1.1897 aic=45.7949 bic=61.5687 bic_k0=61.5687 zHb=7.037940 hwHb=0.002315 chi2Hb=16.5238 zHa=7.040572 hwHa=0.013123 chi2Ha=6.9724 sigHb=600 sigHa=100 sigHaB=900 edge=0
FIT model=P1 comp=2C scen=ERRALL BW=12 n=29 nHb=19 nHa=10 k=11 dof=18 zJ=7.037845 hwJ=0.002357 lo=7.035485 hi=7.040199 hwJscaled=0.002649 chi2=22.7420 chi2red=1.2634 aic=44.7420 bic=59.7823 bic_k0=59.7823 zHb=7.037940 hwHb=0.002315 chi2Hb=16.5238 zHa=7.023212 hwHa=NaN chi2Ha=5.1556 sigHb=600 sigHa=600 sigHaB=900 edge=0
FIT model=P1 comp=2C scen=ERREDGE BW=12 n=29 nHb=19 nHa=10 k=11 dof=18 zJ=7.037845 hwJ=0.002357 lo=7.035485 hi=7.040199 hwJscaled=0.002649 chi2=22.7420 chi2red=1.2634 aic=44.7420 bic=59.7823 bic_k0=59.7823 zHb=7.037940 hwHb=0.002315 chi2Hb=16.5238 zHa=7.023212 hwHa=NaN chi2Ha=5.1556 sigHb=600 sigHa=600 sigHaB=900 edge=0
FIT model=P2 comp=1C scen=D0 BW=6 n=29 nHb=19 nHa=10 k=11 dof=18 zJ=7.042044 hwJ=0.000380 lo=7.041667 hi=7.042426 hwJscaled=0.000669 chi2=55.8470 chi2red=3.1026 aic=77.8470 bic=92.8873 bic_k0=92.8873 zHb=7.038509 hwHb=0.002410 chi2Hb=14.3926 zHa=7.042128 hwHa=0.000386 chi2Ha=39.3733 sigHb=600 sigHa=400 sigHaB=NaN edge=0
FIT model=P2 comp=1C scen=D0 BW=8 n=31 nHb=19 nHa=12 k=11 dof=20 zJ=7.041999 hwJ=0.000370 lo=7.041630 hi=7.042370 hwJscaled=0.000679 chi2=67.2680 chi2red=3.3634 aic=89.2680 bic=105.0419 bic_k0=105.0419 zHb=7.038509 hwHb=0.002410 chi2Hb=14.3926 zHa=7.042077 hwHa=0.000375 chi2Ha=50.8487 sigHb=600 sigHa=500 sigHaB=NaN edge=0
FIT model=P2 comp=1C scen=D0 BW=12 n=35 nHb=19 nHa=16 k=11 dof=24 zJ=7.041442 hwJ=0.000324 lo=7.041118 hi=7.041766 hwJscaled=0.000591 chi2=80.0436 chi2red=3.3351 aic=102.0436 bic=119.1524 bic_k0=119.1524 zHb=7.038509 hwHb=0.002410 chi2Hb=14.3926 zHa=7.041492 hwHa=0.000326 chi2Ha=64.2167 sigHb=600 sigHa=500 sigHaB=NaN edge=0
FIT model=P2 comp=1C scen=D1 BW=12 n=34 nHb=19 nHa=15 k=11 dof=23 zJ=7.039781 hwJ=0.000347 lo=7.039433 hi=7.040128 hwJscaled=0.000494 chi2=46.5181 chi2red=2.0225 aic=68.5181 bic=85.3081 bic_k0=85.3081 zHb=7.038509 hwHb=0.002410 chi2Hb=14.3926 zHa=7.039809 hwHa=0.000350 chi2Ha=31.8329 sigHb=500 sigHa=400 sigHaB=NaN edge=0
FIT model=P2 comp=1C scen=D2 BW=12 n=33 nHb=19 nHa=14 k=11 dof=22 zJ=7.038958 hwJ=0.000357 lo=7.038598 hi=7.039312 hwJscaled=0.000515 chi2=45.7047 chi2red=2.0775 aic=67.7047 bic=84.1663 bic_k0=84.1663 zHb=7.038509 hwHb=0.002410 chi2Hb=14.3926 zHa=7.038968 hwHa=0.000361 chi2Ha=31.2755 sigHb=500 sigHa=300 sigHaB=NaN edge=0
FIT model=P2 comp=1C scen=D3 BW=12 n=32 nHb=19 nHa=13 k=11 dof=21 zJ=7.040639 hwJ=0.000478 lo=7.040167 hi=7.041123 hwJscaled=0.000594 chi2=32.3951 chi2red=1.5426 aic=54.3951 bic=70.5182 bic_k0=70.5182 zHb=7.038509 hwHb=0.002410 chi2Hb=14.3926 zHa=7.040720 hwHa=0.000491 chi2Ha=17.2138 sigHb=600 sigHa=400 sigHaB=NaN edge=0
FIT model=P2 comp=1C scen=D4 BW=12 n=31 nHb=19 nHa=12 k=11 dof=20 zJ=7.040740 hwJ=0.001034 lo=7.039739 hi=7.041807 hwJscaled=0.001316 chi2=32.3827 chi2red=1.6191 aic=54.3827 bic=70.1566 bic_k0=70.1566 zHb=7.038509 hwHb=0.002410 chi2Hb=14.3926 zHa=7.063099 hwHa=NaN chi2Ha=8.4350 sigHb=600 sigHa=400 sigHaB=NaN edge=0
FIT model=P2 comp=1C scen=ERRALL BW=12 n=29 nHb=19 nHa=10 k=11 dof=18 zJ=7.038262 hwJ=0.002529 lo=7.036040 hi=7.041098 hwJscaled=0.002529 chi2=17.0979 chi2red=0.9499 aic=39.0979 bic=54.1382 bic_k0=54.1382 zHb=7.038509 hwHb=0.002410 chi2Hb=14.3926 zHa=7.041486 hwHa=NaN chi2Ha=2.5949 sigHb=500 sigHa=900 sigHaB=NaN edge=0
FIT model=P2 comp=1C scen=ERREDGE BW=12 n=29 nHb=19 nHa=10 k=11 dof=18 zJ=7.038262 hwJ=0.002529 lo=7.036040 hi=7.041098 hwJscaled=0.002529 chi2=17.0979 chi2red=0.9499 aic=39.0979 bic=54.1382 bic_k0=54.1382 zHb=7.038509 hwHb=0.002410 chi2Hb=14.3926 zHa=7.041486 hwHa=NaN chi2Ha=2.5949 sigHb=500 sigHa=900 sigHaB=NaN edge=0
FIT model=P2 comp=2C scen=D0 BW=6 n=29 nHb=19 nHa=10 k=13 dof=16 zJ=7.042100 hwJ=0.000405 lo=7.041700 hi=7.042510 hwJscaled=0.000700 chi2=47.8004 chi2red=2.9875 aic=73.8004 bic=91.5753 bic_k0=91.5753 zHb=7.038509 hwHb=0.002410 chi2Hb=14.3926 zHa=7.042198 hwHa=0.000414 chi2Ha=31.2545 sigHb=600 sigHa=0 sigHaB=900 edge=0
FIT model=P2 comp=2C scen=D0 BW=8 n=31 nHb=19 nHa=12 k=13 dof=18 zJ=7.042137 hwJ=0.000403 lo=7.041739 hi=7.042544 hwJscaled=0.000683 chi2=51.7589 chi2red=2.8755 aic=77.7589 bic=96.4007 bic_k0=96.4007 zHb=7.038509 hwHb=0.002410 chi2Hb=14.3926 zHa=7.042234 hwHa=0.000411 chi2Ha=35.1706 sigHb=600 sigHa=200 sigHaB=900 edge=0
FIT model=P2 comp=2C scen=D0 BW=12 n=35 nHb=19 nHa=16 k=13 dof=22 zJ=7.042245 hwJ=0.000398 lo=7.041851 hi=7.042648 hwJscaled=0.000624 chi2=54.0322 chi2red=2.4560 aic=80.0322 bic=100.2518 bic_k0=100.2518 zHb=7.038509 hwHb=0.002410 chi2Hb=14.3926 zHa=7.042342 hwHa=0.000407 chi2Ha=37.3153 sigHb=600 sigHa=200 sigHaB=900 edge=0
FIT model=P2 comp=2C scen=D1 BW=12 n=34 nHb=19 nHa=15 k=13 dof=21 zJ=7.040500 hwJ=0.000486 lo=7.039975 hi=7.040948 hwJscaled=0.000534 chi2=25.3080 chi2red=1.2051 aic=51.3080 bic=71.1507 bic_k0=71.1507 zHb=7.038509 hwHb=0.002410 chi2Hb=14.3926 zHa=7.040564 hwHa=0.000490 chi2Ha=10.2251 sigHb=600 sigHa=100 sigHaB=900 edge=0
FIT model=P2 comp=2C scen=D2 BW=12 n=33 nHb=19 nHa=14 k=13 dof=20 zJ=7.041625 hwJ=0.000835 lo=7.040908 hi=7.042578 hwJscaled=0.000849 chi2=20.6743 chi2red=1.0337 aic=46.6743 bic=66.1289 bic_k0=66.1289 zHb=7.038509 hwHb=0.002410 chi2Hb=14.3926 zHa=7.043013 hwHa=0.001688 chi2Ha=4.3898 sigHb=600 sigHa=200 sigHaB=900 edge=0
FIT model=P2 comp=2C scen=D3 BW=12 n=32 nHb=19 nHa=13 k=13 dof=19 zJ=7.041906 hwJ=0.001013 lo=7.040954 hi=7.042980 hwJscaled=0.001043 chi2=20.1582 chi2red=1.0610 aic=46.1582 bic=65.2128 bic_k0=65.2128 zHb=7.038509 hwHb=0.002410 chi2Hb=14.3926 zHa=7.043461 hwHa=0.001329 chi2Ha=3.3533 sigHb=600 sigHa=200 sigHaB=1000 edge=0
FIT model=P2 comp=2C scen=D4 BW=12 n=31 nHb=19 nHa=12 k=13 dof=18 zJ=7.038786 hwJ=0.001612 lo=7.037598 hi=7.040821 hwJscaled=0.001612 chi2=17.2621 chi2red=0.9590 aic=43.2621 bic=61.9039 bic_k0=61.9039 zHb=7.038509 hwHb=0.002410 chi2Hb=14.3926 zHa=7.038872 hwHa=0.003675 chi2Ha=2.8517 sigHb=500 sigHa=0 sigHaB=1000 edge=0
FIT model=P2 comp=2C scen=ERRALL BW=12 n=29 nHb=19 nHa=10 k=13 dof=16 zJ=7.038520 hwJ=0.002408 lo=7.036151 hi=7.040967 hwJscaled=0.002481 chi2=16.9848 chi2red=1.0615 aic=42.9848 bic=60.7596 bic_k0=60.7596 zHb=7.038509 hwHb=0.002410 chi2Hb=14.3926 zHa=7.032497 hwHa=NaN chi2Ha=2.5582 sigHb=500 sigHa=400 sigHaB=1000 edge=0
FIT model=P2 comp=2C scen=ERREDGE BW=12 n=29 nHb=19 nHa=10 k=13 dof=16 zJ=7.038520 hwJ=0.002408 lo=7.036151 hi=7.040967 hwJscaled=0.002481 chi2=16.9848 chi2red=1.0615 aic=42.9848 bic=60.7596 bic_k0=60.7596 zHb=7.038509 hwHb=0.002410 chi2Hb=14.3926 zHa=7.032497 hwHa=NaN chi2Ha=2.5582 sigHb=500 sigHa=400 sigHaB=1000 edge=0
FIT model=P3 comp=1C scen=D0 BW=6 n=29 nHb=19 nHa=10 k=13 dof=16 zJ=7.039741 hwJ=0.000468 lo=7.039269 hi=7.040206 hwJscaled=0.000535 chi2=20.8721 chi2red=1.3045 aic=46.8721 bic=64.6469 bic_k0=64.6469 zHb=7.038342 hwHb=0.002442 chi2Hb=14.1177 zHa=7.039794 hwHa=0.000476 chi2Ha=6.4125 sigHb=500 sigHa=0 sigHaB=NaN edge=0
FIT model=P3 comp=1C scen=D0 BW=8 n=31 nHb=19 nHa=12 k=13 dof=18 zJ=7.040776 hwJ=0.000397 lo=7.040379 hi=7.041173 hwJscaled=0.000570 chi2=37.0459 chi2red=2.0581 aic=63.0459 bic=81.6877 bic_k0=81.6877 zHb=7.038342 hwHb=0.002442 chi2Hb=14.1177 zHa=7.040842 hwHa=0.000403 chi2Ha=21.9073 sigHb=500 sigHa=200 sigHaB=NaN edge=0
FIT model=P3 comp=1C scen=D0 BW=12 n=35 nHb=19 nHa=16 k=13 dof=22 zJ=7.041922 hwJ=0.000371 lo=7.041554 hi=7.042295 hwJscaled=0.000657 chi2=69.1668 chi2red=3.1439 aic=95.1668 bic=115.3863 bic_k0=115.3863 zHb=7.038342 hwHb=0.002442 chi2Hb=14.1177 zHa=7.042005 hwHa=0.000375 chi2Ha=52.8597 sigHb=500 sigHa=500 sigHaB=NaN edge=0
FIT model=P3 comp=1C scen=D1 BW=12 n=34 nHb=19 nHa=15 k=13 dof=21 zJ=7.040057 hwJ=0.000615 lo=7.039241 hi=7.040470 hwJscaled=0.000895 chi2=44.5618 chi2red=2.1220 aic=70.5618 bic=90.4045 bic_k0=90.4045 zHb=7.038342 hwHb=0.002442 chi2Hb=14.1177 zHa=7.040107 hwHa=0.000594 chi2Ha=29.9347 sigHb=500 sigHa=400 sigHaB=NaN edge=0
FIT model=P3 comp=1C scen=D2 BW=12 n=33 nHb=19 nHa=14 k=13 dof=20 zJ=7.040635 hwJ=0.000535 lo=7.040097 hi=7.041166 hwJscaled=0.000774 chi2=41.9419 chi2red=2.0971 aic=67.9419 bic=87.3965 bic_k0=87.3965 zHb=7.038342 hwHb=0.002442 chi2Hb=14.1177 zHa=7.042709 hwHa=0.000590 chi2Ha=26.6274 sigHb=500 sigHa=400 sigHaB=NaN edge=0
FIT model=P3 comp=1C scen=D3 BW=12 n=32 nHb=19 nHa=13 k=13 dof=19 zJ=7.035841 hwJ=0.000836 lo=7.035064 hi=7.036736 hwJscaled=0.000891 chi2=21.5983 chi2red=1.1368 aic=47.5983 bic=66.6529 bic_k0=66.6529 zHb=7.038342 hwHb=0.002442 chi2Hb=14.1177 zHa=7.035574 hwHa=0.000857 chi2Ha=6.3232 sigHb=500 sigHa=0 sigHaB=NaN edge=0
FIT model=P3 comp=1C scen=D4 BW=12 n=31 nHb=19 nHa=12 k=13 dof=18 zJ=7.037793 hwJ=0.002028 lo=7.036151 hi=7.040207 hwJscaled=0.002043 chi2=18.2647 chi2red=1.0147 aic=44.2647 bic=62.9065 bic_k0=62.9065 zHb=7.038342 hwHb=0.002442 chi2Hb=14.1177 zHa=7.037022 hwHa=0.005340 chi2Ha=4.0215 sigHb=500 sigHa=100 sigHaB=NaN edge=0
FIT model=P3 comp=1C scen=ERRALL BW=12 n=29 nHb=19 nHa=10 k=13 dof=16 zJ=7.038103 hwJ=0.002586 lo=7.035799 hi=7.040971 hwJscaled=0.002651 chi2=16.8082 chi2red=1.0505 aic=42.8082 bic=60.5831 bic_k0=60.5831 zHb=7.038342 hwHb=0.002442 chi2Hb=14.1177 zHa=7.062351 hwHa=NaN chi2Ha=2.3601 sigHb=500 sigHa=900 sigHaB=NaN edge=0
FIT model=P3 comp=1C scen=ERREDGE BW=12 n=29 nHb=19 nHa=10 k=13 dof=16 zJ=7.038103 hwJ=0.002586 lo=7.035799 hi=7.040971 hwJscaled=0.002651 chi2=16.8082 chi2red=1.0505 aic=42.8082 bic=60.5831 bic_k0=60.5831 zHb=7.038342 hwHb=0.002442 chi2Hb=14.1177 zHa=7.062351 hwHa=NaN chi2Ha=2.3601 sigHb=500 sigHa=900 sigHaB=NaN edge=0
FIT model=P3 comp=2C scen=D0 BW=6 n=29 nHb=19 nHa=10 k=15 dof=14 zJ=7.039741 hwJ=0.000468 lo=7.039269 hi=7.040206 hwJscaled=0.000572 chi2=20.8721 chi2red=1.4909 aic=50.8721 bic=71.3815 bic_k0=71.3815 zHb=7.038342 hwHb=0.002442 chi2Hb=14.1177 zHa=7.039794 hwHa=0.000476 chi2Ha=6.4125 sigHb=500 sigHa=0 sigHaB=900 edge=0
FIT model=P3 comp=2C scen=D0 BW=8 n=31 nHb=19 nHa=12 k=15 dof=16 zJ=7.040776 hwJ=0.000397 lo=7.040379 hi=7.041173 hwJscaled=0.000604 chi2=37.0459 chi2red=2.3154 aic=67.0459 bic=88.5557 bic_k0=88.5557 zHb=7.038342 hwHb=0.002442 chi2Hb=14.1177 zHa=7.040842 hwHa=0.000403 chi2Ha=21.9073 sigHb=500 sigHa=200 sigHaB=900 edge=0
FIT model=P3 comp=2C scen=D0 BW=12 n=35 nHb=19 nHa=16 k=15 dof=20 zJ=7.042213 hwJ=0.000400 lo=7.041815 hi=7.042614 hwJscaled=0.000650 chi2=52.8711 chi2red=2.6436 aic=82.8711 bic=106.2014 bic_k0=106.2014 zHb=7.038342 hwHb=0.002442 chi2Hb=14.1177 zHa=7.042309 hwHa=0.000405 chi2Ha=36.1998 sigHb=600 sigHa=200 sigHaB=900 edge=0
FIT model=P3 comp=2C scen=D1 BW=12 n=34 nHb=19 nHa=15 k=15 dof=19 zJ=7.040401 hwJ=0.000431 lo=7.039976 hi=7.040838 hwJscaled=0.000434 chi2=19.2971 chi2red=1.0156 aic=49.2971 bic=72.1925 bic_k0=72.1925 zHb=7.038342 hwHb=0.002442 chi2Hb=14.1177 zHa=7.040467 hwHa=0.000441 chi2Ha=4.4442 sigHb=500 sigHa=100 sigHaB=1000 edge=0
FIT model=P3 comp=2C scen=D2 BW=12 n=33 nHb=19 nHa=14 k=15 dof=18 zJ=7.040977 hwJ=0.000942 lo=7.039990 hi=7.041875 hwJscaled=0.000966 chi2=18.9059 chi2red=1.0503 aic=48.9059 bic=71.3535 bic_k0=71.3535 zHb=7.038342 hwHb=0.002442 chi2Hb=14.1177 zHa=7.041271 hwHa=0.001571 chi2Ha=3.4958 sigHb=500 sigHa=200 sigHaB=1100 edge=0
FIT model=P3 comp=2C scen=D3 BW=12 n=32 nHb=19 nHa=13 k=15 dof=17 zJ=7.038299 hwJ=0.002040 lo=7.036745 hi=7.040825 hwJscaled=0.002072 chi2=17.5491 chi2red=1.0323 aic=47.5491 bic=69.5351 bic_k0=69.5351 zHb=7.038342 hwHb=0.002442 chi2Hb=14.1177 zHa=7.057886 hwHa=0.002755 chi2Ha=2.9773 sigHb=500 sigHa=0 sigHaB=1000 edge=0
FIT model=P3 comp=2C scen=D4 BW=12 n=31 nHb=19 nHa=12 k=15 dof=16 zJ=7.039446 hwJ=0.001781 lo=7.037398 hi=7.040959 hwJscaled=0.001826 chi2=16.8256 chi2red=1.0516 aic=46.8256 bic=68.3354 bic_k0=68.3354 zHb=7.038342 hwHb=0.002442 chi2Hb=14.1177 zHa=7.052531 hwHa=0.001750 chi2Ha=2.1365 sigHb=500 sigHa=100 sigHaB=1100 edge=0
FIT model=P3 comp=2C scen=ERRALL BW=12 n=29 nHb=19 nHa=10 k=15 dof=14 zJ=7.038294 hwJ=0.002504 lo=7.035904 hi=7.040913 hwJscaled=0.002689 chi2=16.1416 chi2red=1.1530 aic=46.1416 bic=66.6511 bic_k0=66.6511 zHb=7.038342 hwHb=0.002442 chi2Hb=14.1177 zHa=7.020273 hwHa=NaN chi2Ha=1.5258 sigHb=500 sigHa=500 sigHaB=1200 edge=0
FIT model=P3 comp=2C scen=ERREDGE BW=12 n=29 nHb=19 nHa=10 k=15 dof=14 zJ=7.038294 hwJ=0.002504 lo=7.035904 hi=7.040913 hwJscaled=0.002689 chi2=16.1416 chi2red=1.1530 aic=46.1416 bic=66.6511 bic_k0=66.6511 zHb=7.038342 hwHb=0.002442 chi2Hb=14.1177 zHa=7.020273 hwHa=NaN chi2Ha=1.5258 sigHb=500 sigHa=500 sigHaB=1200 edge=0
FIT model=PLLIN comp=1C scen=D0 BW=6 n=29 nHb=19 nHa=10 k=10 dof=19 zJ=7.041407 hwJ=0.000313 lo=7.041093 hi=7.041719 hwJscaled=0.000625 chi2=75.5922 chi2red=3.9785 aic=95.5922 bic=109.2652 bic_k0=109.2652 zHb=7.037941 hwHb=0.002315 chi2Hb=16.5204 zHa=7.041464 hwHa=0.000315 chi2Ha=56.8734 sigHb=700 sigHa=500 sigHaB=NaN edge=0
FIT model=PLLIN comp=1C scen=D0 BW=8 n=31 nHb=19 nHa=12 k=10 dof=21 zJ=7.040832 hwJ=0.000293 lo=7.040537 hi=7.041122 hwJscaled=0.000638 chi2=99.9128 chi2red=4.7578 aic=119.9128 bic=134.2526 bic_k0=134.2526 zHb=7.037941 hwHb=0.002315 chi2Hb=16.5204 zHa=7.040873 hwHa=0.000292 chi2Ha=81.8170 sigHb=700 sigHa=500 sigHaB=NaN edge=0
FIT model=PLLIN comp=1C scen=D0 BW=12 n=35 nHb=19 nHa=16 k=10 dof=25 zJ=7.040487 hwJ=0.000276 lo=7.040211 hi=7.040763 hwJscaled=0.000588 chi2=113.3060 chi2red=4.5322 aic=133.3060 bic=148.8595 bic_k0=148.8595 zHb=7.037941 hwHb=0.002315 chi2Hb=16.5204 zHa=7.040524 hwHa=0.000278 chi2Ha=95.5594 sigHb=600 sigHa=500 sigHaB=NaN edge=0
FIT model=PLLIN comp=1C scen=D1 BW=12 n=34 nHb=19 nHa=15 k=10 dof=24 zJ=7.040199 hwJ=0.000286 lo=7.039912 hi=7.040485 hwJscaled=0.000430 chi2=54.1827 chi2red=2.2576 aic=74.1827 bic=89.4463 bic_k0=89.4463 zHb=7.037941 hwHb=0.002315 chi2Hb=16.5204 zHa=7.040215 hwHa=0.000289 chi2Ha=36.2699 sigHb=600 sigHa=400 sigHaB=NaN edge=0
FIT model=PLLIN comp=1C scen=D2 BW=12 n=33 nHb=19 nHa=14 k=10 dof=23 zJ=7.040026 hwJ=0.000295 lo=7.039731 hi=7.040321 hwJscaled=0.000438 chi2=50.6200 chi2red=2.2009 aic=70.6200 bic=85.5851 bic_k0=85.5851 zHb=7.037941 hwHb=0.002315 chi2Hb=16.5204 zHa=7.040050 hwHa=0.000298 chi2Ha=33.1314 sigHb=600 sigHa=400 sigHaB=NaN edge=0
FIT model=PLLIN comp=1C scen=D3 BW=12 n=32 nHb=19 nHa=13 k=10 dof=22 zJ=7.042017 hwJ=0.000481 lo=7.041541 hi=7.042503 hwJscaled=0.000647 chi2=39.8033 chi2red=1.8092 aic=59.8033 bic=74.4607 bic_k0=74.4607 zHb=7.037941 hwHb=0.002315 chi2Hb=16.5204 zHa=7.042188 hwHa=0.000497 chi2Ha=20.1123 sigHb=700 sigHa=500 sigHaB=NaN edge=0
FIT model=PLLIN comp=1C scen=D4 BW=12 n=31 nHb=19 nHa=12 k=10 dof=21 zJ=7.041990 hwJ=0.000892 lo=7.041113 hi=7.042898 hwJscaled=0.001228 chi2=39.8020 chi2red=1.8953 aic=59.8020 bic=74.1419 bic_k0=74.1419 zHb=7.037941 hwHb=0.002315 chi2Hb=16.5204 zHa=7.063457 hwHa=NaN chi2Ha=8.4615 sigHb=700 sigHa=500 sigHaB=NaN edge=0
FIT model=PLLIN comp=1C scen=ERRALL BW=12 n=29 nHb=19 nHa=10 k=10 dof=19 zJ=7.037449 hwJ=0.002543 lo=7.035272 hi=7.040359 hwJscaled=0.002764 chi2=22.4324 chi2red=1.1807 aic=42.4324 bic=56.1053 bic_k0=56.1053 zHb=7.037941 hwHb=0.002315 chi2Hb=16.5204 zHa=7.023212 hwHa=NaN chi2Ha=5.1556 sigHb=600 sigHa=700 sigHaB=NaN edge=0
FIT model=PLLIN comp=1C scen=ERREDGE BW=12 n=29 nHb=19 nHa=10 k=10 dof=19 zJ=7.037449 hwJ=0.002543 lo=7.035272 hi=7.040359 hwJscaled=0.002764 chi2=22.4324 chi2red=1.1807 aic=42.4324 bic=56.1053 bic_k0=56.1053 zHb=7.037941 hwHb=0.002315 chi2Hb=16.5204 zHa=7.023212 hwHa=NaN chi2Ha=5.1556 sigHb=600 sigHa=700 sigHaB=NaN edge=0
FIT model=PLLIN comp=2C scen=D0 BW=6 n=29 nHb=19 nHa=10 k=12 dof=17 zJ=7.042147 hwJ=0.000398 lo=7.041756 hi=7.042551 hwJscaled=0.000696 chi2=52.1536 chi2red=3.0679 aic=76.1536 bic=92.5611 bic_k0=92.5611 zHb=7.037941 hwHb=0.002315 chi2Hb=16.5204 zHa=7.042261 hwHa=0.000415 chi2Ha=32.4362 sigHb=700 sigHa=200 sigHaB=900 edge=0
FIT model=PLLIN comp=2C scen=D0 BW=8 n=31 nHb=19 nHa=12 k=12 dof=19 zJ=7.042140 hwJ=0.000451 lo=7.041637 hi=7.042539 hwJscaled=0.000770 chi2=55.5629 chi2red=2.9244 aic=79.5629 bic=96.7708 bic_k0=96.7708 zHb=7.037941 hwHb=0.002315 chi2Hb=16.5204 zHa=7.042242 hwHa=0.000452 chi2Ha=35.8641 sigHb=700 sigHa=200 sigHaB=1000 edge=0
FIT model=PLLIN comp=2C scen=D0 BW=12 n=35 nHb=19 nHa=16 k=12 dof=23 zJ=7.042072 hwJ=0.000394 lo=7.041673 hi=7.042460 hwJscaled=0.000697 chi2=72.0043 chi2red=3.1306 aic=96.0043 bic=114.6684 bic_k0=114.6684 zHb=7.037941 hwHb=0.002315 chi2Hb=16.5204 zHa=7.042179 hwHa=0.000395 chi2Ha=52.3415 sigHb=700 sigHa=500 sigHaB=2400 edge=0
FIT model=PLLIN comp=2C scen=D1 BW=12 n=34 nHb=19 nHa=15 k=12 dof=22 zJ=7.040835 hwJ=0.000345 lo=7.040525 hi=7.041214 hwJscaled=0.000400 chi2=29.6748 chi2red=1.3489 aic=53.6748 bic=71.9912 bic_k0=71.9912 zHb=7.037941 hwHb=0.002315 chi2Hb=16.5204 zHa=7.040946 hwHa=0.000346 chi2Ha=11.4440 sigHb=700 sigHa=200 sigHaB=900 edge=0
FIT model=PLLIN comp=2C scen=D2 BW=12 n=33 nHb=19 nHa=14 k=12 dof=21 zJ=7.040616 hwJ=0.000318 lo=7.040304 hi=7.040940 hwJscaled=0.000352 chi2=25.7707 chi2red=1.2272 aic=49.7707 bic=67.7288 bic_k0=67.7288 zHb=7.037941 hwHb=0.002315 chi2Hb=16.5204 zHa=7.040665 hwHa=0.000332 chi2Ha=7.8924 sigHb=600 sigHa=200 sigHaB=900 edge=0
FIT model=PLLIN comp=2C scen=D3 BW=12 n=32 nHb=19 nHa=13 k=12 dof=20 zJ=7.040920 hwJ=0.000544 lo=7.040389 hi=7.041477 hwJscaled=0.000611 chi2=25.2773 chi2red=1.2639 aic=49.2773 bic=66.8661 bic_k0=66.8661 zHb=7.037941 hwHb=0.002315 chi2Hb=16.5204 zHa=7.041075 hwHa=0.000750 chi2Ha=7.0397 sigHb=700 sigHa=200 sigHaB=900 edge=0
FIT model=PLLIN comp=2C scen=D4 BW=12 n=31 nHb=19 nHa=12 k=12 dof=19 zJ=7.038632 hwJ=0.001703 lo=7.037175 hi=7.040580 hwJscaled=0.001905 chi2=23.7913 chi2red=1.2522 aic=47.7913 bic=64.9991 bic_k0=64.9991 zHb=7.037941 hwHb=0.002315 chi2Hb=16.5204 zHa=7.040572 hwHa=0.013123 chi2Ha=6.9723 sigHb=600 sigHa=100 sigHaB=900 edge=0
FIT model=PLLIN comp=2C scen=ERRALL BW=12 n=29 nHb=19 nHa=10 k=12 dof=17 zJ=7.037845 hwJ=0.002357 lo=7.035486 hi=7.040200 hwJscaled=0.002726 chi2=22.7386 chi2red=1.3376 aic=46.7386 bic=63.1461 bic_k0=63.1461 zHb=7.037941 hwHb=0.002315 chi2Hb=16.5204 zHa=7.023212 hwHa=NaN chi2Ha=5.1556 sigHb=600 sigHa=600 sigHaB=900 edge=0
FIT model=PLLIN comp=2C scen=ERREDGE BW=12 n=29 nHb=19 nHa=10 k=12 dof=17 zJ=7.037845 hwJ=0.002357 lo=7.035486 hi=7.040200 hwJscaled=0.002726 chi2=22.7386 chi2red=1.3376 aic=46.7386 bic=63.1461 bic_k0=63.1461 zHb=7.037941 hwHb=0.002315 chi2Hb=16.5204 zHa=7.023212 hwHa=NaN chi2Ha=5.1556 sigHb=600 sigHa=600 sigHaB=900 edge=0
FIT model=PL comp=1C scen=D0 BW=6 n=29 nHb=19 nHa=10 k=9 dof=20 zJ=7.040612 hwJ=0.000273 lo=7.040341 hi=7.040887 hwJscaled=0.000602 chi2=97.1888 chi2red=4.8594 aic=115.1888 bic=127.4944 bic_k0=127.4944 zHb=7.037958 hwHb=0.002314 chi2Hb=16.5503 zHa=7.040650 hwHa=0.000274 chi2Ha=79.2950 sigHb=600 sigHa=500 sigHaB=NaN edge=0
FIT model=PL comp=1C scen=D0 BW=8 n=31 nHb=19 nHa=12 k=9 dof=22 zJ=7.040569 hwJ=0.000270 lo=7.040300 hi=7.040840 hwJscaled=0.000590 chi2=104.8098 chi2red=4.7641 aic=122.8098 bic=135.7157 bic_k0=135.7157 zHb=7.037958 hwHb=0.002314 chi2Hb=16.5503 zHa=7.040605 hwHa=0.000271 chi2Ha=86.9596 sigHb=600 sigHa=500 sigHaB=NaN edge=0
FIT model=PL comp=1C scen=D0 BW=12 n=35 nHb=19 nHa=16 k=9 dof=26 zJ=7.040475 hwJ=0.000274 lo=7.040200 hi=7.040749 hwJscaled=0.000573 chi2=113.4765 chi2red=4.3645 aic=131.4765 bic=145.4747 bic_k0=145.4747 zHb=7.037958 hwHb=0.002314 chi2Hb=16.5503 zHa=7.040511 hwHa=0.000276 chi2Ha=95.7167 sigHb=600 sigHa=500 sigHaB=NaN edge=0
FIT model=PL comp=1C scen=D1 BW=12 n=34 nHb=19 nHa=15 k=9 dof=25 zJ=7.040648 hwJ=0.000284 lo=7.040366 hi=7.040933 hwJscaled=0.000459 chi2=65.4374 chi2red=2.6175 aic=83.4374 bic=97.1747 bic_k0=97.1747 zHb=7.037958 hwHb=0.002314 chi2Hb=16.5503 zHa=7.040688 hwHa=0.000284 chi2Ha=47.5069 sigHb=600 sigHa=500 sigHaB=NaN edge=0
FIT model=PL comp=1C scen=D2 BW=12 n=33 nHb=19 nHa=14 k=9 dof=24 zJ=7.040455 hwJ=0.000310 lo=7.040145 hi=7.040766 hwJscaled=0.000504 chi2=63.3313 chi2red=2.6388 aic=81.3313 bic=94.7999 bic_k0=94.7999 zHb=7.037958 hwHb=0.002314 chi2Hb=16.5503 zHa=7.040500 hwHa=0.000313 chi2Ha=45.5862 sigHb=600 sigHa=500 sigHaB=NaN edge=0
FIT model=PL comp=1C scen=D3 BW=12 n=32 nHb=19 nHa=13 k=9 dof=23 zJ=7.043688 hwJ=0.000503 lo=7.043189 hi=7.044195 hwJscaled=0.000705 chi2=45.1269 chi2red=1.9620 aic=63.1269 bic=76.3185 bic_k0=76.3185 zHb=7.037958 hwHb=0.002314 chi2Hb=16.5503 zHa=7.043945 hwHa=0.000519 chi2Ha=22.6571 sigHb=700 sigHa=600 sigHaB=NaN edge=0
FIT model=PL comp=1C scen=D4 BW=12 n=31 nHb=19 nHa=12 k=9 dof=22 zJ=7.044288 hwJ=0.000876 lo=7.043421 hi=7.045173 hwJscaled=0.001244 chi2=44.4070 chi2red=2.0185 aic=62.4070 bic=75.3129 bic_k0=75.3129 zHb=7.037958 hwHb=0.002314 chi2Hb=16.5503 zHa=7.062745 hwHa=0.001662 chi2Ha=8.8025 sigHb=700 sigHa=600 sigHaB=NaN edge=0
FIT model=PL comp=1C scen=ERRALL BW=12 n=29 nHb=19 nHa=10 k=9 dof=20 zJ=7.037375 hwJ=0.002572 lo=7.035255 hi=7.040398 hwJscaled=0.002727 chi2=22.4957 chi2red=1.1248 aic=40.4957 bic=52.8014 bic_k0=52.8014 zHb=7.037958 hwHb=0.002314 chi2Hb=16.5503 zHa=7.023177 hwHa=NaN chi2Ha=5.1738 sigHb=600 sigHa=700 sigHaB=NaN edge=0
FIT model=PL comp=1C scen=ERREDGE BW=12 n=29 nHb=19 nHa=10 k=9 dof=20 zJ=7.037375 hwJ=0.002572 lo=7.035255 hi=7.040398 hwJscaled=0.002727 chi2=22.4957 chi2red=1.1248 aic=40.4957 bic=52.8014 bic_k0=52.8014 zHb=7.037958 hwHb=0.002314 chi2Hb=16.5503 zHa=7.023177 hwHa=NaN chi2Ha=5.1738 sigHb=600 sigHa=700 sigHaB=NaN edge=0
FIT model=PL comp=2C scen=D0 BW=6 n=29 nHb=19 nHa=10 k=11 dof=18 zJ=7.041090 hwJ=0.000272 lo=7.040818 hi=7.041362 hwJscaled=0.000582 chi2=82.4279 chi2red=4.5793 aic=104.4279 bic=119.4682 bic_k0=119.4682 zHb=7.037958 hwHb=0.002314 chi2Hb=16.5503 zHa=7.041129 hwHa=0.000274 chi2Ha=64.0588 sigHb=700 sigHa=300 sigHaB=3000 edge=0
FIT model=PL comp=2C scen=D0 BW=8 n=31 nHb=19 nHa=12 k=11 dof=20 zJ=7.040574 hwJ=0.000270 lo=7.040305 hi=7.040845 hwJscaled=0.000584 chi2=93.6734 chi2red=4.6837 aic=115.6734 bic=131.4473 bic_k0=131.4473 zHb=7.037958 hwHb=0.002314 chi2Hb=16.5503 zHa=7.040610 hwHa=0.000271 chi2Ha=75.8184 sigHb=600 sigHa=300 sigHaB=900 edge=0
FIT model=PL comp=2C scen=D0 BW=12 n=35 nHb=19 nHa=16 k=11 dof=24 zJ=7.040568 hwJ=0.000269 lo=7.040300 hi=7.040838 hwJscaled=0.000543 chi2=97.5006 chi2red=4.0625 aic=119.5006 bic=136.6095 bic_k0=136.6095 zHb=7.037958 hwHb=0.002314 chi2Hb=16.5503 zHa=7.040603 hwHa=0.000270 chi2Ha=79.6516 sigHb=600 sigHa=300 sigHaB=900 edge=0
FIT model=PL comp=2C scen=D1 BW=12 n=34 nHb=19 nHa=15 k=11 dof=23 zJ=7.040820 hwJ=0.000349 lo=7.040510 hi=7.041208 hwJscaled=0.000396 chi2=29.6529 chi2red=1.2893 aic=51.6529 bic=68.4428 bic_k0=68.4428 zHb=7.037958 hwHb=0.002314 chi2Hb=16.5503 zHa=7.040962 hwHa=0.000354 chi2Ha=11.5251 sigHb=700 sigHa=200 sigHaB=900 edge=0
FIT model=PL comp=2C scen=D2 BW=12 n=33 nHb=19 nHa=14 k=11 dof=22 zJ=7.040616 hwJ=0.000315 lo=7.040304 hi=7.040934 hwJscaled=0.000341 chi2=25.7956 chi2red=1.1725 aic=47.7956 bic=64.2571 bic_k0=64.2571 zHb=7.037958 hwHb=0.002314 chi2Hb=16.5503 zHa=7.040665 hwHa=0.000326 chi2Ha=7.8927 sigHb=600 sigHa=200 sigHaB=900 edge=0
FIT model=PL comp=2C scen=D3 BW=12 n=32 nHb=19 nHa=13 k=11 dof=21 zJ=7.040919 hwJ=0.000542 lo=7.040392 hi=7.041476 hwJscaled=0.000594 chi2=25.2919 chi2red=1.2044 aic=47.2919 bic=63.4150 bic_k0=63.4150 zHb=7.037958 hwHb=0.002314 chi2Hb=16.5503 zHa=7.041074 hwHa=0.000750 chi2Ha=7.0408 sigHb=700 sigHa=200 sigHaB=900 edge=0
FIT model=PL comp=2C scen=D4 BW=12 n=31 nHb=19 nHa=12 k=11 dof=20 zJ=7.038628 hwJ=0.001706 lo=7.037175 hi=7.040587 hwJscaled=0.001862 chi2=23.8232 chi2red=1.1912 aic=45.8232 bic=61.5970 bic_k0=61.5970 zHb=7.037958 hwHb=0.002314 chi2Hb=16.5503 zHa=7.040570 hwHa=0.012855 chi2Ha=6.9728 sigHb=600 sigHa=100 sigHaB=900 edge=0
FIT model=PL comp=2C scen=ERRALL BW=12 n=29 nHb=19 nHa=10 k=11 dof=18 zJ=7.037838 hwJ=0.002356 lo=7.035493 hi=7.040206 hwJscaled=0.002650 chi2=22.7717 chi2red=1.2651 aic=44.7717 bic=59.8120 bic_k0=59.8120 zHb=7.037958 hwHb=0.002314 chi2Hb=16.5503 zHa=7.023162 hwHa=NaN chi2Ha=5.1705 sigHb=600 sigHa=600 sigHaB=900 edge=0
FIT model=PL comp=2C scen=ERREDGE BW=12 n=29 nHb=19 nHa=10 k=11 dof=18 zJ=7.037838 hwJ=0.002356 lo=7.035493 hi=7.040206 hwJscaled=0.002650 chi2=22.7717 chi2red=1.2651 aic=44.7717 bic=59.8120 bic_k0=59.8120 zHb=7.037958 hwHb=0.002314 chi2Hb=16.5503 zHa=7.023162 hwHa=NaN chi2Ha=5.1705 sigHb=600 sigHa=600 sigHaB=900 edge=0
FIT model=RM12 comp=1C scen=D0 BW=6 n=29 nHb=19 nHa=10 k=7 dof=22 zJ=7.040278 hwJ=0.000268 lo=7.040010 hi=7.040546 hwJscaled=0.000608 chi2=113.4811 chi2red=5.1582 aic=127.4811 bic=137.0522 bic_k0=130.3176 zHb=7.038287 hwHb=0.002328 chi2Hb=16.4054 zHa=7.040305 hwHa=0.000270 chi2Ha=96.3370 sigHb=600 sigHa=500 sigHaB=NaN edge=0
FIT model=RM12 comp=1C scen=D0 BW=8 n=31 nHb=19 nHa=12 k=7 dof=24 zJ=7.040278 hwJ=0.000268 lo=7.040010 hi=7.040546 hwJscaled=0.000588 chi2=115.6913 chi2red=4.8205 aic=129.6913 bic=139.7293 bic_k0=132.8613 zHb=7.038287 hwHb=0.002328 chi2Hb=16.4054 zHa=7.040305 hwHa=0.000270 chi2Ha=98.5471 sigHb=600 sigHa=500 sigHaB=NaN edge=0
FIT model=RM12 comp=1C scen=D0 BW=12 n=35 nHb=19 nHa=16 k=7 dof=28 zJ=7.040278 hwJ=0.000268 lo=7.040010 hi=7.040546 hwJscaled=0.000552 chi2=118.7887 chi2red=4.2425 aic=132.7887 bic=143.6762 bic_k0=136.5655 zHb=7.038287 hwHb=0.002328 chi2Hb=16.4054 zHa=7.040305 hwHa=0.000270 chi2Ha=101.6445 sigHb=600 sigHa=500 sigHaB=NaN edge=0
FIT model=RM12 comp=1C scen=D1 BW=12 n=34 nHb=19 nHa=15 k=7 dof=27 zJ=7.040678 hwJ=0.000277 lo=7.040402 hi=7.040955 hwJscaled=0.000448 chi2=70.7169 chi2red=2.6191 aic=84.7169 bic=95.4014 bic_k0=88.3487 zHb=7.038287 hwHb=0.002328 chi2Hb=16.4054 zHa=7.040712 hwHa=0.000279 chi2Ha=53.2465 sigHb=600 sigHa=500 sigHaB=NaN edge=0
FIT model=RM12 comp=1C scen=D2 BW=12 n=33 nHb=19 nHa=14 k=7 dof=26 zJ=7.040396 hwJ=0.000301 lo=7.040095 hi=7.040698 hwJscaled=0.000479 chi2=65.5985 chi2red=2.5230 aic=79.5985 bic=90.0740 bic_k0=83.0810 zHb=7.038287 hwHb=0.002328 chi2Hb=16.4054 zHa=7.040432 hwHa=0.000304 chi2Ha=48.3613 sigHb=600 sigHa=500 sigHaB=NaN edge=0
FIT model=RM12 comp=1C scen=D3 BW=12 n=32 nHb=19 nHa=13 k=7 dof=25 zJ=7.043488 hwJ=0.000477 lo=7.043014 hi=7.043968 hwJscaled=0.000650 chi2=46.3694 chi2red=1.8548 aic=60.3694 bic=70.6296 bic_k0=63.6981 zHb=7.038287 hwHb=0.002328 chi2Hb=16.4054 zHa=7.043691 hwHa=0.000489 chi2Ha=25.1846 sigHb=700 sigHa=600 sigHaB=NaN edge=0
FIT model=RM12 comp=1C scen=D4 BW=12 n=31 nHb=19 nHa=12 k=7 dof=24 zJ=7.043877 hwJ=0.000818 lo=7.043067 hi=7.044703 hwJscaled=0.001133 chi2=46.0209 chi2red=1.9175 aic=60.0209 bic=70.0588 bic_k0=63.1908 zHb=7.038287 hwHb=0.002328 chi2Hb=16.4054 zHa=7.062238 hwHa=0.001489 chi2Ha=10.1618 sigHb=700 sigHa=600 sigHaB=NaN edge=0
FIT model=RM12 comp=1C scen=ERRALL BW=12 n=29 nHb=19 nHa=10 k=7 dof=22 zJ=7.037568 hwJ=0.002442 lo=7.035508 hi=7.040392 hwJscaled=0.002524 chi2=23.5066 chi2red=1.0685 aic=37.5066 bic=47.0776 bic_k0=40.3430 zHb=7.038287 hwHb=0.002328 chi2Hb=16.4054 zHa=7.023119 hwHa=NaN chi2Ha=6.0246 sigHb=600 sigHa=700 sigHaB=NaN edge=0
FIT model=RM12 comp=1C scen=ERREDGE BW=12 n=29 nHb=19 nHa=10 k=7 dof=22 zJ=7.037568 hwJ=0.002442 lo=7.035508 hi=7.040392 hwJscaled=0.002524 chi2=23.5066 chi2red=1.0685 aic=37.5066 bic=47.0776 bic_k0=40.3430 zHb=7.038287 hwHb=0.002328 chi2Hb=16.4054 zHa=7.023119 hwHa=NaN chi2Ha=6.0246 sigHb=600 sigHa=700 sigHaB=NaN edge=0
FIT model=RM12 comp=2C scen=D0 BW=6 n=29 nHb=19 nHa=10 k=9 dof=20 zJ=7.040350 hwJ=0.000272 lo=7.040083 hi=7.040627 hwJscaled=0.000608 chi2=99.8784 chi2red=4.9939 aic=117.8784 bic=130.1841 bic_k0=123.4495 zHb=7.038287 hwHb=0.002328 chi2Hb=16.4054 zHa=7.040388 hwHa=0.000274 chi2Ha=82.6744 sigHb=600 sigHa=400 sigHaB=1100 edge=0
FIT model=RM12 comp=2C scen=D0 BW=8 n=31 nHb=19 nHa=12 k=9 dof=22 zJ=7.040340 hwJ=0.000267 lo=7.040073 hi=7.040606 hwJscaled=0.000578 chi2=103.4680 chi2red=4.7031 aic=121.4680 bic=134.3739 bic_k0=127.5060 zHb=7.038287 hwHb=0.002328 chi2Hb=16.4054 zHa=7.040367 hwHa=0.000268 chi2Ha=86.2778 sigHb=600 sigHa=400 sigHaB=1000 edge=0
FIT model=RM12 comp=2C scen=D0 BW=12 n=35 nHb=19 nHa=16 k=9 dof=26 zJ=7.040340 hwJ=0.000267 lo=7.040073 hi=7.040606 hwJscaled=0.000540 chi2=106.5211 chi2red=4.0970 aic=124.5211 bic=138.5192 bic_k0=131.4085 zHb=7.038287 hwHb=0.002328 chi2Hb=16.4054 zHa=7.040367 hwHa=0.000268 chi2Ha=89.3309 sigHb=600 sigHa=400 sigHaB=1000 edge=0
FIT model=RM12 comp=2C scen=D1 BW=12 n=34 nHb=19 nHa=15 k=9 dof=25 zJ=7.040876 hwJ=0.000283 lo=7.040594 hi=7.041160 hwJscaled=0.000320 chi2=32.0486 chi2red=1.2819 aic=50.0486 bic=63.7859 bic_k0=56.7332 zHb=7.038287 hwHb=0.002328 chi2Hb=16.4054 zHa=7.040915 hwHa=0.000285 chi2Ha=14.3948 sigHb=600 sigHa=200 sigHaB=900 edge=0
FIT model=RM12 comp=2C scen=D2 BW=12 n=33 nHb=19 nHa=14 k=9 dof=24 zJ=7.040602 hwJ=0.000303 lo=7.040300 hi=7.040907 hwJscaled=0.000326 chi2=27.7216 chi2red=1.1551 aic=45.7216 bic=59.1902 bic_k0=52.1972 zHb=7.038287 hwHb=0.002328 chi2Hb=16.4054 zHa=7.040641 hwHa=0.000307 chi2Ha=10.3152 sigHb=600 sigHa=200 sigHaB=900 edge=0
FIT model=RM12 comp=2C scen=D3 BW=12 n=32 nHb=19 nHa=13 k=9 dof=23 zJ=7.041334 hwJ=0.000796 lo=7.040329 hi=7.041920 hwJscaled=0.000868 chi2=27.3723 chi2red=1.1901 aic=45.3723 bic=58.5640 bic_k0=51.6325 zHb=7.038287 hwHb=0.002328 chi2Hb=16.4054 zHa=7.041509 hwHa=0.000758 chi2Ha=9.1965 sigHb=700 sigHa=300 sigHaB=900 edge=0
FIT model=RM12 comp=2C scen=D4 BW=12 n=31 nHb=19 nHa=12 k=9 dof=22 zJ=7.039400 hwJ=0.001613 lo=7.037497 hi=7.040722 hwJscaled=0.001761 chi2=26.2239 chi2red=1.1920 aic=44.2239 bic=57.1298 bic_k0=50.2618 zHb=7.038287 hwHb=0.002328 chi2Hb=16.4054 zHa=7.046842 hwHa=NaN chi2Ha=8.7234 sigHb=600 sigHa=200 sigHaB=900 edge=0
FIT model=RM12 comp=2C scen=ERRALL BW=12 n=29 nHb=19 nHa=10 k=9 dof=20 zJ=7.038086 hwJ=0.002384 lo=7.035705 hi=7.040473 hwJscaled=0.002613 chi2=24.0170 chi2red=1.2009 aic=42.0170 bic=54.3227 bic_k0=47.5881 zHb=7.038287 hwHb=0.002328 chi2Hb=16.4054 zHa=7.023119 hwHa=NaN chi2Ha=6.0246 sigHb=600 sigHa=600 sigHaB=900 edge=0
FIT model=RM12 comp=2C scen=ERREDGE BW=12 n=29 nHb=19 nHa=10 k=9 dof=20 zJ=7.038086 hwJ=0.002384 lo=7.035705 hi=7.040473 hwJscaled=0.002613 chi2=24.0170 chi2red=1.2009 aic=42.0170 bic=54.3227 bic_k0=47.5881 zHb=7.038287 hwHb=0.002328 chi2Hb=16.4054 zHa=7.023119 hwHa=NaN chi2Ha=6.0246 sigHb=600 sigHa=600 sigHaB=900 edge=0
FIT model=RM20 comp=1C scen=D0 BW=6 n=29 nHb=19 nHa=10 k=7 dof=22 zJ=7.040448 hwJ=0.000269 lo=7.040179 hi=7.040716 hwJscaled=0.000605 chi2=111.2371 chi2red=5.0562 aic=125.2371 bic=134.8082 bic_k0=128.0736 zHb=7.037888 hwHb=0.002298 chi2Hb=18.1779 zHa=7.040483 hwHa=0.000271 chi2Ha=91.8065 sigHb=700 sigHa=500 sigHaB=NaN edge=0
FIT model=RM20 comp=1C scen=D0 BW=8 n=31 nHb=19 nHa=12 k=7 dof=24 zJ=7.040448 hwJ=0.000269 lo=7.040179 hi=7.040717 hwJscaled=0.000586 chi2=113.7281 chi2red=4.7387 aic=127.7281 bic=137.7660 bic_k0=130.8980 zHb=7.037888 hwHb=0.002298 chi2Hb=18.1779 zHa=7.040483 hwHa=0.000271 chi2Ha=94.2973 sigHb=700 sigHa=500 sigHaB=NaN edge=0
FIT model=RM20 comp=1C scen=D0 BW=12 n=35 nHb=19 nHa=16 k=7 dof=28 zJ=7.040448 hwJ=0.000269 lo=7.040179 hi=7.040717 hwJscaled=0.000548 chi2=116.4402 chi2red=4.1586 aic=130.4402 bic=141.3276 bic_k0=134.2169 zHb=7.037888 hwHb=0.002298 chi2Hb=18.1779 zHa=7.040483 hwHa=0.000271 chi2Ha=97.0094 sigHb=700 sigHa=500 sigHaB=NaN edge=0
FIT model=RM20 comp=1C scen=D1 BW=12 n=34 nHb=19 nHa=15 k=7 dof=27 zJ=7.040706 hwJ=0.000276 lo=7.040430 hi=7.040982 hwJscaled=0.000467 chi2=77.3982 chi2red=2.8666 aic=91.3982 bic=102.0828 bic_k0=95.0301 zHb=7.037888 hwHb=0.002298 chi2Hb=18.1779 zHa=7.040747 hwHa=0.000278 chi2Ha=57.7023 sigHb=700 sigHa=500 sigHaB=NaN edge=0
FIT model=RM20 comp=1C scen=D2 BW=12 n=33 nHb=19 nHa=14 k=7 dof=26 zJ=7.040392 hwJ=0.000300 lo=7.040093 hi=7.040692 hwJscaled=0.000496 chi2=71.0392 chi2red=2.7323 aic=85.0392 bic=95.5148 bic_k0=88.5218 zHb=7.037888 hwHb=0.002298 chi2Hb=18.1779 zHa=7.040435 hwHa=0.000303 chi2Ha=51.6581 sigHb=700 sigHa=500 sigHaB=NaN edge=0
FIT model=RM20 comp=1C scen=D3 BW=12 n=32 nHb=19 nHa=13 k=7 dof=25 zJ=7.043370 hwJ=0.000477 lo=7.042899 hi=7.043854 hwJscaled=0.000686 chi2=51.6394 chi2red=2.0656 aic=65.6394 bic=75.8995 bic_k0=68.9680 zHb=7.037888 hwHb=0.002298 chi2Hb=18.1779 zHa=7.043606 hwHa=0.000486 chi2Ha=27.6288 sigHb=700 sigHa=600 sigHaB=NaN edge=0
FIT model=RM20 comp=1C scen=D4 BW=12 n=31 nHb=19 nHa=12 k=7 dof=24 zJ=7.043560 hwJ=0.000834 lo=7.042761 hi=7.044428 hwJscaled=0.001222 chi2=51.5540 chi2red=2.1481 aic=65.5540 bic=75.5919 bic_k0=68.7239 zHb=7.037888 hwHb=0.002298 chi2Hb=18.1779 zHa=7.061742 hwHa=0.001473 chi2Ha=10.4247 sigHb=700 sigHa=600 sigHaB=NaN edge=0
FIT model=RM20 comp=1C scen=ERRALL BW=12 n=29 nHb=19 nHa=10 k=7 dof=22 zJ=7.038512 hwJ=0.002752 lo=7.035062 hi=7.040566 hwJscaled=0.002922 chi2=24.8097 chi2red=1.1277 aic=38.8097 bic=48.3808 bic_k0=41.6462 zHb=7.037888 hwHb=0.002298 chi2Hb=18.1779 zHa=7.022262 hwHa=NaN chi2Ha=5.7334 sigHb=700 sigHa=800 sigHaB=NaN edge=0
FIT model=RM20 comp=1C scen=ERREDGE BW=12 n=29 nHb=19 nHa=10 k=7 dof=22 zJ=7.038512 hwJ=0.002752 lo=7.035062 hi=7.040566 hwJscaled=0.002922 chi2=24.8097 chi2red=1.1277 aic=38.8097 bic=48.3808 bic_k0=41.6462 zHb=7.037888 hwHb=0.002298 chi2Hb=18.1779 zHa=7.022262 hwHa=NaN chi2Ha=5.7334 sigHb=700 sigHa=800 sigHaB=NaN edge=0
FIT model=RM20 comp=2C scen=D0 BW=6 n=29 nHb=19 nHa=10 k=9 dof=20 zJ=7.040524 hwJ=0.000269 lo=7.040255 hi=7.040793 hwJscaled=0.000597 chi2=98.5324 chi2red=4.9266 aic=116.5324 bic=128.8381 bic_k0=122.1035 zHb=7.037888 hwHb=0.002298 chi2Hb=18.1779 zHa=7.040560 hwHa=0.000272 chi2Ha=79.0262 sigHb=700 sigHa=400 sigHaB=1100 edge=0
FIT model=RM20 comp=2C scen=D0 BW=8 n=31 nHb=19 nHa=12 k=9 dof=22 zJ=7.040513 hwJ=0.000269 lo=7.040245 hi=7.040782 hwJscaled=0.000580 chi2=102.4310 chi2red=4.6560 aic=120.4310 bic=133.3369 bic_k0=126.4689 zHb=7.037888 hwHb=0.002298 chi2Hb=18.1779 zHa=7.040549 hwHa=0.000271 chi2Ha=82.9356 sigHb=700 sigHa=400 sigHaB=1000 edge=0
FIT model=RM20 comp=2C scen=D0 BW=12 n=35 nHb=19 nHa=16 k=9 dof=26 zJ=7.040513 hwJ=0.000269 lo=7.040244 hi=7.040782 hwJscaled=0.000540 chi2=105.0782 chi2red=4.0415 aic=123.0782 bic=137.0763 bic_k0=129.9656 zHb=7.037888 hwHb=0.002298 chi2Hb=18.1779 zHa=7.040549 hwHa=0.000271 chi2Ha=85.5830 sigHb=700 sigHa=400 sigHaB=1000 edge=0
FIT model=RM20 comp=2C scen=D1 BW=12 n=34 nHb=19 nHa=15 k=9 dof=25 zJ=7.040920 hwJ=0.000283 lo=7.040637 hi=7.041203 hwJscaled=0.000323 chi2=32.5996 chi2red=1.3040 aic=50.5996 bic=64.3368 bic_k0=57.2841 zHb=7.037888 hwHb=0.002298 chi2Hb=18.1779 zHa=7.040966 hwHa=0.000285 chi2Ha=12.6649 sigHb=700 sigHa=200 sigHaB=900 edge=0
FIT model=RM20 comp=2C scen=D2 BW=12 n=33 nHb=19 nHa=14 k=9 dof=24 zJ=7.040642 hwJ=0.000304 lo=7.040340 hi=7.040948 hwJscaled=0.000330 chi2=28.2704 chi2red=1.1779 aic=46.2704 bic=59.7389 bic_k0=52.7459 zHb=7.037888 hwHb=0.002298 chi2Hb=18.1779 zHa=7.040690 hwHa=0.000307 chi2Ha=8.6379 sigHb=700 sigHa=200 sigHaB=900 edge=0
FIT model=RM20 comp=2C scen=D3 BW=12 n=32 nHb=19 nHa=13 k=9 dof=23 zJ=7.040853 hwJ=0.000661 lo=7.040355 hi=7.041676 hwJscaled=0.000729 chi2=27.9946 chi2red=1.2172 aic=45.9946 bic=59.1863 bic_k0=52.2548 zHb=7.037888 hwHb=0.002298 chi2Hb=18.1779 zHa=7.041012 hwHa=0.000879 chi2Ha=8.0737 sigHb=700 sigHa=200 sigHaB=900 edge=0
FIT model=RM20 comp=2C scen=D4 BW=12 n=31 nHb=19 nHa=12 k=9 dof=22 zJ=7.038363 hwJ=0.001839 lo=7.037059 hi=7.040737 hwJscaled=0.002025 chi2=26.6664 chi2red=1.2121 aic=44.6664 bic=57.5723 bic_k0=50.7043 zHb=7.037888 hwHb=0.002298 chi2Hb=18.1779 zHa=7.043154 hwHa=0.012042 chi2Ha=7.5928 sigHb=700 sigHa=100 sigHaB=900 edge=0
FIT model=RM20 comp=2C scen=ERRALL BW=12 n=29 nHb=19 nHa=10 k=9 dof=20 zJ=7.037774 hwJ=0.002338 lo=7.035438 hi=7.040115 hwJscaled=0.002610 chi2=24.9161 chi2red=1.2458 aic=42.9161 bic=55.2218 bic_k0=48.4872 zHb=7.037888 hwHb=0.002298 chi2Hb=18.1779 zHa=7.022262 hwHa=NaN chi2Ha=5.7334 sigHb=700 sigHa=600 sigHaB=900 edge=0
FIT model=RM20 comp=2C scen=ERREDGE BW=12 n=29 nHb=19 nHa=10 k=9 dof=20 zJ=7.037774 hwJ=0.002338 lo=7.035438 hi=7.040115 hwJscaled=0.002610 chi2=24.9161 chi2red=1.2458 aic=42.9161 bic=55.2218 bic_k0=48.4872 zHb=7.037888 hwHb=0.002298 chi2Hb=18.1779 zHa=7.022262 hwHa=NaN chi2Ha=5.7334 sigHb=700 sigHa=600 sigHaB=900 edge=0
FIT model=RM6 comp=1C scen=D0 BW=6 n=29 nHb=19 nHa=10 k=8 dof=21 zJ=7.038408 hwJ=0.000234 lo=7.038174 hi=7.038642 hwJscaled=0.001819 chi2=1264.3807 chi2red=60.2086 aic=1280.3807 bic=1291.3191 bic_k0=1281.2172 zHb=7.038698 hwHb=0.002319 chi2Hb=15.5843 zHa=7.038405 hwHa=0.000236 chi2Ha=1248.7806 sigHb=500 sigHa=300 sigHaB=NaN edge=0
FIT model=RM6 comp=1C scen=D0 BW=8 n=31 nHb=19 nHa=12 k=8 dof=23 zJ=7.038408 hwJ=0.000234 lo=7.038174 hi=7.038642 hwJscaled=0.001740 chi2=1268.2473 chi2red=55.1412 aic=1284.2473 bic=1295.7192 bic_k0=1285.4172 zHb=7.038698 hwHb=0.002319 chi2Hb=15.5843 zHa=7.038405 hwHa=0.000236 chi2Ha=1252.6471 sigHb=500 sigHa=300 sigHaB=NaN edge=0
FIT model=RM6 comp=1C scen=D0 BW=12 n=35 nHb=19 nHa=16 k=9 dof=26 zJ=7.038408 hwJ=0.000234 lo=7.038174 hi=7.038642 hwJscaled=0.001639 chi2=1271.7016 chi2red=48.9116 aic=1289.7016 bic=1303.6998 bic_k0=1289.4784 zHb=7.038698 hwHb=0.002319 chi2Hb=15.5843 zHa=7.038405 hwHa=0.000236 chi2Ha=1256.1015 sigHb=500 sigHa=300 sigHaB=NaN edge=0
FIT model=RM6 comp=1C scen=D1 BW=12 n=34 nHb=19 nHa=15 k=9 dof=25 zJ=7.036498 hwJ=0.000229 lo=7.036268 hi=7.036727 hwJscaled=0.000988 chi2=464.0463 chi2red=18.5619 aic=482.0463 bic=495.7836 bic_k0=481.6781 zHb=7.038698 hwHb=0.002319 chi2Hb=15.5843 zHa=7.036476 hwHa=0.000231 chi2Ha=447.5486 sigHb=500 sigHa=200 sigHaB=NaN edge=0
FIT model=RM6 comp=1C scen=D2 BW=12 n=33 nHb=19 nHa=14 k=9 dof=24 zJ=7.036273 hwJ=0.000234 lo=7.036039 hi=7.036507 hwJscaled=0.000899 chi2=354.9995 chi2red=14.7916 aic=372.9995 bic=386.4680 bic_k0=372.4820 zHb=7.038698 hwHb=0.002319 chi2Hb=15.5843 zHa=7.036248 hwHa=0.000235 chi2Ha=338.3054 sigHb=500 sigHa=200 sigHaB=NaN edge=0
FIT model=RM6 comp=1C scen=D3 BW=12 n=32 nHb=19 nHa=13 k=8 dof=24 zJ=7.038294 hwJ=0.000413 lo=7.037882 hi=7.038709 hwJscaled=0.000694 chi2=67.6953 chi2red=2.8206 aic=83.6953 bic=95.4212 bic_k0=85.0240 zHb=7.038698 hwHb=0.002319 chi2Hb=15.5843 zHa=7.038281 hwHa=0.000420 chi2Ha=52.0796 sigHb=500 sigHa=500 sigHaB=NaN edge=0
FIT model=RM6 comp=1C scen=D4 BW=12 n=31 nHb=19 nHa=12 k=8 dof=23 zJ=7.043934 hwJ=0.000840 lo=7.043117 hi=7.044796 hwJscaled=0.001178 chi2=45.2389 chi2red=1.9669 aic=61.2389 bic=72.7108 bic_k0=62.4089 zHb=7.038698 hwHb=0.002319 chi2Hb=15.5843 zHa=7.062440 hwHa=0.001512 chi2Ha=11.1929 sigHb=500 sigHa=600 sigHaB=NaN edge=0
FIT model=RM6 comp=1C scen=ERRALL BW=12 n=29 nHb=19 nHa=10 k=8 dof=21 zJ=7.038142 hwJ=0.002073 lo=7.036082 hi=7.040227 hwJscaled=0.002229 chi2=24.2826 chi2red=1.1563 aic=40.2826 bic=51.2210 bic_k0=41.1191 zHb=7.038698 hwHb=0.002319 chi2Hb=15.5843 zHa=7.020000 hwHa=NaN chi2Ha=7.6825 sigHb=500 sigHa=700 sigHaB=NaN edge=1
FIT model=RM6 comp=1C scen=ERREDGE BW=12 n=29 nHb=19 nHa=10 k=8 dof=21 zJ=7.038142 hwJ=0.002073 lo=7.036082 hi=7.040227 hwJscaled=0.002229 chi2=24.2826 chi2red=1.1563 aic=40.2826 bic=51.2210 bic_k0=41.1191 zHb=7.038698 hwHb=0.002319 chi2Hb=15.5843 zHa=7.020000 hwHa=NaN chi2Ha=7.6825 sigHb=500 sigHa=700 sigHaB=NaN edge=1
FIT model=RM6 comp=2C scen=D0 BW=6 n=29 nHb=19 nHa=10 k=10 dof=19 zJ=7.038408 hwJ=0.000234 lo=7.038174 hi=7.038642 hwJscaled=0.001912 chi2=1264.3807 chi2red=66.5464 aic=1284.3807 bic=1298.0537 bic_k0=1287.9518 zHb=7.038698 hwHb=0.002319 chi2Hb=15.5843 zHa=7.038405 hwHa=0.000236 chi2Ha=1248.7806 sigHb=500 sigHa=300 sigHaB=900 edge=0
FIT model=RM6 comp=2C scen=D0 BW=8 n=31 nHb=19 nHa=12 k=10 dof=21 zJ=7.038408 hwJ=0.000234 lo=7.038174 hi=7.038642 hwJscaled=0.001821 chi2=1268.2473 chi2red=60.3927 aic=1288.2473 bic=1302.5871 bic_k0=1292.2852 zHb=7.038698 hwHb=0.002319 chi2Hb=15.5843 zHa=7.038405 hwHa=0.000236 chi2Ha=1252.6471 sigHb=500 sigHa=300 sigHaB=900 edge=0
FIT model=RM6 comp=2C scen=D0 BW=12 n=35 nHb=19 nHa=16 k=11 dof=24 zJ=7.038408 hwJ=0.000234 lo=7.038174 hi=7.038642 hwJscaled=0.001706 chi2=1271.7016 chi2red=52.9876 aic=1293.7016 bic=1310.8105 bic_k0=1296.5891 zHb=7.038698 hwHb=0.002319 chi2Hb=15.5843 zHa=7.038405 hwHa=0.000236 chi2Ha=1256.1015 sigHb=500 sigHa=300 sigHaB=900 edge=0
FIT model=RM6 comp=2C scen=D1 BW=12 n=34 nHb=19 nHa=15 k=11 dof=23 zJ=7.036501 hwJ=0.000230 lo=7.036270 hi=7.036731 hwJscaled=0.001035 chi2=463.5399 chi2red=20.1539 aic=485.5399 bic=502.3299 bic_k0=488.2244 zHb=7.038698 hwHb=0.002319 chi2Hb=15.5843 zHa=7.036479 hwHa=0.000232 chi2Ha=447.0445 sigHb=500 sigHa=200 sigHaB=1600 edge=0
FIT model=RM6 comp=2C scen=D2 BW=12 n=33 nHb=19 nHa=14 k=11 dof=22 zJ=7.036728 hwJ=0.000240 lo=7.036488 hi=7.036967 hwJscaled=0.000892 chi2=304.8387 chi2red=13.8563 aic=326.8387 bic=343.3003 bic_k0=329.3143 zHb=7.038698 hwHb=0.002319 chi2Hb=15.5843 zHa=7.036707 hwHa=0.000241 chi2Ha=288.5214 sigHb=500 sigHa=0 sigHaB=1100 edge=0
FIT model=RM6 comp=2C scen=D3 BW=12 n=32 nHb=19 nHa=13 k=10 dof=22 zJ=7.036993 hwJ=0.000376 lo=7.036624 hi=7.037375 hwJscaled=0.000439 chi2=30.1014 chi2red=1.3682 aic=50.1014 bic=64.7588 bic_k0=54.3616 zHb=7.038698 hwHb=0.002319 chi2Hb=15.5843 zHa=7.036948 hwHa=0.000378 chi2Ha=13.9597 sigHb=500 sigHa=0 sigHaB=900 edge=0
FIT model=RM6 comp=2C scen=D4 BW=12 n=31 nHb=19 nHa=12 k=10 dof=21 zJ=7.039583 hwJ=0.002016 lo=7.037972 hi=7.042004 hwJscaled=0.002310 chi2=27.5726 chi2red=1.3130 aic=47.5726 bic=61.9125 bic_k0=51.6105 zHb=7.038698 hwHb=0.002319 chi2Hb=15.5843 zHa=7.047269 hwHa=NaN chi2Ha=10.3573 sigHb=500 sigHa=200 sigHaB=900 edge=0
FIT model=RM6 comp=2C scen=ERRALL BW=12 n=29 nHb=19 nHa=10 k=10 dof=19 zJ=7.038460 hwJ=0.002381 lo=7.036082 hi=7.040845 hwJscaled=0.002734 chi2=25.0458 chi2red=1.3182 aic=45.0458 bic=58.7188 bic_k0=48.6169 zHb=7.038698 hwHb=0.002319 chi2Hb=15.5843 zHa=7.020000 hwHa=NaN chi2Ha=7.6825 sigHb=500 sigHa=600 sigHaB=900 edge=1
FIT model=RM6 comp=2C scen=ERREDGE BW=12 n=29 nHb=19 nHa=10 k=10 dof=19 zJ=7.038460 hwJ=0.002381 lo=7.036082 hi=7.040845 hwJscaled=0.002734 chi2=25.0458 chi2red=1.3182 aic=45.0458 bic=58.7188 bic_k0=48.6169 zHb=7.038698 hwHb=0.002319 chi2Hb=15.5843 zHa=7.020000 hwHa=NaN chi2Ha=7.6825 sigHb=500 sigHa=600 sigHaB=900 edge=1
FIT model=SPL comp=1C scen=D0 BW=6 n=29 nHb=19 nHa=10 k=13 dof=16 zJ=7.039242 hwJ=0.000648 lo=7.038575 hi=7.039872 hwJscaled=0.000821 chi2=25.6671 chi2red=1.6042 aic=51.6671 bic=69.4420 bic_k0=69.4420 zHb=7.038624 hwHb=0.002488 chi2Hb=14.1414 zHa=7.039275 hwHa=0.000665 chi2Ha=11.4637 sigHb=600 sigHa=0 sigHaB=NaN edge=0
FIT model=SPL comp=1C scen=D0 BW=8 n=31 nHb=19 nHa=12 k=13 dof=18 zJ=7.042117 hwJ=0.000479 lo=7.041644 hi=7.042602 hwJscaled=0.000801 chi2=50.2735 chi2red=2.7930 aic=76.2735 bic=94.9154 bic_k0=94.9154 zHb=7.038624 hwHb=0.002488 chi2Hb=14.1414 zHa=7.042251 hwHa=0.000493 chi2Ha=34.1678 sigHb=600 sigHa=200 sigHaB=NaN edge=0
FIT model=SPL comp=1C scen=D0 BW=12 n=35 nHb=19 nHa=16 k=13 dof=22 zJ=7.042329 hwJ=0.000417 lo=7.041914 hi=7.042749 hwJscaled=0.000727 chi2=66.7482 chi2red=3.0340 aic=92.7482 bic=112.9677 bic_k0=112.9677 zHb=7.038624 hwHb=0.002488 chi2Hb=14.1414 zHa=7.042435 hwHa=0.000425 chi2Ha=50.4123 sigHb=600 sigHa=500 sigHaB=NaN edge=0
FIT model=SPL comp=1C scen=D1 BW=12 n=34 nHb=19 nHa=15 k=13 dof=21 zJ=7.039870 hwJ=0.000400 lo=7.039471 hi=7.040271 hwJscaled=0.000531 chi2=37.0604 chi2red=1.7648 aic=63.0604 bic=82.9031 bic_k0=82.9031 zHb=7.038624 hwHb=0.002488 chi2Hb=14.1414 zHa=7.039900 hwHa=0.000406 chi2Ha=22.6904 sigHb=600 sigHa=300 sigHaB=NaN edge=0
FIT model=SPL comp=1C scen=D2 BW=12 n=33 nHb=19 nHa=14 k=13 dof=20 zJ=7.040993 hwJ=0.000540 lo=7.040446 hi=7.041527 hwJscaled=0.000743 chi2=37.8345 chi2red=1.8917 aic=63.8345 bic=83.2891 bic_k0=83.2891 zHb=7.038624 hwHb=0.002488 chi2Hb=14.1414 zHa=7.043149 hwHa=0.000586 chi2Ha=21.8859 sigHb=600 sigHa=400 sigHaB=NaN edge=0
FIT model=SPL comp=1C scen=D3 BW=12 n=32 nHb=19 nHa=13 k=13 dof=19 zJ=7.037002 hwJ=0.000735 lo=7.036287 hi=7.037757 hwJscaled=0.000765 chi2=20.5780 chi2red=1.0831 aic=46.5780 bic=65.6326 bic_k0=65.6326 zHb=7.038624 hwHb=0.002488 chi2Hb=14.1414 zHa=7.036854 hwHa=0.000763 chi2Ha=5.9419 sigHb=500 sigHa=0 sigHaB=NaN edge=0
FIT model=SPL comp=1C scen=D4 BW=12 n=31 nHb=19 nHa=12 k=13 dof=18 zJ=7.038381 hwJ=0.001801 lo=7.037093 hi=7.040695 hwJscaled=0.001801 chi2=17.8927 chi2red=0.9940 aic=43.8927 bic=62.5346 bic_k0=62.5346 zHb=7.038624 hwHb=0.002488 chi2Hb=14.1414 zHa=7.038262 hwHa=0.003775 chi2Ha=3.7360 sigHb=500 sigHa=0 sigHaB=NaN edge=0
FIT model=SPL comp=1C scen=ERRALL BW=12 n=29 nHb=19 nHa=10 k=13 dof=16 zJ=7.038619 hwJ=0.002489 lo=7.036209 hi=7.041188 hwJscaled=0.002520 chi2=16.3896 chi2red=1.0243 aic=42.3896 bic=60.1644 bic_k0=60.1644 zHb=7.038624 hwHb=0.002488 chi2Hb=14.1414 zHa=7.055803 hwHa=NaN chi2Ha=1.8684 sigHb=500 sigHa=500 sigHaB=NaN edge=0
FIT model=SPL comp=1C scen=ERREDGE BW=12 n=29 nHb=19 nHa=10 k=13 dof=16 zJ=7.038619 hwJ=0.002489 lo=7.036209 hi=7.041188 hwJscaled=0.002520 chi2=16.3896 chi2red=1.0243 aic=42.3896 bic=60.1644 bic_k0=60.1644 zHb=7.038624 hwHb=0.002488 chi2Hb=14.1414 zHa=7.055803 hwHa=NaN chi2Ha=1.8684 sigHb=500 sigHa=500 sigHaB=NaN edge=0
FIT model=SPL comp=2C scen=D0 BW=6 n=29 nHb=19 nHa=10 k=15 dof=14 zJ=7.040161 hwJ=0.000554 lo=7.039633 hi=7.040742 hwJscaled=0.000640 chi2=18.6972 chi2red=1.3355 aic=48.6972 bic=69.2067 bic_k0=69.2067 zHb=7.038624 hwHb=0.002488 chi2Hb=14.1414 zHa=7.040217 hwHa=0.000675 chi2Ha=4.1983 sigHb=600 sigHa=0 sigHaB=2100 edge=0
FIT model=SPL comp=2C scen=D0 BW=8 n=31 nHb=19 nHa=12 k=15 dof=16 zJ=7.039073 hwJ=0.000648 lo=7.038398 hi=7.039694 hwJscaled=0.000735 chi2=20.5823 chi2red=1.2864 aic=50.5823 bic=72.0921 bic_k0=72.0921 zHb=7.038624 hwHb=0.002488 chi2Hb=14.1414 zHa=7.039102 hwHa=0.000665 chi2Ha=6.4039 sigHb=500 sigHa=0 sigHaB=2900 edge=0
FIT model=SPL comp=2C scen=D0 BW=12 n=35 nHb=19 nHa=16 k=15 dof=20 zJ=7.040158 hwJ=0.000497 lo=7.039657 hi=7.040651 hwJscaled=0.000643 chi2=33.5176 chi2red=1.6759 aic=63.5176 bic=86.8478 bic_k0=86.8478 zHb=7.038624 hwHb=0.002488 chi2Hb=14.1414 zHa=7.040217 hwHa=0.000506 chi2Ha=19.0197 sigHb=600 sigHa=0 sigHaB=1500 edge=0
FIT model=SPL comp=2C scen=D1 BW=12 n=34 nHb=19 nHa=15 k=15 dof=19 zJ=7.040254 hwJ=0.000477 lo=7.039753 hi=7.040707 hwJscaled=0.000486 chi2=19.7580 chi2red=1.0399 aic=49.7580 bic=72.6534 bic_k0=72.6534 zHb=7.038624 hwHb=0.002488 chi2Hb=14.1414 zHa=7.040306 hwHa=0.000484 chi2Ha=5.2147 sigHb=600 sigHa=0 sigHaB=1100 edge=0
FIT model=SPL comp=2C scen=D2 BW=12 n=33 nHb=19 nHa=14 k=15 dof=18 zJ=7.041078 hwJ=0.000980 lo=7.039902 hi=7.041863 hwJscaled=0.000983 chi2=18.1087 chi2red=1.0060 aic=48.1087 bic=70.5563 bic_k0=70.5563 zHb=7.038624 hwHb=0.002488 chi2Hb=14.1414 zHa=7.041336 hwHa=0.001556 chi2Ha=2.9559 sigHb=600 sigHa=200 sigHaB=1400 edge=0
FIT model=SPL comp=2C scen=D3 BW=12 n=32 nHb=19 nHa=13 k=15 dof=17 zJ=7.039035 hwJ=0.001947 lo=7.037657 hi=7.041551 hwJscaled=0.001984 chi2=17.6589 chi2red=1.0388 aic=47.6589 bic=69.6449 bic_k0=69.6449 zHb=7.038624 hwHb=0.002488 chi2Hb=14.1414 zHa=7.054968 hwHa=0.003766 chi2Ha=2.3326 sigHb=500 sigHa=0 sigHaB=1300 edge=0
FIT model=SPL comp=2C scen=D4 BW=12 n=31 nHb=19 nHa=12 k=15 dof=16 zJ=7.038881 hwJ=0.001710 lo=7.037554 hi=7.040974 hwJscaled=0.001726 chi2=16.3074 chi2red=1.0192 aic=46.3074 bic=67.8172 bic_k0=67.8172 zHb=7.038624 hwHb=0.002488 chi2Hb=14.1414 zHa=7.043025 hwHa=0.003804 chi2Ha=2.0719 sigHb=500 sigHa=100 sigHaB=1400 edge=0
FIT model=SPL comp=2C scen=ERRALL BW=12 n=29 nHb=19 nHa=10 k=15 dof=14 zJ=7.038683 hwJ=0.002490 lo=7.036231 hi=7.041212 hwJscaled=0.002666 chi2=16.0421 chi2red=1.1459 aic=46.0421 bic=66.5516 bic_k0=66.5516 zHb=7.038624 hwHb=0.002488 chi2Hb=14.1414 zHa=7.054191 hwHa=NaN chi2Ha=1.8234 sigHb=500 sigHa=600 sigHaB=1600 edge=0
FIT model=SPL comp=2C scen=ERREDGE BW=12 n=29 nHb=19 nHa=10 k=15 dof=14 zJ=7.038683 hwJ=0.002490 lo=7.036231 hi=7.041212 hwJscaled=0.002666 chi2=16.0421 chi2red=1.1459 aic=46.0421 bic=66.5516 bic_k0=66.5516 zHb=7.038624 hwHb=0.002488 chi2Hb=14.1414 zHa=7.054191 hwHa=NaN chi2Ha=1.8234 sigHb=500 sigHa=600 sigHaB=1600 edge=0
--- mask logs (verbatim, one per scenario)
MASKLOG scen=D1 dropped idx 420
MASKLOG scen=D2 dropped idx [419 420]
MASKLOG scen=D3 dropped idx [418 419 420]
MASKLOG scen=D4 dropped idx [417 418 419 420]
MASKLOG scen=ERRALL thr_Jy=5.443221e-08 ref_median_Jy=3.628814e-08 masked idx [415 416 417 418 419 420]
MASKLOG scen=ERREDGE thr_Jy=5.443221e-08 ref_median_Jy=3.628814e-08 masked idx [415 416 417 418 419 420]

=== 6. Halpha leave-one-out (D0)
LOO model=P0 comp=1C full zJ=7.040445 hwJ=0.000270 nHa=16
LOO model=P0 comp=1C drop=405 zJ=7.040452 hwJ=0.000270 dz=+7.615e-06
LOO model=P0 comp=1C drop=406 zJ=7.040449 hwJ=0.000270 dz=+4.183e-06
LOO model=P0 comp=1C drop=407 zJ=7.040443 hwJ=0.000270 dz=-1.954e-06
LOO model=P0 comp=1C drop=408 zJ=7.040443 hwJ=0.000270 dz=-1.638e-06
LOO model=P0 comp=1C drop=409 zJ=7.040442 hwJ=0.000270 dz=-2.273e-06
LOO model=P0 comp=1C drop=410 zJ=7.040452 hwJ=0.000270 dz=+7.236e-06
LOO model=P0 comp=1C drop=411 zJ=7.040442 hwJ=0.000270 dz=-2.695e-06
LOO model=P0 comp=1C drop=412 zJ=7.040462 hwJ=0.000269 dz=+1.743e-05
LOO model=P0 comp=1C drop=413 zJ=7.040624 hwJ=0.000269 dz=+1.791e-04
LOO model=P0 comp=1C drop=414 zJ=7.040460 hwJ=0.000295 dz=+1.562e-05
LOO model=P0 comp=1C drop=415 zJ=7.039775 hwJ=0.000319 dz=-6.692e-04
LOO model=P0 comp=1C drop=416 zJ=7.040487 hwJ=0.000282 dz=+4.214e-05
LOO model=P0 comp=1C drop=417 zJ=7.040173 hwJ=0.000295 dz=-2.717e-04
LOO model=P0 comp=1C drop=418 zJ=7.040970 hwJ=0.000318 dz=+5.256e-04
LOO model=P0 comp=1C drop=419 zJ=7.040091 hwJ=0.000292 dz=-3.531e-04
LOO model=P0 comp=1C drop=420 zJ=7.040737 hwJ=0.000278 dz=+2.926e-04
LOO model=P0 comp=2C full zJ=7.040508 hwJ=0.000271 nHa=16
LOO model=P0 comp=2C drop=405 zJ=7.040501 hwJ=0.000269 dz=-6.793e-06
LOO model=P0 comp=2C drop=406 zJ=7.040497 hwJ=0.000273 dz=-1.037e-05
LOO model=P0 comp=2C drop=407 zJ=7.040503 hwJ=0.000270 dz=-4.407e-06
LOO model=P0 comp=2C drop=408 zJ=7.040504 hwJ=0.000272 dz=-3.330e-06
LOO model=P0 comp=2C drop=409 zJ=7.040490 hwJ=0.000271 dz=-1.829e-05
LOO model=P0 comp=2C drop=410 zJ=7.040527 hwJ=0.000269 dz=+1.930e-05
LOO model=P0 comp=2C drop=411 zJ=7.040496 hwJ=0.000272 dz=-1.193e-05
LOO model=P0 comp=2C drop=412 zJ=7.040494 hwJ=0.000268 dz=-1.336e-05
LOO model=P0 comp=2C drop=413 zJ=7.040606 hwJ=0.000266 dz=+9.810e-05
LOO model=P0 comp=2C drop=414 zJ=7.040647 hwJ=0.000296 dz=+1.392e-04
LOO model=P0 comp=2C drop=415 zJ=7.039997 hwJ=0.000370 dz=-5.107e-04
LOO model=P0 comp=2C drop=416 zJ=7.040384 hwJ=0.000287 dz=-1.234e-04
LOO model=P0 comp=2C drop=417 zJ=7.040241 hwJ=0.000304 dz=-2.671e-04
LOO model=P0 comp=2C drop=418 zJ=7.040899 hwJ=0.000327 dz=+3.913e-04
LOO model=P0 comp=2C drop=419 zJ=7.040063 hwJ=0.000279 dz=-4.445e-04
LOO model=P0 comp=2C drop=420 zJ=7.040923 hwJ=0.000283 dz=+4.152e-04
LOO model=P1 comp=1C full zJ=7.040487 hwJ=0.000276 nHa=16
LOO model=P1 comp=1C drop=405 zJ=7.040571 hwJ=0.000278 dz=+8.355e-05
LOO model=P1 comp=1C drop=406 zJ=7.040524 hwJ=0.000277 dz=+3.633e-05
LOO model=P1 comp=1C drop=407 zJ=7.040483 hwJ=0.000277 dz=-4.873e-06
LOO model=P1 comp=1C drop=408 zJ=7.040484 hwJ=0.000277 dz=-3.446e-06
LOO model=P1 comp=1C drop=409 zJ=7.040484 hwJ=0.000276 dz=-3.614e-06
LOO model=P1 comp=1C drop=410 zJ=7.040490 hwJ=0.000277 dz=+2.371e-06
LOO model=P1 comp=1C drop=411 zJ=7.040494 hwJ=0.000276 dz=+6.672e-06
LOO model=P1 comp=1C drop=412 zJ=7.040546 hwJ=0.000275 dz=+5.854e-05
LOO model=P1 comp=1C drop=413 zJ=7.040770 hwJ=0.000278 dz=+2.829e-04
LOO model=P1 comp=1C drop=414 zJ=7.040536 hwJ=0.000310 dz=+4.837e-05
LOO model=P1 comp=1C drop=415 zJ=7.039798 hwJ=0.000328 dz=-6.889e-04
LOO model=P1 comp=1C drop=416 zJ=7.040516 hwJ=0.000286 dz=+2.836e-05
LOO model=P1 comp=1C drop=417 zJ=7.040166 hwJ=0.000309 dz=-3.214e-04
LOO model=P1 comp=1C drop=418 zJ=7.041023 hwJ=0.000325 dz=+5.360e-04
LOO model=P1 comp=1C drop=419 zJ=7.040126 hwJ=0.000289 dz=-3.615e-04
LOO model=P1 comp=1C drop=420 zJ=7.040199 hwJ=0.000286 dz=-2.883e-04
LOO model=P1 comp=2C full zJ=7.042072 hwJ=0.000394 nHa=16
LOO model=P1 comp=2C drop=405 zJ=7.041928 hwJ=0.000363 dz=-1.444e-04
LOO model=P1 comp=2C drop=406 zJ=7.042055 hwJ=0.000394 dz=-1.752e-05
LOO model=P1 comp=2C drop=407 zJ=7.042121 hwJ=0.000389 dz=+4.874e-05
LOO model=P1 comp=2C drop=408 zJ=7.042125 hwJ=0.000426 dz=+5.273e-05
LOO model=P1 comp=2C drop=409 zJ=7.042076 hwJ=0.000466 dz=+4.209e-06
LOO model=P1 comp=2C drop=410 zJ=7.042077 hwJ=0.000386 dz=+5.256e-06
LOO model=P1 comp=2C drop=411 zJ=7.042105 hwJ=0.000390 dz=+3.247e-05
LOO model=P1 comp=2C drop=412 zJ=7.042062 hwJ=0.000406 dz=-9.833e-06
LOO model=P1 comp=2C drop=413 zJ=7.041869 hwJ=0.000379 dz=-2.031e-04
LOO model=P1 comp=2C drop=414 zJ=7.042020 hwJ=0.000399 dz=-5.212e-05
LOO model=P1 comp=2C drop=415 zJ=7.041470 hwJ=0.000456 dz=-6.016e-04
LOO model=P1 comp=2C drop=416 zJ=7.042318 hwJ=0.000444 dz=+2.459e-04
LOO model=P1 comp=2C drop=417 zJ=7.041840 hwJ=0.000419 dz=-2.321e-04
LOO model=P1 comp=2C drop=418 zJ=7.043538 hwJ=0.000487 dz=+1.466e-03
LOO model=P1 comp=2C drop=419 zJ=7.041256 hwJ=0.000349 dz=-8.157e-04
LOO model=P1 comp=2C drop=420 zJ=7.040835 hwJ=0.000344 dz=-1.237e-03
LOO model=P2 comp=1C full zJ=7.041442 hwJ=0.000324 nHa=16
LOO model=P2 comp=1C drop=405 zJ=7.041511 hwJ=0.000332 dz=+6.884e-05
LOO model=P2 comp=1C drop=406 zJ=7.041446 hwJ=0.000324 dz=+4.298e-06
LOO model=P2 comp=1C drop=407 zJ=7.041436 hwJ=0.000324 dz=-6.547e-06
LOO model=P2 comp=1C drop=408 zJ=7.041455 hwJ=0.000326 dz=+1.250e-05
LOO model=P2 comp=1C drop=409 zJ=7.041481 hwJ=0.000327 dz=+3.849e-05
LOO model=P2 comp=1C drop=410 zJ=7.041625 hwJ=0.000329 dz=+1.831e-04
LOO model=P2 comp=1C drop=411 zJ=7.041474 hwJ=0.000328 dz=+3.142e-05
LOO model=P2 comp=1C drop=412 zJ=7.042322 hwJ=0.000348 dz=+8.796e-04
LOO model=P2 comp=1C drop=413 zJ=7.041547 hwJ=0.000319 dz=+1.048e-04
LOO model=P2 comp=1C drop=414 zJ=7.042054 hwJ=0.000392 dz=+6.118e-04
LOO model=P2 comp=1C drop=415 zJ=7.041601 hwJ=0.000402 dz=+1.585e-04
LOO model=P2 comp=1C drop=416 zJ=7.042573 hwJ=0.000370 dz=+1.131e-03
LOO model=P2 comp=1C drop=417 zJ=7.041959 hwJ=0.000386 dz=+5.167e-04
LOO model=P2 comp=1C drop=418 zJ=7.043587 hwJ=0.000398 dz=+2.145e-03
LOO model=P2 comp=1C drop=419 zJ=7.041071 hwJ=0.000322 dz=-3.712e-04
LOO model=P2 comp=1C drop=420 zJ=7.039781 hwJ=0.000347 dz=-1.661e-03
LOO model=P2 comp=2C full zJ=7.042245 hwJ=0.000398 nHa=16
LOO model=P2 comp=2C drop=405 zJ=7.042206 hwJ=0.000399 dz=-3.897e-05
LOO model=P2 comp=2C drop=406 zJ=7.042244 hwJ=0.000398 dz=-2.196e-07
LOO model=P2 comp=2C drop=407 zJ=7.042228 hwJ=0.000398 dz=-1.684e-05
LOO model=P2 comp=2C drop=408 zJ=7.042224 hwJ=0.000398 dz=-2.088e-05
LOO model=P2 comp=2C drop=409 zJ=7.042219 hwJ=0.000398 dz=-2.565e-05
LOO model=P2 comp=2C drop=410 zJ=7.042201 hwJ=0.000401 dz=-4.372e-05
LOO model=P2 comp=2C drop=411 zJ=7.042250 hwJ=0.000399 dz=+4.985e-06
LOO model=P2 comp=2C drop=412 zJ=7.042243 hwJ=0.000398 dz=-1.960e-06
LOO model=P2 comp=2C drop=413 zJ=7.042168 hwJ=0.000402 dz=-7.688e-05
LOO model=P2 comp=2C drop=414 zJ=7.042376 hwJ=0.000409 dz=+1.318e-04
LOO model=P2 comp=2C drop=415 zJ=7.042031 hwJ=0.000462 dz=-2.140e-04
LOO model=P2 comp=2C drop=416 zJ=7.042732 hwJ=0.000535 dz=+4.871e-04
LOO model=P2 comp=2C drop=417 zJ=7.042138 hwJ=0.000424 dz=-1.069e-04
LOO model=P2 comp=2C drop=418 zJ=7.044143 hwJ=0.000585 dz=+1.899e-03
LOO model=P2 comp=2C drop=419 zJ=7.041606 hwJ=0.000359 dz=-6.389e-04
LOO model=P2 comp=2C drop=420 zJ=7.040500 hwJ=0.000486 dz=-1.744e-03
LOO model=P3 comp=1C full zJ=7.041922 hwJ=0.000371 nHa=16
LOO model=P3 comp=1C drop=405 zJ=7.041998 hwJ=0.000380 dz=+7.611e-05
LOO model=P3 comp=1C drop=406 zJ=7.041927 hwJ=0.000371 dz=+4.649e-06
LOO model=P3 comp=1C drop=407 zJ=7.041975 hwJ=0.000375 dz=+5.302e-05
LOO model=P3 comp=1C drop=408 zJ=7.041947 hwJ=0.000374 dz=+2.530e-05
LOO model=P3 comp=1C drop=409 zJ=7.041922 hwJ=0.000371 dz=+3.042e-07
LOO model=P3 comp=1C drop=410 zJ=7.042012 hwJ=0.000372 dz=+9.026e-05
LOO model=P3 comp=1C drop=411 zJ=7.041975 hwJ=0.000377 dz=+5.268e-05
LOO model=P3 comp=1C drop=412 zJ=7.041905 hwJ=0.000379 dz=-1.699e-05
LOO model=P3 comp=1C drop=413 zJ=7.041817 hwJ=0.000361 dz=-1.052e-04
LOO model=P3 comp=1C drop=414 zJ=7.041881 hwJ=0.000386 dz=-4.060e-05
LOO model=P3 comp=1C drop=415 zJ=7.041326 hwJ=0.000439 dz=-5.957e-04
LOO model=P3 comp=1C drop=416 zJ=7.042136 hwJ=0.000412 dz=+2.142e-04
LOO model=P3 comp=1C drop=417 zJ=7.041679 hwJ=0.000401 dz=-2.426e-04
LOO model=P3 comp=1C drop=418 zJ=7.044307 hwJ=0.000489 dz=+2.385e-03
LOO model=P3 comp=1C drop=419 zJ=7.041015 hwJ=0.000332 dz=-9.072e-04
LOO model=P3 comp=1C drop=420 zJ=7.040057 hwJ=0.000615 dz=-1.864e-03
LOO model=P3 comp=2C full zJ=7.042213 hwJ=0.000400 nHa=16
LOO model=P3 comp=2C drop=405 zJ=7.042212 hwJ=0.000401 dz=-8.611e-07
LOO model=P3 comp=2C drop=406 zJ=7.042211 hwJ=0.000400 dz=-1.913e-06
LOO model=P3 comp=2C drop=407 zJ=7.042209 hwJ=0.000400 dz=-3.751e-06
LOO model=P3 comp=2C drop=408 zJ=7.042208 hwJ=0.000400 dz=-4.670e-06
LOO model=P3 comp=2C drop=409 zJ=7.042198 hwJ=0.000400 dz=-1.485e-05
LOO model=P3 comp=2C drop=410 zJ=7.042232 hwJ=0.000399 dz=+1.881e-05
LOO model=P3 comp=2C drop=411 zJ=7.042238 hwJ=0.000398 dz=+2.463e-05
LOO model=P3 comp=2C drop=412 zJ=7.042215 hwJ=0.000400 dz=+1.714e-06
LOO model=P3 comp=2C drop=413 zJ=7.042206 hwJ=0.000399 dz=-7.011e-06
LOO model=P3 comp=2C drop=414 zJ=7.042283 hwJ=0.000410 dz=+6.971e-05
LOO model=P3 comp=2C drop=415 zJ=7.042145 hwJ=0.000486 dz=-6.819e-05
LOO model=P3 comp=2C drop=416 zJ=7.042662 hwJ=0.000590 dz=+4.486e-04
LOO model=P3 comp=2C drop=417 zJ=7.042193 hwJ=0.000411 dz=-2.045e-05
LOO model=P3 comp=2C drop=418 zJ=7.044166 hwJ=0.000709 dz=+1.953e-03
LOO model=P3 comp=2C drop=419 zJ=7.041665 hwJ=0.000358 dz=-5.483e-04
LOO model=P3 comp=2C drop=420 zJ=7.040401 hwJ=0.000431 dz=-1.812e-03
LOO model=PLLIN comp=1C full zJ=7.040487 hwJ=0.000276 nHa=16
LOO model=PLLIN comp=1C drop=405 zJ=7.040571 hwJ=0.000278 dz=+8.354e-05
LOO model=PLLIN comp=1C drop=406 zJ=7.040524 hwJ=0.000277 dz=+3.633e-05
LOO model=PLLIN comp=1C drop=407 zJ=7.040483 hwJ=0.000277 dz=-4.873e-06
LOO model=PLLIN comp=1C drop=408 zJ=7.040484 hwJ=0.000277 dz=-3.446e-06
LOO model=PLLIN comp=1C drop=409 zJ=7.040484 hwJ=0.000276 dz=-3.614e-06
LOO model=PLLIN comp=1C drop=410 zJ=7.040490 hwJ=0.000277 dz=+2.371e-06
LOO model=PLLIN comp=1C drop=411 zJ=7.040494 hwJ=0.000276 dz=+6.671e-06
LOO model=PLLIN comp=1C drop=412 zJ=7.040546 hwJ=0.000275 dz=+5.854e-05
LOO model=PLLIN comp=1C drop=413 zJ=7.040770 hwJ=0.000278 dz=+2.828e-04
LOO model=PLLIN comp=1C drop=414 zJ=7.040536 hwJ=0.000310 dz=+4.837e-05
LOO model=PLLIN comp=1C drop=415 zJ=7.039799 hwJ=0.000328 dz=-6.889e-04
LOO model=PLLIN comp=1C drop=416 zJ=7.040516 hwJ=0.000286 dz=+2.837e-05
LOO model=PLLIN comp=1C drop=417 zJ=7.040166 hwJ=0.000309 dz=-3.214e-04
LOO model=PLLIN comp=1C drop=418 zJ=7.041023 hwJ=0.000325 dz=+5.360e-04
LOO model=PLLIN comp=1C drop=419 zJ=7.040126 hwJ=0.000289 dz=-3.615e-04
LOO model=PLLIN comp=1C drop=420 zJ=7.040199 hwJ=0.000286 dz=-2.882e-04
LOO model=PLLIN comp=2C full zJ=7.042072 hwJ=0.000394 nHa=16
LOO model=PLLIN comp=2C drop=405 zJ=7.041928 hwJ=0.000363 dz=-1.444e-04
LOO model=PLLIN comp=2C drop=406 zJ=7.042055 hwJ=0.000394 dz=-1.752e-05
LOO model=PLLIN comp=2C drop=407 zJ=7.042121 hwJ=0.000389 dz=+4.875e-05
LOO model=PLLIN comp=2C drop=408 zJ=7.042125 hwJ=0.000426 dz=+5.273e-05
LOO model=PLLIN comp=2C drop=409 zJ=7.042076 hwJ=0.000466 dz=+4.212e-06
LOO model=PLLIN comp=2C drop=410 zJ=7.042077 hwJ=0.000386 dz=+5.263e-06
LOO model=PLLIN comp=2C drop=411 zJ=7.042105 hwJ=0.000390 dz=+3.247e-05
LOO model=PLLIN comp=2C drop=412 zJ=7.042062 hwJ=0.000406 dz=-9.831e-06
LOO model=PLLIN comp=2C drop=413 zJ=7.041869 hwJ=0.000379 dz=-2.031e-04
LOO model=PLLIN comp=2C drop=414 zJ=7.042020 hwJ=0.000399 dz=-5.212e-05
LOO model=PLLIN comp=2C drop=415 zJ=7.041470 hwJ=0.000456 dz=-6.016e-04
LOO model=PLLIN comp=2C drop=416 zJ=7.042318 hwJ=0.000444 dz=+2.459e-04
LOO model=PLLIN comp=2C drop=417 zJ=7.041840 hwJ=0.000419 dz=-2.321e-04
LOO model=PLLIN comp=2C drop=418 zJ=7.043538 hwJ=0.000487 dz=+1.466e-03
LOO model=PLLIN comp=2C drop=419 zJ=7.041256 hwJ=0.000349 dz=-8.157e-04
LOO model=PLLIN comp=2C drop=420 zJ=7.040835 hwJ=0.000345 dz=-1.237e-03
LOO model=PL comp=1C full zJ=7.040475 hwJ=0.000274 nHa=16
LOO model=PL comp=1C drop=405 zJ=7.040539 hwJ=0.000274 dz=+6.361e-05
LOO model=PL comp=1C drop=406 zJ=7.040503 hwJ=0.000275 dz=+2.747e-05
LOO model=PL comp=1C drop=407 zJ=7.040471 hwJ=0.000275 dz=-4.618e-06
LOO model=PL comp=1C drop=408 zJ=7.040472 hwJ=0.000275 dz=-3.313e-06
LOO model=PL comp=1C drop=409 zJ=7.040472 hwJ=0.000274 dz=-3.314e-06
LOO model=PL comp=1C drop=410 zJ=7.040478 hwJ=0.000275 dz=+2.913e-06
LOO model=PL comp=1C drop=411 zJ=7.040480 hwJ=0.000274 dz=+4.530e-06
LOO model=PL comp=1C drop=412 zJ=7.040523 hwJ=0.000272 dz=+4.829e-05
LOO model=PL comp=1C drop=413 zJ=7.040724 hwJ=0.000269 dz=+2.485e-04
LOO model=PL comp=1C drop=414 zJ=7.040515 hwJ=0.000306 dz=+3.976e-05
LOO model=PL comp=1C drop=415 zJ=7.039790 hwJ=0.000326 dz=-6.847e-04
LOO model=PL comp=1C drop=416 zJ=7.040506 hwJ=0.000285 dz=+3.085e-05
LOO model=PL comp=1C drop=417 zJ=7.040164 hwJ=0.000307 dz=-3.115e-04
LOO model=PL comp=1C drop=418 zJ=7.041008 hwJ=0.000323 dz=+5.329e-04
LOO model=PL comp=1C drop=419 zJ=7.040106 hwJ=0.000289 dz=-3.691e-04
LOO model=PL comp=1C drop=420 zJ=7.040648 hwJ=0.000284 dz=+1.724e-04
LOO model=PL comp=2C full zJ=7.040568 hwJ=0.000269 nHa=16
LOO model=PL comp=2C drop=405 zJ=7.040580 hwJ=0.000269 dz=+1.158e-05
LOO model=PL comp=2C drop=406 zJ=7.040573 hwJ=0.000269 dz=+4.563e-06
LOO model=PL comp=2C drop=407 zJ=7.040561 hwJ=0.000272 dz=-6.626e-06
LOO model=PL comp=2C drop=408 zJ=7.040561 hwJ=0.000269 dz=-6.621e-06
LOO model=PL comp=2C drop=409 zJ=7.040561 hwJ=0.000269 dz=-6.521e-06
LOO model=PL comp=2C drop=410 zJ=7.040618 hwJ=0.000270 dz=+5.039e-05
LOO model=PL comp=2C drop=411 zJ=7.040570 hwJ=0.000269 dz=+1.904e-06
LOO model=PL comp=2C drop=412 zJ=7.040578 hwJ=0.000275 dz=+9.835e-06
LOO model=PL comp=2C drop=413 zJ=7.040691 hwJ=0.000268 dz=+1.229e-04
LOO model=PL comp=2C drop=414 zJ=7.040642 hwJ=0.000326 dz=+7.370e-05
LOO model=PL comp=2C drop=415 zJ=7.040117 hwJ=0.000417 dz=-4.513e-04
LOO model=PL comp=2C drop=416 zJ=7.040477 hwJ=0.000287 dz=-9.092e-05
LOO model=PL comp=2C drop=417 zJ=7.040353 hwJ=0.000304 dz=-2.146e-04
LOO model=PL comp=2C drop=418 zJ=7.041013 hwJ=0.000327 dz=+4.446e-04
LOO model=PL comp=2C drop=419 zJ=7.040118 hwJ=0.000279 dz=-4.501e-04
LOO model=PL comp=2C drop=420 zJ=7.040820 hwJ=0.000349 dz=+2.522e-04
LOO model=RM12 comp=1C full zJ=7.040278 hwJ=0.000268 nHa=16
LOO model=RM12 comp=1C drop=405 zJ=7.040381 hwJ=0.000269 dz=+1.023e-04
LOO model=RM12 comp=1C drop=406 zJ=7.040395 hwJ=0.000269 dz=+1.164e-04
LOO model=RM12 comp=1C drop=407 zJ=7.040407 hwJ=0.000266 dz=+1.287e-04
LOO model=RM12 comp=1C drop=408 zJ=7.040404 hwJ=0.000266 dz=+1.252e-04
LOO model=RM12 comp=1C drop=409 zJ=7.040407 hwJ=0.000266 dz=+1.287e-04
LOO model=RM12 comp=1C drop=410 zJ=7.040379 hwJ=0.000269 dz=+1.006e-04
LOO model=RM12 comp=1C drop=411 zJ=7.040409 hwJ=0.000266 dz=+1.307e-04
LOO model=RM12 comp=1C drop=412 zJ=7.040412 hwJ=0.000267 dz=+1.336e-04
LOO model=RM12 comp=1C drop=413 zJ=7.040569 hwJ=0.000268 dz=+2.909e-04
LOO model=RM12 comp=1C drop=414 zJ=7.040410 hwJ=0.000292 dz=+1.315e-04
LOO model=RM12 comp=1C drop=415 zJ=7.039693 hwJ=0.000315 dz=-5.852e-04
LOO model=RM12 comp=1C drop=416 zJ=7.040397 hwJ=0.000278 dz=+1.187e-04
LOO model=RM12 comp=1C drop=417 zJ=7.040060 hwJ=0.000292 dz=-2.179e-04
LOO model=RM12 comp=1C drop=418 zJ=7.040815 hwJ=0.000315 dz=+5.367e-04
LOO model=RM12 comp=1C drop=419 zJ=7.039959 hwJ=0.000289 dz=-3.196e-04
LOO model=RM12 comp=1C drop=420 zJ=7.040678 hwJ=0.000277 dz=+4.001e-04
LOO model=RM12 comp=2C full zJ=7.040340 hwJ=0.000267 nHa=16
LOO model=RM12 comp=2C drop=405 zJ=7.040444 hwJ=0.000268 dz=+1.045e-04
LOO model=RM12 comp=2C drop=406 zJ=7.040459 hwJ=0.000267 dz=+1.197e-04
LOO model=RM12 comp=2C drop=407 zJ=7.040483 hwJ=0.000266 dz=+1.433e-04
LOO model=RM12 comp=2C drop=408 zJ=7.040480 hwJ=0.000266 dz=+1.401e-04
LOO model=RM12 comp=2C drop=409 zJ=7.040483 hwJ=0.000266 dz=+1.437e-04
LOO model=RM12 comp=2C drop=410 zJ=7.040463 hwJ=0.000268 dz=+1.232e-04
LOO model=RM12 comp=2C drop=411 zJ=7.040484 hwJ=0.000266 dz=+1.445e-04
LOO model=RM12 comp=2C drop=412 zJ=7.040454 hwJ=0.000266 dz=+1.147e-04
LOO model=RM12 comp=2C drop=413 zJ=7.040565 hwJ=0.000263 dz=+2.256e-04
LOO model=RM12 comp=2C drop=414 zJ=7.040617 hwJ=0.000290 dz=+2.771e-04
LOO model=RM12 comp=2C drop=415 zJ=7.039952 hwJ=0.000323 dz=-3.872e-04
LOO model=RM12 comp=2C drop=416 zJ=7.040305 hwJ=0.000282 dz=-3.410e-05
LOO model=RM12 comp=2C drop=417 zJ=7.040155 hwJ=0.000296 dz=-1.846e-04
LOO model=RM12 comp=2C drop=418 zJ=7.040750 hwJ=0.000325 dz=+4.106e-04
LOO model=RM12 comp=2C drop=419 zJ=7.039927 hwJ=0.000276 dz=-4.130e-04
LOO model=RM12 comp=2C drop=420 zJ=7.040876 hwJ=0.000283 dz=+5.369e-04
LOO model=RM20 comp=1C full zJ=7.040448 hwJ=0.000269 nHa=16
LOO model=RM20 comp=1C drop=405 zJ=7.040437 hwJ=0.000269 dz=-1.027e-05
LOO model=RM20 comp=1C drop=406 zJ=7.040437 hwJ=0.000269 dz=-1.027e-05
LOO model=RM20 comp=1C drop=407 zJ=7.040447 hwJ=0.000269 dz=-4.282e-07
LOO model=RM20 comp=1C drop=408 zJ=7.040447 hwJ=0.000269 dz=-4.280e-07
LOO model=RM20 comp=1C drop=409 zJ=7.040447 hwJ=0.000269 dz=-4.222e-07
LOO model=RM20 comp=1C drop=410 zJ=7.040437 hwJ=0.000269 dz=-1.046e-05
LOO model=RM20 comp=1C drop=411 zJ=7.040449 hwJ=0.000269 dz=+1.411e-06
LOO model=RM20 comp=1C drop=412 zJ=7.040470 hwJ=0.000269 dz=+2.184e-05
LOO model=RM20 comp=1C drop=413 zJ=7.040632 hwJ=0.000270 dz=+1.844e-04
LOO model=RM20 comp=1C drop=414 zJ=7.040472 hwJ=0.000294 dz=+2.446e-05
LOO model=RM20 comp=1C drop=415 zJ=7.039775 hwJ=0.000318 dz=-6.723e-04
LOO model=RM20 comp=1C drop=416 zJ=7.040479 hwJ=0.000280 dz=+3.146e-05
LOO model=RM20 comp=1C drop=417 zJ=7.040180 hwJ=0.000294 dz=-2.677e-04
LOO model=RM20 comp=1C drop=418 zJ=7.040970 hwJ=0.000317 dz=+5.224e-04
LOO model=RM20 comp=1C drop=419 zJ=7.040102 hwJ=0.000291 dz=-3.460e-04
LOO model=RM20 comp=1C drop=420 zJ=7.040706 hwJ=0.000276 dz=+2.583e-04
LOO model=RM20 comp=2C full zJ=7.040513 hwJ=0.000269 nHa=16
LOO model=RM20 comp=2C drop=405 zJ=7.040502 hwJ=0.000269 dz=-1.123e-05
LOO model=RM20 comp=2C drop=406 zJ=7.040502 hwJ=0.000269 dz=-1.123e-05
LOO model=RM20 comp=2C drop=407 zJ=7.040513 hwJ=0.000269 dz=-1.748e-07
LOO model=RM20 comp=2C drop=408 zJ=7.040513 hwJ=0.000269 dz=-5.508e-08
LOO model=RM20 comp=2C drop=409 zJ=7.040513 hwJ=0.000269 dz=+3.077e-07
LOO model=RM20 comp=2C drop=410 zJ=7.040523 hwJ=0.000269 dz=+1.020e-05
LOO model=RM20 comp=2C drop=411 zJ=7.040514 hwJ=0.000269 dz=+9.620e-07
LOO model=RM20 comp=2C drop=412 zJ=7.040505 hwJ=0.000269 dz=-7.650e-06
LOO model=RM20 comp=2C drop=413 zJ=7.040615 hwJ=0.000266 dz=+1.020e-04
LOO model=RM20 comp=2C drop=414 zJ=7.040645 hwJ=0.000296 dz=+1.320e-04
LOO model=RM20 comp=2C drop=415 zJ=7.040021 hwJ=0.000326 dz=-4.924e-04
LOO model=RM20 comp=2C drop=416 zJ=7.040479 hwJ=0.000321 dz=-3.386e-05
LOO model=RM20 comp=2C drop=417 zJ=7.040261 hwJ=0.000298 dz=-2.518e-04
LOO model=RM20 comp=2C drop=418 zJ=7.040914 hwJ=0.000330 dz=+4.009e-04
LOO model=RM20 comp=2C drop=419 zJ=7.040083 hwJ=0.000278 dz=-4.297e-04
LOO model=RM20 comp=2C drop=420 zJ=7.040920 hwJ=0.000283 dz=+4.065e-04
LOO model=RM6 comp=1C full zJ=7.038408 hwJ=0.000234 nHa=16
LOO model=RM6 comp=1C drop=405 zJ=7.038408 hwJ=0.000234 dz=+3.136e-12
LOO model=RM6 comp=1C drop=406 zJ=7.038408 hwJ=0.000234 dz=+3.136e-12
LOO model=RM6 comp=1C drop=407 zJ=7.038408 hwJ=0.000234 dz=-1.111e-07
LOO model=RM6 comp=1C drop=408 zJ=7.038408 hwJ=0.000234 dz=-3.430e-08
LOO model=RM6 comp=1C drop=409 zJ=7.038395 hwJ=0.000235 dz=-1.360e-05
LOO model=RM6 comp=1C drop=410 zJ=7.038408 hwJ=0.000234 dz=-2.430e-09
LOO model=RM6 comp=1C drop=411 zJ=7.038430 hwJ=0.000231 dz=+2.131e-05
LOO model=RM6 comp=1C drop=412 zJ=7.038697 hwJ=0.000229 dz=+2.890e-04
LOO model=RM6 comp=1C drop=413 zJ=7.038793 hwJ=0.000227 dz=+3.850e-04
LOO model=RM6 comp=1C drop=414 zJ=7.039651 hwJ=0.000221 dz=+1.242e-03
LOO model=RM6 comp=1C drop=415 zJ=7.038080 hwJ=0.000298 dz=-3.284e-04
LOO model=RM6 comp=1C drop=416 zJ=7.038772 hwJ=0.000226 dz=+3.638e-04
LOO model=RM6 comp=1C drop=417 zJ=7.038205 hwJ=0.000291 dz=-2.032e-04
LOO model=RM6 comp=1C drop=418 zJ=7.038026 hwJ=0.000280 dz=-3.825e-04
LOO model=RM6 comp=1C drop=419 zJ=7.036760 hwJ=0.000240 dz=-1.648e-03
LOO model=RM6 comp=1C drop=420 zJ=7.036498 hwJ=0.000229 dz=-1.910e-03
LOO model=RM6 comp=2C full zJ=7.038408 hwJ=0.000234 nHa=16
LOO model=RM6 comp=2C drop=405 zJ=7.038408 hwJ=0.000234 dz=+3.136e-12
LOO model=RM6 comp=2C drop=406 zJ=7.038408 hwJ=0.000234 dz=+3.136e-12
LOO model=RM6 comp=2C drop=407 zJ=7.038408 hwJ=0.000234 dz=-1.111e-07
LOO model=RM6 comp=2C drop=408 zJ=7.038408 hwJ=0.000234 dz=-3.430e-08
LOO model=RM6 comp=2C drop=409 zJ=7.038395 hwJ=0.000235 dz=-1.360e-05
LOO model=RM6 comp=2C drop=410 zJ=7.038408 hwJ=0.000234 dz=-2.430e-09
LOO model=RM6 comp=2C drop=411 zJ=7.038430 hwJ=0.000231 dz=+2.131e-05
LOO model=RM6 comp=2C drop=412 zJ=7.038697 hwJ=0.000229 dz=+2.890e-04
LOO model=RM6 comp=2C drop=413 zJ=7.038793 hwJ=0.000227 dz=+3.850e-04
LOO model=RM6 comp=2C drop=414 zJ=7.039651 hwJ=0.000221 dz=+1.242e-03
LOO model=RM6 comp=2C drop=415 zJ=7.038080 hwJ=0.000298 dz=-3.284e-04
LOO model=RM6 comp=2C drop=416 zJ=7.038772 hwJ=0.000226 dz=+3.638e-04
LOO model=RM6 comp=2C drop=417 zJ=7.038205 hwJ=0.000291 dz=-2.032e-04
LOO model=RM6 comp=2C drop=418 zJ=7.038026 hwJ=0.000280 dz=-3.825e-04
LOO model=RM6 comp=2C drop=419 zJ=7.036760 hwJ=0.000240 dz=-1.648e-03
LOO model=RM6 comp=2C drop=420 zJ=7.036501 hwJ=0.000230 dz=-1.908e-03
LOO model=SPL comp=1C full zJ=7.042329 hwJ=0.000417 nHa=16
LOO model=SPL comp=1C drop=405 zJ=7.042515 hwJ=0.000531 dz=+1.863e-04
LOO model=SPL comp=1C drop=406 zJ=7.042414 hwJ=0.000432 dz=+8.520e-05
LOO model=SPL comp=1C drop=407 zJ=7.042449 hwJ=0.000435 dz=+1.203e-04
LOO model=SPL comp=1C drop=408 zJ=7.042460 hwJ=0.000437 dz=+1.311e-04
LOO model=SPL comp=1C drop=409 zJ=7.042447 hwJ=0.000437 dz=+1.174e-04
LOO model=SPL comp=1C drop=410 zJ=7.042365 hwJ=0.000429 dz=+3.609e-05
LOO model=SPL comp=1C drop=411 zJ=7.042362 hwJ=0.000421 dz=+3.278e-05
LOO model=SPL comp=1C drop=412 zJ=7.042327 hwJ=0.000433 dz=-2.053e-06
LOO model=SPL comp=1C drop=413 zJ=7.042076 hwJ=0.000417 dz=-2.526e-04
LOO model=SPL comp=1C drop=414 zJ=7.042289 hwJ=0.000425 dz=-4.051e-05
LOO model=SPL comp=1C drop=415 zJ=7.041721 hwJ=0.000481 dz=-6.085e-04
LOO model=SPL comp=1C drop=416 zJ=7.042596 hwJ=0.000460 dz=+2.667e-04
LOO model=SPL comp=1C drop=417 zJ=7.042077 hwJ=0.000438 dz=-2.519e-04
LOO model=SPL comp=1C drop=418 zJ=7.044769 hwJ=0.000552 dz=+2.440e-03
LOO model=SPL comp=1C drop=419 zJ=7.041464 hwJ=0.000354 dz=-8.648e-04
LOO model=SPL comp=1C drop=420 zJ=7.039870 hwJ=0.000400 dz=-2.459e-03
LOO model=SPL comp=2C full zJ=7.040158 hwJ=0.000497 nHa=16
LOO model=SPL comp=2C drop=405 zJ=7.040111 hwJ=0.000553 dz=-4.624e-05
LOO model=SPL comp=2C drop=406 zJ=7.040381 hwJ=0.000857 dz=+2.230e-04
LOO model=SPL comp=2C drop=407 zJ=7.039541 hwJ=0.000891 dz=-6.171e-04
LOO model=SPL comp=2C drop=408 zJ=7.039545 hwJ=0.000861 dz=-6.129e-04
LOO model=SPL comp=2C drop=409 zJ=7.039573 hwJ=0.000876 dz=-5.848e-04
LOO model=SPL comp=2C drop=410 zJ=7.039391 hwJ=0.000607 dz=-7.664e-04
LOO model=SPL comp=2C drop=411 zJ=7.040107 hwJ=0.000503 dz=-5.014e-05
LOO model=SPL comp=2C drop=412 zJ=7.040036 hwJ=0.000522 dz=-1.211e-04
LOO model=SPL comp=2C drop=413 zJ=7.040068 hwJ=0.000513 dz=-8.989e-05
LOO model=SPL comp=2C drop=414 zJ=7.040158 hwJ=0.000516 dz=+5.600e-07
LOO model=SPL comp=2C drop=415 zJ=7.040621 hwJ=0.000579 dz=+4.634e-04
LOO model=SPL comp=2C drop=416 zJ=7.040746 hwJ=0.000596 dz=+5.884e-04
LOO model=SPL comp=2C drop=417 zJ=7.040358 hwJ=0.000620 dz=+2.003e-04
LOO model=SPL comp=2C drop=418 zJ=7.042830 hwJ=0.001393 dz=+2.672e-03
LOO model=SPL comp=2C drop=419 zJ=7.041418 hwJ=0.000502 dz=+1.260e-03
LOO model=SPL comp=2C drop=420 zJ=7.040254 hwJ=0.000477 dz=+9.641e-05

=== 7. SYNTHETIC controls (NOT data)
SYNTHETIC kind=noisefree model=P0 comp=1C z_true=7.04510 zJ=7.045062 bias=-3.848e-05 hwJ=0.000275 chi2=2.2351 zHb=7.045652 zHa=7.045053
SYNTHETIC kind=noisefree model=P0 comp=2C z_true=7.04510 zJ=7.045062 bias=-3.848e-05 hwJ=0.000275 chi2=2.2351 zHb=7.045652 zHa=7.045053
SYNTHETIC kind=noisefree model=P1 comp=1C z_true=7.04510 zJ=7.045100 bias=-3.189e-10 hwJ=0.000280 chi2=-0.0000 zHb=7.045100 zHa=7.045100
SYNTHETIC kind=noisefree model=P1 comp=2C z_true=7.04510 zJ=7.045102 bias=+1.765e-06 hwJ=0.000344 chi2=-0.0000 zHb=7.045100 zHa=7.045102
SYNTHETIC kind=noisefree model=P2 comp=1C z_true=7.04510 zJ=7.045100 bias=-4.208e-10 hwJ=0.000338 chi2=0.0000 zHb=7.045100 zHa=7.045100
SYNTHETIC kind=noisefree model=P2 comp=2C z_true=7.04510 zJ=7.045101 bias=+1.392e-06 hwJ=0.000398 chi2=-0.0000 zHb=7.045100 zHa=7.045101
SYNTHETIC kind=noisefree model=P3 comp=1C z_true=7.04510 zJ=7.045100 bias=+1.069e-09 hwJ=0.000384 chi2=-0.0000 zHb=7.045100 zHa=7.045100
SYNTHETIC kind=noisefree model=P3 comp=2C z_true=7.04510 zJ=7.045102 bias=+2.240e-06 hwJ=0.000498 chi2=-0.0000 zHb=7.045100 zHa=7.045102
SYNTHETIC kind=noisefree model=PLLIN comp=1C z_true=7.04510 zJ=7.045100 bias=-1.028e-08 hwJ=0.000281 chi2=-0.0000 zHb=7.045100 zHa=7.045099
SYNTHETIC kind=noisefree model=PLLIN comp=2C z_true=7.04510 zJ=7.045102 bias=+1.748e-06 hwJ=0.000345 chi2=-0.0000 zHb=7.045100 zHa=7.045101
SYNTHETIC kind=noisefree model=PL comp=1C z_true=7.04510 zJ=7.045097 bias=-3.037e-06 hwJ=0.000279 chi2=0.0008 zHb=7.045088 zHa=7.045097
SYNTHETIC kind=noisefree model=PL comp=2C z_true=7.04510 zJ=7.045101 bias=+5.763e-07 hwJ=0.000302 chi2=0.0007 zHb=7.045088 zHa=7.045101
SYNTHETIC kind=noisefree model=RM12 comp=1C z_true=7.04510 zJ=7.045084 bias=-1.584e-05 hwJ=0.000275 chi2=1.9283 zHb=7.044737 zHa=7.045089
SYNTHETIC kind=noisefree model=RM12 comp=2C z_true=7.04510 zJ=7.045084 bias=-1.584e-05 hwJ=0.000275 chi2=1.9283 zHb=7.044737 zHa=7.045089
SYNTHETIC kind=noisefree model=RM20 comp=1C z_true=7.04510 zJ=7.045103 bias=+2.646e-06 hwJ=0.000276 chi2=4.7914 zHb=7.044737 zHa=7.045108
SYNTHETIC kind=noisefree model=RM20 comp=2C z_true=7.04510 zJ=7.045103 bias=+2.646e-06 hwJ=0.000276 chi2=4.7914 zHb=7.044737 zHa=7.045108
SYNTHETIC kind=noisefree model=RM6 comp=1C z_true=7.04510 zJ=7.041992 bias=-3.108e-03 hwJ=0.000237 chi2=520.7946 zHb=7.044737 zHa=7.041964
SYNTHETIC kind=noisefree model=RM6 comp=2C z_true=7.04510 zJ=7.041992 bias=-3.108e-03 hwJ=0.000237 chi2=520.7946 zHb=7.044737 zHa=7.041964
SYNTHETIC kind=noisefree model=SPL comp=1C z_true=7.04510 zJ=7.045100 bias=+1.001e-09 hwJ=0.000430 chi2=0.0000 zHb=7.045100 zHa=7.045100
SYNTHETIC kind=noisefree model=SPL comp=2C z_true=7.04510 zJ=7.045099 bias=-1.272e-06 hwJ=0.000536 chi2=-0.0000 zHb=7.045100 zHa=7.045099
SYNTHETIC kind=edge model=P0 comp=1C z_true=7.04510 zJ=7.044586 bias=-5.142e-04 hwJ=0.000269 chi2=58.6663 zHb=7.045652 zHa=7.044571
SYNTHETIC kind=edge model=P0 comp=2C z_true=7.04510 zJ=7.044586 bias=-5.142e-04 hwJ=0.000285 chi2=58.6663 zHb=7.045652 zHa=7.044571
SYNTHETIC kind=edge model=P1 comp=1C z_true=7.04510 zJ=7.044847 bias=-2.532e-04 hwJ=0.000267 chi2=35.7022 zHb=7.045100 zHa=7.044843
SYNTHETIC kind=edge model=P1 comp=2C z_true=7.04510 zJ=7.046179 bias=+1.079e-03 hwJ=0.000397 chi2=10.4513 zHb=7.045100 zHa=7.047453
SYNTHETIC kind=edge model=P2 comp=1C z_true=7.04510 zJ=7.046790 bias=+1.690e-03 hwJ=0.000339 chi2=6.6807 zHb=7.045100 zHa=7.046824
SYNTHETIC kind=edge model=P2 comp=2C z_true=7.04510 zJ=7.047140 bias=+2.040e-03 hwJ=0.000431 chi2=4.8547 zHb=7.045100 zHa=7.047208
SYNTHETIC kind=edge model=P3 comp=1C z_true=7.04510 zJ=7.047110 bias=+2.010e-03 hwJ=0.000418 chi2=4.8212 zHb=7.045100 zHa=7.047173
SYNTHETIC kind=edge model=P3 comp=2C z_true=7.04510 zJ=7.047110 bias=+2.010e-03 hwJ=0.000625 chi2=4.8212 zHb=7.045100 zHa=7.047173
SYNTHETIC kind=edge model=PLLIN comp=1C z_true=7.04510 zJ=7.044847 bias=-2.532e-04 hwJ=0.000267 chi2=35.7015 zHb=7.045100 zHa=7.044843
SYNTHETIC kind=edge model=PLLIN comp=2C z_true=7.04510 zJ=7.046179 bias=+1.079e-03 hwJ=0.000397 chi2=10.4511 zHb=7.045100 zHa=7.047457
SYNTHETIC kind=edge model=PL comp=1C z_true=7.04510 zJ=7.044659 bias=-4.407e-04 hwJ=0.000267 chi2=45.7316 zHb=7.045088 zHa=7.044653
SYNTHETIC kind=edge model=PL comp=2C z_true=7.04510 zJ=7.044659 bias=-4.407e-04 hwJ=0.000267 chi2=45.7316 zHb=7.045088 zHa=7.044653
SYNTHETIC kind=edge model=RM12 comp=1C z_true=7.04510 zJ=7.044629 bias=-4.708e-04 hwJ=0.000271 chi2=60.4627 zHb=7.044737 zHa=7.044628
SYNTHETIC kind=edge model=RM12 comp=2C z_true=7.04510 zJ=7.044665 bias=-4.351e-04 hwJ=0.000265 chi2=57.9246 zHb=7.044737 zHa=7.044664
SYNTHETIC kind=edge model=RM20 comp=1C z_true=7.04510 zJ=7.044643 bias=-4.570e-04 hwJ=0.000271 chi2=64.9329 zHb=7.044737 zHa=7.044642
SYNTHETIC kind=edge model=RM20 comp=2C z_true=7.04510 zJ=7.044672 bias=-4.282e-04 hwJ=0.000264 chi2=60.5970 zHb=7.044737 zHa=7.044671
SYNTHETIC kind=edge model=RM6 comp=1C z_true=7.04510 zJ=7.042095 bias=-3.005e-03 hwJ=0.000232 chi2=859.0418 zHb=7.044737 zHa=7.042069
SYNTHETIC kind=edge model=RM6 comp=2C z_true=7.04510 zJ=7.042095 bias=-3.005e-03 hwJ=0.000232 chi2=859.0418 zHb=7.044737 zHa=7.042069
SYNTHETIC kind=edge model=SPL comp=1C z_true=7.04510 zJ=7.047155 bias=+2.055e-03 hwJ=0.000477 chi2=4.7877 zHb=7.045100 zHa=7.047238
SYNTHETIC kind=edge model=SPL comp=2C z_true=7.04510 zJ=7.045879 bias=+7.788e-04 hwJ=0.000627 chi2=3.3986 zHb=7.045100 zHa=7.045924
SYNTHETIC setup z_true=7.04510 P1-params Hb[c0 c1 A]=[0.362867 0.0200698 102.818] Ha[c0 c1 A]=[0.440709 -0.0374744 970.41] sigHb=600 sigHa=500 (from real-data P1/1C fit at z=7.04049)
SYNTHETIC SUMMARY kind=noisy model=P1 comp=1C N=30 z_true=7.04510 mean_bias=+3.786e-05 sd=3.334e-04 mean_hw=2.787e-04 coverage_1sigma=14/30
SYNTHETIC SUMMARY kind=noisy model=P2 comp=1C N=30 z_true=7.04510 mean_bias=+7.147e-05 sd=4.116e-04 mean_hw=3.394e-04 coverage_1sigma=19/30
SYNTHETIC SUMMARY kind=noisy model=RM12 comp=1C N=30 z_true=7.04510 mean_bias=+2.886e-05 sd=2.299e-04 mean_hw=2.759e-04 coverage_1sigma=23/30
SYNTHETIC SUMMARY kind=noisy model=SPL comp=1C N=30 z_true=7.04510 mean_bias=+6.059e-06 sd=3.651e-04 mean_hw=4.456e-04 coverage_1sigma=24/30

=== 8. existing Fortran reference lines (verbatim copy of lines from fixtures/reference/<sha>/zinvest.kv, read-only)
7dd9e741c4c659542586e25b4184262d65e844402ce1f90b85b5ee5c3b18f1e7  /workspace/verify-main/repo/fixtures/reference/c0b878576d7d7ec723c5ee526d29715fb672d81e45bc8ba4e02598ce8b9c5ee7/zinvest.kv
source_sha256=c0b878576d7d7ec723c5ee526d29715fb672d81e45bc8ba4e02598ce8b9c5ee7
a.lsf.joint.z=7.04050000E+00
a.lsf.joint.z_lo_dchi2_1=7.04022000E+00
a.lsf.joint.z_hi_dchi2_1=7.04077000E+00
a.lsf.joint.chi2_min=1.14709875E+02
a.point.joint.z=7.04050000E+00
a.point.joint.z_lo_dchi2_1=7.04023000E+00
a.point.joint.z_hi_dchi2_1=7.04077000E+00
a.point.joint.chi2_min=1.14670230E+02
a.centroid.Hbeta.z=7.03846105E+00
a.centroid.Hbeta.z_err=2.20719560E-03
a.centroid.Halpha.z=7.04226243E+00
a.centroid.Halpha.z_err=2.71350905E-04

=== 8b. sigma-grid boundary tally (awk/gridtally.awk)
GRIDTALLY FIT records=180 (2C=90)
GRIDTALLY 2C broad sigma at lower bound 900: 56 ; at upper bound 3000: 1 (of 90)
GRIDTALLY 2C narrow sigma at lower bound 0: 11 ; at upper bound 600: 16 (of 90)
GRIDTALLY 1C Halpha sigma at 0: 5 ; at 4000: 0 ; Hbeta at 0: 0 ; at 4000: 0

=== 8c. PREREG range R3 over exactly the 7 scenarios (awk/r3strict.awk)
R3STRICT records=140 range=[7.035841 (P3_1C_D3), 7.044288 (PL_1C_D4)] width=0.008447
R3STRICT published 7.0451 inside: 0 ; distance to nearest edge=0.000812

=== 9. analysis (PREREG criteria applied by octave/cc_report.m)
REPORT records parsed: 180 (expect 180)

REPORT A. D0 baseline (BW=12), all 20 models
REPORT model  C          zJ       hwJ   hwJscal       zHb       zHa     chi2   k  dof chi2red       AIC       BIC    dBIC flags
REPORT RM6_1C     7.038408  0.000234  0.001639  7.038698  7.038405 1271.702   9   26  48.912  1289.702  1303.700 1216.85
REPORT RM12_1C    7.040278  0.000268  0.000552  7.038287  7.040305  118.789   7   28   4.242   132.789   143.676   56.83
REPORT RM20_1C    7.040448  0.000269  0.000548  7.037888  7.040483  116.440   7   28   4.159   130.440   141.328   54.48
REPORT P0_1C      7.040445  0.000270  0.000547  7.038601  7.040470  115.261   7   28   4.117   129.261   140.149   53.30
REPORT P1_1C      7.040487  0.000276  0.000577  7.037940  7.040524  113.311   9   26   4.358   131.311   145.310   58.46
REPORT P2_1C      7.041442  0.000324  0.000591  7.038509  7.041492   80.044  11   24   3.335   102.044   119.152   32.30
REPORT P3_1C      7.041922  0.000371  0.000657  7.038342  7.042005   69.167  13   22   3.144    95.167   115.386   28.54
REPORT PL_1C      7.040475  0.000274  0.000573  7.037958  7.040511  113.477   9   26   4.364   131.476   145.475   58.63
REPORT PLLIN_1C   7.040487  0.000276  0.000588  7.037941  7.040524  113.306  10   25   4.532   133.306   148.859   62.01
REPORT SPL_1C     7.042329  0.000417  0.000727  7.038624  7.042435   66.748  13   22   3.034    92.748   112.968   26.12
REPORT RM6_2C     7.038408  0.000234  0.001706  7.038698  7.038405 1271.702  11   24  52.988  1293.702  1310.811 1223.96
REPORT RM12_2C    7.040340  0.000267  0.000540  7.038287  7.040367  106.521   9   26   4.097   124.521   138.519   51.67
REPORT RM20_2C    7.040513  0.000269  0.000540  7.037888  7.040549  105.078   9   26   4.042   123.078   137.076   50.23
REPORT P0_2C      7.040508  0.000271  0.000541  7.038601  7.040534  103.903   9   26   3.996   121.903   135.901   49.05
REPORT P1_2C      7.042072  0.000394  0.000682  7.037940  7.042179   72.008  11   24   3.000    94.008   111.117   24.27
REPORT P2_2C      7.042245  0.000398  0.000624  7.038509  7.042342   54.032  13   22   2.456    80.032   100.252   13.40
REPORT P3_2C      7.042213  0.000400  0.000650  7.038342  7.042309   52.871  15   20   2.644    82.871   106.201   19.35
REPORT PL_2C      7.040568  0.000269  0.000543  7.037958  7.040603   97.501  11   24   4.062   119.501   136.609   49.76
REPORT PLLIN_2C   7.042072  0.000394  0.000697  7.037941  7.042179   72.004  12   23   3.131    96.004   114.668   27.82
REPORT SPL_2C     7.040158  0.000497  0.000643  7.038624  7.040217   33.518  15   20   1.676    63.518    86.848    0.00

REPORT B. selection by lowest BIC = chi2 + k ln n (n = 35)
REPORT best=SPL_2C BIC=86.848 runner-up=P2_2C dBIC=13.404
REPORT selection status: selected
REPORT indistinguishable set (dBIC<2): SPL_2C
REPORT admissible set (dBIC<=10): SPL_2C
REPORT QBIC (EXPLORATORY) c_hat=1.6759 best=SPL_2C ; BIC and QBIC pick the same model: 1  => robust
REPORT BIC with k_cont=0 for RM (EXPLORATORY) best=SPL_2C
REPORT D1 best BIC model=P0_2C (BIC=62.653) ; D0 best=SPL_2C ; selection persistent: 0

REPORT C. stability |z(D1)-z(D0)| < sigma_J(D0), plus shifts in units of sigma_J(D0)
REPORT model        zJ(D0)     sigma       D1       D2       D3       D4   ERRALL  ERREDGE  BW8/BW6 STABLE
REPORT RM6_1C     7.038408  0.000234    -8.16    -9.12    -0.49   +23.62    -1.14    -1.14    +0.00/+0.00      0
REPORT RM12_1C    7.040278  0.000268    +1.49    +0.44   +11.98   +13.43   -10.11   -10.11    +0.00/+0.00      0
REPORT RM20_1C    7.040448  0.000269    +0.96    -0.21   +10.86   +11.57    -7.20    -7.20    +0.00/+0.00      1
REPORT P0_1C      7.040445  0.000270    +1.08    -0.01   +11.21   +12.54    -6.12    -6.12    +0.05/+0.13      0
REPORT P1_1C      7.040487  0.000276    -1.04    -1.67    +5.54    +5.45   -11.01   -11.01    +1.25/+3.33      0
REPORT P2_1C      7.041442  0.000324    -5.13    -7.67    -2.48    -2.17    -9.81    -9.81    +1.72/+1.86      0
REPORT P3_1C      7.041922  0.000371    -5.03    -3.47   -16.39   -11.13   -10.29   -10.29    -3.09/-5.88      0
REPORT PL_1C      7.040475  0.000274    +0.63    -0.07   +11.73   +13.92   -11.31   -11.31    +0.34/+0.50      1
REPORT PLLIN_1C   7.040487  0.000276    -1.04    -1.67    +5.54    +5.45   -11.01   -11.01    +1.25/+3.33      0
REPORT SPL_1C     7.042329  0.000417    -5.90    -3.20   -12.77    -9.47    -8.90    -8.90    -0.51/-7.40      0
REPORT RM6_2C     7.038408  0.000234    -8.15    -7.18    -6.05    +5.02    +0.22    +0.22    +0.00/+0.00      0
REPORT RM12_2C    7.040340  0.000267    +2.01    +0.98    +3.72    -3.52    -8.44    -8.44    +0.00/+0.04      0
REPORT RM20_2C    7.040513  0.000269    +1.51    +0.48    +1.26    -7.99   -10.18   -10.18    +0.00/+0.04      0
REPORT P0_2C      7.040508  0.000271    +1.53    +0.44    +1.56    -6.49    -7.20    -7.20    -0.08/+0.02      0
REPORT P1_2C      7.042072  0.000394    -3.14    -3.70    -2.92    -8.73   -10.73   -10.73    +0.17/+0.19      0
REPORT P2_2C      7.042245  0.000398    -4.38    -1.56    -0.85    -8.69    -9.36    -9.36    -0.27/-0.36      0
REPORT P3_2C      7.042213  0.000400    -4.53    -3.09    -9.78    -6.92    -9.80    -9.80    -3.59/-6.18      0
REPORT PL_2C      7.040568  0.000269    +0.94    +0.18    +1.30    -7.21   -10.15   -10.15    +0.02/+1.94      1
REPORT PLLIN_2C   7.042072  0.000394    -3.14    -3.70    -2.92    -8.73   -10.73   -10.73    +0.17/+0.19      0
REPORT SPL_2C     7.040158  0.000497    +0.19    +1.85    -2.26    -2.57    -2.97    -2.97    -2.18/+0.01      1
REPORT model-selected set for the stability statement: SPL_2C
REPORT every member stable (PREREG sec. 5): 1 ; members stable: true
REPORT number of the 20 models that are stable: 4/20

REPORT D. gap to published z=7.0451 (Fortran centroid 7.04221, dz=0.00289 = 107.7 km/s)
REPORT R1 (20 models, D0): [7.038408, 7.042329] width=0.003921 ; published 7.0451 inside: 0 ; distance to nearest edge=0.002771 (10.1 x median sigma_J(D0)=0.000275)
REPORT R2 (admissible set, D0): [7.040158, 7.040158] width=0.000000 ; published 7.0451 inside: 0 ; distance to nearest edge=0.004942 (18.0 x median sigma_J(D0)=0.000275)
REPORT R3 (20 models x 7 scenarios + BW8/6): [7.035841, 7.044288] width=0.008447 ; published 7.0451 inside: 0 ; distance to nearest edge=0.000812 (3.0 x median sigma_J(D0)=0.000275)
REPORT highest D0 z: SPL_1C zJ=7.042329 (hwJ=0.000417, 6.65 sigma from 7.0451)
REPORT D0 models within 3 sigma_J of 7.0451: 

REPORT E. Halpha leave-one-out at D0 (influential: |dz| >= 0.5 sigma_J)
REPORT RM6_1C    m=16 jackknifeSD=0.002785 (11.90 sigma) max|dz|=-1.910e-03 at px 420 (-8.16 sigma) influential px: [412 413 414 415 416 417 418 419 420]
REPORT RM12_1C   m=16 jackknifeSD=0.000999 (3.73 sigma) max|dz|=-5.850e-04 at px 415 (-2.18 sigma) influential px: [412 413 415 417 418 419 420]
REPORT RM20_1C   m=16 jackknifeSD=0.000975 (3.63 sigma) max|dz|=-6.730e-04 at px 415 (-2.50 sigma) influential px: [413 415 417 418 419 420]
REPORT P0_1C     m=16 jackknifeSD=0.000988 (3.66 sigma) max|dz|=-6.700e-04 at px 415 (-2.48 sigma) influential px: [413 415 417 418 419 420]
REPORT P1_1C     m=16 jackknifeSD=0.001039 (3.77 sigma) max|dz|=-6.890e-04 at px 415 (-2.50 sigma) influential px: [413 415 417 418 419 420]
REPORT P2_1C     m=16 jackknifeSD=0.002960 (9.13 sigma) max|dz|=2.145e-03 at px 418 (6.62 sigma) influential px: [410 412 414 416 417 418 419 420]
REPORT P3_1C     m=16 jackknifeSD=0.003128 (8.43 sigma) max|dz|=2.385e-03 at px 418 (6.43 sigma) influential px: [415 416 417 418 419 420]
REPORT PL_1C     m=16 jackknifeSD=0.001009 (3.68 sigma) max|dz|=-6.850e-04 at px 415 (-2.50 sigma) influential px: [413 415 417 418 419 420]
REPORT PLLIN_1C  m=16 jackknifeSD=0.001039 (3.76 sigma) max|dz|=-6.880e-04 at px 415 (-2.49 sigma) influential px: [413 415 417 418 419 420]
REPORT SPL_1C    m=16 jackknifeSD=0.003536 (8.48 sigma) max|dz|=-2.459e-03 at px 420 (-5.90 sigma) influential px: [413 415 416 417 418 419 420]
REPORT RM6_2C    m=16 jackknifeSD=0.002783 (11.89 sigma) max|dz|=-1.907e-03 at px 420 (-8.15 sigma) influential px: [412 413 414 415 416 417 418 419 420]
REPORT RM12_2C   m=16 jackknifeSD=0.000939 (3.52 sigma) max|dz|=5.360e-04 at px 420 (2.01 sigma) influential px: [407 408 409 411 413 414 415 417 418 419 420]
REPORT RM20_2C   m=16 jackknifeSD=0.000890 (3.31 sigma) max|dz|=-4.920e-04 at px 415 (-1.83 sigma) influential px: [415 417 418 419 420]
REPORT P0_2C     m=16 jackknifeSD=0.000915 (3.38 sigma) max|dz|=-5.110e-04 at px 415 (-1.89 sigma) influential px: [414 415 417 418 419 420]
REPORT P1_2C     m=16 jackknifeSD=0.002113 (5.36 sigma) max|dz|=1.466e-03 at px 418 (3.72 sigma) influential px: [413 415 416 417 418 419 420]
REPORT P2_2C     m=16 jackknifeSD=0.002628 (6.60 sigma) max|dz|=1.898e-03 at px 418 (4.77 sigma) influential px: [415 416 418 419 420]
REPORT P3_2C     m=16 jackknifeSD=0.002671 (6.68 sigma) max|dz|=1.953e-03 at px 418 (4.88 sigma) influential px: [416 418 419 420]
REPORT PL_2C     m=16 jackknifeSD=0.000834 (3.10 sigma) max|dz|=-4.510e-04 at px 415 (-1.68 sigma) influential px: [415 417 418 419 420]
REPORT PLLIN_2C  m=16 jackknifeSD=0.002113 (5.36 sigma) max|dz|=1.466e-03 at px 418 (3.72 sigma) influential px: [413 415 416 417 418 419 420]
REPORT SPL_2C    m=16 jackknifeSD=0.003164 (6.37 sigma) max|dz|=2.672e-03 at px 418 (5.38 sigma) influential px: [407 408 409 410 415 416 418 419]
REPORT driver: pixel 415 has the largest |dz_i| in 9 of 20 model fits; full tally: [415 418 420;9 7 4]

REPORT F. SYNTHETIC controls (generated from the P1/1C fit; NOT data)
REPORT SYNTHETIC noisefree P0     1C bias=-3.848e-05 family=0
REPORT SYNTHETIC noisefree P0     2C bias=-3.848e-05 family=0
REPORT SYNTHETIC noisefree P1     1C bias=-3.189e-10 family=1
REPORT SYNTHETIC noisefree P1     2C bias=+1.765e-06 family=1
REPORT SYNTHETIC noisefree P2     1C bias=-4.208e-10 family=1
REPORT SYNTHETIC noisefree P2     2C bias=+1.392e-06 family=1
REPORT SYNTHETIC noisefree P3     1C bias=+1.069e-09 family=1
REPORT SYNTHETIC noisefree P3     2C bias=+2.240e-06 family=1
REPORT SYNTHETIC noisefree PLLIN  1C bias=-1.028e-08 family=1
REPORT SYNTHETIC noisefree PLLIN  2C bias=+1.748e-06 family=1
REPORT SYNTHETIC noisefree PL     1C bias=-3.037e-06 family=0
REPORT SYNTHETIC noisefree PL     2C bias=+5.763e-07 family=0
REPORT SYNTHETIC noisefree RM12   1C bias=-1.584e-05 family=0
REPORT SYNTHETIC noisefree RM12   2C bias=-1.584e-05 family=0
REPORT SYNTHETIC noisefree RM20   1C bias=+2.646e-06 family=0
REPORT SYNTHETIC noisefree RM20   2C bias=+2.646e-06 family=0
REPORT SYNTHETIC noisefree RM6    1C bias=-3.108e-03 family=0
REPORT SYNTHETIC noisefree RM6    2C bias=-3.108e-03 family=0
REPORT SYNTHETIC noisefree SPL    1C bias=+1.001e-09 family=1
REPORT SYNTHETIC noisefree SPL    2C bias=-1.272e-06 family=1
REPORT SYNTHETIC edge-deficit P0     1C bias=-5.142e-04 chi2=58.666
REPORT SYNTHETIC edge-deficit P0     2C bias=-5.142e-04 chi2=58.666
REPORT SYNTHETIC edge-deficit P1     1C bias=-2.532e-04 chi2=35.702
REPORT SYNTHETIC edge-deficit P1     2C bias=+1.079e-03 chi2=10.451
REPORT SYNTHETIC edge-deficit P2     1C bias=+1.690e-03 chi2=6.681
REPORT SYNTHETIC edge-deficit P2     2C bias=+2.040e-03 chi2=4.855
REPORT SYNTHETIC edge-deficit P3     1C bias=+2.010e-03 chi2=4.821
REPORT SYNTHETIC edge-deficit P3     2C bias=+2.010e-03 chi2=4.821
REPORT SYNTHETIC edge-deficit PLLIN  1C bias=-2.532e-04 chi2=35.702
REPORT SYNTHETIC edge-deficit PLLIN  2C bias=+1.079e-03 chi2=10.451
REPORT SYNTHETIC edge-deficit PL     1C bias=-4.407e-04 chi2=45.732
REPORT SYNTHETIC edge-deficit PL     2C bias=-4.407e-04 chi2=45.732
REPORT SYNTHETIC edge-deficit RM12   1C bias=-4.708e-04 chi2=60.463
REPORT SYNTHETIC edge-deficit RM12   2C bias=-4.351e-04 chi2=57.925
REPORT SYNTHETIC edge-deficit RM20   1C bias=-4.570e-04 chi2=64.933
REPORT SYNTHETIC edge-deficit RM20   2C bias=-4.282e-04 chi2=60.597
REPORT SYNTHETIC edge-deficit RM6    1C bias=-3.005e-03 chi2=859.042
REPORT SYNTHETIC edge-deficit RM6    2C bias=-3.005e-03 chi2=859.042
REPORT SYNTHETIC edge-deficit SPL    1C bias=+2.055e-03 chi2=4.788
REPORT SYNTHETIC edge-deficit SPL    2C bias=+7.788e-04 chi2=3.399
=== run.sh finished 2026-10-26 21:09:00 PDT
```
