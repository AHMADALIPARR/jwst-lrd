/* SPDX-License-Identifier: AGPL-3.0-only
 * Also licensed under the SnapKitty Opaque License; see LICENSE and
 * SNAPKITTY_OPAQUE_LICENSE.md at the repository root.
 * Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 *
 * lrdc: compiler for LRD-IR (grammar in llvm/LRD-IR.md).
 *   parse -> type check -> lower to LLVM IR text (.ll) -> llc -> clang link
 *   with the LRD-IR runtime (llvm/runtime) -> native executable.
 *
 * usage: lrdc -S [-o OUT.ll|-] IN.lrd             emit LLVM IR only
 *        lrdc -o OUT [--runtime-lib LIB] IN.lrd     build native executable
 *                                                   (keeps OUT.ll and OUT.o)
 * Any parse or type error: message "lrdc: error: FILE:LINE: ..." and exit 1.
 * Output is deterministic: no timestamps, no absolute paths, fixed ordering.
 * FP policy (validation/FP_POLICY.md): the emitted IR carries no fast-math or
 * contract flags; llc and clang are invoked with fp-contract=off.
 */
#define _POSIX_C_SOURCE 200809L
#include <ctype.h>
#include <errno.h>
#include <inttypes.h>
#include <math.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <unistd.h>

#define LRDC_VERSION "0.1.0"
#ifndef LRDC_LLC
#define LRDC_LLC "/usr/bin/llc"
#endif
#ifndef LRDC_CLANG
#define LRDC_CLANG "/usr/bin/clang"
#endif
#ifndef LRDC_RUNTIME_LIB
#define LRDC_RUNTIME_LIB ""
#endif

/* ------------------------------------------------------------------ diagnostics */
static const char *g_file = "<input>";
static int g_line;

static void die(const char *fmt, ...) {
  va_list ap;
  fprintf(stderr, "lrdc: error: %s:%d: ", g_file, g_line);
  va_start(ap, fmt);
  vfprintf(stderr, fmt, ap);
  va_end(ap);
  fputc('\n', stderr);
  exit(1);
}
static void fatal(const char *fmt, ...) {
  va_list ap;
  fprintf(stderr, "lrdc: error: ");
  va_start(ap, fmt);
  vfprintf(stderr, fmt, ap);
  va_end(ap);
  fputc('\n', stderr);
  exit(1);
}

/* ------------------------------------------------------------------ string buffer */
typedef struct { char *p; size_t n, cap; } Buf;
static void bprintf(Buf *b, const char *fmt, ...) {
  va_list ap;
  int k;
  for (;;) {
    size_t room = b->cap - b->n;
    va_start(ap, fmt);
    k = vsnprintf(b->p ? b->p + b->n : NULL, b->p ? room : 0, fmt, ap);
    va_end(ap);
    if (k < 0) fatal("formatting failure");
    if (b->p && (size_t)k < room) { b->n += (size_t)k; return; }
    b->cap = (b->cap + (size_t)k + 1) * 2;
    b->p = realloc(b->p, b->cap);
    if (!b->p) fatal("out of memory");
  }
}

/* ------------------------------------------------------------------ types */
typedef enum { T_NONE, T_F64, T_I64, T_BOOL, T_ARR, T_MAT, T_REC, T_STR } Ty;
static const char *tyname(Ty t) {
  switch (t) {
    case T_F64: return "f64"; case T_I64: return "i64"; case T_BOOL: return "bool";
    case T_ARR: return "arr<f64>"; case T_MAT: return "mat<f64>"; case T_REC: return "rec";
    case T_STR: return "str"; default: return "<none>";
  }
}

/* ------------------------------------------------------------------ lexer */
typedef enum { K_EOL, K_ID, K_NUM, K_STR, K_ARG, K_PUNCT } Kind;
typedef struct { Kind k; char s[512]; } Tok;
static Tok toks[256];
static int ntok, tpos;

static void lex_line(const char *l) {
  const char *p = l;
  ntok = 0; tpos = 0;
  for (;;) {
    Tok *t;
    while (*p == ' ' || *p == '\t') p++;
    if (!*p || *p == '#') break;
    if (ntok >= 255) die("line has too many tokens");
    t = &toks[ntok++];
    if (isalpha((unsigned char)*p) || *p == '_') {
      size_t n = 0;
      while (isalnum((unsigned char)*p) || *p == '_') { if (n < 500) t->s[n++] = *p; p++; }
      if (n >= 500) die("identifier too long");
      t->s[n] = 0; t->k = K_ID;
    } else if (isdigit((unsigned char)*p) || (*p == '-' && (isdigit((unsigned char)p[1]) || p[1] == '.')) || (*p == '.' && isdigit((unsigned char)p[1]))) {
      size_t n = 0;
      while (*p && (isalnum((unsigned char)*p) || *p == '.' || *p == '-' || *p == '+')) {
        if ((*p == '-' || *p == '+') && n > 0 && !(t->s[n - 1] == 'e' || t->s[n - 1] == 'E')) break;
        if (n < 500) t->s[n++] = *p;
        p++;
      }
      t->s[n] = 0; t->k = K_NUM;
    } else if (*p == '"') {
      size_t n = 0;
      p++;
      while (*p && *p != '"') {
        if (*p == '\\') { p++; if (*p != '"' && *p != '\\') die("unsupported escape in string literal"); }
        if ((unsigned char)*p < 0x20) die("control character in string literal");
        if (n < 500) t->s[n++] = *p; else die("string literal too long");
        p++;
      }
      if (*p != '"') die("unterminated string literal");
      p++;
      t->s[n] = 0; t->k = K_STR;
    } else if (*p == '$') {
      size_t n = 0;
      p++;
      while (isdigit((unsigned char)*p)) { if (n < 6) t->s[n++] = *p; p++; }
      if (n == 0 || n > 5 || t->s[0] == '0') die("bad program argument reference (use $1, $2, ...)");
      t->s[n] = 0; t->k = K_ARG;
    } else if (strchr("(),:=<>", *p)) {
      t->s[0] = *p++; t->s[1] = 0; t->k = K_PUNCT;
    } else {
      die("unexpected character '%c'", *p);
    }
  }
  toks[ntok].k = K_EOL; toks[ntok].s[0] = 0;
}
static Tok *peek(void) { return &toks[tpos]; }
static Tok *next(void) { Tok *t = &toks[tpos]; if (t->k != K_EOL) tpos++; return t; }
static int is_p(Tok *t, char c) { return t->k == K_PUNCT && t->s[0] == c; }
static void expect_p(char c) { Tok *t = next(); if (!is_p(t, c)) die("expected '%c', got '%s'", c, t->k == K_EOL ? "end of line" : t->s); }
static void expect_eol(void) { Tok *t = peek(); if (t->k != K_EOL) die("unexpected trailing token '%s'", t->s); }

