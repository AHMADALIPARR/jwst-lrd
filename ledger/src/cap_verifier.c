/* Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 * Dual-licensed: AGPL-3.0-or-later plus SnapKitty Opaque License.
 * SPDX-License-Identifier: AGPL-3.0-or-later AND LicenseRef-SnapKitty-Opaque
 *
 * lrd-capverifier -- TASK 010 capability authority / verifier process.
 * This is the ONLY program that holds or uses the Ed25519 signing key, and the only writer of
 * the authoritative state log VDIR/state.log (created 0600, opened O_APPEND, fsync'd per entry).
 *
 *   lrd-capverifier init     VDIR
 *   lrd-capverifier submit   VDIR PROPOSAL_FILE OUT_CAP_FILE
 *   lrd-capverifier check    VDIR CAP_FILE [--current]
 *   lrd-capverifier retire   VDIR CAP_ID
 *   lrd-capverifier state-at VDIR SEQ
 *   lrd-capverifier head     VDIR
 *
 * submit/check print an LRD-STATE-v1 decision record (LRD-REC-v1) on stdout.
 * Exit: 0 ACCEPT/ok, 1 REJECT, 2 usage/IO error, 3 state log corrupt (refuses to operate).
 *
 * Log line grammar (one entry per line, chained and signed):
 *   A seq=<n> cap_id=<id> nonce=<hex32> payload_sha256=<hex64> prev_commit=<hex64> new_commit=<hex64> chain=<hex64> sig=<hex128>
 *   R cap_id=<id> chain=<hex64> sig=<hex128>
 * body  = the line up to (excluding) " chain="
 * chain = SHA-256hex("LRD-CAPLOG-v1\0" || prev_chain_hex || " " || body), prev_chain of first = 64 zeros
 * sig   = Ed25519("LRD-CAPLOG-SIG-v1\0" || chain_hex)
 */
#define _POSIX_C_SOURCE 200809L
#include "lrd_cap.h"

#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/file.h>
#include <sys/stat.h>
#include <unistd.h>
#include <openssl/pem.h>
#include <openssl/rand.h>

#define LOG_DOMAIN     "LRD-CAPLOG-v1"       /* + NUL = 14 bytes */
#define LOG_SIG_DOMAIN "LRD-CAPLOG-SIG-v1"   /* + NUL = 18 bytes */

typedef struct {
  uint64_t seq;
  char cap_id[LRD_CAP_ID_MAX + 1], nonce[LRD_CAP_NONCE_HEX + 1];
  char payload[LRD_HEX256_BUF], prev[LRD_HEX256_BUF], newc[LRD_HEX256_BUF];
} entry_t;

typedef struct {
  entry_t *e; size_t n, cap;              /* accepted states, e[i].seq == i+1 */
  char **retired; size_t nret, capret;
  char chain[LRD_HEX256_BUF];             /* chain value after last line */
  EVP_PKEY *priv, *pub;
  char dir[4096];
} vstate_t;

static void path_of(char *out, size_t sz, const char *dir, const char *name) {
  snprintf(out, sz, "%s/%s", dir, name);
}

/* ------------------------------------------------------------------ crypto */
static int ed_sign(EVP_PKEY *k, const unsigned char *m, size_t n, unsigned char sig[64]) {
  EVP_MD_CTX *c = EVP_MD_CTX_new(); size_t sl = 64;
  int ok = c && EVP_DigestSignInit(c, NULL, NULL, NULL, k) == 1 && EVP_DigestSign(c, sig, &sl, m, n) == 1 && sl == 64;
  EVP_MD_CTX_free(c);
  return ok ? 0 : -1;
}

static void chain_next(const char *prev, const char *body, char out[LRD_HEX256_BUF]) {
  size_t bl = strlen(body);
  unsigned char *b = malloc(14 + 64 + 1 + bl);
  memcpy(b, LOG_DOMAIN, 14); memcpy(b + 14, prev, 64); b[78] = ' '; memcpy(b + 79, body, bl);
  lrd_sha256_hex(b, 79 + bl, out);
  free(b);
}

static void log_sig_msg(const char *chain, unsigned char m[18 + 64]) {
  memcpy(m, LOG_SIG_DOMAIN, 18); memcpy(m + 18, chain, 64);
}

