"Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
 Licensed under AGPL-3.0-only plus the SnapKitty Opaque License (dual license, intentional).

 Headless Self test of self/topology/simplicialComplex.self (no Morphic needed).
 Run as: Self -f worldBuilder.self -b <objects> -o none -f2 self_headless.self
 Environment: TOPO_SELF_DIR, TOPO_GEOM_DIR.  Prints PASS/FAIL lines and SELF summaries."

((os environmentAt: 'TOPO_SELF_DIR' IfFail: '.'), '/simplicialComplex.self') runScript.

[| gd. names. check. |
  gd: os environmentAt: 'TOPO_GEOM_DIR' IfFail: '.'.
  check: [|:name. :ok. :why| ok ifTrue: [ ('PASS ', name) printLine ]
                                False: [ ('FAIL ', name, ' ', why) printLine ] ].
  names: ('SYNTHETIC_vertex' & 'SYNTHETIC_two_vertices' & 'SYNTHETIC_edge' &
          'SYNTHETIC_hollow_triangle' & 'SYNTHETIC_filled_triangle' & 'SYNTHETIC_tetra_boundary' &
          'SYNTHETIC_solid_tetra' & 'SYNTHETIC_hollow_square' & 'SYNTHETIC_hollow_triangle_relab' &
          'SYNTHETIC_rp2_6v' & 'SYNTHETIC_torus_7v' & 'SYNTHETIC_torus_grid3x3' &
          'SYNTHETIC_klein_grid4x4' & 'SYNTHETIC_random_seed20261019') asVector.
  names do: [|:n. c|
    c: simplicialComplex copyFromFile: gd, '/', n, '.geom.lrdrec'.
    c summary printLine.
    check value: 'self_incidence_symmetric_', n With: c incidenceIsConsistent With: 'faces/cofaces disagree'.
    check value: 'self_header_matches_root_', n With: c headerMatchesRoot With: 'header vs complex_root'.
    check value: 'self_euler_poincare_', n With: (c eulerCharacteristic = c alternatingBettiSum)
          With: 'chi /= alternating Betti sum'.
    check value: 'self_positions_cover_vertices_', n With: (c positions size = (c countDim: 0))
          With: 'vertex_position count'.
  ].
  [| c. s |
    c: simplicialComplex copyFromFile: gd, '/SYNTHETIC_filled_triangle.geom.lrdrec'.
    s: c facesOfIdString: '2:0,1,2'.
    ('SELF QUERY faces(2:0,1,2) = ', s) printLine.
    check value: 'self_query_faces_filled_triangle' With: (s = '1:1,2 1:0,2 1:0,1') With: s.
    s: c cofacesOfIdString: '0:0'.
    ('SELF QUERY cofaces(0:0) = ', s) printLine.
    check value: 'self_query_cofaces_vertex0' With: (s = '1:0,1 1:0,2') With: s.
    check value: 'self_query_betti_filled_triangle' With: (((c bettiAt: 0) = 1) && [((c bettiAt: 1) = 0) && [(c bettiAt: 2) = 0]]) With: 'betti'.
    c: simplicialComplex copyFromFile: gd, '/SYNTHETIC_tetra_boundary.geom.lrdrec'.
    s: c cofacesOfIdString: '1:0,1'.
    ('SELF QUERY cofaces(1:0,1) in tetra_boundary = ', s) printLine.
    check value: 'self_query_cofaces_tetra_edge' With: (s = '2:0,1,2 2:0,1,3') With: s.
    check value: 'self_query_betti_tetra_boundary' With: (((c bettiAt: 0) = 1) && [((c bettiAt: 1) = 0) && [(c bettiAt: 2) = 1]]) With: 'betti'.
    c: simplicialComplex copyFromFile: gd, '/SYNTHETIC_torus_7v.geom.lrdrec'.
    check value: 'self_query_betti_torus_7v' With: (((c bettiAt: 0) = 1) && [((c bettiAt: 1) = 2) && [(c bettiAt: 2) = 1]]) With: 'betti'.
    [| r. m |
      m: 'accepted'.
      r: simplicialComplex parseRecords: 'LRD-REC-v1\n0:3:abc\n' IfFail: [|:e| m: e ].
      ('SELF QUERY empty-key record -> ', m) printLine.
      check value: 'self_lrdrec_rejects_empty_key' With: (m = 'accepted') not With: 'empty key accepted'.
      m: 'accepted'.
      r: simplicialComplex parseRecords: 'LRD-REC-v1\n1:a1:x\n' IfFail: [|:e| m: e ].
      check value: 'self_lrdrec_accepts_minimal' With: ((m = 'accepted') && [r size = 1]) With: m.
    ] value.
  ] value.
  'SELF_HEADLESS_DONE' printLine.
] value.
_Quit