static Ty parse_type(void) {
  Tok *t = next();
  if (t->k != K_ID) die("expected a type");
  if (!strcmp(t->s, "f64")) return T_F64;
  if (!strcmp(t->s, "i64")) return T_I64;
  if (!strcmp(t->s, "bool")) return T_BOOL;
  if (!strcmp(t->s, "rec")) return T_REC;
  if (!strcmp(t->s, "arr") || !strcmp(t->s, "mat")) {
    Ty r = t->s[0] == 'a' ? T_ARR : T_MAT;
    Tok *e;
    expect_p('<');
    e = next();
    if (e->k != K_ID || strcmp(e->s, "f64")) die("only %s<f64> is supported", r == T_ARR ? "arr" : "mat");
    expect_p('>');
    return r;
  }
  die("unknown type '%s'", t->s);
  return T_NONE;
}

/* ------------------------------------------------------------------ symbols */
typedef struct { char name[128]; Ty ty; char val[160]; } Sym;
static Sym syms[4096];
static int nsyms;
static Sym *lookup(const char *n) {
  int i;
  for (i = 0; i < nsyms; i++) if (!strcmp(syms[i].name, n)) return &syms[i];
  return NULL;
}
static int reserved(const char *n) {
  static const char *kw[] = {"let", "print", "store", "emit", "assert", "lrdir", "true", "false",
                             "f64", "i64", "bool", "arr", "mat", "rec", "str", NULL};
  int i;
  for (i = 0; kw[i]; i++) if (!strcmp(kw[i], n)) return 1;
  return 0;
}

/* ------------------------------------------------------------------ operations */
enum { OP_LOAD, OP_LEN, OP_GET, OP_RESTFRAME, OP_OBSFRAME, OP_REDSHIFT, OP_REDSHIFT_ARR, OP_CONVERT,
       OP_ALL_FINITE, OP_MONOTONE_INC, OP_IN_RANGE, OP_IN_RANGE_S, OP_AND, OP_OR, OP_NOT,
       OP_RESIDUALS, OP_CHI2, OP_MAT, OP_MATMUL, OP_SOLVE, OP_FLATTEN, OP_LEDGER_PROPOSAL, OP_GATE };
typedef struct { const char *name; int id; int nargs; Ty a[4]; Ty ret; } OpSig;
static const OpSig OPS[] = {
  {"load", OP_LOAD, 2, {T_STR, T_STR}, T_ARR},
  {"len", OP_LEN, 1, {T_ARR}, T_I64},
  {"get", OP_GET, 2, {T_ARR, T_I64}, T_F64},
  {"restframe", OP_RESTFRAME, 2, {T_ARR, T_F64}, T_ARR},
  {"obsframe", OP_OBSFRAME, 2, {T_ARR, T_F64}, T_ARR},
  {"redshift", OP_REDSHIFT, 2, {T_F64, T_F64}, T_F64},
  {"redshift_arr", OP_REDSHIFT_ARR, 2, {T_ARR, T_ARR}, T_ARR},
  {"convert", OP_CONVERT, 3, {T_ARR, T_STR, T_STR}, T_ARR},
  {"all_finite", OP_ALL_FINITE, 1, {T_ARR}, T_BOOL},
  {"monotone_inc", OP_MONOTONE_INC, 1, {T_ARR}, T_BOOL},
  {"in_range", OP_IN_RANGE, 3, {T_ARR, T_F64, T_F64}, T_BOOL},
  {"in_range", OP_IN_RANGE_S, 3, {T_F64, T_F64, T_F64}, T_BOOL},
  {"and", OP_AND, 2, {T_BOOL, T_BOOL}, T_BOOL},
  {"or", OP_OR, 2, {T_BOOL, T_BOOL}, T_BOOL},
  {"not", OP_NOT, 1, {T_BOOL}, T_BOOL},
  {"residuals", OP_RESIDUALS, 2, {T_ARR, T_ARR}, T_ARR},
  {"chi2", OP_CHI2, 3, {T_ARR, T_ARR, T_ARR}, T_F64},
  {"mat", OP_MAT, 3, {T_ARR, T_I64, T_I64}, T_MAT},
  {"matmul", OP_MATMUL, 2, {T_MAT, T_MAT}, T_MAT},
  {"solve", OP_SOLVE, 2, {T_MAT, T_ARR}, T_ARR},
  {"flatten", OP_FLATTEN, 1, {T_MAT}, T_ARR},
  {"ledger_proposal", OP_LEDGER_PROPOSAL, 3, {T_STR, T_I64, T_ARR}, T_REC},
  {"gate", OP_GATE, 2, {T_STR, T_REC}, T_REC},
};
#define NOPS ((int)(sizeof OPS / sizeof OPS[0]))

/* Exactly defined unit conversions. MUL: x*f ; DIV: x/f. f is exact in binary64. */
typedef struct { const char *from, *to; int mul; double f; } Conv;
static const Conv CONVS[] = {
  {"um", "Angstrom", 1, 1.0e4}, {"Angstrom", "um", 0, 1.0e4},
  {"um", "nm", 1, 1.0e3},       {"nm", "um", 0, 1.0e3},
  {"nm", "Angstrom", 1, 10.0},  {"Angstrom", "nm", 0, 10.0},
};

