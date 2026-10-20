#!/bin/bash
# SPDX-License-Identifier: AGPL-3.0-only
# Also licensed under the SnapKitty Opaque License; see LICENSE and
# SNAPKITTY_OPAQUE_LICENSE.md at the repository root.
# tests/matlab/run.sh - role 09 independent validation (MATLAB track).
# MATLAB is licensed and may be absent: then the section reports
# UNAVAILABLE. GNU Octave may execute the same .m sources as a logic
# check; Octave is NOT MATLAB (mission role 09), so an Octave run is
# labelled as such and is never reported as a MATLAB result.
set -u
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT"
RC=0
if command -v matlab >/dev/null 2>&1; then
  echo "INFO matlab.engine MATLAB"
  OUT="$(matlab -batch "addpath('$ROOT/matlab'); ok = validate_growth_grid(); if ~ok, exit(1); end" 2>&1)"
  echo "$OUT" | grep -E "^(PASS|FAIL|INFO) " || true
  echo "$OUT" | grep -q "^MATLAB_GROWTH_DONE" || RC=1
elif command -v octave >/dev/null 2>&1; then
  echo "INFO matlab.engine GNU Octave (NOT MATLAB)"
  OUT="$(octave --no-gui --quiet --eval "addpath('$ROOT/matlab'); ok = validate_growth_grid(); if ~ok, exit(1); end" 2>&1)"
  echo "$OUT" | grep -E "^(PASS|FAIL|INFO) " || true
  echo "$OUT" | grep -q "^MATLAB_GROWTH_DONE" || RC=1
else
  echo "UNAVAILABLE matlab.growth_validation reason=no_matlab_or_octave_runtime"
fi
exit $RC
