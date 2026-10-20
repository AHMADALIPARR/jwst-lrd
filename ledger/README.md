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
