/* Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 * Dual-licensed: AGPL-3.0-or-later plus SnapKitty Opaque License (see LICENSE, SNAPKITTY_OPAQUE_LICENSE.md).
 * SPDX-License-Identifier: AGPL-3.0-or-later AND LicenseRef-SnapKitty-Opaque
 *
 * Test suite for the Frustration Hamiltonian Action-WORM engine (TASK 008).
 * Prints one line per test: "PASS <name>" | "FAIL <name> <why>" |
 * "UNAVAILABLE <name> <reason>". Exit status 1 iff any FAIL.
 *
 * Floating point appears ONLY in exact_* tests, as a witness that a double
 * comparison would have produced the wrong decision. The engine never uses it.
 */
#include "ham.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int g_fail = 0, g_pass = 0, g_unav = 0;
static char g_why[512];
static const char *g_golden_commit = NULL;

#define REQ(cond) do { if (!(cond)) { snprintf(g_why, sizeof g_why, "line %d: %s", __LINE__, #cond); return 0; } } while (0)
#define REQS(cond, ...) do { if (!(cond)) { snprintf(g_why, sizeof g_why, __VA_ARGS__); return 0; } } while (0)

typedef int (*test_fn)(void);
static void run(const char *name, test_fn f) {
    g_why[0] = 0;
    int r = f();
    if (r == 1) { printf("PASS %s\n", name); g_pass++; }
    else if (r == 2) { printf("UNAVAILABLE %s %s\n", name, g_why); g_unav++; }
    else { printf("FAIL %s %s\n", name, g_why); g_fail++; }
    fflush(stdout);
}

/* field lookup in a serialized record */
static char *field(const char *rec, size_t len, const char *key) {
    ham_rec r;
    if (ham_rec_parse(rec, len, &r) != HAM_OK) return NULL;
    const char *v = ham_rec_get(&r, key);
    char *out = NULL;
    if (v) { size_t l = strlen(v) + 1; out = malloc(l); if (out) memcpy(out, v, l); }
    ham_rec_free(&r);
    return out;
}
static int field_is(const char *rec, size_t len, const char *key, const char *want) {
    char *v = field(rec, len, key);
    int ok = v && strcmp(v, want) == 0;
    if (!ok) snprintf(g_why, sizeof g_why, "field %s = %s, want %s", key, v ? v : "(absent)", want);
    free(v);
    return ok;
}
static int field_absent(const char *rec, size_t len, const char *key) {
    char *v = field(rec, len, key);
    int ok = (v == NULL);
    free(v);
    return ok;
}

/* ---------- Model A: 2 vars x 3 values ----------
 * H = V0(x0) + V1(x1) + 1/2 [x0==x1],  hard no_22: not (x0=2 and x1=2)
 *   H(0,0)=5/2 H(1,0)=1 H(2,0)=0 H(0,1)=3 H(1,1)=5/2 H(2,1)=1 H(0,2)=7 H(1,2)=6 */
static void model_a(ham_model *m) {
    int dom[2] = {3, 3};
    ham_model_init(m, 2, dom);
    const char *v0[] = {"2", "1", "0"};
    const char *v1[] = {"0", "1", "5"};
    const char *eq[] = {"1","0","0", "0","1","0", "0","0","1"};
    unsigned char ok[9] = {1,1,1, 1,1,1, 1,1,0};
    ham_model_add_field(m, 0, "1", v0);
    ham_model_add_field(m, 1, "1", v1);
    ham_model_add_coupling(m, 0, 1, "1/2", eq);
    ham_model_add_hard(m, "no_22", 0, 1, ok);
}

typedef struct { char *b; size_t n; int acc; } dec;
static void dec_free(dec *d) { free(d->b); d->b = NULL; }

static int step(const ham_model *m, const ham_epoch_cfg *cfg, const ham_state *cur,
                int x0, int x1, dec *d, ham_state *next) {
    int a[2] = {x0, x1};
    char *p; size_t pl;
    if (ham_propose_step(m, cur, a, &p, &pl) != HAM_OK) return 0;
    ham_status st = ham_decide(m, cfg, cur, p, pl, &d->b, &d->n, &d->acc, next);
    free(p);
    return st == HAM_OK;
}

/* ================= tests ================= */
static int t_sha256_vectors(void) {
    struct { const char *in; const char *hex; } v[] = {
        {"", "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"},
        {"abc", "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad"},
        {"abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq",
         "248d6a61d20638b8e5c026930c3e6039a33ce45964ff2167f6ecedd419db06c1"}};
    unsigned char d[32]; char h[65];
    for (size_t i = 0; i < 3; i++) {
        ham_sha256(v[i].in, strlen(v[i].in), d); ham_hex(d, 32, h);
        REQS(strcmp(h, v[i].hex) == 0, "vector %zu: %s", i, h);
    }
    char *mil = malloc(1000000);
    REQ(mil);
    memset(mil, 'a', 1000000);
    ham_sha256(mil, 1000000, d); ham_hex(d, 32, h);
    free(mil);
    REQS(strcmp(h, "cdc76e5c9914fb9281a1c7e284d73e67f1809a48a497200e046d39ccc7112cd0") == 0, "million a: %s", h);
    return 1;
}

static int t_rec_canonical_bytes(void) {
    ham_rec r; ham_rec_init(&r);
    REQ(ham_rec_add(&r, "b", "2") == HAM_OK);
    REQ(ham_rec_add(&r, "a", "xy") == HAM_OK);
    char *s; size_t n;
    REQ(ham_rec_serialize(&r, &s, &n) == HAM_OK);
    const char *want = "LRD-REC-v1\n1:a2:xy\n1:b1:2\n";
    int ok = n == strlen(want) && memcmp(s, want, n) == 0;
    ham_rec q; int rt = ham_rec_parse(s, n, &q) == HAM_OK && q.n == 2;
    if (rt) ham_rec_free(&q);
    free(s);
    REQ(ok); REQ(rt);
    REQ(ham_rec_add(&r, "a", "dup") == HAM_OK);
    REQ(ham_rec_serialize(&r, &s, &n) == HAM_ERR_ARG);          /* duplicate key */
    ham_rec_free(&r);
    REQ(ham_rec_add(&r, "k", "line\nbreak") == HAM_ERR_ARG);   /* newline in value */
    ham_rec_free(&r);
    return 1;
}

static int t_rec_commit_matches_sha256sum(void) {
    if (!g_golden_commit) { snprintf(g_why, sizeof g_why, "no sha256sum cross-check value passed by run.sh"); return 2; }
    const char *rec = "LRD-REC-v1\n1:a2:xy\n1:b1:2\n";
    char h[65];
    REQ(ham_commit_bytes(rec, strlen(rec), h) == HAM_OK);
    REQS(strcmp(h, g_golden_commit) == 0, "engine %s vs sha256sum %s", h, g_golden_commit);
    return 1;
}

