/* SPDX-License-Identifier: AGPL-3.0-only
 * Also licensed under the SnapKitty Opaque License; see LICENSE and
 * SNAPKITTY_OPAQUE_LICENSE.md at the repository root.
 * Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 *
 * LRD-IR native runtime (see lrd_rt.h). Compiled with -ffp-contract=off and
 * without fast-math (validation/FP_POLICY.md). Array I/O goes through the
 * LRD-NUM-ABI (abi/lrd_num_abi.h); LRD-STATE-v1 constants and helpers come from
 * ledger/abi/lrd_state.h (included, not forked).
 */
#define _POSIX_C_SOURCE 200809L
#include "lrd_rt.h"
#include "lrd_rec.h"
#include "lrd_sha256.h"
#include "../../abi/lrd_num_abi.h"
#include "../../ledger/abi/lrd_state.h"

#include <float.h>
#include <math.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

#if LRD_NUM_ABI_VERSION != 1
#error "runtime written against LRD-NUM-ABI version 1"
#endif

typedef struct { int64_t n; char unit[LRD_ARR_UNIT_MAX + 1]; int synthetic; double *d; } rt_arr;
typedef struct { int64_t r, c; int synthetic; double *d; } rt_mat;

static int g_argc;
static char **g_argv;

static void die(int code, const char *op, const char *fmt, ...) {
  va_list ap;
  fflush(stdout);
  fprintf(stderr, "lrd runtime error: %s: ", op);
  va_start(ap, fmt);
  vfprintf(stderr, fmt, ap);
  va_end(ap);
  fputc('\n', stderr);
  exit(code);
}

static void *xmalloc(size_t n) {
  void *p = malloc(n ? n : 1);
  if (!p) die(LRD_EXIT_RUNTIME, "alloc", "out of memory");
  return p;
}

void lrd_rt_init(int32_t argc, char **argv) {
  g_argc = argc;
  g_argv = argv;
  if (lrd_num_abi_version() != LRD_NUM_ABI_VERSION)
    die(LRD_EXIT_RUNTIME, "init", "LRD-NUM-ABI version mismatch: library %d, header %d",
        lrd_num_abi_version(), LRD_NUM_ABI_VERSION);
}

const char *lrd_rt_arg(int32_t i) {
  if (i < 1 || i >= g_argc) die(LRD_EXIT_RUNTIME, "arg", "program argument $%d not supplied (got %d)", i, g_argc - 1);
  return g_argv[i];
}

int32_t lrd_rt_finish(void) {
  if (fflush(stdout)) die(LRD_EXIT_RUNTIME, "finish", "cannot flush stdout");
  return 0;
}

/* ------------------------------------------------------------------ arrays */
void *lrd_arr_new(int64_t n, const char *unit, void *src_a, void *src_b) {
  rt_arr *a = xmalloc(sizeof *a);
  if (n < 0) die(LRD_EXIT_RUNTIME, "alloc", "negative length");
  a->n = n;
  snprintf(a->unit, sizeof a->unit, "%s", unit);
  a->synthetic = (src_a && ((rt_arr *)src_a)->synthetic) || (src_b && ((rt_arr *)src_b)->synthetic);
  a->d = xmalloc((size_t)n * sizeof(double));
  return a;
}
int64_t lrd_arr_len(void *a) { return ((rt_arr *)a)->n; }
double *lrd_arr_data(void *a) { return ((rt_arr *)a)->d; }
const char *lrd_arr_unit(void *a) { return ((rt_arr *)a)->unit; }

void *lrd_load(const char *path, const char *unit) {
  lrd_arr_t x;
  char err[1024];
  rt_arr *a;
  int rc = lrd_arr_read(path, unit, &x, err, sizeof err);
  if (rc) die(LRD_EXIT_RUNTIME, "load", "%s", err);
  a = xmalloc(sizeof *a);
  a->n = x.length;
  snprintf(a->unit, sizeof a->unit, "%s", x.unit);
  a->synthetic = strstr(x.name, "SYNTHETIC") || strstr(x.extra, "SYNTHETIC") || strstr(path, "SYNTHETIC");
  a->d = x.data ? x.data : xmalloc(8);
  return a;
}

