/* SPDX-License-Identifier: AGPL-3.0-only
 * Also subject to SNAPKITTY_OPAQUE_LICENSE.md (dual license, see repository root).
 *
 * lrd_fetch: streaming HTTP(S) download with retries and HTTP Range resume,
 * followed by SHA-256 of the completed file.
 *
 *   lrd_fetch <url> <partial-path> [expected-size]
 *
 * Writes into <partial-path> (appending when it already exists, via Range).
 * On success prints "sha256=<hex>" and "size=<bytes>" on stdout and exits 0.
 * Refuses to run when LRD_OFFLINE=1 (no network calls in offline replay).
 */
#include <curl/curl.h>
#include <errno.h>
#include <openssl/evp.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>

#define MAX_TRIES 6

#ifndef LRD_NO_MAIN
static long long file_size(const char *p) {
    struct stat st;
    if (stat(p, &st) != 0) return -1;
    return (long long)st.st_size;
}
#endif

int lrd_sha256_file(const char *path, char hex[65], long long *size_out) {
    FILE *f = fopen(path, "rb");
    if (!f) return -1;
    EVP_MD_CTX *ctx = EVP_MD_CTX_new();
    EVP_DigestInit_ex(ctx, EVP_sha256(), NULL);
    unsigned char buf[1 << 16];
    size_t n;
    long long total = 0;
    while ((n = fread(buf, 1, sizeof buf, f)) > 0) {
        EVP_DigestUpdate(ctx, buf, n);
        total += (long long)n;
    }
    int err = ferror(f);
    fclose(f);
    unsigned char md[32];
    unsigned int mdlen = 0;
    EVP_DigestFinal_ex(ctx, md, &mdlen);
    EVP_MD_CTX_free(ctx);
    if (err) return -1;
    for (int i = 0; i < 32; i++) sprintf(hex + 2 * i, "%02x", md[i]);
    hex[64] = 0;
    if (size_out) *size_out = total;
    return 0;
}

#ifndef LRD_NO_MAIN
static size_t sink(void *ptr, size_t sz, size_t nm, void *ud) {
    return fwrite(ptr, sz, nm, (FILE *)ud);
}

int main(int argc, char **argv) {
    if (argc < 3) {
        fprintf(stderr, "usage: lrd_fetch <url> <partial-path> [expected-size]\n");
        return 2;
    }
    const char *off = getenv("LRD_OFFLINE");
    if (off && strcmp(off, "1") == 0) {
        fprintf(stderr, "lrd_fetch: LRD_OFFLINE=1, refusing network access\n");
        return 3;
    }
    const char *url = argv[1], *part = argv[2];
    long long expect = argc > 3 ? atoll(argv[3]) : -1;
    curl_global_init(CURL_GLOBAL_DEFAULT);
    int ok = 0;
    for (int attempt = 1; attempt <= MAX_TRIES && !ok; attempt++) {
        long long have = file_size(part);
        if (have < 0) have = 0;
        if (expect >= 0 && have == expect) { ok = 1; break; }
        if (expect >= 0 && have > expect) {
            fprintf(stderr, "lrd_fetch: partial larger than expected, restarting\n");
            unlink(part);
            have = 0;
        }
        FILE *f = fopen(part, have > 0 ? "ab" : "wb");
        if (!f) { perror(part); return 1; }
        CURL *c = curl_easy_init();
        char range[64];
        curl_easy_setopt(c, CURLOPT_URL, url);
        curl_easy_setopt(c, CURLOPT_FOLLOWLOCATION, 1L);
        curl_easy_setopt(c, CURLOPT_WRITEFUNCTION, sink);
        curl_easy_setopt(c, CURLOPT_WRITEDATA, f);
        curl_easy_setopt(c, CURLOPT_FAILONERROR, 1L);
        curl_easy_setopt(c, CURLOPT_CONNECTTIMEOUT, 30L);
        curl_easy_setopt(c, CURLOPT_LOW_SPEED_LIMIT, 1024L);
        curl_easy_setopt(c, CURLOPT_LOW_SPEED_TIME, 60L);
        curl_easy_setopt(c, CURLOPT_USERAGENT, "jwst-lrd-ingest/1 (libcurl)");
        if (have > 0) {
            snprintf(range, sizeof range, "%lld-", have);
            curl_easy_setopt(c, CURLOPT_RANGE, range);
            fprintf(stderr, "lrd_fetch: attempt %d resuming at byte %lld\n", attempt, have);
        } else {
            fprintf(stderr, "lrd_fetch: attempt %d from byte 0\n", attempt);
        }
        CURLcode rc = curl_easy_perform(c);
        long code = 0;
        curl_easy_getinfo(c, CURLINFO_RESPONSE_CODE, &code);
        curl_easy_cleanup(c);
        fclose(f);
        if (rc == CURLE_OK && have > 0 && code == 200) {
            /* Server ignored Range and sent the whole body: appended data is wrong. */
            fprintf(stderr, "lrd_fetch: server ignored Range (HTTP 200); restarting clean\n");
            unlink(part);
            continue;
        }
        if (rc == CURLE_OK && (code == 200 || code == 206 || (code == 0 && strncmp(url, "file:", 5) == 0))) {
            long long now = file_size(part);
            if (expect < 0 || now == expect) ok = 1;
            else fprintf(stderr, "lrd_fetch: size %lld != expected %lld, retrying\n", now, expect);
        } else {
            fprintf(stderr, "lrd_fetch: attempt %d failed: %s (HTTP %ld)\n", attempt,
                    curl_easy_strerror(rc), code);
            sleep((unsigned)(attempt * 2));
        }
    }
    curl_global_cleanup();
    if (!ok) { fprintf(stderr, "lrd_fetch: giving up after %d attempts\n", MAX_TRIES); return 1; }
    char hex[65];
    long long sz;
    if (lrd_sha256_file(part, hex, &sz) != 0) { perror("sha256"); return 1; }
    printf("sha256=%s\nsize=%lld\n", hex, sz);
    return 0;
}
#endif
