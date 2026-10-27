#!/usr/bin/env bash
# SPDX-License-Identifier: AGPL-3.0-only
# usage: scripts/lc.sh <latch_ctl command and args...>
cd "$(dirname "$0")/.."
exec erl -noshell -pa ebin -eval 'latch_ctl:main()' -extra "$@"