void lrd_check_len(void *a, void *b, const char *op) {
  if (((rt_arr *)a)->n != ((rt_arr *)b)->n)
    die(LRD_EXIT_RUNTIME, op, "length mismatch: %lld vs %lld", (long long)((rt_arr *)a)->n, (long long)((rt_arr *)b)->n);
}
void lrd_check_unit(void *a, const char *unit, const char *op) {
  if (strcmp(((rt_arr *)a)->unit, unit))
    die(LRD_EXIT_RUNTIME, op, "unit mismatch: array unit is '%s', operation expects '%s'", ((rt_arr *)a)->unit, unit);
}
void lrd_check_z(double z, const char *op) {
  if (!isfinite(z) || !(z > -1.0)) die(LRD_EXIT_RUNTIME, op, "redshift z=%.17g must be finite and > -1", z);
}
void lrd_check_pos(double x, const char *op) {
  if (!isfinite(x) || !(x > 0.0)) die(LRD_EXIT_RUNTIME, op, "value %.17g must be finite and > 0", x);
}
void lrd_check_all_pos(void *p, const char *op) {
  rt_arr *a = p;
  int64_t i;
  for (i = 0; i < a->n; i++)
    if (!isfinite(a->d[i]) || !(a->d[i] > 0.0)) die(LRD_EXIT_RUNTIME, op, "element %lld = %.17g must be finite and > 0", (long long)i, a->d[i]);
}
void lrd_check_sigma(void *p, const char *op) {
  rt_arr *a = p;
  int64_t i;
  for (i = 0; i < a->n; i++)
    if (!isfinite(a->d[i]) || !(a->d[i] > 0.0)) die(LRD_EXIT_RUNTIME, op, "sigma[%lld] = %.17g must be finite and > 0", (long long)i, a->d[i]);
}

/* ------------------------------------------------------------------ constraints */
int32_t lrd_all_finite(void *p) {
  rt_arr *a = p;
  int64_t i;
  for (i = 0; i < a->n; i++) if (!isfinite(a->d[i])) return 0;
  return 1;
}
int32_t lrd_monotone_inc(void *p) {
  rt_arr *a = p;
  int64_t i;
  for (i = 0; i < a->n; i++) if (!isfinite(a->d[i])) return 0;
  for (i = 1; i < a->n; i++) if (!(a->d[i] > a->d[i - 1])) return 0;
  return 1;
}
int32_t lrd_in_range_s(double x, double lo, double hi) { return isfinite(x) && x >= lo && x <= hi; }
int32_t lrd_in_range(void *p, double lo, double hi) {
  rt_arr *a = p;
  int64_t i;
  for (i = 0; i < a->n; i++) if (!lrd_in_range_s(a->d[i], lo, hi)) return 0;
  return 1;
}
double lrd_get(void *p, int64_t i) {
  rt_arr *a = p;
  if (i < 0 || i >= a->n) die(LRD_EXIT_RUNTIME, "get", "index %lld out of bounds for length %lld", (long long)i, (long long)a->n);
  return a->d[i];
}

/* ------------------------------------------------------------------ matrices (row-major) */
void *lrd_mat(void *p, int64_t r, int64_t c) {
  rt_arr *a = p;
  rt_mat *m;
  if (r < 1 || c < 1 || r > (1 << 20) || c > (1 << 20)) die(LRD_EXIT_RUNTIME, "mat", "bad shape %lldx%lld", (long long)r, (long long)c);
  if (a->n != r * c) die(LRD_EXIT_RUNTIME, "mat", "length mismatch: array length %lld != rows*cols = %lld", (long long)a->n, (long long)(r * c));
  m = xmalloc(sizeof *m);
  m->r = r; m->c = c; m->synthetic = a->synthetic;
  m->d = xmalloc((size_t)(r * c) * sizeof(double));
  memcpy(m->d, a->d, (size_t)(r * c) * sizeof(double));
  return m;
}
void *lrd_matmul(void *pa, void *pb) {
  rt_mat *a = pa, *b = pb, *m;
  int64_t i, j, k;
  if (a->c != b->r) die(LRD_EXIT_RUNTIME, "matmul", "dimension mismatch: %lldx%lld times %lldx%lld",
                        (long long)a->r, (long long)a->c, (long long)b->r, (long long)b->c);
  m = xmalloc(sizeof *m);
  m->r = a->r; m->c = b->c; m->synthetic = a->synthetic || b->synthetic;
  m->d = xmalloc((size_t)(m->r * m->c) * sizeof(double));
  for (i = 0; i < a->r; i++)
    for (j = 0; j < b->c; j++) {
      double s = 0.0;
      for (k = 0; k < a->c; k++) s = s + a->d[i * a->c + k] * b->d[k * b->c + j];
      m->d[i * m->c + j] = s;
    }
  return m;
}
/* LU with partial pivoting (Doolittle, row swaps), then forward/back substitution.
 * Singular: pivot magnitude == 0, or <= n * DBL_EPSILON * max|A_ij| (numerically singular). */
