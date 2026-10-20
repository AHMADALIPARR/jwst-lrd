/* SPDX-License-Identifier: AGPL-3.0-only
 * Also subject to SNAPKITTY_OPAQUE_LICENSE.md (dual license, see repository root).
 *
 * Explicit C boundary between the Fortran kernel and CFITSIO.
 * Every function has a flat C signature (no CFITSIO types cross the boundary) and is
 * bound from Fortran with ISO_C_BINDING in lrd_fits.f90. Strings are NUL-terminated.
 * Return value: 0 on success, otherwise a CFITSIO status (>0) or -1.
 */
#include <fitsio.h>
#include <stdio.h>
#include <string.h>

static int goto_extract1d(fitsfile *f, int *st) {
    int n = 0, t;
    char en[FLEN_VALUE];
    if (fits_get_num_hdus(f, &n, st)) return *st;
    for (int h = 2; h <= n; h++) {
        if (fits_movabs_hdu(f, h, &t, st)) return *st;
        int s2 = 0;
        if (t == BINARY_TBL && fits_read_key(f, TSTRING, "EXTNAME", en, NULL, &s2) == 0 &&
            strcmp(en, "EXTRACT1D") == 0)
            return 0;
    }
    return -1;
}

/* Number of rows of the first EXTRACT1D table. */
int lrd_fits_nrows(const char *path, long *nrows) {
    fitsfile *f;
    int st = 0, rc;
    if (fits_open_file(&f, path, READONLY, &st)) return st;
    rc = goto_extract1d(f, &st);
    if (rc == 0) fits_get_num_rows(f, nrows, &st);
    int cs = 0;
    fits_close_file(f, &cs);
    return rc ? rc : st;
}

/* Read column `col` (n rows) as double; NULL cells become NaN. TUNITn -> unit (or "ABSENT"). */
int lrd_fits_read_dcol(const char *path, const char *col, long n, double *out, char *unit,
                       int unitlen) {
    fitsfile *f;
    int st = 0, rc, c = 0, anynul = 0;
    double nul = 0.0 / 0.0;
    if (fits_open_file(&f, path, READONLY, &st)) return st;
    rc = goto_extract1d(f, &st);
    if (rc == 0 && fits_get_colnum(f, CASEINSEN, (char *)col, &c, &st) == 0) {
        char key[16], u[FLEN_VALUE];
        int s2 = 0;
        snprintf(key, sizeof key, "TUNIT%d", c);
        if (fits_read_key(f, TSTRING, key, u, NULL, &s2)) strcpy(u, "ABSENT");
        strncpy(unit, u, (size_t)unitlen - 1);
        unit[unitlen - 1] = 0;
        fits_read_col(f, TDOUBLE, c, 1, 1, n, &nul, out, &anynul, &st);
    }
    int cs = 0;
    fits_close_file(f, &cs);
    return rc ? rc : st;
}

/* Keyword value as string: primary HDU first, then EXTRACT1D. Missing -> -1. */
int lrd_fits_read_key(const char *path, const char *key, char *out, int outlen) {
    fitsfile *f;
    int st = 0, s2 = 0, rc = -1;
    char v[FLEN_VALUE];
    if (fits_open_file(&f, path, READONLY, &st)) return st;
    if (fits_read_key(f, TSTRING, key, v, NULL, &s2) == 0) rc = 0;
    else if (goto_extract1d(f, &st) == 0) {
        s2 = 0;
        if (fits_read_key(f, TSTRING, key, v, NULL, &s2) == 0) rc = 0;
    }
    if (rc == 0) { strncpy(out, v, (size_t)outlen - 1); out[outlen - 1] = 0; }
    int cs = 0;
    fits_close_file(f, &cs);
    return rc;
}
