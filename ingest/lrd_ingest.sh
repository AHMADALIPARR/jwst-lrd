#!/bin/sh
# SPDX-License-Identifier: AGPL-3.0-only
# Also subject to SNAPKITTY_OPAQUE_LICENSE.md (dual license, see repository root).
#
# MAST archive polling + ingestion for one public JWST NIRSpec x1d product.
# This is ARCHIVE POLLING of the public MAST API, not telemetry.
#
#   ingest/lrd_ingest.sh            online: Cone -> Filtered -> Products -> Download
#   LRD_OFFLINE=1 ingest/lrd_ingest.sh   offline replay: zero network calls,
#                                   verifies stored fixture checksum, re-extracts,
#                                   and compares with the committed outputs.
# Tools: sh, curl, jq (discovery JSON), C + libcurl (download), C + CFITSIO (parse).
set -eu
ROOT=$(cd "$(dirname "$0")/.." && pwd)
BIN="$ROOT/build/out/bin"
OUT="$ROOT/build/out/ingest"
FIX="$ROOT/fixtures"
API="https://mast.stsci.edu/api/v0/invoke"
DL="https://mast.stsci.edu/api/v0.1/Download/file"
. "$ROOT/ingest/target.conf"

die() { echo "lrd_ingest: FATAL: $*" >&2; exit 1; }
log() { echo "lrd_ingest: $*" >&2; }
offline() { [ "${LRD_OFFLINE:-0}" = "1" ]; }

for b in lrd_fetch lrd_sha256 lrd_rec lrd_fitsx; do
  [ -x "$BIN/$b" ] || die "missing $BIN/$b (run make build)"
done

sex2deg() { # $1 = [+-]a:b:c, $2 = 15 for RA hours or 1 for degrees
  echo "$1" | awk -F: -v k="$2" '{s=1; a=$1; if (substr(a,1,1)=="-") {s=-1; a=substr(a,2)}
    printf "%.7f\n", s*k*(a + $2/60 + $3/3600)}'
}
RA=$(sex2deg "$TARGET_RA_SEX" 15)
DEC=$(sex2deg "$TARGET_DEC_SEX" 1)

mast() { # $1 = request JSON, $2 = output file
  offline && die "network call attempted in offline mode"
  n=1
  while :; do
    if curl -sS --fail --max-time 300 -X POST "$API" \
         -H 'User-Agent: jwst-lrd-ingest/1 (curl)' \
         --data-urlencode "request=$1" -o "$2.tmp"; then
      st=$(jq -r '.status' "$2.tmp")
      [ "$st" = "COMPLETE" ] && { mv "$2.tmp" "$2"; return 0; }
      log "MAST status $st (attempt $n)"
    fi
    n=$((n+1)); [ $n -gt 5 ] && die "MAST request failed: $1"
    sleep $((n*3))
  done
}

