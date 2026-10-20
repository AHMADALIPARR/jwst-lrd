{-# OPTIONS --safe --without-K #-}
-- Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
-- Dual-licensed: AGPL-3.0-or-later plus SnapKitty Opaque License.
-- SPDX-License-Identifier: AGPL-3.0-or-later AND LicenseRef-SnapKitty-Opaque
--
-- JWST-LRD Sovereign Scientific Runtime -- TASK 011: Agda verified core.
-- Obligation group BND: boundary of a boundary is zero -- proved IN GENERAL (every dimension,
-- every finite integer chain), not by bounded computation.
--
-- Model: an (ordered) simplex is a list of vertex labels (ℕ); the empty list is the (-1)-simplex
-- of the augmented complex. A chain is a finite formal ℤ-linear combination, represented as a list
-- of (coefficient, simplex) pairs; two chains are equal as chains when they have the same
-- coefficient on every simplex (`eval`). The boundary of a simplex is the textbook alternating
-- sum of its codimension-1 faces,
--     ∂ [v₀,…,vₙ] = Σᵢ (−1)ⁱ [v₀,…,v̂ᵢ,…,vₙ]          (`∂-standard` proves this form),
-- and ∂ is extended linearly to chains (`∂c`).
--
-- Main theorems:
--   ∂∂-simplex : ∀ σ τ → eval (∂c (∂ σ)) τ ≡ 0
--   ∂∂≡0       : ∀ c τ → eval (∂c (∂c c)) τ ≡ 0
-- The proof uses the cone recursion ∂(v ∷ σ) = σ − v·∂σ and induction on σ.
-- Note: the theorem holds for arbitrary vertex lists (no sortedness / distinctness needed); the
-- augmented convention means ∂ of a 0-simplex is the empty simplex with coefficient 1.

module Core.Boundary where

open import Data.Nat using (ℕ; zero; suc)
import Data.Nat.Properties as ℕP
open import Data.Integer using (ℤ; _+_; _*_; _-_; -_; 0ℤ; 1ℤ; -1ℤ)
open import Data.Integer.Solver using (module +-*-Solver)
open import Data.List using (List; []; _∷_; _++_; map; length)
open import Data.List.Properties using (≡-dec; ∷-injectiveˡ; ∷-injectiveʳ; map-∘)
open import Data.Product using (_×_; _,_)
open import Data.Empty using (⊥-elim)
open import Function using (_∘_)
open import Relation.Nullary using (Dec; yes; no; ¬_)
open import Relation.Binary.PropositionalEquality

open +-*-Solver using (solve; _:=_; _:+_; _:-_; _:*_; con)

Simplex : Set
Simplex = List ℕ

_≟s_ : (σ τ : Simplex) → Dec (σ ≡ τ)
_≟s_ = ≡-dec ℕP._≟_

Chain : Set
Chain = List (ℤ × Simplex)

scale : ℤ → Chain → Chain
scale k = map (λ { (c , σ) → (k * c , σ) })

neg : Chain → Chain
neg = scale -1ℤ

cone : ℕ → Chain → Chain
cone v = map (λ { (c , σ) → (c , v ∷ σ) })

-- codimension-1 faces, i-th entry = σ with its i-th vertex deleted
faces : Simplex → List Simplex
faces []      = []
faces (v ∷ σ) = σ ∷ map (v ∷_) (faces σ)

-- alternating signs +,−,+,…
alt : List Simplex → Chain
alt []       = []
alt (τ ∷ τs) = (1ℤ , τ) ∷ neg (alt τs)

∂ : Simplex → Chain
∂ σ = alt (faces σ)

∂c : Chain → Chain
∂c []            = []
∂c ((k , σ) ∷ c) = scale k (∂ σ) ++ ∂c c

-- coefficient of simplex τ in a chain
pick : ∀ {A : Set} → Dec A → ℤ → ℤ
pick (yes _) k = k
pick (no _)  _ = 0ℤ

eval : Chain → Simplex → ℤ
eval []            τ = 0ℤ
eval ((k , σ) ∷ c) τ = pick (σ ≟s τ) k + eval c τ

------------------------------------------------------------------------
-- The alternating-sum form is the textbook one

deleteAt : Simplex → ℕ → Simplex
deleteAt []      _       = []
deleteAt (v ∷ σ) zero    = σ
deleteAt (v ∷ σ) (suc i) = v ∷ deleteAt σ i

idxs : ℕ → List ℕ
idxs zero    = []
idxs (suc n) = zero ∷ map suc (idxs n)

sign : ℕ → ℤ
sign zero    = 1ℤ
sign (suc i) = -1ℤ * sign i

altS : ℕ → List Simplex → Chain
altS i []       = []
altS i (τ ∷ τs) = (sign i , τ) ∷ altS (suc i) τs

faces-standard : ∀ σ → faces σ ≡ map (deleteAt σ) (idxs (length σ))
faces-standard []      = refl
faces-standard (v ∷ σ) = cong (σ ∷_) (begin
  map (v ∷_) (faces σ)                                 ≡⟨ cong (map (v ∷_)) (faces-standard σ) ⟩
  map (v ∷_) (map (deleteAt σ) (idxs (length σ)))      ≡⟨ sym (map-∘ (idxs (length σ))) ⟩
  map (λ i → v ∷ deleteAt σ i) (idxs (length σ))       ≡⟨ map-∘ (idxs (length σ)) ⟩
  map (deleteAt (v ∷ σ)) (map suc (idxs (length σ)))   ∎)
  where open ≡-Reasoning

altS-suc : ∀ i τs → altS (suc i) τs ≡ neg (altS i τs)
altS-suc i []       = refl
altS-suc i (τ ∷ τs) = cong ((sign (suc i) , τ) ∷_) (altS-suc (suc i) τs)

alt-standard : ∀ τs → alt τs ≡ altS 0 τs
alt-standard []       = refl
alt-standard (τ ∷ τs) = cong ((1ℤ , τ) ∷_) (trans (cong neg (alt-standard τs)) (sym (altS-suc 0 τs)))

-- ∂ [v₀,…,vₙ] = Σᵢ (−1)ⁱ [v₀,…,v̂ᵢ,…,vₙ]
∂-standard : ∀ σ → ∂ σ ≡ altS 0 (map (deleteAt σ) (idxs (length σ)))
∂-standard σ = trans (alt-standard (faces σ)) (cong (altS 0) (faces-standard σ))

------------------------------------------------------------------------
-- Syntactic lemmas

neg-cone : ∀ v c → neg (cone v c) ≡ cone v (neg c)
neg-cone v []            = refl
neg-cone v ((k , σ) ∷ c) = cong ((-1ℤ * k , v ∷ σ) ∷_) (neg-cone v c)

scale-cone : ∀ k v c → scale k (cone v c) ≡ cone v (scale k c)
scale-cone k v []            = refl
scale-cone k v ((j , σ) ∷ c) = cong ((k * j , v ∷ σ) ∷_) (scale-cone k v c)

cone-++ : ∀ v c d → cone v (c ++ d) ≡ cone v c ++ cone v d
cone-++ v []      d = refl
cone-++ v (x ∷ c) d = cong (_ ∷_) (cone-++ v c d)

alt-cone : ∀ v τs → alt (map (v ∷_) τs) ≡ cone v (alt τs)
alt-cone v []       = refl
alt-cone v (τ ∷ τs) = cong ((1ℤ , v ∷ τ) ∷_)
  (trans (cong neg (alt-cone v τs)) (neg-cone v (alt τs)))

-- cone recursion: ∂ (v ∷ σ) = σ − v·∂σ
∂-cons : ∀ v σ → ∂ (v ∷ σ) ≡ (1ℤ , σ) ∷ neg (cone v (∂ σ))
∂-cons v σ = cong ((1ℤ , σ) ∷_) (cong neg (alt-cone v (faces σ)))

++-assoc′ : ∀ (a b c : Chain) → (a ++ b) ++ c ≡ a ++ (b ++ c)
++-assoc′ []      b c = refl
++-assoc′ (x ∷ a) b c = cong (x ∷_) (++-assoc′ a b c)

∂c-++ : ∀ c d → ∂c (c ++ d) ≡ ∂c c ++ ∂c d
∂c-++ []            d = refl
∂c-++ ((k , σ) ∷ c) d =
  trans (cong (scale k (∂ σ) ++_) (∂c-++ c d)) (sym (++-assoc′ (scale k (∂ σ)) (∂c c) (∂c d)))

------------------------------------------------------------------------
-- Evaluation lemmas

pick-cong : ∀ {A B : Set} → (A → B) → (B → A) → (d : Dec A) (e : Dec B) (k : ℤ) → pick d k ≡ pick e k
pick-cong f g (yes _) (yes _) k = refl
pick-cong f g (yes a) (no ¬b) k = ⊥-elim (¬b (f a))
pick-cong f g (no ¬a) (yes b) k = ⊥-elim (¬a (g b))
pick-cong f g (no _)  (no _)  k = refl

pick-no : ∀ {A : Set} → ¬ A → (d : Dec A) (k : ℤ) → pick d k ≡ 0ℤ
pick-no ¬a (yes a) k = ⊥-elim (¬a a)
pick-no ¬a (no _)  k = refl

pick-scale : ∀ {A : Set} (d : Dec A) k j → pick d (k * j) ≡ k * pick d j
pick-scale (yes _) k j = refl
pick-scale (no _)  k j = solve 1 (λ k → con 0ℤ := k :* con 0ℤ) refl k

pick-1 : ∀ {A : Set} (d : Dec A) k → pick d k ≡ pick d 1ℤ * k
pick-1 (yes _) k = sym (solve 1 (λ k → con 1ℤ :* k := k) refl k)
pick-1 (no _)  k = refl

eval-++ : ∀ c d τ → eval (c ++ d) τ ≡ eval c τ + eval d τ
eval-++ []            d τ = sym (solve 1 (λ e → con 0ℤ :+ e := e) refl (eval d τ))
eval-++ ((k , σ) ∷ c) d τ rewrite eval-++ c d τ =
  solve 3 (λ p a b → p :+ (a :+ b) := (p :+ a) :+ b) refl (pick (σ ≟s τ) k) (eval c τ) (eval d τ)

eval-scale : ∀ k c τ → eval (scale k c) τ ≡ k * eval c τ
eval-scale k []            τ = solve 1 (λ k → con 0ℤ := k :* con 0ℤ) refl k
eval-scale k ((j , σ) ∷ c) τ rewrite eval-scale k c τ | pick-scale (σ ≟s τ) k j =
  solve 3 (λ k p e → k :* p :+ k :* e := k :* (p :+ e)) refl k (pick (σ ≟s τ) j) (eval c τ)

eval-cone-nil : ∀ v c → eval (cone v c) [] ≡ 0ℤ
eval-cone-nil v []            = refl
eval-cone-nil v ((k , σ) ∷ c) rewrite eval-cone-nil v c | pick-no (λ ()) ((v ∷ σ) ≟s []) k = refl

eval-cone-same : ∀ v c τ → eval (cone v c) (v ∷ τ) ≡ eval c τ
eval-cone-same v []            τ = refl
eval-cone-same v ((k , σ) ∷ c) τ
  rewrite eval-cone-same v c τ
        | pick-cong ∷-injectiveʳ (cong (v ∷_)) ((v ∷ σ) ≟s (v ∷ τ)) (σ ≟s τ) k = refl

eval-cone-diff : ∀ v w c τ → ¬ v ≡ w → eval (cone v c) (w ∷ τ) ≡ 0ℤ
eval-cone-diff v w []            τ ne = refl
eval-cone-diff v w ((k , σ) ∷ c) τ ne
  rewrite eval-cone-diff v w c τ ne
        | pick-no (λ eq → ne (∷-injectiveˡ eq)) ((v ∷ σ) ≟s (w ∷ τ)) k = refl

cone-zero : ∀ v c → (∀ τ → eval c τ ≡ 0ℤ) → ∀ τ → eval (cone v c) τ ≡ 0ℤ
cone-zero v c z []      = eval-cone-nil v c
cone-zero v c z (w ∷ τ) with v ℕP.≟ w
... | yes refl = trans (eval-cone-same v c τ) (z τ)
... | no ne    = eval-cone-diff v w c τ ne

-- ∂ commutes with scaling (as chains)
∂c-scale : ∀ k c τ → eval (∂c (scale k c)) τ ≡ k * eval (∂c c) τ
∂c-scale k []            τ = solve 1 (λ k → con 0ℤ := k :* con 0ℤ) refl k
∂c-scale k ((j , σ) ∷ c) τ
  rewrite eval-++ (scale (k * j) (∂ σ)) (∂c (scale k c)) τ
        | eval-++ (scale j (∂ σ)) (∂c c) τ
        | eval-scale (k * j) (∂ σ) τ
        | eval-scale j (∂ σ) τ
        | ∂c-scale k c τ =
  solve 4 (λ k j e r → (k :* j) :* e :+ k :* r := k :* (j :* e :+ r)) refl
    k j (eval (∂ σ) τ) (eval (∂c c) τ)

-- ∂ of a cone: ∂(v·c) = c − v·∂c   (as chains)
∂c-cone : ∀ v c τ → eval (∂c (cone v c)) τ ≡ eval c τ - eval (cone v (∂c c)) τ
∂c-cone v []            τ = refl
∂c-cone v ((k , σ) ∷ c) τ = begin
  eval (scale k (∂ (v ∷ σ)) ++ ∂c (cone v c)) τ
    ≡⟨ eval-++ (scale k (∂ (v ∷ σ))) (∂c (cone v c)) τ ⟩
  eval (scale k (∂ (v ∷ σ))) τ + eval (∂c (cone v c)) τ
    ≡⟨ cong₂ _+_ (eval-scale k (∂ (v ∷ σ)) τ) (∂c-cone v c τ) ⟩
  k * eval (∂ (v ∷ σ)) τ + (E - D)
    ≡⟨ cong (λ z → k * eval z τ + (E - D)) (∂-cons v σ) ⟩
  k * (P1 + eval (scale -1ℤ (cone v (∂ σ))) τ) + (E - D)
    ≡⟨ cong (λ z → k * (P1 + z) + (E - D)) (eval-scale -1ℤ (cone v (∂ σ)) τ) ⟩
  k * (P1 + -1ℤ * B) + (E - D)
    ≡⟨ solve 5 (λ k p b e d → k :* (p :+ con -1ℤ :* b) :+ (e :- d) := (p :* k :+ e) :- (k :* b :+ d))
         refl k P1 B E D ⟩
  (P1 * k + E) - (k * B + D)
    ≡⟨ cong₂ (λ y z → (y + E) - (z + D)) (sym (pick-1 (σ ≟s τ) k)) (sym kB) ⟩
  (pick (σ ≟s τ) k + E) - (eval (cone v (scale k (∂ σ))) τ + D)
    ≡⟨ cong (λ z → (pick (σ ≟s τ) k + E) - z) (sym (eval-++ (cone v (scale k (∂ σ))) (cone v (∂c c)) τ)) ⟩
  (pick (σ ≟s τ) k + E) - eval (cone v (scale k (∂ σ)) ++ cone v (∂c c)) τ
    ≡⟨ cong (λ z → (pick (σ ≟s τ) k + E) - eval z τ) (sym (cone-++ v (scale k (∂ σ)) (∂c c))) ⟩
  (pick (σ ≟s τ) k + E) - eval (cone v (scale k (∂ σ) ++ ∂c c)) τ ∎
  where
  open ≡-Reasoning
  P1 = pick (σ ≟s τ) 1ℤ
  B  = eval (cone v (∂ σ)) τ
  E  = eval c τ
  D  = eval (cone v (∂c c)) τ
  kB : eval (cone v (scale k (∂ σ))) τ ≡ k * B
  kB = trans (cong (λ z → eval z τ) (sym (scale-cone k v (∂ σ)))) (eval-scale k (cone v (∂ σ)) τ)

------------------------------------------------------------------------
-- Main theorems

∂∂-simplex : ∀ σ τ → eval (∂c (∂ σ)) τ ≡ 0ℤ
∂∂-simplex []      τ = refl
∂∂-simplex (v ∷ σ) τ = begin
  eval (∂c (∂ (v ∷ σ))) τ
    ≡⟨ cong (λ z → eval (∂c z) τ) (∂-cons v σ) ⟩
  eval (scale 1ℤ (∂ σ) ++ ∂c (scale -1ℤ (cone v (∂ σ)))) τ
    ≡⟨ eval-++ (scale 1ℤ (∂ σ)) (∂c (scale -1ℤ (cone v (∂ σ)))) τ ⟩
  eval (scale 1ℤ (∂ σ)) τ + eval (∂c (scale -1ℤ (cone v (∂ σ)))) τ
    ≡⟨ cong₂ _+_ (eval-scale 1ℤ (∂ σ) τ) (∂c-scale -1ℤ (cone v (∂ σ)) τ) ⟩
  1ℤ * S + -1ℤ * eval (∂c (cone v (∂ σ))) τ
    ≡⟨ cong (λ z → 1ℤ * S + -1ℤ * z) (∂c-cone v (∂ σ) τ) ⟩
  1ℤ * S + -1ℤ * (S - eval (cone v (∂c (∂ σ))) τ)
    ≡⟨ cong (λ z → 1ℤ * S + -1ℤ * (S - z)) (cone-zero v (∂c (∂ σ)) (∂∂-simplex σ) τ) ⟩
  1ℤ * S + -1ℤ * (S - 0ℤ)
    ≡⟨ solve 1 (λ e → con 1ℤ :* e :+ con -1ℤ :* (e :- con 0ℤ) := con 0ℤ) refl S ⟩
  0ℤ ∎
  where
  open ≡-Reasoning
  S = eval (∂ σ) τ
∂∂≡0 : ∀ c τ → eval (∂c (∂c c)) τ ≡ 0ℤ
∂∂≡0 []            τ = refl
∂∂≡0 ((k , σ) ∷ c) τ
  rewrite ∂c-++ (scale k (∂ σ)) (∂c c)
        | eval-++ (∂c (scale k (∂ σ))) (∂c (∂c c)) τ
        | ∂c-scale k (∂ σ) τ
        | ∂∂-simplex σ τ
        | ∂∂≡0 c τ =
  solve 1 (λ k → k :* con 0ℤ :+ con 0ℤ := con 0ℤ) refl k

------------------------------------------------------------------------
-- Sanity computations (checked by normalisation, not needed for the theorems)

faces-tetra : faces (0 ∷ 1 ∷ 2 ∷ 3 ∷ []) ≡
  (1 ∷ 2 ∷ 3 ∷ []) ∷ (0 ∷ 2 ∷ 3 ∷ []) ∷ (0 ∷ 1 ∷ 3 ∷ []) ∷ (0 ∷ 1 ∷ 2 ∷ []) ∷ []
faces-tetra = refl
