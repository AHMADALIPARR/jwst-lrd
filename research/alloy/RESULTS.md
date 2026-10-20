<!--
Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
-->
# JWST-LRD bounded Alloy 6 model checks: TASK 004, TASK 006, TASK 010

These are **bounded model checks, not proofs**. "UNSAT" means only that the analyzer found no
counterexample (or no instance) within the stated scope and step bound. Machine-checked proofs are
deferred to Agda (TASK 011).

- Tooling: Alloy 6.2.0 (`/workspace/hcalc/alloy/tools/org.alloytools.alloy.dist.jar`) on OpenJDK 21.0.12.1
  (`~/bin/java`), with the JNI **glucose** solver bundled in the jar. Every exec runs under `nice -n 19`,
  one command at a time.
- Runner: `./check.sh`, adapted from `/workspace/hcalc/alloy/check.sh`. It checks that `expectations.tsv`
  matches the `expect N` annotations in every `.als` file, runs each command, and compares the result
  (0 = UNSAT, 1 = SAT). Summary: `logs/alloy-check.txt`. Per-command stdout: `logs/stdout/<module>/<command>.txt`
  (each has a 2-line license/command header, followed by the verbatim analyzer output). Solution files
  go to `logs/solutions/` (git-ignored). The relevant ones are copied, with a license header, into
  `logs/counterexamples/`.
- **Final run (run 2):** started 2026-10-19 22:37:46 PDT. Result: `=== summary: ok=36 fail=0 total_wall=701s ===`
  (`time`: real 11m41.665s, user 12m36.676s). Console copy: `logs/history/run2-console.txt`.
- During run 2, the license header lines (comment lines 2-3) of the three `.als` files were changed from
  `-or-later` to `-only`. Only comments changed and the line count stayed the same, so the checked
  semantics did not change. The check.sh-written header line of the logs from that run was then fixed
  with sed. The analyzer output lines were not touched.

## Results (run 2)