/* ------------------------------------------------------------------ emitter */
static Buf G, B;          /* globals, function body */
static char strs[1024][512];
static int nstrs, ntmp, nlbl;

static const char *fmt_double(double d) {
  static char s[8][32];
  static int k;
  uint64_t u;
  char *r = s[k++ & 7];
  memcpy(&u, &d, 8);
  snprintf(r, 32, "0x%016" PRIX64, u);
  return r;
}
static int intern(const char *s) {
  int i;
  for (i = 0; i < nstrs; i++) if (!strcmp(strs[i], s)) return i;
  if (nstrs >= 1024) die("too many string constants");
  snprintf(strs[nstrs], sizeof strs[0], "%s", s);
  return nstrs++;
}
static const char *strop(const char *s) {
  static char r[8][32];
  static int k;
  char *o = r[k++ & 7];
  snprintf(o, 32, "@.str.%d", intern(s));
  return o;
}
static char *tmp(void) {
  char *s = malloc(24);
  snprintf(s, 24, "%%t%d", ntmp++);
  return s;
}

typedef struct { Ty ty; char v[512]; int is_lit_str; int is_num; char num[512]; } Arg;

static const char *str_arg(Arg *a) {
  static char r[160];
  if (a->is_lit_str) return strop(a->v);
  {
    char *t = tmp();
    bprintf(&B, "  %s = call ptr @lrd_rt_arg(i32 %s)\n", t, a->v);
    snprintf(r, sizeof r, "%s", t);
    free(t);
    return r;
  }
}

enum { MAP_FDIV_S, MAP_FMUL_S, MAP_FSUB2, MAP_REDSHIFT2 };
/* elementwise loop: res[i] = f(a[i], b[i] or scalar). returns result handle name */
static void emit_map(int kind, const char *a, const char *b, const char *s, const char *unit, char *res) {
  char *n = tmp(), *r = tmp(), *pa = tmp(), *pb = b ? tmp() : NULL, *pr = tmp(), *ip = tmp();
  char *i = tmp(), *c = tmp(), *ga = tmp(), *x = tmp(), *y = tmp(), *gr = tmp(), *i2 = tmp();
  int L = nlbl++;
  bprintf(&B, "  %s = call i64 @lrd_arr_len(ptr %s)\n", n, a);
  bprintf(&B, "  %s = call ptr @lrd_arr_new(i64 %s, ptr %s, ptr %s, ptr %s)\n", r, n, unit, a, b ? b : "null");
  bprintf(&B, "  %s = call ptr @lrd_arr_data(ptr %s)\n", pa, a);
  if (b) bprintf(&B, "  %s = call ptr @lrd_arr_data(ptr %s)\n", pb, b);
  bprintf(&B, "  %s = call ptr @lrd_arr_data(ptr %s)\n", pr, r);
  bprintf(&B, "  %s = alloca i64\n  store i64 0, ptr %s\n  br label %%L%d.head\n", ip, ip, L);
  bprintf(&B, "L%d.head:\n  %s = load i64, ptr %s\n  %s = icmp slt i64 %s, %s\n  br i1 %s, label %%L%d.body, label %%L%d.end\n",
          L, i, ip, c, i, n, c, L, L);
  bprintf(&B, "L%d.body:\n  %s = getelementptr inbounds double, ptr %s, i64 %s\n  %s = load double, ptr %s\n", L, ga, pa, i, x, ga);
  switch (kind) {
    case MAP_FDIV_S: bprintf(&B, "  %s = fdiv double %s, %s\n", y, x, s); break;
    case MAP_FMUL_S: bprintf(&B, "  %s = fmul double %s, %s\n", y, x, s); break;
    case MAP_FSUB2: case MAP_REDSHIFT2: {
      char *gb = tmp(), *xb = tmp();
      bprintf(&B, "  %s = getelementptr inbounds double, ptr %s, i64 %s\n  %s = load double, ptr %s\n", gb, pb, i, xb, gb);
      if (kind == MAP_FSUB2) bprintf(&B, "  %s = fsub double %s, %s\n", y, x, xb);
      else {
        char *q = tmp();
        bprintf(&B, "  %s = fdiv double %s, %s\n  %s = fsub double %s, %s\n", q, x, xb, y, q, fmt_double(1.0));
        free(q);
      }
      free(gb); free(xb);
      break;
    }
  }
  bprintf(&B, "  %s = getelementptr inbounds double, ptr %s, i64 %s\n  store double %s, ptr %s\n", gr, pr, i, y, gr);
  bprintf(&B, "  %s = add nsw i64 %s, 1\n  store i64 %s, ptr %s\n  br label %%L%d.head\nL%d.end:\n", i2, i, i2, ip, L, L);
  strcpy(res, r);
  free(n); free(r); free(pa); free(pb); free(pr); free(ip); free(i); free(c); free(ga); free(x); free(y); free(gr); free(i2);
}

