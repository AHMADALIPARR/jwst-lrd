<!--
Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
-->
# ledger/ STATUS (branch blocker-a-ledger)

Scope: TASK 004 (Gödel prime ledger, LRD-REC-v1), blocker (a) repair, and `ledger/abi/lrd_state.h` (LRD-STATE-v1, unchanged here).
Not here: TASK 005 is in `ledger/rsaacc/` (not touched), TASK 010 is in `capability/` (not touched).

Tested code commit: 3a29c62 (this STATUS file is the only later change). Output of `make -C ledger clean; tests/ledger/run.sh; echo exit=$?`, verbatim (37 PASS, 0 FAIL, 0 UNAVAILABLE):

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
PASS godel_primes_match_checked_in_table
PASS godel_prime_cap_documented_error
PASS godel_record_roundtrip_gt2bytes
PASS godel_max_len_boundary
PASS godel_genesis_seq0_convention
PASS godel_parse_rejects_nonpositive_l_and_exponents
INFO godel_pos_a fast_vs_reference_decoder stream_ms=614.072 reference_per_prime_ms=1338.195 identical=yes
INFO godel_pos_a record=REAL:/workspace/jwst-lrd-blocker-a/fixtures/ingest/09bcd9077647ebf4fdaa766807de832bf6a94b92e3ed73fdb8a3c0281ae50c31/source.kv(sha256=7fcc149262783ace355a9ca39e716235e81e99b6654c5737749f76606c6e3fcd) record_bytes=1217 stream_bytes=1210 largest_prime=9811 log2_L_bits=1103517 max_bits=67108864 append_ms=20.524 decode_ms=619.006
PASS godel_pos_realsize_record_append_decode_byte_exact
INFO godel_pos_b records=REAL:/workspace/jwst-lrd-blocker-a/fixtures/ingest/09bcd9077647ebf4fdaa766807de832bf6a94b92e3ed73fdb8a3c0281ae50c31/source.kv(sha256=7fcc149262783ace355a9ca39e716235e81e99b6654c5737749f76606c6e3fcd)|SYNTHETIC|SYNTHETIC record_bytes=1217,280,280 stream_bytes=1756 largest_prime=15017 log2_L_bits=1749961 (L1=1103517 L2=1423129) append_total_ms=32.042 verify_sequence_ms=762.679
PASS godel_pos_three_records_prefix_and_sequence_verification
PASS godel_pos_reject_gap
PASS godel_pos_reject_extra_factor
PASS godel_pos_reject_zero_exponent_in_stream
PASS godel_pos_reject_exponent_257
PASS godel_pos_reject_truncated_framing
PASS godel_pos_reject_noncanonical_record
PASS godel_pos_reject_nonpositive_and_first_prime_cases
INFO godel_pos_mode L=210 decodes_in_both_modes=yes positional_items=1 bij256_records_items=4 (mode must come from the API/export, not from L)
PASS godel_pos_mode_explicit_and_recorded
PASS godel_pos_too_big_refused_ledger_unchanged
INFO godel_pos_capacity default_max_bits=67108864 worst_case_stream_bytes_fitting=16518 (bound 256*sum log2 p_k; typical text is far smaller per byte)
PASS env_size_0
PASS env_size_1
PASS env_size_2
PASS env_size_3
PASS env_size_255
PASS env_size_256
PASS env_size_1024
PASS env_size_65535
PASS env_oversized_refused
PASS env_legacy_detect
PASS rec_v1_commitment_matches_openssl_cli
exit=0
```

What changed: a positional (record-size-independent exponent) mode that fits real LRD-REC-v1 records, `LRD_GODEL_MAX_LEN`, a prime source with a documented cap and a checked-in table, strict decoding, and the seq 0 genesis convention. See `README.md` and `SPEC.md`. bij256 remains tiny-record only.

Known limits (all also in README.md):
- L grows as O(|S| log |S|) bits in positional mode (exponent up to 256 per stream byte), so the default 2^26-bit cap bounds the stream at about 16,518 bytes worst case; prime cap is 65536 (E_PRIMECAP).
- A bare integer L carries no mode tag and can decode in both modes (example L = 210). The mode must come from the API or export.
- `lrd_godel_append_envelope` is a marker-only hack and does not encode the payload.
- Only record 1 in `godel_pos_*` tests is a real manifest (in-repo `source.kv`, 1217 B); records 2 and 3 are SYNTHETIC.
- Alloy: the 3 new G2 commands were run individually and gave the expected result. The full `check.sh` sweep was not re-run to completion on this branch.

Review: not reviewed. Completed implementation, not a verified integration; requires owner review.
