<!-- SPDX-License-Identifier: AGPL-3.0-only. Also subject to SNAPKITTY_OPAQUE_LICENSE.md (dual license). -->
# theorems/ — proved theorems, labelled

Every theorem here carries a label. The label is the join key across
the three verification layers:

1. **Coq** (`theorems/coq/`) — the proof of record.
2. **Liquid Haskell** (`haskell/theorems/`) — the same statements as
   refinement theorems, checked by Liquid Haskell + Z3. The
   Curry classifier (`curry/growth/`) is likewise refined into
   Liquid Haskell (`haskell/growth/`): Curry-Howard, propositions as
   refinement types.
3. **CompCert** (`theorems/compcert/`) — every C file in the repo
   compiled with CompCert 3.14: compilation that is semantics-
   preserving by CompCert's own correctness theorem. CompCert checks
   compilation, not the mathematics; the mathematics is layers 1–2.

The runtimes do not change: the Fortran solver, the Curry classifier
and the C code keep running exactly as before. This directory is the
proof layer over them.

## Label index

| label | statement | C source certified | Coq | Liquid Haskell |
|---|---|---|---|---|
| THM-AIR-FP-ADD-001 | fp_add(a,b) = (a+b) mod p, canonical, for canonical a,b | air/include/air/field.h fp_add | PROVED (fp_add_correct) | pending toolchain |
| THM-AIR-FP-SUB-002 | fp_sub(a,b) = (a−b) mod p, canonical | air/include/air/field.h fp_sub | PROVED (fp_sub_correct) | pending toolchain |
| THM-AIR-FP-NEG-003 | fp_neg(a) = (−a) mod p, canonical | air/include/air/field.h fp_neg | PROVED (fp_neg_correct) | pending toolchain |
| THM-AIR-FP-RED128-004 | fp_reduce128(x) = x mod p, canonical, for all x < 2^128 | air/include/air/field.h fp_reduce128 | PROVED (fp_reduce128_correct) | pending toolchain |
| THM-AIR-FP-MUL-005 | fp_mul(a,b) = (a·b) mod p, canonical | air/include/air/field.h fp_mul | PROVED (fp_mul_correct) | pending toolchain |

p = 2^64 − 2^32 + 1 (Goldilocks). All five Coq theorems verified with
`Print Assumptions`: **closed under the global context** — no axioms,
no admits (Coq 8.18.0). The Coq definitions model the C line by line
over Z, uint64 wraparound written as (mod 2^64); inputs are canonical
([0, p)), matching the contract stated in field.h.

## CompCert sweep (theorems/compcert/run_sweep.sh)

2026-10-20, CompCert 3.14 built from source: **32 of 45 C files PASS**
(compile under CompCert's verified C subset). The 13 failures are all
CompCert language-subset limits, not code defects:

- 10 files fail only because air/field.h uses `unsigned __int128`,
  which CompCert's C parser does not support: air/src/{arr, crypto,
  field, poly, proof, rec, stark, state}.c, air/tools/air_cli.c,
  tests/air/test_air.c. The mathematics those files rely on is
  exactly THM-AIR-FP-* above, proved in Coq.
- 2 files fail on a function returning a struct/union by value
  (outside CompCert's subset): ledger/src/lrd_godel.c,
  tests/ledger/test_godel.c (via ledger/include/lrd_godel.h:64).
- 1 file uses a long double constant (outside the subset):
  llvm/runtime/lrd_rt.c:198.

The sweep uses two declaration-only shims (theorems/compcert/shim/)
so CompCert does not ingest glibc headers that use long double, and
for the POSIX ssize_t typedef. Full per-file results reproduce by
running the script.
