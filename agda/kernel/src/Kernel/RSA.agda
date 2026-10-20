-- Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
-- JWST-LRD Sovereign Scientific Runtime -- formal verification kernel (Agda).
-- Dual-licensed, intentionally: AGPL-3.0-only AND SnapKitty Opaque License.
-- SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
--
-- Module boundary: VERIFIED CORE (--safe --without-K). No postulates.
--
-- RSA-accumulator model: transitions and the witness verification
-- contract.  The group is abstract: any monoid with propositional laws
-- and decidable equality (for the real system: ℤ_N^* with N an RSA
-- modulus of unknown factorisation).
--
--   PROVED  (pure algebra, from the monoid laws):
--     * verification is a decidable check (`verify`, Bool-valued);
--     * completeness: the honest witness for a member verifies;
--     * add-transition correctness: acc (x ∷ S) ≡ acc S ^ x;
--     * witness update: an old valid witness w for y becomes w ^ x.
--   ASSUMED (Kernel.Assumptions.Crypto.AccumulatorWitnessSound):
--     * soundness: an accepted witness implies membership.  This is the
--       strong-RSA assumption and is NEVER proved here; the only theorem
--       that uses it (`cert⇒member`) takes it as an explicit argument.
{-# OPTIONS --safe --without-K #-}
module Kernel.RSA where

open import Data.Bool.Base using (Bool; true; false; T)
open import Data.Empty using (⊥-elim)
open import Data.Unit.Base using (tt)
open import Data.Nat.Base using (ℕ; zero; suc; _+_; _*_)
open import Data.Nat.Properties as ℕP using (*-suc; *-zeroʳ; *-comm; *-assoc; *-identityʳ)
open import Data.Nat.Primality using (Prime; prime?)
open import Data.List.Base using (List; []; _∷_)
open import Data.List.Membership.Propositional using (_∈_)
open import Data.List.Membership.DecPropositional ℕP._≟_ using (_∈?_)
open import Data.List.Relation.Unary.Any using (here; there)
open import Data.Maybe.Base using (Maybe; just; nothing)
open import Data.Product.Base using (Σ; _,_; _×_)
open import Relation.Nullary using (Dec; yes; no; ¬_)
open import Relation.Nullary.Decidable using (isYes)
open import Relation.Binary.Definitions using (DecidableEquality)
open import Relation.Binary.PropositionalEquality
open import Kernel.Decision
open import Kernel.Assumptions.Crypto using (AccumulatorWitnessSound)

-- Monoid with propositional laws and decidable equality.
record PMonoid : Set₁ where
  infixl 7 _∙_
  field
    Carrier   : Set
    _∙_       : Carrier → Carrier → Carrier
    ε         : Carrier
    assoc     : ∀ x y z → (x ∙ y) ∙ z ≡ x ∙ (y ∙ z)
    identityˡ : ∀ x → ε ∙ x ≡ x
    _≟_       : DecidableEquality Carrier

module Accumulator (𝕄 : PMonoid) (g : PMonoid.Carrier 𝕄) where
  open PMonoid 𝕄

  infixr 8 _^_
  _^_ : Carrier → ℕ → Carrier
  x ^ zero  = ε
  x ^ suc n = x ∙ (x ^ n)

  pow-+ : ∀ x a b → x ^ (a + b) ≡ x ^ a ∙ x ^ b
  pow-+ x zero    b = sym (identityˡ (x ^ b))
  pow-+ x (suc a) b = trans (cong (x ∙_) (pow-+ x a b)) (sym (assoc x (x ^ a) (x ^ b)))

  pow-* : ∀ x a b → (x ^ a) ^ b ≡ x ^ (a * b)
  pow-* x a zero    rewrite *-zeroʳ a = refl
  pow-* x a (suc b) rewrite *-suc a b =
    trans (cong (x ^ a ∙_) (pow-* x a b)) (sym (pow-+ x a (a * b)))

  pow-swap : ∀ w a b → (w ^ a) ^ b ≡ (w ^ b) ^ a
  pow-swap w a b = trans (pow-* w a b) (trans (cong (w ^_) (*-comm a b)) (sym (pow-* w b a)))

  prod : List ℕ → ℕ
  prod []       = 1
  prod (x ∷ xs) = x * prod xs

  acc : List ℕ → Carrier
  acc S = g ^ prod S

  -- The decidable verification check.
  verify : Carrier → ℕ → Carrier → Bool
  verify A x w = isYes ((w ^ x) ≟ A)

  verify-≡ : ∀ A x w → w ^ x ≡ A → verify A x w ≡ true
  verify-≡ A x w eq with (w ^ x) ≟ A
  ... | yes _ = refl
  ... | no ¬p = ⊥-elim (¬p eq)

  verify-sound-eq : ∀ A x w → verify A x w ≡ true → w ^ x ≡ A
  verify-sound-eq A x w eq with (w ^ x) ≟ A
  ... | yes p = p
  verify-sound-eq A x w () | no _

  removeFirst : ℕ → List ℕ → List ℕ
  removeFirst x [] = []
  removeFirst x (y ∷ ys) with x ℕP.≟ y
  ... | yes _ = ys
  ... | no  _ = y ∷ removeFirst x ys

  prod-remove : ∀ {x S} → x ∈ S → prod S ≡ x * prod (removeFirst x S)
  prod-remove {x} {y ∷ ys} m with x ℕP.≟ y
  ... | yes refl = refl
  prod-remove {x} {y ∷ ys} (here refl) | no x≢y = ⊥-elim (x≢y refl)
  prod-remove {x} {y ∷ ys} (there m)   | no _ =
    trans (cong (y *_) (prod-remove m))
          (trans (sym (*-assoc y x _)) (trans (cong (_* prod (removeFirst x ys)) (*-comm y x)) (*-assoc x y _)))

  -- Honest witness for x ∈ S.
  witness : List ℕ → ℕ → Carrier
  witness S x = g ^ prod (removeFirst x S)

  -- Completeness (proved).
  completeness : ∀ {S x} → x ∈ S → verify (acc S) x (witness S x) ≡ true
  completeness {S} {x} m = verify-≡ (acc S) x (witness S x) (trans (pow-* g (prod (removeFirst x S)) x)
    (cong (g ^_) (trans (*-comm (prod (removeFirst x S)) x) (sym (prod-remove m)))))

  -- Add transition (proved): acc (x ∷ S) = acc S ^ x.
  acc-add : ∀ x S → acc (x ∷ S) ≡ acc S ^ x
  acc-add x S = trans (cong (g ^_) (*-comm x (prod S))) (sym (pow-* g (prod S) x))

  -- Witness update on add (proved).
  witness-update : ∀ {S y w} x → verify (acc S) y w ≡ true → verify (acc (x ∷ S)) y (w ^ x) ≡ true
  witness-update {S} {y} {w} x vok =
    verify-≡ (acc (x ∷ S)) y (w ^ x) (trans (pow-swap w x y) (trans (cong (_^ x) (verify-sound-eq (acc S) y w vok)) (sym (acc-add x S))))

  ----------------------------------------------------------------------
  -- Witness-verification contract: certificate with abstract constructor.
  abstract
    data MemberCert (A : Carrier) (x : ℕ) : Set where
      cert : (w : Carrier) → verify A x w ≡ true → MemberCert A x

    checkWitness : (A : Carrier) (x : ℕ) (w : Carrier) → Maybe (MemberCert A x)
    checkWitness A x w with (w ^ x) ≟ A
    ... | yes p = just (cert w (verify-≡ A x w p))
    ... | no  _ = nothing

    cert-witness : ∀ {A x} → MemberCert A x → Carrier
    cert-witness (cert w _) = w

    cert-verified : ∀ {A x} (c : MemberCert A x) → verify A x (cert-witness c) ≡ true
    cert-verified (cert _ vok) = vok

    checkWitness-complete : (A : Carrier) (x : ℕ) (w : Carrier) → verify A x w ≡ true → Σ (MemberCert A x) λ c → checkWitness A x w ≡ just c
    checkWitness-complete A x w vok with (w ^ x) ≟ A
    ... | yes p = cert w (verify-≡ A x w p) , refl
    checkWitness-complete A x w () | no _

  -- Soundness: ONLY under the crypto assumption, passed explicitly.
  cert⇒member : AccumulatorWitnessSound acc verify _∈_ →
                ∀ {S x} → MemberCert (acc S) x → x ∈ S
  cert⇒member sound {S} {x} c = sound S x (cert-witness c) (cert-verified c)

  ----------------------------------------------------------------------
  -- Accumulator state machine (proof-carrying record).
  record AccState : Set where
    constructor accState
    field
      members  : List ℕ
      value    : Carrier
      value-ok : value ≡ acc members
  open AccState public

  genesisAcc : AccState
  genesisAcc = accState [] (g ^ 1) refl

  -- Add: representative must be prime (hash-to-prime output) and fresh.
  tryAdd : AccState → ℕ → Outcome AccState
  tryAdd s x with prime? x | x ∈? members s
  ... | yes _ | no _  = accept (accState (x ∷ members s) (value s ^ x)
                                 (trans (cong (_^ x) (value-ok s)) (sym (acc-add x (members s)))))
  ... | yes _ | yes _ = reject bad-witness
  ... | no _  | _     = reject bad-witness

  tryAdd-value : ∀ s x {s′} → tryAdd s x ≡ accept s′ → value s′ ≡ value s ^ x × members s′ ≡ x ∷ members s
  tryAdd-value s x eq with prime? x | x ∈? members s
  tryAdd-value s x refl | yes _ | no _ = refl , refl
  tryAdd-value s x ()   | yes _ | yes _
  tryAdd-value s x ()   | no _  | _
