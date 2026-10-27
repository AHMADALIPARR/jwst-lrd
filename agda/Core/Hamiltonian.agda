{-# OPTIONS --safe --without-K #-}
-- Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
-- Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
-- SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
--
-- JWST-LRD Sovereign Scientific Runtime -- TASK 011: Agda verified core.
-- Obligation group HAM: Hamiltonian descent within epochs. Energies are naturals (exact; a
-- rational energy with a fixed common denominator q reduces to this case via E·q -- assumption
-- A-HAM-1). PENDING ALIGNMENT: branch t008-hamiltonian exists but contains no
-- hamiltonian/OBLIGATIONS.md yet (checked 2026-10-19); these obligations must be re-aligned with
-- Foundry J Verify's list once it lands.
--
--   step-ok? / step-ok?-sound / step-ok?-complete : the step check E' < E is decidable (the
--       `energy_not_decreasing` rejection reason of LRD-STATE-v1)
--   descent-length  : any accepted descent run within one epoch starting at energy E has at
--                     most E steps (the run length is bounded by the initial energy)
--   descent-final   : the final energy is ≤ E − (number of steps)
--   epochs-length   : over a sequence of epochs (energy may be re-seeded at each epoch
--                     boundary), the total number of steps is ≤ the sum of the epoch seeds
--   descent-filter  : the run produced by a filter that drops non-decreasing proposals is an
--                     accepted descent

module Core.Hamiltonian where

open import Data.Nat using (ℕ; zero; suc; _+_; _∸_; _<_; _≤_; _<?_; z≤n; s≤s)
open import Data.Nat.Properties
  using (≤-refl; ≤-trans; +-mono-≤; <-≤-trans; +-identityʳ; +-suc)
open import Data.List using (List; []; _∷_; length; sum; map)
open import Data.Bool using (Bool; T)
open import Data.Product using (_×_; _,_; proj₁; proj₂; Σ)
open import Relation.Nullary using (Dec; yes; no)
open import Relation.Nullary.Decidable using (⌊_⌋; toWitness; fromWitness)
open import Relation.Binary.PropositionalEquality

Energy : Set
Energy = ℕ

-- single step check: strictly decreasing energy
StepOK : Energy → Energy → Set
StepOK e e′ = e′ < e

step-ok? : Energy → Energy → Bool
step-ok? e e′ = ⌊ e′ <? e ⌋

step-ok?-sound : ∀ e e′ → T (step-ok? e e′) → StepOK e e′
step-ok?-sound e e′ = toWitness

step-ok?-complete : ∀ e e′ → StepOK e e′ → T (step-ok? e e′)
step-ok?-complete e e′ = fromWitness

-- An accepted descent within one epoch: starting energy e, then the list of successive energies.
data Descent : Energy → List Energy → Set where
  done : ∀ {e} → Descent e []
  step : ∀ {e e′ es} → e′ < e → Descent e′ es → Descent e (e′ ∷ es)

last : Energy → List Energy → Energy
last e []       = e
last e (x ∷ xs) = last x xs

descent-length : ∀ {e es} → Descent e es → length es ≤ e
descent-length done                 = z≤n
descent-length (step {e} {e′} lt d) = <-≤-trans (s≤s (descent-length d)) lt

-- the final energy has dropped by at least one unit per step
descent-final : ∀ {e es} → Descent e es → last e es + length es ≤ e
descent-final {e} done = subst (_≤ e) (sym (+-identityʳ e)) ≤-refl
descent-final {e} {e′ ∷ es} (step lt d) =
  ≤-trans (subst (_≤ suc e′) (sym (+-suc (last e′ es) (length es))) (s≤s (descent-final d))) lt

-- Epochs: each epoch has its own seed energy and a descent from it.
record Epoch : Set where
  constructor mkEpoch
  field
    seed  : Energy
    steps : List Energy

EpochOK : Epoch → Set
EpochOK (mkEpoch s es) = Descent s es

data AllEpochs : List Epoch → Set where
  []  : AllEpochs []
  _∷_ : ∀ {ep eps} → EpochOK ep → AllEpochs eps → AllEpochs (ep ∷ eps)

total-steps : List Epoch → ℕ
total-steps []                 = 0
total-steps (mkEpoch _ es ∷ eps) = length es + total-steps eps

total-seed : List Epoch → ℕ
total-seed []                = 0
total-seed (mkEpoch s _ ∷ eps) = s + total-seed eps

epochs-length : ∀ {eps} → AllEpochs eps → total-steps eps ≤ total-seed eps
epochs-length []                          = z≤n
epochs-length {mkEpoch s es ∷ _} (d ∷ rest) = +-mono-≤ (descent-length d) (epochs-length rest)

-- A verifier that filters proposed energies, accepting only strict decreases, always produces a
-- Descent (rejected proposals construct nothing).
filter-run : Energy → List Energy → List Energy
filter-run e []         = []
filter-run e (x ∷ xs) with x <? e
... | yes _ = x ∷ filter-run x xs
... | no  _ = filter-run e xs