| module | command | scope (and steps) | expected | actual analyzer output (time) | log |
|---|---|---|---|---|---|
| GodelLedger | check EncodingInjective | 5 but 5 int, 4 seq | 0 | UNSAT: no counterexample within scope (`00. check EncodingInjective 0 UNSAT`) (19s) | logs/stdout/GodelLedger/EncodingInjective.txt |
| GodelLedger | check EncodeFacInjective | 5 but 5 int, 4 seq | 0 | UNSAT: no counterexample within scope (`00. check EncodeFacInjective 0 UNSAT`) (22s) | logs/stdout/GodelLedger/EncodeFacInjective.txt |
| GodelLedger | check AppendDeterministic | 5 but 5 int, 4 seq | 0 | UNSAT: no counterexample within scope (`00. check AppendDeterministic 0 UNSAT`) (109s) | logs/stdout/GodelLedger/AppendDeterministic.txt |
| GodelLedger | check AppendExtendsCode | 5 but 5 int, 4 seq | 0 | UNSAT: no counterexample within scope (`00. check AppendExtendsCode 0 UNSAT`) (46s) | logs/stdout/GodelLedger/AppendExtendsCode.txt |
| GodelLedger | check EncoderSound | 5 but 5 int, 4 seq | 0 | UNSAT: no counterexample within scope (`00. check EncoderSound 0 UNSAT`) (8s) | logs/stdout/GodelLedger/EncoderSound.txt |
| GodelLedger | check PrefixVerifies | 5 but 5 int, 4 seq | 0 | UNSAT: no counterexample within scope (`00. check PrefixVerifies 0 UNSAT`) (18s) | logs/stdout/GodelLedger/PrefixVerifies.txt |
| GodelLedger | check CodePrefixVerifies | 5 but 5 int, 4 seq | 0 | UNSAT: no counterexample within scope (`00. check CodePrefixVerifies 0 UNSAT`) (2s) | logs/stdout/GodelLedger/CodePrefixVerifies.txt |
| GodelLedger | check MalformedRejected | 5 but 5 int, 4 seq | 0 | UNSAT: no counterexample within scope (`00. check MalformedRejected 0 UNSAT`) (1s) | logs/stdout/GodelLedger/MalformedRejected.txt |
| GodelLedger | check VerifyCharacterisation | 5 but 5 int, 4 seq | 0 | UNSAT: no counterexample within scope (`00. check VerifyCharacterisation 0 UNSAT`) (1s) | logs/stdout/GodelLedger/VerifyCharacterisation.txt |
| GodelLedger | check EncodingInjective_s6 | 6 but 5 int, 5 seq | 0 | UNSAT: no counterexample within scope (`00. check EncodingInjective_s6 0 UNSAT`) (33s) | logs/stdout/GodelLedger/EncodingInjective_s6.txt |
| GodelLedger | check MalformedRejected_s6 | 6 but 5 int, 5 seq | 0 | UNSAT: no counterexample within scope (`00. check MalformedRejected_s6 0 UNSAT`) (2s) | logs/stdout/GodelLedger/MalformedRejected_s6.txt |
| GodelLedger | check MalformedRejected_BROKEN | 5 but 5 int, 4 seq | 1 | SAT: counterexample found (`00. check MalformedRejected_BROKEN 0 1/1 SAT`) (1s) | logs/stdout/GodelLedger/MalformedRejected_BROKEN.txt |
| GodelLedger | run vacuity_GodelLedger | 5 but 5 int, 4 seq | 1 | SAT: instance found (`00. run vacuity_GodelLedger 0 1/1 SAT`) (1s) | logs/stdout/GodelLedger/vacuity_GodelLedger.txt |
| CapabilityAddressing | check NoForgedOrRolledBackAccepted | 4 but 5 int 1..10 steps | 0 | UNSAT: no counterexample within scope (`00. check NoForgedOrRolledBackAccepted 0 UNSAT`) (96s) | logs/stdout/CapabilityAddressing/NoForgedOrRolledBackAccepted.txt |
| CapabilityAddressing | check ReplayedNonceRejected | 4 but 5 int 1..10 steps | 0 | UNSAT: no counterexample within scope (`00. check ReplayedNonceRejected 0 UNSAT`) (3s) | logs/stdout/CapabilityAddressing/ReplayedNonceRejected.txt |
| CapabilityAddressing | check NoMessageAcceptedTwice | 4 but 5 int 1..10 steps | 0 | UNSAT: no counterexample within scope (`00. check NoMessageAcceptedTwice 0 UNSAT`) (15s) | logs/stdout/CapabilityAddressing/NoMessageAcceptedTwice.txt |
| CapabilityAddressing | check RetiredCapabilityRejected | 4 but 5 int 1..10 steps | 0 | UNSAT: no counterexample within scope (`00. check RetiredCapabilityRejected 0 UNSAT`) (2s) | logs/stdout/CapabilityAddressing/RetiredCapabilityRejected.txt |
| CapabilityAddressing | check CounterMonotonic | 4 but 5 int 1..10 steps | 0 | UNSAT: no counterexample within scope (`00. check CounterMonotonic 0 UNSAT`) (23s) | logs/stdout/CapabilityAddressing/CounterMonotonic.txt |
| CapabilityAddressing | check CounterDominatesAccepted | 4 but 5 int 1..10 steps | 0 | UNSAT: no counterexample within scope (`00. check CounterDominatesAccepted 0 UNSAT`) (51s) | logs/stdout/CapabilityAddressing/CounterDominatesAccepted.txt |
| CapabilityAddressing | check WorkerCannotWriteCounter | 4 but 5 int 1..10 steps | 0 | UNSAT: no counterexample within scope (`00. check WorkerCannotWriteCounter 0 UNSAT`) (3s) | logs/stdout/CapabilityAddressing/WorkerCannotWriteCounter.txt |
| CapabilityAddressing | check NoForgedOrRolledBackAccepted_s5 | 5 but 5 int 1..14 steps | 0 | UNSAT: no counterexample within scope (`00. check NoForgedOrRolledBackAccepted_s5 0 UNSAT`) (230s) | logs/stdout/CapabilityAddressing/NoForgedOrRolledBackAccepted_s5.txt |
| CapabilityAddressing | check NoForgedOrRolledBackAccepted_BROKEN | 4 but 5 int 1..10 steps | 1 | SAT: counterexample found (`00. check NoForgedOrRolledBackAccepted_BROKEN 0 1/1 SAT`) (1s) | logs/stdout/CapabilityAddressing/NoForgedOrRolledBackAccepted_BROKEN.txt |
| CapabilityAddressing | check CounterMonotonic_BROKEN | 4 but 5 int 1..10 steps | 1 | SAT: counterexample found (`00. check CounterMonotonic_BROKEN 0 1/1 SAT`) (2s) | logs/stdout/CapabilityAddressing/CounterMonotonic_BROKEN.txt |
| CapabilityAddressing | run vacuity_CapabilityAddressing | 4 but 5 int 1..10 steps | 1 | SAT: instance found (`00. run vacuity_CapabilityAddressing 0 1/1 SAT`) (1s) | logs/stdout/CapabilityAddressing/vacuity_CapabilityAddressing.txt |
| CapabilityAddressing | run scenario_rollback_rejected | 4 but 5 int 1..10 steps | 1 | SAT: instance found (`00. run scenario_rollback_rejected 0 1/1 SAT`) (1s) | logs/stdout/CapabilityAddressing/scenario_rollback_rejected.txt |
| CausalPoset | check NoCausalityFromTimestampsAlone | 6 but 5 int | 0 | UNSAT: no counterexample within scope (`00. check NoCausalityFromTimestampsAlone 0 UNSAT`) (1s) | logs/stdout/CausalPoset/NoCausalityFromTimestampsAlone.txt |
| CausalPoset | check PrecRequiresValidConeRelation | 6 but 5 int | 0 | UNSAT: no counterexample within scope (`00. check PrecRequiresValidConeRelation 0 UNSAT`) (0s) | logs/stdout/CausalPoset/PrecRequiresValidConeRelation.txt |
| CausalPoset | check PrecIrreflexive | 6 but 5 int | 0 | UNSAT: no counterexample within scope (`00. check PrecIrreflexive 0 UNSAT`) (1s) | logs/stdout/CausalPoset/PrecIrreflexive.txt |
| CausalPoset | check PrecTransitive | 6 but 5 int | 0 | UNSAT: no counterexample within scope (`00. check PrecTransitive 0 UNSAT`) (2s) | logs/stdout/CausalPoset/PrecTransitive.txt |
| CausalPoset | check PrecAntisymmetric | 6 but 5 int | 0 | UNSAT: no counterexample within scope (`00. check PrecAntisymmetric 0 UNSAT`) (1s) | logs/stdout/CausalPoset/PrecAntisymmetric.txt |
| CausalPoset | check PrecAcyclic | 6 but 5 int | 0 | UNSAT: no counterexample within scope (`00. check PrecAcyclic 0 UNSAT`) (0s) | logs/stdout/CausalPoset/PrecAcyclic.txt |
| CausalPoset | check KindChainConsistent | 6 but 5 int | 0 | UNSAT: no counterexample within scope (`00. check KindChainConsistent 0 UNSAT`) (1s) | logs/stdout/CausalPoset/KindChainConsistent.txt |
| CausalPoset | check ChainEventsInValidFrames | 6 but 5 int | 0 | UNSAT: no counterexample within scope (`00. check ChainEventsInValidFrames 0 UNSAT`) (1s) | logs/stdout/CausalPoset/ChainEventsInValidFrames.txt |
| CausalPoset | check NoCausalityFromTimestampsAlone_s8 | 8 but 5 int | 0 | UNSAT: no counterexample within scope (`00. check NoCausalityFromTimestampsAlone_s8 0 UNSAT`) (1s) | logs/stdout/CausalPoset/NoCausalityFromTimestampsAlone_s8.txt |
| CausalPoset | check NoCausalityFromTimestampsAlone_BROKEN | 6 but 5 int | 1 | SAT: counterexample found (`00. check NoCausalityFromTimestampsAlone_BROKEN 0 1/1 SAT`) (1s) | logs/stdout/CausalPoset/NoCausalityFromTimestampsAlone_BROKEN.txt |
| CausalPoset | run vacuity_CausalPoset | 8 but 5 int | 1 | SAT: instance found (`00. run vacuity_CausalPoset 0 1/1 SAT`) (0s) | logs/stdout/CausalPoset/vacuity_CausalPoset.txt |

