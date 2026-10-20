-- Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
-- JWST-LRD Sovereign Scientific Runtime -- formal verification kernel (Agda).
-- Dual-licensed, intentionally: AGPL-3.0-only AND SnapKitty Opaque License.
-- SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
--
-- Module boundary: VERIFIED CORE (--safe --without-K). No postulates.
--
-- Accepted-state preservation for the composed kernel state machine.
-- A transition = LRD-STATE-v1 envelope check (stale_seq, bad_prev),
-- then the kind/payload match (wrong_kind), then the kind-specific
-- checker (observation validity, prime-ledger append, Hamiltonian
-- check in the normative order, capability consumption, AIR verifier).
-- A rejection at any stage leaves the whole state unchanged.
--
-- PROVED: every state reachable from genesis satisfies the invariant
--   (`accepted-state-preservation`, induction over `Reachable`).
-- BRIDGE (module `RuntimeBridge`): IF the runtime trace refines the
--   model (obligation TransitionRefinement) THEN every persisted state
--   satisfies the invariant, NoRollback holds, and (given that the
--   runtime's consumed log is the model's retired set) the obligation
--   CapabilityConsumedOnce holds; with the crypto assumption
--   CollisionResistant, equal head commitments imply equal heads.
{-# OPTIONS --safe --without-K #-}
open import Relation.Binary.Definitions using (DecidableEquality)
open import Data.Nat.Base using (ℕ)
open import Data.Bool.Base using (Bool)
open import Kernel.PrimeLedger using (PrimeBasis)
open import Kernel.State using ()
module Kernel.AcceptedState
  (Digest   : Set) (_≟D_ : DecidableEquality Digest)
  (hash     : Kernel.State.LrdState Digest _≟D_ → Digest)
  (B        : PrimeBasis)
  (HS       : Set) (E : HS → ℕ) (feasible : HS → Bool)
  (airVerify : ℕ → Bool)      -- AIR/STARK verifier: untrusted Boolean, soundness out of scope
  (genesisHead : Kernel.State.LrdState Digest _≟D_)
  (h₀ : HS) (epochs₀ : ℕ)
  where

open import Data.Nat.Base using (zero; suc; pred; _≤_; _<_)
open import Data.Nat.Properties using (≤-refl; ≤-trans; <⇒≤; n≤1+n)
open import Data.Bool.Base using (true; false)
open import Data.List.Base using (List; []; _∷_)
open import Data.List.Relation.Unary.All using (All; []; _∷_)
open import Data.Product.Base using (_×_; _,_; Σ; proj₁; proj₂)
open import Relation.Nullary using (yes; no)
open import Data.Sum.Base using (_⊎_; inj₁; inj₂)
open import Relation.Binary.PropositionalEquality

open import Kernel.Decision
open import Kernel.Observation using (RawObs; IsValid; isValid?)
open import Kernel.PrimeLedger using (Ledger; genesisLedger; append; decode; code; entries; ledger-decodes)
open import Kernel.Capability using (AuthState; genesisAuth; Cap; consume; AuthInv; genesis-inv; apply-inv; consumeOp; retired)
open import Kernel.Hamiltonian E using (module Checked; strict-decreasing)
open Checked feasible using (hamCheck; hamCheck-accept)
open import Kernel.State Digest _≟D_
open Transition hash using (decide; decide-seq)
open import Kernel.Assumptions.Crypto using (CollisionResistant)
open import Kernel.Assumptions.Runtime using (Trace; TransitionRefinement; NoRollback; CapabilityConsumedOnce)

record KernelState : Set where
  constructor kernelState
  field
    head         : LrdState
    observations : List RawObs
    ledger       : Ledger B
    auth         : AuthState
    ham          : HS
    epochs       : ℕ
open KernelState public

genesis : KernelState
genesis = kernelState genesisHead [] (genesisLedger B) genesisAuth h₀ epochs₀

data Payload : Set where
  obsP    : RawObs → Payload
  ledgerP : ℕ → Payload
  hamP    : HS → Payload
  capP    : Cap → Payload
  airP    : ℕ → Payload

payloadKind : Payload → Kind
payloadKind (obsP _)    = observation
payloadKind (ledgerP _) = ledger-append
payloadKind (hamP _)    = hamiltonian-step
payloadKind (capP _)    = capability
payloadKind (airP _)    = air-proof

record FullProposal : Set where
  constructor fullProposal
  field
    env     : Proposal
    payload : Payload
open FullProposal public

------------------------------------------------------------------------
-- Kind-specific step (after the envelope passed)

kindStep : KernelState → LrdState → Payload → Outcome KernelState
kindStep ks h (obsP r) with isValid? r
... | yes _ = accept (record ks { head = h ; observations = r ∷ observations ks })
... | no _  = reject invalid-observation
kindStep ks h (ledgerP e) with append (ledger ks) e
... | accept L = accept (record ks { head = h ; ledger = L })
... | reject x = reject x
kindStep ks h (hamP s) with hamCheck (epochs ks) (ham ks) s
... | accept s′ = accept (record ks { head = h ; ham = s′ ; epochs = pred (epochs ks) })
... | reject x  = reject x
kindStep ks h (capP c) with consume (auth ks) c
... | accept a = accept (record ks { head = h ; auth = a })
... | reject x = reject x
kindStep ks h (airP x) with airVerify x
... | true  = accept (record ks { head = h })
... | false = reject bad-proof

step : KernelState → FullProposal → Outcome KernelState
step ks p with decide (head ks) (env p)
... | reject r = reject r
... | accept h with pKind (env p) ≟K payloadKind (payload p)
...   | no _  = reject wrong-kind
...   | yes _ = kindStep ks h (payload p)

next : KernelState → FullProposal → KernelState
next ks p = settle ks (step ks p)

------------------------------------------------------------------------
-- Invariant

Inv : KernelState → Set
Inv ks = All IsValid (observations ks)
       × AuthInv (auth ks)
       × E (ham ks) ≤ E h₀
       × decode B (code (ledger ks)) ≡ just (entries (ledger ks))
  where open import Data.Maybe.Base using (just)

genesis-Inv : Inv genesis
genesis-Inv = [] , genesis-inv , ≤-refl , ledger-decodes (genesisLedger B)

kindStep-Inv : ∀ ks h pl → Inv ks → Inv (settle ks (kindStep ks h pl))
kindStep-Inv ks h (obsP r) inv@(o , a , e , d) with isValid? r
... | yes v = (v ∷ o) , a , e , d
... | no _  = inv
kindStep-Inv ks h (ledgerP x) inv@(o , a , e , d) with append (ledger ks) x
... | accept L = o , a , e , ledger-decodes L
... | reject _ = inv
kindStep-Inv ks h (hamP s) inv@(o , a , e , d) with hamCheck (epochs ks) (ham ks) s in eq
... | accept s′ = o , a , ≤-trans (<⇒≤ (proj₂ (proj₂ (hamCheck-accept (epochs ks) (ham ks) s eq)))) e , d
... | reject _  = inv
kindStep-Inv ks h (capP c) inv@(o , a , e , d) with consume (auth ks) c in eq
... | accept a′ = o , subst AuthInv (cong (settle (auth ks)) eq) (apply-inv (auth ks) (consumeOp c) a) , e , d
... | reject _  = inv
kindStep-Inv ks h (airP x) inv with airVerify x
... | true  = inv
... | false = inv

step-Inv : ∀ ks p → Inv ks → Inv (next ks p)
step-Inv ks p inv with decide (head ks) (env p)
... | reject _ = inv
... | accept h with pKind (env p) ≟K payloadKind (payload p)
...   | no _  = inv
...   | yes _ = kindStep-Inv ks h (payload p) inv

-- Rejections never construct a new state.
step-reject-unchanged : ∀ ks p {r} → step ks p ≡ reject r → next ks p ≡ ks
step-reject-unchanged ks p eq = reject-preserves ks eq

------------------------------------------------------------------------
-- Head sequence never decreases (model-level NoRollback).

kindStep-head : ∀ ks h pl → head (settle ks (kindStep ks h pl)) ≡ head ks ⊎ head (settle ks (kindStep ks h pl)) ≡ h
kindStep-head = helper
  where
  helper : ∀ ks h pl → head (settle ks (kindStep ks h pl)) ≡ head ks ⊎ head (settle ks (kindStep ks h pl)) ≡ h
  helper ks h (obsP r) with isValid? r
  ... | yes _ = inj₂ refl
  ... | no _  = inj₁ refl
  helper ks h (ledgerP x) with append (ledger ks) x
  ... | accept _ = inj₂ refl
  ... | reject _ = inj₁ refl
  helper ks h (hamP s) with hamCheck (epochs ks) (ham ks) s
  ... | accept _ = inj₂ refl
  ... | reject _ = inj₁ refl
  helper ks h (capP c) with consume (auth ks) c
  ... | accept _ = inj₂ refl
  ... | reject _ = inj₁ refl
  helper ks h (airP x) with airVerify x
  ... | true  = inj₂ refl
  ... | false = inj₁ refl

next-seq : ∀ ks p → seq (head ks) ≤ seq (head (next ks p))
next-seq ks p with decide (head ks) (env p) in eq
... | reject _ = ≤-refl
... | accept h with pKind (env p) ≟K payloadKind (payload p)
...   | no _  = ≤-refl
...   | yes _ with kindStep-head ks h (payload p)
...     | inj₁ e = subst (λ x → seq (head ks) ≤ seq x) (sym e) ≤-refl
...     | inj₂ e = subst (λ x → seq (head ks) ≤ seq x) (sym e)
                                 (subst (seq (head ks) ≤_) (sym (decide-seq (head ks) (env p) eq)) (n≤1+n _))

------------------------------------------------------------------------
-- Reachability and preservation

data Reachable : KernelState → Set where
  genesisR : Reachable genesis
  stepR    : ∀ {ks} → Reachable ks → (p : FullProposal) → Reachable (next ks p)

accepted-state-preservation : ∀ {ks} → Reachable ks → Inv ks
accepted-state-preservation genesisR     = genesis-Inv
accepted-state-preservation (stepR r p)  = step-Inv _ p (accepted-state-preservation r)

------------------------------------------------------------------------
-- Bridge to the trusted runtime (obligations are module parameters).

module RuntimeBridge
  (tr      : Trace KernelState)
  (tr-gen  : tr 0 ≡ genesis)
  (refines : TransitionRefinement next tr)   -- obligation-runtime
  where

  trace-reachable : ∀ t → Reachable (tr t)
  trace-reachable zero    = subst Reachable (sym tr-gen) genesisR
  trace-reachable (suc t) with refines t
  ... | p , eq = subst Reachable (sym eq) (stepR (trace-reachable t) p)

  trace-invariant : ∀ t → Inv (tr t)
  trace-invariant t = accepted-state-preservation (trace-reachable t)

  -- NoRollback is DERIVED from TransitionRefinement.
  trace-no-rollback : NoRollback (λ ks → seq (head ks)) tr
  trace-no-rollback t with refines t
  ... | p , eq = subst (λ x → seq (head (tr t)) ≤ seq (head x)) (sym eq) (next-seq (tr t) p)

  -- CapabilityConsumedOnce for any runtime log that matches the model.
  trace-consumed-once : (consumedLog : ℕ → List ℕ) →
    (∀ t → consumedLog t ≡ retired (auth (tr t))) →     -- obligation-runtime (log matches model)
    ∀ t → CapabilityConsumedOnce (consumedLog t)
  trace-consumed-once log logOk t =
    subst CapabilityConsumedOnce (sym (logOk t)) (proj₂ (proj₂ (proj₁ (proj₂ (trace-invariant t)))))

  -- With the crypto assumption: equal head commitments ⇒ equal heads.
  trace-commit-binding : CollisionResistant hash → ∀ t u →
    hash (head (tr t)) ≡ hash (head (tr u)) → head (tr t) ≡ head (tr u)
  trace-commit-binding cr t u = cr
