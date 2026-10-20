<!--
Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
Dual-licensed: AGPL-3.0-or-later plus SnapKitty Opaque License.
SPDX-License-Identifier: AGPL-3.0-or-later AND LicenseRef-SnapKitty-Opaque
-->
# ledger/ — JWST-LRD ledger track

C17 only (GMP + OpenSSL libcrypto). Build: `make -C ledger`. Test: `tests/ledger/run.sh`.

| Path | What |
|---|---|
| `abi/lrd_state.h` | LRD-STATE-v1 shared ABI (research/CONTRACTS.md). Other tracks include it. |
| `include/lrd_rec.h`, `src/lrd_rec.c` | LRD-REC-v1 builder, strict canonical parser, LRD-COMMIT-v1 commitment |
| `src/lrd_rec_tool.c` → `out/lrd-rec` | CLI: `make k=v…`, `commit FILE`, `check FILE` |
| `include/lrd_godel.h`, `src/lrd_godel.c` | TASK 004 Gödel prime ledger |
| `include/lrd_cap.h`, `src/lrd_cap.c` | TASK 010 shared public-key-only helpers (capability format, Ed25519 verify) |
| `src/cap_verifier.c` → `out/lrd-capverifier` | TASK 010 authority/verifier process (sole holder of the signing key and the state log) |
| `src/cap_worker.c` → `out/lrd-capworker` | TASK 010 untrusted worker + independent capability verifier (`verify-cap`) |
| `rsaacc/` | TASK 005 RSA accumulator — **not part of this branch**; owned by branch `t005-rsaacc` |

## TASK 004 — Gödel prime ledger

**Factorization gives exact recoverability, NOT physical immutability.** Anyone who holds `L`
can compute a different integer `L'` for a different history; nothing in the arithmetic stops
the number from being replaced, truncated or rewritten. What the construction guarantees is
that a given `L` determines its history exactly and uniquely (fundamental theorem of
arithmetic), and that malformed integers are detected. Tamper *evidence* requires an external
anchor (a commitment held by someone else, a signature, a monotonic counter — see TASK 010).

### Encoding (exact)

* **Ledger value**: `L = ∏_{i=1..n} p_i ^ e_i`, a GMP integer. Empty ledger: `L = 1`.
* **Primes**: `p_1 = 2, p_2 = 3, …`, produced by `lrd_prime(i)`, an incremental table where each
  new entry is the least integer above the previous prime that has no divisor among the known
  primes ≤ its square root (exact trial division). It is deterministic and exact; no
  probabilistic primality test is used (`mpz_nextprime` is *not* used because GMP documents
  it as probabilistic). Tested against an independent sieve of Eratosthenes for the first 1000 primes.
* **Exponent**: `e_i = bij256(s_i) + 1`, where bijective base-256 numeration assigns byte `b`
  the digit value `b+1` (digits 1..256, most significant first):
  `bij256(b_1…b_k) = Σ_{j=1..k} (b_j+1)·256^(k−j)`, `bij256(ε) = 0`.
  This is a bijection {byte strings} → ℕ (strings are numbered in shortlex order), so
  `e` is a bijection onto {1, 2, …}: the empty string ↦ 1, `00` ↦ 2, …, `ff` ↦ 257, `0000` ↦ 258.
  Leading zero bytes are significant. Closed form used in code:
  `bij256(s) = int_big_endian(s) + (256^k − 1)/255`. Exponent 0 is never produced, so
  "prime absent" and "item present" can never be confused.
* **Items**: in `LRD_GODEL_RECORDS` mode, `s_i` is the canonical LRD-REC-v1 serialization of
  record `i` **with the constant 11-byte magic `LRD-REC-v1\n` removed** (it is identical for all
  records, so removing it keeps the map injective; decode re-adds it). In `LRD_GODEL_BYTES`
  mode items are raw byte strings.

### Operations

