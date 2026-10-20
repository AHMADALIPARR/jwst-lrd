#!/bin/sh
# SPDX-License-Identifier: AGPL-3.0-only
# Also subject to SNAPKITTY_OPAQUE_LICENSE.md (dual license, see repository root).
#
# Emits the LRD-STATE-v1 observation chain for the stored products, in ingestion order:
#   seq 1: 09bcd907... (jw02561-o002, provenance_only, flux_globally_negative)  ingested first
#   seq 2: c0b87857... (jw02561-o006, primary, none)
# into <outdir> (default fixtures/state/observation/): NNNN.proposal.rec, NNNN.decision.rec,
# NNNN.state.rec (LRD-REC-v1) and HEAD (commitment of the last state). Offline only.
set -eu
ROOT=$(cd "$(dirname "$0")/.." && pwd)
BIN="$ROOT/build/out/bin"
OUT=${1:-$ROOT/fixtures/state/observation}
FIX="$ROOT/fixtures"
mkdir -p "$OUT"
cur=genesis; i=0
while read -r sha use flag; do
  case "$sha" in ''|'#'*) continue;; esac
  i=$((i+1)); n=$(printf '%04d' $i)
  d="$FIX/ingest/$sha"
  {
    echo "obs_manifest_commit=$(cat "$d/manifest.commit")"
    echo "obs_mast_obsid=$(sed -n 's/^mast.obsid=//p' "$d/source.kv")"
    echo "obs_product=$(sed -n 's/^mast.product_filename=//p' "$d/source.kv")"
    echo "obs_quality_flag=$flag"
    echo "obs_science_use=$use"
  } | "$BIN/lrd_obs" propose "$cur" "$sha" "$OUT/$n.proposal.rec"
  "$BIN/lrd_obs" apply "$FIX" "$cur" "$OUT/$n.proposal.rec" "$OUT/$n.decision.rec" "$OUT/$n.state.rec" \
    || { echo "emit_obs_chain: transition $n REJECTED: $(cat "$OUT/$n.decision.rec" | tr '\n' ' ')" >&2; exit 1; }
  cur="$OUT/$n.state.rec"
done < "$ROOT/ingest/obs_chain.plan"
"$BIN/lrd_obs" commit "$cur" > "$OUT/HEAD"
echo "emit_obs_chain: $i transitions, head $(cat "$OUT/HEAD")"
