/* SPDX-License-Identifier: AGPL-3.0-only
 * Also licensed under the SnapKitty Opaque License; see LICENSE and
 * SNAPKITTY_OPAQUE_LICENSE.md at the repository root.
 * Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 *
 * lrdcmp: compare two LRD-ARR-v1 arrays with a declared tolerance.
 *   lrdcmp --tol-file validation/tolerances.tsv --op OP [--ignore-unit] GOT REF
 *   lrdcmp --atol A --rtol R [--ignore-unit] [--require-finite] GOT REF
 * --require-finite fails when no element pair is finite (guards all-NaN outputs).
 * Element i passes iff |got-ref| <= atol + rtol*|ref| (both NaN also passes;
 * +-inf must match exactly). Lengths must match; units must match unless
 * --ignore-unit. Prints one line "ok ..." (exit 0) or "mismatch ..." (exit 1);
 * read/usage errors exit 2.
 */
#define _POSIX_C_SOURCE 200809L
#include "../abi/lrd_num_abi.h"
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int load_tol(const char *file, const char *op, double *atol, double *rtol) {
  FILE *f = fopen(file, "r");
  char line[512], name[128];
  if (!f) return 1;
  while (fgets(line, sizeof line, f)) {
    double a, r;
    if (line[0] == '#' || line[0] == '\n') continue;
    if (sscanf(line, "%127s %lf %lf", name, &a, &r) == 3 && !strcmp(name, op)) { *atol = a; *rtol = r; fclose(f); return 0; }
  }
  fclose(f);
  return 1;
}

int main(int argc, char **argv) {
  const char *tolf = NULL, *op = NULL, *got = NULL, *ref = NULL;
  double atol = -1, rtol = -1, maxabs = 0, maxrel = 0;
  int ignore_unit = 0, require_finite = 0, i;
  long long nfin = 0;
  long long k, worst = -1;
  lrd_arr_t g, r;
  char err[1024];
  for (i = 1; i < argc; i++) {
    if (!strcmp(argv[i], "--tol-file") && i + 1 < argc) tolf = argv[++i];
    else if (!strcmp(argv[i], "--op") && i + 1 < argc) op = argv[++i];
    else if (!strcmp(argv[i], "--atol") && i + 1 < argc) atol = strtod(argv[++i], NULL);
    else if (!strcmp(argv[i], "--rtol") && i + 1 < argc) rtol = strtod(argv[++i], NULL);
    else if (!strcmp(argv[i], "--ignore-unit")) ignore_unit = 1;
    else if (!strcmp(argv[i], "--require-finite")) require_finite = 1;
    else if (!got) got = argv[i];
    else if (!ref) ref = argv[i];
    else { fprintf(stderr, "lrdcmp: too many arguments\n"); return 2; }
  }
  if (tolf && op && load_tol(tolf, op, &atol, &rtol)) { fprintf(stderr, "lrdcmp: op '%s' not in %s\n", op, tolf); return 2; }
  if (!got || !ref || atol < 0 || rtol < 0) { fprintf(stderr, "lrdcmp: usage error\n"); return 2; }
  if (lrd_arr_read(got, NULL, &g, err, sizeof err)) { printf("error reading %s: %s\n", got, err); return 2; }
  if (lrd_arr_read(ref, NULL, &r, err, sizeof err)) { printf("error reading %s: %s\n", ref, err); return 2; }
  if (g.length != r.length) { printf("mismatch length %lld vs %lld\n", (long long)g.length, (long long)r.length); return 1; }
  if (!ignore_unit && strcmp(g.unit, r.unit)) { printf("mismatch unit '%s' vs '%s'\n", g.unit, r.unit); return 1; }
  for (k = 0; k < g.length; k++) {
    double a = g.data[k], b = r.data[k], d;
    if (isnan(a) || isnan(b)) { if (isnan(a) && isnan(b)) continue; printf("mismatch NaN at %lld\n", k); return 1; }
    if (isinf(a) || isinf(b)) { if (a == b) continue; printf("mismatch inf at %lld\n", k); return 1; }
    nfin++;
    d = fabs(a - b);
    if (d > maxabs) maxabs = d;
    if (b != 0 && d / fabs(b) > maxrel) maxrel = d / fabs(b);
    if (!(d <= atol + rtol * fabs(b)) && worst < 0) worst = k;
  }
  if (worst >= 0) {
    printf("mismatch n=%lld first_bad=%lld got=%.17g ref=%.17g maxabs=%.3e maxrel=%.3e atol=%g rtol=%g\n", (long long)g.length,
           worst, g.data[worst], r.data[worst], maxabs, maxrel, atol, rtol);
    return 1;
  }
  if (require_finite && nfin == 0) { printf("mismatch no finite element pairs compared (n=%lld)\n", (long long)g.length); return 1; }
  printf("ok n=%lld finite=%lld maxabs=%.3e maxrel=%.3e atol=%g rtol=%g\n", (long long)g.length, nfin, maxabs, maxrel, atol, rtol);
  return 0;
}
