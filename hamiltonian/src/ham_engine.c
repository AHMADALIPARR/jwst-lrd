/* Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 * Dual-licensed: AGPL-3.0-or-later plus SnapKitty Opaque License (see LICENSE, SNAPKITTY_OPAQUE_LICENSE.md).
 * SPDX-License-Identifier: AGPL-3.0-or-later AND LicenseRef-SnapKitty-Opaque
 */
/* Action-WORM engine: LRD-STATE-v1 hamiltonian_step decisions.
 *
 * Decision procedure (first failing check determines the reason; see
 * OBLIGATIONS.md section 3 for the normative order):
 *   1 malformed            proposal is not a valid LRD-REC-v1 record
 *   2 wrong_kind           kind != hamiltonian_step
 *   3 malformed            field set / field syntax / assignment outside D
 *   4 stale_seq            seq != cur.seq + 1
 *   5 bad_prev             prev_commit != commitment(cur)
 *   6 bad_payload          payload_sha256 != SHA-256(canonical payload)
 *   op=step:
 *   7 bad_epoch            epoch != cur.epoch
 *   8 epoch_exhausted      cur.steps_used >= budget
 *   9 infeasible           some hard constraint violated by candidate
 *  10 energy_not_decreasing  not (H(cand) < H(cur))   [exact mpq_cmp]
 *   op=epoch_advance:
 *   7 bad_epoch            epoch != cur.epoch + 1, or assign != cur.assign
 *   8 epoch_exhausted      epoch >= max_epochs
 *   otherwise ACCEPT / ok.
 */
#include "ham.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static uint64_t g_constructed = 0;
uint64_t ham_states_constructed(void) { return g_constructed; }

void ham_state_free(ham_state *st) { mpq_clear(st->energy); memset(st, 0, sizeof *st); }

void ham_state_view(const ham_state *st, lrd_state_t *out) {
    memset(out, 0, sizeof *out);
    out->seq = st->seq;
    memcpy(out->commit, st->prev_commit, 65);
    out->kind = LRD_KIND_HAMILTONIAN_STEP;
    memcpy(out->payload_sha256, st->payload_sha256, 65);
}

static ham_status payload_bytes(const char *model_commit, const char *op, const char *assign,
                                uint32_t epoch, uint32_t epoch_step, char hex[65]) {
    ham_rec r; ham_rec_init(&r);
    ham_status st = ham_rec_add(&r, "format", "LRD-HAM-PAYLOAD-v1");
    if (st == HAM_OK) st = ham_rec_add(&r, "assign", assign);
    if (st == HAM_OK) st = ham_rec_addf(&r, "epoch", "%u", (unsigned)epoch);
    if (st == HAM_OK) st = ham_rec_addf(&r, "epoch_step", "%u", (unsigned)epoch_step);
    if (st == HAM_OK) st = ham_rec_add(&r, "model", model_commit);
    if (st == HAM_OK) st = ham_rec_add(&r, "op", op);
    char *b = NULL; size_t n = 0;
    if (st == HAM_OK) st = ham_rec_serialize(&r, &b, &n);
    if (st == HAM_OK) { unsigned char d[32]; ham_sha256(b, n, d); ham_hex(d, 32, hex); }
    free(b); ham_rec_free(&r);
    return st;
}

ham_status ham_payload_sha256(const ham_model *m, const char *op, const char *assign,
                              uint32_t epoch, uint32_t epoch_step, char hex[65]) {
    char mc[65];
    ham_status st = ham_model_commit(m, mc);
    if (st != HAM_OK) return st;
    return payload_bytes(mc, op, assign, epoch, epoch_step, hex);
}

static ham_status state_commit(uint64_t seq, const char *prev, const char *payload, char hex[65]) {
    ham_rec r; ham_rec_init(&r);
    ham_status st = ham_rec_add(&r, LRD_F_COMMIT, prev);
    if (st == HAM_OK) st = ham_rec_add(&r, LRD_F_KIND, HAM_KIND);
    if (st == HAM_OK) st = ham_rec_add(&r, LRD_F_PAYLOAD_SHA256, payload);
    if (st == HAM_OK) st = ham_rec_addf(&r, LRD_F_SEQ, "%llu", (unsigned long long)seq);
    char *b = NULL; size_t n = 0;
    if (st == HAM_OK) st = ham_rec_serialize(&r, &b, &n);
    if (st == HAM_OK) st = ham_commit_bytes(b, n, hex);
    free(b); ham_rec_free(&r);
    return st;
}

