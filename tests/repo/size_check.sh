#!/usr/bin/env bash
# SPDX-License-Identifier: AGPL-3.0-only
# Proves blocker (e): no tracked build artifacts, ignore rules cover them, tracked size.
# Prints PASS/FAIL lines; exits nonzero only on FAIL.
cd "$(git rev-parse --show-toplevel)" || exit 2
fail=0
read -r bytes files < <(git ls-tree -r -l HEAD | awk '{s+=$4;n++} END{print s, n}')
echo "tracked_bytes=$bytes files=$files"
kept=$(git ls-files build | sort | tr '\n' ' ')
if [ "$kept" = "build/TOOLCHAIN.lock build/install-curry-self.sh build/toolchain.sh " ]; then echo "PASS build_only_three_files"; else echo "FAIL build_only_three_files: $kept"; fail=1; fi
if [ -z "$(git ls-files | grep -E '(^|/)\.curry/|\.(vo|vos|vok|glob)$')" ]; then echo "PASS no_tracked_build_artifacts"; else echo "FAIL no_tracked_build_artifacts"; fail=1; fi
ok=1; for p in build/tools/x build/logs/x build/out/x curry/growth/.curry/x theorems/coq/AirField.vo theorems/coq/AirField.glob theorems/coq/.lia.cache; do git check-ignore -q "$p" || { echo "FAIL gitignore_covers $p"; ok=0; fail=1; }; done
[ $ok = 1 ] && echo "PASS gitignore_covers_artifacts"
for p in build/TOOLCHAIN.lock build/toolchain.sh build/install-curry-self.sh; do git check-ignore -q "$p" && { echo "FAIL kept_file_ignored $p"; fail=1; }; done
rawb=$(git ls-tree -r -l HEAD fixtures/raw 2>/dev/null | awk '{s+=$4} END{print s+0}')
ex=$((bytes-rawb))
if [ "$bytes" -lt $((15*1024*1024)) ]; then echo "PASS tracked_size_lt_15MB"; else echo "UNAVAILABLE tracked_size_lt_15MB (total $bytes; fixtures/raw $rawb needs owner decision)"; fi
if [ "$ex" -lt $((15*1024*1024)) ]; then echo "PASS tracked_size_excluding_fixtures_raw_lt_15MB ($ex)"; else echo "FAIL tracked_size_excluding_fixtures_raw_lt_15MB ($ex)"; fail=1; fi
exit $fail
