<!-- SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque -->
<!-- Dual-licensed (intentionally): AGPL-3.0-only plus the SnapKitty Opaque License. -->
# TASK 010: security model (capability addressing and proof-gated transitions)

## Read this first

**A separate process on the same operating system is not a secure trust anchor.** The
`lrd-authority` verifier is an ordinary user-space process. If an attacker has root, controls the
kernel, can ptrace the authority, or can read or write the authority's directory, every guarantee
below is void. This code does **not** protect against such an attacker, and nothing here claims
otherwise.

Stronger guarantees need a hardware or remote anchor: a TPM 2.0 NV monotonic counter plus sealed
key, a TEE (SGX/SEV-SNP/TrustZone) holding the key and counter, or a remote HSM or verifier on a
separate machine. **None of these are implemented.**

## Components and trust boundary

| Component | Trust | Holds |
|---|---|---|
| `lrd-authority serve` (verifier, separate process) | TRUSTED, by assumption | `authority.key` (HMAC key K_auth, mode 0600), `authority.state` (counter, head, history, capability table, retired list; mode 0600), `modulus.hex`, admin socket. Directory mode is 0700. |
| `lrd-worker` (separate process) | UNTRUSTED | its own state file, capability files handed to it, the public modulus. It is never given the authority directory. |
| operator (test harness / `lrd-authority admin`) | trusted to issue capabilities | access to the admin socket inside the authority directory |

Communication is a line protocol over Unix stream sockets (see PROTOCOL.md). The worker socket
offers SUBMIT, HEAD, HISTORY, VERIFY, RETIRED_PROOF and PARAMS. It cannot issue or revoke.

## What the authority enforces (in this order, on SUBMIT)

