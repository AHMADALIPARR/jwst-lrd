<!-- SPDX-License-Identifier: AGPL-3.0-only; also subject to SNAPKITTY_OPAQUE_LICENSE.md (see LICENSE). -->
# futhark/STATUS.md: JWST-LRD TASK 013, Futhark subsystem (Agent 2)

- **Worktree / branch:** `/workspace/jwst-lrd-futhark`, branch `agent2-futhark`, based on main `6b9cef6`. Nothing has been pushed.
- **Code head:** `24f34314c98b951f103de3a7190d86a4f13ffc8d`, the last code commit (the repair round: Jy kernel, published-pair gate, zgrid caveat). This STATUS.md is committed on top of it, and that commit's hash is given in the agent's report.
- **Author:** Nova Parr <nova-parr@users.noreply.github.com>

## Source files
| file | purpose |
|---|---|
| futhark/lrd.fut | f64 kernels and entry points |
| futhark/lrdarr.sh | POSIX sh LRD-ARR-v1 <-> Futhark binary converters |
| futhark/lrd-fut | sh CLI over the compiled Futhark program |
| futhark/Makefile | c and multicore builds |
| futhark/ABI.md, futhark/README.md, futhark/TOOLCHAIN.txt | ABI, formulas and sources, toolchain |
| tests/futhark/unit.fut | 22 analytic tests (`futhark test` stanzas plus t_/m_ entries) |
| tests/futhark/run.sh | gate runner |
| tests/futhark/refdata/morton2000_table2_p406.txt | verbatim Morton (2000) excerpt used as the published-pair oracle |
| tests/futhark/fortran-ref/lrd_kernels.f90 | Fortran 2018 reference kernels, real(real64) |
| tests/futhark/fortran-ref/lrd_io.f90 | Fortran LRD-ARR-v1 reader/writer |
| tests/futhark/fortran-ref/lrdref.f90 | Fortran CLI, same kernels and arguments as lrd-fut |
| tests/futhark/fortran-ref/test_lrd_kernels.f90 | 16 Fortran analytic unit tests |
| tests/futhark/fortran-ref/Makefile | Fortran build |

Every source file carries `SPDX-License-Identifier: AGPL-3.0-only` and a pointer to LICENSE and SNAPKITTY_OPAQUE_LICENSE.md.

## Build commands
```
make -C futhark                 # futhark c --safe -o build/lrd-c lrd.fut
make -C futhark multicore       # futhark multicore --safe -o build/lrd-multicore lrd.fut
make -C tests/futhark/fortran-ref B=<dir> all
  # gfortran -std=f2018 -O2 -Wall -Wextra -fimplicit-none -ffp-contract=off -Wno-compare-reals -ffpe-summary=none
  #   -> <dir>/lrdref, <dir>/test_lrd_kernels
tests/futhark/run.sh            # builds what it needs into scratch / futhark/build (gitignored)
```

**Build results.**
- The c backend compiles and runs.
- The multicore backend compiles and runs. On this 8-CPU box its zgrid output matches the c backend within atol 1e-12 and rtol 1e-9, and best z/index match exactly. I did not benchmark it for speed.
- The Fortran build succeeds. The only warning is `-Wfunction-elimination` about the impure `arg()` in lrdref.f90 short-circuit tests, and it is harmless.

## Toolchain (details in futhark/TOOLCHAIN.txt)
- **Futhark:** 0.25.27 ("Futhark 0.25.27." / "Compiled with GHC 9.6.6.").
  - It came from the Debian package futhark 0.25.27-1+b1, which was already installed. No tarball was downloaded, so there is no tarball sha256.
  - sha256 of /usr/bin/futhark: 83784b16d83dc1c553a37cde27ee9e489563fd6db36d6ea963605e78c39266a2
- **C compiler:** gcc (Debian 14.2.0-19) 14.2.0
- **Fortran compiler:** GNU Fortran (Debian 14.2.0-19) 14.2.0
- **Shell and tools:** dash 0.5.12-12, GNU Make 4.4.1, coreutils 9.7-3, bc 1.07.1, poppler-utils pdftotext (only for the optional source re-verification)

