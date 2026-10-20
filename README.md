# JWST-LRD

A sovereign scientific runtime for public James Webb Space Telescope data on Little Red Dots, starting with Abell 2744-QSO1.

The project's charter:

1. Preserve observations exactly.
2. Verify computations independently.
3. Keep competing explanations alive.
4. Never confuse mathematical proof with empirical discovery.

Licensed AGPL-3.0-only plus the SnapKitty Opaque License (see `LICENSE` and `SNAPKITTY_OPAQUE_LICENSE.md`).

## What it does

**Archive ingestion** (branch `t001-ingest-fortran`)
- Retrieves NIRSpec PRISM/CLEAR x1d spectra of QSO1 Image A from MAST by a cone search at RA 3.5798375, Dec −30.4015733. The position is from Furtak et al. 2023, ApJ 952, 142.
- Stores each raw FITS file read-only under its SHA-256. The primary product is `jw02561-o006_s000024175_nirspec_clear-prism_x1d.fits` (obsid 230168921, sha256 `c0b87857…5ee7`).
- Checks that the product's pointing lies within 0.03″ of the published position.
- Exports wavelength, flux and flux error as LRD-ARR-v1 arrays with LRD-REC-v1 manifests.
- Replays the full ingest offline, with network access removed, and verifies every byte.

**Spectral numerics**
- Fortran 2018 kernels fit Hβ and Hα on the real spectrum and give z = 7.04221 ± 0.00027 (`t001-ingest-fortran`).
- Futhark 0.25.27 kernels do unit conversion (µm to Å, Jy to f_λ with propagated errors), vacuum-to-air conversion checked against Morton 2000, and a z-grid line search, each diffed against a Fortran reference (`agent2-futhark`).

**Compiler** (branch `t014-llvm`)
- `lrdc` lowers the LRD-IR scientific operations to LLVM 19 native code. These are rest-frame and observed-frame transforms, unit conversion, residuals, χ², matmul, LU solve and ledger proposals.
- On the real QSO1 spectrum, its output matches the Fortran results bit for bit.
- It uses the versioned C ABI in `abi/lrd_num_abi.h`.

**Ledger ABI**
- `ledger/abi/lrd_state.h` is the C17 and C++17 header for the LRD-STATE-v1 transition record.
- Every state change is a proposal plus a decision, and each is committed by SHA-256.

**Hamiltonian transition engine** (branch `t008-hamiltonian`)
- Exact rational arithmetic (GMP).
- Checks hard and soft constraints and requires strictly descending energy within bounded epochs.
- Returns deterministic accept or reject decisions with reasons.

**AIR/STARK proofs** (branch `t009-air`)
- A from-scratch C17 STARK-style prover and verifier over the Goldilocks field.
- Uses DEEP-ALI, FRI, SHA-256 Merkle commitments, a Fiat-Shamir transcript and grinding.
- It attests one numerical transition and rejects fabricated results.
- Security is stated in two regimes: 127 bits conjectured, and 49 or 74 bits proven.

**Capability layer** (branch `t010-capability`)
- An independent authority process issues single-use, slot-bound capabilities.
- It is backed by a hand-written RSA accumulator, HMAC-SHA256 and SHA-256, checked against NIST, RFC 4231 and OpenSSL vectors.

**Topology ledger** (branch `t-topology`)
- Fortran and Futhark simplicial homology over GF(2), GF(3), GF(5) and Q.
- Merkle commitments over the full incidence structure.
- Incremental updates that match a full recompute.

**Bounded formal models** (branch `guardian-alloy`)
- Alloy 6 models of the Gödel ledger, capability addressing and causal ordering.
- All 36 checks give their expected results.

## Build and test

```sh
git clone https://github.com/AHMADALIPARR/jwst-lrd.git && cd jwst-lrd
git checkout <branch>
make fixtures   # on t001-ingest-fortran: re-fetch and verify the MAST products
make test       # every suite prints PASS / FAIL / UNAVAILABLE lines
```

Toolchain: gcc and gfortran 14.2.0, clang and LLVM 19.1.7, Futhark 0.25.27, GMP, cfitsio, OpenSSL, Rust (capability authority only), Alloy 6. Exact versions are pinned in `build/TOOLCHAIN.lock`.

Test counts below are from independent re-runs:

| Branch | Result |
|---|---|
| `t001-ingest-fortran` | 59 PASS |
| `t014-llvm` | 129 PASS; validation 31 PASS |
| `t010-capability` | 67 PASS |
| `t008-hamiltonian` | 40 PASS |
| `t009-air` | 29 PASS |
| `agent2-futhark` | 58 PASS |

## Repository layout

| Path | Contents |
|---|---|
| `research/CONTRACTS.md` | File formats (LRD-ARR-v1, LRD-REC-v1, LRD-STATE-v1) and the charter |
| `research/INTEGRATION.md` | Integration log: verified heads, build commands, test counts |
| `research/BLIND-PROTOCOL.md` | Blind four-model analysis of the QSO1 spectrum |
| `research/MISSION-QSO1-DCBH-001.md` | Black-hole seed and growth-history study |
| `research/assets/` | Illustrations, not data |

Each subsystem is developed on its own branch and merged to `main` after independent re-test and review.

## Production status (2026-10-20)
Integration branch includes a clean merge of current main. Key observational paper (Juodžbalis et al. 2026, Nature) has been retrieved for the QSO1-DCBH-001 mission. Remaining work: complete pending reviews (Alloy/Lean), resolve listed blockers in research/INTEGRATION.md (ledger record size, capability design reconciliation, real-fixture end-to-end, etc.), and finish specialized mission agent deliverables once rate limits clear. All claims require independent re-test by Hilbert.
