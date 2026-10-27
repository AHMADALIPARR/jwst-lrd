{-# OPTIONS --safe --without-K #-}
-- Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
-- Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
-- SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
--
-- JWST-LRD Sovereign Scientific Runtime -- TASK 011: Agda verified core.
-- Obligation group SEQ: sequence monotonicity.
--   * `Incr xs`  : xs is strictly increasing between neighbours (decidable, sound, complete);
--   * `incr⇒pairwise` : neighbour-wise strict increase implies every earlier element is strictly
--     below every later element (no duplicates, no rollback anywhere in the list);
--   * `Consecutive n xs` : xs is exactly n, n+1, n+2, ... (the LRD-STATE-v1 rule seq = prev+1);
--     consecutive lists are strictly increasing;
--   * snoc lemma: appending a value above the last element preserves `Incr`.

module Core.Sequence where

open import Data.Nat using (ℕ; zero; suc; _<_; _<?_)
open import Data.Nat.Properties using (<-trans; n<1+n)
open import Data.List using (List; []; _∷_; _++_; [_])
open import Data.List.Relation.Unary.Linked as Linked using (Linked; []; [-]; _∷_)
open import Data.List.Relation.Unary.Linked.Properties using (Linked⇒AllPairs)
open import Data.List.Relation.Unary.AllPairs using (AllPairs)
open import Data.Bool using (Bool; T)
open import Relation.Nullary using (Dec)
open import Relation.Nullary.Decidable using (⌊_⌋; toWitness; fromWitness)

Incr : List ℕ → Set
Incr = Linked _<_

incr-dec : (xs : List ℕ) → Dec (Incr xs)
incr-dec = Linked.linked? _<?_

incr? : List ℕ → Bool
incr? xs = ⌊ incr-dec xs ⌋

incr?-sound : ∀ xs → T (incr? xs) → Incr xs
incr?-sound xs = toWitness

incr?-complete : ∀ xs → Incr xs → T (incr? xs)
incr?-complete xs = fromWitness

-- Neighbour-wise increase gives global pairwise strict increase (by transitivity of _<_).
incr⇒pairwise : ∀ {xs} → Incr xs → AllPairs _<_ xs
incr⇒pairwise = Linked⇒AllPairs <-trans

-- Exactly consecutive sequence numbers starting at n.
data Consecutive : ℕ → List ℕ → Set where
  []  : ∀ {n} → Consecutive n []
  _∷_ : ∀ {xs} n → Consecutive (suc n) xs → Consecutive n (n ∷ xs)

consecutive⇒incr : ∀ {n xs} → Consecutive n xs → Incr xs
consecutive⇒incr []                  = []
consecutive⇒incr (n ∷ [])            = [-]
consecutive⇒incr (n ∷ c@(._ ∷ _))    = n<1+n n ∷ consecutive⇒incr c

-- Appending above the last element preserves strict increase.
data Last : List ℕ → ℕ → Set where
  here  : ∀ {x} → Last [ x ] x
  there : ∀ {x y ys l} → Last (y ∷ ys) l → Last (x ∷ y ∷ ys) l

incr-snoc : ∀ {xs l y} → Incr xs → Last xs l → l < y → Incr (xs ++ [ y ])
incr-snoc [-]        here      l<y = l<y ∷ [-]
incr-snoc (p ∷ rest) (there t) l<y = p ∷ incr-snoc rest t l<y

incr-snoc-[] : ∀ {y} → Incr ([] ++ [ y ])
incr-snoc-[] = [-]
