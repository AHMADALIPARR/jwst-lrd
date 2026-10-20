"Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
 Licensed under AGPL-3.0-only plus the SnapKitty Opaque License (dual license, intentional).

 GUI demo, loaded with -f2 into a morphic world under an X server (Xvfb).
 Environment: TOPO_SELF_DIR (this directory), TOPO_GEOM_DIR (geometry exports).
 The desktop needs the scheduler, which only starts after -f2 scripts return, so
 this script only defines topologyGuiDemo; the driver then types
 'topologyGuiDemo run' at the Self prompt (stdin), screenshots, and kills Self."

((os environmentAt: 'TOPO_SELF_DIR' IfFail: '.'), '/simplicialComplex.self') runScript.
((os environmentAt: 'TOPO_SELF_DIR' IfFail: '.'), '/simplicialComplexMorph.self') runScript.

lobby _AddSlots: (|
  topologyGuiDemo = (|
    parent* = traits clonable.
    run = ( | gd. x <- 20 |
      gd: os environmentAt: 'TOPO_GEOM_DIR' IfFail: '.'.
      desktop openNewWorldOnDisplay: (os environmentAt: 'DISPLAY' IfFail: '') Bounds: ((0 @ 0) # (1420 @ 560)).
      ('SYNTHETIC_torus_7v' & 'SYNTHETIC_rp2_6v' & 'SYNTHETIC_filled_triangle') asVector do: [|:n. c. m|
        c: simplicialComplex copyFromFile: gd, '/', n, '.geom.lrdrec'.
        m: simplicialComplexMorph copyOnComplex: c.
        m position: x @ 20.
        desktop w addMorph: m.
        m changed.
        x: x + 460.
        ('GUI added morph for ', c summary) printLine ].
      'GUI_DEMO_DONE' printLine.
      self ).
  |).
|).
'GUI_DEMO_READY' printLine.
