/* SPDX-License-Identifier: AGPL-3.0-only
 * Additional terms: SnapKitty Opaque License (SNAPKITTY_OPAQUE_LICENSE.md, repository root).
 * Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 *
 * air_cli: end-to-end prove / verify of one LRD-AIR-SUMSQ-v1 transition on an LRD-ARR-v1 input.
 *   air_cli params <n_inputs>
 *   air_cli prove  <arr_base> <scale> <out_dir>     (ledger state: genesis observation state)
 *   air_cli verify <arr_base> <scale> <out_dir>     (writes <out_dir>/decision.rec)
 * The current ledger state used by both is the genesis state
 *   {seq=0, commit=0^64, kind=observation, payload_sha256=SHA-256(<arr_base>.f64)}
 * so the proof is bound to the observation via observation_sha256 and to the ledger via
 * ledger_prev_commit = LRD-COMMIT-v1(genesis state record).
 */
#include "air/arr.h"
#include "air/crypto.h"
#include "air/rec.h"
#include "air/stark.h"
#include "air/state.h"
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int write_file(const char *dir, const char *name, const void *b, size_t n) {
  char p[4096];
  snprintf(p, sizeof p, "%s/%s", dir, name);
  FILE *f = fopen(p, "wb");
  if (!f) return -1;
  size_t w = fwrite(b, 1, n, f);
  return (fclose(f) || w != n) ? -1 : 0;
}
static uint8_t *read_file(const char *dir, const char *name, size_t *n) {
  char p[4096];
  snprintf(p, sizeof p, "%s/%s", dir, name);
  FILE *f = fopen(p, "rb");
  if (!f) return NULL;
  if (fseek(f, 0, SEEK_END)) { fclose(f); return NULL; }
  long L = ftell(f);
  if (L < 0 || fseek(f, 0, SEEK_SET)) { fclose(f); return NULL; }
  uint8_t *b = malloc((size_t)L + 1);
  if (!b || fread(b, 1, (size_t)L, f) != (size_t)L) { free(b); fclose(f); return NULL; }
  fclose(f);
  *n = (size_t)L;
  return b;
}
static int write_rec(const char *dir, const char *name, const lrd_rec *r) {
  size_t n;
  unsigned char *s = rec_serialize(r, &n);
  if (!s) return -1;
  int e = write_file(dir, name, s, n);
  free(s);
  return e;
}
static int read_rec(const char *dir, const char *name, lrd_rec *r) {
  size_t n;
  uint8_t *b = read_file(dir, name, &n);
  if (!b) return -1;
  int e = rec_parse(r, b, n);
  free(b);
  return e;
}
static void print_params(const air_params *p) {
  printf("field=Goldilocks p=2^64-2^32+1 (64-bit base), challenges/OOD/DEEP/FRI over Fp2=Fp[u]/(u^2-7)\n");
  printf("hash=SHA-256 (Merkle + Fiat-Shamir), trace_length=%u blowup=%u queries=%u grinding_bits=%u "
         "fri_folding=2 fri_remainder_coeffs=%u fri_folds=%u\n",
         1u << p->log_trace_len, 1u << p->log_blowup, p->num_queries, p->grinding_bits,
         1u << p->log_remainder, air_num_folds(p));
  printf("conjectured_security_bits=%u (winterfell ConjecturedSecurity formula, ethSTARK Conjecture 1)\n",
         air_conjectured_security_bits(p));
  printf("proven_security_bits_udr=%u proven_security_bits_ldr=%u (winterfell ProvenSecurity formulas)\n",
         air_proven_security_udr_bits(p), air_proven_security_ldr_bits(p));
}
static int load(const char *base, const char *scale_s, lrd_arr *a, int64_t **q, int64_t *scale) {
  const char *why;
  if (arr_load(base, a, &why)) { fprintf(stderr, "load %s: %s\n", base, why); return -1; }
  char *end;
  *scale = strtoll(scale_s, &end, 10);
  if (*end || *scale <= 0) { fprintf(stderr, "bad scale\n"); return -1; }
  *q = calloc(a->length ? a->length : 1, sizeof **q);
  if (!*q || fixed_encode(a->v, a->length, *scale, *q, &why)) { fprintf(stderr, "encode: %s\n", why); return -1; }
  printf("input name=%s length=%zu unit=%s observation_sha256=%s%s\n", a->name, a->length, a->unit,
         a->f64_sha256, a->synthetic ? " [SYNTHETIC]" : "");
  return 0;
}
static void genesis(const lrd_arr *a, lrd_state_t *s) {
  memset(s, 0, sizeof *s);
  s->seq = 0;
  memcpy(s->commit, LRD_GENESIS_COMMIT, 65);
  s->kind = LRD_KIND_OBSERVATION;
  memcpy(s->payload_sha256, a->f64_sha256, 65);
}

