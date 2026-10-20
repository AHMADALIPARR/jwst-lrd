/* Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 * Dual-licensed: AGPL-3.0-or-later plus SnapKitty Opaque License.
 * SPDX-License-Identifier: AGPL-3.0-or-later AND LicenseRef-SnapKitty-Opaque
 *
 * TASK 010 shared, public-key-only helpers. See include/lrd_cap.h.
 */
#define _POSIX_C_SOURCE 200809L
#include "lrd_cap.h"

#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <openssl/pem.h>

int lrd_slurp(const char *path, unsigned char **buf, size_t *n) {
  FILE *f = fopen(path, "rb");
  if (!f) return -1;
  size_t cap = 4096, len = 0;
  unsigned char *b = malloc(cap);
  while (b) {
    size_t r = fread(b + len, 1, cap - len, f);
    len += r;
    if (r == 0) break;
    if (len == cap) {
      unsigned char *t = realloc(b, cap * 2);
      if (!t) { free(b); b = NULL; break; }
      b = t; cap *= 2;
    }
  }
  int err = ferror(f);
  fclose(f);
  if (!b || err) { free(b); return -1; }
  *buf = b; *n = len;
  return 0;
}

int lrd_write_file(const char *path, const void *buf, size_t n, unsigned mode, int excl) {
  int fd = open(path, O_WRONLY | O_CREAT | (excl ? O_EXCL : O_TRUNC), (mode_t)mode);
  if (fd < 0) return -1;
  const unsigned char *p = buf;
  while (n) {
    ssize_t w = write(fd, p, n);
    if (w < 0) { if (errno == EINTR) continue; close(fd); return -1; }
    p += w; n -= (size_t)w;
  }
  if (fsync(fd)) { close(fd); return -1; }
  return close(fd);
}

int lrd_fsync_dir(const char *dir) {
  int fd = open(dir, O_RDONLY);
  if (fd < 0) return -1;
  int rc = fsync(fd);
  close(fd);
  return rc;
}

