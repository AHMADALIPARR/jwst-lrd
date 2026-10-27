# curry/growth-search — Curry growth-history search for Abell 2744-QSO1

Mission QSO1-DCBH-001, role 08 (branch `t024-curry-growth`). Licence: AGPL-3.0-only
(dual-licensed with the SnapKitty Opaque License, see repository root).

**Code/evidence commit:** `c58dbf5d79a49726107b767c8568af97a4173f11` (branch `t024-curry-growth`; the commit that adds
this STATUS.md follows it, so the final branch head hash is reported in the hand-off message and
by `git rev-parse t024-curry-growth`, not inside this file).

## Deviation from the brief: directory name

The brief suggested `curry/growth/`. That directory already exists on origin/main (another agent's
`GrowthClassify`, PR #17), so this module lives in **`curry/growth-search/`** and
`tests/curry-growth/`. Nothing under `curry/growth/` or `curry/causal/` was touched
(`cg.scope_only_own_dirs` and `cg.curry_causal_untouched` check this in every test run).
The branch was created fresh from main and fast-forwarded to origin/main `4280b88` (local main was
95 commits stale; the real growth evidence is on origin/main). Self-contained: no import of any other
curry module.

## What it is

`GrowthSearch.curry` (PAKCS 3.10.0, Curry only; POSIX shell for the test):

* **Horn-clause style rules** (`rules`): `viable(Family, Tuple) :- goal1, goal2, ...`, one rule per family,
  each carrying provenance tags: `CITED`, `SOLVER`, `DEFINITION`, `ASSUMPTION(uncited)`, `OPEN-PROOF-OBLIGATION`.
* **Families:** light-seed, heavy-seed (direct-collapse-class), super-Eddington, primordial black hole, composite.
* **Bounded nondeterministic search:** a candidate is chosen with `member` (`?`), evaluated, and the results are
  collected with a set function (`set1`, `sortValues`). `mainAt CSV BOUND` examines at most BOUND candidates and says
  `BOUND_REACHED ... NOT exhaustive` if it stops early. The full space is 4960 candidates (rows x families x models
  x assumption sets).
* **Assumption sets (declared, uncited):** `AFid`: eps = 0.1, duty = 1 (the benchmark's values). `AGrid`: the solver's whole grid.
* **Contradiction detection** on the evidence: simple and saturated min seeds must agree for lam <= 1; min seed must be strictly monotone
  (decreasing in z_form, lam, duty; increasing in eps) for both models; feasibility flags must equal (min seed <= 1e5 Msun); the 464/382
  counts in fortran/growth/STATUS.md must match. A SYNTHETIC negative control proves the detector can fire.
* **Inference traces:** every candidate has a trace (rule, provenance, each goal HOLDS/FAILS/UNAVAILABLE, conclusion).
* **Evidence used:** only `fixtures/growth/feasible_grid.csv` (the Fortran solver's sweep; the test re-runs the committed solver and
  confirms it reproduces the committed CSV and REC byte for byte). Floats are parsed by hand because PAKCS `reads` rejects Fortran
  `E+007` exponents.

Verdict vocabulary: **viable under assumptions** (never "confirmed"), **rejected** (a counterexample with its reason),
**UNAVAILABLE** (evidence missing; nothing filled in).

## How to run

```
sh tests/curry-growth/run.sh                      # needs a working PAKCS; ~15-20 min (PAKCS is slow)
LRD_CG_EVIDENCE=1 sh tests/curry-growth/run.sh    # also refreshes tests/curry-growth/evidence/
```

The test probes for PAKCS (`LRD_PAKCS`, `PATH`, `build/tools/pakcs-3.10.0`, then
`/workspace/jwst-lrd/build/tools/pakcs-3.10.0`) and accepts only one that answers `--numeric-version` and evaluates `1+1`.
**On this box the PAKCS copy committed under the t024 worktree's `build/tools/` fails with "incompatible VM-signature"**, so the run used
`/workspace/jwst-lrd/build/tools/pakcs-3.10.0` (3.10.0). On a machine with no working PAKCS every Curry check prints UNAVAILABLE.

## Real test run (tests/curry-growth/run.sh, exit 0)

Verbatim from `tests/curry-growth/evidence/run_sh.out` (27 PASS, 0 FAIL, 13 UNAVAILABLE):

```
PASS cg.solver_reproduces_csv
PASS cg.solver_reproduces_rec
PASS cg.csv_1200_rows_plus_header
PASS cg.missing_evidence_claims_match_repo
PASS cg.scope_only_own_dirs
PASS cg.curry_causal_untouched
PASS cg.licence_wording
PASS cg.no_python_ts_js
PASS curry_growth.row_count_1200
PASS curry_growth.light_benchmark_rejected
PASS curry_growth.light_viable_exactly_lam1_zform30
PASS curry_growth.heavy_rejected_only_lam05_zform12
PASS curry_growth.heavy_fid_14_viable_of_15
PASS curry_growth.supereddington_simple_hand_value
PASS curry_growth.supereddington_saturated_hand_value
PASS curry_growth.pbh_all_unavailable
PASS curry_growth.composite_all_unavailable
PASS curry_growth.no_family_confirmed
PASS curry_growth.every_rejection_has_reason
PASS curry_growth.nondet_search_equals_deterministic
PASS curry_growth.contradiction_detector_silent_on_real_data
PASS curry_growth.bounded_search_honours_bound
PASS curry_growth.search_exhaustive
UNAVAILABLE curry_growth.family.PrimordialBH PO-PBH-1 missing: PBH mass/abundance source (primary paper) not retrieved; no abundance in repo
UNAVAILABLE curry_growth.family.Composite PO-COMP-1 missing: time-varying growth history; solver only sweeps constant (lam, eps, duty)
UNAVAILABLE curry_growth.evidence.t018-dynmass-independent-mass independent dynamical-mass reproduction (role 02): branch t018-dynmass has no commits beyond main; M_target = 5e7 Msun is the published value (Juodzbalis+ 2026), not reproduced here
UNAVAILABLE curry_growth.evidence.t019-formation-window cosmological clock and seed-formation window (role 03): t019-clock has no clock output of its own; z_form is a swept grid value (12..30), not a derived window
UNAVAILABLE curry_growth.evidence.t021-dcbh-scenario-models direct-collapse scenario models (role 05): branch t021-dcbh has no commits beyond main; no formation conditions, mass range, gas supply or metallicity model is in the repo
UNAVAILABLE curry_growth.evidence.t022-hamiltonian-feasibility Foundry J Verify Hamiltonian growth feasibility (role 06): no branch t022-growth-hamiltonian exists locally or on origin; /workspace/foundry-j/verify holds the J property harness (no growth results); hamiltonian/ (t008) is a generic engine with no growth model
UNAVAILABLE curry_growth.evidence.dcbh-baryon-cap arXiv:2508.21748v2 states DCBH growth is limited by the baryon fraction in an atomically cooling halo, upper limit M_BH/M_dyn ~ 0.1, more than 1 dex below its inferred lower limit (refs 33,34 there). That is a published claim, NOT reproduced here: it needs t018 (independent M_dyn) and t021 (halo model)
UNAVAILABLE curry_growth.evidence.m-target-uncertainty no published uncertainty on M_target = 5e7 Msun is available to the repo (research/CITATIONS.md); solver gives 'minimum seed to reach >= target' only, so overshoot of the observed mass cannot be tested
UNAVAILABLE curry_growth.evidence.current-eddington-ratio-link observed current L/L_Edd (about 0.03 in arXiv:2508.21748v2, about 0.3 in arXiv:2308.05735v2, 10x apart, no uncertainties) cannot be tied to the solver's constant-lam history without a duty-cycle/episode model; no verdict
UNAVAILABLE curry_growth.evidence.pbh-abundance-mass PBH mass function and abundance source: none in the repo (open proof obligation PO-PBH-1)
UNAVAILABLE curry_growth.evidence.composite-time-varying time-varying growth histories (open proof obligation PO-COMP-1)
UNAVAILABLE curry_growth.evidence.saturation-prescription-citation paper for the lam_eff = 1 + ln(lam) saturation prescription (open proof obligation PO-SAT-1)
UNAVAILABLE curry_growth.evidence.parameter-priors literature priors for eps and duty cycle (AFid/AGrid are declared uncited assumptions; adversary/PLAN.md cites 1911.05791 for them but that paper is not retrieved in this repo)
PASS curry_growth.report_deterministic
PASS curry_growth.contradiction_detector_synthetic
PASS curry_growth.bounded_run
PASS curry_growth.every_rejection_has_reason_full_dump
exit=0
```

(The UNAVAILABLE lines are truncated at 400 columns here; full text is in the evidence file.)

## Family verdicts (exhaustive search, 4960 candidates)

Verbatim from `tests/curry-growth/evidence/report_exhaustive.txt` (`rows=1200 candidates_total=4960 bound=100000 evaluated=4960 exhaustive=yes`):

```
GROUP aset=AFid family=LightSeed      model=Simple    candidates=15    viable=1     rejected=14    unavailable=0     status=VIABLE_UNDER_ASSUMPTIONS
GROUP aset=AFid family=HeavySeed      model=Simple    candidates=15    viable=14    rejected=1     unavailable=0     status=VIABLE_UNDER_ASSUMPTIONS
GROUP aset=AFid family=SuperEddington model=Simple    candidates=25    viable=24    rejected=1     unavailable=0     status=VIABLE_UNDER_ASSUMPTIONS
GROUP aset=AFid family=SuperEddington model=Saturated candidates=25    viable=24    rejected=1     unavailable=0     status=VIABLE_UNDER_ASSUMPTIONS
GROUP aset=AFid family=PrimordialBH   model=Simple    candidates=40    viable=0     rejected=0     unavailable=40    status=UNAVAILABLE
GROUP aset=AFid family=Composite      model=Simple    candidates=40    viable=0     rejected=0     unavailable=40    status=UNAVAILABLE
GROUP aset=AGrid family=LightSeed      model=Simple    candidates=450   viable=21    rejected=429   unavailable=0     status=VIABLE_UNDER_ASSUMPTIONS
GROUP aset=AGrid family=HeavySeed      model=Simple    candidates=450   viable=117   rejected=333   unavailable=0     status=VIABLE_UNDER_ASSUMPTIONS
GROUP aset=AGrid family=SuperEddington model=Simple    candidates=750   viable=220   rejected=530   unavailable=0     status=VIABLE_UNDER_ASSUMPTIONS
GROUP aset=AGrid family=SuperEddington model=Saturated candidates=750   viable=150   rejected=600   unavailable=0     status=VIABLE_UNDER_ASSUMPTIONS
GROUP aset=AGrid family=PrimordialBH   model=Simple    candidates=1200  viable=0     rejected=0     unavailable=1200  status=UNAVAILABLE
GROUP aset=AGrid family=Composite      model=Simple    candidates=1200  viable=0     rejected=0     unavailable=1200  status=UNAVAILABLE
```

"VIABLE_UNDER_ASSUMPTIONS" means only that the solver's constant-(lam, eps, z_form, duty) minimum seed does not exceed the
family's reference seed under the declared assumption set. It is not confirmation of any scenario.

## Survivors: viable under assumptions (AFid: eps = 0.1, duty = 1)

Verbatim; each line is a candidate whose rule body held. `ratio` = min seed / family seed bound (<= 1).

```
LightSeed       Simple    #14    lam=1 eps=0.1 z_form=30 duty=1 | viable, seed ratio 0.6876 | viable under assumptions (AFid); not confirmed
HeavySeed       Simple    #16    lam=0.5 eps=0.1 z_form=15 duty=1 | viable, seed ratio 0.3901 | viable under assumptions (AFid); not confirmed
HeavySeed       Simple    #17    lam=0.5 eps=0.1 z_form=20 duty=1 | viable, seed ratio 0.1585 | viable under assumptions (AFid); not confirmed
HeavySeed       Simple    #18    lam=0.5 eps=0.1 z_form=25 duty=1 | viable, seed ratio 0.0970 | viable under assumptions (AFid); not confirmed
HeavySeed       Simple    #19    lam=0.5 eps=0.1 z_form=30 duty=1 | viable, seed ratio 0.0718 | viable under assumptions (AFid); not confirmed
HeavySeed       Simple    #20    lam=0.75 eps=0.1 z_form=12 duty=1 | viable, seed ratio 0.1504 | viable under assumptions (AFid); not confirmed
HeavySeed       Simple    #21    lam=0.75 eps=0.1 z_form=15 duty=1 | viable, seed ratio 0.0345 | viable under assumptions (AFid); not confirmed
HeavySeed       Simple    #22    lam=0.75 eps=0.1 z_form=20 duty=1 | viable, seed ratio 0.0089 | viable under assumptions (AFid); not confirmed
HeavySeed       Simple    #23    lam=0.75 eps=0.1 z_form=25 duty=1 | viable, seed ratio 0.0043 | viable under assumptions (AFid); not confirmed
HeavySeed       Simple    #24    lam=0.75 eps=0.1 z_form=30 duty=1 | viable, seed ratio 0.0027 | viable under assumptions (AFid); not confirmed
HeavySeed       Simple    #25    lam=1 eps=0.1 z_form=12 duty=1 | viable, seed ratio 0.0217 | viable under assumptions (AFid); not confirmed
HeavySeed       Simple    #26    lam=1 eps=0.1 z_form=15 duty=1 | viable, seed ratio 0.0030 | viable under assumptions (AFid); not confirmed
HeavySeed       Simple    #27    lam=1 eps=0.1 z_form=20 duty=1 | viable, seed ratio 0.0005 | viable under assumptions (AFid); not confirmed
HeavySeed       Simple    #28    lam=1 eps=0.1 z_form=25 duty=1 | viable, seed ratio 0.0002 | viable under assumptions (AFid); not confirmed
HeavySeed       Simple    #29    lam=1 eps=0.1 z_form=30 duty=1 | viable, seed ratio 0.0001 | viable under assumptions (AFid); not confirmed
SuperEddington  Simple    #31    lam=1.5 eps=0.1 z_form=15 duty=1 | viable, seed ratio 0.1583 | viable under assumptions (AFid); not confirmed
SuperEddington  Simple    #32    lam=1.5 eps=0.1 z_form=20 duty=1 | viable, seed ratio 0.0106 | viable under assumptions (AFid); not confirmed
SuperEddington  Simple    #33    lam=1.5 eps=0.1 z_form=25 duty=1 | viable, seed ratio 0.0024 | viable under assumptions (AFid); not confirmed
SuperEddington  Simple    #34    lam=1.5 eps=0.1 z_form=30 duty=1 | viable, seed ratio 0.0010 | viable under assumptions (AFid); not confirmed
SuperEddington  Simple    #35    lam=2 eps=0.1 z_form=12 duty=1 | viable, seed ratio 0.0629 | viable under assumptions (AFid); not confirmed
SuperEddington  Simple    #36    lam=2 eps=0.1 z_form=15 duty=1 | viable, seed ratio 0.0012 | viable under assumptions (AFid); not confirmed
SuperEddington  Simple    #37    lam=2 eps=0.1 z_form=20 duty=1 | viable, seed ratio 0.0000 | viable under assumptions (AFid); not confirmed
SuperEddington  Simple    #38    lam=2 eps=0.1 z_form=25 duty=1 | viable, seed ratio 0.0000 | viable under assumptions (AFid); not confirmed
SuperEddington  Simple    #39    lam=2 eps=0.1 z_form=30 duty=1 | viable, seed ratio 0.0000 | viable under assumptions (AFid); not confirmed
SuperEddington  Simple    #40    lam=2.5 eps=0.1 z_form=12 duty=1 | viable, seed ratio 0.0013 | viable under assumptions (AFid); not confirmed
SuperEddington  Simple    #41    lam=2.5 eps=0.1 z_form=15 duty=1 | viable, seed ratio 0.0000 | viable under assumptions (AFid); not confirmed
SuperEddington  Simple    #42    lam=2.5 eps=0.1 z_form=20 duty=1 | viable, seed ratio 0.0000 | viable under assumptions (AFid); not confirmed
SuperEddington  Simple    #43    lam=2.5 eps=0.1 z_form=25 duty=1 | viable, seed ratio 0.0000 | viable under assumptions (AFid); not confirmed
SuperEddington  Simple    #44    lam=2.5 eps=0.1 z_form=30 duty=1 | viable, seed ratio 0.0000 | viable under assumptions (AFid); not confirmed
SuperEddington  Simple    #45    lam=3 eps=0.1 z_form=12 duty=1 | viable, seed ratio 0.0000 | viable under assumptions (AFid); not confirmed
SuperEddington  Simple    #46    lam=3 eps=0.1 z_form=15 duty=1 | viable, seed ratio 0.0000 | viable under assumptions (AFid); not confirmed
SuperEddington  Simple    #47    lam=3 eps=0.1 z_form=20 duty=1 | viable, seed ratio 0.0000 | viable under assumptions (AFid); not confirmed
SuperEddington  Simple    #48    lam=3 eps=0.1 z_form=25 duty=1 | viable, seed ratio 0.0000 | viable under assumptions (AFid); not confirmed
SuperEddington  Simple    #49    lam=3 eps=0.1 z_form=30 duty=1 | viable, seed ratio 0.0000 | viable under assumptions (AFid); not confirmed
SuperEddington  Simple    #50    lam=5 eps=0.1 z_form=12 duty=1 | viable, seed ratio 0.0000 | viable under assumptions (AFid); not confirmed
SuperEddington  Simple    #51    lam=5 eps=0.1 z_form=15 duty=1 | viable, seed ratio 0.0000 | viable under assumptions (AFid); not confirmed
SuperEddington  Simple    #52    lam=5 eps=0.1 z_form=20 duty=1 | viable, seed ratio 0.0000 | viable under assumptions (AFid); not confirmed
SuperEddington  Simple    #53    lam=5 eps=0.1 z_form=25 duty=1 | viable, seed ratio 0.0000 | viable under assumptions (AFid); not confirmed
SuperEddington  Simple    #54    lam=5 eps=0.1 z_form=30 duty=1 | viable, seed ratio 0.0000 | viable under assumptions (AFid); not confirmed
SuperEddington  Saturated #56    lam=1.5 eps=0.1 z_form=15 duty=1 | viable, seed ratio 0.3962 | viable under assumptions (AFid); not confirmed
SuperEddington  Saturated #57    lam=1.5 eps=0.1 z_form=20 duty=1 | viable, seed ratio 0.0315 | viable under assumptions (AFid); not confirmed
SuperEddington  Saturated #58    lam=1.5 eps=0.1 z_form=25 duty=1 | viable, seed ratio 0.0079 | viable under assumptions (AFid); not confirmed
SuperEddington  Saturated #59    lam=1.5 eps=0.1 z_form=30 duty=1 | viable, seed ratio 0.0034 | viable under assumptions (AFid); not confirmed
SuperEddington  Saturated #60    lam=2 eps=0.1 z_form=12 duty=1 | viable, seed ratio 0.6763 | viable under assumptions (AFid); not confirmed
SuperEddington  Saturated #61    lam=2 eps=0.1 z_form=15 duty=1 | viable, seed ratio 0.0243 | viable under assumptions (AFid); not confirmed
SuperEddington  Saturated #62    lam=2 eps=0.1 z_form=20 duty=1 | viable, seed ratio 0.0011 | viable under assumptions (AFid); not confirmed
SuperEddington  Saturated #63    lam=2 eps=0.1 z_form=25 duty=1 | viable, seed ratio 0.0002 | viable under assumptions (AFid); not confirmed
SuperEddington  Saturated #64    lam=2 eps=0.1 z_form=30 duty=1 | viable, seed ratio 0.0001 | viable under assumptions (AFid); not confirmed
SuperEddington  Saturated #65    lam=2.5 eps=0.1 z_form=12 duty=1 | viable, seed ratio 0.1202 | viable under assumptions (AFid); not confirmed
SuperEddington  Saturated #66    lam=2.5 eps=0.1 z_form=15 duty=1 | viable, seed ratio 0.0028 | viable under assumptions (AFid); not confirmed
SuperEddington  Saturated #67    lam=2.5 eps=0.1 z_form=20 duty=1 | viable, seed ratio 0.0001 | viable under assumptions (AFid); not confirmed
SuperEddington  Saturated #68    lam=2.5 eps=0.1 z_form=25 duty=1 | viable, seed ratio 0.0000 | viable under assumptions (AFid); not confirmed
SuperEddington  Saturated #69    lam=2.5 eps=0.1 z_form=30 duty=1 | viable, seed ratio 0.0000 | viable under assumptions (AFid); not confirmed
SuperEddington  Saturated #70    lam=3 eps=0.1 z_form=12 duty=1 | viable, seed ratio 0.0293 | viable under assumptions (AFid); not confirmed
SuperEddington  Saturated #71    lam=3 eps=0.1 z_form=15 duty=1 | viable, seed ratio 0.0005 | viable under assumptions (AFid); not confirmed
SuperEddington  Saturated #72    lam=3 eps=0.1 z_form=20 duty=1 | viable, seed ratio 0.0000 | viable under assumptions (AFid); not confirmed
SuperEddington  Saturated #73    lam=3 eps=0.1 z_form=25 duty=1 | viable, seed ratio 0.0000 | viable under assumptions (AFid); not confirmed
SuperEddington  Saturated #74    lam=3 eps=0.1 z_form=30 duty=1 | viable, seed ratio 0.0000 | viable under assumptions (AFid); not confirmed
SuperEddington  Saturated #75    lam=5 eps=0.1 z_form=12 duty=1 | viable, seed ratio 0.0006 | viable under assumptions (AFid); not confirmed
SuperEddington  Saturated #76    lam=5 eps=0.1 z_form=15 duty=1 | viable, seed ratio 0.0000 | viable under assumptions (AFid); not confirmed
SuperEddington  Saturated #77    lam=5 eps=0.1 z_form=20 duty=1 | viable, seed ratio 0.0000 | viable under assumptions (AFid); not confirmed
SuperEddington  Saturated #78    lam=5 eps=0.1 z_form=25 duty=1 | viable, seed ratio 0.0000 | viable under assumptions (AFid); not confirmed
SuperEddington  Saturated #79    lam=5 eps=0.1 z_form=30 duty=1 | viable, seed ratio 0.0000 | viable under assumptions (AFid); not confirmed
```

Reading: the light 150 Msun seed survives under AFid at exactly one tuple, (lam = 1, z_form = 30); z_form = 30 is the grid's
upper edge and there is no seed-formation window evidence (role 03 produced none), so that survival is fragile. Heavy-seed and
super-Eddington candidates survive across most of the AFid grid. Under AGrid the survivor counts are in the GROUP lines above
(light 21 of 450, heavy 117 of 450, super-Eddington 220 of 750 simple / 150 of 750 saturated). The super-Eddington "simple"
model is an unbounded upper bound by construction, and the saturated model's prescription is uncited (PO-SAT-1).

## Rejected candidates (counterexamples with rejection reasons)

Every rejected AFid candidate, verbatim (the reason is the text after `|`):

```
LightSeed       Simple    #0     lam=0.5 eps=0.1 z_form=12 duty=1 | min_seed_simple=1.04196387E+006 Msun > light seed 150 Msun [ratio 6946]: the seed cannot reach M_target=5e7 Msun by z_obs under constant (lam=0.5 eps=0.1 z_form=12 duty=1), model Simple
LightSeed       Simple    #1     lam=0.5 eps=0.1 z_form=15 duty=1 | min_seed_simple=3.90056968E+005 Msun > light seed 150 Msun [ratio 2600]: the seed cannot reach M_target=5e7 Msun by z_obs under constant (lam=0.5 eps=0.1 z_form=15 duty=1), model Simple
LightSeed       Simple    #2     lam=0.5 eps=0.1 z_form=20 duty=1 | min_seed_simple=1.58453424E+005 Msun > light seed 150 Msun [ratio 1056]: the seed cannot reach M_target=5e7 Msun by z_obs under constant (lam=0.5 eps=0.1 z_form=20 duty=1), model Simple
LightSeed       Simple    #3     lam=0.5 eps=0.1 z_form=25 duty=1 | min_seed_simple=9.70415460E+004 Msun > light seed 150 Msun [ratio 647]: the seed cannot reach M_target=5e7 Msun by z_obs under constant (lam=0.5 eps=0.1 z_form=25 duty=1), model Simple
LightSeed       Simple    #4     lam=0.5 eps=0.1 z_form=30 duty=1 | min_seed_simple=7.18097137E+004 Msun > light seed 150 Msun [ratio 479]: the seed cannot reach M_target=5e7 Msun by z_obs under constant (lam=0.5 eps=0.1 z_form=30 duty=1), model Simple
LightSeed       Simple    #5     lam=0.75 eps=0.1 z_form=12 duty=1 | min_seed_simple=1.50415985E+005 Msun > light seed 150 Msun [ratio 1003]: the seed cannot reach M_target=5e7 Msun by z_obs under constant (lam=0.75 eps=0.1 z_form=12 duty=1), model Simple
LightSeed       Simple    #6     lam=0.75 eps=0.1 z_form=15 duty=1 | min_seed_simple=3.44514146E+004 Msun > light seed 150 Msun [ratio 230]: the seed cannot reach M_target=5e7 Msun by z_obs under constant (lam=0.75 eps=0.1 z_form=15 duty=1), model Simple
LightSeed       Simple    #7     lam=0.75 eps=0.1 z_form=20 duty=1 | min_seed_simple=8.92005310E+003 Msun > light seed 150 Msun [ratio 59.4670]: the seed cannot reach M_target=5e7 Msun by z_obs under constant (lam=0.75 eps=0.1 z_form=20 duty=1), model Simple
LightSeed       Simple    #8     lam=0.75 eps=0.1 z_form=25 duty=1 | min_seed_simple=4.27515198E+003 Msun > light seed 150 Msun [ratio 28.5010]: the seed cannot reach M_target=5e7 Msun by z_obs under constant (lam=0.75 eps=0.1 z_form=25 duty=1), model Simple
LightSeed       Simple    #9     lam=0.75 eps=0.1 z_form=30 duty=1 | min_seed_simple=2.72138377E+003 Msun > light seed 150 Msun [ratio 18.1426]: the seed cannot reach M_target=5e7 Msun by z_obs under constant (lam=0.75 eps=0.1 z_form=30 duty=1), model Simple
LightSeed       Simple    #10    lam=1 eps=0.1 z_form=12 duty=1 | min_seed_simple=2.17137743E+004 Msun > light seed 150 Msun [ratio 145]: the seed cannot reach M_target=5e7 Msun by z_obs under constant (lam=1 eps=0.1 z_form=12 duty=1), model Simple
LightSeed       Simple    #11    lam=1 eps=0.1 z_form=15 duty=1 | min_seed_simple=3.04288877E+003 Msun > light seed 150 Msun [ratio 20.2859]: the seed cannot reach M_target=5e7 Msun by z_obs under constant (lam=1 eps=0.1 z_form=15 duty=1), model Simple
LightSeed       Simple    #12    lam=1 eps=0.1 z_form=20 duty=1 | min_seed_simple=5.02149751E+002 Msun > light seed 150 Msun [ratio 3.3477]: the seed cannot reach M_target=5e7 Msun by z_obs under constant (lam=1 eps=0.1 z_form=20 duty=1), model Simple
LightSeed       Simple    #13    lam=1 eps=0.1 z_form=25 duty=1 | min_seed_simple=1.88341233E+002 Msun > light seed 150 Msun [ratio 1.2556]: the seed cannot reach M_target=5e7 Msun by z_obs under constant (lam=1 eps=0.1 z_form=25 duty=1), model Simple
HeavySeed       Simple    #15    lam=0.5 eps=0.1 z_form=12 duty=1 | min_seed_simple=1.04196387E+006 Msun > heavy seed upper end 1e6 Msun [ratio 1.0420]: the seed cannot reach M_target=5e7 Msun by z_obs under constant (lam=0.5 eps=0.1 z_form=12 duty=1), model Simple
SuperEddington  Simple    #30    lam=1.5 eps=0.1 z_form=12 duty=1 | min_seed_simple=4.52499369E+002 Msun > light seed 150 Msun with lam > 1 [ratio 3.0167]: the seed cannot reach M_target=5e7 Msun by z_obs under constant (lam=1.5 eps=0.1 z_form=12 duty=1), model Simple
SuperEddington  Saturated #55    lam=1.5 eps=0.1 z_form=12 duty=1 | min_seed_saturated=9.40733197E+002 Msun > light seed 150 Msun with lam > 1 [ratio 6.2716]: the seed cannot reach M_target=5e7 Msun by z_obs under constant (lam=1.5 eps=0.1 z_form=12 duty=1), model Saturated
```

AGrid: 429 (light), 333 (heavy), 530 (super-Eddington simple), 600 (super-Eddington saturated) rejections. The closest miss for each
(verbatim), and **every** AGrid/AFid rejection with its reason is in `tests/curry-growth/evidence/rejected_all.txt` (ends with `REJECTED_COUNT`; the test
checks that each line carries a reason):

```
CLOSEST_MISS LightSeed       Simple    #504   lam=1 eps=0.1 z_form=25 duty=1 | min_seed_simple=1.88341233E+002 Msun > light seed 150 Msun [ratio 1.2556]: the seed cannot reach M_target=5e7 Msun by z_obs under constant (lam=1 eps=0.1 z_form=25 duty=1), model Simple
  rejected_in_group=429
CLOSEST_MISS HeavySeed       Simple    #639   lam=0.5 eps=0.1 z_form=12 duty=1 | min_seed_simple=1.04196387E+006 Msun > heavy seed upper end 1e6 Msun [ratio 1.0420]: the seed cannot reach M_target=5e7 Msun by z_obs under constant (lam=0.5 eps=0.1 z_form=12 duty=1), model Simple
  rejected_in_group=333
CLOSEST_MISS SuperEddington  Simple    #1794  lam=5 eps=0.3 z_form=15 duty=1 | min_seed_simple=1.71472525E+002 Msun > light seed 150 Msun with lam > 1 [ratio 1.1432]: the seed cannot reach M_target=5e7 Msun by z_obs under constant (lam=5 eps=0.3 z_form=15 duty=1), model Simple
  rejected_in_group=530
CLOSEST_MISS SuperEddington  Saturated #2442  lam=5 eps=0.1 z_form=15 duty=0.5 | min_seed_saturated=1.58010982E+002 Msun > light seed 150 Msun with lam > 1 [ratio 1.0534]: the seed cannot reach M_target=5e7 Msun by z_obs under constant (lam=5 eps=0.1 z_form=15 duty=0.5), model Saturated
  rejected_in_group=600
```

## Rule provenance (verbatim)

```
RULE R-LIGHT-1: viable(LightSeed, Tuple) :- lam <= 1, simple and saturated min seeds agree (solver: identical for lam <= 1), reach M_target with light seed 150 Msun
  PROV CITED arXiv:2308.05735v2 (Furtak+ 2024, Nature 628, 57) Discussion: DELPHI model assumes a seed mass of 150 Msun from metal-free stars (a model assumption of that paper, used here only as the reference light-seed mass)
  PROV DEFINITION light seed = the single cited reference mass 150 Msun; no range is invented
  PROV DEFINITION at or below Eddington luminosity: lam <= 1 (lam is L/L_Edd, fortran/growth/STATUS.md)
  PROV SOLVER min seed from fixtures/growth/feasible_grid.csv; constant (lam, eps, duty) from z_form to z_obs = 7.04221; M_target = 5e7 Msun (Juodzbalis+ 2026)
RULE R-HEAVY-1: viable(HeavySeed, Tuple) :- lam <= 1, simple and saturated min seeds agree (solver: identical for lam <= 1), reach M_target with heavy seed upper end 1e6 Msun
  PROV CITED arXiv:2308.05735v2 Discussion: hydrodynamic simulations 'typically starting with heavier seeds (10^(4-6) Msun)'; upper end 1e6 Msun used. Direct collapse is named in arXiv:2508.21748v2 as 'direct collapse of massive pristine clouds' without a mass range
  PROV DEFINITION heavy seed = any seed up to 1e6 Msun; reach test uses the upper end, so 'viable' means some seed in range suffices
  PROV DEFINITION at or below Eddington luminosity: lam <= 1
  PROV OPEN-PROOF-OBLIGATION PO-DCBH-1: DCBH-specific formation conditions, mass range, gas supply, metallicity (role 05, t021-dcbh) are not in the repo; this family is 'heavy seed', DCBH is one possible origin
  PROV SOLVER min seed from fixtures/growth/feasible_grid.csv
RULE R-SEDD-1: viable(SuperEddington, Tuple) :- lam > 1, reach M_target with light seed 150 Msun with lam > 1
  PROV CITED arXiv:2508.21748v2 main text: QSO1 'may still have experienced previous super-Eddington bursts' (qualitative; no rate or duration given)
  PROV DEFINITION super-Eddington: lam > 1
  PROV DEFINITION light reference seed 150 Msun rescued by lam > 1 growth
  PROV OPEN-PROOF-OBLIGATION PO-SAT-1: the saturated model lam_eff = 1 + ln(lam) is a prescription with no paper cited in fortran/growth (STATUS.md OPEN 2); the simple model (growth linear in lam) is an upper bound by construction
  PROV SOLVER min seed under the candidate's model from fixtures/growth/feasible_grid.csv
RULE R-PBH-1: viable(PrimordialBH, Tuple) :- evidence for PO-PBH-1
  PROV OPEN-PROOF-OBLIGATION PO-PBH-1: no PBH abundance or mass-function source in the repo; the only PBH mass statement found (preferred ~1e6 Msun scale, ref 35 = Carr & Kuhnel 2020, quoted in arXiv:2508.21748v2) is a secondary citation, the primary paper was not retrieved
  PROV DEFINITION the classifier in curry/growth/GrowthClassify.curry labels PrimordialBH by (seed >= 1e4 and z_form >= 25); that threshold has no cited source and is NOT used here
RULE R-COMP-1: viable(Composite, Tuple) :- evidence for PO-COMP-1
  PROV OPEN-PROOF-OBLIGATION PO-COMP-1: a composite history (e.g. heavy seed plus super-Eddington episodes) needs time-varying (lam, eps, duty); the solver sweeps constants only (fortran/growth/STATUS.md OPEN 3)
ASET ASSUMPTION(uncited) AFid: eps = 0.1 and duty = 1 (benchmark values of fortran/growth/STATUS.md; no paper cited for them)
ASET ASSUMPTION(uncited) AGrid: the solver's whole swept grid (eps 0.05..0.30, duty 0.1..1); the ranges are the solver's, not literature priors
```

## UNAVAILABLE list (evidence missing, nothing filled in)

Verbatim from the report:

```
UNAVAILABLE_FAMILY aset=AFid family=PrimordialBH candidates=40 | PO-PBH-1 missing: PBH mass/abundance source (primary paper) not retrieved; no abundance in repo
UNAVAILABLE_FAMILY aset=AFid family=Composite candidates=40 | PO-COMP-1 missing: time-varying growth history; solver only sweeps constant (lam, eps, duty)
UNAVAILABLE_FAMILY aset=AGrid family=PrimordialBH candidates=1200 | PO-PBH-1 missing: PBH mass/abundance source (primary paper) not retrieved; no abundance in repo
UNAVAILABLE_FAMILY aset=AGrid family=Composite candidates=1200 | PO-COMP-1 missing: time-varying growth history; solver only sweeps constant (lam, eps, duty)
UNAVAILABLE_EVIDENCE evidence.t018-dynmass-independent-mass | independent dynamical-mass reproduction (role 02): branch t018-dynmass has no commits beyond main; M_target = 5e7 Msun is the published value (Juodzbalis+ 2026), not reproduced here
UNAVAILABLE_EVIDENCE evidence.t019-formation-window | cosmological clock and seed-formation window (role 03): t019-clock has no clock output of its own; z_form is a swept grid value (12..30), not a derived window
UNAVAILABLE_EVIDENCE evidence.t021-dcbh-scenario-models | direct-collapse scenario models (role 05): branch t021-dcbh has no commits beyond main; no formation conditions, mass range, gas supply or metallicity model is in the repo
UNAVAILABLE_EVIDENCE evidence.t022-hamiltonian-feasibility | Foundry J Verify Hamiltonian growth feasibility (role 06): no branch t022-growth-hamiltonian exists locally or on origin; /workspace/foundry-j/verify holds the J property harness (no growth results); hamiltonian/ (t008) is a generic engine with no growth model
UNAVAILABLE_EVIDENCE evidence.dcbh-baryon-cap | arXiv:2508.21748v2 states DCBH growth is limited by the baryon fraction in an atomically cooling halo, upper limit M_BH/M_dyn ~ 0.1, more than 1 dex below its inferred lower limit (refs 33,34 there). That is a published claim, NOT reproduced here: it needs t018 (independent M_dyn) and t021 (halo model)
UNAVAILABLE_EVIDENCE evidence.m-target-uncertainty | no published uncertainty on M_target = 5e7 Msun is available to the repo (research/CITATIONS.md); solver gives 'minimum seed to reach >= target' only, so overshoot of the observed mass cannot be tested
UNAVAILABLE_EVIDENCE evidence.current-eddington-ratio-link | observed current L/L_Edd (about 0.03 in arXiv:2508.21748v2, about 0.3 in arXiv:2308.05735v2, 10x apart, no uncertainties) cannot be tied to the solver's constant-lam history without a duty-cycle/episode model; no verdict
UNAVAILABLE_EVIDENCE evidence.pbh-abundance-mass | PBH mass function and abundance source: none in the repo (open proof obligation PO-PBH-1)
UNAVAILABLE_EVIDENCE evidence.composite-time-varying | time-varying growth histories (open proof obligation PO-COMP-1)
UNAVAILABLE_EVIDENCE evidence.saturation-prescription-citation | paper for the lam_eff = 1 + ln(lam) saturation prescription (open proof obligation PO-SAT-1)
UNAVAILABLE_EVIDENCE evidence.parameter-priors | literature priors for eps and duty cycle (AFid/AGrid are declared uncited assumptions; adversary/PLAN.md cites 1911.05791 for them but that paper is not retrieved in this repo)
```

* **Primordial black hole: UNAVAILABLE (open proof obligation PO-PBH-1).** No PBH abundance or mass-function source is in the repo. The one
  PBH mass statement found (preferred ~1e6 Msun scale; ref 35 in arXiv:2508.21748v2 is Carr & Kuhnel 2020) is a secondary mention in a paper
  retrieved outside the repo; the primary paper was not retrieved. That paper also points to "Not-quite-primordial black holes"
  (Qin et al. 2025, arXiv:2506.13858), which was not retrieved or read. No PBH number is used anywhere.
  The other agent's classifier threshold (seed >= 1e4, z_form >= 25) has no cited source and is not used.
* **Composite: UNAVAILABLE (PO-COMP-1).** The solver sweeps constant (lam, eps, duty) only.
* **Foundry J Verify Hamiltonian growth feasibility: UNAVAILABLE.** No `t022-growth-hamiltonian` branch exists locally or on origin;
  `/workspace/foundry-j/verify` is the J property harness with no growth results; `hamiltonian/` is a generic engine.
* **DCBH scenario models (t021-dcbh): UNAVAILABLE.** The branch has no commits beyond main; no formation-condition, mass-range, gas-supply or metallicity
  model exists in the repo. The heavy-seed family therefore says nothing specific about DCBH.
* Also missing: independent dynamical mass (t018), formation window (t019), M_target uncertainty, link between current L/L_Edd and the history, citations for the
  saturation prescription and for eps/duty priors (see list above).

## Open proof obligations

PO-PBH-1 (PBH mass/abundance source), PO-COMP-1 (time-varying histories), PO-SAT-1 (citation for lam_eff = 1 + ln lam), PO-DCBH-1 (DCBH
formation model), uncited eps/duty assumption sets (AFid/AGrid), M_target uncertainty/overshoot, current-lam link. The test checks that the "no output"
claims about t018/t021/t022 are still true on the tree (`cg.missing_evidence_claims_match_repo`); if a branch gains commits the test FAILs so the claim is revisited.

## Contradiction detection

Real evidence (verbatim): 

```
NO_CONTRADICTION in the evaluated evidence (models agree at lam<=1; min seed monotone in z_form, lam, duty, eps for both models; flags = (seed<=1e5); status counts 464/382)
CONTRADICTION_COUNT 0
```

SYNTHETIC negative control (`SYNTHETIC_models_and_monotone.csv`, built by run.sh: two real rows with corrupted min-seed fields). Verbatim from `tests/curry-growth/evidence/synthetic_detector.txt`:

```
DETECTED C-MODELS-AGREE: row 3 lam=0.5 eps=0.05 z_form=12 duty=0.5 simple=8.40344291E+005 saturated=9.99999999E+009
DETECTED C-MODELS-AGREE: row 39 lam=0.5 eps=0.1 z_form=20 duty=0.75 simple=1.00000000E-009 saturated=6.67834302E+005
DETECTED C-MONO-ZFORM-Simple: rows 39->44 (lam=0.5 eps=0.1 z_form=20 duty=0.75 -> lam=0.5 eps=0.1 z_form=25 duty=0.75) seed 1.0e-9 -> 462339.268
DETECTED C-MONO-LAM-Simple: rows 39->189 (lam=0.5 eps=0.1 z_form=20 duty=0.75 -> lam=0.75 eps=0.1 z_form=20 duty=0.75) seed 1.0e-9 -> 77182.3648
DETECTED C-MONO-DUTY-Simple: rows 39->40 (lam=0.5 eps=0.1 z_form=20 duty=0.75 -> lam=0.5 eps=0.1 z_form=20 duty=1) seed 1.0e-9 -> 158453.424
DETECTED C-MONO-EPS-Simple: rows 14->39 (lam=0.5 eps=0.05 z_form=20 duty=0.75 -> lam=0.5 eps=0.1 z_form=20 duty=0.75) seed 5522.19504 -> 1.0e-9
DETECTED C-MONO-DUTY-Saturated: rows 2->3 (lam=0.5 eps=0.05 z_form=12 duty=0.25 -> lam=0.5 eps=0.05 z_form=12 duty=0.5) seed 6482068.7 -> 9999999990.0
DETECTED C-MONO-EPS-Saturated: rows 3->28 (lam=0.5 eps=0.05 z_form=12 duty=0.5 -> lam=0.5 eps=0.1 z_form=12 duty=0.5) seed 9999999990.0 -> 7217907.85
DETECTED_MODELS_AGREE 2
DETECTED_MONOTONE 6
RESULT PASS contradiction_detector_fires_on_synthetic
GROWTH_SEARCH_SYNTHETIC_DONE
```

No contradiction was found in the real solver data. That is a statement about internal consistency only.

## Inference traces (verbatim from the exhaustive run)

```
TRACE light seed, benchmark tuple (expected: rejected)
CANDIDATE #12 family=LightSeed aset=AFid model=Simple row=340 lam=1 eps=0.1 z_form=20 duty=1
  RULE R-LIGHT-1: viable(LightSeed, Tuple) :- lam <= 1, simple and saturated min seeds agree (solver: identical for lam <= 1), reach M_target with light seed 150 Msun
  PROV CITED arXiv:2308.05735v2 (Furtak+ 2024, Nature 628, 57) Discussion: DELPHI model assumes a seed mass of 150 Msun from metal-free stars (a model assumption of that paper, used here only as the reference light-seed mass)
  PROV DEFINITION light seed = the single cited reference mass 150 Msun; no range is invented
  PROV DEFINITION at or below Eddington luminosity: lam <= 1 (lam is L/L_Edd, fortran/growth/STATUS.md)
  PROV SOLVER min seed from fixtures/growth/feasible_grid.csv; constant (lam, eps, duty) from z_form to z_obs = 7.04221; M_target = 5e7 Msun (Juodzbalis+ 2026)
  PROV ASSUMPTION(uncited) AFid: eps = 0.1 and duty = 1 (benchmark values of fortran/growth/STATUS.md; no paper cited for them)
  GOAL lam <= 1 => HOLDS: lam=1 <= 1
  GOAL simple and saturated min seeds agree (solver: identical for lam <= 1) => HOLDS: min_seed_simple=5.02149751E+002 equals min_seed_saturated=5.02149751E+002
  GOAL reach M_target with light seed 150 Msun => FAILS: min_seed_simple=5.02149751E+002 Msun > light seed 150 Msun [ratio 3.3477]: the seed cannot reach M_target=5e7 Msun by z_obs under constant (lam=1 eps=0.1 z_form=20 duty=1), model Simple
  => REJECTED (counterexample): min_seed_simple=5.02149751E+002 Msun > light seed 150 Msun [ratio 3.3477]: the seed cannot reach M_target=5e7 Msun by z_obs under constant (lam=1 eps=0.1 z_form=20 duty=1), model Simple
TRACE light seed, z_form 30 (expected: viable under assumptions)
CANDIDATE #14 family=LightSeed aset=AFid model=Simple row=350 lam=1 eps=0.1 z_form=30 duty=1
  RULE R-LIGHT-1: viable(LightSeed, Tuple) :- lam <= 1, simple and saturated min seeds agree (solver: identical for lam <= 1), reach M_target with light seed 150 Msun
  PROV CITED arXiv:2308.05735v2 (Furtak+ 2024, Nature 628, 57) Discussion: DELPHI model assumes a seed mass of 150 Msun from metal-free stars (a model assumption of that paper, used here only as the reference light-seed mass)
  PROV DEFINITION light seed = the single cited reference mass 150 Msun; no range is invented
  PROV DEFINITION at or below Eddington luminosity: lam <= 1 (lam is L/L_Edd, fortran/growth/STATUS.md)
  PROV SOLVER min seed from fixtures/growth/feasible_grid.csv; constant (lam, eps, duty) from z_form to z_obs = 7.04221; M_target = 5e7 Msun (Juodzbalis+ 2026)
  PROV ASSUMPTION(uncited) AFid: eps = 0.1 and duty = 1 (benchmark values of fortran/growth/STATUS.md; no paper cited for them)
  GOAL lam <= 1 => HOLDS: lam=1 <= 1
  GOAL simple and saturated min seeds agree (solver: identical for lam <= 1) => HOLDS: min_seed_simple=1.03132700E+002 equals min_seed_saturated=1.03132700E+002
  GOAL reach M_target with light seed 150 Msun => HOLDS: min_seed_simple=1.03132700E+002 Msun <= light seed 150 Msun [ratio 0.6876]
  => VIABLE UNDER ASSUMPTIONS (AFid) [seed ratio 0.6876]; not confirmed
TRACE heavy seed, lam 0.5 z_form 12 (expected: rejected)
CANDIDATE #15 family=HeavySeed aset=AFid model=Simple row=30 lam=0.5 eps=0.1 z_form=12 duty=1
  RULE R-HEAVY-1: viable(HeavySeed, Tuple) :- lam <= 1, simple and saturated min seeds agree (solver: identical for lam <= 1), reach M_target with heavy seed upper end 1e6 Msun
  PROV CITED arXiv:2308.05735v2 Discussion: hydrodynamic simulations 'typically starting with heavier seeds (10^(4-6) Msun)'; upper end 1e6 Msun used. Direct collapse is named in arXiv:2508.21748v2 as 'direct collapse of massive pristine clouds' without a mass range
  PROV DEFINITION heavy seed = any seed up to 1e6 Msun; reach test uses the upper end, so 'viable' means some seed in range suffices
  PROV DEFINITION at or below Eddington luminosity: lam <= 1
  PROV OPEN-PROOF-OBLIGATION PO-DCBH-1: DCBH-specific formation conditions, mass range, gas supply, metallicity (role 05, t021-dcbh) are not in the repo; this family is 'heavy seed', DCBH is one possible origin
  PROV SOLVER min seed from fixtures/growth/feasible_grid.csv
  PROV ASSUMPTION(uncited) AFid: eps = 0.1 and duty = 1 (benchmark values of fortran/growth/STATUS.md; no paper cited for them)
  GOAL lam <= 1 => HOLDS: lam=0.5 <= 1
  GOAL simple and saturated min seeds agree (solver: identical for lam <= 1) => HOLDS: min_seed_simple=1.04196387E+006 equals min_seed_saturated=1.04196387E+006
  GOAL reach M_target with heavy seed upper end 1e6 Msun => FAILS: min_seed_simple=1.04196387E+006 Msun > heavy seed upper end 1e6 Msun [ratio 1.0420]: the seed cannot reach M_target=5e7 Msun by z_obs under constant (lam=0.5 eps=0.1 z_form=12 duty=1), model Simple
  => REJECTED (counterexample): min_seed_simple=1.04196387E+006 Msun > heavy seed upper end 1e6 Msun [ratio 1.0420]: the seed cannot reach M_target=5e7 Msun by z_obs under constant (lam=0.5 eps=0.1 z_form=12 duty=1), model Simple
TRACE heavy seed, benchmark tuple (expected: viable under assumptions)
CANDIDATE #27 family=HeavySeed aset=AFid model=Simple row=340 lam=1 eps=0.1 z_form=20 duty=1
  RULE R-HEAVY-1: viable(HeavySeed, Tuple) :- lam <= 1, simple and saturated min seeds agree (solver: identical for lam <= 1), reach M_target with heavy seed upper end 1e6 Msun
  PROV CITED arXiv:2308.05735v2 Discussion: hydrodynamic simulations 'typically starting with heavier seeds (10^(4-6) Msun)'; upper end 1e6 Msun used. Direct collapse is named in arXiv:2508.21748v2 as 'direct collapse of massive pristine clouds' without a mass range
  PROV DEFINITION heavy seed = any seed up to 1e6 Msun; reach test uses the upper end, so 'viable' means some seed in range suffices
  PROV DEFINITION at or below Eddington luminosity: lam <= 1
  PROV OPEN-PROOF-OBLIGATION PO-DCBH-1: DCBH-specific formation conditions, mass range, gas supply, metallicity (role 05, t021-dcbh) are not in the repo; this family is 'heavy seed', DCBH is one possible origin
  PROV SOLVER min seed from fixtures/growth/feasible_grid.csv
  PROV ASSUMPTION(uncited) AFid: eps = 0.1 and duty = 1 (benchmark values of fortran/growth/STATUS.md; no paper cited for them)
  GOAL lam <= 1 => HOLDS: lam=1 <= 1
  GOAL simple and saturated min seeds agree (solver: identical for lam <= 1) => HOLDS: min_seed_simple=5.02149751E+002 equals min_seed_saturated=5.02149751E+002
  GOAL reach M_target with heavy seed upper end 1e6 Msun => HOLDS: min_seed_simple=5.02149751E+002 Msun <= heavy seed upper end 1e6 Msun [ratio 0.0005]
  => VIABLE UNDER ASSUMPTIONS (AFid) [seed ratio 0.0005]; not confirmed
TRACE super-Eddington, simple model, lam 1.5 z_form 12
CANDIDATE #30 family=SuperEddington aset=AFid model=Simple row=480 lam=1.5 eps=0.1 z_form=12 duty=1
  RULE R-SEDD-1: viable(SuperEddington, Tuple) :- lam > 1, reach M_target with light seed 150 Msun with lam > 1
  PROV CITED arXiv:2508.21748v2 main text: QSO1 'may still have experienced previous super-Eddington bursts' (qualitative; no rate or duration given)
  PROV DEFINITION super-Eddington: lam > 1
  PROV DEFINITION light reference seed 150 Msun rescued by lam > 1 growth
  PROV OPEN-PROOF-OBLIGATION PO-SAT-1: the saturated model lam_eff = 1 + ln(lam) is a prescription with no paper cited in fortran/growth (STATUS.md OPEN 2); the simple model (growth linear in lam) is an upper bound by construction
  PROV SOLVER min seed under the candidate's model from fixtures/growth/feasible_grid.csv
  PROV ASSUMPTION(uncited) AFid: eps = 0.1 and duty = 1 (benchmark values of fortran/growth/STATUS.md; no paper cited for them)
  GOAL lam > 1 => HOLDS: lam=1.5 > 1
  GOAL reach M_target with light seed 150 Msun with lam > 1 => FAILS: min_seed_simple=4.52499369E+002 Msun > light seed 150 Msun with lam > 1 [ratio 3.0167]: the seed cannot reach M_target=5e7 Msun by z_obs under constant (lam=1.5 eps=0.1 z_form=12 duty=1), model Simple
  => REJECTED (counterexample): min_seed_simple=4.52499369E+002 Msun > light seed 150 Msun with lam > 1 [ratio 3.0167]: the seed cannot reach M_target=5e7 Msun by z_obs under constant (lam=1.5 eps=0.1 z_form=12 duty=1), model Simple
TRACE super-Eddington, saturated model, lam 1.5 z_form 12
CANDIDATE #55 family=SuperEddington aset=AFid model=Saturated row=480 lam=1.5 eps=0.1 z_form=12 duty=1
  RULE R-SEDD-1: viable(SuperEddington, Tuple) :- lam > 1, reach M_target with light seed 150 Msun with lam > 1
  PROV CITED arXiv:2508.21748v2 main text: QSO1 'may still have experienced previous super-Eddington bursts' (qualitative; no rate or duration given)
  PROV DEFINITION super-Eddington: lam > 1
  PROV DEFINITION light reference seed 150 Msun rescued by lam > 1 growth
  PROV OPEN-PROOF-OBLIGATION PO-SAT-1: the saturated model lam_eff = 1 + ln(lam) is a prescription with no paper cited in fortran/growth (STATUS.md OPEN 2); the simple model (growth linear in lam) is an upper bound by construction
  PROV SOLVER min seed under the candidate's model from fixtures/growth/feasible_grid.csv
  PROV ASSUMPTION(uncited) AFid: eps = 0.1 and duty = 1 (benchmark values of fortran/growth/STATUS.md; no paper cited for them)
  GOAL lam > 1 => HOLDS: lam=1.5 > 1
  GOAL reach M_target with light seed 150 Msun with lam > 1 => FAILS: min_seed_saturated=9.40733197E+002 Msun > light seed 150 Msun with lam > 1 [ratio 6.2716]: the seed cannot reach M_target=5e7 Msun by z_obs under constant (lam=1.5 eps=0.1 z_form=12 duty=1), model Saturated
  => REJECTED (counterexample): min_seed_saturated=9.40733197E+002 Msun > light seed 150 Msun with lam > 1 [ratio 6.2716]: the seed cannot reach M_target=5e7 Msun by z_obs under constant (lam=1.5 eps=0.1 z_form=12 duty=1), model Saturated
TRACE primordial black hole, benchmark tuple (expected: unavailable)
CANDIDATE #92 family=PrimordialBH aset=AFid model=Simple row=340 lam=1 eps=0.1 z_form=20 duty=1
  RULE R-PBH-1: viable(PrimordialBH, Tuple) :- evidence for PO-PBH-1
  PROV OPEN-PROOF-OBLIGATION PO-PBH-1: no PBH abundance or mass-function source in the repo; the only PBH mass statement found (preferred ~1e6 Msun scale, ref 35 = Carr & Kuhnel 2020, quoted in arXiv:2508.21748v2) is a secondary citation, the primary paper was not retrieved
  PROV DEFINITION the classifier in curry/growth/GrowthClassify.curry labels PrimordialBH by (seed >= 1e4 and z_form >= 25); that threshold has no cited source and is NOT used here
  PROV ASSUMPTION(uncited) AFid: eps = 0.1 and duty = 1 (benchmark values of fortran/growth/STATUS.md; no paper cited for them)
  GOAL evidence for PO-PBH-1 => UNAVAILABLE: PO-PBH-1 missing: PBH mass/abundance source (primary paper) not retrieved; no abundance in repo
  => UNAVAILABLE PO-PBH-1: PBH mass/abundance source (primary paper) not retrieved; no abundance in repo
TRACE composite, benchmark tuple (expected: unavailable)
CANDIDATE #132 family=Composite aset=AFid model=Simple row=340 lam=1 eps=0.1 z_form=20 duty=1
  RULE R-COMP-1: viable(Composite, Tuple) :- evidence for PO-COMP-1
  PROV OPEN-PROOF-OBLIGATION PO-COMP-1: a composite history (e.g. heavy seed plus super-Eddington episodes) needs time-varying (lam, eps, duty); the solver sweeps constants only (fortran/growth/STATUS.md OPEN 3)
  PROV ASSUMPTION(uncited) AFid: eps = 0.1 and duty = 1 (benchmark values of fortran/growth/STATUS.md; no paper cited for them)
  GOAL evidence for PO-COMP-1 => UNAVAILABLE: PO-COMP-1 missing: time-varying growth history; solver only sweeps constant (lam, eps, duty)
  => UNAVAILABLE PO-COMP-1: time-varying growth history; solver only sweeps constant (lam, eps, duty)
```

## Self-check expectations

The expectations in the Curry self-checks were derived by hand from the solver's ODE (E = duty (1-eps)/eps lam_eff dt / t_Edd, min seed = 5e7 / e^E,
M_target = 5e7 Msun from Juodzbalis et al. 2026) before looking at the solver value, with tolerance windows. They are consistency checks of
the pipeline, not literature results.

## Limitations

* Constant (lam, eps, duty) from z_form to z_obs = 7.04221 only; z_form is a grid value (12..30), not a derived formation epoch.
* Reach test compares min seed to one reference mass per family (150 Msun light; 1e6 Msun upper end of a cited 1e4..1e6 range): "viable" for heavy seed means some seed in the range suffices.
* No overshoot test (the solver gives only the minimum seed to reach the target).
* Survivors say nothing about which scenario is true; none is confirmed.
* The run takes several minutes; the nondeterministic search is checked against a deterministic evaluation (`nondet_search_equals_deterministic`) and two independent runs are byte-identical (`report_deterministic`).
