/* Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 * Dual-licensed: AGPL-3.0-or-later plus SnapKitty Opaque License (see LICENSE, SNAPKITTY_OPAQUE_LICENSE.md).
 * SPDX-License-Identifier: AGPL-3.0-or-later AND LicenseRef-SnapKitty-Opaque
 */
/* Model, exact energy, hard-constraint feasibility, SAT, conflicts, reports. */
#include "ham.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define DEFAULT_NODE_LIMIT 10000000ull

ham_status ham_model_init(ham_model *m, int n, const int *dom) {
    memset(m, 0, sizeof *m);
    if (n < 1 || n > HAM_MAX_VARS || !dom) return HAM_ERR_ARG;
    for (int i = 0; i < n; i++) if (dom[i] < 1 || dom[i] > HAM_MAX_DOM) return HAM_ERR_ARG;
    m->n = n;
    memcpy(m->dom, dom, (size_t)n * sizeof(int));
    m->node_limit = DEFAULT_NODE_LIMIT;
    return HAM_OK;
}

static void clear_tab(mpq_t *t, size_t k) { if (t) { for (size_t i = 0; i < k; i++) mpq_clear(t[i]); free(t); } }

void ham_model_free(ham_model *m) {
    for (size_t k = 0; k < m->nv; k++) { mpq_clear(m->v[k].w); clear_tab(m->v[k].tab, (size_t)m->dom[m->v[k].var]); }
    for (size_t k = 0; k < m->nc; k++) { mpq_clear(m->c[k].J); clear_tab(m->c[k].tab, (size_t)m->dom[m->c[k].i] * (size_t)m->dom[m->c[k].j]); }
    for (size_t k = 0; k < m->nh; k++) free(m->h[k].ok);
    for (size_t k = 0; k < m->ns; k++) { mpq_clear(m->s[k].u); free(m->s[k].viol); }
    free(m->v); free(m->c); free(m->h); free(m->s);
    memset(m, 0, sizeof *m);
}

static int var_ok(const ham_model *m, int v) { return v >= 0 && v < m->n; }

static size_t scope_size(const ham_model *m, int i, int j) {
    return j < 0 ? (size_t)m->dom[i] : (size_t)m->dom[i] * (size_t)m->dom[j];
}

static ham_status make_tab(mpq_t **out, size_t k, const char *const *src) {
    mpq_t *t = malloc(k * sizeof *t);
    if (!t) return HAM_ERR_NOMEM;
    for (size_t i = 0; i < k; i++) mpq_init(t[i]);
    for (size_t i = 0; i < k; i++) {
        ham_status st = src[i] ? ham_q_set(t[i], src[i]) : HAM_ERR_ARG;
        if (st != HAM_OK) { clear_tab(t, k); return st; }
    }
    *out = t;
    return HAM_OK;
}

static int name_ok(const ham_model *m, const char *name) {
    size_t l = name ? strlen(name) : 0;
    if (l == 0 || l >= HAM_NAME_MAX) return 0;
    for (size_t i = 0; i < l; i++) {
        char c = name[i];
        if (!((c >= 'a' && c <= 'z') || (c >= '0' && c <= '9') || c == '_')) return 0;
    }
    for (size_t k = 0; k < m->nh; k++) if (strcmp(m->h[k].name, name) == 0) return 0;
    for (size_t k = 0; k < m->ns; k++) if (strcmp(m->s[k].name, name) == 0) return 0;
    return 1;
}


ham_status ham_model_add_field(ham_model *m, int var, const char *w, const char *const *tab) {
    if (!var_ok(m, var) || !w || !tab || m->nv >= 999999) return HAM_ERR_ARG;
    mpq_t wq; mpq_init(wq);
    ham_status st = ham_q_set(wq, w);
    mpq_t *t = NULL;
    if (st == HAM_OK) st = make_tab(&t, (size_t)m->dom[var], tab);
    if (st != HAM_OK) { mpq_clear(wq); return st; }
    void *np = realloc(m->v, (m->nv + 1) * sizeof *m->v);
    if (!np) { mpq_clear(wq); clear_tab(t, (size_t)m->dom[var]); return HAM_ERR_NOMEM; }
    m->v = np;
    ham_vterm *x = &m->v[m->nv++];
    x->var = var; mpq_init(x->w); mpq_set(x->w, wq); x->tab = t;
    mpq_clear(wq);
    return HAM_OK;
}

