#!/bin/sh
# SPDX-License-Identifier: AGPL-3.0-only
# Also subject to SNAPKITTY_OPAQUE_LICENSE.md (dual license, see repository root).
#
# tests/runner: tests for tests/run_all.sh using SYNTHETIC fixture suites in a temp dir.
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
T=$(mktemp -d "${TMPDIR:-/tmp}/lrd-runner-test.XXXXXX")
trap 'rm -rf "$T"' EXIT
FAILS=0
pass() { echo "PASS $1"; }
fail() { echo "FAIL $1 $2"; FAILS=$((FAILS+1)); }
run() { LRD_TESTS_DIR="$1" LRD_TEST_LOGS="$T/logs" sh "$ROOT/tests/run_all.sh" > "$2" 2>&1; echo $?; }
if ! command -v bash >/dev/null 2>&1; then echo "UNAVAILABLE runner_bash_suites bash not installed"; exit 0; fi

# A bash-only suite (uses [[ ]] and process substitution, which dash rejects).
mk_bash() { mkdir -p "$1"; cat > "$1/run.sh" <<'S'
#!/usr/bin/env bash
x=abc
if [[ $x == a* ]]; then while read -r l; do echo "PASS SYNTHETIC_bash_$l"; done < <(printf 'one\ntwo\n'); fi
S
}
mk_bash "$T/a/bashsuite"; chmod +x "$T/a/bashsuite/run.sh"
r=$(run "$T/a" "$T/a.out")
[ "$r" = 0 ] && grep -q '^PASS SYNTHETIC_bash_two$' "$T/a.out" && grep -q '2 PASS, 0 FAIL' "$T/a.out" \
  && pass runner_executes_bash_suite_via_shebang || fail runner_executes_bash_suite_via_shebang "exit $r: $(tail -1 "$T/a.out")"

mk_bash "$T/b/bashsuite"; chmod -x "$T/b/bashsuite/run.sh"
r=$(run "$T/b" "$T/b.out")
[ "$r" = 0 ] && grep -q '2 PASS, 0 FAIL' "$T/b.out" \
  && pass runner_non_executable_uses_shebang_interpreter || fail runner_non_executable_uses_shebang_interpreter "exit $r: $(tail -1 "$T/b.out")"

mkdir -p "$T/c/silent"; printf '#!/bin/sh\necho hello\nexit 0\n' > "$T/c/silent/run.sh"; chmod +x "$T/c/silent/run.sh"
r=$(run "$T/c" "$T/c.out")
[ "$r" != 0 ] && grep -q '^FAIL silent/run.sh printed no PASS/FAIL/UNAVAILABLE line' "$T/c.out" \
  && pass runner_silent_suite_is_fail || fail runner_silent_suite_is_fail "exit $r"

mkdir -p "$T/d/crash"; printf '#!/bin/sh\nexit 3\n' > "$T/d/crash/run.sh"; chmod +x "$T/d/crash/run.sh"
r=$(run "$T/d" "$T/d.out")
[ "$r" != 0 ] && grep -q '^FAIL crash/run.sh' "$T/d.out" && pass runner_nonzero_no_lines_is_fail || fail runner_nonzero_no_lines_is_fail "exit $r"

mkdir -p "$T/e/bad"; printf '#!/bin/sh\necho "PASS SYNTHETIC_x"\nexit 4\n' > "$T/e/bad/run.sh"; chmod +x "$T/e/bad/run.sh"
r=$(run "$T/e" "$T/e.out")
[ "$r" != 0 ] && grep -q '^FAIL bad/run.sh exited 4 without a FAIL line' "$T/e.out" \
  && pass runner_nonzero_without_fail_line_is_fail || fail runner_nonzero_without_fail_line_is_fail "exit $r"

mkdir -p "$T/f/ok"; printf '#!/bin/sh\necho "UNAVAILABLE SYNTHETIC_y licensed"\necho "FAIL SYNTHETIC_z why"\nexit 1\n' > "$T/f/ok/run.sh"; chmod +x "$T/f/ok/run.sh"
r=$(run "$T/f" "$T/f.out")
[ "$r" != 0 ] && grep -q '0 PASS, 1 FAIL, 1 UNAVAILABLE' "$T/f.out" && pass runner_counts_fail_and_unavailable \
  || fail runner_counts_fail_and_unavailable "exit $r: $(tail -1 "$T/f.out")"
[ "$FAILS" -eq 0 ]
