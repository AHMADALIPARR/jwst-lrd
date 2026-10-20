<!-- Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
     Dual-licensed: AGPL-3.0-or-later plus SnapKitty Opaque License (see LICENSE, SNAPKITTY_OPAQUE_LICENSE.md).
     SPDX-License-Identifier: AGPL-3.0-or-later AND LicenseRef-SnapKitty-Opaque -->
# hamiltonian/STATUS.md — TASK 008 Frustration Hamiltonian Action-WORM engine

- Branch: `t008-hamiltonian`, worktree `/workspace/jwst-lrd-t008`, based on main `db41431`
  (main has since gained `5eb191a`, which only touches research/INTEGRATION.md).
- Code commit tested by the run below: **`36db32a1a56ddf67b894a0cfda3895d50bac6bd6`** (the run's `# git:` line shows it).
  This STATUS.md and the run log go into the next commit. A commit can't contain its own SHA, so the branch
  head is that next commit (`git rev-parse t008-hamiltonian`). It changes only STATUS.md and the log.
- Final run: 2026-10-19 22:39:48 PDT, log `tests/hamiltonian/logs/20261019T223948-0700.log`.
- Reviewer sign-off (HCALC Alloy): **not yet**. Per CONTRACTS.md the track is not done until that review.

## ABI header
Built against the **real** `ledger/abi/lrd_state.h`, owned by the ledger track and merged on main at 627fda7.
sha256 is `563d0ea4bc82442f302be397721e26697916efccff8d4f194d190d3b4f515920`. The provisional copy used during
development was deleted, so nothing is forked. The Makefile errors out if the header is missing. The engine uses
`lrd_state_t`, `lrd_proposal_t`, `lrd_decision_t`, `lrd_kind_token` and `lrd_decision_reject`.
`ham_decide_abi` meets the `lrd_transition_fn` contract but takes the context explicitly (model, epoch cfg, engine state).

## Implemented (C17 + GMP `mpq_t`, no floating point in the engine)
- **Exact rational energy.** `H_F(s) = Σ w_i V_i(s_i) + Σ J_ij C_ij(s_i,s_j) + Σ u_k [soft_k violated]`. Every rational is a
  canonical `mpq_t`, serialized per LRD-REC-v1 as `p/q` (q>0, gcd=1, zero is `0/1`, sign on p). There is a strict
  canonical parser, plus a lenient parser for building models that canonicalizes its input (`2/6` → `1/3`).
- **Hard constraints** are unary or binary allowed-tables. A violation means `infeasible`. They never add energy.
  **Soft constraints** add `u` when violated.
- **Satisfiability** is decided over the finite domain `S = Π {0..dom_v−1}` (n ≤ 64, dom ≤ 64). The search is deterministic
  lexicographic backtracking with a node budget. If the budget runs out the result is `HAM_ERR_LIMIT` / `report=search_limit`,
  and no answer is claimed.
- **Conflict detection** uses deletion to find an irreducible conflict set: removing any one member makes the rest satisfiable,
  and the tests check this.
- **Reports** are LRD-REC-v1 records:
  - `report=satisfiable`: witness and witness_energy.
  - `report=unsatisfiable`: `conflict`, `conflict_size`, `conflict_status=irreducible`, `scope.<name>`.
  - `report=infeasible` counterexample: `assign`, `violated`, `violated_count`, `witness.<name>=x_i=v,…`.
- **Decisions** (`ham_decide`). A proposal is an LRD-STATE-v1 `kind=hamiltonian_step` record with the kind-specific fields
  `op` (`step` or `epoch_advance`), `assign` and `epoch`. It is ACCEPTed only if the envelope is valid, the candidate is feasible,
  `H(s') < H(s)` holds under exact `mpq_cmp`, and epoch budget remains. Reasons are checked in this order (full table in OBLIGATIONS.md §1.6):
  - All proposals: malformed, wrong_kind, malformed, stale_seq, bad_prev, bad_payload.
  - `step`: then bad_epoch, epoch_exhausted, infeasible, energy_not_decreasing.
  - `epoch_advance`: then bad_epoch, epoch_exhausted.
- **Bounded epochs.** Configured by `ham_epoch_cfg{budget B ≥ 1, max_epochs E ≥ 1}`.
  - An epoch allows at most B accepted steps. The next step gets `epoch_exhausted`.
  - Epochs change only through an **explicit**, recorded `op=epoch_advance` transition. It keeps the state and energy, sets epoch+1
    and used=0, and has its own commit. An advance past E is rejected with `epoch_exhausted`.
  - At most E·B+E−1 transitions can be accepted in total. OBLIGATIONS.md §3 explains why: ℚ with a lower bound is not well-founded.
- **Reject never constructs a state.** `construct_state` is the only constructor. It runs only on ACCEPT, after all work that can
  fail. On REJECT or error, `*next` and `*next_view` are left untouched and the counter `ham_states_constructed()` does not change.
  Genesis from an infeasible assignment returns `HAM_ERR_INFEASIBLE` plus a report and constructs nothing.
- **Determinism.** Decisions are canonical LRD-REC-v1 bytes computed from the inputs alone (no time, addresses or floats).
- **Commitments.** SHA-256 is implemented in-tree (FIPS 180-4). LRD-COMMIT-v1 = SHA-256("LRD-COMMIT-v1\0"‖ser), cross-checked
  against coreutils `sha256sum` in run.sh. Payloads bind the model commitment (`LRD-HAM-MODEL-v1`).
- **Decision record fields:** `assign, decision, energy_cand, energy_delta, energy_prev, epoch, epoch_budget, epoch_max, epoch_prev,
  epoch_steps_after (ACCEPT), epoch_steps_used, kind, new_commit (ACCEPT only), op, payload_sha256 (ACCEPT), prev_commit,
  proposal_commit, reason, seq, state_commit, state_seq, violated/violated_count (infeasible)`. A field appears only once the check
  that produces it has been reached.
- **Proof obligations** for the Agda track to mirror in `agda/Core/Hamiltonian.agda` are in `hamiltonian/OBLIGATIONS.md` (H-1 … H-12).
  They are stated and tested in C but **not proved**.

## Build / test commands
```
tests/hamiltonian/run.sh          # CONTRACTS.md runner (builds everything, writes logs/<ts>.log)
make -C hamiltonian test          # wraps run.sh
make -C hamiltonian [std|clang|asan|clean]
```
- gcc flags: `-std=c17 -Wall -Wextra -Werror -Wpedantic -Wshadow -Wstrict-prototypes -Wformat=2 -O2 -g`.
- The asan build adds `-fsanitize=address,undefined -fno-sanitize-recover=all`. LeakSanitizer was checked with a deliberate leak and works on this box.
- valgrind runs with `--leak-check=full --errors-for-leak-kinds=definite,indirect --error-exitcode=99`.

## Tool versions (from the run)
gcc 14.2.0 (Debian 14.2.0-19); Debian clang 19.1.7; GNU Make 4.4.1; valgrind-3.24.0; libgmp-dev 2:6.3.0+dfsg-3.
There is no ctest target; testing is make + run.sh only.

## Measured results (final run)
- Top level: **40 PASS, 0 FAIL, 0 UNAVAILABLE**; exit 0.
- Unit suite (gcc): `# SUMMARY pass=31 fail=0 unavailable=0`. The same 31/31 pass under clang and under ASan+UBSan.
- valgrind memcheck: `All heap blocks were freed -- no leaks are possible`, `ERROR SUMMARY: 0 errors from 0 contexts`.
- Extra manual check, not in run.sh and not committed (run before the ABI switch): changing `<` to `<=` in the energy check, or `>=` to `>` in the budget
  check, made several tests FAIL. The suite catches both faults.

## UNAVAILABLE
- Nothing in the run.
- No Agda proofs: this track does not own agda/, so it supplies obligations only.

## Open issues
1. **Extra reason tokens.** CONTRACTS.md v1 names `ok, stale_seq, bad_prev, energy_not_decreasing, infeasible`, and both CONTRACTS.md and the ledger header
   allow further tokens. This engine also emits `epoch_exhausted` (from the owner spec), `malformed`, `wrong_kind`, `bad_payload` and `bad_epoch`.
   Hilbert needs to ratify these.
2. **Track-defined formats.** The kind-specific proposal fields (`op`, `assign`, `epoch`) and the payload and model record formats
   (`LRD-HAM-PAYLOAD-v1`, `LRD-HAM-MODEL-v1`) are defined by this track. payload_sha256 is plain SHA-256 of the payload record bytes, without
   the commit-domain prefix, because CONTRACTS.md does not say which applies.
3. **Check order.** For steps, `epoch_exhausted` is checked before `infeasible` and the energy check (the budget gate comes first).
   This is documented in OBLIGATIONS.md §1.6 and needs the owner's confirmation.
4. **SAT cost.** SAT is exhaustive backtracking, exponential in the worst case, with a node limit (default 10^7). Large models get
   `search_limit`, never a guessed answer.
5. **Stray log.** `tests/hamiltonian/logs/20261019T223711-0700.log` is untracked and was not created by this track's agent. Another process ran run.sh
   on the pre-rebase commit d694bc4. It was left in place and not committed.
6. Waiting on the HCALC Alloy review.

## Verbatim output of `tests/hamiltonian/run.sh` (final run)
```
# hamiltonian run.sh  log=/workspace/jwst-lrd-t008/tests/hamiltonian/logs/20261019T223948-0700.log
# date: 2026-10-19 22:39:48 PDT
# git: t008-hamiltonian 36db32a1a56ddf67b894a0cfda3895d50bac6bd6
# gcc: gcc (Debian 14.2.0-19) 14.2.0
# clang: Debian clang version 19.1.7 (3+b1)
# make: GNU Make 4.4.1
# valgrind: valgrind-3.24.0
# gmp: libgmp-dev 2:6.3.0+dfsg-3
# abi header: ledger/abi/lrd_state.h sha256=563d0ea4bc82442f302be397721e26697916efccff8d4f194d190d3b4f515920 last-commit=627fda7
PASS ledger_abi_header
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
PASS abi_adapter_ledger_header
PASS reason_tokens_abi_conformant
# SUMMARY pass=31 fail=0 unavailable=0
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
#   PASS abi_adapter_ledger_header
#   PASS reason_tokens_abi_conformant
#   # SUMMARY pass=31 fail=0 unavailable=0
PASS clang_suite
# clang_suite: 31 tests passed, 0 failed, exit 0
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
#   PASS abi_adapter_ledger_header
#   PASS reason_tokens_abi_conformant
#   # SUMMARY pass=31 fail=0 unavailable=0
PASS asan_ubsan_suite
# asan_ubsan_suite: 31 tests passed, 0 failed, exit 0
#   ==1426755== All heap blocks were freed -- no leaks are possible
#   ==1426755== ERROR SUMMARY: 0 errors from 0 contexts (suppressed: 0 from 0)
PASS valgrind_memcheck
# runner: fails=0
```
