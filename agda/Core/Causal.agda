{-# OPTIONS --safe --without-K #-}
-- Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
-- Dual-licensed: AGPL-3.0-or-later plus SnapKitty Opaque License.
-- SPDX-License-Identifier: AGPL-3.0-or-later AND LicenseRef-SnapKitty-Opaque
--
-- JWST-LRD Sovereign Scientific Runtime -- TASK 011: Agda verified core.
-- Obligation group CAU: causal relations in integer 1+1D Minkowski space (units with c = 1).
--
-- For events a, b with u = Δt = t b - t a and x = Δx = x b - x a:
--   future-timelike  a ≺ b  :  x < u  and  - x < u     (|Δx| < Δt, which forces Δt > 0)
--   light-like               :  x ≡ u  or   x ≡ - u     (|Δx| ≡ |Δt|)
--   space-like               :  |Δt| < |Δx|, written as (u < x and - u < x) or (x < u and x < - u)
-- Proved: ≺ is irreflexive and transitive (a strict partial order; asymmetry follows), every pair
-- of events is classified as future-timelike / past-timelike / light-like / space-like, and the
-- classes are pairwise exclusive. Under uncertainty bounds (axis-aligned integer boxes) a
-- three-valued classifier returns timelike-future / timelike-past / spacelike only when the
-- relation holds for EVERY pair of points in the boxes, otherwise `unknown`.

module Core.Causal where

open import Data.Integer using (ℤ; _+_; _-_; -_; _<_; _≤_; _<?_; +0)
open import Data.Integer.Properties
  using (<-cmp; <-irrefl; <-asym; <-trans; ≤-<-trans; <-≤-trans; <⇒≤; +-mono-<-≤; +-mono-≤;
         neg-mono-<; neg-mono-≤; neg-involutive; neg-distrib-+; +-inverseʳ)
open import Data.Integer.Solver using (module +-*-Solver)
open import Data.Product using (_×_; _,_; Σ; proj₁; proj₂)
open import Data.Sum using (_⊎_; inj₁; inj₂)
open import Data.Unit using (⊤; tt)
open import Data.Empty using (⊥)
open import Relation.Nullary using (¬_; yes; no)
open import Relation.Nullary.Decidable using (_×-dec_; _⊎-dec_)
open import Relation.Binary using (tri<; tri≈; tri>)
open import Relation.Binary.PropositionalEquality

open +-*-Solver using (solve; _:=_; _:+_; _:-_; :-_)

------------------------------------------------------------------------
-- Relations on a displacement (u = Δt, x = Δx)

FutD : ℤ → ℤ → Set
FutD u x = (x < u) × (- x < u)

LightD : ℤ → ℤ → Set
LightD u x = (x ≡ u) ⊎ (x ≡ - u)

SpaceD : ℤ → ℤ → Set
SpaceD u x = ((u < x) × (- u < x)) ⊎ ((x < u) × (x < - u))

------------------------------------------------------------------------
-- Events

record Event : Set where
  constructor ev
  field
    t : ℤ
    x : ℤ
open Event public

Δt : Event → Event → ℤ
Δt a b = t b - t a

Δx : Event → Event → ℤ
Δx a b = x b - x a

FutTL : Event → Event → Set          -- a ≺ b : b is in the open future cone of a
FutTL a b = FutD (Δt a b) (Δx a b)

PastTL : Event → Event → Set
PastTL a b = FutTL b a

Light : Event → Event → Set
Light a b = LightD (Δt a b) (Δx a b)

Space : Event → Event → Set
Space a b = SpaceD (Δt a b) (Δx a b)

------------------------------------------------------------------------
-- Integer lemmas

split : ∀ p q r → r - p ≡ (q - p) + (r - q)
split = solve 3 (λ p q r → r :- p := (q :- p) :+ (r :- q)) refl

swap : ∀ p q → p - q ≡ - (q - p)
swap = solve 2 (λ p q → p :- q := :- (q :- p)) refl

self : ∀ p → p - p ≡ +0
self p = +-inverseʳ p

------------------------------------------------------------------------
-- Strict partial order

FutD-irrefl : ¬ FutD +0 +0
FutD-irrefl (p , _) = <-irrefl refl p

FutD-trans : ∀ {u₁ x₁ u₂ x₂} → FutD u₁ x₁ → FutD u₂ x₂ → FutD (u₁ + u₂) (x₁ + x₂)
FutD-trans {u₁} {x₁} {u₂} {x₂} (p₁ , q₁) (p₂ , q₂) =
  +-mono-<-≤ p₁ (<⇒≤ p₂) ,
  subst (_< u₁ + u₂) (sym (neg-distrib-+ x₁ x₂)) (+-mono-<-≤ q₁ (<⇒≤ q₂))

≺-irrefl : ∀ a → ¬ FutTL a a
≺-irrefl a f rewrite self (t a) | self (x a) = FutD-irrefl f

≺-trans : ∀ {a b c} → FutTL a b → FutTL b c → FutTL a c
≺-trans {a} {b} {c} f g
  rewrite split (t a) (t b) (t c) | split (x a) (x b) (x c) = FutD-trans f g

≺-asym : ∀ {a b} → FutTL a b → ¬ FutTL b a
≺-asym {a} {b} f g = ≺-irrefl a (≺-trans {a} {b} {a} f g)

------------------------------------------------------------------------
-- Classification

data Class (a b : Event) : Set where
  future-timelike : FutTL a b  → Class a b
  past-timelike   : PastTL a b → Class a b
  light-like      : Light a b  → Class a b
  space-like      : Space a b  → Class a b

-- PastTL a b in displacement form: u < x and x < - u  (i.e. Δt < -|Δx|)
PastD : ℤ → ℤ → Set
PastD u x = (u < x) × (x < - u)

past-intro : ∀ a b → PastD (Δt a b) (Δx a b) → PastTL a b
past-intro a b (u<x , x<-u)
  rewrite swap (t a) (t b) | swap (x a) (x b) =
  neg-mono-< u<x , subst (_< - Δt a b) (sym (neg-involutive (Δx a b))) x<-u

past-elim : ∀ a b → PastTL a b → PastD (Δt a b) (Δx a b)
past-elim a b (p , q) =
  subst₂ _<_ (neg-involutive (Δt a b)) (neg-involutive (Δx a b)) (neg-mono-< p′) ,
  subst (_< - Δt a b) (neg-involutive (Δx a b)) q′
  where
  p′ : - Δx a b < - Δt a b
  p′ = subst₂ _<_ (swap (x a) (x b)) (swap (t a) (t b)) p
  q′ : - - Δx a b < - Δt a b
  q′ = subst₂ _<_ (cong -_ (swap (x a) (x b))) (swap (t a) (t b)) q

classifyD : ∀ u x → FutD u x ⊎ PastD u x ⊎ LightD u x ⊎ SpaceD u x
classifyD u x with <-cmp x u | <-cmp x (- u)
... | tri< x<u _ _ | tri> _ _ -u<x =
      inj₁ (x<u , subst (- x <_) (neg-involutive u) (neg-mono-< -u<x))
... | tri< x<u _ _ | tri< x<-u _ _ = inj₂ (inj₂ (inj₂ (inj₂ (x<u , x<-u))))
... | tri< _ _ _   | tri≈ _ x≡-u _ = inj₂ (inj₂ (inj₁ (inj₂ x≡-u)))
... | tri≈ _ x≡u _ | _             = inj₂ (inj₂ (inj₁ (inj₁ x≡u)))
... | tri> _ _ u<x | tri> _ _ -u<x = inj₂ (inj₂ (inj₂ (inj₁ (u<x , -u<x))))
... | tri> _ _ _   | tri≈ _ x≡-u _ = inj₂ (inj₂ (inj₁ (inj₂ x≡-u)))
... | tri> _ _ u<x | tri< x<-u _ _ = inj₂ (inj₁ (u<x , x<-u))

classify : ∀ a b → Class a b
classify a b with classifyD (Δt a b) (Δx a b)
... | inj₁ f                = future-timelike f
... | inj₂ (inj₁ p)         = past-timelike (past-intro a b p)
... | inj₂ (inj₂ (inj₁ l))  = light-like l
... | inj₂ (inj₂ (inj₂ s))  = space-like s

-- Exclusivity (displacement level)
fut-not-light : ∀ {u x} → FutD u x → ¬ LightD u x
fut-not-light (x<u , _)   (inj₁ refl) = <-irrefl refl x<u
fut-not-light {u} (_ , -x<u) (inj₂ refl) = <-irrefl refl (subst (_< u) (neg-involutive u) -x<u)

fut-not-space : ∀ {u x} → FutD u x → ¬ SpaceD u x
fut-not-space (x<u , _)    (inj₁ (u<x , _))   = <-asym x<u u<x
fut-not-space {u} {x} (_ , -x<u) (inj₂ (_ , x<-u)) =
  <-asym x<-u (subst (- u <_) (neg-involutive x) (neg-mono-< -x<u))

past-not-fut : ∀ {u x} → PastD u x → ¬ FutD u x
past-not-fut (u<x , _) (x<u , _) = <-asym x<u u<x

past-not-light : ∀ {u x} → PastD u x → ¬ LightD u x
past-not-light (u<x , _)    (inj₁ refl) = <-irrefl refl u<x
past-not-light (_ , x<-u)   (inj₂ refl) = <-irrefl refl x<-u

past-not-space : ∀ {u x} → PastD u x → ¬ SpaceD u x
past-not-space (_ , x<-u) (inj₁ (_ , -u<x)) = <-asym x<-u -u<x
past-not-space (u<x , _)  (inj₂ (x<u , _))  = <-asym x<u u<x

light-not-space : ∀ {u x} → LightD u x → ¬ SpaceD u x
light-not-space (inj₁ refl) (inj₁ (u<x , _)) = <-irrefl refl u<x
light-not-space (inj₁ refl) (inj₂ (x<u , _)) = <-irrefl refl x<u
light-not-space (inj₂ refl) (inj₁ (_ , -u<x)) = <-irrefl refl -u<x
light-not-space (inj₂ refl) (inj₂ (_ , x<-u)) = <-irrefl refl x<-u

-- Exclusivity lifted to events: at most one class holds for any pair (a, b).
≺-not-light : ∀ {a b} → FutTL a b → ¬ Light a b
≺-not-light = fut-not-light

≺-not-space : ∀ {a b} → FutTL a b → ¬ Space a b
≺-not-space = fut-not-space

past-not-≺ : ∀ {a b} → PastTL a b → ¬ FutTL a b
past-not-≺ {a} {b} p = past-not-fut (past-elim a b p)

pastTL-not-light : ∀ {a b} → PastTL a b → ¬ Light a b
pastTL-not-light {a} {b} p = past-not-light (past-elim a b p)

pastTL-not-space : ∀ {a b} → PastTL a b → ¬ Space a b
pastTL-not-space {a} {b} p = past-not-space (past-elim a b p)

lightlike-not-space : ∀ {a b} → Light a b → ¬ Space a b
lightlike-not-space = light-not-space

------------------------------------------------------------------------
-- Three-valued classification under uncertainty bounds

record Box : Set where
  constructor box
  field
    tlo thi xlo xhi : ℤ
open Box public

In : Box → Event → Set
In B e = (tlo B ≤ t e) × (t e ≤ thi B) × (xlo B ≤ x e) × (x e ≤ xhi B)

data Verdict : Set where
  timelike-future timelike-past spacelike unknown : Verdict

Holds : Box → Box → Verdict → Set
Holds A B timelike-future = ∀ a b → In A a → In B b → FutTL a b
Holds A B timelike-past   = ∀ a b → In A a → In B b → PastTL a b
Holds A B spacelike       = ∀ a b → In A a → In B b → Space a b
Holds A B unknown         = ⊤

-- Displacement bounds
dtl dth dxl dxh : Box → Box → ℤ
dtl A B = tlo B - thi A
dth A B = thi B - tlo A
dxl A B = xlo B - xhi A
dxh A B = xhi B - xlo A

sub-mono : ∀ {p p′ q q′} → p ≤ p′ → q′ ≤ q → p - q ≤ p′ - q′
sub-mono p≤ q≤ = +-mono-≤ p≤ (neg-mono-≤ q≤)

module _ {A B : Box} {a b : Event} (ia : In A a) (ib : In B b) where
  private
    u = Δt a b
    x′ = Δx a b
  tl≤u : dtl A B ≤ u
  tl≤u = sub-mono (proj₁ ib) (proj₁ (proj₂ ia))
  u≤th : u ≤ dth A B
  u≤th = sub-mono (proj₁ (proj₂ ib)) (proj₁ ia)
  xl≤x : dxl A B ≤ x′
  xl≤x = sub-mono (proj₁ (proj₂ (proj₂ ib))) (proj₂ (proj₂ (proj₂ ia)))
  x≤xh : x′ ≤ dxh A B
  x≤xh = sub-mono (proj₂ (proj₂ (proj₂ ib))) (proj₁ (proj₂ (proj₂ ia)))

classifyU : ∀ A B → Σ Verdict (Holds A B)
classifyU A B
  with (dxh A B <? dtl A B) ×-dec (- dxl A B <? dtl A B)
... | yes (c₁ , c₂) = timelike-future , λ a b ia ib →
        ≤-<-trans (x≤xh ia ib) (<-≤-trans c₁ (tl≤u ia ib)) ,
        ≤-<-trans (neg-mono-≤ (xl≤x ia ib)) (<-≤-trans c₂ (tl≤u ia ib))
... | no _
  with (dth A B <? dxl A B) ×-dec (dxh A B <? - dth A B)
... | yes (c₁ , c₂) = timelike-past , λ a b ia ib → past-intro a b
        ( ≤-<-trans (u≤th ia ib) (<-≤-trans c₁ (xl≤x ia ib))
        , ≤-<-trans (x≤xh ia ib) (<-≤-trans c₂ (neg-mono-≤ (u≤th ia ib))))
... | no _
  with (dth A B <? dxl A B) ×-dec (- dtl A B <? dxl A B)
... | yes (c₁ , c₂) = spacelike , λ a b ia ib → inj₁
        ( ≤-<-trans (u≤th ia ib) (<-≤-trans c₁ (xl≤x ia ib))
        , ≤-<-trans (neg-mono-≤ (tl≤u ia ib)) (<-≤-trans c₂ (xl≤x ia ib)))
... | no _
  with (dxh A B <? dtl A B) ×-dec (dxh A B <? - dth A B)
... | yes (c₁ , c₂) = spacelike , λ a b ia ib → inj₂
        ( ≤-<-trans (x≤xh ia ib) (<-≤-trans c₁ (tl≤u ia ib))
        , ≤-<-trans (x≤xh ia ib) (<-≤-trans c₂ (neg-mono-≤ (u≤th ia ib))))
... | no _ = unknown , tt

-- The plain three-valued verdict and its soundness statement.
verdict : Box → Box → Verdict
verdict A B = proj₁ (classifyU A B)

verdict-sound : ∀ A B → Holds A B (verdict A B)
verdict-sound A B = proj₂ (classifyU A B)

------------------------------------------------------------------------
-- Sanity computations (checked by normalisation)

private
  pt : ℤ → ℤ → Box
  pt t x = box t t x x

open import Data.Integer using (+_)

-- origin vs (t=10, x=±1 uncertainty): surely future-timelike
ex-future : verdict (pt +0 +0) (box (+ 10) (+ 11) (- (+ 1)) (+ 1)) ≡ timelike-future
ex-future = refl

-- origin vs (t=1, x=10): surely space-like
ex-space : verdict (pt +0 +0) (pt (+ 1) (+ 10)) ≡ spacelike
ex-space = refl

-- box straddling the light cone: unknown
ex-unknown : verdict (pt +0 +0) (box (+ 5) (+ 5) (+ 4) (+ 6)) ≡ unknown
ex-unknown = refl
