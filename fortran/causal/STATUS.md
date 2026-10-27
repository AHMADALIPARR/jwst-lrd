<!-- SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque -->
<!-- Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited.
     Licensed under AGPL-3.0-only plus the SnapKitty Opaque License (dual license, intentional). -->
# STATUS: causal poset track (TASK 006, `t006-causal`)

Branch `t006-causal-repairs`, repairs on top of main bb12b59 (which contains t006-causal 13cc3d7).
These repairs address the HCALC Spec review `t006-causal-13cc3d7` (verdict NOT PASS). This file
reports what the author's own runs showed. It is not a verified integration and it has not been
re-reviewed. It needs owner review and HCALC Spec / HCALC Alloy re-review.

**What this is:** a library and tests for causal-order bookkeeping over synthetic events in flat
Minkowski space: interval arithmetic with outward rounding, light-cone classification of event
pairs, a DAG of validated causal edges, and a canonical LRD-REC-v1 serialization with a SHA-256
commitment. Cone membership is necessary but not sufficient for causation; see the header of
`src/causal_classify.f90`. No observational data is involved.

## Files
| Path | Contents |
|---|---|
| `fortran/causal/Makefile` | builds `build/libcausal.a` and the test programs (`gfortran -std=f2018 -Wall -Wextra -fcheck=all -g -O1 -fimplicit-none -ffp-contract=off`). `make test` runs `tests/causal/run.sh`; `make ftest` runs only the Fortran programs |
| `fortran/causal/src/*.f90` | 12 modules, 2673 lines: units, interval, coords, frames, events, classify, digraph, graph, hexfloat, sha256, lrdrec, serial |
| `fortran/causal/FORMAT.md` | the LRD-REC-v1 / LRD-CAUSAL-GRAPH-v1 format as implemented |
| `curry/causal/CausalGraph.curry`, `TestCausalGraph.curry` | Curry model of the graph schema, and its tests (26 checks) |
| `self/causal/causalGraph.self`, `testCausalGraph.self` | Self model and headless tests (25 checks) |
| `tests/causal/run.sh` | the runner (bash). Builds, creates `out/`, runs everything it can, prints PASS / FAIL / UNAVAILABLE lines and a summary |
| `tests/causal/test_*.f90`, `fixture_graph.f90` | 7 Fortran test programs |

## Counts from the author's run (clean clone of the pushed branch, 2026-10-27, America/Los_Angeles)
| Suite | Passed | Failed | Notes |
|---|---|---|---|
| fortran.build | 1 | 0 | `make -C fortran/causal all` |
| test_units_interval | 33 | 0 | includes 7 new upper-bound outward-rounding checks |
| test_classify | 25 | 0 | |
| test_edges | 39 | 0 | includes 6 new `cg_add_event` kind checks |
| test_dag | 55 | 0 | |
| test_boost | 12 | 0 | s2 invariance worst \|s2_L - s2_B\| / scale = 2.6064E-15 |
| test_serial | 44 | 0 | |
| test_fixture | 4 | 0 | fixture commitment `1d8a8390637cf6b386d31beade096ce092be5f58b6acc0213d14c03e3c2be2e4` |
| curry.causal_graph | 26 | 0 | PAKCS 3.10.0 |
| self.causal_graph | 25 | 0 | Self VM and morphic snapshot, see below |
| **total** | **264** | **0** | 0 UNAVAILABLE in this environment |

Before the repairs, on a fresh clone: no `tests/causal/run.sh` (so `make test` had nothing to run
for this track) and `test_serial` and `test_fixture` failed because `out/` did not exist.

## What ran, and where
- **Fortran:** gfortran 14.2.0, run here.
- **Curry:** run here with PAKCS 3.10.0 found at `/workspace/jwst-lrd/build/tools/pakcs-3.10.0/bin/pakcs`.
  The copy tracked at `build/tools/pakcs-3.10.0` in this repository is not usable (it reports an
  incompatible VM signature), so `run.sh` checks that a candidate PAKCS reports the required version
  and can evaluate `1+1` before using it. If none qualifies, it prints `UNAVAILABLE curry.causal_graph`
  with the reason for each candidate.
- **Self:** run here. VM `/workspace/jwst-lrd/build/tools/self-src/build32/vm/Self` (Self 2023.1/13,
  Linux i386) with the snapshot `/workspace/_self_tools/world/morphic.snap`. This was a property of
  this machine only. On a machine with no Self VM, or with a VM and neither a snapshot nor
  `objects/worldBuilder.self`, `run.sh` prints `UNAVAILABLE self.causal_graph <reason>`, and that is not a PASS.
  The snapshot-less path (build a world with `worldBuilder.self`) was exercised once here and gave 25 PASS.

## Mutation checks (author's own runs)
Each mutant was applied, the new tests were shown to FAIL, and the mutant was reverted and the tests shown to pass.
| Mutant | Change | New tests that failed |
|---|---|---|
| 11 | `add_up` and `mul_up` never widen (`e > 0` replaced by `e > 1e300`) | 5 in test_units_interval |
| 11a | `add_up` only | 2 |
| 11b | `mul_up` only | 3 |
| 17 | `cg_add_event` kind check removed | 4 in test_edges |

## Assumptions
- The Fortran tests assume IEEE binary64 and no fused multiply-add contraction (`-ffp-contract=off`).
  The full runner output and the fixture bytes were identical with and without the flag on this machine.
- `rel_tol = 1e-12` is an engineering margin, not a proven bound. Its basis and its limits are in the
  header of `src/causal_classify.f90`. A boost with beta very close to 1 has not been characterised.

## Known gaps and blockers
- `graph_load` computes the commitment of a file but does not verify it against the `.commit` sidecar (see FORMAT.md).
- Tests on a machine without PAKCS 3.10.0 or without a Self VM report UNAVAILABLE for those two suites,
  and then only the Fortran suite (213 PASS lines including the build) has run.
- Not independently re-reviewed (HCALC Spec / HCALC Alloy).
