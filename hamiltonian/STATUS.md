<!-- SPDX-License-Identifier: AGPL-3.0-only
     Also subject to SNAPKITTY_OPAQUE_LICENSE.md (dual license, see repository root). -->
# hamiltonian/STATUS.md — TASK 008 Frustration Hamiltonian Action-WORM engine

- Branch: `t008-hamiltonian` (worktree `/workspace/jwst-lrd-t008`, based on main `6b9cef6`).
- Code commit tested by the run below: **`5bff11408b5c85594a8304fc0fef9b2327ba08b0`** (also shown in the run's `# git:` line).
  This STATUS.md and the run log are added in the commit directly after it; a commit cannot
  contain its own SHA, so the branch head is that next commit (`git log -1 t008-hamiltonian`).
- Final run: 2026-10-19 22:36:15 PDT, log `tests/hamiltonian/logs/20261019T223615-0700.log`.
- Reviewer sign-off (HCALC Alloy): **not yet** — track is not "done" per CONTRACTS.md until then.

## Implemented (C17 + GMP `mpq_t`, no floating point in the engine)
- **Exact rational energy** `H_F(s) = Σ w_i V_i(s_i) + Σ J_ij C_ij(s_i,s_j) + Σ u_k [soft_k violated]`,
  all rationals canonical `mpq_t`; serialized as LRD-REC-v1 `p/q` (q>0, gcd=1, zero `0/1`, sign on p);
  strict canonical parser plus a lenient model-construction parser (`2/6` → `1/3`).
- **Hard constraints** (unary/binary allowed tables): violation ⇒ `infeasible`, never contribute energy.
  **Soft constraints** contribute `u` when violated.
- **Satisfiability** over the finite domain `S = Π {0..dom_v−1}` (n ≤ 64, dom ≤ 64) by deterministic
  lexicographic backtracking with a node budget; hitting the budget returns `HAM_ERR_LIMIT` /
  `report=search_limit` and claims nothing.
- **Conflict detection**: deletion-based irreducible conflict set (every member necessary — verified in tests).
- **Reports** (LRD-REC-v1): `report=satisfiable` (witness, witness_energy), `report=unsatisfiable`
  (`conflict`, `conflict_size`, `conflict_status=irreducible`, `scope.<name>`), `report=infeasible`
  counterexample (`assign`, `violated`, `violated_count`, `witness.<name>=x_i=v,…`).
- **Candidate transition evaluation / acceptance** (`ham_decide`): proposal is an LRD-STATE-v1
  `kind=hamiltonian_step` record with kind-specific fields `op` (`step`|`epoch_advance`), `assign`, `epoch`;
  ACCEPT iff envelope valid ∧ feasible ∧ `H(s') < H(s)` (exact `mpq_cmp`) ∧ budget remains.
  Reason precedence: malformed, wrong_kind, malformed, stale_seq, bad_prev, bad_payload, then
  (step) bad_epoch, epoch_exhausted, infeasible, energy_not_decreasing / (advance) bad_epoch, epoch_exhausted.
- **Bounded epochs**: `ham_epoch_cfg{budget B ≥ 1, max_epochs E ≥ 1}`; ≤ B accepted steps per epoch,
  then `epoch_exhausted`; **explicit** `op=epoch_advance` transitions (state/energy unchanged, epoch+1,
  used=0, own commit) rejected with `epoch_exhausted` beyond E. Total accepted transitions ≤ E·B+E−1.
  Rationale (ℚ with a lower bound is not well-founded) in OBLIGATIONS.md §3.
- **Never constructs on reject**: the only constructor is `construct_state`, called only on ACCEPT after
  all fallible work; `*next` untouched on REJECT/errors; counter `ham_states_constructed()`. Genesis on an
  infeasible assignment returns `HAM_ERR_INFEASIBLE` + report, nothing constructed.
- **Determinism**: decisions are canonical LRD-REC-v1 bytes from inputs only (no time/addresses/floats).
- **Commitments**: own FIPS 180-4 SHA-256; LRD-COMMIT-v1 = SHA-256("LRD-COMMIT-v1\0"‖ser), cross-checked
  against coreutils `sha256sum` in run.sh. Payloads bind the model commitment (`LRD-HAM-MODEL-v1`).
- Decision record fields: `assign, decision, energy_cand, energy_delta, energy_prev, epoch, epoch_budget,
  epoch_max, epoch_prev, epoch_steps_after (ACCEPT), epoch_steps_used, kind, new_commit (ACCEPT only), op,
  payload_sha256 (ACCEPT), prev_commit, proposal_commit, reason, seq, state_commit, state_seq,
  violated/violated_count (infeasible)` — fields present only once the corresponding check is reached.
- Proof obligations for the Agda track: `hamiltonian/OBLIGATIONS.md` (H-1 … H-11). Stated + tested, **not proved**.

## Build / test commands
```
tests/hamiltonian/run.sh          # CONTRACTS.md runner (builds everything, writes logs/<ts>.log)
make -C hamiltonian test          # wraps run.sh
make -C hamiltonian [std|clang|asan|clean]
```
gcc flags: `-std=c17 -Wall -Wextra -Werror -Wpedantic -Wshadow -Wstrict-prototypes -Wformat=2 -O2 -g`;
asan build adds `-fsanitize=address,undefined -fno-sanitize-recover=all` (LeakSanitizer confirmed functional on this box);
valgrind: `--leak-check=full --errors-for-leak-kinds=definite,indirect --error-exitcode=99`.

## Tool versions (from the run)
gcc 14.2.0 (Debian 14.2.0-19); Debian clang 19.1.7; GNU Make 4.4.1; valgrind-3.24.0; libgmp-dev 2:6.3.0+dfsg-3.
No ctest target (make + run.sh only).

## Measured results (final run)
- Top level: **37 PASS, 0 FAIL, 1 UNAVAILABLE**; exit 0.
- Unit suite (gcc): `# SUMMARY pass=29 fail=0 unavailable=0`; same 29/29 under clang and under ASan+UBSan.
- valgrind memcheck: `All heap blocks were freed -- no leaks are possible`, `ERROR SUMMARY: 0 errors`.
- Additional manual check (not in run.sh, not committed): mutating `<` to `<=` in the energy check and
  `>=` to `>` in the budget check each made several tests FAIL, i.e. the suite detects those faults.

## UNAVAILABLE
- `ledger_abi_header`: `ledger/abi/lrd_state.h` not on main, branch `t004-ledger` does not exist, not in any worktree
  (checked 2026-10-19 22:24 PDT). Built against **PROVISIONAL** `hamiltonian/abi/lrd_state.h` (constants + plain
  struct written from CONTRACTS.md v1, marked TODO(t004-ledger)). The Makefile switches to `../ledger/abi` automatically
  when the real header exists; the build may then need adapting to its actual names.
- Agda proofs: not written (this track does not own agda/); obligations only.

## Open issues
1. Reason tokens beyond those named in CONTRACTS.md v1 (`ok, stale_seq, bad_prev, energy_not_decreasing, infeasible`):
   this engine also emits `epoch_exhausted` (owner spec), `malformed`, `wrong_kind`, `bad_payload`, `bad_epoch`.
   CONTRACTS.md says "e.g.", so needs Hilbert to ratify the token set.
2. Kind-specific proposal fields (`op`, `assign`, `epoch`) and payload/model record formats
   (`LRD-HAM-PAYLOAD-v1`, `LRD-HAM-MODEL-v1`) are this track's own definitions; payload_sha256 is plain SHA-256 of the
   payload record bytes (CONTRACTS.md does not say whether the commit domain prefix applies to payloads).
3. Check order puts `epoch_exhausted` before `infeasible`/energy checks for steps (budget gate first); documented in
   OBLIGATIONS.md §1.6 — confirm with owner.
4. SAT is exhaustive backtracking (exponential worst case) with a node limit (default 10^7); large models get
   `search_limit`, never a guessed answer.
5. License header uses `SPDX-License-Identifier: AGPL-3.0-only` + SnapKitty line, matching sibling tracks (t001);
   confirm "-only" vs "-or-later" with the coordinator.
6. Awaiting HCALC Alloy review.

## Verbatim output of `tests/hamiltonian/run.sh` (final run)
```
# hamiltonian run.sh  log=/workspace/jwst-lrd-t008/tests/hamiltonian/logs/20261019T223615-0700.log
# date: 2026-10-19 22:36:15 PDT
# git: t008-hamiltonian 5bff11408b5c85594a8304fc0fef9b2327ba08b0
# gcc: gcc (Debian 14.2.0-19) 14.2.0
# clang: Debian clang version 19.1.7 (3+b1)
# make: GNU Make 4.4.1
# valgrind: valgrind-3.24.0
# gmp: libgmp-dev 2:6.3.0+dfsg-3
# abi header: hamiltonian/abi/lrd_state.h
UNAVAILABLE ledger_abi_header ledger/abi/lrd_state.h not landed; built against PROVISIONAL hamiltonian/abi/lrd_state.h
PASS no_float_in_engine
PASS no_py_ts_js
PASS build_gcc_c17_werror
PASS sha256_fips_vectors
PASS rec_canonical_bytes
PASS rec_commit_matches_sha256sum
PASS rec_parse_rejects_noncanonical
PASS rational_canonical_forms
PASS energy_exact_model_a
PASS soft_constraints_energy
PASS satisfiable
PASS unsatisfiable
PASS conflict_report_irreducible
PASS conflict_single_empty_constraint
PASS search_limit_explicit
PASS genesis_infeasible_no_state
PASS genesis_state_fields
PASS valid_descent_accepted
PASS equal_energy_rejected
PASS energy_increasing_rejected
PASS infeasible_transition_rejected
PASS epoch_exhausted
PASS epoch_transition_explicit
PASS envelope_rejects
PASS replay_rejected
PASS reject_never_constructs_state
PASS determinism_bytes
PASS script_expected_reasons
PASS exact_thirds_equal
PASS exact_tenths_double_would_accept
PASS exact_huge_values
PASS model_commit_binds
# SUMMARY pass=29 fail=0 unavailable=0
PASS build_clang_c17_werror
#   PASS sha256_fips_vectors
#   PASS rec_canonical_bytes
#   PASS rec_commit_matches_sha256sum
#   PASS rec_parse_rejects_noncanonical
#   PASS rational_canonical_forms
#   PASS energy_exact_model_a
#   PASS soft_constraints_energy
#   PASS satisfiable
#   PASS unsatisfiable
#   PASS conflict_report_irreducible
#   PASS conflict_single_empty_constraint
#   PASS search_limit_explicit
#   PASS genesis_infeasible_no_state
#   PASS genesis_state_fields
#   PASS valid_descent_accepted
#   PASS equal_energy_rejected
#   PASS energy_increasing_rejected
#   PASS infeasible_transition_rejected
#   PASS epoch_exhausted
#   PASS epoch_transition_explicit
#   PASS envelope_rejects
#   PASS replay_rejected
#   PASS reject_never_constructs_state
#   PASS determinism_bytes
#   PASS script_expected_reasons
#   PASS exact_thirds_equal
#   PASS exact_tenths_double_would_accept
#   PASS exact_huge_values
#   PASS model_commit_binds
#   # SUMMARY pass=29 fail=0 unavailable=0
PASS clang_suite
# clang_suite: 29 tests passed, 0 failed, exit 0
PASS build_asan_ubsan
#   PASS sha256_fips_vectors
#   PASS rec_canonical_bytes
#   PASS rec_commit_matches_sha256sum
#   PASS rec_parse_rejects_noncanonical
#   PASS rational_canonical_forms
#   PASS energy_exact_model_a
#   PASS soft_constraints_energy
#   PASS satisfiable
#   PASS unsatisfiable
#   PASS conflict_report_irreducible
#   PASS conflict_single_empty_constraint
#   PASS search_limit_explicit
#   PASS genesis_infeasible_no_state
#   PASS genesis_state_fields
#   PASS valid_descent_accepted
#   PASS equal_energy_rejected
#   PASS energy_increasing_rejected
#   PASS infeasible_transition_rejected
#   PASS epoch_exhausted
#   PASS epoch_transition_explicit
#   PASS envelope_rejects
#   PASS replay_rejected
#   PASS reject_never_constructs_state
#   PASS determinism_bytes
#   PASS script_expected_reasons
#   PASS exact_thirds_equal
#   PASS exact_tenths_double_would_accept
#   PASS exact_huge_values
#   PASS model_commit_binds
#   # SUMMARY pass=29 fail=0 unavailable=0
PASS asan_ubsan_suite
# asan_ubsan_suite: 29 tests passed, 0 failed, exit 0
#   ==1330411== All heap blocks were freed -- no leaks are possible
#   ==1330411== ERROR SUMMARY: 0 errors from 0 contexts (suppressed: 0 from 0)
PASS valgrind_memcheck
# runner: fails=0
```
