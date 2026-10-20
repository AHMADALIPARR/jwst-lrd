/* SPDX-License-Identifier: AGPL-3.0-only
 * Additional terms: SnapKitty Opaque License (SNAPKITTY_OPAQUE_LICENSE.md, repository root).
 * Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 */
#include "air/rec.h"
#include "air/crypto.h"
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void rec_init(lrd_rec *r) { r->n = 0; }
int rec_set(lrd_rec *r, const char *key, const char *val) {
  size_t kl = strlen(key), vl = strlen(val);
  if (!kl || kl > REC_MAX_KEY || vl > REC_MAX_VAL || r->n >= REC_MAX_FIELDS) return -1;
  if (strchr(val, '\n') || strchr(key, '\n')) return -1;
  for (size_t i = 0; i < r->n; i++) if (!strcmp(r->key[i], key)) return -1;
  /* insert keeping bytewise (unsigned) order: strcmp compares as unsigned char */
  size_t pos = r->n;
  while (pos > 0 && strcmp(r->key[pos - 1], key) > 0) {
    memcpy(r->key[pos], r->key[pos - 1], sizeof r->key[0]);
    memcpy(r->val[pos], r->val[pos - 1], sizeof r->val[0]);
    pos--;
  }
  memcpy(r->key[pos], key, kl + 1);
  memcpy(r->val[pos], val, vl + 1);
  r->n++;
  return 0;
}
int rec_set_u64(lrd_rec *r, const char *key, uint64_t v) {
  char b[32];
  snprintf(b, sizeof b, "%" PRIu64, v);
  return rec_set(r, key, b);
}
int rec_set_i64(lrd_rec *r, const char *key, int64_t v) {
  char b[32];
  snprintf(b, sizeof b, "%" PRId64, v);
  return rec_set(r, key, b);
}
const char *rec_get(const lrd_rec *r, const char *key) {
  for (size_t i = 0; i < r->n; i++) if (!strcmp(r->key[i], key)) return r->val[i];
  return NULL;
}
unsigned char *rec_serialize(const lrd_rec *r, size_t *len) {
  size_t cap = 16;
  for (size_t i = 0; i < r->n; i++) cap += strlen(r->key[i]) + strlen(r->val[i]) + 48;
  unsigned char *b = malloc(cap);
  if (!b) return NULL;
  size_t o = (size_t)snprintf((char *)b, cap, "LRD-REC-v1\n");
  for (size_t i = 0; i < r->n; i++) {
    int w = snprintf((char *)b + o, cap - o, "%zu:%s%zu:%s\n", strlen(r->key[i]), r->key[i],
                     strlen(r->val[i]), r->val[i]);
    if (w < 0 || (size_t)w >= cap - o) { free(b); return NULL; }
    o += (size_t)w;
  }
  *len = o;
  return b;
}
static int parse_len(const unsigned char *b, size_t len, size_t *o, size_t *out) {
  size_t v = 0, start = *o;
  while (*o < len && b[*o] >= '0' && b[*o] <= '9') {
    if (v > 100000) return -1;
    v = v * 10 + (size_t)(b[*o] - '0');
    (*o)++;
  }
  if (*o == start || *o >= len || b[*o] != ':') return -1;
  if (*o - start > 1 && b[start] == '0') return -1; /* no leading zeros */
  (*o)++;
  *out = v;
  return 0;
}
int rec_parse(lrd_rec *r, const unsigned char *b, size_t len) {
  rec_init(r);
  if (len < 11 || memcmp(b, "LRD-REC-v1\n", 11)) return -1;
  size_t o = 11;
  while (o < len) {
    size_t kl, vl;
    char k[REC_MAX_KEY + 1], v[REC_MAX_VAL + 1];
    if (parse_len(b, len, &o, &kl) || kl == 0 || kl > REC_MAX_KEY || len - o < kl) return -1;
    memcpy(k, b + o, kl); k[kl] = 0; o += kl;
    if (memchr(k, 0, kl)) return -1;
    if (parse_len(b, len, &o, &vl) || vl > REC_MAX_VAL || len - o < vl + 1) return -1;
    memcpy(v, b + o, vl); v[vl] = 0; o += vl;
    if (memchr(v, 0, vl) || memchr(v, '\n', vl)) return -1;
    if (b[o++] != '\n') return -1;
    if (r->n && strcmp(r->key[r->n - 1], k) >= 0) return -1; /* sorted, unique */
    if (rec_set(r, k, v)) return -1;
  }
  return 0;
}
int rec_commit(const lrd_rec *r, char out[65]) {
  size_t len;
  unsigned char *s = rec_serialize(r, &len);
  if (!s) return -1;
  static const char dom[] = "LRD-COMMIT-v1"; /* sizeof includes the NUL: 14 bytes */
  sha256_ctx *c = sha256_new();
  sha256_update(c, dom, sizeof dom);
  sha256_update(c, s, len);
  uint8_t d[32];
  sha256_final_free(c, d);
  free(s);
  hex_encode(d, 32, out);
  return 0;
}
