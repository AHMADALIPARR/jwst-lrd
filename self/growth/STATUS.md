<!-- SPDX-License-Identifier: AGPL-3.0-only. Also subject to SNAPKITTY_OPAQUE_LICENSE.md (dual license). -->
# self/growth/STATUS.md — QSO1 growth front end (Mission QSO1-DCBH-001, role 10)

Written 2026-10-20 under the SUNDAY EXECUTION directive: "build out the front
end using the self code only morphic no python typescript don't add any code
that's not already there." The growth front end is built ONLY from the
repository's existing Self code and idioms — no new language, no new
framework, no code imported from outside the repo:

- `self/growth/growthHistory.self` — reuses the topology track's
  `simplicialComplex parseRecords:IfFail:` (the repo's LRD-REC-v1 parser)
  verbatim as its record reader; adds only growth-dataset accessors in the
  same prototype style (hand-written ES-float reader mirroring
  `tests/ledger/ledger.self`'s `parseLeadingNumber:` idiom; row lookups;
  feasible counters; benchmark seed; commitment string).
- `self/growth/growthMorph.self` — a `ui2Morph`-style chart in the idiom of
  `self/topology/topologyMorph.self`: minimum seed vs formation redshift
  for lambda = 0.5 / 1 / 3 (epsilon = 0.1, duty = 1 slice) on a log10 seed
  axis over the swept seed range 10--1e5 Msun, with feasible counts, the
  benchmark seed, and the dataset commitment as painted text.
- `self/growth/gui_demo_growth.self` — mirrors `self/topology/gui_demo.self`
  (same worldMorph open + "Scheduler started" wait + GUI_DONE marker), with
  the `growthGuiDemo` globals registration.
- `tests/growth/self_headless_growth.self` — mirrors
  `tests/topology/self_headless.self` (PRESS RETURN prompt, PASS/FAIL
  lines, SELF_DONE marker): six checks against the Fortran dataset,
  including that the Self-read feasible counts equal the solver's, and that
  the benchmark seed read through Self lies in (480, 525) Msun.

## Execution status in THIS environment: UNAVAILABLE (kernel-level)

The Self VM cannot run on this VM, for a reason below the repo's control:
**32-bit x86 execution segfaults at the kernel level here.** Evidence
(2026-10-20): a trivial `int main(){return 0;}` built with `gcc -m32`
(dynamically linked AND static) exits 139 (SIGSEGV) on this host
(kernel 7.0.0-39-generic). The repo's Self build is 32-bit
(`build/tools/self-src/build32`); its own build tool `makeDeps` segfaults
during the build at the `_precompiled.hh` generation step for the same
reason. The topology track's Self programs were exercised on the repo
host, whose kernel permits IA32 execution.

Accordingly `tests/growth/run.sh` reports the Self sections as
`UNAVAILABLE growth_self_*` in this environment (no built Self VM), and
the files above stand as source deliverables written entirely in the
repo's existing Self idiom, to be exercised wherever a 32-bit-capable
host runs the repo's `build/install-curry-self.sh`. No behavior of the
growth front end is claimed as executed here.
