/* SPDX-License-Identifier: AGPL-3.0-only
 * Also licensed under the SnapKitty Opaque License; see LICENSE and
 * SNAPKITTY_OPAQUE_LICENSE.md at the repository root.
 * Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 *
 * LRD-REC-v1 canonical records (research/CONTRACTS.md): build, serialize,
 * strictly parse, and commit ("LRD-COMMIT-v1\0" || serialization, SHA-256 hex).
 */
#ifndef LRD_REC_H
#define LRD_REC_H
#include <stddef.h>

#define LRD_REC_MAX_FIELDS 32

typedef struct { char *key; char *value; } lrd_rec_field;
typedef struct lrd_rec { size_t n; lrd_rec_field f[LRD_REC_MAX_FIELDS]; } lrd_rec;

lrd_rec *lrd_rec_new(void);
void lrd_rec_free(lrd_rec *r);
/* insert keeping bytewise-sorted order; returns nonzero on duplicate/invalid key or value */
int lrd_rec_set(lrd_rec *r, const char *key, const char *value);
const char *lrd_rec_get(const lrd_rec *r, const char *key);
/* malloc'd serialization; *len receives its byte length */
char *lrd_rec_serialize(const lrd_rec *r, size_t *len);
void lrd_rec_commit(const lrd_rec *r, char hex[65]);
/* strict parse; on error returns NULL and writes reason into err */
lrd_rec *lrd_rec_parse(const char *buf, size_t len, char *err, size_t errlen);
#endif
