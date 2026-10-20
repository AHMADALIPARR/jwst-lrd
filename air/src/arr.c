/* SPDX-License-Identifier: AGPL-3.0-only
 * Additional terms: SnapKitty Opaque License (SNAPKITTY_OPAQUE_LICENSE.md, repository root).
 * Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 */
#include "air/arr.h"
#include "air/crypto.h"
#include "air/stark.h"
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define WHY(m) do { if (why) *why = (m); goto fail; } while (0)

static char *slurp(const char *path, size_t *len) {
  FILE *f = fopen(path, "rb");
  if (!f) return NULL;
  size_t cap = 4096, n = 0;
  char *b = malloc(cap + 1);
  if (!b) { fclose(f); return NULL; }
  for (;;) {
    if (n == cap) {
      char *nb = realloc(b, cap * 2 + 1);
      if (!nb) { free(b); fclose(f); return NULL; }
      b = nb; cap *= 2;
    }
    size_t r = fread(b + n, 1, cap - n, f);
    n += r;
    if (r == 0) break;
  }
  int err = ferror(f);
  fclose(f);
  if (err) { free(b); return NULL; }
  b[n] = 0;
  *len = n;
  return b;
}

int arr_load(const char *base, lrd_arr *a, const char **why) {
  memset(a, 0, sizeof *a);
  char path[4096];
  char *hdr = NULL, *dat = NULL;
  size_t hl = 0, dl = 0;
  int have_fmt = 0, have_name = 0, have_len = 0, have_unit = 0;
  if (snprintf(path, sizeof path, "%s.hdr", base) >= (int)sizeof path) WHY("path_too_long");
  if (!(hdr = slurp(path, &hl))) WHY("cannot_read_hdr");
  if (snprintf(path, sizeof path, "%s.f64", base) >= (int)sizeof path) WHY("path_too_long");
  if (!(dat = slurp(path, &dl))) WHY("cannot_read_f64");
  if (strstr(hdr, "SYNTHETIC") || strstr(base, "SYNTHETIC")) a->synthetic = 1;
  for (char *line = hdr; line && *line;) {
    char *nl = strchr(line, '\n');
    if (nl) *nl = 0;
    size_t ll = strlen(line);
    if (ll && line[ll - 1] == '\r') line[--ll] = 0;
    if (ll) {
      char *eq = strchr(line, '=');
      if (!eq) WHY("hdr_line_without_equals");
      *eq = 0;
      const char *k = line, *v = eq + 1;
      if (!strcmp(k, "format")) { if (strcmp(v, "LRD-ARR-v1")) WHY("hdr_bad_format"); have_fmt = 1; }
      else if (!strcmp(k, "name")) { snprintf(a->name, sizeof a->name, "%s", v); have_name = 1; }
      else if (!strcmp(k, "unit")) { snprintf(a->unit, sizeof a->unit, "%s", v); have_unit = 1; }
      else if (!strcmp(k, "length")) {
        char *end;
        unsigned long long L = strtoull(v, &end, 10);
        if (!*v || *end || (v[0] == '0' && v[1])) WHY("hdr_bad_length");
        a->length = (size_t)L;
        have_len = 1;
      } else if (!strcmp(k, "source_sha256")) snprintf(a->source_sha256, sizeof a->source_sha256, "%s", v);
    }
    line = nl ? nl + 1 : NULL;
  }
  if (!have_fmt || !have_name || !have_len || !have_unit) WHY("hdr_missing_required_key");
  if (strstr(a->name, "SYNTHETIC")) a->synthetic = 1;
  if (dl != a->length * 8) WHY("f64_size_mismatch");
  uint8_t d[32];
  sha256(dat, dl, d);
  hex_encode(d, 32, a->f64_sha256);
  a->v = calloc(a->length ? a->length : 1, sizeof(double));
  if (!a->v) WHY("oom");
  for (size_t i = 0; i < a->length; i++) {
    uint64_t u = get_u64le((const uint8_t *)dat + 8 * i);
    memcpy(&a->v[i], &u, 8);
  }
  free(hdr); free(dat);
  if (why) *why = "ok";
  return 0;
fail:
  free(hdr); free(dat);
  arr_free(a);
  return -1;
}
void arr_free(lrd_arr *a) { free(a->v); a->v = NULL; }

int fixed_encode(const double *v, size_t n, int64_t scale, int64_t *out, const char **why) {
  if (scale <= 0) { if (why) *why = "bad_scale"; return -1; }
  for (size_t i = 0; i < n; i++) {
    if (!isfinite(v[i])) { if (why) *why = "non_finite_input"; return -1; }
    double x = v[i] * (double)scale;
    if (!(fabs(x) <= (double)AIR_MAX_ABS_INPUT)) { if (why) *why = "input_exceeds_2^24_after_scaling"; return -1; }
    long long r = llround(x);
    if (r > AIR_MAX_ABS_INPUT || r < -AIR_MAX_ABS_INPUT) { if (why) *why = "input_exceeds_2^24_after_scaling"; return -1; }
    out[i] = (int64_t)r;
  }
  if (why) *why = "ok";
  return 0;
}
