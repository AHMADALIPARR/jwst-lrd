<!-- SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque -->
<!-- Dual-licensed (intentionally): AGPL-3.0-only plus the SnapKitty Opaque License. -->
# capability/ STATUS: TASK 010, cryptographic linear addressing and proof-gated transitions

Branch `t010-capability` (worktree `/workspace/jwst-lrd-capability`), based on main `6b9cef6`.
The code is Rust with no external crates. SHA-256, HMAC-SHA256, bigint, Miller-Rabin, hash-to-prime
and the RSA accumulator are all vendored. A small C shim compiles the ledger track's
`lrd_state.h` unmodified.

## Result of the last run (re-run 2026-10-26 on branch repairs-oct26; counts are the PASS/FAIL/UNAVAILABLE lines printed by the script)
`bash tests/capability/run.sh`: **67 PASS, 0 FAIL, 0 UNAVAILABLE**, exit 0, wall time 47 s.
(Before the ABI-drift fix the same run gave 66 PASS, 0 FAIL, 1 UNAVAILABLE: the drift check wanted a
branch `t004-ledger` that is not in this repository.)
- `cargo test --release --offline`: `test result: ok. 19 passed; 0 failed` (unit) and
  `test result: ok. 14 passed; 0 failed` (multi-process adversarial suite)
- openssl cross-checks: 11 PASS. These compare modexp against `openssl pkeyutl` raw RSA with the
  public e=65537 and with the 2048-bit private exponent, and check five hash-to-prime outputs with
  `openssl prime`.
- bash end-to-end with two real processes: 12 PASS
- mutation check: 8 of 8 disabled checks were detected by the suite
- ABI drift of `abi/vendor/lrd_state.h` vs the in-repo `ledger/abi/lrd_state.h` (t004-ledger branch if present): PASS. obligations.json parses (jq): PASS

## Versions (evidence/versions.log)
```
date: Mon Oct 19 22:39:49 PDT 2026
cargo 1.85.1 (d73d2caf9 2024-12-31)
rustc 1.85.1 (4eb161250 2025-03-15) (built from a source tarball)
cc (Debian 14.2.0-19) 14.2.0
OpenSSL 3.5.7 9 Jun 2026 (Library: OpenSSL 3.5.7 9 Jun 2026)
Linux 6.12.94+ x86_64
```

## Commands
```
nice -n 19 bash tests/capability/run.sh          # everything; PASS/FAIL/UNAVAILABLE lines
cd capability && make build | make unit | make e2e
LRDCAP_SKIP_MUTATION=1 bash tests/capability/run.sh   # skip the ~40 s mutation check (reported UNAVAILABLE)
```
Binaries: `target/release/lrd-authority` (init / serve / admin / selftest-*) and
`target/release/lrd-worker` (sync / transition [--attack MODE] / history / raw).

## Files
- `src/sha256.rs`, `src/hmac.rs`: vendored FIPS 180-4 and RFC 2104, tested against the NIST and RFC 4231 vectors (cases 1-7; case 5 truncated). The vectors were also confirmed with `openssl dgst` while writing.
- `src/bigint.rs`, `src/prime.rs`: u64-limb bigint with Knuth D division and modexp; Miller-Rabin and hash-to-prime.
- `src/accumulator.rs`: RSA accumulator (add, witness, `verify_witness`, which is the contract for Agda).
- `src/rec.rs`: LRD-REC-v1 serialization and the LRD-COMMIT-v1 commitment. `src/abi.rs` + `abi/lrd_abi_shim.c` + `build.rs`: FFI to `lrd_state.h`.
- `src/cap.rs`: MAC'd capabilities. `src/authority.rs`: the authority (verifier) logic and atomic persistence. `src/proto.rs`: socket client.
- `src/bin/lrd-authority.rs`, `src/bin/lrd-worker.rs`: the two separate processes.
- `tests/adversarial.rs`: the multi-process adversarial suite. `scripts/integration.sh`: bash end-to-end. `scripts/openssl_crosscheck.sh`, `scripts/mutation_check.sh`, `scripts/abi_drift_check.sh`, `scripts/gen_modulus.sh`.
- `SECURITY.md` (threat model, assumptions, out of scope), `PROTOCOL.md`, `obligations.json`, `evidence/`.
- `../tests/capability/run.sh`: the track test runner.
- `fixtures/SYNTHETIC_unit_modulus_1024.hex`: a 1024-bit modulus from `openssl genrsa`, key deleted, used for unit tests only. The integration tests generate a fresh 2048-bit modulus on every run.

