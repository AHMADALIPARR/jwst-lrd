<!-- SPDX-License-Identifier: AGPL-3.0-only. Also licensed under the SnapKitty Opaque License; see LICENSE and SNAPKITTY_OPAQUE_LICENSE.md at the repository root. -->
# matlab/STATUS.md

Mission QSO1-DCBH-001, role 09 (independent validation of the role-04
growth solver). This directory was an empty placeholder (`.gitkeep`
only, on every branch) until 2026-10-20.

## Contents
- `lrd_age_gyr.m` — closed-form cosmic age for flat ΛCDM,
  t(z) = 2/(3H0√ΩΛ)·asinh(√(ΩΛ/Ωm)·(1+z)^(−3/2)). Deliberately a
  different method from the Fortran kernel's grid quadrature: role 09
  validates by independent re-derivation.
- `lrd_growth_factor.m` — growth factor exp(rate·Δt) with the declared
  inputs (Planck 2018; CODATA 2018 t_Edd = 0.45049041223042019 Gyr;
  z_obs = 7.04221), both models (simple / slim-disk-saturated).
  λ = L/L_Edd (luminosity ratio) and mdot = λ/ε (physical accretion
  rate) kept distinct, as in the solver.
- `lrd_min_seed.m` — minimum seed = M_target / factor.
- `validate_growth_grid.m` — the validation driver: reads
  `fixtures/growth/feasible_grid.csv` (1,200 rows) and checks row
  count; per-row Δt, min-seed (both models) and mdot re-derivation
  within tolerance (measured deviations printed); feasibility-flag
  agreement outside a 0.1% boundary guard band (rows inside the band —
  an artifact of the CSV's 9 significant digits — are reported, not
  silently passed); benchmark seed in (480, 525) M☉; exact linearity
  of seed in M_target (the propagation law for the target-mass
  uncertainty); H0 +1% sensitivity probe (labelled a probe, not an
  uncertainty: higher H0 → younger universe → strictly larger seed).

## Engine status
MATLAB is licensed and is NOT installed on the repo host or the CI VM:
no MATLAB execution exists. `tests/matlab/run.sh` reports
`UNAVAILABLE matlab.growth_validation` when neither MATLAB nor Octave
is present; when GNU Octave is present it executes the same sources
labelled "GNU Octave (NOT MATLAB)" — an Octave pass is evidence about
the .m logic only, never a MATLAB result (mission role 09).

## Open
- A licensed MATLAB run remains the only way to close this track as
  MATLAB; none is available to the project.
