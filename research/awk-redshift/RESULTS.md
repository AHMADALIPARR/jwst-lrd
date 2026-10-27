<!-- SPDX-License-Identifier: AGPL-3.0-only -->
# Abell 2744-QSO1 — independent awk signal-processing redshift cross-check

Run: 2026-10-26 18:00–18:08 PDT (America/Los_Angeles), `./run.sh` (mawk 1.3.4; no gawk on the box; no Python/JS/TS anywhere).
Data: JWST NIRSpec CLEAR/PRISM x1d, obsid 230168921, raw sha256 `c0b878576d7d7ec723c5ee526d29715fb672d81e45bc8ba4e02598ce8b9c5ee7`
(verified; LRD-ARR-v1 `.f64` arrays verified against `manifest.kv`; converted with `od -An -t f8 -v -w8`). Fixture 09bcd907 not read.
Nothing was pushed or modified outside `/workspace/awk-sp`; inputs read-only from `/workspace/verify-main/repo/fixtures`
(`/workspace/jwst-lrd/fixtures/ingest/CURRENT` does not exist on this box, so the verify-main clone's `ingest/CURRENT` was used; it equals the sha above).

**Everything in section "Verbatim output" is copied unedited from `results/run.log`. The analysis section below is hand-written from those numbers.**

## Headline (all numbers from the log)

| estimator (rest set B = NIST vacuum unless stated) | joint Hβ+Hα z | Δz vs published 7.0451 | Δz vs Fortran 7.04221 |
|---|---|---|---|
| **pre-specified primary**: running-median continuum, matched filter, HW=5 px, LSF 2.2 px, σ_int profiled | **7.040280** (Δχ²=1 ±0.000268; χ²_red-rescaled ±0.000685; bootstrap sd 0.000259 param / 0.001047 case) | −4.82e-3 (5.7σ using rescaled error + published ±5e-4) | −1.93e-3 |
| simultaneous polynomial continuum, order 1 / 2 (HW=5) | 7.041836 / 7.042200 | −3.26e-3 / −2.90e-3 | −3.7e-4 / −1.0e-5 |
| polynomial order 1, HW=4 | 7.042306 | −2.79e-3 | +9.6e-5 |
| rest values exactly as given in the task (set A, which are AIR wavelengths) | 7.042524 | −2.58e-3 | +3.1e-4 |
| range over 27 set-B variants (continuum model, HW, LSF, red-edge pixel drops) | 7.039347 … 7.043317 (range 3.97e-3) | min gap −1.78e-3 (rm_drop3) | |
| centroid, Hα only, W = 100–400 Å (observed) | 7.038117 … 7.043930 (range 5.8e-3, sd 2.2e-3) | | |

## Analysis (plain statements)

1. **Does the awk estimate resolve the gap between Fortran 7.04221 and published 7.0451? No.** The pre-specified primary estimator
   gives 7.04028, which is *lower* than the Fortran value by 1.9e-3 and 4.8e-3 below the published value (so it widens, not narrows, the
   gap to the published number). No variant I ran reaches 7.0451; the closest are RM with the last 3 valid pixels dropped (7.043317, still
   −1.78e-3) and the narrowest (3-pixel) Hα-only centroid (7.043930).
2. **It does show that the Fortran–awk difference and the Fortran–published difference are of the same size as the analysis-choice systematic.**
   Across 27 set-B variants the joint z moves by 3.97e-3 (2.84e-3 without the drop-3 variants), about 10–15× the Δχ²=1 error (≈2.7e-4).
   Continuum model alone moves it: RM 7.04028 → POLY1 7.04184 → POLY2 7.04220 (POLY2 reproduces the Fortran 7.04221 to 1e-5; I take that as
   agreement of two similar models, not as evidence either is right). POLY1 depends on window size: HW=4 7.04231, 5 7.04184, 6 7.04143, 8 7.04083.
   So the quoted ±0.00027 is a *statistical* error under one continuum model and is not the total uncertainty.
3. **Fit quality**: Hα has χ²_red = 15.8 (dof 6) and joint 6.53 under RM; Gaussian + LSF is not an adequate description of the Hα profile at the
   data's S/N (peak pixel S/N 48.6). The Δχ²=1 interval therefore understates; the χ²_red-rescaled half-width is 6.85e-4 (joint). Synthetic
   Gaussian injections give joint χ²_red=0.051 (noise-free RM), i.e. the misfit is a property of the real line (asymmetry, broad wings, pixel correlation, or flux calibration), not of the estimator.
4. **Red edge**: the last valid pixel (idx 420, 5.3038 µm) lies below its running-median continuum (0.335 vs 0.479) and the Hα window reaches it.
   Dropping 1/2/3 red pixels moves RM joint z to 7.040543 / 7.040256 / 7.043317 and POLY1 to 7.039592 / 7.039463 / 7.039347. The response is non-monotonic and
   estimator-dependent, so the detector edge/flux-calibration is a live competing explanation for a ~1e-3–3e-3 shift but not a demonstrated one.
5. **Rest wavelengths — the task's values are air, not vacuum.** Hβ 4861.35, [OIII] 4958.9/5006.8 and Hα 6562.8 are standard-air wavelengths;
   NIST vacuum Hα is 6564.632. Using them against vacuum x1d wavelengths raises z by (1+z)(R_vac/R_air−1) = +2.24e-3 (log: set A 7.042524 vs set B 7.040280 = +2.244e-3).
   My own air→vacuum conversion (set C, Edlén/Morton) reproduces set B to 2.3e-5. Set A lands closer to the published value, but still −2.58e-3 below it, so an air/vacuum
   mix-up in someone's pipeline is a *possible contributor of the right size*, not an explanation; I have not verified what the published analysis used.
6. **Centroid window bias (FFT-free)**. Real data, Hα, observed-frame half-window 100–400 Å: fixed-centre z 7.043930 (W≤125, 3 px) → 7.042815 (150–200) → 7.040208 (225–275) → 7.038738 (300–350) → 7.038117 (375–400);
   range 5.81e-3, sd 2.23e-3 (iterated variant range 6.10e-3). Joint (inverse-variance) centroid 7.043874 (W=125) → 7.038138 (W=375). Hβ-only range 9.5e-4 (errors 1.1e-3–3.1e-3).
   This is the known ~2e-3 window bias and larger. **Synthetic control** (noise-free injection at 7.0451 with flat-Fν continuum): Hα centroid bias is only −3.75e-4…+3.35e-4 (range 7.1e-4) over the same windows,
   so for a symmetric Gaussian the window choice would cost <4e-4 at Hα. The 5.8e-3 spread in the real data is thus ~8× larger than a Gaussian-line window bias; the line (or its surrounding continuum/red edge) is not a symmetric
   Gaussian on a flat continuum. Hβ synthetic bias range is 5.0e-3 purely from the 3/5/7-pixel quantisation, so Hβ centroids carry ±3e-3 window noise by construction.
7. **Matched filter checks**: grid 7.00–7.08 step 1e-4 (+1e-5 refinement); [OIII]4959/5007 not detected (Δχ² 1.5, 1.2 < 25), Hβ Δχ²=245 and Hα Δχ²=7037 vs no-line. σ_int profile 600 km/s (Hβ), 500 km/s (Hα) identical to the Fortran fit.
   LSF FWHM scan 1.6–3.0 px (σ_int=0): joint z 7.040091–7.040280 (range 1.9e-4): LSF width is not the cause.
8. **Tests**: `PASS=37 FAIL=0` (counts in the log): 10 data-integrity, 5 unit, 12 synthetic noise-free injection-recovery (3 z_true × RM/POLY1 × joint/Hα; Hβ-only reported as INFO,
   RM Hβ-only is biased +9.6e-4 at 7.0451 because the running median partly absorbs the line), 6 noisy-synthetic (N=40: RM mean bias +6.3e-5, sd 3.02e-4, coverage 29/40; POLY1 mean bias +1.5e-4, sd 5.53e-4, coverage 22/40),
   2 noise-only negative controls (0/40 false detections each; max Δχ² 4.31, 4.79) and 2 pixel-permutation controls (0/40 permutations reach the real Δχ²). Criteria were fixed before running. SYNTHETIC lines are labelled in the output and are **not data**.
   The permutation control is weak in one sense: single bright shuffled pixels still give large Δχ² (median 1363 for Hα), it only shows the ordered line is stronger than any of 40 permutations (p<0.024).

## What is untested / not resolved

- Wavelength calibration: this is CAL_VER 3.0.0 x1d, one product (jw02561-o006). Furtak et al. 2024 used their own reduction/stack of the lensed images; I did not test a different calibration version or the other (o002 inverted-image) product.
- Whether the x1d wavelength grid is strictly vacuum was assumed (JWST convention), not verified from the header here.
- Line shape: no asymmetric, double-component, or broad+narrow Hα/Hβ model; no Balmer-absorption/blueshifted-absorber model (the very high Hα χ²_red suggests this is the main open modelling question).
- No pixel covariance (prism x1d pixels are correlated), no flux-calibration error model, no slit-position/LSF-compactness correction for a point vs extended source.
- Red-edge pixels 418–420 and detector-edge systematics: shown to matter at the 1e-3–3e-3 level, not understood.
- Published uncertainty and exact method of Furtak et al. were not re-derived; the published value 7.0451±0.0005 is quoted from the task.
- Bootstraps: N=200 each, σ_int fixed at its best fit; rand() is mawk's; the case bootstrap (sd 1.05e-3) treats pixels as independent.
- Detection threshold Δχ²≥25 is a convention, not a proof. Nothing here is an empirical discovery claim; this is a cross-check of one real spectrum.

## Files

`run.sh` (everything) · `test.sh` (PASS/FAIL) · `lib/prep.sh` (sha256 + od export) · `awk/{common,mask,continuum,matched,centroid,synth,compare,bias,restwl_report}.awk` · `results/run.log` (verbatim) · `work/` (intermediates, mask.log).
Rest wavelengths used: set B (primary) = NIST ASD v5.12 Ritz vacuum (Hβ 4862.691, [OIII] 4960.295/5008.240, Hα 6564.632) as in `fortran/src/lrd_lines.f90`; set A = task values (air); set C = A→vacuum via Edlén 1966 / Morton 1991 (ApJS 77, 119).

## Verbatim output (`results/run.log`)

```text
=== awk-sp run.sh  started 2026-10-26 18:00:02 PDT  host=grok-bot-vm-450106434  awk=mawk (mawk 1.3.4 20250131)
=== script sha256 (ties this log to the code that produced it)
fb8704bb04fa63abcd21e98a9343fe2ed1420450631898f8f23235c7a965e538  run.sh
38dfccab3fbf666f154c9d643723774692c2744f3c2c2c495d2bbe1e91f84ee8  test.sh
47300b4a87c1336dcf4d22c7ff27bfda9f6d15d7f2fc07865fdfd3c7569995df  lib/prep.sh
1d2593287f9fda9da918d254617af5103085edfde04965c510cb53f8c5fee14f  awk/bias.awk
9f661fcf82e9d0f782cdf2ffecacda8b2295c3a5910fd94755b1753e06673c26  awk/centroid.awk
b9a18d068d7fad6fdc3d8ac5d4f75769e37f0f765c061a7f4665bba997e2844f  awk/common.awk
f393c83fb7ae177eb20014ad028f8d2498b95458fa91ec2b802513323cb0a168  awk/compare.awk
e4135079e8b9ab95b9a0e8f2e87d694be8f7bfabeb59c48535d2be85036ba641  awk/continuum.awk
c6cd79c55236ee759d3b067481741d768e6fafcf292eed9bd10db33146ed143d  awk/mask.awk
b664db535111fa38d59fb73d3290e87462b19657098eb8dd706865d286231c75  awk/matched.awk
01a72fa29609fc3c164bd4e71b8c40251a26e4e54e467f2a8c443e189d9b5cc7  awk/restwl_report.awk
c048bac540f64c840447737986f9eda5145644b74bd81d6386145a5205aada49  awk/synth.awk

=== 0. data verification and export -> text (lib/prep.sh)
prep: SRC=/workspace/verify-main/repo/fixtures
SHA-OK   ingest/CURRENT c0b878576d7d7ec723c5ee526d29715fb672d81e45bc8ba4e02598ce8b9c5ee7
SHA-OK   raw.fits(verify-main) c0b878576d7d7ec723c5ee526d29715fb672d81e45bc8ba4e02598ce8b9c5ee7
NOTE /workspace/jwst-lrd/fixtures/raw/c0b878576d7d7ec723c5ee526d29715fb672d81e45bc8ba4e02598ce8b9c5ee7.fits absent
NOTE /workspace/jwst-lrd/fixtures/ingest/CURRENT does not exist (no ingest dir there); using verify-main clone
SHA-OK   wavelength.f64 349b11d7be59344b2812433983fbb41215dffb868a0a74be667f7d04e8444d9e
HDR wavelength format=LRD-ARR-v1 length=429 unit=um bytes=3432 (expect 8*length=3432) source_sha256_matches=yes
SHA-OK   flux.f64 594d5e4c4778f71b8d3ba0b5e294a3c5368a253ea7f64d4d905031d235c3ee63
HDR flux format=LRD-ARR-v1 length=429 unit=Jy bytes=3432 (expect 8*length=3432) source_sha256_matches=yes
SHA-OK   flux_error.f64 ed7e63c559e0f8cb2ce2bdb4cecd7cf9193344ddc007587717bb8b14792b4711
HDR flux_error format=LRD-ARR-v1 length=429 unit=Jy bytes=3432 (expect 8*length=3432) source_sha256_matches=yes
prep: wrote /workspace/awk-sp/work/spectrum.tsv rows=429
prep: fixture 09bcd907 deliberately not read (provenance only).

=== 1. rest wavelengths (stated and cited; see NOTE on air vs vacuum)
REST set A = values exactly as given in the task: Hbeta 4861.35, [OIII] 4958.9 / 5006.8, Halpha 6562.8 (the task calls them vacuum)
REST NOTE: these are the conventional AIR wavelengths (standard air, e.g. Halpha 6562.8, Hbeta 4861.3, [OIII] 4958.9/5006.8). JWST x1d wavelengths are vacuum.
REST set B = NIST ASD v5.12 Ritz vacuum wavelengths used by the Fortran kernel (fortran/src/lrd_lines.f90 line_vac_ang; raw queries in fortran/data/nist/*.csv)
REST set C = set A converted air->vacuum here with Edlen(1966)/Morton(1991, ApJS 77, 119) refractivity, air2vac() in common.awk
line       A(air,given)  B(NIST vac)   C=air2vac(A)        B-C [A] (1+z)ratio B/A
Hbeta         4861.3500    4862.6910      4862.7080        -0.0170     1.00027585
OIII4959      4958.9000    4960.2950      4960.2839         0.0111     1.00028131
OIII5007      5006.8000    5008.2400      5008.1967         0.0433     1.00028761
Halpha        6562.8000    6564.6320      6564.6130         0.0190     1.00027915
REST consequence: for a fixed observed line, z_A - z_B = (1+z)*(R_B/R_A - 1) (smaller rest wavelength => larger z); R_B/R_A-1 at Halpha = 2.791e-04 => z_A is higher than z_B by about 0.00224 at (1+z)=8.04

=== 2. masking (explicit mask file work/mask.log + work/masked0.tsv)
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

=== 3. continuum: iterative sigma-clipped running median
CONT iter=0 clipped_pixels=14 changed=14
CONT iter=1 clipped_pixels=15 changed=1
CONT iter=2 clipped_pixels=15 changed=0
CONT final clipped pixel idx: 61 69 220 256 257 258 259 412 413 414 415 416 417 418 419
CONT params HALF=12 (window 25 valid px) CLIP=3 NITER=6; valid=408; truncated_edge_windows=24
CONT last valid pixel idx=420 wl_A=53038.230 window_px=13 cont=0.478519 flam=0.335348
pixel width at Halpha pixel 417 (A): 74.208

=== 4. matched filter, z grid 7.00-7.08 step 1e-4 (then 1e-5 refinement), inverse-variance weights
--- 4a PRIMARY: rest set B (NIST vacuum), running-median continuum (RM), HW=5 px, LSF FWHM 2.2 px, sigma_int profiled 0-4000 km/s, bootstrap N=200 seed 12345
MF set=B est=RM ord=-1 hw=5 lsfpx=2.2 smax=4000 dropred=0 tag=primary line=Hbeta rest=4862.6910 ip=258 lam_ip=39096.01 nwin=11 snr_peakpix=10.29 coarse_z=7.03829 fine_z=7.038287 dz1_lo=7.035964 dz1_hi=7.040621 dz1_halfwidth=0.002328 chi2min=2.318 dof=8 chi2red=0.290 scaled_lo=7.035964 scaled_hi=7.040621 scaled_halfwidth=0.002328 sigma_int_kms=600 A=101.47 dchi2_vs_A0=245.093
MF set=B est=RM ord=-1 hw=5 lsfpx=2.2 smax=4000 dropred=0 tag=primary line=OIII4959 rest=4960.2950 ip=266 lam_ip=39906.93 nwin=11 snr_peakpix=1.06 NOT_DETECTED dchi2_vs_A0(coarse)=1.525 (<25 or peak at grid edge) coarse_z=7.04554 (no fine fit/interval reported)
MF set=B est=RM ord=-1 hw=5 lsfpx=2.2 smax=4000 dropred=0 tag=primary line=OIII5007 rest=5008.2400 ip=270 lam_ip=40306.04 nwin=11 snr_peakpix=1.44 NOT_DETECTED dchi2_vs_A0(coarse)=1.157 (<25 or peak at grid edge) coarse_z=7.00000(EDGE) (no fine fit/interval reported)
MF set=B est=RM ord=-1 hw=5 lsfpx=2.2 smax=4000 dropred=0 tag=primary line=Halpha rest=6564.6320 ip=417 lam_ip=52816.13 nwin=9 snr_peakpix=48.61 coarse_z=7.04031 fine_z=7.040306 dz1_lo=7.040037 dz1_hi=7.040576 dz1_halfwidth=0.000270 chi2min=94.930 dof=6 chi2red=15.822 scaled_lo=7.039232 scaled_hi=7.041378 scaled_halfwidth=0.001073 sigma_int_kms=500 A=965.55 dchi2_vs_A0=7037.477
MFJ set=B est=RM ord=-1 hw=5 lsfpx=2.2 smax=4000 dropred=0 tag=primary joint=HbHa coarse_z=7.04028 fine_z=7.040280 dz1_lo=7.040012 dz1_hi=7.040548 dz1_halfwidth=0.000268 chi2min=97.989 dof=15 chi2red=6.533 scaled_lo=7.039595 scaled_hi=7.040964 scaled_halfwidth=0.000685 sigma_int_kms=[600,500] A=[101.3,965.5] dchi2_vs_A0=7281.830
MFJ set=B est=RM ord=-1 hw=5 lsfpx=2.2 smax=4000 dropred=0 tag=primary joint=ALL4 coarse_z=7.04028 fine_z=7.040280 dz1_lo=7.040013 dz1_hi=7.040548 dz1_halfwidth=0.000268 chi2min=112.536 dof=33 chi2red=3.410 scaled_lo=7.039786 scaled_hi=7.040775 scaled_halfwidth=0.000495 sigma_int_kms=[600,0,0,500] A=[101.3,6.521,5.136,965.5] dchi2_vs_A0=7284.283
BOOT set=B est=RM ord=-1 hw=5 lsfpx=2.2 smax=4000 dropred=0 tag=primary kind=param joint=HbHa N=200 ok=200 edge_fail=0 seed=12345 z_mean=7.040273 z_sd=0.000259 p16=7.039995 p50=7.040277 p84=7.040544 (sigma_int fixed at best fit)
BOOT set=B est=RM ord=-1 hw=5 lsfpx=2.2 smax=4000 dropred=0 tag=primary kind=case joint=HbHa N=200 ok=200 edge_fail=0 seed=12345 z_mean=7.039976 z_sd=0.001047 p16=7.039211 p50=7.040179 p84=7.040834 (sigma_int fixed at best fit)
--- 4b LSF-only (sigma_int=0)
MF set=B est=RM ord=-1 hw=5 lsfpx=2.2 smax=0 dropred=0 tag=lsfonly line=Hbeta rest=4862.6910 ip=258 lam_ip=39096.01 nwin=11 snr_peakpix=10.29 coarse_z=7.03803 fine_z=7.038028 dz1_lo=7.035884 dz1_hi=7.040179 dz1_halfwidth=0.002148 chi2min=10.360 dof=8 chi2red=1.295 scaled_lo=7.035588 scaled_hi=7.040477 scaled_halfwidth=0.002445 sigma_int_kms=0 A=89.1 dchi2_vs_A0=237.052
MF set=B est=RM ord=-1 hw=5 lsfpx=2.2 smax=0 dropred=0 tag=lsfonly line=Halpha rest=6564.6320 ip=417 lam_ip=52816.13 nwin=9 snr_peakpix=48.61 coarse_z=7.04018 fine_z=7.040180 dz1_lo=7.039939 dz1_hi=7.040421 dz1_halfwidth=0.000241 chi2min=763.101 dof=6 chi2red=127.183 scaled_lo=7.037450 scaled_hi=7.042917 scaled_halfwidth=0.002733 sigma_int_kms=0 A=755.23 dchi2_vs_A0=6369.307
MFJ set=B est=RM ord=-1 hw=5 lsfpx=2.2 smax=0 dropred=0 tag=lsfonly joint=HbHa coarse_z=7.04015 fine_z=7.040153 dz1_lo=7.039914 dz1_hi=7.040393 dz1_halfwidth=0.000239 chi2min=774.449 dof=15 chi2red=51.630 scaled_lo=7.038431 scaled_hi=7.041879 scaled_halfwidth=0.001724 sigma_int_kms=[0,0] A=[88.83,755.2] dchi2_vs_A0=6605.370
--- 4c rest set A (values as given in the task; they are AIR wavelengths) and set C (A converted to vacuum)
MF set=A est=RM ord=-1 hw=5 lsfpx=2.2 smax=4000 dropred=0 tag=setA line=Hbeta rest=4861.3500 ip=258 lam_ip=39096.01 nwin=11 snr_peakpix=10.29 coarse_z=7.04050 fine_z=7.040505 dz1_lo=7.038181 dz1_hi=7.042839 dz1_halfwidth=0.002329 chi2min=2.318 dof=8 chi2red=0.290 scaled_lo=7.038181 scaled_hi=7.042839 scaled_halfwidth=0.002329 sigma_int_kms=600 A=101.47 dchi2_vs_A0=245.093
MF set=A est=RM ord=-1 hw=5 lsfpx=2.2 smax=4000 dropred=0 tag=setA line=Halpha rest=6562.8000 ip=417 lam_ip=52816.13 nwin=9 snr_peakpix=48.61 coarse_z=7.04255 fine_z=7.042551 dz1_lo=7.042281 dz1_hi=7.042821 dz1_halfwidth=0.000270 chi2min=94.930 dof=6 chi2red=15.822 scaled_lo=7.041476 scaled_hi=7.043623 scaled_halfwidth=0.001074 sigma_int_kms=500 A=965.55 dchi2_vs_A0=7037.477
MFJ set=A est=RM ord=-1 hw=5 lsfpx=2.2 smax=4000 dropred=0 tag=setA joint=HbHa coarse_z=7.04252 fine_z=7.042524 dz1_lo=7.042256 dz1_hi=7.042792 dz1_halfwidth=0.000268 chi2min=98.008 dof=15 chi2red=6.534 scaled_lo=7.041838 scaled_hi=7.043209 scaled_halfwidth=0.000685 sigma_int_kms=[600,500] A=[101.3,965.5] dchi2_vs_A0=7281.811
MF set=C est=RM ord=-1 hw=5 lsfpx=2.2 smax=4000 dropred=0 tag=setC line=Hbeta rest=4862.7080 ip=258 lam_ip=39096.01 nwin=11 snr_peakpix=10.29 coarse_z=7.03826 fine_z=7.038259 dz1_lo=7.035936 dz1_hi=7.040592 dz1_halfwidth=0.002328 chi2min=2.318 dof=8 chi2red=0.290 scaled_lo=7.035936 scaled_hi=7.040592 scaled_halfwidth=0.002328 sigma_int_kms=600 A=101.47 dchi2_vs_A0=245.093
MF set=C est=RM ord=-1 hw=5 lsfpx=2.2 smax=4000 dropred=0 tag=setC line=Halpha rest=6564.6130 ip=417 lam_ip=52816.13 nwin=9 snr_peakpix=48.61 coarse_z=7.04033 fine_z=7.040330 dz1_lo=7.040060 dz1_hi=7.040599 dz1_halfwidth=0.000270 chi2min=94.930 dof=6 chi2red=15.822 scaled_lo=7.039255 scaled_hi=7.041402 scaled_halfwidth=0.001073 sigma_int_kms=500 A=965.55 dchi2_vs_A0=7037.477
MFJ set=C est=RM ord=-1 hw=5 lsfpx=2.2 smax=4000 dropred=0 tag=setC joint=HbHa coarse_z=7.04030 fine_z=7.040303 dz1_lo=7.040035 dz1_hi=7.040570 dz1_halfwidth=0.000268 chi2min=98.027 dof=15 chi2red=6.535 scaled_lo=7.039617 scaled_hi=7.040987 scaled_halfwidth=0.000685 sigma_int_kms=[600,500] A=[101.3,965.5] dchi2_vs_A0=7281.792
--- 4d continuum-estimator sensitivity: simultaneous polynomial continuum + line (POLY), order 1 and 2
MF set=B est=POLY ord=1 hw=5 lsfpx=2.2 smax=4000 dropred=0 tag=poly1 line=Hbeta rest=4862.6910 ip=258 lam_ip=39096.01 nwin=11 snr_peakpix=10.29 coarse_z=7.03852 fine_z=7.038520 dz1_lo=7.036081 dz1_hi=7.040972 dz1_halfwidth=0.002445 chi2min=1.861 dof=6 chi2red=0.310 scaled_lo=7.036081 scaled_hi=7.040972 scaled_halfwidth=0.002445 sigma_int_kms=600 A=102.61 dchi2_vs_A0=155.799
MF set=B est=POLY ord=1 hw=5 lsfpx=2.2 smax=4000 dropred=0 tag=poly1 line=Halpha rest=6564.6320 ip=417 lam_ip=52816.13 nwin=9 snr_peakpix=48.61 coarse_z=7.04189 fine_z=7.041892 dz1_lo=7.041553 dz1_hi=7.042230 dz1_halfwidth=0.000339 chi2min=45.373 dof=4 chi2red=11.343 scaled_lo=7.040742 scaled_hi=7.043612 scaled_halfwidth=0.001435 sigma_int_kms=500 A=1005.6 dchi2_vs_A0=2923.066
MFJ set=B est=POLY ord=1 hw=5 lsfpx=2.2 smax=4000 dropred=0 tag=poly1 joint=HbHa coarse_z=7.04184 fine_z=7.041836 dz1_lo=7.041499 dz1_hi=7.042172 dz1_halfwidth=0.000336 chi2min=49.031 dof=11 chi2red=4.457 scaled_lo=7.041121 scaled_hi=7.042543 scaled_halfwidth=0.000711 sigma_int_kms=[700,500] A=[107.5,1005] dchi2_vs_A0=3077.067
MF set=B est=POLY ord=2 hw=5 lsfpx=2.2 smax=4000 dropred=0 tag=poly2 line=Hbeta rest=4862.6910 ip=258 lam_ip=39096.01 nwin=11 snr_peakpix=10.29 coarse_z=7.03864 fine_z=7.038641 dz1_lo=7.036102 dz1_hi=7.041101 dz1_halfwidth=0.002499 chi2min=1.840 dof=5 chi2red=0.368 scaled_lo=7.036102 scaled_hi=7.041101 scaled_halfwidth=0.002499 sigma_int_kms=700 A=113.61 dchi2_vs_A0=62.100
MF set=B est=POLY ord=2 hw=5 lsfpx=2.2 smax=4000 dropred=0 tag=poly2 line=Halpha rest=6564.6320 ip=417 lam_ip=52816.13 nwin=9 snr_peakpix=48.61 coarse_z=7.04230 fine_z=7.042295 dz1_lo=7.041890 dz1_hi=7.042709 dz1_halfwidth=0.000410 chi2min=35.854 dof=3 chi2red=11.951 scaled_lo=7.040922 scaled_hi=7.043765 scaled_halfwidth=0.001421 sigma_int_kms=400 A=740.8 dchi2_vs_A0=784.286
MFJ set=B est=POLY ord=2 hw=5 lsfpx=2.2 smax=4000 dropred=0 tag=poly2 joint=HbHa coarse_z=7.04220 fine_z=7.042200 dz1_lo=7.041802 dz1_hi=7.042606 dz1_halfwidth=0.000402 chi2min=39.819 dof=9 chi2red=4.424 scaled_lo=7.041370 scaled_hi=7.043063 scaled_halfwidth=0.000846 sigma_int_kms=[700,400] A=[110.9,742.4] dchi2_vs_A0=844.261
--- 4e fit half-window scan HW (px); HW>=8 lets the Hbeta window overlap [OIII]4959/5007 and the Halpha window reach the red edge
MF set=B est=RM ord=-1 hw=3 lsfpx=2.2 smax=4000 dropred=0 tag=rm_hw3 line=Hbeta rest=4862.6910 ip=258 lam_ip=39096.01 nwin=7 snr_peakpix=10.29 coarse_z=7.03828 fine_z=7.038283 dz1_lo=7.035953 dz1_hi=7.040687 dz1_halfwidth=0.002367 chi2min=0.698 dof=4 chi2red=0.174 scaled_lo=7.035953 scaled_hi=7.040687 scaled_halfwidth=0.002367 sigma_int_kms=600 A=101.5 dchi2_vs_A0=245.213
MF set=B est=RM ord=-1 hw=3 lsfpx=2.2 smax=4000 dropred=0 tag=rm_hw3 line=Halpha rest=6564.6320 ip=417 lam_ip=52816.13 nwin=7 snr_peakpix=48.61 coarse_z=7.04053 fine_z=7.040531 dz1_lo=7.040261 dz1_hi=7.040801 dz1_halfwidth=0.000270 chi2min=67.197 dof=4 chi2red=16.799 scaled_lo=7.039421 scaled_hi=7.041637 scaled_halfwidth=0.001108 sigma_int_kms=500 A=963 dchi2_vs_A0=6970.199
MFJ set=B est=RM ord=-1 hw=3 lsfpx=2.2 smax=4000 dropred=0 tag=rm_hw3 joint=HbHa coarse_z=7.04050 fine_z=7.040505 dz1_lo=7.040236 dz1_hi=7.040773 dz1_halfwidth=0.000269 chi2min=68.768 dof=9 chi2red=7.641 scaled_lo=7.039760 scaled_hi=7.041247 scaled_halfwidth=0.000743 sigma_int_kms=[700,500] A=[104.4,962.9] dchi2_vs_A0=7214.538
MF set=B est=RM ord=-1 hw=4 lsfpx=2.2 smax=4000 dropred=0 tag=rm_hw4 line=Hbeta rest=4862.6910 ip=258 lam_ip=39096.01 nwin=9 snr_peakpix=10.29 coarse_z=7.03829 fine_z=7.038291 dz1_lo=7.035968 dz1_hi=7.040624 dz1_halfwidth=0.002328 chi2min=1.267 dof=6 chi2red=0.211 scaled_lo=7.035968 scaled_hi=7.040624 scaled_halfwidth=0.002328 sigma_int_kms=600 A=101.47 dchi2_vs_A0=245.086
MF set=B est=RM ord=-1 hw=4 lsfpx=2.2 smax=4000 dropred=0 tag=rm_hw4 line=Halpha rest=6564.6320 ip=417 lam_ip=52816.13 nwin=8 snr_peakpix=48.61 coarse_z=7.04033 fine_z=7.040333 dz1_lo=7.040064 dz1_hi=7.040603 dz1_halfwidth=0.000269 chi2min=88.599 dof=5 chi2red=17.720 scaled_lo=7.039197 scaled_hi=7.041467 scaled_halfwidth=0.001135 sigma_int_kms=500 A=965.33 dchi2_vs_A0=7032.248
MFJ set=B est=RM ord=-1 hw=4 lsfpx=2.2 smax=4000 dropred=0 tag=rm_hw4 joint=HbHa coarse_z=7.04031 fine_z=7.040307 dz1_lo=7.040039 dz1_hi=7.040574 dz1_halfwidth=0.000268 chi2min=90.622 dof=12 chi2red=7.552 scaled_lo=7.039570 scaled_hi=7.041042 scaled_halfwidth=0.000736 sigma_int_kms=[600,500] A=[101.3,965.2] dchi2_vs_A0=7276.577
MF set=B est=RM ord=-1 hw=6 lsfpx=2.2 smax=4000 dropred=0 tag=rm_hw6 line=Hbeta rest=4862.6910 ip=258 lam_ip=39096.01 nwin=13 snr_peakpix=10.29 coarse_z=7.03829 fine_z=7.038287 dz1_lo=7.035964 dz1_hi=7.040620 dz1_halfwidth=0.002328 chi2min=9.751 dof=10 chi2red=0.975 scaled_lo=7.035964 scaled_hi=7.040620 scaled_halfwidth=0.002328 sigma_int_kms=600 A=101.47 dchi2_vs_A0=245.094
MF set=B est=RM ord=-1 hw=6 lsfpx=2.2 smax=4000 dropred=0 tag=rm_hw6 line=Halpha rest=6564.6320 ip=417 lam_ip=52816.13 nwin=10 snr_peakpix=48.61 coarse_z=7.04030 fine_z=7.040305 dz1_lo=7.040035 dz1_hi=7.040574 dz1_halfwidth=0.000270 chi2min=96.336 dof=7 chi2red=13.762 scaled_lo=7.039303 scaled_hi=7.041305 scaled_halfwidth=0.001001 sigma_int_kms=500 A=965.56 dchi2_vs_A0=7037.732
MFJ set=B est=RM ord=-1 hw=6 lsfpx=2.2 smax=4000 dropred=0 tag=rm_hw6 joint=HbHa coarse_z=7.04028 fine_z=7.040278 dz1_lo=7.040010 dz1_hi=7.040546 dz1_halfwidth=0.000268 chi2min=106.826 dof=18 chi2red=5.935 scaled_lo=7.039625 scaled_hi=7.040931 scaled_halfwidth=0.000653 sigma_int_kms=[600,500] A=[101.3,965.5] dchi2_vs_A0=7282.087
MF set=B est=RM ord=-1 hw=8 lsfpx=2.2 smax=4000 dropred=0 tag=rm_hw8 line=Hbeta rest=4862.6910 ip=258 lam_ip=39096.01 nwin=17 snr_peakpix=10.29 coarse_z=7.03829 fine_z=7.038287 dz1_lo=7.035964 dz1_hi=7.040620 dz1_halfwidth=0.002328 chi2min=11.403 dof=14 chi2red=0.814 scaled_lo=7.035964 scaled_hi=7.040620 scaled_halfwidth=0.002328 sigma_int_kms=600 A=101.47 dchi2_vs_A0=245.094
MF set=B est=RM ord=-1 hw=8 lsfpx=2.2 smax=4000 dropred=0 tag=rm_hw8 line=Halpha rest=6564.6320 ip=417 lam_ip=52816.13 nwin=12 snr_peakpix=48.61 coarse_z=7.04030 fine_z=7.040305 dz1_lo=7.040035 dz1_hi=7.040574 dz1_halfwidth=0.000270 chi2min=98.547 dof=9 chi2red=10.950 scaled_lo=7.039411 scaled_hi=7.041197 scaled_halfwidth=0.000893 sigma_int_kms=500 A=965.56 dchi2_vs_A0=7037.711
MFJ set=B est=RM ord=-1 hw=8 lsfpx=2.2 smax=4000 dropred=0 tag=rm_hw8 joint=HbHa coarse_z=7.04028 fine_z=7.040278 dz1_lo=7.040010 dz1_hi=7.040546 dz1_halfwidth=0.000268 chi2min=110.688 dof=24 chi2red=4.612 scaled_lo=7.039702 scaled_hi=7.040853 scaled_halfwidth=0.000575 sigma_int_kms=[600,500] A=[101.3,965.5] dchi2_vs_A0=7282.066
MF set=B est=RM ord=-1 hw=10 lsfpx=2.2 smax=4000 dropred=0 tag=rm_hw10 line=Hbeta rest=4862.6910 ip=258 lam_ip=39096.01 nwin=21 snr_peakpix=10.29 coarse_z=7.03829 fine_z=7.038287 dz1_lo=7.035964 dz1_hi=7.040620 dz1_halfwidth=0.002328 chi2min=13.313 dof=18 chi2red=0.740 scaled_lo=7.035964 scaled_hi=7.040620 scaled_halfwidth=0.002328 sigma_int_kms=600 A=101.47 dchi2_vs_A0=245.094
MF set=B est=RM ord=-1 hw=10 lsfpx=2.2 smax=4000 dropred=0 tag=rm_hw10 line=Halpha rest=6564.6320 ip=417 lam_ip=52816.13 nwin=14 snr_peakpix=48.61 coarse_z=7.04030 fine_z=7.040305 dz1_lo=7.040035 dz1_hi=7.040574 dz1_halfwidth=0.000270 chi2min=99.057 dof=11 chi2red=9.005 scaled_lo=7.039495 scaled_hi=7.041114 scaled_halfwidth=0.000810 sigma_int_kms=500 A=965.56 dchi2_vs_A0=7037.711
MFJ set=B est=RM ord=-1 hw=10 lsfpx=2.2 smax=4000 dropred=0 tag=rm_hw10 joint=HbHa coarse_z=7.04028 fine_z=7.040278 dz1_lo=7.040010 dz1_hi=7.040546 dz1_halfwidth=0.000268 chi2min=113.109 dof=30 chi2red=3.770 scaled_lo=7.039758 scaled_hi=7.040798 scaled_halfwidth=0.000520 sigma_int_kms=[600,500] A=[101.3,965.5] dchi2_vs_A0=7282.066
MF set=B est=RM ord=-1 hw=12 lsfpx=2.2 smax=4000 dropred=0 tag=rm_hw12 line=Hbeta rest=4862.6910 ip=258 lam_ip=39096.01 nwin=25 snr_peakpix=10.29 coarse_z=7.03829 fine_z=7.038287 dz1_lo=7.035964 dz1_hi=7.040620 dz1_halfwidth=0.002328 chi2min=20.224 dof=22 chi2red=0.919 scaled_lo=7.035964 scaled_hi=7.040620 scaled_halfwidth=0.002328 sigma_int_kms=600 A=101.47 dchi2_vs_A0=245.094
MF set=B est=RM ord=-1 hw=12 lsfpx=2.2 smax=4000 dropred=0 tag=rm_hw12 line=Halpha rest=6564.6320 ip=417 lam_ip=52816.13 nwin=16 snr_peakpix=48.61 coarse_z=7.04030 fine_z=7.040305 dz1_lo=7.040035 dz1_hi=7.040574 dz1_halfwidth=0.000270 chi2min=101.644 dof=13 chi2red=7.819 scaled_lo=7.039550 scaled_hi=7.041058 scaled_halfwidth=0.000754 sigma_int_kms=500 A=965.56 dchi2_vs_A0=7037.711
MFJ set=B est=RM ord=-1 hw=12 lsfpx=2.2 smax=4000 dropred=0 tag=rm_hw12 joint=HbHa coarse_z=7.04028 fine_z=7.040278 dz1_lo=7.040010 dz1_hi=7.040546 dz1_halfwidth=0.000268 chi2min=122.607 dof=36 chi2red=3.406 scaled_lo=7.039784 scaled_hi=7.040773 scaled_halfwidth=0.000494 sigma_int_kms=[600,500] A=[101.3,965.5] dchi2_vs_A0=7282.066
MF set=B est=POLY ord=1 hw=4 lsfpx=2.2 smax=4000 dropred=0 tag=poly1_hw4 line=Hbeta rest=4862.6910 ip=258 lam_ip=39096.01 nwin=9 snr_peakpix=10.29 coarse_z=7.03792 fine_z=7.037923 dz1_lo=7.035232 dz1_hi=7.040627 dz1_halfwidth=0.002698 chi2min=1.112 dof=4 chi2red=0.278 scaled_lo=7.035232 scaled_hi=7.040627 scaled_halfwidth=0.002698 sigma_int_kms=700 A=110.69 dchi2_vs_A0=137.058
MF set=B est=POLY ord=1 hw=4 lsfpx=2.2 smax=4000 dropred=0 tag=poly1_hw4 line=Halpha rest=6564.6320 ip=417 lam_ip=52816.13 nwin=8 snr_peakpix=48.61 coarse_z=7.04239 fine_z=7.042394 dz1_lo=7.042007 dz1_hi=7.042780 dz1_halfwidth=0.000386 chi2min=38.021 dof=3 chi2red=12.674 scaled_lo=7.041011 scaled_hi=7.043765 scaled_halfwidth=0.001377 sigma_int_kms=500 A=996.97 dchi2_vs_A0=2603.798
MFJ set=B est=POLY ord=1 hw=4 lsfpx=2.2 smax=4000 dropred=0 tag=poly1_hw4 joint=HbHa coarse_z=7.04231 fine_z=7.042306 dz1_lo=7.041923 dz1_hi=7.042689 dz1_halfwidth=0.000383 chi2min=41.793 dof=8 chi2red=5.224 scaled_lo=7.041428 scaled_hi=7.043181 scaled_halfwidth=0.000877 sigma_int_kms=[700,500] A=[109.7,996.1] dchi2_vs_A0=2738.195
MF set=B est=POLY ord=1 hw=6 lsfpx=2.2 smax=4000 dropred=0 tag=poly1_hw6 line=Hbeta rest=4862.6910 ip=258 lam_ip=39096.01 nwin=13 snr_peakpix=10.29 coarse_z=7.03900 fine_z=7.039004 dz1_lo=7.036655 dz1_hi=7.041585 dz1_halfwidth=0.002465 chi2min=5.084 dof=8 chi2red=0.635 scaled_lo=7.036655 scaled_hi=7.041585 scaled_halfwidth=0.002465 sigma_int_kms=500 A=94.962 dchi2_vs_A0=159.969
MF set=B est=POLY ord=1 hw=6 lsfpx=2.2 smax=4000 dropred=0 tag=poly1_hw6 line=Halpha rest=6564.6320 ip=417 lam_ip=52816.13 nwin=10 snr_peakpix=48.61 coarse_z=7.04146 fine_z=7.041464 dz1_lo=7.041148 dz1_hi=7.041779 dz1_halfwidth=0.000315 chi2min=56.873 dof=5 chi2red=11.375 scaled_lo=7.040391 scaled_hi=7.043440 scaled_halfwidth=0.001525 sigma_int_kms=500 A=1005.8 dchi2_vs_A0=3015.347
MFJ set=B est=POLY ord=1 hw=6 lsfpx=2.2 smax=4000 dropred=0 tag=poly1_hw6 joint=HbHa coarse_z=7.04143 fine_z=7.041427 dz1_lo=7.041113 dz1_hi=7.041739 dz1_halfwidth=0.000313 chi2min=62.847 dof=14 chi2red=4.489 scaled_lo=7.040760 scaled_hi=7.042875 scaled_halfwidth=0.001058 sigma_int_kms=[600,500] A=[98.93,1005] dchi2_vs_A0=3174.426
MF set=B est=POLY ord=1 hw=8 lsfpx=2.2 smax=4000 dropred=0 tag=poly1_hw8 line=Hbeta rest=4862.6910 ip=258 lam_ip=39096.01 nwin=17 snr_peakpix=10.29 coarse_z=7.03827 fine_z=7.038267 dz1_lo=7.035921 dz1_hi=7.040623 dz1_halfwidth=0.002351 chi2min=9.474 dof=12 chi2red=0.789 scaled_lo=7.035921 scaled_hi=7.040623 scaled_halfwidth=0.002351 sigma_int_kms=600 A=100.58 dchi2_vs_A0=182.429
MF set=B est=POLY ord=1 hw=8 lsfpx=2.2 smax=4000 dropred=0 tag=poly1_hw8 line=Halpha rest=6564.6320 ip=417 lam_ip=52816.13 nwin=12 snr_peakpix=48.61 coarse_z=7.04087 fine_z=7.040873 dz1_lo=7.040580 dz1_hi=7.041165 dz1_halfwidth=0.000292 chi2min=81.817 dof=7 chi2red=11.688 scaled_lo=7.039865 scaled_hi=7.042524 scaled_halfwidth=0.001329 sigma_int_kms=500 A=994.73 dchi2_vs_A0=3025.725
MFJ set=B est=POLY ord=1 hw=8 lsfpx=2.2 smax=4000 dropred=0 tag=poly1_hw8 joint=HbHa coarse_z=7.04083 fine_z=7.040834 dz1_lo=7.040543 dz1_hi=7.041124 dz1_halfwidth=0.000290 chi2min=92.494 dof=20 chi2red=4.625 scaled_lo=7.040206 scaled_hi=7.041982 scaled_halfwidth=0.000888 sigma_int_kms=[600,500] A=[100.2,994] dchi2_vs_A0=3206.951
--- 4f prism-LSF-width scan: FWHM = LSFPX x pixel width, sigma_int=0 (isolates the instrumental-width assumption)
MF set=B est=RM ord=-1 hw=5 lsfpx=1.6 smax=0 dropred=0 tag=lsf1.6 line=Hbeta rest=4862.6910 ip=258 lam_ip=39096.01 nwin=11 snr_peakpix=10.29 coarse_z=7.03752 fine_z=7.037519 dz1_lo=7.035205 dz1_hi=7.039961 dz1_halfwidth=0.002378 chi2min=35.768 dof=8 chi2red=4.471 scaled_lo=7.032788 scaled_hi=7.042733 scaled_halfwidth=0.004972 sigma_int_kms=0 A=73.378 dchi2_vs_A0=211.644
MF set=B est=RM ord=-1 hw=5 lsfpx=1.6 smax=0 dropred=0 tag=lsf1.6 line=Halpha rest=6564.6320 ip=417 lam_ip=52816.13 nwin=9 snr_peakpix=48.61 coarse_z=7.04012 fine_z=7.040120 dz1_lo=7.039907 dz1_hi=7.040333 dz1_halfwidth=0.000213 chi2min=1622.809 dof=6 chi2red=270.468 scaled_lo=7.036422 scaled_hi=7.043832 scaled_halfwidth=0.003705 sigma_int_kms=0 A=618.89 dchi2_vs_A0=5509.598
MFJ set=B est=RM ord=-1 hw=5 lsfpx=1.6 smax=0 dropred=0 tag=lsf1.6 joint=HbHa coarse_z=7.04010 fine_z=7.040101 dz1_lo=7.039889 dz1_hi=7.040313 dz1_halfwidth=0.000212 chi2min=1659.700 dof=15 chi2red=110.647 scaled_lo=7.037820 scaled_hi=7.042384 scaled_halfwidth=0.002282 sigma_int_kms=[0,0] A=[73.01,618.9] dchi2_vs_A0=5720.118
MF set=B est=RM ord=-1 hw=5 lsfpx=1.8 smax=0 dropred=0 tag=lsf1.8 line=Hbeta rest=4862.6910 ip=258 lam_ip=39096.01 nwin=11 snr_peakpix=10.29 coarse_z=7.03791 fine_z=7.037908 dz1_lo=7.035744 dz1_hi=7.040097 dz1_halfwidth=0.002177 chi2min=24.763 dof=8 chi2red=3.095 scaled_lo=7.034118 scaled_hi=7.041774 scaled_halfwidth=0.003828 sigma_int_kms=0 A=79.162 dchi2_vs_A0=222.648
MF set=B est=RM ord=-1 hw=5 lsfpx=1.8 smax=0 dropred=0 tag=lsf1.8 line=Halpha rest=6564.6320 ip=417 lam_ip=52816.13 nwin=9 snr_peakpix=48.61 coarse_z=7.04012 fine_z=7.040116 dz1_lo=7.039884 dz1_hi=7.040348 dz1_halfwidth=0.000232 chi2min=1303.619 dof=6 chi2red=217.270 scaled_lo=7.036621 scaled_hi=7.043625 scaled_halfwidth=0.003502 sigma_int_kms=0 A=665.94 dchi2_vs_A0=5828.788
MFJ set=B est=RM ord=-1 hw=5 lsfpx=1.8 smax=0 dropred=0 tag=lsf1.8 joint=HbHa coarse_z=7.04009 fine_z=7.040091 dz1_lo=7.039861 dz1_hi=7.040322 dz1_halfwidth=0.000231 chi2min=1329.388 dof=15 chi2red=88.626 scaled_lo=7.037900 scaled_hi=7.042287 scaled_halfwidth=0.002194 sigma_int_kms=[0,0] A=[78.87,665.9] dchi2_vs_A0=6050.430
MF set=B est=RM ord=-1 hw=5 lsfpx=2 smax=0 dropred=0 tag=lsf2.0 line=Hbeta rest=4862.6910 ip=258 lam_ip=39096.01 nwin=11 snr_peakpix=10.29 coarse_z=7.03799 fine_z=7.037992 dz1_lo=7.035865 dz1_hi=7.040128 dz1_halfwidth=0.002132 chi2min=16.445 dof=8 chi2red=2.056 scaled_lo=7.034943 scaled_hi=7.041061 scaled_halfwidth=0.003059 sigma_int_kms=0 A=84.377 dchi2_vs_A0=230.966
MF set=B est=RM ord=-1 hw=5 lsfpx=2 smax=0 dropred=0 tag=lsf2.0 line=Halpha rest=6564.6320 ip=417 lam_ip=52816.13 nwin=9 snr_peakpix=48.61 coarse_z=7.04014 fine_z=7.040138 dz1_lo=7.039900 dz1_hi=7.040377 dz1_halfwidth=0.000239 chi2min=1013.380 dof=6 chi2red=168.897 scaled_lo=7.037011 scaled_hi=7.043280 scaled_halfwidth=0.003135 sigma_int_kms=0 A=711.87 dchi2_vs_A0=6119.027
MFJ set=B est=RM ord=-1 hw=5 lsfpx=2 smax=0 dropred=0 tag=lsf2.0 joint=HbHa coarse_z=7.04011 fine_z=7.040112 dz1_lo=7.039875 dz1_hi=7.040349 dz1_halfwidth=0.000237 chi2min=1030.823 dof=15 chi2red=68.722 scaled_lo=7.038140 scaled_hi=7.042089 scaled_halfwidth=0.001975 sigma_int_kms=[0,0] A=[84.1,711.8] dchi2_vs_A0=6348.996
MF set=B est=RM ord=-1 hw=5 lsfpx=2.2 smax=0 dropred=0 tag=lsf2.2 line=Hbeta rest=4862.6910 ip=258 lam_ip=39096.01 nwin=11 snr_peakpix=10.29 coarse_z=7.03803 fine_z=7.038028 dz1_lo=7.035884 dz1_hi=7.040179 dz1_halfwidth=0.002148 chi2min=10.360 dof=8 chi2red=1.295 scaled_lo=7.035588 scaled_hi=7.040477 scaled_halfwidth=0.002445 sigma_int_kms=0 A=89.1 dchi2_vs_A0=237.052
MF set=B est=RM ord=-1 hw=5 lsfpx=2.2 smax=0 dropred=0 tag=lsf2.2 line=Halpha rest=6564.6320 ip=417 lam_ip=52816.13 nwin=9 snr_peakpix=48.61 coarse_z=7.04018 fine_z=7.040180 dz1_lo=7.039939 dz1_hi=7.040421 dz1_halfwidth=0.000241 chi2min=763.101 dof=6 chi2red=127.183 scaled_lo=7.037450 scaled_hi=7.042917 scaled_halfwidth=0.002733 sigma_int_kms=0 A=755.23 dchi2_vs_A0=6369.307
MFJ set=B est=RM ord=-1 hw=5 lsfpx=2.2 smax=0 dropred=0 tag=lsf2.2 joint=HbHa coarse_z=7.04015 fine_z=7.040153 dz1_lo=7.039914 dz1_hi=7.040393 dz1_halfwidth=0.000239 chi2min=774.449 dof=15 chi2red=51.630 scaled_lo=7.038431 scaled_hi=7.041879 scaled_halfwidth=0.001724 sigma_int_kms=[0,0] A=[88.83,755.2] dchi2_vs_A0=6605.370
MF set=B est=RM ord=-1 hw=5 lsfpx=2.4 smax=0 dropred=0 tag=lsf2.4 line=Hbeta rest=4862.6910 ip=258 lam_ip=39096.01 nwin=11 snr_peakpix=10.29 coarse_z=7.03808 fine_z=7.038079 dz1_lo=7.035894 dz1_hi=7.040273 dz1_halfwidth=0.002190 chi2min=6.165 dof=8 chi2red=0.771 scaled_lo=7.035894 scaled_hi=7.040273 scaled_halfwidth=0.002190 sigma_int_kms=0 A=93.388 dchi2_vs_A0=241.246
MF set=B est=RM ord=-1 hw=5 lsfpx=2.4 smax=0 dropred=0 tag=lsf2.4 line=Halpha rest=6564.6320 ip=417 lam_ip=52816.13 nwin=9 snr_peakpix=48.61 coarse_z=7.04022 fine_z=7.040225 dz1_lo=7.039982 dz1_hi=7.040467 dz1_halfwidth=0.000243 chi2min=555.673 dof=6 chi2red=92.612 scaled_lo=7.037880 scaled_hi=7.042571 scaled_halfwidth=0.002345 sigma_int_kms=0 A=795.44 dchi2_vs_A0=6576.735
MFJ set=B est=RM ord=-1 hw=5 lsfpx=2.4 smax=0 dropred=0 tag=lsf2.4 joint=HbHa coarse_z=7.04020 fine_z=7.040199 dz1_lo=7.039958 dz1_hi=7.040440 dz1_halfwidth=0.000241 chi2min=562.782 dof=15 chi2red=37.519 scaled_lo=7.038719 scaled_hi=7.041679 scaled_halfwidth=0.001480 sigma_int_kms=[0,0] A=[93.14,795.4] dchi2_vs_A0=6817.036
MF set=B est=RM ord=-1 hw=5 lsfpx=2.6 smax=0 dropred=0 tag=lsf2.6 line=Hbeta rest=4862.6910 ip=258 lam_ip=39096.01 nwin=11 snr_peakpix=10.29 coarse_z=7.03816 fine_z=7.038159 dz1_lo=7.035917 dz1_hi=7.040410 dz1_halfwidth=0.002247 chi2min=3.592 dof=8 chi2red=0.449 scaled_lo=7.035917 scaled_hi=7.040410 scaled_halfwidth=0.002247 sigma_int_kms=0 A=97.274 dchi2_vs_A0=243.819
MF set=B est=RM ord=-1 hw=5 lsfpx=2.6 smax=0 dropred=0 tag=lsf2.6 line=Halpha rest=6564.6320 ip=417 lam_ip=52816.13 nwin=9 snr_peakpix=48.61 coarse_z=7.04026 fine_z=7.040262 dz1_lo=7.040017 dz1_hi=7.040507 dz1_halfwidth=0.000245 chi2min=390.397 dof=6 chi2red=65.066 scaled_lo=7.038277 scaled_hi=7.042244 scaled_halfwidth=0.001983 sigma_int_kms=0 A=832.35 dchi2_vs_A0=6742.010
MFJ set=B est=RM ord=-1 hw=5 lsfpx=2.6 smax=0 dropred=0 tag=lsf2.6 joint=HbHa coarse_z=7.04024 fine_z=7.040237 dz1_lo=7.039994 dz1_hi=7.040481 dz1_halfwidth=0.000244 chi2min=394.852 dof=15 chi2red=26.323 scaled_lo=7.038985 scaled_hi=7.041489 scaled_halfwidth=0.001252 sigma_int_kms=[0,0] A=[97.05,832.3] dchi2_vs_A0=6984.967
MF set=B est=RM ord=-1 hw=5 lsfpx=2.8 smax=0 dropred=0 tag=lsf2.8 line=Hbeta rest=4862.6910 ip=258 lam_ip=39096.01 nwin=11 snr_peakpix=10.29 coarse_z=7.03826 fine_z=7.038263 dz1_lo=7.035954 dz1_hi=7.040581 dz1_halfwidth=0.002313 chi2min=2.409 dof=8 chi2red=0.301 scaled_lo=7.035954 scaled_hi=7.040581 scaled_halfwidth=0.002313 sigma_int_kms=0 A=100.79 dchi2_vs_A0=245.002
MF set=B est=RM ord=-1 hw=5 lsfpx=2.8 smax=0 dropred=0 tag=lsf2.8 line=Halpha rest=6564.6320 ip=417 lam_ip=52816.13 nwin=9 snr_peakpix=48.61 coarse_z=7.04029 fine_z=7.040288 dz1_lo=7.040039 dz1_hi=7.040536 dz1_halfwidth=0.000249 chi2min=265.079 dof=6 chi2red=44.180 scaled_lo=7.038630 scaled_hi=7.041941 scaled_halfwidth=0.001655 sigma_int_kms=0 A=865.94 dchi2_vs_A0=6867.328
MFJ set=B est=RM ord=-1 hw=5 lsfpx=2.8 smax=0 dropred=0 tag=lsf2.8 joint=HbHa coarse_z=7.04026 fine_z=7.040265 dz1_lo=7.040017 dz1_hi=7.040512 dz1_halfwidth=0.000247 chi2min=268.243 dof=15 chi2red=17.883 scaled_lo=7.039218 scaled_hi=7.041310 scaled_halfwidth=0.001046 sigma_int_kms=[0,0] A=[100.6,865.9] dchi2_vs_A0=7111.575
MF set=B est=RM ord=-1 hw=5 lsfpx=3 smax=0 dropred=0 tag=lsf3.0 line=Hbeta rest=4862.6910 ip=258 lam_ip=39096.01 nwin=11 snr_peakpix=10.29 coarse_z=7.03838 fine_z=7.038383 dz1_lo=7.035999 dz1_hi=7.040776 dz1_halfwidth=0.002388 chi2min=2.406 dof=8 chi2red=0.301 scaled_lo=7.035999 scaled_hi=7.040776 scaled_halfwidth=0.002388 sigma_int_kms=0 A=103.96 dchi2_vs_A0=245.006
MF set=B est=RM ord=-1 hw=5 lsfpx=3 smax=0 dropred=0 tag=lsf3.0 line=Halpha rest=6564.6320 ip=417 lam_ip=52816.13 nwin=9 snr_peakpix=48.61 coarse_z=7.04030 fine_z=7.040302 dz1_lo=7.040049 dz1_hi=7.040554 dz1_halfwidth=0.000253 chi2min=176.734 dof=6 chi2red=29.456 scaled_lo=7.038926 scaled_hi=7.041674 scaled_halfwidth=0.001374 sigma_int_kms=0 A=896.34 dchi2_vs_A0=6955.673
MFJ set=B est=RM ord=-1 hw=5 lsfpx=3 smax=0 dropred=0 tag=lsf3.0 joint=HbHa coarse_z=7.04028 fine_z=7.040280 dz1_lo=7.040029 dz1_hi=7.040532 dz1_halfwidth=0.000251 chi2min=179.777 dof=15 chi2red=11.985 scaled_lo=7.039409 scaled_hi=7.041151 scaled_halfwidth=0.000871 sigma_int_kms=[0,0] A=[103.8,896.3] dchi2_vs_A0=7200.042
--- 4g red-edge test: drop the last N valid pixels (pixel 420 sits below its running-median continuum)
MF set=B est=RM ord=-1 hw=5 lsfpx=2.2 smax=4000 dropred=1 tag=rm_drop1 line=Hbeta rest=4862.6910 ip=258 lam_ip=39096.01 nwin=11 snr_peakpix=10.29 coarse_z=7.03829 fine_z=7.038287 dz1_lo=7.035964 dz1_hi=7.040621 dz1_halfwidth=0.002328 chi2min=2.318 dof=8 chi2red=0.290 scaled_lo=7.035964 scaled_hi=7.040621 scaled_halfwidth=0.002328 sigma_int_kms=600 A=101.47 dchi2_vs_A0=245.093
MF set=B est=RM ord=-1 hw=5 lsfpx=2.2 smax=4000 dropred=1 tag=rm_drop1 line=Halpha rest=6564.6320 ip=417 lam_ip=52816.13 nwin=8 snr_peakpix=48.61 coarse_z=7.04057 fine_z=7.040574 dz1_lo=7.040298 dz1_hi=7.040850 dz1_halfwidth=0.000276 chi2min=53.643 dof=5 chi2red=10.729 scaled_lo=7.039670 scaled_hi=7.041479 scaled_halfwidth=0.000905 sigma_int_kms=500 A=970.11 dchi2_vs_A0=7073.913
MFJ set=B est=RM ord=-1 hw=5 lsfpx=2.2 smax=4000 dropred=1 tag=rm_drop1 joint=HbHa coarse_z=7.04054 fine_z=7.040543 dz1_lo=7.040269 dz1_hi=7.040817 dz1_halfwidth=0.000274 chi2min=56.909 dof=14 chi2red=4.065 scaled_lo=7.039990 scaled_hi=7.041096 scaled_halfwidth=0.000553 sigma_int_kms=[600,500] A=[101.3,970] dchi2_vs_A0=7318.058
MF set=B est=POLY ord=1 hw=5 lsfpx=2.2 smax=4000 dropred=1 tag=poly1_drop1 line=Hbeta rest=4862.6910 ip=258 lam_ip=39096.01 nwin=11 snr_peakpix=10.29 coarse_z=7.03852 fine_z=7.038520 dz1_lo=7.036081 dz1_hi=7.040972 dz1_halfwidth=0.002445 chi2min=1.861 dof=6 chi2red=0.310 scaled_lo=7.036081 scaled_hi=7.040972 scaled_halfwidth=0.002445 sigma_int_kms=600 A=102.61 dchi2_vs_A0=155.799
MF set=B est=POLY ord=1 hw=5 lsfpx=2.2 smax=4000 dropred=1 tag=poly1_drop1 line=Halpha rest=6564.6320 ip=417 lam_ip=52816.13 nwin=8 snr_peakpix=48.61 coarse_z=7.03961 fine_z=7.039613 dz1_lo=7.039269 dz1_hi=7.039955 dz1_halfwidth=0.000343 chi2min=13.013 dof=3 chi2red=4.338 scaled_lo=7.038893 scaled_hi=7.040639 scaled_halfwidth=0.000873 sigma_int_kms=300 A=654.36 dchi2_vs_A0=1631.591
MFJ set=B est=POLY ord=1 hw=5 lsfpx=2.2 smax=4000 dropred=1 tag=poly1_drop1 joint=HbHa coarse_z=7.03959 fine_z=7.039592 dz1_lo=7.039251 dz1_hi=7.039931 dz1_halfwidth=0.000340 chi2min=15.069 dof=10 chi2red=1.507 scaled_lo=7.039173 scaled_hi=7.040007 scaled_halfwidth=0.000417 sigma_int_kms=[600,300] A=[102.5,654] dchi2_vs_A0=1787.194
MF set=B est=RM ord=-1 hw=5 lsfpx=2.2 smax=4000 dropred=2 tag=rm_drop2 line=Hbeta rest=4862.6910 ip=258 lam_ip=39096.01 nwin=11 snr_peakpix=10.29 coarse_z=7.03829 fine_z=7.038287 dz1_lo=7.035964 dz1_hi=7.040621 dz1_halfwidth=0.002328 chi2min=2.318 dof=8 chi2red=0.290 scaled_lo=7.035964 scaled_hi=7.040621 scaled_halfwidth=0.002328 sigma_int_kms=600 A=101.47 dchi2_vs_A0=245.093
MF set=B est=RM ord=-1 hw=5 lsfpx=2.2 smax=4000 dropred=2 tag=rm_drop2 line=Halpha rest=6564.6320 ip=417 lam_ip=52816.13 nwin=7 snr_peakpix=48.61 coarse_z=7.04029 fine_z=7.040288 dz1_lo=7.039988 dz1_hi=7.040589 dz1_halfwidth=0.000300 chi2min=48.357 dof=4 chi2red=12.089 scaled_lo=7.039248 scaled_hi=7.041339 scaled_halfwidth=0.001045 sigma_int_kms=500 A=963.73 dchi2_vs_A0=6763.785
MFJ set=B est=RM ord=-1 hw=5 lsfpx=2.2 smax=4000 dropred=2 tag=rm_drop2 joint=HbHa coarse_z=7.04026 fine_z=7.040256 dz1_lo=7.039958 dz1_hi=7.040554 dz1_halfwidth=0.000298 chi2min=51.400 dof=13 chi2red=3.954 scaled_lo=7.039665 scaled_hi=7.040850 scaled_halfwidth=0.000592 sigma_int_kms=[600,500] A=[101.3,963.5] dchi2_vs_A0=7008.153
MF set=B est=POLY ord=1 hw=5 lsfpx=2.2 smax=4000 dropred=2 tag=poly1_drop2 line=Hbeta rest=4862.6910 ip=258 lam_ip=39096.01 nwin=11 snr_peakpix=10.29 coarse_z=7.03852 fine_z=7.038520 dz1_lo=7.036081 dz1_hi=7.040972 dz1_halfwidth=0.002445 chi2min=1.861 dof=6 chi2red=0.310 scaled_lo=7.036081 scaled_hi=7.040972 scaled_halfwidth=0.002445 sigma_int_kms=600 A=102.61 dchi2_vs_A0=155.799
MF set=B est=POLY ord=1 hw=5 lsfpx=2.2 smax=4000 dropred=2 tag=poly1_drop2 line=Halpha rest=6564.6320 ip=417 lam_ip=52816.13 nwin=7 snr_peakpix=48.61 coarse_z=7.03948 fine_z=7.039485 dz1_lo=7.039107 dz1_hi=7.039855 dz1_halfwidth=0.000374 chi2min=11.942 dof=2 chi2red=5.971 scaled_lo=7.037855 scaled_hi=7.041127 scaled_halfwidth=0.001636 sigma_int_kms=300 A=632.62 dchi2_vs_A0=684.976
MFJ set=B est=POLY ord=1 hw=5 lsfpx=2.2 smax=4000 dropred=2 tag=poly1_drop2 joint=HbHa coarse_z=7.03946 fine_z=7.039463 dz1_lo=7.038540 dz1_hi=7.039829 dz1_halfwidth=0.000645 chi2min=13.955 dof=9 chi2red=1.551 scaled_lo=7.038429 scaled_hi=7.039918 scaled_halfwidth=0.000745 sigma_int_kms=[600,300] A=[102.5,631.9] dchi2_vs_A0=840.623
MF set=B est=RM ord=-1 hw=5 lsfpx=2.2 smax=4000 dropred=3 tag=rm_drop3 line=Hbeta rest=4862.6910 ip=258 lam_ip=39096.01 nwin=11 snr_peakpix=10.29 coarse_z=7.03829 fine_z=7.038287 dz1_lo=7.035964 dz1_hi=7.040621 dz1_halfwidth=0.002328 chi2min=2.318 dof=8 chi2red=0.290 scaled_lo=7.035964 scaled_hi=7.040621 scaled_halfwidth=0.002328 sigma_int_kms=600 A=101.47 dchi2_vs_A0=245.093
MF set=B est=RM ord=-1 hw=5 lsfpx=2.2 smax=4000 dropred=3 tag=rm_drop3 line=Halpha rest=6564.6320 ip=417 lam_ip=52816.13 nwin=6 snr_peakpix=48.61 coarse_z=7.04351 fine_z=7.043507 dz1_lo=7.043028 dz1_hi=7.043991 dz1_halfwidth=0.000481 chi2min=23.461 dof=3 chi2red=7.820 scaled_lo=7.042179 scaled_hi=7.044873 scaled_halfwidth=0.001347 sigma_int_kms=600 A=1111.9 dchi2_vs_A0=5897.565
MFJ set=B est=RM ord=-1 hw=5 lsfpx=2.2 smax=4000 dropred=3 tag=rm_drop3 joint=HbHa coarse_z=7.04332 fine_z=7.043317 dz1_lo=7.042849 dz1_hi=7.043789 dz1_halfwidth=0.000470 chi2min=30.255 dof=12 chi2red=2.521 scaled_lo=7.042576 scaled_hi=7.044069 scaled_halfwidth=0.000746 sigma_int_kms=[700,600] A=[103.6,1107] dchi2_vs_A0=6138.182
MF set=B est=POLY ord=1 hw=5 lsfpx=2.2 smax=4000 dropred=3 tag=poly1_drop3 line=Hbeta rest=4862.6910 ip=258 lam_ip=39096.01 nwin=11 snr_peakpix=10.29 coarse_z=7.03852 fine_z=7.038520 dz1_lo=7.036081 dz1_hi=7.040972 dz1_halfwidth=0.002445 chi2min=1.861 dof=6 chi2red=0.310 scaled_lo=7.036081 scaled_hi=7.040972 scaled_halfwidth=0.002445 sigma_int_kms=600 A=102.61 dchi2_vs_A0=155.799
MF set=B est=POLY ord=1 hw=5 lsfpx=2.2 smax=4000 dropred=3 tag=poly1_drop3 line=Halpha rest=6564.6320 ip=417 lam_ip=52816.13 nwin=6 snr_peakpix=48.61 coarse_z=7.03938 fine_z=7.039380 dz1_lo=7.038702 dz1_hi=7.039875 dz1_halfwidth=0.000586 chi2min=0.134 dof=1 chi2red=0.134 scaled_lo=7.038702 scaled_hi=7.039875 scaled_halfwidth=0.000586 sigma_int_kms=200 A=430.35 dchi2_vs_A0=165.535
MFJ set=B est=POLY ord=1 hw=5 lsfpx=2.2 smax=4000 dropred=3 tag=poly1_drop3 joint=HbHa coarse_z=7.03935 fine_z=7.039347 dz1_lo=7.038651 dz1_hi=7.039831 dz1_halfwidth=0.000590 chi2min=2.114 dof=8 chi2red=0.264 scaled_lo=7.038651 scaled_hi=7.039831 scaled_halfwidth=0.000590 sigma_int_kms=[600,200] A=[102.6,430.4] dchi2_vs_A0=321.215

=== 5. FFT-free flux-weighted centroid vs observed-frame half-window W (100-400 A); CENSUM = spread across windows
CEN set=B dropred=0 tag=cen_B line=Hbeta W_obsA=100 npix_fixed=1 z_fixed=NA z_err=NA z_iter=NA iters=0 iter_status=FAIL(npix<MINPIX_or_nonpositive_sum)
CEN set=B dropred=0 tag=cen_B line=Hbeta W_obsA=125 npix_fixed=3 z_fixed=7.039231 z_err=0.001148 z_iter=7.039231 iters=2 iter_status=ok
CEN set=B dropred=0 tag=cen_B line=Hbeta W_obsA=150 npix_fixed=3 z_fixed=7.039231 z_err=0.001148 z_iter=7.039231 iters=2 iter_status=ok
CEN set=B dropred=0 tag=cen_B line=Hbeta W_obsA=175 npix_fixed=3 z_fixed=7.039231 z_err=0.001148 z_iter=7.039231 iters=2 iter_status=ok
CEN set=B dropred=0 tag=cen_B line=Hbeta W_obsA=200 npix_fixed=3 z_fixed=7.039231 z_err=0.001148 z_iter=7.039231 iters=2 iter_status=ok
CEN set=B dropred=0 tag=cen_B line=Hbeta W_obsA=225 npix_fixed=5 z_fixed=7.038620 z_err=0.002047 z_iter=7.038620 iters=2 iter_status=ok
CEN set=B dropred=0 tag=cen_B line=Hbeta W_obsA=250 npix_fixed=5 z_fixed=7.038620 z_err=0.002047 z_iter=7.038620 iters=2 iter_status=ok
CEN set=B dropred=0 tag=cen_B line=Hbeta W_obsA=275 npix_fixed=5 z_fixed=7.038620 z_err=0.002047 z_iter=7.038620 iters=2 iter_status=ok
CEN set=B dropred=0 tag=cen_B line=Hbeta W_obsA=300 npix_fixed=5 z_fixed=7.038620 z_err=0.002047 z_iter=7.038620 iters=2 iter_status=ok
CEN set=B dropred=0 tag=cen_B line=Hbeta W_obsA=325 npix_fixed=7 z_fixed=7.039571 z_err=0.003137 z_iter=7.039571 iters=2 iter_status=ok
CEN set=B dropred=0 tag=cen_B line=Hbeta W_obsA=350 npix_fixed=7 z_fixed=7.039571 z_err=0.003137 z_iter=7.039571 iters=2 iter_status=ok
CEN set=B dropred=0 tag=cen_B line=Hbeta W_obsA=375 npix_fixed=7 z_fixed=7.039571 z_err=0.003137 z_iter=7.039571 iters=2 iter_status=ok
CEN set=B dropred=0 tag=cen_B line=Hbeta W_obsA=400 npix_fixed=7 z_fixed=7.039571 z_err=0.003137 z_iter=7.039571 iters=2 iter_status=ok
CEN set=B dropred=0 tag=cen_B line=Halpha W_obsA=100 npix_fixed=3 z_fixed=7.043930 z_err=0.000127 z_iter=7.043930 iters=2 iter_status=ok
CEN set=B dropred=0 tag=cen_B line=Halpha W_obsA=125 npix_fixed=3 z_fixed=7.043930 z_err=0.000127 z_iter=7.043930 iters=2 iter_status=ok
CEN set=B dropred=0 tag=cen_B line=Halpha W_obsA=150 npix_fixed=5 z_fixed=7.042815 z_err=0.000195 z_iter=7.040177 iters=3 iter_status=ok
CEN set=B dropred=0 tag=cen_B line=Halpha W_obsA=175 npix_fixed=5 z_fixed=7.042815 z_err=0.000195 z_iter=7.042815 iters=2 iter_status=ok
CEN set=B dropred=0 tag=cen_B line=Halpha W_obsA=200 npix_fixed=5 z_fixed=7.042815 z_err=0.000195 z_iter=7.042815 iters=2 iter_status=ok
CEN set=B dropred=0 tag=cen_B line=Halpha W_obsA=225 npix_fixed=7 z_fixed=7.040208 z_err=0.000308 z_iter=7.040660 iters=3 iter_status=ok
CEN set=B dropred=0 tag=cen_B line=Halpha W_obsA=250 npix_fixed=7 z_fixed=7.040208 z_err=0.000308 z_iter=7.040660 iters=3 iter_status=ok
CEN set=B dropred=0 tag=cen_B line=Halpha W_obsA=275 npix_fixed=7 z_fixed=7.040208 z_err=0.000308 z_iter=7.038738 iters=3 iter_status=ok
CEN set=B dropred=0 tag=cen_B line=Halpha W_obsA=300 npix_fixed=8 z_fixed=7.038738 z_err=0.000341 z_iter=7.038738 iters=2 iter_status=ok
CEN set=B dropred=0 tag=cen_B line=Halpha W_obsA=325 npix_fixed=8 z_fixed=7.038738 z_err=0.000341 z_iter=7.038738 iters=2 iter_status=ok
CEN set=B dropred=0 tag=cen_B line=Halpha W_obsA=350 npix_fixed=8 z_fixed=7.038738 z_err=0.000341 z_iter=7.038117 iters=3 iter_status=ok
CEN set=B dropred=0 tag=cen_B line=Halpha W_obsA=375 npix_fixed=9 z_fixed=7.038117 z_err=0.000383 z_iter=7.038117 iters=2 iter_status=ok
CEN set=B dropred=0 tag=cen_B line=Halpha W_obsA=400 npix_fixed=9 z_fixed=7.038117 z_err=0.000383 z_iter=7.037834 iters=3 iter_status=ok
CENSUM set=B dropred=0 tag=cen_B line=Hbeta kind=fixed nW=12 min=7.038620 max=7.039571 range=0.000951 mean=7.039141 sd_over_windows=0.000411
CENSUM set=B dropred=0 tag=cen_B line=Hbeta kind=iter nW=12 min=7.038620 max=7.039571 range=0.000951 mean=7.039141 sd_over_windows=0.000411
CENSUM set=B dropred=0 tag=cen_B line=Halpha kind=fixed nW=13 min=7.038117 max=7.043930 range=0.005814 mean=7.040721 sd_over_windows=0.002234
CENSUM set=B dropred=0 tag=cen_B line=Halpha kind=iter nW=13 min=7.037834 max=7.043930 range=0.006096 mean=7.040405 sd_over_windows=0.002274
CENJ set=B dropred=0 tag=cen_B kind=fixed W_obsA=125 z_joint_ivmean=7.043874 err=0.000126
CENJ set=B dropred=0 tag=cen_B kind=iter W_obsA=125 z_joint_ivmean=7.043874 err=0.000126
CENJ set=B dropred=0 tag=cen_B kind=fixed W_obsA=150 z_joint_ivmean=7.042715 err=0.000192
CENJ set=B dropred=0 tag=cen_B kind=iter W_obsA=150 z_joint_ivmean=7.040160 err=0.000152
CENJ set=B dropred=0 tag=cen_B kind=fixed W_obsA=175 z_joint_ivmean=7.042715 err=0.000192
CENJ set=B dropred=0 tag=cen_B kind=iter W_obsA=175 z_joint_ivmean=7.042715 err=0.000192
CENJ set=B dropred=0 tag=cen_B kind=fixed W_obsA=200 z_joint_ivmean=7.042715 err=0.000192
CENJ set=B dropred=0 tag=cen_B kind=iter W_obsA=200 z_joint_ivmean=7.042715 err=0.000192
CENJ set=B dropred=0 tag=cen_B kind=fixed W_obsA=225 z_joint_ivmean=7.040173 err=0.000305
CENJ set=B dropred=0 tag=cen_B kind=iter W_obsA=225 z_joint_ivmean=7.040635 err=0.000223
CENJ set=B dropred=0 tag=cen_B kind=fixed W_obsA=250 z_joint_ivmean=7.040173 err=0.000305
CENJ set=B dropred=0 tag=cen_B kind=iter W_obsA=250 z_joint_ivmean=7.040635 err=0.000223
CENJ set=B dropred=0 tag=cen_B kind=fixed W_obsA=275 z_joint_ivmean=7.040173 err=0.000305
CENJ set=B dropred=0 tag=cen_B kind=iter W_obsA=275 z_joint_ivmean=7.038735 err=0.000336
CENJ set=B dropred=0 tag=cen_B kind=fixed W_obsA=300 z_joint_ivmean=7.038735 err=0.000336
CENJ set=B dropred=0 tag=cen_B kind=iter W_obsA=300 z_joint_ivmean=7.038735 err=0.000336
CENJ set=B dropred=0 tag=cen_B kind=fixed W_obsA=325 z_joint_ivmean=7.038748 err=0.000339
CENJ set=B dropred=0 tag=cen_B kind=iter W_obsA=325 z_joint_ivmean=7.038748 err=0.000339
CENJ set=B dropred=0 tag=cen_B kind=fixed W_obsA=350 z_joint_ivmean=7.038748 err=0.000339
CENJ set=B dropred=0 tag=cen_B kind=iter W_obsA=350 z_joint_ivmean=7.038138 err=0.000380
CENJ set=B dropred=0 tag=cen_B kind=fixed W_obsA=375 z_joint_ivmean=7.038138 err=0.000380
CENJ set=B dropred=0 tag=cen_B kind=iter W_obsA=375 z_joint_ivmean=7.038138 err=0.000380
CENJ set=B dropred=0 tag=cen_B kind=fixed W_obsA=400 z_joint_ivmean=7.038138 err=0.000380
CENJ set=B dropred=0 tag=cen_B kind=iter W_obsA=400 z_joint_ivmean=7.037868 err=0.000435
CEN set=A dropred=0 tag=cen_A line=Hbeta W_obsA=100 npix_fixed=1 z_fixed=NA z_err=NA z_iter=NA iters=0 iter_status=FAIL(npix<MINPIX_or_nonpositive_sum)
CEN set=A dropred=0 tag=cen_A line=Hbeta W_obsA=125 npix_fixed=3 z_fixed=7.041448 z_err=0.001148 z_iter=7.041448 iters=2 iter_status=ok
CEN set=A dropred=0 tag=cen_A line=Hbeta W_obsA=150 npix_fixed=3 z_fixed=7.041448 z_err=0.001148 z_iter=7.041448 iters=2 iter_status=ok
CEN set=A dropred=0 tag=cen_A line=Hbeta W_obsA=175 npix_fixed=3 z_fixed=7.041448 z_err=0.001148 z_iter=7.041448 iters=2 iter_status=ok
CEN set=A dropred=0 tag=cen_A line=Hbeta W_obsA=200 npix_fixed=3 z_fixed=7.041448 z_err=0.001148 z_iter=7.041448 iters=2 iter_status=ok
CEN set=A dropred=0 tag=cen_A line=Hbeta W_obsA=225 npix_fixed=5 z_fixed=7.040838 z_err=0.002048 z_iter=7.040838 iters=2 iter_status=ok
CEN set=A dropred=0 tag=cen_A line=Hbeta W_obsA=250 npix_fixed=5 z_fixed=7.040838 z_err=0.002048 z_iter=7.040838 iters=2 iter_status=ok
CEN set=A dropred=0 tag=cen_A line=Hbeta W_obsA=275 npix_fixed=5 z_fixed=7.040838 z_err=0.002048 z_iter=7.040838 iters=2 iter_status=ok
CEN set=A dropred=0 tag=cen_A line=Hbeta W_obsA=300 npix_fixed=5 z_fixed=7.040838 z_err=0.002048 z_iter=7.040838 iters=2 iter_status=ok
CEN set=A dropred=0 tag=cen_A line=Hbeta W_obsA=325 npix_fixed=7 z_fixed=7.041789 z_err=0.003138 z_iter=7.041789 iters=2 iter_status=ok
CEN set=A dropred=0 tag=cen_A line=Hbeta W_obsA=350 npix_fixed=7 z_fixed=7.041789 z_err=0.003138 z_iter=7.041789 iters=2 iter_status=ok
CEN set=A dropred=0 tag=cen_A line=Hbeta W_obsA=375 npix_fixed=7 z_fixed=7.041789 z_err=0.003138 z_iter=7.041789 iters=2 iter_status=ok
CEN set=A dropred=0 tag=cen_A line=Hbeta W_obsA=400 npix_fixed=7 z_fixed=7.041789 z_err=0.003138 z_iter=7.041789 iters=2 iter_status=ok
CEN set=A dropred=0 tag=cen_A line=Halpha W_obsA=100 npix_fixed=3 z_fixed=7.046176 z_err=0.000127 z_iter=7.046176 iters=2 iter_status=ok
CEN set=A dropred=0 tag=cen_A line=Halpha W_obsA=125 npix_fixed=3 z_fixed=7.046176 z_err=0.000127 z_iter=7.046176 iters=2 iter_status=ok
CEN set=A dropred=0 tag=cen_A line=Halpha W_obsA=150 npix_fixed=5 z_fixed=7.045060 z_err=0.000195 z_iter=7.042421 iters=3 iter_status=ok
CEN set=A dropred=0 tag=cen_A line=Halpha W_obsA=175 npix_fixed=5 z_fixed=7.045060 z_err=0.000195 z_iter=7.045060 iters=2 iter_status=ok
CEN set=A dropred=0 tag=cen_A line=Halpha W_obsA=200 npix_fixed=5 z_fixed=7.045060 z_err=0.000195 z_iter=7.045060 iters=2 iter_status=ok
CEN set=A dropred=0 tag=cen_A line=Halpha W_obsA=225 npix_fixed=7 z_fixed=7.042453 z_err=0.000308 z_iter=7.042904 iters=3 iter_status=ok
CEN set=A dropred=0 tag=cen_A line=Halpha W_obsA=250 npix_fixed=7 z_fixed=7.042453 z_err=0.000308 z_iter=7.042904 iters=3 iter_status=ok
CEN set=A dropred=0 tag=cen_A line=Halpha W_obsA=275 npix_fixed=7 z_fixed=7.042453 z_err=0.000308 z_iter=7.040982 iters=3 iter_status=ok
CEN set=A dropred=0 tag=cen_A line=Halpha W_obsA=300 npix_fixed=8 z_fixed=7.040982 z_err=0.000341 z_iter=7.040982 iters=2 iter_status=ok
CEN set=A dropred=0 tag=cen_A line=Halpha W_obsA=325 npix_fixed=8 z_fixed=7.040982 z_err=0.000341 z_iter=7.040982 iters=2 iter_status=ok
CEN set=A dropred=0 tag=cen_A line=Halpha W_obsA=350 npix_fixed=8 z_fixed=7.040982 z_err=0.000341 z_iter=7.040360 iters=3 iter_status=ok
CEN set=A dropred=0 tag=cen_A line=Halpha W_obsA=375 npix_fixed=9 z_fixed=7.040360 z_err=0.000383 z_iter=7.040360 iters=2 iter_status=ok
CEN set=A dropred=0 tag=cen_A line=Halpha W_obsA=400 npix_fixed=9 z_fixed=7.040360 z_err=0.000383 z_iter=7.040078 iters=3 iter_status=ok
CENSUM set=A dropred=0 tag=cen_A line=Hbeta kind=fixed nW=12 min=7.040838 max=7.041789 range=0.000951 mean=7.041358 sd_over_windows=0.000411
CENSUM set=A dropred=0 tag=cen_A line=Hbeta kind=iter nW=12 min=7.040838 max=7.041789 range=0.000951 mean=7.041358 sd_over_windows=0.000411
CENSUM set=A dropred=0 tag=cen_A line=Halpha kind=fixed nW=13 min=7.040360 max=7.046176 range=0.005815 mean=7.042966 sd_over_windows=0.002235
CENSUM set=A dropred=0 tag=cen_A line=Halpha kind=iter nW=13 min=7.040078 max=7.046176 range=0.006098 mean=7.042650 sd_over_windows=0.002275
CENJ set=A dropred=0 tag=cen_A kind=fixed W_obsA=125 z_joint_ivmean=7.046119 err=0.000126
CENJ set=A dropred=0 tag=cen_A kind=iter W_obsA=125 z_joint_ivmean=7.046119 err=0.000126
CENJ set=A dropred=0 tag=cen_A kind=fixed W_obsA=150 z_joint_ivmean=7.044959 err=0.000192
CENJ set=A dropred=0 tag=cen_A kind=iter W_obsA=150 z_joint_ivmean=7.042404 err=0.000152
CENJ set=A dropred=0 tag=cen_A kind=fixed W_obsA=175 z_joint_ivmean=7.044959 err=0.000192
CENJ set=A dropred=0 tag=cen_A kind=iter W_obsA=175 z_joint_ivmean=7.044959 err=0.000192
CENJ set=A dropred=0 tag=cen_A kind=fixed W_obsA=200 z_joint_ivmean=7.044959 err=0.000192
CENJ set=A dropred=0 tag=cen_A kind=iter W_obsA=200 z_joint_ivmean=7.044959 err=0.000192
CENJ set=A dropred=0 tag=cen_A kind=fixed W_obsA=225 z_joint_ivmean=7.042417 err=0.000305
CENJ set=A dropred=0 tag=cen_A kind=iter W_obsA=225 z_joint_ivmean=7.042879 err=0.000224
CENJ set=A dropred=0 tag=cen_A kind=fixed W_obsA=250 z_joint_ivmean=7.042417 err=0.000305
CENJ set=A dropred=0 tag=cen_A kind=iter W_obsA=250 z_joint_ivmean=7.042879 err=0.000224
CENJ set=A dropred=0 tag=cen_A kind=fixed W_obsA=275 z_joint_ivmean=7.042417 err=0.000305
CENJ set=A dropred=0 tag=cen_A kind=iter W_obsA=275 z_joint_ivmean=7.040978 err=0.000336
CENJ set=A dropred=0 tag=cen_A kind=fixed W_obsA=300 z_joint_ivmean=7.040978 err=0.000336
CENJ set=A dropred=0 tag=cen_A kind=iter W_obsA=300 z_joint_ivmean=7.040978 err=0.000336
CENJ set=A dropred=0 tag=cen_A kind=fixed W_obsA=325 z_joint_ivmean=7.040991 err=0.000339
CENJ set=A dropred=0 tag=cen_A kind=iter W_obsA=325 z_joint_ivmean=7.040991 err=0.000339
CENJ set=A dropred=0 tag=cen_A kind=fixed W_obsA=350 z_joint_ivmean=7.040991 err=0.000339
CENJ set=A dropred=0 tag=cen_A kind=iter W_obsA=350 z_joint_ivmean=7.040381 err=0.000381
CENJ set=A dropred=0 tag=cen_A kind=fixed W_obsA=375 z_joint_ivmean=7.040381 err=0.000381
CENJ set=A dropred=0 tag=cen_A kind=iter W_obsA=375 z_joint_ivmean=7.040381 err=0.000381
CENJ set=A dropred=0 tag=cen_A kind=fixed W_obsA=400 z_joint_ivmean=7.040381 err=0.000381
CENJ set=A dropred=0 tag=cen_A kind=iter W_obsA=400 z_joint_ivmean=7.040111 err=0.000436
--- centroid with the last valid pixel dropped (set B)
CEN set=B dropred=1 tag=cen_B_drop1 line=Hbeta W_obsA=100 npix_fixed=1 z_fixed=NA z_err=NA z_iter=NA iters=0 iter_status=FAIL(npix<MINPIX_or_nonpositive_sum)
CEN set=B dropred=1 tag=cen_B_drop1 line=Hbeta W_obsA=125 npix_fixed=3 z_fixed=7.039231 z_err=0.001148 z_iter=7.039231 iters=2 iter_status=ok
CEN set=B dropred=1 tag=cen_B_drop1 line=Hbeta W_obsA=150 npix_fixed=3 z_fixed=7.039231 z_err=0.001148 z_iter=7.039231 iters=2 iter_status=ok
CEN set=B dropred=1 tag=cen_B_drop1 line=Hbeta W_obsA=175 npix_fixed=3 z_fixed=7.039231 z_err=0.001148 z_iter=7.039231 iters=2 iter_status=ok
CEN set=B dropred=1 tag=cen_B_drop1 line=Hbeta W_obsA=200 npix_fixed=3 z_fixed=7.039231 z_err=0.001148 z_iter=7.039231 iters=2 iter_status=ok
CEN set=B dropred=1 tag=cen_B_drop1 line=Hbeta W_obsA=225 npix_fixed=5 z_fixed=7.038620 z_err=0.002047 z_iter=7.038620 iters=2 iter_status=ok
CEN set=B dropred=1 tag=cen_B_drop1 line=Hbeta W_obsA=250 npix_fixed=5 z_fixed=7.038620 z_err=0.002047 z_iter=7.038620 iters=2 iter_status=ok
CEN set=B dropred=1 tag=cen_B_drop1 line=Hbeta W_obsA=275 npix_fixed=5 z_fixed=7.038620 z_err=0.002047 z_iter=7.038620 iters=2 iter_status=ok
CEN set=B dropred=1 tag=cen_B_drop1 line=Hbeta W_obsA=300 npix_fixed=5 z_fixed=7.038620 z_err=0.002047 z_iter=7.038620 iters=2 iter_status=ok
CEN set=B dropred=1 tag=cen_B_drop1 line=Hbeta W_obsA=325 npix_fixed=7 z_fixed=7.039571 z_err=0.003137 z_iter=7.039571 iters=2 iter_status=ok
CEN set=B dropred=1 tag=cen_B_drop1 line=Hbeta W_obsA=350 npix_fixed=7 z_fixed=7.039571 z_err=0.003137 z_iter=7.039571 iters=2 iter_status=ok
CEN set=B dropred=1 tag=cen_B_drop1 line=Hbeta W_obsA=375 npix_fixed=7 z_fixed=7.039571 z_err=0.003137 z_iter=7.039571 iters=2 iter_status=ok
CEN set=B dropred=1 tag=cen_B_drop1 line=Hbeta W_obsA=400 npix_fixed=7 z_fixed=7.039571 z_err=0.003137 z_iter=7.039571 iters=2 iter_status=ok
CEN set=B dropred=1 tag=cen_B_drop1 line=Halpha W_obsA=100 npix_fixed=3 z_fixed=7.043930 z_err=0.000127 z_iter=7.043930 iters=2 iter_status=ok
CEN set=B dropred=1 tag=cen_B_drop1 line=Halpha W_obsA=125 npix_fixed=3 z_fixed=7.043930 z_err=0.000127 z_iter=7.043930 iters=2 iter_status=ok
CEN set=B dropred=1 tag=cen_B_drop1 line=Halpha W_obsA=150 npix_fixed=5 z_fixed=7.042815 z_err=0.000195 z_iter=7.040177 iters=3 iter_status=ok
CEN set=B dropred=1 tag=cen_B_drop1 line=Halpha W_obsA=175 npix_fixed=5 z_fixed=7.042815 z_err=0.000195 z_iter=7.042815 iters=2 iter_status=ok
CEN set=B dropred=1 tag=cen_B_drop1 line=Halpha W_obsA=200 npix_fixed=5 z_fixed=7.042815 z_err=0.000195 z_iter=7.042815 iters=2 iter_status=ok
CEN set=B dropred=1 tag=cen_B_drop1 line=Halpha W_obsA=225 npix_fixed=6 z_fixed=7.040660 z_err=0.000225 z_iter=7.040660 iters=2 iter_status=ok
CEN set=B dropred=1 tag=cen_B_drop1 line=Halpha W_obsA=250 npix_fixed=6 z_fixed=7.040660 z_err=0.000225 z_iter=7.040660 iters=2 iter_status=ok
CEN set=B dropred=1 tag=cen_B_drop1 line=Halpha W_obsA=275 npix_fixed=6 z_fixed=7.040660 z_err=0.000225 z_iter=7.039189 iters=3 iter_status=ok
CEN set=B dropred=1 tag=cen_B_drop1 line=Halpha W_obsA=300 npix_fixed=7 z_fixed=7.039189 z_err=0.000268 z_iter=7.039189 iters=2 iter_status=ok
CEN set=B dropred=1 tag=cen_B_drop1 line=Halpha W_obsA=325 npix_fixed=7 z_fixed=7.039189 z_err=0.000268 z_iter=7.039189 iters=2 iter_status=ok
CEN set=B dropred=1 tag=cen_B_drop1 line=Halpha W_obsA=350 npix_fixed=7 z_fixed=7.039189 z_err=0.000268 z_iter=7.038569 iters=3 iter_status=ok
CEN set=B dropred=1 tag=cen_B_drop1 line=Halpha W_obsA=375 npix_fixed=8 z_fixed=7.038569 z_err=0.000320 z_iter=7.038569 iters=2 iter_status=ok
CEN set=B dropred=1 tag=cen_B_drop1 line=Halpha W_obsA=400 npix_fixed=8 z_fixed=7.038569 z_err=0.000320 z_iter=7.038569 iters=2 iter_status=ok
CENSUM set=B dropred=1 tag=cen_B_drop1 line=Hbeta kind=fixed nW=12 min=7.038620 max=7.039571 range=0.000951 mean=7.039141 sd_over_windows=0.000411
CENSUM set=B dropred=1 tag=cen_B_drop1 line=Hbeta kind=iter nW=12 min=7.038620 max=7.039571 range=0.000951 mean=7.039141 sd_over_windows=0.000411
CENSUM set=B dropred=1 tag=cen_B_drop1 line=Halpha kind=fixed nW=13 min=7.038569 max=7.043930 range=0.005361 mean=7.040999 sd_over_windows=0.002022
CENSUM set=B dropred=1 tag=cen_B_drop1 line=Halpha kind=iter nW=13 min=7.038569 max=7.043930 range=0.005361 mean=7.040636 sd_over_windows=0.002052
CENJ set=B dropred=1 tag=cen_B_drop1 kind=fixed W_obsA=125 z_joint_ivmean=7.043874 err=0.000126
CENJ set=B dropred=1 tag=cen_B_drop1 kind=iter W_obsA=125 z_joint_ivmean=7.043874 err=0.000126
CENJ set=B dropred=1 tag=cen_B_drop1 kind=fixed W_obsA=150 z_joint_ivmean=7.042715 err=0.000192
CENJ set=B dropred=1 tag=cen_B_drop1 kind=iter W_obsA=150 z_joint_ivmean=7.040160 err=0.000152
CENJ set=B dropred=1 tag=cen_B_drop1 kind=fixed W_obsA=175 z_joint_ivmean=7.042715 err=0.000192
CENJ set=B dropred=1 tag=cen_B_drop1 kind=iter W_obsA=175 z_joint_ivmean=7.042715 err=0.000192
CENJ set=B dropred=1 tag=cen_B_drop1 kind=fixed W_obsA=200 z_joint_ivmean=7.042715 err=0.000192
CENJ set=B dropred=1 tag=cen_B_drop1 kind=iter W_obsA=200 z_joint_ivmean=7.042715 err=0.000192
CENJ set=B dropred=1 tag=cen_B_drop1 kind=fixed W_obsA=225 z_joint_ivmean=7.040635 err=0.000223
CENJ set=B dropred=1 tag=cen_B_drop1 kind=iter W_obsA=225 z_joint_ivmean=7.040635 err=0.000223
CENJ set=B dropred=1 tag=cen_B_drop1 kind=fixed W_obsA=250 z_joint_ivmean=7.040635 err=0.000223
CENJ set=B dropred=1 tag=cen_B_drop1 kind=iter W_obsA=250 z_joint_ivmean=7.040635 err=0.000223
CENJ set=B dropred=1 tag=cen_B_drop1 kind=fixed W_obsA=275 z_joint_ivmean=7.040635 err=0.000223
CENJ set=B dropred=1 tag=cen_B_drop1 kind=iter W_obsA=275 z_joint_ivmean=7.039180 err=0.000266
CENJ set=B dropred=1 tag=cen_B_drop1 kind=fixed W_obsA=300 z_joint_ivmean=7.039180 err=0.000266
CENJ set=B dropred=1 tag=cen_B_drop1 kind=iter W_obsA=300 z_joint_ivmean=7.039180 err=0.000266
CENJ set=B dropred=1 tag=cen_B_drop1 kind=fixed W_obsA=325 z_joint_ivmean=7.039192 err=0.000267
CENJ set=B dropred=1 tag=cen_B_drop1 kind=iter W_obsA=325 z_joint_ivmean=7.039192 err=0.000267
CENJ set=B dropred=1 tag=cen_B_drop1 kind=fixed W_obsA=350 z_joint_ivmean=7.039192 err=0.000267
CENJ set=B dropred=1 tag=cen_B_drop1 kind=iter W_obsA=350 z_joint_ivmean=7.038580 err=0.000318
CENJ set=B dropred=1 tag=cen_B_drop1 kind=fixed W_obsA=375 z_joint_ivmean=7.038580 err=0.000318
CENJ set=B dropred=1 tag=cen_B_drop1 kind=iter W_obsA=375 z_joint_ivmean=7.038580 err=0.000318
CENJ set=B dropred=1 tag=cen_B_drop1 kind=fixed W_obsA=400 z_joint_ivmean=7.038580 err=0.000318
CENJ set=B dropred=1 tag=cen_B_drop1 kind=iter W_obsA=400 z_joint_ivmean=7.038580 err=0.000318

=== 6. SYNTHETIC (NOT REAL DATA) centroid-window bias: noise-free injection at z_true=7.0451 on the real grid/mask, amplitudes+widths = the real primary fit
synthetic injection spec (line:A[1e-20 cgs]:sigma_int[km/s], parsed from primary real-data fit): 1:101.47:600 4:965.55:500
SYNTH-NOTE SYNTHETIC mode=inject seed=1 noise_scale=0 z_true=7.0451 set=B (NOT REAL DATA); K=median(cont*lam^2, lam>35000A)=8.06096e+08 from 200 px
BIAS SYNTHETIC line=Hbeta W_obsA=100 z_fixed=NA
BIAS SYNTHETIC line=Hbeta W_obsA=125 z_fixed=7.042047 bias_vs_ztrue=-0.003053
BIAS SYNTHETIC line=Hbeta W_obsA=150 z_fixed=7.042047 bias_vs_ztrue=-0.003053
BIAS SYNTHETIC line=Hbeta W_obsA=175 z_fixed=7.042047 bias_vs_ztrue=-0.003053
BIAS SYNTHETIC line=Hbeta W_obsA=200 z_fixed=7.042047 bias_vs_ztrue=-0.003053
BIAS SYNTHETIC line=Hbeta W_obsA=225 z_fixed=7.044979 bias_vs_ztrue=-0.000121
BIAS SYNTHETIC line=Hbeta W_obsA=250 z_fixed=7.044979 bias_vs_ztrue=-0.000121
BIAS SYNTHETIC line=Hbeta W_obsA=275 z_fixed=7.044979 bias_vs_ztrue=-0.000121
BIAS SYNTHETIC line=Hbeta W_obsA=300 z_fixed=7.044979 bias_vs_ztrue=-0.000121
BIAS SYNTHETIC line=Hbeta W_obsA=325 z_fixed=7.047076 bias_vs_ztrue=+0.001976
BIAS SYNTHETIC line=Hbeta W_obsA=350 z_fixed=7.047076 bias_vs_ztrue=+0.001976
BIAS SYNTHETIC line=Hbeta W_obsA=375 z_fixed=7.047076 bias_vs_ztrue=+0.001976
BIAS SYNTHETIC line=Hbeta W_obsA=400 z_fixed=7.047076 bias_vs_ztrue=+0.001976
BIAS SYNTHETIC line=Halpha W_obsA=100 z_fixed=7.045435 bias_vs_ztrue=+0.000335
BIAS SYNTHETIC line=Halpha W_obsA=125 z_fixed=7.045435 bias_vs_ztrue=+0.000335
BIAS SYNTHETIC line=Halpha W_obsA=150 z_fixed=7.045278 bias_vs_ztrue=+0.000178
BIAS SYNTHETIC line=Halpha W_obsA=175 z_fixed=7.045278 bias_vs_ztrue=+0.000178
BIAS SYNTHETIC line=Halpha W_obsA=200 z_fixed=7.045278 bias_vs_ztrue=+0.000178
BIAS SYNTHETIC line=Halpha W_obsA=225 z_fixed=7.045173 bias_vs_ztrue=+0.000073
BIAS SYNTHETIC line=Halpha W_obsA=250 z_fixed=7.045173 bias_vs_ztrue=+0.000073
BIAS SYNTHETIC line=Halpha W_obsA=275 z_fixed=7.045173 bias_vs_ztrue=+0.000073
BIAS SYNTHETIC line=Halpha W_obsA=300 z_fixed=7.044775 bias_vs_ztrue=-0.000325
BIAS SYNTHETIC line=Halpha W_obsA=325 z_fixed=7.044775 bias_vs_ztrue=-0.000325
BIAS SYNTHETIC line=Halpha W_obsA=350 z_fixed=7.044775 bias_vs_ztrue=-0.000325
BIAS SYNTHETIC line=Halpha W_obsA=375 z_fixed=7.044725 bias_vs_ztrue=-0.000375
BIAS SYNTHETIC line=Halpha W_obsA=400 z_fixed=7.044725 bias_vs_ztrue=-0.000375
BIASSUM SYNTHETIC line=Halpha n_windows=13 bias_min=-0.000375 bias_max=+0.000335 bias_range=0.000710 (ztrue=7.0451)
BIASSUM SYNTHETIC line=Hbeta n_windows=12 bias_min=-0.003053 bias_max=+0.001976 bias_range=0.005029 (ztrue=7.0451)
--- SYNTHETIC matched-filter recovery, noise-free, z_true=7.0451 (RM and POLY1)
MF set=B est=RM ord=-1 hw=5 lsfpx=2.2 smax=4000 dropred=0 tag=SYNTHETIC_rm line=Hbeta rest=4862.6910 ip=258 lam_ip=39096.01 nwin=11 snr_peakpix=9.72 coarse_z=7.04606 fine_z=7.046061 dz1_lo=7.043617 dz1_hi=7.048520 dz1_halfwidth=0.002451 chi2min=0.544 dof=8 chi2red=0.068 scaled_lo=7.043617 scaled_hi=7.048520 scaled_halfwidth=0.002451 sigma_int_kms=600 A=96.093 dchi2_vs_A0=220.762
MF set=B est=RM ord=-1 hw=5 lsfpx=2.2 smax=4000 dropred=0 tag=SYNTHETIC_rm line=Halpha rest=6564.6320 ip=417 lam_ip=52816.13 nwin=9 snr_peakpix=48.07 coarse_z=7.04510 fine_z=7.045100 dz1_lo=7.044823 dz1_hi=7.045377 dz1_halfwidth=0.000277 chi2min=0.068 dof=6 chi2red=0.011 scaled_lo=7.044823 scaled_hi=7.045377 scaled_halfwidth=0.000277 sigma_int_kms=500 A=962.03 dchi2_vs_A0=6862.196
MFJ set=B est=RM ord=-1 hw=5 lsfpx=2.2 smax=4000 dropred=0 tag=SYNTHETIC_rm joint=HbHa coarse_z=7.04511 fine_z=7.045112 dz1_lo=7.044837 dz1_hi=7.045388 dz1_halfwidth=0.000275 chi2min=0.763 dof=15 chi2red=0.051 scaled_lo=7.044837 scaled_hi=7.045388 scaled_halfwidth=0.000275 sigma_int_kms=[600,500] A=[96.1,962] dchi2_vs_A0=7082.805
MF set=B est=POLY ord=1 hw=5 lsfpx=2.2 smax=4000 dropred=0 tag=SYNTHETIC_poly1 line=Hbeta rest=4862.6910 ip=258 lam_ip=39096.01 nwin=11 snr_peakpix=9.72 coarse_z=7.04510 fine_z=7.045102 dz1_lo=7.042623 dz1_hi=7.047586 dz1_halfwidth=0.002482 chi2min=0.000 dof=6 chi2red=0.000 scaled_lo=7.042623 scaled_hi=7.047586 scaled_halfwidth=0.002482 sigma_int_kms=600 A=101.4 dchi2_vs_A0=152.001
MF set=B est=POLY ord=1 hw=5 lsfpx=2.2 smax=4000 dropred=0 tag=SYNTHETIC_poly1 line=Halpha rest=6564.6320 ip=417 lam_ip=52816.13 nwin=9 snr_peakpix=48.07 coarse_z=7.04510 fine_z=7.045100 dz1_lo=7.044744 dz1_hi=7.045454 dz1_halfwidth=0.000355 chi2min=0.000 dof=4 chi2red=0.000 scaled_lo=7.044744 scaled_hi=7.045454 scaled_halfwidth=0.000355 sigma_int_kms=500 A=965.54 dchi2_vs_A0=2390.006
MFJ set=B est=POLY ord=1 hw=5 lsfpx=2.2 smax=4000 dropred=0 tag=SYNTHETIC_poly1 joint=HbHa coarse_z=7.04510 fine_z=7.045100 dz1_lo=7.044747 dz1_hi=7.045451 dz1_halfwidth=0.000352 chi2min=0.000 dof=11 chi2red=0.000 scaled_lo=7.044747 scaled_hi=7.045451 scaled_halfwidth=0.000352 sigma_int_kms=[600,500] A=[101.4,965.5] dchi2_vs_A0=2542.007

=== 7. comparison table (parsed from this log; ZF=Fortran 7.04221+-0.00027, ZP=published 7.0451+-0.0005)
run(tag)                   joint/line est    z            dz1_hw     scaled_hw  | z-ZF[e-5] z-ZP[e-5] | z-ZP[km/s] z-ZP[A@Ha] [px]     sigmas 
primary                    Hbeta     RM     7.038287     0.002328   0.002328   |    -392.3    -681.3 |     -254.1
primary                    Halpha    RM     7.040306     0.000270   0.001073   |    -190.4    -479.4 |     -178.8    -31.47   -0.424
primary                    joint-HbHa RM     7.040280     0.000268   0.000685   |    -193.0    -482.0 |     -179.7    -31.64   -0.426 5.7    
lsfonly                    Hbeta     RM     7.038028     0.002148   0.002445   |    -418.2    -707.2 |     -263.8
lsfonly                    Halpha    RM     7.040180     0.000241   0.002733   |    -203.0    -492.0 |     -183.5    -32.30   -0.435
lsfonly                    joint-HbHa RM     7.040153     0.000239   0.001724   |    -205.7    -494.7 |     -184.5    -32.48   -0.438 2.8    
setA                       Hbeta     RM     7.040505     0.002329   0.002329   |    -170.5    -459.5 |     -171.3
setA                       Halpha    RM     7.042551     0.000270   0.001074   |     +34.1    -254.9 |      -95.0    -16.73   -0.225
setA                       joint-HbHa RM     7.042524     0.000268   0.000685   |     +31.4    -257.6 |      -96.0    -16.91   -0.228 3.0    
setC                       Hbeta     RM     7.038259     0.002328   0.002328   |    -395.1    -684.1 |     -255.1
setC                       Halpha    RM     7.040330     0.000270   0.001073   |    -188.0    -477.0 |     -177.9    -31.31   -0.422
setC                       joint-HbHa RM     7.040303     0.000268   0.000685   |    -190.7    -479.7 |     -178.9    -31.49   -0.424 5.7    
poly1                      Hbeta     POLY   7.038520     0.002445   0.002445   |    -369.0    -658.0 |     -245.4
poly1                      Halpha    POLY   7.041892     0.000339   0.001435   |     -31.8    -320.8 |     -119.6    -21.06   -0.284
poly1                      joint-HbHa POLY   7.041836     0.000336   0.000711   |     -37.4    -326.4 |     -121.7    -21.43   -0.289 3.8    
poly2                      Hbeta     POLY   7.038641     0.002499   0.002499   |    -356.9    -645.9 |     -240.9
poly2                      Halpha    POLY   7.042295     0.000410   0.001421   |      +8.5    -280.5 |     -104.6    -18.41   -0.248
poly2                      joint-HbHa POLY   7.042200     0.000402   0.000846   |      -1.0    -290.0 |     -108.1    -19.04   -0.257 3.0    
rm_hw3                     Hbeta     RM     7.038283     0.002367   0.002367   |    -392.7    -681.7 |     -254.2
rm_hw3                     Halpha    RM     7.040531     0.000270   0.001108   |    -167.9    -456.9 |     -170.4    -29.99   -0.404
rm_hw3                     joint-HbHa RM     7.040505     0.000269   0.000743   |    -170.5    -459.5 |     -171.3    -30.16   -0.406 5.1    
rm_hw4                     Hbeta     RM     7.038291     0.002328   0.002328   |    -391.9    -680.9 |     -253.9
rm_hw4                     Halpha    RM     7.040333     0.000269   0.001135   |    -187.7    -476.7 |     -177.7    -31.29   -0.422
rm_hw4                     joint-HbHa RM     7.040307     0.000268   0.000736   |    -190.3    -479.3 |     -178.7    -31.46   -0.424 5.4    
rm_hw6                     Hbeta     RM     7.038287     0.002328   0.002328   |    -392.3    -681.3 |     -254.1
rm_hw6                     Halpha    RM     7.040305     0.000270   0.001001   |    -190.5    -479.5 |     -178.8    -31.48   -0.424
rm_hw6                     joint-HbHa RM     7.040278     0.000268   0.000653   |    -193.2    -482.2 |     -179.8    -31.65   -0.427 5.9    
rm_hw8                     Hbeta     RM     7.038287     0.002328   0.002328   |    -392.3    -681.3 |     -254.1
rm_hw8                     Halpha    RM     7.040305     0.000270   0.000893   |    -190.5    -479.5 |     -178.8    -31.48   -0.424
rm_hw8                     joint-HbHa RM     7.040278     0.000268   0.000575   |    -193.2    -482.2 |     -179.8    -31.65   -0.427 6.3    
rm_hw10                    Hbeta     RM     7.038287     0.002328   0.002328   |    -392.3    -681.3 |     -254.1
rm_hw10                    Halpha    RM     7.040305     0.000270   0.000810   |    -190.5    -479.5 |     -178.8    -31.48   -0.424
rm_hw10                    joint-HbHa RM     7.040278     0.000268   0.000520   |    -193.2    -482.2 |     -179.8    -31.65   -0.427 6.7    
rm_hw12                    Hbeta     RM     7.038287     0.002328   0.002328   |    -392.3    -681.3 |     -254.1
rm_hw12                    Halpha    RM     7.040305     0.000270   0.000754   |    -190.5    -479.5 |     -178.8    -31.48   -0.424
rm_hw12                    joint-HbHa RM     7.040278     0.000268   0.000494   |    -193.2    -482.2 |     -179.8    -31.65   -0.427 6.9    
poly1_hw4                  Hbeta     POLY   7.037923     0.002698   0.002698   |    -428.7    -717.7 |     -267.7
poly1_hw4                  Halpha    POLY   7.042394     0.000386   0.001377   |     +18.4    -270.6 |     -100.9    -17.76   -0.239
poly1_hw4                  joint-HbHa POLY   7.042306     0.000383   0.000877   |      +9.6    -279.4 |     -104.2    -18.34   -0.247 2.8    
poly1_hw6                  Hbeta     POLY   7.039004     0.002465   0.002465   |    -320.6    -609.6 |     -227.3
poly1_hw6                  Halpha    POLY   7.041464     0.000315   0.001525   |     -74.6    -363.6 |     -135.6    -23.87   -0.322
poly1_hw6                  joint-HbHa POLY   7.041427     0.000313   0.001058   |     -78.3    -367.3 |     -136.9    -24.11   -0.325 3.1    
poly1_hw8                  Hbeta     POLY   7.038267     0.002351   0.002351   |    -394.3    -683.3 |     -254.8
poly1_hw8                  Halpha    POLY   7.040873     0.000292   0.001329   |    -133.7    -422.7 |     -157.6    -27.75   -0.374
poly1_hw8                  joint-HbHa POLY   7.040834     0.000290   0.000888   |    -137.6    -426.6 |     -159.1    -28.00   -0.377 4.2    
lsf1.6                     Hbeta     RM     7.037519     0.002378   0.004972   |    -469.1    -758.1 |     -282.8
lsf1.6                     Halpha    RM     7.040120     0.000213   0.003705   |    -209.0    -498.0 |     -185.7    -32.69   -0.441
lsf1.6                     joint-HbHa RM     7.040101     0.000212   0.002282   |    -210.9    -499.9 |     -186.4    -32.82   -0.442 2.1    
lsf1.8                     Hbeta     RM     7.037908     0.002177   0.003828   |    -430.2    -719.2 |     -268.2
lsf1.8                     Halpha    RM     7.040116     0.000232   0.003502   |    -209.4    -498.4 |     -185.8    -32.72   -0.441
lsf1.8                     joint-HbHa RM     7.040091     0.000231   0.002194   |    -211.9    -500.9 |     -186.8    -32.88   -0.443 2.2    
lsf2.0                     Hbeta     RM     7.037992     0.002132   0.003059   |    -421.8    -710.8 |     -265.1
lsf2.0                     Halpha    RM     7.040138     0.000239   0.003135   |    -207.2    -496.2 |     -185.0    -32.57   -0.439
lsf2.0                     joint-HbHa RM     7.040112     0.000237   0.001975   |    -209.8    -498.8 |     -186.0    -32.74   -0.441 2.4    
lsf2.2                     Hbeta     RM     7.038028     0.002148   0.002445   |    -418.2    -707.2 |     -263.8
lsf2.2                     Halpha    RM     7.040180     0.000241   0.002733   |    -203.0    -492.0 |     -183.5    -32.30   -0.435
lsf2.2                     joint-HbHa RM     7.040153     0.000239   0.001724   |    -205.7    -494.7 |     -184.5    -32.48   -0.438 2.8    
lsf2.4                     Hbeta     RM     7.038079     0.002190   0.002190   |    -413.1    -702.1 |     -261.9
lsf2.4                     Halpha    RM     7.040225     0.000243   0.002345   |    -198.5    -487.5 |     -181.8    -32.00   -0.431
lsf2.4                     joint-HbHa RM     7.040199     0.000241   0.001480   |    -201.1    -490.1 |     -182.7    -32.17   -0.434 3.1    
lsf2.6                     Hbeta     RM     7.038159     0.002247   0.002247   |    -405.1    -694.1 |     -258.9
lsf2.6                     Halpha    RM     7.040262     0.000245   0.001983   |    -194.8    -483.8 |     -180.4    -31.76   -0.428
lsf2.6                     joint-HbHa RM     7.040237     0.000244   0.001252   |    -197.3    -486.3 |     -181.3    -31.92   -0.430 3.6    
lsf2.8                     Hbeta     RM     7.038263     0.002313   0.002313   |    -394.7    -683.7 |     -255.0
lsf2.8                     Halpha    RM     7.040288     0.000249   0.001655   |    -192.2    -481.2 |     -179.4    -31.59   -0.426
lsf2.8                     joint-HbHa RM     7.040265     0.000247   0.001046   |    -194.5    -483.5 |     -180.3    -31.74   -0.428 4.2    
lsf3.0                     Hbeta     RM     7.038383     0.002388   0.002388   |    -382.7    -671.7 |     -250.5
lsf3.0                     Halpha    RM     7.040302     0.000253   0.001374   |    -190.8    -479.8 |     -178.9    -31.50   -0.424
lsf3.0                     joint-HbHa RM     7.040280     0.000251   0.000871   |    -193.0    -482.0 |     -179.7    -31.64   -0.426 4.8    
rm_drop1                   Hbeta     RM     7.038287     0.002328   0.002328   |    -392.3    -681.3 |     -254.1
rm_drop1                   Halpha    RM     7.040574     0.000276   0.000905   |    -163.6    -452.6 |     -168.8    -29.71   -0.400
rm_drop1                   joint-HbHa RM     7.040543     0.000274   0.000553   |    -166.7    -455.7 |     -169.9    -29.92   -0.403 6.1    
poly1_drop1                Hbeta     POLY   7.038520     0.002445   0.002445   |    -369.0    -658.0 |     -245.4
poly1_drop1                Halpha    POLY   7.039613     0.000343   0.000873   |    -259.7    -548.7 |     -204.6    -36.02   -0.485
poly1_drop1                joint-HbHa POLY   7.039592     0.000340   0.000417   |    -261.8    -550.8 |     -205.4    -36.16   -0.487 8.5    
rm_drop2                   Hbeta     RM     7.038287     0.002328   0.002328   |    -392.3    -681.3 |     -254.1
rm_drop2                   Halpha    RM     7.040288     0.000300   0.001045   |    -192.2    -481.2 |     -179.4    -31.59   -0.426
rm_drop2                   joint-HbHa RM     7.040256     0.000298   0.000592   |    -195.4    -484.4 |     -180.6    -31.80   -0.429 6.3    
poly1_drop2                Hbeta     POLY   7.038520     0.002445   0.002445   |    -369.0    -658.0 |     -245.4
poly1_drop2                Halpha    POLY   7.039485     0.000374   0.001636   |    -272.5    -561.5 |     -209.4    -36.86   -0.497
poly1_drop2                joint-HbHa POLY   7.039463     0.000645   0.000745   |    -274.7    -563.7 |     -210.2    -37.00   -0.499 6.3    
rm_drop3                   Hbeta     RM     7.038287     0.002328   0.002328   |    -392.3    -681.3 |     -254.1
rm_drop3                   Halpha    RM     7.043507     0.000481   0.001347   |    +129.7    -159.3 |      -59.4    -10.46   -0.141
rm_drop3                   joint-HbHa RM     7.043317     0.000470   0.000746   |    +110.7    -178.3 |      -66.5    -11.70   -0.158 2.0    
poly1_drop3                Hbeta     POLY   7.038520     0.002445   0.002445   |    -369.0    -658.0 |     -245.4
poly1_drop3                Halpha    POLY   7.039380     0.000586   0.000586   |    -283.0    -572.0 |     -213.3    -37.55   -0.506
poly1_drop3                joint-HbHa POLY   7.039347     0.000590   0.000590   |    -286.3    -575.3 |     -214.5    -37.77   -0.509 7.4    

=== 8. test script (test.sh)
=== test.sh 2026-10-26 18:02:02 PDT
--- A. data integrity (real data)
PASS  A1 raw FITS sha256 :: got=c0b878576d7d7ec723c5ee526d29715fb672d81e45bc8ba4e02598ce8b9c5ee7
PASS  A2 wavelength.txt rows :: rows=429 expected=429
PASS  A3 wavelength.f64 sha256 vs manifest.kv :: got=349b11d7be59344b.. want=349b11d7be59344b..
PASS  A2 flux.txt rows :: rows=429 expected=429
PASS  A3 flux.f64 sha256 vs manifest.kv :: got=594d5e4c4778f71b.. want=594d5e4c4778f71b..
PASS  A2 flux_error.txt rows :: rows=429 expected=429
PASS  A3 flux_error.f64 sha256 vs manifest.kv :: got=ed7e63c559e0f8cb.. want=ed7e63c559e0f8cb..
PASS  A4 masked count equals header.kv col.FLUX.nan_count :: masked=21 header_nan_count=21
PASS  A5 valid pixel count :: valid=408 expected=408 (429-21)
PASS  A6 no valid pixel has non-positive sigma or non-finite flux :: violations=0
--- B. unit tests of the awk building blocks (tiny hand-made inputs)
PASS  B1 erf (A&S 7.1.26) vs Maclaurin series, x in [-3,3] :: points=121 max|diff|=1.385e-07 tol=2e-7 (A&S bound 1.5e-7)
PASS  B2 median odd/even/duplicates :: got='3 2.5 2' expected='3 2.5 2'
PASS  B3 air2vac(6562.8) vs NIST ASD vacuum Halpha 6564.632 (tol 0.05 A) :: got=6564.613 NIST=6564.632
PASS  B4 mask.awk on 8-row hand-made input (CONTROL, not real) :: got='MASK pixels_total=8 valid=3 masked=5' expected='MASK pixels_total=8 valid=3 masked=5'
PASS  B5 running median reproduces a linear continuum (interior px 13-88, CONTROL) :: pixels=76 max|cont-true|=0.00e+00 tol=1e-5
--- C. SYNTHETIC injection-recovery, noise-free (NOT REAL DATA; flat-F_nu continuum + Gaussian lines on the real grid/mask)
SYNTHETIC injection spec from the real primary fit (line:A:sigma_int_kms): 1:101.47:600 4:965.55:500
PASS  C1 SYNTHETIC noise-free joint recovery z_true=7.0451 est=RM :: z_joint=7.045112 |dz|=1.20e-05 tol=2e-4
PASS  C2 SYNTHETIC noise-free Halpha-only recovery z_true=7.0451 est=RM :: z_Ha=7.045100 |dz|=0.00e+00 tol=2e-4
INFO  SYNTHETIC noise-free Hbeta-only est=RM z_true=7.0451: z_Hb=7.046061 (no pass criterion; RM continuum partly absorbs the weaker line, bias is reported not hidden)
PASS  C1 SYNTHETIC noise-free joint recovery z_true=7.0451 est=POLY1 :: z_joint=7.045100 |dz|=0.00e+00 tol=2e-4
PASS  C2 SYNTHETIC noise-free Halpha-only recovery z_true=7.0451 est=POLY1 :: z_Ha=7.045100 |dz|=0.00e+00 tol=2e-4
INFO  SYNTHETIC noise-free Hbeta-only est=POLY1 z_true=7.0451: z_Hb=7.045102 (no pass criterion; RM continuum partly absorbs the weaker line, bias is reported not hidden)
PASS  C1 SYNTHETIC noise-free joint recovery z_true=7.0300 est=RM :: z_joint=7.030008 |dz|=8.00e-06 tol=2e-4
PASS  C2 SYNTHETIC noise-free Halpha-only recovery z_true=7.0300 est=RM :: z_Ha=7.029997 |dz|=3.00e-06 tol=2e-4
INFO  SYNTHETIC noise-free Hbeta-only est=RM z_true=7.0300: z_Hb=7.030943 (no pass criterion; RM continuum partly absorbs the weaker line, bias is reported not hidden)
PASS  C1 SYNTHETIC noise-free joint recovery z_true=7.0300 est=POLY1 :: z_joint=7.030003 |dz|=3.00e-06 tol=2e-4
PASS  C2 SYNTHETIC noise-free Halpha-only recovery z_true=7.0300 est=POLY1 :: z_Ha=7.030003 |dz|=3.00e-06 tol=2e-4
INFO  SYNTHETIC noise-free Hbeta-only est=POLY1 z_true=7.0300: z_Hb=7.029998 (no pass criterion; RM continuum partly absorbs the weaker line, bias is reported not hidden)
PASS  C1 SYNTHETIC noise-free joint recovery z_true=7.0600 est=RM :: z_joint=7.060017 |dz|=1.70e-05 tol=2e-4
PASS  C2 SYNTHETIC noise-free Halpha-only recovery z_true=7.0600 est=RM :: z_Ha=7.060010 |dz|=1.00e-05 tol=2e-4
INFO  SYNTHETIC noise-free Hbeta-only est=RM z_true=7.0600: z_Hb=7.060427 (no pass criterion; RM continuum partly absorbs the weaker line, bias is reported not hidden)
PASS  C1 SYNTHETIC noise-free joint recovery z_true=7.0600 est=POLY1 :: z_joint=7.060000 |dz|=0.00e+00 tol=2e-4
PASS  C2 SYNTHETIC noise-free Halpha-only recovery z_true=7.0600 est=POLY1 :: z_Ha=7.060000 |dz|=0.00e+00 tol=2e-4
INFO  SYNTHETIC noise-free Hbeta-only est=POLY1 z_true=7.0600: z_Hb=7.060000 (no pass criterion; RM continuum partly absorbs the weaker line, bias is reported not hidden)
--- D. SYNTHETIC noisy recovery (NOT REAL DATA): N=40 realisations, noise = NOISE x N(0, real per-pixel sigma), z_true=7.0451
PASS  D1 SYNTHETIC joint fits obtained, est=RM :: n_joint_fits=40 of 40
PASS  D2 SYNTHETIC mean bias consistent with 0 (|mean|<=3*sd/sqrt(N)), est=RM :: mean(z-ztrue)=0.000063 sd=0.000302 sd/sqrtN=0.000048
PASS  D3 SYNTHETIC coverage of dchi2=1 interval in [0.45,0.90] (binomial 3-sigma around 0.68 for N=40), est=RM :: covered=29 of 40 fraction=0.7250
PASS  D1 SYNTHETIC joint fits obtained, est=POLY1 :: n_joint_fits=40 of 40
PASS  D2 SYNTHETIC mean bias consistent with 0 (|mean|<=3*sd/sqrt(N)), est=POLY1 :: mean(z-ztrue)=0.000154 sd=0.000553 sd/sqrtN=0.000087
PASS  D3 SYNTHETIC coverage of dchi2=1 interval in [0.45,0.90] (binomial 3-sigma around 0.68 for N=40), est=POLY1 :: covered=22 of 40 fraction=0.5500
--- E. negative controls (NOT REAL DATA unless stated)
PASS  E1 CONTROL noise-only (continuum+noise, no line): false detections at dchi2>=25, line=Hb (criterion <=1 of 40) :: trials=40 false_detections=0 max_dchi2=4.31
PASS  E1 CONTROL noise-only (continuum+noise, no line): false detections at dchi2>=25, line=Ha (criterion <=1 of 40) :: trials=40 false_detections=0 max_dchi2=4.79
PASS  E2 CONTROL within-window pixel permutation (REAL pixel values, order destroyed): shuffled dchi2 >= real (245.093) never, line=Hb :: permutations=40 n_ge_real=0 median_shuffled=33.31 max_shuffled=132.56 => permutation p < 0.024
PASS  E2 CONTROL within-window pixel permutation (REAL pixel values, order destroyed): shuffled dchi2 >= real (7037.477) never, line=Ha :: permutations=40 n_ge_real=0 median_shuffled=1363.37 max_shuffled=5018.13 => permutation p < 0.024
=== SUMMARY: PASS=37 FAIL=0 total=37
=== finished 2026-10-26 18:08:32 PDT
```
