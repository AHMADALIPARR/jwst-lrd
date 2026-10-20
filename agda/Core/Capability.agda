{-# OPTIONS --safe --without-K #-}
-- Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
-- Dual-licensed: AGPL-3.0-or-later plus SnapKitty Opaque License.
-- SPDX-License-Identifier: AGPL-3.0-or-later AND LicenseRef-SnapKitty-Opaque
--
-- JWST-LRD Sovereign Scientific Runtime -- TASK 011: Agda verified core.
-- Obligation group CAP: capability transition validity -- replay and rollback are rejected.
-- Mirrors the guard of research/alloy/CapabilityAddressing.als (TASK 010), but as unbounded
-- machine-checked proofs (no scope / step bound).
--
-- A verifier accepts a message only if (i) it is authentic (`Genuine`, a decidable MODULE
-- PARAMETER -- assumption A-CAP-1, the MAC/signature scheme is not modelled), (ii) its capability
-- is not retired, (iii) its nonce is fresh, (iv) it chains from the current head, and (v) its
-- seqId is strictly greater than the authoritative counter (gaps allowed, as in TASK 010 G3).
--
--   submit-sound / submit-complete : acceptance ⇔ Valid
--   invalid-rejected               : every invalid transition is rejected (no state is built)
--   replay-rejected / rollback-rejected / retired-rejected : the specific cases
--   run-mono-*                     : counter, used nonces and retired caps only grow over runs
--   no-replay-after, no-rollback-after, no-double-accept, retired-forever :
--       once a message is accepted (resp. a cap retired) the corresponding later submissions
--       are rejected after ANY sequence of further events

open import Data.Nat using (ℕ)
open import Relation.Nullary using (Dec)

module Core.Capability
  (Msg      : Set)
  (cap nonce seqId prevC newC : Msg → ℕ)   -- commitments abstracted to ℕ (A-CAP-2)
  (Genuine  : Msg → Set)
  (genuine? : ∀ m → Dec (Genuine m))
  where

open import Data.Nat using (_<_; _≤_; _<?_; _≟_)
open import Data.Nat.Properties using (≤-refl; ≤-trans; <⇒≤; <-≤-trans; ≤⇒≯; <-irrefl)
open import Data.List using (List; []; _∷_)
open import Data.List.Membership.Propositional using (_∈_)
open import Data.List.Membership.DecPropositional _≟_ using (_∈?_)
open import Data.List.Relation.Unary.Any using (here; there)
open import Data.Product using (_×_; _,_; Σ; proj₁; proj₂)
open import Data.Empty using (⊥-elim)
open import Relation.Nullary using (yes; no; ¬_)
open import Relation.Binary.PropositionalEquality

record Verifier : Set where
  constructor verifier
  field
    head    : ℕ          -- current head commitment
    counter : ℕ          -- authoritative monotonic counter (outside the worker, A-CAP-3)
    used    : List ℕ     -- nonces already accepted
    retired : List ℕ     -- retired capabilities (retirement is permanent, A-CAP-4)
open Verifier public

Valid : Verifier → Msg → Set
Valid v m = Genuine m × ¬ (cap m ∈ retired v) × ¬ (nonce m ∈ used v)
          × (prevC m ≡ head v) × (counter v < seqId m)

data Reason : Set where
  forged retired-cap replay bad-prev rollback : Reason

data Result : Set where
  accepted : Verifier → Result
  rejected : Reason → Result

accept : Verifier → Msg → Verifier
accept v m = verifier (newC m) (seqId m) (nonce m ∷ used v) (retired v)

submit : Verifier → Msg → Result
submit v m with genuine? m | cap m ∈? retired v | nonce m ∈? used v
              | prevC m ≟ head v | counter v <? seqId m
... | no _  | _     | _     | _     | _     = rejected forged
... | yes _ | yes _ | _     | _     | _     = rejected retired-cap
... | yes _ | no _  | yes _ | _     | _     = rejected replay
... | yes _ | no _  | no _  | no _  | _     = rejected bad-prev
... | yes _ | no _  | no _  | yes _ | no _  = rejected rollback
... | yes _ | no _  | no _  | yes _ | yes _ = accepted (accept v m)

submit-sound : ∀ v m {v′} → submit v m ≡ accepted v′ → Valid v m × v′ ≡ accept v m
submit-sound v m eq with genuine? m | cap m ∈? retired v | nonce m ∈? used v
                       | prevC m ≟ head v | counter v <? seqId m
submit-sound v m () | no _  | _     | _     | _     | _
submit-sound v m () | yes _ | yes _ | _     | _     | _
submit-sound v m () | yes _ | no _  | yes _ | _     | _
submit-sound v m () | yes _ | no _  | no _  | no _  | _
submit-sound v m () | yes _ | no _  | no _  | yes _ | no _
submit-sound v m refl | yes g | no r | no u | yes p | yes c = (g , r , u , p , c) , refl

submit-complete : ∀ v m → Valid v m → submit v m ≡ accepted (accept v m)
submit-complete v m (g , r , u , p , c) with genuine? m | cap m ∈? retired v | nonce m ∈? used v
                                           | prevC m ≟ head v | counter v <? seqId m
... | no ¬g | _     | _     | _     | _     = ⊥-elim (¬g g)
... | yes _ | yes r′ | _    | _     | _     = ⊥-elim (r r′)
... | yes _ | no _  | yes u′ | _    | _     = ⊥-elim (u u′)
... | yes _ | no _  | no _  | no ¬p | _     = ⊥-elim (¬p p)
... | yes _ | no _  | no _  | yes _ | no ¬c = ⊥-elim (¬c c)
... | yes _ | no _  | no _  | yes _ | yes _ = refl

-- Invalid transitions are never accepted.
invalid-rejected : ∀ v m → ¬ Valid v m → Σ Reason (λ r → submit v m ≡ rejected r)
invalid-rejected v m ¬val with submit v m in eq
... | rejected r = r , refl
... | accepted _ = ⊥-elim (¬val (proj₁ (submit-sound v m eq)))

replay-rejected : ∀ v m → nonce m ∈ used v → Σ Reason (λ r → submit v m ≡ rejected r)
replay-rejected v m u = invalid-rejected v m (λ val → proj₁ (proj₂ (proj₂ val)) u)

rollback-rejected : ∀ v m → seqId m ≤ counter v → Σ Reason (λ r → submit v m ≡ rejected r)
rollback-rejected v m le = invalid-rejected v m (λ val → ≤⇒≯ le (proj₂ (proj₂ (proj₂ (proj₂ val)))))

retired-rejected : ∀ v m → cap m ∈ retired v → Σ Reason (λ r → submit v m ≡ rejected r)
retired-rejected v m r = invalid-rejected v m (λ val → proj₁ (proj₂ val) r)

forged-rejected : ∀ v m → ¬ Genuine m → Σ Reason (λ r → submit v m ≡ rejected r)
forged-rejected v m ¬g = invalid-rejected v m (λ val → ¬g (proj₁ val))

------------------------------------------------------------------------
-- Runs

data Event : Set where
  submitE : Msg → Event
  retireE : ℕ → Event

applyR : Verifier → Result → Verifier
applyR v (accepted v′) = v′
applyR v (rejected _)  = v

stepE : Verifier → Event → Verifier
stepE v (submitE m) = applyR v (submit v m)
stepE v (retireE c) = verifier (head v) (counter v) (used v) (c ∷ retired v)

runE : Verifier → List Event → Verifier
runE v []       = v
runE v (e ∷ es) = runE (stepE v e) es

_⊆_ : List ℕ → List ℕ → Set
xs ⊆ ys = ∀ {x} → x ∈ xs → x ∈ ys

-- monotonicity of one event
record Grows (v w : Verifier) : Set where
  field
    counter≤ : counter v ≤ counter w
    used⊆    : used v ⊆ used w
    retired⊆ : retired v ⊆ retired w
open Grows

grows-refl : ∀ v → Grows v v
grows-refl v = record { counter≤ = ≤-refl ; used⊆ = λ x → x ; retired⊆ = λ x → x }

grows-trans : ∀ {u v w} → Grows u v → Grows v w → Grows u w
grows-trans g h = record
  { counter≤ = ≤-trans (counter≤ g) (counter≤ h)
  ; used⊆    = λ x → used⊆ h (used⊆ g x)
  ; retired⊆ = λ x → retired⊆ h (retired⊆ g x) }

step-grows : ∀ v e → Grows v (stepE v e)
step-grows v (retireE c) = record { counter≤ = ≤-refl ; used⊆ = λ x → x ; retired⊆ = there }
step-grows v (submitE m) with submit v m in eq
... | rejected _  = grows-refl v
... | accepted v′ with submit-sound v m eq
...   | (_ , _ , _ , _ , c) , refl =
        record { counter≤ = <⇒≤ c ; used⊆ = there ; retired⊆ = λ x → x }

run-grows : ∀ v es → Grows v (runE v es)
run-grows v []       = grows-refl v
run-grows v (e ∷ es) = grows-trans (step-grows v e) (run-grows (stepE v e) es)

run-mono-counter : ∀ v es → counter v ≤ counter (runE v es)
run-mono-counter v es = counter≤ (run-grows v es)

run-mono-used : ∀ v es → used v ⊆ used (runE v es)
run-mono-used v es = used⊆ (run-grows v es)

run-mono-retired : ∀ v es → retired v ⊆ retired (runE v es)
run-mono-retired v es = retired⊆ (run-grows v es)

------------------------------------------------------------------------
-- Safety after acceptance

-- After m is accepted, any later message reusing m's nonce is rejected, whatever happens between.
no-replay-after : ∀ v m {v′} → submit v m ≡ accepted v′ → ∀ es m′ → nonce m′ ≡ nonce m
                → Σ Reason (λ r → submit (runE v′ es) m′ ≡ rejected r)
no-replay-after v m eq es m′ n≡ with submit-sound v m eq
... | _ , refl = replay-rejected (runE (accept v m) es) m′
                   (run-mono-used (accept v m) es (subst (_∈ (nonce m ∷ used v)) (sym n≡) (here refl)))

-- After m is accepted, any later message whose seqId is not above m's is rejected.
no-rollback-after : ∀ v m {v′} → submit v m ≡ accepted v′ → ∀ es m′ → seqId m′ ≤ seqId m
                  → Σ Reason (λ r → submit (runE v′ es) m′ ≡ rejected r)
no-rollback-after v m eq es m′ le with submit-sound v m eq
... | _ , refl = rollback-rejected (runE (accept v m) es) m′
                   (≤-trans le (run-mono-counter (accept v m) es))

-- The same message is never accepted twice.
no-double-accept : ∀ v m {v′} → submit v m ≡ accepted v′ → ∀ es
                 → Σ Reason (λ r → submit (runE v′ es) m ≡ rejected r)
no-double-accept v m eq es = no-replay-after v m eq es m refl

-- Once a capability is retired it is rejected forever.
retired-forever : ∀ v c es m → cap m ≡ c
                → Σ Reason (λ r → submit (runE (stepE v (retireE c)) es) m ≡ rejected r)
retired-forever v c es m refl =
  retired-rejected (runE (stepE v (retireE c)) es) m (run-mono-retired (stepE v (retireE c)) es (here refl))
