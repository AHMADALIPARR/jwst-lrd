/* SPDX-License-Identifier: AGPL-3.0-only
 * Additional terms: SnapKitty Opaque License (SNAPKITTY_OPAQUE_LICENSE.md, repository root).
 * Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 *
 * Goldilocks prime field Fp, p = 2^64 - 2^32 + 1 (two-adicity 32, multiplicative generator 7),
 * and its quadratic extension Fp2 = Fp[u]/(u^2 - 7). 7 generates Fp^*, hence is a quadratic
 * non-residue, so u^2 - 7 is irreducible (checked by a unit test: 7^((p-1)/2) = -1).
 * All elements are kept canonical (in [0, p)).
 */
#ifndef AIR_FIELD_H
#define AIR_FIELD_H
#include <stddef.h>
#include <stdint.h>

#define FP_P        0xFFFFFFFF00000001ULL
#define FP_EPS      0x00000000FFFFFFFFULL /* 2^64 mod p = 2^32 - 1 */
#define FP_GEN      7ULL
#define FP_TWO_ADICITY 32u
#define FP2_NONRES  7ULL

typedef uint64_t fp;
typedef struct { fp c0, c1; } fp2; /* c0 + c1*u, u^2 = 7 */

static inline fp fp_add(fp a, fp b) {
  uint64_t s = a + b;
  int carry = s < a;
  /* if carry: real value s + 2^64 = s + EPS (mod p) and s < p-EPS so no further overflow */
  if (carry) s += FP_EPS;
  if (s >= FP_P) s -= FP_P;
  return s;
}
static inline fp fp_sub(fp a, fp b) {
  uint64_t d = a - b;
  if (a < b) d += FP_P; /* wraps back correctly modulo 2^64 */
  return d;
}
static inline fp fp_neg(fp a) { return a ? FP_P - a : 0; }

/* Reduce a 128-bit value modulo p using 2^64 = 2^32-1, 2^96 = -1 (mod p). */
static inline fp fp_reduce128(unsigned __int128 x) {
  uint64_t lo = (uint64_t)x;
  uint64_t hi = (uint64_t)(x >> 64);
  uint64_t hi_hi = hi >> 32;
  uint64_t hi_lo = hi & FP_EPS;
  uint64_t t0 = lo - hi_hi;
  if (lo < hi_hi) t0 -= FP_EPS; /* borrow: subtract 2^64 == EPS */
  uint64_t t1 = hi_lo * FP_EPS;  /* < 2^64 */
  uint64_t r = t0 + t1;
  if (r < t1) r += FP_EPS;       /* carry: add 2^64 == EPS */
  if (r >= FP_P) r -= FP_P;
  return r;
}
static inline fp fp_mul(fp a, fp b) { return fp_reduce128((unsigned __int128)a * b); }
static inline fp fp_sqr(fp a) { return fp_mul(a, a); }

fp fp_pow(fp a, uint64_t e);
fp fp_inv(fp a);                       /* a != 0; returns 0 for a == 0 */
fp fp_from_i64(int64_t v);             /* v mod p (negative values map to p - |v|) */
int fp_is_canonical(uint64_t v);
/* Primitive 2^log2n-th root of unity, log2n <= 32: 7^((p-1)/2^log2n). Returns 0 on bad input. */
fp fp_root_of_unity(unsigned log2n);
void fp_batch_inv(fp *a, size_t n);    /* in place; all entries must be nonzero */

static inline fp2 fp2_make(fp a, fp b) { fp2 r = {a, b}; return r; }
static inline fp2 fp2_from_fp(fp a) { fp2 r = {a, 0}; return r; }
static inline fp2 fp2_add(fp2 a, fp2 b) { return fp2_make(fp_add(a.c0, b.c0), fp_add(a.c1, b.c1)); }
static inline fp2 fp2_sub(fp2 a, fp2 b) { return fp2_make(fp_sub(a.c0, b.c0), fp_sub(a.c1, b.c1)); }
static inline fp2 fp2_neg(fp2 a) { return fp2_make(fp_neg(a.c0), fp_neg(a.c1)); }
static inline fp2 fp2_mul(fp2 a, fp2 b) {
  fp t0 = fp_mul(a.c0, b.c0), t1 = fp_mul(a.c1, b.c1);
  fp c0 = fp_add(t0, fp_mul(FP2_NONRES, t1));
  fp c1 = fp_add(fp_mul(a.c0, b.c1), fp_mul(a.c1, b.c0));
  return fp2_make(c0, c1);
}
static inline fp2 fp2_mul_fp(fp2 a, fp b) { return fp2_make(fp_mul(a.c0, b), fp_mul(a.c1, b)); }
static inline int fp2_eq(fp2 a, fp2 b) { return a.c0 == b.c0 && a.c1 == b.c1; }
static inline int fp2_is_zero(fp2 a) { return a.c0 == 0 && a.c1 == 0; }
fp2 fp2_inv(fp2 a);
fp2 fp2_pow(fp2 a, uint64_t e);
void fp2_batch_inv(fp2 *a, size_t n);

#endif
