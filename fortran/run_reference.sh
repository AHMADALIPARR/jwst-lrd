#!/bin/sh
# SPDX-License-Identifier: AGPL-3.0-only
# Also subject to SNAPKITTY_OPAQUE_LICENSE.md (dual license, see repository root).
#
# Runs the Fortran reference analysis on the primary real product (fixtures/ingest/CURRENT)
# and writes LRD-ARR-v1 arrays + reference.{kv,rec,commit} (LRD-REC-v1) to <outdir>
# (default fixtures/reference/<sha>/). Offline only: reads the stored, checksum-verified FITS.
set -eu
ROOT=$(cd "$(dirname "$0")/.." && pwd)
BIN="$ROOT/build/out/bin"
SHA=$(cat "$ROOT/fixtures/ingest/CURRENT")
RAW="$ROOT/fixtures/raw/$SHA.fits"
OUT=${1:-$ROOT/fixtures/reference/$SHA}
"$BIN/lrd_sha256" "$RAW" "$SHA" > /dev/null || { echo "run_reference: CHECKSUM MISMATCH $RAW" >&2; exit 1; }
mkdir -p "$OUT"
"$BIN/lrd_reference" "$RAW" "$OUT" "$SHA"
"$BIN/lrd_rec" "$OUT/reference.rec" < "$OUT/reference.kv" > "$OUT/reference.commit"
echo "run_reference: wrote $OUT (commit $(cat "$OUT/reference.commit"))"