ham_status ham_model_add_coupling(ham_model *m, int i, int j, const char *J, const char *const *tab) {
    if (!var_ok(m, i) || !var_ok(m, j) || i == j || !J || !tab || m->nc >= 999999) return HAM_ERR_ARG;
    size_t k = scope_size(m, i, j);
    mpq_t jq; mpq_init(jq);
    ham_status st = ham_q_set(jq, J);
    mpq_t *t = NULL;
    if (st == HAM_OK) st = make_tab(&t, k, tab);
    if (st != HAM_OK) { mpq_clear(jq); return st; }
    void *np = realloc(m->c, (m->nc + 1) * sizeof *m->c);
    if (!np) { mpq_clear(jq); clear_tab(t, k); return HAM_ERR_NOMEM; }
    m->c = np;
    ham_cterm *x = &m->c[m->nc++];
    x->i = i; x->j = j; mpq_init(x->J); mpq_set(x->J, jq); x->tab = t;
    mpq_clear(jq);
    return HAM_OK;
}

static ham_status bool_tab(unsigned char **out, size_t k, const unsigned char *src) {
    unsigned char *t = malloc(k);
    if (!t) return HAM_ERR_NOMEM;
    for (size_t i = 0; i < k; i++) t[i] = src[i] ? 1 : 0;
    *out = t;
    return HAM_OK;
}

ham_status ham_model_add_hard(ham_model *m, const char *name, int i, int j, const unsigned char *ok) {
    if (!var_ok(m, i) || (j >= 0 && (!var_ok(m, j) || i == j)) || !ok || !name_ok(m, name) || m->nh >= 999999)
        return HAM_ERR_ARG;
    if (j < 0) j = -1;
    unsigned char *t;
    ham_status st = bool_tab(&t, scope_size(m, i, j), ok);
    if (st != HAM_OK) return st;
    void *np = realloc(m->h, (m->nh + 1) * sizeof *m->h);
    if (!np) { free(t); return HAM_ERR_NOMEM; }
    m->h = np;
    ham_hard *x = &m->h[m->nh++];
    memset(x->name, 0, sizeof x->name); strcpy(x->name, name);
    x->i = i; x->j = j; x->ok = t;
    return HAM_OK;
}

ham_status ham_model_add_soft(ham_model *m, const char *name, int i, int j, const char *u,
                              const unsigned char *viol) {
    if (!var_ok(m, i) || (j >= 0 && (!var_ok(m, j) || i == j)) || !viol || !u || !name_ok(m, name) || m->ns >= 999999)
        return HAM_ERR_ARG;
    if (j < 0) j = -1;
    mpq_t uq; mpq_init(uq);
    ham_status st = ham_q_set(uq, u);
    unsigned char *t = NULL;
    if (st == HAM_OK) st = bool_tab(&t, scope_size(m, i, j), viol);
    if (st != HAM_OK) { mpq_clear(uq); return st; }
    void *np = realloc(m->s, (m->ns + 1) * sizeof *m->s);
    if (!np) { mpq_clear(uq); free(t); return HAM_ERR_NOMEM; }
    m->s = np;
    ham_soft *x = &m->s[m->ns++];
    memset(x->name, 0, sizeof x->name); strcpy(x->name, name);
    x->i = i; x->j = j; mpq_init(x->u); mpq_set(x->u, uq); x->viol = t;
    mpq_clear(uq);
    return HAM_OK;
}

