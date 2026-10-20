/* SPDX-License-Identifier: AGPL-3.0-only
 * Also subject to SNAPKITTY_OPAQUE_LICENSE.md (dual license, see repository root).
 *
 * LRD-STATE-v1 "observation" transitions for ingested raw products.
 * Uses ledger/abi/lrd_state.h (owned by the ledger track; included, not forked).
 *
 * Kind-specific proposal fields for kind=observation (documented in ingest/STATUS.md):
 *   obs_manifest_commit   LRD-REC-v1 commitment of fixtures/ingest/<sha>/manifest.rec (64 hex)
 *   obs_mast_obsid        MAST obsid (canonical natural number)
 *   obs_product           MAST product filename
 *   obs_science_use       "primary" | "provenance_only"
 *   obs_quality_flag      "none" | a lowercase token, e.g. "flux_globally_negative"
 * payload_sha256 = sha256 of the raw FITS bytes (= the immutable raw ID).
 *
 * Genesis convention (same as the ledger track's tests): the chain starts from a virtual
 * genesis state with seq = 0 whose commitment is LRD_GENESIS_COMMIT (64 zeros).
 * For any other state S, commitment(S) = LRD-REC-v1 commitment of
 * {commit=S.commit, kind, payload_sha256, seq}  (CONTRACTS v1.1).
 *
 * Checks (in order): malformed, wrong_kind, stale_seq, bad_prev, bad_payload, then ok.
 *   malformed   : proposal fields missing/duplicated/non-canonical, or unknown extra fields
 *   bad_payload : fixtures/raw/<payload_sha256>.fits missing or its sha256 differs, or
 *                 obs_manifest_commit != commitment of the stored manifest.rec
 *
 * CLI:
 *   lrd_obs propose <cur_state.rec|genesis> <payload_sha256> <out.rec>   (extra fields: stdin key=value)
 *   lrd_obs apply   <fixtures_dir> <cur_state.rec|genesis> <proposal.rec> <decision.rec> <state.rec>
 *       exit 0 on ACCEPT (writes both files), 1 on REJECT (writes decision only; state untouched)
 *   lrd_obs commit  <record.rec>     prints the LRD-COMMIT-v1 commitment of a stored record
 */
#include "lrd_state.h"

#include <ctype.h>
#include <errno.h>
#include <openssl/evp.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int lrd_sha256_file(const char *path, char hex[65], long long *size_out);

#define MAXF 128
#define MAXV 1024
typedef struct { char k[64]; char v[MAXV]; } kv_t;
typedef struct { kv_t f[MAXF]; int n; } rec_t;

static int kvcmp(const void *a, const void *b) { return strcmp(((const kv_t *)a)->k, ((const kv_t *)b)->k); }

