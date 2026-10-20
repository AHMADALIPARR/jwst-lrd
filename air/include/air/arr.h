/* SPDX-License-Identifier: AGPL-3.0-only
 * Additional terms: SnapKitty Opaque License (SNAPKITTY_OPAQUE_LICENSE.md, repository root).
 * Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 *
 * LRD-ARR-v1 loader (research/CONTRACTS.md): <base>.f64 raw little-endian binary64 values and
 * <base>.hdr "key=value" lines with required keys format=LRD-ARR-v1, name, length, unit.
 * Fixed-point encoding for the AIR: q_i = llround(v_i * scale) (round half away from zero),
 * requiring finite v_i and |v_i * scale| <= 2^24. The scale is chosen by the caller and recorded
 * in the public-input record (key "scale").
 */
#ifndef AIR_ARR_H
#define AIR_ARR_H
#include <stddef.h>
#include <stdint.h>

typedef struct {
  char name[256], unit[256], source_sha256[65];
  size_t length;
  double *v;
  char f64_sha256[65]; /* SHA-256 of the raw .f64 bytes = observation_sha256 */
  int synthetic;       /* 1 iff "SYNTHETIC" appears in the base name, name, or header text */
} lrd_arr;

int arr_load(const char *base, lrd_arr *a, const char **why);
void arr_free(lrd_arr *a);
int fixed_encode(const double *v, size_t n, int64_t scale, int64_t *out, const char **why);
#endif
