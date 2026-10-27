#!/bin/sh
# Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
# Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
# SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
#
# Ledger track tests (TASK 004 Goedel ledger incl. positional mode, env framing). Blocker (a) repair.
# RSA accumulator (ledger/rsaacc/) and capability addressing are NOT run here.
# Convention (research/CONTRACTS.md): one line per test,
#   PASS <name> | FAIL <name> <why> | UNAVAILABLE <name> <reason>
# Exit status is nonzero only if some test FAILed. Build output and INFO lines go to
# ledger/out/run.log.
set -u
HERE=$(cd "$(dirname "$0")" && pwd)
ROOT=$(cd "$HERE/../.." && pwd)
LEDGER="$ROOT/ledger"
OUT="$LEDGER/out"
mkdir -p "$OUT"
LOG="$OUT/run.log"
: > "$LOG"
FAILED=0

unavailable_all() {
  for t in $TESTS_ALL; do echo "UNAVAILABLE $t $1"; done
  exit 0
}

TESTS_004="godel_primes_match_sieve_first_1000 godel_bij256_shortlex_bijection_len_le_2 godel_bij256_roundtrip_len_3_to_299 rec_v1_canonical_serialize_and_strict_parse godel_append_multiplicative_and_full_decode godel_history_prefix_and_sequence_verification godel_reject_gaps_extra_factors_nonpositive godel_records_mode_noncanonical_and_size_limit godel_record_exponent_roundtrip_full_record rec_v1_commitment_matches_openssl_cli"
TESTS_BLOCKER_A="godel_primes_match_checked_in_table godel_prime_cap_documented_error godel_record_roundtrip_gt2bytes godel_max_len_boundary godel_genesis_seq0_convention godel_parse_rejects_nonpositive_l_and_exponents"
TESTS_POS="godel_pos_realsize_record_append_decode_byte_exact godel_pos_three_records_prefix_and_sequence_verification godel_pos_reject_gap godel_pos_reject_extra_factor godel_pos_reject_zero_exponent_in_stream godel_pos_reject_exponent_257 godel_pos_reject_truncated_framing godel_pos_reject_noncanonical_record godel_pos_reject_nonpositive_and_first_prime_cases godel_pos_mode_explicit_and_recorded godel_pos_too_big_refused_ledger_unchanged"
TESTS_ENV="env_size_0 env_size_1 env_size_2 env_size_3 env_size_255 env_size_256 env_size_1024 env_size_65535 env_oversized_refused env_legacy_detect"
TESTS_ALL="$TESTS_004 $TESTS_BLOCKER_A $TESTS_POS $TESTS_ENV"

CC=${CC:-cc}
command -v "$CC" >/dev/null 2>&1 || unavailable_all "no C compiler ($CC)"
command -v make >/dev/null 2>&1 || unavailable_all "make not installed"
printf '#include <gmp.h>\nint main(void){mpz_t x;mpz_init(x);mpz_clear(x);return 0;}\n' > "$OUT/probe_gmp.c"
"$CC" -std=c17 "$OUT/probe_gmp.c" -o "$OUT/probe_gmp" -lgmp >>"$LOG" 2>&1 \
  || unavailable_all "GMP (libgmp-dev) not available"
printf '#include <openssl/evp.h>\nint main(void){EVP_PKEY_CTX *c=EVP_PKEY_CTX_new_id(EVP_PKEY_ED25519,NULL);EVP_PKEY_CTX_free(c);return 0;}\n' > "$OUT/probe_ssl.c"
"$CC" -std=c17 "$OUT/probe_ssl.c" -o "$OUT/probe_ssl" -lcrypto >>"$LOG" 2>&1 \
  || unavailable_all "OpenSSL libcrypto (libssl-dev) with Ed25519 not available"

if ! make -C "$LEDGER" CC="$CC" >>"$LOG" 2>&1; then
  for t in $TESTS_ALL; do echo "FAIL $t build_failed_see_ledger/out/run.log"; done
  exit 1