static int t_rec_parse_rejects(void) {
    const char *bad[] = {
        "LRD-REC-v2\n1:a1:1\n",          /* magic */
        "LRD-REC-v1\n1:b1:2\n1:a1:1\n",  /* unsorted */
        "LRD-REC-v1\n1:a1:1\n1:a1:2\n",  /* duplicate */
        "LRD-REC-v1\n01:a1:1\n",         /* leading zero length */
        "LRD-REC-v1\n1:a2:1\n",          /* wrong value length */
        "LRD-REC-v1\n1:a1:1",            /* missing newline */
        "LRD-REC-v1\n0:1:1\n",           /* empty key */
        "LRD-REC-v1\n2:ab1:1\n1:a1:1\n", /* prefix ordering: "a" < "ab" */
    };
    for (size_t i = 0; i < sizeof bad / sizeof bad[0]; i++) {
        ham_rec r;
        REQS(ham_rec_parse(bad[i], strlen(bad[i]), &r) == HAM_ERR_PARSE, "accepted bad record %zu", i);
    }
    ham_rec r;
    const char *good = "LRD-REC-v1\n1:a0:\n2:ab1:1\n";
    REQ(ham_rec_parse(good, strlen(good), &r) == HAM_OK && r.n == 2);
    ham_rec_free(&r);
    return 1;
}

static int t_rational_canonical(void) {
    mpq_t q; mpq_init(q);
    struct { const char *in, *out; } c[] = {
        {"0", "0/1"}, {"-0", "0/1"}, {"6/4", "3/2"}, {"-2/6", "-1/3"}, {"5", "5/1"},
        {"000123/0006", "41/2"},
        {"340282366920938463463374607431768211457/2", "340282366920938463463374607431768211457/2"}};
    for (size_t i = 0; i < sizeof c / sizeof c[0]; i++) {
        if (ham_q_set(q, c[i].in) != HAM_OK) { mpq_clear(q); REQS(0, "lenient rejected %s", c[i].in); }
        char *s = ham_q_str(q);
        int ok = s && strcmp(s, c[i].out) == 0;
        free(s);
        if (!ok) { mpq_clear(q); REQS(0, "%s -> wrong canonical form", c[i].in); }
    }
    const char *bad_lenient[] = {"1/0", "", "-", "1/", "/2", "1.5", "1e3", " 1", "--1", "+1"};
    for (size_t i = 0; i < sizeof bad_lenient / sizeof bad_lenient[0]; i++)
        if (ham_q_set(q, bad_lenient[i]) == HAM_OK) { mpq_clear(q); REQS(0, "lenient accepted '%s'", bad_lenient[i]); }
    const char *bad_strict[] = {"2/4", "-0/1", "0/2", "01/2", "1/02", "3", "1/-2", "-1/0"};
    for (size_t i = 0; i < sizeof bad_strict / sizeof bad_strict[0]; i++)
        if (ham_q_parse_canonical(q, bad_strict[i]) == HAM_OK) { mpq_clear(q); REQS(0, "strict accepted '%s'", bad_strict[i]); }
    const char *good_strict[] = {"0/1", "-7/3", "1/1"};
    for (size_t i = 0; i < 3; i++)
        if (ham_q_parse_canonical(q, good_strict[i]) != HAM_OK) { mpq_clear(q); REQS(0, "strict rejected '%s'", good_strict[i]); }
    mpq_clear(q);
    return 1;
}

static int t_energy_exact_model_a(void) {
    ham_model m; model_a(&m);
    const char *want[3][3] = {{"5/2", "3/1", "7/1"}, {"1/1", "5/2", "6/1"}, {"0/1", "1/1", "1/1"}};
    mpq_t e; mpq_init(e);
    int ok = 1;
    for (int x0 = 0; x0 < 3 && ok; x0++)
        for (int x1 = 0; x1 < 3 && ok; x1++) {
            int a[2] = {x0, x1};
            ham_energy(&m, a, e);
            char *s = ham_q_str(e);
            /* (2,2): energy is defined arithmetically (V0=0, V1=5, eq=1/2 -> 11/2) but infeasible */
            const char *w = (x0 == 2 && x1 == 2) ? "11/2" : want[x0][x1];
            if (strcmp(s, w) != 0) { snprintf(g_why, sizeof g_why, "H(%d,%d)=%s want %s", x0, x1, s, w); ok = 0; }
            free(s);
        }
    mpq_clear(e); ham_model_free(&m);
    return ok;
}

static int t_satisfiable(void) {
    int dom[4] = {2, 2, 2, 2};
    ham_model m; ham_model_init(&m, 4, dom);
    unsigned char neq[4] = {0, 1, 1, 0}, z[2] = {1, 0};
    ham_model_add_hard(&m, "x3_zero", 3, -1, z);
    ham_model_add_hard(&m, "neq01", 0, 1, neq);
    ham_model_add_hard(&m, "neq12", 1, 2, neq);
    ham_sat_result r;
    REQ(ham_sat(&m, NULL, &r) == HAM_OK);
    REQ(r.sat == 1);
    REQ(r.witness[0] == 0 && r.witness[1] == 1 && r.witness[2] == 0 && r.witness[3] == 0);
    size_t nv; REQ(ham_violations(&m, r.witness, NULL, &nv) == HAM_OK && nv == 0);
    char *rep; size_t rl;
    REQ(ham_sat_report(&m, &rep, &rl) == HAM_OK);
    int ok = field_is(rep, rl, "report", "satisfiable") && field_is(rep, rl, "witness", "0,1,0,0") &&
             field_is(rep, rl, "witness_energy", "0/1") && field_is(rep, rl, "kind", "hamiltonian_step");
    free(rep); ham_model_free(&m);
    return ok;
}

static void model_triangle(ham_model *m) {
    int dom[4] = {2, 2, 2, 2};
    ham_model_init(m, 4, dom);
    unsigned char neq[4] = {0, 1, 1, 0}, z[2] = {1, 0}, all[4] = {1, 1, 1, 1};
    ham_model_add_hard(m, "x3_zero", 3, -1, z);
    ham_model_add_hard(m, "neq01", 0, 1, neq);
    ham_model_add_hard(m, "loose", 0, 3, all);
    ham_model_add_hard(m, "neq12", 1, 2, neq);
    ham_model_add_hard(m, "neq02", 0, 2, neq);
}

static int t_unsatisfiable(void) {
    ham_model m; model_triangle(&m);
    ham_sat_result r;
    REQ(ham_sat(&m, NULL, &r) == HAM_OK);
    REQ(r.sat == 0);
    /* exhaustive cross-check over all 16 states */
    int any = 0;
    for (int s = 0; s < 16; s++) {
        int a[4] = {s & 1, (s >> 1) & 1, (s >> 2) & 1, (s >> 3) & 1};
        size_t nv; ham_violations(&m, a, NULL, &nv);
        if (nv == 0) any = 1;
    }
    REQ(!any);
    ham_model_free(&m);
    return 1;
}