static int retired(const vstate_t *v, const char *id) {
  for (size_t i = 0; i < v->nret; i++) if (strcmp(v->retired[i], id) == 0) return 1;
  return 0;
}
static int nonce_used(const vstate_t *v, const char *nonce) {
  for (size_t i = 0; i < v->n; i++) if (strcmp(v->e[i].nonce, nonce) == 0) return 1;
  return 0;
}
static const char *head_commit(const vstate_t *v) { return v->n ? v->e[v->n - 1].newc : LRD_GENESIS_COMMIT; }

/* ------------------------------------------------------------------ log load (full re-verification) */
static int get_tok(char **p, const char *key, char *out, size_t outsz) {
  size_t kl = strlen(key);
  if (strncmp(*p, key, kl) != 0 || (*p)[kl] != '=') return -1;
  char *v = *p + kl + 1, *end = strchr(v, ' ');
  size_t vl = end ? (size_t)(end - v) : strlen(v);
  if (vl == 0 || vl >= outsz) return -1;
  memcpy(out, v, vl); out[vl] = 0;
  *p = end ? end + 1 : v + vl;
  return 0;
}

static int load(vstate_t *v, const char *dir, int need_priv) {
  memset(v, 0, sizeof *v);
  snprintf(v->dir, sizeof v->dir, "%s", dir);
  strcpy(v->chain, LRD_GENESIS_COMMIT);
  char p[4200];
  path_of(p, sizeof p, dir, "authority.pub");
  if (!(v->pub = lrd_load_pubkey(p))) { fprintf(stderr, "lrd-capverifier: cannot load %s\n", p); return 2; }
  if (need_priv) {
    path_of(p, sizeof p, dir, "authority.key");
    FILE *f = fopen(p, "r");
    if (!f) { fprintf(stderr, "lrd-capverifier: cannot open %s\n", p); return 2; }
    v->priv = PEM_read_PrivateKey(f, NULL, NULL, NULL);
    fclose(f);
    if (!v->priv) return 2;
  }
  path_of(p, sizeof p, dir, "state.log");
  unsigned char *buf; size_t n;
  if (lrd_slurp(p, &buf, &n)) { fprintf(stderr, "lrd-capverifier: cannot read %s\n", p); return 2; }
  int rc = 0; size_t i = 0, lineno = 0;
  while (i < n) {
    unsigned char *nl = memchr(buf + i, '\n', n - i);
    if (!nl) { rc = 3; break; }                       /* torn / unterminated last line */
    *nl = 0; char *line = (char *)buf + i; i = (size_t)(nl - buf) + 1; lineno++;
    if (strlen(line) != (size_t)(nl - (unsigned char *)line)) { rc = 3; break; }
    char *cp = strstr(line, " chain=");
    if (!cp) { rc = 3; break; }
    *cp = 0;
    char *tail = cp + 1, chain[LRD_HEX256_BUF], sighex[130], want[LRD_HEX256_BUF];
    if (get_tok(&tail, "chain", chain, sizeof chain) || get_tok(&tail, "sig", sighex, sizeof sighex) || *tail) { rc = 3; break; }
    chain_next(v->chain, line, want);
    unsigned char sig[64], m[82];
    if (strcmp(want, chain) || strlen(sighex) != 128 || lrd_hex_decode(sighex, sig, 64)) { rc = 3; break; }
    log_sig_msg(chain, m);
    if (!lrd_ed25519_verify(v->pub, m, sizeof m, sig, 64)) { rc = 3; break; }
    char *q = line;
    if (q[0] == 'A' && q[1] == ' ') {
      q += 2; entry_t e; char sq[24];
      if (get_tok(&q, "seq", sq, sizeof sq) || get_tok(&q, "cap_id", e.cap_id, sizeof e.cap_id) ||
          get_tok(&q, "nonce", e.nonce, sizeof e.nonce) || get_tok(&q, "payload_sha256", e.payload, sizeof e.payload) ||
          get_tok(&q, "prev_commit", e.prev, sizeof e.prev) || get_tok(&q, "new_commit", e.newc, sizeof e.newc) || *q ||
          lrd_parse_u64(sq, &e.seq)) { rc = 3; break; }
      char nc[LRD_HEX256_BUF];
      /* semantic re-check of every historical transition */
      if (e.seq != v->n + 1 || strcmp(e.prev, head_commit(v)) || nonce_used(v, e.nonce) ||
          lrd_cap_state_commit(e.prev, e.payload, e.seq, nc) || strcmp(nc, e.newc)) { rc = 3; break; }
      if (v->n == v->cap) { v->cap = v->cap ? 2 * v->cap : 16; v->e = realloc(v->e, v->cap * sizeof *v->e); }
      v->e[v->n++] = e;
    } else if (q[0] == 'R' && q[1] == ' ') {
      q += 2; char id[LRD_CAP_ID_MAX + 1];
      if (get_tok(&q, "cap_id", id, sizeof id) || *q || !lrd_cap_valid_id(id)) { rc = 3; break; }
      if (v->nret == v->capret) { v->capret = v->capret ? 2 * v->capret : 8; v->retired = realloc(v->retired, v->capret * sizeof *v->retired); }
      v->retired[v->nret++] = strdup(id);
    } else { rc = 3; break; }
    strcpy(v->chain, chain);
  }
  free(buf);
  if (rc == 3) fprintf(stderr, "lrd-capverifier: state_corrupt at log line %zu; refusing to operate\n", lineno);
  return rc;
}

