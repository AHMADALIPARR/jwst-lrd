/* Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 * Dual-licensed: AGPL-3.0-or-later plus SnapKitty Opaque License.
 * SPDX-License-Identifier: AGPL-3.0-or-later AND LicenseRef-SnapKitty-Opaque
 *
 * LRD-REC-v1 implementation. See include/lrd_rec.h.
 */
#include "lrd_rec.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <openssl/evp.h>

void lrd_rec_init(lrd_rec_t *r) { memset(r, 0, sizeof *r); }

void lrd_rec_free(lrd_rec_t *r) {
  for (size_t i = 0; i < r->n; i++) { free(r->key[i]); free(r->val[i]); }
  free(r->key); free(r->key_len); free(r->val); free(r->val_len);
  memset(r, 0, sizeof *r);
}

/* UTF-8 well-formedness (RFC 3629: no overlongs, no surrogates, <= U+10FFFF), and no '\n'.
 * NUL is rejected too so that values are safe C strings. */
int lrd_utf8_valid_no_nl(const char *s, size_t n) {
  const unsigned char *p = (const unsigned char *)s;
  size_t i = 0;
  while (i < n) {
    unsigned c = p[i];
    if (c == '\n' || c == 0) return 0;
    if (c < 0x80) { i++; continue; }
    size_t len; unsigned min, cp;
    if ((c & 0xE0) == 0xC0) { len = 2; cp = c & 0x1F; min = 0x80; }
    else if ((c & 0xF0) == 0xE0) { len = 3; cp = c & 0x0F; min = 0x800; }
    else if ((c & 0xF8) == 0xF0) { len = 4; cp = c & 0x07; min = 0x10000; }
    else return 0;
    if (i + len > n) return 0;
    for (size_t j = 1; j < len; j++) {
      if ((p[i + j] & 0xC0) != 0x80) return 0;
      cp = (cp << 6) | (p[i + j] & 0x3F);
    }
    if (cp < min || cp > 0x10FFFF || (cp >= 0xD800 && cp <= 0xDFFF)) return 0;
    i += len;
  }
  return 1;
}

static int keycmp(const char *a, size_t al, const char *b, size_t bl) {
  size_t m = al < bl ? al : bl;
  int c = memcmp(a, b, m);
  if (c) return c;
  return (al > bl) - (al < bl);
}

int lrd_rec_setn(lrd_rec_t *r, const char *k, size_t kl, const char *v, size_t vl) {
  if (kl == 0) return -1;
  if (!lrd_utf8_valid_no_nl(k, kl) || !lrd_utf8_valid_no_nl(v, vl)) return -1;
  size_t pos = 0;
  while (pos < r->n) {
    int c = keycmp(r->key[pos], r->key_len[pos], k, kl);
    if (c == 0) return -1;
    if (c > 0) break;
    pos++;
  }
  if (r->n == r->cap) {
    size_t nc = r->cap ? 2 * r->cap : 8;
    char **nk = realloc(r->key, nc * sizeof *nk); if (!nk) return -1; r->key = nk;
    char **nv = realloc(r->val, nc * sizeof *nv); if (!nv) return -1; r->val = nv;
    size_t *nkl = realloc(r->key_len, nc * sizeof *nkl); if (!nkl) return -1; r->key_len = nkl;
    size_t *nvl = realloc(r->val_len, nc * sizeof *nvl); if (!nvl) return -1; r->val_len = nvl;
    r->cap = nc;
  }
  char *kc = malloc(kl + 1), *vc = malloc(vl + 1);
  if (!kc || !vc) { free(kc); free(vc); return -1; }
  memcpy(kc, k, kl); kc[kl] = 0;
  if (vl) memcpy(vc, v, vl);
  vc[vl] = 0;
  memmove(r->key + pos + 1, r->key + pos, (r->n - pos) * sizeof *r->key);
  memmove(r->val + pos + 1, r->val + pos, (r->n - pos) * sizeof *r->val);
  memmove(r->key_len + pos + 1, r->key_len + pos, (r->n - pos) * sizeof *r->key_len);
  memmove(r->val_len + pos + 1, r->val_len + pos, (r->n - pos) * sizeof *r->val_len);
  r->key[pos] = kc; r->key_len[pos] = kl; r->val[pos] = vc; r->val_len[pos] = vl;
  r->n++;
  return 0;
}

int lrd_rec_set(lrd_rec_t *r, const char *k, const char *v) {
  return lrd_rec_setn(r, k, strlen(k), v, strlen(v));
}

const char *lrd_rec_get(const lrd_rec_t *r, const char *k) {
  size_t kl = strlen(k);
  for (size_t i = 0; i < r->n; i++)
    if (r->key_len[i] == kl && memcmp(r->key[i], k, kl) == 0) return r->val[i];
  return NULL;
}

