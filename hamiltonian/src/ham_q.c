/* SPDX-License-Identifier: AGPL-3.0-only
 * Also subject to SNAPKITTY_OPAQUE_LICENSE.md (dual license, see repository root).
 */
/* Exact rational text forms (LRD-REC-v1: "p/q", q>0, gcd(p,q)=1). */
#include "ham.h"
#include <stdlib.h>
#include <string.h>

const char *ham_status_str(ham_status st) {
    switch (st) {
    case HAM_OK: return "ok";
    case HAM_ERR_NOMEM: return "nomem";
    case HAM_ERR_ARG: return "bad_argument";
    case HAM_ERR_PARSE: return "parse_error";
    case HAM_ERR_INFEASIBLE: return "infeasible";
    case HAM_ERR_LIMIT: return "search_limit";
    }
    return "unknown";
}

char *ham_q_str(const mpq_t q) {
    /* mpq_t values in this library are always canonical; we still emit
     * from a canonicalized copy so the text form is canonical by construction. */
    mpq_t c; mpq_init(c); mpq_set(c, q); mpq_canonicalize(c);
    char *ns = mpz_get_str(NULL, 10, mpq_numref(c));
    char *ds = mpz_get_str(NULL, 10, mpq_denref(c));
    char *out = NULL;
    if (ns && ds) {
        size_t a = strlen(ns), b = strlen(ds);
        out = malloc(a + b + 2);
        if (out) { memcpy(out, ns, a); out[a] = '/'; memcpy(out + a + 1, ds, b + 1); }
    }
    void (*fr)(void *, size_t);
    mp_get_memory_functions(NULL, NULL, &fr);
    if (ns) fr(ns, strlen(ns) + 1);
    if (ds) fr(ds, strlen(ds) + 1);
    mpq_clear(c);
    return out;
}

/* digits: nonempty, all [0-9]; canonical => no leading zero unless "0" */
static int digits(const char *s, size_t n, int canonical) {
    if (n == 0) return 0;
    for (size_t i = 0; i < n; i++) if (s[i] < '0' || s[i] > '9') return 0;
    if (canonical && n > 1 && s[0] == '0') return 0;
    return 1;
}

static ham_status set_parts(mpq_t out, const char *s, int canonical) {
    if (!s) return HAM_ERR_ARG;
    const char *slash = strchr(s, '/');
    int neg = (s[0] == '-');
    const char *p = s + neg;
    size_t plen = slash ? (size_t)(slash - p) : strlen(p);
    if (!digits(p, plen, canonical)) return HAM_ERR_PARSE;
    const char *q = slash ? slash + 1 : NULL;
    if (canonical && !q) return HAM_ERR_PARSE;
    if (q && !digits(q, strlen(q), canonical)) return HAM_ERR_PARSE;
    char *pbuf = malloc(plen + 2);
    if (!pbuf) return HAM_ERR_NOMEM;
    if (neg) pbuf[0] = '-';
    memcpy(pbuf + neg, p, plen); pbuf[plen + neg] = '\0';
    mpz_t num, den; mpz_init(num); mpz_init(den);
    ham_status st = HAM_OK;
    if (mpz_set_str(num, pbuf, 10) != 0) st = HAM_ERR_PARSE;
    if (st == HAM_OK) {
        if (q) { if (mpz_set_str(den, q, 10) != 0) st = HAM_ERR_PARSE; }
        else mpz_set_ui(den, 1);
    }
    if (st == HAM_OK && mpz_sgn(den) == 0) st = HAM_ERR_PARSE;
    if (st == HAM_OK && canonical) {
        if (neg && mpz_sgn(num) == 0) st = HAM_ERR_PARSE;      /* "-0/1" */
        mpz_t g; mpz_init(g); mpz_gcd(g, num, den);
        if (mpz_cmp_ui(g, 1) != 0) st = HAM_ERR_PARSE;         /* "2/4", "0/2" */
        mpz_clear(g);
    }
    if (st == HAM_OK) {
        mpq_set_num(out, num); mpq_set_den(out, den); mpq_canonicalize(out);
    }
    mpz_clear(num); mpz_clear(den); free(pbuf);
    return st;
}

ham_status ham_q_parse_canonical(mpq_t out, const char *s) { return set_parts(out, s, 1); }
ham_status ham_q_set(mpq_t out, const char *s) { return set_parts(out, s, 0); }
