<!-- SPDX-License-Identifier: AGPL-3.0-only. Also licensed under the SnapKitty Opaque License; see LICENSE and SNAPKITTY_OPAQUE_LICENSE.md at the repository root. -->
# llvm/STATUS.md: TASK 014 (LRD-IR -> LLVM pipeline, LRD-NUM-ABI)

Track: t014-llvm, worktree /workspace/jwst-lrd-t014. Last run: 2026-10-19 23:03 PDT.

## What built
- `llvm/lrdc/lrdc.c` (C17): the LRD-IR compiler. Parser, type checker, LLVM IR text emitter, and a driver that
  runs `llc -O2 --fp-contract=off -relocation-model=pic -filetype=obj` and then `clang -ffp-contract=off -fno-fast-math`.
- `llvm/runtime/`: `lrd_rt.{h,c}` (ops called from IR, proof gate via fork/exec), `lrd_rec.{h,c}`
  (LRD-REC-v1 build/serialize/strict parse/commit), `lrd_sha256.{h,c}` (own SHA-256, no libcrypto).
  The runtime includes `ledger/abi/lrd_state.h` (read-only, not forked) and uses `abi/lrd_num_abi.h` for all array I/O.
- `abi/lrd_num_abi.{h,c}`: LRD-NUM-ABI version 1 (`LRD_NUM_ABI_VERSION 1`), an LRD-ARR-v1 reader and writer, with
  the self-test `abi/test_lrd_num_abi.c` (round-trip bit-exact, bad headers, length mismatch, unit mismatch).
- `llvm/Makefile`, `llvm/check_toolchain.sh`, `llvm/toolchain.pin` (version pin; refuses to build on a mismatch).
- Tests: `tests/llvm/run.sh`, helpers `tests/llvm/helpers/{gen_synth,ref,sha_vectors,rec_tool}.c`,
  verifier TEST STUBS `tests/llvm/stubs/verifier_stub_{accept,reject,garbage}.c`, LRD-IR programs
  `tests/llvm/programs/*.lrd`, negative programs `tests/llvm/neg/*.lrd`, golden IR `tests/llvm/fixtures/*.ll`.

## Toolchain (see llvm/TOOLCHAIN.md; nothing installed via apt)
- clang --version: `Debian clang version 19.1.7 (3+b1)`
- llc --version: `Debian LLVM version 19.1.7`
- llvm-config --version: `19.1.7`
- llvm-as / opt --version: `Debian LLVM version 19.1.7`

## LRD-IR summary (full grammar: llvm/LRD-IR.md; tested ops: llvm/SUPPORT.md)
Line-based and SSA-like: `let x : T = op(args)`, plus `print`, `store`, `emit`, `assert`. Types are f64, i64, bool,
arr<f64> (LRD-ARR-v1), mat<f64>, rec (LRD-REC-v1), and argument-only str (literals, `$N`). Ops: load, len, get,
restframe, obsframe, redshift, redshift_arr, convert (um/nm/Angstrom, exact factors), all_finite, monotone_inc,
in_range, and/or/not, residuals, chi2, mask, mask_finite, mask_and, apply_mask, mat, matmul, solve (LU with partial pivoting), flatten, ledger_proposal
(kind=ledger_append), gate (external verifier, ACCEPT-only). Elementwise kernels and chi2 are inline LLVM IR loops
without fast-math or contract flags. Everything else calls the C runtime.

## Assumptions
- payload_sha256 of a ledger proposal = SHA-256 of the raw `.f64` bytes only (little-endian binary64, `.hdr`
  excluded), as defined in research/CONTRACTS.md v1.2. Identical to `sha256sum <prefix>.f64` (test ledger_proposal_commit_vs_sha256sum).
- `ledger_proposal` requires seq >= 1. It cannot check "prev seq + 1" because it does not know the previous state.
  That check belongs to the verifier.
- The gate checks the decision record strictly (magic, length prefixes, sorted keys, only decision/reason/new_commit,
  reason token `[a-z0-9_]{1,63}`, ACCEPT needs 64-hex new_commit, REJECT must not carry one). It does not check
  how new_commit was derived. The ACCEPT test stub uses SHA-256("LRD-COMMIT-v1\0" || proposal bytes), a
  choice made only for the stub.