static void emit_chi2(const char *o, const char *m, const char *s, char *res) {
  char *n = tmp(), *po = tmp(), *pm = tmp(), *ps = tmp(), *ip = tmp(), *ap = tmp(), *i = tmp(), *c = tmp();
  char *g1 = tmp(), *x1 = tmp(), *g2 = tmp(), *x2 = tmp(), *g3 = tmp(), *x3 = tmp();
  char *d = tmp(), *q = tmp(), *sq = tmp(), *acc = tmp(), *acc2 = tmp(), *i2 = tmp(), *r = tmp();
  int L = nlbl++;
  bprintf(&B, "  %s = call i64 @lrd_arr_len(ptr %s)\n", n, o);
  bprintf(&B, "  %s = call ptr @lrd_arr_data(ptr %s)\n  %s = call ptr @lrd_arr_data(ptr %s)\n  %s = call ptr @lrd_arr_data(ptr %s)\n", po, o, pm, m, ps, s);
  bprintf(&B, "  %s = alloca i64\n  store i64 0, ptr %s\n  %s = alloca double\n  store double %s, ptr %s\n  br label %%L%d.head\n",
          ip, ip, ap, fmt_double(0.0), ap, L);
  bprintf(&B, "L%d.head:\n  %s = load i64, ptr %s\n  %s = icmp slt i64 %s, %s\n  br i1 %s, label %%L%d.body, label %%L%d.end\n",
          L, i, ip, c, i, n, c, L, L);
  bprintf(&B, "L%d.body:\n", L);
  bprintf(&B, "  %s = getelementptr inbounds double, ptr %s, i64 %s\n  %s = load double, ptr %s\n", g1, po, i, x1, g1);
  bprintf(&B, "  %s = getelementptr inbounds double, ptr %s, i64 %s\n  %s = load double, ptr %s\n", g2, pm, i, x2, g2);
  bprintf(&B, "  %s = getelementptr inbounds double, ptr %s, i64 %s\n  %s = load double, ptr %s\n", g3, ps, i, x3, g3);
  bprintf(&B, "  %s = fsub double %s, %s\n  %s = fdiv double %s, %s\n  %s = fmul double %s, %s\n", d, x1, x2, q, d, x3, sq, q, q);
  bprintf(&B, "  %s = load double, ptr %s\n  %s = fadd double %s, %s\n  store double %s, ptr %s\n", acc, ap, acc2, acc, sq, acc2, ap);
  bprintf(&B, "  %s = add nsw i64 %s, 1\n  store i64 %s, ptr %s\n  br label %%L%d.head\nL%d.end:\n", i2, i, i2, ip, L, L);
  bprintf(&B, "  %s = load double, ptr %s\n", r, ap);
  strcpy(res, r);
  free(n); free(po); free(pm); free(ps); free(ip); free(ap); free(i); free(c); free(g1); free(x1); free(g2); free(x2);
  free(g3); free(x3); free(d); free(q); free(sq); free(acc); free(acc2); free(i2); free(r);
}

/* operand text of a typed argument (variables or numeric/bool literals) */
static const char *val(Arg *a) { return a->v; }

