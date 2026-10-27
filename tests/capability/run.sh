#!/usr/bin/env bash
# SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
# Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
# Dual-licensed (intentionally): AGPL-3.0-only plus the SnapKitty Opaque License.
# TASK 010 capability track test runner (CONTRACTS.md test convention).
# Prints PASS <name> | FAIL <name> <why> | UNAVAILABLE <name> <reason>; exits nonzero only on FAIL.
# Evidence: capability/evidence/*.log (overwritten each run).
#   LRDCAP_SKIP_MUTATION=1  skips the (slow, ~40 s) mutation check -> reported UNAVAILABLE.
set -uo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
CAP="$ROOT/capability"; EV="$CAP/evidence"; mkdir -p "$EV"
fails=0
emit() { echo "$1"; case "$1" in FAIL*) fails=$((fails+1));; esac; }
for t in cargo rustc cc openssl; do
  command -v "$t" >/dev/null || { emit "UNAVAILABLE capability_all missing toolchain: $t"; exit 0; }
done
{ echo "date: $(date)"; cargo --version; rustc --version; cc --version | head -1; openssl version; uname -srm; } > "$EV/versions.log" 2>&1

# 1. ABI header drift (ledger track owns ledger/abi/lrd_state.h)
while read -r l; do emit "$l"; done < <(bash "$CAP/scripts/abi_drift_check.sh")

# 2. build
cd "$CAP"
if nice -n 19 cargo build --release --offline > "$EV/build.log" 2>&1; then emit "PASS build_release"
else emit "FAIL build_release see capability/evidence/build.log"; exit 1; fi

# 3. cargo tests (unit + multi-process adversarial). One line per Rust test.
nice -n 19 cargo test --release --offline -- --nocapture --test-threads=4 > "$EV/cargo_test.log" 2>&1
crc=$?
while read -r l; do
  name=$(echo "$l" | sed -E 's/^test ([^ ]+) \.\.\. .*/\1/' | sed 's/::/__/g')
  case "$l" in *"... ok") emit "PASS rust_$name";; *"... FAILED") emit "FAIL rust_$name see capability/evidence/cargo_test.log";;
               *"... ignored") emit "UNAVAILABLE rust_$name ignored";; esac
done < <(grep -E '^test [^ ]+ \.\.\. (ok|FAILED|ignored)$' "$EV/cargo_test.log")
# OPEN lines printed by tests (known, unfixed inconsistencies; not counted as FAIL)
grep -E "^OPEN " "$EV/cargo_test.log" | while read -r l; do emit "$l"; done
grep -q '^test result: ' "$EV/cargo_test.log" || emit "FAIL cargo_test no test result (exit $crc)"
[ $crc -eq 0 ] || grep -q 'FAILED$' "$EV/cargo_test.log" || emit "FAIL cargo_test exit $crc"

# 4. openssl cross-checks of vendored bigint / hash-to-prime
while read -r l; do emit "$l"; done < <(nice -n 19 bash "$CAP/scripts/openssl_crosscheck.sh" "$CAP/target/release/lrd-authority" 2>&1 | tee "$EV/openssl_crosscheck.log")

# 5. bash end-to-end with two real processes (includes the ACCEPTANCE test)
while read -r l; do emit "$l"; done < <(bash "$CAP/scripts/integration.sh" "$CAP/target/release" "$EV/e2e" 2>&1 | tee "$EV/e2e_results.log")

# 6. mutation check (the adversarial suite must catch each disabled check)
if [ "${LRDCAP_SKIP_MUTATION:-0}" = 1 ]; then emit "UNAVAILABLE mutation_check skipped by LRDCAP_SKIP_MUTATION=1"
else while read -r l; do emit "$l"; done < <(bash "$CAP/scripts/mutation_check.sh" 2>&1 | tee "$EV/mutation_check.log"); fi

# 7. obligations file is well-formed enough to be consumed (jq if present)
if command -v jq >/dev/null; then
  jq -e '.obligations | length > 0' "$CAP/obligations.json" >/dev/null && emit "PASS obligations_json_parses" || emit "FAIL obligations_json_parses jq error"
else emit "UNAVAILABLE obligations_json_parses jq not installed"; fi
exit $([ $fails -eq 0 ] && echo 0 || echo 1)
