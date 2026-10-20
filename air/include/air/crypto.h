/* SPDX-License-Identifier: AGPL-3.0-only
 * Additional terms: SnapKitty Opaque License (SNAPKITTY_OPAQUE_LICENSE.md, repository root).
 * Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 *
 * SHA-256 (via OpenSSL libcrypto EVP, a widely reviewed implementation; validated against
 * FIPS 180-4 example vectors in tests/air), hex helpers, SHA-256 Merkle tree, and a SHA-256
 * Fiat-Shamir transcript.
 *
 * Merkle tree: leaf = SHA256(0x00 || leaf_bytes), node = SHA256(0x01 || left || right).
 * Number of leaves is a power of two. Paths list siblings bottom-up.
 *
 * Transcript (LRD-AIR-FS-v1):
 *   state0 = SHA256("LRD-AIR-FS-v1" || 0x00)
 *   absorb(m):  state = SHA256(0x41 'A' || state || u64le(len m) || m)
 *   squeeze():  state = SHA256(0x53 'S' || state); output state (32 bytes)
 *   field elements are drawn as u64le(first 8 bytes of a squeeze); values >= p are rejected
 *   and re-drawn; Fp2 elements are two Fp draws (c0 then c1).
 *   grinding: nonce valid iff SHA256(0x47 'G' || state || u64le(nonce)) has >= g leading zero bits.
 */
#ifndef AIR_CRYPTO_H
#define AIR_CRYPTO_H
#include <stddef.h>
#include <stdint.h>
#include "air/field.h"

typedef struct { uint8_t b[32]; } digest;

void sha256(const void *data, size_t len, uint8_t out[32]);
typedef struct sha256_ctx sha256_ctx;
sha256_ctx *sha256_new(void);
void sha256_update(sha256_ctx *c, const void *data, size_t len);
void sha256_final_free(sha256_ctx *c, uint8_t out[32]);
void hex_encode(const uint8_t *in, size_t n, char *out); /* writes 2n chars + NUL, lowercase */
int hex_decode(const char *in, uint8_t *out, size_t n); /* exactly 2n lowercase hex chars */

void put_u64le(uint8_t *p, uint64_t v);
uint64_t get_u64le(const uint8_t *p);

typedef struct {
  size_t nleaves;   /* power of two */
  unsigned depth;   /* log2(nleaves) */
  digest *nodes;    /* 2*nleaves; nodes[1] = root, leaves at nodes[nleaves + i] */
} merkle_tree;

void merkle_leaf_hash(const void *leaf, size_t len, digest *out);
int merkle_build(merkle_tree *t, const digest *leaf_hashes, size_t nleaves);
void merkle_free(merkle_tree *t);
digest merkle_root(const merkle_tree *t);
void merkle_path(const merkle_tree *t, size_t idx, digest *path /* depth entries */);
int merkle_verify(const digest *root, const digest *leaf_hash, size_t idx, unsigned depth,
                  const digest *path);

typedef struct { uint8_t state[32]; } transcript;
void ts_init(transcript *t);
void ts_absorb(transcript *t, const void *m, size_t len);
void ts_squeeze(transcript *t, uint8_t out[32]);
fp ts_draw_fp(transcript *t);
fp2 ts_draw_fp2(transcript *t);
uint64_t ts_draw_u64(transcript *t);
int ts_grind_ok(const transcript *t, uint64_t nonce, unsigned bits);
uint64_t ts_grind(const transcript *t, unsigned bits);
#endif
