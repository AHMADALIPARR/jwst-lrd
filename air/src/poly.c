/* SPDX-License-Identifier: AGPL-3.0-only
 * Additional terms: SnapKitty Opaque License (SNAPKITTY_OPAQUE_LICENSE.md, repository root).
 * Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 */
#include "air/poly.h"
#include <string.h>

int is_pow2(size_t n) { return n && !(n & (n - 1)); }
unsigned log2_exact(size_t n) {
  unsigned k = 0;
  while (((size_t)1 << k) < n) k++;
  return k;
}

static void bit_reverse(fp *a, size_t n) {
  for (size_t i = 1, j = 0; i < n; i++) {
    size_t bit = n >> 1;
    for (; j & bit; bit >>= 1) j ^= bit;
    j ^= bit;
    if (i < j) { fp t = a[i]; a[i] = a[j]; a[j] = t; }
  }
}

static int ntt_core(fp *a, size_t n, int inverse) {
  if (!is_pow2(n)) return -1;
  unsigned logn = log2_exact(n);
  if (logn > FP_TWO_ADICITY) return -1;
  bit_reverse(a, n);
  for (unsigned s = 1; s <= logn; s++) {
    size_t m = (size_t)1 << s, half = m >> 1;
    fp wm = fp_root_of_unity(s);
    if (inverse) wm = fp_inv(wm);
    for (size_t k = 0; k < n; k += m) {
      fp w = 1;
      for (size_t j = 0; j < half; j++) {
        fp t = fp_mul(w, a[k + j + half]);
        fp u = a[k + j];
        a[k + j] = fp_add(u, t);
        a[k + j + half] = fp_sub(u, t);
        w = fp_mul(w, wm);
      }
    }
  }
  if (inverse) {
    fp ninv = fp_inv((fp)n % FP_P);
    for (size_t i = 0; i < n; i++) a[i] = fp_mul(a[i], ninv);
  }
  return 0;
}
int fp_ntt(fp *a, size_t n) { return ntt_core(a, n, 0); }
int fp_intt(fp *a, size_t n) { return ntt_core(a, n, 1); }
int fp_coset_ntt(fp *a, size_t n, fp offset) {
  fp s = 1;
  for (size_t i = 0; i < n; i++) { a[i] = fp_mul(a[i], s); s = fp_mul(s, offset); }
  return fp_ntt(a, n);
}
int fp_coset_intt(fp *a, size_t n, fp offset) {
  if (fp_intt(a, n)) return -1;
  fp oi = fp_inv(offset), s = 1;
  for (size_t i = 0; i < n; i++) { a[i] = fp_mul(a[i], s); s = fp_mul(s, oi); }
  return 0;
}
int fp_lde(const fp *evals, size_t n, size_t blowup, fp offset, fp *out) {
  if (!is_pow2(n) || !is_pow2(blowup)) return -1;
  size_t m = n * blowup;
  memcpy(out, evals, n * sizeof *out);
  if (fp_intt(out, n)) return -1;
  memset(out + n, 0, (m - n) * sizeof *out);
  return fp_coset_ntt(out, m, offset);
}
fp fp_poly_eval(const fp *coef, size_t n, fp x) {
  fp r = 0;
  for (size_t i = n; i-- > 0;) r = fp_add(fp_mul(r, x), coef[i]);
  return r;
}
fp2 fp_poly_eval_ext(const fp *coef, size_t n, fp2 x) {
  fp2 r = fp2_from_fp(0);
  for (size_t i = n; i-- > 0;) r = fp2_add(fp2_mul(r, x), fp2_from_fp(coef[i]));
  return r;
}
fp2 fp2_poly_eval(const fp2 *coef, size_t n, fp2 x) {
  fp2 r = fp2_from_fp(0);
  for (size_t i = n; i-- > 0;) r = fp2_add(fp2_mul(r, x), coef[i]);
  return r;
}