int lrd_cap_valid_id(const char *s) {
  size_t n = strlen(s);
  if (n == 0 || n > LRD_CAP_ID_MAX) return 0;
  for (size_t i = 0; i < n; i++) {
    char c = s[i];
    if (!((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9') ||
          c == '.' || c == '_' || c == '-')) return 0;
  }
  return 1;
}

int lrd_cap_valid_nonce(const char *s) {
  if (strlen(s) != LRD_CAP_NONCE_HEX) return 0;
  for (size_t i = 0; i < LRD_CAP_NONCE_HEX; i++)
    if (!((s[i] >= '0' && s[i] <= '9') || (s[i] >= 'a' && s[i] <= 'f'))) return 0;
  return 1;
}

int lrd_parse_u64(const char *s, uint64_t *out) {
  size_t n = strlen(s);
  if (n == 0 || n > 20 || (n > 1 && s[0] == '0')) return -1;
  uint64_t v = 0;
  for (size_t i = 0; i < n; i++) {
    if (s[i] < '0' || s[i] > '9') return -1;
    uint64_t d = (uint64_t)(s[i] - '0');
    if (v > (UINT64_MAX - d) / 10) return -1;
    v = v * 10 + d;
  }
  *out = v;
  return 0;
}

int lrd_cap_state_commit(const char *prev_commit, const char *payload_sha256, uint64_t seq,
                         char out[LRD_HEX256_BUF]) {
  char sbuf[24];
  snprintf(sbuf, sizeof sbuf, "%llu", (unsigned long long)seq);
  lrd_rec_t r; lrd_rec_init(&r);
  int rc = 0;
  rc |= lrd_rec_set(&r, LRD_F_COMMIT, prev_commit);
  rc |= lrd_rec_set(&r, LRD_F_KIND, "capability");
  rc |= lrd_rec_set(&r, LRD_F_PAYLOAD_SHA256, payload_sha256);
  rc |= lrd_rec_set(&r, LRD_F_SEQ, sbuf);
  if (!rc) rc = lrd_rec_commit_hex(&r, out);
  lrd_rec_free(&r);
  return rc ? -1 : 0;
}

int lrd_cap_signing_bytes(const lrd_rec_t *rec, unsigned char **msg, size_t *n) {
  unsigned char *ser; size_t sl;
  if (lrd_rec_serialize(rec, &ser, &sl)) return -1;
  unsigned char *m = malloc(LRD_CAP_SIG_DOMAIN_LEN + sl);
  if (!m) { free(ser); return -1; }
  memcpy(m, LRD_CAP_SIG_DOMAIN, LRD_CAP_SIG_DOMAIN_LEN);   /* includes trailing NUL */
  memcpy(m + LRD_CAP_SIG_DOMAIN_LEN, ser, sl);
  free(ser);
  *msg = m; *n = LRD_CAP_SIG_DOMAIN_LEN + sl;
  return 0;
}

EVP_PKEY *lrd_load_pubkey(const char *path) {
  FILE *f = fopen(path, "r");
  if (!f) return NULL;
  EVP_PKEY *k = PEM_read_PUBKEY(f, NULL, NULL, NULL);
  fclose(f);
  if (k && EVP_PKEY_get_id(k) != EVP_PKEY_ED25519) { EVP_PKEY_free(k); return NULL; }
  return k;
}

int lrd_ed25519_verify(EVP_PKEY *pub, const unsigned char *msg, size_t n,
                       const unsigned char *sig, size_t siglen) {
  EVP_MD_CTX *c = EVP_MD_CTX_new();
  if (!c) return 0;
  int ok = EVP_DigestVerifyInit(c, NULL, NULL, NULL, pub) == 1 &&
           EVP_DigestVerify(c, sig, siglen, msg, n) == 1;
  EVP_MD_CTX_free(c);
  return ok;
}

static const char *const CAP_FIELDS[] = {
  "cap_id", "kind", "new_commit", "nonce", "payload_sha256", "prev_commit", "seq", "sig"
};

int lrd_cap_verify_bytes(EVP_PKEY *pub, const unsigned char *b, size_t n, lrd_rec_t *out,
                         const char **why) {
  lrd_rec_t r, u; lrd_rec_init(&r); lrd_rec_init(&u);
  unsigned char *msg = NULL; size_t ml;
  const char *w = NULL;
  if (lrd_rec_parse(b, n, &r, NULL)) { w = "bad_record"; goto fail; }
  if (r.n != 8) { w = "bad_fields"; goto fail; }
  for (size_t i = 0; i < 8; i++)
    if (strcmp(r.key[i], CAP_FIELDS[i]) != 0) { w = "bad_fields"; goto fail; }
  if (strcmp(lrd_rec_get(&r, "kind"), "capability") != 0) { w = "bad_kind"; goto fail; }
  uint64_t seq;
  if (!lrd_cap_valid_id(lrd_rec_get(&r, "cap_id")) || !lrd_cap_valid_nonce(lrd_rec_get(&r, "nonce")) ||
      !lrd_is_hex256(lrd_rec_get(&r, "new_commit")) || !lrd_is_hex256(lrd_rec_get(&r, "prev_commit")) ||
      !lrd_is_hex256(lrd_rec_get(&r, "payload_sha256")) || lrd_parse_u64(lrd_rec_get(&r, "seq"), &seq) ||
      seq == 0 || strlen(lrd_rec_get(&r, "sig")) != 128) { w = "bad_format"; goto fail; }
  unsigned char sig[64];
  if (lrd_hex_decode(lrd_rec_get(&r, "sig"), sig, 64)) { w = "bad_format"; goto fail; }
  for (size_t i = 0; i < 7; i++)
    if (lrd_rec_set(&u, r.key[i], r.val[i])) { w = "bad_record"; goto fail; }
  if (lrd_cap_signing_bytes(&u, &msg, &ml)) { w = "oom"; goto fail; }
  if (!lrd_ed25519_verify(pub, msg, ml, sig, 64)) { w = "bad_sig"; goto fail; }
  /* signature is checked first so a forged cap always reports bad_sig; then self-consistency */
  char nc[LRD_HEX256_BUF];
  if (lrd_cap_state_commit(lrd_rec_get(&r, "prev_commit"), lrd_rec_get(&r, "payload_sha256"), seq, nc) ||
      strcmp(nc, lrd_rec_get(&r, "new_commit")) != 0) { w = "bad_commit"; goto fail; }
  free(msg); lrd_rec_free(&u);
  *out = r;
  return 0;
fail:
  free(msg); lrd_rec_free(&u); lrd_rec_free(&r);
  if (why) *why = w;
  return -1;
}