## ABI (LRD-STATE-v1 / LRD-REC-v1)
- `ledger/abi/lrd_state.h` is owned by the ledger track. It is vendored read-only at
  `abi/vendor/lrd_state.h` from `t004-ledger`, last changed in commit
  `627fda784a3c73451c5e5d68b13a51ff04c106f3`, blob `79c15be3`, sha256 `563d0ea4...5920`. The full
  provenance is in `abi/vendor/SOURCE`.
- `scripts/abi_drift_check.sh` FAILs if the vendored copy is edited or differs from `t004-ledger`.
  It reports UNAVAILABLE if that branch is absent.
- The header is compiled unmodified, under `-std=c17 -Wall -Wextra -Werror`. The Rust `#[repr(C)]`
  mirror's sizes and offsets for lrd_state_t, lrd_decision_t, lrd_proposal_t and lrd_field_t are
  checked against `sizeof`/`offsetof` from the C compiler. Constants are checked too. The authority
  uses the header's `lrd_kind_from_token`, `lrd_is_hex256`, `lrd_kind_token` and
  `lrd_decision_reject` through FFI.
- Proposals have `kind=capability prev_commit seq payload_sha256` plus `cap_*`, `prev_witness` and
  `claimed_commit`. Decisions have `decision reason`, with `new_commit` on ACCEPT only.
- The state record is `{cap_nonce, commit, kind, payload_sha256, seq}`. Its commitment is
  `SHA-256("LRD-COMMIT-v1\0" || serialization)`. `cap_nonce` is this track's kind-specific field,
  binding the authority nonce into the commitment.
- During the work the header changed on t004-ledger (the C++ static_assert fix, 35c6a35 to
  627fda7). It was re-vendored, and the drift check is what would have caught it.

## Acceptance test (required). Excerpt from evidence/cargo_test.log
In the test `acceptance_corrupted_worker_memory_is_refused_by_independent_authority`, the worker
process overwrote its in-memory state struct and its state file with a valid-format forged
commitment. It then submitted using a fresh, valid transition capability. The separately running
authority refused it, and its counter and head were unchanged:
```
[worker] ATTACK corrupt-memory: in-memory head_commit e373920973b5af78db6b1bc595a736a13e7010c9fb0a38954dab812d032f0e5a -> d6c63271c5a6f237f8268499046b74547555dfc9ed68349fc6fb1166f64a41fd
[worker] ATTACK corrupt-memory: state file /tmp/lrdcap-accept-1426917/worker/worker.state rewritten with forged commit
[worker] authority REJECTED: reason=bad_prev
[authority] SUBMIT seq=1 prev=d5157305d33a95fd01bd9179a4340c6bea31318412060c36a543e26e57493dbd -> ACCEPT reason=ok new_commit=e373920973b5af78db6b1bc595a736a13e7010c9fb0a38954dab812d032f0e5a counter=1
[authority] SUBMIT seq=2 prev=d6c63271c5a6f237f8268499046b74547555dfc9ed68349fc6fb1166f64a41fd -> REJECT reason=bad_prev authority_head=e373920973b5af78db6b1bc595a736a13e7010c9fb0a38954dab812d032f0e5a
[authority] SUBMIT seq=2 prev=e373920973b5af78db6b1bc595a736a13e7010c9fb0a38954dab812d032f0e5a -> REJECT reason=bad_commit claimed=372128d82f52e452fe3a003401ccebf85b92ca2f8581a8691ee8ae8bd2a3f4d3
[authority] VERIFY -> REJECT reason=bad_witness element=d6c63271c5a6f237f8268499046b74547555dfc9ed68349fc6fb1166f64a41fd
[authority] SUBMIT seq=2 prev=e373920973b5af78db6b1bc595a736a13e7010c9fb0a38954dab812d032f0e5a -> ACCEPT reason=ok new_commit=29166b30402a11b6bb8214b16921881a525e409e77d21033504994dc596b86c4 counter=2
```
The same scenario run through bash with real processes (evidence/e2e/authority.log and acceptance_decision.rec):
```
[authority] SUBMIT seq=3 prev=5903ee5440fae37bc7a7292047b74e6edb5ba0fe2a1168c0887cc7da268820fa -> REJECT reason=bad_prev authority_head=1d06458ad067f663da0a40782e2940fefef928ef7e45ad57c1023af3a651e6d2
decision=REJECT head_seq=2 reason=bad_prev
```
Positive controls: honest transitions are accepted before and after the attacks
(`positive_control_honest_transitions_accepted`, `e2e_positive_control_after_attacks`).