## Integration interfaces
- Futhark entry points: see futhark/ABI.md §3. CLI (identical for `futhark/lrd-fut` and the Fortran `lrdref`):
  - vac2air, air2vac, um2a, a2um
  - rest Z, obs Z
  - flam2fnu, fnu2flam, **jy2flam** (`-` = no lambda error)
  - resid, chi2, gauss, zgrid
- File ABI: LRD-ARR-v1 exactly as in research/CONTRACTS.md (ABI.md §1). The Futhark binary value format is documented in ABI.md §2.
- **New: `jy_to_flam` / `jy2flam`.**
  - 1 Jy = 1e-23 erg s^-1 cm^-2 Hz^-1, and f_lambda = 1e-23 f_Jy c / lambda^2 in erg s^-1 cm^-2 A^-1 (lambda in A, c = 2.99792458e18 A/s).
  - sigma_flam^2 = (1e-23 c/lambda^2 sigma_Jy)^2 + (2e-23 f_Jy c/lambda^3 sigma_lam)^2, the same convention as fnu_to_flam (independent errors).
  - The CLI requires FJY and SIGJY to have unit=Jy and LAM to have unit=Angstrom.
- **zgrid_search limitation: no LSF, fixed line widths, test kernel, not a redshift measurement.**
  - Every zgrid output header (`OUT_chi2`, `OUT_best`, `OUT_params`, from both lrd-fut and lrdref) carries `caveat=no LSF, fixed line widths, test kernel, not a redshift measurement`, and both CLIs print the statement on stderr. The `zgrid-caveat` test checks this.
  - The same statement appears in lrd.fut, lrd_kernels.f90, ABI.md and README.md.

## Published vacuum/air pairs (gate `vac_air_published_pairs`, and `fortran-ref-vac_air_published_pairs`)
- **Source:** Morton, D. C. 2000, ApJS 130, 403 (doi:10.1086/317349).
  - Publisher PDF: https://iopscience.iop.org/article/10.1086/317349/pdf, retrieved 2026-10-19 22:40 PDT, sha256 d0695ab273886ccda7b8e5c8191458303bcb620c9dd9211f44ae29dabf2b7211.
  - Cached for re-verification at ~/.cache/jwst-lrd/morton2000_ApJS130_403.pdf on the box. It is not committed, because it is copyrighted.
- **Pairs used:** Table 2, journal page 406 (PDF page 4), "RESONANCE LINES BY ELEMENT : Ge (Z = 32)", Ge I multiplets 1 and 2, giving 9 (air, vacuum) pairs.
  - They are quoted verbatim from `pdftotext -layout -f 4 -l 4` in tests/futhark/refdata/morton2000_table2_p406.txt.
  - The air column is "calculated by equation (8)", per the Table 2 note quoted from the IOP HTML full text: "Air: For λ > 2000 Å calculated by equation (8)." Eq. (8) is on p. 405 and is also quoted verbatim.
- **Values (air / vacuum, Å):**
  - 2754.5877/2755.4020
  - 2709.6237/2710.4270
  - 2691.3410/2692.1400
  - 2651.5683/2652.3577
  - 2651.1719/2651.9612
  - 2592.5340/2593.3093
  - 2589.1877/2589.9623
  - 2533.2304/2533.9918
  - 2497.9625/2498.7156
- **Tolerance:** 1e-4 Å absolute, declared because both columns are rounded to 1e-4 Å.
- **Measured maximum deviation:**
  - vac2air(vac) vs air: 6.78038e-5 Å (Futhark), with the same value from Fortran.
  - air2vac(air) vs vac: 6.78191e-5 Å.