static void vfree(vstate_t *v) {
  for (size_t i = 0; i < v->nret; i++) free(v->retired[i]);
  free(v->retired); free(v->e);
  EVP_PKEY_free(v->priv); EVP_PKEY_free(v->pub);
}

/* Append one signed, chained line; fsync. */
static int log_append(vstate_t *v, const char *body) {
  char chain[LRD_HEX256_BUF], sighex[129];
  unsigned char m[82], sig[64];
  chain_next(v->chain, body, chain);
  log_sig_msg(chain, m);
  if (ed_sign(v->priv, m, sizeof m, sig)) return -1;
  lrd_hex_encode(sig, 64, sighex);
  char p[4200]; path_of(p, sizeof p, v->dir, "state.log");
  int fd = open(p, O_WRONLY | O_APPEND);
  if (fd < 0) return -1;
  size_t ll = strlen(body) + 7 + 64 + 5 + 128 + 2;
  char *line = malloc(ll + 1);
  int len = snprintf(line, ll + 1, "%s chain=%s sig=%s\n", body, chain, sighex);
  ssize_t w = write(fd, line, (size_t)len);
  free(line);
  if (w != len || fsync(fd)) { close(fd); return -1; }
  close(fd);
  strcpy(v->chain, chain);
  return 0;
}

static int lock_dir(const char *dir) {
  char p[4200]; path_of(p, sizeof p, dir, "state.log");
  int fd = open(p, O_RDONLY);
  if (fd < 0 || flock(fd, LOCK_EX)) return -1;
  return fd;    /* released at process exit */
}

static void print_decision(int accept, const char *reason, const char *newc) {
  lrd_decision_t d;
  if (accept) {
    d.decision = LRD_DECISION_ACCEPT;
    snprintf(d.reason, sizeof d.reason, "%s", reason);
    snprintf(d.new_commit, sizeof d.new_commit, "%s", newc ? newc : "");
  } else lrd_decision_reject(&d, reason);
  lrd_rec_t r; lrd_rec_init(&r);
  lrd_rec_set(&r, LRD_F_DECISION, d.decision == LRD_DECISION_ACCEPT ? LRD_DECISION_TOKEN_ACCEPT : LRD_DECISION_TOKEN_REJECT);
  lrd_rec_set(&r, LRD_F_REASON, d.reason);
  if (d.decision == LRD_DECISION_ACCEPT && d.new_commit[0]) lrd_rec_set(&r, LRD_F_NEW_COMMIT, d.new_commit);
  unsigned char *s; size_t n;
  if (lrd_rec_serialize(&r, &s, &n) == 0) { fwrite(s, 1, n, stdout); free(s); }
  lrd_rec_free(&r);
}

/* ------------------------------------------------------------------ LRD-STATE-v1 transition */
static vstate_t *G;   /* verifier context for the transition function */

