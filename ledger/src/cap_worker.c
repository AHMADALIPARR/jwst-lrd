/* Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 * Dual-licensed: AGPL-3.0-or-later plus SnapKitty Opaque License.
 * SPDX-License-Identifier: AGPL-3.0-or-later AND LicenseRef-SnapKitty-Opaque
 *
 * lrd-capworker -- TASK 010 untrusted worker. Holds NO signing key and has no code path that
 * signs or reads a private key; it only reads the authority's PUBLIC key. Its local state file
 * WDIR/state (LRD-REC-v1: head_commit, seq) is merely the worker's own view and is NOT trusted
 * by the verifier.
 *
 *   lrd-capworker init       WDIR
 *   lrd-capworker propose    WDIR CAP_ID PAYLOAD_SHA256 OUT_PROPOSAL
 *   lrd-capworker accept     WDIR PUBKEY CAP_FILE
 *   lrd-capworker verify-cap PUBKEY CAP_FILE        (independent witness/signature verifier)
 * Exit: 0 ok, 1 rejected, 2 usage/IO error.
 */
#define _POSIX_C_SOURCE 200809L
#include "lrd_cap.h"

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <openssl/rand.h>

static int write_rec(const char *path, const lrd_rec_t *r) {
  unsigned char *s; size_t n;
  if (lrd_rec_serialize(r, &s, &n)) return -1;
  char tmp[4200]; snprintf(tmp, sizeof tmp, "%s.tmp", path);
  int rc = lrd_write_file(tmp, s, n, 0644, 0);
  free(s);
  if (rc || rename(tmp, path)) return -1;
  return 0;
}

static int read_state(const char *wdir, uint64_t *seq, char commit[LRD_HEX256_BUF]) {
  char p[4200]; snprintf(p, sizeof p, "%s/state", wdir);
  unsigned char *b; size_t n;
  if (lrd_slurp(p, &b, &n)) return -1;
  lrd_rec_t r; lrd_rec_init(&r);
  int rc = lrd_rec_parse(b, n, &r, NULL); free(b);
  if (rc) return -1;
  const char *c = lrd_rec_get(&r, "head_commit"), *s = lrd_rec_get(&r, "seq");
  rc = (!c || !s || !lrd_is_hex256(c) || lrd_parse_u64(s, seq)) ? -1 : 0;
  if (!rc) strcpy(commit, c);
  lrd_rec_free(&r);
  return rc;
}

static int write_state(const char *wdir, uint64_t seq, const char *commit) {
  char p[4200], sq[24]; snprintf(p, sizeof p, "%s/state", wdir);
  snprintf(sq, sizeof sq, "%llu", (unsigned long long)seq);
  lrd_rec_t r; lrd_rec_init(&r);
  lrd_rec_set(&r, "head_commit", commit); lrd_rec_set(&r, "seq", sq);
  int rc = write_rec(p, &r);
  lrd_rec_free(&r);
  return rc;
}

static int cmd_init(const char *wdir) {
  if (mkdir(wdir, 0755) && errno != EEXIST) { perror(wdir); return 2; }
  char p[4200]; snprintf(p, sizeof p, "%s/caps", wdir);
  if (mkdir(p, 0755) && errno != EEXIST) { perror(p); return 2; }
  if (write_state(wdir, 0, LRD_GENESIS_COMMIT)) return 2;
  printf("OK init %s\n", wdir);
  return 0;
}

static int cmd_propose(const char *wdir, const char *cap_id, const char *payload, const char *out) {
  uint64_t seq; char commit[LRD_HEX256_BUF];
  if (read_state(wdir, &seq, commit)) { fprintf(stderr, "lrd-capworker: bad local state\n"); return 2; }
  if (!lrd_cap_valid_id(cap_id) || !lrd_is_hex256(payload) || seq == UINT64_MAX) return 2;
  unsigned char nb[16]; char nonce[33], sq[24];
  if (RAND_bytes(nb, sizeof nb) != 1) return 2;
  lrd_hex_encode(nb, 16, nonce);
  snprintf(sq, sizeof sq, "%llu", (unsigned long long)(seq + 1));
  lrd_rec_t r; lrd_rec_init(&r);
  lrd_rec_set(&r, "cap_id", cap_id); lrd_rec_set(&r, "kind", "capability");
  lrd_rec_set(&r, "nonce", nonce); lrd_rec_set(&r, "payload_sha256", payload);
  lrd_rec_set(&r, "prev_commit", commit); lrd_rec_set(&r, "seq", sq);
  int rc = write_rec(out, &r) ? 2 : 0;
  lrd_rec_free(&r);
  return rc;
}

static int verify_file(const char *pubpath, const char *capf, lrd_rec_t *out) {
  EVP_PKEY *pub = lrd_load_pubkey(pubpath);
  if (!pub) { fprintf(stderr, "lrd-capworker: cannot load public key %s\n", pubpath); return 2; }
  unsigned char *b; size_t n;
  if (lrd_slurp(capf, &b, &n)) { EVP_PKEY_free(pub); return 2; }
  const char *why = NULL;
  int rc = lrd_cap_verify_bytes(pub, b, n, out, &why);
  free(b); EVP_PKEY_free(pub);
  if (rc) { printf("REJECT %s\n", why); return 1; }
  return 0;
}

static int cmd_accept(const char *wdir, const char *pubpath, const char *capf) {
  lrd_rec_t c;
  int rc = verify_file(pubpath, capf, &c);
  if (rc) return rc;
  uint64_t seq, cseq; char commit[LRD_HEX256_BUF];
  if (read_state(wdir, &seq, commit)) { lrd_rec_free(&c); return 2; }
  lrd_parse_u64(lrd_rec_get(&c, "seq"), &cseq);
  if (cseq != seq + 1 || strcmp(lrd_rec_get(&c, "prev_commit"), commit)) {
    printf("REJECT does_not_extend_local_state\n"); lrd_rec_free(&c); return 1;
  }
  char p[4200]; snprintf(p, sizeof p, "%s/caps/%llu.cap", wdir, (unsigned long long)cseq);
  unsigned char *s; size_t n; lrd_rec_serialize(&c, &s, &n);
  rc = lrd_write_file(p, s, n, 0644, 0); free(s);
  if (rc || write_state(wdir, cseq, lrd_rec_get(&c, "new_commit"))) { lrd_rec_free(&c); return 2; }
  printf("OK accepted seq=%llu\n", (unsigned long long)cseq);
  lrd_rec_free(&c);
  return 0;
}

int main(int argc, char **argv) {
  if (argc == 3 && !strcmp(argv[1], "init")) return cmd_init(argv[2]);
  if (argc == 6 && !strcmp(argv[1], "propose")) return cmd_propose(argv[2], argv[3], argv[4], argv[5]);
  if (argc == 5 && !strcmp(argv[1], "accept")) return cmd_accept(argv[2], argv[3], argv[4]);
  if (argc == 4 && !strcmp(argv[1], "verify-cap")) {
    lrd_rec_t c; int rc = verify_file(argv[2], argv[3], &c);
    if (!rc) { printf("OK seq=%s new_commit=%s\n", lrd_rec_get(&c, "seq"), lrd_rec_get(&c, "new_commit")); lrd_rec_free(&c); }
    return rc;
  }
  fprintf(stderr, "usage: lrd-capworker init|propose|accept|verify-cap ...\n");
  return 2;
}