static void lower_op(const OpSig *op, Arg *a, char *res) {
  char *t;
  const char *opn = strop(op->name);
  char opname[32];
  snprintf(opname, sizeof opname, "%s", opn);
  switch (op->id) {
    case OP_LOAD: {
      char p[160], u[160];
      snprintf(p, sizeof p, "%s", str_arg(&a[0]));
      snprintf(u, sizeof u, "%s", str_arg(&a[1]));
      t = tmp();
      bprintf(&B, "  %s = call ptr @lrd_load(ptr %s, ptr %s)\n", t, p, u);
      strcpy(res, t); free(t); return;
    }
    case OP_LEN:
      t = tmp(); bprintf(&B, "  %s = call i64 @lrd_arr_len(ptr %s)\n", t, val(&a[0])); strcpy(res, t); free(t); return;
    case OP_GET:
      t = tmp(); bprintf(&B, "  %s = call double @lrd_get(ptr %s, i64 %s)\n", t, val(&a[0]), val(&a[1])); strcpy(res, t); free(t); return;
    case OP_RESTFRAME: case OP_OBSFRAME: {
      char *s = tmp(), *u = tmp();
      bprintf(&B, "  call void @lrd_check_z(double %s, ptr %s)\n", val(&a[1]), opname);
      bprintf(&B, "  %s = fadd double %s, %s\n", s, fmt_double(1.0), val(&a[1]));
      bprintf(&B, "  %s = call ptr @lrd_arr_unit(ptr %s)\n", u, val(&a[0]));
      emit_map(op->id == OP_RESTFRAME ? MAP_FDIV_S : MAP_FMUL_S, val(&a[0]), NULL, s, u, res);
      free(s); free(u); return;
    }
    case OP_REDSHIFT: {
      char *q = tmp();
      t = tmp();
      bprintf(&B, "  call void @lrd_check_pos(double %s, ptr %s)\n  call void @lrd_check_pos(double %s, ptr %s)\n",
              val(&a[0]), opname, val(&a[1]), opname);
      bprintf(&B, "  %s = fdiv double %s, %s\n  %s = fsub double %s, %s\n", q, val(&a[0]), val(&a[1]), t, q, fmt_double(1.0));
      strcpy(res, t); free(t); free(q); return;
    }
    case OP_REDSHIFT_ARR: case OP_RESIDUALS: {
      char *u = tmp();
      char one[32];
      snprintf(one, sizeof one, "%s", strop("1"));
      bprintf(&B, "  call void @lrd_check_len(ptr %s, ptr %s, ptr %s)\n", val(&a[0]), val(&a[1]), opname);
      bprintf(&B, "  %s = call ptr @lrd_arr_unit(ptr %s)\n", u, val(&a[0]));
      bprintf(&B, "  call void @lrd_check_unit(ptr %s, ptr %s, ptr %s)\n", val(&a[1]), u, opname);
      if (op->id == OP_REDSHIFT_ARR) {
        bprintf(&B, "  call void @lrd_check_all_pos(ptr %s, ptr %s)\n  call void @lrd_check_all_pos(ptr %s, ptr %s)\n",
                val(&a[0]), opname, val(&a[1]), opname);
        emit_map(MAP_REDSHIFT2, val(&a[0]), val(&a[1]), NULL, one, res);
      } else {
        emit_map(MAP_FSUB2, val(&a[0]), val(&a[1]), NULL, u, res);
      }
      free(u); return;
    }
    case OP_CONVERT: {
      size_t k;
      const Conv *cv = NULL;
      char from[32], to[32];
      if (!a[1].is_lit_str || !a[2].is_lit_str) die("convert: unit arguments must be string literals so the conversion is checked at compile time");
      for (k = 0; k < sizeof CONVS / sizeof CONVS[0]; k++)
        if (!strcmp(CONVS[k].from, a[1].v) && !strcmp(CONVS[k].to, a[2].v)) cv = &CONVS[k];
      if (!cv) die("unknown unit conversion '%s' -> '%s'", a[1].v, a[2].v);
      snprintf(from, sizeof from, "%s", strop(a[1].v));
      snprintf(to, sizeof to, "%s", strop(a[2].v));
      bprintf(&B, "  call void @lrd_check_unit(ptr %s, ptr %s, ptr %s)\n", val(&a[0]), from, opname);
      emit_map(cv->mul ? MAP_FMUL_S : MAP_FDIV_S, val(&a[0]), NULL, fmt_double(cv->f), to, res);
      return;
    }
    case OP_ALL_FINITE: case OP_MONOTONE_INC: case OP_IN_RANGE: case OP_IN_RANGE_S: {
      char *r = tmp();
      t = tmp();
      if (op->id == OP_ALL_FINITE) bprintf(&B, "  %s = call i32 @lrd_all_finite(ptr %s)\n", r, val(&a[0]));
      else if (op->id == OP_MONOTONE_INC) bprintf(&B, "  %s = call i32 @lrd_monotone_inc(ptr %s)\n", r, val(&a[0]));
      else if (op->id == OP_IN_RANGE) bprintf(&B, "  %s = call i32 @lrd_in_range(ptr %s, double %s, double %s)\n", r, val(&a[0]), val(&a[1]), val(&a[2]));
      else bprintf(&B, "  %s = call i32 @lrd_in_range_s(double %s, double %s, double %s)\n", r, val(&a[0]), val(&a[1]), val(&a[2]));
      bprintf(&B, "  %s = icmp ne i32 %s, 0\n", t, r);
      strcpy(res, t); free(t); free(r); return;
    }
    case OP_AND: case OP_OR:
      t = tmp(); bprintf(&B, "  %s = %s i1 %s, %s\n", t, op->id == OP_AND ? "and" : "or", val(&a[0]), val(&a[1])); strcpy(res, t); free(t); return;
    case OP_NOT:
      t = tmp(); bprintf(&B, "  %s = xor i1 %s, true\n", t, val(&a[0])); strcpy(res, t); free(t); return;
    case OP_CHI2: {
      char *u = tmp();
      bprintf(&B, "  call void @lrd_check_len(ptr %s, ptr %s, ptr %s)\n  call void @lrd_check_len(ptr %s, ptr %s, ptr %s)\n",
              val(&a[0]), val(&a[1]), opname, val(&a[0]), val(&a[2]), opname);
      bprintf(&B, "  %s = call ptr @lrd_arr_unit(ptr %s)\n", u, val(&a[0]));
      bprintf(&B, "  call void @lrd_check_unit(ptr %s, ptr %s, ptr %s)\n", val(&a[1]), u, opname);
      bprintf(&B, "  call void @lrd_check_unit(ptr %s, ptr %s, ptr %s)\n", val(&a[2]), u, opname);
      bprintf(&B, "  call void @lrd_check_sigma(ptr %s, ptr %s)\n", val(&a[2]), opname);
      emit_chi2(val(&a[0]), val(&a[1]), val(&a[2]), res);
      free(u); return;
    }
    case OP_MAT:
      t = tmp(); bprintf(&B, "  %s = call ptr @lrd_mat(ptr %s, i64 %s, i64 %s)\n", t, val(&a[0]), val(&a[1]), val(&a[2])); strcpy(res, t); free(t); return;
    case OP_MATMUL:
      t = tmp(); bprintf(&B, "  %s = call ptr @lrd_matmul(ptr %s, ptr %s)\n", t, val(&a[0]), val(&a[1])); strcpy(res, t); free(t); return;
    case OP_SOLVE:
      t = tmp(); bprintf(&B, "  %s = call ptr @lrd_solve(ptr %s, ptr %s)\n", t, val(&a[0]), val(&a[1])); strcpy(res, t); free(t); return;
    case OP_FLATTEN:
      t = tmp(); bprintf(&B, "  %s = call ptr @lrd_flatten(ptr %s)\n", t, val(&a[0])); strcpy(res, t); free(t); return;
    case OP_LEDGER_PROPOSAL: {
      char p[160];
      snprintf(p, sizeof p, "%s", str_arg(&a[0]));
      t = tmp(); bprintf(&B, "  %s = call ptr @lrd_ledger_proposal(ptr %s, i64 %s, ptr %s)\n", t, p, val(&a[1]), val(&a[2]));
      strcpy(res, t); free(t); return;
    }
    case OP_GATE: {
      char p[160];
      snprintf(p, sizeof p, "%s", str_arg(&a[0]));
      t = tmp(); bprintf(&B, "  %s = call ptr @lrd_gate(ptr %s, ptr %s)\n", t, p, val(&a[1]));
      strcpy(res, t); free(t); return;
    }
  }
  die("internal error: operation '%s' has no lowering", op->name);
}

/* ------------------------------------------------------------------ parsing of arguments */
static int parse_i64_lit(const char *s, long long *out) {
  char *e;
  const char *p = s;
  if (*p == '-') p++;
  if (!*p) return 1;
  for (; *p; p++) if (!isdigit((unsigned char)*p)) return 1;
  errno = 0;
  *out = strtoll(s, &e, 10);
  return errno != 0 || *e;
}
static int parse_f64_lit(const char *s, double *out) {
  char *e;
  errno = 0;
  *out = strtod(s, &e);
  return *e || errno == ERANGE || !isfinite(*out);
}