`int` in the scope column is Alloy's Int bitwidth: 5 means the range -16..15. `N seq` is the maximum
sequence length.

## Counterexamples

### Unexpected (run 1), model fixed
- **GodelLedger `AppendExtendsCode`**, scope 5 but 5 int, 4 seq, solver sat4j. Output:
  `00. check AppendExtendsCode 0 1/1 SAT expects=0`. In the counterexample, `Ledger$2` has 4 entries,
  which is the seq bound, and `append[Ledger$2, Symbol$0, Ledger$2]` held. Alloy's `seq` `add`
  silently truncates at the bound, so the first `append` predicate (`l2.entries = l.entries.add[x]`)
  did not require the ledger to grow. **The model was wrong, not the property.** Fix: `append` now also
  requires `#l2.entries = plus[#l.entries, 1]`, and appending to a full ledger is undefined
  (assumption A11). The change is documented inline in `GodelLedger.als`. After the fix, run 2 gives UNSAT.
  The original evidence is kept in `logs/history/run1-AppendExtendsCode-counterexample/` and
  `logs/history/run1-alloy-check-sat4j-aborted.txt`. Run 1 was stopped by hand during the first
  CapabilityAddressing check, which ran for more than 7 minutes under sat4j. The suite then moved to glucose.

### Expected (deliberately broken variants, run 2)
- **GodelLedger `MalformedRejected_BROKEN`** (the verifier has no exponent/alphabet check): SAT.
  `Code$2` = {p_0^0, p_1^14, p_2^-16, p_3^5}, so it has a zero exponent (malformed per A9) and a negative
  one, and `verifyBroken` accepts it.
  File: `logs/counterexamples/GodelLedger.MalformedRejected_BROKEN.txt`.