fi

# ---- TASK 004 (C test binary prints its own PASS/FAIL lines)
"$OUT/test_godel" "$HERE" 2>>"$LOG" > "$OUT/test_godel.out"
rc=$?
cat "$OUT/test_godel.out"
[ $rc -eq 0 ] || FAILED=1
for t in godel_primes_match_sieve_first_1000 godel_bij256_shortlex_bijection_len_le_2 \
         godel_bij256_roundtrip_len_3_to_299 rec_v1_canonical_serialize_and_strict_parse \
         godel_append_multiplicative_and_full_decode godel_history_prefix_and_sequence_verification \
         godel_reject_gaps_extra_factors_nonpositive godel_records_mode_noncanonical_and_size_limit \
         godel_record_exponent_roundtrip_full_record $TESTS_BLOCKER_A; do
  grep -q "^\(PASS\|FAIL\) $t\( \|\$\)" "$OUT/test_godel.out" || { echo "FAIL $t did_not_report(rc=$rc)"; FAILED=1; }
done

# ---- positional mode (separate binary). Real manifest if present (read-only), else the test
# uses a clearly labelled SYNTHETIC record and prints INFO saying so (see ledger/out/run.log).
REAL_KV=${LRD_REAL_SOURCE_KV:-$ROOT/fixtures/ingest/09bcd9077647ebf4fdaa766807de832bf6a94b92e3ed73fdb8a3c0281ae50c31/source.kv}   # tracked in-repo fixture
[ -f "$REAL_KV" ] || REAL_KV=
"$OUT/test_godel_pos" ${REAL_KV:+"$REAL_KV"} 2>>"$LOG" > "$OUT/test_godel_pos.out"
rc=$?
cat "$OUT/test_godel_pos.out"
[ $rc -eq 0 ] || FAILED=1
for t in $TESTS_POS; do
  grep -q "^\(PASS\|FAIL\) $t\( \|\$\)" "$OUT/test_godel_pos.out" || { echo "FAIL $t did_not_report(rc=$rc)"; FAILED=1; }
done

# ---- env framing tests (test_env prints its own PASS/FAIL lines)
"$OUT/test_env" 2>>"$LOG" > "$OUT/test_env.out"
rc=$?
grep "^\(PASS\|FAIL\|UNAVAILABLE\) " "$OUT/test_env.out"
[ $rc -eq 0 ] || FAILED=1
for t in $TESTS_ENV; do
  grep -q "^\(PASS\|FAIL\) $t\( \|\$\)" "$OUT/test_env.out" || { echo "FAIL $t did_not_report(rc=$rc)"; FAILED=1; }
done

# ---- LRD-REC-v1 commitment cross-checked against the openssl command-line tool
t=rec_v1_commitment_matches_openssl_cli
if ! command -v openssl >/dev/null 2>&1; then
  echo "UNAVAILABLE $t openssl CLI not installed"
else
  "$OUT/lrd-rec" make kind=observation seq=7 payload_sha256=e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855 \
    "prev_commit=0000000000000000000000000000000000000000000000000000000000000000" z=1/3 > "$OUT/kat.rec"
  ours=$("$OUT/lrd-rec" commit "$OUT/kat.rec")
  theirs=$( { printf 'LRD-COMMIT-v1\000'; cat "$OUT/kat.rec"; } | openssl dgst -sha256 -r | cut -d' ' -f1)
  echo "INFO $t ours=$ours openssl=$theirs" >> "$LOG"
  if [ -n "$ours" ] && [ "$ours" = "$theirs" ]; then echo "PASS $t"; else echo "FAIL $t ours=$ours openssl=$theirs"; FAILED=1; fi
fi

echo "INFO tests/ledger/run.sh status=$([ $FAILED -eq 0 ] && echo ok || echo FAILED)" >> "$LOG"
exit $FAILED
