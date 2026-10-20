/* SPDX-License-Identifier: AGPL-3.0-only
 * Additional terms: SnapKitty Opaque License (SNAPKITTY_OPAQUE_LICENSE.md, repository root).
 * Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 */
#include "air/state.h"
#include "air/crypto.h"
#include "air/stark.h"
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static void cpy65(char dst[65], const char *src) { snprintf(dst, 65, "%s", src); }

int air_state_to_rec(const lrd_state_t *s, lrd_rec *r) {
  const char *k = lrd_kind_token(s->kind);
  if (!k) return -1;
  rec_init(r);
  int e = rec_set_u64(r, LRD_F_SEQ, s->seq);
  e |= rec_set(r, LRD_F_COMMIT, s->commit);
  e |= rec_set(r, LRD_F_KIND, k);
  e |= rec_set(r, LRD_F_PAYLOAD_SHA256, s->payload_sha256);
  return e ? -1 : 0;
}
int air_proposal_to_rec(const lrd_proposal_t *p, lrd_rec *r) {
  const char *k = lrd_kind_token(p->kind);
  if (!k) return -1;
  rec_init(r);
  int e = rec_set(r, LRD_F_KIND, k);
  e |= rec_set(r, LRD_F_PREV_COMMIT, p->prev_commit);
  e |= rec_set_u64(r, LRD_F_SEQ, p->seq);
  e |= rec_set(r, LRD_F_PAYLOAD_SHA256, p->payload_sha256);
  for (size_t i = 0; i < p->n_extra; i++) {
    char kk[REC_MAX_KEY + 1], vv[REC_MAX_VAL + 1];
    if (p->extra[i].key_len > REC_MAX_KEY || p->extra[i].value_len > REC_MAX_VAL) return -1;
    memcpy(kk, p->extra[i].key, p->extra[i].key_len); kk[p->extra[i].key_len] = 0;
    memcpy(vv, p->extra[i].value, p->extra[i].value_len); vv[p->extra[i].value_len] = 0;
    e |= rec_set(r, kk, vv); /* rec_set rejects collisions with common keys */
  }
  return e ? -1 : 0;
}
static void set_extra(air_proposal_buf *pb) {
  static const char *keys[3] = {"air_name", "air_output", "air_pub_commit"};
  const char *vals[3] = {AIR_NAME, pb->output, pb->pub_commit};
  for (int i = 0; i < 3; i++) {
    pb->extra[i].key = keys[i]; pb->extra[i].key_len = strlen(keys[i]);
    pb->extra[i].value = vals[i]; pb->extra[i].value_len = strlen(vals[i]);
  }
  pb->prop.extra = pb->extra;
  pb->prop.n_extra = 3;
}
int air_proposal_from_rec(const lrd_rec *r, air_proposal_buf *pb) {
  memset(pb, 0, sizeof *pb);
  const char *k = rec_get(r, LRD_F_KIND), *pc = rec_get(r, LRD_F_PREV_COMMIT);
  const char *sq = rec_get(r, LRD_F_SEQ), *ps = rec_get(r, LRD_F_PAYLOAD_SHA256);
  const char *nm = rec_get(r, "air_name"), *ou = rec_get(r, "air_output"), *cm = rec_get(r, "air_pub_commit");
  if (!k || !pc || !sq || !ps || !nm || !ou || !cm || r->n != 7) return -1;
  if (strcmp(nm, AIR_NAME) || strlen(ou) >= sizeof pb->output) return -1;
  pb->prop.kind = lrd_kind_from_token(k, strlen(k));
  if (strlen(pc) != 64 || strlen(ps) != 64 || strlen(cm) != 64) return -1;
  cpy65(pb->prop.prev_commit, pc);
  cpy65(pb->prop.payload_sha256, ps);
  cpy65(pb->pub_commit, cm);
  snprintf(pb->output, sizeof pb->output, "%s", ou);
  char *end;
  if (!*sq || (sq[0] == '0' && sq[1])) return -1;
  pb->prop.seq = strtoull(sq, &end, 10);
  if (*end) return -1;
  set_extra(pb);
  return 0;
}
int air_decision_to_rec(const lrd_decision_t *d, lrd_rec *r) {
  rec_init(r);
  int e = rec_set(r, LRD_F_DECISION, d->decision == LRD_DECISION_ACCEPT ? LRD_DECISION_TOKEN_ACCEPT
                                                                       : LRD_DECISION_TOKEN_REJECT);
  e |= rec_set(r, LRD_F_REASON, d->reason);
  if (d->decision == LRD_DECISION_ACCEPT) e |= rec_set(r, LRD_F_NEW_COMMIT, d->new_commit);
  return e ? -1 : 0;
}
int air_make_proposal(const lrd_state_t *cur, const lrd_rec *pub, const uint8_t *proof, size_t plen,
                      air_proposal_buf *pb) {
  memset(pb, 0, sizeof *pb);
  char cur_commit[65];
  lrd_rec sr;
  if (air_state_to_rec(cur, &sr) || rec_commit(&sr, cur_commit)) return -1;
  const char *ou = rec_get(pub, "output");
  if (!ou || strlen(ou) >= sizeof pb->output) return -1;
  pb->prop.kind = LRD_KIND_AIR_PROOF;
  cpy65(pb->prop.prev_commit, cur_commit);
  if (cur->seq == UINT64_MAX) return -1;
  pb->prop.seq = cur->seq + 1;
  uint8_t d[32];
  sha256(proof, plen, d);
  hex_encode(d, 32, pb->prop.payload_sha256);
  snprintf(pb->output, sizeof pb->output, "%s", ou);
  if (rec_commit(pub, pb->pub_commit)) return -1;
  set_extra(pb);
  return 0;
}

