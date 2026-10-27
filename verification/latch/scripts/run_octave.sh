#!/usr/bin/env bash
# SPDX-License-Identifier: AGPL-3.0-only
# Octave (NOT MATLAB) evidence producer. Revision = HEAD of /workspace/jwst-lrd (read-only query).
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p run
REV=${REV:-$(git -C /workspace/jwst-lrd rev-parse HEAD)}
echo "== Octave checks (Octave, NOT MATLAB) =="
octave --no-gui --quiet --path octave --eval "test_evidence()"
echo "== evidence production for revision $REV =="
octave --no-gui --quiet --path octave --eval "rz_evidence('data/redshift_inputs.txt','$REV',1,'run/octave_events.ndjson')"
