<!-- SPDX-License-Identifier: AGPL-3.0-only -->
# verify-latch — prototype

"MATLAB produces measurement evidence, but Erlang decides whether the latch opens."

Everything below was actually run in the original scratch directory. Outputs are verbatim copies of
the run outputs. `/workspace/jwst-lrd` was only read (HEAD revision query).

## Status (honest summary)
- **MATLAB: UNAVAILABLE.** MATLAB was never run. The `.m` files were run only under **GNU Octave 9.4.0 — NOT MATLAB**.
- **Rust differential: not done** (the Rust `SignalLatch` source was not found on disk; no Rust was written or compiled).
- Erlang unit tests (`latch_core`): **19/19 PASS**.
- Octave evidence checks: **11/11 PASS** (Octave 9.4.0, not MATLAB).
- Scripted JetStream demo events are SYNTHETIC (`scripted-rev-*`), not verification results of the jwst-lrd project.

## What is in this directory
Committed: `src/`, `test/`, `scripts/`, `octave/`, `data/redshift_inputs.txt`, this README, and the logs `run/demo_output.txt` and `run/svc.log`.
Not committed (see `.gitignore`): `ebin/`, `ebin_test/` build outputs, the `nats-server` binary (`bin/`), the JetStream store (`run/js/`), and all key material (`run/*.key`; `scripts/demo_js.sh` generates a fresh HMAC key with `openssl rand`).
The README below was written in the scratch directory and refers to other run outputs (`run/*.txt`, `run/*.log`) that are quoted verbatim in it but not committed as files, and to `bin/`; regenerate them with the scripts.


