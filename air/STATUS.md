<!-- SPDX-License-Identifier: AGPL-3.0-only
     Additional terms: SnapKitty Opaque License (SNAPKITTY_OPAQUE_LICENSE.md, repository root). -->
# air/STATUS.md — TASK 009: AIR + STARK

Branch `t009-air` (from main `6b9cef6`). Track owner: t009. **HCALC Alloy review: PENDING.**
This track doesn't count as done until HCALC Alloy signs off.

## What this is

`LRD-AIR-SUMSQ-v1` is a small deterministic arithmetic AIR with a STARK prover and verifier. Everything is written from scratch in C17 (no external STARK library). SHA-256 comes from OpenSSL libcrypto.

* **Kernel (one real numerical transition):** fixed-point sum of squares, a chi-square-like accumulation.
  Inputs `v_i` (LRD-ARR-v1 `.f64`) are encoded as `q_i = llround(v_i * scale)` (round half away from zero). The encoder requires `|q_i| <= 2^24`, and the trace length must satisfy `N <= 2^14`. Together these give `output = sum q_i^2 < 2^62 < p`, so the field result equals the integer result (no wrap-around).
  The output is published as an integer and as the reduced rational `output/scale^2`.
* **Trace:** `N = max(16, next_pow2(n+1))` rows, 2 columns `x` and `acc` over Goldilocks.
  `acc[0]=0`, `acc[i+1]=acc[i]+x[i]^2`, `x[i]=q_i` (zero padding).
* **Constraints** (`w` = generator of the size-N subgroup H):
  * T (transition, degree 2): `acc(wX) - acc(X) - x(X)^2 = 0` on H minus `{w^(N-1)}`, divisor `(X^N-1)/(X-w^(N-1))`.
  * B0: `acc(1) = 0`.
  * B1: `acc(w^(N-1)) = output` (public output).
  * P (public-input binding): `x(X) - I(X) = 0` on H, where I is the interpolant of the public fixed-point inputs. The verifier computes `I(z)` itself with an iNTT of the inputs.
* **Field:** Goldilocks `p = 2^64 - 2^32 + 1` (two-adicity 32, generator 7). All verifier randomness lives in the quadratic extension `Fp2 = Fp[u]/(u^2 - 7)`: composition coefficients, the OOD point `z` (forced to lie in Fp2 \ Fp), DEEP coefficients and FRI folding challenges. 7 is a non-residue (unit-tested), so the extension is irreducible.
* **Protocol** (in transcript order):
  1. The Fiat-Shamir transcript absorbs the serialized LRD-REC-v1 public-input record first, then the 40-byte proof header (parameters).
  2. Trace columns are interpolated (iNTT) and low-degree-extended (blowup 8) on the coset `7*<w_{8N}>`. Each Merkle leaf holds the rows `j` and `j+4N`, hashed with SHA-256 (`leaf=H(0x00||data)`, `node=H(0x01||L||R)`). The root is absorbed.
  3. Draw 4 coefficients `alpha_k` in Fp2. Build the composition `H = sum alpha_k C_k/Z_k`, which has degree < N, so no splitting is needed. The prover self-checks this degree. Commit H's LDE with a Merkle tree and absorb the root.
  4. Draw the OOD point `z` in Fp2 \ Fp. Send `acc(z), x(z), acc(wz), x(wz), H(z)`. The verifier checks `H(z) == sum alpha_k C_k(z)/Z_k(z)`.
  5. Draw 5 DEEP coefficients and build the DEEP composition `D(X) = sum gamma * (f(X)-f(zeta))/(X-zeta)` over `{acc,x}@{z,wz}` and `H@z`.
  6. Run FRI on D, fold factor 2. The first layer is not committed, because the verifier recomputes D from the trace and H openings (ethSTARK style). Layers 1..r-1 each get a Merkle commitment. After r = log2(N) - 3 folds, the prover sends an explicit remainder polynomial of 8 coefficients.
  7. Grinding: a 16-bit proof-of-work nonce over the transcript state.
  8. Draw 40 distinct query pair-indices from the transcript. Each query opens trace, H and every FRI layer with Merkle paths.