static lrd_decision_code_t cap_transition(const lrd_state_t *cur, const lrd_proposal_t *pr,
                                          lrd_decision_t *out, lrd_state_t *next) {
  const char *cap_id = NULL, *nonce = NULL;
  for (size_t i = 0; i < pr->n_extra; i++) {
    if (strcmp(pr->extra[i].key, "cap_id") == 0) cap_id = pr->extra[i].value;
    else if (strcmp(pr->extra[i].key, "nonce") == 0) nonce = pr->extra[i].value;
  }
  const char *head = head_commit(G);
  if (pr->kind != LRD_KIND_CAPABILITY) { lrd_decision_reject(out, "bad_kind"); return LRD_DECISION_REJECT; }
  if (!cap_id || !nonce || !lrd_cap_valid_id(cap_id) || !lrd_cap_valid_nonce(nonce) ||
      !lrd_is_hex256(pr->prev_commit) || !lrd_is_hex256(pr->payload_sha256)) {
    lrd_decision_reject(out, "bad_record"); return LRD_DECISION_REJECT;
  }
  if (retired(G, cap_id)) { lrd_decision_reject(out, "retired"); return LRD_DECISION_REJECT; }
  if (nonce_used(G, nonce)) { lrd_decision_reject(out, "replay_nonce"); return LRD_DECISION_REJECT; }
  if (cur->seq == UINT64_MAX || pr->seq <= cur->seq) { lrd_decision_reject(out, LRD_REASON_STALE_SEQ); return LRD_DECISION_REJECT; }
  if (pr->seq != cur->seq + 1) { lrd_decision_reject(out, "seq_gap"); return LRD_DECISION_REJECT; }
  if (strcmp(pr->prev_commit, head) != 0) { lrd_decision_reject(out, LRD_REASON_BAD_PREV); return LRD_DECISION_REJECT; }
  char nc[LRD_HEX256_BUF];
  if (lrd_cap_state_commit(pr->prev_commit, pr->payload_sha256, pr->seq, nc)) { lrd_decision_reject(out, "internal"); return LRD_DECISION_REJECT; }
  out->decision = LRD_DECISION_ACCEPT;
  strcpy(out->reason, LRD_REASON_OK);
  strcpy(out->new_commit, nc);
  if (next) {
    next->seq = pr->seq; next->kind = LRD_KIND_CAPABILITY;
    strcpy(next->commit, pr->prev_commit); strcpy(next->payload_sha256, pr->payload_sha256);
  }
  return LRD_DECISION_ACCEPT;
}

/* ------------------------------------------------------------------ commands */
static int cmd_init(const char *dir) {
  if (mkdir(dir, 0700) && errno != EEXIST) { perror(dir); return 2; }
  if (chmod(dir, 0700)) { perror(dir); return 2; }
  char p[4200];
  EVP_PKEY_CTX *c = EVP_PKEY_CTX_new_id(EVP_PKEY_ED25519, NULL);
  EVP_PKEY *k = NULL;
  if (!c || EVP_PKEY_keygen_init(c) != 1 || EVP_PKEY_keygen(c, &k) != 1) { EVP_PKEY_CTX_free(c); return 2; }
  EVP_PKEY_CTX_free(c);
  path_of(p, sizeof p, dir, "authority.key");
  int fd = open(p, O_WRONLY | O_CREAT | O_EXCL, 0600);
  if (fd < 0) { perror(p); EVP_PKEY_free(k); return 2; }
  FILE *f = fdopen(fd, "w");
  int ok = f && PEM_write_PrivateKey(f, k, NULL, NULL, 0, NULL, NULL) == 1 && fflush(f) == 0 && fsync(fd) == 0;
  if (f) fclose(f);
  if (!ok) { EVP_PKEY_free(k); return 2; }
  path_of(p, sizeof p, dir, "authority.pub");
  fd = open(p, O_WRONLY | O_CREAT | O_EXCL, 0644);
  if (fd < 0) { perror(p); EVP_PKEY_free(k); return 2; }
  f = fdopen(fd, "w");
  ok = f && PEM_write_PUBKEY(f, k) == 1 && fflush(f) == 0 && fsync(fd) == 0;
  if (f) fclose(f);
  EVP_PKEY_free(k);
  if (!ok) return 2;
  path_of(p, sizeof p, dir, "state.log");
  if (lrd_write_file(p, "", 0, 0600, 1)) { perror(p); return 2; }
  if (lrd_fsync_dir(dir)) return 2;
  printf("OK init %s\n", dir);
  return 0;
}

