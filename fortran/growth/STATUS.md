<!-- SPDX-License-Identifier: AGPL-3.0-only. Also subject to SNAPKITTY_OPAQUE_LICENSE.md (dual license). -->
# fortran/growth/STATUS.md — QSO1 growth solver (Mission QSO1-DCBH-001, role 04)

Executed 2026-10-20 under the SUNDAY EXECUTION directive (QSO1 GROWTH
CONSTRAINTS), resuming the repository after the previous worker's credits ran
out. Completed work was not replaced: the solver reuses `lrd_cosmo` (cosmic
time) and `lrd_const` from the kernel, and links the causal track's
`causal_lrdrec`/`causal_sha256` (LRD-REC-v1 writer + commitment) unmodified.

## What built
- `fortran/growth/src/lrd_growth.f90` — continuous accretion growth.
  dM/dt = duty · (1−ε)/ε · λ · M / t_Edd, integrated by explicit stepping over
  the `lrd_cosmo` cosmological time grid (uniform steps in z from z_form to
  z_obs, dt from `age_gyr` differences), with an independent RK4 integration
  of the same ODE in cosmic time as a cross-check.
- `fortran/growth/app/lrd_growth_sweep.f90` — driver: `benchmark`,
  `selfcheck`, and `sweep` modes.
- Outputs: `fixtures/growth/feasible_grid.csv` (1200 rows) and
  `fixtures/growth/feasible_grid.rec` (LRD-GROWTH-v1) + `.rec.commit`.

## Definitions (kept distinct, directive item 5)
- λ_Edd is the **luminosity ratio** L/L_Edd.
- The **physical mass-accretion rate** in units of L_Edd/c² is ṁ = λ/ε
  (column `mdot_edd`). At the benchmark (λ=1, ε=0.1) ṁ = 10: the hole
  swallows ten times L_Edd/c² while radiating at the Eddington luminosity,
  because only ε of the accreted rest mass becomes light.
- Super-Eddington: the simple model lets growth rise linearly with λ without
  bound (an upper bound). `MODE_SATURATED` uses λ_eff = 1 + ln λ for λ > 1
  (slim-disk luminosity saturation) as a lower, saturation-motivated
  estimate. Both models are carried through every output; at λ ≤ 1 they are
  identical (checked: ratio exactly 1 at λ=0.5; at λ=3 the saturated growth
  factor is 3.1e-5 of the simple one over the benchmark interval).

## Constants and declared inputs
- t_Edd = σ_T c/(4π G m_p) = **450.490 Myr** from CODATA 2018 (G, m_p, σ_T;
  measured constants, held in `lrd_growth`, not in `lrd_const`, which keeps
  only exact/defined values).
- Cosmology: Planck 2018 (H0=67.36, Ωm=0.3153, ΩΛ=0.6847), as in the kernel.
- z_obs = 7.04221 (this repo's measured redshift, fortran/STATUS.md).
- M_target = 5.0e7 M☉ (Juodžbalis et al. 2026, "~50 million solar masses",
  research/CITATIONS.md). **No published uncertainty appears in the retrieved
  text, so none is invented.** Propagation mechanism: seed masses scale
  exactly linearly with M_target (linear ODE), so any future ± on the mass
  maps to the same relative ± on every seed in the dataset. See OPEN items.

## Benchmark verification (directive item 4)
Directive: Δt ≈ 576 Myr; min seed ≈ 497 M☉ at λ=1; required λ ≈ 1.139 for a
100 M☉ seed. Solver (this run, gfortran, bit-identical across two compiler
versions and two runs):

| quantity | solver | directive |
|---|---|---|
| growth interval Δt (z 20 → 7.04221) | 576.059 Myr | ~576 Myr |
| minimum seed (λ=1, ε=0.1, duty=1) | 502.15 M☉ | ~497 M☉ |
| required λ (seed 100 M☉) | 1.14022 | ~1.139 |
| t_Edd | 450.490 Myr | (450 Myr nominal) |

The seed is 1.0% above the directive's round figure and the required λ is
0.1% above; both offsets trace to the exact constants (CODATA t_Edd =
450.49 Myr, Planck-2018 Δt = 576.06 Myr) versus the rounded values behind
the directive's estimate. No constant was tuned to force agreement.
Cross-checks: RK4 vs stepped factor agree to 1.0e-10 relative; step-count
convergence (50 vs 800 steps) 3.5e-15 relative.

## Sweep (directive items 2–3)
Grid: λ ∈ {0.5, 0.75, 1, 1.5, 2, 2.5, 3, 5}, ε ∈ {0.05…0.30 step 0.05},
z_form ∈ {12, 15, 20, 25, 30}, duty ∈ {0.1, 0.25, 0.5, 0.75, 1} → 1200
tuples, each with dt, ṁ, both growth factors, both minimum seeds, and
feasibility against the swept seed range 10–1e5 M☉.
Feasible tuples: **464/1200 (simple), 382/1200 (saturated)**. Minimum seed
among feasible tuples ranges from 4.8e-53 M☉ (λ=5, ε=0.05, z_form=30,
duty=1 corner) to 9.70e4 M☉ at the feasibility edge.
Dataset commitment: `43b24d24797eff37e7e288f2346569d3a146c466470090e64f9fd3c193e7e632`
(recomputed independently with coreutils sha256sum over
"LRD-COMMIT-v1\0" ‖ record; matches).

## Consumers
- Curry classification: `curry/growth/` (role 08) reads the record;
  competing hypotheses are kept alive by nondeterministic classification.
- Agda certificate: `agda/growth/Growth.agda` (role 07) — exact symbolic
  threshold over ℚ plus a certified sufficient seed for the benchmark
  tuple (64-step Euler certificate, seed bound 1300 M☉; see
  agda/growth/STATUS.md for its typecheck status); 497 appears nowhere
  in it.
- Self/Morphic front end: `self/growth/` (role 10) reads the same record.

## OPEN (unresolved scientific questions, retained per directive item 9)
1. **Mass uncertainty**: the retrieved Juodžbalis et al. 2026 text states
   "~50 million solar masses" with no error bar available to this repo.
   Propagation is linear and implemented by construction, but no numerical
   uncertainty band can be quoted until the paper's mass uncertainty is
   retrieved. Do not invent one (research/CITATIONS.md).
2. **Super-Eddington model choice**: λ_eff = 1 + ln λ is one saturation
   prescription, not a measurement. Feasibility at λ > 1 differs by orders
   of magnitude between the two carried models (382 vs 464 feasible
   tuples); which (if either) describes QSO1 is an empirical question the
   sweep alone cannot settle.
3. **Constant λ, ε, duty**: the sweep holds all three constant over
   ~576 Myr. Time-varying histories (e.g. early super-Eddington bursts)
   are representable in the integrator's structure but are not swept here.
4. **z_obs systematics**: the kernel's z = 7.04221 ± 0.00027 sits 0.0029
   below Furtak et al. 2024 (fortran/STATUS.md, OPEN there). Δt is
   insensitive to this at the 0.01% level, so growth conclusions are not,
   but the discrepancy itself remains open in its own track.
