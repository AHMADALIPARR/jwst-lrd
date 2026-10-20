#!/bin/sh
# SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
set -eu
ROOT=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
OUT="$ROOT/build/out/growth-result"
mkdir -p "$OUT"
cc -std=c17 -O2 -Wall -Wextra -Werror -pedantic \
  "$ROOT/self/experiment/transport/growth_result.c" -lm -o "$OUT/growth_result"
"$OUT/growth_result" "$ROOT/fixtures/growth/feasible_grid.csv" \
  "$OUT/result.txt" "$OUT/result.svg" > "$OUT/test-results.txt"
cat "$OUT/test-results.txt"
# A changed scientific input must fail independent reconstruction, even though
# the changed row remains syntactically valid and positive.
awk -F, 'BEGIN {OFS=","} NR==2 {$9=$9*1.1} {print}' \
  "$ROOT/fixtures/growth/feasible_grid.csv" > "$OUT/corrupt-grid.csv"
if "$OUT/growth_result" "$OUT/corrupt-grid.csv" "$OUT/bad.txt" "$OUT/bad.svg" >/dev/null; then
  echo 'FAIL corrupted_seed_accepted'; exit 1
fi
echo 'PASS corrupted_seed_rejected' | tee -a "$OUT/test-results.txt"
head -n 1200 "$ROOT/fixtures/growth/feasible_grid.csv" > "$OUT/truncated.csv"
if "$OUT/growth_result" "$OUT/truncated.csv" "$OUT/bad.txt" "$OUT/bad.svg" >/dev/null; then
  echo 'FAIL truncated_grid_accepted'; exit 1
fi
echo 'PASS truncated_grid_rejected' | tee -a "$OUT/test-results.txt"
cat "$OUT/result.txt"