descent-filter : ∀ e xs → Descent e (filter-run e xs)
descent-filter e []       = done
descent-filter e (x ∷ xs) with x <? e
... | yes lt = step lt (descent-filter x xs)
... | no  _  = descent-filter e xs

filter-run-bounded : ∀ e xs → length (filter-run e xs) ≤ e
filter-run-bounded e xs = descent-length (descent-filter e xs)

------------------------------------------------------------------------
------------------------------------------------------------------------
-- PART 2: the TASK 008 engine (`kind=hamiltonian_step`), mirroring
-- /workspace/jwst-lrd-t008/hamiltonian/OBLIGATIONS.md (H-1 … H-12), read at t008 commit c67266f.
-- Energies are exact rationals (Data.Rational). The model M is abstracted to the parameters
-- S, H, Feasible (A-HAM-2); hashes/commitments are abstract (A-HAM-3); parsing of the proposal
-- bytes is abstracted to its result `Input` (A-HAM-4).

open import Data.Rational as ℚ using (ℚ) renaming (_<_ to _<ℚ_; _≤_ to _≤ℚ_)
import Data.Rational.Properties as ℚP
open import Data.Maybe using (Maybe; just; nothing)
open import Data.List.Relation.Unary.Linked using (Linked; [-]; _∷_)
open import Data.Empty using (⊥; ⊥-elim)
open import Data.Unit using (⊤; tt)
open import Relation.Nullary using (¬_)
open import Relation.Nullary.Decidable using (_×-dec_)
open import Relation.Binary using (DecidableEquality)
open import Data.Nat using (_*_; _≟_; _≥_)
import Data.Nat.Properties as ℕP
open import Core.State using (Kind; hamiltonian-step; observation; ledger-append; capability; air-proof)

record Cfg : Set where
  field
    B   : ℕ
    E   : ℕ
    B≥1 : 1 ≤ B
    E≥1 : 1 ≤ E

data Op : Set where
  step-op advance-op : Op

ham? : (k : Kind) → Dec (k ≡ hamiltonian-step)
ham? hamiltonian-step = yes refl
ham? observation      = no (λ ())
ham? ledger-append    = no (λ ())
ham? capability       = no (λ ())
ham? air-proof        = no (λ ())

data HReason : Set where
  ok malformed wrong-kind stale-seq bad-prev bad-payload bad-epoch
    epoch-exhausted infeasible energy-not-decreasing : HReason