- **Sensitivity:** in a scratch mutation, dropping the 38.9 term gave a 0.0174 Å deviation, and the gate failed. Because of the 1e-4 Å rounding, the gate cannot detect coefficient errors below about 1e-4 Å; `unit-vac_air_formula` covers those.
- **Re-verification:** `vac_air_published_source_verified` re-extracts the text from the cached PDF, after checking its sha256, and byte-compares it with the committed excerpt. Without the cached PDF it reports UNAVAILABLE.
- **UNAVAILABLE case:** if the excerpt is missing or has fewer than 3 pairs, `vac_air_published_pairs` prints UNAVAILABLE.

## run.sh output, verbatim (shared checkout = /workspace/jwst-lrd, main; started 2026-10-19 22:44 PDT)
```
PASS futhark-build-c
PASS unit-gauss_integral
PASS unit-gauss_integral_cont
PASS unit-gauss_peak
PASS unit-chi2_exact_model
PASS unit-chi2_known
PASS unit-chi2_mask
PASS unit-rest_inverse
PASS unit-um_angstrom
PASS unit-vac_air_roundtrip
PASS unit-vac_air_passthrough
PASS unit-vac_air_formula
PASS unit-fnu_flam_roundtrip
PASS unit-fnu_known
PASS unit-fnu_lambda_error
PASS unit-fnu_combined_error
PASS unit-zgrid_recover
PASS unit-zgrid_noiseless
PASS unit-zgrid_degenerate
PASS unit-zgrid_mask
PASS unit-jy_known
PASS unit-jy_identity
PASS unit-jy_lambda_error
PASS futhark-test-unit
PASS abi-roundtrip
PASS abi-reject-bad-length
PASS abi-reject-unit
PASS fortran-ref-build
PASS fortran-ref-unit-gauss_integral
PASS fortran-ref-unit-chi2_exact_model
PASS fortran-ref-unit-chi2_known
PASS fortran-ref-unit-chi2_mask
PASS fortran-ref-unit-rest_inverse
PASS fortran-ref-unit-um_angstrom
PASS fortran-ref-unit-vac_air_roundtrip
PASS fortran-ref-unit-vac_air_passthrough
PASS fortran-ref-unit-vac_air_formula
PASS fortran-ref-unit-fnu_flam_roundtrip
PASS fortran-ref-unit-fnu_known
PASS fortran-ref-unit-fnu_combined_error
PASS fortran-ref-unit-jy_known
PASS fortran-ref-unit-jy_identity
PASS fortran-ref-unit-zgrid_noiseless
PASS fortran-ref-unit-zgrid_degenerate
PASS vac_air_published_pairs
PASS fortran-ref-vac_air_published_pairs
PASS vac_air_published_source_verified
PASS fortran-ref-diff-syn-um2a
PASS fortran-ref-diff-syn-a2um
PASS fortran-ref-diff-syn-vac2air
PASS fortran-ref-diff-syn-air2vac
PASS fortran-ref-diff-syn-rest
PASS fortran-ref-diff-syn-obs
PASS fortran-ref-diff-syn-flam2fnu
PASS fortran-ref-diff-syn-flam2fnu-nolamerr
PASS fortran-ref-diff-syn-fnu2flam
PASS fortran-ref-diff-syn-jy2flam
PASS fortran-ref-diff-syn-jy2flam-nolamerr
PASS fortran-ref-diff-syn-gauss
PASS fortran-ref-diff-syn-resid
PASS fortran-ref-diff-syn-chi2
PASS fortran-ref-diff-syn-zgrid
PASS fortran-ref-diff-syn-zgrid-best
PASS fortran-ref-diff-syn-zgrid-masked
PASS fortran-ref-diff-syn-chi2-masked
PASS fortran-ref-diff
PASS zgrid-caveat
UNAVAILABLE fortran-ref-diff-x1d no LRD-ARR-v1 x1d wavelength/flux/error arrays under /workspace/jwst-lrd/fixtures (x1d FITS files found: 0; waiting on ingest export)
PASS futhark-build-multicore
PASS multicore-vs-c-zgrid
UNAVAILABLE fortran-diff waiting on fortran reference
SUMMARY pass=69 fail=0 unavailable=2
exit=0
```
(The `exit=` line was appended by the invoking shell. It is not printed by run.sh.)

