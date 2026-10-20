{-# OPTIONS --safe --without-K #-}
-- Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
-- Dual-licensed: AGPL-3.0-or-later plus SnapKitty Opaque License.
-- SPDX-License-Identifier: AGPL-3.0-or-later AND LicenseRef-SnapKitty-Opaque
--
-- JWST-LRD Sovereign Scientific Runtime -- TASK 011: Agda verified core.
-- Obligation group OBS: observation validity.
-- A decidable checker `valid?` with soundness AND completeness w.r.t. the predicate `Valid`.
--
-- All quantities are exact integers in fixed instrument units (no floating point):
--   wavelengths (wlLo, wlHi) in a fixed integer unit, flux as an integer (may be negative after
--   background subtraction), flux error and exposure time as naturals.
-- The instrument wavelength window [instLo, instHi] is a MODULE PARAMETER (assumption A-OBS-1 in
-- agda/ASSUMPTIONS.md); no instrument constants are hard-coded here.

open import Data.Nat using (ℕ)

module Core.Observation (instLo instHi : ℕ) where

open import Data.Nat using (_≤_; _<_; _≤?_; _<?_)
open import Data.Integer using (ℤ)
open import Data.Bool using (Bool; T)
open import Data.Product using (_×_; _,_)
open import Relation.Nullary using (Dec; yes; no)
open import Relation.Nullary.Decidable using (⌊_⌋; _×-dec_; toWitness; fromWitness)

record Observation : Set where
  field
    obsId    : ℕ
    wlLo     : ℕ
    wlHi     : ℕ
    flux     : ℤ
    fluxErr  : ℕ
    exposure : ℕ
open Observation public

-- Validity: the band lies inside the instrument window and is non-degenerate, the flux error is
-- strictly positive, and the exposure time is strictly positive.
Valid : Observation → Set
Valid o = (instLo ≤ wlLo o) × (wlLo o < wlHi o) × (wlHi o ≤ instHi)
        × (0 < fluxErr o) × (0 < exposure o)

valid-dec : (o : Observation) → Dec (Valid o)
valid-dec o = (instLo ≤? wlLo o) ×-dec (wlLo o <? wlHi o) ×-dec (wlHi o ≤? instHi)
            ×-dec (0 <? fluxErr o) ×-dec (0 <? exposure o)

-- The executable Boolean checker.
valid? : Observation → Bool
valid? o = ⌊ valid-dec o ⌋

-- Soundness: the checker only accepts valid observations.
valid?-sound : ∀ o → T (valid? o) → Valid o
valid?-sound o = toWitness

-- Completeness: every valid observation is accepted.
valid?-complete : ∀ o → Valid o → T (valid? o)
valid?-complete o = fromWitness
