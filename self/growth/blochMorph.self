"Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
 Licensed under AGPL-3.0-only plus the SnapKitty Opaque License (dual license, intentional).
 See LICENSE and SNAPKITTY_OPAQUE_LICENSE.md at the repository root.

 blochMorph: Morphic (ui2) view of a blochState -- the Self Bloch
 sphere. Merges the growth front end's morph idiom (growthMorph) with
 the Stereographic 2D Bloch Projection Engine (BLOCH-FRONTEND.md):
 the state's bounded stereographic projection is drawn in the unit
 disk, with the phase arm at the crystallized phase angle, and the
 fixed-point (milli-unit) vectors printed below for the hardware
 rasterization pipeline. Screen y is down, so projected and phase
 y components are negated when drawing.
 Requires a world built with -o morphic and blochSphere.self loaded."

lobby _AddSlots: (| blochMorph = morph copy |).

blochMorph _AddSlots: (|
  state <- nil.

  copyOnState: s = ( | m |
    m: copy.
    m state: s.
    m setWidth: 460 Height: 520.
    m color: paint named: 'white'.
    m ).

  center: o = ( o + (230 @ 180) ).

  diskPoint: o = ( | c |
    c: center: o.
    c + (((state projX * 150.0) asInteger) @ (0 - ((state projY * 150.0) asInteger))) ).

  baseDrawOn: cv = ( | o. ink. c. r. pt. rim |
    o: baseBounds origin.
    ink: paint named: 'black'.
    c: center: o.
    r: 150.
    cv fillRectangle: baseBounds Color: (paint named: 'white').
    "unit disk outline: 64 deterministic segments"
    64 do: [|:i. a1. a2. p1. p2|
      a1: i asFloat * 2.0 * 3.141592653589793 / 64.0.
      a2: (i + 1) asFloat * 2.0 * 3.141592653589793 / 64.0.
      p1: c + (((a1 cos * r asFloat) asInteger) @ (0 - ((a1 sin * r asFloat) asInteger))).
      p2: c + (((a2 cos * r asFloat) asInteger) @ (0 - ((a2 sin * r asFloat) asInteger))).
      cv line: p1 To: p2 Width: 2 Color: ink ].
    "equator cross"
    cv line: (c + ((0 - r) @ 0)) To: (c + (r @ 0)) Width: 1 Color: (paint named: 'lightGray').
    cv line: (c + (0 @ (0 - r))) To: (c + (0 @ r)) Width: 1 Color: (paint named: 'lightGray').
    "the far pole of the current chart sits at the disk center"
    cv fillCircleCenteredAt: c Diameter: 6 Color: ink.
    cv text: (state chart = 'S' ifTrue: [ 'N' ] False: [ 'S' ]) At: c + (8 @ 4) Color: ink.
    "phase arm: center to the projected state point"
    pt: diskPoint: o.
    cv line: c To: pt Width: 2 Color: (paint named: 'blue').
    cv fillCircleCenteredAt: pt Diameter: 10 Color: (paint named: 'blue').
    "phase tick on the rim at the crystallized phase angle"
    rim: c + (((state phase cos * r asFloat) asInteger) @ (0 - ((state phase sin * r asFloat) asInteger))).
    cv fillCircleCenteredAt: rim Diameter: 6 Color: (paint named: 'red').
    cv text: 'Bloch sphere: stereographic projection (bounded atlas)'
         At: o + (10 @ 352) Color: ink.
    cv text: ('theta steps=', state thetaSteps printString, '/128',
              '  phase steps=', state phaseSteps printString, '/256',
              '  chart=', state chart)
         At: o + (10 @ 380) Color: ink.
    cv text: ('state x1000: x=', state xFixed printString,
              ' y=', state yFixed printString,
              ' z=', state zFixed printString)
         At: o + (10 @ 404) Color: ink.
    cv text: ('proj  x1000: X=', state projXFixed printString,
              ' Y=', state projYFixed printString,
              '  (fixed-point raster vector)')
         At: o + (10 @ 428) Color: ink.
    cv text: ('P(N)=', state probNorthMilli printString, '/1000',
              '  P(S)=', state probSouthMilli printString, '/1000')
         At: o + (10 @ 452) Color: ink.
    self ).
|).
