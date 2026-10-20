"Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
 Licensed under AGPL-3.0-only plus the SnapKitty Opaque License (dual license, intentional).
 See LICENSE and SNAPKITTY_OPAQUE_LICENSE.md at the repository root.

 blochSphere: the state model for the Stereographic 2D Bloch Projection
 Engine (self/growth/BLOCH-FRONTEND.md), merged with the Morphic front
 end (blochMorph.self). A two-level state is held ONLY as integers --
 thetaSteps (polar angle, 0..128 steps of pi/128) and phaseSteps
 (azimuth, 0..255 steps of 2pi/256) -- so the phase is crystallized:
 rendering frames read the same integers and cannot accumulate
 floating-point drift. Floats appear only as derived values.

 Stereographic atlas (bounded): the point is projected from the pole
 OPPOSITE its hemisphere, so the image always lands in the closed
 unit disk. From the south pole (used when z >= 0):
   X = x / (1 + z),  Y = y / (1 + z),  X^2 + Y^2 = (1 - z) / (1 + z) <= 1.
 From the north pole (z < 0): divide by (1 - z), radius^2 = (1 + z) /
 (1 - z) <= 1. The two charts agree on the equator (z = 0). Both poles
 therefore have bounded Euclidean coordinates, as the spec requires.

 State-vector quantization: projXFixed / projYFixed are the projected
 coordinates in milli-units (integers), the fixed-point vectors the
 spec sends to spatial hardware rasterization."

lobby _AddSlots: (|
  blochState = (|
    parent* = traits clonable.
    thetaSteps <- 0.
    phaseSteps <- 0.

    pi = 3.141592653589793.

    copyTheta: t Phase: p = ( | s |
      s: copy.
      s thetaSteps: ((t max: 0) min: 128).
      s phaseSteps: (((p % 256) + 256) % 256).
      s ).

    theta = ( (thetaSteps asFloat * pi) / 128.0 ).
    phase = ( ((phaseSteps asFloat * 2.0) * pi) / 256.0 ).

    "Phase advance mutates only the integer state: no float drift."
    advancePhase: k = (
      phaseSteps: (((phaseSteps + k) % 256) + 256) % 256.
      self ).

    x = ( theta sin * phase cos ).
    y = ( theta sin * phase sin ).
    z = ( theta cos ).

    probNorth = ( (1.0 + z) / 2.0 ).
    probSouth = ( (1.0 - z) / 2.0 ).
    probNorthMilli = ( (probNorth * 1000.0) asInteger ).
    probSouthMilli = ( (probSouth * 1000.0) asInteger ).

    "'S' = projected from the south pole (northern point), 'N' = from
     the north pole (southern point)."
    chart = ( (z < 0.0) ifTrue: [ 'N' ] False: [ 'S' ] ).
    projX = ( (z < 0.0) ifTrue: [ x / (1.0 - z) ] False: [ x / (1.0 + z) ] ).
    projY = ( (z < 0.0) ifTrue: [ y / (1.0 - z) ] False: [ y / (1.0 + z) ] ).
    projRadiusSq = ( (projX * projX) + (projY * projY) ).

    projXFixed = ( (projX * 1000.0) asInteger ).
    projYFixed = ( (projY * 1000.0) asInteger ).
    xFixed = ( (x * 1000.0) asInteger ).
    yFixed = ( (y * 1000.0) asInteger ).
    zFixed = ( (z * 1000.0) asInteger ).
  |)
|).
