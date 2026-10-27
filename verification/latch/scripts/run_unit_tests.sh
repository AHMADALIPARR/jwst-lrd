#!/usr/bin/env bash
# SPDX-License-Identifier: AGPL-3.0-only
set -uo pipefail
cd "$(dirname "$0")/.."
./scripts/build.sh >/dev/null
echo "== custom runner (PASS/FAIL/UNAVAILABLE counts) =="
erl -noshell -pa ebin -pa ebin_test -eval 'latch_test_runner:main()'
rc=$?
echo "== plain eunit =="
erl -noshell -pa ebin -pa ebin_test -eval 'R = eunit:test(latch_core_tests, []), io:format("eunit result: ~p~n",[R]), halt(case R of ok -> 0; _ -> 1 end).'
exit $(( rc | $? ))
