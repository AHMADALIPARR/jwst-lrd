#!/usr/bin/env bash
# SPDX-License-Identifier: AGPL-3.0-only
# job.sh 'NAME|octave expression'  -- run one Octave job, stdout+stderr to results/jobs/NAME.out (GNU Octave, not MATLAB).
set -u
cd "$(dirname "$0")/.."
NAME="${1%%|*}"; EXPR="${1#*|}"
octave -q --no-gui --eval "addpath('octave'); $EXPR" > "results/jobs/$NAME.out" 2>&1
echo "exit=$?" >> "results/jobs/$NAME.out"
