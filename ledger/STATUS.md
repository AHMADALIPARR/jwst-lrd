<!--
Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
Dual-licensed: AGPL-3.0-or-later plus SnapKitty Opaque License.
-->
# ledger/ STATUS (branch t004-ledger)

Scope: TASK 004 (Gödel prime ledger, LRD-REC-v1) and `ledger/abi/lrd_state.h` (LRD-STATE-v1).
Not here: TASK 005 is in `ledger/rsaacc/` on t005-rsaacc, and TASK 010 is in `capability/` on t010-capability.
An earlier 010 implementation (a0873f6) was reverted on this branch by ca5a26e.

Header commits: 35c6a35 (LRD-STATE-v1) and 627fda7 (C++17 include fix).

Tested code commit: ca5a26e. The output of `make -C ledger clean; tests/ledger/run.sh; echo exit=$?` follows verbatim:

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
exit=0
```

Known limit: L grows exponentially with record length. Only records of 2 bytes or less (and the empty record) fit under the default `max_bits` cap of 2^23 bits, and larger appends are refused with `too_big`. The byte-to-exponent mapping is exact at any length. Factorization gives exact recoverability, not physical immutability (see README).

Review: HCALC Alloy has not reviewed this yet.
