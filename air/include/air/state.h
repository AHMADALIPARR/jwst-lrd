/* SPDX-License-Identifier: AGPL-3.0-only
 * Additional terms: SnapKitty Opaque License (SNAPKITTY_OPAQUE_LICENSE.md, repository root).
 * Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 *
 * LRD-STATE-v1 C ABI types come from "lrd_state.h", resolved via -I../ledger/abi to the
 * canonical ledger/abi/lrd_state.h (the former air/abi_mirror copy was removed).
 *
 * air_proof proposal (LRD-REC-v1): common fields kind=air_proof, prev_commit, seq,
 * payload_sha256 = SHA-256(serialized proof bytes); kind-specific fields
 *   air_name        = LRD-AIR-SUMSQ-v1
 *   air_output      = claimed integer output (decimal)
 *   air_pub_commit  = LRD-COMMIT-v1 commitment of the public-input record
 * Decision checks, in order (first failure is the reason):
 *   kind != air_proof -> bad_kind; seq != cur.seq+1 -> stale_seq; prev_commit != cur.commit
 *   -> bad_prev; payload_sha256 mismatch -> bad_payload; air_pub_commit mismatch, or the public
 *   record's ledger_prev_commit/ledger_seq/output differ from the proposal -> bad_public_input;
 *   deserialization or STARK verification failure -> bad_proof.
 * ACCEPT: new state {seq, commit=prev_commit, kind=air_proof, payload_sha256};
 *   new_commit = LRD-COMMIT-v1 of that state record (ASSUMPTION pending the ledger track's
 *   definition). REJECT never constructs a state.
 */
#ifndef AIR_STATE_H
#define AIR_STATE_H
#include <stddef.h>
#include <stdint.h>
#include "lrd_state.h"
#include "air/rec.h"

#define AIR_REASON_BAD_KIND "bad_kind"
#define AIR_REASON_BAD_PAYLOAD "bad_payload"
#define AIR_REASON_BAD_PUBLIC_INPUT "bad_public_input"

typedef struct {
  lrd_proposal_t prop;
  lrd_field_t extra[3];
  char output[24], pub_commit[65];
} air_proposal_buf;

int air_state_to_rec(const lrd_state_t *s, lrd_rec *r);
int air_proposal_to_rec(const lrd_proposal_t *p, lrd_rec *r);
int air_proposal_from_rec(const lrd_rec *r, air_proposal_buf *pb);
int air_decision_to_rec(const lrd_decision_t *d, lrd_rec *r);
int air_make_proposal(const lrd_state_t *cur, const lrd_rec *pub, const uint8_t *proof, size_t plen,
                      air_proposal_buf *pb);
lrd_decision_code_t air_transition(const lrd_state_t *cur, const lrd_proposal_t *prop,
                                   const lrd_rec *pub, const int64_t *q, size_t n,
                                   const uint8_t *proof, size_t plen, lrd_decision_t *out,
                                   lrd_state_t *next, const char **detail);
#endif