static int t_conflict_report(void) {
    ham_model m; model_triangle(&m);
    unsigned char mus[5]; size_t mn; int sat;
    REQ(ham_conflict(&m, mus, &mn, &sat) == HAM_OK);
    REQ(sat == 0 && mn == 3);
    REQ(!mus[0] && mus[1] && !mus[2] && mus[3] && mus[4]);
    /* irreducible: dropping any member makes the rest satisfiable */
    for (int k = 0; k < 5; k++) {
        if (!mus[k]) continue;
        unsigned char act[5]; memcpy(act, mus, 5); act[k] = 0;
        ham_sat_result r; REQ(ham_sat(&m, act, &r) == HAM_OK); REQS(r.sat == 1, "MUS not minimal at %d", k);
    }
    ham_sat_result r; REQ(ham_sat(&m, mus, &r) == HAM_OK && r.sat == 0);
    char *rep; size_t rl;
    REQ(ham_sat_report(&m, &rep, &rl) == HAM_OK);
    int ok = field_is(rep, rl, "report", "unsatisfiable") &&
             field_is(rep, rl, "conflict", "neq01,neq12,neq02") &&
             field_is(rep, rl, "conflict_size", "3") &&
             field_is(rep, rl, "conflict_status", "irreducible") &&
             field_is(rep, rl, "scope.neq01", "x0,x1") &&
             field_is(rep, rl, "scope.neq02", "x0,x2") &&
             field_absent(rep, rl, "scope.loose") && field_absent(rep, rl, "scope.x3_zero");
    free(rep); ham_model_free(&m);
    return ok;
}

static int t_conflict_single_empty_constraint(void) {
    int dom[3] = {3, 3, 3};
    ham_model m; ham_model_init(&m, 3, dom);
    unsigned char none[3] = {0, 0, 0}, some[3] = {1, 0, 1};
    ham_model_add_hard(&m, "a", 0, -1, some);
    ham_model_add_hard(&m, "never", 1, -1, none);
    ham_model_add_hard(&m, "b", 2, -1, some);
    unsigned char mus[3]; size_t mn; int sat;
    REQ(ham_conflict(&m, mus, &mn, &sat) == HAM_OK);
    REQ(sat == 0 && mn == 1 && !mus[0] && mus[1] && !mus[2]);
    ham_model_free(&m);
    return 1;
}

static int t_search_limit_explicit(void) {
    int dom[24]; for (int i = 0; i < 24; i++) dom[i] = 2;
    ham_model m; ham_model_init(&m, 24, dom);
    unsigned char none[2] = {0, 0};
    ham_model_add_hard(&m, "last_never", 23, -1, none);
    m.node_limit = 1000;
    ham_sat_result r;
    REQ(ham_sat(&m, NULL, &r) == HAM_ERR_LIMIT);              /* no sat/unsat claimed */
    char *rep; size_t rl;
    REQ(ham_sat_report(&m, &rep, &rl) == HAM_OK);
    int ok = field_is(rep, rl, "report", "search_limit") && field_is(rep, rl, "node_limit", "1000");
    free(rep);
    m.node_limit = 100000000;
    REQ(ham_sat(&m, NULL, &r) == HAM_OK && r.sat == 0);
    ham_model_free(&m);
    return ok;
}

static int t_genesis_infeasible_no_state(void) {
    ham_model m; model_a(&m);
    ham_epoch_cfg cfg = {4, 2};
    ham_state out; memset(&out, 0xA5, sizeof out);
    unsigned char snap[sizeof out]; memcpy(snap, &out, sizeof out);
    uint64_t c0 = ham_states_constructed();
    int a[2] = {2, 2};
    char *rep; size_t rl;
    REQ(ham_state_genesis(&m, &cfg, a, &out, &rep, &rl) == HAM_ERR_INFEASIBLE);
    REQ(memcmp(&out, snap, sizeof out) == 0);
    REQ(ham_states_constructed() == c0);
    int ok = field_is(rep, rl, "report", "infeasible") && field_is(rep, rl, "violated", "no_22") &&
             field_is(rep, rl, "violated_count", "1") && field_is(rep, rl, "witness.no_22", "x0=2,x1=2") &&
             field_is(rep, rl, "assign", "2,2");
    free(rep);
    int oob[2] = {3, 0};
    REQ(ham_state_genesis(&m, &cfg, oob, &out, NULL, NULL) == HAM_ERR_ARG);
    REQ(memcmp(&out, snap, sizeof out) == 0 && ham_states_constructed() == c0);
    ham_model_free(&m);
    return ok;
}

static int t_genesis_state_fields(void) {
    ham_model m; model_a(&m);
    ham_epoch_cfg cfg = {4, 2};
    ham_state s; int a[2] = {0, 0};
    REQ(ham_state_genesis(&m, &cfg, a, &s, NULL, NULL) == HAM_OK);
    lrd_state_t v; ham_state_view(&s, &v);
    int ok = v.seq == 0 && strcmp(v.commit, LRD_GENESIS_COMMIT) == 0 &&
             v.kind == LRD_KIND_HAMILTONIAN_STEP && strcmp(lrd_kind_token(v.kind), HAM_KIND) == 0 &&
             lrd_is_hex256(v.payload_sha256) && lrd_is_hex256(s.self_commit) && strlen(v.payload_sha256) == 64 &&
             strlen(s.self_commit) == 64 && strcmp(s.self_commit, LRD_GENESIS_COMMIT) != 0;
    char *e = ham_q_str(s.energy);
    ok = ok && strcmp(e, "5/2") == 0;
    free(e);
    ham_state_free(&s); ham_model_free(&m);
    REQ(ok);
    return 1;
}

static int t_valid_descent_accepted(void) {
    ham_model m; model_a(&m);
    ham_epoch_cfg cfg = {4, 2};
    ham_state s0, s1, s2; int a[2] = {0, 0};
    REQ(ham_state_genesis(&m, &cfg, a, &s0, NULL, NULL) == HAM_OK);
    dec d = {0};
    REQ(step(&m, &cfg, &s0, 1, 0, &d, &s1));
    int ok = d.acc && field_is(d.b, d.n, "decision", "ACCEPT") && field_is(d.b, d.n, "reason", "ok") &&
             field_is(d.b, d.n, "energy_prev", "5/2") && field_is(d.b, d.n, "energy_cand", "1/1") &&
             field_is(d.b, d.n, "energy_delta", "-3/2") && field_is(d.b, d.n, "kind", "hamiltonian_step") &&
             field_is(d.b, d.n, "seq", "1") && field_is(d.b, d.n, "epoch_steps_after", "1");
    char *nc = field(d.b, d.n, "new_commit");
    ok = ok && nc && strcmp(nc, s1.self_commit) == 0 && s1.seq == 1 &&
         strcmp(s1.prev_commit, s0.self_commit) == 0 && s1.steps_used == 1 && s1.epoch == 0 &&
         s1.assign[0] == 1 && s1.assign[1] == 0;
    free(nc); dec_free(&d);
    if (!ok) { ham_state_free(&s0); if (s1.n) ham_state_free(&s1); ham_model_free(&m); return 0; }
    /* chain a second descent: 1 -> 0 */
    REQ(step(&m, &cfg, &s1, 2, 0, &d, &s2));
    ok = d.acc && field_is(d.b, d.n, "energy_cand", "0/1") && s2.seq == 2 &&
         strcmp(s2.prev_commit, s1.self_commit) == 0;
    dec_free(&d);
    ham_state_free(&s0); ham_state_free(&s1); if (ok) ham_state_free(&s2);
    ham_model_free(&m);
    return ok;
}

static int expect_reject(const char *rec, size_t n, int acc, const char *reason) {
    if (acc) { snprintf(g_why, sizeof g_why, "accepted, want REJECT %s", reason); return 0; }
    return field_is(rec, n, "decision", "REJECT") && field_is(rec, n, "reason", reason) &&
           field_absent(rec, n, "new_commit");
}