static int cmd_submit(const char *dir, const char *prop, const char *capout) {
  int lk = lock_dir(dir); if (lk < 0) return 2;
  vstate_t v; int rc = load(&v, dir, 1);
  if (rc) { vfree(&v); return rc; }
  G = &v;
  unsigned char *b; size_t n;
  if (lrd_slurp(prop, &b, &n)) { vfree(&v); return 2; }
  lrd_rec_t r; lrd_rec_init(&r);
  int prc = lrd_rec_parse(b, n, &r, NULL); free(b);
  if (prc) { print_decision(0, "bad_record", NULL); vfree(&v); return 1; }
  static const char *const want[] = { "cap_id", "kind", "nonce", "payload_sha256", "prev_commit", "seq" };
  int shape = r.n == 6;
  for (size_t i = 0; shape && i < 6; i++) shape = strcmp(r.key[i], want[i]) == 0;
  lrd_proposal_t pr; memset(&pr, 0, sizeof pr);
  if (!shape || lrd_parse_u64(lrd_rec_get(&r, "seq"), &pr.seq) ||
      strlen(lrd_rec_get(&r, "prev_commit")) != 64 || strlen(lrd_rec_get(&r, "payload_sha256")) != 64) {
    print_decision(0, "bad_record", NULL); lrd_rec_free(&r); vfree(&v); return 1;
  }
  const char *kt = lrd_rec_get(&r, "kind");
  pr.kind = lrd_kind_from_token(kt, strlen(kt));
  strcpy(pr.prev_commit, lrd_rec_get(&r, "prev_commit"));
  strcpy(pr.payload_sha256, lrd_rec_get(&r, "payload_sha256"));
  lrd_field_t ex[2] = {
    { "cap_id", 6, lrd_rec_get(&r, "cap_id"), strlen(lrd_rec_get(&r, "cap_id")) },
    { "nonce", 5, lrd_rec_get(&r, "nonce"), strlen(lrd_rec_get(&r, "nonce")) },
  };
  pr.extra = ex; pr.n_extra = 2;
  lrd_state_t cur; memset(&cur, 0, sizeof cur);
  cur.seq = v.n; cur.kind = LRD_KIND_CAPABILITY;
  if (v.n) { strcpy(cur.commit, v.e[v.n - 1].prev); strcpy(cur.payload_sha256, v.e[v.n - 1].payload); }
  else { strcpy(cur.commit, LRD_GENESIS_COMMIT); memset(cur.payload_sha256, '0', 64); cur.payload_sha256[64] = 0; }
  lrd_decision_t d; lrd_state_t next;
  if (cap_transition(&cur, &pr, &d, &next) != LRD_DECISION_ACCEPT) {
    print_decision(0, d.reason, NULL); lrd_rec_free(&r); vfree(&v); return 1;
  }
  /* durable append FIRST, then issue the capability */
  char body[512];
  snprintf(body, sizeof body, "A seq=%llu cap_id=%s nonce=%s payload_sha256=%s prev_commit=%s new_commit=%s",
           (unsigned long long)pr.seq, ex[0].value, ex[1].value, pr.payload_sha256, pr.prev_commit, d.new_commit);
  if (log_append(&v, body)) { fprintf(stderr, "lrd-capverifier: log append failed\n"); lrd_rec_free(&r); vfree(&v); return 2; }
  lrd_rec_t cap; lrd_rec_init(&cap);
  char sq[24]; snprintf(sq, sizeof sq, "%llu", (unsigned long long)pr.seq);
  lrd_rec_set(&cap, "cap_id", ex[0].value); lrd_rec_set(&cap, "kind", "capability");
  lrd_rec_set(&cap, "new_commit", d.new_commit); lrd_rec_set(&cap, "nonce", ex[1].value);
  lrd_rec_set(&cap, "payload_sha256", pr.payload_sha256); lrd_rec_set(&cap, "prev_commit", pr.prev_commit);
  lrd_rec_set(&cap, "seq", sq);
  unsigned char *m, sig[64]; size_t ml; char sighex[129];
  if (lrd_cap_signing_bytes(&cap, &m, &ml) || ed_sign(v.priv, m, ml, sig)) { lrd_rec_free(&cap); lrd_rec_free(&r); vfree(&v); return 2; }
  free(m);
  lrd_hex_encode(sig, 64, sighex);
  lrd_rec_set(&cap, "sig", sighex);
  unsigned char *cs; size_t cl;
  lrd_rec_serialize(&cap, &cs, &cl);
  rc = lrd_write_file(capout, cs, cl, 0644, 0) ? 2 : 0;
  free(cs); lrd_rec_free(&cap); lrd_rec_free(&r);
  if (rc == 0) print_decision(1, LRD_REASON_OK, d.new_commit);
  vfree(&v);
  return rc;
}

