<!-- SPDX-License-Identifier: AGPL-3.0-only. Also licensed under the SnapKitty Opaque License; see LICENSE and SNAPKITTY_OPAQUE_LICENSE.md at the repository root. -->
# LRD-IR v1: a small typed text IR for JWST-LRD analysis programs

LRD-IR is compiled by `llvm/lrdc` (C17): parse -> type check -> LLVM IR text (`.ll`) ->
`llc` -> object -> `clang` link with `llvm/runtime` + `abi/` -> native executable.
What is actually tested is listed in `llvm/SUPPORT.md`. Only those ops are claimed.

## Lexical structure
- One statement per line. `#` starts a comment that runs to the end of the line. Blank lines are ignored.
- Identifiers: `[A-Za-z_][A-Za-z0-9_]*`. Reserved words: `let print store emit assert lrdir true false f64 i64 bool arr mat rec str`.
- Numeric literals: C `strtod` syntax for f64 (must be finite). i64 literals are `-?[0-9]+`.
- String literals: `"..."`, no newline, with `\"` and `\\` as the only escapes.
- Program arguments: `$1`, `$2`, ... (a string that is `argv[N]` of the executable at run time).
  A missing argument is a run-time error.

## Grammar (EBNF)
```
program   := header { stmt }
header    := "lrdir" "1"                       (* first non-comment line *)
stmt      := "let" IDENT ":" type "=" init
           | "print"  IDENT                    (* any bound type *)
           | "store"  IDENT strarg             (* arr<f64> or f64 -> LRD-ARR-v1 at prefix strarg *)
           | "emit"   IDENT strarg             (* rec -> canonical LRD-REC-v1 bytes to file strarg *)
           | "assert" IDENT STRING             (* bool; false -> runtime error with the message *)
init      := literal | OP "(" [ arg { "," arg } ] ")"
literal   := NUMBER | "true" | "false"
arg       := IDENT | NUMBER | "true" | "false" | STRING | "$" DIGITS
strarg    := STRING | "$" DIGITS
type      := "f64" | "i64" | "bool" | "arr" "<" "f64" ">" | "mat" "<" "f64" ">" | "rec"
```
Variables are immutable and bound exactly once (`redefinition of 'x'` is an error). They must be
bound before use (`undefined variable 'x'`). The declared type must equal the op's result type.
`str` is an argument-only type: string literals and `$N`. It cannot be bound to a variable.

## Types
| type | meaning | LLVM representation |
|---|---|---|
| `f64` | IEEE-754 binary64 | `double` |
| `i64` | signed 64-bit integer | `i64` |
| `bool` | truth value | `i1` |
| `arr<f64>` | LRD-ARR-v1 array (values + unit string) | `ptr` (runtime handle) |
| `mat<f64>` | row-major dense matrix | `ptr` (runtime handle) |
| `rec` | LRD-REC-v1 record (proposal or state) | `ptr` (runtime handle) |
| `str` | argument-only string | `ptr` to a private constant, or `lrd_rt_arg(N)` |

## Operations (signature -> result)
Argument types are checked exactly. A numeric literal is accepted where `f64` or `i64` is expected.
For `i64` it must be an integer literal. An unknown op, wrong arity, or wrong argument type is a
compile-time error and lrdc exits 1 with no output file.