* **Proof format:** `LRDAIRP1` version 1 (see `air/src/proof.c` header comment). Contents: magic, version, field_id, hash_id, params, roots, OOD values, FRI roots, remainder, nonce, then per query the openings and paths. The deserializer bounds-checks every read, rejects non-canonical field elements, requires counts to match the parameters and requires exact length. For the SYNTHETIC input the proof is 56744 bytes.
* **Ledger binding (LRD-STATE-v1, kind=air_proof):**
  * The public-input record contains `observation_sha256` (SHA-256 of the raw `.f64` bytes), `ledger_prev_commit` (LRD-COMMIT-v1 of the current state record), `ledger_seq`, `inputs_sha256`, `output`, `output_rational`, `scale`, `trace_length`, `input_count`, `input_name` and all proof parameters (18 fields).
  * The proposal record contains `kind=air_proof`, `prev_commit`, `seq`, `payload_sha256 = SHA-256(proof bytes)`, `air_name`, `air_output` and `air_pub_commit` (LRD-COMMIT-v1 of the public record).
  * The decision is `ACCEPT reason=ok new_commit=...`, or `REJECT` with reason `stale_seq` | `bad_prev` | `bad_payload` | `bad_public_input` | `bad_proof` (`bad_kind` for a wrong kind). A REJECT never builds a state.
  * **ASSUMPTION:** `new_commit` = LRD-COMMIT-v1 of the new state record `{seq, commit=prev_commit, kind=air_proof, payload_sha256}`. CONTRACTS.md doesn't define how `new_commit` is derived, so the ledger track must confirm this.

## What is and is not a "complete STARK"

It **is** a STARK-style argument: an AIR, trace LDE plus Merkle commitment, a constraint-quotient composition, DEEP-ALI with an out-of-domain point in an extension field, FRI with per-layer Merkle commitments and a query phase, made non-interactive with Fiat-Shamir (SHA-256), plus grinding. It is not just a polynomial identity check: every claim the verifier relies on comes from Merkle openings at Fiat-Shamir-chosen positions, and FRI enforces low degree.

It is **not** any of the following, and nothing here claims otherwise:
* **Zero-knowledge.** There is no trace masking or randomizer polynomial. The inputs are public anyway.
* **Succinct for this kernel.** The verifier does O(n) work to bind the public inputs (iNTT of the inputs to get `I(z)`), which is about the cost of recomputing the sum. The point is a working, verifiable demonstration of the pipeline, not a speedup.
* **Reviewed or audited.** The code is new, has not been externally reviewed, and is not production-ready.
* **Using Merkle multi-proofs.** Each opening carries its own path, which affects size but not soundness.
* **A general AIR framework.** The AIR is hard-coded: one kernel with 4 constraints.

## Parameters and security (computed by the code, printed by `air_cli`/`test_air`)

| parameter | value |
|---|---|
| field | Goldilocks p = 2^64 - 2^32 + 1; challenges/OOD/DEEP/FRI over Fp2 (u^2 = 7), ~128-bit |
| hash | SHA-256 (Merkle trees + Fiat-Shamir transcript); collision resistance 128 bits |
| trace length (SYNTHETIC, n=100) | 128 |
| blowup | 8 (rate 1/8), LDE domain 1024, coset offset 7 |
| FRI | fold factor 2, 4 folds, remainder 8 coefficients |
| queries | 40 (distinct) |
| grinding | 16 bits |
| verifier policy | rejects any proof whose parameters differ from the above (`params_not_policy`) |

