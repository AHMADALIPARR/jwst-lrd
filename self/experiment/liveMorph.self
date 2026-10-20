"SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
 Live native Morphic renderer. Astronomy data and illustrative state geometry
 stay separate. No frames are generated in the HTTP transport."
lobby _AddSlots: (| lrdLiveMorph = lrdExperimentMorph copy |).
lrdLiveMorph _AddSlots: (|
  tick <- 0.
  playing <- true.
  background = ( paint copyRed: 0.025 Green: 0.035 Blue: 0.065 ).
  panelColor = ( paint copyRed: 0.05 Green: 0.065 Blue: 0.10 ).
  ink = ( paint copyRed: 0.88 Green: 0.92 Blue: 0.96 ).
  muted = ( paint copyRed: 0.33 Green: 0.42 Blue: 0.52 ).
  accent = ( paint copyRed: 0.18 Green: 0.80 Blue: 0.91 ).
  ember = ( paint copyRed: 1.0 Green: 0.27 Blue: 0.30 ).
  addControls = (
    button: 'Efficiency' At: (24 @ 91) Script: [ target model cycleEpsilon. target changed ].
    button: 'Duty' At: (130 @ 91) Script: [ target model cycleDuty. target changed ].
    button: 'Lambda' At: (205 @ 91) Script: [ target model cycleLambda. target changed ].
    button: 'Formation z' At: (288 @ 91) Script: [ target model cycleFormation. target changed ].
    button: 'Growth model' At: (403 @ 91) Script: [ target model toggleModel. target changed ].
    button: 'Polar angle' At: (530 @ 91) Script: [ target model cycleTheta. target changed ].
    button: 'Phase' At: (645 @ 91) Script: [ target model cyclePhase. target changed ].
    button: 'Play / pause' At: (735 @ 91) Script: [ target playing: target playing not. target changed ].
    button: 'Reset' At: (870 @ 91) Script: [ target model reset. target tick: 0. target changed ].
    self ).
  phase = ( (((tick + model sphere phaseSteps) % 256) asFloat * model sphere pi) / 128.0 ).
  effectiveState = ( blochState copyTheta: model sphere thetaSteps Phase: (tick + model sphere phaseSteps) ).
  step = ( playing ifTrue: [ tick: (tick + 1) % 256. changed ]. self ).
  panelAt: p Extent: e Title: title On: cv = (
    cv fillRectangle: ((baseBounds origin + p) # (baseBounds origin + p + e)) Color: panelColor.
    text: title At: p + (16 @ 24) On: cv ).
  drawObservedWave: cv = ( | previous. x. y. range. value. err |
    panelAt: (24 @ 145) Extent: (780 @ 290) Title: '01 / OBSERVED WAVEFORM   -   QSO1 NIRSPEC / PRISM' On: cv.
    range: spectrum maxFlux - spectrum minFlux.
    range = 0.0 ifTrue: [ range: 1.0 ]. previous: nil.
    spectrum flux size do: [|:i|
      (spectrum validAt: i) ifTrue: [
        x: 75 + ((((spectrum wavelength at: i) - 0.5) / 5.0) * 670.0) asInteger.
        value: spectrum flux at: i.
        y: 373 - (((value - spectrum minFlux) / range) * 170.0) asInteger.
        ((x >= 75) && [x <= 745]) ifTrue: [
          err: ((((spectrum sigma at: i) / range) * 170.0) asInteger) min: 170.
          lineFrom: (x @ ((y - err) max: 195)) To: (x @ ((y + err) min: 380)) On: cv Color: muted.
          previous isNil ifFalse: [ lineFrom: previous To: (x @ y) On: cv Color: accent ].
          previous: x @ y ]
      ] False: [ previous: nil ] ].
    lineFrom: (75 @ 385) To: (745 @ 385) On: cv Color: muted.
    text: '0.5                         observed wavelength [um]                           5.5' At: (75 @ 402) On: cv.
    text: ('flux [Jy] +/- sigma | 429 archived samples | excluded=', spectrum excluded printString) At: (42 @ 423) On: cv ).
  drawRedDot: cv = ( | center. state. r. col. radius. p. previous |
    panelAt: (24 @ 455) Extent: (780 @ 345) Title: '02 / RED-DOT STATE   +   PHASE WAVE' On: cv.
    state: effectiveState. center: 205 @ 625.
    16 reverseDo: [|:i|
      r: 24 + (i * 9).
      col: paint copyRed: (0.14 + ((16 - i) asFloat * 0.045))
        Green: 0.035 Blue: 0.065.
      cv fillCircleCenteredAt: baseBounds origin + center Diameter: r Color: col ].
    radius: 48 + ((phase sin * 8.0) asInteger).
    cv fillCircleCenteredAt: baseBounds origin + center Diameter: radius Color: ember.
    cv fillCircleCenteredAt: baseBounds origin + center Diameter: 14 Color: ink.
    text: ('polar=', model sphere thetaSteps printString, '/128 | phase=', ((tick + model sphere phaseSteps) % 256) printString, '/256')
      At: (365 @ 525) On: cv.
    text: ('P(N)=', state probNorthMilli printString, '/1000   P(S)=', state probSouthMilli printString, '/1000')
      At: (365 @ 550) On: cv.
    text: ('atlas radius^2=', state projRadiusSq printString) At: (365 @ 575) On: cv.
    previous: nil.
    181 do: [|:i. a. y|
      a: ((i asFloat / 180.0) * (4.0 * model sphere pi)) + phase.
      y: 660 - (a sin * 44.0) asInteger.
      p: (365 + (i * 2)) @ y.
      previous isNil ifFalse: [ lineFrom: previous To: p On: cv Color: ember ].
      previous: p ].
    lineFrom: (365 @ 660) To: (725 @ 660) On: cv Color: muted.
    text: 'Derived phase wave; no temporal signal inferred from JWST.' At: (365 @ 733) On: cv.
    text: 'Illustrative nucleus / state projection. No resolved image or physical helix is claimed.' At: (42 @ 779) On: cv ).
  helixPoint: i Offset: offset = ( | t. a |
    t: i asFloat / 160.0.
    a: ((t * 5.0) * model sphere pi) + phase + offset.
    (1105 + (a cos * 165.0) asInteger) @
      (270 + (t * 390.0) asInteger + (a sin * 28.0) asInteger) ).
  drawHelix: cv = ( | previousA. previousB. a. b |
    panelAt: (830 @ 145) Extent: (565 @ 655) Title: '03 / LIVE HELIX   -   MODEL PHASE GEOMETRY' On: cv.
    previousA: nil. previousB: nil.
    161 do: [|:i|
      a: helixPoint: i Offset: 0.0.
      b: helixPoint: i Offset: model sphere pi.
      ((i % 8) = 0) ifTrue: [ lineFrom: a To: b On: cv Color: muted ].
      previousA isNil ifFalse: [
        lineFrom: previousA To: a On: cv Color: accent.
        lineFrom: previousB To: b On: cv Color: ember ].
      previousA: a. previousB: b ].
    cv fillCircleCenteredAt: baseBounds origin + (helixPoint: tick % 161 Offset: 0.0) Diameter: 10 Color: ink.
    text: 'Self computes each frame from an integer phase state.' At: (850 @ 720) On: cv.
    text: ('frame phase=', tick printString, ' | ', (playing ifTrue: 'RUNNING' False: 'PAUSED')) At: (850 @ 745) On: cv.
    text: 'A model visualization; not observed red-dot morphology.' At: (850 @ 775) On: cv ).
  baseDrawOn: cv = ( | r |
    cv fillRectangle: baseBounds Color: background.
    text: 'L R D  /  LIVE SELF-MORPHIC OBSERVATORY' At: (24 @ 32) On: cv.
    text: 'ABELL 2744-QSO1  |  archived spectrum + animated model geometry  |  native Self frames'
      At: (24 @ 61) On: cv.
    drawObservedWave: cv. drawRedDot: cv. drawHelix: cv.
    panelAt: (24 @ 820) Extent: (1371 @ 130) Title: 'INVARIANTS / PROVENANCE' On: cv.
    r: model selectedRow.
    text: ('epsilon=', model epsilon printString, ' duty=', model duty printString, ' lambda=', model lambda printString,
      ' z_form=', model formation printString, ' model=', (model saturated ifTrue: 'saturated' False: 'simple'),
      ' | seed=', (model seedFor: r) printString, ' Msun') At: (42 @ 866) On: cv.
    text: model proofSummary At: (42 @ 890) On: cv.
    text: ('Observation SHA256: ', spectrum source) At: (42 @ 913) On: cv.
    text: 'Continuous-growth and runtime bridges are explicit assumptions; animation is not an empirical discovery.' At: (42 @ 936) On: cv.
    self ).
|).
lrdWorkspace _AddSlots: (|
  openLive = ( | m. s |
    m: lrdExperiment copyFromRoot: lrdRoot. s: lrdSpectrum copyFromRoot: lrdRoot.
    desktop openNewWorldOnDisplay: (os environmentAt: 'DISPLAY' IfFail: '')
      Bounds: ((0 @ 0) # (1460 @ 1020)).
    view: lrdLiveMorph copyOn: m Spectrum: s.
    view position: 12 @ 12. desktop w addMorph: view.
    worldMorph desiredFrameTime: 80.
    view startGettingStepped. view changed.
    'LRD_LIVE_OPEN' printLine. self ).
|).
