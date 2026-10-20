"SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
 Native Self/Morphic research workspace. All chart marks come from loaded records."
lobby _AddSlots: (| lrdExperimentMorph = morph copy |).
lrdExperimentMorph _AddSlots: (|
  model <- nil.
  spectrum <- nil.
  ink = ( paint named: 'black' ).
  muted = ( paint named: 'gray' ).
  accent = ( paint named: 'blue' ).
  good = ( paint named: 'green' ).
  bad = ( paint named: 'red' ).
  copyOn: m Spectrum: s = ( | v |
    v: copyRemoveAllMorphs. v model: m. v spectrum: s.
    v setWidth: 1420 Height: 970. v color: paint named: 'white'.
    v addControls. v ).
  button: title At: p Script: script = ( | b |
    b: ui2Button copyColor: (paint named: 'lightGray') Target: self.
    b label: title. b scriptBlock: script.
    addMorph: b. b position: position + p. self ).
  addControls = (
    button: 'Efficiency' At: (24 @ 91) Script: [ target model cycleEpsilon. target changed ].
    button: 'Duty cycle' At: (135 @ 91) Script: [ target model cycleDuty. target changed ].
    button: 'Luminosity ratio' At: (244 @ 91) Script: [ target model cycleLambda. target changed ].
    button: 'Formation z' At: (385 @ 91) Script: [ target model cycleFormation. target changed ].
    button: 'Simple / saturated' At: (505 @ 91) Script: [ target model toggleModel. target changed ].
    button: 'Reset' At: (682 @ 91) Script: [ target model reset. target changed ].
    button: 'Topology fixture' At: (850 @ 91) Script: [ target model cycleTopology. target changed ].
    button: 'Polar angle' At: (1020 @ 91) Script: [ target model cycleTheta. target changed ].
    button: 'Phase' At: (1140 @ 91) Script: [ target model cyclePhase. target changed ].
    self ).
  text: s At: p On: cv = ( cv text: s At: baseBounds origin + p Color: ink ).
  lineFrom: a To: b On: cv Color: col = (
    cv line: baseBounds origin + a To: baseBounds origin + b Width: 1 Color: col ).
  panelAt: p Extent: e Title: title On: cv = (
    cv fillRectangle: ((baseBounds origin + p) # (baseBounds origin + p + e))
      Color: paint named: 'lightGray'.
    cv fillRectangle: ((baseBounds origin + p + (1 @ 1)) # ((baseBounds origin + p + e) - (1 @ 1)))
      Color: paint named: 'white'.
    text: title At: p + (16 @ 22) On: cv ).
  seedPoint: r = ( | x. lg. y |
    x: 95 + (((r at: 'zform') - 12.0) * 34.0) asInteger.
    lg: (model seedFor: r) base10Log.
    y: 420 - ((((lg max: -5.0) min: 8.0) + 5.0) * 16.0).
    x @ y asInteger ).
  drawGrowth: cv = ( | selected. prev. col |
    panelAt: (24 @ 145) Extent: (780 @ 335) Title: '01  /  GROWTH HISTORIES' On: cv.
    text: ('epsilon=', model epsilon printString, '  duty=', model duty printString,
      '  model=', (model saturated ifTrue: 'saturated' False: 'simple')) At: (42 @ 193) On: cv.
    cv fillRectangle: ((baseBounds origin + (95 @ 260)) # (baseBounds origin + (707 @ 324)))
      Color: paint named: 'lightGray'.
    text: 'swept seed interval: 10 .. 100000 solar masses' At: (105 @ 278) On: cv.
    (-5 & 0 & 1 & 3 & 5 & 8) asVector do: [|:tick. y|
      y: 420 - ((tick + 5) * 16).
      lineFrom: (90 @ y) To: (710 @ y) On: cv Color: muted.
      text: ('10^', tick printString) At: (42 @ y) On: cv ].
    model lamValues do: [|:lam|
      prev: nil. col: muted.
      (lam = model lambda) ifTrue: [ col: accent ].
      model formValues do: [|:zf. r. pt|
        r: model grid rowLam: lam Eps: model epsilon ZForm: zf Duty: model duty.
        pt: seedPoint: r.
        prev isNil ifFalse: [ lineFrom: prev To: pt On: cv Color: col ].
        cv fillCircleCenteredAt: baseBounds origin + pt Diameter: 6
          Color: ((model rowIsFeasible: r) ifTrue: good False: bad).
        prev: pt ] ].
    model formValues do: [|:zf|
      text: zf printString At: ((95 + ((zf - 12.0) * 34.0) asInteger) @ 440) On: cv ].
    selected: model selectedRow.
    cv fillCircleCenteredAt: baseBounds origin + (seedPoint: selected) Diameter: 12 Color: accent.
    text: ('formation redshift  |  selected lambda=', model lambda printString,
      '  feasible=', model sliceFeasibleCount printString, '/', model sliceRows size printString)
      At: (42 @ 465) On: cv ).
  drawSpectrum: cv = ( | prev. lo. hi. span. yspan. pt. x. y. err |
    panelAt: (24 @ 500) Extent: (780 @ 300) Title: '02  /  QSO1 IMAGE A - ARCHIVED NIRSPEC SPECTRUM' On: cv.
    lo: 0.5. hi: 5.5.
    span: hi - lo. yspan: spectrum maxFlux - spectrum minFlux.
    yspan = 0.0 ifTrue: [ yspan: 1.0 ].
    prev: nil.
    spectrum flux size do: [|:i|
      (spectrum validAt: i) ifTrue: [
        x: 80 + ((((spectrum wavelength at: i) - lo) / span) * 650.0) asInteger.
        y: 735 - ((((spectrum flux at: i) - spectrum minFlux) / yspan) * 170.0) asInteger.
        pt: x @ y.
        ((x >= 80) && [x <= 730]) ifTrue: [
          err: (((spectrum sigma at: i) / yspan) * 170.0) asInteger min: 170.
          lineFrom: (x @ ((y - err) max: 550)) To: (x @ ((y + err) min: 750)) On: cv Color: muted.
          prev isNil ifFalse: [ lineFrom: prev To: pt On: cv Color: accent ].
          prev: pt ]
      ] False: [ prev: nil ] ].
    lineFrom: (80 @ 750) To: (730 @ 750) On: cv Color: ink.
    text: 'observed wavelength [um]  0.5                                    5.5' At: (80 @ 770) On: cv.
    text: ('flux [Jy], +/-1 sigma | samples=', spectrum flux size printString,
      ' excluded (nonfinite or nonpositive sigma)=', spectrum excluded printString) At: (42 @ 790) On: cv ).
  topologyPoint: label = ( | p |
    p: model topology pointOfLabel: label.
    (870 + (p x asFloat * 0.8) asInteger) @ (165 + (p y asFloat * 0.55) asInteger) ).
  drawTopology: cv = ( | c |
    c: model topology.
    panelAt: (830 @ 145) Extent: (565 @ 335) Title: '03  /  TOPOLOGICAL INVARIANT' On: cv.
    (c indicesOfDim: 2) do: [|:i. pts. vs|
      vs: c vertices: i. pts: vector copySize: 3.
      3 do: [|:j| pts at: j Put: baseBounds origin + (topologyPoint: (vs at: j)) ].
      cv fillPolygon: pts Color: paint named: 'lightGray' ].
    (c indicesOfDim: 1) do: [|:i. vs|
      vs: c vertices: i.
      lineFrom: (topologyPoint: vs first) To: (topologyPoint: vs last) On: cv Color: accent ].
    (c indicesOfDim: 0) do: [|:i|
      cv fillCircleCenteredAt: baseBounds origin + (topologyPoint: (c vertices: i) first)
        Diameter: 9 Color: bad ].
    text: c name At: (850 @ 410) On: cv.
    text: ('Betti=', (c listString: c betti), '  Euler=', c eulerCharacteristic printString,
      '  field=', c field) At: (850 @ 433) On: cv.
    text: ('incidence / Euler-Betti / header: ', model topologyChecks printString) At: (850 @ 456) On: cv ).
  drawBloch: cv = ( | s. center. pt. prev |
    s: model sphere. center: 970 @ 640.
    panelAt: (830 @ 500) Extent: (565 @ 300) Title: '04  /  BOUNDED TWO-CHART STATE VIEW' On: cv.
    prev: center + (90 @ 0).
    1 to: 64 Do: [|:i. a. p|
      a: ((i asFloat * 2.0) * s pi) / 64.0.
      p: center + ((a cos * 90.0) asInteger @ (0 - (a sin * 90.0) asInteger)).
      lineFrom: prev To: p On: cv Color: muted. prev: p ].
    pt: center + ((s projX * 90.0) asInteger @ (0 - (s projY * 90.0) asInteger)).
    lineFrom: center To: pt On: cv Color: accent.
    cv fillCircleCenteredAt: baseBounds origin + pt Diameter: 12 Color: bad.
    text: ('chart=', s chart) At: (1090 @ 568) On: cv.
    text: ('theta=', s thetaSteps printString, '/128') At: (1090 @ 593) On: cv.
    text: ('phase=', s phaseSteps printString, '/256') At: (1090 @ 618) On: cv.
    text: ('X=', s projXFixed printString, ' /1000') At: (1090 @ 643) On: cv.
    text: ('Y=', s projYFixed printString, ' /1000') At: (1090 @ 668) On: cv.
    text: ('radius^2=', s projRadiusSq printString) At: (1090 @ 693) On: cv.
    text: 'Representation of a two-level state; not a QSO1 measurement.' At: (850 @ 762) On: cv.
    text: 'Integer phase storage; derived coordinates use Self floating point.' At: (850 @ 784) On: cv ).
  drawEvidence: cv = ( | r |
    r: model selectedRow.
    panelAt: (24 @ 820) Extent: (1371 @ 130) Title: 'EVIDENCE / ASSUMPTIONS / PROOF BOUNDARY' On: cv.
    text: ('Selected minimum seed=', (model seedFor: r) printString,
      ' Msun | feasible within swept bounds=', (model rowIsFeasible: r) printString,
      ' | mdot=', (r at: 'mdot') printString) At: (42 @ 865) On: cv.
    text: ('Observation SHA256: ', spectrum source) At: (42 @ 889) On: cv.
    text: ('Growth record commitment (loaded, not rehashed by UI): ', model grid commitment) At: (42 @ 913) On: cv.
    text: (model proofSummary, ' | continuous-growth and runtime bridges are conditional.')
      At: (42 @ 937) On: cv ).
  baseDrawOn: cv = (
    cv fillRectangle: baseBounds Color: paint named: 'white'.
    text: 'L R D   /   EXPERIMENT WORKSPACE' At: (24 @ 32) On: cv.
    text: 'ABELL 2744-QSO1     |     Self / Morphic     |     observations, hypotheses, invariants' At: (24 @ 60) On: cv.
    drawGrowth: cv. drawSpectrum: cv. drawTopology: cv. drawBloch: cv. drawEvidence: cv.
    self ).
|).
