<!-- SPDX-License-Identifier: AGPL-3.0-only. Also subject to SNAPKITTY_OPAQUE_LICENSE.md (dual license). -->
# curry/growth/STATUS.md — QSO1 growth classification (Mission QSO1-DCBH-001, role 08)

Executed 2026-10-20 under the SUNDAY EXECUTION directive (QSO1 GROWTH
CONSTRAINTS). Input: the Fortran solver's LRD-GROWTH-v1 record
(`fixtures/growth/feasible_grid.rec`, commitment
`43b24d24797eff37e7e288f2346569d3a146c466470090e64f9fd3c193e7e632`).

## What built
- `curry/growth/GrowthClassify.curry` — strict LRD-REC-v1 parser (same shape
  as the causal track's `CausalGraph.curry` parser), growth tuple accessors,
  and the classifier. Classification is nondeterministic by design
  (directive item 6): `hypothesis t` yields every hypothesis consistent
  with tuple t (LightSeed / HeavySeed / SuperEddington / PrimordialBH /
  Composite); competing hypotheses are kept alive, never eliminated by
  order. `counterexample t` holds when no seed in the swept range reaches
  the target under either carried growth model.
- `curry/growth/TestGrowthClassify.curry` — 11 checks, expectations derived
  from the solver's stated model by hand (fortran/growth/STATUS.md), not
  copied from solver output.

## Two defects found by execution and fixed
1. **PAKCS `reads` cannot parse Fortran floats.** `reads` delegates to
   SWI-Prolog `number_codes`, which rejects the ES-format positive
   exponent: `reads "5.0214975104612182E+002"` raises
   `syntax_error(illegal_number)` (the negative-exponent form parses).
   The classifier therefore parses decimals by hand (digit accumulation +
   power-of-ten scaling, ~1e-13 relative error, immaterial against the
   classification thresholds). The causal track never hit this: its
   records carry integers and strings only.
2. **Quadratic row assembly.** The first version did ten full-list key
   lookups per row over the 10,801-entry record (~6.5e7 scans). Replaced
   by a single pass over the bytewise-sorted entries grouping each row's
   fields; per-row cost is now constant — measured linear (marginal
   ~80 ms/row of PAKCS throughput, constant from 100 to 400 rows).

## Verification status
- 1-row, 100-row, and 400-row prefixes of the real record (n_rows adjusted)
  parse and load in PAKCS 3.10.0. First tuple hand-verified end to end:
  (lam 0.5, eps 0.05, z_form 12, duty 0.1) gives mdot = lam/eps = 10 and
  min seed 22,083,477 Msun under both models (lam < 1 makes them equal),
  matching an independent by-hand exponent computation (E = 0.8172,
  factor 2.2642, 5e7/2.2642 = 2.2083e7).
- **Full 1200-row run COMPLETED 2026-10-20: all 11 checks PASS**
  (row_count_1200, benchmark_tuple_found, benchmark_seed_near_497,
  benchmark_heavy_seed_only, competing_hypotheses_alive,
  nondet_matches_filter, weak_tuple_is_counterexample, pbh_range_alive,
  light_seed_exists, every_feasible_has_hypothesis,
  no_infeasible_has_hypothesis; log in
  `tests/growth/evidence/curry_run.log`). Runtime was ~19 minutes of
  PAKCS on this small VM — the classifier is correct but PAKCS's
  throughput on a 522 KB record is what it is; earlier attempts were
  killed by VM replacements and CPU contention, not by defects.