static int t_equal_energy_rejected(void) {
    ham_model m; model_a(&m);
    ham_epoch_cfg cfg = {4, 2};
    ham_state s0, nx; memset(&nx, 0x5A, sizeof nx);
    int a[2] = {0, 0};
    REQ(ham_state_genesis(&m, &cfg, a, &s0, NULL, NULL) == HAM_OK);
    dec d = {0};
    REQ(step(&m, &cfg, &s0, 1, 1, &d, &nx));            /* 5/2 -> 5/2 */
    int ok = expect_reject(d.b, d.n, d.acc, "energy_not_decreasing") &&
             field_is(d.b, d.n, "energy_delta", "0/1") && field_is(d.b, d.n, "energy_cand", "5/2");
    dec_free(&d);
    REQ(step(&m, &cfg, &s0, 0, 0, &d, &nx));            /* self-loop */
    ok = ok && expect_reject(d.b, d.n, d.acc, "energy_not_decreasing");
    dec_free(&d); ham_state_free(&s0); ham_model_free(&m);
    return ok;
}

static int t_energy_increasing_rejected(void) {
    ham_model m; model_a(&m);
    ham_epoch_cfg cfg = {4, 2};
    ham_state s0, nx;
    int a[2] = {1, 0};
    REQ(ham_state_genesis(&m, &cfg, a, &s0, NULL, NULL) == HAM_OK);
    dec d = {0};
    REQ(step(&m, &cfg, &s0, 0, 1, &d, &nx));            /* 1 -> 3 */
    int ok = expect_reject(d.b, d.n, d.acc, "energy_not_decreasing") &&
             field_is(d.b, d.n, "energy_delta", "2/1");
    dec_free(&d); ham_state_free(&s0); ham_model_free(&m);
    return ok;
}

static int t_infeasible_transition_rejected(void) {
    ham_model m; model_a(&m);
    ham_epoch_cfg cfg = {4, 2};
    ham_state s0, nx;
    int a[2] = {1, 2};                                   /* H=6 */
    REQ(ham_state_genesis(&m, &cfg, a, &s0, NULL, NULL) == HAM_OK);
    dec d = {0};
    REQ(step(&m, &cfg, &s0, 2, 2, &d, &nx));            /* H would be 11/2 < 6, but infeasible */
    int ok = expect_reject(d.b, d.n, d.acc, "infeasible") && field_is(d.b, d.n, "violated", "no_22") &&
             field_is(d.b, d.n, "violated_count", "1") && field_absent(d.b, d.n, "energy_cand");
    dec_free(&d); ham_state_free(&s0); ham_model_free(&m);
    return ok;
}

static int t_epoch_exhausted(void) {
    ham_model m; model_a(&m);
    ham_epoch_cfg cfg = {2, 2};
    ham_state s0, s1, s2, nx;
    int a[2] = {0, 1};                                   /* H=3 */
    REQ(ham_state_genesis(&m, &cfg, a, &s0, NULL, NULL) == HAM_OK);
    dec d = {0};
    REQ(step(&m, &cfg, &s0, 0, 0, &d, &s1) && d.acc); dec_free(&d);    /* 5/2 */
    REQ(step(&m, &cfg, &s1, 1, 0, &d, &s2) && d.acc); dec_free(&d);    /* 1 */
    REQ(s2.steps_used == 2);
    REQ(step(&m, &cfg, &s2, 2, 0, &d, &nx));                           /* would descend to 0 */
    int ok = expect_reject(d.b, d.n, d.acc, "epoch_exhausted") && field_is(d.b, d.n, "epoch_steps_used", "2") &&
             field_is(d.b, d.n, "epoch_budget", "2");
    dec_free(&d);
    ham_state_free(&s0); ham_state_free(&s1); ham_state_free(&s2); ham_model_free(&m);
    return ok;
}

static int t_epoch_transition_explicit(void) {
    ham_model m; model_a(&m);
    ham_epoch_cfg cfg = {1, 2};
    ham_state s0, s1, s2, s3, nx;
    int a[2] = {0, 0};
    REQ(ham_state_genesis(&m, &cfg, a, &s0, NULL, NULL) == HAM_OK);
    dec d = {0};
    REQ(step(&m, &cfg, &s0, 1, 0, &d, &s1) && d.acc); dec_free(&d);
    REQ(step(&m, &cfg, &s1, 2, 0, &d, &nx) && !d.acc); dec_free(&d);   /* budget 1 exhausted */
    char *p; size_t pl;
    REQ(ham_propose_epoch_advance(&m, &s1, &p, &pl) == HAM_OK);
    REQ(ham_decide(&m, &cfg, &s1, p, pl, &d.b, &d.n, &d.acc, &s2) == HAM_OK);
    free(p);
    int ok = d.acc && field_is(d.b, d.n, "op", "epoch_advance") && field_is(d.b, d.n, "epoch", "1") &&
             field_is(d.b, d.n, "epoch_steps_after", "0") && s2.epoch == 1 && s2.steps_used == 0 &&
             s2.seq == 2 && mpq_cmp(s2.energy, s1.energy) == 0 && s2.assign[0] == 1 &&
             strcmp(s2.prev_commit, s1.self_commit) == 0;
    dec_free(&d);
    REQ(ok);
    /* descent resumes in epoch 1 */
    REQ(step(&m, &cfg, &s2, 2, 0, &d, &s3) && d.acc && s3.epoch == 1 && s3.steps_used == 1); dec_free(&d);
    /* epoch 2 would be >= max_epochs=2 */
    REQ(ham_propose_epoch_advance(&m, &s3, &p, &pl) == HAM_OK);
    REQ(ham_decide(&m, &cfg, &s3, p, pl, &d.b, &d.n, &d.acc, &nx) == HAM_OK);
    free(p);
    ok = expect_reject(d.b, d.n, d.acc, "epoch_exhausted");
    dec_free(&d);
    ham_state_free(&s0); ham_state_free(&s1); ham_state_free(&s2); ham_state_free(&s3); ham_model_free(&m);
    return ok;
}

/* hand-built proposal: lets tests forge each envelope fault precisely */
static int mkprop(const ham_model *m, const char *kind, const char *op, unsigned long long seq,
                  const char *prev, const char *assign, unsigned epoch, unsigned pay_epoch_step,
                  const char *pay_override, const char *extra_key, char **out, size_t *len) {
    char ph[65];
    if (pay_override) snprintf(ph, sizeof ph, "%s", pay_override);
    else if (ham_payload_sha256(m, op, assign, epoch, pay_epoch_step, ph) != HAM_OK) return 0;
    ham_rec r; ham_rec_init(&r);
    ham_rec_add(&r, "kind", kind); ham_rec_add(&r, "op", op);
    ham_rec_addf(&r, "seq", "%llu", seq); ham_rec_add(&r, "prev_commit", prev);
    ham_rec_add(&r, "payload_sha256", ph); ham_rec_add(&r, "assign", assign);
    ham_rec_addf(&r, "epoch", "%u", epoch);
    if (extra_key) ham_rec_add(&r, extra_key, "x");
    int ok = ham_rec_serialize(&r, out, len) == HAM_OK;
    ham_rec_free(&r);
    return ok;
}

