/* SPDX-License-Identifier: AGPL-3.0-only
 * Additional terms: SnapKitty Opaque License (SNAPKITTY_OPAQUE_LICENSE.md, repository root).
 * Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 *
 * Radix-2 NTT / inverse NTT over 2-power subgroups of Fp, polynomial interpolation (iNTT),
 * evaluation (Horner) and coset low-degree extension (LDE).
 * Convention: evaluations are in natural order, a[i] = f(w^i) with w = fp_root_of_unity(log2 n).
 */
#ifndef AIR_POLY_H
#define AIR_POLY_H
#include "air/field.h"

/* In-place forward NTT: coefficients -> evaluations on <w_n>. n must be a power of two <= 2^32. */
int fp_ntt(fp *a, size_t n);
/* In-place inverse NTT: evaluations on <w_n> -> coefficients (interpolation). */
int fp_intt(fp *a, size_t n);
/* Evaluate on coset offset*<w_n>: coefficients (length n) -> evaluations, in place. */
int fp_coset_ntt(fp *a, size_t n, fp offset);
/* Interpolate from coset offset*<w_n> evaluations back to coefficients, in place. */
int fp_coset_intt(fp *a, size_t n, fp offset);
/* Low-degree extension: evals over <w_n> (length n) -> evals over offset*<w_{n*blowup}>.
 * out must hold n*blowup elements. */
int fp_lde(const fp *evals, size_t n, size_t blowup, fp offset, fp *out);
fp fp_poly_eval(const fp *coef, size_t n, fp x);
fp2 fp_poly_eval_ext(const fp *coef, size_t n, fp2 x);
fp2 fp2_poly_eval(const fp2 *coef, size_t n, fp2 x);
int is_pow2(size_t n);
unsigned log2_exact(size_t n);
#endif
