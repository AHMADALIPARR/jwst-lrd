/* Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 * Dual-licensed: AGPL-3.0-or-later plus SnapKitty Opaque License.
 * SPDX-License-Identifier: AGPL-3.0-or-later AND LicenseRef-SnapKitty-Opaque
 *
 * TASK 010 -- capability addressing: definitions shared by the verifier (authority) and the
 * worker. Contains ONLY public-key operations; signing lives exclusively in cap_verifier.c.
 *
 * Capability (an LRD-REC-v1 record, file *.cap), exactly these fields:
 *   cap_id, kind=capability, new_commit, nonce, payload_sha256, prev_commit, seq, sig
 * sig = lowercase hex Ed25519 signature over
 *   "LRD-CAP-SIG-v1\0" || LRD-REC-v1 serialization of the same record WITHOUT the sig field.
 * new_commit = LRD-COMMIT-v1 commitment of the LRD-STATE-v1 state record
 *   { commit = prev_commit, kind = capability, payload_sha256, seq }.
 */
#ifndef LRD_CAP_H
#define LRD_CAP_H

#include <stddef.h>
#include <stdint.h>
#include <openssl/evp.h>
#include "lrd_rec.h"

#define LRD_CAP_SIG_DOMAIN      "LRD-CAP-SIG-v1"      /* + trailing NUL: 15 bytes */
#define LRD_CAP_SIG_DOMAIN_LEN  15u
#define LRD_CAP_NONCE_HEX       32u                   /* 16 random bytes */
#define LRD_CAP_ID_MAX          64u

int  lrd_slurp(const char *path, unsigned char **buf, size_t *n);
/* Write whole file; O_CREAT|O_TRUNC (or O_EXCL if excl), given mode, fsync. 0 / -1. */
int  lrd_write_file(const char *path, const void *buf, size_t n, unsigned mode, int excl);
/* fsync a directory (so a newly created entry is durable). */
int  lrd_fsync_dir(const char *dir);

int  lrd_cap_valid_id(const char *s);                 /* [A-Za-z0-9._-]{1,64} */
int  lrd_cap_valid_nonce(const char *s);              /* 32 lowercase hex */
int  lrd_parse_u64(const char *s, uint64_t *out);     /* canonical base-10, no leading zeros */

int  lrd_cap_state_commit(const char *prev_commit, const char *payload_sha256, uint64_t seq,
                          char out[LRD_HEX256_BUF]);
/* "LRD-CAP-SIG-v1\0" || serialization(rec). *msg malloc'd. */
int  lrd_cap_signing_bytes(const lrd_rec_t *rec_without_sig, unsigned char **msg, size_t *n);

EVP_PKEY *lrd_load_pubkey(const char *path);
int  lrd_ed25519_verify(EVP_PKEY *pub, const unsigned char *msg, size_t n,
                        const unsigned char *sig, size_t siglen);
/* Parse + fully check a capability file: canonical record, exact field set, formats,
 * new_commit consistency and signature. On success fills *out (caller frees) and returns 0;
 * otherwise returns -1 and sets *why to a reason token (bad_record, bad_fields, bad_kind,
 * bad_format, bad_commit, bad_sig). */
int  lrd_cap_verify_bytes(EVP_PKEY *pub, const unsigned char *b, size_t n, lrd_rec_t *out,
                          const char **why);

#endif