void *lrd_solve(void *pa, void *pb) {
  rt_mat *A = pa;
  rt_arr *b = pb, *x;
  int64_t n = A->r, i, j, k;
  double *lu, *y, amax = 0.0, tol;
  int64_t *perm;
  if (A->r != A->c) die(LRD_EXIT_RUNTIME, "solve", "matrix is %lldx%lld, must be square", (long long)A->r, (long long)A->c);
  if (b->n != n) die(LRD_EXIT_RUNTIME, "solve", "length mismatch: matrix order %lld vs rhs length %lld", (long long)n, (long long)b->n);
  for (i = 0; i < n * n; i++) {
    if (!isfinite(A->d[i])) die(LRD_EXIT_RUNTIME, "solve", "matrix entry %lld is not finite", (long long)i);
    if (fabs(A->d[i]) > amax) amax = fabs(A->d[i]);
  }
  for (i = 0; i < n; i++) if (!isfinite(b->d[i])) die(LRD_EXIT_RUNTIME, "solve", "rhs entry %lld is not finite", (long long)i);
  tol = (double)n * DBL_EPSILON * amax;
  lu = xmalloc((size_t)(n * n) * sizeof(double));
  perm = xmalloc((size_t)n * sizeof(int64_t));
  y = xmalloc((size_t)n * sizeof(double));
  memcpy(lu, A->d, (size_t)(n * n) * sizeof(double));
  for (i = 0; i < n; i++) perm[i] = i;
  for (k = 0; k < n; k++) {
    int64_t p = k;
    double pv = fabs(lu[k * n + k]);
    for (i = k + 1; i < n; i++) if (fabs(lu[i * n + k]) > pv) { pv = fabs(lu[i * n + k]); p = i; }
    if (pv == 0.0 || pv <= tol)
      die(LRD_EXIT_RUNTIME, "solve", "matrix is singular (pivot |%.17g| <= %.3g at column %lld)", pv, tol, (long long)k);
    if (p != k) {
      int64_t t = perm[k]; perm[k] = perm[p]; perm[p] = t;
      for (j = 0; j < n; j++) { double s = lu[k * n + j]; lu[k * n + j] = lu[p * n + j]; lu[p * n + j] = s; }
    }
    for (i = k + 1; i < n; i++) {
      double l = lu[i * n + k] / lu[k * n + k];
      lu[i * n + k] = l;
      for (j = k + 1; j < n; j++) lu[i * n + j] = lu[i * n + j] - l * lu[k * n + j];
    }
  }
  for (i = 0; i < n; i++) {           /* L y = P b */
    double s = b->d[perm[i]];
    for (j = 0; j < i; j++) s = s - lu[i * n + j] * y[j];
    y[i] = s;
  }
  x = lrd_arr_new(n, "1", b, NULL);
  x->synthetic = x->synthetic || A->synthetic;
  for (i = n - 1; i >= 0; i--) {      /* U x = y */
    double s = y[i];
    for (j = i + 1; j < n; j++) s = s - lu[i * n + j] * x->d[j];
    x->d[i] = s / lu[i * n + i];
  }
  free(lu); free(perm); free(y);
  return x;
}
void *lrd_flatten(void *pm) {
  rt_mat *m = pm;
  rt_arr *a = lrd_arr_new(m->r * m->c, "1", NULL, NULL);
  a->synthetic = m->synthetic;
  memcpy(a->d, m->d, (size_t)(m->r * m->c) * sizeof(double));
  return a;
}

/* ------------------------------------------------------------------ ledger / transitions */
static void arr_sha256(rt_arr *a, char hex[65]) {
  lrd_sha256_ctx c;
  unsigned char d[32];
  int64_t i;
  lrd_sha256_init(&c);
  for (i = 0; i < a->n; i++) {   /* the LRD-ARR-v1 .f64 bytes: little-endian binary64 */
    unsigned char b[8];
    uint64_t u;
    int k;
    memcpy(&u, &a->d[i], 8);
    for (k = 0; k < 8; k++) b[k] = (unsigned char)(u >> (8 * k));
    lrd_sha256_update(&c, b, 8);
  }
  lrd_sha256_final(&c, d);
  lrd_hex32(d, hex);
}