/* The ONLY place a ham_state is constructed. All inputs are precomputed so
 * this cannot fail after it starts writing *out. */
static void construct_state(ham_state *out, uint64_t seq, const char *prev, const char *self,
                            const char *payload, const char *model, uint32_t epoch,
                            uint32_t steps, int n, const int *a, const mpq_t energy) {
    memset(out, 0, sizeof *out);
    out->seq = seq;
    memcpy(out->prev_commit, prev, 65);
    memcpy(out->self_commit, self, 65);
    memcpy(out->payload_sha256, payload, 65);
    memcpy(out->model_commit, model, 65);
    out->epoch = epoch; out->steps_used = steps; out->n = n;
    memcpy(out->assign, a, (size_t)n * sizeof(int));
    mpq_init(out->energy); mpq_set(out->energy, energy);
    g_constructed++;
}

ham_status ham_state_genesis(const ham_model *m, const ham_epoch_cfg *cfg, const int *a,
                             ham_state *out, char **report, size_t *report_len) {
    if (report) { *report = NULL; if (report_len) *report_len = 0; }
    if (!m || !cfg || !a || !out || cfg->budget < 1 || cfg->max_epochs < 1) return HAM_ERR_ARG;
    char *as = ham_assign_str(m, a);
    if (!as) return HAM_ERR_ARG;                     /* outside domain (or nomem) */
    size_t nv = 0;
    ham_status st = ham_violations(m, a, NULL, &nv);
    if (st == HAM_OK && nv > 0) {
        if (report) {
            size_t l = 0;
            ham_status rs = ham_infeasibility_report(m, a, report, &l);
            if (rs != HAM_OK) { free(as); return rs; }
            if (report_len) *report_len = l;
        }
        free(as);
        return HAM_ERR_INFEASIBLE;
    }
    char mc[65], ph[65], self[65];
    mpq_t e; mpq_init(e);
    if (st == HAM_OK) st = ham_model_commit(m, mc);
    if (st == HAM_OK) st = payload_bytes(mc, "genesis", as, 0, 0, ph);
    if (st == HAM_OK) st = state_commit(0, LRD_GENESIS_COMMIT, ph, self);
    if (st == HAM_OK) st = ham_energy(m, a, e);
    if (st == HAM_OK) construct_state(out, 0, LRD_GENESIS_COMMIT, self, ph, mc, 0, 0, m->n, a, e);
    mpq_clear(e); free(as);
    return st;
}

static ham_status build_proposal(const char *op, uint64_t seq, const char *prev, const char *ph,
                                 const char *assign, uint32_t epoch, char **out, size_t *len) {
    ham_rec r; ham_rec_init(&r);
    ham_status st = ham_rec_add(&r, "kind", HAM_KIND);
    if (st == HAM_OK) st = ham_rec_add(&r, "op", op);
    if (st == HAM_OK) st = ham_rec_addf(&r, "seq", "%llu", (unsigned long long)seq);
    if (st == HAM_OK) st = ham_rec_add(&r, "prev_commit", prev);
    if (st == HAM_OK) st = ham_rec_add(&r, "payload_sha256", ph);
    if (st == HAM_OK) st = ham_rec_add(&r, "assign", assign);
    if (st == HAM_OK) st = ham_rec_addf(&r, "epoch", "%u", (unsigned)epoch);
    if (st == HAM_OK) st = ham_rec_serialize(&r, out, len);
    ham_rec_free(&r);
    return st;
}

ham_status ham_propose_step(const ham_model *m, const ham_state *cur, const int *a,
                            char **out, size_t *len) {
    *out = NULL; *len = 0;
    char *as = ham_assign_str(m, a);
    if (!as) return HAM_ERR_ARG;
    char ph[65];
    ham_status st = payload_bytes(cur->model_commit, "step", as, cur->epoch, cur->steps_used + 1u, ph);
    if (st == HAM_OK) st = build_proposal("step", cur->seq + 1, cur->self_commit, ph, as, cur->epoch, out, len);
    free(as);
    return st;
}