## Adversarial coverage (privileged worker)
(a) corrupted memory/state: bad_prev, bad_commit, bad_witness. (b) replay: replay.
(c) rollback: stale_seq / bad_prev. (d) forged MAC: bad_mac. (e) historical-read used to
transition: bad_scope. (f) consumed capability reused after restart: replay. (g) bad witness:
bad_witness. Also covered: expiry, revocation, slot binding (cap_binding), issuance blocked on the
worker socket, the on-disk counter never decreasing, and no silent reset when the state file is
missing.

Out of scope, demonstrated on purpose. These two tests **pass because the forgery succeeds**,
which is the stated limit: `out_of_scope_key_read_allows_mac_forgery` and
`out_of_scope_store_write_allows_rollback_and_replay`. No protection is claimed against an
attacker who controls the verifier's key or counter store.

## Mutation check (evidence/mutation_check.log)
```
PASS mutation_no_bad_prev_check detected (3 failing tests: acceptance_corrupted_worker_memory_is_refused_by_independent_authority rollback_rejected state_file_tampered_externally_is_refused )
PASS mutation_no_consumption detected (1 failing tests: consumed_capability_rejected_after_authority_restart )
PASS mutation_mac_always_ok detected (1 failing tests: forged_mac_rejected )
PASS mutation_no_witness_check detected (2 failing tests: bad_accumulator_witness_rejected consumed_capability_rejected_after_authority_restart )
PASS mutation_no_stale_seq_check detected (1 failing tests: rollback_rejected )
PASS mutation_no_scope_check detected (1 failing tests: historical_read_cannot_transition )
PASS mutation_no_expiry_check detected (1 failing tests: expiry_and_revocation )
PASS mutation_no_cap_binding detected (1 failing tests: capability_bound_to_exactly_one_slot )
```
Defense in depth means the acceptance attack is also caught when the bad_prev check is removed
(cap_binding and bad_witness still fire). The test fails in that case only because it asserts the
exact reason token.

## Assumptions (full text in SECURITY.md; machine-readable in obligations.json)
AuthorityKeyUncompromised, CounterStoreUncompromised, OSProcessIsolation, MACUnforgeable
(HMAC-SHA256), CollisionResistant (SHA-256), AccumulatorWitnessSound (strong RSA + hash-to-prime),
TrustedSetupRSAModulus, CSPRNGFresh (/dev/urandom), and an honest authority wall clock for expiry.
**A separate process on the same OS is not a secure trust anchor.** There is no TPM, TEE or HSM.

## Agda integration
`obligations.json` names were aligned (read-only) with `Kernel.Assumptions.{Crypto,Runtime}` in the
`t011-agda-kernel` worktree, which had uncommitted files when observed. Those are
CapabilityConsumedOnce, MonotonicCounter, NoRollback, NoReplay, AccumulatorWitnessSound,
MACUnforgeable, AuthorityKeyUncompromised and CollisionResistant. This track adds
CapabilitySlotBinding, HistoricalReadNoTransition, ProofGatedTransition, RejectNoNewState,
AuthorityComputesCommitment, CounterStoreUncompromised, OSProcessIsolation,
TrustedSetupRSAModulus and CSPRNGFresh. Nothing was written to agda/. `agda/OBLIGATIONS.md` is
owned by the Agda track, and entries go through Hilbert. "runtime_checked" means enforced and
tested, not proved.

## Gaps / blockers
- There is no hardware trust anchor. In the tests the worker and authority run as the same uid, so
  directory separation is a convention and is not OS-enforced.
- The accumulator is local to this track. `ledger/` on main had none. `t005-rsaacc` has an
  uncommitted C accumulator in `ledger/rsaacc/` (`jlrd_acc_verify.h`). Once it is canonical, this
  one should be swapped in behind the `verify_witness` contract.
- **Coordination issue for Hilbert:** `t004-ledger` (216833f) also contains a "TASK 010"
  capability implementation in C (`ledger/include/lrd_cap.h`, `cap_verifier.c`, `cap_worker.c`).
  It uses Ed25519 signatures, a different capability field set, and a state record without a nonce
  field. These two TASK 010 designs are not reconciled.
- Witness generation is O(k) modexps per request, with no batching or witness caching. Replies are
  not signed.
- If an ACCEPT persist fails, the in-memory chain is rolled back but the capability stays
  consumed. A crash between persists is safe (the old consistent file remains) but was not
  fault-injected.