static int decide_raw(const ham_model *m, const ham_epoch_cfg *cfg, const ham_state *cur,
                      const char *p, size_t pl, dec *d, ham_state *nx) {
    return ham_decide(m, cfg, cur, p, pl, &d->b, &d->n, &d->acc, nx) == HAM_OK;
}

static int t_envelope_rejects(void) {
    ham_model m; model_a(&m);
    ham_epoch_cfg cfg = {4, 2};
    ham_state s0, nx;
    int a[2] = {0, 0};
    REQ(ham_state_genesis(&m, &cfg, a, &s0, NULL, NULL) == HAM_OK);
    const char *P = s0.self_commit;
    struct { const char *kind, *op; unsigned long long seq; const char *prev, *assign;
             unsigned ep, pes; const char *pay, *extra, *want; } c[] = {
        {"hamiltonian_step", "step", 0, P, "1,0", 0, 1, NULL, NULL, "stale_seq"},
        {"hamiltonian_step", "step", 2, P, "1,0", 0, 1, NULL, NULL, "stale_seq"},
        {"hamiltonian_step", "step", 1, LRD_GENESIS_COMMIT, "1,0", 0, 1, NULL, NULL, "bad_prev"},
        {"hamiltonian_step", "step", 1, P, "1,0", 0, 1,
         "1111111111111111111111111111111111111111111111111111111111111111", NULL, "bad_payload"},
        {"hamiltonian_step", "step", 1, P, "1,0", 0, 5, NULL, NULL, "bad_payload"},  /* wrong epoch_step bound */
        {"ledger_append", "step", 1, P, "1,0", 0, 1, NULL, NULL, "wrong_kind"},
        {"hamiltonian_step", "jump", 1, P, "1,0", 0, 1, NULL, NULL, "malformed"},
        {"hamiltonian_step", "step", 1, P, "3,0", 0, 1, NULL, NULL, "malformed"},    /* outside D */
        {"hamiltonian_step", "step", 1, P, "1", 0, 1, NULL, NULL, "malformed"},
        {"hamiltonian_step", "step", 1, P, "01,0", 0, 1, NULL, NULL, "malformed"},
        {"hamiltonian_step", "step", 1, P, "1,0", 0, 1, NULL, "zzz", "malformed"},   /* unknown field */
        {"hamiltonian_step", "step", 1, P, "1,0", 1, 1, NULL, NULL, "bad_epoch"},
        {"hamiltonian_step", "epoch_advance", 1, P, "0,0", 2, 0, NULL, NULL, "bad_epoch"},  /* skip */
        {"hamiltonian_step", "epoch_advance", 1, P, "1,0", 1, 0, NULL, NULL, "bad_epoch"},  /* moves state */
    };
    int ok = 1;
    for (size_t i = 0; i < sizeof c / sizeof c[0] && ok; i++) {
        char *p; size_t pl; dec d = {0};
        REQ(mkprop(&m, c[i].kind, c[i].op, c[i].seq, c[i].prev, c[i].assign, c[i].ep, c[i].pes,
                   c[i].pay, c[i].extra, &p, &pl));
        REQ(decide_raw(&m, &cfg, &s0, p, pl, &d, &nx));
        if (!expect_reject(d.b, d.n, d.acc, c[i].want)) {
            char tmp[512]; snprintf(tmp, sizeof tmp, "case %zu: %.400s", i, g_why); memcpy(g_why, tmp, sizeof tmp); ok = 0;
        }
        free(p); dec_free(&d);
    }
    /* raw garbage and empty input */
    const char *garbage[] = {"", "hello", "LRD-REC-v1\n1:b1:2\n1:a1:1\n"};
    for (size_t i = 0; i < 3 && ok; i++) {
        dec d = {0};
        REQ(decide_raw(&m, &cfg, &s0, garbage[i], strlen(garbage[i]), &d, &nx));
        ok = expect_reject(d.b, d.n, d.acc, "malformed");
        dec_free(&d);
    }
    ham_state_free(&s0); ham_model_free(&m);
    return ok;
}

static int t_replay_rejected(void) {
    ham_model m; model_a(&m);
    ham_epoch_cfg cfg = {4, 2};
    ham_state s0, s1, nx; int a[2] = {0, 0};
    REQ(ham_state_genesis(&m, &cfg, a, &s0, NULL, NULL) == HAM_OK);
    int b[2] = {1, 0}; char *p; size_t pl; dec d = {0};
    REQ(ham_propose_step(&m, &s0, b, &p, &pl) == HAM_OK);
    REQ(decide_raw(&m, &cfg, &s0, p, pl, &d, &s1) && d.acc); dec_free(&d);
    REQ(decide_raw(&m, &cfg, &s1, p, pl, &d, &nx));
    int ok = expect_reject(d.b, d.n, d.acc, "stale_seq");
    free(p); dec_free(&d); ham_state_free(&s0); ham_state_free(&s1); ham_model_free(&m);
    return ok;
}

static int t_reject_never_constructs_state(void) {
    ham_model m; model_a(&m);
    ham_epoch_cfg cfg = {1, 1};
    ham_state s0, s1; int a[2] = {1, 2};                 /* H=6 */
    REQ(ham_state_genesis(&m, &cfg, a, &s0, NULL, NULL) == HAM_OK);
    ham_state nx; memset(&nx, 0xA5, sizeof nx);
    unsigned char snap[sizeof nx]; memcpy(snap, &nx, sizeof nx);
    unsigned char cur_snap[sizeof s0]; memcpy(cur_snap, &s0, sizeof s0);
    uint64_t c0 = ham_states_constructed();
    int cand[][2] = {{2, 2} /* infeasible */, {0, 2} /* increasing */, {1, 2} /* equal */};
    const char *why[] = {"infeasible", "energy_not_decreasing", "energy_not_decreasing"};
    for (int i = 0; i < 3; i++) {
        dec d = {0};
        REQ(step(&m, &cfg, &s0, cand[i][0], cand[i][1], &d, &nx));
        int ok = expect_reject(d.b, d.n, d.acc, why[i]);
        dec_free(&d);
        if (!ok) return 0;
        REQS(memcmp(&nx, snap, sizeof nx) == 0, "next written on reject %d", i);
        REQS(ham_states_constructed() == c0, "state constructed on reject %d", i);
    }
    /* exhaust budget, then epoch_exhausted (step) and epoch_exhausted (advance) */
    dec d = {0};
    REQ(step(&m, &cfg, &s0, 1, 0, &d, &s1) && d.acc); dec_free(&d);
    c0 = ham_states_constructed();
    REQ(step(&m, &cfg, &s1, 2, 0, &d, &nx)); REQ(expect_reject(d.b, d.n, d.acc, "epoch_exhausted")); dec_free(&d);
    char *p; size_t pl;
    REQ(ham_propose_epoch_advance(&m, &s1, &p, &pl) == HAM_OK);
    REQ(decide_raw(&m, &cfg, &s1, p, pl, &d, &nx)); free(p);
    REQ(expect_reject(d.b, d.n, d.acc, "epoch_exhausted")); dec_free(&d);
    REQ(decide_raw(&m, &cfg, &s1, "junk", 4, &d, &nx)); REQ(expect_reject(d.b, d.n, d.acc, "malformed")); dec_free(&d);
    REQ(memcmp(&nx, snap, sizeof nx) == 0);
    REQ(ham_states_constructed() == c0);
    REQ(memcmp(&s0, cur_snap, sizeof s0) == 0);          /* current state unchanged too */
    ham_state_free(&s0); ham_state_free(&s1); ham_model_free(&m);
    return 1;
}

