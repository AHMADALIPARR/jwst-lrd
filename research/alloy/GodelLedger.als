-- Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
-- Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
-- SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
--
-- JWST-LRD Sovereign Scientific Runtime -- TASK 004: Godel prime ledger.
-- BOUNDED MODEL CHECK (Alloy 6.2.0), NOT A PROOF. Results hold only within the stated scopes.
-- Machine-checked proofs are deferred to Agda (TASK 011).
--
-- ARITHMETIC ABSTRACTION (explicit): a Godel code G = prod_i p_i ^ e_i is never computed as an
-- integer -- with Alloy's two's-complement Int bitwidth (5 bits here: -16..15) the product would
-- overflow immediately. Instead a code is represented RELATIONALLY by its factorisation
-- `fac : Base -> lone Int` (base -> exponent). Primes are abstract atoms carrying their index i
-- in the prime table (p_0 = 2, p_1 = 3, ...); primality itself is not computed.
-- Only exponents, prime indices and sequence positions are Ints, and all stay inside -16..15.
module GodelLedger

-- ===================================================================== signatures
abstract sig Base {}
-- ASSUMPTION A1: `Prime` atoms are exactly the prime table p_0..p_{k-1}; `idx` is the table index.
sig Prime extends Base { idx: one Int }
-- ASSUMPTION A2: `NonPrime` atoms stand for any base that is not prime (1, 4, 6, ...). They exist
-- only so that malformed codes with a non-prime base are representable.
sig NonPrime extends Base {}

-- ASSUMPTION A3: ledger symbols have integer codes; code = the exponent written on the prime.
sig Symbol { sym: one Int }

-- An abstract Godel number, represented by its factorisation (see ARITHMETIC ABSTRACTION).
sig Code { fac: Base -> lone Int }

-- A ledger: a finite sequence of symbols plus its code.
sig Ledger { entries: seq Symbol, code: one Code }

-- ===================================================================== facts (assumptions)
-- ASSUMPTION A4: the prime table is indexed injectively and contiguously from 0 (p_0, p_1, ...).
fact PrimeTable {
  all p: Prime | p.idx >= 0
  all disj p, q: Prime | p.idx != q.idx
  all p: Prime, i: Int | (0 <= i and i < p.idx) implies some q: Prime | q.idx = i
}

-- ASSUMPTION A5: symbol codes are >= 1 (so an exponent 0 never encodes a symbol) and the
-- symbol -> code map is injective (distinct symbols have distinct codes).
fact SymbolAlphabet {
  all s: Symbol | s.sym >= 1
  all disj a, b: Symbol | a.sym != b.sym
}

-- ASSUMPTION A6 (fundamental theorem of arithmetic, abstracted): a natural number is determined by
-- its factorisation, so two distinct Code atoms never have the same factorisation.
fact CanonicalCodes { all disj c, d: Code | c.fac != d.fac }

-- Encoding: position i of the sequence goes to prime p_i with exponent = code of the symbol at i.
fun encodeFac[s: Int -> Symbol]: Prime -> Int {
  { p: Prime, e: Int | p.idx in s.inds and e = (s[p.idx]).sym }
}

-- ASSUMPTION A7: the prime table in scope is large enough for every ledger in scope
-- (each position of each ledger has a prime). GAP G1: the real runtime must fix a maximum ledger
-- length or an unbounded prime source; that bound is not specified in TASK 004.
fact PrimeTableLargeEnough { all l: Ledger, i: l.entries.inds | some p: Prime | p.idx = i }

-- ASSUMPTION A8: a ledger's stored code is exactly the encoding of its entries.
fact LedgerCodeIsEncoding { all l: Ledger | l.code.fac = encodeFac[l.entries] }

-- ===================================================================== operations
-- The set of bases with an exponent in code c.
fun bases[c: Code]: set Base { c.fac.Int }
fun exps[c: Code]: set Int { Base.(c.fac) }