static lrd_decision_code_t reject(lrd_decision_t *out, const char *reason) {
  lrd_decision_reject(out, reason);
  return LRD_DECISION_REJECT;
}

lrd_decision_code_t air_transition(const lrd_state_t *cur, const lrd_proposal_t *prop,
                                   const lrd_rec *pub, const int64_t *q, size_t n,
                                   const uint8_t *proof, size_t plen, lrd_decision_t *out,
                                   lrd_state_t *next, const char **detail) {
  if (detail) *detail = "";
  char cur_commit[65], pc[65], buf[32];
  lrd_rec sr;
  if (prop->kind != LRD_KIND_AIR_PROOF) return reject(out, AIR_REASON_BAD_KIND);
  if (cur->seq == UINT64_MAX || prop->seq != cur->seq + 1) return reject(out, LRD_REASON_STALE_SEQ);
  if (air_state_to_rec(cur, &sr) || rec_commit(&sr, cur_commit)) return reject(out, LRD_REASON_BAD_PREV);
  if (strcmp(prop->prev_commit, cur_commit)) return reject(out, LRD_REASON_BAD_PREV);
  uint8_t d[32];
  char dh[65];
  sha256(proof, plen, d);
  hex_encode(d, 32, dh);
  if (strcmp(prop->payload_sha256, dh)) return reject(out, AIR_REASON_BAD_PAYLOAD);
  const char *want_pc = NULL, *want_out = NULL;
  for (size_t i = 0; i < prop->n_extra; i++) {
    if (prop->extra[i].key_len == 14 && !memcmp(prop->extra[i].key, "air_pub_commit", 14) && prop->extra[i].value_len == 64) {
      memcpy(pc, prop->extra[i].value, 64); pc[64] = 0; want_pc = pc;
    }
    if (prop->extra[i].key_len == 10 && !memcmp(prop->extra[i].key, "air_output", 10) && prop->extra[i].value_len < sizeof buf) {
      memcpy(buf, prop->extra[i].value, prop->extra[i].value_len); buf[prop->extra[i].value_len] = 0; want_out = buf;
    }
  }
  char pubc[65];
  if (!want_pc || !want_out || rec_commit(pub, pubc) || strcmp(pubc, want_pc)) return reject(out, AIR_REASON_BAD_PUBLIC_INPUT);
  const char *lp = rec_get(pub, "ledger_prev_commit"), *ls = rec_get(pub, "ledger_seq"), *po = rec_get(pub, "output");
  char seqs[24];
  snprintf(seqs, sizeof seqs, "%" PRIu64, prop->seq);
  if (!lp || !ls || !po || strcmp(lp, prop->prev_commit) || strcmp(ls, seqs) || strcmp(po, want_out))
    return reject(out, AIR_REASON_BAD_PUBLIC_INPUT);
  air_proof pf;
  const char *why = NULL;
  if (air_proof_deserialize(proof, plen, &pf, &why)) {
    if (detail) *detail = why;
    return reject(out, LRD_REASON_BAD_PROOF);
  }
  int ok = air_verify(pub, q, n, &pf, &why);
  air_proof_free(&pf);
  if (detail) *detail = why;
  if (!ok) return reject(out, LRD_REASON_BAD_PROOF);
  lrd_state_t ns;
  memset(&ns, 0, sizeof ns);
  ns.seq = prop->seq;
  cpy65(ns.commit, prop->prev_commit);
  ns.kind = LRD_KIND_AIR_PROOF;
  cpy65(ns.payload_sha256, prop->payload_sha256);
  char nc[65];
  if (air_state_to_rec(&ns, &sr) || rec_commit(&sr, nc)) return reject(out, LRD_REASON_BAD_PROOF);
  out->decision = LRD_DECISION_ACCEPT;
  snprintf(out->reason, sizeof out->reason, "%s", LRD_REASON_OK);
  cpy65(out->new_commit, nc);
  if (next) *next = ns;
  return LRD_DECISION_ACCEPT;
}