-- lexicographic order on ℕ × ℕ (the suggested termination measure's order)
data _<lex_ : ℕ × ℕ → ℕ × ℕ → Set where
  left  : ∀ {a b a′ b′} → a < a′ → (a , b) <lex (a′ , b′)
  right : ∀ {a b b′}    → b < b′ → (a , b) <lex (a , b′)

∸-suc : ∀ {m n} → n < m → m ∸ n ≡ suc (m ∸ suc n)
∸-suc {suc m} {zero}  _         = refl
∸-suc {suc m} {suc n} (s≤s n<m) = ∸-suc n<m

∸-mono-< : ∀ {m n} → n < m → m ∸ suc n < m ∸ n
∸-mono-< {m} {n} n<m rewrite ∸-suc n<m = ≤-refl

module Engine
  (S         : Set)
  (_≟S_      : DecidableEquality S)
  (H         : S → ℚ)
  (Feasible  : S → Set)
  (feasible? : ∀ s → Dec (Feasible s))
  (Hash      : Set)
  (_≟h_      : DecidableEquality Hash)
  (zeroHash  : Hash)                          -- 0^64
  (modelCommit : Hash)                        -- commit(M)
  (commitRec : ℕ → Hash → Hash → Hash)        -- seq, prev, payload ↦ self (kind fixed)
  (payloadHash : Op → S → ℕ → ℕ → Hash)       -- op, assign, epoch, estep ↦ payload_sha256
  (genesisPayload : Hash)
  (cfg       : Cfg)
  where

  open Cfg cfg
  open ℕP using (+-comm; +-assoc; *-suc; m≤m+n; m≤n+m; +-monoʳ-≤; +-monoˡ-≤; *-monoˡ-≤; m∸n≤m;
                 ∸-monoʳ-≤; n≤1+n)

  record EState : Set where
    constructor estate
    field
      seq     : ℕ
      prev    : Hash
      self    : Hash
      payload : Hash
      model   : Hash
      epoch   : ℕ
      used    : ℕ
      assign  : S
      energy  : ℚ
  open EState

  record Prop : Set where
    constructor prop
    field
      op         : Op
      pseq       : ℕ
      prevCommit : Hash
      payloadSha : Hash
      pepoch     : ℕ
      passign    : S
  open Prop

  -- result of `parse`: nothing = not a record (row 1); body nothing = row 3 failure
  record Parsed : Set where
    constructor parsed
    field
      kind : Kind
      body : Maybe Prop
  open Parsed

  Input : Set
  Input = Maybe Parsed

  data Decision : Set where
    accept : EState → Decision
    reject : (r : HReason) → r ≢ ok → Decision

  stateOf : Decision → Maybe EState
  stateOf (accept σ)   = just σ
  stateOf (reject _ _) = nothing

  reasonOf : Decision → HReason
  reasonOf (accept _)   = ok
  reasonOf (reject r _) = r

  Inv : EState → Set
  Inv σ = Feasible (assign σ) × (energy σ ≡ H (assign σ)) × (used σ ≤ B) × (epoch σ < E)
        × (model σ ≡ modelCommit) × (self σ ≡ commitRec (seq σ) (prev σ) (payload σ))

  genesis : S → Maybe EState
  genesis a with feasible? a
  ... | yes _ = just (estate 0 zeroHash (commitRec 0 zeroHash genesisPayload) genesisPayload
                             modelCommit 0 0 a (H a))
  ... | no _  = nothing

  estep : Op → EState → ℕ
  estep step-op    σ = suc (used σ)
  estep advance-op σ = 0

  newPayload : EState → Prop → Hash
  newPayload σ p = payloadHash (op p) (passign p) (pepoch p) (estep (op p) σ)

  nextStep : EState → Prop → EState
  nextStep σ p = estate (suc (seq σ)) (self σ)
                        (commitRec (suc (seq σ)) (self σ) (newPayload σ p)) (newPayload σ p)
                        (model σ) (epoch σ) (suc (used σ)) (passign p) (H (passign p))

  -- energy is carried over (equal to H a under Inv, since a ≡ assign σ is checked)
  nextAdv : EState → Prop → EState
  nextAdv σ p = estate (suc (seq σ)) (self σ)
                       (commitRec (suc (seq σ)) (self σ) (newPayload σ p)) (newPayload σ p)
                       (model σ) (suc (epoch σ)) 0 (passign p) (energy σ)

  guard : ∀ {A : Set} → Dec A → (r : HReason) → r ≢ ok → Decision → Decision
  guard (yes _) r ne k = k
  guard (no _)  r ne k = reject r ne

  guard-acc : ∀ {A : Set} (d : Dec A) {r ne k σ′} → guard d r ne k ≡ accept σ′ → A × k ≡ accept σ′
  guard-acc (yes a) eq = a , eq
  guard-acc (no _)  ()

  guard-yes : ∀ {A : Set} (d : Dec A) {r ne k} → A → guard d r ne k ≡ k
  guard-yes (yes _) _ = refl
  guard-yes (no ¬a) a = ⊥-elim (¬a a)

  guard-no : ∀ {A : Set} (d : Dec A) {r ne k} → ¬ A → reasonOf (guard d r ne k) ≡ r
  guard-no (yes a) ¬a = ⊥-elim (¬a a)
  guard-no (no _)  _  = refl

  -- rows 7–10 for `step`, rows 7–8 for `epoch_advance` (table order of OBLIGATIONS.md §1.6)
  decideOp : EState → Prop → Op → Decision
  decideOp σ p step-op =
    guard (pepoch p ≟ epoch σ) bad-epoch (λ ()) (
    guard (used σ <? B) epoch-exhausted (λ ()) (
    guard (feasible? (passign p)) infeasible (λ ()) (
    guard (H (passign p) ℚP.<? energy σ) energy-not-decreasing (λ ()) (
    accept (nextStep σ p)))))
  decideOp σ p advance-op =
    guard ((pepoch p ≟ suc (epoch σ)) ×-dec (passign p ≟S assign σ)) bad-epoch (λ ()) (
    guard (pepoch p <? E) epoch-exhausted (λ ()) (
    accept (nextAdv σ p)))

  -- rows 4–6
  decideProp : EState → Prop → Decision
  decideProp σ p =
    guard (pseq p ≟ suc (seq σ)) stale-seq (λ ()) (
    guard (prevCommit p ≟h self σ) bad-prev (λ ()) (
    guard (payloadSha p ≟h newPayload σ p) bad-payload (λ ()) (
    decideOp σ p (op p))))

  -- rows 1–3
  decide : EState → Input → Decision
  decide σ nothing   = reject malformed (λ ())
  decide σ (just pr) = guard (ham? (kind pr)) wrong-kind (λ ()) (decideBody (body pr))
    where
    decideBody : Maybe Prop → Decision
    decideBody nothing  = reject malformed (λ ())
    decideBody (just p) = decideProp σ p

  Envelope : EState → Prop → Set
  Envelope σ p = (pseq p ≡ suc (seq σ)) × (prevCommit p ≡ self σ) × (payloadSha p ≡ newPayload σ p)

  StepChecks : EState → Prop → Set
  StepChecks σ p = (pepoch p ≡ epoch σ) × (used σ < B) × Feasible (passign p) × (H (passign p) <ℚ energy σ)

  AdvChecks : EState → Prop → Set
  AdvChecks σ p = (pepoch p ≡ suc (epoch σ)) × (passign p ≡ assign σ) × (pepoch p < E)

  data Accepted (σ : EState) : Input → EState → Set where
    acc-step : ∀ pr p → kind pr ≡ hamiltonian-step → body pr ≡ just p → op p ≡ step-op
             → Envelope σ p → StepChecks σ p → Accepted σ (just pr) (nextStep σ p)
    acc-adv  : ∀ pr p → kind pr ≡ hamiltonian-step → body pr ≡ just p → op p ≡ advance-op
             → Envelope σ p → AdvChecks σ p → Accepted σ (just pr) (nextAdv σ p)

  ------------------------------------------------------------------
  -- H-1: rejection never constructs a state (by construction of Decision), and genesis on an
  -- infeasible assignment produces no state.
  H1-reject-no-state : ∀ σ inp r ne → decide σ inp ≡ reject r ne → stateOf (decide σ inp) ≡ nothing
  H1-reject-no-state σ inp r ne eq rewrite eq = refl

  H1-genesis-infeasible : ∀ a → ¬ Feasible a → genesis a ≡ nothing
  H1-genesis-infeasible a ¬f with feasible? a
  ... | yes f = ⊥-elim (¬f f)
  ... | no _  = refl

  -- H-2: determinism (at the Decision level; byte serialization is not modelled, A-HAM-3)
  H2-deterministic : ∀ {σ₁ σ₂ i₁ i₂} → σ₁ ≡ σ₂ → i₁ ≡ i₂ → decide σ₁ i₁ ≡ decide σ₂ i₂
  H2-deterministic refl refl = refl

  -- soundness inversion: every ACCEPT is one of the two accepted shapes
  decideOp-sound : ∀ σ p o {σ′} → op p ≡ o → Envelope σ p → decideOp σ p o ≡ accept σ′
                 → ∀ pr → kind pr ≡ hamiltonian-step → body pr ≡ just p → Accepted σ (just pr) σ′
  decideOp-sound σ p step-op o≡ env eq pr k b
    with guard-acc (pepoch p ≟ epoch σ) eq
  ... | e , eq₁ with guard-acc (used σ <? B) eq₁
  ... | u , eq₂ with guard-acc (feasible? (passign p)) eq₂
  ... | f , eq₃ with guard-acc (H (passign p) ℚP.<? energy σ) eq₃
  ... | h , refl = acc-step pr p k b o≡ env (e , u , f , h)
  decideOp-sound σ p advance-op o≡ env eq pr k b
    with guard-acc ((pepoch p ≟ suc (epoch σ)) ×-dec (passign p ≟S assign σ)) eq
  ... | (e , a) , eq₁ with guard-acc (pepoch p <? E) eq₁
  ... | l , refl = acc-adv pr p k b o≡ env (e , a , l)

  decide-sound : ∀ σ inp {σ′} → decide σ inp ≡ accept σ′ → Accepted σ inp σ′
  decide-sound σ nothing ()
  decide-sound σ (just pr) eq with guard-acc (ham? (kind pr)) eq
  ... | k , eq₁ with body pr in b
  ...   | nothing = case eq₁
    where case : ∀ {A : Set} → reject malformed (λ ()) ≡ accept _ → A
          case ()
  ...   | just p with guard-acc (pseq p ≟ suc (seq σ)) eq₁
  ...     | s , eq₂ with guard-acc (prevCommit p ≟h self σ) eq₂
  ...     | v , eq₃ with guard-acc (payloadSha p ≟h newPayload σ p) eq₃
  ...     | w , eq₄ = decideOp-sound σ p (op p) refl (s , v , w) eq₄ pr k b

  ------------------------------------------------------------------
  -- H-3: step soundness
  H3-step-sound : ∀ σ inp {σ′} → decide σ inp ≡ accept σ′ →
    ∀ pr p → inp ≡ just pr → body pr ≡ just p → op p ≡ step-op →
    Feasible (assign σ′) × (H (assign σ′) <ℚ energy σ) × (used σ < B) × (used σ′ ≡ suc (used σ))
    × (epoch σ′ ≡ epoch σ) × (seq σ′ ≡ suc (seq σ)) × (prev σ′ ≡ self σ)
  H3-step-sound σ inp eq pr p refl b o with decide-sound σ inp eq
  ... | acc-step _ p′ _ b′ _ _ (_ , u , f , h) = f , h , u , refl , refl , refl , refl
  ... | acc-adv _ p′ _ b′ o′ _ _ with trans (sym b) b′
  ...   | refl with trans (sym o) o′
  ...     | ()

  -- (with Inv σ the energy comparison is H σ′.assign < H σ.assign, as stated in H-3)
  H3-step-sound-H : ∀ σ inp {σ′} → Inv σ → decide σ inp ≡ accept σ′ →
    ∀ pr p → inp ≡ just pr → body pr ≡ just p → op p ≡ step-op → H (assign σ′) <ℚ H (assign σ)
  H3-step-sound-H σ inp {σ′} (_ , e , _) eq pr p i b o =
    subst (H (assign σ′) <ℚ_) e (proj₁ (proj₂ (H3-step-sound σ inp eq pr p i b o)))

  -- H-4: step completeness
  decideOp-step-complete : ∀ σ p → StepChecks σ p → decideOp σ p step-op ≡ accept (nextStep σ p)
  decideOp-step-complete σ p (e , u , f , h) =
    trans (guard-yes (pepoch p ≟ epoch σ) e)
    (trans (guard-yes (used σ <? B) u)
    (trans (guard-yes (feasible? (passign p)) f)
           (guard-yes (H (passign p) ℚP.<? energy σ) h)))

  decideOp-adv-complete : ∀ σ p → AdvChecks σ p → decideOp σ p advance-op ≡ accept (nextAdv σ p)
  decideOp-adv-complete σ p (e , a , l) =
    trans (guard-yes ((pepoch p ≟ suc (epoch σ)) ×-dec (passign p ≟S assign σ)) (e , a))
          (guard-yes (pepoch p <? E) l)

  decideProp-complete : ∀ σ p {d} → Envelope σ p → decideOp σ p (op p) ≡ d → decideProp σ p ≡ d
  decideProp-complete σ p (s , v , w) eq =
    trans (guard-yes (pseq p ≟ suc (seq σ)) s)
    (trans (guard-yes (prevCommit p ≟h self σ) v)
    (trans (guard-yes (payloadSha p ≟h newPayload σ p) w) eq))

  decide-complete : ∀ σ pr p {d} → kind pr ≡ hamiltonian-step → body pr ≡ just p
                  → decideProp σ p ≡ d → decide σ (just pr) ≡ d
  decide-complete σ (parsed .hamiltonian-step .(just p)) p refl refl eq = eq

  -- H-4: step completeness
  H4-step-complete : ∀ σ pr p → kind pr ≡ hamiltonian-step → body pr ≡ just p → op p ≡ step-op
    → Envelope σ p → StepChecks σ p → decide σ (just pr) ≡ accept (nextStep σ p)
  H4-step-complete σ pr p k b o env chk =
    decide-complete σ pr p k b (decideProp-complete σ p env
      (subst (λ x → decideOp σ p x ≡ accept (nextStep σ p)) (sym o) (decideOp-step-complete σ p chk)))

  -- epoch_advance completeness (companion of H-4)
  adv-complete : ∀ σ pr p → kind pr ≡ hamiltonian-step → body pr ≡ just p → op p ≡ advance-op
    → Envelope σ p → AdvChecks σ p → decide σ (just pr) ≡ accept (nextAdv σ p)
  adv-complete σ pr p k b o env chk =
    decide-complete σ pr p k b (decideProp-complete σ p env
      (subst (λ x → decideOp σ p x ≡ accept (nextAdv σ p)) (sym o) (decideOp-adv-complete σ p chk)))

  ------------------------------------------------------------------
  -- H-5: explicit epoch transitions
  H5-advance-sound : ∀ σ inp {σ′} → decide σ inp ≡ accept σ′ →
    ∀ pr p → inp ≡ just pr → body pr ≡ just p → op p ≡ advance-op →
    (epoch σ′ ≡ suc (epoch σ)) × (epoch σ′ < E) × (used σ′ ≡ 0) × (assign σ′ ≡ assign σ)
    × (energy σ′ ≡ energy σ) × (seq σ′ ≡ suc (seq σ)) × (prev σ′ ≡ self σ)
    × (self σ′ ≡ commitRec (seq σ′) (prev σ′) (payload σ′))
  H5-advance-sound σ inp eq pr p refl b o with decide-sound σ inp eq
  ... | acc-adv _ p′ _ _ _ _ (e , a , l) = refl , subst (_< E) e l , refl , a , refl , refl , refl , refl
  ... | acc-step _ p′ _ b′ o′ _ _ with trans (sym b) b′
  ...   | refl with trans (sym o) o′
  ...     | ()

  -- H-5 (second half): the epoch changes ONLY through an accepted epoch_advance; a step keeps it.
  H5-epoch-only-by-advance : ∀ {σ inp σ′} → Accepted σ inp σ′ → ¬ (epoch σ′ ≡ epoch σ)
    → Σ Prop (λ p → op p ≡ advance-op)
  H5-epoch-only-by-advance (acc-step pr p _ _ _ _ _) ne = ⊥-elim (ne refl)
  H5-epoch-only-by-advance (acc-adv pr p _ _ o _ _) ne = p , o

  ------------------------------------------------------------------
  -- H-6: invariant preservation (and genesis establishes Inv)
  H6-genesis : ∀ a {σ} → genesis a ≡ just σ → Inv σ
  H6-genesis a eq with feasible? a
  H6-genesis a refl | yes f = f , refl , z≤n , Cfg.E≥1 cfg , refl , refl
  H6-genesis a ()   | no _

  H6-accepted : ∀ {σ inp σ′} → Inv σ → Accepted σ inp σ′ → Inv σ′
  H6-accepted (_ , _ , _ , ep , m , _) (acc-step pr p _ _ _ _ (_ , u , f , _)) =
    f , refl , u , ep , m , refl
  H6-accepted {σ} (fσ , eσ , _ , _ , m , _) (acc-adv pr p _ _ _ _ (e , a , l)) =
    subst Feasible (sym a) fσ , trans eσ (cong H (sym a)) , z≤n , subst (_< E) e l , m , refl

  H6-preserve : ∀ σ inp {σ′} → Inv σ → decide σ inp ≡ accept σ′ → Inv σ′
  H6-preserve σ inp i eq = H6-accepted i (decide-sound σ inp eq)

  ------------------------------------------------------------------
  -- H-7: bounded-epoch strict descent, by induction on accepted runs

  data Run : EState → EState → Set where
    []  : ∀ {σ} → Run σ σ
    _∷_ : ∀ {σ inp σ₁ σ₂} → Accepted σ inp σ₁ → Run σ₁ σ₂ → Run σ σ₂

  -- runs can be built directly from decide results
  run-cons : ∀ {σ σ₁ σ₂} inp → decide σ inp ≡ accept σ₁ → Run σ₁ σ₂ → Run σ σ₂
  run-cons {σ} inp eq r = decide-sound σ inp eq ∷ r

  len : ∀ {σ σ′} → Run σ σ′ → ℕ
  len []      = 0
  len (_ ∷ r) = suc (len r)

  nsteps : ∀ {σ σ′} → Run σ σ′ → ℕ
  nsteps []                    = 0
  nsteps (acc-step _ _ _ _ _ _ _ ∷ r) = suc (nsteps r)
  nsteps (acc-adv  _ _ _ _ _ _ _ ∷ r) = nsteps r

  nadv : ∀ {σ σ′} → Run σ σ′ → ℕ
  nadv []                    = 0
  nadv (acc-step _ _ _ _ _ _ _ ∷ r) = nadv r
  nadv (acc-adv  _ _ _ _ _ _ _ ∷ r) = suc (nadv r)

  run-inv : ∀ {σ σ′} → Inv σ → Run σ σ′ → Inv σ′
  run-inv i []      = i
  run-inv i (a ∷ r) = run-inv (H6-accepted i a) r

  -- The suggested measure (E − epoch, B − used) decreases lexicographically on EVERY accepted
  -- transition: `step` decreases the second component, `epoch_advance` the first.
  measure : EState → ℕ × ℕ
  measure σ = (E ∸ epoch σ , B ∸ used σ)

  H7-measure-decreases : ∀ {σ inp σ′} → Accepted σ inp σ′ → measure σ′ <lex measure σ
  H7-measure-decreases (acc-step pr p _ _ _ _ (_ , u , _ , _)) = right (∸-mono-< u)
  H7-measure-decreases {σ} (acc-adv pr p _ _ _ _ (e , _ , l)) =
    left (∸-mono-< (≤-trans (n≤1+n (suc (epoch σ))) (subst (_< E) e l)))

  -- Linearisation of the lexicographic measure used for counting (B+1 > B − used).
  μ : EState → ℕ
  μ σ = (E ∸ suc (epoch σ)) * suc B + (B ∸ used σ)

  ν : EState → ℕ
  ν σ = (E ∸ suc (epoch σ)) * B + (B ∸ used σ)


  μ-step : ∀ {σ p} → StepChecks σ p → suc (μ (nextStep σ p)) ≤ μ σ
  μ-step {σ} (_ , u , _ , _) rewrite ∸-suc u =
    ≤-reflexive (sym (+-suc ((E ∸ suc (epoch σ)) * suc B) (B ∸ suc (used σ))))
    where open ℕP using (≤-reflexive)

  ν-step : ∀ {σ p} → StepChecks σ p → suc (ν (nextStep σ p)) ≤ ν σ
  ν-step {σ} (_ , u , _ , _) rewrite ∸-suc u =
    ≤-reflexive (sym (+-suc ((E ∸ suc (epoch σ)) * B) (B ∸ suc (used σ))))
    where open ℕP using (≤-reflexive)

  μ-adv : ∀ {σ p} → AdvChecks σ p → suc (μ (nextAdv σ p)) ≤ μ σ
  μ-adv {σ} {p} (e , _ , l) rewrite ∸-suc (subst (_< E) e l) =
    ≤-trans (≤-reflexive (cong suc (+-comm (X * suc B) B))) (m≤m+n (suc B + X * suc B) (B ∸ used σ))
    where
    open ℕP using (≤-reflexive)
    X = E ∸ suc (suc (epoch σ))

  ν-adv : ∀ {σ p} → AdvChecks σ p → ν (nextAdv σ p) ≤ ν σ
  ν-adv {σ} {p} (e , _ , l) rewrite ∸-suc (subst (_< E) e l) =
    ≤-trans (≤-reflexive (+-comm (X * B) B)) (m≤m+n (B + X * B) (B ∸ used σ))
    where
    open ℕP using (≤-reflexive)
    X = E ∸ suc (suc (epoch σ))

  len-μ : ∀ {σ σ′} (r : Run σ σ′) → len r + μ σ′ ≤ μ σ
  len-μ []      = ≤-refl
  len-μ {σ} (acc-step pr p _ _ _ _ c ∷ r) = ≤-trans (s≤s (len-μ r)) (μ-step {σ} {p} c)
  len-μ {σ} (acc-adv  pr p _ _ _ _ c ∷ r) = ≤-trans (s≤s (len-μ r)) (μ-adv {σ} {p} c)

  steps-ν : ∀ {σ σ′} (r : Run σ σ′) → nsteps r + ν σ′ ≤ ν σ
  steps-ν []      = ≤-refl
  steps-ν {σ} (acc-step pr p _ _ _ _ c ∷ r) = ≤-trans (s≤s (steps-ν r)) (ν-step {σ} {p} c)
  steps-ν {σ} (acc-adv  pr p _ _ _ _ c ∷ r) = ≤-trans (steps-ν r) (ν-adv {σ} {p} c)

  μ-max : ∀ σ → μ σ ≤ (E ∸ 1) * suc B + B
  μ-max σ = +-mono-≤ (*-monoˡ-≤ (suc B) (∸-monoʳ-≤ E (s≤s z≤n))) (m∸n≤m B (used σ))

  ν-max : ∀ σ → ν σ ≤ (E ∸ 1) * B + B
  ν-max σ = +-mono-≤ (*-monoˡ-≤ B (∸-monoʳ-≤ E (s≤s z≤n))) (m∸n≤m B (used σ))

  bound-eq : (E ∸ 1) * suc B + B ≡ E * B + (E ∸ 1)
  bound-eq with E | Cfg.E≥1 cfg
  ... | suc E′ | _ = solve 2 (λ e b → e :* (con 1 :+ b) :+ b := b :+ e :* b :+ e) refl E′ B
    where open import Data.Nat.Solver using (module +-*-Solver)
          open +-*-Solver using (solve; _:=_; _:+_; _:*_; con)

  bound-eq-steps : (E ∸ 1) * B + B ≡ E * B
  bound-eq-steps with E | Cfg.E≥1 cfg
  ... | suc E′ | _ = +-comm (E′ * B) B

  -- H-7(b), total: k ≤ E·B + E − 1
  H7b-run-length : ∀ {σ σ′} (r : Run σ σ′) → len r ≤ E * B + (E ∸ 1)
  H7b-run-length {σ} r =
    subst (len r ≤_) bound-eq (≤-trans (≤-trans (m≤m+n (len r) _) (len-μ r)) (μ-max σ))

  -- H-7(b), steps: at most E·B step accepts
  H7b-steps : ∀ {σ σ′} (r : Run σ σ′) → nsteps r ≤ E * B
  H7b-steps {σ} r =
    subst (nsteps r ≤_) bound-eq-steps (≤-trans (≤-trans (m≤m+n (nsteps r) _) (steps-ν r)) (ν-max σ))

  -- H-7(b), advances: epoch grows by exactly one per advance, so at most E − 1 advances
  epoch-count : ∀ {σ σ′} (r : Run σ σ′) → nadv r + epoch σ ≡ epoch σ′
  epoch-count []                         = refl
  epoch-count (acc-step pr p _ _ _ _ _ ∷ r) = epoch-count r
  epoch-count {σ} (acc-adv pr p _ _ _ _ _ ∷ r) = trans (sym (+-suc (nadv r) (epoch σ))) (epoch-count r)

  H7b-advances : ∀ {σ σ′} → Inv σ → (r : Run σ σ′) → nadv r ≤ E ∸ 1
  H7b-advances {σ} {σ′} i r with run-inv i r
  ... | (_ , _ , _ , ep , _) =
    ≤-trans (≤-trans (m≤m+n (nadv r) (epoch σ)) (≤-reflexive (epoch-count r)))
            (≤-pred′ ep)
    where
    open ℕP using (≤-reflexive)
    ≤-pred′ : ∀ {a b} → a < b → a ≤ b ∸ 1
    ≤-pred′ {a} {suc b} (s≤s a≤b) = a≤b

  -- H-7(c): energy is non-increasing along any accepted run (strict on step, equal on advance)
  H7c-energy-nonincreasing : ∀ {σ σ′} → Run σ σ′ → energy σ′ ≤ℚ energy σ
  H7c-energy-nonincreasing []                           = ℚP.≤-refl
  H7c-energy-nonincreasing (acc-step pr p _ _ _ _ (_ , _ , _ , h) ∷ r) =
    ℚP.≤-trans (H7c-energy-nonincreasing r) (ℚP.<⇒≤ h)
  H7c-energy-nonincreasing (acc-adv  pr p _ _ _ _ _ ∷ r) = H7c-energy-nonincreasing r

  -- H-7(a): a segment of consecutive step accepts is a strict descent in energy, stays in one
  -- epoch, and has length ≤ B − used ≤ B.
  AllSteps : ∀ {σ σ′} → Run σ σ′ → Set
  AllSteps []                           = ⊤
  AllSteps (acc-step _ _ _ _ _ _ _ ∷ r) = AllSteps r
  AllSteps (acc-adv  _ _ _ _ _ _ _ ∷ r) = ⊥

  energies : ∀ {σ σ′} → Run σ σ′ → List ℚ
  tailE    : ∀ {σ σ′} → Run σ σ′ → List ℚ
  energies {σ} r = energy σ ∷ tailE r
  tailE []      = []
  tailE (_ ∷ r) = energies r

  H7a-strict-descent : ∀ {σ σ′} (r : Run σ σ′) → AllSteps r → Linked (λ x y → y <ℚ x) (energies r)
  H7a-strict-descent []                                         _ = [-]
  H7a-strict-descent (acc-step _ _ _ _ _ _ (_ , _ , _ , h) ∷ r) s = h ∷ H7a-strict-descent r s
  H7a-strict-descent (acc-adv  _ _ _ _ _ _ _ ∷ r)              ()

  H7a-same-epoch : ∀ {σ σ′} (r : Run σ σ′) → AllSteps r → epoch σ′ ≡ epoch σ
  H7a-same-epoch []                              _ = refl
  H7a-same-epoch (acc-step _ _ _ _ _ _ _ ∷ r)    s = H7a-same-epoch r s
  H7a-same-epoch (acc-adv  _ _ _ _ _ _ _ ∷ r)    ()

  H7a-length : ∀ {σ σ′} (r : Run σ σ′) → AllSteps r → len r ≤ B ∸ used σ
  H7a-length []                                         _ = z≤n
  H7a-length {σ} (acc-step _ _ _ _ _ _ (_ , u , _ , _) ∷ r) s
    rewrite ∸-suc u = s≤s (H7a-length r s)
  H7a-length (acc-adv _ _ _ _ _ _ _ ∷ r) ()

  H7a-length-B : ∀ {σ σ′} (r : Run σ σ′) → AllSteps r → len r ≤ B
  H7a-length-B {σ} r s = ≤-trans (H7a-length r s) (ℕP.m∸n≤m B (used σ))

  ------------------------------------------------------------------
  -- H-8: exactness. All energy comparisons are the decidable order of Data.Rational (exact,
  -- normalised); the examples from OBLIGATIONS.md hold as equalities by normalisation.
  H8-decidable : ∀ (x y : ℚ) → Dec (x <ℚ y)
  H8-decidable = ℚP._<?_

  ------------------------------------------------------------------
  -- H-9: reason precedence. `decide` is literally the guard chain in table order, so the reason
  -- is the first failing row. The rows the ratified order singles out (8 before 9 before 10):
  module _ (σ : EState) (pr : Parsed) (p : Prop)
           (k : kind pr ≡ hamiltonian-step) (b : body pr ≡ just p) (o : op p ≡ step-op)
           (env : Envelope σ p) (e : pepoch p ≡ epoch σ) where

    private
      viaOp : ∀ d → decideOp σ p step-op ≡ d → decide σ (just pr) ≡ d
      viaOp d eq = decide-complete σ pr p k b (decideProp-complete σ p env
                     (subst (λ x → decideOp σ p x ≡ d) (sym o) eq))

    H9-exhausted-first : ¬ (used σ < B) → reasonOf (decide σ (just pr)) ≡ epoch-exhausted
    H9-exhausted-first nu = trans (cong reasonOf (viaOp _ (guard-yes (pepoch p ≟ epoch σ) e)))
                                  (guard-no (used σ <? B) nu)

    H9-infeasible-second : used σ < B → ¬ Feasible (passign p) → reasonOf (decide σ (just pr)) ≡ infeasible
    H9-infeasible-second u nf =
      trans (cong reasonOf (viaOp _ (trans (guard-yes (pepoch p ≟ epoch σ) e) (guard-yes (used σ <? B) u))))
            (guard-no (feasible? (passign p)) nf)

    H9-energy-third : used σ < B → Feasible (passign p) → ¬ (H (passign p) <ℚ energy σ)
                    → reasonOf (decide σ (just pr)) ≡ energy-not-decreasing
    H9-energy-third u f nh =
      trans (cong reasonOf (viaOp _ (trans (guard-yes (pepoch p ≟ epoch σ) e)
                                    (trans (guard-yes (used σ <? B) u) (guard-yes (feasible? (passign p)) f)))))
            (guard-no (H (passign p) ℚP.<? energy σ) nh)

  -- rows 1–2
  H9-malformed : ∀ σ → reasonOf (decide σ nothing) ≡ malformed
  H9-malformed σ = refl

  H9-wrong-kind : ∀ σ pr → ¬ (kind pr ≡ hamiltonian-step) → reasonOf (decide σ (just pr)) ≡ wrong-kind
  H9-wrong-kind σ pr nk = guard-no (ham? (kind pr)) nk

------------------------------------------------------------------------
-- H-8 examples (normalisation on exact rationals)
open import Data.Integer using (+_)
open import Data.Rational using (_+_; _/_; 1ℚ)

H8-thirds : (+ 1 / 3) Data.Rational.+ (+ 1 / 3) Data.Rational.+ (+ 1 / 3) ≡ 1ℚ
H8-thirds = refl

H8-tenths : (+ 1 / 10) Data.Rational.+ (+ 2 / 10) ≡ + 3 / 10
H8-tenths = refl
