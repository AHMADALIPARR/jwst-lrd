<!-- SPDX-License-Identifier: AGPL-3.0-only. Also licensed under the SnapKitty Opaque License; see LICENSE and SNAPKITTY_OPAQUE_LICENSE.md at the repository root. -->
# LRD-IR support matrix

An op is listed as **supported** only if it compiles through the LLVM path (lrdc -> .ll checked
by `llvm-as` and `opt -passes=verify` -> llc -> clang) **and** at least one test named here
passes in `tests/llvm/run.sh` or `tests/validation/run.sh`. Test names are the exact `PASS` names.
"inline IR" means the arithmetic is emitted as LLVM instructions. "runtime" means a call into
`llvm/runtime` (C, built with the FP policy flags).

## Supported (compiled through LLVM and tested)
| op / statement | lowering | passing tests |
|---|---|---|
| `load` | runtime (abi/lrd_num_abi) | `run_load`, `neg_bad_header_format`, `neg_bad_header_length`, `neg_load_unit_mismatch`, `neg_missing_program_argument`, `real_jwst_diff` |
| `len` | runtime | `run_load` |
| `get` | runtime | `run_load` |
| `restframe` | inline IR loop (`fdiv` by `fadd 1,z`) | `run_restframe_vs_ref`, `real_jwst_restframe_lrdc_vs_cref`, `real_jwst_restframe_z7_lrdc_vs_cref_Halpha`, `futhark_vs_lrdc_restframe_synth`, `futhark_vs_lrdc_restframe_real`, `fortran_fut_vs_lrdc_restframe_synth`, `fortran_fut_vs_lrdc_restframe_real` |
| `obsframe` | inline IR loop | `run_obsframe_vs_ref` |
| `redshift` (scalar) | inline IR (`fdiv`, `fsub`) | `run_redshift_scalar_hand` |
| `redshift_arr` | inline IR loop | `run_redshift_arr_vs_ref` |
| `convert` um->Angstrom | inline IR loop (`fmul 1e4`) | `run_convert_um_angstrom_vs_ref`, `real_jwst_diff_wavelength_ang_Halpha`, `fortran_t001_vs_lrdc_convert_real`, `futhark_vs_lrdc_convert_synth`, `fortran_fut_vs_lrdc_convert_real` |
| `convert` Angstrom->um | inline IR loop (`fdiv 1e4`) | `run_convert_angstrom_um_vs_ref` |
| `convert` um->nm | inline IR loop | `run_convert_um_nm_vs_ref` |
| `convert` nm->um | inline IR loop | `run_convert_nm_um_vs_ref` |
| `convert` nm->Angstrom | inline IR loop | `run_convert_nm_angstrom_vs_ref` |
| `convert` Angstrom->nm | inline IR loop | `run_convert_angstrom_nm_vs_ref` |
| `convert` unknown pair (rejected) | compile-time error | `neg_unknown_unit_conversion` |
| `convert` array unit != `from` (rejected) | runtime check | `neg_convert_runtime_unit` |
| `all_finite` | runtime | `run_constraints_hand`, `neg_assert_false` |
| `monotone_inc` | runtime | `run_constraints_hand` |
| `in_range` (arr and f64 overloads) | runtime | `run_constraints_hand` |
| `and`, `or`, `not` | inline IR (`and`/`or`/`xor i1`) | `run_constraints_hand` |
| `residuals` | inline IR loop (`fsub`) | `run_residuals_vs_ref`, `run_chi2_residuals_hand`, `neg_length_mismatch_residuals`, `real_jwst_diff_resid_Halpha`, `real_jwst_diff_resid_Hbeta`, `fortran_t001_vs_lrdc_residuals_Halpha`, `fortran_t001_vs_lrdc_residuals_Hbeta`, `futhark_vs_lrdc_residuals_synth`, `fortran_fut_vs_lrdc_residuals_synth` |
| `chi2` | inline IR loop (`fsub`,`fdiv`,`fmul`,`fadd`) | `run_chi2_vs_ref`, `run_chi2_residuals_hand`, `neg_length_mismatch_chi2`, `neg_chi2_zero_sigma`, `neg_chi2_unmasked_nan_sigma`, `run_masked_chi2_vs_cref`, `real_jwst_masked_chi2_lrdc_vs_cref_Halpha`, `real_jwst_masked_chi2_lrdc_vs_cref_Hbeta`, `real_jwst_masked_chi2_lrdc_vs_fortran_Halpha`, `real_jwst_masked_chi2_lrdc_vs_fortran_Hbeta`, `futhark_vs_lrdc_chi2_synth`, `fortran_fut_vs_lrdc_chi2_synth` |
| `mask` (protocol rule; writes and logs mask) | runtime | `run_mask_logged_counts_hand`, `run_mask_array_mask_hand`, `run_mask_hdr_lrd_arr_v1`, `neg_mask_length_mismatch`, `neg_mask_unit_mismatch`, `neg_mask_no_output_on_error`, `neg_mask_path_type`, `real_jwst_mask_counts_Halpha`, `real_jwst_mask_counts_Hbeta`, `real_jwst_mask_vs_fortran_mask_Halpha`, `real_jwst_mask_vs_fortran_mask_Hbeta` |
| `mask_finite` | runtime | `run_mask_logged_counts_hand`, `run_mask_array_window_hand`, `real_jwst_mask_counts_Halpha`, `real_jwst_mask_counts_Hbeta` |
| `mask_and` | runtime | `run_mask_logged_counts_hand`, `run_mask_array_maskand_hand`, `real_jwst_mask_counts_Halpha`, `real_jwst_mask_counts_Hbeta` |
| `apply_mask` | runtime | `run_mask_logged_counts_hand`, `run_masked_chi2_vs_cref`, `neg_apply_mask_not_01`, `neg_apply_mask_unit`, `real_jwst_masked_chi2_lrdc_vs_cref_Halpha`, `real_jwst_masked_chi2_lrdc_vs_cref_Hbeta` |
| `mat` | runtime | `run_matmul_vs_ref`, `neg_mat_shape` |
| `matmul` | runtime | `run_matmul_vs_ref`, `run_matmul_hand`, `neg_matmul_dimension` |
| `solve` (LU, partial pivoting) | runtime | `run_solve_vs_cramer_ref`, `run_solve_vs_hand`, `neg_solve_singular` |
| `flatten` | runtime | `run_matmul_vs_ref` |
| `ledger_proposal` | runtime | `ledger_proposal_bytes_vs_printf`, `ledger_proposal_commit_vs_sha256sum`, `full_proposal_bytes` |
| `gate` | runtime (fork/exec verifier) | `gate_accept_constructs_state`, `neg_verifier_reject`, `neg_verifier_reject_no_state`, `neg_verifier_garbage`, `neg_verifier_garbage_no_state`, `neg_verifier_missing`, `full_gate_accept_state`, `full_program_reject` |
| `print` (f64, i64, bool, arr, mat, rec) | runtime | `run_load`, `run_constraints_hand`, `run_chi2_residuals_hand`, `run_matmul_hand`, `ledger_proposal_commit_vs_sha256sum` |
| `store` (arr, f64) | runtime (abi writer) | `run_restframe_vs_ref`, `run_chi2_vs_ref` |
| `emit` (rec) | runtime | `ledger_proposal_bytes_vs_printf`, `gate_accept_constructs_state` |
| `assert` | runtime | `neg_assert_false`, `full_restframe_angstrom_vs_ref` (assert passes in full.lrd) |
| literals `let x : f64/i64/bool = ...` | constants in IR | `run_redshift_scalar_hand`, `run_constraints_hand` |
| compile-time rejection: unknown op, type mismatch, wrong arity, undefined variable, declared-type mismatch, redefinition, unsupported type, unknown statement, missing `lrdir 1` | lrdc front end | `neg_unknown_op`, `neg_type_mismatch_chi2_bool`, `neg_wrong_arity`, `neg_undefined_variable`, `neg_declared_type_mismatch`, `neg_redefinition`, `neg_unsupported_type`, `neg_unknown_statement`, `neg_missing_version_line` |
| deterministic `.ll` output | lrdc | `deterministic_ll_*`, `golden_ll_spectral`, `golden_ll_kernels`, `golden_ll_matrix`, `golden_ll_full`, `golden_ll_mask_chi2` |