/* run a fixed script on a freshly built model; return concatenated decisions */
static char *script(size_t *outlen) {
    ham_model m; model_a(&m);
    ham_epoch_cfg cfg = {2, 3};
    ham_state st[8]; int ns = 0;
    int a[2] = {0, 2};                                   /* H=7 */
    if (ham_state_genesis(&m, &cfg, a, &st[0], NULL, NULL) != HAM_OK) return NULL;
    ns = 1;
    int moves[][3] = {{0,1,1},{2,2,0},{0,2,0},{0,0,0},{1,0,0},{2,0,0},{-1,0,0},{2,0,0},{2,1,0}};
    char *all = NULL; size_t n = 0;
    for (size_t i = 0; i < sizeof moves / sizeof moves[0]; i++) {
        char *p; size_t pl; dec d = {0};
        ham_state *cur = &st[ns - 1];
        if (moves[i][0] < 0) ham_propose_epoch_advance(&m, cur, &p, &pl);
        else { int b[2] = {moves[i][0], moves[i][1]}; ham_propose_step(&m, cur, b, &p, &pl); }
        ham_decide(&m, &cfg, cur, p, pl, &d.b, &d.n, &d.acc, &st[ns]);
        if (d.acc) ns++;
        all = realloc(all, n + d.n);
        memcpy(all + n, d.b, d.n); n += d.n;
        free(p); dec_free(&d);
    }
    for (int i = 0; i < ns; i++) ham_state_free(&st[i]);
    ham_model_free(&m);
    *outlen = n;
    return all;
}

static int t_determinism_bytes(void) {
    size_t n1, n2;
    char *a = script(&n1);
    REQ(a);
    for (int rep = 0; rep < 50; rep++) {
        char *b = script(&n2);
        int same = b && n1 == n2 && memcmp(a, b, n1) == 0;
        free(b);
        if (!same) { free(a); REQS(0, "run %d differs", rep); }
    }
    /* same proposal decided repeatedly against one state: identical bytes */
    ham_model m; model_a(&m);
    ham_epoch_cfg cfg = {2, 3};
    ham_state s0, nx; int g[2] = {0, 0};
    ham_state_genesis(&m, &cfg, g, &s0, NULL, NULL);
    int c[2] = {1, 1}; char *p; size_t pl; dec d0 = {0};
    ham_propose_step(&m, &s0, c, &p, &pl);
    decide_raw(&m, &cfg, &s0, p, pl, &d0, &nx);
    int ok = !d0.acc;
    for (int rep = 0; rep < 100 && ok; rep++) {
        dec d = {0};
        decide_raw(&m, &cfg, &s0, p, pl, &d, &nx);
        ok = d.n == d0.n && memcmp(d.b, d0.b, d.n) == 0;
        dec_free(&d);
    }
    free(p); dec_free(&d0); free(a); ham_state_free(&s0); ham_model_free(&m);
    REQ(ok);
    return 1;
}

static int t_script_expected_reasons(void) {
    /* same script as determinism; check the reason sequence is what the spec says */
    size_t n; char *all = script(&n);
    REQ(all);
    const char *want[] = {"ok", "infeasible", "energy_not_decreasing", "ok", "epoch_exhausted",
                          "epoch_exhausted", "ok", "ok", "energy_not_decreasing"};
    /* split on record magic */
    size_t i = 0, pos = 0;
    int ok = 1;
    while (pos < n && ok) {
        size_t end = pos + 1;
        while (end < n && !(end + LRD_REC_MAGIC_LEN <= n && memcmp(all + end, LRD_REC_MAGIC, LRD_REC_MAGIC_LEN) == 0)) end++;
        if (i >= 9) { ok = 0; snprintf(g_why, sizeof g_why, "too many records"); break; }
        ok = field_is(all + pos, end - pos, "reason", want[i]);
        if (!ok) { char t[512]; snprintf(t, sizeof t, "decision %zu: %.400s", i, g_why); memcpy(g_why, t, sizeof t); }
        i++; pos = end;
    }
    free(all);
    if (ok && i != 9) { snprintf(g_why, sizeof g_why, "got %zu records", i); ok = 0; }
    return ok;
}

/* ---- exact arithmetic edge cases ---- */
static void one_var(ham_model *m) { int dom[1] = {2}; ham_model_init(m, 1, dom); }

static int t_exact_thirds_equal(void) {
    ham_model m; one_var(&m);
    const char *t3[] = {"1/3", "0"}, *one[] = {"0", "1"};
    ham_model_add_field(&m, 0, "1", t3); ham_model_add_field(&m, 0, "1", t3);
    ham_model_add_field(&m, 0, "1", t3); ham_model_add_field(&m, 0, "1", one);
    ham_epoch_cfg cfg = {4, 1};
    ham_state s0, nx; int a[1] = {0};
    REQ(ham_state_genesis(&m, &cfg, a, &s0, NULL, NULL) == HAM_OK);
    char *e = ham_q_str(s0.energy); int is1 = strcmp(e, "1/1") == 0; free(e);
    REQ(is1);
    int b[1] = {1}; char *p; size_t pl; dec d = {0};
    REQ(ham_propose_step(&m, &s0, b, &p, &pl) == HAM_OK);
    REQ(decide_raw(&m, &cfg, &s0, p, pl, &d, &nx));
    int ok = expect_reject(d.b, d.n, d.acc, "energy_not_decreasing") && field_is(d.b, d.n, "energy_delta", "0/1");
    free(p); dec_free(&d); ham_state_free(&s0); ham_model_free(&m);
    return ok;
}

static int t_exact_tenths_double_would_accept(void) {
    /* H(0) = 1/10 + 2/10, H(1) = 3/10 exactly equal. In binary64,
     * 0.1+0.2 = 0.30000000000000004 > 0.3, so a double engine would ACCEPT 0->1. */
    volatile double x = 0.1, y = 0.2, z = 0.3;
    int double_accepts = (z < x + y);
    if (!double_accepts) { snprintf(g_why, sizeof g_why, "platform double did not exhibit rounding; witness void"); return 2; }
    ham_model m; one_var(&m);
    const char *f1[] = {"1/10", "3/10"}, *f2[] = {"2/10", "0"};
    ham_model_add_field(&m, 0, "1", f1); ham_model_add_field(&m, 0, "1", f2);
    ham_epoch_cfg cfg = {4, 1};
    ham_state s0, nx; int a[1] = {0};
    REQ(ham_state_genesis(&m, &cfg, a, &s0, NULL, NULL) == HAM_OK);
    int b[1] = {1}; char *p; size_t pl; dec d = {0};
    REQ(ham_propose_step(&m, &s0, b, &p, &pl) == HAM_OK);
    REQ(decide_raw(&m, &cfg, &s0, p, pl, &d, &nx));
    int ok = expect_reject(d.b, d.n, d.acc, "energy_not_decreasing") &&
             field_is(d.b, d.n, "energy_prev", "3/10") && field_is(d.b, d.n, "energy_cand", "3/10");
    free(p); dec_free(&d); ham_state_free(&s0); ham_model_free(&m);
    return ok;
}

