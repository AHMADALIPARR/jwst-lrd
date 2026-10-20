/* SPDX-License-Identifier: AGPL-3.0-only
 * Also subject to SNAPKITTY_OPAQUE_LICENSE.md (dual license, see repository root).
 */
/* LRD-REC-v1 canonical records and LRD-COMMIT-v1 commitments. */
#include "ham.h"
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void ham_rec_init(ham_rec *r) { r->f = NULL; r->n = r->cap = 0; }

void ham_rec_free(ham_rec *r) {
    for (size_t i = 0; i < r->n; i++) { free(r->f[i].key); free(r->f[i].val); }
    free(r->f); ham_rec_init(r);
}

static ham_status add_n(ham_rec *r, const char *k, size_t kl, const char *v, size_t vl) {
    if (kl == 0) return HAM_ERR_ARG;
    if (memchr(k, '\n', kl) || memchr(k, '\0', kl) || memchr(v, '\n', vl) || memchr(v, '\0', vl))
        return HAM_ERR_ARG;
    if (r->n == r->cap) {
        size_t nc = r->cap ? r->cap * 2 : 16;
        ham_field_kv *nf = realloc(r->f, nc * sizeof *nf);
        if (!nf) return HAM_ERR_NOMEM;
        r->f = nf; r->cap = nc;
    }
    char *kk = malloc(kl + 1), *vv = malloc(vl + 1);
    if (!kk || !vv) { free(kk); free(vv); return HAM_ERR_NOMEM; }
    memcpy(kk, k, kl); kk[kl] = 0; memcpy(vv, v, vl); vv[vl] = 0;
    r->f[r->n].key = kk; r->f[r->n].val = vv; r->n++;
    return HAM_OK;
}

ham_status ham_rec_add(ham_rec *r, const char *key, const char *val) {
    if (!key || !val) return HAM_ERR_ARG;
    return add_n(r, key, strlen(key), val, strlen(val));
}

ham_status ham_rec_addf(ham_rec *r, const char *key, const char *fmt, ...) {
    va_list ap; va_start(ap, fmt);
    char *buf = NULL;
    int n = vsnprintf(NULL, 0, fmt, ap); va_end(ap);
    if (n < 0) return HAM_ERR_ARG;
    buf = malloc((size_t)n + 1);
    if (!buf) return HAM_ERR_NOMEM;
    va_start(ap, fmt); vsnprintf(buf, (size_t)n + 1, fmt, ap); va_end(ap);
    ham_status st = ham_rec_add(r, key, buf);
    free(buf);
    return st;
}

ham_status ham_rec_add_q(ham_rec *r, const char *key, const mpq_t q) {
    char *s = ham_q_str(q);
    if (!s) return HAM_ERR_NOMEM;
    ham_status st = ham_rec_add(r, key, s);
    free(s);
    return st;
}

static int kcmp(const void *a, const void *b) {
    /* strcmp compares as unsigned char: bytewise ascending */
    return strcmp(((const ham_field_kv *)a)->key, ((const ham_field_kv *)b)->key);
}

ham_status ham_rec_serialize(ham_rec *r, char **out, size_t *len) {
    *out = NULL; *len = 0;
    if (r->n > 1) qsort(r->f, r->n, sizeof *r->f, kcmp);
    for (size_t i = 1; i < r->n; i++)
        if (strcmp(r->f[i-1].key, r->f[i].key) == 0) return HAM_ERR_ARG;   /* duplicate */
    size_t total = LRD_REC_MAGIC_LEN;
    for (size_t i = 0; i < r->n; i++)
        total += strlen(r->f[i].key) + strlen(r->f[i].val) + 2 * 21 + 3;
    char *b = malloc(total + 1);
    if (!b) return HAM_ERR_NOMEM;
    size_t o = 0;
    memcpy(b, LRD_REC_MAGIC, LRD_REC_MAGIC_LEN); o = LRD_REC_MAGIC_LEN;
    for (size_t i = 0; i < r->n; i++) {
        size_t kl = strlen(r->f[i].key), vl = strlen(r->f[i].val);
        o += (size_t)sprintf(b + o, "%zu:", kl); memcpy(b + o, r->f[i].key, kl); o += kl;
        o += (size_t)sprintf(b + o, "%zu:", vl); memcpy(b + o, r->f[i].val, vl); o += vl;
        b[o++] = '\n';
    }
    b[o] = 0;
    *out = b; *len = o;
    return HAM_OK;
}

/* decimal length, no leading zeros, terminated by ':' */
static int read_len(const char *b, size_t len, size_t *pos, size_t *val) {
    size_t p = *pos, v = 0, nd = 0;
    while (p < len && b[p] >= '0' && b[p] <= '9') {
        if (nd == 0 && b[p] == '0' && p + 1 < len && b[p+1] != ':') return 0;
        if (v > (SIZE_MAX - 9) / 10) return 0;
        v = v * 10 + (size_t)(b[p] - '0'); p++; nd++;
    }
    if (nd == 0 || p >= len || b[p] != ':') return 0;
    *pos = p + 1; *val = v;
    return 1;
}

ham_status ham_rec_parse(const char *b, size_t len, ham_rec *out) {
    ham_rec_init(out);
    if (len < LRD_REC_MAGIC_LEN || memcmp(b, LRD_REC_MAGIC, LRD_REC_MAGIC_LEN) != 0)
        return HAM_ERR_PARSE;
    size_t p = LRD_REC_MAGIC_LEN;
    while (p < len) {
        size_t kl, vl;
        if (!read_len(b, len, &p, &kl) || kl == 0 || kl > len - p) goto bad;
        const char *k = b + p; p += kl;
        if (!read_len(b, len, &p, &vl) || vl > len - p) goto bad;
        const char *v = b + p; p += vl;
        if (p >= len || b[p] != '\n') goto bad;
        p++;
        if (out->n > 0) {
            const char *pk = out->f[out->n - 1].key;
            size_t pl = strlen(pk), m = pl < kl ? pl : kl;
            int c = memcmp(pk, k, m);
            if (c > 0 || (c == 0 && pl >= kl)) goto bad;   /* not strictly ascending */
        }
        ham_status st = add_n(out, k, kl, v, vl);
        if (st == HAM_ERR_NOMEM) { ham_rec_free(out); return st; }
        if (st != HAM_OK) goto bad;
    }
    return HAM_OK;
bad:
    ham_rec_free(out);
    return HAM_ERR_PARSE;
}

const char *ham_rec_get(const ham_rec *r, const char *key) {
    for (size_t i = 0; i < r->n; i++) if (strcmp(r->f[i].key, key) == 0) return r->f[i].val;
    return NULL;
}

ham_status ham_commit_bytes(const char *bytes, size_t len, char hex[65]) {
    unsigned char *buf = malloc(LRD_COMMIT_DOMAIN_LEN + len + 1);
    unsigned char d[32];
    if (!buf) { hex[0] = 0; return HAM_ERR_NOMEM; }
    memcpy(buf, LRD_COMMIT_DOMAIN, LRD_COMMIT_DOMAIN_LEN - 1);
    buf[LRD_COMMIT_DOMAIN_LEN - 1] = 0;
    if (len) memcpy(buf + LRD_COMMIT_DOMAIN_LEN, bytes, len);
    ham_sha256(buf, LRD_COMMIT_DOMAIN_LEN + len, d);
    ham_hex(d, 32, hex);
    free(buf);
    return HAM_OK;
}
