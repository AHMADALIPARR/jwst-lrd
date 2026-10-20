-- Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
-- JWST-LRD Sovereign Scientific Runtime -- formal verification kernel (Agda).
-- Dual-licensed, intentionally: AGPL-3.0-only AND SnapKitty Opaque License.
-- SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
--
-- Module boundary: ASSUMPTION STATEMENTS — TRUSTED RUNTIME OBLIGATIONS.
--
-- Statements (types) of the obligations the *runtime* (Rust authority
-- in capability/, C ledger in ledger/, ingest in ingest/) must
-- discharge.  No postulate, no inhabitant: Agda cannot observe the
-- running system, so none of these can be proved here.  The kernel's
-- bridge theorems take them as module parameters.  Names align with
-- capability/obligations.json (CapabilityConsumedOnce, MonotonicCounter,
-- NoRollback, NoReplay); IngestFaithful and TransitionRefinement are
-- kernel-specific additions.
--
-- Status of every definition here: obligation-runtime (NOT proved).
{-# OPTIONS --safe --without-K #-}
module Kernel.Assumptions.Runtime where

open import Data.Nat.Base using (ℕ; suc; _<_; _≤_)
open import Data.List.Base using (List)
open import Data.List.Relation.Unary.Unique.Propositional using (Unique)
open import Data.Product.Base using (Σ)
open import Relation.Binary.PropositionalEquality using (_≡_)

-- A runtime trace: the sequence of persisted states, indexed by the
-- runtime's commit instants 0, 1, 2, ...
Trace : Set → Set
Trace S = ℕ → S

-- MonotonicCounter: the authority's persisted counter strictly
-- increases at every commit instant.
MonotonicCounter : Trace ℕ → Set
MonotonicCounter c = ∀ t → c t < c (suc t)

-- CapabilityConsumedOnce: the runtime's log of consumed capability IDs
-- never contains an ID twice (actual one-time enforcement, done by the
-- Rust authority; the Agda model only constrains its own state machine).
CapabilityConsumedOnce : List ℕ → Set
CapabilityConsumedOnce consumedLog = Unique consumedLog

-- NoRollback: the persisted head never moves to an older sequence
-- number (no restore of a stale snapshot).
NoRollback : {S : Set} → (seqOf : S → ℕ) → Trace S → Set
NoRollback seqOf tr = ∀ t → seqOf (tr t) ≤ seqOf (tr (suc t))

-- NoReplay: the runtime never re-accepts an already accepted proposal;
-- stated over the log of accepted proposal identities.
NoReplay : {P : Set} → List P → Set
NoReplay acceptedLog = Unique acceptedLog

-- TransitionRefinement: every persisted state is obtained from its
-- predecessor by the kernel's own transition function (the runtime
-- implements exactly the modelled step, atomically).
TransitionRefinement : {S P : Set} → (step : S → P → S) → Trace S → Set
TransitionRefinement {S} {P} step tr = ∀ t → Σ P λ p → tr (suc t) ≡ step (tr t) p

-- IngestFaithful: the raw observation handed to the kernel is the
-- faithful decoding of the referenced MAST/FITS product.  Abstract:
-- the relation `Faithful` is supplied by the ingest track.
IngestFaithful : {Raw Product : Set} → (Faithful : Raw → Product → Set) →
                 (decodeIngest : Product → Raw) → Set
IngestFaithful {Raw} {Product} Faithful decodeIngest = ∀ (p : Product) → Faithful (decodeIngest p) p

-- PayloadHashRawBytes (CONTRACTS v1.2): the payload_sha256 the runtime
-- puts in a proposal is SHA-256 of the raw LRD-ARR-v1 `.f64` bytes only
-- (the `.hdr` sidecar excluded).  The kernel treats digests abstractly
-- and cannot check this; it is an obligation of ingest/ and ledger/.
PayloadHashRawBytes : {Payload Bytes Digest : Set} →
  (rawF64Bytes : Payload → Bytes) → (sha256 : Bytes → Digest) →
  (payloadDigest : Payload → Digest) → Set
PayloadHashRawBytes {Payload} rawF64Bytes sha256 payloadDigest =
  ∀ (p : Payload) → payloadDigest p ≡ sha256 (rawF64Bytes p)
