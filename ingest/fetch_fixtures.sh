#!/bin/sh
# SPDX-License-Identifier: AGPL-3.0-only
# Also subject to SNAPKITTY_OPAQUE_LICENSE.md (dual license, see repository root).
#
# make fixtures: for every stored product fixtures/ingest/<sha>/source.kv, re-fetch the raw
# FITS from MAST if it is missing (streaming, retry, Range resume via lrd_fetch), then verify
# that sha256(raw) == <sha> and size == raw.size. Fails loudly on any mismatch.
# With LRD_OFFLINE=1 nothing is fetched; only verification is performed.
set -eu
ROOT=$(cd "$(dirname "$0")/.." && pwd)
BIN="$ROOT/build/out/bin"
n=0
for d in "$ROOT"/fixtures/ingest/*/; do
  [ -f "$d/source.kv" ] || continue
  sha=$(basename "$d")
  raw="$ROOT/fixtures/raw/$sha.fits"
  size=$(sed -n 's/^raw.size=//p' "$d/source.kv")
  if [ ! -f "$raw" ]; then
    [ "${LRD_OFFLINE:-0}" = "1" ] && { echo "fixtures: FATAL missing $raw (offline)" >&2; exit 1; }
    url=$(sed -n 's/^mast.download_url=//p' "$d/source.kv")
    mkdir -p "$ROOT/build/out/dl" "$ROOT/fixtures/raw"
    "$BIN/lrd_fetch" "$url" "$ROOT/build/out/dl/$sha.part" "$size" >/dev/null
    mv "$ROOT/build/out/dl/$sha.part" "$raw"
  fi
  chmod 0444 "$raw"
  "$BIN/lrd_sha256" "$raw" "$sha" >/dev/null || { echo "fixtures: FATAL CHECKSUM MISMATCH $raw" >&2; exit 1; }
  [ "$(wc -c < "$raw" | tr -d ' ')" = "$size" ] || { echo "fixtures: FATAL size mismatch $raw" >&2; exit 1; }
  echo "fixtures: verified $sha ($(sed -n 's/^mast.product_filename=//p' "$d/source.kv"), $size bytes)"
  n=$((n+1))
done
[ $n -gt 0 ] || { echo "fixtures: no products under fixtures/ingest/" >&2; exit 1; }
