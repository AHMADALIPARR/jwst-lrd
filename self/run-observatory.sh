#!/bin/sh
# Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
# Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
# SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
#
# Launch the JWST-LRD Self/Morphic observatory on an X display and leave it running.
#   SELF_VM     Self VM binary      (default /workspace/_self_tools/build/vm/Self)
#   SELF_WORLD  Morphic snapshot    (default /workspace/_self_tools/world/morphic.snap)
#   DISPLAY     X display           (default :2)
#   LRD_ROOTS   optional space-separated worktree roots to scan
# Only the instance recorded in the pid file is replaced; other Self processes are untouched.
set -eu
HERE=$(cd "$(dirname "$0")" && pwd)
SELF_VM=${SELF_VM:-/workspace/_self_tools/build/vm/Self}
SELF_WORLD=${SELF_WORLD:-/workspace/_self_tools/world/morphic.snap}
DISPLAY=${DISPLAY:-:2}
RUN=${LRD_RUN_DIR:-/workspace/_self_tools/run}
mkdir -p "$RUN"
[ -x "$SELF_VM" ] || { echo "UNAVAILABLE Self VM not built at $SELF_VM (see self/STATUS.md)"; exit 2; }
[ -f "$SELF_WORLD" ] || { echo "UNAVAILABLE Morphic world missing at $SELF_WORLD"; exit 2; }
if [ -f "$RUN/observatory.pid" ]; then
  old=$(cat "$RUN/observatory.pid")
  if [ -n "$old" ] && tr '\0' ' ' < "/proc/$old/cmdline" 2>/dev/null | grep -q "observatory-gui.self"; then
    kill "$old" 2>/dev/null || true; sleep 1
  fi
fi
export DISPLAY LRD_SELF_DIR="$HERE"
# stdin is kept open (tail -f /dev/null) so the Self prompt does not see EOF and exit.
cd "$RUN"
nohup sh -c "tail -f /dev/null | exec \"$SELF_VM\" -s \"$SELF_WORLD\" -f \"$HERE/observatory-gui.self\"" > "$RUN/observatory.log" 2>&1 &
sleep 2
pid=$(pgrep -n -f "$HERE/observatory-gui.self" || true)
echo "$pid" > "$RUN/observatory.pid"
echo "Self observatory pid=$pid DISPLAY=$DISPLAY log=$RUN/observatory.log"
