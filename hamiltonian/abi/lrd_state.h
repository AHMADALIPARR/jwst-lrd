/* SPDX-License-Identifier: AGPL-3.0-only
 * Also subject to SNAPKITTY_OPAQUE_LICENSE.md (dual license, see repository root).
 *
 * ===================================================================
 *  PROVISIONAL COPY -- TODO(t004-ledger): replace with ledger/abi/lrd_state.h
 * ===================================================================
 * The canonical LRD-STATE-v1 C header is owned by the ledger track and lives
 * at ledger/abi/lrd_state.h. When this was written (2026-10-19) it did not
 * exist on main, on t004-ledger (branch absent) or in any worktree, so this
 * file is written directly from research/CONTRACTS.md (v1). It is NOT a
 * fork: hamiltonian/Makefile picks ../ledger/abi/lrd_state.h automatically
 * as soon as that file exists, and this copy should then be deleted.
 *
 * Only constants and a plain-data struct are defined here; no functions.
 */
#ifndef LRD_STATE_H
#define LRD_STATE_H

#define LRD_STATE_H_PROVISIONAL 1

#include <stdint.h>

/* LRD-REC-v1 */
#define LRD_REC_MAGIC          "LRD-REC-v1\n"
#define LRD_REC_MAGIC_LEN      11u
/* Commitment = SHA-256("LRD-COMMIT-v1\0" || serialization) */
#define LRD_COMMIT_DOMAIN      "LRD-COMMIT-v1"
#define LRD_COMMIT_DOMAIN_LEN  14u   /* includes the trailing NUL byte */
#define LRD_HEX_LEN            64u
#define LRD_GENESIS_COMMIT \
    "0000000000000000000000000000000000000000000000000000000000000000"

/* LRD-STATE-v1 state record fields */
#define LRD_F_SEQ              "seq"
#define LRD_F_COMMIT           "commit"
#define LRD_F_KIND             "kind"
#define LRD_F_PAYLOAD_SHA256   "payload_sha256"
/* proposal fields */
#define LRD_F_PREV_COMMIT      "prev_commit"
/* decision fields */
#define LRD_F_DECISION         "decision"
#define LRD_F_REASON           "reason"
#define LRD_F_NEW_COMMIT       "new_commit"

/* kinds */
#define LRD_KIND_OBSERVATION       "observation"
#define LRD_KIND_LEDGER_APPEND     "ledger_append"
#define LRD_KIND_HAMILTONIAN_STEP  "hamiltonian_step"
#define LRD_KIND_CAPABILITY        "capability"
#define LRD_KIND_AIR_PROOF         "air_proof"

/* decisions */
#define LRD_DECISION_ACCEPT    "ACCEPT"
#define LRD_DECISION_REJECT    "REJECT"

/* reasons named in CONTRACTS.md v1 */
#define LRD_REASON_OK                     "ok"
#define LRD_REASON_STALE_SEQ              "stale_seq"
#define LRD_REASON_BAD_PREV               "bad_prev"
#define LRD_REASON_ENERGY_NOT_DECREASING  "energy_not_decreasing"
#define LRD_REASON_INFEASIBLE             "infeasible"
#define LRD_REASON_BAD_PROOF              "bad_proof"

/* LRD-STATE-v1 state record as plain data (hex strings NUL-terminated). */
typedef struct lrd_state_v1 {
    uint64_t seq;
    char     commit[LRD_HEX_LEN + 1];         /* commitment of previous state */
    char     kind[32];
    char     payload_sha256[LRD_HEX_LEN + 1];
} lrd_state_v1;

#endif /* LRD_STATE_H */