- New state record = {commit=new_commit, kind, payload_sha256, seq} from the proposal (LRD-STATE-v1 fields).
- Masking (CONTRACTS v1.2, research/BLIND-PROTOCOL.md) is an explicit op: `mask(flux, sigma, path)` excludes non-finite
  flux, non-finite sigma and sigma <= 0, writes an LRD-ARR-v1 mask (unit 1) with kept/excluded counts in its header and
  logs them on stdout. `mask_finite` (model window: the Fortran models are NaN outside the line window), `mask_and`
  and `apply_mask` complete the chain. chi2 itself still rejects non-finite or <= 0 sigma (neg_chi2_zero_sigma,
  neg_chi2_unmasked_nan_sigma).
- Real-data masked chi2 (tests/llvm/programs/mask_chi2.lrd): mask from ingest FLUX/FLUX_ERROR (Jy), chi2 over the Fortran
  flam, flam_err and model_<line> arrays. Kept pixels: 429 rows -> 408 after the protocol mask (21 excluded: NaN flux,
  FLUX_ERROR = 0) -> 16 (Halpha) and 24 (Hbeta) after the model window, matching reference.kv n_rows=429, n_valid=408,
  model.Halpha.n=16, model.Hbeta.n=24. chi2: Halpha 95.587821301959664, Hbeta 16.65575944028793, equal to the Fortran
  reference.kv model.<line>.chi2_line values and to the independent C reference (ref masked_chi2). The protocol mask is
  byte-identical to the Fortran mask.f64.
- solve flags a matrix as singular when a pivot is 0 or <= n*DBL_EPSILON*max|A_ij|.
- Real-data inputs come only from COMMITTED objects on t001-ingest-fortran (`git show`; local branch head 04e2319 at the start of the last run and 641faff at its end, since another agent
  is committing to it; the reference arrays and reference.kv used are identical to origin/t001-ingest-fortran feeb98b):
  fixtures/ingest/CURRENT wavelength, and the Fortran reference outputs fixtures/reference/<sha>/
  {wavelength_ang, flam, flam_err, mask, model_Halpha, model_Hbeta, resid_Halpha, resid_Hbeta, reference.kv}, plus ingest flux and flux_error. z = 7.0451 in
  tests/llvm/programs/real_full.lrd is Furtak et al. 2024 as cited in that branch's fortran/STATUS.md. It is only a
  transform parameter, compared against the C reference. It is not a new measurement.
- All other array fixtures are SYNTHETIC: tests/llvm/helpers/gen_synth.c writes SYNTHETIC_* names, with
  `note=SYNTHETIC ...` in every header. Outputs derived from them are also marked SYNTHETIC.

## Blockers / limits
- None blocking. Not supported: see llvm/SUPPORT.md ("Not supported").
- The real-data diff covers wavelength um->Angstrom (vs Fortran wavelength_ang) and residuals vs Fortran
  resid_Halpha/resid_Hbeta, and masked chi2 vs the Fortran reference.kv chi2_line values. The Fortran track publishes
  no rest-frame array to diff against.

## Deviations from the task text
- The worktree was created with the exact contract command, but `main` had already moved from 6b9cef6 to
  db41431 (ledger header merged). So t014-llvm is based on db41431b8262a69bd791faef905c758a27879a86, not 6b9cef6.
- License header: the user asked for `SPDX-License-Identifier: AGPL-3.0-only` plus a SnapKitty Opaque License line.
  All files owned by this track say AGPL-3.0-only (CONTRACTS v1.2). ledger/ is not owned here and was not edited.
- Scope widened by the parent: abi/ and validation/ are also owned by this track. Local commits were approved
  later (author/committer Nova Parr).
- `real_jwst_diff` was expected to be UNAVAILABLE. While I worked, Foundry J Spec committed the real spectrum and
  Fortran reference outputs on t001-ingest-fortran, so the diff actually ran (see output).
