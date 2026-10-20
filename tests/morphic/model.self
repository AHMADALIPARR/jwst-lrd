"SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque"
((os environmentAt: 'LRD_ROOT' IfFail: '.'), '/self/topology/simplicialComplex.self') runScript.
((os environmentAt: 'LRD_ROOT' IfFail: '.'), '/self/growth/growthHistory.self') runScript.
((os environmentAt: 'LRD_ROOT' IfFail: '.'), '/self/growth/blochSphere.self') runScript.
((os environmentAt: 'LRD_ROOT' IfFail: '.'), '/self/experiment/experimentModel.self') runScript.
((os environmentAt: 'LRD_ROOT' IfFail: '.'), '/self/experiment/spectrum.self') runScript.
[| m. s. check. count <- 0. before. n. near. atlasOK <- true. bytes |
  check: [|:name. :ok| ok ifTrue: [ ('PASS ', name) printLine ]
    False: [ ('FAIL ', name) printLine ] ].
  m: lrdExperiment copyFromRoot: (os environmentAt: 'LRD_ROOT' IfFail: '.').
  check value: 'morphic_grid_1200' With: m grid nRows = 1200.
  check value: 'morphic_benchmark' With: ((m seedFor: m selectedRow) > 480.0) &&
    [(m seedFor: m selectedRow) < 525.0].
  check value: 'morphic_benchmark_100_seed_excluded' With: (m seedReachesTarget: 100.0) not.
  check value: 'morphic_benchmark_1000_seed_reaches' With: (m seedReachesTarget: 1000.0).
  check value: 'morphic_benchmark_final_mass' With: ((m finalMassForSeed: 100.0) > 9900000.0) &&
    [(m finalMassForSeed: 100.0) < 10000000.0].
  m cycleLambda.
  check value: 'morphic_higher_rate_rescues_light_seed' With: (m seedReachesTarget: 100.0).
  m reset.
  6 do: [
    5 do: [
      8 do: [
        5 do: [
          m selectedRow isNil ifFalse: [ count: count + 1 ].
          m cycleFormation ].
        m cycleLambda ].
      m cycleDuty ].
    m cycleEpsilon ].
  check value: 'morphic_all_1200_selectors_resolve' With: count = 1200.
  before: m grid commitment. m toggleModel.
  check value: 'morphic_model_changes_seed_field' With: m seedKey = 'seed_sat'.
  check value: 'morphic_ui_preserves_commitment' With: before = m grid commitment.
  4 do: [
    check value: ('morphic_topology_', m topology name) With: m topologyChecks.
    m cycleTopology ].
  m reset.
  check value: 'morphic_reset' With: (m saturated not && [m lambda = 1.0]).
  s: lrdSpectrum copyFromRoot: (os environmentAt: 'LRD_ROOT' IfFail: '.').
  check value: 'morphic_real_spectrum_429_samples' With: s flux size = 429.
  check value: 'morphic_spectrum_dynamic_range' With: s maxFlux > s minFlux.
  check value: 'morphic_spectrum_source' With:
    s source = 'c0b878576d7d7ec723c5ee526d29715fb672d81e45bc8ba4e02598ce8b9c5ee7'.
  near: [|:a. :b| (a - b) absoluteValue < 0.00001 ].
  n: blochState copyTheta: 0 Phase: 0.
  check value: 'morphic_bloch_pole' With: (near value: n projRadiusSq With: 0.0).
  n advancePhase: -1.
  check value: 'morphic_bloch_negative_wrap' With: n phaseSteps = 255.
  0 to: 128 Do: [|:theta|
    256 do: [|:phase. state|
      state: blochState copyTheta: theta Phase: phase.
      ((state projRadiusSq < -0.00001) || [state projRadiusSq > 1.00001])
        ifTrue: [ atlasOK: false ] ] ].
  check value: 'morphic_all_33024_bloch_states_bounded' With: atlasOK.
  bytes: byteVector copySize: 8 FillingWith: 0.
  bytes at: 6 Put: 240. bytes at: 7 Put: 63.
  check value: 'morphic_binary64_one' With: (s doubleIn: bytes At: 0) = 1.0.
  bytes at: 6 Put: 0. bytes at: 7 Put: 192.
  check value: 'morphic_binary64_negative_two' With: (s doubleIn: bytes At: 0) = -2.0.
  bytes at: 6 Put: 240. bytes at: 7 Put: 127.
  check value: 'morphic_binary64_infinity_rejected' With: (s doubleIn: bytes At: 0) isNil.
  'LRD_MODEL_DONE' printLine.
] value.
_Quit
