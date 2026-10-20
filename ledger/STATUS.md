<!--
Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
Dual-licensed: AGPL-3.0-or-later plus SnapKitty Opaque License.
SPDX-License-Identifier: AGPL-3.0-or-later AND LicenseRef-SnapKitty-Opaque
-->
# ledger/ STATUS

* Branch: `t004-ledger` (worktree `/workspace/jwst-lrd-t004`, based on main `6b9cef6`)
* Code commit tested: `a0873f69b93d367d6a02ddd81f51dd1f372323ed` — this STATUS.md is committed on top of it, so the
  branch head is the child of this SHA (the head SHA is reported to Hilbert separately).
* Scope: TASK 004 (Gödel prime ledger), TASK 010 (capability addressing), `ledger/abi/lrd_state.h`
  (LRD-STATE-v1 ABI). **TASK 005 (RSA accumulator) is not on this branch**: it lives in
  `ledger/rsaacc/` on branch `t005-rsaacc` and is not run by `tests/ledger/run.sh`.
* Toolchain: cc (Debian 14.2.0-19) 14.2.0; GMP 2:6.3.0+dfsg-3; OpenSSL 3.5.7 9 Jun 2026 (Library: OpenSSL 3.5.7 9 Jun 2026)
* Run on: 2026-10-19 22:40 PDT (Linux x86_64)

## What built

`make -C ledger` (`-std=c17 -Wall -Wextra -O2`): `out/test_godel`, `out/lrd-rec`,
`out/lrd-capverifier`, `out/lrd-capworker` — no compiler warnings (`grep -ci warning ledger/out/run.log` → 0).
Header check: `cc -std=c17 -Wall -Wextra -pedantic -fsyntax-only ledger/abi/lrd_state.h` → clean.

## What ran

Command (from a clean build, `make -C ledger clean` first):

```
cd /workspace/jwst-lrd-t004 && tests/ledger/run.sh; echo "exit=$?"
```

Verbatim output:

```
PASS godel_primes_match_sieve_first_1000
PASS godel_bij256_shortlex_bijection_len_le_2
PASS godel_bij256_roundtrip_len_3_to_299
PASS rec_v1_canonical_serialize_and_strict_parse
PASS godel_append_multiplicative_and_full_decode
PASS godel_history_prefix_and_sequence_verification
PASS godel_reject_gaps_extra_factors_nonpositive
PASS godel_records_mode_noncanonical_and_size_limit
PASS godel_record_exponent_roundtrip_full_record
PASS rec_v1_commitment_matches_openssl_cli
PASS cap_verifier_private_file_modes
PASS cap_worker_binary_has_no_signing_code
PASS cap_valid_chain_accepted
PASS cap_independent_witness_verifier_accepts_valid
PASS cap_check_current_accepts_head
PASS cap_forged_signature_rejected
PASS cap_altered_commitment_rejected
PASS cap_foreign_authority_rejected
PASS cap_replayed_proposal_rejected
PASS cap_stale_seq_rejected
PASS cap_rollback_bad_prev_rejected
PASS cap_seq_gap_rejected
PASS cap_stale_capability_not_current
PASS cap_historical_reads
PASS cap_noncanonical_proposal_rejected
PASS cap_wrong_kind_rejected
PASS cap_reject_decision_has_no_new_commit
PASS cap_retired_rejected
PASS cap_adversarial_worker_state_tamper_and_replay
PASS cap_adversarial_verifier_log_tamper_detected
SUMMARY ledger status=OK pass=30 fail=0 unavailable=0 (TASK 005 not run here: ledger/rsaacc/ on branch t005-rsaacc)
exit=0
```

Detail lines from `ledger/out/run.log` (INFO lines, verbatim):

```
INFO godel_append_decode: n=6 bits(L)=295182
INFO godel_records: exponent for body "1:a1:b\n" has 54 bits; cap max_bits=8388608; append -> too_big
INFO godel_record_exponent: 213-byte body -> exponent of 1702 bits (L would need ~2^1701 bits)
INFO rec_v1_commitment_matches_openssl_cli ours=4765f3ee5158a83996618e8de8d861980f4a28cc35dfdef5b1b74322db5faf33 openssl=4765f3ee5158a83996618e8de8d861980f4a28cc35dfdef5b1b74322db5faf33
INFO cap_verifier_private_file_modes dir=700 key=600 log=600 pub=644 owner=box worker_uid=box
INFO cap_worker_binary_has_no_signing_code worker_signing_imports='' verifier_signing_imports=6
INFO cap_valid_chain_accepted verifier_head='3 449381c3c652dc11123c3b7156ae4c0dbba85e29a7867fd1c99ac9c0800acd98' worker_head='3 449381c3c652dc11123c3b7156ae4c0dbba85e29a7867fd1c99ac9c0800acd98'
INFO cap_adversarial_worker_state_tamper_and_replay verifier head before='5 659cdd27cf687eea624389433bc27e98ee57880a1a7d9b192c622cb0d3b63959' after='5 659cdd27cf687eea624389433bc27e98ee57880a1a7d9b192c622cb0d3b63959' log_sha256 before=cd411101dc0c429a2467b84045bcd9275444188f2bd46fbcf613bac5939bc4bb after=cd411101dc0c429a2467b84045bcd9275444188f2bd46fbcf613bac5939bc4bb
INFO limitation: log truncated to 2 valid entries -> verifier exit=0 head='2 008c862336c89e8c61e34a3e7c24ca35f500ea82554c50b719a86377a0414461' (truncation to a valid prefix is NOT detectable without an external monotonic anchor)
INFO tests/ledger/run.sh status=OK
```

FAIL items: none. UNAVAILABLE items: none on this box (run.sh reports every test UNAVAILABLE if
no C compiler, GMP or OpenSSL/Ed25519 is present; checked with `CC=no-such-cc`).

## Known limitations / assumptions

1. **Gödel ledger size**: `L` grows exponentially in item length (`e ≈ 256^len`). Only bodies ≤ 2 bytes
   and the empty LRD-REC-v1 record fit under the default 2^23-bit cap; real records are refused with
   `too_big` (measured: the smallest one-field record has a 54-bit exponent). The exponent mapping is
   exact for any length. It is a reference/verification construction, not a storage format.
2. **Factorization = exact recoverability, NOT physical immutability.**
3. Record mode strips the constant 11-byte magic `LRD-REC-v1\n` before encoding (documented choice).
4. Gap vs extra-factor classification uses a 64-prime lookahead; both are rejected either way.
5. **Same Unix user**: verifier and worker run as `box`. Directory 0700 / files 0600 / O_APPEND do not
   stop a same-uid process; tamper *detection* comes from per-entry Ed25519 log signatures.
6. Truncating the verifier log to a valid prefix is **not detected** (observed: exit 0, head seq 2); needs an
   external monotonic anchor. Verifier compromise is out of scope.
7. The prime table is a process-global cache (not thread-safe).
8. Interpretations of CONTRACTS.md: C types for LRD-STATE-v1 chosen in the header (uint64 seq, char[65]
   hex, open reason-token set); LRD-REC-v1 empty keys are rejected (spec silent); integer/rational value
   syntax is not validated generically (no per-field schema in the record format); run.sh prints one
   extra `SUMMARY ...` line after the per-test lines.
9. Not yet reviewed by HCALC Alloy (track not "done" until it signs off).
