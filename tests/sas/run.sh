#!/bin/bash
# SPDX-License-Identifier: AGPL-3.0-only
# Also licensed under the SnapKitty Opaque License; see LICENSE and
# SNAPKITTY_OPAQUE_LICENSE.md at the repository root.
# tests/sas/run.sh - role 09 independent validation (SAS track).
# SAS is licensed and is not installed on the repo host or the CI VM:
# the section reports UNAVAILABLE wherever no SAS runtime exists
# (mission role 09). The deliverable is the source program
# sas/validate_growth.sas.
set -u
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT"
RC=0
if command -v sas >/dev/null 2>&1; then
  LOG="$(mktemp)"
  if sas -sysin "$ROOT/sas/validate_growth.sas" -log "$LOG" -print /dev/null; then
    grep -E "^(PASS|FAIL|INFO) sas\." "$LOG" || true
    grep -q "^FAIL sas\." "$LOG" && RC=1
    grep -q "^PASS sas.benchmark_seed_window" "$LOG" || RC=1
  else
    echo "FAIL sas.growth_validation sas_exit_nonzero"
    RC=1
  fi
  rm -f "$LOG"
else
  echo "UNAVAILABLE sas.growth_validation reason=sas_not_installed_licensed"
fi
exit $RC
