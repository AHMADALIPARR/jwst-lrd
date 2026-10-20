"SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
 Experiment state: selectors reference committed rows; no solver runs in the view."
lobby _AddSlots: (|
  lrdExperiment = (|
    parent* = traits clonable.
    grid <- nil.
    topology <- nil.
    sphere <- nil.
    rootPath <- ''.
    epsIndex <- 1.
    dutyIndex <- 4.
    lamIndex <- 2.
    formIndex <- 2.
    saturated <- false.
    topologyIndex <- 0.
    proofSummary <- 'UNAVAILABLE - run tests/morphic/proofs.sh'.
    epsValues = ( (0.05 & 0.1 & 0.15 & 0.2 & 0.25 & 0.3) asVector ).
    dutyValues = ( (0.1 & 0.25 & 0.5 & 0.75 & 1.0) asVector ).
    lamValues = ( (0.5 & 0.75 & 1.0 & 1.5 & 2.0 & 2.5 & 3.0 & 5.0) asVector ).
    formValues = ( (12.0 & 15.0 & 20.0 & 25.0 & 30.0) asVector ).
    topologyNames = ( ('SYNTHETIC_hollow_triangle' & 'SYNTHETIC_filled_triangle' &
      'SYNTHETIC_torus_7v' & 'SYNTHETIC_tetra_boundary') asVector ).
    copyFromRoot: p = ( | m |
      m: copy. m rootPath: p.
      m grid: growthGrid copyFromFile: p, '/fixtures/growth/feasible_grid.rec'.
      m sphere: blochState copyTheta: 64 Phase: 0.
      m loadTopology. m loadProofStatus. m ).
    loadProofStatus = ( | p. r |
      p: rootPath, '/tests/morphic/evidence/proofs.rec'.
      (os_file exists: p) ifTrue: [
        r: (simplicialComplex parseRecords: p asFileContents) first.
        proofSummary: 'Recorded Agda: core=', (r at: 'status.core'),
          ' kernel=', (r at: 'status.kernel'), ' growth=', (r at: 'status.growth'),
          ' | ', (r at: 'compiler') ]. self ).
    loadTopology = (
      topology: simplicialComplex copyFromFile:
        rootPath, '/self/topology/geometry/', (topologyNames at: topologyIndex), '.geom.lrdrec'.
      self ).
    epsilon = ( epsValues at: epsIndex ).
    duty = ( dutyValues at: dutyIndex ).
    lambda = ( lamValues at: lamIndex ).
    formation = ( formValues at: formIndex ).
    selectedRow = ( grid rowLam: lambda Eps: epsilon ZForm: formation Duty: duty ).
    seedKey = ( saturated ifTrue: 'seed_sat' False: 'seed_simple' ).
    feasibleKey = ( saturated ifTrue: 'feas_sat' False: 'feas_simple' ).
    seedFor: r = ( r at: seedKey ).
    targetMass = ( grid floatFromES: (grid header at: 'm_target_msun') ).
    selectedLogFactor = ( targetMass base10Log - (seedFor: selectedRow) base10Log ).
    finalMassForSeed: seed = ( seed * (targetMass / (seedFor: selectedRow)) ).
    seedReachesTarget: seed = ( seed >= (seedFor: selectedRow) ).
    growthConclusion = (
      (seedReachesTarget: 100.0)
        ifTrue: '100 Msun seed REACHES target for this tuple.'
        False: '100 Msun seed EXCLUDED for this tuple.' ).
    rowIsFeasible: r = ( (r at: feasibleKey) = 1.0 ).
    sliceRows = ( | r |
      r: list copyRemoveAll.
      grid rows do: [|:x|
        ((((x at: 'eps') - epsilon) absoluteValue < 0.000001) &&
          [((x at: 'duty') - duty) absoluteValue < 0.000001]) ifTrue: [ r add: x ] ].
      r ).
    sliceFeasibleCount = ( | n <- 0 |
      sliceRows do: [|:r| (rowIsFeasible: r) ifTrue: [ n: n + 1 ] ]. n ).
    cycleEpsilon = ( epsIndex: (epsIndex + 1) % epsValues size. self ).
    cycleDuty = ( dutyIndex: (dutyIndex + 1) % dutyValues size. self ).
    cycleLambda = ( lamIndex: (lamIndex + 1) % lamValues size. self ).
    cycleFormation = ( formIndex: (formIndex + 1) % formValues size. self ).
    toggleModel = ( saturated: saturated not. self ).
    cycleTopology = ( topologyIndex: (topologyIndex + 1) % topologyNames size. loadTopology ).
    cycleTheta = ( sphere thetaSteps: (sphere thetaSteps + 16) % 129. self ).
    cyclePhase = ( sphere advancePhase: 16. self ).
    topologyChecks = ( topology incidenceIsConsistent &&
      [topology headerMatchesRoot &&
        [topology eulerCharacteristic = topology alternatingBettiSum]] ).
    reset = (
      epsIndex: 1. dutyIndex: 4. lamIndex: 2. formIndex: 2. saturated: false.
      topologyIndex: 0. sphere: blochState copyTheta: 64 Phase: 0.
      loadTopology ).
  |).
|).
