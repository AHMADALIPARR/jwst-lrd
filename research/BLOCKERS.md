<!-- SPDX-License-Identifier: AGPL-3.0-only -->
# BLOCKERS — resolution criteria for the five remaining blockers

Status: **proposal for owner review. Nothing in this file is implemented or verified by this branch**; it only fixes what "resolved" will mean so
each blocker can be closed by a test rather than by assertion. Baseline = `origin/main` at `ecfa86a` (measured 2026-10-27). The five blockers are
out of scope of the `repairs-oct26` PR (#20). Test names below are *proposed* names; none exists yet unless a file/line is cited.

Conventions: every test prints one line `PASS <name>` / `FAIL <name> <detail>` (the repo's existing style) and must be wired into the owning suite's
`tests/<suite>/run.sh` so `tests/run_all.sh` fails on regression. A blocker is closed only when **all** its pass conditions hold in a fresh clone.
No Python/JS/TS and no GitHub Actions are used for any of these tests.

| # | Blocker | Owner | Test suite |
|---|---|---|---|
| a | Ledger positional Gödel encoding: records > 2 bytes do not fit | Alapeno Spec | `tests/ledger`, `research/alloy` |
| b | Hamiltonian check order `epoch_exhausted` before `infeasible` is not mutation-pinned | Foundry J Verify | `tests/hamiltonian` |
| c | Capability `persist_failed` path has no test | HCALC Alloy | `capability/tests`, `tests/capability` |
| d | Ingest/reference assertions are weak or unconditional | Foundry J Spec | `tests/fortran` (reference run), `tests/ingest` |
| e | ~190 MB of tracked build artifacts | unassigned (no owner was named) | `tests/run_all.sh`, repo size check |

---

## (a) Ledger positional Gödel encoding — records > 2 bytes must fit
**Owner:** Alapeno Spec.

**Current state (`ledger/include/lrd_godel.h`, `ledger/STATUS.md`).** L = ∏ p_i^e_i with e_i = bijective-base-256(bytes of item i) + 1, so e_i ≈ 256^len and
log2(L) is exponential in record length. Under the default `max_bits` = 2^23 only records of ≤ 2 bytes (and the empty record) fit; larger appends are
refused with `too_big`. The smallest one-field record body (`1:a1:b\n`, 7 bytes) has a 54-bit exponent. The Alloy model (`research/alloy/GodelLedger.als`) documents
open gaps: **G1** no maximum ledger length / prime source is specified; **G2** negative exponents and exponents that are not the code of any symbol are unspecified;
the genesis (`seq 0`) convention is not pinned.

**Resolution criteria (each a pass condition).**
1. *Encoding fits.* A positional encoding is chosen for which an item's exponent is bounded by a function of a symbol code, not exponential in byte length
   (e.g. exponent = code of a canonical record/symbol table entry, as in Alloy assumption A3), **or** records are bound to bytes by another injective, documented scheme.
   Pass: a canonical record of ≥ 64 bytes (`LRD-REC-v1`) appends, and `bits(L)` ≤ `max_bits`.
2. *Documented maximum length.* A single named constant `LRD_GODEL_MAX_LEN` (items) and `max_bits` default are in `lrd_godel.h` and `ledger/README.md`.
   Pass: appending item `MAX_LEN+1` returns `LRD_GODEL_E_TOOBIG` (or a new `E_LEN`) **before** allocating; appending item `MAX_LEN` succeeds.
3. *Prime source specified.* The prime table is deterministic and exact (trial division today); document the largest index supported and the failure token beyond it.
   Pass: `p_1..p_k` equals a checked-in table (first 1000 primes, sha256 recorded) and index `k+1` beyond the cap returns the documented error.
4. *Negative / unknown exponents (Alloy G2) closed.* Decoding refuses every non-positive exponent and every exponent that is not a canonical symbol/record.
   Pass: C tests for `L` with exponent 0, a negative exponent (represented via rational/zero-denominator input rejected at parse), and a non-canonical exponent return
   `E_NOTPOS` / `E_GAP` / `E_EXTRA` / `E_NONCANON` as appropriate; Alloy `check` commands for G2 are added to `expectations.tsv` and return 0 (no counterexample) in scope.
5. *Genesis `seq 0` convention fixed.* State in `ledger/README.md` whether position 0 / `seq 0` is the empty ledger (`L = 1`) or the genesis record, and that `lrd_state.h`'s `seq` agrees.
   Pass: test `godel_genesis_seq0_convention` asserts `L = 1` (or the chosen value) at `seq 0`, and the first append yields `seq 1`.
6. *Backward behaviour.* Existing `tests/ledger` remain 10 PASS / 0 FAIL; no previously accepted ≤ 2-byte vector changes its decoded value (or the change is listed and approved).

**Test that proves it.** `tests/ledger/test_godel.c::godel_record_roundtrip_gt2bytes`: build an `LRD-REC-v1` record whose serialized body is **> 2 bytes** (use the 7-byte `1:a1:b\n`, then a 64-byte one),
append, check `bits(L) ≤ max_bits`, decode, and require byte-identical re-serialization (round trip) and that the appended record's commit equals the independently computed sha256 of the canonical bytes.
Pass: `PASS godel_record_roundtrip_gt2bytes` and `PASS godel_max_len_boundary`; the Alloy script `research/alloy/check.sh` reports all `expectations.tsv` rows matching.

---

## (b) Hamiltonian: `epoch_exhausted` must be checked before `infeasible`
**Owner:** Foundry J Verify.

**Current state.** `hamiltonian/OBLIGATIONS.md` §1.6 makes the order normative (row 8 `epoch_exhausted` → row 9 `infeasible` → row 10 `energy_not_decreasing`) and
`hamiltonian/src/ham_engine.c` (`ham_decide`, step path, lines ~273–301) implements it. But no test pins it: every existing exhaustion test (`t_epoch_exhausted`, `tests/hamiltonian/test_ham.c` ~L428 and ~L582)
uses a *feasible* candidate, and every infeasible test uses a non-exhausted state. A mutant that swaps rows 8 and 9 therefore survived with `pass=30 fail=0` (mutation result as reported by the owner of this track; not re-run here).

**Resolution criteria.**
1. A test constructs an epoch whose budget is used up (`steps_used == budget`) and proposes a candidate assignment that **violates a hard constraint** and **would also fail or pass energy** (cover both).
   Pass: reason is exactly `epoch_exhausted`; the decision record has `decision=REJECT`, **no** `violated` / `violated_count` fields (the infeasibility report was not computed), no state constructed (`ham_states_constructed()` unchanged), `*next` untouched.
2. The mirror case at the other boundary stays correct: the same infeasible candidate in a **non-exhausted** state returns `infeasible` with `violated_count ≥ 1`.
3. The `epoch_advance` path: advancing at `epoch+1 ≥ max_epochs` returns `epoch_exhausted` (already covered ~L471; keep).
4. **Mutation gate:** the order-swap mutant (rows 8/9 exchanged in `ham_engine.c`) is *killed* — `tests/hamiltonian/run.sh` reports `fail ≥ 1` against the mutant and `fail = 0` against the real source.
   Record the mutant as a patch file `hamiltonian/mutants/swap_8_9.patch` and a script `hamiltonian/mutants/run.sh` that applies it to a temp copy (never to the tree), builds, runs, and prints `KILLED swap_8_9` / `SURVIVED swap_8_9`.
5. Total pass count increases (30 → ≥ 32); no existing test is edited to make this pass.

**Test that proves it.** `tests/hamiltonian/test_ham.c::t_exhausted_beats_infeasible` (new) plus `hamiltonian/mutants/run.sh`.
Pass: `PASS exhausted_beats_infeasible` on the real source **and** `KILLED swap_8_9` from the mutant runner.

---

## (c) Capability: `persist_failed` path has no test
**Owner:** HCALC Alloy.

**Current state (`capability/src/authority.rs` @ `ecfa86a`).** The reason token `persist_failed` is produced at three `return` sites in code: line 330 (admin op path: `Rec::new().with("result","persist_failed")`),
line 400 (on consuming a capability: persist before any further decision) and line 443 (on ACCEPT: persist failed after extending the chain). The brief counted four places; this review found **three** returns plus the token declaration in
`capability/PROTOCOL.md` (L33), so the owner should confirm whether a fourth exists elsewhere. No file under `capability/tests`, `tests/capability` or `capability/scripts` references the token (grep: only `authority.rs` and `PROTOCOL.md`).
`capability/STATUS.md` (L152) states the ACCEPT-persist-failure rollback leaves the capability consumed and that crash/fault-injection was never done.

**Resolution criteria.**
1. A fault-injection hook makes `persist_inner` fail deterministically **without** weakening production code paths: e.g. point the authority's state directory at a path where the temp-file write or `rename` fails
   (read-only directory, or a path component that is a regular file). No `cfg(test)`-only branch that skips the real I/O.
2. For **each** of the three sites, a test drives the request and asserts the exact reason token:
   - consume-site (L400): `decision=REJECT reason=persist_failed`, no `new_commit`, `head_seq` unchanged.
   - accept-site (L443): `decision=REJECT reason=persist_failed`, no `new_commit`, in-memory chain rolled back (`STATUS seq` unchanged), capability stays **consumed** (a replay returns `replay` / `retired`, not `ok`).
   - admin-site (L330): `result=persist_failed` with a `detail=` field.
3. After the injected failure is removed, the authority recovers: a fresh request with a new capability is ACCEPTed and `persisted_seq` equals `seq`; the on-disk state file is the old consistent one (byte-identical to before the fault, sha256 compared).
4. The token list in `PROTOCOL.md` matches the code (a test greps every `reject(&tag, "<tok>"` token in `authority.rs` and requires each to appear in `PROTOCOL.md`).
5. `capability` suite stays all PASS (currently 67/0/0) with ≥ 3 additional PASS.

**Test that proves it.** `capability/tests/adversarial.rs::persist_failed_*` (three tests, Rust, existing harness) and a shell-level `capability/scripts/integration.sh` case `e2e_persist_failed_token`.
Pass: three `PASS persist_failed_<site>` lines asserting the exact token, and a `PASS persist_failed_recovers` line.

---

## (d) Ingest / reference assertions
**Owner:** Foundry J Spec.

**Current state (`tests/fortran/run.sh`, reference-run block ~L25–49; ingest tests in `tests/ingest/run.sh`).**
- The redshift check passes if |z − 7.0451| ≤ one Hα prism pixel expressed in z (`pixel_ang/6564.632`); the measured gap is **0.0029**, which this tolerance hides (`fortran/STATUS.md` L53 says it is ≈ 10× the formal error). It is reported as `PASS redshift_vs_furtak2024…`.
- `PASS reference_lrd_arr_v1_headers` (L49) is printed **unconditionally** after the loop; a failing array `continue`s the loop but the loop's own `fail` is a different line, so a bogus array name in the list is only caught by chance of the `|| { fail …; continue; }` branch and is followed by an unconditional PASS.
- No test prints the expected pixel/array **count** it asserts against; and no independent check of the σ (flux_error) values against the source FITS exists.

**Resolution criteria.**
1. *Expected count printed.* Each count assertion prints `expected=<n> got=<m>` in both PASS and FAIL lines (arrays: 8; pixels: 429, valid 408, masked 21 for the c0b87857 fixture).
2. *Conditional `reference_lrd_arr_v1_headers`.* The PASS is emitted only if every array in the list passed. Negative test: inject a bogus array name (`bogus_array`) into the list (via an env var such as `LRD_TEST_EXTRA_ARRAY`) — the suite must print `FAIL reference_lrd_arr_bogus_array` and **must not** print `PASS reference_lrd_arr_v1_headers`; exit status non-zero.
3. *Independent sigma-value check.* σ(flux_error) is re-derived independently of the Fortran path (e.g. read the FITS `FLUX_ERROR` column with the repo's `ingest/src/lrd_fitsx.c` or `od`+`awk`) and compared with `flux_error.f64`: pass = max relative difference ≤ 1e-12 over all valid pixels, and the check prints the count compared.
4. *z gate labelled OPEN, not PASS.* The one-pixel-tolerance check is renamed/printed as `OPEN redshift_vs_furtak2024 dz=0.0029 tol=<one pixel> (inside declared tolerance; 0.0029 ≈ 10x formal error; unresolved)`; it does not increment PASS and does not fail the suite. Add a separate strict line `FAIL-EXPECTED/OPEN redshift_strict dz=0.0029 > 3*formal_err` so the offset is visible. Pass: no `PASS redshift_vs_furtak2024…` line remains; one `OPEN` line shows the 0.0029 offset.
5. Suite counts are re-baselined and documented (OPEN is a new category in `tests/run_all.sh` summary, counted separately from PASS/FAIL/UNAVAILABLE).

**Test that proves it.** `tests/fortran/run.sh` negative-injection run (`LRD_TEST_EXTRA_ARRAY=bogus_array sh tests/fortran/run.sh`) must exit non-zero with the `FAIL … bogus_array` line and **no** `PASS reference_lrd_arr_v1_headers`; the normal run prints `expected=… got=…` on every count line, one `PASS reference_sigma_independent n=<count>`, and one `OPEN redshift_vs_furtak2024`.

---

## (e) ~190 MB of tracked build artifacts
**Owner:** unassigned (no owner named; proposed: repository owner).

**Current state (measured on a fresh clone of `ecfa86a`, `git ls-tree -r -l HEAD`).**
- Total tracked: **216.4 MB (5197 files)**. `build/tools` **189.7 MB (4410 files)**, `build/logs` 0.87 MB (4 files), `build/out` 0.10 MB (11 files).
- Curry caches `**/.curry/**`: 61.1 MB (1039 files) — 60.7 MB of these are inside `build/tools`; 0.48 MB (10 files) in `curry/growth/.curry/`.
- Coq artifacts in `theorems/coq/`: `AirField.vo`, `.glob`, `.vok`, `.vos`, `.AirField.aux`, `.lia.cache`, `.nia.cache` (≈ 0.6 MB, 7 files).
- `.gitignore` already lists `build/logs/`, `build/tools/`, `build/out/`, `*.o`, `*.agdai`, `_build/` but the files are **tracked**, so the ignore has no effect. It lacks `.curry/` and the Coq artifacts.
- **After removing everything above, tracked size is 24.6 MB (755 files).** Of this, **17.3 MB is `fixtures/raw/*.fits`** (10.9 MB + 6.3 MB), which tests read (sha256-pinned). So the literal target "< 15 MB" is **not reachable by removing build artifacts alone**; see criterion 3.
- Note: removal only changes the tip. The ~80 MB packed history keeps the blobs; shrinking `.git` needs a history rewrite.

**Resolution criteria.**
1. *Untrack the artifacts (tip only, no history rewrite):*
   `git rm -r --cached build/tools build/logs build/out` · `git rm -r --cached $(git ls-files | grep -E '(^|/)\.curry/')` · `git rm --cached theorems/coq/{AirField.vo,AirField.vok,AirField.vos,AirField.glob,.AirField.aux,.lia.cache,.nia.cache}`.
   **Keep tracked:** `build/TOOLCHAIN.lock`, `build/toolchain.sh`, `build/install-curry-self.sh`.
   Pass: `git ls-files build | sort` equals exactly those three files; `git ls-files | grep -E '(^|/)\.curry/|\.(vo|vos|vok|glob)$'` is empty.
2. *`.gitignore`* gains `.curry/`, `theorems/coq/*.vo`, `*.vos`, `*.vok`, `*.glob`, `theorems/coq/.*.aux`, `theorems/coq/.*.cache` and keeps the existing build entries (negation lines for the three kept build files, as `build/*` + `!build/TOOLCHAIN.lock` etc.).
   Pass: `git status --porcelain` is empty after running `build/toolchain.sh` and the full suite in the work tree (no artifact is re-added).
3. *Size gate.* Pass: `git ls-tree -r -l HEAD | awk '{s+=$4} END{exit !(s < 15*1024*1024)}'` returns 0 **or** the owner records an explicit decision for `fixtures/raw/` (17.3 MB): move to a release asset / fetch script with sha256 pinned (`ingest/fetch_fixtures.sh` already exists), after which the gate must pass; the interim, honest gate is `tracked size excluding fixtures/raw < 15 MB` (measured 7.3 MB) plus the explicit decision. Do not quietly relax the number.
4. *Tests still pass.* In a **fresh clone of the new tip**: run `build/toolchain.sh`, `build/install-curry-self.sh` (re-creates PAKCS/Self under `build/tools`), then `tests/run_all.sh`. Pass: no suite regresses vs the pre-change totals (the PR #20 baseline 843/1/29, or the then-current baseline) — in particular `growth`, `curry-growth` and `self` (they resolve `build/tools/pakcs-3.10.0` and `build/tools/self-src/...`) must not drop from PASS to FAIL; a suite whose tool cannot be rebuilt must report `UNAVAILABLE`, not FAIL, and the reason is documented.
5. *History rewrite and force-push are NOT authorized.* Shrinking the 80 MB pack would require `git filter-repo`/BFG plus a force-push to all branches; that needs **explicit written user approval** and is excluded from this blocker's closing criteria. A tip-only removal closes (e) only with the size-gate caveat above.

**Test that proves it.** `tests/repo/size_check.sh` (new): prints `tracked_bytes=<n> files=<m>`, `PASS no_tracked_build_artifacts` (criterion 1 greps), `PASS gitignore_covers_artifacts` (`git check-ignore -q` on a sample of 10 artifact paths) and `PASS tracked_size_lt_15MB` (or the documented fixtures exception); then `tests/run_all.sh` in the fresh clone as in criterion 4.
