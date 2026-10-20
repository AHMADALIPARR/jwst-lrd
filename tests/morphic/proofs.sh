#!/bin/sh
# SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
set -eu
ROOT=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
AGDA=${LRD_AGDA:-agda}
STDLIB=${LRD_AGDA_STDLIB:-/usr/share/agda-stdlib/src}
EVD="$ROOT/tests/morphic/evidence"
mkdir -p "$EVD" "$ROOT/build/out"
# Invalidate earlier evidence before any availability or checking failure.
printf 'LRD-REC-v1\n8:compiler11:UNAVAILABLE\n11:status.core11:UNAVAILABLE\n13:status.growth11:UNAVAILABLE\n13:status.kernel11:UNAVAILABLE\n' > "$EVD/proofs.rec"
if ! command -v "$AGDA" >/dev/null 2>&1 || [ ! -d "$STDLIB/Data" ]; then
  echo 'UNAVAILABLE morphic_agda missing compiler or stdlib source'; exit 0
fi
if ! grep -qx 'name: standard-library-2.1' "$STDLIB/../standard-library.agda-lib"; then
  echo 'FAIL morphic_agda_stdlib expected_standard_library_2.1'; exit 1
fi
VERSION=$("$AGDA" --version)
if [ "$VERSION" != 'Agda version 2.6.4.3' ]; then
  echo "FAIL morphic_agda_version expected_2.6.4.3_got_$VERSION"; exit 1
fi
RESULT="$ROOT/build/out/morphic-proofs.rec"
printf 'LRD-REC-v1\n' > "$RESULT"
field() { printf '%s:%s%s:%s\n' "${#1}" "$1" "${#2}" "$2" >> "$RESULT"; }
field compiler "$VERSION"
# Canonical LF text makes the source-tree identity portable across Windows
# checkouts. Fixture commitments always hash original bytes instead.
SOURCE_HASH=$(cd "$ROOT" && find agda/Core agda/kernel/src agda/growth -name '*.agda' -type f | LC_ALL=C sort |
  while IFS= read -r P; do
    H=$(tr -d '\r' < "$P" | sha256sum | cut -d' ' -f1)
    printf '%s  %s\n' "$H" "$P"
  done | sha256sum | cut -d' ' -f1)
field source_tree_sha256 "$SOURCE_HASH"
: > "$EVD/proof-results.txt"
for TRACK in core growth kernel; do
  case "$TRACK" in
    core) MODULE=Core/All.agda ;;
    kernel) MODULE=kernel/src/Kernel/Everything.agda ;;
    growth) MODULE=growth/Growth.agda ;;
  esac
  LOG="$ROOT/build/out/morphic-agda-$TRACK.log"
  if (cd "$ROOT/agda" && timeout -k 5 300 "$AGDA" --no-libraries --safe --without-K \
    -i. -ikernel/src -igrowth -i"$STDLIB" "$MODULE" +RTS -M1600m -RTS) > "$LOG" 2>&1; then
    echo "PASS morphic_agda_$TRACK" | tee -a "$EVD/proof-results.txt"
    field "status.$TRACK" PASS
  else
    echo "FAIL morphic_agda_$TRACK see_$LOG" | tee -a "$EVD/proof-results.txt"
    tail -15 "$LOG"; exit 1
  fi
done
STDLIB_HASH=$(cd "$STDLIB/.." && find src -name '*.agda' -type f | LC_ALL=C sort | xargs sha256sum | sha256sum | cut -d' ' -f1)
field stdlib_tree_sha256 "$STDLIB_HASH"
field stdlib_version '2.1'
NEG="$ROOT/build/out/morphic-agda-negative.log"
if (cd "$ROOT" && timeout -k 5 120 "$AGDA" --no-libraries --safe --without-K \
  -iagda/growth -itests/morphic -i"$STDLIB" tests/morphic/BadGrowth.agda) > "$NEG" 2>&1; then
  echo 'FAIL morphic_agda_false_certificate_accepted'; exit 1
elif grep -q 'when checking that the expression tt has type' "$NEG"; then
  echo 'PASS morphic_agda_false_certificate_rejected' | tee -a "$EVD/proof-results.txt"
else
  echo 'FAIL morphic_agda_negative_unexpected_error'; tail -15 "$NEG"; exit 1
fi
field trust_boundary 'continuous-growth bridge, cryptographic binding, and runtime refinement remain conditional'
cp "$RESULT" "$EVD/proofs.rec"
printf '%s\nsource_tree_sha256=%s\n' "$VERSION" "$SOURCE_HASH" >> "$EVD/proof-results.txt"
