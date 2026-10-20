#!/bin/sh
# SPDX-License-Identifier: AGPL-3.0-only
# Also subject to SNAPKITTY_OPAQUE_LICENSE.md (dual license, see repository root).
#
# Redshift-discrepancy investigation on the primary product; writes
# <outdir>/zinvest.{kv,rec,commit} (default fixtures/reference/<sha>/). Offline only.
set -eu
ROOT=$(cd "$(dirname "$0")/.." && pwd)
BIN="$ROOT/build/out/bin"
SHA=$(cat "$ROOT/fixtures/ingest/CURRENT")
RAW="$ROOT/fixtures/raw/$SHA.fits"
LSF="$ROOT/fortran/data/jdox/jwst_nirspec_prism_disp.fits"
LSF_SHA=58f9330440c50af624313e70f3e5b9f58a6b22d06af094e0085ed66408d0d937
OUT=${1:-$ROOT/fixtures/reference/$SHA}
"$BIN/lrd_sha256" "$RAW" "$SHA" > /dev/null || { echo "run_zinvest: CHECKSUM MISMATCH $RAW" >&2; exit 1; }
"$BIN/lrd_sha256" "$LSF" "$LSF_SHA" > /dev/null || { echo "run_zinvest: CHECKSUM MISMATCH $LSF" >&2; exit 1; }
mkdir -p "$OUT"
"$BIN/lrd_zinvest" "$RAW" "$LSF" "$OUT/zinvest.body"
{ echo "source_sha256=$SHA"; echo "lsf.file_sha256=$LSF_SHA"
  echo "z_published=7.0451 (Furtak et al. 2024, Nature 628, 57, arXiv:2308.05735)"
  cat "$OUT/zinvest.body"; } > "$OUT/zinvest.kv"
rm -f "$OUT/zinvest.body"
"$BIN/lrd_rec" "$OUT/zinvest.rec" < "$OUT/zinvest.kv" > "$OUT/zinvest.commit"
echo "run_zinvest: wrote $OUT/zinvest.kv (commit $(cat "$OUT/zinvest.commit"))"
