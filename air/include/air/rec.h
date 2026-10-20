/* SPDX-License-Identifier: AGPL-3.0-only
 * Additional terms: SnapKitty Opaque License (SNAPKITTY_OPAQUE_LICENSE.md, repository root).
 * Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 *
 * LRD-REC-v1 canonical records (research/CONTRACTS.md):
 *   "LRD-REC-v1\n" then per field (keys sorted bytewise ascending, no duplicates)
 *   "<len(key)>:<key><len(value)>:<value>\n"; commitment = lowercase hex SHA-256 of
 *   "LRD-COMMIT-v1\0" || serialization.
 */
#ifndef AIR_REC_H
#define AIR_REC_H
#include <stddef.h>
#include <stdint.h>

#define REC_MAX_FIELDS 32
#define REC_MAX_KEY 64
#define REC_MAX_VAL 256

typedef struct {
  size_t n;
  char key[REC_MAX_FIELDS][REC_MAX_KEY + 1];
  char val[REC_MAX_FIELDS][REC_MAX_VAL + 1];
} lrd_rec;

void rec_init(lrd_rec *r);
/* Returns 0, or -1 on duplicate key / overflow / newline in value / empty key. */
int rec_set(lrd_rec *r, const char *key, const char *val);
int rec_set_u64(lrd_rec *r, const char *key, uint64_t v);
int rec_set_i64(lrd_rec *r, const char *key, int64_t v);
const char *rec_get(const lrd_rec *r, const char *key);
/* Serialize into a malloc'd buffer (sorted). *len receives byte count. Returns NULL on error. */
unsigned char *rec_serialize(const lrd_rec *r, size_t *len);
/* Parse a serialization (strict: magic, lengths, sorted unique keys, no trailing bytes). */
int rec_parse(lrd_rec *r, const unsigned char *buf, size_t len);
/* LRD-COMMIT-v1 commitment as 64 lowercase hex chars + NUL. Returns 0 on success. */
int rec_commit(const lrd_rec *r, char out[65]);
#endif