-- MALFORMED (ASSUMPTION A9, the task's definition taken literally): a code is malformed iff
--   (a) a non-contiguous prime index: some p_j is used while some p_i, i < j, is absent; or
--   (b) a zero exponent; or
--   (c) a non-prime base.
-- GAP G2: TASK 004 does not say whether negative exponents or exponents that are not the code of any
-- known symbol are "malformed". Here they are NOT in `malformed`, but `verify` rejects them anyway
-- (see check VerifyCharacterisation).
pred nonContiguous[c: Code] {
  some p: bases[c] & Prime, q: Prime | q.idx < p.idx and q not in bases[c]
}
pred zeroExponent[c: Code] { 0 in exps[c] }
pred nonPrimeBase[c: Code] { some bases[c] & NonPrime }
pred malformed[c: Code] { nonContiguous[c] or zeroExponent[c] or nonPrimeBase[c] }

-- VERIFY (sequence verification / decoder acceptance). Deliberately formulated differently from
-- `malformed`: all bases are primes, every used prime index is < the number of used bases
-- (pigeonhole => indices are exactly 0..n-1), and every exponent decodes to a known symbol.
-- ASSUMPTION A10: the empty ledger (code with no factors, i.e. G = 1) verifies.
pred verify[c: Code] {
  bases[c] in Prime
  all p: bases[c] | p.idx < #bases[c]
  exps[c] in Symbol.sym
}

-- Deliberately BROKEN verifier: forgets the exponent/alphabet check.
pred verifyBroken[c: Code] {
  bases[c] in Prime
  all p: bases[c] | p.idx < #bases[c]
}

-- APPEND: l2 is l with x appended at position #l.entries.
-- MODEL FIX (run 1, 2026-10-19): the first version was `l2.entries = l.entries.add[x]` only. Alloy's
-- `add` silently TRUNCATES at the seq bound, so for a full ledger (#entries = maxseq) it returned the
-- ledger unchanged and append[l, x, l] held; check AppendExtendsCode found that counterexample
-- (logs/history/run1-AppendExtendsCode-counterexample/). The model, not the property, was wrong:
-- append must grow the ledger by exactly one entry. ASSUMPTION A11: append on a ledger already at
-- the maximum length is undefined (no result ledger), cf. GAP G1.
pred append[l: Ledger, x: Symbol, l2: Ledger] {
  l2.entries = l.entries.add[x]
  #l2.entries = plus[#l.entries, 1]
}

-- PREFIX (ledger level): p's entries are an initial segment of l's entries.
pred prefix[p, l: Ledger] {
  #p.entries <= #l.entries
  all i: p.entries.inds | p.entries[i] = l.entries[i]
}

-- PREFIX (code level): c2 is c restricted to the primes with index < k.
pred codePrefix[c2, c: Code, k: Int] {
  k >= 0
  c2.fac = { p: Prime, e: Int | p -> e in c.fac and p.idx < k }
}

-- ===================================================================== assertions
-- Encoding is injective: distinct sequences give distinct codes.
assert EncodingInjective {
  all a, b: Ledger | a.code = b.code implies a.entries = b.entries
}
-- Same at the level of the encoding function itself (independent of Code atoms).
assert EncodeFacInjective {
  all a, b: Ledger | encodeFac[a.entries] = encodeFac[b.entries] implies a.entries = b.entries
}
-- Append is deterministic (same ledger + same symbol => same result and same code).
assert AppendDeterministic {
  all l, a, b: Ledger, x: Symbol |
    (append[l, x, a] and append[l, x, b]) implies (a.entries = b.entries and a.code = b.code)
}
-- Append extends the code by exactly one factor p_n ^ code(x), n = old length.
assert AppendExtendsCode {
  all l, a: Ledger, x: Symbol | append[l, x, a] implies
    a.code.fac = l.code.fac + { p: Prime, e: Int | p.idx = #l.entries and e = x.sym }
}
-- Every ledger's code verifies (encoder soundness).
assert EncoderSound { all l: Ledger | verify[l.code] }
-- A prefix of a valid ledger verifies (ledger level).
assert PrefixVerifies {
  all p, l: Ledger | (verify[l.code] and prefix[p, l]) implies verify[p.code]
}
-- A prefix of a valid code verifies (code level, no Ledger needed).
assert CodePrefixVerifies {
  all c, c2: Code, k: Int | (verify[c] and codePrefix[c2, c, k]) implies verify[c2]
}
-- Malformed encodings are rejected.
assert MalformedRejected { all c: Code | malformed[c] implies not verify[c] }
-- Exact characterisation: verify <=> not malformed and every exponent is a known symbol code.
assert VerifyCharacterisation {
  all c: Code | verify[c] iff (not malformed[c] and exps[c] in Symbol.sym)
}
-- BROKEN variant: with the exponent check removed, malformed codes CAN be accepted.
assert MalformedRejected_BROKEN { all c: Code | malformed[c] implies not verifyBroken[c] }

-- ===================================================================== commands
-- Scope: 5 atoms per top-level sig, Int bitwidth 5 (-16..15), sequences of length <= 4.
check EncodingInjective        for 5 but 5 Int, 4 seq expect 0
check EncodeFacInjective       for 5 but 5 Int, 4 seq expect 0
check AppendDeterministic      for 5 but 5 Int, 4 seq expect 0
check AppendExtendsCode        for 5 but 5 Int, 4 seq expect 0
check EncoderSound             for 5 but 5 Int, 4 seq expect 0
check PrefixVerifies           for 5 but 5 Int, 4 seq expect 0
check CodePrefixVerifies       for 5 but 5 Int, 4 seq expect 0
check MalformedRejected        for 5 but 5 Int, 4 seq expect 0
check VerifyCharacterisation   for 5 but 5 Int, 4 seq expect 0
-- Larger scope repeat of the two headline properties.
check EncodingInjective_s6 { all a, b: Ledger | a.code = b.code implies a.entries = b.entries }
  for 6 but 5 Int, 5 seq expect 0
check MalformedRejected_s6 { all c: Code | malformed[c] implies not verify[c] }
  for 6 but 5 Int, 5 seq expect 0
-- Broken variant: a counterexample is EXPECTED.
check MalformedRejected_BROKEN for 5 but 5 Int, 4 seq expect 1

-- Vacuity: facts are satisfiable with non-empty key relations (ledgers with >= 2 entries,
-- an append step, a prefix pair, at least one malformed and one valid non-empty code).
run vacuity_GodelLedger {
  some l: Ledger | #l.entries >= 2
  some l, a: Ledger, x: Symbol | append[l, x, a] and some l.entries
  some disj p, l: Ledger | prefix[p, l] and some p.entries
  some c: Code | malformed[c]
  some c: Code | verify[c] and some c.fac
  some c: Code | zeroExponent[c]
  some c: Code | nonPrimeBase[c]
  some c: Code | nonContiguous[c]
} for 5 but 5 Int, 4 seq expect 1