/* ---- growable string buffer ---- */
typedef struct { char *b; size_t n, cap; int oom; } sbuf;
static void sb_put(sbuf *s, const char *x) {
    size_t l = strlen(x);
    if (s->oom) return;
    if (s->n + l + 1 > s->cap) {
        size_t nc = s->cap ? s->cap : 64;
        while (nc < s->n + l + 1) nc *= 2;
        char *nb = realloc(s->b, nc);
        if (!nb) { s->oom = 1; return; }
        s->b = nb; s->cap = nc;
    }
    memcpy(s->b + s->n, x, l + 1); s->n += l;
}
static void sb_int(sbuf *s, long long v) { char t[32]; snprintf(t, sizeof t, "%lld", v); sb_put(s, t); }
static void sb_q(sbuf *s, const mpq_t q) {
    char *t = ham_q_str(q);
    if (!t) { s->oom = 1; return; }
    sb_put(s, t); free(t);
}
static void sb_qtab(sbuf *s, mpq_t *t, size_t k) {
    for (size_t i = 0; i < k; i++) { if (i) sb_put(s, ","); sb_q(s, t[i]); }
}
static void sb_btab(sbuf *s, const unsigned char *t, size_t k) {
    for (size_t i = 0; i < k; i++) { if (i) sb_put(s, ","); sb_put(s, t[i] ? "1" : "0"); }
}

static ham_status add_sb(ham_rec *r, const char *key, sbuf *s) {
    ham_status st = s->oom ? HAM_ERR_NOMEM : ham_rec_add(r, key, s->b ? s->b : "");
    free(s->b); s->b = NULL; s->n = s->cap = 0; s->oom = 0;
    return st;
}

ham_status ham_model_commit(const ham_model *m, char hex[65]) {
    ham_rec r; ham_rec_init(&r);
    sbuf s = {0};
    char key[32];
    ham_status st = ham_rec_add(&r, "format", "LRD-HAM-MODEL-v1");
    if (st == HAM_OK) st = ham_rec_addf(&r, "n", "%d", m->n);
    if (st == HAM_OK) {
        for (int i = 0; i < m->n; i++) { if (i) sb_put(&s, ","); sb_int(&s, m->dom[i]); }
        st = add_sb(&r, "dom", &s);
    }
    for (size_t k = 0; st == HAM_OK && k < m->nv; k++) {
        const ham_vterm *x = &m->v[k];
        sb_put(&s, "var="); sb_int(&s, x->var); sb_put(&s, ";w="); sb_q(&s, x->w);
        sb_put(&s, ";tab="); sb_qtab(&s, x->tab, (size_t)m->dom[x->var]);
        snprintf(key, sizeof key, "v.%06zu", k); st = add_sb(&r, key, &s);
    }
    for (size_t k = 0; st == HAM_OK && k < m->nc; k++) {
        const ham_cterm *x = &m->c[k];
        sb_put(&s, "i="); sb_int(&s, x->i); sb_put(&s, ";j="); sb_int(&s, x->j);
        sb_put(&s, ";J="); sb_q(&s, x->J); sb_put(&s, ";tab=");
        sb_qtab(&s, x->tab, scope_size(m, x->i, x->j));
        snprintf(key, sizeof key, "c.%06zu", k); st = add_sb(&r, key, &s);
    }
    for (size_t k = 0; st == HAM_OK && k < m->nh; k++) {
        const ham_hard *x = &m->h[k];
        sb_put(&s, "name="); sb_put(&s, x->name); sb_put(&s, ";i="); sb_int(&s, x->i);
        sb_put(&s, ";j="); sb_int(&s, x->j); sb_put(&s, ";ok=");
        sb_btab(&s, x->ok, scope_size(m, x->i, x->j));
        snprintf(key, sizeof key, "h.%06zu", k); st = add_sb(&r, key, &s);
    }
    for (size_t k = 0; st == HAM_OK && k < m->ns; k++) {
        const ham_soft *x = &m->s[k];
        sb_put(&s, "name="); sb_put(&s, x->name); sb_put(&s, ";i="); sb_int(&s, x->i);
        sb_put(&s, ";j="); sb_int(&s, x->j); sb_put(&s, ";u="); sb_q(&s, x->u);
        sb_put(&s, ";viol="); sb_btab(&s, x->viol, scope_size(m, x->i, x->j));
        snprintf(key, sizeof key, "s.%06zu", k); st = add_sb(&r, key, &s);
    }
    char *ser = NULL; size_t len = 0;
    if (st == HAM_OK) st = ham_rec_serialize(&r, &ser, &len);
    if (st == HAM_OK) st = ham_commit_bytes(ser, len, hex);
    free(ser); free(s.b); ham_rec_free(&r);
    return st;
}

