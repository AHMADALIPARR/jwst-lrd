/* SPDX-License-Identifier: AGPL-3.0-only
 * Also subject to SNAPKITTY_OPAQUE_LICENSE.md (dual license, see repository root).
 *
 * lrd_rec <out.rec>   reads key=value lines on stdin (split at the first '='),
 * sorts keys bytewise ascending, rejects duplicate keys / empty keys,
 * writes the LRD-REC-v1 serialization to <out.rec> and prints the
 * LRD-COMMIT-v1 commitment (lowercase hex SHA-256) on stdout.
 */
#include <openssl/evp.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct { char *k, *v; } kv_t;
static int cmp(const void *a, const void *b) {
    const kv_t *x = a, *y = b;
    return strcmp(x->k, y->k); /* strcmp compares as unsigned char: bytewise */
}
int main(int argc, char **argv) {
    if (argc != 2) { fprintf(stderr, "usage: lrd_rec <out.rec> < fields\n"); return 2; }
    size_t cap = 64, n = 0;
    kv_t *a = malloc(cap * sizeof *a);
    char *line = NULL;
    size_t lc = 0;
    ssize_t len;
    while ((len = getline(&line, &lc, stdin)) > 0) {
        if (line[len - 1] == '\n') line[--len] = 0;
        if (len == 0) continue;
        char *eq = strchr(line, '=');
        if (!eq || eq == line) { fprintf(stderr, "lrd_rec: bad field line: %s\n", line); return 1; }
        *eq = 0;
        if (n == cap) a = realloc(a, (cap *= 2) * sizeof *a);
        a[n].k = strdup(line);
        a[n].v = strdup(eq + 1);
        n++;
    }
    qsort(a, n, sizeof *a, cmp);
    for (size_t i = 1; i < n; i++)
        if (strcmp(a[i - 1].k, a[i].k) == 0) { fprintf(stderr, "lrd_rec: duplicate key %s\n", a[i].k); return 1; }
    FILE *o = fopen(argv[1], "wb");
    if (!o) { perror(argv[1]); return 1; }
    EVP_MD_CTX *ctx = EVP_MD_CTX_new();
    EVP_DigestInit_ex(ctx, EVP_sha256(), NULL);
    EVP_DigestUpdate(ctx, "LRD-COMMIT-v1\0", 14);
    char buf[16384];
#define EMIT(s, l) do { fwrite((s), 1, (l), o); EVP_DigestUpdate(ctx, (s), (l)); } while (0)
    EMIT("LRD-REC-v1\n", 11);
    for (size_t i = 0; i < n; i++) {
        int m = snprintf(buf, sizeof buf, "%zu:", strlen(a[i].k));
        EMIT(buf, (size_t)m);
        EMIT(a[i].k, strlen(a[i].k));
        m = snprintf(buf, sizeof buf, "%zu:", strlen(a[i].v));
        EMIT(buf, (size_t)m);
        EMIT(a[i].v, strlen(a[i].v));
        EMIT("\n", 1);
    }
    fclose(o);
    unsigned char md[32];
    unsigned int ml;
    EVP_DigestFinal_ex(ctx, md, &ml);
    EVP_MD_CTX_free(ctx);
    for (int i = 0; i < 32; i++) printf("%02x", md[i]);
    printf("\n");
    return 0;
}
