-- Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
-- Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
-- SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
--
-- JWST-LRD Sovereign Scientific Runtime -- TASK 006: causal poset of observation events.
-- BOUNDED MODEL CHECK (Alloy 6.2.0), NOT A PROOF. Results hold only within the stated scopes.
-- Machine-checked proofs are deferred to Agda (TASK 011).
--
-- ABSTRACTION: no spacetime coordinates or metric are computed. The interval class of each pair of
-- events (timelike / lightlike / spacelike / ambiguous / invalid-frame) is GIVEN as relations.
-- GAP G1: TASK 006 does not specify how light-cone membership is computed (metric, FLRW null
-- geodesics for the LRD emission, measurement error bars, which observer frame). Here it is an input
-- classification constrained only by the facts below.
-- Timestamps are Alloy Ints (bitwidth 5: -16..15) and are only compared, never added.
module CausalPoset

-- ===================================================================== signatures
sig Frame {}
-- ASSUMPTION A1: a frame is either valid (a usable, declared reference frame) or not.
sig ValidFrame in Frame {}

abstract sig Event { ts: one Int, frame: one Frame }
sig Emission, Detection, GroundReceipt, ArchivePublication extends Event {}

-- Interval classification. tl, ll are DIRECTED (a->b: b is in the future cone of a);
-- sl, amb, inv are symmetric.
one sig Geo {
  tl:  Event -> Event,   -- timelike, future-pointing
  ll:  Event -> Event,   -- lightlike (null), future-pointing
  sl:  Event -> Event,   -- spacelike
  amb: Event -> Event,   -- ambiguous (e.g. within error bars of the cone boundary)
  inv: Event -> Event    -- invalid-frame (classification impossible)
}

-- Causal precedence: transitive closure of the valid-frame cone relations ONLY. Timestamps do not
-- appear in this definition at all.
fun prec: Event -> Event { ^(Geo.tl + Geo.ll) }

-- Deliberately BROKEN precedence: also derives causality from timestamp order.
fun precBroken: Event -> Event { prec + { a, b: Event | a.ts < b.ts } }

-- ===================================================================== facts (assumptions)
-- ASSUMPTION A2: every ordered pair of distinct events has exactly one classification
-- (a tl b, b tl a, a ll b, b ll a, spacelike, ambiguous, invalid-frame); no self-classification.
fact Partition {
  let T = Geo.tl + ~(Geo.tl), L = Geo.ll + ~(Geo.ll) {
    no iden & (T + L + Geo.sl + Geo.amb + Geo.inv)
    no Geo.tl & ~(Geo.tl)
    no Geo.ll & ~(Geo.ll)
    Geo.sl = ~(Geo.sl)
    Geo.amb = ~(Geo.amb)
    Geo.inv = ~(Geo.inv)

    no T & L
    no T & Geo.sl
    no T & Geo.amb
    no T & Geo.inv

    no L & Geo.sl
    no L & Geo.amb
    no L & Geo.inv

    no Geo.sl & Geo.amb
    no Geo.sl & Geo.inv
    no Geo.amb & Geo.inv
    (Event -> Event) - iden = T + L + Geo.sl + Geo.amb + Geo.inv
  }
}

-- ASSUMPTION A3: a pair is invalid-frame iff at least one event's frame is not valid.
-- GAP G2: cross-frame transformations between two DIFFERENT valid frames are not specified; two
-- events in different valid frames are treated as comparable (as if a common frame were known).
fact InvalidFrameDef {
  all a, b: Event | a != b implies
    (a -> b in Geo.inv iff (a.frame not in ValidFrame or b.frame not in ValidFrame))
}

-- ASSUMPTION A4 (time orientation): timestamps are in ONE common coordinate time (GAP G3: which time
-- scale -- TDB/TCB/UTC, light-travel corrections -- is not specified), and a future-pointing
-- timelike/lightlike pair has strictly increasing timestamp. (Only this direction: ordered
-- timestamps do NOT imply a cone relation.)
fact TimeOrientation { all a, b: Event | a -> b in Geo.tl + Geo.ll implies a.ts < b.ts }

-- ASSUMPTION A5 (cone transitivity): if b is in the causal future of a and c in that of b, then c is
-- in the causal future of a (true in Minkowski space; tl.tl, tl.ll, ll.tl give tl, ll.ll gives tl or ll).
fact ConeTransitive { (Geo.tl + Geo.ll).(Geo.tl + Geo.ll) in Geo.tl + Geo.ll }

