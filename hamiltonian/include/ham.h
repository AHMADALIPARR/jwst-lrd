/* Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 * Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License (see LICENSE, SNAPKITTY_OPAQUE_LICENSE.md).
 * SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
 *
 * ham.h -- Frustration Hamiltonian Action-WORM engine (JWST-LRD TASK 008).
 *
 *   H_F(s) = sum_i w_i V_i(s) + sum_ij J_ij C_ij(s) + sum_k u_k [soft_k violated](s)
 *
 * All energies are GMP mpq_t (canonical). No floating point is used anywhere
 * in this library. Hard constraints restrict the finite state domain
 * D = D_0 x ... x D_{n-1}, D_v = {0..dom[v]-1}; they never contribute energy.
 *
 * Transitions are LRD-STATE-v1 proposals (kind=hamiltonian_step). The engine
 * returns a canonical LRD-REC-v1 decision record and constructs a successor
 * state ONLY on ACCEPT (see OBLIGATIONS.md).
 */
#ifndef HAM_H
#define HAM_H

#include <stddef.h>
#include <stdint.h>
#include <gmp.h>
#include "lrd_state.h"

/* kind token for this subsystem (lrd_kind_token(LRD_KIND_HAMILTONIAN_STEP)) */
#define HAM_KIND       "hamiltonian_step"

#define HAM_MAX_VARS   64
#define HAM_MAX_DOM    64
#define HAM_NAME_MAX   32      /* incl. NUL; names match [a-z0-9_]{1,31} */

typedef enum {
    HAM_OK = 0,
    HAM_ERR_NOMEM,
    HAM_ERR_ARG,          /* invalid argument / malformed input */
    HAM_ERR_PARSE,        /* malformed record / rational / assignment */
    HAM_ERR_INFEASIBLE,   /* hard constraint violated: nothing constructed */
    HAM_ERR_LIMIT         /* search node limit hit: no answer claimed */
} ham_status;

const char *ham_status_str(ham_status st);

/* ---------------- SHA-256 ---------------- */
void ham_sha256(const void *data, size_t len, unsigned char out[32]);
void ham_hex(const unsigned char *in, size_t n, char *out /* 2n+1 */);

/* ---------------- exact rationals ---------------- */
/* Canonical LRD-REC-v1 text "p/q", q>0, gcd(p,q)=1 (zero is "0/1"). malloc'd. */
char *ham_q_str(const mpq_t q);
/* Strict parse: accepts only the canonical form above. */
ham_status ham_q_parse_canonical(mpq_t out, const char *s);
/* Lenient parse for model construction: "-?d+" or "-?d+/d+", q!=0;
 * result is canonicalized (e.g. "2/6" -> 1/3). */
ham_status ham_q_set(mpq_t out, const char *s);

/* ---------------- LRD-REC-v1 records ---------------- */
typedef struct { char *key; char *val; } ham_field_kv;
typedef struct {
    ham_field_kv *f;
    size_t n, cap;
} ham_rec;

void       ham_rec_init(ham_rec *r);
void       ham_rec_free(ham_rec *r);
ham_status ham_rec_add(ham_rec *r, const char *key, const char *val);
ham_status ham_rec_addn(ham_rec *r, const char *key, size_t klen, const char *val, size_t vlen);
ham_status ham_rec_addf(ham_rec *r, const char *key, const char *fmt, ...)
    __attribute__((format(printf, 3, 4)));
ham_status ham_rec_add_q(ham_rec *r, const char *key, const mpq_t q);
/* Sorts keys bytewise, rejects duplicates, emits canonical bytes (malloc'd,
 * NUL-terminated for convenience; *len excludes the NUL). */
ham_status ham_rec_serialize(ham_rec *r, char **out, size_t *len);
/* Strict parser: magic, length prefixes without leading zeros, keys strictly
 * ascending (sorted, no duplicates), no NUL/newline in key or value. */
ham_status ham_rec_parse(const char *buf, size_t len, ham_rec *out);
const char *ham_rec_get(const ham_rec *r, const char *key);
/* hex SHA-256("LRD-COMMIT-v1\0" || bytes) */
ham_status ham_commit_bytes(const char *bytes, size_t len, char hex[65]);

/* ---------------- model ---------------- */
typedef struct { int var; mpq_t w; mpq_t *tab; } ham_vterm;          /* tab[dom[var]] */
typedef struct { int i, j; mpq_t J; mpq_t *tab; } ham_cterm;         /* tab[a*dom[j]+b] */
typedef struct { char name[HAM_NAME_MAX]; int i, j; unsigned char *ok; } ham_hard;   /* j<0: unary */
typedef struct { char name[HAM_NAME_MAX]; int i, j; mpq_t u; unsigned char *viol; } ham_soft;

typedef struct ham_model {
    int n;
    int dom[HAM_MAX_VARS];
    ham_vterm *v; size_t nv;
    ham_cterm *c; size_t nc;
    ham_hard  *h; size_t nh;
    ham_soft  *s; size_t ns;
    uint64_t node_limit;          /* backtracking node budget for SAT/MUS */
} ham_model;

