#!/bin/sh
# SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
set -eu
ROOT=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
OUT="$ROOT/build/out/live-test"
mkdir -p "$OUT"
BASE=http://127.0.0.1:8765
curl -fsS "$BASE/health" > "$OUT/health.json"
grep -q '"fresh":true' "$OUT/health.json"
echo 'PASS live_native_renderer_fresh'
curl -fsS "$BASE/live/" > "$OUT/page.html"
TOKEN=$(sed -n "s/.*name=token value='\([^']*\)'.*/\1/p" "$OUT/page.html")
[ "${#TOKEN}" -eq 32 ]
STATUS=$(curl -sS -o "$OUT/rejected.txt" -w '%{http_code}' --data 'token=invalid&action=phase' "$BASE/action")
[ "$STATUS" = 403 ]
echo 'PASS live_rejects_invalid_session_token'
STATUS=$(curl -sS -o "$OUT/rejected.txt" -w '%{http_code}' --data "token=$TOKEN&action=execute" "$BASE/action")
[ "$STATUS" = 403 ]
echo 'PASS live_rejects_arbitrary_action'
STATUS=$(curl -sS -o "$OUT/ack" -w '%{http_code}' --data "token=$TOKEN&action=phase" "$BASE/action")
[ "$STATUS" = 204 ]
echo 'PASS live_action_reaches_self_fifo'
curl -sS --max-time 2 "$BASE/stream.mjpg" > "$OUT/stream.multipart" 2> "$OUT/curl.log" || [ "$?" = 28 ]
ffmpeg -hide_banner -loglevel error -f mpjpeg -i "$OUT/stream.multipart" -frames:v 4 -f framemd5 -y "$OUT/frames.md5"
N=$(grep -v '^#' "$OUT/frames.md5" | awk -F, '{gsub(/ /,"",$6); print $6}' | sort -u | wc -l)
[ "$N" -gt 1 ]
echo 'PASS live_stream_has_distinct_native_frames'
sleep 1
STATUS=$(curl -sS -o "$OUT/ack" -w '%{http_code}' --data "token=$TOKEN&action=play" "$BASE/action")
[ "$STATUS" = 204 ]
sleep 1
RUN=$(cat "$ROOT/build/out/live/session.path")
FIRST=$(sha256sum "$RUN/frame.jpg" | cut -d' ' -f1)
sleep 1
SECOND=$(sha256sum "$RUN/frame.jpg" | cut -d' ' -f1)
[ "$FIRST" = "$SECOND" ]
echo 'PASS live_pause_stops_morphic_animation'
STATUS=$(curl -sS -o "$OUT/ack" -w '%{http_code}' --data "token=$TOKEN&action=phase" "$BASE/action")
[ "$STATUS" = 204 ]
sleep 1
THIRD=$(sha256sum "$RUN/frame.jpg" | cut -d' ' -f1)
[ "$THIRD" != "$SECOND" ]
echo 'PASS live_control_changes_paused_native_frame'
STATUS=$(curl -sS -o "$OUT/ack" -w '%{http_code}' --data "token=$TOKEN&action=play" "$BASE/action")
[ "$STATUS" = 204 ]
sleep 1
FOURTH=$(sha256sum "$RUN/frame.jpg" | cut -d' ' -f1)
[ "$FOURTH" != "$THIRD" ]
echo 'PASS live_resume_restarts_morphic_animation'