int lrd_rec_serialize(const lrd_rec_t *r, unsigned char **out, size_t *len) {
  size_t total = LRD_REC_MAGIC_LEN;
  for (size_t i = 0; i < r->n; i++) total += r->key_len[i] + r->val_len[i] + 2 * 21 + 3;
  unsigned char *b = malloc(total + 1);
  if (!b) return -1;
  size_t o = 0;
  memcpy(b, LRD_REC_MAGIC, LRD_REC_MAGIC_LEN); o = LRD_REC_MAGIC_LEN;
  for (size_t i = 0; i < r->n; i++) {
    o += (size_t)sprintf((char *)b + o, "%zu:", r->key_len[i]);
    memcpy(b + o, r->key[i], r->key_len[i]); o += r->key_len[i];
    o += (size_t)sprintf((char *)b + o, "%zu:", r->val_len[i]);
    memcpy(b + o, r->val[i], r->val_len[i]); o += r->val_len[i];
    b[o++] = '\n';
  }
  *out = b; *len = o;
  return 0;
}

/* Parse a canonical decimal length (no leading zeros, "0" allowed) terminated by ':'. */
static int parse_len(const unsigned char *s, size_t n, size_t *i, size_t *val) {
  size_t j = *i, v = 0, digits = 0;
  while (j < n && s[j] >= '0' && s[j] <= '9') {
    if (digits == 0 && s[j] == '0' && j + 1 < n && s[j + 1] >= '0' && s[j + 1] <= '9') return -1;
    size_t d = (size_t)(s[j] - '0');
    if (v > (SIZE_MAX - d) / 10) return -1;
    v = v * 10 + d; j++; digits++;
  }
  if (digits == 0 || j >= n || s[j] != ':') return -1;
  *i = j + 1; *val = v;
  return 0;
}

int lrd_rec_parse(const unsigned char *s, size_t n, lrd_rec_t *out, const char **why) {
  const char *w = NULL;
  size_t i = LRD_REC_MAGIC_LEN;
  if (n < LRD_REC_MAGIC_LEN || memcmp(s, LRD_REC_MAGIC, LRD_REC_MAGIC_LEN) != 0) { w = "bad_magic"; goto fail; }
  while (i < n) {
    size_t kl, vl;
    if (parse_len(s, n, &i, &kl)) { w = "bad_key_length"; goto fail; }
    if (kl > n - i) { w = "truncated_key"; goto fail; }
    const char *k = (const char *)s + i; i += kl;
    if (parse_len(s, n, &i, &vl)) { w = "bad_value_length"; goto fail; }
    if (vl > n - i) { w = "truncated_value"; goto fail; }
    const char *v = (const char *)s + i; i += vl;
    if (i >= n || s[i] != '\n') { w = "missing_newline"; goto fail; }
    i++;
    if (kl == 0) { w = "empty_key"; goto fail; }
    if (!lrd_utf8_valid_no_nl(k, kl) || !lrd_utf8_valid_no_nl(v, vl)) { w = "bad_utf8_or_newline"; goto fail; }
    if (out->n && keycmp(out->key[out->n - 1], out->key_len[out->n - 1], k, kl) >= 0) {
      w = "keys_not_strictly_ascending"; goto fail;
    }
    if (lrd_rec_setn(out, k, kl, v, vl)) { w = "insert_failed"; goto fail; }
  }
  /* Belt and braces: canonical round trip must be byte-identical. */
  unsigned char *re; size_t rl;
  if (lrd_rec_serialize(out, &re, &rl)) { w = "oom"; goto fail; }
  int same = (rl == n && memcmp(re, s, n) == 0);
  free(re);
  if (!same) { w = "non_canonical"; goto fail; }
  return 0;
fail:
  lrd_rec_free(out);
  if (why) *why = w;
  return -1;
}

void lrd_hex_encode(const unsigned char *b, size_t n, char *out) {
  static const char hx[] = "0123456789abcdef";
  for (size_t i = 0; i < n; i++) { out[2 * i] = hx[b[i] >> 4]; out[2 * i + 1] = hx[b[i] & 15]; }
  out[2 * n] = 0;
}

int lrd_hex_decode(const char *hex, unsigned char *out, size_t n) {
  for (size_t i = 0; i < 2 * n; i++) {
    char c = hex[i]; int v;
    if (c >= '0' && c <= '9') v = c - '0';
    else if (c >= 'a' && c <= 'f') v = c - 'a' + 10;
    else return -1;
    if (i & 1) out[i / 2] = (unsigned char)(out[i / 2] | v); else out[i / 2] = (unsigned char)(v << 4);
  }
  return hex[2 * n] == 0 ? 0 : -1;
}

void lrd_sha256_hex(const void *data, size_t n, char out[LRD_HEX256_BUF]) {
  unsigned char md[32]; unsigned int ml = 0;
  EVP_Digest(data, n, md, &ml, EVP_sha256(), NULL);
  lrd_hex_encode(md, 32, out);
}

int lrd_rec_commit_hex(const lrd_rec_t *r, char out[LRD_HEX256_BUF]) {
  unsigned char *ser; size_t sl;
  if (lrd_rec_serialize(r, &ser, &sl)) return -1;
  unsigned char *buf = malloc(LRD_COMMIT_DOMAIN_LEN + sl);
  if (!buf) { free(ser); return -1; }
  memcpy(buf, LRD_COMMIT_DOMAIN, LRD_COMMIT_DOMAIN_LEN);   /* includes the trailing NUL */
  memcpy(buf + LRD_COMMIT_DOMAIN_LEN, ser, sl);
  lrd_sha256_hex(buf, LRD_COMMIT_DOMAIN_LEN + sl, out);
  free(buf); free(ser);
  return 0;
}
