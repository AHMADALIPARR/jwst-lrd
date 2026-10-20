#!/bin/sh
# SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
set -eu
ROOT=$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)
: "${SELF_BIN:?Set SELF_BIN to the native Self executable}"
: "${SELF_OBJECTS:?Set SELF_OBJECTS to its matching objects directory}"
OUT=${LRD_DEMO_DIR:-$ROOT/build/out/demo}
mkdir -p "$OUT"
RUN=$(mktemp -d /tmp/lrd-vector-demo.XXXXXX)
cp -R "$ROOT/self" "$ROOT/fixtures" "$RUN/"
mkdir -p "$RUN/frames" "$RUN/tests/morphic/evidence"
cp "$ROOT/tests/morphic/evidence/proofs.rec" "$RUN/tests/morphic/evidence/"
(cd "$SELF_OBJECTS" && LRD_ROOT="$RUN" LRD_DEMO_OUT="$RUN/frames" \
  timeout -k 5 600 "$SELF_BIN" -f worldBuilder.self -b . -o morphic \
  -f2 "$RUN/self/experiment/demoMain.self" < /dev/null) > "$OUT/export.log" 2>&1
grep -q LRD_VECTOR_DEMO_DONE "$OUT/export.log"
[ "$(find "$RUN/frames" -name 'frame-*.svg' | wc -l)" -eq 720 ]
ffmpeg -nostdin -hide_banner -loglevel warning -framerate 24 \
  -i "$RUN/frames/frame-%04d.svg" -c:v libx264 -preset medium -crf 14 \
  -pix_fmt yuv420p -threads 2 -movflags +faststart -t 30 -y \
  "$OUT/Self-Morphic-LRD-2D-Demo.mp4" > "$OUT/encode.log" 2>&1
ffmpeg -nostdin -hide_banner -loglevel warning -framerate 24 -width 3840 -height 2160 \
  -i "$RUN/frames/frame-%04d.svg" -c:v libx264 -preset medium -crf 14 \
  -pix_fmt yuv420p -threads 2 -movflags +faststart -t 30 -y \
  "$OUT/Self-Morphic-LRD-2D-Demo-4K.mp4" > "$OUT/encode-4k.log" 2>&1
for NAME in red-dot-detail helix-detail overview red-dot-loop; do
  cp "$RUN/frames/$NAME.svg" "$OUT/$NAME.svg"
done
ffmpeg -nostdin -hide_banner -loglevel error -i "$OUT/overview.svg" \
  -frames:v 1 -y "$OUT/demo-poster.png"
ffprobe -v error -select_streams v:0 -show_entries \
  stream=codec_name,width,height,r_frame_rate,nb_frames:format=duration,size \
  -of json "$OUT/Self-Morphic-LRD-2D-Demo.mp4" > "$OUT/video-metadata.json"
ffmpeg -nostdin -v error -i "$OUT/Self-Morphic-LRD-2D-Demo.mp4" -f null - \
  > "$OUT/decode.log" 2>&1
ffmpeg -nostdin -v error -i "$OUT/Self-Morphic-LRD-2D-Demo-4K.mp4" -f null - \
  > "$OUT/decode-4k.log" 2>&1
(cd "$OUT" && sha256sum ./*.mp4 ./*.svg demo-poster.png > SHA256SUMS)
printf '%s\n' 'PASS demo_720_self_vector_frames' 'PASS demo_standalone_mp4_decodes' \
  'PASS demo_vector_detail_exports' > "$OUT/results.txt"
cat "$OUT/results.txt"
printf 'Demo output: %s\n' "$OUT"
