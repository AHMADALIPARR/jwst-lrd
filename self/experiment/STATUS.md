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

This branch is an implementation and executed-test result. It does not
substitute for the repository's independent guardian review.