* `lrd_godel_append`: `L' = L · p_{n+1}^{e_{n+1}}` (multiplicative append; refused, with `L`
  unchanged, if the item is not canonical or the size cap would be exceeded).
* `lrd_godel_decode` / `lrd_godel_history`: factor by the known prime sequence with
  `mpz_remove`, map every multiplicity back through `bij256⁻¹`, recover every item.
* `lrd_godel_verify_prefix`, `lrd_godel_verify_sequence`, `lrd_godel_verify_prefix_code`
  (`Lp | L` and decoded prefix relation).
* Rejected encodings: `L ≤ 0` (`not_positive`); **gap** — `p_j` absent while one of the next
  `gap_lookahead` (64) sequence primes divides the remaining cofactor; **extra factor** — any other
  cofactor `> 1` (unknown prime or composite); **non-canonical exponent** — in record mode, a
  multiplicity whose byte string is not a canonical LRD-REC-v1 body. In bytes mode every
  positive exponent is canonical by construction (the map is a bijection), so this case
  cannot arise there. "Gap" vs "extra factor" is a classification of the rejection; both are rejected.

### Practical size limit (honest)

`log2 L ≈ Σ e_i·log2 p_i` and `e_i ≈ 256^len(s_i)`, so the size of `L` is **exponential in
item length**. Measured in the tests: six items of ≤ 2 bytes give a 295 182-bit `L`; the
7-byte body of the smallest one-field record (`1:a1:b\n`) has a 54-bit exponent, i.e. `L` would need
~2^53 bits; a realistic 213-byte observation record has a 1702-bit exponent. Every operation
enforces `cfg.max_bits` (default 2^23 bits = 1 MiB) and refuses with `too_big` before allocating.
In practice only bodies of ≤ 2 bytes (and the empty record) fit; real LRD-REC-v1 records do
**not**. The exponent mapping itself is exact for records of any length (tested on a 213-byte
body). The Gödel ledger is therefore a reference/verification construction, not a storage format.

The prime table is a process-global cache and is not thread-safe.

## TASK 005 — RSA accumulator

Not on this branch. It is implemented in `ledger/rsaacc/` on branch `t005-rsaacc` by another
agent and is not built or run by `tests/ledger/run.sh`.

## TASK 010 — Capability addressing

### Objects

* **Proposal** (worker → verifier), LRD-REC-v1 / LRD-STATE-v1 transition proposal with exactly
  the fields `cap_id, kind=capability, nonce, payload_sha256, prev_commit, seq`.
  Kind-specific fields: `cap_id` (`[A-Za-z0-9._-]{1,64}`), `nonce` (32 lowercase hex = 16 bytes
  from `RAND_bytes`).
* **State** after accepting seq `n`: the LRD-STATE-v1 record
  `{commit = prev_commit, kind = capability, payload_sha256, seq = n}`; its LRD-COMMIT-v1
  commitment is `new_commit`. Genesis head: seq 0, commitment 64 zeros.
* **Capability** (verifier → worker), LRD-REC-v1 record with exactly
  `cap_id, kind, new_commit, nonce, payload_sha256, prev_commit, seq, sig`, where `sig` is the
  hex Ed25519 signature (OpenSSL EVP, `EVP_DigestSign`) over
  `"LRD-CAP-SIG-v1\0" || serialization(record without sig)`.
* **Decision**: LRD-STATE-v1 decision record on stdout; `new_commit` only on ACCEPT.
  Reason tokens: `ok`, `stale_seq`, `seq_gap`, `bad_prev`, `replay_nonce`, `retired`,
  `bad_kind`, `bad_record`, and for capability checks `bad_sig`, `bad_fields`, `bad_format`,
  `bad_commit`, `not_in_log`, `unknown_seq`.

### Verifier rules (`lrd-capverifier submit`)

