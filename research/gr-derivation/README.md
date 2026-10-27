# gr-derivation

> **Scope.** A mathematical derivation of a model: not empirical evidence about QSO1, and not an explanation of the z = 7.04221 vs 7.0451 discrepancy. See `DERIVATION.md`, including the *conditional characteristic radius* in section 1.5, which is not an upper limit and not a measured radius.

## What runs

`./run.sh` runs every check in `checks/` and writes `results.txt`. It exits non-zero if any FAIL line appears.

| Tool | Checks |
|---|---|
| Maxima 5.47.0 (symbolic) | `checks/maxima/01`-`06_*.mac` (with `common.mac`) |
| GNU Octave 9.4.0 (not MATLAB) | `checks/octave/numeric_kruskal.m` |
| gfortran (Fortran 2018) | `checks/fortran/redshift_er.f90` |
| bc and awk (mawk) | `checks/arith/redshift_table.bc`, `checks/arith/redshift_check.awk` |

`bootstrap_maxima.sh` is an optional user-space install of Debian's Maxima (no root) for machines without it. The run script finds Maxima on PATH or in `$HOME/tools/maxroot`.

No Python, JavaScript or TypeScript is used. No Lean, Agda or Coq was used, and no formal proof is claimed.

## Result (verbatim last line of `results.txt`, run 2026-10-26)

```
SUMMARY: 55 PASS lines, 0 FAIL lines; individual checks passed: 9475 of 9475
```

All code files carry `SPDX-License-Identifier: AGPL-3.0-only`.
