/* SPDX-License-Identifier: AGPL-3.0-only
 * Also licensed under the SnapKitty Opaque License; see LICENSE and
 * SNAPKITTY_OPAQUE_LICENSE.md at the repository root.
 * Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 *
 * LRD-ARR-v1 reader/writer implementing abi/lrd_num_abi.h.
 */
#define _POSIX_C_SOURCE 200809L
#include "lrd_num_abi.h"

#include <errno.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define HDR_MAX (1u << 16)

static int fail(char *err, size_t errlen, int code, const char *fmt, ...) {
  if (err && errlen) {
    va_list ap;
    va_start(ap, fmt);
    vsnprintf(err, errlen, fmt, ap);
    va_end(ap);
  }
  return code;
}

int lrd_num_abi_version(void) { return LRD_NUM_ABI_VERSION; }

void lrd_arr_free(lrd_arr_t *a) {
  if (!a) return;
  free(a->data);
  a->data = NULL;
  a->length = 0;
}

static int path_with(char *buf, size_t n, const char *prefix, const char *ext) {
  int k = snprintf(buf, n, "%s%s", prefix, ext);
  return k < 0 || (size_t)k >= n;
}

static int is_hex64(const char *s) {
  size_t i;
  for (i = 0; i < 64; i++) {
    char c = s[i];
    if (!((c >= '0' && c <= '9') || (c >= 'a' && c <= 'f'))) return 0;
  }
  return s[64] == '\0';
}

/* strict natural number: digits only, no leading zero unless "0" */
static int parse_nat(const char *s, int64_t *out) {
  int64_t v = 0;
  size_t i, n = strlen(s);
  if (n == 0 || n > 18) return 1;
  if (n > 1 && s[0] == '0') return 1;
  for (i = 0; i < n; i++) {
    if (s[i] < '0' || s[i] > '9') return 1;
    v = v * 10 + (s[i] - '0');
  }
  if (v >= ((int64_t)1 << 60)) return 1;
  *out = v;
  return 0;
}

int lrd_arr_read(const char *prefix, const char *expect_unit, lrd_arr_t *out,
                 char *err, size_t errlen) {
  char path[4096];
  char *hdr = NULL;
  size_t hlen = 0;
  FILE *f;
  int have_format = 0, have_name = 0, have_length = 0, have_unit = 0, have_sha = 0;
  int64_t length = 0;
  char *line, *save = NULL;
  int rc;
  long fsz;

  if (!prefix || !out) return fail(err, errlen, LRD_ARR_E_ARG, "null argument");
  memset(out, 0, sizeof *out);
  if (path_with(path, sizeof path, prefix, ".hdr"))
    return fail(err, errlen, LRD_ARR_E_ARG, "path too long");
  f = fopen(path, "rb");
  if (!f) return fail(err, errlen, LRD_ARR_E_IO, "cannot open %s: %s", path, strerror(errno));
  hdr = malloc(HDR_MAX + 1);
  if (!hdr) { fclose(f); return fail(err, errlen, LRD_ARR_E_NOMEM, "out of memory"); }
  hlen = fread(hdr, 1, HDR_MAX + 1, f);
  fclose(f);
  if (hlen > HDR_MAX) { free(hdr); return fail(err, errlen, LRD_ARR_E_HEADER, "%s: header too large", path); }
  hdr[hlen] = '\0';
  if (memchr(hdr, '\0', hlen) || memchr(hdr, '\r', hlen)) {
    free(hdr);
    return fail(err, errlen, LRD_ARR_E_HEADER, "%s: header contains NUL or CR bytes", path);
  }
  for (line = strtok_r(hdr, "\n", &save); line; line = strtok_r(NULL, "\n", &save)) {
    char *eq = strchr(line, '=');
    const char *k, *v;
    if (!eq) { rc = fail(err, errlen, LRD_ARR_E_HEADER, "%s: line without '=': '%s'", path, line); goto bad; }
    *eq = '\0';
    k = line; v = eq + 1;
    if (!*k) { rc = fail(err, errlen, LRD_ARR_E_HEADER, "%s: empty key", path); goto bad; }
#define DUP(flag) do { if (flag) { rc = fail(err, errlen, LRD_ARR_E_HEADER, "%s: duplicate key '%s'", path, k); goto bad; } flag = 1; } while (0)
    if (!strcmp(k, "format")) {
      DUP(have_format);
      if (strcmp(v, LRD_ARR_FORMAT)) { rc = fail(err, errlen, LRD_ARR_E_FORMAT, "%s: format is '%s', expected '" LRD_ARR_FORMAT "'", path, v); goto bad; }
    } else if (!strcmp(k, "name")) {
      DUP(have_name);
      if (!*v || strlen(v) > LRD_ARR_NAME_MAX) { rc = fail(err, errlen, LRD_ARR_E_HEADER, "%s: bad name", path); goto bad; }
      strcpy(out->name, v);
    } else if (!strcmp(k, "length")) {
      DUP(have_length);
      if (parse_nat(v, &length)) { rc = fail(err, errlen, LRD_ARR_E_HEADER, "%s: bad length '%s'", path, v); goto bad; }
    } else if (!strcmp(k, "unit")) {
      DUP(have_unit);
      if (!*v || strlen(v) > LRD_ARR_UNIT_MAX) { rc = fail(err, errlen, LRD_ARR_E_HEADER, "%s: bad unit", path); goto bad; }
      strcpy(out->unit, v);
    } else if (!strcmp(k, "source_sha256")) {
      DUP(have_sha);
      if (!is_hex64(v)) { rc = fail(err, errlen, LRD_ARR_E_HEADER, "%s: source_sha256 is not 64 lowercase hex", path); goto bad; }
      strcpy(out->source_sha256, v);
    } else {
      size_t cur = strlen(out->extra), need = strlen(k) + strlen(v) + 2;
      if (cur + need > LRD_ARR_EXTRA_MAX) { rc = fail(err, errlen, LRD_ARR_E_HEADER, "%s: too many extra keys", path); goto bad; }
      snprintf(out->extra + cur, LRD_ARR_EXTRA_MAX + 1 - cur, "%s=%s\n", k, v);
    }
#undef DUP
  }
  free(hdr); hdr = NULL;
  if (!have_format) return fail(err, errlen, LRD_ARR_E_FORMAT, "%s: missing required key 'format'", path);
  if (!have_name)   return fail(err, errlen, LRD_ARR_E_HEADER, "%s: missing required key 'name'", path);
  if (!have_length) return fail(err, errlen, LRD_ARR_E_HEADER, "%s: missing required key 'length'", path);
  if (!have_unit)   return fail(err, errlen, LRD_ARR_E_HEADER, "%s: missing required key 'unit'", path);
  if (expect_unit && strcmp(expect_unit, out->unit))
    return fail(err, errlen, LRD_ARR_E_UNIT, "%s: unit is '%s', expected '%s'", path, out->unit, expect_unit);

  if (path_with(path, sizeof path, prefix, ".f64"))
    return fail(err, errlen, LRD_ARR_E_ARG, "path too long");
  f = fopen(path, "rb");
  if (!f) return fail(err, errlen, LRD_ARR_E_IO, "cannot open %s: %s", path, strerror(errno));
  if (fseek(f, 0, SEEK_END) || (fsz = ftell(f)) < 0 || fseek(f, 0, SEEK_SET)) {
    fclose(f);
    return fail(err, errlen, LRD_ARR_E_IO, "cannot size %s", path);
  }
  if ((int64_t)fsz != length * 8) {
    fclose(f);
    return fail(err, errlen, LRD_ARR_E_LENGTH, "%s: length mismatch: header length=%lld needs %lld bytes, file has %ld",
                path, (long long)length, (long long)(length * 8), fsz);
  }
  if (length > 0) {
    unsigned char *raw = malloc((size_t)length * 8);
    int64_t i;
    out->data = malloc((size_t)length * sizeof(double));
    if (!raw || !out->data) { free(raw); fclose(f); lrd_arr_free(out); return fail(err, errlen, LRD_ARR_E_NOMEM, "out of memory"); }
    if (fread(raw, 8, (size_t)length, f) != (size_t)length) {
      free(raw); fclose(f); lrd_arr_free(out);
      return fail(err, errlen, LRD_ARR_E_IO, "short read on %s", path);
    }
    for (i = 0; i < length; i++) {
      uint64_t u = 0;
      int b;
      for (b = 7; b >= 0; b--) u = (u << 8) | raw[i * 8 + b];
      memcpy(&out->data[i], &u, 8);
    }
    free(raw);
  }
  fclose(f);
  out->length = length;
  return LRD_ARR_OK;
bad:
  free(hdr);
  return rc;
}

