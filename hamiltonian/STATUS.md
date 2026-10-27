<!-- Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
     Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License (see LICENSE, SNAPKITTY_OPAQUE_LICENSE.md).
     SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque -->
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
1. **Extra reason tokens (RESOLVED 2026-10-19).** `malformed`, `wrong_kind`, `bad_payload`, `bad_epoch` and `epoch_exhausted` were ratified by the coordinator and are being added to CONTRACTS.md.
2. **Track-defined formats (RESOLVED 2026-10-19).** The proposal fields `op`/`assign`/`epoch`, `LRD-HAM-PAYLOAD-v1`, `LRD-HAM-MODEL-v1`, and `payload_sha256` as plain SHA-256 of the payload bytes (no commit-domain prefix) were accepted as track-defined.
3. **Check order (RESOLVED 2026-10-19).** epoch_exhausted, then infeasible, then the energy check was accepted and is now marked normative in OBLIGATIONS.md §1.6.
4. **SAT cost.** SAT is exhaustive backtracking, exponential in the worst case, with a node limit (default 10^7). Large models get
   `search_limit`, never a guessed answer.
5. **Stray log.** `tests/hamiltonian/logs/20261019T223711-0700.log` is untracked and was not created by this track's agent. Another process ran run.sh
   on the pre-rebase commit d694bc4. It was left in place and not committed. Per the coordinator it stays untracked and is never committed.
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

## Blocker (b): `epoch_exhausted` before `infeasible` is now mutation-pinned (branch `blocker-b-hamiltonian`)
Scope: only research/BLOCKERS.md (b). Based on origin/main `db089a3`. Measured 2026-10-27 (America/Los_Angeles), gcc 14.2.0, clang 19.1.7.
This is a completed implementation, not a verified integration; requires owner review. No PR was opened and nothing was merged.

- **Baseline correction.** BLOCKERS.md says the surviving mutant gave `pass=30 fail=0`. On `db089a3` the unit suite has 31 tests;
  the survival was re-measured here with the unmodified tests: `# SUMMARY pass=31 fail=0 unavailable=0` (full `tests/hamiltonian/run.sh`
  against the mutant copy: `# runner: fails=0`). So the survival claim holds, with baseline 31, not 30.
- **Added.**
  - `t_exhausted_beats_infeasible` in `tests/hamiltonian/test_ham.c` (prints `PASS exhausted_beats_infeasible`). Model A, budget 1:
    (1) exhausted state with energy 6 (energy check would pass for candidate (2,2), H=11/2) and exhausted state with energy 0 (energy check would fail):
    reason exactly `epoch_exhausted`, `decision=REJECT`, no `violated`/`violated_count`, `ham_states_constructed()` unchanged, `*next` byte-identical;
    (2) the same candidate in a non-exhausted state: `infeasible`, `violated=no_22`, `violated_count >= 1`.
    No existing test was edited (diff is additions only); the `epoch_advance` exhausted coverage (`epoch_transition_explicit`, `reject_never_constructs_state`) is unchanged.
  - `hamiltonian/mutants/swap_8_9.patch` (rows 8 and 9 exchanged in `ham_engine.c`) and `hamiltonian/mutants/run.sh` (POSIX sh, tested under bash and dash).
    It copies sources plus the unit suite to a temp dir, first checks the unmutated copy passes, applies the patch to the copy only, builds with the module
    Makefile and runs the suite. Exit 0 KILLED, 1 SURVIVED, 2 error. The tree is never modified.
  - `tests/hamiltonian/run.sh` gained one block (`mutant_swap_8_9_killed`) before the final summary; nothing else in it changed.
- **Mutant BEFORE the new test** (commit `df347aa`, tests unmodified), verbatim, same output under `bash` and `dash`:
  ```
  # unmutated: pass=31 fail=0 unavailable=0 exit=0
  # mutant swap_8_9: pass=31 fail=0 unavailable=0 exit=0
  SURVIVED swap_8_9
  ```
  (runner exit status 1)
- **Mutant AFTER the new test** (commit `a7d516f`), verbatim, same output under `bash` and `dash`:
  ```
  # unmutated: pass=32 fail=0 unavailable=0 exit=0
  #   FAIL exhausted_beats_infeasible field reason = infeasible, want epoch_exhausted
  # mutant swap_8_9: pass=31 fail=1 unavailable=0 exit=1
  KILLED swap_8_9
  ```
  (runner exit status 0). The new test is the only one that fails against the mutant.
- **Real source, `tests/hamiltonian/run.sh`** at `a7d516f`: unit suite `# SUMMARY pass=32 fail=0 unavailable=0` (gcc), identical under clang and ASan+UBSan;
  valgrind `ERROR SUMMARY: 0 errors from 0 contexts`; `PASS mutant_swap_8_9_killed`; `# runner: fails=0`. Runner top level: 42 PASS, 0 FAIL, 0 UNAVAILABLE. Unit tests 31 -> 32 (+1).
  The BLOCKERS.md target ">= 32" is met from the real baseline of 31, but the rise is +1, not the +2 that "30 -> >= 32" implied.
- **Reproduce.** `tests/hamiltonian/run.sh`; `hamiltonian/mutants/run.sh` (also `sh hamiltonian/mutants/run.sh`).
  To see BEFORE, check out `df347aa`; for the new test alone against the mutant, read the `FAIL` line above.
- **Not done / open.**
  - `tests/run_all.sh` did **not** complete: killed by a 600 s timeout while in the `curry-growth` suite, which also printed
    `UNAVAILABLE real_input ... AIR_REAL_SCALE ... is not set`. The `hamiltonian` suite is after it in order and was not reached through run_all.
    No run_all totals are claimed; no FAIL line appeared in the partial output. Running it also rewrote tracked `capability/evidence/*` files, which were restored with `git checkout`.
  - Only the 8/9 order is mutation-tested. Other row orders (e.g. 9/10) and the `epoch_advance` row 7/8 order have no mutant here.
  - Reviewer sign-off (HCALC Alloy): not yet.
