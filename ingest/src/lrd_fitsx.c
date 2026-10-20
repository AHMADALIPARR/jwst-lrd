/* SPDX-License-Identifier: AGPL-3.0-only
 * Also subject to SNAPKITTY_OPAQUE_LICENSE.md (dual license, see repository root).
 *
 * lrd_fitsx <x1d.fits> <outdir> <source_sha256>
 *
 * Reads a JWST x1d product with CFITSIO and writes:
 *   <outdir>/header.kv          key=value lines (hdr.<KEY>, hdu.<KEY>, col.<NAME>.tunit, ...)
 *   <outdir>/<name>.f64/.hdr    LRD-ARR-v1 arrays for WAVELENGTH, FLUX, FLUX_ERROR
 * Keywords are searched in the primary HDU first, then the first EXTRACT1D HDU.
 * A keyword present in neither is written as hdr.<KEY>=ABSENT (never invented).
 */
#include <fitsio.h>
#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static const char *KEYS[] = {"CAL_VER", "CRDS_CTX", "INSTRUME", "GRATING", "FILTER", "DATE-OBS",
                             "TIME-OBS", "TARGNAME", "TARGPROP", "RA_TARG", "DEC_TARG", "TARG_RA", "TARG_DEC", "SRCRA",
                             "SRCDEC", "SOURCEID", "SRCNAME", "BUNIT", "EXP_TYPE", "PROGRAM",
                             "OBSERVTN", "TELESCOP", "FILENAME", "SRCTYPE", NULL};
static const char *COLS[] = {"WAVELENGTH", "FLUX", "FLUX_ERROR", NULL};

static void die(int st, const char *what) {
    fprintf(stderr, "lrd_fitsx: CFITSIO error in %s: ", what);
    fits_report_error(stderr, st);
    exit(1);
}

/* Read keyword as a string; strips quotes. Returns 1 if found. */
static int getkey(fitsfile *f, const char *k, char *out) {
    int st = 0;
    char card[FLEN_CARD], val[FLEN_VALUE], com[FLEN_COMMENT];
    if (fits_read_card(f, k, card, &st)) return 0;
    st = 0;
    if (fits_parse_value(card, val, com, &st)) return 0;
    size_t n = strlen(val);
    if (n >= 2 && val[0] == '\'') {
        /* string value: strip quotes and trailing blanks, unescape '' */
        char *o = out;
        for (size_t i = 1; i < n - 1; i++) {
            if (val[i] == '\'' && val[i + 1] == '\'') i++;
            *o++ = val[i];
        }
        *o = 0;
        while (o > out && o[-1] == ' ') *--o = 0;
    } else {
        strcpy(out, val);
    }
    return 1;
}

static int host_is_le(void) { uint16_t x = 1; return *(uint8_t *)&x == 1; }

static void write_arr(const char *dir, const char *name, const double *v, long n,
                      const char *unit, const char *sha) {
    char p[4096];
    snprintf(p, sizeof p, "%s/%s.f64", dir, name);
    FILE *f = fopen(p, "wb");
    if (!f) { perror(p); exit(1); }
    for (long i = 0; i < n; i++) {
        uint64_t u;
        memcpy(&u, &v[i], 8);
        if (!host_is_le()) u = __builtin_bswap64(u);
        fwrite(&u, 8, 1, f);
    }
    fclose(f);
    snprintf(p, sizeof p, "%s/%s.hdr", dir, name);
    f = fopen(p, "w");
    if (!f) { perror(p); exit(1); }
    fprintf(f, "format=LRD-ARR-v1\nname=%s\nlength=%ld\nunit=%s\nsource_sha256=%s\n", name, n,
            unit, sha);
    fclose(f);
}

