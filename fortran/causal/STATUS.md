<!-- SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque -->
<!-- Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited.
     Licensed under AGPL-3.0-only plus the SnapKitty Opaque License (dual license, intentional). -->
# STATUS: causal poset track (TASK 006, `t006-causal`)

Branch `t006-causal-followup`, on top of main 31b06fb (which contains the merged PR #23, `t006-causal-repairs`).
This follow-up addresses the LOW and INFO items of the HCALC Spec review of 56e51cf (`jwst-lrd-reviews/t006-causal-repairs-56e51cf.md`): L1 two_prod fallback tests, L2 sidecar verification in `graph_load`, L3 and L4 tool discovery in `run.sh`, and two INFO items. The earlier review was `t006-causal-13cc3d7` (verdict NOT PASS). This file
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
| `fortran/causal/src/*.f90` | 12 modules, 2722 lines: units, interval, coords, frames, events, classify, digraph, graph, hexfloat, sha256, lrdrec, serial |
| `fortran/causal/FORMAT.md` | the LRD-REC-v1 / LRD-CAUSAL-GRAPH-v1 format as implemented |
| `curry/causal/CausalGraph.curry`, `TestCausalGraph.curry` | Curry model of the graph schema, and its tests (26 checks) |
| `self/causal/causalGraph.self`, `testCausalGraph.self` | Self model and headless tests (25 checks) |
| `tests/causal/run.sh` | the runner (bash). Builds, creates `out/`, runs everything it can, prints PASS / FAIL / UNAVAILABLE lines and a summary |
| `tests/causal/test_*.f90`, `fixture_graph.f90` | 7 Fortran test programs |

## Counts from the author's run (clean clone of the pushed branch, 2026-10-27, America/Los_Angeles; commit c168a16 plus this file)
| Suite | Passed | Failed | Notes |
|---|---|---|---|
| fortran.build | 1 | 0 | `make -C fortran/causal all` |
| test_units_interval | 41 | 0 | was 33; 8 new checks pin the `two_prod` fallback and its thresholds (L1) |
| test_classify | 25 | 0 | |
| test_edges | 39 | 0 | |
| test_dag | 55 | 0 | |
| test_boost | 12 | 0 | s2 invariance worst \|s2_L - s2_B\| / scale = 2.6064E-15 |
| test_serial | 44 | 0 | |
| test_fixture | 17 | 0 | was 4; 13 new checks for `graph_load` sidecar verification (L2). Fixture commitment `1d8a8390637cf6b386d31beade096ce092be5f58b6acc0213d14c03e3c2be2e4` |
| curry.causal_graph | 26 | 0 | PAKCS 3.10.0 |
| self.causal_graph | 25 | 0 | Self VM and morphic snapshot, see below |
| **total** | **285** | **0** | 0 UNAVAILABLE in this environment (264 in the previous PR) |

Before PR #23, on a fresh clone: no `tests/causal/run.sh` (so `make test` had nothing to run
for this track) and `test_serial` and `test_fixture` failed because `out/` did not exist.

The 285 above is the sum of `PASS` lines (1 build + 233 Fortran + 26 Curry + 25 Self) from `bash tests/causal/run.sh` in a fresh clone of the pushed branch. Curry and Self actually ran. The same run with the tool directories hidden gave 234 PASS, 0 FAIL, 2 UNAVAILABLE and exit 0.

## What ran, and where
- **Fortran:** gfortran 14.2.0, run here.
- **Curry:** run here with PAKCS 3.10.0 found at `/workspace/jwst-lrd/build/tools/pakcs-3.10.0/bin/pakcs`.
  The copy tracked at `build/tools/pakcs-3.10.0` in this repository is not usable (it reports an
  incompatible VM signature and aborts, exit 134). `run.sh` now tries `LRD_PAKCS`, `PAKCS`, `PAKCSHOME`,
  `pakcs` on PATH, and then the repository and tool-directory paths; a candidate must report the required
  version and evaluate `1+1`. The probe runs quietly (no stray `Aborted` on stderr, also under `sh`), and the exit status and the
  first line of the candidate's own output are kept in the reason. If none qualifies it prints
  `UNAVAILABLE curry.causal_graph` with the reason for each candidate.
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
| X6 | `two_prod` tiny guard `1e-280` changed to `1e-300` (L1) | 3 in test_units_interval |
| X7 | `two_prod` guard line `abs(a)` and `abs(b)` `> 1e290` deleted | 3 |
| X8 | `two_prod` guard line `abs(p) < 1e-280` deleted | 3 |
| X9 | large threshold raised to `1e305` | 3 |
| X10 | large threshold lowered to `1e280` | 1 (`two_prod_exact_2pow963_not_widened`) |
| X11 | tiny threshold raised to `1e-250` | 1 (`two_prod_exact_2pow-930_not_widened`) |
| L2a | `graph_load` mismatch comparison removed | 3 in test_fixture |
| L2b | all-zero sidecar check removed | 1 |
| L2c | a missing sidecar ignored | 1 |
| L2d | sidecar hex check removed | 2 |
| L2e | sidecar length check removed | 1 |

After each revert test_units_interval printed `41 passed, 0 failed` and test_fixture `17 passed, 0 failed`.
X6-X8 are the surviving mutants named in the review; X9-X11 and L2a-L2e are additional. The X9 and later labels are this follow-up's own; the raw output is in the PR description.

## Assumptions
- The Fortran tests assume IEEE binary64 and no fused multiply-add contraction (`-ffp-contract=off`).
  The full runner output and the fixture bytes were identical with and without the flag on this machine.
- `rel_tol = 1e-12` is an engineering margin, not a proven bound. Its basis and its limits are in the
  header of `src/causal_classify.f90`. A boost with beta very close to 1 has not been characterised.

## Known gaps and blockers
- The `.commit` sidecar sits next to the record it protects, so `graph_load`'s check detects accidental or unannounced change, not an attacker who rewrites both files (see FORMAT.md).
- The `two_prod` fallback widens one ulp on both sides unconditionally; the new tests pin that behaviour and the 1e290 / 1e-280 thresholds, but do not claim those thresholds are tight.
- The `1/C_LIGHT` widening in `transform_coord` is argued in the header of `src/causal_classify.f90`; no test pins it.
- Tests on a machine without PAKCS 3.10.0 or without a Self VM report UNAVAILABLE for those two suites,
  and then only the Fortran suite (234 PASS lines including the build) has run.
- Not independently re-reviewed (HCALC Spec / HCALC Alloy).
