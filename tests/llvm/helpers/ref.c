/* SPDX-License-Identifier: AGPL-3.0-only
 * Also licensed under the SnapKitty Opaque License; see LICENSE and
 * SNAPKITTY_OPAQUE_LICENSE.md at the repository root.
 * Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 *
 * Independent C reference for the LRD-IR tests. Shares NO code with lrdc, the
 * runtime or abi/ (own minimal LRD-ARR-v1 reader/writer). Writes expected
 * outputs as LRD-ARR-v1 so validation/lrdcmp can compare them.
 *   ref restframe IN Z OUT | obsframe IN Z OUT
 *   ref um2A IN OUT | um2nm IN OUT | A2um IN OUT | nm2um IN OUT | nm2A IN OUT | A2nm IN OUT
 *   ref resid A B OUT | chi2 O M S OUT | redshift_arr OBS REST OUT
 *   ref masked_chi2 FLUX FERR OBS MODEL SIG OUT | scalar DECIMAL OUT
 *   ref matmul A ar ac B br bc OUT | solve3 A b OUT (Cramer's rule)
 */
#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static double *rd(const char *pfx, long *n, char *unit) {
  char p[4096], line[512];
  FILE *f;
  long len = -1, i;
  double *v;
  snprintf(p, sizeof p, "%s.hdr", pfx);
  f = fopen(p, "r");
  if (!f) { perror(p); exit(2); }
  unit[0] = 0;
  while (fgets(line, sizeof line, f)) {
    line[strcspn(line, "\n")] = 0;
    if (!strncmp(line, "length=", 7)) len = atol(line + 7);
    if (!strncmp(line, "unit=", 5)) snprintf(unit, 64, "%s", line + 5);
  }
  fclose(f);
  if (len < 0) { fprintf(stderr, "ref: no length in %s\n", p); exit(2); }
  snprintf(p, sizeof p, "%s.f64", pfx);
  f = fopen(p, "rb");
  if (!f) { perror(p); exit(2); }
  v = malloc((size_t)(len ? len : 1) * sizeof(double));
  for (i = 0; i < len; i++) {
    unsigned char b[8];
    uint64_t u = 0;
    int k;
    if (fread(b, 1, 8, f) != 8) { fprintf(stderr, "ref: short %s\n", p); exit(2); }
    for (k = 7; k >= 0; k--) u = (u << 8) | b[k];
    memcpy(&v[i], &u, 8);
  }
  fclose(f);
  *n = len;
  return v;
}

static void wr(const char *pfx, const char *unit, const double *v, long n) {
  char p[4096];
  FILE *f;
  long i;
  const char *b = strrchr(pfx, '/');
  snprintf(p, sizeof p, "%s.f64", pfx);
  f = fopen(p, "wb");
  for (i = 0; i < n; i++) {
    uint64_t u;
    int k;
    memcpy(&u, &v[i], 8);
    for (k = 0; k < 8; k++) fputc((int)((u >> (8 * k)) & 255u), f);
  }
  fclose(f);
  snprintf(p, sizeof p, "%s.hdr", pfx);
  f = fopen(p, "w");
  fprintf(f, "format=LRD-ARR-v1\nname=%s\nlength=%ld\nunit=%s\nnote=SYNTHETIC reference output of tests/llvm/helpers/ref.c\n",
          b ? b + 1 : pfx, n, unit);
  fclose(f);
}

static double det3(const double *m) {
  return m[0] * (m[4] * m[8] - m[5] * m[7]) - m[1] * (m[3] * m[8] - m[5] * m[6]) + m[2] * (m[3] * m[7] - m[4] * m[6]);
}

