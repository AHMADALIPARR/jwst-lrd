/* Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 * Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
 * SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
 *
 * JWST-LRD Sovereign Scientific Runtime -- LRD-STATE-v1 shared state-transition ABI (C17).
 * Specification: research/CONTRACTS.md, sections "LRD-REC-v1" and "LRD-STATE-v1".
 * Owned by the ledger track. Other tracks include this header and must not fork it.
 *
 * This header is declaration-only plus small static inline helpers; it has no link-time
 * dependency. Any producer/consumer of states, proposals or decisions exchanges them on the
 * wire as LRD-REC-v1 records; the structs below are the in-memory C view of those records.
 *
 * Design choices made here (CONTRACTS.md does not fix C types; documented so they are explicit):
 *   - `seq` is a natural number, represented as uint64_t. A transition from seq == UINT64_MAX
 *     cannot satisfy "seq = prev seq + 1" and MUST be rejected (reason "stale_seq").
 *   - Hex digests (commit, prev_commit, new_commit, payload_sha256) are exactly 64 lowercase
 *     hex characters stored NUL-terminated in char[65].
 *   - `kind` is stored both as an enum (for switch statements) and is serialized as its token.
 *   - `reason` is an open token set (CONTRACTS.md: "a token, e.g. ..."): stored as a
 *     NUL-terminated string of at most LRD_REASON_MAX bytes; known tokens are macros below.
 *   - Kind-specific proposal fields are carried as a borrowed array of key/value byte strings.
 */
#ifndef LRD_STATE_H
#define LRD_STATE_H

#include <stddef.h>
#include <stdint.h>
#include <string.h>

