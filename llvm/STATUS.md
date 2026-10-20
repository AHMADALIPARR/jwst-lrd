<!-- SPDX-License-Identifier: AGPL-3.0-only. Also licensed under the SnapKitty Opaque License; see LICENSE and SNAPKITTY_OPAQUE_LICENSE.md at the repository root. -->
# llvm/STATUS.md: TASK 014 (LRD-IR -> LLVM pipeline, LRD-NUM-ABI)

Track: t014-llvm, worktree /workspace/jwst-lrd-t014. Last run: 2026-10-19 22:49 PDT.

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
in_range, and/or/not, residuals, chi2, mat, matmul, solve (LU with partial pivoting), flatten, ledger_proposal
(kind=ledger_append), gate (external verifier, ACCEPT-only). Elementwise kernels and chi2 are inline LLVM IR loops
without fast-math or contract flags. Everything else calls the C runtime.

## Assumptions
- payload_sha256 of a ledger proposal = SHA-256 of the payload array's little-endian binary64 bytes
  (identical to `sha256sum <prefix>.f64`). CONTRACTS.md does not fix what the payload is.
- `ledger_proposal` requires seq >= 1. It cannot check "prev seq + 1" because it does not know the previous state.
  That check belongs to the verifier.
- The gate checks the decision record strictly (magic, length prefixes, sorted keys, only decision/reason/new_commit,
  reason token `[a-z0-9_]{1,63}`, ACCEPT needs 64-hex new_commit, REJECT must not carry one). It does not check
  how new_commit was derived. The ACCEPT test stub uses SHA-256("LRD-COMMIT-v1\0" || proposal bytes), a
  choice made only for the stub.
- New state record = {commit=new_commit, kind, payload_sha256, seq} from the proposal (LRD-STATE-v1 fields).
- chi2 does not mask pixels: non-finite or <= 0 sigma is a runtime error. Real-data chi2 is therefore not run,
  because flam_err is NaN on masked pixels.
- solve flags a matrix as singular when a pivot is 0 or <= n*DBL_EPSILON*max|A_ij|.
- Real-data inputs come only from COMMITTED objects on t001-ingest-fortran (`git show`, head 69ee34a at run time):
  fixtures/ingest/CURRENT wavelength, and the Fortran reference outputs fixtures/reference/<sha>/
  {wavelength_ang, flam, model_Halpha, model_Hbeta, resid_Halpha, resid_Hbeta}. z = 7.0451 in
  tests/llvm/programs/real_full.lrd is Furtak et al. 2024 as cited in that branch's fortran/STATUS.md. It is only a
  transform parameter, compared against the C reference. It is not a new measurement.
- All other array fixtures are SYNTHETIC: tests/llvm/helpers/gen_synth.c writes SYNTHETIC_* names, with
  `note=SYNTHETIC ...` in every header. Outputs derived from them are also marked SYNTHETIC.

## Blockers / limits
- None blocking. Not supported: see llvm/SUPPORT.md ("Not supported").
- The real-data diff covers wavelength um->Angstrom (vs Fortran wavelength_ang) and residuals vs Fortran
  resid_Halpha/resid_Hbeta. The Fortran track publishes no rest-frame or chi2 arrays to diff against.

## Deviations from the task text
- The worktree was created with the exact contract command, but `main` had already moved from 6b9cef6 to
  db41431 (ledger header merged). So t014-llvm is based on db41431b8262a69bd791faef905c758a27879a86, not 6b9cef6.
- License header: the user asked for `SPDX-License-Identifier: AGPL-3.0-only` plus a SnapKitty Opaque License line.
  ledger/abi/lrd_state.h on main uses `AGPL-3.0-or-later AND LicenseRef-SnapKitty-Opaque`. I followed the user's
  wording, the same as the ingest/futhark/fortran tracks.
- Scope widened by the parent: abi/ and validation/ are also owned by this track. Local commits were approved
  later (author/committer Nova Parr).
- `real_jwst_diff` was expected to be UNAVAILABLE. While I worked, Foundry J Spec committed the real spectrum and
  Fortran reference outputs on t001-ingest-fortran, so the diff actually ran (see output).
- tests/llvm/fixtures/*.ll golden files carry a 3-line license comment. The test compares everything after it.

## Verbatim output of `bash tests/llvm/run.sh` (before commit)
Exit code: 0. Counts: PASS 129, FAIL 0, UNAVAILABLE 0.
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
PASS golden_ll_spectral
PASS golden_ll_kernels
PASS golden_ll_matrix
PASS golden_ll_full
PASS real_jwst_restframe_lrdc_vs_cref
PASS real_jwst_convert_lrdc_vs_cref
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

## Git state
`git -C /workspace/jwst-lrd-t014 rev-parse HEAD` at the time of this run: `db41431b8262a69bd791faef905c758a27879a86`. That is the branch base (main at db41431, see Deviations). Nothing of this track was committed yet, so `git status --short` lists all t014 files as untracked. The run is re-done after the commit, and this file is then updated in a second commit.

`git -C /workspace/jwst-lrd-t014 status --short`:
```
?? abi/
?? llvm/.gitignore
?? llvm/LRD-IR.md
?? llvm/Makefile
?? llvm/STATUS.md
?? llvm/SUPPORT.md
?? llvm/TOOLCHAIN.md
?? llvm/check_toolchain.sh
?? llvm/lrdc/
?? llvm/runtime/
?? llvm/toolchain.pin
?? tests/llvm/
?? tests/validation/
?? validation/
```
