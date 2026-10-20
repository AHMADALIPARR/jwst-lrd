/* Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 * Dual-licensed: AGPL-3.0-or-later plus SnapKitty Opaque License.
 * SPDX-License-Identifier: AGPL-3.0-or-later AND LicenseRef-SnapKitty-Opaque
 *
 * LRD-REC-v1 canonical records (research/CONTRACTS.md): builder, strict parser, commitment.
 * Records are kept sorted bytewise by key at insertion time, so serialization is canonical.
 * The strict parser accepts a byte string iff it is the exact canonical serialization of some
 * record (parse(s) succeeds  =>  serialize(parse(s)) == s, checked byte for byte).
 */
#ifndef LRD_REC_H
#define LRD_REC_H

#include <stddef.h>
#include "../abi/lrd_state.h"

typedef struct lrd_rec {
  size_t n, cap;
  char  **key;   size_t *key_len;   /* each NUL-terminated copy; key_len excludes NUL */
  char  **val;   size_t *val_len;
} lrd_rec_t;

void lrd_rec_init(lrd_rec_t *r);
void lrd_rec_free(lrd_rec_t *r);
/* Insert a field. Returns 0 on success, -1 on duplicate key, empty key, newline or invalid
 * UTF-8 in key/value, or allocation failure. */
int  lrd_rec_setn(lrd_rec_t *r, const char *k, size_t kl, const char *v, size_t vl);
int  lrd_rec_set(lrd_rec_t *r, const char *k, const char *v);
/* NULL if absent. Returned pointer is NUL-terminated (values containing NUL bytes cannot be
 * stored because LRD-REC-v1 values are UTF-8 text; NUL is rejected as well). */
const char *lrd_rec_get(const lrd_rec_t *r, const char *k);
/* Serialize: *out is malloc'd. Returns 0 / -1. */
int  lrd_rec_serialize(const lrd_rec_t *r, unsigned char **out, size_t *len);
/* Strict canonical parse. Returns 0 on success; on failure returns -1 and sets *why (static
 * string) if why != NULL. *out must be freshly initialised; it is filled on success. */
int  lrd_rec_parse(const unsigned char *s, size_t n, lrd_rec_t *out, const char **why);
/* Commitment: lowercase hex SHA-256 over "LRD-COMMIT-v1\0" || serialization. */
int  lrd_rec_commit_hex(const lrd_rec_t *r, char out[LRD_HEX256_BUF]);
void lrd_sha256_hex(const void *data, size_t n, char out[LRD_HEX256_BUF]);
void lrd_hex_encode(const unsigned char *b, size_t n, char *out /* 2n+1 */);
/* 0 on success; requires exactly 2n lowercase hex chars. */
int  lrd_hex_decode(const char *hex, unsigned char *out, size_t n);
int  lrd_utf8_valid_no_nl(const char *s, size_t n);

#endif
