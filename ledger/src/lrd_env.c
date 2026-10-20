/* Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 * Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
 * SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
 */
#include "lrd_env.h"
#include <stdlib.h>
#include <string.h>
#include <openssl/sha.h>

int lrd_env_is_legacy_rec(const unsigned char *buf, size_t n) {
  return n >= 11 && memcmp(buf, "LRD-REC-v1\n", 11) == 0;
}

int lrd_env_build(lrd_env_t *e, uint8_t flags,
                  const unsigned char *payload, size_t payload_len) {
  if (!e) return -1;
  if (payload_len > LRD_ENV_MAX_PAYLOAD) return -1;
  if (payload_len > 0 && !payload) return -1;
  memset(e, 0, sizeof *e);
  e->version = LRD_ENV_VERSION;
  e->flags = flags;
  e->payload = payload;
  e->payload_len = payload_len;
  size_t total = LRD_ENV_HEADER_LEN + payload_len;
  e->serialized = malloc(total);
  if (!e->serialized) return -1;
  unsigned char *p = e->serialized;
  memcpy(p, LRD_ENV_MAGIC, LRD_ENV_MAGIC_LEN); p += LRD_ENV_MAGIC_LEN;
  *p++ = LRD_ENV_VERSION;
  *p++ = flags;
  uint32_t len32 = (uint32_t)payload_len;
  *p++ = (len32 >> 24) & 0xff;
  *p++ = (len32 >> 16) & 0xff;
  *p++ = (len32 >>  8) & 0xff;
  *p++ =  len32        & 0xff;
  if (payload_len) memcpy(p, payload, payload_len);
  e->serialized_len = total;
  SHA256(e->serialized, total, e->sha256);
  return 0;
}

int lrd_env_parse(const unsigned char *buf, size_t n, lrd_env_t *e) {
  if (!e || !buf) return -1;
  memset(e, 0, sizeof *e);
  if (n < LRD_ENV_HEADER_LEN) return -1;                 /* truncated */
  if (memcmp(buf, LRD_ENV_MAGIC, LRD_ENV_MAGIC_LEN) != 0) return -1;
  uint8_t ver = buf[LRD_ENV_MAGIC_LEN];
  if (ver != LRD_ENV_VERSION) return -1;                 /* bad version */
  uint8_t flags = buf[LRD_ENV_MAGIC_LEN + 1];
  uint32_t plen = ((uint32_t)buf[LRD_ENV_MAGIC_LEN + 2] << 24)
                | ((uint32_t)buf[LRD_ENV_MAGIC_LEN + 3] << 16)
                | ((uint32_t)buf[LRD_ENV_MAGIC_LEN + 4] <<  8)
                |  (uint32_t)buf[LRD_ENV_MAGIC_LEN + 5];
  if (plen > LRD_ENV_MAX_PAYLOAD) return -1;             /* oversized */
  size_t total = LRD_ENV_HEADER_LEN + (size_t)plen;
  if (n < total) return -1;                              /* truncated */
  if (n != total) return -1;                             /* trailing garbage = noncanonical */
  e->version = ver;
  e->flags = flags;
  e->payload_len = plen;
  e->serialized = malloc(total);
  if (!e->serialized) return -1;
  memcpy(e->serialized, buf, total);
  e->serialized_len = total;
  e->payload = e->serialized + LRD_ENV_HEADER_LEN;
  SHA256(e->serialized, total, e->sha256);
  return 0;
}

void lrd_env_free(lrd_env_t *e) {
  if (!e) return;
  free(e->serialized);
  e->serialized = NULL;
  e->payload = NULL;
}