* **Conjectured security: 127 bits (CONJECTURED).** Formula, ported from winterfell `air/src/proof/security.rs` `ConjecturedSecurity::compute` (Eq. 19 of ethSTARK, eprint 2021/582):
  `min( min(field_bits, Q*log2(blowup) + G) - 1, collision_bits )` = `min( min(64*2, 40*3 + 16) - 1, 128 )` = 127.
  Winterfell adds grinding only when `Q*log2(blowup) >= 80`; here that's 120, so grinding counts.
  * **Assumptions:** SHA-256 behaves as a random oracle (Fiat-Shamir and Merkle binding); the ethSTARK Conjecture 1 / FRI proximity-gap conjecture (list-decoding up to capacity); 40 distinct uniformly random queries; and `field_bits = 64*2`, following winterfell's convention for Goldilocks (log2 p ≈ 63.99999999966).
  * **Without the quadratic extension** the OOD/DEEP and batching soundness would be capped near log2(p) ≈ 64 bits minus degree terms (about log2(N*blowup)). That's why all challenges are drawn in Fp2.
  * The value is capped by SHA-256's 128-bit collision resistance.
* **Proven (non-conjectural) estimates are much lower:** unique-decoding regime **49 bits**, list-decoding regime **74 bits**. These come from C ports of winterfell `ProvenSecurity` (Theorems 2/3 of eprint 2024/1553). The ports are cross-checked against winterfell's own unit-test expectations (116, 100 and 69 bits for their test parameter sets) in test `security_estimate_port`. The bottleneck is the query phase at 40 queries; by the same ported formula, reaching 100 proven UDR bits at N=128, blowup 8, grinding 16 needs 102 queries (computed with `air_proven_security_udr_bits`).
* Don't read 127 as a proven bound. It's a conjecture-based estimate. The proven figures for these parameters are 49 bits (UDR) and 74 bits (LDR).
* Source of the formulas: `https://raw.githubusercontent.com/facebook/winterfell/main/air/src/proof/security.rs`, fetched 2026-10-19 (sha256 of the fetched file `2dd4f4626d809acfd86b44490c7a63549c299873593c5fd8aba2cdbcd821ffc2`).

## Libraries considered (audit status, checked on the web 2026-10-19)

No external STARK library is used. The narrow-ABI option (Rust winterfell behind a C ABI) was evaluated and not taken.

* **winterfell (Rust, facebook/winterfell):** **not audited, per its own README** (verified by fetching `README.md` on 2026-10-19): "WARNING: This is a research project. It has not been audited and may contain bugs and security flaws. This implementation is NOT ready for production use." Since wrapping it would give no audited guarantee, it wasn't used. Only its published security-estimate formulas were ported.
* **StarkWare Stone prover (C++, starkware-libs/stone-prover):** **no dedicated public audit report of Stone found: not verified.** Its README contains no audit statement (checked 2026-10-19). StarkWare's blog says Stone has been in production since June 2020 (an operational claim, not an audit). StarkWare also reports a Lean formal verification of the Cairo-VM-to-polynomial encoding for Stone, which covers the AIR encoding and is not a code audit. zkSecurity audited verifiers that consume Stone proofs (Herodotus Integrity, a Cairo verifier) and the Stwo-Cairo verifier, but not the Stone prover itself.
* **SHA-256:** OpenSSL libcrypto EVP (system package), a widely reviewed implementation. In this repo it is checked only against the FIPS 180-4/NIST example vectors ("abc", empty string, 448-bit message, one million 'a').
* **Toolchains present on the box:** gcc 14.2.0, clang 19.1.7, g++ 14.2.0, rustc/cargo 1.85.1, gfortran, cmake. (winterfell 0.13.x lists MSRV 1.87 on crates.io, newer than the installed rustc 1.85.1.)

## Input data: SYNTHETIC

