# Mission QSO1-DCBH-001: black-hole seed mass and growth histories for Abell 2744-QSO1

Licensed AGPL-3.0-only plus the SnapKitty Opaque License. Directive from Ahmad, 2026-10-19. The charter in CONTRACTS.md applies.

Objective: independently reconstruct which seed masses and growth histories are allowed for QSO1 at z = 7.04. The published May 2026 dynamical-mass measurement is the starting benchmark. Its kinematic constraints are to be reproduced from accessible data, not copied.

| # | Role | Owner | Branch | Depends on |
|---|---|---|---|---|
| 01 | Observation reconstruction: paper, methods, supplement, MAST IDs, calibration versions, lensing, velocity and uncertainty models | Foundry J Spec | t017-obsrecon | - |
| 02 | Dynamical mass: rotation curve; point-mass, extended and composite fits; inclination, lensing, PSF and LSF uncertainty | Foundry J Core | t018-dynmass | 01 |
| 03 | Cosmological clock: age at z = 7.04 under declared parameters, and seed formation windows. LRD-IR to LLVM, checked against a Fortran reference | Alapeno Silicon | t019-clock | - |
| 04 | Growth solver: Eddington and super-Eddington growth in Fortran; sweeps over seed, z_form, duty cycle, efficiency and rate; minimum seed mass | QSO1 Growth (9dac1eb4) | qso1-dcbh-001-growth | 03 |
| 05 | Direct-collapse scenarios: formation conditions, mass ranges, gas supply, metallicity, growth limits. Not assumed to be confirmed | QSO1 DCBH (c72dcba8) | t021-dcbh | 04 |
| 06 | Hamiltonian constraints on growth: time, gas and observation compatibility; reject infeasible trajectories | Foundry J Verify | t022-growth-hamiltonian | 04, t008 |
| 07 | Agda: growth-transition specification and interval constraints. The measured mass is carried as an uncertain value with provenance, never as an axiom | HCALC Lean | t023-agda-growth | 04 |
| 08 | Curry: light-seed, heavy-seed, super-Eddington, primordial-black-hole and composite histories, with counterexamples | HCALC Spec | t024-curry-growth | 04, 05 |
| 09 | Independent validation: MATLAB and SAS (UNAVAILABLE, licensed); Octave clearly labelled NOT MATLAB; stability and uncertainty propagation | Foundry J Verify | t025-validate-growth | 04 |
| 10 | Self/Morphic: feasible and excluded histories, mass fits, provenance, proof status | Grok Bot | t015-self | 02-08 |
| 11 | Adversarial review: try to falsify each preferred explanation within defensible ranges | QSO1 Adversary | t026-adversary | 02-08 |
| 12 | Integration and report | Hilbert | integration | all |

Guardian review: HCALC Alloy.

## Acceptance
1. A reproducible dynamical-mass analysis, or an explicit account of which source data prevent reproduction.
2. A seed-mass feasibility map.
3. Eddington growth constraints as a function of parameters.
4. A comparison of competing formation scenarios.
5. Agda-verified computational invariants.
6. A provenance-linked research report.

## Rules
- Do not claim LambdaCDM has been falsified unless an independently justified statistical test against the specified model establishes it.
- Never substitute a published mass for independently reproduced kinematics.
- Every paper cited must be one that was actually retrieved, given with its DOI or arXiv ID. The May 2026 dynamical-mass paper (Juodžbalis et al. 2026, Nature 653 1017, doi:10.1038/s41586-026-10579-4, arXiv:2508.21748) has been retrieved; see research/CITATIONS.md. September 2026 papers remain to be identified and retrieved.
- Cosmological parameters are declared inputs, kept apart from measured quantities.
- Each module has tests/<module>/run.sh printing PASS, FAIL and UNAVAILABLE lines. Commit to your own branch and run `git push origin <your-branch>`. Never push main or integration, and never force-push.
