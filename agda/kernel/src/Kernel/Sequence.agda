-- Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
-- JWST-LRD Sovereign Scientific Runtime -- formal verification kernel (Agda).
-- Dual-licensed, intentionally: AGPL-3.0-only AND SnapKitty Opaque License.
-- SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
--
-- Module boundary: VERIFIED CORE (--safe --without-K). No postulates.
--
-- Strictly monotone sequences.  Representation: newest element first;
-- the invariant `Desc` says each element is strictly greater than the
-- one recorded before it (chronologically strictly increasing).
-- MonoSeq is proof-carrying (the invariant is a field), so it needs no
-- hidden constructor: any value of the type is monotone by typing.
{-# OPTIONS --safe --without-K #-}
module Kernel.Sequence where

open import Data.Nat.Base using (ℕ; _<_)
open import Data.Nat.Properties using (_<?_; <-trans)
open import Data.List.Base using (List; []; _∷_; length)
open import Data.List.Relation.Unary.All using (All; []; _∷_)
open import Data.Product.Base using (Σ; _,_; proj₁; proj₂)
open import Data.Unit.Base using (⊤)
open import Data.Empty using (⊥-elim)
open import Relation.Nullary using (yes; no; ¬_)
open import Relation.Binary.PropositionalEquality using (_≡_; refl; cong)
open import Kernel.Decision

data Desc : List ℕ → Set where
  []   : Desc []
  [_]  : ∀ x → Desc (x ∷ [])
  cons : ∀ {x y xs} → x < y → Desc (x ∷ xs) → Desc (y ∷ x ∷ xs)

MonoSeq : Set
MonoSeq = Σ (List ℕ) Desc

elems : MonoSeq → List ℕ
elems = proj₁

empty : MonoSeq
empty = [] , []

-- Head-below relation used by the checker.
Fresh : ℕ → List ℕ → Set
Fresh x []      = ⊤
Fresh x (y ∷ _) = y < x

tryAppend : MonoSeq → ℕ → Outcome MonoSeq
tryAppend ([] , [])        x = accept (x ∷ [] , [ x ])
tryAppend (y ∷ ys , d)     x with y <? x
... | yes y<x = accept (x ∷ y ∷ ys , cons y<x d)
... | no  _   = reject not-monotone

-- Accepted appends put x on top of the old sequence.
append-shape : ∀ s x {s′} → tryAppend s x ≡ accept s′ → elems s′ ≡ x ∷ elems s
append-shape ([] , [])    x refl = refl
append-shape (y ∷ ys , d) x eq with y <? x
append-shape (y ∷ ys , d) x refl | yes _ = refl
append-shape (y ∷ ys , d) x ()   | no _

-- Every append with a fresh value is accepted.
append-complete : ∀ s x → Fresh x (elems s) → Σ MonoSeq λ s′ → tryAppend s x ≡ accept s′
append-complete ([] , [])    x _   = _ , refl
append-complete (y ∷ ys , d) x y<x with y <? x
... | yes _  = _ , refl
... | no ¬p  = ⊥-elim (¬p y<x)

-- A rejected append was genuinely non-monotone, and leaves the state unchanged.
append-reject-reason : ∀ s x {r} → tryAppend s x ≡ reject r → ¬ Fresh x (elems s)
append-reject-reason ([] , [])    x ()
append-reject-reason (y ∷ ys , d) x eq with y <? x
append-reject-reason (y ∷ ys , d) x () | yes _
append-reject-reason (y ∷ ys , d) x eq | no ¬p = ¬p

append-reject-unchanged : ∀ s x {r} → tryAppend s x ≡ reject r → settle s (tryAppend s x) ≡ s
append-reject-unchanged s x eq = reject-preserves s eq

-- Global consequence of the local invariant: the newest element
-- strictly dominates *every* earlier element.
desc-dominates : ∀ {x xs} → Desc (x ∷ xs) → All (_< x) xs
desc-dominates [ x ]          = []
desc-dominates (cons x<y d)   = x<y ∷ weaken x<y (desc-dominates d)
  where
  weaken : ∀ {a b zs} → a < b → All (_< a) zs → All (_< b) zs
  weaken a<b []         = []
  weaken a<b (z<a ∷ ps) = <-trans z<a a<b ∷ weaken a<b ps

-- Committing any decision preserves monotonicity: trivially by typing,
-- stated explicitly for the proof-status table.
settle-monotone : ∀ s x → Desc (elems (settle s (tryAppend s x)))
settle-monotone s x with tryAppend s x
... | accept (_ , d) = d
... | reject _       = proj₂ s
