#!/usr/bin/env bash
# SPDX-License-Identifier: AGPL-3.0-only
# prep.sh -- fixture resolution in the style of awk-sp/lib/prep.sh: verify sha256 of the raw FITS bytes and of the three
# LRD-ARR-v1 .f64 arrays against manifest.kv, then convert binary64 LE to text with od. Read-only on inputs.
# Writes work/spectrum.tsv (idx wl_um flux_Jy err_Jy; "nan" kept verbatim) -- the raw arrays are never edited.
# Fixture directory resolution is in lib/fixtures.sh (no hard-coded scratch path).
set -u
HERE="$(cd "$(dirname "$0")/.." && pwd)"
. "$HERE/lib/fixtures.sh"   # sets SRC: $SRC > <repo root>/fixtures > $LRD_SHARED/fixtures
SHA=c0b878576d7d7ec723c5ee526d29715fb672d81e45bc8ba4e02598ce8b9c5ee7
D="$SRC/ingest/$SHA"
OUT="$HERE/work"; mkdir -p "$OUT"
fail=0
chk() { if [ "$2" = "$3" ]; then echo "SHA-OK   $1 $2"; else echo "SHA-FAIL $1 got=$2 want=$3"; fail=1; fi; }
echo "prep: SRC=$SRC"
chk "ingest/CURRENT" "$(cat "$SRC/ingest/CURRENT" 2>/dev/null)" "$SHA"
chk "raw.fits" "$(sha256sum "$SRC/raw/$SHA.fits" | cut -d' ' -f1)" "$SHA"
for a in wavelength flux flux_error; do
  want="$(awk -F= -v k="arr.$a.sha256" '$1==k{print $2}' "$D/manifest.kv")"
  chk "$a.f64" "$(sha256sum "$D/$a.f64" | cut -d' ' -f1)" "$want"
  len="$(awk -F= '$1=="length"{print $2}' "$D/$a.hdr")"
  src="$(awk -F= '$1=="source_sha256"{print $2}' "$D/$a.hdr")"
  nb="$(wc -c < "$D/$a.f64")"
  echo "HDR $a format=$(awk -F= '$1=="format"{print $2}' "$D/$a.hdr") length=$len unit=$(awk -F= '$1=="unit"{print $2}' "$D/$a.hdr") bytes=$nb (expect $((8*len))) source_sha256_matches=$([ "$src" = "$SHA" ] && echo yes || echo NO)"
  [ "$nb" -eq $((8*len)) ] || { echo "SHA-FAIL $a byte count"; fail=1; }
  od -An -t f8 -v -w8 "$D/$a.f64" | awk '{print $1}' > "$OUT/$a.txt"
done
[ "$fail" -eq 0 ] || { echo "prep: FAILED verification; refusing to continue"; exit 1; }
paste "$OUT/wavelength.txt" "$OUT/flux.txt" "$OUT/flux_error.txt" | awk 'BEGIN{OFS="\t"}{print NR,$1,$2,$3}' > "$OUT/spectrum.tsv"
echo "prep: wrote $OUT/spectrum.tsv rows=$(wc -l < "$OUT/spectrum.tsv")"
echo "prep: sha256(work/spectrum.tsv)=$(sha256sum "$OUT/spectrum.tsv" | cut -d' ' -f1)"
