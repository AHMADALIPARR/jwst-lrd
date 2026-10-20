#!/bin/sh
# SPDX-License-Identifier: AGPL-3.0-only
# Additional terms: SnapKitty Opaque License (SNAPKITTY_OPAQUE_LICENSE.md, repository root).
# Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
#
# tests/air/run.sh -- builds the AIR/STARK subsystem and prints one line per test:
#   PASS <name> | FAIL <name> <why> | UNAVAILABLE <name> <reason>
# Exits nonzero only if a FAIL was printed. Diagnostics go to air/build/logs/.
set -u
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
AIR="$ROOT/air"
B="$AIR/build"
LOG="$B/logs"
FX="$ROOT/tests/air/fixtures/SYNTHETIC_lrd_flux"
FAILED=0
pass() { echo "PASS $1"; }
fail() { echo "FAIL $1 $2"; FAILED=1; }
unav() { echo "UNAVAILABLE $1 $2"; }
mkdir -p "$LOG"

# 1. strict C17 build (gcc or default cc)
if make -C "$AIR" BUILD=build >"$LOG/build.log" 2>&1; then pass build_c17_wall_wextra_werror
else fail build_c17_wall_wextra_werror "see air/build/logs/build.log"; exit 1; fi

# 2. clang build of the same sources
if command -v clang >/dev/null 2>&1; then
  if make -C "$AIR" BUILD=build-clang CC=clang >"$LOG/build-clang.log" 2>&1; then pass build_clang_c17_werror
  else fail build_clang_c17_werror "see air/build/logs/build-clang.log"; fi
else unav build_clang_c17_werror "clang not installed"; fi

# 3. SYNTHETIC fixture is reproducible from its generator
mkdir -p "$B/fx"
if "$B/gen_synthetic" "$B/fx/SYNTHETIC_lrd_flux" >"$LOG/gen.log" 2>&1 &&
   cmp -s "$B/fx/SYNTHETIC_lrd_flux.f64" "$FX.f64" && cmp -s "$B/fx/SYNTHETIC_lrd_flux.hdr" "$FX.hdr" &&
   grep -q SYNTHETIC "$FX.hdr"; then pass synthetic_fixture_reproducible
else fail synthetic_fixture_reproducible "regenerated fixture differs from tests/air/fixtures"; fi

# 4. unit + integration tests (C)
"$B/test_air" "$FX" >"$LOG/test_air.log" 2>&1
rc=$?
grep -E '^(PASS|FAIL|UNAVAILABLE) ' "$LOG/test_air.log"
if grep -q '^FAIL ' "$LOG/test_air.log"; then FAILED=1
elif [ $rc -ne 0 ]; then fail test_air_exit "exit code $rc, see air/build/logs/test_air.log"; fi

# 5. end-to-end CLI: prove + verify one transition, then rejections
E="$B/e2e"; rm -rf "$E"; mkdir -p "$E/ok" "$E/flip" "$E/obs"
if "$B/air_cli" prove "$FX" 65536 "$E/ok" >"$LOG/cli_prove.log" 2>&1 &&
   "$B/air_cli" verify "$FX" 65536 "$E/ok" >"$LOG/cli_verify.log" 2>&1 &&
   grep -q '^decision=ACCEPT reason=ok' "$LOG/cli_verify.log" &&
   grep -q 'ACCEPT' "$E/ok/decision.rec"; then pass cli_prove_verify_accept
else fail cli_prove_verify_accept "see air/build/logs/cli_*.log"; fi
# 5b. one flipped bit in proof.bin (proposal payload hash recomputed is NOT done: expect bad_payload)
cp "$E/ok/"* "$E/flip/"
printf '\001' | dd of="$E/flip/proof.bin" bs=1 seek=4000 conv=notrunc 2>/dev/null
"$B/air_cli" verify "$FX" 65536 "$E/flip" >"$LOG/cli_flip.log" 2>&1
if [ $? -eq 3 ] && grep -q '^decision=REJECT' "$LOG/cli_flip.log"; then pass cli_modified_proof_rejected
else fail cli_modified_proof_rejected "see air/build/logs/cli_flip.log"; fi
# 5c. verify against a different observation: lowest mantissa byte of value 0 changed (fixed-point
#     inputs may be unchanged, but observation_sha256 differs)
cp "$FX.hdr" "$E/obs/SYNTHETIC_other.hdr"; cp "$FX.f64" "$E/obs/SYNTHETIC_other.f64"
printf '\001' | dd of="$E/obs/SYNTHETIC_other.f64" bs=1 seek=0 conv=notrunc 2>/dev/null
cp "$E/ok/"*.rec "$E/ok/proof.bin" "$E/obs/"
"$B/air_cli" verify "$E/obs/SYNTHETIC_other" 65536 "$E/obs" >"$LOG/cli_obs.log" 2>&1
if [ $? -eq 3 ] && grep -q '^decision=REJECT' "$LOG/cli_obs.log"; then pass cli_other_observation_rejected
else fail cli_other_observation_rejected "see air/build/logs/cli_obs.log"; fi

