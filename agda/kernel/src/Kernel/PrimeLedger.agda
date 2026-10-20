-- Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
-- JWST-LRD Sovereign Scientific Runtime -- formal verification kernel (Agda).
-- Dual-licensed, intentionally: AGPL-3.0-only AND SnapKitty Opaque License.
-- SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
--
-- Module boundary: VERIFIED CORE (--safe --without-K). No postulates.
--
-- Gödel prime-ledger.  A ledger of entries e₀ … eₙ₋₁ (chronological)
-- is encoded over a *verified finite prime basis* p₀ < p₁ < … as
--     encode [e₀ … eₙ₋₁] = ∏ᵢ pᵢ ^ (eᵢ + 1)
-- (exponent eᵢ+1 so that the length is recoverable and 0 is a legal
-- entry).  The basis is checked by the decidable stdlib predicate
-- `prime?` and a strict-ascent check (smart constructor `mkBasis`).
--
-- Proved here (no assumptions):
--   * decode (encode es) ≡ just es              (decode-encode)
--   * encode is injective                       (encode-injective)
--   * append correctness: the new code is the old code times
--     p_n^(e+1), and still decodes to entries ++ [e]   (append-*)
--   * a rejected append (capacity exhausted) leaves the state unchanged.
-- Scope: exponent lists no longer than the basis.  The proof uses
-- Euclid's lemma (stdlib `euclidsLemma`, itself proved), not full FTA.
{-# OPTIONS --safe --without-K #-}
module Kernel.PrimeLedger where

open import Data.Bool.Base using (if_then_else_)
open import Data.Empty using (⊥-elim)
open import Data.Nat.Base
open import Data.Nat.Properties
open import Data.Nat.DivMod using (m*n/n≡m)
open import Data.Nat.Divisibility using (_∣_; _∣?_; ∣1⇒≡1; m∣m*n)
open import Data.Nat.Primality using (Prime; prime?; euclidsLemma; prime⇒irreducible; prime⇒nonTrivial)
open import Data.List.Base using (List; []; _∷_; _++_; length)
open import Data.List.Properties using (length-++)
open import Data.List.Relation.Unary.All using (All; []; _∷_; all?)
open import Data.Maybe.Base as Maybe using (Maybe; just; nothing)
open import Data.Maybe.Properties using (just-injective)
open import Data.Sum.Base using (inj₁; inj₂)
open import Data.Product.Base using (Σ; _,_)
open import Relation.Nullary using (Dec; yes; no; ¬_)
open import Relation.Binary.PropositionalEquality
open import Kernel.Decision

------------------------------------------------------------------------
-- Verified prime basis

data Asc : List ℕ → Set where
  []  : Asc []
  _∷_ : ∀ {q qs} → All (q <_) qs → Asc qs → Asc (q ∷ qs)

asc? : (qs : List ℕ) → Dec (Asc qs)
asc? [] = yes []
asc? (q ∷ qs) with all? (q <?_) qs | asc? qs
... | yes a | yes s = yes (a ∷ s)
... | no ¬a | _     = no λ { (a ∷ _) → ¬a a }
... | yes _ | no ¬s = no λ { (_ ∷ s) → ¬s s }

record PrimeBasis : Set where
  constructor basis
  field
    primes    : List ℕ
    allPrime  : All Prime primes
    ascending : Asc primes
open PrimeBasis public

mkBasis : List ℕ → Maybe PrimeBasis
mkBasis qs with all? prime? qs | asc? qs
... | yes p | yes a = just (basis qs p a)
... | _     | _     = nothing

capacity : PrimeBasis → ℕ
capacity B = length (primes B)

------------------------------------------------------------------------
-- Encoding

go : List ℕ → List ℕ → ℕ
go _        []       = 1
go []       (_ ∷ _)  = 0
go (q ∷ qs) (e ∷ es) = q ^ suc e * go qs es

encode : PrimeBasis → List ℕ → ℕ
encode B = go (primes B)

nth : List ℕ → ℕ → ℕ
nth []       _       = 1
nth (x ∷ _)  zero    = x
nth (_ ∷ xs) (suc i) = nth xs i

------------------------------------------------------------------------
-- Decoding

divN : ℕ → ℕ → ℕ
divN n zero    = 0
divN n (suc d) = n / suc d

-- p-adic valuation with fuel
val : (fuel q n : ℕ) → ℕ
val zero    q n = 0
val (suc f) q n with q ∣? n
... | yes _ = suc (val f q (divN n q))
... | no  _ = 0

finish : ℕ → Maybe (List ℕ)
finish n = if n ≡ᵇ 1 then just [] else nothing

mutual
  decodeL : List ℕ → ℕ → Maybe (List ℕ)
  decodeL []       n = finish n
  decodeL (q ∷ qs) n = stepD q qs n (val n q n)

  stepD : ℕ → List ℕ → ℕ → ℕ → Maybe (List ℕ)
  stepD q qs n zero    = finish n
  stepD q qs n (suc e) = Maybe.map (e ∷_) (decodeL qs (divN n (q ^ suc e)))

decode : PrimeBasis → ℕ → Maybe (List ℕ)
decode B = decodeL (primes B)

------------------------------------------------------------------------
-- Arithmetic lemmas

divN-cancel : ∀ m d → 1 ≤ d → divN (d * m) d ≡ m
divN-cancel m (suc d) _ rewrite *-comm (suc d) m = m*n/n≡m m (suc d)

pow-pos : ∀ q k → 1 ≤ q → 1 ≤ q ^ k
pow-pos q zero    _ = ≤-refl
pow-pos q (suc k) h = *-mono-≤ h (pow-pos q k h)

pow-gt : ∀ q k → 2 ≤ q → k < q ^ k
pow-gt q zero    _   = s≤s z≤n
pow-gt q (suc k) 2≤q = ≤-trans step (*-monoˡ-≤ (q ^ k) 2≤q)
  where
  ih : suc k ≤ q ^ k
  ih = pow-gt q k 2≤q
  one : 1 ≤ q ^ k + 0
  one = subst (1 ≤_) (sym (+-identityʳ (q ^ k))) (≤-trans (s≤s z≤n) ih)
  step : suc (suc k) ≤ q ^ k + (q ^ k + 0)
  step = subst (_≤ q ^ k + (q ^ k + 0)) (cong suc (+-comm k 1)) (+-mono-≤ ih one)

prime≥2 : ∀ {q} → Prime q → 2 ≤ q
prime≥2 {q} pq = nonTrivial⇒n>1 q ⦃ prime⇒nonTrivial pq ⦄

prime∤1 : ∀ {q} → Prime q → ¬ q ∣ 1
prime∤1 pq d = nonTrivial⇒≢1 ⦃ prime⇒nonTrivial pq ⦄ (∣1⇒≡1 d)

pow-div : ∀ {q r} k → Prime q → q ∣ r ^ k → q ∣ r
pow-div {q} {r} zero    pq d = ⊥-elim (prime∤1 pq d)
pow-div {q} {r} (suc k) pq d with euclidsLemma r (r ^ k) pq d
... | inj₁ q∣r  = q∣r
... | inj₂ q∣rk = pow-div k pq q∣rk

------------------------------------------------------------------------
-- Valuation lemmas

val-zero : ∀ f q m → ¬ q ∣ m → val (suc f) q m ≡ 0
val-zero f q m ¬d with q ∣? m
... | yes d = ⊥-elim (¬d d)
... | no  _ = refl

val-pow : ∀ q k f m → 2 ≤ q → ¬ q ∣ m → k < f → val f q (q ^ k * m) ≡ k
val-pow q zero (suc f) m _ ¬d _ rewrite *-identityˡ m = val-zero f q m ¬d
val-pow q (suc k) (suc f) m 2≤q ¬d (s≤s k<f) with q ∣? (q * q ^ k * m)
... | yes _ = cong suc (trans (cong (val f q) quot) (val-pow q k f m 2≤q ¬d k<f))
  where
  quot : divN (q * q ^ k * m) q ≡ q ^ k * m
  quot = trans (cong (λ x → divN x q) (*-assoc q (q ^ k) m))
               (divN-cancel (q ^ k * m) q (≤-trans (s≤s z≤n) 2≤q))
... | no ¬dd = ⊥-elim (¬dd (subst (q ∣_) (sym (*-assoc q (q ^ k) m)) (m∣m*n (q ^ k * m))))

------------------------------------------------------------------------
-- Structural lemmas on the encoding

go-pos : ∀ {qs es} → All Prime qs → length es ≤ length qs → 1 ≤ go qs es
go-pos {_}      {[]}     _          _       = ≤-refl
go-pos {q ∷ qs} {e ∷ es} (pq ∷ ps) (s≤s l) =
  *-mono-≤ (pow-pos q (suc e) (≤-trans (s≤s z≤n) (prime≥2 pq))) (go-pos {es = es} ps l)

-- A basis prime never divides the code of the strictly later primes.
coprime-tail : ∀ {q qs es} → Prime q → All Prime qs → All (q <_) qs →
               length es ≤ length qs → ¬ q ∣ go qs es
coprime-tail {es = []} pq _ _ _ = prime∤1 pq
coprime-tail {q} {r ∷ rs} {e ∷ es} pq (pr ∷ ps) (q<r ∷ q<rs) (s≤s l) d
  with euclidsLemma (r ^ suc e) (go rs es) pq d
... | inj₂ d′ = coprime-tail {es = es} pq ps q<rs l d′
... | inj₁ d′ with prime⇒irreducible pr (pow-div (suc e) pq d′)
...   | inj₁ q≡1 = nonTrivial⇒≢1 ⦃ prime⇒nonTrivial pq ⦄ q≡1
...   | inj₂ q≡r = <-irrefl q≡r q<r

------------------------------------------------------------------------
-- Main theorems

decode-encode-go : ∀ {qs es} → All Prime qs → Asc qs → length es ≤ length qs →
                   decodeL qs (go qs es) ≡ just es
decode-encode-go {[]}     {[]}     _ _ _ = refl
decode-encode-go {q ∷ qs} {[]}     (pq ∷ _) _ _ =
  cong (stepD q qs 1) (val-zero 0 q 1 (prime∤1 pq))
decode-encode-go {q ∷ qs} {e ∷ es} (pq ∷ ps) (a ∷ s) (s≤s l) =
  trans (cong (stepD q qs n) valEq)
        (cong (Maybe.map (e ∷_)) (trans (cong (decodeL qs) divEq) (decode-encode-go {es = es} ps s l)))
  where
  M = go qs es
  n = q ^ suc e * M
  2≤q = prime≥2 pq
  1≤qe : 1 ≤ q ^ suc e
  1≤qe = pow-pos q (suc e) (≤-trans (s≤s z≤n) 2≤q)
  bound : suc e < n
  bound = ≤-trans (pow-gt q (suc e) 2≤q)
                  (subst (_≤ n) (*-identityʳ (q ^ suc e)) (*-monoʳ-≤ (q ^ suc e) (go-pos {es = es} ps l)))
  valEq : val n q n ≡ suc e
  valEq = val-pow q (suc e) n M 2≤q (coprime-tail {es = es} pq ps a l) bound
  divEq : divN n (q ^ suc e) ≡ M
  divEq = divN-cancel M (q ^ suc e) 1≤qe

decode-encode : ∀ (B : PrimeBasis) es → length es ≤ capacity B → decode B (encode B es) ≡ just es
decode-encode B es l = decode-encode-go (allPrime B) (ascending B) l

encode-injective : ∀ (B : PrimeBasis) {es₁ es₂} →
  length es₁ ≤ capacity B → length es₂ ≤ capacity B →
  encode B es₁ ≡ encode B es₂ → es₁ ≡ es₂
encode-injective B {es₁} {es₂} l₁ l₂ eq =
  just-injective (trans (sym (decode-encode B es₁ l₁))
                        (trans (cong (decode B) eq) (decode-encode B es₂ l₂)))

-- Incremental (append) form of the encoding.
go-append : ∀ qs es e → length es < length qs →
            go qs (es ++ e ∷ []) ≡ go qs es * nth qs (length es) ^ suc e
go-append (q ∷ qs) []       e _ = trans (*-identityʳ (q ^ suc e)) (sym (*-identityˡ (q ^ suc e)))
go-append (q ∷ qs) (x ∷ xs) e (s≤s l) =
  trans (cong (q ^ suc x *_) (go-append qs xs e l))
        (sym (*-assoc (q ^ suc x) (go qs xs) (nth qs (length xs) ^ suc e)))

------------------------------------------------------------------------
-- Ledger state machine (proof-carrying record)

record Ledger (B : PrimeBasis) : Set where
  constructor ledger
  field
    entries : List ℕ
    code    : ℕ
    code-ok : code ≡ encode B entries
    cap     : length entries ≤ capacity B
open Ledger public

genesisLedger : (B : PrimeBasis) → Ledger B
genesisLedger B = ledger [] 1 refl z≤n

append : ∀ {B} → Ledger B → ℕ → Outcome (Ledger B)
append {B} L e with length (entries L) <? capacity B
... | yes lt = accept (ledger (entries L ++ e ∷ [])
                              (code L * nth (primes B) (length (entries L)) ^ suc e)
                              codeOk capOk)
  where
  codeOk = trans (cong (λ c → c * nth (primes B) (length (entries L)) ^ suc e) (code-ok L))
                 (sym (go-append (primes B) (entries L) e lt))
  capOk  = subst (_≤ capacity B) (sym (trans (length-++ (entries L)) (+-comm (length (entries L)) 1))) lt
... | no _ = reject capacity-exceeded

-- Every ledger state decodes to its own entries.
ledger-decodes : ∀ {B} (L : Ledger B) → decode B (code L) ≡ just (entries L)
ledger-decodes {B} L = trans (cong (decode B) (code-ok L)) (decode-encode B (entries L) (cap L))

append-entries : ∀ {B} (L : Ledger B) e {L′} → append L e ≡ accept L′ →
                 entries L′ ≡ entries L ++ e ∷ []
append-entries {B} L e eq with length (entries L) <? capacity B
append-entries {B} L e refl | yes _ = refl
append-entries {B} L e ()   | no _

append-code : ∀ {B} (L : Ledger B) e {L′} → append L e ≡ accept L′ →
              code L′ ≡ code L * nth (primes B) (length (entries L)) ^ suc e
append-code {B} L e eq with length (entries L) <? capacity B
append-code {B} L e refl | yes _ = refl
append-code {B} L e ()   | no _

append-decodes : ∀ {B} (L : Ledger B) e {L′} → append L e ≡ accept L′ →
                 decode B (code L′) ≡ just (entries L ++ e ∷ [])
append-decodes L e {L′} eq = trans (ledger-decodes L′) (cong just (append-entries L e eq))

append-reject-full : ∀ {B} (L : Ledger B) e {r} → append L e ≡ reject r → length (entries L) ≡ capacity B
append-reject-full {B} L e eq with length (entries L) <? capacity B
append-reject-full {B} L e () | yes _
append-reject-full {B} L e eq | no ¬lt = ≤∧≮⇒≡ (cap L) ¬lt

append-reject-unchanged : ∀ {B} (L : Ledger B) e {r} → append L e ≡ reject r → settle L (append L e) ≡ L
append-reject-unchanged L e eq = reject-preserves L eq
