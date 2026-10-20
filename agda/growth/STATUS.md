<!-- SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque -->
# Growth invariants

Growth.agda has passed Agda 2.6.4.3 with stdlib 2.1, --safe --without-K,
on the NUC under WSL. tests/morphic/proofs.sh also checks Core.All and
Kernel.Everything. Results and the checked source-tree SHA-256 are recorded
in tests/morphic/evidence/proof-results.txt and proofs.rec.

The heap-exhausting certificate is replaced by local rational inequalities
and monotonic multiplication. For step 55/32, four squarings have respective
lower bounds 295/100, 87/10, 75 and 5625. A 9000-solar-mass seed therefore
reaches at least 50,625,000 solar masses in the 16-step lower-bound model.
No large closed rational is evaluated to decide this inequality. Witnesses
specify their decision procedures; recursive proofs specify their step counts.

Other checked results cover power composition, squaring-chain equivalence,
factor nonnegativity, monotonicity in seed and multiplier, nondecreasing
mass for nonnegative seeds and multipliers at least one, exact epoch
composition, and sufficient factor bounds. The BadGrowth.agda negative
control must be rejected at its impossible decidable witness.

This conservative certificate is not the numerical minimum of approximately
502.15 solar masses. Benchmark.verify is conditional on A-GR-1: the certified
Euler factor lower-bounds the continuous solver factor. Rational benchmark
input bounds are declared inputs. No theorem here establishes measured mass,
floating-point error bounds, cosmology, or runtime refinement. These explicit
trust boundaries are not filled with axioms. No postulates, holes, unsafe
flags or termination escapes were introduced.

Stdlib 2.1 emits UnsupportedIndexedMatch compatibility warnings under Agda
2.6.4.3. The checker exits zero; project modules remain safe and without K.
Existing toolchain pins are preserved. Independent reviewer sign-off remains
separate from these executed checks.
