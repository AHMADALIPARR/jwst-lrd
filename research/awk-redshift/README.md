<!-- SPDX-License-Identifier: AGPL-3.0-only -->
# awk redshift cross-check (Abell 2744-QSO1) — what actually ran

An independent signal-processing cross-check of the QSO1 redshift written only in `awk` + `bash` + `od`
(no Python/JS/TS). Only **mawk 1.3.4** was used; gawk was not available and was not tested.

## What ran (2026-10-26, 18:00-18:08 PDT, full `./run.sh`)
- `test.sh`: **PASS=37 FAIL=0** (total 37), verbatim in `results/run.log`.
- Pre-specified primary estimator (matched filter, running-median continuum, joint Hbeta+Halpha):
  **z = 7.040280** (Delta-chi2=1 +/-0.000268; chi2_red-rescaled +/-0.000685).
- For comparison: Fortran **7.04221** (+/-0.00027); published **7.0451** (+/-0.0005).
- **The gap is unresolved.** The awk primary value is below both; no variant reached 7.0451.
  Variants span about 4e-3 in z (see `RESULTS.md`), i.e. analysis-choice systematics are the same size as the gap.
- Tests and results labelled SYNTHETIC or CONTROL (injection/recovery, noisy recovery, noise-only and
  permutation controls) are **synthetic, not real data** and say nothing about the real redshift.

## What did not run
Only the real-data run described above. Nothing was checked with any other awk. After the path change below,
only a quick smoke was re-run (`lib/prep.sh` plus the `test.sh` A and B sections: data integrity and unit
tests, 15/15 PASS); the full ~8 minute `run.sh` was **not** re-run, so `results/run.log` comes from the original run.

## Layout
- `run.sh` end-to-end driver; `test.sh` tests; `lib/prep.sh` sha256 verification + `od` export to text;
  `lib/fixtures.sh` fixture-directory resolution; `awk/*.awk` the algorithms.
- `results/run.log` verbatim log of the run; `RESULTS.md` the write-up (verbatim output + hand-written analysis).
- Scratch `work/` and raw data copies are **not** included. The raw data are the repo's own fixtures, referenced by
  sha256 `c0b878576d7d7ec723c5ee526d29715fb672d81e45bc8ba4e02598ce8b9c5ee7` at
  `fixtures/raw/<sha>.fits` and `fixtures/ingest/<sha>/` (arrays checked against `manifest.kv`). Fixture 09bcd907 is not read.

## Running
`./run.sh` (about 8 minutes) from this directory; writes `work/` (untracked scratch) and `results/run.log`.
Fixtures are resolved by `lib/fixtures.sh`: `$SRC` if set, else `<repo root>/fixtures`, else `$LRD_SHARED/fixtures`
(`LRD_SHARED` = root of a jwst-lrd checkout).

## Note on RESULTS.md and results/run.log
They are verbatim from the original run, which read fixtures from a scratch clone at
`/workspace/verify-main/repo/fixtures` (the log's `prep: SRC=` line and the "nothing was pushed" remark reflect
that scratch environment). Only the fixture path handling was changed afterwards; no algorithm changed.
Both files embed the original scratch paths.