- **CapabilityAddressing `NoForgedOrRolledBackAccepted_BROKEN`** (the verifier trusts the worker's
  `wseq` instead of the external counter): SAT, 4-state trace.
  - State 0→1: `Msg$3` (seq 7) is accepted, so Counter = 7.
  - State 1→2: `Msg$2` (seq 7, fresh nonce, prev = head) is also accepted, because the worker reports
    `wseq = 5` < 7.
  - A seqId that is not above an already-accepted seqId (a rollback/duplicate position) is accepted.
  - File: `logs/counterexamples/CapabilityAddressing.NoForgedOrRolledBackAccepted_BROKEN.txt`.
- **CapabilityAddressing `CounterMonotonic_BROKEN`**: SAT. `Msg$1` (seq 14) is accepted, then `Msg$0`
  (seq 6) is accepted with worker `wseq = -14`. The authoritative counter goes 0 → 14 → 6, so it decreases.
  File: `logs/counterexamples/CapabilityAddressing.CounterMonotonic_BROKEN.txt`.
- **CausalPoset `NoCausalityFromTimestampsAlone_BROKEN`** (precedence also derived from `ts` order):
  SAT. Two spacelike `Emission`s with ts 14 < 15 become "causally ordered".
  File: `logs/counterexamples/CausalPoset.NoCausalityFromTimestampsAlone_BROKEN.txt`.

Vacuity and scenario instances are in `logs/counterexamples/*.vacuity_*.txt` and
`logs/counterexamples/CapabilityAddressing.scenario_rollback_rejected.txt`.

