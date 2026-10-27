<!--
Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
-->
# ledger/SPEC.md — Gödel prime ledger (normative)

Scope: `include/lrd_godel.h`, `src/lrd_godel.c`. Key words MUST / MUST NOT are used as in RFC 2119.
Factorization gives **exact recoverability, NOT physical immutability**: whoever holds `L` can
replace it with another integer; tamper evidence needs an external anchor.

## 1. Ledger object and modes

A ledger is `lrd_godel_t { L (GMP integer), n, mode, stream_len }`. The **mode is explicit**: it is
given to `lrd_godel_init(g, mode)`, stored in `g->mode`, and every operation takes a `cfg` whose
`cfg->mode` MUST equal it (else `E_MODE`). The exported form (`lrd_godel_export`, an LRD-REC-v1
record with keys `L`, `format`, `mode`, `n`) records the mode. The bare integer `L` carries **no** mode
tag and MUST NOT be interpreted without one (`L = 210` is four empty records in `bij256-records`,
one empty record in `positional`).

| Mode | Intended items |
|---|---|
| `LRD_GODEL_POSITIONAL` | canonical LRD-REC-v1 records of any size up to the limits in §4 (tested at 1217 bytes) |
| `LRD_GODEL_BIJ256_RECORDS`, `LRD_GODEL_BIJ256_BYTES` | **tiny items only** (≤ 2 bytes); backward compatible with earlier ledgers |

## 2. Encodings

### 2.1 Positional (`LRD_GODEL_POSITIONAL`)

Stream `S` = concatenation, per record `r` in ingestion order, of `be32(len(body_r)) || body_r`,
where `body_r` is the canonical LRD-REC-v1 serialization of `r` without the constant 11-byte magic
`LRD-REC-v1\n`. Byte `S[k]` (k = 0, 1, …) is carried by the `(k+1)`-th prime:

    L = ∏_{k=0..|S|-1} p_{k+1} ^ (S[k] + 1)         exponent ∈ 1..256;  empty stream ⇒ L = 1

* **Append** multiplies `L` by the prime powers of the new bytes, continuing at prime index `|S|+1`.
* **Decode** divides out `p_1, p_2, …` in order. It MUST reject: `L ≤ 0` (`E_NOTPOS`); an absent
  prime while a later one divides `L`, i.e. exponent 0 (`E_GAP` between whole records, `E_ZEROEXP`
  inside a record frame); an exponent above 256 (`E_EXPRANGE`); a cofactor not made of the next
  sequence primes — an unknown factor (`E_EXTRA`); a truncated length prefix or a length that runs
  past the end (`E_FRAMING`); a body that does not strict-parse as canonical LRD-REC-v1, or whose
  re-serialization differs byte for byte (`E_NONCANON`); more than `LRD_GODEL_MAX_LEN` records (`E_LEN`).
* **Size.** `log2 L = Σ (S[k]+1)·log2 p_{k+1} ≤ 256·Σ_{k≤|S|} log2 p_k ≈ 256·|S|·log2 p_|S|`:
  **n log n growth** in the stream length (constant up to 256, about 128 for uniformly random bytes);
  not exponential. It is still large: a 1217-byte real record gave a 1 103 517-bit `L`.
* Default `cfg.max_bits` = `LRD_GODEL_POSITIONAL_DEFAULT_MAX_BITS` = 2^26. An append that would exceed
  it returns `E_TOOBIG` with `L`, `n` unchanged.

### 2.2 Bijective-base-256 (`LRD_GODEL_BIJ256_*`) — tiny items only

`L = ∏_{i=1..n} p_i ^ (bij256(s_i) + 1)`, one prime per item; `bij256(b_1…b_k) = Σ_j (b_j+1)·256^(k−j)`,
`bij256(ε) = 0` (a bijection from byte strings onto ℕ). In `RECORDS` mode `s_i` is the canonical
serialization without the 11-byte magic. **`log2 L` is exponential in item length** (the 7-byte body
`1:a1:b\n` has a 54-bit exponent and is refused with `E_TOOBIG` under the default 2^23 bits;
`LRD_GODEL_BIJ256_DEFAULT_MAX_BITS`). It is retained only for ≤ 2-byte items and
MUST NOT be used for real records.

