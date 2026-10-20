#!/bin/sh
# SPDX-License-Identifier: AGPL-3.0-only
# Also subject to SNAPKITTY_OPAQUE_LICENSE.md (dual license, see repository root).
#
# tests/ingest: checksum verification, header extraction, LRD formats, offline replay.
# Prints PASS/FAIL/UNAVAILABLE lines (CONTRACTS.md); exits nonzero iff a FAIL occurred.
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
cd "$ROOT" || exit 2
BIN="$ROOT/build/out/bin"
T=$(mktemp -d "${TMPDIR:-/tmp}/lrd-ingest-test.XXXXXX")
trap 'chmod -R u+w "$T" 2>/dev/null; rm -rf "$T"' EXIT
FAILS=0
pass() { echo "PASS $1"; }
fail() { echo "FAIL $1 $2"; FAILS=$((FAILS+1)); }
unav() { echo "UNAVAILABLE $1 $2"; }

if make -s ingest >"$T/build.log" 2>&1; then pass build_ingest_tools
else fail build_ingest_tools "make ingest failed: $(tail -1 "$T/build.log")"; echo "== ingest done"; exit 1; fi

# 1. SHA-256 known-answer test (FIPS 180-2 example "abc").
printf abc > "$T/abc"
got=$("$BIN/lrd_sha256" "$T/abc" | cut -d' ' -f1)
[ "$got" = "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad" ] \
  && pass sha256_known_answer || fail sha256_known_answer "got $got"

SHA=$(cat fixtures/ingest/CURRENT 2>/dev/null)
RAW="fixtures/raw/$SHA.fits"
D="fixtures/ingest/$SHA"
if [ -z "$SHA" ] || [ ! -f "$RAW" ]; then
  fail fixture_present "fixtures/ingest/CURRENT or raw FITS missing"
  exit 1
fi
pass fixture_present

# 2. Fixture name == sha256 (our C tool and coreutils sha256sum must agree).
c=$("$BIN/lrd_sha256" "$RAW" | cut -d' ' -f1)
if command -v sha256sum >/dev/null; then
  s=$(sha256sum "$RAW" | cut -d' ' -f1)
  [ "$c" = "$SHA" ] && [ "$s" = "$SHA" ] && pass checksum_fixture_matches_raw_id \
    || fail checksum_fixture_matches_raw_id "lrd_sha256=$c sha256sum=$s name=$SHA"
else
  [ "$c" = "$SHA" ] && pass checksum_fixture_matches_raw_id || fail checksum_fixture_matches_raw_id "lrd_sha256=$c"
fi

# 3. Size matches the size MAST reported for the product.
ms=$(sed -n 's/^mast.size_reported=//p' "$D/source.kv"); as=$(wc -c < "$RAW" | tr -d ' ')
[ "$ms" = "$as" ] && pass size_matches_mast_metadata || fail size_matches_mast_metadata "mast=$ms actual=$as"

# 4. A single flipped byte is detected loudly by the offline pipeline.
mkdir -p "$T/root/fixtures/raw" "$T/root/build/out" "$T/root/ingest"
cp -R ingest/. "$T/root/ingest/"; cp -R fixtures/ingest "$T/root/fixtures/"
ln -s "$BIN" "$T/root/build/out/bin"
cp "$RAW" "$T/root/$RAW"; chmod u+w "$T/root/$RAW"
printf 'X' | dd of="$T/root/$RAW" bs=1 seek=5000 conv=notrunc 2>/dev/null
if LRD_OFFLINE=1 LRD_SHA="$SHA" sh "$T/root/ingest/lrd_ingest.sh" >"$T/tamper.out" 2>"$T/tamper.err"; then
  fail checksum_mismatch_fails_loudly "tampered fixture was accepted"
elif grep -q 'CHECKSUM MISMATCH' "$T/tamper.err"; then pass checksum_mismatch_fails_loudly
else fail checksum_mismatch_fails_loudly "nonzero exit but no CHECKSUM MISMATCH message"; fi

# 5. Header extraction: CFITSIO values equal the raw 80-char primary header cards.
mkdir -p "$T/x"
if "$BIN/lrd_fitsx" "$RAW" "$T/x" "$SHA" 2>"$T/x.err"; then
  ok=1; why=""
  for k in CAL_VER CRDS_CTX INSTRUME GRATING FILTER DATE-OBS TARGNAME; do
    card=$(head -c 2880000 "$RAW" | fold -w 80 | grep -a -m1 "^$(printf '%-8s' "$k")= ")
    raw=$(printf '%s' "$card" | cut -c11- | sed "s/ \/.*//; s/^ *'//; s/' *$//; s/ *$//")
    got=$(sed -n "s/^hdr\.$k=//p" "$T/x/header.kv")
    [ -n "$card" ] && [ "$raw" = "$got" ] || { ok=0; why="$why $k(raw='$raw' got='$got')"; }
  done
  [ $ok = 1 ] && pass header_keywords_match_raw_cards || fail header_keywords_match_raw_cards "$why"
  ok=1; why=""
  for k in "hdr.SRCRA" "hdr.SRCDEC" "col.WAVELENGTH.tunit" "col.FLUX.tunit" "col.FLUX_ERROR.tunit" "hdr.BUNIT"; do
    grep -q "^$k=" "$T/x/header.kv" || { ok=0; why="$why $k"; }
  done
  [ $ok = 1 ] && pass header_required_fields_present || fail header_required_fields_present "missing:$why"
  cmp -s "$T/x/header.kv" "$D/header.kv" && pass header_extraction_reproducible \
    || fail header_extraction_reproducible "differs from committed header.kv"
