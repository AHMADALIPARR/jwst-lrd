/* SPDX-License-Identifier: AGPL-3.0-or-later OR LicenseRef-SnapKitty-Opaque
 * Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 * Dual-licensed (intentionally): GNU AGPL-3.0-or-later plus the SnapKitty Opaque License.
 *
 * FFI shim: exposes the static-inline helpers and the struct layout of the ledger track's
 * LRD-STATE-v1 header (ledger/abi/lrd_state.h, included UNMODIFIED) to Rust. This file does
 * not redefine any ABI type; it only re-exports what the header declares.
 */
#include <stddef.h>
#include "lrd_state.h"

const char *lrdcap_kind_token(int k) { return lrd_kind_token((lrd_kind_t)k); }
int lrdcap_kind_from_token(const char *s, size_t n) { return (int)lrd_kind_from_token(s, n); }
int lrdcap_is_hex256(const char *s) { return lrd_is_hex256(s); }
void lrdcap_decision_reject(lrd_decision_t *d, const char *reason) { lrd_decision_reject(d, reason); }
unsigned lrdcap_abi_version(void) { return (unsigned)LRD_STATE_ABI_VERSION; }
const char *lrdcap_rec_magic(void) { return LRD_REC_MAGIC; }
const char *lrdcap_commit_domain(void) { return LRD_COMMIT_DOMAIN; }
size_t lrdcap_commit_domain_len(void) { return LRD_COMMIT_DOMAIN_LEN; }
const char *lrdcap_genesis_commit(void) { return LRD_GENESIS_COMMIT; }
size_t lrdcap_reason_max(void) { return LRD_REASON_MAX; }

/* Layout table: index -> value. Order is mirrored in src/abi.rs. */
size_t lrdcap_layout(int i) {
  switch (i) {
    case 0: return sizeof(lrd_state_t);
    case 1: return offsetof(lrd_state_t, seq);
    case 2: return offsetof(lrd_state_t, commit);
    case 3: return offsetof(lrd_state_t, kind);
    case 4: return offsetof(lrd_state_t, payload_sha256);
    case 5: return sizeof(lrd_decision_t);
    case 6: return offsetof(lrd_decision_t, decision);
    case 7: return offsetof(lrd_decision_t, reason);
    case 8: return offsetof(lrd_decision_t, new_commit);
    case 9: return sizeof(lrd_kind_t);
    case 10: return sizeof(lrd_proposal_t);
    case 11: return offsetof(lrd_proposal_t, prev_commit);
    case 12: return offsetof(lrd_proposal_t, seq);
    case 13: return offsetof(lrd_proposal_t, payload_sha256);
    case 14: return offsetof(lrd_proposal_t, extra);
    case 15: return offsetof(lrd_proposal_t, n_extra);
    case 16: return sizeof(lrd_field_t);
    default: return (size_t)-1;
  }
}