# 6. ASan + UBSan run of the C tests (tamper test strided to bound runtime)
if make -C "$AIR" BUILD=build-san CFLAGS="-O1 -g -fno-omit-frame-pointer" \
     SAN="-fsanitize=address,undefined -fno-sanitize-recover=all" >"$LOG/build-san.log" 2>&1; then
  AIR_TAMPER_STRIDE=97 ASAN_OPTIONS=detect_leaks=1:abort_on_error=1 UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1 \
    "$AIR/build-san/test_air" "$FX" >"$LOG/test_air_san.log" 2>&1
  rc=$?
  if [ $rc -eq 0 ] && ! grep -q '^FAIL ' "$LOG/test_air_san.log"; then pass asan_ubsan_test_air
  else fail asan_ubsan_test_air "exit $rc, see air/build/logs/test_air_san.log"; fi
else unav asan_ubsan_test_air "sanitizer build failed (see air/build/logs/build-san.log)"; fi

# 7. local LRD-STATE-v1 header mirror equals the ledger track's header
if git -C "$ROOT" rev-parse --verify -q t004-ledger >/dev/null 2>&1; then
  git -C "$ROOT" show t004-ledger:ledger/abi/lrd_state.h >"$LOG/lrd_state.owner.h" 2>/dev/null
  tail -n +10 "$AIR/abi_mirror/lrd_state.h" >"$LOG/lrd_state.mirror.h"
  if cmp -s "$LOG/lrd_state.owner.h" "$LOG/lrd_state.mirror.h"; then pass lrd_state_mirror_matches_t004_ledger
  else fail lrd_state_mirror_matches_t004_ledger "air/abi_mirror/lrd_state.h differs from t004-ledger:ledger/abi/lrd_state.h"; fi
elif [ -f "$ROOT/ledger/abi/lrd_state.h" ]; then
  tail -n +10 "$AIR/abi_mirror/lrd_state.h" | cmp -s - "$ROOT/ledger/abi/lrd_state.h" &&
    pass lrd_state_mirror_matches_ledger || fail lrd_state_mirror_matches_ledger "mirror differs from ledger/abi/lrd_state.h"
else unav lrd_state_mirror_matches_t004_ledger "neither branch t004-ledger nor ledger/abi/lrd_state.h is present"; fi

# 8. real JWST input (pluggable: any non-SYNTHETIC LRD-ARR-v1 under fixtures/; scale via AIR_REAL_SCALE)
REAL=""
if [ -d "$ROOT/fixtures" ]; then
  for h in $(find "$ROOT/fixtures" -name '*.hdr' 2>/dev/null | sort); do
    if grep -q '^format=LRD-ARR-v1' "$h" && ! grep -q SYNTHETIC "$h" && ! echo "$h" | grep -q SYNTHETIC; then
      REAL="${h%.hdr}"; break
    fi
  done
fi
if [ -z "$REAL" ]; then
  unav real_input "no real (non-SYNTHETIC) LRD-ARR-v1 JWST x1d fixture under fixtures/ (Foundry J Spec fixture not landed)"
elif [ -z "${AIR_REAL_SCALE:-}" ]; then
  unav real_input "found $REAL but AIR_REAL_SCALE (fixed-point scale for its unit) is not set"
else
  mkdir -p "$E/real"
  if "$B/air_cli" prove "$REAL" "$AIR_REAL_SCALE" "$E/real" >"$LOG/cli_real_prove.log" 2>&1 &&
     "$B/air_cli" verify "$REAL" "$AIR_REAL_SCALE" "$E/real" >"$LOG/cli_real_verify.log" 2>&1; then pass real_input
  else fail real_input "see air/build/logs/cli_real_*.log"; fi
fi

# 9. hygiene: no Python/TypeScript/JavaScript; license header on every source file
BAD=$(find "$AIR" "$ROOT/tests/air" -path "$AIR/build*" -prune -o -type f \
        \( -name '*.py' -o -name '*.ts' -o -name '*.tsx' -o -name '*.js' -o -name '*.jsx' -o -name '*.mjs' \) -print)
if [ -z "$BAD" ]; then pass no_python_typescript_javascript; else fail no_python_typescript_javascript "$BAD"; fi
MISS=""
for f in $(find "$AIR" "$ROOT/tests/air" -path "$AIR/build*" -prune -o -type f \( -name '*.c' -o -name '*.h' -o -name Makefile -o -name '*.sh' \) -print); do
  grep -q 'SPDX-License-Identifier: AGPL-3.0-only' "$f" && grep -q 'SnapKitty Opaque License' "$f" || MISS="$MISS $f"
done
if [ -z "$MISS" ]; then pass license_headers; else fail license_headers "$MISS"; fi

exit $FAILED