static int rec_set(rec_t *r, const char *k, const char *v) {
    if (!*k || strlen(k) >= 64 || strlen(v) >= MAXV || strchr(v, '\n') || r->n >= MAXF) return -1;
    for (int i = 0; i < r->n; i++) if (strcmp(r->f[i].k, k) == 0) return -1;
    strcpy(r->f[r->n].k, k);
    strcpy(r->f[r->n].v, v);
    r->n++;
    return 0;
}
static const char *rec_get(const rec_t *r, const char *k) {
    for (int i = 0; i < r->n; i++) if (strcmp(r->f[i].k, k) == 0) return r->f[i].v;
    return NULL;
}
/* Serialize (sorted) into buf; returns length or -1. */
static long rec_ser(const rec_t *r0, char *buf, size_t cap) {
    rec_t r = *r0;
    qsort(r.f, (size_t)r.n, sizeof r.f[0], kvcmp);
    size_t o = 0;
    int m = snprintf(buf, cap, "%s", LRD_REC_MAGIC);
    o += (size_t)m;
    for (int i = 0; i < r.n; i++) {
        m = snprintf(buf + o, cap - o, "%zu:%s%zu:%s\n", strlen(r.f[i].k), r.f[i].k, strlen(r.f[i].v), r.f[i].v);
        if (m < 0 || (size_t)m >= cap - o) return -1;
        o += (size_t)m;
    }
    return (long)o;
}
static void commit_bytes(const char *b, size_t n, char hex[65]) {
    unsigned char md[32]; unsigned int ml;
    EVP_MD_CTX *c = EVP_MD_CTX_new();
    EVP_DigestInit_ex(c, EVP_sha256(), NULL);
    EVP_DigestUpdate(c, LRD_COMMIT_DOMAIN, LRD_COMMIT_DOMAIN_LEN);
    EVP_DigestUpdate(c, b, n);
    EVP_DigestFinal_ex(c, md, &ml);
    EVP_MD_CTX_free(c);
    for (int i = 0; i < 32; i++) sprintf(hex + 2 * i, "%02x", md[i]);
    hex[64] = 0;
}
static int rec_commit(const rec_t *r, char hex[65]) {
    static char buf[1 << 16];
    long n = rec_ser(r, buf, sizeof buf);
    if (n < 0) return -1;
    commit_bytes(buf, (size_t)n, hex);
    return 0;
}
static int rec_write(const rec_t *r, const char *path) {
    static char buf[1 << 16];
    long n = rec_ser(r, buf, sizeof buf);
    FILE *f = fopen(path, "wb");
    if (n < 0 || !f) { if (f) fclose(f); return -1; }
    fwrite(buf, 1, (size_t)n, f);
    fclose(f);
    return 0;
}
/* Strict LRD-REC-v1 parse: magic, canonical lengths, keys strictly ascending, no empty keys. */
static int rec_read(const char *path, rec_t *r) {
    static char buf[1 << 16];
    FILE *f = fopen(path, "rb");
    if (!f) return -1;
    size_t n = fread(buf, 1, sizeof buf - 1, f);
    fclose(f);
    buf[n] = 0;
    r->n = 0;
    if (n < LRD_REC_MAGIC_LEN || memcmp(buf, LRD_REC_MAGIC, LRD_REC_MAGIC_LEN) != 0) return -1;
    size_t o = LRD_REC_MAGIC_LEN;
    char prev[64] = "";
    while (o < n) {
        size_t lens[2]; const char *s[2];
        for (int j = 0; j < 2; j++) {
            if (!isdigit((unsigned char)buf[o])) return -1;
            if (buf[o] == '0' && buf[o + 1] != ':') return -1; /* no leading zeros */
            size_t L = 0;
            while (o < n && isdigit((unsigned char)buf[o])) L = L * 10 + (size_t)(buf[o++] - '0');
            if (o >= n || buf[o++] != ':' || o + L > n) return -1;
            s[j] = buf + o; lens[j] = L; o += L;
        }
        if (o >= n || buf[o++] != '\n') return -1;
        if (lens[0] == 0 || lens[0] >= 64 || lens[1] >= MAXV || r->n >= MAXF) return -1;
        if (memchr(s[1], '\n', lens[1])) return -1;
        memcpy(r->f[r->n].k, s[0], lens[0]); r->f[r->n].k[lens[0]] = 0;
        memcpy(r->f[r->n].v, s[1], lens[1]); r->f[r->n].v[lens[1]] = 0;
        if (r->n > 0 && strcmp(prev, r->f[r->n].k) >= 0) return -1; /* sorted, no duplicates */
        strcpy(prev, r->f[r->n].k);
        r->n++;
    }
    return 0;
}
static int canon_nat(const char *s, uint64_t *out) {
    if (!*s || (s[0] == '0' && s[1]) ) return 0;
    uint64_t v = 0;
    for (const char *p = s; *p; p++) {
        if (!isdigit((unsigned char)*p)) return 0;
        uint64_t d = (uint64_t)(*p - '0');
        if (v > (UINT64_MAX - d) / 10) return 0;
        v = v * 10 + d;
    }
    *out = v;
    return 1;
}
static int is_token(const char *s) {
    if (!*s) return 0;
    for (; *s; s++) if (!((*s >= 'a' && *s <= 'z') || (*s >= '0' && *s <= '9') || *s == '_')) return 0;
    return 1;
}