## run.sh output against t001's worktree, read-only (`LRD_SHARED=/workspace/jwst-lrd-t001`; started 2026-10-19 22:44 PDT)
- **Fixture:** the real x1d fixture is in t001-ingest-fortran's worktree only (not on main): jw02561-o002_s000013123_nirspec_clear-prism_x1d.fits, Abell2744-QSO1 image A, per its source.kv.
- **Input sha256:**
  - wavelength.f64 c7a9e816a03156599607506deba9c6b0801d83e3eac1fec40c749465f2c43331
  - flux.f64 78a16556f528bf4f517b98ca8961934486be3a27a4e6a063e327ae28848db537
  - flux_error.f64 5a65786bdf69994f2127deeb31b2d2916a8522efa4597ede253005e7a4dbd024
- The files are copied into scratch, and nothing is written there.

Output, verbatim:
```
PASS futhark-build-c
PASS unit-gauss_integral
PASS unit-gauss_integral_cont
PASS unit-gauss_peak
PASS unit-chi2_exact_model
PASS unit-chi2_known
PASS unit-chi2_mask
PASS unit-rest_inverse
PASS unit-um_angstrom
PASS unit-vac_air_roundtrip
PASS unit-vac_air_passthrough
PASS unit-vac_air_formula
PASS unit-fnu_flam_roundtrip
PASS unit-fnu_known
PASS unit-fnu_lambda_error
PASS unit-fnu_combined_error
PASS unit-zgrid_recover
PASS unit-zgrid_noiseless
PASS unit-zgrid_degenerate
PASS unit-zgrid_mask
PASS unit-jy_known
PASS unit-jy_identity
PASS unit-jy_lambda_error
PASS futhark-test-unit
PASS abi-roundtrip
PASS abi-reject-bad-length
PASS abi-reject-unit
PASS fortran-ref-build
PASS fortran-ref-unit-gauss_integral
PASS fortran-ref-unit-chi2_exact_model
PASS fortran-ref-unit-chi2_known
PASS fortran-ref-unit-chi2_mask
PASS fortran-ref-unit-rest_inverse
PASS fortran-ref-unit-um_angstrom
PASS fortran-ref-unit-vac_air_roundtrip
PASS fortran-ref-unit-vac_air_passthrough
PASS fortran-ref-unit-vac_air_formula
PASS fortran-ref-unit-fnu_flam_roundtrip
PASS fortran-ref-unit-fnu_known
PASS fortran-ref-unit-fnu_combined_error
PASS fortran-ref-unit-jy_known
PASS fortran-ref-unit-jy_identity
PASS fortran-ref-unit-zgrid_noiseless
PASS fortran-ref-unit-zgrid_degenerate
PASS vac_air_published_pairs
PASS fortran-ref-vac_air_published_pairs
PASS vac_air_published_source_verified
PASS fortran-ref-diff-syn-um2a
PASS fortran-ref-diff-syn-a2um
PASS fortran-ref-diff-syn-vac2air
PASS fortran-ref-diff-syn-air2vac
PASS fortran-ref-diff-syn-rest
PASS fortran-ref-diff-syn-obs
PASS fortran-ref-diff-syn-flam2fnu
PASS fortran-ref-diff-syn-flam2fnu-nolamerr
PASS fortran-ref-diff-syn-fnu2flam
PASS fortran-ref-diff-syn-jy2flam
PASS fortran-ref-diff-syn-jy2flam-nolamerr
PASS fortran-ref-diff-syn-gauss
PASS fortran-ref-diff-syn-resid
PASS fortran-ref-diff-syn-chi2
PASS fortran-ref-diff-syn-zgrid
PASS fortran-ref-diff-syn-zgrid-best
PASS fortran-ref-diff-syn-zgrid-masked
PASS fortran-ref-diff-syn-chi2-masked
PASS fortran-ref-diff
PASS zgrid-caveat
PASS fortran-ref-diff-x1d-um2a
PASS fortran-ref-diff-x1d-a2um
PASS fortran-ref-diff-x1d-vac2air
PASS fortran-ref-diff-x1d-air2vac
PASS fortran-ref-diff-x1d-rest
PASS fortran-ref-diff-x1d-obs
PASS fortran-ref-diff-x1d-flam2fnu
PASS fortran-ref-diff-x1d-flam2fnu-nolamerr
PASS fortran-ref-diff-x1d-fnu2flam
PASS fortran-ref-diff-x1d-jy2flam
PASS fortran-ref-diff-x1d-jy2flam-nolamerr
PASS fortran-ref-diff-x1d-gauss
PASS fortran-ref-diff-x1d-resid
PASS fortran-ref-diff-x1d-chi2
PASS fortran-ref-diff-x1d-zgrid
PASS fortran-ref-diff-x1d-zgrid-best
PASS fortran-ref-diff-x1d
PASS futhark-build-multicore
PASS multicore-vs-c-zgrid
UNAVAILABLE fortran-diff waiting on fortran reference
SUMMARY pass=86 fail=0 unavailable=1
exit=0
```

