{-# OPTIONS --safe --without-K #-}
-- Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
-- Dual-licensed: AGPL-3.0-or-later plus SnapKitty Opaque License.
-- SPDX-License-Identifier: AGPL-3.0-or-later AND LicenseRef-SnapKitty-Opaque
--
-- JWST-LRD Sovereign Scientific Runtime -- TASK 011: Agda verified core.
-- Obligation group PRE: accepted-state preservation, by induction over runs of the
-- LRD-STATE-v1 machine (Core.State.Machine).
--
--   run-preserves     : any predicate that holds initially and is preserved by every ACCEPTED
--                       transition holds after any run (rejections leave the state unchanged)
--   run-reachable     : the state after any run from genesis is Reachable (built only from
--                       genesis by accepted transitions)
--   reachable-genesis-commit : a reachable state with seq 0 is genesis-shaped (commit = 64 zeros)
--   trace-linked      : in the list of accepted states of any run, each state's seq is the
--                       predecessor's seq + 1 and its commit is the predecessor's commitment
--   trace-consecutive / trace-increasing : the seq numbers along any run are exactly
--                       s₀, s₀+1, s₀+2, ... and hence strictly increasing (Core.Sequence)

open import Data.Nat using (ℕ; suc)
open import Relation.Nullary using (Dec)
open import Core.State

module Core.Preservation
  (commitOf   : State → Digest)
  (KindOK     : State → Proposal → Set)
  (kindOK?    : ∀ s p → Dec (KindOK s p))
  (kindReason : State → Proposal → Reason)
  (g-kind     : Kind)
  (g-payload  : Digest)
  where

open import Data.List using (List; []; _∷_; map)
open import Data.List.Relation.Unary.Linked using (Linked; []; [-]; _∷_)
open import Data.Product using (_×_; _,_)
open import Data.Empty using (⊥-elim)
open import Relation.Binary.PropositionalEquality
open import Data.Nat.Properties using (suc-injective)
open import Core.Sequence using (Consecutive; Incr; consecutive⇒incr)
import Core.Sequence as Seq

open Machine commitOf KindOK kindOK? kindReason g-kind g-payload public

apply : State → Result → State
apply s (accepted s′ _) = s′
apply s (rejected _)    = s

run : State → List Proposal → State
run s []       = s
run s (p ∷ ps) = run (apply s (step s p)) ps

------------------------------------------------------------------------
-- Generic preservation by induction over runs

Preserved : (State → Set) → Set
Preserved P = ∀ s p → P s → Accepts s p → P (next s p)

step-preserves : ∀ P → Preserved P → ∀ s p → P s → P (apply s (step s p))
step-preserves P pres s p Ps with step s p in eq
... | rejected _    = Ps
... | accepted s′ c with step-sound s p eq
...   | acc , refl , _ = pres s p Ps acc

run-preserves : ∀ P → Preserved P → ∀ s ps → P s → P (run s ps)
run-preserves P pres s []       Ps = Ps
run-preserves P pres s (p ∷ ps) Ps =
  run-preserves P pres (apply s (step s p)) ps (step-preserves P pres s p Ps)

------------------------------------------------------------------------
-- Reachability

data Reachable : State → Set where
  gen : Reachable genesis
  ext : ∀ {s p} → Reachable s → Accepts s p → Reachable (next s p)

run-reachable : ∀ ps → Reachable (run genesis ps)
run-reachable ps = run-preserves Reachable (λ s p r a → ext r a) genesis ps gen

-- Every reachable state with seq 0 is genesis; every other reachable state's seq is positive
reachable-genesis-commit : ∀ {s} → Reachable s → State.seq s ≡ 0 → State.commit s ≡ zeros
reachable-genesis-commit gen           _  = refl
reachable-genesis-commit (ext {s} {p} r (a , _)) eq with trans (sym a) eq
... | ()

------------------------------------------------------------------------
-- Traces of accepted states

Link : State → State → Set
Link a b = (State.seq b ≡ suc (State.seq a)) × (State.commit b ≡ commitOf a)

traceTail : State → List Proposal → List State
traceTail s []       = []
traceTail s (p ∷ ps) with step s p
... | accepted s′ _ = s′ ∷ traceTail s′ ps
... | rejected _    = traceTail s ps

trace : State → List Proposal → List State
trace s ps = s ∷ traceTail s ps

trace-linked : ∀ s ps → Linked Link (trace s ps)
trace-linked s []       = [-]
trace-linked s (p ∷ ps) with step s p in eq
... | rejected _    = trace-linked s ps
... | accepted s′ c with step-sound s p eq
...   | (a , _ , _) , refl , _ = (a , refl) ∷ trace-linked (next s p) ps

linked⇒consecutive : ∀ {x xs} → Linked Link (x ∷ xs) → Consecutive (State.seq x) (map State.seq (x ∷ xs))
linked⇒consecutive {x} {[]}     _               = State.seq x Seq.∷ Seq.[]
linked⇒consecutive {x} {y ∷ ys} ((e , _) ∷ rest) rewrite sym e =
  State.seq x Seq.∷ subst (λ n → Consecutive n (map State.seq (y ∷ ys))) e (linked⇒consecutive rest)

trace-consecutive : ∀ s ps → Consecutive (State.seq s) (map State.seq (trace s ps))
trace-consecutive s ps = linked⇒consecutive (trace-linked s ps)

trace-increasing : ∀ s ps → Incr (map State.seq (trace s ps))
trace-increasing s ps = consecutive⇒incr (trace-consecutive s ps)
