<!-- SPDX-License-Identifier: AGPL-3.0-only; also subject to SNAPKITTY_OPAQUE_LICENSE.md (see LICENSE). -->
# futhark/STATUS.md: JWST-LRD TASK 013, Futhark subsystem (Agent 2)

- **Worktree / branch:** `/workspace/jwst-lrd-futhark`, branch `agent2-futhark`, based on main `6b9cef6`. Nothing has been pushed.
- **Code head:** `5c11355c08b0f15767a71a6844465ebdedb4c8bc`. This is the last code commit. STATUS.md is committed on top of it, and the HEAD hash of that commit is given in the agent's report.
- **Author:** Nova Parr <nova-parr@users.noreply.github.com>

## Source files
| file | purpose |
|---|---|
| futhark/lrd.fut | f64 kernels and entry points |
| futhark/lrdarr.sh | POSIX sh LRD-ARR-v1 <-> Futhark binary converters |
| futhark/lrd-fut | sh CLI over the compiled Futhark program |
| futhark/Makefile | c and multicore builds |
| futhark/ABI.md, futhark/README.md, futhark/TOOLCHAIN.txt | ABI, formulas and sources, toolchain |
| tests/futhark/unit.fut | 19 analytic tests (`futhark test` stanzas plus t_/m_ entries) |
| tests/futhark/run.sh | gate runner |
| tests/futhark/fortran-ref/lrd_kernels.f90 | Fortran 2018 reference kernels, real(real64) |
| tests/futhark/fortran-ref/lrd_io.f90 | Fortran LRD-ARR-v1 reader/writer |
| tests/futhark/fortran-ref/lrdref.f90 | Fortran CLI, same kernels and arguments as lrd-fut |
| tests/futhark/fortran-ref/test_lrd_kernels.f90 | 14 Fortran analytic unit tests |
| tests/futhark/fortran-ref/Makefile | Fortran build |

Every source file carries `SPDX-License-Identifier: AGPL-3.0-only` and a pointer to LICENSE and SNAPKITTY_OPAQUE_LICENSE.md.

## Build commands
```
make -C futhark                 # futhark c --safe -o build/lrd-c lrd.fut
make -C futhark multicore       # futhark multicore --safe -o build/lrd-multicore lrd.fut
make -C tests/futhark/fortran-ref B=<dir> all
  # gfortran -std=f2018 -O2 -Wall -Wextra -fimplicit-none -ffp-contract=off -Wno-compare-reals -ffpe-summary=none
  #   -> <dir>/lrdref, <dir>/test_lrd_kernels
tests/futhark/run.sh            # builds everything it needs into scratch / futhark/build (gitignored)
```

**Build results.**
- The c backend compiles and runs.
- The multicore backend compiles and runs. On this 8-CPU box its zgrid output (chi2 curve, params, best z) matches the c backend within atol 1e-12 and rtol 1e-9, and best z/index match exactly. I did not benchmark it for speed.
- The Fortran build succeeds. The only warning is `-Wfunction-elimination` about the impure `arg()` in lrdref.f90 short-circuit tests, and it is harmless.

## Toolchain (details in futhark/TOOLCHAIN.txt)
- **Futhark:** 0.25.27 (`futhark --version` prints "Futhark 0.25.27." and "Compiled with GHC 9.6.6.").
  - It came from the Debian package futhark 0.25.27-1+b1, which was already installed on the box. No tarball was downloaded, so there is no tarball sha256.
  - sha256 of /usr/bin/futhark: 83784b16d83dc1c553a37cde27ee9e489563fd6db36d6ea963605e78c39266a2
- **C compiler:** gcc (Debian 14.2.0-19) 14.2.0
- **Fortran compiler:** GNU Fortran (Debian 14.2.0-19) 14.2.0
- **Shell and tools:** dash 0.5.12-12, GNU Make 4.4.1, coreutils 9.7-3, bc 1.07.1

## Integration interfaces
- Futhark entry points: see futhark/ABI.md §3. The main signature is
  `zgrid_search [n][k][m] (lam) (flux) (sigma) (centers:[k]) (widths:[k]) (fit_cont: bool) (zgrid:[m]) : ([m]f64, [2]f64 /*best_z, best_index*/, [k+1]f64 /*amps, cont*/)`.