- tests/llvm/fixtures/*.ll golden files carry a 3-line license comment. The test compares everything after it.

## Verbatim output of `bash tests/llvm/run.sh` (after commit 38997017595aa22ae0ea648e5b4d12ca3302052a)
```
PASS toolchain_clang
PASS toolchain_llc
PASS toolchain_llvm-config
PASS toolchain_llvm-as
PASS toolchain_opt
PASS build_lrdc_runtime
PASS build_abi
PASS build_test_helpers
PASS abi_version
PASS abi_roundtrip_bitexact
PASS abi_little_endian_layout
PASS abi_zero_length
PASS abi_bad_header_format
PASS abi_bad_header_missing_unit
PASS abi_bad_header_duplicate_key
PASS abi_bad_header_leading_zero
PASS abi_bad_header_no_equals
PASS abi_length_mismatch
PASS abi_length_partial_value
PASS abi_unit_mismatch
PASS abi_missing_file
PASS synthetic_fixture_marked
PASS verify_ll_load
PASS run_load
PASS verify_ll_spectral
PASS run_restframe_vs_ref
PASS run_convert_um_angstrom_vs_ref
PASS run_convert_um_nm_vs_ref
PASS run_obsframe_vs_ref
PASS run_convert_angstrom_um_vs_ref
PASS verify_ll_convert_nm
PASS run_convert_nm_um_vs_ref
PASS run_convert_nm_angstrom_vs_ref
PASS run_convert_angstrom_nm_vs_ref
PASS verify_ll_redshift
PASS run_redshift_scalar_hand
PASS run_redshift_arr_vs_ref
PASS verify_ll_constraints
PASS run_constraints_hand
PASS verify_ll_kernels
PASS run_residuals_vs_ref
PASS run_chi2_vs_ref
PASS verify_ll_chi2_hand
PASS run_chi2_residuals_hand
PASS verify_ll_mask_chi2
PASS run_mask_logged_counts_hand
PASS run_mask_array_mask_hand
PASS run_mask_array_window_hand
PASS run_mask_array_maskand_hand
PASS run_mask_hdr_lrd_arr_v1
PASS run_masked_chi2_vs_cref
PASS verify_ll_matrix
PASS run_matmul_vs_ref
PASS run_solve_vs_cramer_ref
PASS run_solve_vs_hand
PASS run_matmul_hand
PASS sha256_abc
PASS sha256_empty
PASS sha256_448bit
PASS sha256_million_a
PASS sha256_vs_sha256sum_file
PASS rec_serialize_sorted_lenprefixed
PASS rec_commit_vs_sha256sum
PASS rec_commit_domain_14_bytes
PASS rec_reject_duplicate_key
PASS rec_parse_reject_unsorted
PASS rec_parse_reject_leading_zero
PASS rec_parse_reject_bad_length
PASS rec_parse_reject_no_magic
PASS rec_parse_roundtrip
PASS verify_ll_ledger
PASS ledger_proposal_bytes_vs_printf
PASS ledger_proposal_commit_vs_sha256sum
PASS verify_ll_gate
PASS gate_accept_constructs_state
PASS neg_verifier_reject
PASS neg_verifier_reject_no_state
PASS neg_verifier_garbage
PASS neg_verifier_garbage_no_state
PASS neg_verifier_missing
PASS neg_unknown_op
PASS neg_type_mismatch_chi2_bool
PASS neg_wrong_arity
PASS neg_undefined_variable
PASS neg_unknown_unit_conversion
PASS neg_declared_type_mismatch
PASS neg_redefinition
PASS neg_unsupported_type
PASS neg_unknown_statement
PASS neg_missing_version_line
PASS neg_length_mismatch_residuals
PASS neg_length_mismatch_chi2
PASS neg_bad_header_format
PASS neg_bad_header_length
PASS neg_load_unit_mismatch
PASS neg_convert_runtime_unit
PASS neg_solve_singular
PASS neg_mat_shape
PASS neg_matmul_dimension
PASS neg_missing_program_argument
PASS neg_assert_false
PASS neg_chi2_zero_sigma
PASS neg_mask_path_type
PASS neg_chi2_unmasked_nan_sigma
PASS neg_apply_mask_not_01
PASS neg_apply_mask_unit
PASS neg_mask_length_mismatch
PASS neg_mask_unit_mismatch
PASS neg_mask_no_output_on_error
PASS verify_ll_full
PASS full_restframe_angstrom_vs_ref
PASS full_residuals_vs_ref
PASS full_chi2_vs_ref
PASS full_proposal_bytes
PASS full_gate_accept_state
PASS full_output_marked_synthetic
PASS full_program_reject
PASS deterministic_ll_load
PASS deterministic_ll_spectral
PASS deterministic_ll_convert_nm
PASS deterministic_ll_redshift
PASS deterministic_ll_constraints
PASS deterministic_ll_kernels
PASS deterministic_ll_matrix
PASS deterministic_ll_ledger
PASS deterministic_ll_gate
PASS deterministic_ll_full
PASS deterministic_ll_mask_chi2
PASS golden_ll_spectral
PASS golden_ll_kernels
PASS golden_ll_matrix
PASS golden_ll_full
PASS golden_ll_mask_chi2
PASS real_jwst_restframe_lrdc_vs_cref
PASS real_jwst_convert_lrdc_vs_cref
  mask: mask n=429 kept=408 excluded=21 (nonfinite_flux=21 nonfinite_sigma=0 sigma_le_0=21; reasons may overlap)
  mask_finite: window n=429 kept=16 excluded=413 (non-finite values)
  mask_and: mw n=429 kept=16 excluded=413
  n = 16
  c = 95.587821301959664
PASS real_jwst_mask_counts_Halpha
PASS real_jwst_mask_vs_fortran_mask_Halpha
  ref masked_chi2: n=429 base_kept=408 kept=16 chi2=95.587821301959664
PASS real_jwst_masked_chi2_lrdc_vs_cref_Halpha
  fortran reference.kv model.Halpha.chi2_line=9.5587821301959664E+001 model.Halpha.n=16
PASS real_jwst_masked_chi2_lrdc_vs_fortran_Halpha
  mask: mask n=429 kept=408 excluded=21 (nonfinite_flux=21 nonfinite_sigma=0 sigma_le_0=21; reasons may overlap)
  mask_finite: window n=429 kept=24 excluded=405 (non-finite values)
  mask_and: mw n=429 kept=24 excluded=405
  n = 24
  c = 16.65575944028793
PASS real_jwst_mask_counts_Hbeta
PASS real_jwst_mask_vs_fortran_mask_Hbeta
  ref masked_chi2: n=429 base_kept=408 kept=24 chi2=16.65575944028793
PASS real_jwst_masked_chi2_lrdc_vs_cref_Hbeta
  fortran reference.kv model.Hbeta.chi2_line=1.6655759440287930E+001 model.Hbeta.n=24
PASS real_jwst_masked_chi2_lrdc_vs_fortran_Hbeta
PASS real_jwst_masked_chi2
PASS verify_ll_real_full
PASS real_jwst_diff_wavelength_ang_Halpha
PASS real_jwst_diff_resid_Halpha
PASS real_jwst_restframe_z7_lrdc_vs_cref_Halpha
PASS real_jwst_ledger_gate_Halpha
PASS real_jwst_diff_wavelength_ang_Hbeta
PASS real_jwst_diff_resid_Hbeta
PASS real_jwst_restframe_z7_lrdc_vs_cref_Hbeta
PASS real_jwst_ledger_gate_Hbeta
PASS real_jwst_diff
```
Exit code: 0

## Git state
`git -C /workspace/jwst-lrd-t014 rev-parse HEAD` at the time of this run: `38997017595aa22ae0ea648e5b4d12ca3302052a`. That commit holds all sources for this round (mask ops, masked real-data chi2, CONTRACTS v1.2 docs) on top of merge b2294fd (origin/main f83eb5b merged into t014-llvm). This STATUS file is committed afterwards in a STATUS-only commit, so the branch head is one commit later. A commit cannot contain its own hash.

`git status --short` at the time of this run:
```
(clean: no output)
```
