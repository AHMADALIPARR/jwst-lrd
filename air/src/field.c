/* SPDX-License-Identifier: AGPL-3.0-only
 * Additional terms: SnapKitty Opaque License (SNAPKITTY_OPAQUE_LICENSE.md, repository root).
 * Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 */
#include "air/field.h"
#include <stdlib.h>

fp fp_pow(fp a, uint64_t e) {
  fp r = 1;
  while (e) {
    if (e & 1) r = fp_mul(r, a);
    a = fp_mul(a, a);
    e >>= 1;
  }
  return r;
}
fp fp_inv(fp a) { return a ? fp_pow(a, FP_P - 2) : 0; }
fp fp_from_i64(int64_t v) {
  if (v >= 0) return (uint64_t)v % FP_P;
  uint64_t m = (uint64_t)(-(v + 1)) + 1u; /* |v| without overflow */
  m %= FP_P;
  return m ? FP_P - m : 0;
}
int fp_is_canonical(uint64_t v) { return v < FP_P; }
fp fp_root_of_unity(unsigned log2n) {
  if (log2n > FP_TWO_ADICITY) return 0;
  return fp_pow(FP_GEN, (FP_P - 1) >> log2n);
}
void fp_batch_inv(fp *a, size_t n) {
  if (!n) return;
  fp *pre = malloc(n * sizeof *pre);
  if (!pre) abort();
  fp acc = 1;
  for (size_t i = 0; i < n; i++) { pre[i] = acc; acc = fp_mul(acc, a[i]); }
  fp inv = fp_inv(acc);
  for (size_t i = n; i-- > 0;) {
    fp t = fp_mul(inv, pre[i]);
    inv = fp_mul(inv, a[i]);
    a[i] = t;
  }
  free(pre);
}
fp2 fp2_inv(fp2 a) {
  /* (c0 + c1 u)^-1 = (c0 - c1 u) / (c0^2 - 7 c1^2) */
  fp n = fp_sub(fp_sqr(a.c0), fp_mul(FP2_NONRES, fp_sqr(a.c1)));
  fp ni = fp_inv(n);
  return fp2_make(fp_mul(a.c0, ni), fp_neg(fp_mul(a.c1, ni)));
}
fp2 fp2_pow(fp2 a, uint64_t e) {
  fp2 r = fp2_from_fp(1);
  while (e) {
    if (e & 1) r = fp2_mul(r, a);
    a = fp2_mul(a, a);
    e >>= 1;
  }
  return r;
}
void fp2_batch_inv(fp2 *a, size_t n) {
  if (!n) return;
  fp2 *pre = malloc(n * sizeof *pre);
  if (!pre) abort();
  fp2 acc = fp2_from_fp(1);
  for (size_t i = 0; i < n; i++) { pre[i] = acc; acc = fp2_mul(acc, a[i]); }
  fp2 inv = fp2_inv(acc);
  for (size_t i = n; i-- > 0;) {
    fp2 t = fp2_mul(inv, pre[i]);
    inv = fp2_mul(inv, a[i]);
    a[i] = t;
  }
  free(pre);
}
