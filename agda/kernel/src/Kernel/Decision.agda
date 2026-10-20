-- Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
-- JWST-LRD Sovereign Scientific Runtime -- formal verification kernel (Agda).
-- Dual-licensed, intentionally: AGPL-3.0-only AND SnapKitty Opaque License.
-- SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
--
-- Module boundary: VERIFIED CORE (--safe --without-K). No postulates.
--
-- Decisions shared by all transition checkers, mirroring the
-- LRD-STATE-v1 decision record: ACCEPT carries the new state, REJECT
-- carries only a reason token.  A rejection therefore *cannot*
-- construct a new state: `settle s (reject r) = s` by definition, and
-- `reject` has no state argument at all.
{-# OPTIONS --safe --without-K #-}
module Kernel.Decision where

open import Data.String.Base using (String)
open import Data.Bool.Base using (Bool; true; false)
open import Relation.Binary.PropositionalEquality using (_≡_; refl)

-- Reason tokens: the six of CONTRACTS.md v1, the five of v1.1, then kernel-specific
-- tokens (lowercase [a-z0-9_]+ as lrd_state.h requires).
data Reason : Set where
  ok stale-seq bad-prev energy-not-decreasing infeasible bad-proof : Reason
  not-monotone capacity-exceeded invalid-observation
    already-consumed unknown-capability not-causal bad-witness : Reason
  -- CONTRACTS v1.1 amendments
  malformed wrong-kind bad-payload bad-epoch epoch-exhausted : Reason

reasonToken : Reason → String
reasonToken ok                    = "ok"
reasonToken stale-seq             = "stale_seq"
reasonToken bad-prev              = "bad_prev"
reasonToken energy-not-decreasing = "energy_not_decreasing"
reasonToken infeasible            = "infeasible"
reasonToken bad-proof             = "bad_proof"
reasonToken not-monotone          = "not_monotone"
reasonToken capacity-exceeded     = "capacity_exceeded"
reasonToken invalid-observation   = "invalid_observation"
reasonToken already-consumed      = "already_consumed"
reasonToken unknown-capability    = "unknown_capability"
reasonToken not-causal            = "not_causal"
reasonToken bad-witness           = "bad_witness"
reasonToken malformed             = "malformed"
reasonToken wrong-kind            = "wrong_kind"
reasonToken bad-payload           = "bad_payload"
reasonToken bad-epoch             = "bad_epoch"
reasonToken epoch-exhausted       = "epoch_exhausted"

data Outcome (A : Set) : Set where
  accept : A → Outcome A
  reject : Reason → Outcome A

-- Apply a decision to the current state.
settle : ∀ {A} → A → Outcome A → A
settle s (accept s′) = s′
settle s (reject _)  = s

isAccept : ∀ {A} → Outcome A → Bool
isAccept (accept _) = true
isAccept (reject _) = false

decisionToken : ∀ {A} → Outcome A → String
decisionToken (accept _) = "ACCEPT"
decisionToken (reject _) = "REJECT"

-- Rejected decisions leave the state unchanged (proved).
reject-preserves : ∀ {A} (s : A) {o : Outcome A} {r} → o ≡ reject r → settle s o ≡ s
reject-preserves s refl = refl

accept-commits : ∀ {A} (s : A) {o : Outcome A} {s′} → o ≡ accept s′ → settle s o ≡ s′
accept-commits s refl = refl