/* ---- assignments ---- */
ham_status ham_assign_parse(const ham_model *m, const char *s, int *out) {
    if (!s) return HAM_ERR_ARG;
    int tmp[HAM_MAX_VARS];
    const char *p = s;
    for (int v = 0; v < m->n; v++) {
        if (*p < '0' || *p > '9') return HAM_ERR_PARSE;
        if (*p == '0' && p[1] >= '0' && p[1] <= '9') return HAM_ERR_PARSE;   /* leading zero */
        long val = 0;
        while (*p >= '0' && *p <= '9') { val = val * 10 + (*p - '0'); if (val > HAM_MAX_DOM) return HAM_ERR_PARSE; p++; }
        if (val >= m->dom[v]) return HAM_ERR_PARSE;                        /* outside D_v */
        tmp[v] = (int)val;
        if (v + 1 < m->n) { if (*p != ',') return HAM_ERR_PARSE; p++; }
    }
    if (*p != '\0') return HAM_ERR_PARSE;
    memcpy(out, tmp, (size_t)m->n * sizeof(int));
    return HAM_OK;
}

static int in_domain(const ham_model *m, const int *a) {
    for (int v = 0; v < m->n; v++) if (a[v] < 0 || a[v] >= m->dom[v]) return 0;
    return 1;
}

char *ham_assign_str(const ham_model *m, const int *a) {
    if (!in_domain(m, a)) return NULL;
    sbuf s = {0};
    for (int v = 0; v < m->n; v++) { if (v) sb_put(&s, ","); sb_int(&s, a[v]); }
    if (s.oom) { free(s.b); return NULL; }
    return s.b;
}

static size_t idx2(const ham_model *m, int i, int j, const int *a) {
    return j < 0 ? (size_t)a[i] : (size_t)a[i] * (size_t)m->dom[j] + (size_t)a[j];
}

ham_status ham_energy(const ham_model *m, const int *a, mpq_t out) {
    if (!in_domain(m, a)) return HAM_ERR_ARG;
    mpq_t acc, t; mpq_init(acc); mpq_init(t);
    for (size_t k = 0; k < m->nv; k++) {
        mpq_mul(t, m->v[k].w, m->v[k].tab[a[m->v[k].var]]); mpq_add(acc, acc, t);
    }
    for (size_t k = 0; k < m->nc; k++) {
        const ham_cterm *x = &m->c[k];
        mpq_mul(t, x->J, x->tab[idx2(m, x->i, x->j, a)]); mpq_add(acc, acc, t);
    }
    for (size_t k = 0; k < m->ns; k++) {
        const ham_soft *x = &m->s[k];
        if (x->viol[idx2(m, x->i, x->j, a)]) mpq_add(acc, acc, x->u);
    }
    mpq_set(out, acc);
    mpq_clear(acc); mpq_clear(t);
    return HAM_OK;
}

ham_status ham_violations(const ham_model *m, const int *a, size_t *idx, size_t *nviol) {
    if (!in_domain(m, a)) return HAM_ERR_ARG;
    size_t c = 0;
    for (size_t k = 0; k < m->nh; k++)
        if (!m->h[k].ok[idx2(m, m->h[k].i, m->h[k].j, a)]) { if (idx) idx[c] = k; c++; }
    *nviol = c;
    return HAM_OK;
}

/* ---- satisfiability: deterministic backtracking in lexicographic order ---- */
typedef struct {
    const ham_model *m; const unsigned char *active;
    int a[HAM_MAX_VARS]; uint64_t nodes; int found;
} btctx;

static int consistent_at(const btctx *c, int v) {
    const ham_model *m = c->m;
    for (size_t k = 0; k < m->nh; k++) {
        if (c->active && !c->active[k]) continue;
        const ham_hard *h = &m->h[k];
        int mx = h->j > h->i ? h->j : h->i;
        if (mx != v) continue;
        if (!h->ok[idx2(m, h->i, h->j, c->a)]) return 0;
    }
    return 1;
}