if ! offline; then
  mkdir -p "$OUT/mast" "$OUT/dl" "$FIX/raw" "$FIX/mast"
  TS=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  # Step 1: discovery (Mast.Caom.Cone)
  log "step 1 Mast.Caom.Cone ra=$RA dec=$DEC r=$CONE_RADIUS_DEG deg"
  mast "{\"service\":\"Mast.Caom.Cone\",\"format\":\"json\",\"params\":{\"ra\":$RA,\"dec\":$DEC,\"radius\":$CONE_RADIUS_DEG}}" "$OUT/mast/cone.json"
  jq -r --arg c "$SEL_COLLECTION" --arg i "$SEL_INSTRUMENT" \
    '[.data[] | select(.obs_collection==$c and .instrument_name==$i) | .obs_id] | unique | .[]' \
    "$OUT/mast/cone.json" > "$OUT/mast/cone_obs_ids.txt"
  log "cone: $(jq '.data|length' "$OUT/mast/cone.json") rows, $(wc -l < "$OUT/mast/cone_obs_ids.txt") $SEL_INSTRUMENT obs_ids"
  # Step 2: metadata (Mast.Caom.Filtered) restricted to the cone's obs_ids
  IDS=$(jq -R . < "$OUT/mast/cone_obs_ids.txt" | jq -sc .)
  mast "{\"service\":\"Mast.Caom.Filtered\",\"format\":\"json\",\"params\":{\"columns\":\"*\",\"filters\":[
    {\"paramName\":\"obs_id\",\"values\":$IDS},
    {\"paramName\":\"obs_collection\",\"values\":[\"$SEL_COLLECTION\"]},
    {\"paramName\":\"instrument_name\",\"values\":[\"$SEL_INSTRUMENT\"]},
    {\"paramName\":\"proposal_id\",\"values\":[\"$SEL_PROPOSAL\"]},
    {\"paramName\":\"calib_level\",\"values\":[$SEL_CALIB_LEVEL]},
    {\"paramName\":\"dataRights\",\"values\":[\"PUBLIC\"]},
    {\"paramName\":\"dataproduct_type\",\"values\":[\"spectrum\"]}]}}" "$OUT/mast/filtered.json"
  # Keep source-level (_s<id>) observations whose footprint bounding box contains the target.
  # If SEL_OBS_ID is set (target.conf or env) it must be among the candidates; otherwise
  # the earliest epoch (t_min) is chosen deterministically.
  jq -c --argjson ra "$RA" --argjson dec "$DEC" '
    [.data[] | select(.obs_id|test("_s[0-9]+_"))
     | . as $o | ($o.s_region | split(" ") | .[1:] | map(tonumber)) as $p
     | [range(0; $p|length; 2) as $j | $p[$j]] as $xs
     | [range(1; $p|length; 2) as $j | $p[$j]] as $ys
     | select(($xs|min) <= $ra and $ra <= ($xs|max) and ($ys|min) <= $dec and $dec <= ($ys|max))
     | {obsid, obs_id, t_min, filters, target_name, proposal_id, proposal_pi, s_region}]
    | sort_by(.t_min)' "$OUT/mast/filtered.json" > "$OUT/mast/candidates.json"
  log "candidates: $(jq -c '[.[].obs_id]' "$OUT/mast/candidates.json")"
  SEL=${LRD_SELECT_OBS_ID:-${SEL_OBS_ID:-}}
  if [ -n "$SEL" ]; then
    jq -c --arg s "$SEL" "[.[] | select(.obs_id==\$s)]" "$OUT/mast/candidates.json" > "$OUT/mast/selected.json"
  else
    jq -c ".[0:1]" "$OUT/mast/candidates.json" > "$OUT/mast/selected.json"
  fi
  OBSID=$(jq -r ".[0].obsid // empty" "$OUT/mast/selected.json")
  [ -n "$OBSID" ] || die "selected obs_id '$SEL' not among discovered candidates"
  OBS_ID=$(jq -r ".[0].obs_id" "$OUT/mast/selected.json")
  # Step 3: products (Mast.Caom.Products)
  mast "{\"service\":\"Mast.Caom.Products\",\"format\":\"json\",\"params\":{\"obsid\":\"$OBSID\"}}" "$OUT/mast/products.json"
  jq -c --arg g "$SEL_PRODUCT_SUBGROUP" --arg o "$OBSID" \
    '[.data[] | select(.productSubGroupDescription==$g and (.obsID|tostring)==$o and .dataRights=="PUBLIC"
                      and (.productFilename|endswith(".fits")))] | .[0]' \
    "$OUT/mast/products.json" > "$OUT/mast/product.json"
  FN=$(jq -r '.productFilename // empty' "$OUT/mast/product.json")
  [ -n "$FN" ] || die "no public $SEL_PRODUCT_SUBGROUP product for obsid $OBSID"
  URI=$(jq -r '.dataURI' "$OUT/mast/product.json")
  SIZE_MAST=$(jq -r '.size' "$OUT/mast/product.json")
  log "product $FN ($URI, MAST size $SIZE_MAST)"
  # Step 4: streaming download with retry + Range resume
  ENC=$(jq -rn --arg u "$URI" '$u|@uri')
  RES=$("$BIN/lrd_fetch" "$DL?uri=$ENC" "$OUT/dl/$FN.part" "$SIZE_MAST")
  SHA=$(echo "$RES" | sed -n 's/^sha256=//p')
  SIZE=$(echo "$RES" | sed -n 's/^size=//p')
  [ "$SIZE" = "$SIZE_MAST" ] || die "size $SIZE != MAST size $SIZE_MAST"
  RAW="$FIX/raw/$SHA.fits"
  if [ -e "$RAW" ]; then
    "$BIN/lrd_sha256" "$RAW" "$SHA" >/dev/null || die "existing $RAW does not match"
    rm -f "$OUT/dl/$FN.part"
  else
    mv "$OUT/dl/$FN.part" "$RAW"
  fi
  chmod 0444 "$RAW"
  # Persist the discovery evidence (small JSON) alongside the fixture.
  D="$FIX/ingest/$SHA"; mkdir -p "$D/mast"
  cp "$OUT/mast/candidates.json" "$OUT/mast/selected.json" "$OUT/mast/product.json" "$OUT/mast/cone_obs_ids.txt" "$D/mast/"
  jq -c --arg o "$OBSID" "[.data[] | select((.obsID|tostring)==\$o)]" "$OUT/mast/products.json" > "$D/mast/products_obsid.json"
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
  echo "$SHA" > "$FIX/ingest/CURRENT"
else
  if [ -z "${LRD_SHA:-}" ]; then
    # Replay every stored product (each fixtures/ingest/<sha>/ with a source.kv).
    nrep=0
    for d in "$FIX"/ingest/*/; do
      [ -f "$d/source.kv" ] || continue
      LRD_SHA=$(basename "$d") sh "$0" || exit 1
      nrep=$((nrep+1))
    done
    [ $nrep -gt 0 ] || die "offline: no stored products under fixtures/ingest/"
    exit 0
  fi
  SHA=$LRD_SHA
  D="$FIX/ingest/$SHA"
  RAW="$FIX/raw/$SHA.fits"
  log "offline replay of $SHA (no network)"
fi

# Checksum verification of the immutable raw product (both modes). Fails loudly.
[ -f "$RAW" ] || die "missing raw fixture $RAW"
"$BIN/lrd_sha256" "$RAW" "$SHA" > /dev/null || die "CHECKSUM MISMATCH for $RAW"
EXPECT_SIZE=$(sed -n 's/^raw.size=//p' "$D/source.kv")
ACT_SIZE=$(wc -c < "$RAW" | tr -d ' ')
[ "$ACT_SIZE" = "$EXPECT_SIZE" ] || die "size mismatch $ACT_SIZE != $EXPECT_SIZE"
# git does not preserve mode 0444 on checkout; re-assert immutability before checking.
chmod 0444 "$RAW"
PERM=$(stat -c %a "$RAW")
[ "$PERM" = "444" ] || die "raw fixture not read-only (mode $PERM)"

# Header/calibration + array extraction with CFITSIO (C).
W="$OUT/work/$SHA"
rm -rf "$W"; mkdir -p "$W"
"$BIN/lrd_fitsx" "$RAW" "$W" "$SHA"
# LRD-REC-v1 provenance manifest: source.kv + FITS header fields + array digests.
{
  cat "$D/source.kv"
  sed 's/^/fits./' "$W/header.kv"
  for a in wavelength flux flux_error; do
    echo "arr.$a.sha256=$("$BIN/lrd_sha256" "$W/$a.f64" | cut -d' ' -f1)"
    echo "arr.$a.hdr_sha256=$("$BIN/lrd_sha256" "$W/$a.hdr" | cut -d' ' -f1)"
  done
} > "$W/manifest.kv"
"$BIN/lrd_rec" "$W/manifest.rec" < "$W/manifest.kv" > "$W/manifest.commit"
OUTPUTS="header.kv wavelength.f64 wavelength.hdr flux.f64 flux.hdr flux_error.f64 flux_error.hdr manifest.kv manifest.rec manifest.commit"
if offline; then
  for f in $OUTPUTS; do
    cmp -s "$W/$f" "$D/$f" || die "OFFLINE REPLAY MISMATCH: $f differs from committed fixtures/ingest/$SHA/$f"
  done
  echo "OFFLINE_REPLAY_OK sha256=$SHA commit=$(cat "$W/manifest.commit") network_calls=0"
else
  for f in $OUTPUTS; do cp "$W/$f" "$D/$f"; done
  echo "INGEST_OK sha256=$SHA size=$ACT_SIZE obsid=$(sed -n 's/^mast.obsid=//p' "$D/source.kv") file=$(sed -n 's/^mast.product_filename=//p' "$D/source.kv") commit=$(cat "$D/manifest.commit")"
fi
