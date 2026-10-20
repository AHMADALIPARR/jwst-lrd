-- Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
-- JWST-LRD Sovereign Scientific Runtime -- formal verification kernel (Agda).
-- Dual-licensed, intentionally: AGPL-3.0-only AND SnapKitty Opaque License.
-- SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
--
-- Module boundary: ASSUMPTION STATEMENTS — CRYPTOGRAPHIC.
--
-- This module contains only the *statements* (types) of the
-- cryptographic assumptions.  It contains NO postulate and NO
-- inhabitant of any of them; it is therefore checked with --safe so
-- that the --safe core may import it.  Nothing in this repository
-- proves or postulates these types.  Every theorem that relies on one
-- of them takes it as an explicit hypothesis or module parameter, so
-- the dependency is visible in the theorem's type.
--
-- Status of every definition here: assumption-crypto (NOT proved).
{-# OPTIONS --safe --without-K #-}
module Kernel.Assumptions.Crypto where

open import Data.Bool.Base using (Bool; true)
open import Relation.Binary.PropositionalEquality using (_≡_)

-- CollisionResistant: idealised hash.  Stated as injectivity on the
-- modelled message space.  For real SHA-256 this is information-
-- theoretically false (pigeonhole); it is the standard idealisation of
-- the computational assumption "no adversary in the runtime's threat
-- model ever exhibits a collision".  It must never be discharged by a
-- postulate claiming mathematical truth.
CollisionResistant : {M D : Set} → (M → D) → Set
CollisionResistant h = ∀ {x y} → h x ≡ h y → x ≡ y

-- AccumulatorWitnessSound (strong-RSA + hash-to-prime, idealised):
-- every witness that passes the decidable verifier for accumulator
-- value `acc S` proves membership of x in S.  Not provable for an
-- abstract group (and false for small toy groups).
AccumulatorWitnessSound :
  {Sets Acc Elem Wit : Set} →
  (acc : Sets → Acc) → (verify : Acc → Elem → Wit → Bool) →
  (_∈ˢ_ : Elem → Sets → Set) → Set
AccumulatorWitnessSound {Sets} {Acc} {Elem} {Wit} acc verify _∈ˢ_ =
  ∀ (S : Sets) (x : Elem) (w : Wit) → verify (acc S) x w ≡ true → x ∈ˢ S

-- MACUnforgeable (EUF-CMA, idealised): a tag that verifies under the
-- authority key was produced by a holder of that key.
MACUnforgeable :
  {Msg Tag : Set} → (verifyMac : Msg → Tag → Bool) →
  (KeyHolderTagged : Msg → Set) → Set
MACUnforgeable {Msg} {Tag} verifyMac KeyHolderTagged =
  ∀ (m : Msg) (t : Tag) → verifyMac m t ≡ true → KeyHolderTagged m

-- AuthorityKeyUncompromised (operational/crypto): the only holder of
-- the authority key is the Authority, so anything tagged by a key
-- holder was issued by the Authority.
AuthorityKeyUncompromised :
  {Msg : Set} → (KeyHolderTagged : Msg → Set) → (AuthorityIssued : Msg → Set) → Set
AuthorityKeyUncompromised {Msg} KeyHolderTagged AuthorityIssued =
  ∀ (m : Msg) → KeyHolderTagged m → AuthorityIssued m