void *lrd_ledger_proposal(const char *prev, int64_t seq, void *payload) {
  lrd_rec *r;
  char hex[65], s[32];
  if (!lrd_is_hex256(prev)) die(LRD_EXIT_RUNTIME, "ledger_proposal", "prev_commit must be 64 lowercase hex characters");
  if (seq < 1) die(LRD_EXIT_RUNTIME, "ledger_proposal", "seq must be >= 1 (got %lld)", (long long)seq);
  arr_sha256(payload, hex);
  snprintf(s, sizeof s, "%lld", (long long)seq);
  r = lrd_rec_new();
  if (lrd_rec_set(r, LRD_F_KIND, lrd_kind_token(LRD_KIND_LEDGER_APPEND)) || lrd_rec_set(r, LRD_F_PREV_COMMIT, prev) ||
      lrd_rec_set(r, LRD_F_SEQ, s) || lrd_rec_set(r, LRD_F_PAYLOAD_SHA256, hex))
    die(LRD_EXIT_RUNTIME, "ledger_proposal", "cannot build record");
  return r;
}

static int is_token(const char *s) {
  size_t n = strlen(s), i;
  if (n == 0 || n > LRD_REASON_MAX) return 0;
  for (i = 0; i < n; i++) if (!((s[i] >= 'a' && s[i] <= 'z') || (s[i] >= '0' && s[i] <= '9') || s[i] == '_')) return 0;
  return 1;
}

void *lrd_gate(const char *verifier, void *prop) {
  lrd_rec *p = prop, *d, *st;
  size_t slen, olen = 0, cap = 65536;
  char *ser = lrd_rec_serialize(p, &slen), *out = xmalloc(cap + 1), err[256], tmpl[4096];
  const char *dec, *reason, *nc, *tmpdir = getenv("TMPDIR");
  int fd, pfd[2], status;
  ssize_t k;
  pid_t pid;
  size_t i;

  snprintf(tmpl, sizeof tmpl, "%s/lrd-proposal.XXXXXX", tmpdir && *tmpdir ? tmpdir : "/tmp");
  fd = mkstemp(tmpl);
  if (fd < 0) die(LRD_EXIT_GATE, "gate", "cannot create proposal temp file");
  unlink(tmpl);
  if (write(fd, ser, slen) != (ssize_t)slen || lseek(fd, 0, SEEK_SET) != 0) die(LRD_EXIT_GATE, "gate", "cannot write proposal");
  free(ser);
  if (pipe(pfd)) die(LRD_EXIT_GATE, "gate", "pipe failed");
  fflush(stdout);
  pid = fork();
  if (pid < 0) die(LRD_EXIT_GATE, "gate", "fork failed");
  if (pid == 0) {
    char *av[2];
    av[0] = (char *)verifier; av[1] = NULL;
    dup2(fd, 0); dup2(pfd[1], 1);
    close(pfd[0]); close(pfd[1]); close(fd);
    execv(verifier, av);
    _exit(127);
  }
  close(fd); close(pfd[1]);
  while ((k = read(pfd[0], out + olen, cap - olen)) > 0) olen += (size_t)k;
  if (k == 0 && olen == cap) { char c; if (read(pfd[0], &c, 1) > 0) { close(pfd[0]); waitpid(pid, &status, 0); die(LRD_EXIT_GATE, "gate", "verifier output malformed: exceeds %zu bytes; no new state constructed", cap); } }
  close(pfd[0]);
  if (waitpid(pid, &status, 0) != pid) die(LRD_EXIT_GATE, "gate", "waitpid failed");
  if (!WIFEXITED(status) || WEXITSTATUS(status) != 0)
    die(LRD_EXIT_GATE, "gate", "verifier '%s' failed (status %d); no new state constructed", verifier,
        WIFEXITED(status) ? WEXITSTATUS(status) : -1);
  out[olen] = '\0';
  d = lrd_rec_parse(out, olen, err, sizeof err);
  if (!d) die(LRD_EXIT_GATE, "gate", "verifier output malformed: %s; no new state constructed", err);
  for (i = 0; i < d->n; i++)
    if (strcmp(d->f[i].key, LRD_F_DECISION) && strcmp(d->f[i].key, LRD_F_REASON) && strcmp(d->f[i].key, LRD_F_NEW_COMMIT))
      die(LRD_EXIT_GATE, "gate", "verifier output malformed: unexpected field '%s'; no new state constructed", d->f[i].key);
  dec = lrd_rec_get(d, LRD_F_DECISION);
  reason = lrd_rec_get(d, LRD_F_REASON);
  nc = lrd_rec_get(d, LRD_F_NEW_COMMIT);
  if (!dec) die(LRD_EXIT_GATE, "gate", "verifier output malformed: missing decision; no new state constructed");
  if (!reason || !is_token(reason)) die(LRD_EXIT_GATE, "gate", "verifier output malformed: missing or invalid reason; no new state constructed");
  if (!strcmp(dec, LRD_DECISION_TOKEN_REJECT)) {
    if (nc) die(LRD_EXIT_GATE, "gate", "verifier output malformed: new_commit present on REJECT; no new state constructed");
    die(LRD_EXIT_GATE, "gate", "transition rejected: reason=%s; no new state constructed", reason);
  }
  if (strcmp(dec, LRD_DECISION_TOKEN_ACCEPT))
    die(LRD_EXIT_GATE, "gate", "verifier output malformed: decision '%s' is neither ACCEPT nor REJECT; no new state constructed", dec);
  if (!nc || !lrd_is_hex256(nc))
    die(LRD_EXIT_GATE, "gate", "verifier output malformed: ACCEPT without valid new_commit; no new state constructed");
  st = lrd_rec_new();
  if (lrd_rec_set(st, LRD_F_COMMIT, nc) || lrd_rec_set(st, LRD_F_KIND, lrd_rec_get(p, LRD_F_KIND)) ||
      lrd_rec_set(st, LRD_F_PAYLOAD_SHA256, lrd_rec_get(p, LRD_F_PAYLOAD_SHA256)) ||
      lrd_rec_set(st, LRD_F_SEQ, lrd_rec_get(p, LRD_F_SEQ)))
    die(LRD_EXIT_GATE, "gate", "cannot construct state");
  printf("gate: ACCEPT reason=%s new_commit=%s\n", reason, nc);
  lrd_rec_free(d);
  free(out);
  return st;
}

