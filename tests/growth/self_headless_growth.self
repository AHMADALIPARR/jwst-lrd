"Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
 Licensed under AGPL-3.0-only plus the SnapKitty Opaque License (dual license, intentional).

 Headless Self test of self/growth/growthHistory.self (no Morphic needed).
 Run as: Self -f worldBuilder.self -b <objects> -o none -f2 self_headless_growth.self
 Environment: GROWTH_SELF_DIR, GROWTH_TOPO_DIR, GROWTH_REC.
 Prints PASS/FAIL lines, the SELF GROWTH summary line, and SELF_GROWTH_DONE.
 Cross-checks against the Fortran dataset are done by tests/growth/run.sh
 (the SELF GROWTH counts must equal the CSV counts)."

((os environmentAt: 'GROWTH_TOPO_DIR' IfFail: '.'), '/simplicialComplex.self') runScript.
((os environmentAt: 'GROWTH_SELF_DIR' IfFail: '.'), '/growthHistory.self') runScript.

[| g. check. r1. r2. |
  check: [|:name. :ok. :why| ok ifTrue: [ ('PASS ', name) printLine ]
                               False: [ ('FAIL ', name, ' ', why) printLine ] ].
  g: growthGrid copyFromFile:
       (os environmentAt: 'GROWTH_REC' IfFail: 'fixtures/growth/feasible_grid.rec').
  g summary printLine.
  check value: 'self_growth_rows_1200' With: (g nRows = 1200) With: g nRows printString.
  check value: 'self_growth_some_feasible' With: (g nFeasibleSimple > 0)
        With: g nFeasibleSimple printString.
  check value: 'self_growth_some_infeasible' With: (g nFeasibleSimple < 1200)
        With: g nFeasibleSimple printString.
  check value: 'self_growth_sat_le_simple' With: (g nFeasibleSat <= g nFeasibleSimple)
        With: 'saturated feasible exceeds simple'.
  check value: 'self_growth_benchmark_seed'
        With: ((g benchmarkSeed > 480.0) && [g benchmarkSeed < 525.0])
        With: g benchmarkSeed printString.
  r1: g rowLam: 3.0 Eps: 0.3 ZForm: 30.0 Duty: 1.0.
  r2: g rowLam: 0.5 Eps: 0.3 ZForm: 30.0 Duty: 1.0.
  check value: 'self_growth_lookup_found' With: ((r1 = nil) not && [(r2 = nil) not])
        With: 'row lookup missed'.
  ((r1 = nil) not && [(r2 = nil) not]) ifTrue: [
    check value: 'self_growth_seed_falls_with_lam'
          With: ((r1 at: 'seed_simple') < (r2 at: 'seed_simple'))
          With: 'seed does not fall as lam rises' ].
  check value: 'self_growth_commit_64' With: (g commitment size = 64)
        With: g commitment size printString.
  'SELF_GROWTH_DONE' printLine.
] value.
_Quit
