-- Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
-- JWST-LRD Sovereign Scientific Runtime -- formal verification kernel (Agda).
-- Dual-licensed, intentionally: AGPL-3.0-only AND SnapKitty Opaque License.
-- SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
--
-- Module boundary: VERIFIED CORE (--safe --without-K). No postulates.
--
-- Hamiltonian descent, abstracted.  The state space S and the energy
-- E : S → ℕ are parameters (energies are quantised naturals: no real
-- analysis, no symplectic structure, no integrator error is modelled).
-- The numeric kernel (fortran/, futhark/) proposes a next state; the
-- kernel's guard accepts it only if energy does not increase (weak
-- guard) or strictly decreases (strict guard, LRD reason
-- `energy_not_decreasing`).  Proved: one-step non-increase, monotone
-- energy along all guarded iterates, and that any strictly descending
-- run has length ≤ E s₀ (so strict descent terminates).
{-# OPTIONS --safe --without-K #-}
open import Data.Nat.Base using (ℕ)
module Kernel.Hamiltonian {S : Set} (E : S → ℕ) where

open import Data.Nat.Base using (ℕ; zero; suc; _+_; _∸_; _≤_; _<_; s≤s; z≤n)
open import Data.Nat.Properties using (_≤?_; _<?_; ≤-refl; ≤-trans; <⇒≤; m∸n+n≡m)
open import Data.List.Base using (List; []; _∷_; length)
open import Relation.Nullary using (yes; no)
open import Relation.Binary.PropositionalEquality using (_≡_; refl; subst)
open import Kernel.Decision
import Data.Bool.Base
open import Data.Product.Base using (Σ; _×_; _,_)

-- Weak guard: accept iff E s′ ≤ E s.
tryStep : S → S → Outcome S
tryStep s s′ with E s′ ≤? E s
... | yes _ = accept s′
... | no  _ = reject energy-not-decreasing

-- Strict guard: accept iff E s′ < E s.
tryStrict : S → S → Outcome S
tryStrict s s′ with E s′ <? E s
... | yes _ = accept s′
... | no  _ = reject energy-not-decreasing

step-nonincreasing : ∀ s s′ {s″} → tryStep s s′ ≡ accept s″ → E s″ ≤ E s
step-nonincreasing s s′ eq with E s′ ≤? E s
step-nonincreasing s s′ refl | yes p = p
step-nonincreasing s s′ ()   | no _

strict-decreasing : ∀ s s′ {s″} → tryStrict s s′ ≡ accept s″ → E s″ < E s
strict-decreasing s s′ eq with E s′ <? E s
strict-decreasing s s′ refl | yes p = p
strict-decreasing s s′ ()   | no _

-- The committed state never has higher energy, whatever the outcome.
settle-nonincreasing : ∀ s s′ → E (settle s (tryStep s s′)) ≤ E s
settle-nonincreasing s s′ with E s′ ≤? E s
... | yes p = p
... | no  _ = ≤-refl

commitStrict-nonincreasing : ∀ s s′ → E (settle s (tryStrict s s′)) ≤ E s
commitStrict-nonincreasing s s′ with E s′ <? E s
... | yes p = <⇒≤ p
... | no  _ = ≤-refl

-- Guarded iteration of an arbitrary (untrusted) proposal map.
module Iterate (propose : S → S) where
  next : S → S
  next s = settle s (tryStep s (propose s))

  iter : ℕ → S → S
  iter zero    s = s
  iter (suc n) s = next (iter n s)

  energy-step : ∀ n s → E (iter (suc n) s) ≤ E (iter n s)
  energy-step n s = settle-nonincreasing (iter n s) (propose (iter n s))

  energy-offset : ∀ k n s → E (iter (k + n) s) ≤ E (iter n s)
  energy-offset zero    n s = ≤-refl
  energy-offset (suc k) n s = ≤-trans (energy-step (k + n) s) (energy-offset k n s)

  -- Monotone energy along iterates: m ≤ n ⇒ E (iterₙ s) ≤ E (iterₘ s).
  energy-monotone : ∀ {m n} s → m ≤ n → E (iter n s) ≤ E (iter m s)
  energy-monotone {m} {n} s m≤n =
    subst (λ k → E (iter k s) ≤ E (iter m s)) (m∸n+n≡m m≤n) (energy-offset (n ∸ m) m s)

  energy-bounded : ∀ n s → E (iter n s) ≤ E s
  energy-bounded n s = energy-monotone {zero} {n} s z≤n

-- Strictly descending runs (s₀ > s₁ > … in energy) are short.
data StrictRun : S → List S → Set where
  []  : ∀ {s} → StrictRun s []
  _∷_ : ∀ {s s′ ss} → E s′ < E s → StrictRun s′ ss → StrictRun s (s′ ∷ ss)

strict-run-bound : ∀ {s ss} → StrictRun s ss → length ss ≤ E s
strict-run-bound []          = z≤n
strict-run-bound (lt ∷ run)  = ≤-trans (s≤s (strict-run-bound run)) lt

------------------------------------------------------------------------
-- Full LRD hamiltonian_step check, normative order (CONTRACTS v1.1):
--   1. epoch_exhausted (no remaining epoch budget),
--   2. infeasible      (proposal fails the feasibility predicate),
--   3. energy          (strict decrease, else energy_not_decreasing).
-- `feasible` is an untrusted, decidable predicate supplied by the
-- numeric track; only its Boolean result is used.

module Checked (feasible : S → Data.Bool.Base.Bool) where
  open Data.Bool.Base using (Bool; true; false)

  hamCheck : (budget : ℕ) → S → S → Outcome S
  hamCheck zero    s s′ = reject epoch-exhausted
  hamCheck (suc _) s s′ with feasible s′
  ... | false = reject infeasible
  ... | true  = tryStrict s s′

  order-epoch-first : ∀ s s′ → hamCheck zero s s′ ≡ reject epoch-exhausted
  order-epoch-first s s′ = refl

  order-infeasible-second : ∀ b s s′ → feasible s′ ≡ false → hamCheck (suc b) s s′ ≡ reject infeasible
  order-infeasible-second b s s′ eq with feasible s′
  order-infeasible-second b s s′ refl | false = refl

  order-energy-third : ∀ b s s′ → feasible s′ ≡ true → hamCheck (suc b) s s′ ≡ tryStrict s s′
  order-energy-third b s s′ eq with feasible s′
  order-energy-third b s s′ refl | true = refl

  hamCheck-accept : ∀ b s s′ {s″} → hamCheck b s s′ ≡ accept s″ →
                    Σ ℕ (λ b′ → b ≡ suc b′) × feasible s′ ≡ true × E s″ < E s
  hamCheck-accept zero    s s′ ()
  hamCheck-accept (suc b) s s′ eq with feasible s′
  hamCheck-accept (suc b) s s′ () | false
  hamCheck-accept (suc b) s s′ eq | true = (b , refl) , refl , strict-decreasing s s′ eq
