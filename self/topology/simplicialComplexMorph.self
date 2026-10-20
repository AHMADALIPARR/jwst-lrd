"Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
 Licensed under AGPL-3.0-only plus the SnapKitty Opaque License (dual license, intentional).
 See LICENSE and SNAPKITTY_OPAQUE_LICENSE.md at the repository root.

 simplicialComplexMorph: Morphic (ui2) view of a simplicialComplex.  Draws filled
 triangles, edges and vertices at the deterministic 2D layout (px, py) of the
 export, plus the name, the committed Betti vector, the field and the commitment
 root.  Requires a world built with -o morphic and simplicialComplex.self loaded."

lobby _AddSlots: (| simplicialComplexMorph = morph copy |).

simplicialComplexMorph _AddSlots: (|
  complex <- nil.

  copyOnComplex: c = ( | m |
    m: copy.
    m complex: c.
    m setWidth: 440 Height: 500.
    m color: paint named: 'white'.
    m ).

  pointFor: l Origin: o = ( o + (complex pointOfLabel: l) ).

  baseDrawOn: cv = ( | o. c. tri. edge. vert. ink |
    c: complex.
    o: baseBounds origin.
    tri: paint named: 'lightGray'.
    edge: paint named: 'blue'.
    vert: paint named: 'red'.
    ink: paint named: 'black'.
    cv fillRectangle: baseBounds Color: (paint named: 'white').
    (c indicesOfDim: 2) do: [|:i. vs. pts|
      vs: c vertices: i.
      pts: vector copySize: 3.
      pts at: 0 Put: (pointFor: (vs at: 0) Origin: o).
      pts at: 1 Put: (pointFor: (vs at: 1) Origin: o).
      pts at: 2 Put: (pointFor: (vs at: 2) Origin: o).
      cv fillPolygon: pts Color: tri ].
    (c indicesOfDim: 1) do: [|:i. vs|
      vs: c vertices: i.
      cv line: (pointFor: (vs at: 0) Origin: o)
            To: (pointFor: (vs at: 1) Origin: o)
         Width: 2 Color: edge ].
    (c indicesOfDim: 0) do: [|:i. vs|
      vs: c vertices: i.
      cv fillCircleCenteredAt: (pointFor: (vs at: 0) Origin: o) Diameter: 10 Color: vert ].
    cv text: c name At: o + (10 @ 412) Color: ink.
    cv text: ('field=', c field, '  counts=', c countsString, '  betti=', (c listString: c betti))
          At: o + (10 @ 432) Color: ink.
    cv text: ('root=', (c root copyFrom: 0 UpTo: 32)) At: o + (10 @ 452) Color: ink.
    cv text: ('      ', (c root copyFrom: 32 UpTo: 64)) At: o + (10 @ 472) Color: ink.
    self ).
|).
