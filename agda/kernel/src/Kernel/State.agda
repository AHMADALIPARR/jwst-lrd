-- Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
-- JWST-LRD Sovereign Scientific Runtime -- formal verification kernel (Agda).
-- Dual-licensed, intentionally: AGPL-3.0-only AND SnapKitty Opaque License.
-- SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
--
-- Module boundary: VERIFIED CORE (--safe --without-K). No postulates.
--
-- Kernel mirror of LRD-STATE-v1 (research/CONTRACTS.md v1.1;
-- ledger/abi/lrd_state.h on branch t004-ledger).  This is the
-- kernel's OWN mirror, kept for later reconciliation with
-- agda/Core/State.agda (owned by the agda track; not present at the
-- time of writing).  Field names follow the ABI:
--   state    = seq, commit, kind, payload_sha256
--   proposal = kind, prev_commit, seq, payload_sha256
--   decision = ACCEPT (reason ok, new_commit) | REJECT (reason)
-- The digest type and the commitment function are parameters: the
-- real system uses SHA-256 over "LRD-COMMIT-v1\0" || LRD-REC-v1 bytes.
{-# OPTIONS --safe --without-K #-}
open import Relation.Binary.Definitions using (DecidableEquality)
module Kernel.State (Digest : Set) (_≟D_ : DecidableEquality Digest) where

open import Data.Nat.Base using (ℕ; zero; suc; _≤_; _<_; s≤s; z≤n)
open import Data.Nat.Properties as ℕP using (≤-refl; ≤-trans; n≤1+n; <-irrefl; m<n⇒m<1+n)
open import Data.String.Base using (String)
open import Data.Product.Base using (_×_; _,_; Σ)
open import Data.Empty using (⊥-elim)
open import Relation.Nullary using (yes; no; ¬_)
open import Relation.Binary.PropositionalEquality
open import Kernel.Decision
open import Kernel.Assumptions.Crypto using (CollisionResistant)

data Kind : Set where
  observation ledger-append hamiltonian-step capability air-proof : Kind

kindToken : Kind → String
kindToken observation      = "observation"
kindToken ledger-append    = "ledger_append"
kindToken hamiltonian-step = "hamiltonian_step"
kindToken capability       = "capability"
kindToken air-proof        = "air_proof"

_≟K_ : DecidableEquality Kind
observation      ≟K observation      = yes refl
ledger-append    ≟K ledger-append    = yes refl
hamiltonian-step ≟K hamiltonian-step = yes refl
capability       ≟K capability       = yes refl
air-proof        ≟K air-proof        = yes refl
observation      ≟K ledger-append    = no λ ()
observation      ≟K hamiltonian-step = no λ ()
observation      ≟K capability       = no λ ()
observation      ≟K air-proof        = no λ ()
ledger-append    ≟K observation      = no λ ()
ledger-append    ≟K hamiltonian-step = no λ ()
ledger-append    ≟K capability       = no λ ()
ledger-append    ≟K air-proof        = no λ ()
hamiltonian-step ≟K observation      = no λ ()
hamiltonian-step ≟K ledger-append    = no λ ()
hamiltonian-step ≟K capability       = no λ ()
hamiltonian-step ≟K air-proof        = no λ ()
capability       ≟K observation      = no λ ()
capability       ≟K ledger-append    = no λ ()
capability       ≟K hamiltonian-step = no λ ()
capability       ≟K air-proof        = no λ ()
air-proof        ≟K observation      = no λ ()
air-proof        ≟K ledger-append    = no λ ()
air-proof        ≟K hamiltonian-step = no λ ()
air-proof        ≟K capability       = no λ ()

record LrdState : Set where
  constructor lrdState
  field
    seq           : ℕ
    commit        : Digest   -- commitment of the previous state (zeros at genesis)
    kind          : Kind
    payloadSha256 : Digest
open LrdState public

record Proposal : Set where
  constructor proposal
  field
    pKind          : Kind
    prevCommit     : Digest
    pSeq           : ℕ
    pPayloadSha256 : Digest
open Proposal public

data DecisionRec : Set where
  ACCEPT : (newCommit : Digest) → DecisionRec   -- reason = ok
  REJECT : Reason → DecisionRec                 -- no new_commit, no state

module Transition (hash : LrdState → Digest) where

  -- CONTRACTS v1.1: new state record = {commit=<prev_commit>, kind, payload_sha256, seq};
  -- new_commit = hash of that record.  Kind-specific fields are not part of it.
  successor : LrdState → Proposal → LrdState
  successor _ p = lrdState (pSeq p) (prevCommit p) (pKind p) (pPayloadSha256 p)

  -- Envelope check: seq first (stale_seq), then prev_commit (bad_prev).
  decide : LrdState → Proposal → Outcome LrdState
  decide s p with pSeq p ℕP.≟ suc (seq s) | prevCommit p ≟D hash s
  ... | no _  | _     = reject stale-seq
  ... | yes _ | no _  = reject bad-prev
  ... | yes _ | yes _ = accept (successor s p)

  toDecision : Outcome LrdState → DecisionRec
  toDecision (accept s′) = ACCEPT (hash s′)
  toDecision (reject r)  = REJECT r

  decide-accept : ∀ s p {s′} → decide s p ≡ accept s′ →
    pSeq p ≡ suc (seq s) × prevCommit p ≡ hash s × s′ ≡ successor s p
  decide-accept s p eq with pSeq p ℕP.≟ suc (seq s) | prevCommit p ≟D hash s
  decide-accept s p refl | yes a | yes b = a , b , refl
  decide-accept s p ()   | no _  | _
  decide-accept s p ()   | yes _ | no _

  decide-seq : ∀ s p {s′} → decide s p ≡ accept s′ → seq s′ ≡ suc (seq s)
  decide-seq s p eq with decide-accept s p eq
  ... | a , _ , refl = a

  decide-reject-unchanged : ∀ s p {r} → decide s p ≡ reject r → settle s (decide s p) ≡ s
  decide-reject-unchanged s p eq = reject-preserves s eq

  -- Runs of accepted transitions.
  data Run : LrdState → LrdState → Set where
    done : ∀ {s} → Run s s
    step : ∀ {s s′ s″} p → decide s p ≡ accept s′ → Run s′ s″ → Run s s″

  run-seq : ∀ {s s′} → Run s s′ → seq s ≤ seq s′
  run-seq done           = ≤-refl
  run-seq (step p eq r)  = ≤-trans (n≤1+n _) (subst (_≤ _) (decide-seq _ p eq) (run-seq r))

  decide-stale : ∀ s p → ¬ pSeq p ≡ suc (seq s) → decide s p ≡ reject stale-seq
  decide-stale s p ne with pSeq p ℕP.≟ suc (seq s)
  ... | yes q = ⊥-elim (ne q)
  ... | no _  = refl

  -- NoReplay inside the model: a proposal accepted at s is rejected
  -- (stale_seq) at every state reachable from its successor.
  no-replay : ∀ s p {s′ s″} → decide s p ≡ accept s′ → Run s′ s″ → decide s″ p ≡ reject stale-seq
  no-replay s p {s′} {s″} eq r with decide-accept s p eq
  ... | _ , _ , refl = decide-stale s″ p λ q → <-irrefl refl (subst (_≤ seq s″) q (run-seq r))

  -- Fork freedom (uses the CRYPTO assumption, passed explicitly):
  -- two accepted successors of one proposal share their predecessor.
  no-fork : CollisionResistant hash → ∀ {s₁ s₂ t₁ t₂} p →
    decide s₁ p ≡ accept t₁ → decide s₂ p ≡ accept t₂ → s₁ ≡ s₂ × t₁ ≡ t₂
  no-fork cr {s₁} {s₂} p e₁ e₂ with decide-accept s₁ p e₁ | decide-accept s₂ p e₂
  ... | _ , h₁ , refl | _ , h₂ , refl with cr (trans (sym h₁) h₂)
  ...   | refl = refl , refl
