<!-- SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque -->
# Execution status

Live-route update: native Self now renders an animated helix, red-dot state
and derived phase wave beside the archived QSO1 spectrum. The C transport
binds only 127.0.0.1:8765 and forwards nine predefined experiment messages.
Eight executed live tests verify fresh frames, invalid-token/action rejection,
FIFO delivery, changing MJPEG frames, pause, changes while paused and resume.
An isolated Edge test profile verified the live process inside the deployed
Pages iframe after granting its this-device browser permission. It is not a
publicly hosted Self VM: the NUC must be running the local companion.

Executed on the Windows NUC in Ubuntu 22.04 WSL2, x86-64, 2026-10-20.
The existing Self source distribution was built with X11, GCC 11.4,
32-bit multilib and ncurses/X11 libraries. Runtime source revision:
`russellallen/self@abb0d5ca7b29509c010922b9e3853f6a990a8f55`.
The runtime and its build products are excluded from this branch.

The Agda compiler is the repository-pinned 2.6.4.3, run from an isolated
tool directory with the v2.1 standard-library source distribution. System
compiler pins and project language choices were not changed. Stdlib emits
Cubical compatibility warnings; all proof aggregates exit zero in safe,
without-K mode. See the precise trust boundary in agda/growth/STATUS.md.

The repeatable suite is tests/morphic/run.sh. Concise actual PASS output is
in tests/morphic/evidence/proof-results.txt and model-results.txt; GUI
screenshots show initial and changed view states. The tests exercise all
1,200 growth selectors, four synthetic topology exports, the real 429-point
spectrum, positive/negative/nonfinite binary64 decoding, all 33,024
quantized Bloch states, native world creation, and a real mouse-button event.

No dynamical-mass fit, physical quantum apparatus, VR pipeline or hardware
MacroEASM execution is implemented by this UI. Those specification items
must not be inferred from a projection drawing. Observation arrays and
canonical records retain their committed bytes; the UI is read-only.

## Computed growth constraints (2026-10-20)

The live right-hand panel now computes the selected seed threshold and
plots mass histories against the declared target. Efficiency, duty, rate,
formation redshift and model controls change the allowed/excluded result.
`research/QSO1-GROWTH-RESULT.md` identifies the implemented invariants and
reports the conditional scientific conclusion, including competing histories.

`tests/morphic/results.sh` built the independent C calculation with
`-std=c17 -O2 -Wall -Wextra -Werror -pedantic` and executed:

```text
PASS analytic_clock_reproduces_all_1200_fortran_rows
PASS saturation_changes_82_grid_feasibility_labels
PASS rk4_log_growth_invariant_all_2000_steps
PASS benchmark_excludes_100_accepts_1000
PASS simple_rate_counterexample_hits_target
PASS saturated_rate_counterexample_hits_target
PASS duty_lambda_degeneracy_same_history
PASS saturated_duty_lambda_degeneracy
PASS reduced_duty_increases_required_seed
PASS corrupted_seed_rejected
PASS truncated_grid_rejected
```

All three pinned Agda aggregates and the false-certificate negative test
were rerun successfully. Four new Self checks exercise the benchmark
exclusion, successful larger seed, actual final mass and rescue by a higher
rate. The complete model suite and four existing GUI checks passed.
The Fortran compiler is UNAVAILABLE on this host: comparisons use the
committed Fortran fixture, whose bytes are preserved. No new runtime proof,
mass measurement, uncertainty inference or observational helix is claimed.

This branch is an implementation and executed-test result. It does not
substitute for the repository's independent guardian review.
