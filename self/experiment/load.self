"SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque"
lobby _AddSlots: (| lrdRoot = (os environmentAt: 'LRD_ROOT' IfFail: '.') |).
(lrdRoot, '/self/topology/simplicialComplex.self') runScript.
(lrdRoot, '/self/growth/growthHistory.self') runScript.
(lrdRoot, '/self/growth/blochSphere.self') runScript.
(lrdRoot, '/self/growth/blochMorph.self') runScript.
(lrdRoot, '/self/experiment/experimentModel.self') runScript.
(lrdRoot, '/self/experiment/spectrum.self') runScript.
(lrdRoot, '/self/experiment/experimentMorph.self') runScript.
lobby _AddSlots: (|
  lrdWorkspace = (|
    parent* = traits clonable.
    view <- nil.
    open = ( | m. s |
      m: lrdExperiment copyFromRoot: lrdRoot.
      s: lrdSpectrum copyFromRoot: lrdRoot.
      desktop openNewWorldOnDisplay: (os environmentAt: 'DISPLAY' IfFail: '')
        Bounds: ((0 @ 0) # (1460 @ 1020)).
      view: lrdExperimentMorph copyOn: m Spectrum: s.
      view position: 12 @ 12. desktop w addMorph: view. view changed.
      'LRD_WORKSPACE_OPEN' printLine. self ).
  |).
|).
'LRD_WORKSPACE_READY' printLine.
