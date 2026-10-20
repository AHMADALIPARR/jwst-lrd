"Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
 Licensed under AGPL-3.0-only plus the SnapKitty Opaque License (dual license, intentional).
 See LICENSE and SNAPKITTY_OPAQUE_LICENSE.md at the repository root.

 growthMorph: Morphic (ui2) view of a growthGrid. Draws the feasible region
 for the benchmark slice (eps = 0.1, duty = 1, simple model): minimum seed
 against formation redshift for lam = 0.5, 1, 3, on a log seed axis with the
 swept seed-range band (10 to 1e5 Msun) marked. Below the chart: the swept
 counts, the benchmark seed, the target mass and the record commitment
 (provenance), in the same layout idiom as simplicialComplexMorph.
 Requires a world built with -o morphic and growthHistory.self loaded."

lobby _AddSlots: (| growthMorph = morph copy |).

growthMorph _AddSlots: (|
  grid <- nil.

  copyOnGrid: g = ( | m |
    m: copy.
    m grid: g.
    m setWidth: 460 Height: 520.
    m color: paint named: 'white'.
    m ).

  "Chart point for a seed at formation redshift zf. Plot area: origin
   o + (60 @ 30), 360 wide (z 12..30), 290 tall (log10 seed 8 at top, -5 at
   bottom)."
  pointForSeed: seed ZForm: zf Origin: o = ( | lg |
    lg: grid log10Approx: seed.
    o + (((zf - 12.0) * 20.0) asInteger @ (30 + ((8.0 - lg) * 22.307692) asInteger)) ).

  baseDrawOn: cv = ( | o. ink. band. series |
    o: baseBounds origin.
    ink: paint named: 'black'.
    band: paint named: 'lightGray'.
    cv fillRectangle: baseBounds Color: (paint named: 'white').
    "seed-range band: log10 seed 1..5"
    cv fillRectangle: ((o + (60 @ 96)) # (o + (420 @ 204))) Color: band.
    cv text: 'seed range 10..1e5' At: o + (64 @ 100) Color: ink.
    cv text: 'z_form ->' At: o + (60 @ 326) Color: ink.
    cv text: 'min seed (log)' At: o + (60 @ 16) Color: ink.
    series: vector copySize: 3.
    series at: 0 Put: (0.5 & (paint named: 'blue')).
    series at: 1 Put: (1.0 & (paint named: 'black')).
    series at: 2 Put: (3.0 & (paint named: 'red')).
    series do: [|:pr. lam. col. prev |
      lam: pr first.
      col: pr last.
      prev: nil.
      (12 & 15 & 20 & 25 & 30) asVector do: [|:zf. r. pt|
        r: grid rowLam: lam Eps: 0.1 ZForm: zf asFloat Duty: 1.0.
        (r = nil) ifFalse: [
          pt: pointForSeed: (r at: 'seed_simple') ZForm: zf asFloat Origin: o.
          cv fillCircleCenteredAt: pt Diameter: 8 Color: col.
          (prev = nil) ifFalse: [ cv line: prev To: pt Width: 2 Color: col ].
          prev: pt ] ].
      cv text: ('lam=', lam printString) At: o + (428 @ (40 + ((lam * 20.0) asInteger))) Color: col ].
    cv text: 'QSO1 growth: feasible region (eps=0.1 duty=1 simple)'
         At: o + (10 @ 412) Color: ink.
    cv text: ('rows=', grid nRows printString,
              '  feasible_simple=', grid nFeasibleSimple printString,
              '  feasible_sat=', grid nFeasibleSat printString)
         At: o + (10 @ 432) Color: ink.
    cv text: ('target=', (grid header at: 'm_target_msun'),
              '  benchmark seed=', grid benchmarkSeed printString)
         At: o + (10 @ 452) Color: ink.
    cv text: ('commit=', (grid commitment copyFrom: 0 UpTo: 32)) At: o + (10 @ 472) Color: ink.
    cv text: ('      ', (grid commitment copyFrom: 32 UpTo: 64)) At: o + (10 @ 492) Color: ink.
    self ).
|).