static int t_exact_huge_values(void) {
    /* H(0) = (10^40+1)/10^40, H(1) = 1: doubles see equal (both 1.0); exact descent. */
    const char *big = "10000000000000000000000000000000000000001/10000000000000000000000000000000000000000";
    volatile double hb = 1.0 + 1e-40, h1 = 1.0;
    if (!(hb == h1)) { snprintf(g_why, sizeof g_why, "double distinguished values; witness void"); return 2; }
    ham_model m; one_var(&m);
    const char *f[] = {big, "1"};
    ham_model_add_field(&m, 0, "1", f);
    ham_epoch_cfg cfg = {4, 1};
    ham_state s0, s1; int a[1] = {0};
    REQ(ham_state_genesis(&m, &cfg, a, &s0, NULL, NULL) == HAM_OK);
    int b[1] = {1}; char *p; size_t pl; dec d = {0};
    REQ(ham_propose_step(&m, &s0, b, &p, &pl) == HAM_OK);
    REQ(decide_raw(&m, &cfg, &s0, p, pl, &d, &s1));
    int ok = d.acc && field_is(d.b, d.n, "energy_delta", "-1/10000000000000000000000000000000000000000");
    free(p); dec_free(&d);
    if (ok) ham_state_free(&s1);
    ham_state_free(&s0); ham_model_free(&m);
    REQ(ok);
    /* huge integers differing by 1, weights huge and negative */
    ham_model m2; one_var(&m2);
    const char *g[] = {"123456789012345678901234567890123456789012345678901",
                       "123456789012345678901234567890123456789012345678900"};
    ham_model_add_field(&m2, 0, "-98765432109876543210987654321", g);
    ham_state t0, t1; int z[1] = {1};
    REQ(ham_state_genesis(&m2, &cfg, z, &t0, NULL, NULL) == HAM_OK);
    int y[1] = {0};
    REQ(ham_propose_step(&m2, &t0, y, &p, &pl) == HAM_OK);
    REQ(decide_raw(&m2, &cfg, &t0, p, pl, &d, &t1));
    /* w<0: larger table value => lower energy, delta = w * 1 */
    ok = d.acc && field_is(d.b, d.n, "energy_delta", "-98765432109876543210987654321/1");
    free(p); dec_free(&d);
    if (ok) ham_state_free(&t1);
    ham_state_free(&t0); ham_model_free(&m2);
    return ok;
}

static int t_soft_constraints_energy(void) {
    /* soft constraints add energy u when violated; hard ones never add energy */
    int dom[2] = {2, 2};
    ham_model m; ham_model_init(&m, 2, dom);
    unsigned char diff[4] = {0, 1, 1, 0}, all_ok[4] = {1, 1, 1, 1};
    ham_model_add_soft(&m, "prefer_equal", 0, 1, "7/3", diff);
    ham_model_add_hard(&m, "trivial", 0, 1, all_ok);
    REQ(ham_model_add_hard(&m, "prefer_equal", 0, -1, all_ok) == HAM_ERR_ARG);   /* dup name */
    REQ(ham_model_add_hard(&m, "Bad-Name", 0, -1, all_ok) == HAM_ERR_ARG);
    mpq_t e; mpq_init(e);
    int a[2] = {0, 1}, b[2] = {1, 1};
    ham_energy(&m, a, e); char *s1 = ham_q_str(e);
    ham_energy(&m, b, e); char *s2 = ham_q_str(e);
    int ok = strcmp(s1, "7/3") == 0 && strcmp(s2, "0/1") == 0;
    free(s1); free(s2); mpq_clear(e); ham_model_free(&m);
    REQ(ok);
    return 1;
}

static int t_model_commit_binds(void) {
    /* changing any weight changes the model commitment, so stale proposals fail */
    ham_model m1, m2; model_a(&m1); model_a(&m2);
    char c1[65], c2[65];
    REQ(ham_model_commit(&m1, c1) == HAM_OK && ham_model_commit(&m2, c2) == HAM_OK);
    REQ(strcmp(c1, c2) == 0);
    mpq_set_si(m2.c[0].J, 1, 3);
    REQ(ham_model_commit(&m2, c2) == HAM_OK);
    REQ(strcmp(c1, c2) != 0);
    ham_epoch_cfg cfg = {4, 2};
    ham_state s0; int a[2] = {0, 0};
    REQ(ham_state_genesis(&m1, &cfg, a, &s0, NULL, NULL) == HAM_OK);
    char *p; size_t pl; dec d = {0}; ham_state nx; int b[2] = {1, 0};
    REQ(ham_propose_step(&m1, &s0, b, &p, &pl) == HAM_OK);
    /* deciding under a different model than the state was built with: explicit error */
    REQ(ham_decide(&m2, &cfg, &s0, p, pl, &d.b, &d.n, &d.acc, &nx) == HAM_ERR_ARG && d.b == NULL && !d.acc);
    free(p); ham_state_free(&s0); ham_model_free(&m1); ham_model_free(&m2);
    return 1;
}

/* ---- ledger ABI adapter (ledger/abi/lrd_state.h) ---- */
static int prop_from_bytes(const char *p, size_t pl, ham_rec *r, lrd_proposal_t *pr, lrd_field_t *ex, size_t *nex) {
    if (ham_rec_parse(p, pl, r) != HAM_OK) return 0;
    memset(pr, 0, sizeof *pr);
    *nex = 0;
    for (size_t i = 0; i < r->n; i++) {
        const char *k = r->f[i].key, *v = r->f[i].val;
        if (strcmp(k, "kind") == 0) pr->kind = lrd_kind_from_token(v, strlen(v));
        else if (strcmp(k, "prev_commit") == 0) snprintf(pr->prev_commit, sizeof pr->prev_commit, "%s", v);
        else if (strcmp(k, "payload_sha256") == 0) snprintf(pr->payload_sha256, sizeof pr->payload_sha256, "%s", v);
        else if (strcmp(k, "seq") == 0) pr->seq = strtoull(v, NULL, 10);
        else { ex[*nex].key = k; ex[*nex].key_len = strlen(k); ex[*nex].value = v; ex[*nex].value_len = strlen(v); (*nex)++; }
    }
    pr->extra = ex; pr->n_extra = *nex;
    return 1;
}

