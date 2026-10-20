-- Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
-- JWST-LRD Sovereign Scientific Runtime -- formal verification kernel (Agda).
-- Dual-licensed, intentionally: AGPL-3.0-only AND SnapKitty Opaque License.
-- SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
--
-- Module boundary: VERIFIED CORE (--safe --without-K). No postulates.
--
-- Simplicial boundary composition.  Oriented simplices are vertex
-- lists (orientation = list order); chains are formal ℤ-linear
-- combinations (lists of terms), compared by their coefficient
-- function ⟦c⟧ : Simplex → ℤ.  The boundary is the augmented one
-- (∂[v] = [ ] , the empty simplex); dropping degree −1 gives the
-- ordinary boundary and does not affect ∂∘∂ = 0 in degrees ≥ 0.
--
-- SCOPE PROVED (fully general): for EVERY simplex of EVERY dimension
-- (including degenerate vertex lists) and for EVERY finite ℤ-chain,
-- ⟦∂ (∂ c)⟧ ρ ≡ 0 for all simplices ρ.  In addition, the recursive
-- boundary is proved syntactically equal to the textbook formula
-- ∂[v₀…vₖ] = Σᵢ (−1)ⁱ [v₀…v̂ᵢ…vₖ].
{-# OPTIONS --safe --without-K #-}
module Kernel.Simplicial where

open import Data.Bool.Base using (Bool; true; false; if_then_else_; _∧_)
open import Data.Nat.Base as ℕ using (ℕ; zero; suc; _≡ᵇ_)
open import Data.Integer.Base using (ℤ; +_; -[1+_]; _+_; _*_; _-_; -_; 0ℤ; 1ℤ; -1ℤ)
open import Data.Integer.Properties using (+-identityˡ; +-identityʳ; +-assoc; *-zeroʳ)
open import Data.Integer.Solver using (module +-*-Solver)
open import Data.List.Base using (List; []; _∷_; _++_; map; length)
open import Data.List.Properties using (map-++; ++-assoc)
open import Data.Product.Base using (_×_; _,_)
open import Relation.Binary.PropositionalEquality
open +-*-Solver using (solve; _:+_; _:*_; _:-_; con; _:=_)

Simplex : Set
Simplex = List ℕ

Term : Set
Term = ℤ × Simplex

Chain : Set
Chain = List Term

------------------------------------------------------------------------
-- Coefficient semantics

eqS : Simplex → Simplex → Bool
eqS []      []      = true
eqS (v ∷ σ) (w ∷ ρ) = (v ≡ᵇ w) ∧ eqS σ ρ
eqS _       _       = false

ι : Simplex → Simplex → ℤ
ι σ ρ = if eqS σ ρ then 1ℤ else 0ℤ

⟦_⟧ : Chain → Simplex → ℤ
⟦ []          ⟧ ρ = 0ℤ
⟦ (a , σ) ∷ c ⟧ ρ = a * ι σ ρ + ⟦ c ⟧ ρ

------------------------------------------------------------------------
-- Operations

scaleT : ℤ → Term → Term
scaleT a (b , σ) = (a * b , σ)

coneT : ℕ → Term → Term
coneT v (b , σ) = (b , v ∷ σ)

scale : ℤ → Chain → Chain
scale a = map (scaleT a)

cone : ℕ → Chain → Chain
cone v = map (coneT v)

-- Boundary of a simplex:  ∂(v ∷ τ) = τ − v·∂τ
∂s : Simplex → Chain
∂s []      = []
∂s (v ∷ τ) = (1ℤ , τ) ∷ scale -1ℤ (cone v (∂s τ))

-- Linear extension to chains.
∂ : Chain → Chain
∂ []            = []
∂ ((a , σ) ∷ c) = scale a (∂s σ) ++ ∂ c

------------------------------------------------------------------------
-- Equivalence with the textbook alternating-face formula (syntactic).

deleteAt : ℕ → Simplex → Simplex
deleteAt _       []      = []
deleteAt zero    (_ ∷ σ) = σ
deleteAt (suc i) (v ∷ σ) = v ∷ deleteAt i σ

sign : ℕ → ℤ          -- sign i = (−1)ⁱ
sign zero    = 1ℤ
sign (suc i) = -1ℤ * sign i

upTo : ℕ → List ℕ
upTo zero    = []
upTo (suc n) = 0 ∷ map suc (upTo n)

face : Simplex → ℕ → Term
face σ i = (sign i , deleteAt i σ)

stdBoundary : Simplex → Chain
stdBoundary σ = map (face σ) (upTo (length σ))

private
  shift : ∀ v τ (is : List ℕ) →
    map (face (v ∷ τ)) (map suc is) ≡ scale -1ℤ (cone v (map (face τ) is))
  shift v τ []       = refl
  shift v τ (i ∷ is) = cong (_ ∷_) (shift v τ is)

∂s≡std : ∀ σ → ∂s σ ≡ stdBoundary σ
∂s≡std []      = refl
∂s≡std (v ∷ τ) = cong ((1ℤ , τ) ∷_)
  (trans (cong (λ c → scale -1ℤ (cone v c)) (∂s≡std τ)) (sym (shift v τ (upTo (length τ)))))

------------------------------------------------------------------------
-- Ring identities (discharged by the stdlib commutative-ring solver)

private
  r-scale : ∀ a b i k → (a * b) * i + a * k ≡ a * (b * i + k)
  r-scale = solve 4 (λ a b i k → (a :* b) :* i :+ a :* k := a :* (b :* i :+ k)) refl

  r-cone : ∀ b i C k D → b * (1ℤ * i + -1ℤ * C) + (k - D) ≡ (b * i + k) - (b * C + D)
  r-cone = solve 5 (λ b i C k D →
    b :* (con 1ℤ :* i :+ con -1ℤ :* C) :+ (k :- D) := (b :* i :+ k) :- (b :* C :+ D)) refl

  r-main : ∀ A B → 1ℤ * A + -1ℤ * (A - B) ≡ B
  r-main = solve 2 (λ A B → con 1ℤ :* A :+ con -1ℤ :* (A :- B) := B) refl

  r-zero : ∀ a → a * 0ℤ + 0ℤ ≡ 0ℤ
  r-zero = solve 1 (λ a → a :* con 0ℤ :+ con 0ℤ := con 0ℤ) refl

------------------------------------------------------------------------
-- Linearity lemmas

⟦++⟧ : ∀ c d ρ → ⟦ c ++ d ⟧ ρ ≡ ⟦ c ⟧ ρ + ⟦ d ⟧ ρ
⟦++⟧ []            d ρ = sym (+-identityˡ (⟦ d ⟧ ρ))
⟦++⟧ ((a , σ) ∷ c) d ρ =
  trans (cong (_+_ (a * ι σ ρ)) (⟦++⟧ c d ρ)) (sym (+-assoc (a * ι σ ρ) (⟦ c ⟧ ρ) (⟦ d ⟧ ρ)))

⟦scale⟧ : ∀ a c ρ → ⟦ scale a c ⟧ ρ ≡ a * ⟦ c ⟧ ρ
⟦scale⟧ a []            ρ = sym (*-zeroʳ a)
⟦scale⟧ a ((b , σ) ∷ c) ρ =
  trans (cong (_+_ ((a * b) * ι σ ρ)) (⟦scale⟧ a c ρ)) (r-scale a b (ι σ ρ) (⟦ c ⟧ ρ))

cone-scale : ∀ v b c → cone v (scale b c) ≡ scale b (cone v c)
cone-scale v b []      = refl
cone-scale v b (t ∷ c) = cong (_ ∷_) (cone-scale v b c)
  where open import Data.Product.Base using (proj₁)

∂-++ : ∀ c d → ∂ (c ++ d) ≡ ∂ c ++ ∂ d
∂-++ []            d = refl
∂-++ ((a , σ) ∷ c) d =
  trans (cong (scale a (∂s σ) ++_) (∂-++ c d)) (sym (++-assoc (scale a (∂s σ)) (∂ c) (∂ d)))

⟦∂scale⟧ : ∀ a c ρ → ⟦ ∂ (scale a c) ⟧ ρ ≡ a * ⟦ ∂ c ⟧ ρ
⟦∂scale⟧ a []            ρ = sym (*-zeroʳ a)
⟦∂scale⟧ a ((b , σ) ∷ c) ρ =
  begin
    ⟦ scale (a * b) (∂s σ) ++ ∂ (scale a c) ⟧ ρ
  ≡⟨ ⟦++⟧ (scale (a * b) (∂s σ)) (∂ (scale a c)) ρ ⟩
    ⟦ scale (a * b) (∂s σ) ⟧ ρ + ⟦ ∂ (scale a c) ⟧ ρ
  ≡⟨ cong₂ _+_ (⟦scale⟧ (a * b) (∂s σ) ρ) (⟦∂scale⟧ a c ρ) ⟩
    (a * b) * ⟦ ∂s σ ⟧ ρ + a * ⟦ ∂ c ⟧ ρ
  ≡⟨ r-scale a b (⟦ ∂s σ ⟧ ρ) (⟦ ∂ c ⟧ ρ) ⟩
    a * (b * ⟦ ∂s σ ⟧ ρ + ⟦ ∂ c ⟧ ρ)
  ≡⟨ cong (a *_) (sym (cong₂ _+_ (⟦scale⟧ b (∂s σ) ρ) refl)) ⟩
    a * (⟦ scale b (∂s σ) ⟧ ρ + ⟦ ∂ c ⟧ ρ)
  ≡⟨ cong (a *_) (sym (⟦++⟧ (scale b (∂s σ)) (∂ c) ρ)) ⟩
    a * ⟦ scale b (∂s σ) ++ ∂ c ⟧ ρ
  ∎
  where open ≡-Reasoning

-- Cone lemma:  ∂(v·c) = c − v·∂c   (coefficient-wise)
⟦∂cone⟧ : ∀ v c ρ → ⟦ ∂ (cone v c) ⟧ ρ ≡ ⟦ c ⟧ ρ - ⟦ cone v (∂ c) ⟧ ρ
⟦∂cone⟧ v [] ρ = refl
⟦∂cone⟧ v ((b , σ) ∷ c) ρ =
  begin
    ⟦ scale b ((1ℤ , σ) ∷ X) ++ ∂ (cone v c) ⟧ ρ
  ≡⟨ ⟦++⟧ (scale b ((1ℤ , σ) ∷ X)) (∂ (cone v c)) ρ ⟩
    ⟦ scale b ((1ℤ , σ) ∷ X) ⟧ ρ + ⟦ ∂ (cone v c) ⟧ ρ
  ≡⟨ cong₂ _+_ (⟦scale⟧ b ((1ℤ , σ) ∷ X) ρ) (⟦∂cone⟧ v c ρ) ⟩
    b * (1ℤ * ι σ ρ + ⟦ X ⟧ ρ) + (⟦ c ⟧ ρ - ⟦ cone v (∂ c) ⟧ ρ)
  ≡⟨ cong (λ u → b * (1ℤ * ι σ ρ + u) + (⟦ c ⟧ ρ - ⟦ cone v (∂ c) ⟧ ρ)) (⟦scale⟧ -1ℤ (cone v (∂s σ)) ρ) ⟩
    b * (1ℤ * ι σ ρ + -1ℤ * C) + (⟦ c ⟧ ρ - ⟦ cone v (∂ c) ⟧ ρ)
  ≡⟨ r-cone b (ι σ ρ) C (⟦ c ⟧ ρ) (⟦ cone v (∂ c) ⟧ ρ) ⟩
    (b * ι σ ρ + ⟦ c ⟧ ρ) - (b * C + ⟦ cone v (∂ c) ⟧ ρ)
  ≡⟨ cong (λ u → (b * ι σ ρ + ⟦ c ⟧ ρ) - (u + ⟦ cone v (∂ c) ⟧ ρ)) (sym CS) ⟩
    (b * ι σ ρ + ⟦ c ⟧ ρ) - (⟦ cone v (scale b (∂s σ)) ⟧ ρ + ⟦ cone v (∂ c) ⟧ ρ)
  ≡⟨ cong (λ u → (b * ι σ ρ + ⟦ c ⟧ ρ) - u) (sym (⟦++⟧ (cone v (scale b (∂s σ))) (cone v (∂ c)) ρ)) ⟩
    (b * ι σ ρ + ⟦ c ⟧ ρ) - ⟦ cone v (scale b (∂s σ)) ++ cone v (∂ c) ⟧ ρ
  ≡⟨ cong (λ u → (b * ι σ ρ + ⟦ c ⟧ ρ) - ⟦ u ⟧ ρ) (sym (map-++ (coneT v) (scale b (∂s σ)) (∂ c))) ⟩
    (b * ι σ ρ + ⟦ c ⟧ ρ) - ⟦ cone v (scale b (∂s σ) ++ ∂ c) ⟧ ρ
  ∎
  where
  open ≡-Reasoning
  X = scale -1ℤ (cone v (∂s σ))
  C = ⟦ cone v (∂s σ) ⟧ ρ
  CS : ⟦ cone v (scale b (∂s σ)) ⟧ ρ ≡ b * C
  CS = trans (cong (λ u → ⟦ u ⟧ ρ) (cone-scale v b (∂s σ))) (⟦scale⟧ b (cone v (∂s σ)) ρ)

-- Coning a coefficient-wise zero chain gives a zero chain.
cone-zero : ∀ v c → (∀ ρ → ⟦ c ⟧ ρ ≡ 0ℤ) → ∀ ρ → ⟦ cone v c ⟧ ρ ≡ 0ℤ
cone-zero v c z [] = go c
  where
  go : ∀ c → ⟦ cone v c ⟧ [] ≡ 0ℤ
  go []            = refl
  go ((b , σ) ∷ c) = trans (cong (_+_ (b * 0ℤ)) (go c)) (r-zero b)
cone-zero v c z (w ∷ ρ) with v ≡ᵇ w in eq
... | true  = trans (hit c) (z ρ)
  where
  hit : ∀ c → ⟦ cone v c ⟧ (w ∷ ρ) ≡ ⟦ c ⟧ ρ
  hit []            = refl
  hit ((b , σ) ∷ c) rewrite eq = cong (_+_ (b * ι σ ρ)) (hit c)
... | false = miss c
  where
  miss : ∀ c → ⟦ cone v c ⟧ (w ∷ ρ) ≡ 0ℤ
  miss []            = refl
  miss ((b , σ) ∷ c) rewrite eq = trans (cong (_+_ (b * 0ℤ)) (miss c)) (r-zero b)

------------------------------------------------------------------------
-- ∂ ∘ ∂ = 0

∂∂s≡0 : ∀ σ ρ → ⟦ ∂ (∂s σ) ⟧ ρ ≡ 0ℤ
∂∂s≡0 []      ρ = refl
∂∂s≡0 (v ∷ τ) ρ =
  begin
    ⟦ scale 1ℤ (∂s τ) ++ ∂ (scale -1ℤ (cone v (∂s τ))) ⟧ ρ
  ≡⟨ ⟦++⟧ (scale 1ℤ (∂s τ)) (∂ (scale -1ℤ (cone v (∂s τ)))) ρ ⟩
    ⟦ scale 1ℤ (∂s τ) ⟧ ρ + ⟦ ∂ (scale -1ℤ (cone v (∂s τ))) ⟧ ρ
  ≡⟨ cong₂ _+_ (⟦scale⟧ 1ℤ (∂s τ) ρ) (⟦∂scale⟧ -1ℤ (cone v (∂s τ)) ρ) ⟩
    1ℤ * ⟦ ∂s τ ⟧ ρ + -1ℤ * ⟦ ∂ (cone v (∂s τ)) ⟧ ρ
  ≡⟨ cong (λ u → 1ℤ * ⟦ ∂s τ ⟧ ρ + -1ℤ * u) (⟦∂cone⟧ v (∂s τ) ρ) ⟩
    1ℤ * ⟦ ∂s τ ⟧ ρ + -1ℤ * (⟦ ∂s τ ⟧ ρ - ⟦ cone v (∂ (∂s τ)) ⟧ ρ)
  ≡⟨ r-main (⟦ ∂s τ ⟧ ρ) (⟦ cone v (∂ (∂s τ)) ⟧ ρ) ⟩
    ⟦ cone v (∂ (∂s τ)) ⟧ ρ
  ≡⟨ cone-zero v (∂ (∂s τ)) (∂∂s≡0 τ) ρ ⟩
    0ℤ
  ∎
  where open ≡-Reasoning

-- General theorem: for every finite ℤ-chain c, ∂(∂ c) is zero.
∂∂≡0 : ∀ c ρ → ⟦ ∂ (∂ c) ⟧ ρ ≡ 0ℤ
∂∂≡0 []            ρ = refl
∂∂≡0 ((a , σ) ∷ c) ρ =
  begin
    ⟦ ∂ (scale a (∂s σ) ++ ∂ c) ⟧ ρ
  ≡⟨ cong (λ u → ⟦ u ⟧ ρ) (∂-++ (scale a (∂s σ)) (∂ c)) ⟩
    ⟦ ∂ (scale a (∂s σ)) ++ ∂ (∂ c) ⟧ ρ
  ≡⟨ ⟦++⟧ (∂ (scale a (∂s σ))) (∂ (∂ c)) ρ ⟩
    ⟦ ∂ (scale a (∂s σ)) ⟧ ρ + ⟦ ∂ (∂ c) ⟧ ρ
  ≡⟨ cong₂ _+_ (⟦∂scale⟧ a (∂s σ) ρ) (∂∂≡0 c ρ) ⟩
    a * ⟦ ∂ (∂s σ) ⟧ ρ + 0ℤ
  ≡⟨ cong (λ u → a * u + 0ℤ) (∂∂s≡0 σ ρ) ⟩
    a * 0ℤ + 0ℤ
  ≡⟨ r-zero a ⟩
    0ℤ
  ∎
  where open ≡-Reasoning

------------------------------------------------------------------------
-- Executable check used by the boundary tests (not a proof device):
-- every coefficient of the chain at every simplex in its support is 0.

_==ℤ_ : ℤ → ℤ → Bool
(+ m)    ==ℤ (+ n)    = m ≡ᵇ n
-[1+ m ] ==ℤ -[1+ n ] = m ≡ᵇ n
_        ==ℤ _        = false

isZeroChain : Chain → Bool
isZeroChain c = allB (λ t → ⟦ c ⟧ (proj₂ t) ==ℤ 0ℤ) c
  where
  open import Data.Product.Base using (proj₂)
  allB : (Term → Bool) → Chain → Bool
  allB p []      = true
  allB p (t ∷ ts) = p t ∧ allB p ts