/* ---------------------------------------------------------------- state <-> record */
static int state_is_genesis(const lrd_state_t *s) {
    return s->seq == 0 && strcmp(s->commit, LRD_GENESIS_COMMIT) == 0;
}
static void state_genesis(lrd_state_t *s) {
    memset(s, 0, sizeof *s);
    s->seq = 0;
    strcpy(s->commit, LRD_GENESIS_COMMIT);
    s->kind = LRD_KIND_INVALID;
    strcpy(s->payload_sha256, LRD_GENESIS_COMMIT);
}
static int state_rec(const lrd_state_t *s, rec_t *r) {
    char seq[32];
    const char *k = lrd_kind_token(s->kind);
    if (!k) return -1;
    r->n = 0;
    snprintf(seq, sizeof seq, "%llu", (unsigned long long)s->seq);
    return rec_set(r, LRD_F_COMMIT, s->commit) | rec_set(r, LRD_F_KIND, k) |
           rec_set(r, LRD_F_PAYLOAD_SHA256, s->payload_sha256) | rec_set(r, LRD_F_SEQ, seq);
}
/* commitment of the state itself (what the next proposal's prev_commit must equal) */
static int state_self_commit(const lrd_state_t *s, char hex[65]) {
    if (state_is_genesis(s)) { strcpy(hex, LRD_GENESIS_COMMIT); return 0; }
    rec_t r;
    if (state_rec(s, &r)) return -1;
    return rec_commit(&r, hex);
}
static int state_from_rec(const rec_t *r, lrd_state_t *s) {
    const char *c = rec_get(r, LRD_F_COMMIT), *k = rec_get(r, LRD_F_KIND),
               *p = rec_get(r, LRD_F_PAYLOAD_SHA256), *q = rec_get(r, LRD_F_SEQ);
    if (r->n != 4 || !c || !k || !p || !q) return -1;
    if (strlen(c) != 64 || strlen(p) != 64) return -1;
    strcpy(s->commit, c); strcpy(s->payload_sha256, p);
    if (!lrd_is_hex256(s->commit) || !lrd_is_hex256(s->payload_sha256)) return -1;
    s->kind = lrd_kind_from_token(k, strlen(k));
    if (s->kind == LRD_KIND_INVALID || !canon_nat(q, &s->seq)) return -1;
    return 0;
}
static int load_state(const char *arg, lrd_state_t *s) {
    if (strcmp(arg, "genesis") == 0) { state_genesis(s); return 0; }
    rec_t r;
    if (rec_read(arg, &r)) return -1;
    return state_from_rec(&r, s);
}

/* ---------------------------------------------------------------- transition */
static const char *g_fixtures = NULL; /* bound context (CONTRACTS v1.1 wrapper rule) */
static const char *OBS_EXTRA[] = {"obs_manifest_commit", "obs_mast_obsid", "obs_product",
                                  "obs_quality_flag", "obs_science_use", NULL};

static lrd_decision_code_t accept(lrd_decision_t *out, lrd_state_t *next, const lrd_state_t *ns) {
    rec_t r;
    char h[65];
    if (state_rec(ns, &r) || rec_commit(&r, h)) { lrd_decision_reject(out, "malformed"); return out->decision; }
    out->decision = LRD_DECISION_ACCEPT;
    strcpy(out->reason, LRD_REASON_OK);
    strcpy(out->new_commit, h);
    if (next) *next = *ns;
    return LRD_DECISION_ACCEPT;
}