void lrd_emit(void *r, const char *path) {
  size_t n;
  char *s = lrd_rec_serialize(r, &n);
  FILE *f = fopen(path, "wb");
  if (!f || fwrite(s, 1, n, f) != n || fclose(f)) die(LRD_EXIT_RUNTIME, "emit", "cannot write %s", path);
  free(s);
}

/* ------------------------------------------------------------------ output */
static void store(const char *path, const double *d, int64_t n, const char *unit, int synthetic) {
  char err[1024];
  const char *base = strrchr(path, '/');
  base = base ? base + 1 : path;
  if (lrd_arr_write(path, base, unit, d, n,
                    synthetic ? "note=SYNTHETIC (derived from SYNTHETIC input by an lrdc program)\n" : "note=derived by an lrdc program\n",
                    err, sizeof err))
    die(LRD_EXIT_RUNTIME, "store", "%s", err);
}
void lrd_store_arr(void *p, const char *path) { rt_arr *a = p; store(path, a->d, a->n, a->unit, a->synthetic); }
void lrd_store_f64(double x, const char *path) { store(path, &x, 1, "1", 0); }
void lrd_assert(int32_t b, const char *msg) { if (!b) die(LRD_EXIT_RUNTIME, "assert", "constraint failed: %s", msg); }

void lrd_print_f64(const char *name, double x) { printf("%s = %.17g\n", name, x); }
void lrd_print_i64(const char *name, int64_t x) { printf("%s = %lld\n", name, (long long)x); }
void lrd_print_bool(const char *name, int32_t b) { printf("%s = %s\n", name, b ? "true" : "false"); }
void lrd_print_arr(const char *name, void *p) {
  rt_arr *a = p;
  int64_t i;
  printf("%s : arr<f64> length=%lld unit=%s\n", name, (long long)a->n, a->unit);
  for (i = 0; i < a->n; i++) printf("%s[%lld] = %.17g\n", name, (long long)i, a->d[i]);
}
void lrd_print_mat(const char *name, void *p) {
  rt_mat *m = p;
  int64_t i, j;
  printf("%s : mat<f64> %lldx%lld\n", name, (long long)m->r, (long long)m->c);
  for (i = 0; i < m->r; i++)
    for (j = 0; j < m->c; j++) printf("%s[%lld,%lld] = %.17g\n", name, (long long)i, (long long)j, m->d[i * m->c + j]);
}
void lrd_print_rec(const char *name, void *p) {
  char hex[65];
  size_t i;
  lrd_rec *r = p;
  lrd_rec_commit(r, hex);
  printf("%s : rec commit=%s\n", name, hex);
  for (i = 0; i < r->n; i++) printf("%s.%s = %s\n", name, r->f[i].key, r->f[i].value);
}
