"Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
 SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque

 Non-GUI tests of causalGraph on the SYNTHETIC fixture written by the Fortran tests.
 Environment: CAUSAL_SELF_DIR (this directory), CAUSAL_FIXTURE (the .lrdrec file).
 Prints PASS self.<name> / FAIL self.<name> <why> per check, then quits."

(('CAUSAL_SELF_DIR' _getenvenvironmentAtIfFail: [ '.' ]), '/causalGraph.self') _RunScript.

lobby _AddSlots: ( |
  causalSelfTest = ( |
    parent* = traits oddball.
    passed <- 0.
    failed <- 0.
    check: n Is: b = (
      b ifTrue: [ passed: passed + 1. ('PASS self.', n) printLine ]
         False: [ failed: failed + 1. ('FAIL self.', n, ' assertion_false') printLine ] ).
    run = ( | g. path. v |
      path: 'CAUSAL_FIXTURE' _getenvenvironmentAtIfFail: [ 'out/SYNTHETIC_causal_fixture.lrdrec' ].
      g: causalGraph loadFrom: path.
      check: 'loaded' Is: g isNil not.
      g isNil ifTrue: [ ('FAIL self.load_error ', causalGraph lastError) printLine. ^ self ].
      check: 'fixture_synthetic' Is: (g fixture = 'SYNTHETIC') && [ (g name copyFrom: 0 UpTo: 9) = 'SYNTHETIC' ].
      check: 'eleven_events' Is: g events size = 11.
      check: 'six_edges' Is: g edges size = 6.
      check: 'ten_rejections' Is: g rejected size = 10.
      check: 'kind_1_emission' Is: (g kindOf: 1) = 'emission'.
      check: 'kind_2_detection' Is: (g kindOf: 2) = 'detection'.
      check: 'kind_3_ground_receipt' Is: (g kindOf: 3) = 'ground_receipt'.
      check: 'kind_4_archive_publication' Is: (g kindOf: 4) = 'archive_publication'.
      check: 'ancestors_of_4' Is: (g joinIds: (g ancestorsOf: 4)) = '1,2,3,5,6'.
      check: 'descendants_of_1' Is: (g joinIds: (g descendantsOf: 1)) = '2,3,4,10'.
      check: 'causal_before_1_4' Is: g isCausallyBefore: 1 To: 4.
      check: 'not_causal_before_1_5' Is: (g isCausallyBefore: 1 To: 5) not.
      check: 'not_causal_before_4_1' Is: (g isCausallyBefore: 4 To: 1) not.
      check: 'redshift_event_7_isolated' Is: (g descendantsOf: 7) isEmpty && [ (g ancestorsOf: 7) isEmpty ].
      check: 'closure_size_11' Is: g closureSize = 11.
      check: 'topo_matches_fortran' Is: (g joinIds: g topoOrder) = (g rec at: 'topo').
      check: 'topo_known' Is: (g joinIds: g topoOrder) = '1,2,3,5,6,4,7,8,9,10,11'.
      check: 'class_1_2' Is: (g classificationOf: 1 To: 2) = 'lightlike/future'.
      check: 'class_1_5' Is: (g classificationOf: 1 To: 5) = 'spacelike/future'.
      check: 'class_7_2' Is: (g classificationOf: 7 To: 2) = 'invalid_frame/na'.
      check: 'parser_rejects_empty_key' Is: (causalRecParser copy parse: 'LRD-REC-v1\n0:1:x\n') isNil.
      check: 'parser_rejects_unsorted' Is: (causalRecParser copy parse: 'LRD-REC-v1\n1:b1:2\n1:a1:1\n') isNil.
      check: 'parser_accepts_canonical' Is: (causalRecParser copy parse: 'LRD-REC-v1\n1:a1:1\n2:aa1:x\n') isNil not.
      v: g morphicView.
      check: 'morphic_view_rows' Is: v morphCount = 18.
      ('# self: ', passed printString, ' passed, ', failed printString, ' failed') printLine ).
  | ).
| ).

causalSelfTest run.
_Quit