- CLI (identical for `futhark/lrd-fut` and the Fortran `lrdref`):
  - vac2air, air2vac, um2a, a2um
  - rest Z, obs Z
  - flam2fnu, fnu2flam (with `-` = no lambda error)
  - resid, chi2, gauss, zgrid
- File ABI: LRD-ARR-v1 exactly as in research/CONTRACTS.md (ABI.md §1). The Futhark binary value format is documented in ABI.md §2.
- Units: wavelength kernels check the input `unit` (Angstrom or um). Flux kernels expect cgs (erg/s/cm2/A or erg/s/cm2/Hz) but do not check the flux unit and do not convert Jy.

## run.sh output, verbatim (shared checkout = /workspace/jwst-lrd, main; started 2026-10-19 22:36 PDT)
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
PASS fortran-ref-unit-zgrid_noiseless
PASS fortran-ref-unit-zgrid_degenerate
PASS fortran-ref-diff-syn-um2a
PASS fortran-ref-diff-syn-a2um
PASS fortran-ref-diff-syn-vac2air
PASS fortran-ref-diff-syn-air2vac
PASS fortran-ref-diff-syn-rest
PASS fortran-ref-diff-syn-obs
PASS fortran-ref-diff-syn-flam2fnu
PASS fortran-ref-diff-syn-flam2fnu-nolamerr
PASS fortran-ref-diff-syn-fnu2flam
PASS fortran-ref-diff-syn-gauss
PASS fortran-ref-diff-syn-resid
PASS fortran-ref-diff-syn-chi2
PASS fortran-ref-diff-syn-zgrid
PASS fortran-ref-diff-syn-zgrid-best
PASS fortran-ref-diff-syn-zgrid-masked
PASS fortran-ref-diff-syn-chi2-masked
PASS fortran-ref-diff
UNAVAILABLE fortran-ref-diff-x1d no LRD-ARR-v1 x1d wavelength/flux/error arrays under /workspace/jwst-lrd/fixtures (x1d FITS files found: 0; waiting on ingest export)
PASS futhark-build-multicore
PASS multicore-vs-c-zgrid
UNAVAILABLE fortran-diff waiting on fortran reference
SUMMARY pass=58 fail=0 unavailable=2
exit=0
```
(The `exit=` line was appended by the invoking shell. It is not printed by run.sh.)

## Real JWST x1d differential vs our Fortran ref (run against t001's worktree, read-only; started 2026-10-19 22:37 PDT)
- **Where the fixture is:** the real x1d fixture exists only in branch t001-ingest-fortran's worktree (`/workspace/jwst-lrd-t001/fixtures/ingest/09bcd907.../`). It is not on main yet.
- **Product:** jw02561-o002_s000013123_nirspec_clear-prism_x1d.fits, target Abell2744-QSO1 image A, per its source.kv.
- **Input sha256:**
  - wavelength.f64 c7a9e816a03156599607506deba9c6b0801d83e3eac1fec40c749465f2c43331
  - flux.f64 78a16556f528bf4f517b98ca8961934486be3a27a4e6a063e327ae28848db537
  - flux_error.f64 5a65786bdf69994f2127deeb31b2d2916a8522efa4597ede253005e7a4dbd024
- **How it was run:** `LRD_SHARED=/workspace/jwst-lrd-t001 tests/futhark/run.sh`. The files are copied into scratch, and nothing is written there.

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
PASS fortran-ref-unit-zgrid_noiseless
PASS fortran-ref-unit-zgrid_degenerate
PASS fortran-ref-diff-syn-um2a
PASS fortran-ref-diff-syn-a2um
PASS fortran-ref-diff-syn-vac2air
PASS fortran-ref-diff-syn-air2vac
PASS fortran-ref-diff-syn-rest
PASS fortran-ref-diff-syn-obs
PASS fortran-ref-diff-syn-flam2fnu
PASS fortran-ref-diff-syn-flam2fnu-nolamerr
PASS fortran-ref-diff-syn-fnu2flam
PASS fortran-ref-diff-syn-gauss
PASS fortran-ref-diff-syn-resid
PASS fortran-ref-diff-syn-chi2
PASS fortran-ref-diff-syn-zgrid
PASS fortran-ref-diff-syn-zgrid-best
PASS fortran-ref-diff-syn-zgrid-masked
PASS fortran-ref-diff-syn-chi2-masked
PASS fortran-ref-diff
PASS fortran-ref-diff-x1d-um2a
PASS fortran-ref-diff-x1d-a2um
PASS fortran-ref-diff-x1d-vac2air
PASS fortran-ref-diff-x1d-air2vac
PASS fortran-ref-diff-x1d-rest
PASS fortran-ref-diff-x1d-obs
PASS fortran-ref-diff-x1d-flam2fnu
PASS fortran-ref-diff-x1d-flam2fnu-nolamerr
PASS fortran-ref-diff-x1d-fnu2flam
PASS fortran-ref-diff-x1d-gauss
PASS fortran-ref-diff-x1d-resid
PASS fortran-ref-diff-x1d-chi2
PASS fortran-ref-diff-x1d-zgrid
PASS fortran-ref-diff-x1d-zgrid-best
PASS fortran-ref-diff-x1d
PASS futhark-build-multicore
PASS multicore-vs-c-zgrid
UNAVAILABLE fortran-diff waiting on fortran reference
SUMMARY pass=73 fail=0 unavailable=1
exit=0
```

