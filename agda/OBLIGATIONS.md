<!-- SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque -->
# Invariants and trust boundaries

These aggregates have been checked by Agda 2.6.4.3 / stdlib 2.1 in
`--safe --without-K` mode. Rerun `tests/morphic/proofs.sh` after changing
sources; the recorded result includes a canonical-LF source-tree hash.

| Aggregate | Checked scope |
|---|---|
| `Core.All` | Observation preservation, increasing sequences, ledger constraints, causal ordering, boundary algebra, Hamiltonian checks, capability checks, generic transition soundness/completeness and accepted-run preservation |
| `Kernel.Everything` | Integrated accepted-state invariant, capability consumption, sequence preservation, causal structure, general integer-chain boundary composition, and conditional runtime-bridge theorems |
| `Growth` | Rational stepped-growth algebra, nonnegative factors, seed/multiplier monotonicity, no mass loss for allowed epochs, epoch composition, symbolic factor bounds and the conservative benchmark certificate |

The deliberately false certificate in `tests/morphic/BadGrowth.agda` must
fail typechecking. It is a negative test, never part of a proof aggregate.

## Conditions that are not unconditional theorems

- **Continuous growth:** `Growth.Benchmark.verify` requires a lower-bound
  bridge from the rational Euler factor to the continuous solver factor.
  No real exponential or floating-point error analysis is proved here.
- **Physical inputs:** cosmological parameters and uncertain measured masses
  are inputs with provenance, not conclusions of Agda normalization.
- **Runtime fidelity:** the deployed trace must refine the modeled transition
  function and retain its genesis. The kernel derives trace invariants from
  that refinement; it cannot inspect a running deployment.
- **Cryptography:** commitment binding and accumulator security are conditional
  on the explicit assumptions in `Kernel.Assumptions.Crypto`.
- **Observation decoding:** raw-byte fidelity and faithful FITS decoding remain
  runtime obligations. A theorem about immutable model values is not a proof
  that an external decoder supplied the correct values.

There are no inserted inhabitants for these assumptions. An assumption
statement is not a stub to replace with a postulate. See
[ASSUMPTIONS.md](ASSUMPTIONS.md) and the source modules for exact types.
Independent review is separate from successful typechecking.