/* lrd_transition_fn for kind=observation, with the fixtures directory bound in g_fixtures. */
static lrd_decision_code_t obs_transition(const lrd_state_t *cur, const lrd_proposal_t *p,
                                          lrd_decision_t *out, lrd_state_t *next) {
    memset(out, 0, sizeof *out);
    if (!lrd_is_hex256(p->prev_commit) || !lrd_is_hex256(p->payload_sha256)) {
        lrd_decision_reject(out, "malformed"); return out->decision; }
    /* exactly the documented extra fields, each once, canonical */
    for (int i = 0; OBS_EXTRA[i]; i++) {
        int c = 0;
        for (size_t j = 0; j < p->n_extra; j++)
            if (p->extra[j].key_len == strlen(OBS_EXTRA[i]) && memcmp(p->extra[j].key, OBS_EXTRA[i], p->extra[j].key_len) == 0) c++;
        if (c != 1) { lrd_decision_reject(out, "malformed"); return out->decision; }
    }
    if (p->n_extra != 5) { lrd_decision_reject(out, "malformed"); return out->decision; }
    char mc[65] = "", obsid[64] = "", use[64] = "", flag[64] = "", prod[MAXV] = "";
    for (size_t j = 0; j < p->n_extra; j++) {
        const lrd_field_t *f = &p->extra[j];
        char *dst = NULL; size_t cap = 0;
        if (f->key_len == 19 && !memcmp(f->key, "obs_manifest_commit", 19)) { dst = mc; cap = sizeof mc; }
        else if (f->key_len == 14 && !memcmp(f->key, "obs_mast_obsid", 14)) { dst = obsid; cap = sizeof obsid; }
        else if (f->key_len == 15 && !memcmp(f->key, "obs_science_use", 15)) { dst = use; cap = sizeof use; }
        else if (f->key_len == 16 && !memcmp(f->key, "obs_quality_flag", 16)) { dst = flag; cap = sizeof flag; }
        else if (f->key_len == 11 && !memcmp(f->key, "obs_product", 11)) { dst = prod; cap = sizeof prod; }
        if (!dst || f->value_len >= cap) { lrd_decision_reject(out, "malformed"); return out->decision; }
        memcpy(dst, f->value, f->value_len); dst[f->value_len] = 0;
    }
    uint64_t oid;
    if (strlen(mc) != 64 || !lrd_is_hex256(mc) || !canon_nat(obsid, &oid) || !*prod || strchr(prod, '/') ||
        (strcmp(use, "primary") && strcmp(use, "provenance_only")) || !is_token(flag)) {
        lrd_decision_reject(out, "malformed"); return out->decision; }
    if (p->kind != LRD_KIND_OBSERVATION) { lrd_decision_reject(out, "wrong_kind"); return out->decision; }
    if (cur->seq == UINT64_MAX || p->seq != cur->seq + 1) { lrd_decision_reject(out, LRD_REASON_STALE_SEQ); return out->decision; }
    char self[65];
    if (state_self_commit(cur, self) || strcmp(self, p->prev_commit) != 0) {
        lrd_decision_reject(out, LRD_REASON_BAD_PREV); return out->decision; }
    /* payload: the stored raw product must hash to payload_sha256; manifest commitment must match */
    char path[4096], hex[65];
    long long sz;
    snprintf(path, sizeof path, "%s/raw/%s.fits", g_fixtures, p->payload_sha256);
    if (lrd_sha256_file(path, hex, &sz) != 0 || strcmp(hex, p->payload_sha256) != 0) {
        lrd_decision_reject(out, "bad_payload"); return out->decision; }
    rec_t man;
    snprintf(path, sizeof path, "%s/ingest/%s/manifest.rec", g_fixtures, p->payload_sha256);
    if (rec_read(path, &man) || rec_commit(&man, hex) || strcmp(hex, mc) != 0) {
        lrd_decision_reject(out, "bad_payload"); return out->decision; }
    lrd_state_t ns;
    memset(&ns, 0, sizeof ns);
    ns.seq = p->seq;
    strcpy(ns.commit, p->prev_commit);
    ns.kind = LRD_KIND_OBSERVATION;
    strcpy(ns.payload_sha256, p->payload_sha256);
    return accept(out, next, &ns);
}
static lrd_transition_fn obs_bind(const char *fixtures_dir) {
    g_fixtures = fixtures_dir;
    return obs_transition;
}

/* ---------------------------------------------------------------- proposal <-> record */
static int proposal_from_rec(const rec_t *r, lrd_proposal_t *p, lrd_field_t *ex, int *malformed) {
    const char *k = rec_get(r, LRD_F_KIND), *pc = rec_get(r, LRD_F_PREV_COMMIT),
               *q = rec_get(r, LRD_F_SEQ), *ps = rec_get(r, LRD_F_PAYLOAD_SHA256);
    *malformed = 1;
    memset(p, 0, sizeof *p);
    if (!k || !pc || !q || !ps || strlen(pc) != 64 || strlen(ps) != 64 || !canon_nat(q, &p->seq)) return 0;
    p->kind = lrd_kind_from_token(k, strlen(k));
    if (p->kind == LRD_KIND_INVALID) return 0;
    strcpy(p->prev_commit, pc); strcpy(p->payload_sha256, ps);
    size_t ne = 0;
    for (int i = 0; i < r->n; i++) {
        const char *key = r->f[i].k;
        if (!strcmp(key, LRD_F_KIND) || !strcmp(key, LRD_F_PREV_COMMIT) || !strcmp(key, LRD_F_SEQ) ||
            !strcmp(key, LRD_F_PAYLOAD_SHA256)) continue;
        ex[ne].key = key; ex[ne].key_len = strlen(key);
        ex[ne].value = r->f[i].v; ex[ne].value_len = strlen(r->f[i].v);
        ne++;
    }
    p->extra = ex; p->n_extra = ne;
    *malformed = 0;
    return 0;
}