## 3. Parsing

`lrd_godel_parse_hex`: only hex digits; a sign (`-`, `+`) or a value ≤ 0 is `E_NOTPOS`; other text is `E_ARG`;
the output is untouched on error. `lrd_godel_parse_factored("p^e p^e …")`: an exponent `≤ 0` (including
`2^-1`, `2^0`) is `E_NOTPOS`; a non-prime base or a sign on a base is `E_ARG`; a product above `cfg.max_bits`
is `E_TOOBIG` before computing.

## 4. Constants and limits

| Name | Value | Where | Behaviour |
|---|---|---|---|
| `LRD_GODEL_MAX_LEN` | 1024 | `lrd_godel.h` | max items. Item 1025 → `E_LEN` (`too_many_items`), tested before the item is read or anything allocated (`L`, `n` unchanged). Item 1024 succeeds. |
| `LRD_GODEL_POSITIONAL_DEFAULT_MAX_BITS` | 2^26 | `lrd_godel.h` | default `max_bits`, positional |
| `LRD_GODEL_BIJ256_DEFAULT_MAX_BITS` | 2^23 | `lrd_godel.h` | default `max_bits`, bij256 |
| `LRD_PRIME_MAX_INDEX` | 65536 | `lrd_godel.h` | largest supported prime index (p_65536 = 821641) |

The binding limit is whichever is hit first: item count, `max_bits`, or prime index. At the default
2^26 bits the measured worst-case (all-0xff) stream capacity is 16 518 bytes.

## 5. Prime source

`lrd_prime(i)` is an incremental exact trial-division table (no probabilistic primality test, no
`mpz_nextprime`). It is deterministic and exact for `1 ≤ i ≤ LRD_PRIME_MAX_INDEX`.
**Largest supported index: 65536. Failure token beyond it:** `lrd_prime(0)` and `lrd_prime(i > 65536)` return
`0` (so does an allocation failure); ledger operations that need such a prime return `LRD_GODEL_E_PRIMECAP`
(`prime_index_above_cap`). `lrd_godel_pos_from_stream` with a start index or stream that crosses the cap returns it.

Reference table: `tests/ledger/primes_first1000.txt` — p_1 … p_1000 (2 … 7919), one per line after a
`#`-comment header, generated by an awk trial-division loop independent of the C code.
**sha256 of the file: `22db001956f3a84aa74fcb0bce32118f0ba802dff771f5db94aba7ba5748af0a`.**
Test `godel_primes_match_checked_in_table` verifies the hash with libcrypto and `lrd_prime(k)` for all 1000 entries;
`godel_prime_cap_documented_error` checks `lrd_prime(65536)` against an independent sieve, `lrd_prime(65537) == 0`
and the `E_PRIMECAP` result.

## 6. Genesis convention

* **seq 0 is the empty ledger**: `L = 1`, `n = 0`, `stream_len = 0`, in every mode.
* The first successful append yields **seq 1** (`n = 1`). `seq` equals the number of appended records.
* **seq follows ingestion order, one append per seq**: record number `k` (1-based, in the order accepted)
  has `seq = k`; a refused append does not advance `seq`.
* `LRD_GENESIS_COMMIT` in `ledger/abi/lrd_state.h` (line 52–53) is, as found in the file, the string of
  64 `0` characters (`"000…0"`, 64 characters). It is the `commit` of the seq-0 state ("64 zeros at genesis"), so the
  first transition has `seq = 1 = prev seq + 1`, matching LRD-STATE-v1. The ledger code does not hash anything with it.
* Test: `godel_genesis_seq0_convention`.

## 7. Known gaps

* The n log n size of positional `L` and the 2^26-bit default make the capacity finite (§4); there is no streaming/segmenting.
* `lrd_godel_append_envelope` only appends a zero-length marker item in `bij256-bytes` mode; it does **not** encode the payload.
* Bare `L` is mode-ambiguous (§1); the mode must be carried alongside it.
* The Alloy model (`research/alloy/GodelLedger.als`) abstracts arithmetic; it does not model the byte stream or framing.
