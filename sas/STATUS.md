<!-- SPDX-License-Identifier: AGPL-3.0-only. Also licensed under the SnapKitty Opaque License; see LICENSE and SNAPKITTY_OPAQUE_LICENSE.md at the repository root. -->
# sas/STATUS.md

Mission QSO1-DCBH-001, role 09 (independent validation of the role-04
growth solver), SAS half. This directory was an empty placeholder
(`.gitkeep` only, on every branch) until 2026-10-20.

## Contents
- `validate_growth.sas` — closed-form re-derivation of the role-04
  sweep dataset (`fixtures/growth/feasible_grid.csv`): per-row Δt,
  growth factor, and minimum seed under both models (simple /
  saturated), with checks printed as `PASS/FAIL sas.<name>` lines —
  row count, Δt / seed / mdot agreement with the dataset, feasibility
  agreement outside a 0.1% boundary guard band, benchmark seed in
  (480, 525) M☉, and exact linearity of seed in M_target. Same
  declared inputs as the solver (Planck 2018; CODATA 2018 t_Edd;
  z_obs = 7.04221; M_target = 5·10⁷ M☉); λ (luminosity ratio) and
  mdot = λ/ε (physical accretion rate) kept distinct.

## Engine status — read this before citing the track
SAS is licensed and is NOT installed on the repo host, the CI VM, or
any system available to this project. **`validate_growth.sas` has
never been executed.** It is written against the SAS language
reference (DATA step, PROC SQL with macro variables, %sysevalf
conditions) and is the track's source deliverable;
`tests/sas/run.sh` reports `UNAVAILABLE sas.growth_validation`
wherever no SAS runtime exists, which is everywhere the project can
reach. Any future SAS run's log belongs in
`tests/growth/evidence/` (or a tests/sas evidence dir) before any
check in the program may be cited as passing.