ham_status ham_propose_epoch_advance(const ham_model *m, const ham_state *cur,
                                     char **out, size_t *len) {
    *out = NULL; *len = 0;
    char *as = ham_assign_str(m, cur->assign);
    if (!as) return HAM_ERR_ARG;
    char ph[65];
    ham_status st = payload_bytes(cur->model_commit, "epoch_advance", as, cur->epoch + 1u, 0, ph);
    if (st == HAM_OK) st = build_proposal("epoch_advance", cur->seq + 1, cur->self_commit, ph, as,
                                          cur->epoch + 1u, out, len);
    free(as);
    return st;
}

/* canonical natural number (no leading zeros) */
static int parse_nat(const char *s, uint64_t max, uint64_t *out) {
    if (!s || !*s) return 0;
    if (s[0] == '0' && s[1]) return 0;
    uint64_t v = 0;
    for (const char *p = s; *p; p++) {
        if (*p < '0' || *p > '9') return 0;
        uint64_t d = (uint64_t)(*p - '0');
        if (v > (max - d) / 10) return 0;
        v = v * 10 + d;
    }
    *out = v;
    return 1;
}

static int is_hex64(const char *s) {
    if (!s || strlen(s) != 64) return 0;
    for (int i = 0; i < 64; i++)
        if (!((s[i] >= '0' && s[i] <= '9') || (s[i] >= 'a' && s[i] <= 'f'))) return 0;
    return 1;
}

static const char *const PROPOSAL_FIELDS[] = {
    "assign", "epoch", "kind", "op", "payload_sha256", "prev_commit", "seq" };  /* sorted */
#define NPF (sizeof PROPOSAL_FIELDS / sizeof PROPOSAL_FIELDS[0])