## Availability (checked)
| Tool | Status |
|---|---|
| Erlang/OTP 27 (erl, erlc, eunit) | AVAILABLE |
| rebar3 | UNAVAILABLE (plain `erlc` via `scripts/build.sh`) |
| nats-server v2.15.2 | AVAILABLE (downloaded to `bin/`, official release, checksum verified) |
| Erlang NATS client | none installed; minimal `gen_tcp` client written (`src/nats_min.erl`), incl. JetStream via `$JS.API` |
| Octave 9.4.0 | AVAILABLE — all evaluation labelled "Octave, NOT MATLAB" |
| MATLAB | UNAVAILABLE (licensed, not here). `.m` files are written portably but NEVER run under MATLAB |
| Rust differential (user's `SignalLatch`) | UNAVAILABLE: source not found on disk; not recreated ("no new Rust"). rustc exists but nothing was compiled. Rust is not in the decision path. |

## Layout
- `src/latch_core.erl` pure latch (no I/O); `src/latch_sig.erl` HMAC-SHA256 (key read from file, never echoed)
- `src/nats_min.erl`, `src/latch_service.erl`, `src/latch_ctl.erl`, `src/latch_scenario.erl` (synthetic scripted events)
- `test/` eunit cases + PASS/FAIL/UNAVAILABLE runner
- `octave/` MATLAB-compatible evidence producer + checks; `data/redshift_inputs.txt` inputs with provenance
- `scripts/` build / unit / octave / JetStream demo

## Latch rules implemented (latch_core.erl header R1–R9)
Dedupe by event id; sequence per stream (stream key = subject), not global; a stale seq returns
`STALE_EVENT` with no state change; PASS never clears a latched failure; FAIL clears only via
signed repair (`verify.evidence.repair`, HMAC-SHA256 over revision+check+event ids) for the SAME
revision, and then a fresh PASS is still required; state keyed by git revision; invalid status
latches (BLOCK); **critical UNAVAILABLE => QUARANTINE, and a later PASS for the same check on the
same revision resolves it (explicit rule R-UNAVAIL, tested)**. `RELEASE_CANDIDATE` is not final
authorization (carried in every published decision).

**Deviations/additions to flag:** an internal `PENDING` state (no evidence yet / repaired, awaiting
fresh PASS) so BLOCK is not emitted before any evidence; a non-critical FAIL gives QUARANTINE, a
critical FAIL BLOCK; non-critical UNAVAILABLE is recorded without changing the latch.

## 1. Erlang unit tests (verbatim, `run/unit_output.txt`)
```
== custom runner (PASS/FAIL/UNAVAILABLE counts) ==
PASS      stale event returns STALE_EVENT, state unchanged
PASS      duplicate id returns DUPLICATE, state unchanged
PASS      PASS cannot clear a latched FAIL
PASS      FAIL non-critical -> QUARANTINE; critical -> BLOCK
PASS      invalid status latches (BLOCK)
PASS      repair with wrong revision rejected (valid sig for other rev)
PASS      repair with envelope rev != signed rev rejected (bad signature)
PASS      repair with bad signature rejected (wrong key / tampered)
PASS      repair with right revision and signature clears; fresh PASS needed
PASS      critical UNAVAILABLE -> QUARANTINE, resolved by same-check PASS same revision
PASS      UNAVAILABLE not resolved by other check / other revision PASS
PASS      non-critical UNAVAILABLE recorded, no latch change
PASS      UNAVAILABLE cannot weaken a latched FAIL
PASS      per-stream sequences are independent (not global)
PASS      latch state keyed by revision
PASS      malformed envelope -> MALFORMED, state unchanged
PASS      RELEASE_CANDIDATE only when all required checks PASS
PASS      replay of the same log (with redelivered duplicates) -> identical state hash
PASS      signing key never appears in state or decisions

SUMMARY (latch_core eunit cases): PASS=19 FAIL=0 UNAVAILABLE=0 TOTAL=19
== plain eunit ==
  All 19 tests passed.
eunit result: ok
```
Counts: PASS=19 FAIL=0 UNAVAILABLE=0. Mutation sanity check (throw-away copies in /tmp, not kept):
4 deliberately broken mutants (PASS clears failure; no stale check; signature check bypassed; repair
accepted without a failure) were each caught (3, 2, 2, 1 failing tests respectively).

## 2. JetStream wiring (real nats-server 2.15.2, port 14222; verbatim `run/demo_output.txt`)
Run `scripts/demo_js.sh`. Durable pull consumer, explicit ack, ack_wait 3s. Order per event:
decide -> publish decision/audit (Nats-Msg-Id dedupe) -> persist snapshot (tmp+fsync+rename) -> ack.
Phase 1: batch 1, `kill -9`. Phase 2: events published while the service was down, restart and
resume. Phase 3: fault injection halts after persist but BEFORE ack of `S1-repair-good`; on
restart JetStream redelivers it (`delivered=2`) and the latch answers DUPLICATE with no change.
Cold replay with a fresh durable consumer and empty state, and an offline pure fold over the
stream, give the identical state hash. (In the transcript the `delivered=2` line appears after the
state dump of the first idle because the redelivery arrives after ack_wait; it is in `run/svc.log`.)

Key results from the transcript: hashes after phase 3, cold replay, and offline fold are all
`5c737a6cc4c297aedeb6041cc393297309777cf4a12debf6af8e80ca2984b95a` — "replay state IDENTICAL".
Final latch: scripted-rev-S1 RELEASE_CANDIDATE; scripted-rev-S2 BLOCK (invalid status);
real HEAD revision 1ed57a4f… BLOCK (redshift z FAIL + sigma UNAVAILABLE).

The scripted batches are SYNTHETIC (scripted-rev-S1/S2), not real project results.

```
nats-server nats-server: v2.15.2 pid=2402874 port=14222 jetstream on
streams VERIFY, VERIFYOUT ready

######## PHASE 1: publish scripted batch 1, start service (durable consumer 'latch')
  pub verify.signal.runner id=S1-runner-pass -> stream seq 1
  pub verify.signal.agda id=S1-agda-pass -> stream seq 2
  pub verify.signal.futhark id=S1-futhark-pass -> stream seq 3
  pub verify.signal.ledger id=S1-ledger-unavail -> stream seq 4
  pub verify.signal.hamiltonian id=S1-ham-pass-1 -> stream seq 5
published scripted batch 1 (5 events)
--- service log so far:
[latch] start consumer=latch state_file=latch.state events_seen=0 state_hash=ceb8e67200945c6e91cc898a228ba76a71527cf760495ed695eecef4dd9b3590
[latch] js_seq=1 delivered=1 verify.signal.runner id=S1-runner-pass -> ACCEPTED (pass_recorded) latch PENDING -> PENDING
[latch] js_seq=2 delivered=1 verify.signal.agda id=S1-agda-pass -> ACCEPTED (pass_recorded) latch PENDING -> PENDING
[latch] js_seq=3 delivered=1 verify.signal.futhark id=S1-futhark-pass -> ACCEPTED (pass_recorded) latch PENDING -> PENDING
[latch] js_seq=4 delivered=1 verify.signal.ledger id=S1-ledger-unavail -> ACCEPTED (critical_unavailable_quarantines) latch PENDING -> QUARANTINE
[latch] js_seq=5 delivered=1 verify.signal.hamiltonian id=S1-ham-pass-1 -> ACCEPTED (pass_recorded) latch QUARANTINE -> QUARANTINE
[latch] IDLE processed_this_run=5 state_hash=bc12e26b3352acd98a98ada2aecafc1e7de5824779abc2a39331d3b0346abc56
  rev scripted-rev-S1 latch=QUARANTINE passed=[<<"agda.kernel">>,
                                               <<"futhark.diff">>,
                                               <<"hamiltonian.suite">>,
                                               <<"runner.suite">>] failed=[] unavailable=[<<"ledger.abi">>]
  stream verify.signal.agda last_seq=1
  stream verify.signal.futhark last_seq=1
  stream verify.signal.hamiltonian last_seq=1
  stream verify.signal.ledger last_seq=1
  stream verify.signal.runner last_seq=1
  events_seen=5

>>> kill -9 service (pid 2402973)
state file persisted: 584 bytes

######## PHASE 2: publish batch 2 + Octave evidence while the service is DOWN
  pub verify.signal.ledger id=S1-ledger-pass -> stream seq 6
  pub verify.signal.hamiltonian id=S1-ham-fail -> stream seq 7
  pub verify.signal.hamiltonian id=S1-ham-pass-2 -> stream seq 8
  pub verify.signal.hamiltonian id=S1-ham-fail -> stream seq 9
  pub verify.signal.runner id=S1-runner-stale -> stream seq 10
  pub verify.signal.license id=S1-license-pass -> stream seq 11
  pub verify.signal.ingest id=S1-ingest-pass -> stream seq 12
  pub verify.signal.redshift id=S1-redshift-pass -> stream seq 13
  pub verify.signal.qso1 id=S1-qso1-pass -> stream seq 14
published scripted batch 2 (9 events)
published verify.evidence.measurement id=octave-redshift.z_residual-1ed57a4f5b94-qso1-fortran-t001-readme-2026-10 -> stream seq 15
published verify.evidence.measurement id=octave-redshift.sigma_residual-1ed57a4f5b94-qso1-fortran-t001-readme-2026-10 -> stream seq 16
>>> restart service: durable consumer must resume (unacked messages only), state from snapshot
[latch] start consumer=latch state_file=latch.state events_seen=5 state_hash=bc12e26b3352acd98a98ada2aecafc1e7de5824779abc2a39331d3b0346abc56
[latch] js_seq=6 delivered=1 verify.signal.ledger id=S1-ledger-pass -> UNAVAILABLE_RESOLVED (same_check_pass_on_same_revision) latch QUARANTINE -> PENDING
[latch] js_seq=7 delivered=1 verify.signal.hamiltonian id=S1-ham-fail -> ACCEPTED (fail_latched) latch PENDING -> BLOCK
[latch] js_seq=8 delivered=1 verify.signal.hamiltonian id=S1-ham-pass-2 -> PASS_IGNORED (cannot_clear_latched_failure) latch BLOCK -> BLOCK
[latch] js_seq=9 delivered=1 verify.signal.hamiltonian id=S1-ham-fail -> DUPLICATE (event_already_processed) latch BLOCK -> BLOCK
[latch] js_seq=10 delivered=1 verify.signal.runner id=S1-runner-stale -> STALE_EVENT ({seq_not_after_last_for_stream,<<"verify.signal.runner">>,1}) latch BLOCK -> BLOCK
[latch] js_seq=11 delivered=1 verify.signal.license id=S1-license-pass -> ACCEPTED (pass_recorded) latch BLOCK -> BLOCK
[latch] js_seq=12 delivered=1 verify.signal.ingest id=S1-ingest-pass -> ACCEPTED (pass_recorded) latch BLOCK -> BLOCK
[latch] js_seq=13 delivered=1 verify.signal.redshift id=S1-redshift-pass -> ACCEPTED (pass_recorded) latch BLOCK -> BLOCK
[latch] js_seq=14 delivered=1 verify.signal.qso1 id=S1-qso1-pass -> ACCEPTED (pass_recorded) latch BLOCK -> BLOCK
[latch] js_seq=15 delivered=1 verify.evidence.measurement id=octave-redshift.z_residual-1ed57a4f5b94-qso1-fortran-t001-readme-2026-10 -> ACCEPTED (fail_latched) latch PENDING -> BLOCK
[latch] js_seq=16 delivered=1 verify.evidence.measurement id=octave-redshift.sigma_residual-1ed57a4f5b94-qso1-fortran-t001-readme-2026-10 -> ACCEPTED (critical_unavailable_quarantines) latch BLOCK -> BLOCK
[latch] IDLE processed_this_run=11 state_hash=9a48cbb0bd1fde80c14a0a08badbbd2f48378166d05fa3d203402b8a4ed2cbed
  rev 1ed57a4f5b94443c9c224fc9b751ec94a816c1bf latch=BLOCK passed=[] failed=[<<"redshift.z_residual">>] unavailable=[<<"redshift.sigma_residual">>]
  rev scripted-rev-S1 latch=BLOCK passed=[<<"agda.kernel">>,
                                          <<"futhark.diff">>,
                                          <<"ingest.replay">>,
                                          <<"ledger.abi">>,<<"license.spdx">>,
                                          <<"qso1.fixture">>,
                                          <<"redshift.z_residual">>,
                                          <<"runner.suite">>] failed=[<<"hamiltonian.suite">>] unavailable=[]
  stream verify.evidence.measurement last_seq=2
  stream verify.signal.agda last_seq=1
  stream verify.signal.futhark last_seq=1
  stream verify.signal.hamiltonian last_seq=3
  stream verify.signal.ingest last_seq=1
  stream verify.signal.ledger last_seq=2
  stream verify.signal.license last_seq=1
  stream verify.signal.qso1 last_seq=1
  stream verify.signal.redshift last_seq=1
  stream verify.signal.runner last_seq=1
  events_seen=14

>>> kill -9 service (pid 2403146)

######## PHASE 3: batch 3 (repairs, invalid status). Fault injection: service halts after
######## persisting state but BEFORE acking event S1-repair-good (LATCH_CRASH_AFTER_EVENT)
  pub verify.signal.qso1 id=S2-qso1-invalid -> stream seq 17
  pub verify.evidence.repair id=S1-repair-badsig -> stream seq 18
  pub verify.evidence.repair id=S1-repair-wrongrev -> stream seq 19
  pub verify.evidence.repair id=S1-repair-good -> stream seq 20
  pub verify.signal.hamiltonian id=S1-ham-pass-3 -> stream seq 21
published scripted batch 3 (5 events)
>>> service exited with status 137 (137 = injected halt)
[latch] start consumer=latch state_file=latch.state events_seen=14 state_hash=9a48cbb0bd1fde80c14a0a08badbbd2f48378166d05fa3d203402b8a4ed2cbed
[latch] js_seq=17 delivered=1 verify.signal.qso1 id=S2-qso1-invalid -> ACCEPTED (invalid_status_latched) latch PENDING -> BLOCK
[latch] js_seq=18 delivered=1 verify.evidence.repair id=S1-repair-badsig -> REPAIR_REJECTED (bad_signature) latch BLOCK -> BLOCK
[latch] js_seq=19 delivered=1 verify.evidence.repair id=S1-repair-wrongrev -> REPAIR_REJECTED (no_latched_failure_for_this_revision_and_check) latch BLOCK -> BLOCK
[latch] js_seq=20 delivered=1 verify.evidence.repair id=S1-repair-good -> REPAIR_ACCEPTED (failure_cleared_check_needs_fresh_pass) latch BLOCK -> PENDING
[latch] FAULT INJECTION: halting after persist, BEFORE ack of S1-repair-good

>>> restart service WITHOUT fault: unacked repair is redelivered after ack_wait (3s)
[latch] start consumer=latch state_file=latch.state events_seen=16 state_hash=6e49c57651df69f49e6ffcdf6ff9500f1fb03fa9ca93a56acf4c347dafefef77
[latch] js_seq=21 delivered=1 verify.signal.hamiltonian id=S1-ham-pass-3 -> ACCEPTED (pass_recorded) latch PENDING -> RELEASE_CANDIDATE
[latch] IDLE processed_this_run=1 state_hash=5c737a6cc4c297aedeb6041cc393297309777cf4a12debf6af8e80ca2984b95a
  rev 1ed57a4f5b94443c9c224fc9b751ec94a816c1bf latch=BLOCK passed=[] failed=[<<"redshift.z_residual">>] unavailable=[<<"redshift.sigma_residual">>]
  rev scripted-rev-S1 latch=CANDIDATE passed=[<<"agda.kernel">>,
                                              <<"futhark.diff">>,
                                              <<"hamiltonian.suite">>,
                                              <<"ingest.replay">>,
                                              <<"ledger.abi">>,
                                              <<"license.spdx">>,
                                              <<"qso1.fixture">>,
                                              <<"redshift.z_residual">>,
                                              <<"runner.suite">>] failed=[] unavailable=[]
  rev scripted-rev-S2 latch=BLOCK passed=[] failed=[<<"qso1.fixture">>] unavailable=[]
  stream verify.evidence.measurement last_seq=2
  stream verify.evidence.repair last_seq=3
  stream verify.signal.agda last_seq=1
  stream verify.signal.futhark last_seq=1
  stream verify.signal.hamiltonian last_seq=4
  stream verify.signal.ingest last_seq=1
  stream verify.signal.ledger last_seq=2
  stream verify.signal.license last_seq=1
  stream verify.signal.qso1 last_seq=2
  stream verify.signal.redshift last_seq=1
  stream verify.signal.runner last_seq=1
  events_seen=17
[latch] js_seq=20 delivered=2 verify.evidence.repair id=S1-repair-good -> DUPLICATE (event_already_processed) latch RELEASE_CANDIDATE -> RELEASE_CANDIDATE
[latch] IDLE processed_this_run=2 state_hash=5c737a6cc4c297aedeb6041cc393297309777cf4a12debf6af8e80ca2984b95a
  rev 1ed57a4f5b94443c9c224fc9b751ec94a816c1bf latch=BLOCK passed=[] failed=[<<"redshift.z_residual">>] unavailable=[<<"redshift.sigma_residual">>]
  rev scripted-rev-S1 latch=CANDIDATE passed=[<<"agda.kernel">>,
                                              <<"futhark.diff">>,
                                              <<"hamiltonian.suite">>,
                                              <<"ingest.replay">>,
                                              <<"ledger.abi">>,
                                              <<"license.spdx">>,
                                              <<"qso1.fixture">>,
                                              <<"redshift.z_residual">>,
                                              <<"runner.suite">>] failed=[] unavailable=[]
  rev scripted-rev-S2 latch=BLOCK passed=[] failed=[<<"qso1.fixture">>] unavailable=[]
  stream verify.evidence.measurement last_seq=2
  stream verify.evidence.repair last_seq=3
  stream verify.signal.agda last_seq=1
  stream verify.signal.futhark last_seq=1
  stream verify.signal.hamiltonian last_seq=4
  stream verify.signal.ingest last_seq=1
  stream verify.signal.ledger last_seq=2
  stream verify.signal.license last_seq=1
  stream verify.signal.qso1 last_seq=2
  stream verify.signal.redshift last_seq=1
  stream verify.signal.runner last_seq=1
  events_seen=17

######## COLD REPLAY: new empty state, new durable consumer 'latch-replay' (deliver all), no publishing
[latch] start consumer=latch-replay state_file=replay.state events_seen=0 state_hash=ceb8e67200945c6e91cc898a228ba76a71527cf760495ed695eecef4dd9b3590
[latch] IDLE processed_this_run=21 state_hash=5c737a6cc4c297aedeb6041cc393297309777cf4a12debf6af8e80ca2984b95a
  rev 1ed57a4f5b94443c9c224fc9b751ec94a816c1bf latch=BLOCK passed=[] failed=[<<"redshift.z_residual">>] unavailable=[<<"redshift.sigma_residual">>]
  rev scripted-rev-S1 latch=CANDIDATE passed=[<<"agda.kernel">>,
                                              <<"futhark.diff">>,
                                              <<"hamiltonian.suite">>,
                                              <<"ingest.replay">>,
                                              <<"ledger.abi">>,
                                              <<"license.spdx">>,
                                              <<"qso1.fixture">>,
                                              <<"redshift.z_residual">>,
                                              <<"runner.suite">>] failed=[] unavailable=[]
  rev scripted-rev-S2 latch=BLOCK passed=[] failed=[<<"qso1.fixture">>] unavailable=[]
  stream verify.evidence.measurement last_seq=2
  stream verify.evidence.repair last_seq=3
  stream verify.signal.agda last_seq=1
  stream verify.signal.futhark last_seq=1
  stream verify.signal.hamiltonian last_seq=4
  stream verify.signal.ingest last_seq=1
  stream verify.signal.ledger last_seq=2
  stream verify.signal.license last_seq=1
  stream verify.signal.qso1 last_seq=2
  stream verify.signal.redshift last_seq=1
  stream verify.signal.runner last_seq=1
  events_seen=17

######## OFFLINE PURE FOLD over the whole VERIFY stream (STREAM.MSG.GET, no consumer)
[fold-stream] messages=21 state_hash=5c737a6cc4c297aedeb6041cc393297309777cf4a12debf6af8e80ca2984b95a
  rev 1ed57a4f5b94443c9c224fc9b751ec94a816c1bf latch=BLOCK passed=[] failed=[<<"redshift.z_residual">>] unavailable=[<<"redshift.sigma_residual">>]
  rev scripted-rev-S1 latch=CANDIDATE passed=[<<"agda.kernel">>,
                                              <<"futhark.diff">>,
                                              <<"hamiltonian.suite">>,
                                              <<"ingest.replay">>,
                                              <<"ledger.abi">>,
                                              <<"license.spdx">>,
                                              <<"qso1.fixture">>,
                                              <<"redshift.z_residual">>,
                                              <<"runner.suite">>] failed=[] unavailable=[]
  rev scripted-rev-S2 latch=BLOCK passed=[] failed=[<<"qso1.fixture">>] unavailable=[]
  stream verify.evidence.measurement last_seq=2
  stream verify.evidence.repair last_seq=3
  stream verify.signal.agda last_seq=1
  stream verify.signal.futhark last_seq=1
  stream verify.signal.hamiltonian last_seq=4
  stream verify.signal.ingest last_seq=1
  stream verify.signal.ledger last_seq=2
  stream verify.signal.license last_seq=1
  stream verify.signal.qso1 last_seq=2
  stream verify.signal.redshift last_seq=1
  stream verify.signal.runner last_seq=1
  events_seen=17

######## HASH COMPARISON
after phase1 (pre-kill)            bc12e26b3352acd98a98ada2aecafc1e7de5824779abc2a39331d3b0346abc56
after phase2 (restart #1)          9a48cbb0bd1fde80c14a0a08badbbd2f48378166d05fa3d203402b8a4ed2cbed
after phase3 (crash+redelivery)    5c737a6cc4c297aedeb6041cc393297309777cf4a12debf6af8e80ca2984b95a
cold replay from empty state       5c737a6cc4c297aedeb6041cc393297309777cf4a12debf6af8e80ca2984b95a
offline fold of stream             5c737a6cc4c297aedeb6041cc393297309777cf4a12debf6af8e80ca2984b95a
RESULT: replay state IDENTICAL to live service state

######## OUTPUT STREAM VERIFYOUT (decisions published by the Erlang latch)
out#5 verify.latch.quarantine {"prev_latch":"PENDING","latch":"QUARANTINE","revision":"scripted-rev-S1","cause_event_id":"S1-ledger-unavail","note":"RELEASE_CANDIDATE is not final authorization"}
out#9 verify.latch.blocked {"prev_latch":"PENDING","latch":"BLOCK","revision":"scripted-rev-S1","cause_event_id":"S1-ham-fail","note":"RELEASE_CANDIDATE is not final authorization"}
out#18 verify.latch.blocked {"prev_latch":"PENDING","latch":"BLOCK","revision":"1ed57a4f5b94443c9c224fc9b751ec94a816c1bf","cause_event_id":"octave-redshift.z_residual-1ed57a4f5b94-qso1-fortran-t001-readme-2026-10","note":"RELEASE_CANDIDATE is not final authorization"}
out#21 verify.latch.blocked {"prev_latch":"PENDING","latch":"BLOCK","revision":"scripted-rev-S2","cause_event_id":"S2-qso1-invalid","note":"RELEASE_CANDIDATE is not final authorization"}
out#26 verify.latch.candidate {"prev_latch":"PENDING","latch":"RELEASE_CANDIDATE","revision":"scripted-rev-S1","cause_event_id":"S1-ham-pass-3","note":"RELEASE_CANDIDATE is not final authorization"}
audit messages: 22  latch messages: 5

######## KEY LEAK CHECK
key not present in any log/output file
```

## 3. Octave evidence producer (Octave 9.4.0, NOT MATLAB; verbatim `run/octave_output.txt`)
```
== Octave checks (Octave, NOT MATLAB) ==
PASS      real inputs: r_z = z_meas - z_pub
PASS      real inputs: ratio_measured_only about 10.7
PASS      real inputs: not PASS, open_discrepancy (published sigma unknown)
PASS      real inputs: break-even published sigma consistent
PASS      synthetic: |r|=2 sigma within k=3 -> PASS (any published sigma)
PASS      synthetic: with published sigma 0.004, 0.005/0.00412 < 3 -> PASS
PASS      synthetic: out of tolerance with known published sigma -> FAIL
PASS      missing z_measured -> UNAVAILABLE
PASS      sigma: no reference/tolerance -> UNAVAILABLE
PASS      synthetic sigma: r=1e-5 within 2e-5 -> PASS
PASS      synthetic sigma: r=7e-5 outside 2e-5 -> FAIL
SUMMARY (octave evidence checks, Octave, NOT MATLAB): PASS=11 FAIL=0 UNAVAILABLE=0
== evidence production for revision 1ed57a4f5b94443c9c224fc9b751ec94a816c1bf ==
engine: Octave 9.4.0, NOT MATLAB
r_z status=FAIL disposition=open_discrepancy
  z_measured                   7.0422099999999999
  z_measured_sigma             0.00027
  z_published                  7.0450999999999997
  z_published_sigma            NaN
  k_sigma                      3
  r_z                          -0.0028899999999998371
  ratio_measured_only          10.7037037037031
  tolerance_abs_measured_only  0.00080999999999999996
  break_even_published_sigma   0.00092472218050126097
  ratio_combined               NaN
r_sigma status=UNAVAILABLE disposition=reference_sigma_or_tolerance_not_available
  sigma_computed               0.00027
  sigma_reference              NaN
  sigma_abs_tol                NaN
  r_sigma                      NaN
wrote run/octave_events.ndjson (2 events)
```
Events: `run/octave_events.ndjson`. The z/sigma numbers were COPIED from repo text (provenance in
`data/redshift_inputs.txt`); the Fortran was not re-run here.

Tolerance justification: tolerance = k·σ_measured with k=3 (stated, not tuned): 3×0.00027 = 0.00081.
|r_z| = 0.00289 is 10.70σ of the measured error alone (computed, not assumed). The published
uncertainty is UNKNOWN, so no combined ratio is computed; the 10.7 is an upper bound on significance
only if published σ is small. Break-even published σ at which |r_z| would sit at the k=3 limit
(combined in quadrature) is 0.000925. Verdict: FAIL / open_discrepancy — never PASS. The sigma
residual is UNAVAILABLE (no reference sigma or tolerance exists on disk), so under the critical-UNAVAILABLE
rule it quarantines/holds the revision until a same-check PASS.

## Known limitations (not hidden)
- seen-id set grows unbounded; no snapshot compaction.
- Only repairs are signed. Measurement/signal events are unsigned (anyone able to publish can
  publish PASS/FAIL). Shared-secret HMAC => no signer identity, no non-repudiation (Ed25519 would be better).
- Single service instance assumed; no leader election.
- Rust differential not run (UNAVAILABLE). The user's Rust latch is known to clear with a bare bool
  and never clear unavailable; this prototype does neither.
- MATLAB never run.
