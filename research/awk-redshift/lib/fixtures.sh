#!/usr/bin/env bash
# SPDX-License-Identifier: AGPL-3.0-only
# fixtures.sh -- sourced by lib/prep.sh and test.sh. Sets SRC to the fixtures directory.
# Order: $SRC (explicit override) > <repo root>/fixtures (this directory is research/awk-redshift/)
#        > $LRD_SHARED/fixtures (LRD_SHARED = a jwst-lrd checkout root). Read-only.
_FX_HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
if [ -z "${SRC:-}" ]; then
  if [ -f "$_FX_HERE/../../fixtures/ingest/CURRENT" ]; then SRC="$(cd "$_FX_HERE/../../fixtures" && pwd)"
  elif [ -n "${LRD_SHARED:-}" ] && [ -f "$LRD_SHARED/fixtures/ingest/CURRENT" ]; then SRC="$LRD_SHARED/fixtures"
  else echo "FATAL: fixtures not found: no <repo root>/fixtures/ingest/CURRENT and LRD_SHARED unset/invalid (or set SRC=/path/to/fixtures)" >&2; exit 1
  fi
fi
