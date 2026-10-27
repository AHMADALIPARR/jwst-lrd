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

# 6b. Pixel/array counts declared for the c0b87857 fixture (BLOCKERS.md (d) criterion 1); each line prints
#     expected=<n> got=<m> in PASS and FAIL. The fixture bytes are never modified (see fixtures_sha256_unchanged).
if [ "$SHA" = c0b878576d7d7ec723c5ee526d29715fb672d81e45bc8ba4e02598ce8b9c5ee7 ]; then
  cnt() { if [ "$3" = "$2" ]; then pass "$1 expected=$2 got=$3"; else fail "$1" "expected=$2 got=$3"; fi; }
  cnt ingest_pixel_count 429 "$nr"
  cnt ingest_array_f64_count 3 "$(ls "$D"/*.f64 | wc -l | tr -d ' ')"
  for a in wavelength flux flux_error; do cnt "ingest_array_${a}_elements" 429 $(( $(wc -c < "$D/$a.f64" | tr -d ' ') / 8 )); done
else
  unav ingest_pixel_count "no declared expected counts for $SHA"
fi

# 6c. Observations preserved exactly: every file under fixtures/ (raw FITS, LRD-ARR arrays, manifests, reference
#     outputs, state) hashes to the value in fixtures/FIXTURES.sha256, and no file is missing or unlisted.
MF=fixtures/FIXTURES.sha256
if [ ! -f "$MF" ]; then fail fixtures_sha256_unchanged "$MF missing"; else
  grep -v '^#' "$MF" | sed 's/^[0-9a-f]*  //' | LC_ALL=C sort > "$T/mf.paths"
  find fixtures -type f ! -path "$MF" | LC_ALL=C sort > "$T/fs.paths"
  bad=""; n=0
  while read -r h p; do
    n=$((n+1)); g=$("$BIN/lrd_sha256" "$p" 2>/dev/null | cut -d' ' -f1)
    [ "$g" = "$h" ] || bad="$bad $p"
  done <<EOM
$(grep -v '^#' "$MF")
EOM
  extra=$(comm -13 "$T/mf.paths" "$T/fs.paths" | tr '\n' ' '); missing=$(comm -23 "$T/mf.paths" "$T/fs.paths" | tr '\n' ' ')
  if [ "$n" = 67 ] && [ -z "$bad" ] && [ -z "$extra" ] && [ -z "$missing" ]; then
    pass "fixtures_sha256_unchanged expected=67 got=$n"
  else
    fail fixtures_sha256_unchanged "expected=67 got=$n changed:[$bad] unlisted:[$extra] missing:[$missing]"
  fi
fi

# 6d. run_all.sh counts OPEN (and FAIL-EXPECTED/OPEN) separately from PASS/FAIL/UNAVAILABLE; OPEN never fails.
mkdir -p "$T/rt/o1"
printf '#!/bin/sh\necho "PASS SYNTHETIC_p"\necho "OPEN SYNTHETIC_o note"\necho "FAIL-EXPECTED/OPEN SYNTHETIC_s note"\nexit 0\n' > "$T/rt/o1/run.sh"; chmod +x "$T/rt/o1/run.sh"
LRD_TESTS_DIR="$T/rt" LRD_TEST_LOGS="$T/rt.logs" sh tests/run_all.sh > "$T/rt.out" 2>&1; r=$?
[ $r = 0 ] && grep -q '^== TOTAL: 1 PASS, 0 FAIL, 0 UNAVAILABLE, 2 OPEN$' "$T/rt.out" \
  && pass runner_counts_open_separately || fail runner_counts_open_separately "exit $r: $(tail -1 "$T/rt.out")"

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

# 11. Pointing check: for every stored product, read RA/DEC from the x1d EXTRACT1D (SCI)
# header via CFITSIO (SRCRA/SRCDEC, else RA_TARG/DEC_TARG), compute the great-circle
# separation (haversine) from the cited target position in ingest/target.conf and FAIL if it
# exceeds the discovery cone radius. Measured separations go to build/out/ingest/separations.txt.
. ingest/target.conf
sex2deg() { echo "$1" | awk -F: -v k="$2" '{s=1; a=$1; if (substr(a,1,1)=="-") {s=-1; a=substr(a,2)}
  printf "%.10f\n", s*k*(a + $2/60 + $3/3600)}'; }
