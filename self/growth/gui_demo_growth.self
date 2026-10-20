"Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
 Licensed under AGPL-3.0-only plus the SnapKitty Opaque License (dual license, intentional).

 Growth GUI demo, loaded with -f2 into a morphic world under an X server (Xvfb).
 Environment: GROWTH_SELF_DIR (this directory), GROWTH_TOPO_DIR (self/topology,
 for the shared LRD-REC-v1 parser), GROWTH_REC (the LRD-GROWTH-v1 record).
 Like the topology demo, this script only defines growthGuiDemo; the driver
 types 'growthGuiDemo run' at the Self prompt, screenshots, and kills Self."

((os environmentAt: 'GROWTH_TOPO_DIR' IfFail: '.'), '/simplicialComplex.self') runScript.
((os environmentAt: 'GROWTH_SELF_DIR' IfFail: '.'), '/growthHistory.self') runScript.
((os environmentAt: 'GROWTH_SELF_DIR' IfFail: '.'), '/growthMorph.self') runScript.

lobby _AddSlots: (|
  growthGuiDemo = (|
    parent* = traits clonable.
    run = ( | g. m |
      g: growthGrid copyFromFile:
           (os environmentAt: 'GROWTH_REC' IfFail: 'fixtures/growth/feasible_grid.rec').
      desktop openNewWorldOnDisplay: (os environmentAt: 'DISPLAY' IfFail: '') Bounds: ((0 @ 0) # (500 @ 560)).
      m: growthMorph copyOnGrid: g.
      m position: 20 @ 20.
      desktop w addMorph: m.
      m changed.
      ('GUI added growth morph: ', g summary) printLine.
      'GUI_GROWTH_DONE' printLine.
      self ).
  |).
|).
'GUI_GROWTH_READY' printLine.