-- ASSUMPTION A6 (kind chain). GAP G4: TASK 006 names the kinds but not which relation links each
-- consecutive pair; the following is assumed:
--   every Detection is lightlike-reached from some Emission (photons travel on null rays);
--   every GroundReceipt is causally after some Detection (downlink: tl or ll);
--   every ArchivePublication is timelike-after some GroundReceipt (processing takes proper time).
fact KindChain {
  all d: Detection          | some e: Emission      | e -> d in Geo.ll
  all g: GroundReceipt      | some d: Detection     | d -> g in Geo.tl + Geo.ll
  all p: ArchivePublication | some g: GroundReceipt | g -> p in Geo.tl
}
-- ASSUMPTION A7: no modelled event causally precedes an Emission (the LRD emission is a source
-- event far in the past of every observatory event). GAP G5: the model still ALLOWS backward-kind
-- precedence among non-Emission events (e.g. an ArchivePublication preceding a later campaign's
-- Detection); the task does not say whether such cross-campaign edges are forbidden.
fact EmissionIsSource { no prec.Emission }

-- ===================================================================== assertions
-- MAIN INVARIANT: causality is never derived from timestamp order alone. Ordered timestamps with a
-- spacelike, ambiguous or invalid-frame relation do NOT give causal precedence.
assert NoCausalityFromTimestampsAlone {
  all a, b: Event | (a.ts < b.ts and a -> b in Geo.sl + Geo.amb + Geo.inv) implies a -> b not in prec
}
-- Causal precedence requires a timelike or lightlike relation between events in valid frames.
assert PrecRequiresValidConeRelation {
  all a, b: Event | a -> b in prec implies
    (a -> b in Geo.tl + Geo.ll and a.frame in ValidFrame and b.frame in ValidFrame)
}
-- Strict partial order.
assert PrecIrreflexive  { no iden & prec }
assert PrecTransitive   { prec.prec in prec }
assert PrecAntisymmetric { no prec & ~prec }
assert PrecAcyclic      { all e: Event | e not in e.^prec }
-- Expected kind chain is consistent: every ArchivePublication has a full chain
-- Emission -> Detection -> GroundReceipt -> ArchivePublication in causal order with increasing ts.
assert KindChainConsistent {
  all p: ArchivePublication | some e: Emission, d: Detection, g: GroundReceipt |
    e -> d in prec and d -> g in prec and g -> p in prec and
    e.ts < d.ts and d.ts < g.ts and g.ts < p.ts
}
-- All chain events downstream of Emission sit in valid frames.
assert ChainEventsInValidFrames {
  (Detection + GroundReceipt + ArchivePublication).frame in ValidFrame
}
-- BROKEN variant: with timestamp-derived precedence the main invariant FAILS (expected).
assert NoCausalityFromTimestampsAlone_BROKEN {
  all a, b: Event | (a.ts < b.ts and a -> b in Geo.sl + Geo.amb + Geo.inv) implies a -> b not in precBroken
}

-- ===================================================================== commands
-- Scope: 6 atoms per sig (Event total <= 6, Frame <= 6), Int bitwidth 5.
check NoCausalityFromTimestampsAlone for 6 but 5 Int expect 0
check PrecRequiresValidConeRelation  for 6 but 5 Int expect 0
check PrecIrreflexive                for 6 but 5 Int expect 0
check PrecTransitive                 for 6 but 5 Int expect 0
check PrecAntisymmetric              for 6 but 5 Int expect 0
check PrecAcyclic                    for 6 but 5 Int expect 0
check KindChainConsistent            for 6 but 5 Int expect 0
check ChainEventsInValidFrames       for 6 but 5 Int expect 0
-- Larger repeat of the main invariant.
check NoCausalityFromTimestampsAlone_s8 {
  all a, b: Event | (a.ts < b.ts and a -> b in Geo.sl + Geo.amb + Geo.inv) implies a -> b not in prec
} for 8 but 5 Int expect 0
-- Broken variant: counterexample EXPECTED.
check NoCausalityFromTimestampsAlone_BROKEN for 6 but 5 Int expect 1

-- Vacuity: all four kinds present, a full chain exists, and timestamp-ordered spacelike, ambiguous
-- and invalid-frame pairs all occur (so the main invariant is not vacuously true).
run vacuity_CausalPoset {
  some ArchivePublication
  some Geo.tl
  some Geo.ll
  some a, b: Event | a.ts < b.ts and a -> b in Geo.sl
  some a, b: Event | a.ts < b.ts and a -> b in Geo.amb
  some a, b: Event | a.ts < b.ts and a -> b in Geo.inv
} for 8 but 5 Int expect 1
