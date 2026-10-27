{-# OPTIONS --safe --without-K #-}
-- Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
-- Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
-- SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
--
-- JWST-LRD Sovereign Scientific Runtime -- TASK 011: Agda verified core.
-- Obligation group ST: Agda mirror of the LRD-STATE-v1 ABI (research/CONTRACTS.md), field for
-- field, plus the generic decision function shared by every transition kind.
--
-- Field mapping (ABI name -> Agda name : type):
--   State      seq            -> seq            : ℕ
--              commit         -> commit         : Digest  (64 lowercase hex digits, as Vec (Fin 16) 64)
--              kind           -> kind           : Kind    (closed enumeration of the 5 ABI kinds)
--              payload_sha256 -> payload-sha256 : Digest
--   Proposal   kind           -> kind           : Kind
--              prev_commit    -> prev-commit    : Digest
--              seq            -> seq            : ℕ
--              payload_sha256 -> payload-sha256 : Digest
--              kind-specific  -> extra          : List (String × String)   ABSTRACTED (A-ST-3)
--   Decision   decision/reason/new_commit -> data Decision:
--              ACCEPT new_commit (reason is always `ok`) | REJECT reason (no new_commit)
-- Abstractions (see agda/ASSUMPTIONS.md): the commitment function (SHA-256 over the LRD-REC-v1
-- serialization) is a module parameter `commitOf` (A-ST-1); the kind-specific validity check is a
-- decidable module parameter (A-ST-2); the genesis state's kind and payload are parameters (A-ST-4);
-- hex is modelled as digit values, not as the ASCII bytes of the record (A-ST-5).

module Core.State where

open import Data.Nat using (ℕ; suc)
import Data.Nat.Properties as ℕP
open import Data.Fin using (Fin) renaming (zero to fz)
import Data.Fin.Properties as FinP
open import Data.Vec using (Vec; replicate)
import Data.Vec.Properties as VecP
open import Data.List using (List)
open import Data.String using (String)
open import Data.Product using (_×_; _,_; Σ; ∃)
open import Data.Maybe using (Maybe; just; nothing)
open import Relation.Nullary using (Dec; yes; no; ¬_)
open import Data.Empty using (⊥-elim)
open import Relation.Binary.PropositionalEquality

Hex : Set
Hex = Fin 16

Digest : Set
Digest = Vec Hex 64

_≟d_ : (a b : Digest) → Dec (a ≡ b)
_≟d_ = VecP.≡-dec FinP._≟_

-- "64 zeros": the genesis commit
zeros : Digest
zeros = replicate 64 fz

data Kind : Set where
  observation ledger-append hamiltonian-step capability air-proof : Kind

-- ABI tokens
kind-token : Kind → String
kind-token observation      = "observation"
kind-token ledger-append    = "ledger_append"
kind-token hamiltonian-step = "hamiltonian_step"
kind-token capability       = "capability"
kind-token air-proof        = "air_proof"

record State : Set where
  constructor mkState
  field
    seq            : ℕ
    commit         : Digest
    kind           : Kind
    payload-sha256 : Digest

record Proposal : Set where
  constructor mkProposal
  field
    kind           : Kind
    prev-commit    : Digest
    seq            : ℕ
    payload-sha256 : Digest
    extra          : List (String × String)

data Reason : Set where
  ok stale-seq bad-prev energy-not-decreasing infeasible bad-proof : Reason
  other : String → Reason     -- the ABI's reason set is open ("e.g.")

reason-token : Reason → String
reason-token ok                    = "ok"
reason-token stale-seq             = "stale_seq"
reason-token bad-prev              = "bad_prev"
reason-token energy-not-decreasing = "energy_not_decreasing"
reason-token infeasible            = "infeasible"
reason-token bad-proof             = "bad_proof"
reason-token (other s)             = s

data Decision : Set where
  ACCEPT : (new-commit : Digest) → Decision
  REJECT : (reason : Reason) → Decision

decision-reason : Decision → Reason
decision-reason (ACCEPT _) = ok
decision-reason (REJECT r) = r

decision-new-commit : Decision → Maybe Digest   -- set only on ACCEPT
decision-new-commit (ACCEPT c) = just c
decision-new-commit (REJECT _) = nothing

------------------------------------------------------------------------
-- The generic transition machine

module Machine
  (commitOf   : State → Digest)                      -- A-ST-1
  (KindOK     : State → Proposal → Set)              -- A-ST-2
  (kindOK?    : ∀ s p → Dec (KindOK s p))
  (kindReason : State → Proposal → Reason)
  (g-kind     : Kind)                                -- A-ST-4
  (g-payload  : Digest)
  where

  genesis : State
  genesis = mkState 0 zeros g-kind g-payload

  Accepts : State → Proposal → Set
  Accepts s p = (Proposal.seq p ≡ suc (State.seq s))
              × (Proposal.prev-commit p ≡ commitOf s)
              × KindOK s p

  -- the state constructed on ACCEPT; its `commit` field is the commitment of the previous state
  next : State → Proposal → State
  next s p = mkState (Proposal.seq p) (commitOf s) (Proposal.kind p) (Proposal.payload-sha256 p)

  -- A result either carries a new state (ACCEPT) or only a reason (REJECT): rejection never
  -- constructs a state, by construction of the type.
  data Result : Set where
    accepted : State → Digest → Result
    rejected : Reason → Result

  step : State → Proposal → Result
  step s p with Proposal.seq p ℕP.≟ suc (State.seq s)
                | Proposal.prev-commit p ≟d commitOf s
                | kindOK? s p
  ... | no _  | _     | _     = rejected stale-seq
  ... | yes _ | no _  | _     = rejected bad-prev
  ... | yes _ | yes _ | no _  = rejected (kindReason s p)
  ... | yes _ | yes _ | yes _ = accepted (next s p) (commitOf (next s p))

  decide : State → Proposal → Decision
  decide s p with step s p
  ... | accepted _ c = ACCEPT c
  ... | rejected r   = REJECT r

  new-state : Result → Maybe State
  new-state (accepted s _) = just s
  new-state (rejected _)   = nothing

  -- Soundness: anything accepted satisfies all checks, and the new state/commit are the canonical ones.
  step-sound : ∀ s p {s′ c} → step s p ≡ accepted s′ c
             → Accepts s p × s′ ≡ next s p × c ≡ commitOf (next s p)
  step-sound s p eq with Proposal.seq p ℕP.≟ suc (State.seq s)
                       | Proposal.prev-commit p ≟d commitOf s
                       | kindOK? s p
  step-sound s p () | no _  | _     | _
  step-sound s p () | yes _ | no _  | _
  step-sound s p () | yes _ | yes _ | no _
  step-sound s p refl | yes a | yes b | yes k = (a , b , k) , refl , refl

  -- Completeness: every proposal satisfying all checks is accepted.
  step-complete : ∀ s p → Accepts s p → step s p ≡ accepted (next s p) (commitOf (next s p))
  step-complete s p (a , b , k) with Proposal.seq p ℕP.≟ suc (State.seq s)
                                   | Proposal.prev-commit p ≟d commitOf s
                                   | kindOK? s p
  ... | no ¬a | _     | _     = ⊥-elim (¬a a)
  ... | yes _ | no ¬b | _     = ⊥-elim (¬b b)
  ... | yes _ | yes _ | no ¬k = ⊥-elim (¬k k)
  ... | yes _ | yes _ | yes _ = refl

  -- Invalid proposals are rejected (and so construct no state).
  invalid-rejected : ∀ s p → ¬ Accepts s p → Σ Reason (λ r → step s p ≡ rejected r)
  invalid-rejected s p ¬acc with step s p in eq
  ... | rejected r   = r , refl
  ... | accepted s′ c with step-sound s p eq
  ...   | acc , _ = ⊥-elim (¬acc acc)

  stale-seq-rejected : ∀ s p → ¬ (Proposal.seq p ≡ suc (State.seq s)) → step s p ≡ rejected stale-seq
  stale-seq-rejected s p ne with Proposal.seq p ℕP.≟ suc (State.seq s)
  ... | yes e = ⊥-elim (ne e)
  ... | no _  = refl

  bad-prev-rejected : ∀ s p → Proposal.seq p ≡ suc (State.seq s)
                    → ¬ (Proposal.prev-commit p ≡ commitOf s) → step s p ≡ rejected bad-prev
  bad-prev-rejected s p e ne with Proposal.seq p ℕP.≟ suc (State.seq s)
                                | Proposal.prev-commit p ≟d commitOf s
  ... | no ¬e | _     = ⊥-elim (¬e e)
  ... | yes _ | yes b = ⊥-elim (ne b)
  ... | yes _ | no _  = refl

  reject-no-state : ∀ s p r → step s p ≡ rejected r → new-state (step s p) ≡ nothing
  reject-no-state s p r eq rewrite eq = refl

  decide-accept-sound : ∀ s p c → decide s p ≡ ACCEPT c → Accepts s p × c ≡ commitOf (next s p)
  decide-accept-sound s p c d with step s p in eq
  decide-accept-sound s p c refl | accepted s′ .c with step-sound s p eq
  ... | acc , _ , ceq = acc , ceq
