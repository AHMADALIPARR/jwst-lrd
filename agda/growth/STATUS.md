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

## Typecheck status: PASSES on Agda 2.6.4.3 / stdlib 2.1 (re-checked 2026-10-26)
`agda -i. -i/usr/share/agda-stdlib/src Growth.agda` (run from `agda/growth/`,
`--safe --without-K`) completes without error in about 7 s; no postulates.
`tests/growth/run.sh` reports `PASS growth_agda_typechecks`.

An earlier revision of this file was written against stdlib 1.7.3 and never
typechecked end to end. Porting it to stdlib 2.1 (the version pinned in
`agda/VERSIONS` and `agda/agda-dir/libraries`) needed only these changes; no
statement or proof obligation was altered:
- `*-monoˡ-≤-nonNeg` / `*-monoʳ-≤-nonNeg` take the `NonNegative` witness as an
  instance argument (`{{ ... }}`) instead of an explicit one.
- `toWitness tt` got the decision procedure spelled out (`toWitness {a? = x ≤? y} tt`),
  otherwise the `Dec` argument is an unsolved meta.
- `factor≥1` / `factor≥0` are applied with their implicit `step`/`n` given,
  because `factorOf step n = pow step n` is not invertible for unification.
The "Heap exhausted" problem recorded in the earlier revision did not occur.
The stdlib source tree is `/usr/share/agda-stdlib/src` (the 2.1 layout), which is
what `tests/growth/run.sh` now passes as the include path.