**What this shows.** Futhark and Fortran agree on the real spectrum. In a separate check during development, the zgrid chi2 curve and params were bit-identical (`cmp 0 0`).

**What it is not.** It is not a science measurement.
- The flux is in Jy and is fed unscaled to the flux kernels.
- The zgrid template uses 3 Å rest-frame line widths, far narrower than the prism resolution. During development, the best-z fit on this setup returned z=7.036 with a negative Halpha amplitude, so that number must not be quoted as a redshift.

## Tolerances (declared in test sources)
- Gaussian integral: 1e-10 rel
- Gaussian peak: exact, and 1e-15 at μ±σ
- chi2 of the exact model: 0 exactly
- chi2 = 4n: 1e-12
- rest inverse and µm/Å: 1e-15 rel
- vacuum/air round trip (2001–100000 Å): 1e-9 rel. The measured value was 2.7e-12.
- f_ν/f_λ round trip: 1e-14
- Known f_ν values and combined error: 1e-15
- λ-error vs finite difference: 1e-8
- Grid search:
  - noisy recovery within 1e-3 in z and 10% in amplitude
  - noiseless: chi2 <= 1e-16 and params within 1e-9
  - mask equivalence: 1e-12
- Fortran-ref diff:
  - elementwise kernels: 1e-15 (wavelength) and 1e-14 (flux, gauss)
  - chi2: 1e-12
  - zgrid: atol 1e-12, rtol 1e-9
  - best z: exact

## Mutation check (done once during development, not part of run.sh)
- I changed one Morton coefficient (0.02406147 to 0.02406148) and the Fortran residual sign in a scratch copy.
- run.sh then reported 7 FAILs: unit-vac_air_formula, futhark-test-unit, fortran-ref-unit-chi2_exact_model, fortran-ref-unit-chi2_known, fortran-ref-diff-syn-vac2air, fortran-ref-diff-syn-resid, and fortran-ref-diff, with exit 1.
- Both the x1d detection path and the fortran-diff "outputs found" path were also exercised against a SYNTHETIC fake shared tree in /tmp.

## Unresolved blockers
1. **`fortran-diff`** (against the fortran/ track, branch t001-ingest-fortran) is `UNAVAILABLE waiting on fortran reference`.
   - There are no LRD-ARR-v1 outputs under /workspace/jwst-lrd/fortran. t001's worktree has untracked fortran/src and data, but no .hdr outputs.
   - Even once outputs appear, run.sh only detects them. It still reports UNAVAILABLE until a kernel/input to output mapping (a manifest) is agreed through Hilbert.
2. **`fortran-ref-diff-x1d`** is UNAVAILABLE on main because the ingest fixture is not merged to main yet. It passes against t001's worktree (above).
3. **Jy conversion.** There is no Jy to cgs conversion kernel. Callers scale by 1e-23 before using the flux kernels.
4. **Vacuum/air coverage.** Only Morton 2000 and the Piskunov inverse are implemented. Ciddor 1996 is not. No published reference wavelength pair is used as a gate.
5. **Grid-search model.** The zgrid model fits fixed rest-frame widths with linear amplitudes. It does not fit widths or account for instrumental line-spread. Physical fits to prism data need LSF-matched widths.
