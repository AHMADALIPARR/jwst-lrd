/* SPDX-License-Identifier: AGPL-3.0-only
 * Also licensed under the SnapKitty Opaque License; see LICENSE and
 * SNAPKITTY_OPAQUE_LICENSE.md at the repository root.
 * Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 *
 * JWST-LRD numeric interoperability ABI (C17), owned by the t014 track.
 * Implements the LRD-ARR-v1 array container from research/CONTRACTS.md:
 *   <prefix>.f64  raw little-endian IEEE-754 binary64 values
 *   <prefix>.hdr  lines "key=value"; required: format=LRD-ARR-v1, name, length, unit;
 *                 optional: source_sha256; other keys are preserved but not interpreted.
 *
 * Design choices (CONTRACTS.md does not fix them; documented here):
 *   - A path argument is the PREFIX (without .f64/.hdr).
 *   - length is base-10, no sign, no leading zeros ("0" allowed), < 2^60.
 *   - Duplicate keys, lines without '=', an empty key, '\r' anywhere, an empty
 *     name or unit, or a non-hex/non-64-char source_sha256 are header errors.
 *   - Byte order is decoded explicitly, so the reader is host-endian independent.
 *   - All functions return 0 on success, nonzero on error, and write a
 *     NUL-terminated human-readable reason into err (if err != NULL).
 */
#ifndef LRD_NUM_ABI_H
#define LRD_NUM_ABI_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define LRD_NUM_ABI_NAME    "LRD-NUM-ABI"
#define LRD_NUM_ABI_VERSION 1
#define LRD_ARR_FORMAT      "LRD-ARR-v1"

#define LRD_ARR_NAME_MAX  255u
#define LRD_ARR_UNIT_MAX  63u
#define LRD_ARR_EXTRA_MAX 4095u

/* Error codes */
#define LRD_ARR_OK          0
#define LRD_ARR_E_IO        1  /* cannot open/read/write a file */
#define LRD_ARR_E_HEADER    2  /* malformed header / missing or bad key */
#define LRD_ARR_E_FORMAT    3  /* format != LRD-ARR-v1 */
#define LRD_ARR_E_LENGTH    4  /* data size != 8 * length */
#define LRD_ARR_E_UNIT      5  /* unit does not match the expected unit */
#define LRD_ARR_E_NOMEM     6
#define LRD_ARR_E_ARG       7

typedef struct lrd_arr {
  char     name[LRD_ARR_NAME_MAX + 1u];
  char     unit[LRD_ARR_UNIT_MAX + 1u];
  char     source_sha256[65];             /* "" when absent */
  char     extra[LRD_ARR_EXTRA_MAX + 1u]; /* other key=value lines, '\n'-terminated each */
  int64_t  length;
  double  *data;                          /* malloc'd, length elements (NULL if length 0) */
} lrd_arr_t;

/* ABI version implemented by the linked library (compare with LRD_NUM_ABI_VERSION). */
int lrd_num_abi_version(void);

/* Read <prefix>.hdr and <prefix>.f64. If expect_unit != NULL the header unit must
 * equal it exactly (else LRD_ARR_E_UNIT). On error *out is left with data == NULL. */
int lrd_arr_read(const char *prefix, const char *expect_unit, lrd_arr_t *out,
                 char *err, size_t errlen);

/* Write <prefix>.hdr (format, name, length, unit, then extra_hdr lines verbatim if
 * non-NULL; extra_hdr must be "key=value\n" lines) and <prefix>.f64. */
int lrd_arr_write(const char *prefix, const char *name, const char *unit,
                  const double *data, int64_t length, const char *extra_hdr,
                  char *err, size_t errlen);

void lrd_arr_free(lrd_arr_t *a);

#ifdef __cplusplus
}
#endif

#endif /* LRD_NUM_ABI_H */
