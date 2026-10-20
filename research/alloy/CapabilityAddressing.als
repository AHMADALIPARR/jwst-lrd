-- Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
-- Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
-- SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
--
-- JWST-LRD Sovereign Scientific Runtime -- TASK 010: capability addressing, replay and rollback
-- detection. Alloy 6 temporal model (var fields); traces are bounded by a `steps` bound.
-- BOUNDED MODEL CHECK (Alloy 6.2.0), NOT A PROOF. Results hold only within the stated scopes and
-- step bounds. Machine-checked proofs are deferred to Agda (TASK 011).
--
-- ARITHMETIC ABSTRACTION: sequence IDs and the counter are Alloy Ints (bitwidth 5: -16..15). The
-- model only COMPARES them (no +1), so no arithmetic overflow can occur; the counter's range is
-- bounded by the bitwidth, which also bounds the number of acceptances. GAP G1: counter wrap-around
-- / exhaustion behaviour of the real monotonic counter is not specified.
module CapabilityAddressing

-- ===================================================================== static signatures
sig Nonce {}
sig Capability {}
-- A state commitment (abstract hash of a worker state).
sig Commitment {}

-- A submission from the (untrusted) worker to the verifier.
sig Msg {
  seqId:  one Int,          -- claimed sequence ID
  nonce:  one Nonce,
  cap:    one Capability,   -- capability the message is addressed/authorised under
  prev:   one Commitment,   -- commitment of the state this update builds on
  commit: one Commitment    -- commitment of the new state
}

-- ASSUMPTION A1 (perfect authentication oracle): `Genuine` is the set of messages whose MAC /
-- signature verifies under `cap`. Everything else is FORGED. The verifier can decide membership.
-- GAP G2: the concrete MAC/signature scheme and key binding of a capability are not specified;
-- cryptographic soundness is assumed, not modelled.
sig Genuine in Msg {}

-- ASSUMPTION A2: sequence IDs on messages are positive.
fact PositiveSeqIds { all m: Msg | m.seqId >= 1 }

-- ASSUMPTION A3: a fixed genesis commitment is the verifier's initial head.
one sig Init { genesis: one Commitment }

-- Configuration switch for the deliberately BROKEN variant (static, chosen per trace).
-- In broken mode the verifier trusts the WORKER's self-reported counter instead of the external one.
lone sig BrokenMode {}

-- ===================================================================== mutable state
-- ASSUMPTION A4: the authoritative monotonic counter lives OUTSIDE the worker (e.g. HSM/TPM).
-- It is a separate sig; no worker transition writes it (enforced by the frame conditions below and
-- checked by WorkerCannotWriteCounter). Only a verifier acceptance advances it.
one sig Counter { var value: one Int }

-- The untrusted worker: it can set its local view to anything, including rolling it back.
one sig Worker {
  var wseq:   one Int,
  var wstate: one Commitment
}

-- The verifier's state.
one sig Verifier {
  var used:     set Nonce,       -- nonces already consumed
  var retired:  set Capability,  -- retired capabilities
  var head:     one Commitment,  -- commitment of the last accepted state
  var accepted: set Msg,         -- history of accepted messages
  var last:     lone Msg         -- message accepted by the transition INTO this state (if any)
}

-- ===================================================================== transitions
pred init {
  Counter.value = 0
  no Verifier.used
  no Verifier.retired
  Verifier.head = Init.genesis
  no Verifier.accepted
  no Verifier.last
}

-- The verifier's acceptance check. ASSUMPTION A5: acceptance requires (i) authenticity,
-- (ii) live capability, (iii) fresh nonce, (iv) chaining from the current head, and
-- (v) seqId strictly greater than the AUTHORITATIVE counter (gaps allowed).
-- GAP G3: TASK 010 does not say whether seqId must be exactly counter+1 or merely greater (research/
-- CONTRACTS.md LRD-STATE-v1 says "seq must be prev seq + 1" for proposals; whether the external
-- counter is that same seq is not stated). The
-- weaker "greater" is modelled. Argument (NOT machine-checked here): a stricter guard admits a subset
-- of transitions, so the safety assertions below transfer to "exactly +1"; the vacuity runs do not.
pred guard[m: Msg] {
  m in Genuine
  m.cap not in Verifier.retired
  m.nonce not in Verifier.used
  m.prev = Verifier.head
  no BrokenMode   implies m.seqId > Counter.value
  some BrokenMode implies m.seqId > Worker.wseq      -- BROKEN: trusts the worker's counter
}

pred workerFrame { Worker.wseq' = Worker.wseq and Worker.wstate' = Worker.wstate }
pred verifierFrame {
  Verifier.used' = Verifier.used
  Verifier.retired' = Verifier.retired
  Verifier.head' = Verifier.head
  Verifier.accepted' = Verifier.accepted
}

pred accept[m: Msg] {
  guard[m]
  Counter.value'      = m.seqId
  Verifier.used'      = Verifier.used + m.nonce
  Verifier.head'      = m.commit
  Verifier.accepted'  = Verifier.accepted + m
  Verifier.retired'   = Verifier.retired
  Verifier.last'      = m
  workerFrame
}

-- Explicit rejection of a submitted message (replay, rollback, forgery, retired cap, bad chain).
pred reject[m: Msg] {
  not guard[m]
  Counter.value' = Counter.value
  verifierFrame
  no Verifier.last'
  workerFrame
}

-- ASSUMPTION A6: retirement is permanent (no un-retire transition exists).
pred retire[c: Capability] {
  Verifier.retired' = Verifier.retired + c
  Counter.value' = Counter.value
  Verifier.used' = Verifier.used
  Verifier.head' = Verifier.head
  Verifier.accepted' = Verifier.accepted
  no Verifier.last'
  workerFrame
}

