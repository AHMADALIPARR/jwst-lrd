<!-- SPDX-License-Identifier: AGPL-3.0-only. Also licensed under the SnapKitty Opaque License; see LICENSE and SNAPKITTY_OPAQUE_LICENSE.md at the repository root. -->
# validation/STATUS.md: TASK 014 cross-language differential harness

Last run: 2026-10-19 23:03 PDT. Entry point `tests/validation/run.sh` -> `validation/harness.sh` (bash), comparator
`validation/lrdcmp.c` (C, via abi/lrd_num_abi), FP probe `validation/fp_probe.c`, programs `validation/programs/*.lrd`,
tolerances `validation/tolerances.tsv` (= table in `validation/FP_POLICY.md`; equality is itself a test).

## Tool availability (`which gfortran futhark matlab sas`)
```
gfortran: /usr/bin/gfortran
futhark: /usr/bin/futhark
matlab: NOT FOUND
sas: NOT FOUND
```
gfortran and futhark versions: `GNU Fortran (Debian 14.2.0-19) 14.2.0`; `Futhark 0.25.27.`.
LLVM toolchain as pinned in llvm/TOOLCHAIN.md (clang 19.1.7 (3+b1), llc/llvm-as/opt 19.1.7, llvm-config 19.1.7).
GNU Octave is installed but is not MATLAB, and no matlab/ track outputs exist. It is not used.

## References and what was compared
| reference | source (consumed read-only) | status |
|---|---|---|
| Fortran (acceptance) | committed `fixtures/reference/<CURRENT>/` on t001-ingest-fortran (head f6c4681), written by fortran/app/lrd_reference.f90 | ran: lrdc convert um->Angstrom vs wavelength_ang, lrdc residuals vs resid_Halpha and resid_Hbeta (a manual lrdcmp run on the same files reported n=429, finite pairs 429 / 16 / 24, maxabs 0, i.e. bit-identical); synthetic cases UNAVAILABLE (the Fortran app has no input CLI) |
| Futhark | `futhark/` committed on agent2-futhark (head eeb1e78), exported with git archive and built with `futhark c --safe` in a temp dir | ran: restframe, convert, residuals, chi2 (SYNTHETIC) + restframe, convert (real wavelength) |
| Fortran (Futhark track's reference) | `tests/futhark/fortran-ref` committed on agent2-futhark, built with gfortran in a temp dir | ran: same 6 cases |
| MATLAB | - | UNAVAILABLE: not installed (licensed), no outputs |
| SAS | - | UNAVAILABLE: not installed (licensed), no outputs |
Uncommitted edits in those worktrees are never used.

## FP policy enforcement
See FP_POLICY.md. Tests: fp_policy_env_binary64_rne, fp_policy_ll_no_fastmath_or_contract_flags (greps every
emitted .ll), fp_policy_build_flags, fp_policy_lrdc_invokes_llc_clang_contract_off, fp_policy_no_fma_instructions
(objdump), fp_policy_table_matches_tolerances_tsv. lrdcmp is always run with `--require-finite`, so an all-NaN
output cannot pass.

## Blockers
- MATLAB and SAS are licensed and not installed. They stay UNAVAILABLE.
- t001 Fortran publishes only fixed real-product outputs, so synthetic restframe/convert/residuals/chi2 have no t001
  Fortran reference. Real-data masked chi2 IS compared against the Fortran reference.kv values in tests/llvm/run.sh.
- References track moving branches. The heads used are printed above and in the futhark/fortran_fut build test names.

## Verbatim output of `bash tests/validation/run.sh` (after commit 38997017595aa22ae0ea648e5b4d12ca3302052a)
```
PASS toolchain_llvm_pinned
PASS tool_present_gfortran
PASS tool_present_futhark
UNAVAILABLE tool_present_matlab matlab not on PATH (licensed MathWorks product, not installed; GNU Octave is present but is not MATLAB)
UNAVAILABLE tool_present_sas sas not on PATH (licensed SAS Institute product, not installed)
PASS build_lrdc
PASS build_harness_helpers
PASS fp_policy_env_binary64_rne
PASS fp_policy_ll_no_fastmath_or_contract_flags
PASS fp_policy_build_flags
PASS fp_policy_lrdc_invokes_llc_clang_contract_off
PASS fp_policy_no_fma_instructions
PASS fp_policy_table_matches_tolerances_tsv
PASS input_real_jwst_wavelength
PASS compile_validation_programs
PASS fortran_t001_vs_lrdc_convert_real
PASS fortran_t001_vs_lrdc_residuals_Halpha
PASS fortran_t001_vs_lrdc_residuals_Hbeta
PASS acceptance_lrdc_vs_fortran
UNAVAILABLE fortran_t001_vs_lrdc_restframe_synth t001 Fortran publishes only fixed real-product outputs (fixtures/reference/<sha>); it has no CLI for these inputs and no rest-frame/chi2 output arrays
UNAVAILABLE fortran_t001_vs_lrdc_convert_synth t001 Fortran publishes only fixed real-product outputs (fixtures/reference/<sha>); it has no CLI for these inputs and no rest-frame/chi2 output arrays
UNAVAILABLE fortran_t001_vs_lrdc_residuals_synth t001 Fortran publishes only fixed real-product outputs (fixtures/reference/<sha>); it has no CLI for these inputs and no rest-frame/chi2 output arrays
UNAVAILABLE fortran_t001_vs_lrdc_chi2_synth t001 Fortran publishes only fixed real-product outputs (fixtures/reference/<sha>); it has no CLI for these inputs and no rest-frame/chi2 output arrays
UNAVAILABLE fortran_t001_vs_lrdc_restframe_real t001 Fortran publishes only fixed real-product outputs (fixtures/reference/<sha>); it has no CLI for these inputs and no rest-frame/chi2 output arrays
PASS build_futhark_reference_eeb1e78
PASS futhark_vs_lrdc_restframe_synth
PASS futhark_vs_lrdc_convert_synth
PASS futhark_vs_lrdc_residuals_synth
PASS futhark_vs_lrdc_chi2_synth
PASS futhark_vs_lrdc_restframe_real
PASS futhark_vs_lrdc_convert_real
PASS build_fortran_fut_reference_eeb1e78
PASS fortran_fut_vs_lrdc_restframe_synth
PASS fortran_fut_vs_lrdc_convert_synth
PASS fortran_fut_vs_lrdc_residuals_synth
PASS fortran_fut_vs_lrdc_chi2_synth
PASS fortran_fut_vs_lrdc_restframe_real
PASS fortran_fut_vs_lrdc_convert_real
UNAVAILABLE matlab_reference matlab not installed (licensed software); no matlab/ reference outputs in any worktree
UNAVAILABLE sas_reference sas not installed (licensed software); no sas/ reference outputs in any worktree
```
Exit code: 0

## Git state
`git -C /workspace/jwst-lrd-t014 rev-parse HEAD` at the time of this run: `38997017595aa22ae0ea648e5b4d12ca3302052a`. That commit holds all sources for this round (mask ops, masked real-data chi2, CONTRACTS v1.2 docs) on top of merge b2294fd (origin/main f83eb5b merged into t014-llvm). This STATUS file is committed afterwards in a STATUS-only commit, so the branch head is one commit later. A commit cannot contain its own hash.

`git status --short` at the time of this run:
```
(clean: no output)
```
