#!/usr/bin/env bash
# SPDX-License-Identifier: AGPL-3.0-only
# Compile all Erlang sources with erlc (no rebar3 needed).
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p ebin ebin_test
erlc +warnings_as_errors -o ebin src/*.erl
erlc -o ebin_test test/*.erl
echo "build ok"
