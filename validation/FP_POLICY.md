<!-- SPDX-License-Identifier: AGPL-3.0-only. Also licensed under the SnapKitty Opaque License; see LICENSE and SNAPKITTY_OPAQUE_LICENSE.md at the repository root. -->
# Floating-point policy (t014: LRD-IR / lrdc / validation)

## Arithmetic model
- All numeric values are IEEE-754 **binary64** (`double`, 53-bit significand).
- Rounding: **round-to-nearest, ties-to-even** (the IEEE default). Nothing in lrdc,
  its runtime or the harness changes the rounding mode.
- `FLT_EVAL_METHOD == 0`: no extended-precision intermediates (x86-64 SSE2).
- **No fast-math.** lrdc never emits fast-math flags (`fast`, `reassoc`, `nnan`, `ninf`,
  `nsz`, `arcp`, `afn`) on LLVM instructions.
- **No FMA contraction.** lrdc never emits the `contract` flag; it runs
  `llc -O2 --fp-contract=off` and links with `clang -ffp-contract=off -fno-fast-math`.
  The runtime, ABI and helpers are compiled with `-ffp-contract=off -fno-fast-math`
  (llvm/Makefile `CFLAGS`). No contraction is declared anywhere, so none is allowed.

## Enforcement (tests/validation/run.sh -> validation/harness.sh)
| test | what it checks |
|---|---|
| `fp_policy_env_binary64_rne` | `validation/fp_probe.c`: DBL_MANT_DIG=53, FLT_EVAL_METHOD=0, `fegetround()==FE_TONEAREST`, two ties-to-even cases |
| `fp_policy_ll_no_fastmath_or_contract_flags` | every `.ll` emitted for tests/llvm/programs and validation/programs contains none of the words `fast contract reassoc nnan ninf nsz arcp afn` |
| `fp_policy_build_flags` | `make -C llvm print-cflags` contains `-ffp-contract=off` and no `-ffast-math`/`-Ofast`/`-ffinite-math-only`/`-funsafe-math-optimizations`/`-ffp-contract=on|fast` |
| `fp_policy_lrdc_invokes_llc_clang_contract_off` | the lrdc binary carries the `--fp-contract=off` (llc) and `-ffp-contract=off -fno-fast-math` (clang) arguments |
| `fp_policy_no_fma_instructions` | `objdump -d` of the runtime library and a linked LRD-IR executable has no `vfmadd/vfmsub/vfnmadd/vfnmsub` |
| `fp_policy_table_matches_tolerances_tsv` | the table below equals `validation/tolerances.tsv`, which is what `lrdcmp` actually reads |

## Comparison rule
Element i passes iff `|got_i - ref_i| <= atol + rtol * |ref_i|`; NaN must face NaN,
infinities must be equal, lengths must be equal, units must be equal (validation/lrdcmp.c).

## Per-op tolerance table (used by tests/llvm and validation via tolerances.tsv)
| op | atol | rtol | justification |
|---|---|---|---|
| restframe | 0 | 0 | one correctly rounded `fadd` (1+z) and one `fdiv` per element; every conforming binary64 implementation of `lambda/(1+z)` gives the identical bits |
| obsframe | 0 | 0 | same argument with one `fmul` |
| convert | 0 | 0 | one `fmul` or `fdiv` by an exactly representable factor (1e4, 1e3, 10) per element |
| residuals | 0 | 0 | one `fsub` per element |
| redshift | 0 | 0 | `obs/rest - 1`: two correctly rounded ops in a fixed order (reference uses the same formula) |
| redshift_arr | 0 | 0 | as redshift, elementwise |
| chi2 | 0 | 1e-12 | sum of n non-negative terms; implementations may sum in different orders (Futhark reduces as a tree). Relative error of any order is <= gamma_(n-1) ~ (n-1)*2^-53 plus per-term 3 ulp; for n <= 4096 that is < 5e-13, so 1e-12 is a bound, not a fudge. Same-order references (tests/llvm/helpers/ref.c) agree exactly |
| matmul | 0 | 0 | lrdc runtime and the C reference both sum k ascending with separate mul/add (no FMA), so results are bit-identical |
| matmul_xlang | 1e-12 | 1e-12 | reserved for a cross-language matmul reference with a different summation order (k-term dot products of O(1) entries; error <= k*2^-53*sum|a||b|); no such reference is wired up yet |
| solve | 1e-12 | 1e-12 | LU with partial pivoting is backward stable; forward error <= ~n*cond(A)*2^-53. Test matrices are 3x3 with cond_2 < 10 and O(1) solutions, giving < 1e-14; compared against Cramer's rule (different algorithm) and exact hand values |

## Out of scope / not claimed
- No tolerance is defined for ops not listed in llvm/SUPPORT.md.
- `chi2` here does not mask pixels: sigma <= 0 or non-finite sigma is a runtime error
  (the Futhark/Fortran tracks mask such pixels; the harness only feeds valid inputs).