The real JWST x1d fixture from Foundry J Spec has not landed (there's no `fixtures/raw` on main). All proofs here use `tests/air/fixtures/SYNTHETIC_lrd_flux.{f64,hdr}`. This is **SYNTHETIC, not JWST data**: 100 samples, continuum 1.0 + Lorentzian line + ripple, unit `SYNTHETIC_arbitrary`. It is generated by `air/tools/gen_synthetic.c` using only IEEE +,-,*,/, and `run.sh` checks that it regenerates byte for byte.
* f64 sha256 `dcf0ec5f5f8f229aa1371d18b00c47de25d0a125d1ee09d0a29430023730c525`, scale 65536.
* Proven output `1056468827179` = `1056468827179/4294967296` (sum of squared fixed-point fluxes).
* `test_air` cross-checks this output against a direct long-double computation.
* **Pluggable real input:** `air_cli prove|verify <arr_base> <scale> <dir>` accepts any LRD-ARR-v1 pair. `tests/air/run.sh` searches `fixtures/` for a non-SYNTHETIC LRD-ARR-v1 header. If it finds one and `AIR_REAL_SCALE` is set, it proves and verifies it (PASS/FAIL); otherwise it prints `UNAVAILABLE real_input`. The scale must be chosen per unit: physical fluxes like 1e-18 erg/s/cm^2/A need a large scale or pre-normalisation to stay within |q| <= 2^24 without rounding to 0. A suggested follow-up kernel (flux*(1+z) in fixed point) is not implemented.

## Build (exact commands, as run by tests/air/run.sh)

```
make -C air BUILD=build                       # cc (gcc 14.2.0): -O2 -std=c17 -Wall -Wextra -Werror -Iinclude -Iabi_mirror, -lcrypto -lm
make -C air BUILD=build-clang CC=clang        # clang 19.1.7, same flags
make -C air BUILD=build-san CFLAGS="-O1 -g -fno-omit-frame-pointer" \
     SAN="-fsanitize=address,undefined -fno-sanitize-recover=all"
AIR_TAMPER_STRIDE=97 ASAN_OPTIONS=detect_leaks=1:abort_on_error=1 UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1 \
     air/build-san/test_air tests/air/fixtures/SYNTHETIC_lrd_flux
tests/air/run.sh                               # everything; ~30 s; diagnostics in air/build/logs/
```
* All three builds succeed with zero warnings under `-Werror`.
* The ASan+UBSan run of the full C test binary passes with no sanitizer reports. Its tamper test flips one byte in every 97 (585 flips); the normal run flips every byte (56744 flips).

## What ran — verbatim output of `tests/air/run.sh` (exit 0)

```
PASS build_c17_wall_wextra_werror
PASS build_clang_c17_werror
PASS synthetic_fixture_reproducible
PASS sha256_fips180_4_vectors
PASS field_goldilocks_arith
PASS field_roots_of_unity
PASS field_fp2_extension
PASS ntt_roundtrip_and_naive
PASS interpolation_and_lde
PASS merkle_sha256
PASS lrd_rec_v1_serialization
PASS fixed_point_encoding
PASS security_estimate_port
PASS honest_proof_verifies
PASS proof_deterministic
PASS proof_serialization_roundtrip
PASS tampered_proof_bytes_rejected
PASS corrupted_trace_cell_rejected
PASS fabricated_output_rejected
PASS mismatched_observation_sha256_rejected
PASS mismatched_ledger_commit_rejected
PASS lrd_state_air_proof_transition
PASS cli_prove_verify_accept
PASS cli_modified_proof_rejected
PASS cli_other_observation_rejected
PASS asan_ubsan_test_air
PASS lrd_state_mirror_matches_t004_ledger
UNAVAILABLE real_input no real (non-SYNTHETIC) LRD-ARR-v1 JWST x1d fixture under fixtures/ (Foundry J Spec fixture not landed)
PASS no_python_typescript_javascript
PASS license_headers
```

Diagnostic lines from `air/build/logs/test_air.log`, verbatim (`new_commit` changes with the proof bytes):

```
# params: trace_length=128 blowup=8 queries=40 grinding_bits=16 conjectured_bits=127 proven_udr_bits=49 proven_ldr_bits=74
# honest proof: n=100 output=1056468827179 (1056468827179/4294967296) proof_bytes=56744
# tampered proof: 56744/56744 single-bit flips rejected (one flip per byte position, stride 1)
# corrupted cell row=37 col=acc: prover self-check 'composition_not_low_degree(trace violates constraints)'; forced proof rejected by verifier: ood_constraint_mismatch
#   same corruption with OOD-consistent lie about H(z): rejected by FRI: fri_remainder_mismatch
# corrupted cell row=5 col=x: prover self-check 'composition_not_low_degree(trace violates constraints)'; forced proof rejected by verifier: ood_constraint_mismatch
#   same corruption with OOD-consistent lie about H(z): rejected by FRI: fri_remainder_mismatch
# corrupted cell row=127 col=acc: prover self-check 'composition_not_low_degree(trace violates constraints)'; forced proof rejected by verifier: ood_constraint_mismatch
#   same corruption with OOD-consistent lie about H(z): rejected by FRI: fri_remainder_mismatch
# corrupted cell row=127 col=x: prover self-check 'composition_not_low_degree(trace violates constraints)'; forced proof rejected by verifier: ood_constraint_mismatch
#   same corruption with OOD-consistent lie about H(z): rejected by FRI: fri_remainder_mismatch
# fabricated output 1056468827180 (true 1056468827179): forced proof rejected: ood_constraint_mismatch
#   fabricated output with OOD-consistent lie about H(z): rejected by FRI: fri_remainder_mismatch
# honest proof presented with fabricated output: rejected: grinding_nonce_invalid
#   (diagnostic verifier with grinding check skipped also rejects: ood_constraint_mismatch)
# different observation_sha256 at verify time: rejected: grinding_nonce_invalid
#   (diagnostic verifier with grinding check skipped also rejects: ood_constraint_mismatch)
# different ledger_prev_commit at verify time: rejected: grinding_nonce_invalid
#   (diagnostic verifier with grinding check skipped also rejects: ood_constraint_mismatch)
# decision: decision=ACCEPT reason=ok new_commit=cefb12c0e7a29ce377778157ca7db72db05b2570346ef18191f446e6ae73bf7a
# proof made for another ledger commit, relabelled to current: decision=REJECT reason=bad_proof detail=grinding_nonce_invalid
```

**What the rejection tests demonstrate:**
* A corrupted trace cell (in `x` or `acc`, middle row or last row) is refused by the honest prover's self-check. A forced proof built from that trace fails the verifier's OOD check. When the cheating prover also lies about `H(z)` so the OOD check passes, FRI rejects (`fri_remainder_mismatch`).
* A fabricated output gets the same treatment. Presenting the honest proof with a different output, a different `observation_sha256` or a different ledger commit changes the Fiat-Shamir transcript. Verification then fails at the grinding check. A test-only diagnostic verifier that skips grinding (never used for acceptance) shows the OOD check also rejects.
* Every single-byte flip anywhere in the proof is rejected. Truncated proofs and proofs with trailing bytes are rejected too.
* At the ledger level: replaying a proposal gives `stale_seq`, a wrong prev gives `bad_prev`, a proof bound to another ledger commit (relabelled) gives `bad_proof`, an inconsistent public record gives `bad_public_input`, and tampered proof bytes with a recomputed payload hash give `bad_proof`.

## Blockers / assumptions

1. **`ledger/abi/lrd_state.h` is not on main.** `air/abi_mirror/lrd_state.h` is a byte-identical copy of `ledger/abi/lrd_state.h` from branch `t004-ledger` at commit `627fda7` (ledger track), preceded by a 9-line TODO header. `run.sh` checks that it matches (`lrd_state_mirror_matches_t004_ledger`).
   **TODO:** once t004-ledger is merged, delete `air/abi_mirror/` and change `-Iabi_mirror` to `-I../ledger/abi` in `air/Makefile`. No source changes are needed.
   The mirror's own SPDX line (`AGPL-3.0-or-later AND LicenseRef-SnapKitty-Opaque`) is the ledger track's. air/ files use `AGPL-3.0-only` plus the SnapKitty Opaque License line, as instructed.
2. **`new_commit` derivation** is an assumption (see above). It needs confirmation from the ledger track and Hilbert.
3. **`air_transition` signature:** it takes the public record, the inputs and the proof bytes explicitly, so it doesn't match the bare `lrd_transition_fn` typedef. It needs a context mechanism from the ledger track to plug in.
4. **No real JWST fixture:** `real_input` is UNAVAILABLE. Choosing a fixed-point scale for the real flux unit is still open.
5. **Agda obligations** for `air_proof` (`agda/OBLIGATIONS.md`) haven't been contributed. That has to go through Hilbert.
6. **HCALC Alloy review is pending.**
