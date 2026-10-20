# JWST-LRD integration report

Licensed AGPL-3.0 plus the SnapKitty Opaque License. Maintained by Hilbert, the integration engineer. Every claim here comes from a command that Hilbert re-ran in /workspace/jwst-lrd. A track's own completion claim is never accepted without that re-run.

## Gate status
| Gate | Owner / branch | Status | Evidence |
|---|---|---|---|
| 001 toolchain + build | Foundry J Spec / t001-ingest-fortran | not yet received | - |
| 002 real MAST ingestion | Foundry J Spec / t001-ingest-fortran | not yet received | - |
| 003 Fortran kernel | Foundry J Spec / t001-ingest-fortran | not yet received | - |
| 004 Godel ledger + lrd_state.h | Alapeno Spec / t004-ledger | not yet received | - |
| 005 RSA accumulator | Foundry J Verify / t005-rsaacc | not yet received | - |
| 006 causal | HCALC Alloy / t006-causal (review: HCALC Spec) | not yet received | - |
| 007 topology/homology | HCALC Alloy / t-topology (review: HCALC Spec) | not yet received | - |
| 010 capabilities + verifier | HCALC Alloy / t010-capability (review: HCALC Lean) | not yet received | - |
| 011 Agda kernel | HCALC Alloy / t011-agda-kernel (review: HCALC Lean) | not yet received | - |
| 008 Hamiltonian | Foundry J Verify / t008-hamiltonian | not yet received | - |
| 009 AIR/STARK | Alapeno RTL / t009-air | not yet received | - |
| 011 Agda core | HCALC Lean / t011-agda | not yet received | - |
| 012 Curry engine | HCALC Spec / t012-curry | not yet received | - |
| 013 Futhark | Foundry J Core / agent2-futhark | not yet received | - |
| 013 MATLAB/SAS | Foundry J Verify | not yet received | expected UNAVAILABLE (licensed) |
| 014 LRD-IR/LLVM + validation | Alapeno Silicon / t014-llvm | not yet received | - |
| 015 Self/Morphic | Grok Bot / t006-geom-self | not yet received | - |
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
None ingested yet.