## Not supported (not implemented; rejected by lrdc as `unknown operation`/`unknown type`)
- scalar arithmetic (`add`, `sub`, `mul`, `div`, `pow`, `exp`, `log`, `sqrt`), i64 arithmetic, comparisons
- control flow, loops, user functions, variable copy/rebinding, string variables
- arrays of element types other than f64 (`arr<i64>` etc.), slicing, concatenation, implicit masking or NaN filtering (masking exists only as the explicit `mask`/`mask_finite`/`mask_and`/`apply_mask` ops)
- vacuum<->air conversion, f_nu<->f_lambda (Jy -> erg s-1 cm-2 A-1) conversion, any unit pair not in LRD-IR.md
- Gaussian line models, line fitting, redshift grid search, peak finding, cosmic time
- matrix inverse, determinant, transpose, least squares, matrix-vector product
- chi2 that masks internally: chi2 still rejects non-finite or non-positive sigma (CONTRACTS v1.2); mask first with `mask` + `apply_mask`
- ledger kinds other than `ledger_append`. Proposals with kind-specific extra fields. Arbitrary `rec` construction
- verifying `new_commit` against any rule (the gate checks only that it is 64 lowercase hex)

## Implemented but without a dedicated test (not claimed beyond the rows above)
- Runtime error paths `restframe`/`obsframe` with z <= -1, `redshift` with non-positive input,
  `get` out of bounds, `solve` with a non-square matrix or rhs length mismatch, and
  verifier output with unknown fields or `new_commit` on REJECT.
