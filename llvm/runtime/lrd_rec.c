/* SPDX-License-Identifier: AGPL-3.0-only
 * Also licensed under the SnapKitty Opaque License; see LICENSE and
 * SNAPKITTY_OPAQUE_LICENSE.md at the repository root.
 * Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 *
 * LRD-REC-v1 implementation. Serialization:
 *   "LRD-REC-v1\n" then per field (keys bytewise ascending, no duplicates)
 *   "<len(key)>:<key><len(value)>:<value>\n" with decimal byte counts.
 */
#define _POSIX_C_SOURCE 200809L
#include "lrd_rec.h"
#include "lrd_sha256.h"
#include "../../ledger/abi/lrd_state.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

lrd_rec *lrd_rec_new(void) { return calloc(1, sizeof(lrd_rec)); }

void lrd_rec_free(lrd_rec *r) {
  size_t i;
  if (!r) return;
  for (i = 0; i < r->n; i++) { free(r->f[i].key); free(r->f[i].value); }
  free(r);
}

/* bytewise comparison (memcmp on unsigned bytes; a proper prefix sorts first) */
static int keycmp(const char *a, const char *b) {
  size_t la = strlen(a), lb = strlen(b), m = la < lb ? la : lb;
  int c = memcmp(a, b, m);
  if (c) return c;
  return la < lb ? -1 : la > lb;
}

int lrd_rec_set(lrd_rec *r, const char *key, const char *value) {
  size_t i, pos;
  if (!*key || strchr(key, '\n') || strchr(value, '\n')) return 1;
  if (r->n >= LRD_REC_MAX_FIELDS) return 1;
  for (pos = 0; pos < r->n; pos++) {
    int c = keycmp(key, r->f[pos].key);
    if (c == 0) return 1;
    if (c < 0) break;
  }
  for (i = r->n; i > pos; i--) r->f[i] = r->f[i - 1];
  r->f[pos].key = strdup(key);
  r->f[pos].value = strdup(value);
  r->n++;
  return 0;
}

const char *lrd_rec_get(const lrd_rec *r, const char *key) {
  size_t i;
  for (i = 0; i < r->n; i++) if (!strcmp(r->f[i].key, key)) return r->f[i].value;
  return NULL;
}

char *lrd_rec_serialize(const lrd_rec *r, size_t *len) {
  size_t cap = LRD_REC_MAGIC_LEN + 1, i, off;
  char *out;
  for (i = 0; i < r->n; i++) cap += strlen(r->f[i].key) + strlen(r->f[i].value) + 48;
  out = malloc(cap);
  memcpy(out, LRD_REC_MAGIC, LRD_REC_MAGIC_LEN);
  off = LRD_REC_MAGIC_LEN;
  for (i = 0; i < r->n; i++)
    off += (size_t)snprintf(out + off, cap - off, "%zu:%s%zu:%s\n", strlen(r->f[i].key), r->f[i].key,
                            strlen(r->f[i].value), r->f[i].value);
  *len = off;
  return out;
}

void lrd_rec_commit(const lrd_rec *r, char hex[65]) {
  size_t n;
  char *s = lrd_rec_serialize(r, &n);
  lrd_sha256_ctx c;
  unsigned char d[32];
  lrd_sha256_init(&c);
  lrd_sha256_update(&c, LRD_COMMIT_DOMAIN, LRD_COMMIT_DOMAIN_LEN); /* 14 bytes incl. NUL */
  lrd_sha256_update(&c, s, n);
  lrd_sha256_final(&c, d);
  lrd_hex32(d, hex);
  free(s);
}

static int parse_len(const char *b, size_t len, size_t *off, size_t *out) {
  size_t v = 0, start = *off;
  while (*off < len && b[*off] >= '0' && b[*off] <= '9') {
    if (*off - start >= 9) return 1;
    v = v * 10 + (size_t)(b[*off] - '0');
    (*off)++;
  }
  if (*off == start) return 1;
  if (*off - start > 1 && b[start] == '0') return 1; /* no leading zeros */
  if (*off >= len || b[*off] != ':') return 1;
  (*off)++;
  *out = v;
  return 0;
}

lrd_rec *lrd_rec_parse(const char *b, size_t len, char *err, size_t errlen) {
  size_t off = LRD_REC_MAGIC_LEN;
  lrd_rec *r;
  if (len < LRD_REC_MAGIC_LEN || memcmp(b, LRD_REC_MAGIC, LRD_REC_MAGIC_LEN)) {
    snprintf(err, errlen, "missing LRD-REC-v1 header");
    return NULL;
  }
  r = lrd_rec_new();
  while (off < len) {
    size_t kl, vl;
    char *k, *v;
    if (parse_len(b, len, &off, &kl) || kl == 0 || off + kl > len) { snprintf(err, errlen, "bad key length at byte %zu", off); goto bad; }
    k = strndup(b + off, kl); off += kl;
    if (strlen(k) != kl || strchr(k, '\n')) { free(k); snprintf(err, errlen, "bad key bytes"); goto bad; }
    if (parse_len(b, len, &off, &vl) || off + vl + 1 > len) { free(k); snprintf(err, errlen, "bad value length at byte %zu", off); goto bad; }
    v = strndup(b + off, vl); off += vl;
    if (strlen(v) != vl || strchr(v, '\n') || b[off] != '\n') { free(k); free(v); snprintf(err, errlen, "bad value bytes or missing newline"); goto bad; }
    off++;
    if (r->n > 0 && keycmp(r->f[r->n - 1].key, k) >= 0) { free(k); free(v); snprintf(err, errlen, "keys not strictly bytewise ascending"); goto bad; }
    if (r->n >= LRD_REC_MAX_FIELDS) { free(k); free(v); snprintf(err, errlen, "too many fields"); goto bad; }
    r->f[r->n].key = k; r->f[r->n].value = v; r->n++;
  }
  return r;
bad:
  lrd_rec_free(r);
  return NULL;
}