/* coerce a raw argument to the required type; returns 0 on success */
static int coerce(Arg *a, Ty want, char *why, size_t wl) {
  if (a->is_num) {
    if (want == T_F64) {
      double d;
      if (parse_f64_lit(a->num, &d)) { snprintf(why, wl, "bad f64 literal '%s'", a->num); return -1; }
      snprintf(a->v, sizeof a->v, "%s", fmt_double(d));
      return 0;
    }
    if (want == T_I64) {
      long long v;
      if (parse_i64_lit(a->num, &v)) { snprintf(why, wl, "bad i64 literal '%s'", a->num); return -1; }
      snprintf(a->v, sizeof a->v, "%lld", v);
      return 0;
    }
    snprintf(why, wl, "numeric literal");
    return 1;
  }
  if (a->ty == want) return 0;
  snprintf(why, wl, "%s", tyname(a->ty));
  return 1;
}

static void parse_args(Arg *args, int *nargs) {
  *nargs = 0;
  expect_p('(');
  if (is_p(peek(), ')')) { next(); return; }
  for (;;) {
    Tok *t = next();
    Arg *a;
    if (*nargs >= 4) die("too many arguments");
    a = &args[(*nargs)++];
    memset(a, 0, sizeof *a);
    if (t->k == K_ID) {
      if (!strcmp(t->s, "true") || !strcmp(t->s, "false")) { a->ty = T_BOOL; strcpy(a->v, t->s); }
      else {
        Sym *s = lookup(t->s);
        if (!s) die("undefined variable '%s'", t->s);
        a->ty = s->ty;
        snprintf(a->v, sizeof a->v, "%s", s->val);
      }
    } else if (t->k == K_NUM) { a->is_num = 1; strcpy(a->num, t->s); a->ty = T_NONE; }
    else if (t->k == K_STR) { a->ty = T_STR; a->is_lit_str = 1; strcpy(a->v, t->s); }
    else if (t->k == K_ARG) { a->ty = T_STR; strcpy(a->v, t->s); }
    else die("expected an argument, got '%s'", t->k == K_EOL ? "end of line" : t->s);
    t = next();
    if (is_p(t, ')')) return;
    if (!is_p(t, ',')) die("expected ',' or ')' in argument list");
  }
}

static void stmt_let(void) {
  Tok *nt = next();
  char name[128];
  Ty decl;
  Tok *t;
  Sym *s;
  if (nt->k != K_ID) die("expected variable name after 'let'");
  if (strlen(nt->s) >= 100) die("variable name too long");
  if (reserved(nt->s)) die("'%s' is a reserved word", nt->s);
  strcpy(name, nt->s);
  if (lookup(name)) die("redefinition of '%s'", name);
  expect_p(':');
  decl = parse_type();
  expect_p('=');
  t = next();
  if (nsyms >= 4096) die("too many variables");
  s = &syms[nsyms];
  memset(s, 0, sizeof *s);
  strcpy(s->name, name);
  s->ty = decl;
  if (t->k == K_NUM || (t->k == K_ID && (!strcmp(t->s, "true") || !strcmp(t->s, "false")))) {
    expect_eol();
    if (t->k == K_ID) {
      if (decl != T_BOOL) die("type mismatch: '%s' declared %s but initialised with a bool literal", name, tyname(decl));
      strcpy(s->val, t->s);
    } else if (decl == T_F64) {
      double d;
      if (parse_f64_lit(t->s, &d)) die("bad f64 literal '%s'", t->s);
      snprintf(s->val, sizeof s->val, "%s", fmt_double(d));
    } else if (decl == T_I64) {
      long long v;
      if (parse_i64_lit(t->s, &v)) die("type mismatch: '%s' declared i64 but '%s' is not an integer literal", name, t->s);
      snprintf(s->val, sizeof s->val, "%lld", v);
    } else {
      die("type mismatch: '%s' declared %s but initialised with a numeric literal", name, tyname(decl));
    }
    nsyms++;
    return;
  }
  if (t->k != K_ID) die("expected an operation call or literal after '='");
  {
    const OpSig *cand[4];
    int nc = 0, i, j, nargs;
    Arg args[4];
    char res[160], why[256];
    const OpSig *chosen = NULL;
    for (i = 0; i < NOPS; i++) if (!strcmp(OPS[i].name, t->s)) cand[nc++] = &OPS[i];
    if (!nc) {
      if (lookup(t->s) && !is_p(peek(), '(')) die("unsupported: plain variable copy '%s' (bind operation results directly)", t->s);
      die("unknown operation '%s'", t->s);
    }
    parse_args(args, &nargs);
    expect_eol();
    if (nargs != cand[0]->nargs) die("wrong arity: %s expects %d argument%s, got %d", t->s, cand[0]->nargs, cand[0]->nargs == 1 ? "" : "s", nargs);
    for (i = 0; i < nc && !chosen; i++) {
      Arg tryargs[4];
      int ok = 1;
      memcpy(tryargs, args, sizeof args);
      for (j = 0; j < nargs && ok; j++) ok = coerce(&tryargs[j], cand[i]->a[j], why, sizeof why) == 0;
      if (ok) { chosen = cand[i]; memcpy(args, tryargs, sizeof args); }
    }
    if (!chosen) {
      for (j = 0; j < nargs; j++) {
        Arg tmpa = args[j];
        int rc = coerce(&tmpa, cand[0]->a[j], why, sizeof why), alt = 0;
        for (i = 1; i < nc; i++) { Arg t2 = args[j]; char w2[256]; if (coerce(&t2, cand[i]->a[j], w2, sizeof w2) == 0) alt = 1; }
        if (rc < 0) die("%s: argument %d: %s", t->s, j + 1, why);
        if (rc > 0 && !alt) {
          if (nc > 1) {
            char exp[128] = "";
            for (i = 0; i < nc; i++) { if (i) strcat(exp, " or "); strcat(exp, tyname(cand[i]->a[j])); }
            die("type mismatch: %s argument %d expects %s, got %s", t->s, j + 1, exp, why);
          }
          die("type mismatch: %s argument %d expects %s, got %s", t->s, j + 1, tyname(cand[0]->a[j]), why);
        }
      }
      die("type mismatch: no overload of %s matches the argument types", t->s);
    }
    if (chosen->ret != decl) die("type mismatch: '%s' declared %s but %s yields %s", name, tyname(decl), t->s, tyname(chosen->ret));
    lower_op(chosen, args, res);
    snprintf(s->val, sizeof s->val, "%s", res);
    nsyms++;
  }
}