ham_status ham_decide(const ham_model *m, const ham_epoch_cfg *cfg, const ham_state *cur,
                      const char *proposal, size_t plen,
                      char **decision, size_t *dlen, int *accepted, ham_state *next) {
    if (!decision || !dlen || !accepted) return HAM_ERR_ARG;
    *decision = NULL; *dlen = 0; *accepted = 0;
    if (!m || !cfg || !cur || !next || (!proposal && plen) || cfg->budget < 1 || cfg->max_epochs < 1)
        return HAM_ERR_ARG;

    ham_rec d; ham_rec_init(&d);          /* decision under construction */
    ham_rec p; ham_rec_init(&p);          /* parsed proposal */
    const char *reason = NULL;
    ham_status st = HAM_OK;
    char pc[65], mc[65], ph[65], newc[65];
    int a[HAM_MAX_VARS];
    uint64_t seq = 0, ep64 = 0;
    const char *op = NULL;
    int is_step = 0;
    mpq_t ecand, delta; mpq_init(ecand); mpq_init(delta);
    int have_cand = 0;
    size_t *vidx = NULL, nv = 0;

#define TRY(x) do { st = (x); if (st != HAM_OK) goto out; } while (0)

    TRY(ham_commit_bytes(proposal ? proposal : "", plen, pc));
    TRY(ham_rec_add(&d, "kind", HAM_KIND));
    TRY(ham_rec_add(&d, "proposal_commit", pc));
    TRY(ham_rec_add(&d, "state_commit", cur->self_commit));
    TRY(ham_rec_addf(&d, "state_seq", "%llu", (unsigned long long)cur->seq));
    TRY(ham_rec_add_q(&d, "energy_prev", cur->energy));
    TRY(ham_rec_addf(&d, "epoch_budget", "%u", (unsigned)cfg->budget));
    TRY(ham_rec_addf(&d, "epoch_max", "%u", (unsigned)cfg->max_epochs));
    TRY(ham_rec_addf(&d, "epoch_prev", "%u", (unsigned)cur->epoch));
    TRY(ham_rec_addf(&d, "epoch_steps_used", "%u", (unsigned)cur->steps_used));

    /* 1 */
    {
        ham_status ps = ham_rec_parse(proposal ? proposal : "", plen, &p);
        if (ps == HAM_ERR_NOMEM) { st = ps; goto out; }
        if (ps != HAM_OK) { reason = "malformed"; goto decide; }
    }
    /* 2 */
    {
        const char *k = ham_rec_get(&p, "kind");
        if (!k || strcmp(k, HAM_KIND) != 0) { reason = "wrong_kind"; goto decide; }
    }
    /* 3: exact field set (parsed records are sorted, so compare in order) */
    if (p.n != NPF) { reason = "malformed"; goto decide; }
    for (size_t i = 0; i < NPF; i++)
        if (strcmp(p.f[i].key, PROPOSAL_FIELDS[i]) != 0) { reason = "malformed"; goto decide; }
    op = ham_rec_get(&p, "op");
    if (strcmp(op, "step") == 0) is_step = 1;
    else if (strcmp(op, "epoch_advance") != 0) { reason = "malformed"; goto decide; }
    TRY(ham_rec_add(&d, "op", op));
    if (!parse_nat(ham_rec_get(&p, "seq"), UINT64_MAX, &seq) ||
        !parse_nat(ham_rec_get(&p, "epoch"), UINT32_MAX, &ep64) ||
        !is_hex64(ham_rec_get(&p, "prev_commit")) ||
        !is_hex64(ham_rec_get(&p, "payload_sha256"))) { reason = "malformed"; goto decide; }
    {
        ham_status as = ham_assign_parse(m, ham_rec_get(&p, "assign"), a);
        if (as != HAM_OK) { reason = "malformed"; goto decide; }
    }
    TRY(ham_rec_add(&d, "seq", ham_rec_get(&p, "seq")));
    TRY(ham_rec_add(&d, "prev_commit", ham_rec_get(&p, "prev_commit")));
    TRY(ham_rec_add(&d, "epoch", ham_rec_get(&p, "epoch")));
    TRY(ham_rec_add(&d, "assign", ham_rec_get(&p, "assign")));
    /* 4 */
    if (cur->seq == UINT64_MAX || seq != cur->seq + 1) { reason = LRD_REASON_STALE_SEQ; goto decide; }
    /* 5 */
    if (strcmp(ham_rec_get(&p, "prev_commit"), cur->self_commit) != 0) { reason = LRD_REASON_BAD_PREV; goto decide; }
    /* 6 */
    TRY(ham_model_commit(m, mc));
    if (strcmp(mc, cur->model_commit) != 0) { st = HAM_ERR_ARG; goto out; }   /* caller misuse */
    {
        uint32_t estep = is_step ? cur->steps_used + 1u : 0u;
        TRY(payload_bytes(mc, op, ham_rec_get(&p, "assign"), (uint32_t)ep64, estep, ph));
        if (strcmp(ph, ham_rec_get(&p, "payload_sha256")) != 0) { reason = "bad_payload"; goto decide; }
    }
    if (is_step) {
        /* 7 */
        if (ep64 != cur->epoch) { reason = "bad_epoch"; goto decide; }
        /* 8 */
        if (cur->steps_used >= cfg->budget) { reason = "epoch_exhausted"; goto decide; }
        /* 9 */
        vidx = malloc((m->nh ? m->nh : 1) * sizeof *vidx);
        if (!vidx) { st = HAM_ERR_NOMEM; goto out; }
        TRY(ham_violations(m, a, vidx, &nv));
        if (nv > 0) {
            size_t tot = 1;
            for (size_t t = 0; t < nv; t++) tot += strlen(m->h[vidx[t]].name) + 1;
            char *names = malloc(tot);
            if (!names) { st = HAM_ERR_NOMEM; goto out; }
            names[0] = 0;
            for (size_t t = 0; t < nv; t++) { if (t) strcat(names, ","); strcat(names, m->h[vidx[t]].name); }
            st = ham_rec_add(&d, "violated", names);
            free(names);
            if (st != HAM_OK) goto out;
            TRY(ham_rec_addf(&d, "violated_count", "%zu", nv));
            reason = LRD_REASON_INFEASIBLE; goto decide;
        }
        /* 10: exact comparison, no floating point */
        TRY(ham_energy(m, a, ecand));
        have_cand = 1;
        mpq_sub(delta, ecand, cur->energy);
        TRY(ham_rec_add_q(&d, "energy_cand", ecand));
        TRY(ham_rec_add_q(&d, "energy_delta", delta));
        if (!(mpq_cmp(ecand, cur->energy) < 0)) { reason = LRD_REASON_ENERGY_NOT_DECREASING; goto decide; }
    } else {
        /* 7 */
        if (cur->epoch == UINT32_MAX || ep64 != (uint64_t)cur->epoch + 1u ||
            memcmp(a, cur->assign, (size_t)m->n * sizeof(int)) != 0) { reason = "bad_epoch"; goto decide; }
        /* 8 */
        if (ep64 >= cfg->max_epochs) { reason = "epoch_exhausted"; goto decide; }
        mpq_set(ecand, cur->energy);
        have_cand = 1;
    }
    reason = LRD_REASON_OK;

decide:
    {
        int acc = (strcmp(reason, LRD_REASON_OK) == 0);
        uint32_t nsteps = 0, nep = 0;
        if (acc) {
            nep = (uint32_t)ep64;
            nsteps = is_step ? cur->steps_used + 1u : 0u;
            TRY(state_commit(seq, cur->self_commit, ph, newc));
            TRY(ham_rec_add(&d, LRD_F_NEW_COMMIT, newc));
            TRY(ham_rec_addf(&d, "epoch_steps_after", "%u", (unsigned)nsteps));
            TRY(ham_rec_add(&d, "payload_sha256", ph));
        }
        TRY(ham_rec_add(&d, LRD_F_DECISION, acc ? LRD_DECISION_TOKEN_ACCEPT : LRD_DECISION_TOKEN_REJECT));
        TRY(ham_rec_add(&d, LRD_F_REASON, reason));
        TRY(ham_rec_serialize(&d, decision, dlen));
        if (acc) {
            /* everything precomputed; construction cannot fail from here */
            (void)have_cand;
            construct_state(next, seq, cur->self_commit, newc, ph, mc, nep, nsteps, m->n, a, ecand);
            *accepted = 1;
        }
    }
out:
#undef TRY
    if (st != HAM_OK) { free(*decision); *decision = NULL; *dlen = 0; *accepted = 0; }
    free(vidx);
    mpq_clear(ecand); mpq_clear(delta);
    ham_rec_free(&p); ham_rec_free(&d);
    return st;
}

