/* SPDX-License-Identifier: AGPL-3.0-only
 * Also licensed under the SnapKitty Opaque License; see LICENSE and
 * SNAPKITTY_OPAQUE_LICENSE.md at the repository root.
 * Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 *
 * LRD-IR native runtime ABI. Every function here is called from LLVM IR emitted
 * by lrdc; the matching LLVM declarations are generated in llvm/lrdc/lrdc.c
 * (table RT_DECLS) and must stay in sync. Handles (arr, mat, rec) are opaque ptr.
 * Runtime errors print "lrd runtime error: <op>: <reason>" to stderr and exit 3;
 * transition rejection / malformed verifier output exits 4.
 */
#ifndef LRD_RT_H
#define LRD_RT_H
#include <stdint.h>

#define LRD_EXIT_RUNTIME 3
#define LRD_EXIT_GATE    4

void        lrd_rt_init(int32_t argc, char **argv);
const char *lrd_rt_arg(int32_t i);
int32_t     lrd_rt_finish(void);

void       *lrd_load(const char *path, const char *unit);
void       *lrd_arr_new(int64_t n, const char *unit, void *src_a, void *src_b);
int64_t     lrd_arr_len(void *a);
double     *lrd_arr_data(void *a);
const char *lrd_arr_unit(void *a);

void    lrd_check_len(void *a, void *b, const char *op);
void    lrd_check_unit(void *a, const char *unit, const char *op);
void    lrd_check_z(double z, const char *op);
void    lrd_check_pos(double x, const char *op);
void    lrd_check_all_pos(void *a, const char *op);
void    lrd_check_sigma(void *a, const char *op);

int32_t lrd_all_finite(void *a);
int32_t lrd_monotone_inc(void *a);
int32_t lrd_in_range(void *a, double lo, double hi);
int32_t lrd_in_range_s(double x, double lo, double hi);
double  lrd_get(void *a, int64_t i);

void   *lrd_mat(void *a, int64_t rows, int64_t cols);
void   *lrd_matmul(void *a, void *b);
void   *lrd_solve(void *a, void *b);
void   *lrd_flatten(void *m);

void   *lrd_ledger_proposal(const char *prev_commit, int64_t seq, void *payload);
void   *lrd_gate(const char *verifier, void *proposal);
void    lrd_emit(void *rec, const char *path);

void    lrd_store_arr(void *a, const char *path);
void    lrd_store_f64(double x, const char *path);
void    lrd_assert(int32_t b, const char *msg);

void    lrd_print_f64(const char *name, double x);
void    lrd_print_i64(const char *name, int64_t x);
void    lrd_print_bool(const char *name, int32_t b);
void    lrd_print_arr(const char *name, void *a);
void    lrd_print_mat(const char *name, void *m);
void    lrd_print_rec(const char *name, void *r);
#endif