static Sym *need_var(Ty *allowed, int nallowed, const char *stmt) {
  Tok *t = next();
  Sym *s;
  int i;
  if (t->k != K_ID) die("%s: expected a variable name", stmt);
  s = lookup(t->s);
  if (!s) die("undefined variable '%s'", t->s);
  for (i = 0; i < nallowed; i++) if (allowed[i] == s->ty) return s;
  {
    char exp[128] = "";
    for (i = 0; i < nallowed; i++) { if (i) strcat(exp, " or "); strcat(exp, tyname(allowed[i])); }
    die("type mismatch: %s expects %s, got %s '%s'", stmt, exp, tyname(s->ty), s->name);
  }
  return NULL;
}
static void need_str(Arg *a, const char *stmt) {
  Tok *t = next();
  memset(a, 0, sizeof *a);
  if (t->k == K_STR) { a->is_lit_str = 1; strcpy(a->v, t->s); }
  else if (t->k == K_ARG) strcpy(a->v, t->s);
  else die("%s: expected a string literal or $N argument", stmt);
  a->ty = T_STR;
}

static void statement(void) {
  Tok *t = next();
  if (t->k != K_ID) die("expected a statement");
  if (!strcmp(t->s, "let")) { stmt_let(); return; }
  if (!strcmp(t->s, "print")) {
    Ty al[] = {T_F64, T_I64, T_BOOL, T_ARR, T_MAT, T_REC};
    Sym *s = need_var(al, 6, "print");
    const char *nm;
    expect_eol();
    nm = strop(s->name);
    switch (s->ty) {
      case T_F64: bprintf(&B, "  call void @lrd_print_f64(ptr %s, double %s)\n", nm, s->val); break;
      case T_I64: bprintf(&B, "  call void @lrd_print_i64(ptr %s, i64 %s)\n", nm, s->val); break;
      case T_BOOL: { char *z = tmp(); bprintf(&B, "  %s = zext i1 %s to i32\n  call void @lrd_print_bool(ptr %s, i32 %s)\n", z, s->val, nm, z); free(z); break; }
      case T_ARR: bprintf(&B, "  call void @lrd_print_arr(ptr %s, ptr %s)\n", nm, s->val); break;
      case T_MAT: bprintf(&B, "  call void @lrd_print_mat(ptr %s, ptr %s)\n", nm, s->val); break;
      case T_REC: bprintf(&B, "  call void @lrd_print_rec(ptr %s, ptr %s)\n", nm, s->val); break;
      default: die("internal error");
    }
    return;
  }
  if (!strcmp(t->s, "store")) {
    Ty al[] = {T_ARR, T_F64};
    Sym *s = need_var(al, 2, "store");
    Arg p;
    char ps[160];
    need_str(&p, "store");
    expect_eol();
    snprintf(ps, sizeof ps, "%s", str_arg(&p));
    if (s->ty == T_ARR) bprintf(&B, "  call void @lrd_store_arr(ptr %s, ptr %s)\n", s->val, ps);
    else bprintf(&B, "  call void @lrd_store_f64(double %s, ptr %s)\n", s->val, ps);
    return;
  }
  if (!strcmp(t->s, "emit")) {
    Ty al[] = {T_REC};
    Sym *s = need_var(al, 1, "emit");
    Arg p;
    char ps[160];
    need_str(&p, "emit");
    expect_eol();
    snprintf(ps, sizeof ps, "%s", str_arg(&p));
    bprintf(&B, "  call void @lrd_emit(ptr %s, ptr %s)\n", s->val, ps);
    return;
  }
  if (!strcmp(t->s, "assert")) {
    Ty al[] = {T_BOOL};
    Sym *s = need_var(al, 1, "assert");
    Arg p;
    char *z = tmp();
    need_str(&p, "assert");
    if (!p.is_lit_str) die("assert: message must be a string literal");
    expect_eol();
    bprintf(&B, "  %s = zext i1 %s to i32\n  call void @lrd_assert(i32 %s, ptr %s)\n", z, s->val, z, strop(p.v));
    free(z);
    return;
  }
  die("unknown statement '%s'", t->s);
}

static const char *RT_DECLS =
  "declare void @lrd_rt_init(i32, ptr)\n"
  "declare ptr @lrd_rt_arg(i32)\n"
  "declare i32 @lrd_rt_finish()\n"
  "declare ptr @lrd_load(ptr, ptr)\n"
  "declare ptr @lrd_arr_new(i64, ptr, ptr, ptr)\n"
  "declare i64 @lrd_arr_len(ptr)\n"
  "declare ptr @lrd_arr_data(ptr)\n"
  "declare ptr @lrd_arr_unit(ptr)\n"
  "declare void @lrd_check_len(ptr, ptr, ptr)\n"
  "declare void @lrd_check_unit(ptr, ptr, ptr)\n"
  "declare void @lrd_check_z(double, ptr)\n"
  "declare void @lrd_check_pos(double, ptr)\n"
  "declare void @lrd_check_all_pos(ptr, ptr)\n"
  "declare void @lrd_check_sigma(ptr, ptr)\n"
  "declare i32 @lrd_all_finite(ptr)\n"
  "declare i32 @lrd_monotone_inc(ptr)\n"
  "declare i32 @lrd_in_range(ptr, double, double)\n"
  "declare i32 @lrd_in_range_s(double, double, double)\n"
  "declare double @lrd_get(ptr, i64)\n"
  "declare ptr @lrd_mat(ptr, i64, i64)\n"
  "declare ptr @lrd_matmul(ptr, ptr)\n"
  "declare ptr @lrd_solve(ptr, ptr)\n"
  "declare ptr @lrd_flatten(ptr)\n"
  "declare ptr @lrd_ledger_proposal(ptr, i64, ptr)\n"
  "declare ptr @lrd_gate(ptr, ptr)\n"
  "declare void @lrd_emit(ptr, ptr)\n"
  "declare void @lrd_store_arr(ptr, ptr)\n"
  "declare void @lrd_store_f64(double, ptr)\n"
  "declare void @lrd_assert(i32, ptr)\n"
  "declare void @lrd_print_f64(ptr, double)\n"
  "declare void @lrd_print_i64(ptr, i64)\n"
  "declare void @lrd_print_bool(ptr, i32)\n"
  "declare void @lrd_print_arr(ptr, ptr)\n"
  "declare void @lrd_print_mat(ptr, ptr)\n"
  "declare void @lrd_print_rec(ptr, ptr)\n";