TRA=$(sex2deg "$TARGET_RA_SEX" 15); TDEC=$(sex2deg "$TARGET_DEC_SEX" 1)
mkdir -p build/out/ingest; : > build/out/ingest/separations.txt
for d in fixtures/ingest/*/; do
  [ -f "$d/source.kv" ] || continue
  s=$(basename "$d"); mkdir -p "$T/sep/$s"
  if ! "$BIN/lrd_fitsx" "fixtures/raw/$s.fits" "$T/sep/$s" "$s" 2>/dev/null; then
    fail "pointing_within_cone_$s" "lrd_fitsx failed"; continue; fi
  kv="$T/sep/$s/header.kv"
  ra=$(sed -n 's/^hdr.SRCRA=//p' "$kv"); de=$(sed -n 's/^hdr.SRCDEC=//p' "$kv"); src="SRCRA/SRCDEC"
  if [ "$ra" = ABSENT ] || [ -z "$ra" ]; then
    ra=$(sed -n 's/^hdr.RA_TARG=//p' "$kv"); de=$(sed -n 's/^hdr.DEC_TARG=//p' "$kv"); src="RA_TARG/DEC_TARG"; fi
  if [ "$ra" = ABSENT ] || [ -z "$ra" ]; then fail "pointing_within_cone_$s" "no RA/DEC keywords"; continue; fi
  line=$(awk -v r1="$TRA" -v d1="$TDEC" -v r2="$ra" -v d2="$de" -v rad="$CONE_RADIUS_DEG" 'BEGIN{
    p=atan2(0,-1)/180; a=sin((d2-d1)*p/2)^2 + cos(d1*p)*cos(d2*p)*sin((r2-r1)*p/2)^2
    sep=2*atan2(sqrt(a),sqrt(1-a))/p; printf "%.6f %s", sep*3600, (sep<=rad?"OK":"OUT") }')
  sep=${line% *}; verdict=${line#* }
  fn=$(sed -n 's/^mast.product_filename=//p' "$d/source.kv")
  echo "$s $fn $src ra=$ra dec=$de sep_arcsec=$sep cone_arcsec=$(awk -v r="$CONE_RADIUS_DEG" 'BEGIN{printf "%.3f", r*3600}')" >> build/out/ingest/separations.txt
  [ "$verdict" = OK ] && pass "pointing_within_cone_$s" || fail "pointing_within_cone_$s" "separation ${sep}\" > cone"
done

# 12. LRD-STATE-v1 observation chain (fixtures/state/observation, ledger/abi/lrd_state.h).
SD=fixtures/state/observation
if [ ! -f "$SD/HEAD" ]; then fail obs_chain_present "missing $SD/HEAD"; else
  pass obs_chain_present
  # (a) reproducible from the stored fixtures
  if sh ingest/emit_obs_chain.sh "$T/chain" >/dev/null 2>"$T/chain.err"; then
    ok=1; for f in "$SD"/*; do cmp -s "$f" "$T/chain/$(basename "$f")" || { ok=0; why="$why $(basename "$f")"; }; done
    [ $ok = 1 ] && pass obs_chain_reproducible || fail obs_chain_reproducible "differs:$why"
  else fail obs_chain_reproducible "$(tail -1 "$T/chain.err")"; fi
  # (b) independent check with the lrd_rec serializer: new_commit = commit{commit,kind,payload_sha256,seq},
  #     state.commit = previous new_commit (64 zeros at genesis), seq = prev + 1, decision ACCEPT/ok.
  field() { grep -a "^[0-9]*:$2[0-9]*:" "$1" | sed "s/^[0-9]*:$2[0-9]*://"; }
  prev=0000000000000000000000000000000000000000000000000000000000000000; pseq=0; ok=1; why=""
  for s in "$SD"/[0-9][0-9][0-9][0-9].state.rec; do
    n=$(basename "$s" .state.rec); p="$SD/$n.proposal.rec"; d="$SD/$n.decision.rec"
    c=$(field "$s" commit); k=$(field "$s" kind); pl=$(field "$s" payload_sha256); q=$(field "$s" seq)
    nc=$(printf 'commit=%s\nkind=%s\npayload_sha256=%s\nseq=%s\n' "$c" "$k" "$pl" "$q" | "$BIN/lrd_rec" "$T/s.rec")
    cmp -s "$T/s.rec" "$s" || { ok=0; why="$why $n:state-bytes"; }
    [ "$nc" = "$(field "$d" new_commit)" ] || { ok=0; why="$why $n:new_commit"; }
    [ "$(field "$d" decision)" = ACCEPT ] && [ "$(field "$d" reason)" = ok ] || { ok=0; why="$why $n:decision"; }
    [ "$c" = "$prev" ] && [ "$(field "$p" prev_commit)" = "$prev" ] || { ok=0; why="$why $n:prev"; }
    [ "$q" = $((pseq+1)) ] && [ "$(field "$p" seq)" = "$q" ] || { ok=0; why="$why $n:seq"; }
    [ "$k" = observation ] && [ "$(field "$p" payload_sha256)" = "$pl" ] && [ -f "fixtures/raw/$pl.fits" ] || { ok=0; why="$why $n:payload"; }
    [ "$(field "$p" obs_manifest_commit)" = "$(cat "fixtures/ingest/$pl/manifest.commit")" ] || { ok=0; why="$why $n:manifest"; }
    prev=$nc; pseq=$q
  done
  [ "$prev" = "$(cat "$SD/HEAD")" ] || { ok=0; why="$why HEAD"; }
  [ $ok = 1 ] && pass obs_chain_commitments_independent || fail obs_chain_commitments_independent "$why"
  # (c) flags: o002 provenance-only and flagged; o006 primary
  [ "$(field "$SD/0001.proposal.rec" payload_sha256)" = 09bcd9077647ebf4fdaa766807de832bf6a94b92e3ed73fdb8a3c0281ae50c31 ] \
    && [ "$(field "$SD/0001.proposal.rec" obs_science_use)" = provenance_only ] \
    && [ "$(field "$SD/0001.proposal.rec" obs_quality_flag)" = flux_globally_negative ] \
    && [ "$(field "$SD/0002.proposal.rec" payload_sha256)" = c0b878576d7d7ec723c5ee526d29715fb672d81e45bc8ba4e02598ce8b9c5ee7 ] \
    && [ "$(field "$SD/0002.proposal.rec" obs_science_use)" = primary ] \
    && pass obs_chain_flags || fail obs_chain_flags "science_use/quality flags not as planned"
  # (d) rejections construct no state
  rej() { # name expected-reason cur proposal
    rm -f "$T/rj.state"
    out=$("$BIN/lrd_obs" apply fixtures "$3" "$4" "$T/rj.dec" "$T/rj.state"); r=$?
    if [ $r = 1 ] && [ ! -e "$T/rj.state" ] && [ "$(field "$T/rj.dec" reason)" = "$2" ] && [ "$(field "$T/rj.dec" decision)" = REJECT ] \
       && ! grep -aq new_commit "$T/rj.dec"; then pass "$1"; else fail "$1" "exit $r: $out"; fi
  }
  rej obs_reject_stale_seq stale_seq genesis "$SD/0002.proposal.rec"
  rej obs_reject_replay_stale_seq stale_seq "$SD/0002.state.rec" "$SD/0002.proposal.rec"
  mkprop() { # cur payload out [field overrides on stdin]
    "$BIN/lrd_obs" propose "$1" "$2" "$3"; }
  base() { printf 'obs_manifest_commit=%s\nobs_mast_obsid=230168921\nobs_product=x1d.fits\nobs_quality_flag=none\nobs_science_use=primary\n' \
           "$(cat fixtures/ingest/c0b878576d7d7ec723c5ee526d29715fb672d81e45bc8ba4e02598ce8b9c5ee7/manifest.commit)"; }
  base | mkprop genesis c0b878576d7d7ec723c5ee526d29715fb672d81e45bc8ba4e02598ce8b9c5ee7 "$T/p_ok.rec"
  # bad_prev: correct seq for cur=0001 (seq 2) but prev_commit of genesis
  sed 's/^3:seq1:1$/3:seq1:2/' "$T/p_ok.rec" > "$T/p_badprev.rec"
  rej obs_reject_bad_prev bad_prev "$SD/0001.state.rec" "$T/p_badprev.rec"
  base | mkprop genesis 1111111111111111111111111111111111111111111111111111111111111111 "$T/p_nopl.rec"
  rej obs_reject_bad_payload_missing_raw bad_payload genesis "$T/p_nopl.rec"
  printf 'obs_manifest_commit=%s\nobs_mast_obsid=230168921\nobs_product=x1d.fits\nobs_quality_flag=none\nobs_science_use=primary\n' \
    2222222222222222222222222222222222222222222222222222222222222222 | mkprop genesis c0b878576d7d7ec723c5ee526d29715fb672d81e45bc8ba4e02598ce8b9c5ee7 "$T/p_man.rec"
  rej obs_reject_bad_payload_manifest bad_payload genesis "$T/p_man.rec"
  sed 's/^4:kind11:observation$/4:kind9:air_proof/' "$T/p_ok.rec" > "$T/p_kind.rec"
  rej obs_reject_wrong_kind wrong_kind genesis "$T/p_kind.rec"
  base | grep -v obs_science_use | mkprop genesis c0b878576d7d7ec723c5ee526d29715fb672d81e45bc8ba4e02598ce8b9c5ee7 "$T/p_mal.rec"
  rej obs_reject_malformed_missing_field malformed genesis "$T/p_mal.rec"
  sed 's/^3:seq1:1$/3:seq2:01/' "$T/p_ok.rec" > "$T/p_lz.rec"
  rej obs_reject_malformed_noncanonical malformed genesis "$T/p_lz.rec"
  # (e) the valid control proposal is accepted
  if "$BIN/lrd_obs" apply fixtures genesis "$T/p_ok.rec" "$T/ok.dec" "$T/ok.state" >/dev/null && [ -f "$T/ok.state" ]; then
    pass obs_accept_control; else fail obs_accept_control "valid proposal rejected: $(tr '\n' ' ' < "$T/ok.dec")"; fi
fi
[ "$FAILS" -eq 0 ]