| op | signature | semantics |
|---|---|---|
| `load` | `(str path, str unit) -> arr<f64>` | read `<path>.hdr` and `<path>.f64` via `abi/lrd_num_abi.h`. Checks: `format=LRD-ARR-v1`; required keys `name`, `length`, `unit`; no duplicate keys; `.f64` size = 8*length; header unit == `unit` |
| `len` | `(arr) -> i64` | number of elements |
| `get` | `(arr, i64) -> f64` | element, bounds-checked |
| `restframe` | `(arr lam_obs, f64 z) -> arr` | `lam_obs[i] / (1+z)`; z must be finite and > -1; unit is kept |
| `obsframe` | `(arr lam_rest, f64 z) -> arr` | `lam_rest[i] * (1+z)`; same checks |
| `redshift` | `(f64 lam_obs, f64 lam_rest) -> f64` | `lam_obs/lam_rest - 1`; both must be finite and > 0 |
| `redshift_arr` | `(arr obs, arr rest) -> arr` | elementwise `obs[i]/rest[i] - 1`; equal lengths and units, all > 0; result unit `1` |
| `convert` | `(arr, str from, str to) -> arr` | exact unit conversion. `from`/`to` must be literals and the pair is checked at compile time. At run time the array unit must equal `from` |
| `all_finite` | `(arr) -> bool` | no NaN or Inf |
| `monotone_inc` | `(arr) -> bool` | all finite and strictly increasing |
| `in_range` | `(arr, f64 lo, f64 hi) -> bool` / `(f64, f64, f64) -> bool` | all values finite and in [lo, hi] |
| `and`, `or` | `(bool, bool) -> bool` | |
| `not` | `(bool) -> bool` | |
| `residuals` | `(arr obs, arr model) -> arr` | `obs[i] - model[i]`; equal lengths and units, else runtime error |
| `chi2` | `(arr obs, arr model, arr sigma) -> f64` | `sum_i ((obs_i - model_i)/sigma_i)^2`, summed in order i = 0..n-1; equal lengths and units; every sigma finite and > 0 (no masking) |
| `mat` | `(arr, i64 rows, i64 cols) -> mat<f64>` | row-major reshape; length must equal rows*cols |
| `matmul` | `(mat, mat) -> mat` | inner dimensions must agree; k-ascending sums, no FMA |
| `solve` | `(mat A, arr b) -> arr` | solves A x = b by LU with partial pivoting. A must be square, finite, and the same order as b. Singular when a pivot is 0 or <= n*DBL_EPSILON*max abs(A_ij): explicit runtime error |
| `flatten` | `(mat) -> arr` | row-major values, unit `1` |
| `ledger_proposal` | `(str prev_commit, i64 seq, arr payload) -> rec` | LRD-STATE-v1 proposal `{kind=ledger_append, payload_sha256, prev_commit, seq}`. `payload_sha256` = SHA-256 of the payload's little-endian binary64 bytes (= `sha256sum` of its `.f64`). prev_commit must be 64 lowercase hex and seq >= 1 |
| `gate` | `(str verifier, rec proposal) -> rec` | runs the verifier binary with the canonical proposal serialization on stdin and parses stdout as a strict LRD-REC-v1 decision. Proceeds only on `decision=ACCEPT` with valid `reason` and 64-hex `new_commit`; returns the new state `{commit=new_commit, kind, payload_sha256, seq}`. On REJECT, malformed output, unknown fields, nonzero exit or exec failure: no state is constructed, and the program prints the reason and exits 4 |

### Unit conversions (exact, `convert`)
| from | to | operation |
|---|---|---|
| `um` | `Angstrom` | x * 1e4 |
| `Angstrom` | `um` | x / 1e4 |
| `um` | `nm` | x * 1e3 |
| `nm` | `um` | x / 1e3 |
| `nm` | `Angstrom` | x * 10 |
| `Angstrom` | `nm` | x / 10 |
Any other pair is the compile-time error `unknown unit conversion 'A' -> 'B'`.

## LRD-REC-v1 / LRD-STATE-v1
Serialization follows research/CONTRACTS.md exactly: `LRD-REC-v1\n`, then per field, sorted
bytewise by key, `<len(key)>:<key><len(value)>:<value>\n`. The commitment is SHA-256 over
`"LRD-COMMIT-v1\0" || serialization`, written as lowercase hex. Field names, kind tokens and hex checks come
from `ledger/abi/lrd_state.h`, which is included and not forked.

## Exit codes
- lrdc: 0 ok, 1 compile error (`lrdc: error: FILE:LINE: ...`), 2 usage.
- compiled programs: 0 ok; 3 runtime error (`lrd runtime error: <op>: <reason>`); 4 transition
  rejected or malformed verifier output (`... no new state constructed`).

## Lowering
Elementwise ops (`restframe`, `obsframe`, `convert`, `residuals`, `redshift_arr`), `chi2` and the
scalar ops (`redshift`, `and`, `or`, `not`) are lowered to inline LLVM IR loops/instructions
(`fdiv`/`fmul`/`fsub`/`fadd` with no fast-math or contract flags). Checks, I/O, constraints,
matrix ops, records and the gate call the C runtime (`llvm/runtime/lrd_rt.h`). The output is
deterministic: strings are numbered by first use, there are no timestamps, and `source_filename` is the input
basename.
