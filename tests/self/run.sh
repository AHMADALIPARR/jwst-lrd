#!/bin/sh
# Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
# Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
# SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
#
# tests/self: T015 products (JWST program 5015, Abell2744-QSO1) ingested from MAST and
# loaded by the Self observatory. Prints PASS/FAIL/UNAVAILABLE lines (CONTRACTS.md);
# exits nonzero iff a FAIL occurred.  Headless: the GUI is not started.
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
cd "$ROOT" || exit 2
FAILS=0
pass() { echo "PASS $1"; }
fail() { echo "FAIL $1 $2"; FAILS=$((FAILS+1)); }
unav() { echo "UNAVAILABLE $1 $2"; }
SELF_VM=${SELF_VM:-/workspace/_self_tools/build/vm/Self}
SELF_WORLD=${SELF_WORLD:-/workspace/_self_tools/world/morphic.snap}
T=$(mktemp -d "${TMPDIR:-/tmp}/lrd-self-test.XXXXXX"); trap 'rm -rf "$T"' EXIT

# the two public program-5015 L3 IFU x1d products fetched from MAST for T015
PRISM=489230a4da09bd3c32667db84dd727974440b5ba3d9509eb108fe26fa1d0a3fc
G395H=86f2a5226ebfd6d1c657e43bdb48032504a2c022e8f83e1e3e0f363e533e0eaa
kv() { sed -n "s/^$2=//p" "$1" | head -1; }

for SHA in $PRISM $G395H; do
  D="fixtures/ingest/$SHA"; RAW="fixtures/raw/$SHA.fits"
  if [ ! -f "$RAW" ] || [ ! -f "$D/manifest.rec" ]; then unav "fixture_$SHA" "fixture not present in this worktree (run self/ingest-products.sh)"; continue; fi
  got=$(sha256sum "$RAW" | cut -d' ' -f1)
  [ "$got" = "$SHA" ] && pass "raw_sha256_matches_name_${SHA%${SHA#????????}}" || fail "raw_sha256_matches_name_$SHA" "got $got"
  sz=$(wc -c < "$RAW" | tr -d ' ')
  [ "$sz" = "$(kv $D/manifest.kv raw.size)" ] && [ "$sz" = "$(kv $D/manifest.kv mast.size_reported)" ] \
    && pass "raw_size_matches_manifest_and_mast_${SHA%${SHA#????????}}" || fail "raw_size_matches_manifest_and_mast_$SHA" "size $sz"
  c=$({ printf 'LRD-COMMIT-v1\000'; cat "$D/manifest.rec"; } | sha256sum | cut -d' ' -f1)
  [ "$c" = "$(cat "$D/manifest.commit")" ] && pass "commitment_matches_${SHA%${SHA#????????}}" || fail "commitment_matches_$SHA" "computed $c"
  case "$(kv $D/manifest.kv mast.retrieved_utc)" in
    20[0-9][0-9]-[01][0-9]-[0-3][0-9]T[0-2][0-9]:[0-5][0-9]:[0-5][0-9]Z) pass "retrieved_utc_format_${SHA%${SHA#????????}}";;
    *) fail "retrieved_utc_format_$SHA" "bad retrieved_utc";; esac
  [ -f "$D/mast/product.json" ] && [ "$(jq -r .dataRights "$D/mast/product.json" 2>/dev/null)" = PUBLIC ] \
    && pass "mast_dataRights_public_${SHA%${SHA#????????}}" || fail "mast_dataRights_public_$SHA" "product.json missing or not PUBLIC"
done

# Self loader (headless): the catalogue must list these observations with matching arrays
if [ ! -x "$SELF_VM" ] || [ ! -f "$SELF_WORLD" ]; then unav self_loader "Self VM or Morphic snapshot missing"
elif [ ! -f "fixtures/ingest/$PRISM/manifest.rec" ] || [ ! -f "fixtures/ingest/$G395H/manifest.rec" ]; then unav self_loader "fixtures absent"
else
  cat > "$T/q.self" <<'EOS'
((os environmentAt: 'LRD_SELF_DIR' IfFail: '.'), '/load.self') runScript.
lrdObservatory refresh.
lrdObservatory obsList do: [|:o| ('OBS ', o sha, ' ', (o f: 'mast.obs_id'), ' len=', (o arr: 'flux') length printString,
  ' nan=', (o arr: 'flux') nanCount printString, ' commit=', o rec commitment, ' file=', o commitFile) printLine].
'END' printLine.
EOS
  ROOTS="$ROOT"; [ -d /workspace/jwst-lrd-t001/fixtures ] && ROOTS="$ROOTS /workspace/jwst-lrd-t001"
  LRD_SELF_DIR="$ROOT/self" LRD_ROOTS="$ROOTS" timeout 120 "$SELF_VM" -s "$SELF_WORLD" -f "$T/q.self" </dev/null > "$T/q.out" 2>&1
  grep -q '^END' "$T/q.out" && pass self_loader_runs || fail self_loader_runs "no END marker; tail: $(tail -1 "$T/q.out")"
  for SHA in $PRISM $G395H; do
    L=$(grep "^OBS $SHA " "$T/q.out")
    [ -n "$L" ] && pass "self_lists_${SHA%${SHA#????????}}" || { fail "self_lists_$SHA" "not listed"; continue; }
    D="fixtures/ingest/$SHA"
    n=$(sed -n 's/.* len=\([0-9]*\) .*/\1/p' <<EOT
$L
EOT
)
    [ "$n" = "$(sed -n 's/^length=//p' $D/flux.hdr)" ] && pass "self_flux_length_matches_hdr_${SHA%${SHA#????????}}" || fail "self_flux_length_matches_hdr_$SHA" "len $n"
    nan=$(sed -n 's/.* nan=\([0-9]*\) .*/\1/p' <<EOT
$L
EOT
)
    [ "$nan" = "$(kv $D/manifest.kv fits.col.FLUX.nan_count)" ] && pass "self_nan_count_matches_manifest_${SHA%${SHA#????????}} (nan=$nan)" || fail "self_nan_count_matches_manifest_$SHA" "self $nan manifest $(kv $D/manifest.kv fits.col.FLUX.nan_count)"
    case "$L" in *"commit=$(cat $D/manifest.commit) "*) pass "self_commitment_equals_manifest_commit_${SHA%${SHA#????????}}";; *) fail "self_commitment_equals_manifest_commit_$SHA" "differs";; esac
  done
  n=$(grep -c '^OBS ' "$T/q.out"); [ "$n" -ge 4 ] && pass "self_lists_at_least_4_observations (n=$n)" || fail self_lists_at_least_4_observations "n=$n"
  grep -qi 'SYNTHETIC' "$T/q.out" && fail no_synthetic_in_catalogue "SYNTHETIC entry in observation list" || pass no_synthetic_in_catalogue
fi
echo "== self done"
[ "$FAILS" -eq 0 ]