ham_status ham_model_init(ham_model *m, int n, const int *dom);
void       ham_model_free(ham_model *m);
/* tables of rational strings (lenient syntax, canonicalized) */
ham_status ham_model_add_field(ham_model *m, int var, const char *w, const char *const *tab);
ham_status ham_model_add_coupling(ham_model *m, int i, int j, const char *J, const char *const *tab);
/* hard: ok[a] (unary, j<0) or ok[a*dom[j]+b]; nonzero = allowed */
ham_status ham_model_add_hard(ham_model *m, const char *name, int i, int j, const unsigned char *ok);
/* soft: contributes u * [viol[..] != 0] */
ham_status ham_model_add_soft(ham_model *m, const char *name, int i, int j, const char *u,
                              const unsigned char *viol);
/* hex commitment of the canonical model record (binds payloads to a model) */
ham_status ham_model_commit(const ham_model *m, char hex[65]);

/* assignment text "a0,a1,...": canonical decimals, exactly n entries, in domain */
ham_status ham_assign_parse(const ham_model *m, const char *s, int *out);
char      *ham_assign_str(const ham_model *m, const int *a);

/* exact energy; assignment must be in-domain */
ham_status ham_energy(const ham_model *m, const int *a, mpq_t out);
/* indices of violated hard constraints (ascending), count in *nviol */
ham_status ham_violations(const ham_model *m, const int *a, size_t *idx, size_t *nviol);

/* ---------------- satisfiability / conflicts / reports ---------------- */
typedef struct {
    int      sat;                  /* 1 sat, 0 unsat */
    int      witness[HAM_MAX_VARS];/* lexicographically least model if sat */
    uint64_t nodes;
} ham_sat_result;

/* active==NULL means all hard constraints */
ham_status ham_sat(const ham_model *m, const unsigned char *active, ham_sat_result *res);
/* Deletion-based irreducible conflict set. On unsat: in_mus[k]=1 for members.
 * Every member is necessary (removing any one makes the rest satisfiable). */
ham_status ham_conflict(const ham_model *m, unsigned char *in_mus, size_t *mus_n, int *is_sat);
/* Machine-readable reports (LRD-REC-v1 bytes, malloc'd). */
ham_status ham_sat_report(const ham_model *m, char **out, size_t *len);
ham_status ham_infeasibility_report(const ham_model *m, const int *a, char **out, size_t *len);

/* ---------------- engine ---------------- */
typedef struct {
    uint32_t budget;       /* max accepted descent steps per epoch, >=1 */
    uint32_t max_epochs;   /* epochs are numbered 0..max_epochs-1, >=1 */
} ham_epoch_cfg;

typedef struct ham_state {
    uint64_t seq;
    char     prev_commit[65];      /* LRD-STATE-v1 "commit" field */
    char     self_commit[65];      /* commitment of this state's record */
    char     payload_sha256[65];
    char     model_commit[65];
    uint32_t epoch;
    uint32_t steps_used;           /* accepted descent steps in this epoch */
    int      n;
    int      assign[HAM_MAX_VARS];
    mpq_t    energy;
} ham_state;

/* number of ham_state objects ever constructed (genesis or ACCEPT) */
uint64_t ham_states_constructed(void);
void     ham_state_free(ham_state *st);
/* fills the ledger ABI (lrd_state_t) view of st */
void     ham_state_view(const ham_state *st, lrd_state_t *out);

/* Genesis: constructs *out only if a is in-domain and feasible. On
 * HAM_ERR_INFEASIBLE, *report (if non-NULL) gets an infeasibility record and
 * *out is untouched. */
ham_status ham_state_genesis(const ham_model *m, const ham_epoch_cfg *cfg, const int *a,
                             ham_state *out, char **report, size_t *report_len);

/* payload record hash for a proposal (op = "step" | "epoch_advance") */
ham_status ham_payload_sha256(const ham_model *m, const char *op, const char *assign,
                              uint32_t epoch, uint32_t epoch_step, char hex[65]);

/* Proposal builders (canonical LRD-REC-v1 bytes) */
ham_status ham_propose_step(const ham_model *m, const ham_state *cur, const int *a,
                            char **out, size_t *len);
ham_status ham_propose_epoch_advance(const ham_model *m, const ham_state *cur,
                                     char **out, size_t *len);

/* Decide a proposal against cur. Always (on HAM_OK) emits a decision record.
 * *accepted = 1 iff ACCEPT, in which case *next is constructed (caller frees
 * with ham_state_free). On REJECT *next is not written at all.
 * Non-HAM_OK return (NOMEM/ARG) = no decision, nothing constructed. */
ham_status ham_decide(const ham_model *m, const ham_epoch_cfg *cfg, const ham_state *cur,
                      const char *proposal, size_t plen,
                      char **decision, size_t *dlen, int *accepted, ham_state *next);

/* Ledger ABI adapter (ledger/abi/lrd_state.h). Same contract as lrd_transition_fn --
 * on REJECT neither *next nor *next_view is written and out->new_commit is "" --
 * but the engine context (model, epoch cfg, full engine state) is explicit, since
 * lrd_transition_fn has no context parameter. prop is serialized to LRD-REC-v1
 * (common fields + extra) and decided by ham_decide; a proposal that cannot be
 * serialized (bad bytes in extra, duplicate keys) is decided as empty input,
 * i.e. REJECT malformed. record/rlen (both NULL or both non-NULL) receive the full
 * decision record. Non-HAM_OK return: no decision, nothing written to next*. */
ham_status ham_decide_abi(const ham_model *m, const ham_epoch_cfg *cfg, const ham_state *cur,
                          const lrd_proposal_t *prop, lrd_decision_t *out,
                          ham_state *next, lrd_state_t *next_view,
                          char **record, size_t *rlen);

#endif /* HAM_H */