static int decision_write(const lrd_decision_t *d, const char *path) {
    rec_t r; r.n = 0;
    rec_set(&r, LRD_F_DECISION, d->decision == LRD_DECISION_ACCEPT ? LRD_DECISION_TOKEN_ACCEPT : LRD_DECISION_TOKEN_REJECT);
    rec_set(&r, LRD_F_REASON, d->reason);
    if (d->decision == LRD_DECISION_ACCEPT) rec_set(&r, LRD_F_NEW_COMMIT, d->new_commit);
    return rec_write(&r, path);
}

int main(int argc, char **argv) {
    if (argc >= 5 && !strcmp(argv[1], "propose")) {
        lrd_state_t cur;
        if (load_state(argv[2], &cur)) { fprintf(stderr, "lrd_obs: bad current state %s\n", argv[2]); return 2; }
        char self[65];
        if (state_self_commit(&cur, self)) return 2;
        rec_t r; r.n = 0;
        char seq[32], line[1024];
        snprintf(seq, sizeof seq, "%llu", (unsigned long long)(cur.seq + 1));
        if (rec_set(&r, LRD_F_KIND, "observation") || rec_set(&r, LRD_F_PREV_COMMIT, self) ||
            rec_set(&r, LRD_F_SEQ, seq) || rec_set(&r, LRD_F_PAYLOAD_SHA256, argv[3])) return 2;
        while (fgets(line, sizeof line, stdin)) {
            line[strcspn(line, "\n")] = 0;
            if (!*line) continue;
            char *eq = strchr(line, '=');
            if (!eq) { fprintf(stderr, "lrd_obs: bad field %s\n", line); return 2; }
            *eq = 0;
            if (rec_set(&r, line, eq + 1)) { fprintf(stderr, "lrd_obs: rejected field %s\n", line); return 2; }
        }
        return rec_write(&r, argv[4]) ? 2 : 0;
    }
    if (argc == 7 && !strcmp(argv[1], "apply")) {
        lrd_transition_fn fn = obs_bind(argv[2]);
        lrd_state_t cur, next;
        lrd_decision_t d;
        lrd_proposal_t p;
        lrd_field_t ex[MAXF];
        rec_t pr;
        int malformed = 1;
        if (load_state(argv[3], &cur)) { fprintf(stderr, "lrd_obs: bad current state\n"); return 2; }
        if (rec_read(argv[4], &pr) == 0) proposal_from_rec(&pr, &p, ex, &malformed);
        if (malformed) lrd_decision_reject(&d, "malformed");
        else fn(&cur, &p, &d, &next);
        if (decision_write(&d, argv[5])) return 2;
        if (d.decision == LRD_DECISION_ACCEPT) {
            rec_t sr;
            if (state_rec(&next, &sr) || rec_write(&sr, argv[6])) return 2;
            printf("ACCEPT seq=%llu new_commit=%s\n", (unsigned long long)next.seq, d.new_commit);
            return 0;
        }
        printf("REJECT reason=%s\n", d.reason);
        return 1;
    }
    if (argc == 3 && !strcmp(argv[1], "commit")) {
        rec_t r; char h[65];
        if (rec_read(argv[2], &r) || rec_commit(&r, h)) { fprintf(stderr, "lrd_obs: not a canonical LRD-REC-v1 record\n"); return 2; }
        printf("%s\n", h);
        return 0;
    }
    fprintf(stderr, "usage: lrd_obs propose|apply|commit ... (see source header)\n");
    return 2;
}