In order: canonical record with the exact field set → `kind = capability` → `cap_id` not retired
→ nonce never used → `seq > head` (else `stale_seq`) → `seq = head + 1` (else `seq_gap`) →
`prev_commit = head commitment` (else `bad_prev`). On ACCEPT the entry is appended to the state log
and fsync'd **before** the capability is written. Rejection writes nothing.

`check CAP [--current]`: signature (own public key), retirement, exact match with the logged
entry at `cap.seq`; with `--current` additionally `cap.seq = head` (so replaying an old
capability as current → `stale_seq`). Without `--current` it answers "was this a genuine state
at seq k". `state-at VDIR k` is the historical read (state record and commitment at any past seq).
`retire VDIR CAP_ID` is permanent (no un-retire).

### Authoritative state file

`VDIR/state.log`, created by `init` with `O_CREAT|O_EXCL` mode 0600 inside a 0700 directory,
written only with `O_APPEND` + `fsync` (and the directory fsync'd at creation), serialized with
`flock`. Each line is chained (`chain = SHA-256("LRD-CAPLOG-v1\0" || prev_chain || " " || body)`)
and signed with the authority key (`Ed25519("LRD-CAPLOG-SIG-v1\0" || chain)`). On every start
the verifier re-verifies every line (chain, signature, seq continuity, commit chaining,
nonce uniqueness, commitment recomputation) and refuses to operate (exit 3, `state_corrupt`) on
any mismatch.

### Trust boundary (exact)

* **The verifier trusts**: its own binary, its signing key `VDIR/authority.key`, its state log,
  OpenSSL, the OS, and the filesystem's fsync semantics. Verifier compromise is **out of scope**:
  whoever controls the verifier (or its key) can sign anything.
* **The verifier does NOT trust**: anything the worker says. The worker's local state file
  (`WDIR/state`) is never read by the verifier; seq/prev_commit in a proposal are checked against
  the verifier's own log.
* **The worker can**: create arbitrary proposals, rewrite or roll back its own state file,
  replay old proposals and capabilities, edit capability files, present capabilities from
  another authority. All of these are rejected (tests below).
* **The worker cannot** (by construction of the code): sign — `lrd-capworker` contains no signing,
  key-generation or private-key-loading code (checked in the test by inspecting its dynamic imports
  with `nm`); it only reads `authority.pub`.
* **What enforces the file separation on this box — honestly**: in the test, verifier and worker
  run as the **same Unix user** (`box`). The separate directory (0700), mode 0600 and `O_APPEND` do
  **not** stop a same-uid process from reading the key or rewriting the log; they only prevent
  accidental writes and protect against *other* users. Real isolation requires running the
  verifier under a different uid (or in an HSM/TPM/enclave), which this test does not do. What the
  test *does* show is that tampering with the log contents (edited entry, deleted entry, forged
  entry with a recomputed chain but no key) is detected, because every entry is signed.
* **Known limitation**: truncating `state.log` to a shorter **valid prefix** (rolling the verifier
  back) is *not* detectable by the verifier alone — it needs an external monotonic anchor (TPM
  counter, published checkpoint). The test records the observed behaviour as an INFO line, not as a
  PASS. Also, an attacker with the worker's uid can read `authority.key` on this box (same uid).

### Tests (tests/ledger/cap_test.sh)

valid chain + independent `verify-cap`; forged signature, altered commitment, foreign authority
→ `bad_sig`; replayed proposal → `replay_nonce`; old seq with fresh nonce → `stale_seq`;
older prev_commit at the next seq → `bad_prev`; seq gap → `seq_gap`; old capability presented
as current → `stale_seq` (but valid historically); historical reads recomputed independently
with `lrd-rec`; retirement; non-canonical / wrong-kind proposals; REJECT carries no
`new_commit` and leaves state unchanged; adversarial: the test harness (playing a privileged
attacker) rewrites the worker's state file (rollback, forged commit, pushed-ahead seq, garbage) and
replays every old proposal and capability — all rejected, verifier log byte-identical; verifier-log
tampering (edit, delete, forged append) → refuses to operate.
