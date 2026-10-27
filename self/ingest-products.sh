#!/bin/sh
# SPDX-License-Identifier: AGPL-3.0-only
# Also subject to SNAPKITTY_OPAQUE_LICENSE.md (dual license, see repository root).
#
# T015 helper: ingest ONE public MAST X1D product (already identified in a Mast.Caom.Products
# JSON) into the same fixture layout as t001's ingest/lrd_ingest.sh, reusing its C tools
# (lrd_fetch, lrd_fitsx, lrd_rec, lrd_sha256; read-only use of $T001_BIN).  sh + curl + jq only.
#   self/ingest-products.sh <product.json> <candidate-obs.json> <mast-evidence-dir>...
#     <product.json>  one row of Mast.Caom.Products (the X1D product)
#     <obs.json>      one row of Mast.Caom.Cone/Filtered for the same obsid (kept as evidence)
#   Output root FIXROOT (default: worktree root of this script)/fixtures/{raw,ingest}/...
# Does NOT write fixtures/ingest/CURRENT (selection of the primary product belongs to t001).
set -eu
HERE=$(cd "$(dirname "$0")" && pwd)
FIXROOT=${FIXROOT:-$(cd "$HERE/.." && pwd)}
BIN=${T001_BIN:-/workspace/jwst-lrd-t001/build/out/bin}
DL="https://mast.stsci.edu/api/v0.1/Download/file"
for b in lrd_fetch lrd_fitsx lrd_rec lrd_sha256; do [ -x "$BIN/$b" ] || { echo "UNAVAILABLE $BIN/$b" >&2; exit 2; }; done
P=$1; O=$2; shift 2
FN=$(jq -r .productFilename "$P"); URI=$(jq -r .dataURI "$P"); OBSID=$(jq -r .obsID "$P")
OBS_ID=$(jq -r .obs_id "$P"); SIZE_MAST=$(jq -r .size "$P")
[ "$(jq -r .dataRights "$P")" = PUBLIC ] || { echo "REFUSED: $FN is not PUBLIC" >&2; exit 1; }
ENC=$(jq -rn --arg u "$URI" '$u|@uri')
TMP=${TMPDIR:-/tmp}/t015dl; mkdir -p "$TMP" "$FIXROOT/fixtures/raw"
TS=$(date -u +%Y-%m-%dT%H:%M:%SZ)
RES=$("$BIN/lrd_fetch" "$DL?uri=$ENC" "$TMP/$FN.part" "$SIZE_MAST")
SHA=$(echo "$RES" | sed -n 's/^sha256=//p'); SIZE=$(echo "$RES" | sed -n 's/^size=//p')
[ "$SIZE" = "$SIZE_MAST" ] || { echo "size $SIZE != MAST size $SIZE_MAST" >&2; exit 1; }
RAW="$FIXROOT/fixtures/raw/$SHA.fits"
if [ -e "$RAW" ]; then "$BIN/lrd_sha256" "$RAW" "$SHA" >/dev/null; rm -f "$TMP/$FN.part"; else mv "$TMP/$FN.part" "$RAW"; fi
chmod 0444 "$RAW"
D="$FIXROOT/fixtures/ingest/$SHA"; mkdir -p "$D/mast"
cp "$P" "$D/mast/product.json"; cp "$O" "$D/mast/selected.json"
for e in "$@"; do cp "$e" "$D/mast/"; done
. /workspace/jwst-lrd-t001/ingest/target.conf
RA=$(echo "$TARGET_RA_SEX" | awk -F: '{printf "%.7f\n", 15*($1 + $2/60 + $3/3600)}')
DEC=$(echo "$TARGET_DEC_SEX" | awk -F: '{s=1; a=$1; if (substr(a,1,1)=="-") {s=-1; a=substr(a,2)} printf "%.7f\n", s*(a + $2/60 + $3/3600)}')
cat > "$D/source.kv" <<KV
mast.obsid=$OBSID
mast.obs_id=$OBS_ID
mast.uri=$URI
mast.download_url=$DL?uri=$ENC
mast.product_filename=$FN
mast.size_reported=$SIZE_MAST
mast.retrieved_utc=$TS
raw.sha256=$SHA
raw.size=$SIZE
raw.path=fixtures/raw/$SHA.fits
target.name=$TARGET_NAME
target.ra_sex=$TARGET_RA_SEX
target.dec_sex=$TARGET_DEC_SEX
target.ra_deg=$RA
target.dec_deg=$DEC
target.cone_radius_deg=$CONE_RADIUS_DEG
citation.coordinates=$CITATION
citation.spectrum=$CITATION_SPECTRUM
mode=archive_polling_not_telemetry
KV
W="$TMP/work/$SHA"; rm -rf "$W"; mkdir -p "$W"
"$BIN/lrd_fitsx" "$RAW" "$W" "$SHA"
{
  cat "$D/source.kv"
  sed 's/^/fits./' "$W/header.kv"
  for a in wavelength flux flux_error; do
    echo "arr.$a.sha256=$("$BIN/lrd_sha256" "$W/$a.f64" | cut -d' ' -f1)"
    echo "arr.$a.hdr_sha256=$("$BIN/lrd_sha256" "$W/$a.hdr" | cut -d' ' -f1)"
  done
} > "$W/manifest.kv"
"$BIN/lrd_rec" "$W/manifest.rec" < "$W/manifest.kv" > "$W/manifest.commit"
for f in header.kv wavelength.f64 wavelength.hdr flux.f64 flux.hdr flux_error.f64 flux_error.hdr manifest.kv manifest.rec manifest.commit; do cp "$W/$f" "$D/$f"; done
echo "INGEST_OK sha256=$SHA size=$SIZE obsid=$OBSID file=$FN retrieved_utc=$TS commit=$(cat "$D/manifest.commit")"
