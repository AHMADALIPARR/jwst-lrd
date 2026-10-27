"Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
 Licensed under AGPL-3.0-only plus the SnapKitty Opaque License (dual license, intentional).
 See LICENSE and SNAPKITTY_OPAQUE_LICENSE.md at the repository root.

 growthGrid: model of the QSO1 feasible-growth grid (Mission QSO1-DCBH-001,
 role 10 front end). Reads the LRD-GROWTH-v1 record written by the Fortran
 growth solver, reusing the LRD-REC-v1 parser of simplicialComplex (loaded
 first; see GROWTH_TOPO_DIR). A row is one swept tuple (lam, eps, z_form,
 duty) with the minimum feasible seed under the simple and saturated models.
 lam is the Eddington LUMINOSITY ratio; mdot is the physical accretion rate
 in units of L_Edd / c^2. The two are never conflated here either."

lobby _AddSlots: (|
  growthGrid = (|
    parent* = traits clonable.
    path <- ''.
    header <- nil.
    rows <- nil.
    commitment <- ''.

    "Parse an ES-format decimal (e.g. ' 5.0214975104612182E+002') as a float,
     digit by digit; no reliance on locale or runtime float parsing."
    floatFromES: t = ( | s. i <- 0. neg <- false. mant <- 0.0. ex <- 0. eneg <- false. d |
      s: t.
      [(i < s size) && [(s at: i) = ' ']] whileTrue: [ i: i + 1 ].
      ((i < s size) && [(s at: i) = '-']) ifTrue: [ neg: true. i: i + 1 ].
      [(i < s size) && [(s at: i) isDigit]] whileTrue: [
        mant: (mant * 10.0) + ((s at: i) asByte - '0' asByte) asFloat. i: i + 1 ].
      ((i < s size) && [(s at: i) = '.']) ifTrue: [ | sc <- 0.1 |
        i: i + 1.
        [(i < s size) && [(s at: i) isDigit]] whileTrue: [
          mant: mant + (((s at: i) asByte - '0' asByte) asFloat * sc). sc: sc * 0.1. i: i + 1 ] ].
      ((i < s size) && [((s at: i) = 'E') || [(s at: i) = 'e']]) ifTrue: [
        i: i + 1.
        ((i < s size) && [(s at: i) = '-']) ifTrue: [ eneg: true. i: i + 1 ].
        ((i < s size) && [(s at: i) = '+']) ifTrue: [ i: i + 1 ].
        [(i < s size) && [(s at: i) isDigit]] whileTrue: [
          ex: (ex * 10) + ((s at: i) asByte - '0' asByte). i: i + 1 ] ].
      1 to: ex Do: [|:k| eneg ifTrue: [ mant: mant / 10.0 ] False: [ mant: mant * 10.0 ] ].
      neg ifTrue: [ 0.0 - mant ] False: [ mant ] ).

    "Approximate log10 of a positive float by scaling; for chart layout only."
    log10Approx: x = ( | v. n <- 0 |
      v: x.
      [v >= 10.0] whileTrue: [ v: v / 10.0. n: n + 1 ].
      [v < 1.0] whileTrue: [ v: v * 10.0. n: n - 1 ].
      n asFloat + ((v - 1.0) / 9.0) ).

    "Zero-pad an integer to width 6 (record key row index)."
    pad6: i = ( | s |
      s: i printString.
      [s size < 6] whileTrue: [ s: '0', s ].
      s ).

    copyFromFile: p = ( | g. recs. rec. n |
      g: clone.
      g path: p.
      recs: simplicialComplex parseRecords: p asFileContents
             IfFail: [|:m| error: m ].
      rec: recs first.
      (rec at: 'format') = 'LRD-GROWTH-v1'
        ifFalse: [ error: 'growthGrid: bad format' ].
      g header: rec.
      n: (rec at: 'n_rows') asInteger.
      g rows: vector copySize: n.
      1 to: n Do: [|:i. pre. row |
        pre: 'row.', (g pad6: i), '.'.
        row: dictionary copyRemoveAll.
        ('lam eps zform duty dt_myr mdot seed_simple seed_sat feas_simple feas_sat'
           splitOn: ' ') do: [|:f|
          row at: f Put: (g floatFromES: (rec at: pre, f)) ].
        g rows at: i - 1 Put: row ].
      g commitment: (p, '.commit') asFileContents
                      copyFrom: 0 UpTo: 64.
      g ).

    nRows = ( rows size ).
    nFeasibleSimple = ( | c <- 0 |
      rows do: [|:r| ((r at: 'feas_simple') = 1.0) ifTrue: [ c: c + 1 ] ]. c ).
    nFeasibleSat = ( | c <- 0 |
      rows do: [|:r| ((r at: 'feas_sat') = 1.0) ifTrue: [ c: c + 1 ] ]. c ).

    rowLam: lam Eps: eps ZForm: zf Duty: du = (
      rows do: [|:r|
        (((r at: 'lam') - lam) absoluteValue < 0.000001) ifTrue: [
          (((r at: 'eps') - eps) absoluteValue < 0.000001) ifTrue: [
            (((r at: 'zform') - zf) absoluteValue < 0.000001) ifTrue: [
              (((r at: 'duty') - du) absoluteValue < 0.000001) ifTrue: [ ^ r ] ] ] ] ].
      nil ).

    benchmarkSeed = ( | r |
      r: rowLam: 1.0 Eps: 0.1 ZForm: 20.0 Duty: 1.0.
      (r = nil) ifTrue: [ 0.0 ] False: [ r at: 'seed_simple' ] ).

    summary = (
      'SELF GROWTH format=', (header at: 'format'),
      ' rows=', nRows printString,
      ' feasible_simple=', nFeasibleSimple printString,
      ' feasible_sat=', nFeasibleSat printString,
      ' benchmark_seed=', benchmarkSeed printString,
      ' commit=', commitment ).
  |).
|).
