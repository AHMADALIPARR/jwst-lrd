/* SPDX-License-Identifier: AGPL-3.0-only
 * Additional terms: SnapKitty Opaque License (SNAPKITTY_OPAQUE_LICENSE.md, repository root).
 * Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 *
 * LRD-AIR-SUMSQ-v1: a small deterministic arithmetic AIR with a STARK prover/verifier.
 *
 * Execution kernel (fixed-point sum of squares, a chi-square-like accumulation):
 *   inputs  q_0..q_{n-1}: signed integers, q_i = llround(v_i * scale), |q_i| <= 2^24
 *   trace   N = 2^k rows (N = max(16, next_pow2(n+1)), N <= 2^14), 2 columns over Fp:
 *           x[i] = q_i (i < n), 0 (i >= n);  acc[0] = 0;  acc[i+1] = acc[i] + x[i]^2
 *   output  acc[N-1] = sum_i q_i^2  (an integer < 2^62 < p, so no modular wrap-around)
 * Constraints (w = primitive N-th root of unity, H = <w>):
 *   T  (transition, degree 2): acc(wX) - acc(X) - x(X)^2 = 0  on H \ {w^(N-1)}
 *   B0 (boundary):             acc(X) = 0                      at X = 1
 *   B1 (boundary, public out): acc(X) = output                 at X = w^(N-1)
 *   P  (public input binding): x(X) - I(X) = 0 on H, I = interpolant of the public inputs
 * Protocol: trace LDE on coset 7*<w_{N*B}>, SHA-256 Merkle commitment; composition polynomial
 * H = sum alpha_k C_k/Z_k with alpha in Fp2; commitment to H's LDE; out-of-domain point z in
 * Fp2 \ Fp; DEEP composition polynomial; FRI (fold factor 2) with per-layer Merkle commitments
 * and an explicit remainder polynomial; proof-of-work grinding; query phase. All verifier
 * randomness comes from the SHA-256 Fiat-Shamir transcript, which first absorbs the serialized
 * LRD-REC-v1 public-input record (observation_sha256, ledger_prev_commit, ...).
 */
#ifndef AIR_STARK_H
#define AIR_STARK_H
#include <stddef.h>
#include <stdint.h>
#include "air/crypto.h"
#include "air/field.h"
#include "air/rec.h"

#define AIR_NAME "LRD-AIR-SUMSQ-v1"
#define AIR_MAX_ABS_INPUT ((int64_t)1 << 24)
#define AIR_MIN_LOG_TRACE 4u
#define AIR_MAX_LOG_TRACE 14u
#define AIR_MAX_FRI 32u
#define AIR_NUM_CONSTRAINTS 4u
#define AIR_NUM_COMMITTED_POLYS 3u /* x, acc, H */

typedef struct {
  uint32_t log_trace_len;
  uint32_t log_blowup;
  uint32_t num_queries;
  uint32_t grinding_bits;
  uint32_t log_remainder; /* remainder polynomial has 2^log_remainder coefficients */
} air_params;

/* Verifier policy defaults (the verifier rejects any other parameters). */
#define AIR_POLICY_LOG_BLOWUP 3u   /* blowup 8 */
#define AIR_POLICY_QUERIES 40u
#define AIR_POLICY_GRINDING 16u
#define AIR_POLICY_LOG_REMAINDER 3u

air_params air_policy_params(uint32_t log_trace_len);
uint32_t air_trace_log_for_inputs(size_t n); /* 0 if n too large */
uint32_t air_num_folds(const air_params *p);  /* r = log_trace_len - log_remainder */

typedef struct {
  fp trace[2][2]; /* [0]=row j, [1]=row j+M/2; [.][0]=x, [.][1]=acc */
  fp2 comp[2];
  fp2 fri[AIR_MAX_FRI][2]; /* layers 1..r-1 stored at index l */
  digest *paths;  /* trace path, comp path, then FRI layer paths l=1..r-1 */
} air_query;

typedef struct {
  air_params prm;
  digest trace_root, comp_root;
  fp2 ood[5]; /* acc(z), x(z), acc(wz), x(wz), H(z) */
  uint32_t n_fri_roots;
  digest fri_roots[AIR_MAX_FRI];
  uint32_t n_rem;
  fp2 *rem;
  uint64_t nonce;
  air_query *q; /* num_queries entries */
} air_proof;

void air_proof_free(air_proof *pf);
size_t air_query_path_count(const air_params *p);

/* Public-input record (LRD-REC-v1). */
int air_build_public(lrd_rec *rec, const char observation_sha256[65], const char ledger_prev_commit[65],
                     uint64_t ledger_seq, int64_t scale, const char *input_name, const int64_t *q,
                     size_t n, uint64_t output, const air_params *p);
int air_inputs_sha256(const int64_t *q, size_t n, char out[65]);
/* Honest execution of the kernel (fails on bound violation). */
int air_execute(const int64_t *q, size_t n, uint64_t *output);

typedef struct {
  int force;           /* skip prover self-checks (used to build cheating proofs in tests) */
  int corrupt;         /* if nonzero: add corrupt_delta to trace cell (corrupt_row, corrupt_col) */
  size_t corrupt_row;
  unsigned corrupt_col;
  fp corrupt_delta;
  int cheat_ood;       /* with force: claim the H(z) the verifier expects instead of the true H(z),
                          so the OOD check passes and rejection must come from FRI */
} air_prove_opts;

/* Returns 0 on success, else a negative code; *why gets a static reason string. */
int air_prove(const lrd_rec *pub, const int64_t *q, size_t n, const air_prove_opts *opt,
              air_proof *pf, const char **why);
/* Returns 1 iff the proof is accepted; else 0 and *why names the first failed check. */
int air_verify(const lrd_rec *pub, const int64_t *q, size_t n, const air_proof *pf, const char **why);
/* Diagnostic verifier for tests only: AIR_DIAG_SKIP_GRINDING skips the proof-of-work check so
 * that the deeper (OOD / FRI) checks are exercised. Never use it to accept a proof. */
#define AIR_DIAG_SKIP_GRINDING 1u
int air_verify_diag(const lrd_rec *pub, const int64_t *q, size_t n, const air_proof *pf, unsigned flags,
                    const char **why);

/* Header bytes (magic, version, ids, params) shared by serialization and the transcript. */
#define AIR_HEADER_LEN 40u
void air_header_bytes(const air_params *p, uint8_t out[AIR_HEADER_LEN]);
/* Serialization (format LRDAIRP1, version 1; see air/STATUS.md). */
uint8_t *air_proof_serialize(const air_proof *pf, size_t *len);
int air_proof_deserialize(const uint8_t *buf, size_t len, air_proof *pf, const char **why);

/* Security estimates, ported from winterfell air/src/proof/security.rs (see STATUS.md). */
unsigned air_conjectured_security_bits(const air_params *p);
unsigned air_proven_security_udr_bits(const air_params *p);
unsigned air_proven_security_ldr_bits(const air_params *p);
#endif