static int t_abi_adapter(void) {
    ham_model m; model_a(&m);
    ham_epoch_cfg cfg = {4, 2};
    ham_state s0, s1; int a[2] = {0, 0};
    REQ(ham_state_genesis(&m, &cfg, a, &s0, NULL, NULL) == HAM_OK);
    lrd_state_t view0; ham_state_view(&s0, &view0);
    REQ(view0.kind == LRD_KIND_HAMILTONIAN_STEP && view0.seq == 0 && strcmp(view0.commit, LRD_GENESIS_COMMIT) == 0);
    /* ACCEPT: descent 5/2 -> 1 */
    int b[2] = {1, 0}; char *p; size_t pl;
    REQ(ham_propose_step(&m, &s0, b, &p, &pl) == HAM_OK);
    ham_rec r; lrd_proposal_t pr; lrd_field_t ex[8]; size_t nex;
    REQ(prop_from_bytes(p, pl, &r, &pr, ex, &nex));
    lrd_decision_t out; lrd_state_t nv; char *rec; size_t rl;
    REQ(ham_decide_abi(&m, &cfg, &s0, &pr, &out, &s1, &nv, &rec, &rl) == HAM_OK);
    /* the adapter must produce the same bytes as deciding the original record directly */
    dec d = {0}; ham_state s1b;
    REQ(decide_raw(&m, &cfg, &s0, p, pl, &d, &s1b));
    int same = d.acc && d.n == rl && memcmp(d.b, rec, rl) == 0;
    if (d.acc) ham_state_free(&s1b);
    dec_free(&d); ham_rec_free(&r); free(p);
    int ok = same && out.decision == LRD_DECISION_ACCEPT && strcmp(out.reason, "ok") == 0 &&
             lrd_is_hex256(out.new_commit) && strcmp(out.new_commit, s1.self_commit) == 0 &&
             nv.seq == 1 && strcmp(nv.commit, s0.self_commit) == 0 && nv.kind == LRD_KIND_HAMILTONIAN_STEP &&
             strcmp(nv.payload_sha256, s1.payload_sha256) == 0;
    free(rec);
    if (!ok) { ham_state_free(&s0); ham_state_free(&s1); ham_model_free(&m); REQS(0, "accept path mismatch"); }
    /* REJECT (energy increasing 1 -> 3): next/next_view untouched, new_commit "" */
    int c[2] = {0, 1};
    REQ(ham_propose_step(&m, &s1, c, &p, &pl) == HAM_OK);
    REQ(prop_from_bytes(p, pl, &r, &pr, ex, &nex));
    ham_state nx; memset(&nx, 0xA5, sizeof nx); lrd_state_t nvx; memset(&nvx, 0x5A, sizeof nvx);
    unsigned char s1snap[sizeof nx], s2snap[sizeof nvx]; memcpy(s1snap, &nx, sizeof nx); memcpy(s2snap, &nvx, sizeof nvx);
    uint64_t c0 = ham_states_constructed();
    memset(&out, 0x77, sizeof out);
    REQ(ham_decide_abi(&m, &cfg, &s1, &pr, &out, &nx, &nvx, NULL, NULL) == HAM_OK);
    ok = out.decision == LRD_DECISION_REJECT && strcmp(out.reason, "energy_not_decreasing") == 0 &&
         out.new_commit[0] == '\0' && memcmp(&nx, s1snap, sizeof nx) == 0 &&
         memcmp(&nvx, s2snap, sizeof nvx) == 0 && ham_states_constructed() == c0;
    /* wrong kind via enum */
    pr.kind = LRD_KIND_LEDGER_APPEND;
    REQ(ham_decide_abi(&m, &cfg, &s1, &pr, &out, &nx, &nvx, NULL, NULL) == HAM_OK);
    ok = ok && out.decision == LRD_DECISION_REJECT && strcmp(out.reason, "wrong_kind") == 0;
    /* extra field colliding with a common key -> unserializable -> malformed */
    pr.kind = LRD_KIND_HAMILTONIAN_STEP;
    lrd_field_t ex2[9]; memcpy(ex2, ex, nex * sizeof *ex);
    ex2[nex].key = "seq"; ex2[nex].key_len = 3; ex2[nex].value = "2"; ex2[nex].value_len = 1;
    pr.extra = ex2; pr.n_extra = nex + 1;
    REQ(ham_decide_abi(&m, &cfg, &s1, &pr, &out, &nx, &nvx, NULL, NULL) == HAM_OK);
    ok = ok && out.decision == LRD_DECISION_REJECT && strcmp(out.reason, "malformed") == 0 &&
         memcmp(&nx, s1snap, sizeof nx) == 0 && ham_states_constructed() == c0;
    ham_rec_free(&r); free(p);
    ham_state_free(&s0); ham_state_free(&s1); ham_model_free(&m);
    REQ(ok);
    return 1;
}

static int t_reason_tokens_abi_conformant(void) {
    /* every reason this engine can emit: lowercase [a-z0-9_]+, <= LRD_REASON_MAX */
    const char *r[] = {"ok", "malformed", "wrong_kind", "stale_seq", "bad_prev", "bad_payload",
                       "bad_epoch", "epoch_exhausted", "infeasible", "energy_not_decreasing"};
    for (size_t i = 0; i < sizeof r / sizeof r[0]; i++) {
        size_t n = strlen(r[i]);
        REQS(n >= 1 && n <= LRD_REASON_MAX, "%s length", r[i]);
        for (size_t k = 0; k < n; k++)
            REQS((r[i][k] >= 'a' && r[i][k] <= 'z') || (r[i][k] >= '0' && r[i][k] <= '9') || r[i][k] == '_', "%s charset", r[i]);
    }
    REQ(strcmp(LRD_REASON_ENERGY_NOT_DECREASING, "energy_not_decreasing") == 0);
    REQ(strcmp(LRD_REASON_INFEASIBLE, "infeasible") == 0);
    REQ(strcmp(lrd_kind_token(LRD_KIND_HAMILTONIAN_STEP), HAM_KIND) == 0);
    return 1;
}


int main(int argc, char **argv) {
    if (argc > 1) g_golden_commit = argv[1];
    run("sha256_fips_vectors", t_sha256_vectors);
    run("rec_canonical_bytes", t_rec_canonical_bytes);
    run("rec_commit_matches_sha256sum", t_rec_commit_matches_sha256sum);
    run("rec_parse_rejects_noncanonical", t_rec_parse_rejects);
    run("rational_canonical_forms", t_rational_canonical);
    run("energy_exact_model_a", t_energy_exact_model_a);
    run("soft_constraints_energy", t_soft_constraints_energy);
    run("satisfiable", t_satisfiable);
    run("unsatisfiable", t_unsatisfiable);
    run("conflict_report_irreducible", t_conflict_report);
    run("conflict_single_empty_constraint", t_conflict_single_empty_constraint);
    run("search_limit_explicit", t_search_limit_explicit);
    run("genesis_infeasible_no_state", t_genesis_infeasible_no_state);
    run("genesis_state_fields", t_genesis_state_fields);
    run("valid_descent_accepted", t_valid_descent_accepted);
    run("equal_energy_rejected", t_equal_energy_rejected);
    run("energy_increasing_rejected", t_energy_increasing_rejected);
    run("infeasible_transition_rejected", t_infeasible_transition_rejected);
    run("epoch_exhausted", t_epoch_exhausted);
    run("epoch_transition_explicit", t_epoch_transition_explicit);
    run("envelope_rejects", t_envelope_rejects);
    run("replay_rejected", t_replay_rejected);
    run("reject_never_constructs_state", t_reject_never_constructs_state);
    run("determinism_bytes", t_determinism_bytes);
    run("script_expected_reasons", t_script_expected_reasons);
    run("exact_thirds_equal", t_exact_thirds_equal);
    run("exact_tenths_double_would_accept", t_exact_tenths_double_would_accept);
    run("exact_huge_values", t_exact_huge_values);
    run("model_commit_binds", t_model_commit_binds);
    run("abi_adapter_ledger_header", t_abi_adapter);
    run("reason_tokens_abi_conformant", t_reason_tokens_abi_conformant);
    printf("# SUMMARY pass=%d fail=%d unavailable=%d\n", g_pass, g_fail, g_unav);
    return g_fail ? 1 : 0;
}