static ham_status bt(btctx *c, int v) {
    if (v == c->m->n) { c->found = 1; return HAM_OK; }
    for (int val = 0; val < c->m->dom[v]; val++) {
        if (++c->nodes > c->m->node_limit) return HAM_ERR_LIMIT;
        c->a[v] = val;
        if (consistent_at(c, v)) {
            ham_status st = bt(c, v + 1);
            if (st != HAM_OK || c->found) return st;
        }
    }
    return HAM_OK;
}

ham_status ham_sat(const ham_model *m, const unsigned char *active, ham_sat_result *res) {
    btctx c;
    memset(&c, 0, sizeof c);
    c.m = m; c.active = active;
    ham_status st = bt(&c, 0);
    memset(res, 0, sizeof *res);
    res->nodes = c.nodes;
    if (st != HAM_OK) return st;          /* no answer claimed on limit */
    res->sat = c.found;
    if (c.found) memcpy(res->witness, c.a, (size_t)m->n * sizeof(int));
    return HAM_OK;
}

ham_status ham_conflict(const ham_model *m, unsigned char *in_mus, size_t *mus_n, int *is_sat) {
    ham_sat_result r;
    ham_status st = ham_sat(m, NULL, &r);
    *mus_n = 0;
    if (st != HAM_OK) return st;
    *is_sat = r.sat;
    for (size_t k = 0; k < m->nh; k++) in_mus[k] = r.sat ? 0 : 1;
    if (r.sat) return HAM_OK;
    /* deletion-based: drop k if the rest stays unsatisfiable */
    for (size_t k = 0; k < m->nh; k++) {
        in_mus[k] = 0;
        st = ham_sat(m, in_mus, &r);
        if (st != HAM_OK) return st;
        if (r.sat) in_mus[k] = 1;
    }
    for (size_t k = 0; k < m->nh; k++) *mus_n += in_mus[k];
    return HAM_OK;
}

static void sb_scope(sbuf *s, int i, int j) {
    sb_put(s, "x"); sb_int(s, i);
    if (j >= 0) { sb_put(s, ",x"); sb_int(s, j); }
}

