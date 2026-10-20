-- Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
-- JWST-LRD Sovereign Scientific Runtime -- formal verification kernel (Agda).
-- Dual-licensed, intentionally: AGPL-3.0-only AND SnapKitty Opaque License.
-- SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
--
-- Module boundary: VERIFIED CORE (--safe --without-K). No postulates.
--
-- Causal ordering over events with integer coordinates (c = 1 units;
-- the runtime quantises to a fixed grid).  Interval classification by
-- the sign of  s² = Δt² − Δx² − Δy² − Δz²  (exact ℤ arithmetic):
-- timelike (s²>0), lightlike (s²=0), spacelike (s²<0), indeterminate
-- (some position unknown).  Proved:
--   * an accepted edge is timelike or lightlike AND future-directed;
--   * for ANY edge set with a rank certificate (DAG certificate), the
--     transitive closure is a strict partial order (irreflexive,
--     transitive, asymmetric); coordinate time is such a certificate
--     for accepted causal edges;
--   * timestamp order does not imply causal order (explicit
--     counterexample).
-- Not proved (gap): that a *composite* path of causal edges is itself
-- geometrically causal (needs the reverse triangle inequality).
{-# OPTIONS --safe --without-K #-}
module Kernel.Causal where

open import Data.Empty using (⊥; ⊥-elim)
open import Data.Unit.Base using (⊤; tt)
import Data.Bool.Base
open import Data.Nat.Base using (ℕ; zero; suc)
open import Data.Integer.Base as ℤ using (ℤ; +_; -[1+_]; _-_; _*_; _+_; _<_; +<+)
open import Data.Integer.Properties as ℤP using (_<?_)
open import Data.Nat.Base as ℕ using (s≤s; z≤n)
open import Data.List.Base using (List; []; _∷_)
open import Data.List.Membership.Propositional using (_∈_)
open import Data.Maybe.Base using (Maybe; just; nothing)
open import Data.Product.Base using (_×_; _,_; Σ)
open import Data.Sum.Base using (_⊎_; inj₁; inj₂)
open import Relation.Nullary using (yes; no; ¬_)
open import Relation.Binary.PropositionalEquality using (_≡_; refl)
open import Kernel.Decision

record Pos : Set where
  constructor pos
  field x y z : ℤ

record Event : Set where
  constructor event
  field
    eid  : ℕ
    time : ℤ
    loc  : Maybe Pos     -- nothing: position not determined
open Event public

data Interval : Set where
  timelike lightlike spacelike indeterminate : Interval

sq : ℤ → ℤ
sq a = a * a

interval² : ℤ → Pos → Pos → ℤ
interval² dt (pos x₁ y₁ z₁) (pos x₂ y₂ z₂) =
  sq dt - (sq (x₂ - x₁) + sq (y₂ - y₁) + sq (z₂ - z₁))

signClass : ℤ → Interval
signClass (+ zero)  = lightlike
signClass (+ suc _) = timelike
signClass -[1+ _ ]  = spacelike

classify : Event → Event → Interval
classify a b with loc a | loc b
... | just p | just q = signClass (interval² (time b - time a) p q)
... | _      | _      = indeterminate

IsCausal : Interval → Set
IsCausal timelike  = ⊤
IsCausal lightlike = ⊤
IsCausal _         = ⊥

isCausal? : Interval → Data.Bool.Base.Bool
isCausal? timelike  = Data.Bool.Base.true
isCausal? lightlike = Data.Bool.Base.true
isCausal? _         = Data.Bool.Base.false

causal⇒tl : ∀ {i} → IsCausal i → i ≡ timelike ⊎ i ≡ lightlike
causal⇒tl {timelike}  _ = inj₁ refl
causal⇒tl {lightlike} _ = inj₂ refl

-- Proof-carrying accepted edge.
record CausalEdge : Set where
  constructor causalEdge
  field
    src dst : Event
    causal  : IsCausal (classify src dst)
    future  : time src < time dst
open CausalEdge public

causalDec : ∀ i → (IsCausal i) ⊎ ¬ (IsCausal i)
causalDec timelike      = inj₁ tt
causalDec lightlike     = inj₁ tt
causalDec spacelike     = inj₂ λ ()
causalDec indeterminate = inj₂ λ ()

checkEdge : Event → Event → Outcome CausalEdge
checkEdge a b with causalDec (classify a b) | time a <? time b
... | inj₁ c | yes f = accept (causalEdge a b c f)
... | _      | _     = reject not-causal

-- Accepted edges are timelike or lightlike and future-directed.
accepted-edge-causal : ∀ a b {e} → checkEdge a b ≡ accept e →
  (classify a b ≡ timelike ⊎ classify a b ≡ lightlike) × time a < time b
accepted-edge-causal a b eq with causalDec (classify a b) | time a <? time b
accepted-edge-causal a b refl | inj₁ c | yes f = causal⇒tl c , f
accepted-edge-causal a b ()   | inj₁ _ | no _
accepted-edge-causal a b ()   | inj₂ _ | _

-- Edges that are not causal, or not future-directed, are rejected.
checkEdge-rejects-noncausal : ∀ a b → ¬ IsCausal (classify a b) → Σ _ λ r → checkEdge a b ≡ reject r
checkEdge-rejects-noncausal a b ¬c with causalDec (classify a b) | time a <? time b
... | inj₁ c | _     = ⊥-elim (¬c c)
... | inj₂ _ | yes _ = not-causal , refl
... | inj₂ _ | no _  = not-causal , refl

------------------------------------------------------------------------
-- Strict partial order from a DAG (rank) certificate — generic.

module DagOrder {V E : Set} (from to : E → V) (G : List E) where

  data _⇝_ : V → V → Set where
    edge  : ∀ {e} → e ∈ G → from e ⇝ to e
    _⨾_   : ∀ {a b c} → a ⇝ b → b ⇝ c → a ⇝ c

  ⇝-trans : ∀ {a b c} → a ⇝ b → b ⇝ c → a ⇝ c
  ⇝-trans = _⨾_

  -- DAG certificate: a ℤ-valued rank strictly increasing along edges.
  record DagCert : Set where
    field
      rank      : V → ℤ
      rank-mono : ∀ {e} → e ∈ G → rank (from e) < rank (to e)

  module _ (cert : DagCert) where
    open DagCert cert
    ⇝-rank : ∀ {a b} → a ⇝ b → rank a < rank b
    ⇝-rank (edge m) = rank-mono m
    ⇝-rank (p ⨾ q)  = ℤP.<-trans (⇝-rank p) (⇝-rank q)

    ⇝-irrefl : ∀ {a} → ¬ (a ⇝ a)
    ⇝-irrefl p = ℤP.<-irrefl refl (⇝-rank p)

    ⇝-asym : ∀ {a b} → a ⇝ b → ¬ (b ⇝ a)
    ⇝-asym p q = ⇝-irrefl (p ⨾ q)

-- Instance: accepted causal edges; coordinate time is the certificate.
module CausalOrder (G : List CausalEdge) where
  open DagOrder src dst G public

  timeCert : DagCert
  timeCert = record { rank = time ; rank-mono = λ {e} _ → future e }

  causal-irrefl : ∀ {a} → ¬ (a ⇝ a)
  causal-irrefl = ⇝-irrefl timeCert

  causal-trans : ∀ {a b c} → a ⇝ b → b ⇝ c → a ⇝ c
  causal-trans = ⇝-trans

  causal-asym : ∀ {a b} → a ⇝ b → ¬ (b ⇝ a)
  causal-asym = ⇝-asym timeCert

------------------------------------------------------------------------
-- Timestamp order alone does not imply causal order.

e₀ e₁ : Event
e₀ = event 0 (+ 0) (just (pos (+ 0) (+ 0) (+ 0)))
e₁ = event 1 (+ 1) (just (pos (+ 5) (+ 0) (+ 0)))   -- s² = 1 − 25 < 0

e₀-before-e₁ : time e₀ < time e₁
e₀-before-e₁ = +<+ (s≤s z≤n)

e₀e₁-spacelike : classify e₀ e₁ ≡ spacelike
e₀e₁-spacelike = refl

e₀e₁-rejected : checkEdge e₀ e₁ ≡ reject not-causal
e₀e₁-rejected = refl

timestamp⇏causal : ¬ (∀ a b → time a < time b → IsCausal (classify a b))
timestamp⇏causal h = h e₀ e₁ e₀-before-e₁