int main(int argc, char **argv) {
    if (argc != 4) { fprintf(stderr, "usage: lrd_fitsx <fits> <outdir> <sha256>\n"); return 2; }
    const char *path = argv[1], *dir = argv[2], *sha = argv[3];
    int st = 0, nhdu = 0, ext = -1;
    fitsfile *f;
    if (fits_open_file(&f, path, READONLY, &st)) die(st, "open");
    if (fits_get_num_hdus(f, &nhdu, &st)) die(st, "num_hdus");
    /* locate first EXTRACT1D binary table */
    for (int h = 2; h <= nhdu; h++) {
        int t;
        char en[FLEN_VALUE];
        if (fits_movabs_hdu(f, h, &t, &st)) die(st, "movabs");
        if (t == BINARY_TBL && getkey(f, "EXTNAME", en) && strcmp(en, "EXTRACT1D") == 0) { ext = h; break; }
    }
    if (ext < 0) { fprintf(stderr, "lrd_fitsx: no EXTRACT1D HDU found\n"); return 1; }
    int n_extract1d = 0;
    for (int h = 2; h <= nhdu; h++) {
        int t; char en[FLEN_VALUE];
        fits_movabs_hdu(f, h, &t, &st);
        if (t == BINARY_TBL && getkey(f, "EXTNAME", en) && strcmp(en, "EXTRACT1D") == 0) n_extract1d++;
    }
    char p[4096];
    snprintf(p, sizeof p, "%s/header.kv", dir);
    FILE *kv = fopen(p, "w");
    if (!kv) { perror(p); return 1; }
    fprintf(kv, "fits.num_hdus=%d\nfits.extract1d_hdu=%d\nfits.extract1d_count=%d\n", nhdu, ext,
            n_extract1d);
    for (int i = 0; KEYS[i]; i++) {
        char v[FLEN_VALUE];
        int t, found = 0, where = 0;
        fits_movabs_hdu(f, 1, &t, &st);
        if (getkey(f, KEYS[i], v)) { found = 1; where = 1; }
        else {
            fits_movabs_hdu(f, ext, &t, &st);
            if (getkey(f, KEYS[i], v)) { found = 1; where = ext; }
        }
        if (st) die(st, "keyword scan");
        if (found) fprintf(kv, "hdr.%s=%s\nhdu.%s=%d\n", KEYS[i], v, KEYS[i], where);
        else fprintf(kv, "hdr.%s=ABSENT\n", KEYS[i]);
    }
    int t;
    if (fits_movabs_hdu(f, ext, &t, &st)) die(st, "movabs ext");
    long nrows = 0;
    if (fits_get_num_rows(f, &nrows, &st)) die(st, "num_rows");
    fprintf(kv, "table.nrows=%ld\n", nrows);
    for (int i = 0; COLS[i]; i++) {
        int col = 0;
        if (fits_get_colnum(f, CASEINSEN, (char *)COLS[i], &col, &st)) die(st, COLS[i]);
        char tk[32], unit[FLEN_VALUE];
        snprintf(tk, sizeof tk, "TUNIT%d", col);
        if (!getkey(f, tk, unit)) strcpy(unit, "ABSENT");
        double *v = malloc(sizeof(double) * (size_t)(nrows ? nrows : 1));
        int anynul = 0;
        double nul = NAN;
        if (fits_read_col(f, TDOUBLE, col, 1, 1, nrows, &nul, v, &anynul, &st)) die(st, "read_col");
        long nn = 0;
        for (long r = 0; r < nrows; r++) if (isnan(v[r])) nn++;
        char lname[64];
        size_t k;
        for (k = 0; COLS[i][k] && k < sizeof lname - 1; k++)
            lname[k] = (char)((COLS[i][k] >= 'A' && COLS[i][k] <= 'Z') ? COLS[i][k] + 32 : COLS[i][k]);
        lname[k] = 0;
        write_arr(dir, lname, v, nrows, unit, sha);
        fprintf(kv, "col.%s.index=%d\ncol.%s.tunit=%s\ncol.%s.nan_count=%ld\n", COLS[i], col, COLS[i],
                unit, COLS[i], nn);
        free(v);
    }
    fclose(kv);
    fits_close_file(f, &st);
    return 0;
}
