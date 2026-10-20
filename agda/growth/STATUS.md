<!-- SPDX-License-Identifier: AGPL-3.0-only. Also subject to SNAPKITTY_OPAQUE_LICENSE.md (dual license). -->
# agda/growth/STATUS.md — QSO1 growth certificate (Mission QSO1-DCBH-001, role 07)

Written 2026-10-20 under the SUNDAY EXECUTION directive (QSO1 GROWTH
CONSTRAINTS). File: `agda/growth/Growth.agda` (`--safe --without-K`).

## What is proven in the source (statement level)
- An **exact symbolic threshold** for the stepped growth factor
  `factorOf step n = step ^ n`: `sufficient` (any certified lower bound
  on the factor turns into a sufficient seed condition) and `necessary`
  (below the threshold the stepped model does not reach the target) make
  seed\* = target / factor the exact threshold of the stepped model. No
  numerical constant is baked into these theorems; **497 appears nowhere
  in the file** (directive: do not encode the benchmark figure as a
  universal constant).
- Monotonicity (`grow-mono`), factor bounds (`factor>=1`, `factor>=0`),
  power algebra (`pow-add`), and `sqPow==pow` (the squaring chain used to
  make the closed check evaluable).
- A **benchmark certificate** (module `Benchmark`): declared rational
  input bounds dtLo = 576/1000 Gyr (solver: 0.5760588..., Planck 2018) and
  tEddHi = 4505/10000 Gyr (CODATA 2018: 0.45049041...), the cross-multiplied
  exponent bound E >= 23/2 (`eLo-cert`), and a closed decidable check that
  1300 Msun x (64-step Euler factor at E = 23/2) >= 5e7 Msun, giving a
  certified sufficient seed of **1300 Msun** for the benchmark tuple under
  the stated bridge assumption **A-GR-1** ((1 + E/n)^n <= exp(E_true) for
  E <= E_true, the solver's continuous factor; a caller-supplied proof
  parameter of `Benchmark.verify`, in the repo's A-ST idiom — not a
  hidden postulate). The solver's numerical threshold is 502.15 Msun;
  the certificate is deliberately conservative (coarse Euler steps
  underestimate the exponential).

## Typecheck status: NOT YET COMPLETED — read before citing
As of writing, the file has **not** been typechecked end to end, and no
result is claimed:
- Scope/type errors found by Agda 2.6.3 during iteration were fixed
  (missing `tt` import; ambiguous `_+_`; `_/_` literal imports; the
  stdlib 1.7.3 `*-mono*-<=-nonNeg` signature, which takes the value and
  a `NonNegative` wrapper explicitly) — each fix was verified to move the
  checker past the previous error.
- The remaining failure is resource exhaustion, not a reported type
  error: full checks repeatedly hit Agda's default heap cap
  (3,584 MB, "Heap exhausted") during normalization, at 1024, 512, and
  64 certificate steps alike, and one raised-heap run was OOM-killed on
  this 7 GB VM. The size-independence points at the certificate's
  normalization encoding, not the arithmetic magnitude; the planned next
  step is a bisect (generic part vs. Benchmark part) and, if the
  `toWitness (<=?)` encoding is the sink, restating the closed check over
  unnormalised rationals (Data.Rational.Unnormalised), where
  multiplication does not trigger gcd normalization.
- Environment note: this VM provides Agda 2.6.3 / stdlib 1.7.3 (Ubuntu
  noble apt), while `agda/agda-dir/libraries` pins stdlib 2.1 for the
  core library. The growth module is written against 1.7.3 as installed;
  the version discrepancy is recorded here rather than papered over.

The repository's full-suite entry point reports this section through
`tests/growth/run.sh` (`growth_agda_typechecks`); until that prints
PASS on a completed run, treat the certificate as **stated, not checked**.
