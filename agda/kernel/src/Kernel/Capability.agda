-- Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
-- JWST-LRD Sovereign Scientific Runtime -- formal verification kernel (Agda).
-- Dual-licensed, intentionally: AGPL-3.0-only AND SnapKitty Opaque License.
-- SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
--
-- Module boundary: VERIFIED CORE (--safe --without-K). No postulates.
--
-- Capabilities.  The capability type `Cap` and its constructor are
-- `abstract`: the ONLY producer is the Authority's `issue`, which draws
-- a fresh ID from the authority counter.
--
-- IMPORTANT — an Agda value is NOT a linear resource.  Agda has no
-- linear types here: a `Cap` value can be copied, stored and passed to
-- `consume` any number of times.  One-time use is modelled instead as
-- a STATE-MACHINE INVARIANT: the authority state keeps the set of
-- retired IDs, and `consume` rejects a retired ID.  What is proved is
-- that *within the modelled state machine* a consumed capability never
-- authorises again.  That the real system behaves like this model —
-- the counter is persisted monotonically, the retired set is never
-- rolled back, and each capability is consumed at most once — is a
-- TRUSTED RUNTIME OBLIGATION (CapabilityConsumedOnce, MonotonicCounter,
-- NoRollback), discharged by the Rust authority in capability/.
-- `replay-after-rollback` below shows concretely why NoRollback is
-- needed: the pure model happily re-accepts on a rolled-back state.
{-# OPTIONS --safe --without-K #-}
module Kernel.Capability where

open import Data.Nat.Base using (ℕ; zero; suc; _<_)
open import Data.Nat.Properties as ℕP using (n<1+n; m<n⇒m<1+n; <-irrefl)
open import Data.List.Base using (List; []; _∷_)
open import Data.List.Membership.Propositional using (_∈_; _∉_)
open import Data.List.Membership.DecPropositional ℕP._≟_ using (_∈?_)
open import Data.List.Relation.Unary.All as All using (All; []; _∷_)
open import Data.List.Relation.Unary.All.Properties using (¬Any⇒All¬)
open import Data.List.Relation.Unary.Any using (here; there)
open import Data.List.Relation.Unary.Unique.Propositional using (Unique)
open import Data.List.Relation.Unary.AllPairs using ([]; _∷_)
open import Data.Product.Base using (Σ; _×_; _,_; proj₁; proj₂)
open import Data.Empty using (⊥-elim)
open import Relation.Nullary using (yes; no; ¬_)
open import Relation.Binary.PropositionalEquality using (_≡_; refl; sym; subst)
open import Kernel.Decision

data Scope : Set where
  ingest ledgerAppend hamiltonianStep airProof : Scope

record AuthState : Set where
  constructor authState
  field
    nextId  : ℕ         -- authority counter
    issued  : List ℕ
    retired : List ℕ
open AuthState public

genesisAuth : AuthState
genesisAuth = authState 0 [] []

------------------------------------------------------------------------
-- Authority boundary

abstract
  data Cap : Set where
    mkCap : ℕ → Scope → Cap

  capId : Cap → ℕ
  capId (mkCap i _) = i

  capScope : Cap → Scope
  capScope (mkCap _ s) = s

  issue : AuthState → Scope → Cap × AuthState
  issue st sc = mkCap (nextId st) sc , authState (suc (nextId st)) (nextId st ∷ issued st) (retired st)

  issue-id : ∀ st sc → capId (proj₁ (issue st sc)) ≡ nextId st
  issue-id st sc = refl

  issue-state : ∀ st sc → proj₂ (issue st sc) ≡ authState (suc (nextId st)) (nextId st ∷ issued st) (retired st)
  issue-state st sc = refl

------------------------------------------------------------------------
-- Consumption relation

consume : AuthState → Cap → Outcome AuthState
consume st c with capId c ∈? retired st | capId c ∈? issued st
... | yes _ | _     = reject already-consumed
... | no _  | yes _ = accept (authState (nextId st) (issued st) (capId c ∷ retired st))
... | no _  | no _  = reject unknown-capability

consume-accept : ∀ st c {st′} → consume st c ≡ accept st′ →
  capId c ∉ retired st × capId c ∈ issued st ×
  st′ ≡ authState (nextId st) (issued st) (capId c ∷ retired st)
consume-accept st c eq with capId c ∈? retired st | capId c ∈? issued st
consume-accept st c refl | no r | yes i = r , i , refl
consume-accept st c ()   | yes _ | _
consume-accept st c ()   | no _  | no _

-- A retired capability is always rejected.
retired-rejects : ∀ st c → capId c ∈ retired st → consume st c ≡ reject already-consumed
retired-rejects st c m with capId c ∈? retired st
... | yes _ = refl
... | no ¬m = ⊥-elim (¬m m)

-- Main property: after a successful consumption, the same capability
-- can never authorise again from the resulting state.
consumed-never-reauthorises : ∀ st c {st′} → consume st c ≡ accept st′ →
  consume st′ c ≡ reject already-consumed
consumed-never-reauthorises st c eq with consume-accept st c eq
... | _ , _ , refl = retired-rejects _ c (here refl)

-- ... and retirement is permanent under every later operation.
data Op : Set where
  issueOp   : Scope → Op
  consumeOp : Cap → Op

apply : AuthState → Op → AuthState
apply st (issueOp sc)  = proj₂ (issue st sc)
apply st (consumeOp c) = settle st (consume st c)

retired-persists : ∀ st op {i} → i ∈ retired st → i ∈ retired (apply st op)
retired-persists st (issueOp sc) m rewrite issue-state st sc = m
retired-persists st (consumeOp c) m with consume st c in eq
... | accept st′ with consume-accept st c eq
...   | _ , _ , refl = there m
retired-persists st (consumeOp c) m | reject _ = m

applyAll : AuthState → List Op → AuthState
applyAll st []         = st
applyAll st (op ∷ ops) = applyAll (apply st op) ops

never-reauthorises-later : ∀ st c {st′} → consume st c ≡ accept st′ →
  ∀ ops → consume (applyAll st′ ops) c ≡ reject already-consumed
never-reauthorises-later st c eq ops with consume-accept st c eq
... | _ , _ , refl = retired-rejects _ c (go ops (here refl))
  where
  go : ∀ {s} ops → capId c ∈ retired s → capId c ∈ retired (applyAll s ops)
  go []         m = m
  go (op ∷ ops) m = go ops (retired-persists _ op m)

------------------------------------------------------------------------
-- Authority invariant (preserved by every operation)

AuthInv : AuthState → Set
AuthInv st = All (_< nextId st) (issued st) × All (_∈ issued st) (retired st) × Unique (retired st)

genesis-inv : AuthInv genesisAuth
genesis-inv = [] , [] , []

private
  bump : ∀ {n xs} → All (_< n) xs → All (_< suc n) xs
  bump = All.map m<n⇒m<1+n

  widen : ∀ {x : ℕ} {ys zs : List ℕ} → All (_∈ ys) zs → All (_∈ x ∷ ys) zs
  widen = All.map there

apply-inv : ∀ st op → AuthInv st → AuthInv (apply st op)
apply-inv st (issueOp sc) (lt , sub , u) rewrite issue-state st sc =
  (n<1+n (nextId st) ∷ bump lt) , widen {nextId st} sub , u
apply-inv st (consumeOp c) inv@(lt , sub , u) with consume st c in eq
... | reject _ = inv
... | accept st′ with consume-accept st c eq
...   | ¬r , i , refl = lt , (i ∷ sub) , (¬Any⇒All¬ (retired st) ¬r ∷ u)

applyAll-inv : ∀ st ops → AuthInv st → AuthInv (applyAll st ops)
applyAll-inv st []         inv = inv
applyAll-inv st (op ∷ ops) inv = applyAll-inv (apply st op) ops (apply-inv st op inv)

-- Freshness: a newly issued ID is neither issued before nor retired.
issue-fresh : ∀ st sc → AuthInv st → capId (proj₁ (issue st sc)) ∉ issued st
issue-fresh st sc (lt , _ , _) m rewrite issue-id st sc = <-irrefl refl (All.lookup lt m)

------------------------------------------------------------------------
-- Why NoRollback is a runtime obligation (proved counter-scenario):
-- the model is a pure function, so presenting the *pre-consumption*
-- state again re-accepts the same capability.

replay-after-rollback : ∀ st c {st′} → consume st c ≡ accept st′ →
  consume st′ c ≡ reject already-consumed × consume st c ≡ accept st′
replay-after-rollback st c eq = consumed-never-reauthorises st c eq , eq
