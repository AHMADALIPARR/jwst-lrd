#!/bin/sh
# SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
set -eu
ROOT=$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)
: "${SELF_BIN:?Set SELF_BIN to the X11-enabled Self executable}"
: "${SELF_OBJECTS:?Set SELF_OBJECTS to its matching objects directory}"
OUT="$ROOT/build/out/live"
mkdir -p "$OUT"
RUN=$(mktemp -d /tmp/lrd-live.XXXXXX)
printf '%s\n' "$RUN" > "$OUT/session.path"
cp -R "$ROOT/self" "$ROOT/fixtures" "$RUN/"
mkdir -p "$RUN/tests/morphic/evidence"
cp "$ROOT/tests/morphic/evidence/proofs.rec" "$RUN/tests/morphic/evidence/"
cc -std=c17 -O2 -Wall -Wextra -Werror -pthread \
  "$ROOT/self/experiment/transport/live_bridge.c" -o "$RUN/live_bridge"
D=
for N in $(seq 200 219); do
  if [ ! -e "/tmp/.X$N-lock" ] && [ ! -S "/tmp/.X11-unix/X$N" ]; then D=":$N"; break; fi
done
[ -n "$D" ] || { echo 'No free X display'; exit 1; }
XPID= SPID= FPID= HPID=
cleanup() {
  for P in "$HPID" "$FPID" "$SPID" "$XPID"; do
    [ -z "$P" ] || kill "$P" 2>/dev/null || true
  done
}
trap cleanup EXIT HUP INT TERM
Xvfb "$D" -screen 0 1460x1020x24 -nolisten tcp > "$OUT/xvfb.log" 2>&1 &
XPID=$!
mkfifo "$RUN/self.input"
(cd "$SELF_OBJECTS" && DISPLAY="$D" LRD_ROOT="$RUN" exec "$SELF_BIN" \
  -f worldBuilder.self -b . -o morphic -f2 "$RUN/self/experiment/live.self" < "$RUN/self.input") > "$OUT/self.log" 2>&1 &
SPID=$!
exec 7>"$RUN/self.input"
wait_marker() {
  COUNT=0
  while ! grep -aq "$1" "$OUT/self.log"; do
    COUNT=$((COUNT+1))
    if [ "$COUNT" -gt 120 ] || ! kill -0 "$SPID" 2>/dev/null || grep -aqE 'Self VM error:|error --' "$OUT/self.log"; then
      tail -30 "$OUT/self.log"; exit 1
    fi
    sleep 1
  done
}
wait_marker 'Scheduler started'
printf '%s\n' 'lrdWorkspace openLive' >&7
wait_marker 'LRD_LIVE_OPEN'
ffmpeg -nostdin -hide_banner -loglevel warning -f x11grab -draw_mouse 0 -framerate 8 \
  -video_size 1460x1020 -i "$D" -vf format=yuvj420p -q:v 4 \
  -update 1 -atomic_writing 1 -y "$RUN/frame.jpg" > "$OUT/frames.log" 2>&1 &
FPID=$!
COUNT=0
while [ ! -s "$RUN/frame.jpg" ]; do
  COUNT=$((COUNT+1)); [ "$COUNT" -lt 30 ] || { cat "$OUT/frames.log"; exit 1; }
  sleep 1
done
"$RUN/live_bridge" "$RUN/frame.jpg" "$RUN/self.input" > "$OUT/http.log" 2>&1 &
HPID=$!
printf 'SELF_PID=%s\nDISPLAY=%s\nHTTP_PID=%s\nFRAME_PID=%s\nXVFB_PID=%s\n' "$SPID" "$D" "$HPID" "$FPID" "$XPID" > "$RUN/processes"
echo "Live native Self route: http://127.0.0.1:8765/live/"
while kill -0 "$SPID" 2>/dev/null && kill -0 "$FPID" 2>/dev/null && kill -0 "$HPID" 2>/dev/null; do sleep 5; done
echo 'A live renderer component stopped.'
exit 1
