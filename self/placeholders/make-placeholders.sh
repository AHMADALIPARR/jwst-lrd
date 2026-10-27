#!/bin/bash
# Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
# Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
# SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
#
# Writes SYNTHETIC PLACEHOLDER records (LRD-REC-v1 streams) used by the Self
# observatory ONLY while the mission tracks have not produced real outputs.
# Nothing here is a measurement, a model result or a literature value.  The
# grid axes are layout coordinates for the map widget; every "status" is the
# literal word PLACEHOLDER.  Every record carries synthetic=SYNTHETIC PLACEHOLDER.
set -eu
export LC_ALL=C
cd "$(dirname "$0")"

rec() { # stdin: key=value lines -> one canonical LRD-REC-v1 record on stdout
  printf 'LRD-REC-v1\n'
  sort -u | while IFS= read -r line; do
    k=${line%%=*}; v=${line#*=}
    printf '%d:%s%d:%s\n' "${#k}" "$k" "${#v}" "$v"
  done
}
S='synthetic=SYNTHETIC PLACEHOLDER - not data; replaced automatically when the owning track writes LRD files'

# (1) growth map: seed-mass vs z_form grid, every cell PLACEHOLDER
{
  printf '%s\nkind=placeholder_header\nview=growth_map\nowner=t020-growth / t022-growth-hamiltonian\nnote=axes are widget layout indices only\n' "$S" | rec
  for i in 0 1 2 3 4 5 6 7; do for j in 0 1 2 3 4 5; do
    printf '%s\nkind=placeholder_cell\nseed_index=%d\nzform_index=%d\nstatus=PLACEHOLDER\n' "$S" "$i" "$j" | rec
  done; done
} > SYNTHETIC_PLACEHOLDER_growth_map.lrdrec

# (2) dynamical-mass fits: model names only, no numbers
{
  for m in point_mass extended composite; do
    printf '%s\nkind=placeholder_fit\nmodel=%s\nowner=t018-dynmass\nstatus=PLACEHOLDER\nvalue=PLACEHOLDER\n' "$S" "$m" | rec
  done
} > SYNTHETIC_PLACEHOLDER_dynmass.lrdrec

# (4) proof status per obligation: obligation names from CONTRACTS.md transition kinds
{
  for o in observation ledger_append hamiltonian_step capability air_proof growth_transition; do
    printf '%s\nkind=placeholder_obligation\nobligation=%s\nowner=agda (t011 / t023-agda-growth)\nstatus=PLACEHOLDER\n' "$S" "$o" | rec
  done
} > SYNTHETIC_PLACEHOLDER_obligations.lrdrec
echo "wrote $(ls SYNTHETIC_PLACEHOLDER_*.lrdrec | wc -l) placeholder files"
