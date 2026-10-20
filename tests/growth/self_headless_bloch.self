"Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
 Licensed under AGPL-3.0-only plus the SnapKitty Opaque License (dual license, intentional).

 Headless Self test of self/growth/blochSphere.self (no Morphic needed).
 Run as: Self -f worldBuilder.self -b <objects> -o none -f2 self_headless_bloch.self
 Environment: GROWTH_SELF_DIR.
 Prints PASS/FAIL lines and SELF_BLOCH_DONE.
 Uses the VM's single-precision tolerance. The full quantized atlas
 sweep is also covered by tests/morphic/model.self."

((os environmentAt: 'GROWTH_SELF_DIR' IfFail: '.'), '/blochSphere.self') runScript.

[| check. near. n. eq. s |
  check: [|:name. :ok. :why| ok ifTrue: [ ('PASS ', name) printLine ]
                               False: [ ('FAIL ', name, ' ', why) printLine ] ].
  near: [|:v. :w| ((v - w) absoluteValue) < 0.00001 ].

  "north pole: theta = 0"
  n: blochState copyTheta: 0 Phase: 0.
  check value: 'bloch_north_pole_vector' With: ((near value: n x With: 0.0) && [near value: n z With: 1.0])
        With: 'north pole vector wrong'.
  check value: 'bloch_north_pole_chart' With: (n chart = 'S') With: n chart.
  check value: 'bloch_north_pole_proj' With: ((n projXFixed = 0) && [n projYFixed = 0])
        With: 'north pole must project to the disk center'.
  check value: 'bloch_north_pole_prob' With: ((n probNorthMilli = 1000) && [n probSouthMilli = 0])
        With: 'north pole probabilities wrong'.

  "south pole: theta = 128 steps = pi"
  s: blochState copyTheta: 128 Phase: 64.
  check value: 'bloch_south_pole_vector' With: ((near value: s x With: 0.0) && [near value: s z With: -1.0])
        With: 'south pole vector wrong'.
  check value: 'bloch_south_pole_chart' With: (s chart = 'N') With: s chart.
  check value: 'bloch_south_pole_proj' With: ((s projXFixed = 0) && [s projYFixed = 0])
        With: 'south pole must project to the disk center in chart N'.

  "equator: theta = 64 steps = pi/2, phase 0 -> +x, radius 1"
  eq: blochState copyTheta: 64 Phase: 0.
  check value: 'bloch_equator_vector' With: ((near value: eq x With: 1.0) && [near value: eq z With: 0.0])
        With: 'equator vector wrong'.
  check value: 'bloch_equator_rim' With: ((eq projRadiusSq > 0.998) && [eq projRadiusSq < 1.001])
        With: eq projRadiusSq printString.

  "phase crystallization: advance is integer-only and wraps at 256"
  eq advancePhase: 256.
  check value: 'bloch_phase_wrap_full' With: (eq phaseSteps = 0) With: eq phaseSteps printString.
  eq advancePhase: -1.
  check value: 'bloch_phase_wrap_negative' With: (eq phaseSteps = 255) With: eq phaseSteps printString.

  "bounded atlas sweep: every quantized state lands in the unit disk"
  [| ok <- true |
    0 to: 128 Do: [|:ts|
      (0 & 64 & 128 & 192) asVector do: [|:ps. st|
        st: blochState copyTheta: ts Phase: ps.
        (st projRadiusSq > 1.000001) ifTrue: [ ok: false ] ] ].
    check value: 'bloch_atlas_bounded' With: ok With: 'a state escaped the unit disk' ].

  'SELF BLOCH theta=0..128 phase=0..255 charts=N+S' printLine.
  'SELF_BLOCH_DONE' printLine.
] value.