static int valid_value(const char *s) { return s && *s && !strchr(s, '\n') && !strchr(s, '\r'); }

int lrd_arr_write(const char *prefix, const char *name, const char *unit,
                  const double *data, int64_t length, const char *extra_hdr,
                  char *err, size_t errlen) {
  char path[4096];
  FILE *f;
  int64_t i;
  if (!prefix || length < 0 || (length > 0 && !data)) return fail(err, errlen, LRD_ARR_E_ARG, "bad argument");
  if (!valid_value(name) || strlen(name) > LRD_ARR_NAME_MAX) return fail(err, errlen, LRD_ARR_E_ARG, "bad name");
  if (!valid_value(unit) || strlen(unit) > LRD_ARR_UNIT_MAX) return fail(err, errlen, LRD_ARR_E_ARG, "bad unit");
  if (path_with(path, sizeof path, prefix, ".f64")) return fail(err, errlen, LRD_ARR_E_ARG, "path too long");
  f = fopen(path, "wb");
  if (!f) return fail(err, errlen, LRD_ARR_E_IO, "cannot create %s: %s", path, strerror(errno));
  for (i = 0; i < length; i++) {
    unsigned char b[8];
    uint64_t u;
    int k;
    memcpy(&u, &data[i], 8);
    for (k = 0; k < 8; k++) b[k] = (unsigned char)(u >> (8 * k));
    if (fwrite(b, 1, 8, f) != 8) { fclose(f); return fail(err, errlen, LRD_ARR_E_IO, "write error on %s", path); }
  }
  if (fclose(f)) return fail(err, errlen, LRD_ARR_E_IO, "close error on %s", path);
  if (path_with(path, sizeof path, prefix, ".hdr")) return fail(err, errlen, LRD_ARR_E_ARG, "path too long");
  f = fopen(path, "wb");
  if (!f) return fail(err, errlen, LRD_ARR_E_IO, "cannot create %s: %s", path, strerror(errno));
  fprintf(f, "format=" LRD_ARR_FORMAT "\nname=%s\nlength=%lld\nunit=%s\n", name, (long long)length, unit);
  if (extra_hdr) fputs(extra_hdr, f);
  if (fclose(f)) return fail(err, errlen, LRD_ARR_E_IO, "close error on %s", path);
  return LRD_ARR_OK;
}