else
  fail header_extraction "lrd_fitsx failed: $(tail -1 "$T/x.err")"
fi

# 6. LRD-ARR-v1 arrays: required keys, length*8 == bytes, length == table rows.
nr=$(sed -n 's/^table.nrows=//p' "$D/header.kv"); ok=1; why=""
for a in wavelength flux flux_error; do
  h="$D/$a.hdr"
  for k in format name length unit; do grep -q "^$k=" "$h" || { ok=0; why="$why $a:$k"; }; done
  grep -qx 'format=LRD-ARR-v1' "$h" || { ok=0; why="$why $a:format"; }
  grep -qx "source_sha256=$SHA" "$h" || { ok=0; why="$why $a:source_sha256"; }
  len=$(sed -n 's/^length=//p' "$h"); by=$(wc -c < "$D/$a.f64" | tr -d ' ')
  [ "$len" = "$nr" ] && [ $((len*8)) = "$by" ] || { ok=0; why="$why $a:len=$len,bytes=$by,rows=$nr"; }
  cmp -s "$T/x/$a.f64" "$D/$a.f64" || { ok=0; why="$why $a:not-reproducible"; }
done
[ $ok = 1 ] && pass lrd_arr_v1_arrays || fail lrd_arr_v1_arrays "$why"

# 7. LRD-REC-v1 serialization and commitment against a hand-derived vector.
printf 'b=2\na=1\n' | "$BIN/lrd_rec" "$T/r.rec" > "$T/r.commit"
printf 'LRD-REC-v1\n1:a1:1\n1:b1:2\n' > "$T/r.expect"
exp=$( { printf 'LRD-COMMIT-v1\000'; cat "$T/r.expect"; } | sha256sum | cut -d' ' -f1)
cmp -s "$T/r.rec" "$T/r.expect" && [ "$(cat "$T/r.commit")" = "$exp" ] \
  && pass lrd_rec_v1_vector || fail lrd_rec_v1_vector "serialization or commitment mismatch"
if printf 'a=1\na=2\n' | "$BIN/lrd_rec" "$T/d.rec" >/dev/null 2>&1; then fail lrd_rec_v1_rejects_duplicates "accepted"
else pass lrd_rec_v1_rejects_duplicates; fi
mc=$(sed -n 's/^//p' "$D/manifest.commit")
rc=$("$BIN/lrd_rec" "$T/m.rec" < "$D/manifest.kv")
[ "$mc" = "$rc" ] && cmp -s "$T/m.rec" "$D/manifest.rec" && pass manifest_commitment_reproducible \
  || fail manifest_commitment_reproducible "committed=$mc recomputed=$rc"

# 8. Fetcher refuses to touch the network in offline mode.
LRD_OFFLINE=1 "$BIN/lrd_fetch" "https://mast.stsci.edu/" "$T/never" >/dev/null 2>&1; r=$?
[ $r = 3 ] && [ ! -e "$T/never" ] && pass offline_fetch_refused || fail offline_fetch_refused "exit $r"

# 9. Range resume: truncated partial + resume reproduces the exact sha256 (file:// URL, no network).
head -c 1000000 "$RAW" > "$T/part"
res=$("$BIN/lrd_fetch" "file://$ROOT/$RAW" "$T/part" "$as" 2>"$T/resume.err")
got=$(echo "$res" | sed -n 's/^sha256=//p')
[ "$got" = "$SHA" ] && grep -q 'resuming at byte 1000000' "$T/resume.err" && pass range_resume_reproduces_sha256 \
  || fail range_resume_reproduces_sha256 "got=$got"

# 10. Offline replay with network namespace removed (proves zero network calls).
if unshare -rn true 2>/dev/null; then
  if unshare -rn env LRD_OFFLINE=1 sh ingest/lrd_ingest.sh >"$T/replay.out" 2>"$T/replay.err" \
     && grep -q '^OFFLINE_REPLAY_OK' "$T/replay.out"; then pass offline_replay_no_network
  else fail offline_replay_no_network "$(tail -1 "$T/replay.err")"; fi
else
  unav offline_replay_no_network "unshare -rn not permitted on this host"
  if LRD_OFFLINE=1 sh ingest/lrd_ingest.sh >"$T/replay.out" 2>"$T/replay.err"; then pass offline_replay
  else fail offline_replay "$(tail -1 "$T/replay.err")"; fi
fi
[ "$FAILS" -eq 0 ]