ham_status ham_decide_abi(const ham_model *m, const ham_epoch_cfg *cfg, const ham_state *cur,
                          const lrd_proposal_t *prop, lrd_decision_t *out,
                          ham_state *next, lrd_state_t *next_view,
                          char **record, size_t *rlen) {
    if (!m || !cfg || !cur || !prop || !out || !next || !next_view || (!record) != (!rlen) ||
        (prop->n_extra && !prop->extra))
        return HAM_ERR_ARG;
    if (record) { *record = NULL; *rlen = 0; }
    ham_rec r; ham_rec_init(&r);
    const char *kt = lrd_kind_token(prop->kind);
    ham_status st = ham_rec_add(&r, LRD_F_KIND, kt ? kt : "");
    if (st == HAM_OK) st = ham_rec_add(&r, LRD_F_PREV_COMMIT, prop->prev_commit);
    if (st == HAM_OK) st = ham_rec_addf(&r, LRD_F_SEQ, "%llu", (unsigned long long)prop->seq);
    if (st == HAM_OK) st = ham_rec_add(&r, LRD_F_PAYLOAD_SHA256, prop->payload_sha256);
    for (size_t i = 0; st == HAM_OK && i < prop->n_extra; i++)
        st = ham_rec_addn(&r, prop->extra[i].key, prop->extra[i].key_len,
                          prop->extra[i].value, prop->extra[i].value_len);
    char *bytes = NULL; size_t blen = 0;
    if (st == HAM_OK) st = ham_rec_serialize(&r, &bytes, &blen);
    ham_rec_free(&r);
    if (st == HAM_ERR_NOMEM) return st;
    if (st != HAM_OK) { free(bytes); bytes = NULL; blen = 0; }   /* unserializable -> malformed */

    char *d = NULL; size_t dl = 0; int acc = 0;
    ham_state tmp;                    /* written by ham_decide only on ACCEPT */
    st = ham_decide(m, cfg, cur, bytes ? bytes : "", blen, &d, &dl, &acc, &tmp);
    free(bytes);
    if (st != HAM_OK) return st;
    ham_rec dr;
    st = ham_rec_parse(d, dl, &dr);
    if (st != HAM_OK) { free(d); if (acc) ham_state_free(&tmp); return st == HAM_ERR_NOMEM ? st : HAM_ERR_ARG; }
    const char *reason = ham_rec_get(&dr, LRD_F_REASON);
    if (acc) {
        out->decision = LRD_DECISION_ACCEPT;
        snprintf(out->reason, sizeof out->reason, "%s", reason);
        memcpy(out->new_commit, tmp.self_commit, LRD_HEX256_BUF);
        *next = tmp;                  /* ownership of tmp.energy moves to *next */
        ham_state_view(next, next_view);
    } else {
        lrd_decision_reject(out, reason);
    }
    ham_rec_free(&dr);
    if (record) { *record = d; *rlen = dl; } else free(d);
    return HAM_OK;
}