static char *compile(const char *path) {
  FILE *f = fopen(path, "rb");
  char line[4096];
  int seen_header = 0, i;
  Buf out = {0};
  const char *base = strrchr(path, '/');
  base = base ? base + 1 : path;
  g_file = base;
  if (!f) fatal("cannot open %s: %s", path, strerror(errno));
  bprintf(&B, "define i32 @main(i32 %%argc, ptr %%argv) {\nentry:\n  call void @lrd_rt_init(i32 %%argc, ptr %%argv)\n");
  while (fgets(line, sizeof line, f)) {
    size_t n = strlen(line);
    g_line++;
    if (n && line[n - 1] != '\n' && !feof(f)) die("line too long");
    while (n && (line[n - 1] == '\n' || line[n - 1] == '\r')) line[--n] = 0;
    lex_line(line);
    if (ntok == 0) continue;
    if (!seen_header) {
      if (ntok != 2 || toks[0].k != K_ID || strcmp(toks[0].s, "lrdir") || strcmp(toks[1].s, "1"))
        die("first statement must be the version line 'lrdir 1'");
      seen_header = 1;
      continue;
    }
    statement();
  }
  fclose(f);
  if (!seen_header) die("empty program (missing 'lrdir 1')");
  bprintf(&B, "  %%rc = call i32 @lrd_rt_finish()\n  ret i32 %%rc\n}\n");
  bprintf(&out, "; ModuleID = '%s'\n; generated by lrdc %s (LRD-IR v1); deterministic output\nsource_filename = \"%s\"\n\n", base, LRDC_VERSION, base);
  for (i = 0; i < nstrs; i++) {
    size_t k, L = strlen(strs[i]);
    bprintf(&G, "@.str.%d = private unnamed_addr constant [%zu x i8] c\"", i, L + 1);
    for (k = 0; k < L; k++) {
      unsigned char c = (unsigned char)strs[i][k];
      if (c < 0x20 || c >= 0x7f || c == '"' || c == '\\') bprintf(&G, "\\%02X", c);
      else bprintf(&G, "%c", c);
    }
    bprintf(&G, "\\00\"\n");
  }
  if (G.n) bprintf(&out, "%s\n", G.p);
  bprintf(&out, "%s\n%s", RT_DECLS, B.p);
  return out.p;
}

static void run(char *const argv[]) {
  pid_t pid = fork();
  int st;
  if (pid < 0) fatal("fork failed");
  if (pid == 0) { execv(argv[0], argv); fprintf(stderr, "lrdc: error: cannot execute %s: %s\n", argv[0], strerror(errno)); _exit(127); }
  if (waitpid(pid, &st, 0) != pid || !WIFEXITED(st) || WEXITSTATUS(st) != 0)
    fatal("%s failed (status %d)", argv[0], WIFEXITED(st) ? WEXITSTATUS(st) : -1);
}

int main(int argc, char **argv) {
  const char *in = NULL, *out = NULL, *rtlib = LRDC_RUNTIME_LIB;
  int emit_only = 0, i;
  char *ll;
  for (i = 1; i < argc; i++) {
    if (!strcmp(argv[i], "-S")) emit_only = 1;
    else if (!strcmp(argv[i], "-o") && i + 1 < argc) out = argv[++i];
    else if (!strcmp(argv[i], "--runtime-lib") && i + 1 < argc) rtlib = argv[++i];
    else if (!strcmp(argv[i], "--version")) { printf("lrdc %s (LRD-IR v1)\n", LRDC_VERSION); return 0; }
    else if (argv[i][0] == '-' && argv[i][1]) fatal("unknown option '%s'", argv[i]);
    else if (!in) in = argv[i];
    else fatal("more than one input file");
  }
  if (!in) { fprintf(stderr, "usage: lrdc -S [-o OUT.ll|-] IN.lrd | lrdc -o OUT [--runtime-lib LIB] IN.lrd\n"); return 2; }
  ll = compile(in);
  if (emit_only) {
    FILE *f = (!out || !strcmp(out, "-")) ? stdout : fopen(out, "wb");
    if (!f) fatal("cannot write %s", out);
    fputs(ll, f);
    if (f != stdout && fclose(f)) fatal("cannot write %s", out);
    return 0;
  }
  if (!out) fatal("-o OUT is required when building an executable");
  if (!*rtlib) fatal("no runtime library (pass --runtime-lib)");
  {
    char llp[4096], objp[4096];
    FILE *f;
    snprintf(llp, sizeof llp, "%s.ll", out);
    snprintf(objp, sizeof objp, "%s.o", out);
    f = fopen(llp, "wb");
    if (!f || fputs(ll, f) < 0 || fclose(f)) fatal("cannot write %s", llp);
    {
      char *a1[] = {LRDC_LLC, "-O2", "--fp-contract=off", "-relocation-model=pic", "-filetype=obj", "-o", objp, llp, NULL};
      char *a2[] = {LRDC_CLANG, "-ffp-contract=off", "-fno-fast-math", "-o", (char *)out, objp, (char *)rtlib, "-lm", NULL};
      run(a1);
      run(a2);
    }
  }
  return 0;
}