1. Shape: `kind=capability` (via the ledger header's `lrd_kind_from_token`), hex fields (via `lrd_is_hex256`), canonical seq. Failures give `bad_kind` or `malformed`.
2. Capability authentication: the HMAC-SHA256 tag over `"LRD-CAP-v1\0" || LRD-REC-v1(cap fields)` is checked (`bad_mac`). The capability must be in the authority's table with identical fields (`unknown_cap`/`bad_mac`), not consumed (`replay`), not revoked (`retired`), and not expired (`expired`). Scope must be `transition` (`bad_scope`). Its nonce must not already be bound into an accepted state (`replay`).
3. **One-time consumption**: the capability is marked consumed, added to the retired-capability RSA accumulator and persisted atomically *before* any further check. A capability is burned by its first authenticated use, even when that use is rejected.
4. Rollback: `seq <= counter` gives `stale_seq`, a gap gives `seq_gap`, and `prev_commit != head` gives `bad_prev`. These are checked against the authority's own counter and head, never against anything the worker supplies.
5. Linear addressing: the capability's MAC-bound `(cap_seq, cap_prev)` must equal `(seq, prev_commit)`, otherwise `cap_binding`.
6. Proof gate: `prev_witness` must be a valid RSA-accumulator membership witness for `prev_commit` in the accepted-state accumulator, otherwise `bad_witness`.
7. The authority computes `new_commit = SHA-256("LRD-COMMIT-v1\0" || LRD-REC-v1{cap_nonce, commit=prev_commit, kind=capability, payload_sha256, seq})`. That is `H(seq || prev_commit || state_hash || nonce)` in the shared LRD-REC-v1 encoding. The nonce is the authority's fresh CSPRNG nonce. A mismatching `claimed_commit` gives `bad_commit`.
8. ACCEPT: the state is appended, the counter goes up by 1, the commitment is added to the accumulator, and everything is persisted (write temp, fsync, rename, fsync directory). The persist guard refuses to write a counter lower than either the in-memory or the on-disk value. The ACCEPT reply carries `new_commit` and its membership witness.

A REJECT never carries `new_commit` and never changes the chain (seq, head, accepted-state
accumulator). It is built with the ledger header's `lrd_decision_reject`. On REJECT only the
capability table and retired accumulator change, because the capability is burned.

On startup the authority refuses to run if `authority.state` is missing. It recomputes and checks
the chain links, the counter and both accumulator values. `init` refuses to re-initialize a
directory that already exists. These checks catch accidents. They do **not** stop a malicious
writer of the store (see out of scope).

## Threat model: in scope

The attacker fully controls the worker process. It can arbitrarily rewrite the worker's memory
and state file, craft any byte string on the worker socket, replay anything it has seen, and keep
every capability and response it ever received. The adversarial tests (`tests/adversarial.rs`,
`scripts/integration.sh`) cover:

- (a) corrupted worker memory and state file holding a valid-format forged commitment: `bad_prev`; a forged claimed new commitment: `bad_commit`; a forged state is not an accumulator member: `bad_witness`. **This is the acceptance test.**
- (b) replay of an old valid capability or proposal: `replay`.
- (c) rollback to an older commitment or seq: `stale_seq` / `bad_prev`.
- (d) a forged or edited capability MAC, or a self-minted capability: `bad_mac`.
- (e) a historical-read capability used to transition: `bad_scope`; relabelling its scope: `bad_mac`.
- (f) reuse of a consumed capability after the authority restarts: `replay`.
- (g) a bad or missing accumulator witness: `bad_witness`.
- In addition: expiry (`expired`), revocation (`retired`), slot binding (`cap_binding`), and no issuance on the worker socket (`bad_op`).

## Explicit assumptions (all must hold; none is proved here)

1. **AuthorityKeyUncompromised.** Only the authority can read `authority.key`.
2. **CounterStoreUncompromised.** Only the authority can write `authority.state` (counter, head, capability table). It is not rolled back or replaced, for example by restoring a backup or snapshot.
3. **OSProcessIsolation.** The kernel enforces process memory isolation and file permissions between worker and authority, and socket endpoints are not impersonated. *In the test-suite both processes run as the same Unix uid.* The separation there is by convention (separate directories) and **not** OS-enforced. A same-uid worker could, in principle, open the authority directory. A deployment must run the authority under a different uid, at minimum.
4. **MACUnforgeable.** HMAC-SHA256 is EUF-CMA secure. Our vendored implementation matches the RFC 4231 vectors and openssl.
5. **CollisionResistant.** SHA-256 is collision resistant. The implementation matches the NIST FIPS 180-4 example vectors.
6. **AccumulatorWitnessSound.** The strong RSA assumption holds for N. Hash-to-prime acts as a random oracle into 256-bit primes, using Miller-Rabin with 40 hash-derived bases (error at most 4^-40 per candidate).
7. **TrustedSetupRSAModulus.** Nobody knows the factorization of N. Test moduli are made by `openssl genrsa` and the key file is deleted (`scripts/gen_modulus.sh`). That is a convenience, **not** a trustworthy ceremony: the factors existed in memory and on disk. Whoever knows the factorization can forge membership witnesses.
8. **CSPRNGFresh.** `/dev/urandom` (the kernel CSPRNG) is unpredictable to the worker.
9. Time: expiry uses the authority host's wall clock, so a clock rollback extends expiry.
10. Availability is out of scope. The authority is single-threaded per socket and serializes all requests with one mutex.

## Out of scope: no protection claimed

- **Any attacker who controls the verifier's trust anchor**, meaning anyone who can read or modify `authority.key`, `authority.state` or the authority process. Two tests show the limit and *pass when the forgery succeeds*:
  - `out_of_scope_key_read_allows_mac_forgery`: holding the key, the attacker computes valid MACs.
  - `out_of_scope_store_write_allows_rollback_and_replay`: restoring an older `authority.state` rolls the counter back, and a previously rejected replay is then ACCEPTED.
- root or kernel compromise, ptrace or `/proc/<pid>/mem` access to the authority, and same-uid access to the authority directory.
- Hardware and side-channel attacks. The bigint code is not constant-time, but it only handles public values. MAC comparison is constant-time.
- Malicious operators: whoever can reach the admin socket can issue capabilities.
- Confidentiality of payloads. Only `payload_sha256` is committed.
- Non-membership proofs. The accumulator supports membership only. Retirement is proven by membership in the retired accumulator.
- Public verifiability of authority replies. Replies are not signed, so the worker trusts the socket endpoint (assumption 3). It does recompute `new_commit` and verify the returned witness locally.

## Known gaps

- No hardware monotonic counter, TEE or remote HSM (see the top of this file).
- The accumulator is local to this track. It should be replaced by the canonical ledger accumulator (`verify_witness` contract) once one lands. At the time of writing, `t005-rsaacc` had only uncommitted work.
- Witnesses are recomputed from g in O(k) modexps for k elements. That is fine for tests but not for large histories.