ham_status ham_sat_report(const ham_model *m, char **out, size_t *len) {
    *out = NULL; *len = 0;
    ham_sat_result r;
    ham_status st = ham_sat(m, NULL, &r);
    ham_rec rec; ham_rec_init(&rec);
    char mc[65];
    ham_status cst = ham_model_commit(m, mc);
    if (cst != HAM_OK) return cst;
    ham_status s2 = ham_rec_add(&rec, "kind", HAM_KIND);
    if (s2 == HAM_OK) s2 = ham_rec_add(&rec, "model", mc);
    if (s2 == HAM_OK) s2 = ham_rec_addf(&rec, "hard_count", "%zu", m->nh);
    if (st == HAM_ERR_LIMIT) {
        if (s2 == HAM_OK) s2 = ham_rec_add(&rec, "report", "search_limit");
        if (s2 == HAM_OK) s2 = ham_rec_addf(&rec, "node_limit", "%llu", (unsigned long long)m->node_limit);
    } else if (st != HAM_OK) {
        ham_rec_free(&rec); return st;
    } else if (r.sat) {
        char *w = ham_assign_str(m, r.witness);
        mpq_t e; mpq_init(e);
        if (!w) s2 = HAM_ERR_NOMEM;
        if (s2 == HAM_OK) s2 = ham_rec_add(&rec, "report", "satisfiable");
        if (s2 == HAM_OK) s2 = ham_rec_add(&rec, "witness", w);
        if (s2 == HAM_OK) s2 = ham_energy(m, r.witness, e);
        if (s2 == HAM_OK) s2 = ham_rec_add_q(&rec, "witness_energy", e);
        if (s2 == HAM_OK) s2 = ham_rec_addf(&rec, "nodes", "%llu", (unsigned long long)r.nodes);
        mpq_clear(e); free(w);
    } else {
        unsigned char *mus = malloc(m->nh ? m->nh : 1);
        size_t mn = 0; int sat = 0;
        if (!mus) s2 = HAM_ERR_NOMEM;
        if (s2 == HAM_OK) {
            ham_status ms = ham_conflict(m, mus, &mn, &sat);
            if (ms == HAM_ERR_LIMIT) {
                s2 = ham_rec_add(&rec, "report", "unsatisfiable");
                if (s2 == HAM_OK) s2 = ham_rec_add(&rec, "conflict_status", "search_limit");
            } else if (ms != HAM_OK) s2 = ms;
            else {
                sbuf names = {0};
                int first = 1;
                s2 = ham_rec_add(&rec, "report", "unsatisfiable");
                for (size_t k = 0; s2 == HAM_OK && k < m->nh; k++) {
                    if (!mus[k]) continue;
                    if (!first) sb_put(&names, ",");
                    sb_put(&names, m->h[k].name); first = 0;
                    sbuf sc = {0}; char key[64];
                    sb_scope(&sc, m->h[k].i, m->h[k].j);
                    snprintf(key, sizeof key, "scope.%s", m->h[k].name);
                    s2 = add_sb(&rec, key, &sc);
                }
                if (s2 == HAM_OK) s2 = add_sb(&rec, "conflict", &names);
                else free(names.b);
                if (s2 == HAM_OK) s2 = ham_rec_addf(&rec, "conflict_size", "%zu", mn);
                if (s2 == HAM_OK) s2 = ham_rec_add(&rec, "conflict_status", "irreducible");
            }
        }
        if (s2 == HAM_OK) s2 = ham_rec_addf(&rec, "nodes", "%llu", (unsigned long long)r.nodes);
        free(mus);
    }
    if (s2 == HAM_OK) s2 = ham_rec_serialize(&rec, out, len);
    ham_rec_free(&rec);
    return s2;
}

ham_status ham_infeasibility_report(const ham_model *m, const int *a, char **out, size_t *len) {
    *out = NULL; *len = 0;
    if (!in_domain(m, a)) return HAM_ERR_ARG;
    size_t *idx = malloc((m->nh ? m->nh : 1) * sizeof *idx), nv = 0;
    if (!idx) return HAM_ERR_NOMEM;
    ham_status st = ham_violations(m, a, idx, &nv);
    char mc[65];
    if (st == HAM_OK) st = ham_model_commit(m, mc);
    ham_rec rec; ham_rec_init(&rec);
    char *as = ham_assign_str(m, a);
    if (st == HAM_OK && !as) st = HAM_ERR_NOMEM;
    if (st == HAM_OK) st = ham_rec_add(&rec, "kind", HAM_KIND);
    if (st == HAM_OK) st = ham_rec_add(&rec, "model", mc);
    if (st == HAM_OK) st = ham_rec_add(&rec, "report", nv ? "infeasible" : "feasible");
    if (st == HAM_OK) st = ham_rec_add(&rec, "assign", as);
    if (st == HAM_OK) st = ham_rec_addf(&rec, "violated_count", "%zu", nv);
    sbuf names = {0};
    for (size_t t = 0; st == HAM_OK && t < nv; t++) {
        const ham_hard *h = &m->h[idx[t]];
        if (t) sb_put(&names, ",");
        sb_put(&names, h->name);
        sbuf w = {0}; char key[64];
        sb_put(&w, "x"); sb_int(&w, h->i); sb_put(&w, "="); sb_int(&w, a[h->i]);
        if (h->j >= 0) { sb_put(&w, ",x"); sb_int(&w, h->j); sb_put(&w, "="); sb_int(&w, a[h->j]); }
        snprintf(key, sizeof key, "witness.%s", h->name);
        st = add_sb(&rec, key, &w);
    }
    if (st == HAM_OK) st = add_sb(&rec, "violated", &names); else free(names.b);
    if (st == HAM_OK) st = ham_rec_serialize(&rec, out, len);
    ham_rec_free(&rec); free(as); free(idx);
    return st;
}
