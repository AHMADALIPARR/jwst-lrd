-- Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
-- JWST-LRD Sovereign Scientific Runtime -- formal verification kernel (Agda).
-- Dual-licensed, intentionally: AGPL-3.0-only AND SnapKitty Opaque License.
-- SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
--
-- Module boundary: VERIFIED CORE (--safe --without-K). No postulates.
--
-- Canonical observation validity.  An observation is a list of
-- fields (key, value = num/den, unit).  It is canonical/valid iff
--   (W) every field is well formed: den > 0 and gcd(|num|, den) = 1
--       (the LRD-REC-v1 rational rule "p/q with q>0, gcd(p,q)=1");
--   (U) every field declares a unit from the closed unit vocabulary;
--   (K) keys are non-empty (CONTRACTS v1.1: empty LRD-REC-v1 keys are
--       rejected; key code 0 models the empty key);
--   (C) keys are strictly ascending (LRD-REC-v1: "sorted bytewise
--       ascending and no duplicates"; keys are modelled as ℕ codes).
-- ValidObs is a proof-carrying certificate.  Its type and constructor
-- are `abstract`, so code outside this module can neither name the
-- constructor, use record syntax, nor see it through reflection; the
-- only producer is the checked smart constructor `validate`.
{-# OPTIONS --safe --without-K #-}
module Kernel.Observation where

open import Data.Bool.Base using (Bool; true; false; T)
open import Data.Empty using (⊥; ⊥-elim)
open import Data.Unit.Base using (⊤; tt)
open import Data.Nat.Base as ℕ using (ℕ; zero; suc; _<_; _≤_; s≤s; z≤n)
open import Data.Nat.Properties as ℕP using (_<?_; <-irrefl; <-asym)
open import Data.Nat.Coprimality using (Coprime; coprime?)
open import Data.Integer.Base as ℤ using (ℤ; +_; ∣_∣)
open import Data.Rational.Base using (ℚ; mkℚ; _≃_; *≡*)
open import Data.Rational.Properties using (≃⇒≡)
open import Data.List.Base using (List; []; _∷_)
open import Data.List.Relation.Unary.All as All using (All; []; _∷_; all?)
open import Data.List.Relation.Unary.Any using (here; there)
open import Data.List.Membership.Propositional using (_∈_)
open import Data.Maybe.Base using (Maybe; just; nothing)
open import Data.Product.Base using (Σ; _×_; _,_; proj₁; proj₂; ∃)
open import Relation.Nullary using (Dec; yes; no; ¬_)
open import Relation.Nullary.Decidable using (True; toWitness; fromWitness; _×-dec_)
open import Relation.Binary.PropositionalEquality
  using (_≡_; refl; cong; cong₂; subst; sym; trans)

------------------------------------------------------------------------
-- Raw (untrusted) input

-- Closed, declared unit vocabulary.
data UnitTag : Set where
  microjansky micron angstrom second kelvin erg-s-cm2 dimensionless : UnitTag

record RawField : Set where
  constructor field′
  field
    key  : ℕ           -- canonical key code (bytewise order ↦ ℕ order)
    num  : ℤ
    den  : ℕ
    unit : Maybe UnitTag  -- nothing = undeclared unit
open RawField public

record RawObs : Set where
  constructor obs
  field
    obsId  : ℕ
    fields : List RawField
open RawObs public

------------------------------------------------------------------------
-- Validity predicate

UnitDeclared : Maybe UnitTag → Set
UnitDeclared nothing  = ⊥
UnitDeclared (just _) = ⊤

unitDeclared? : (u : Maybe UnitTag) → Dec (UnitDeclared u)
unitDeclared? nothing  = no λ ()
unitDeclared? (just _) = yes tt

-- (W) + (U)
FieldOK : RawField → Set
FieldOK f = (0 < key f) × (0 < den f) × Coprime ∣ num f ∣ (den f) × UnitDeclared (unit f)

fieldOK? : (f : RawField) → Dec (FieldOK f)
fieldOK? f = (0 <? key f) ×-dec ((0 <? den f) ×-dec (coprime? ∣ num f ∣ (den f) ×-dec unitDeclared? (unit f)))

-- (C) strictly ascending keys
_≺_ : RawField → RawField → Set
f ≺ g = key f < key g

data Canonical : List RawField → Set where
  []  : Canonical []
  _∷_ : ∀ {f fs} → All (f ≺_) fs → Canonical fs → Canonical (f ∷ fs)

canonical? : (fs : List RawField) → Dec (Canonical fs)
canonical? [] = yes []
canonical? (f ∷ fs) with all? (λ g → key f <? key g) fs | canonical? fs
... | yes a | yes c = yes (a ∷ c)
... | no ¬a | _     = no λ { (a ∷ _) → ¬a a }
... | yes _ | no ¬c = no λ { (_ ∷ c) → ¬c c }

IsValid : RawObs → Set
IsValid r = All FieldOK (fields r) × Canonical (fields r)

isValid? : (r : RawObs) → Dec (IsValid r)
isValid? r = all? fieldOK? (fields r) ×-dec canonical? (fields r)

------------------------------------------------------------------------
-- Canonical form uniqueness (proved)

-- (1) A canonical field list is determined by its set of fields:
--     two canonical lists with the same members are identical.
canonical-unique : ∀ {xs ys} → Canonical xs → Canonical ys →
  (∀ {z} → z ∈ xs → z ∈ ys) → (∀ {z} → z ∈ ys → z ∈ xs) → xs ≡ ys
canonical-unique [] [] _ _ = refl
canonical-unique [] (_ ∷ _) _ g with g (here refl)
... | ()
canonical-unique (_ ∷ _) [] f _ with f (here refl)
... | ()
canonical-unique {x ∷ xs} {y ∷ ys} (ax ∷ cx) (ay ∷ cy) f g = goal
  where
  x≡y : x ≡ y
  x≡y with f (here refl) | g (here refl)
  ... | here p     | _          = p
  ... | there x∈ys | here y≡x   = ⊥-elim (<-irrefl (cong key y≡x) (All.lookup ay x∈ys))
  ... | there x∈ys | there y∈xs = ⊥-elim (<-asym (All.lookup ay x∈ys) (All.lookup ax y∈xs))
  -- a member of xs is strictly above x, hence never equal to x
  f′ : ∀ {z} → z ∈ xs → z ∈ ys
  f′ {z} z∈xs with f (there z∈xs)
  ... | here z≡y   = ⊥-elim (<-irrefl (cong key (trans x≡y (sym z≡y))) (All.lookup ax z∈xs))
  ... | there z∈ys = z∈ys
  g′ : ∀ {z} → z ∈ ys → z ∈ xs
  g′ {z} z∈ys with g (there z∈ys)
  ... | here z≡x   = ⊥-elim (<-irrefl (cong key (trans (sym x≡y) (sym z≡x))) (All.lookup ay z∈ys))
  ... | there z∈xs = z∈xs
  goal : x ∷ xs ≡ y ∷ ys
  goal = cong₂ _∷_ x≡y (canonical-unique cx cy f′ g′)

-- (2) A well-formed value num/den is the unique reduced representative
--     of its rational number: equal cross-products ⇒ identical fields.
rational-unique : ∀ n₁ n₂ d₁ d₂ →
  Coprime ∣ n₁ ∣ (suc d₁) → Coprime ∣ n₂ ∣ (suc d₂) →
  n₁ ℤ.* + suc d₂ ≡ n₂ ℤ.* + suc d₁ → n₁ ≡ n₂ × d₁ ≡ d₂
rational-unique n₁ n₂ d₁ d₂ c₁ c₂ h =
  cong ℚ.numerator eq , cong ℚ.denominator-1 eq
  where
  eq : mkℚ n₁ d₁ c₁ ≡ mkℚ n₂ d₂ c₂
  eq = ≃⇒≡ (*≡* h)

field-unique : ∀ f g → FieldOK f → FieldOK g →
  key f ≡ key g → unit f ≡ unit g →
  num f ℤ.* + den g ≡ num g ℤ.* + den f → f ≡ g
field-unique (field′ k n₁ zero u) _ (_ , () , _) _ _ _ _
field-unique _ (field′ k n₂ zero u) _ (_ , () , _) _ _ _
field-unique (field′ k n₁ (suc d₁) u) (field′ .k n₂ (suc d₂) .u)
             (_ , _ , c₁ , _) (_ , _ , c₂ , _) refl refl h
  with rational-unique n₁ n₂ d₁ d₂ c₁ c₂ h
... | refl , refl = refl

------------------------------------------------------------------------
-- Proof-irrelevance of the decision token (no funext needed)

True-irrelevant : ∀ {A : Set} (d : Dec A) (p q : True d) → p ≡ q
True-irrelevant (yes _) tt tt = refl
True-irrelevant (no _)  () ()

------------------------------------------------------------------------
-- The certificate: abstract type, abstract constructor.

abstract
  data ValidObs : Set where
    certify : (r : RawObs) → True (isValid? r) → ValidObs

  rawOf : ValidObs → RawObs
  rawOf (certify r _) = r

  -- Soundness of the certificate: it always carries a validity proof.
  validOf : (v : ValidObs) → IsValid (rawOf v)
  validOf (certify r ok) = toWitness ok

  -- Smart constructor (the only producer of ValidObs).
  validate : RawObs → Maybe ValidObs
  validate r with isValid? r
  ... | yes p = just (certify r (fromWitness p))
  ... | no  _ = nothing

  validate-sound : ∀ {r v} → validate r ≡ just v → rawOf v ≡ r
  validate-sound {r} eq with isValid? r
  validate-sound refl | yes _ = refl
  validate-sound ()   | no _

  validate-complete : ∀ r → IsValid r → Σ ValidObs λ v → validate r ≡ just v × rawOf v ≡ r
  validate-complete r p with isValid? r
  ... | yes p′ = certify r (fromWitness p′) , refl , refl
  ... | no ¬p  = ⊥-elim (¬p p)

  validate-reject : ∀ r → ¬ IsValid r → validate r ≡ nothing
  validate-reject r ¬p with isValid? r
  ... | yes p = ⊥-elim (¬p p)
  ... | no _  = refl

  -- Certificates are unique per raw observation.
  cert-unique : ∀ v w → rawOf v ≡ rawOf w → v ≡ w
  cert-unique (certify r p) (certify .r q) refl =
    cong (certify r) (True-irrelevant (isValid? r) p q)

-- Decidable boolean view (for the runtime / executable tests).
isValidᵇ : RawObs → Bool
isValidᵇ r with validate r
... | just _  = true
... | nothing = false