int main(int argc, char **argv) {
  if (argc == 3 && !strcmp(argv[1], "params")) {
    uint32_t k = air_trace_log_for_inputs((size_t)strtoull(argv[2], NULL, 10));
    if (!k) return 2;
    air_params p = air_policy_params(k);
    print_params(&p);
    return 0;
  }
  if (argc != 5 || (strcmp(argv[1], "prove") && strcmp(argv[1], "verify"))) {
    fprintf(stderr, "usage: air_cli params <n> | prove|verify <arr_base> <scale> <dir>\n");
    return 2;
  }
  lrd_arr a;
  int64_t *q = NULL, scale;
  if (load(argv[2], argv[3], &a, &q, &scale)) return 1;
  lrd_state_t cur;
  genesis(&a, &cur);
  lrd_rec sr;
  char cur_commit[65];
  air_state_to_rec(&cur, &sr);
  rec_commit(&sr, cur_commit);
  const char *dir = argv[4], *why = NULL;
  if (!strcmp(argv[1], "prove")) {
    uint64_t out;
    if (air_execute(q, a.length, &out)) { fprintf(stderr, "execute failed\n"); return 1; }
    air_params P = air_policy_params(air_trace_log_for_inputs(a.length));
    lrd_rec pub;
    if (air_build_public(&pub, a.f64_sha256, cur_commit, cur.seq + 1, scale, a.name, q, a.length, out, &P)) {
      fprintf(stderr, "public record failed\n"); return 1;
    }
    air_proof pf;
    if (air_prove(&pub, q, a.length, NULL, &pf, &why)) { fprintf(stderr, "prove: %s\n", why); return 1; }
    size_t plen;
    uint8_t *pb = air_proof_serialize(&pf, &plen);
    air_proposal_buf prop;
    lrd_rec pr;
    if (air_make_proposal(&cur, &pub, pb, plen, &prop) || air_proposal_to_rec(&prop.prop, &pr)) return 1;
    if (write_file(dir, "proof.bin", pb, plen) || write_rec(dir, "public.rec", &pub) ||
        write_rec(dir, "proposal.rec", &pr)) { fprintf(stderr, "write failed\n"); return 1; }
    print_params(&P);
    printf("output=%s output_rational=%s (sum of squares of fixed-point inputs, scale=%" PRId64 ")\n",
           rec_get(&pub, "output"), rec_get(&pub, "output_rational"), scale);
    printf("proof_bytes=%zu payload_sha256=%s\n", plen, prop.prop.payload_sha256);
    free(pb);
    air_proof_free(&pf);
  } else {
    lrd_rec pub, pr, dr;
    air_proposal_buf prop;
    size_t plen;
    uint8_t *pb = read_file(dir, "proof.bin", &plen);
    if (!pb || read_rec(dir, "public.rec", &pub) || read_rec(dir, "proposal.rec", &pr) ||
        air_proposal_from_rec(&pr, &prop)) { fprintf(stderr, "read failed\n"); return 1; }
    const char *obs = rec_get(&pub, "observation_sha256");
    lrd_decision_t d;
    lrd_state_t next;
    memset(&d, 0, sizeof d);
    if (!obs || strcmp(obs, a.f64_sha256)) {
      lrd_decision_reject(&d, "bad_public_input");
      why = "observation_sha256 does not match the .f64 bytes";
    } else {
      air_transition(&cur, &prop.prop, &pub, q, a.length, pb, plen, &d, &next, &why);
    }
    air_decision_to_rec(&d, &dr);
    write_rec(dir, "decision.rec", &dr);
    printf("decision=%s reason=%s detail=%s%s%s\n", d.decision == LRD_DECISION_ACCEPT ? "ACCEPT" : "REJECT",
           d.reason, why ? why : "", d.decision == LRD_DECISION_ACCEPT ? " new_commit=" : "",
           d.decision == LRD_DECISION_ACCEPT ? d.new_commit : "");
    free(pb);
    free(q);
    arr_free(&a);
    return d.decision == LRD_DECISION_ACCEPT ? 0 : 3;
  }
  free(q);
  arr_free(&a);
  return 0;
}
