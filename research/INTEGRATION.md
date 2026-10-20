# JWST-LRD integration report

Licensed AGPL-3.0 plus the SnapKitty Opaque License. Maintained by Hilbert, the integration engineer. Every claim here comes from a command that Hilbert re-ran in /workspace/jwst-lrd. A track's own completion claim is never accepted without that re-run.

## Gate status
| Gate | Owner / branch | Status | Evidence |
|---|---|---|---|
| 001 toolchain + build | Foundry J Spec / t001-ingest-fortran | not yet received | - |
| 002 real MAST ingestion | Foundry J Spec / t001-ingest-fortran | not yet received | - |
| 003 Fortran kernel | Foundry J Spec / t001-ingest-fortran | not yet received | - |
| 004 Godel ledger + lrd_state.h | Alapeno Spec / t004-ledger | header merged (627fda7); ledger 10/10 re-run at ca5a26e but BLOCKED: only records <=2 bytes fit (bij256 exponent), repair assigned (positional encoding) | lrd_state.h: C17 and C++17 -Wall -Wextra -Werror -pedantic syntax OK (Hilbert re-ran) |
| 005 RSA accumulator | Foundry J Verify / t005-rsaacc | not yet received | - |
| 006 causal | HCALC Alloy / t006-causal (review: HCALC Spec) | not yet received | - |
| 007 topology/homology | HCALC Alloy / t-topology (review: HCALC Spec) | not yet received | - |
| 010 capabilities + verifier | HCALC Alloy / t010-capability (review: HCALC Lean) | in review; canonical over reverted a0873f6 | head 0323cbc: Hilbert re-ran tests/capability/run.sh, 67 PASS. Rust, not in the stated stack (rationale requested) |
| 011 Agda kernel | HCALC Alloy / t011-agda-kernel (review: HCALC Lean) | not yet received | - |
| 008 Hamiltonian | Foundry J Verify / t008-hamiltonian | in review (HCALC Alloy) | head c67266f: Hilbert re-ran tests/hamiltonian/run.sh, 40 PASS |
| 009 AIR/STARK | Alapeno RTL / t009-air | in review (HCALC Alloy) | head c9dba36: Hilbert re-ran tests/air/run.sh, 29 PASS 1 UNAVAILABLE (real_input). From-scratch C17 STARK: Goldilocks/Fp2, FRI, blowup 8, 40 queries, 16 grinding bits. Conjectured 127 bits (random oracle plus ethSTARK Conj. 1). Proven 49 bits (unique decoding) / 74 bits (list decoding). No ZK, not audited |
| 011 Agda core | HCALC Lean / t011-agda | not yet received | - |
| 012 Curry engine | HCALC Spec / t012-curry | not yet received | - |
| 013 Futhark | Foundry J Core / agent2-futhark | in review (HCALC Alloy); repairs assigned | head 1a9dd6e: Hilbert re-ran tests/futhark/run.sh, pass=58 fail=0 unavailable=2 (fortran-ref-diff-x1d, fortran-diff) |
| 013 MATLAB/SAS | Foundry J Verify | not yet received | expected UNAVAILABLE (licensed) |
| 014 LRD-IR/LLVM + validation | Alapeno Silicon / t014-llvm | not yet received | - |
| 015 Self/Morphic | Grok Bot / t015-self | not yet received | - |
| 016 adversarial | Foundry J Verify / t016-adversarial | not yet received | - |
| Alloy bounded checks, review | HCALC Alloy / guardian-alloy | not yet received | - |

## Canonical serialization and ABI
Defined in research/CONTRACTS.md (main 6b9cef6): LRD-ARR-v1, LRD-REC-v1, LRD-STATE-v1. Header owners are ledger/abi/lrd_state.h (Alapeno Spec) and abi/lrd_num_abi.h (Alapeno Silicon).

## Exact build commands
Not established yet.

## Test counts
None run at integration level yet.

## Missing dependencies
None recorded yet.

## Unresolved proof obligations
None recorded yet.

## Security assumptions
None recorded yet.

## Scientific limitations
None recorded yet.

## Real observation identifiers
Ingested on t001-ingest-fortran, not merged yet. Both products come from the MAST cone search at the cited QSO1 Image A position (Furtak et al. 2023, ApJ 952, 142, Table 1); the header-coordinate check is still pending.
- jw02561-o002_s000013123_nirspec_clear-prism_x1d.fits: obsid 300843505, 10941120 bytes, sha256 09bcd9077647ebf4fdaa766807de832bf6a94b92e3ed73fdb8a3c0281ae50c31, CAL_VER 3.0.0, DATE-OBS 2023-07-31
- jw02561-o006_s000024175_nirspec_clear-prism_x1d.fits: obsid 230168921, 6347520 bytes, sha256 c0b878576d7d7ec723c5ee526d29715fb672d81e45bc8ba4e02598ce8b9c5ee7

## Status at 2026-10-19 22:58 PT (Hilbert)
Repo: github.com/AHMADALIPARR/jwst-lrd (public). License text is AGPL-3.0-only everywhere (c1bc485).

| Gate | Head | Hilbert re-run | Review |
|---|---|---|---|
| 001-003 ingest+Fortran | 69ee34a | 59 PASS | HCALC Alloy, pending |
| 004 ledger | f30ae12 | blocked (record size) | positional fix plus Alloy gaps assigned |
| 008 Hamiltonian | 737348b | 40 PASS | Alloy: NOT PASS (B1: epoch_exhausted-before-infeasible untested), repair assigned |
| 009 AIR | c9dba36 | 29 PASS / 1 UNAV | Alloy, pending. Real input reads the wrong fixture, repair assigned |
| 010 capability (Rust, rationale accepted) | db02c80 | 67 PASS | Lean: NOT PASS (2 major: stale STATUS; persist-failure path), repair assigned |
| 013 Futhark | eeb1e78 | 58 PASS / 2 UNAV at 1a9dd6e | Alloy: NOT PASS (B1 crash counted as pass; B2 mutation claim), repair assigned |
| 014 LLVM + validation | e4253a5 | 129 PASS; 31 PASS / 9 UNAV (MATLAB and SAS licensed) | Alloy, pending |
| Alloy bounded models (004/010/006) | 5cee510 | not re-run (about 12 min) | 36/36 expected; bounded, not proofs |

Integration branch ec8ffb7 (t001+futhark+t008+t009+t010): 157 PASS / 2 FAIL / 3 UNAV. Both FAILs are tests/run_all.sh launching bash suites with `sh`; the repair is assigned to Foundry J Spec.

Fixture finding: 09bcd907 (obsid 300843505) has all-negative FLUX and is provenance only. The primary is c0b87857 (obsid 230168921). The Fortran gives z = 7.04221 ± 0.00027 against a published 7.0451, a discrepancy that remains open.

Missions: BLIND-PROTOCOL.md (four blind fitters) and MISSION-QSO1-DCBH-001.md (12 roles). The May 2026 and September 2026 papers are not yet retrieved.

## Handoff at 2026-10-19 23:01 PT (Hilbert)
- AIR/STARK passed HCALC Alloy's review (c9dba36, 8 minor). Its merge to main is held: its mirror header failed against the -only ledger header. Alapeno RTL is removing the mirror and including ledger/abi/lrd_state.h from main.
- The -only lrd_state.h is on main at 38570a9, sha256 d5ff6110...ea33.
- Topology t-topology 7f71e07 is pushed and reports 270 PASS. Hilbert's re-run was interrupted, so the count is unverified. Review owner: HCALC Spec.
- Next: re-run each repaired branch, merge the ones that pass review, and trace the real QSO1 fixture c0b87857 end to end.
