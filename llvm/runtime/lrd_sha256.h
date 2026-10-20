/* SPDX-License-Identifier: AGPL-3.0-only
 * Also licensed under the SnapKitty Opaque License; see LICENSE and
 * SNAPKITTY_OPAQUE_LICENSE.md at the repository root.
 * Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 *
 * SHA-256 (FIPS 180-4), self-contained implementation for the LRD-IR runtime.
 */
#ifndef LRD_SHA256_H
#define LRD_SHA256_H
#include <stddef.h>
#include <stdint.h>

typedef struct { uint32_t h[8]; uint64_t nbytes; unsigned char buf[64]; size_t blen; } lrd_sha256_ctx;

void lrd_sha256_init(lrd_sha256_ctx *c);
void lrd_sha256_update(lrd_sha256_ctx *c, const void *data, size_t n);
void lrd_sha256_final(lrd_sha256_ctx *c, unsigned char out[32]);
/* hex: 64 lowercase hex chars + NUL */
void lrd_sha256_hex(const void *data, size_t n, char hex[65]);
void lrd_hex32(const unsigned char d[32], char hex[65]);
#endif
