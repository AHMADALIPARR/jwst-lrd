/* SPDX-License-Identifier: AGPL-3.0-only
 * Also licensed under the SnapKitty Opaque License; see LICENSE and
 * SNAPKITTY_OPAQUE_LICENSE.md at the repository root.
 * Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 *
 * SHA-256 per FIPS 180-4. Tested against the FIPS "abc", empty-string and
 * 448-bit vectors and against sha256sum in tests/llvm/run.sh.
 */
#include "lrd_sha256.h"
#include <string.h>

static const uint32_t K[64] = {
  0x428a2f98u,0x71374491u,0xb5c0fbcfu,0xe9b5dba5u,0x3956c25bu,0x59f111f1u,0x923f82a4u,0xab1c5ed5u,
  0xd807aa98u,0x12835b01u,0x243185beu,0x550c7dc3u,0x72be5d74u,0x80deb1feu,0x9bdc06a7u,0xc19bf174u,
  0xe49b69c1u,0xefbe4786u,0x0fc19dc6u,0x240ca1ccu,0x2de92c6fu,0x4a7484aau,0x5cb0a9dcu,0x76f988dau,
  0x983e5152u,0xa831c66du,0xb00327c8u,0xbf597fc7u,0xc6e00bf3u,0xd5a79147u,0x06ca6351u,0x14292967u,
  0x27b70a85u,0x2e1b2138u,0x4d2c6dfcu,0x53380d13u,0x650a7354u,0x766a0abbu,0x81c2c92eu,0x92722c85u,
  0xa2bfe8a1u,0xa81a664bu,0xc24b8b70u,0xc76c51a3u,0xd192e819u,0xd6990624u,0xf40e3585u,0x106aa070u,
  0x19a4c116u,0x1e376c08u,0x2748774cu,0x34b0bcb5u,0x391c0cb3u,0x4ed8aa4au,0x5b9cca4fu,0x682e6ff3u,
  0x748f82eeu,0x78a5636fu,0x84c87814u,0x8cc70208u,0x90befffau,0xa4506cebu,0xbef9a3f7u,0xc67178f2u};

#define ROR(x, n) (((x) >> (n)) | ((x) << (32 - (n))))

static void block(lrd_sha256_ctx *c, const unsigned char *p) {
  uint32_t w[64], a, b, d, e, f, g, h, cc, t1, t2;
  int i;
  for (i = 0; i < 16; i++)
    w[i] = ((uint32_t)p[4*i] << 24) | ((uint32_t)p[4*i+1] << 16) | ((uint32_t)p[4*i+2] << 8) | p[4*i+3];
  for (i = 16; i < 64; i++) {
    uint32_t s0 = ROR(w[i-15], 7) ^ ROR(w[i-15], 18) ^ (w[i-15] >> 3);
    uint32_t s1 = ROR(w[i-2], 17) ^ ROR(w[i-2], 19) ^ (w[i-2] >> 10);
    w[i] = w[i-16] + s0 + w[i-7] + s1;
  }
  a = c->h[0]; b = c->h[1]; cc = c->h[2]; d = c->h[3];
  e = c->h[4]; f = c->h[5]; g = c->h[6]; h = c->h[7];
  for (i = 0; i < 64; i++) {
    t1 = h + (ROR(e, 6) ^ ROR(e, 11) ^ ROR(e, 25)) + ((e & f) ^ (~e & g)) + K[i] + w[i];
    t2 = (ROR(a, 2) ^ ROR(a, 13) ^ ROR(a, 22)) + ((a & b) ^ (a & cc) ^ (b & cc));
    h = g; g = f; f = e; e = d + t1; d = cc; cc = b; b = a; a = t1 + t2;
  }
  c->h[0] += a; c->h[1] += b; c->h[2] += cc; c->h[3] += d;
  c->h[4] += e; c->h[5] += f; c->h[6] += g; c->h[7] += h;
}

void lrd_sha256_init(lrd_sha256_ctx *c) {
  static const uint32_t H0[8] = {0x6a09e667u,0xbb67ae85u,0x3c6ef372u,0xa54ff53au,
                                 0x510e527fu,0x9b05688cu,0x1f83d9abu,0x5be0cd19u};
  memcpy(c->h, H0, sizeof H0);
  c->nbytes = 0;
  c->blen = 0;
}

void lrd_sha256_update(lrd_sha256_ctx *c, const void *data, size_t n) {
  const unsigned char *p = data;
  c->nbytes += n;
  while (n) {
    size_t k = 64 - c->blen;
    if (k > n) k = n;
    memcpy(c->buf + c->blen, p, k);
    c->blen += k; p += k; n -= k;
    if (c->blen == 64) { block(c, c->buf); c->blen = 0; }
  }
}

void lrd_sha256_final(lrd_sha256_ctx *c, unsigned char out[32]) {
  uint64_t bits = c->nbytes * 8;
  unsigned char pad = 0x80, z = 0, len[8];
  int i;
  lrd_sha256_update(c, &pad, 1);
  while (c->blen != 56) lrd_sha256_update(c, &z, 1);
  for (i = 0; i < 8; i++) len[i] = (unsigned char)(bits >> (56 - 8 * i));
  lrd_sha256_update(c, len, 8);
  for (i = 0; i < 8; i++) {
    out[4*i] = (unsigned char)(c->h[i] >> 24); out[4*i+1] = (unsigned char)(c->h[i] >> 16);
    out[4*i+2] = (unsigned char)(c->h[i] >> 8); out[4*i+3] = (unsigned char)c->h[i];
  }
}

void lrd_hex32(const unsigned char d[32], char hex[65]) {
  static const char *x = "0123456789abcdef";
  int i;
  for (i = 0; i < 32; i++) { hex[2*i] = x[d[i] >> 4]; hex[2*i+1] = x[d[i] & 15]; }
  hex[64] = '\0';
}

void lrd_sha256_hex(const void *data, size_t n, char hex[65]) {
  lrd_sha256_ctx c;
  unsigned char d[32];
  lrd_sha256_init(&c);
  lrd_sha256_update(&c, data, n);
  lrd_sha256_final(&c, d);
  lrd_hex32(d, hex);
}