#ifdef __cplusplus
extern "C" {
#endif

/* ---------------------------------------------------------------- version constants */
#define LRD_STATE_ABI_NAME          "LRD-STATE-v1"
#define LRD_STATE_ABI_VERSION_MAJOR 1
#define LRD_STATE_ABI_VERSION_MINOR 0
#define LRD_STATE_ABI_VERSION       ((LRD_STATE_ABI_VERSION_MAJOR << 16) | LRD_STATE_ABI_VERSION_MINOR)

/* LRD-REC-v1 serialization header: the bytes "LRD-REC-v1\n" (11 bytes, no NUL). */
#define LRD_REC_MAGIC               "LRD-REC-v1\n"
#define LRD_REC_MAGIC_LEN           11u
/* Commitment domain prefix: the 14 bytes "LRD-COMMIT-v1\0" (the NUL IS part of the hashed input). */
#define LRD_COMMIT_DOMAIN           "LRD-COMMIT-v1"
#define LRD_COMMIT_DOMAIN_LEN       14u

/* ---------------------------------------------------------------- sizes */
#define LRD_HEX256_LEN              64u   /* lowercase hex chars of a SHA-256 digest */
#define LRD_HEX256_BUF              65u   /* + NUL */
#define LRD_KIND_MAX                31u   /* longest kind token is "hamiltonian_step" (16) */
#define LRD_REASON_MAX              63u
#define LRD_GENESIS_COMMIT \
  "0000000000000000000000000000000000000000000000000000000000000000"

/* ---------------------------------------------------------------- field names (LRD-REC-v1 keys) */
#define LRD_F_SEQ            "seq"
#define LRD_F_COMMIT         "commit"
#define LRD_F_KIND           "kind"
#define LRD_F_PAYLOAD_SHA256 "payload_sha256"
#define LRD_F_PREV_COMMIT    "prev_commit"
#define LRD_F_DECISION       "decision"
#define LRD_F_REASON         "reason"
#define LRD_F_NEW_COMMIT     "new_commit"

/* ---------------------------------------------------------------- kinds */
typedef enum lrd_kind {
  LRD_KIND_INVALID          = 0,
  LRD_KIND_OBSERVATION      = 1,  /* "observation" */
  LRD_KIND_LEDGER_APPEND    = 2,  /* "ledger_append" */
  LRD_KIND_HAMILTONIAN_STEP = 3,  /* "hamiltonian_step" */
  LRD_KIND_CAPABILITY       = 4,  /* "capability" */
  LRD_KIND_AIR_PROOF        = 5   /* "air_proof" */
} lrd_kind_t;

/* ---------------------------------------------------------------- decisions */
typedef enum lrd_decision_code {
  LRD_DECISION_REJECT = 0,        /* "REJECT" */
  LRD_DECISION_ACCEPT = 1         /* "ACCEPT" */
} lrd_decision_code_t;

#define LRD_DECISION_TOKEN_ACCEPT "ACCEPT"
#define LRD_DECISION_TOKEN_REJECT "REJECT"

/* Reason tokens listed in CONTRACTS.md. Subsystems may define further tokens
 * (lowercase [a-z0-9_]+, at most LRD_REASON_MAX bytes) and document them. */
#define LRD_REASON_OK                    "ok"
#define LRD_REASON_STALE_SEQ             "stale_seq"
#define LRD_REASON_BAD_PREV              "bad_prev"
#define LRD_REASON_ENERGY_NOT_DECREASING "energy_not_decreasing"
#define LRD_REASON_INFEASIBLE            "infeasible"
#define LRD_REASON_BAD_PROOF             "bad_proof"

/* ---------------------------------------------------------------- records */

/* One LRD-REC-v1 field: borrowed byte strings (not necessarily NUL-terminated). */
typedef struct lrd_field {
  const char *key;
  size_t      key_len;
  const char *value;
  size_t      value_len;
} lrd_field_t;

/* State record. Field order matches CONTRACTS.md: seq, commit, kind, payload_sha256.
 * (On the wire, LRD-REC-v1 sorts keys bytewise: commit, kind, payload_sha256, seq.) */
typedef struct lrd_state {
  uint64_t   seq;                             /* natural number */
  char       commit[LRD_HEX256_BUF];          /* commitment of previous state; 64 zeros at genesis */
  lrd_kind_t kind;
  char       payload_sha256[LRD_HEX256_BUF];
} lrd_state_t;

/* Transition proposal: kind, prev_commit, seq (= prev seq + 1), payload_sha256, plus
 * kind-specific fields (sorted bytewise with the common fields when serialized; keys must
 * not collide with the common keys). */
typedef struct lrd_proposal {
  lrd_kind_t         kind;
  char               prev_commit[LRD_HEX256_BUF];
  uint64_t           seq;
  char               payload_sha256[LRD_HEX256_BUF];
  const lrd_field_t *extra;                   /* may be NULL when n_extra == 0 */
  size_t             n_extra;
} lrd_proposal_t;

/* Decision: decision, reason, new_commit (set ONLY on ACCEPT; empty string on REJECT and then
 * omitted from the serialized record). Rejection never constructs a new state. */
typedef struct lrd_decision {
  lrd_decision_code_t decision;
  char                reason[LRD_REASON_MAX + 1u];
  char                new_commit[LRD_HEX256_BUF];
} lrd_decision_t;

/* Transition function signature shared by subsystems. Contract:
 *   - returns LRD_DECISION_ACCEPT or LRD_DECISION_REJECT (same as out->decision);
 *   - on ACCEPT, writes *next (if next != NULL) and out->new_commit;
 *   - on REJECT, MUST NOT write *next and leaves out->new_commit as "". */
typedef lrd_decision_code_t (*lrd_transition_fn)(const lrd_state_t *cur,
                                                 const lrd_proposal_t *prop,
                                                 lrd_decision_t *out,
                                                 lrd_state_t *next);

/* ---------------------------------------------------------------- inline helpers */
static inline const char *lrd_kind_token(lrd_kind_t k) {
  switch (k) {
    case LRD_KIND_OBSERVATION:      return "observation";
    case LRD_KIND_LEDGER_APPEND:    return "ledger_append";
    case LRD_KIND_HAMILTONIAN_STEP: return "hamiltonian_step";
    case LRD_KIND_CAPABILITY:       return "capability";
    case LRD_KIND_AIR_PROOF:        return "air_proof";
    case LRD_KIND_INVALID:          break;
  }
  return NULL;
}

static inline lrd_kind_t lrd_kind_from_token(const char *s, size_t n) {
  static const struct { const char *t; lrd_kind_t k; } tab[] = {
    {"observation", LRD_KIND_OBSERVATION},
    {"ledger_append", LRD_KIND_LEDGER_APPEND},
    {"hamiltonian_step", LRD_KIND_HAMILTONIAN_STEP},
    {"capability", LRD_KIND_CAPABILITY},
    {"air_proof", LRD_KIND_AIR_PROOF},
  };
  for (size_t i = 0; i < sizeof tab / sizeof tab[0]; i++)
    if (strlen(tab[i].t) == n && memcmp(tab[i].t, s, n) == 0) return tab[i].k;
  return LRD_KIND_INVALID;
}

/* 1 iff s is exactly 64 lowercase hex characters followed by NUL. */
static inline int lrd_is_hex256(const char *s) {
  for (size_t i = 0; i < LRD_HEX256_LEN; i++) {
    char c = s[i];
    if (!((c >= '0' && c <= '9') || (c >= 'a' && c <= 'f'))) return 0;
  }
  return s[LRD_HEX256_LEN] == '\0';
}

/* Fill a REJECT decision (never touches any state). */
static inline void lrd_decision_reject(lrd_decision_t *d, const char *reason) {
  size_t n = strlen(reason);
  if (n > LRD_REASON_MAX) n = LRD_REASON_MAX;
  d->decision = LRD_DECISION_REJECT;
  memcpy(d->reason, reason, n);
  d->reason[n] = '\0';
  d->new_commit[0] = '\0';
}

/* ---------------------------------------------------------------- ABI layout checks */
#ifdef __cplusplus
#define LRD_STATIC_ASSERT(cond, msg) static_assert(cond, msg)
#else
#define LRD_STATIC_ASSERT(cond, msg) _Static_assert(cond, msg)
#endif
LRD_STATIC_ASSERT(sizeof(uint64_t) == 8, "LRD-STATE-v1: seq is 64-bit");
LRD_STATIC_ASSERT(sizeof(((lrd_state_t *)0)->commit) == 65, "LRD-STATE-v1: commit is char[65]");
LRD_STATIC_ASSERT(sizeof(((lrd_state_t *)0)->payload_sha256) == 65, "LRD-STATE-v1: payload is char[65]");
LRD_STATIC_ASSERT(sizeof(((lrd_decision_t *)0)->new_commit) == 65, "LRD-STATE-v1: new_commit is char[65]");
LRD_STATIC_ASSERT(sizeof(LRD_REC_MAGIC) - 1u == LRD_REC_MAGIC_LEN, "LRD-REC-v1 magic length");
LRD_STATIC_ASSERT(sizeof(LRD_COMMIT_DOMAIN) == LRD_COMMIT_DOMAIN_LEN, "commit domain incl. NUL");
LRD_STATIC_ASSERT(sizeof(LRD_GENESIS_COMMIT) - 1u == LRD_HEX256_LEN, "genesis commit length");

#ifdef __cplusplus
}
#endif

#endif /* LRD_STATE_H */