## Assumptions and GAPs per module
Every assumption is also stated as a commented fact or predicate in the `.als` file.

### GodelLedger.als (TASK 004)
- Arithmetic abstraction: a Godel number is represented by its factorisation `fac: Base -> lone Int`.
  It is never multiplied out, because a 5-bit Int would overflow. Primality is not computed: primes are
  abstract atoms with a table index.
- A1: `Prime` atoms are the prime table p_0..p_{k-1}.
- A2: `NonPrime` atoms stand for non-prime bases.
- A3: symbol code = exponent.
- A4: the prime table is indexed injectively and contiguously from 0.
- A5: symbol codes are >= 1 and injective.
- A6: canonical codes (abstracted fundamental theorem of arithmetic).
- A7: the prime table is large enough for every ledger in scope.
- A8: a ledger's code is the encoding of its entries.
- A9: malformed = non-contiguous prime index, OR a zero exponent, OR a non-prime base (the task's
  definition, taken literally).
- A10: the empty ledger (G = 1) verifies.
- A11: append to a full ledger is undefined.
- GAP G1: the maximum ledger length, or an unbounded prime source, is not specified.
- GAP G2: it is not specified whether negative exponents, or exponents that are not a known symbol
  code, count as "malformed". They are outside `malformed`, but `verify` rejects them (checked by
  `VerifyCharacterisation`).

### CapabilityAddressing.als (TASK 010)
- Arithmetic: seqIds and the counter are only compared, never incremented, so there is no overflow.
  The bitwidth bounds the counter range.
- A1: perfect authentication oracle (`Genuine`); every other message is forged.
- A2: seqIds are >= 1.
- A3: a fixed genesis commitment.
- A4: the authoritative counter is a separate `Counter` sig outside the worker. Only acceptance writes
  it, and `WorkerCannotWriteCounter` checks the frame conditions.
- A5: acceptance requires all of: genuine, live capability, fresh nonce, prev = head, and
  seqId > authoritative counter.
- A6: retirement is permanent.
- GAP G1: counter wrap-around or exhaustion is not specified.
- GAP G2: the MAC/signature scheme and the capability key binding are not specified. Cryptographic
  soundness is assumed, not modelled.
- GAP G3: it is not specified whether seqId must be exactly counter+1 or merely greater.
  CONTRACTS.md LRD-STATE-v1 says proposals use `seq = prev seq + 1`, but does not say that the external
  counter is that same seq. The weaker "greater" is modelled. The argument that the safety results
  transfer to "+1" is not machine-checked.
- GAP G4: "rolled-back state" is read as "seqId not above an already-accepted seqId". Re-use of an
  earlier commitment value under a higher seqId is not treated as rollback.

### CausalPoset.als (TASK 006)
- Abstraction: no coordinates or metric are modelled. The interval classes are given relations, and
  timestamps are only compared.
- A1: a frame is either valid or not.
- A2: every ordered pair of distinct events has exactly one class (tl/ll directed; spacelike,
  ambiguous and invalid-frame symmetric).
- A3: invalid-frame holds iff some event's frame is not valid.
- A4: one common coordinate time, and a future-pointing tl/ll pair implies ts increases. The converse
  is not assumed.
- A5: cone transitivity.
- A6: kind chain:
  - Emission →ll Detection
  - Detection →(tl or ll) GroundReceipt
  - GroundReceipt →tl ArchivePublication
- A7: nothing precedes an Emission.
- GAP G1: how light-cone membership is computed is not specified (metric, FLRW null geodesics, error
  bars, observer frame).
- GAP G2: transformations between different valid frames are not specified.
- GAP G3: the time scale (TDB/TCB/UTC, light-travel corrections) is not specified.
- GAP G4: which relation links each pair of consecutive kinds is not specified.
- GAP G5: whether backward-kind precedence across campaigns (for example Archive → a later Detection)
  is forbidden is not specified. The model allows it.