static int cmd_check(const char *dir, const char *capf, int current) {
  vstate_t v; int rc = load(&v, dir, 0);
  if (rc) { vfree(&v); return rc; }
  unsigned char *b; size_t n;
  if (lrd_slurp(capf, &b, &n)) { vfree(&v); return 2; }
  lrd_rec_t c; const char *why = NULL;
  int vr = lrd_cap_verify_bytes(v.pub, b, n, &c, &why); free(b);
  if (vr) { print_decision(0, why, NULL); vfree(&v); return 1; }
  uint64_t seq; lrd_parse_u64(lrd_rec_get(&c, "seq"), &seq);
  const char *reason = NULL;
  if (retired(&v, lrd_rec_get(&c, "cap_id"))) reason = "retired";
  else if (seq > v.n) reason = "unknown_seq";
  else {
    const entry_t *e = &v.e[seq - 1];
    if (strcmp(e->nonce, lrd_rec_get(&c, "nonce")) || strcmp(e->cap_id, lrd_rec_get(&c, "cap_id")) ||
        strcmp(e->newc, lrd_rec_get(&c, "new_commit")) || strcmp(e->prev, lrd_rec_get(&c, "prev_commit")) ||
        strcmp(e->payload, lrd_rec_get(&c, "payload_sha256"))) reason = "not_in_log";
    else if (current && seq != v.n) reason = LRD_REASON_STALE_SEQ;
  }
  if (reason) print_decision(0, reason, NULL); else print_decision(1, LRD_REASON_OK, lrd_rec_get(&c, "new_commit"));
  lrd_rec_free(&c); vfree(&v);
  return reason ? 1 : 0;
}

static int cmd_retire(const char *dir, const char *id) {
  if (!lrd_cap_valid_id(id)) return 2;
  int lk = lock_dir(dir); if (lk < 0) return 2;
  vstate_t v; int rc = load(&v, dir, 1);
  if (rc) { vfree(&v); return rc; }
  char body[128]; snprintf(body, sizeof body, "R cap_id=%s", id);
  rc = log_append(&v, body) ? 2 : 0;
  if (!rc) printf("OK retired %s\n", id);
  vfree(&v);
  return rc;
}

static int cmd_state_at(const char *dir, const char *sseq) {
  vstate_t v; int rc = load(&v, dir, 0);
  if (rc) { vfree(&v); return rc; }
  uint64_t s;
  if (lrd_parse_u64(sseq, &s) || s > v.n) { print_decision(0, "unknown_seq", NULL); vfree(&v); return 1; }
  lrd_rec_t r; lrd_rec_init(&r);
  char sq[24]; snprintf(sq, sizeof sq, "%llu", (unsigned long long)s);
  lrd_rec_set(&r, "seq", sq);
  if (s == 0) { lrd_rec_set(&r, "state_commit", LRD_GENESIS_COMMIT); }
  else {
    const entry_t *e = &v.e[s - 1];
    lrd_rec_set(&r, "cap_id", e->cap_id); lrd_rec_set(&r, "commit", e->prev);
    lrd_rec_set(&r, "kind", "capability"); lrd_rec_set(&r, "payload_sha256", e->payload);
    lrd_rec_set(&r, "state_commit", e->newc);
  }
  unsigned char *o; size_t ol; lrd_rec_serialize(&r, &o, &ol); fwrite(o, 1, ol, stdout); free(o);
  lrd_rec_free(&r); vfree(&v);
  return 0;
}

static int cmd_head(const char *dir) {
  vstate_t v; int rc = load(&v, dir, 0);
  if (!rc) printf("%zu %s\n", v.n, head_commit(&v));
  vfree(&v);
  return rc;
}

int main(int argc, char **argv) {
  if (argc == 3 && !strcmp(argv[1], "init")) return cmd_init(argv[2]);
  if (argc == 5 && !strcmp(argv[1], "submit")) return cmd_submit(argv[2], argv[3], argv[4]);
  if ((argc == 4 || (argc == 5 && !strcmp(argv[4], "--current"))) && !strcmp(argv[1], "check"))
    return cmd_check(argv[2], argv[3], argc == 5);
  if (argc == 4 && !strcmp(argv[1], "retire")) return cmd_retire(argv[2], argv[3]);
  if (argc == 4 && !strcmp(argv[1], "state-at")) return cmd_state_at(argv[2], argv[3]);
  if (argc == 3 && !strcmp(argv[1], "head")) return cmd_head(argv[2]);
  fprintf(stderr, "usage: lrd-capverifier init|submit|check|retire|state-at|head VDIR ...\n");
  return 2;
}