int main(int argc, char **argv) {
  char u[64], u2[64], u3[64];
  long n, n2, n3, i;
  double *a, *b, *c, *o;
  if (argc < 2) return 2;
  if ((!strcmp(argv[1], "restframe") || !strcmp(argv[1], "obsframe")) && argc == 5) {
    double z = strtod(argv[3], NULL);
    a = rd(argv[2], &n, u); o = malloc((size_t)n * 8);
    for (i = 0; i < n; i++) o[i] = argv[1][0] == 'r' ? a[i] / (1.0 + z) : a[i] * (1.0 + z);
    wr(argv[4], u, o, n); return 0;
  }
  if ((!strcmp(argv[1], "nm2um") || !strcmp(argv[1], "nm2A") || !strcmp(argv[1], "A2nm")) && argc == 4) {
    a = rd(argv[2], &n, u); o = malloc((size_t)n * 8);
    for (i = 0; i < n; i++) o[i] = !strcmp(argv[1], "nm2um") ? a[i] / 1000.0 : !strcmp(argv[1], "nm2A") ? a[i] * 10.0 : a[i] / 10.0;
    wr(argv[3], !strcmp(argv[1], "nm2um") ? "um" : !strcmp(argv[1], "nm2A") ? "Angstrom" : "nm", o, n); return 0;
  }
  if ((!strcmp(argv[1], "um2A") || !strcmp(argv[1], "um2nm") || !strcmp(argv[1], "A2um")) && argc == 4) {
    a = rd(argv[2], &n, u); o = malloc((size_t)n * 8);
    for (i = 0; i < n; i++)
      o[i] = !strcmp(argv[1], "um2A") ? a[i] * 10000.0 : !strcmp(argv[1], "um2nm") ? a[i] * 1000.0 : a[i] / 10000.0;
    wr(argv[3], !strcmp(argv[1], "um2A") ? "Angstrom" : !strcmp(argv[1], "um2nm") ? "nm" : "um", o, n); return 0;
  }
  if (!strcmp(argv[1], "resid") && argc == 5) {
    a = rd(argv[2], &n, u); b = rd(argv[3], &n2, u2);
    if (n != n2) return 3;
    o = malloc((size_t)n * 8);
    for (i = 0; i < n; i++) o[i] = a[i] - b[i];
    wr(argv[4], u, o, n); return 0;
  }
  if (!strcmp(argv[1], "chi2") && argc == 6) {
    double s = 0.0;
    a = rd(argv[2], &n, u); b = rd(argv[3], &n2, u2); c = rd(argv[4], &n3, u3);
    if (n != n2 || n != n3) return 3;
    for (i = 0; i < n; i++) { double r = (a[i] - b[i]) / c[i]; s += r * r; }
    wr(argv[5], "1", &s, 1); return 0;
  }
  if (!strcmp(argv[1], "scalar") && argc == 4) {   /* decimal text (e.g. a Fortran reference.kv value) -> length-1 LRD-ARR-v1 */
    char *e; double v = strtod(argv[2], &e);
    if (*e || !isfinite(v)) return 3;
    wr(argv[3], "1", &v, 1); return 0;
  }
  if (!strcmp(argv[1], "masked_chi2") && argc == 8) {
    /* independent reference: rule of research/BLIND-PROTOCOL.md applied to FLUX/ERR (argv 2,3),
     * restricted to finite model pixels, chi2 over OBS/MODEL/SIG (argv 4,5,6). Prints counts. */
    double *fl, *fe, s = 0.0; long nn; long long kept = 0, base = 0; char uf[64], ue[64];
    fl = rd(argv[2], &nn, uf); fe = rd(argv[3], &n, ue);
    a = rd(argv[4], &n, u); b = rd(argv[5], &n2, u2); c = rd(argv[6], &n3, u3);
    if (n != n2 || n != n3 || n != nn) return 3;
    for (i = 0; i < n; i++) {
      int ok = isfinite(fl[i]) && isfinite(fe[i]) && fe[i] > 0.0;
      base += ok;
      if (ok && isfinite(b[i])) { double r = (a[i] - b[i]) / c[i]; s += r * r; kept++; }
    }
    printf("ref masked_chi2: n=%lld base_kept=%lld kept=%lld chi2=%.17g\n", (long long)n, (long long)base, (long long)kept, s);
    wr(argv[7], "1", &s, 1); return 0;
  }
  if (!strcmp(argv[1], "redshift_arr") && argc == 5) {
    a = rd(argv[2], &n, u); b = rd(argv[3], &n2, u2);
    if (n != n2) return 3;
    o = malloc((size_t)n * 8);
    for (i = 0; i < n; i++) o[i] = a[i] / b[i] - 1.0;
    wr(argv[4], "1", o, n); return 0;
  }
  if (!strcmp(argv[1], "matmul") && argc == 9) {
    long ar = atol(argv[3]), ac = atol(argv[4]), br = atol(argv[6]), bc = atol(argv[7]), r, k, j;
    a = rd(argv[2], &n, u); b = rd(argv[5], &n2, u2);
    if (n != ar * ac || n2 != br * bc || ac != br) return 3;
    o = malloc((size_t)(ar * bc) * 8);
    for (r = 0; r < ar; r++) for (j = 0; j < bc; j++) { double s = 0.0; for (k = 0; k < ac; k++) s += a[r * ac + k] * b[k * bc + j]; o[r * bc + j] = s; }
    wr(argv[8], "1", o, ar * bc); return 0;
  }
  if (!strcmp(argv[1], "solve3") && argc == 5) {
    double m[9], d, x[3];
    int col, k;
    a = rd(argv[2], &n, u); b = rd(argv[3], &n2, u2);
    if (n != 9 || n2 != 3) return 3;
    d = det3(a);
    for (col = 0; col < 3; col++) {
      memcpy(m, a, sizeof m);
      for (k = 0; k < 3; k++) m[k * 3 + col] = b[k];
      x[col] = det3(m) / d;
    }
    wr(argv[4], "1", x, 3); return 0;
  }
  fprintf(stderr, "ref: bad usage\n");
  return 2;
}