-- The worker may change (including roll back) its own state arbitrarily, but nothing else.
pred workerStep {
  Counter.value' = Counter.value
  verifierFrame
  no Verifier.last'
}

pred stutter {
  Counter.value' = Counter.value
  verifierFrame
  no Verifier.last'
  workerFrame
}

fact Traces {
  init
  always (
    (some m: Msg | accept[m] or reject[m]) or
    (some c: Capability | retire[c]) or
    workerStep or
    stutter )
}

-- ===================================================================== assertions
-- MAIN: no forged or rolled-back state is ever accepted. Whenever a message m is accepted in the
-- next transition, m is genuine, chains from the current head, and its seqId is strictly greater
-- than the seqId of EVERY previously accepted message (=> no rollback to an earlier position).
-- GAP G4: "rolled-back state" is interpreted as "seqId not above an already-accepted seqId";
-- re-accepting a previously seen commitment value under a fresh higher seqId is NOT treated as
-- rollback (the task does not say whether commitments must be globally unique).
assert NoForgedOrRolledBackAccepted {
  no BrokenMode implies always (all m: Msg | (after (m in Verifier.last)) implies (
      m in Genuine and m.prev = Verifier.head and
      (all m0: Verifier.accepted | m0.seqId < m.seqId)))
}
-- Replayed nonce rejected: once a nonce is used it is never accepted again.
assert ReplayedNonceRejected {
  no BrokenMode implies always (all n: Nonce |
      n in Verifier.used implies after always (n not in Verifier.last.nonce))
}
-- The same message is never accepted twice.
assert NoMessageAcceptedTwice {
  no BrokenMode implies always (all m: Msg |
      m in Verifier.accepted implies after always (m not in Verifier.last))
}
-- Retired capability rejected: after retirement no message under it is ever accepted.
assert RetiredCapabilityRejected {
  no BrokenMode implies always (all c: Capability |
      c in Verifier.retired implies after always (c not in Verifier.last.cap))
}
-- The authoritative counter never decreases.
assert CounterMonotonic {
  no BrokenMode implies always (Counter.value' >= Counter.value)
}
-- Inductive invariant: the counter is at least every accepted seqId.
assert CounterDominatesAccepted {
  no BrokenMode implies always (all m: Verifier.accepted | m.seqId <= Counter.value)
}
-- The worker cannot write the counter: it changes only on a verifier acceptance.
assert WorkerCannotWriteCounter {
  always (Counter.value' != Counter.value implies some Verifier.last')
}

-- BROKEN variants (verifier trusts the worker-reported counter): counterexamples EXPECTED.
assert NoForgedOrRolledBackAccepted_BROKEN {
  some BrokenMode implies always (all m: Msg | (after (m in Verifier.last)) implies (
      m in Genuine and m.prev = Verifier.head and
      (all m0: Verifier.accepted | m0.seqId < m.seqId)))
}
assert CounterMonotonic_BROKEN {
  some BrokenMode implies always (Counter.value' >= Counter.value)
}

-- ===================================================================== commands
-- Scope: 4 atoms per sig (Nonce, Capability, Commitment, Msg), Int bitwidth 5, traces of 1..10 steps.
check NoForgedOrRolledBackAccepted for 4 but 5 Int, 1..10 steps expect 0
check ReplayedNonceRejected        for 4 but 5 Int, 1..10 steps expect 0
check NoMessageAcceptedTwice       for 4 but 5 Int, 1..10 steps expect 0
check RetiredCapabilityRejected    for 4 but 5 Int, 1..10 steps expect 0
check CounterMonotonic             for 4 but 5 Int, 1..10 steps expect 0
check CounterDominatesAccepted     for 4 but 5 Int, 1..10 steps expect 0
check WorkerCannotWriteCounter     for 4 but 5 Int, 1..10 steps expect 0
-- Larger repeat of the main assertion: 5 atoms per sig, traces up to 14 steps.
check NoForgedOrRolledBackAccepted_s5 {
  no BrokenMode implies always (all m: Msg | (after (m in Verifier.last)) implies (
      m in Genuine and m.prev = Verifier.head and
      (all m0: Verifier.accepted | m0.seqId < m.seqId)))
} for 5 but 5 Int, 1..14 steps expect 0
-- Broken variants: counterexamples EXPECTED.
check NoForgedOrRolledBackAccepted_BROKEN for 4 but 5 Int, 1..10 steps expect 1
check CounterMonotonic_BROKEN             for 4 but 5 Int, 1..10 steps expect 1

-- Vacuity: correct-mode traces exist with >= 2 acceptances, a retirement, a worker rollback of its
-- local counter, and a rejected genuine message.
run vacuity_CapabilityAddressing {
  no BrokenMode
  some Genuine
  eventually #Verifier.accepted >= 2
  eventually some Verifier.retired
  eventually (some m: Genuine | reject[m])
  eventually (Worker.wseq' < Worker.wseq)
} for 4 but 5 Int, 1..10 steps expect 1
-- Scenario: the worker rolls its local counter back, then a genuine stale message (fresh nonce,
-- correct chaining, old seqId) is submitted and rejected by the external-counter check.
run scenario_rollback_rejected {
  no BrokenMode
  eventually (Worker.wseq' < Worker.wseq and after (some m: Genuine |
      reject[m] and m.nonce not in Verifier.used and m.cap not in Verifier.retired and
      m.prev = Verifier.head and m.seqId <= Counter.value and m.seqId > Worker.wseq))
} for 4 but 5 Int, 1..10 steps expect 1
