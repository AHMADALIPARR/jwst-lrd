/* Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 * Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
 * SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
 *
 * LRD-ENV-v1: versioned, canonical, length-delimited record envelope.
 * Supports zero-length through multi-megabyte payloads. Legacy LRD-REC-v1
 * text records are accepted as payload and remain decodable.
 * Canonical serialized bytes are bound to the ledger commitment via SHA-256.
 */
#ifndef LRD_ENV_H
#define LRD_ENV_H

#include <stddef.h>
#include <stdint.h>

#define LRD_ENV_MAGIC "LRD-ENV-v1\n"
#define LRD_ENV_MAGIC_LEN 12
#define LRD_ENV_VERSION 1
#define LRD_ENV_HEADER_LEN (LRD_ENV_MAGIC_LEN + 1 + 1 + 4)  /* magic + ver + flags + u32be len */

/* Maximum payload the envelope will accept (2^32-1 is theoretical; practical cap). */
#define LRD_ENV_MAX_PAYLOAD (64u * 1024u * 1024u)

typedef struct lrd_env {
  uint8_t  version;
  uint8_t  flags;
  const unsigned char *payload;  /* not owned */
  size_t   payload_len;
  unsigned char *serialized;     /* owned, full envelope bytes */
  size_t   serialized_len;
  unsigned char sha256[32];      /* SHA-256 of serialized */
} lrd_env_t;

/* Build envelope. Returns 0 on success, -1 on error (oversized, null, etc.).
 * On success, e->serialized is malloc'd and e->sha256 is filled. */
int lrd_env_build(lrd_env_t *e, uint8_t flags,
                  const unsigned char *payload, size_t payload_len);

/* Parse and validate. Returns 0 on success (fills e, e->serialized is a copy),
 * -1 on truncated, oversized, bad magic, bad version, or non-canonical length. */
int lrd_env_parse(const unsigned char *buf, size_t n, lrd_env_t *e);

/* Free owned memory. */
void lrd_env_free(lrd_env_t *e);

/* True if the buffer looks like a legacy LRD-REC-v1 (starts with its magic). */
int lrd_env_is_legacy_rec(const unsigned char *buf, size_t n);

#endif