**What this shows.** These are differential agreements between Futhark and Fortran on real data. `x1d-jy2flam` uses the real Jy flux and error.

**What it is not.** The zgrid results are **no LSF, fixed line widths, test kernel, not a redshift measurement**. In an earlier development check, the best z on this setup came with a negative Halpha amplitude, and it must not be quoted as a redshift.

## Tolerances (declared in test sources)
- Gaussian integral: 1e-10 rel
- Gaussian peak: exact, and 1e-15 at μ±σ
- chi2 of the exact model: 0 exactly
- chi2 = 4n: 1e-12
- rest inverse and µm/Å: 1e-15 rel
- vacuum/air round trip (2001–100000 Å): 1e-9 rel. The measured value was 2.7e-12.
- published pairs: 1e-4 Å abs
- f_ν/f_λ round trip: 1e-14
- known f_ν, combined error, and Jy known/identity: 1e-15
- λ-error vs finite difference: 1e-8
- Grid search:
  - noisy recovery within 1e-3 in z and 10% in amplitude
  - noiseless: chi2 <= 1e-16 and params within 1e-9
  - mask equivalence: 1e-12
- Fortran-ref diff:
  - elementwise kernels: 1e-15 (wavelength) and 1e-14 (flux, Jy, gauss)
  - chi2: 1e-12
  - zgrid: atol 1e-12, rtol 1e-9
  - best z: exact

## Mutation checks (done during development, not part of run.sh)
- **Round 1:** I changed one Morton coefficient (0.02406147 to 0.02406148) and the Fortran residual sign. run.sh then reported 7 FAILs with exit 1.
- **Round 2:** I dropped the Morton 38.9 term. The published-pair comparison failed with a 0.0174 Å deviation.

## Unresolved blockers
1. **`fortran-diff`** (against the fortran/ track, branch t001-ingest-fortran) is `UNAVAILABLE waiting on fortran reference`.
   - No LRD-ARR-v1 outputs exist under /workspace/jwst-lrd/fortran.
   - Once outputs exist, a kernel/input to output mapping still has to be agreed through Hilbert.
2. **`fortran-ref-diff-x1d`** is UNAVAILABLE on main because the ingest fixture is not merged to main yet. It passes against t001's worktree.
3. **Vacuum/air coverage.** Only Morton 2000 and the Piskunov inverse are implemented, not Ciddor 1996.
   - The published-pair oracle spans only 2497–2755 Å, which is what the quoted Table 2 page offers. It cannot detect errors below about 1e-4 Å.
4. **zgrid:** no LSF, fixed line widths, test kernel, not a redshift measurement. Physical fits to prism data need LSF-matched widths or a width fit, and neither is implemented.
