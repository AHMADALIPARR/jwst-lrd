#!/bin/sh
# SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
set -eu
ROOT=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
: "${SELF_BIN:?Set SELF_BIN to the X11-enabled Self executable}"
: "${SELF_OBJECTS:?Set SELF_OBJECTS to its objects directory}"
EVD="$ROOT/tests/morphic/evidence"
mkdir -p "$EVD"
TMP=$(mktemp -d /tmp/lrd-morphic.XXXXXX)
SPID= XPID=
cleanup() {
  [ -z "$SPID" ] || kill "$SPID" 2>/dev/null || true
  [ -z "$XPID" ] || kill "$XPID" 2>/dev/null || true
}
trap cleanup EXIT HUP INT TERM
# The 32-bit VM's old file API cannot read some Windows drvfs inodes.
# Stage the exact checkout bytes onto Linux ext4; never rewrite fixtures.
cp -R "$ROOT/self" "$ROOT/fixtures" "$TMP/"
mkdir -p "$TMP/tests/morphic/evidence"
[ ! -f "$EVD/proofs.rec" ] || cp "$EVD/proofs.rec" "$TMP/tests/morphic/evidence/"
D=
for N in $(seq 180 199); do
  if [ ! -e "/tmp/.X$N-lock" ] && [ ! -S "/tmp/.X11-unix/X$N" ]; then D=":$N"; break; fi
done
[ -n "$D" ] || { echo 'FAIL morphic_display_unavailable'; exit 1; }
Xvfb "$D" -screen 0 1460x1020x24 -nolisten tcp > "$EVD/xvfb.log" 2>&1 &
XPID=$!
mkfifo "$TMP/input"
(
  cd "$SELF_OBJECTS"
  DISPLAY="$D" LRD_ROOT="$TMP" exec timeout -k 5 240 "$SELF_BIN" \
    -f worldBuilder.self -b . -o morphic -f2 "$TMP/self/experiment/load.self" < "$TMP/input"
) > "$EVD/gui.log" 2>&1 &
SPID=$!
exec 7>"$TMP/input"
wait_marker() {
  n=0
  while ! grep -q "$1" "$EVD/gui.log"; do
    n=$((n+1))
    if [ "$n" -gt 100 ] || ! kill -0 "$SPID" 2>/dev/null || grep -qE 'Self VM error:|error --' "$EVD/gui.log"; then
      echo "FAIL morphic_gui_missing_$1"; tail -20 "$EVD/gui.log"; exit 1
    fi
    sleep 1
  done
}
wait_marker 'Scheduler started'
printf '%s\n' 'lrdWorkspace open' >&7
wait_marker 'LRD_WORKSPACE_OPEN'
sleep 2
DISPLAY="$D" import -window root "$EVD/workspace.png"
if command -v xdotool >/dev/null; then
  DISPLAY="$D" xdotool mousemove 60 113 click 1
  sleep 1
  printf '%s\n' "(lrdWorkspace view model epsilon = 0.15) ifTrue: [ 'PASS morphic_gui_mouse_button' printLine ] False: [ 'FAIL morphic_gui_mouse_button' printLine ]. 'LRD_MOUSE_DONE' printLine" >&7
  wait_marker 'LRD_MOUSE_DONE'
fi
printf '%s\n' "lrdWorkspace view model cycleEpsilon. lrdWorkspace view model toggleModel. lrdWorkspace view model cycleTopology. lrdWorkspace view model cyclePhase. lrdWorkspace view changed. 'LRD_GUI_CHANGED' printLine" >&7
wait_marker 'LRD_GUI_CHANGED'
sleep 2
DISPLAY="$D" import -window root "$EVD/workspace-changed.png"
if grep -qE 'Self VM error:|error --|FAIL ' "$EVD/gui.log"; then
  echo 'FAIL morphic_gui_runtime_error'; exit 1
fi
[ ! -x "$(command -v xdotool 2>/dev/null)" ] || echo 'PASS morphic_gui_mouse_button'
echo 'PASS morphic_gui_open'
echo 'PASS morphic_gui_controls_update'
echo 'PASS morphic_gui_screenshots'
exec 7>&-
