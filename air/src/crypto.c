/* SPDX-License-Identifier: AGPL-3.0-only
 * Additional terms: SnapKitty Opaque License (SNAPKITTY_OPAQUE_LICENSE.md, repository root).
 * Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 */
#include "air/crypto.h"
#include <openssl/evp.h>
#include <stdlib.h>
#include <string.h>

struct sha256_ctx { EVP_MD_CTX *md; };

void sha256(const void *data, size_t len, uint8_t out[32]) {
  unsigned int ol = 32;
  if (!EVP_Digest(data, len, out, &ol, EVP_sha256(), NULL) || ol != 32) abort();
}
sha256_ctx *sha256_new(void) {
  sha256_ctx *c = malloc(sizeof *c);
  if (!c) abort();
  c->md = EVP_MD_CTX_new();
  if (!c->md || !EVP_DigestInit_ex(c->md, EVP_sha256(), NULL)) abort();
  return c;
}
void sha256_update(sha256_ctx *c, const void *data, size_t len) {
  if (len && !EVP_DigestUpdate(c->md, data, len)) abort();
}
void sha256_final_free(sha256_ctx *c, uint8_t out[32]) {
  unsigned int ol = 32;
  if (!EVP_DigestFinal_ex(c->md, out, &ol) || ol != 32) abort();
  EVP_MD_CTX_free(c->md);
  free(c);
}
void hex_encode(const uint8_t *in, size_t n, char *out) {
  static const char hx[] = "0123456789abcdef";
  for (size_t i = 0; i < n; i++) { out[2 * i] = hx[in[i] >> 4]; out[2 * i + 1] = hx[in[i] & 15]; }
  out[2 * n] = 0;
}
static int hv(char c) {
  if (c >= '0' && c <= '9') return c - '0';
  if (c >= 'a' && c <= 'f') return c - 'a' + 10;
  return -1;
}
int hex_decode(const char *in, uint8_t *out, size_t n) {
  if (strlen(in) != 2 * n) return -1;
  for (size_t i = 0; i < n; i++) {
    int a = hv(in[2 * i]), b = hv(in[2 * i + 1]);
    if (a < 0 || b < 0) return -1;
    out[i] = (uint8_t)(a << 4 | b);
  }
  return 0;
}
void put_u64le(uint8_t *p, uint64_t v) { for (int i = 0; i < 8; i++) p[i] = (uint8_t)(v >> (8 * i)); }
uint64_t get_u64le(const uint8_t *p) {
  uint64_t v = 0;
  for (int i = 7; i >= 0; i--) v = v << 8 | p[i];
  return v;
}

void merkle_leaf_hash(const void *leaf, size_t len, digest *out) {
  sha256_ctx *c = sha256_new();
  uint8_t tag = 0;
  sha256_update(c, &tag, 1);
  sha256_update(c, leaf, len);
  sha256_final_free(c, out->b);
}
static void node_hash(const digest *l, const digest *r, digest *out) {
  uint8_t buf[65];
  buf[0] = 1;
  memcpy(buf + 1, l->b, 32);
  memcpy(buf + 33, r->b, 32);
  sha256(buf, sizeof buf, out->b);
}
int merkle_build(merkle_tree *t, const digest *leaf_hashes, size_t nleaves) {
  if (!nleaves || (nleaves & (nleaves - 1))) return -1;
  t->nleaves = nleaves;
  t->depth = 0;
  while (((size_t)1 << t->depth) < nleaves) t->depth++;
  t->nodes = calloc(2 * nleaves, sizeof *t->nodes);
  if (!t->nodes) return -1;
  memcpy(t->nodes + nleaves, leaf_hashes, nleaves * sizeof *leaf_hashes);
  for (size_t i = nleaves; i-- > 1;) node_hash(&t->nodes[2 * i], &t->nodes[2 * i + 1], &t->nodes[i]);
  return 0;
}
void merkle_free(merkle_tree *t) { free(t->nodes); t->nodes = NULL; }
digest merkle_root(const merkle_tree *t) { return t->nodes[1]; }
void merkle_path(const merkle_tree *t, size_t idx, digest *path) {
  size_t i = t->nleaves + idx;
  for (unsigned d = 0; d < t->depth; d++, i >>= 1) path[d] = t->nodes[i ^ 1];
}
int merkle_verify(const digest *root, const digest *leaf_hash, size_t idx, unsigned depth,
                  const digest *path) {
  if (depth < 64 && (idx >> depth)) return 0;
  digest cur = *leaf_hash;
  for (unsigned d = 0; d < depth; d++, idx >>= 1) {
    digest nx;
    if (idx & 1) node_hash(&path[d], &cur, &nx);
    else node_hash(&cur, &path[d], &nx);
    cur = nx;
  }
  return memcmp(cur.b, root->b, 32) == 0;
}

void ts_init(transcript *t) {
  static const char tag[] = "LRD-AIR-FS-v1"; /* hashed including its NUL */
  sha256(tag, sizeof tag, t->state);
}
void ts_absorb(transcript *t, const void *m, size_t len) {
  sha256_ctx *c = sha256_new();
  uint8_t tag = 'A', l8[8];
  put_u64le(l8, (uint64_t)len);
  sha256_update(c, &tag, 1);
  sha256_update(c, t->state, 32);
  sha256_update(c, l8, 8);
  sha256_update(c, m, len);
  sha256_final_free(c, t->state);
}
void ts_squeeze(transcript *t, uint8_t out[32]) {
  uint8_t buf[33];
  buf[0] = 'S';
  memcpy(buf + 1, t->state, 32);
  sha256(buf, sizeof buf, t->state);
  memcpy(out, t->state, 32);
}
uint64_t ts_draw_u64(transcript *t) {
  uint8_t o[32];
  ts_squeeze(t, o);
  return get_u64le(o);
}
fp ts_draw_fp(transcript *t) {
  for (;;) {
    uint64_t v = ts_draw_u64(t);
    if (v < FP_P) return v;
  }
}
fp2 ts_draw_fp2(transcript *t) {
  fp a = ts_draw_fp(t);
  fp b = ts_draw_fp(t);
  return fp2_make(a, b);
}
static unsigned leading_zero_bits(const uint8_t h[32]) {
  unsigned n = 0;
  for (int i = 0; i < 32; i++) {
    if (h[i] == 0) { n += 8; continue; }
    for (int b = 7; b >= 0 && !(h[i] >> b & 1); b--) n++;
    break;
  }
  return n;
}
int ts_grind_ok(const transcript *t, uint64_t nonce, unsigned bits) {
  uint8_t buf[41], h[32];
  buf[0] = 'G';
  memcpy(buf + 1, t->state, 32);
  put_u64le(buf + 33, nonce);
  sha256(buf, sizeof buf, h);
  return leading_zero_bits(h) >= bits;
}
uint64_t ts_grind(const transcript *t, unsigned bits) {
  for (uint64_t n = 0;; n++)
    if (ts_grind_ok(t, n, bits)) return n;
}
