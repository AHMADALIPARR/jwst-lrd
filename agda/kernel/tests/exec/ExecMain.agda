-- Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
-- JWST-LRD Sovereign Scientific Runtime -- formal verification kernel (Agda).
-- Dual-licensed, intentionally: AGPL-3.0-only AND SnapKitty Opaque License.
-- SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
--
-- Module boundary: TEST HARNESS (not part of the verified core).
-- Not --safe only because the stdlib IO module requires --guardedness
-- and is not --safe.  Contains no postulate.  Runs the kernel's smart
-- constructors and checkers on sample inputs and prints one result per
-- line; scripts/exec.sh compares the output with tests/exec/expected.txt.
-- The ℕ-multiplicative "group" and the toy hash below are INSECURE test
-- instances: they exercise the code paths, not the cryptography.
{-# OPTIONS --without-K --guardedness #-}
module ExecMain where

open import Data.Bool.Base using (Bool; true; false; if_then_else_)
open import Data.Bool.Show using () renaming (show to showB)
open import Data.Nat.Base using (ℕ; zero; suc; _*_; _+_; _<ᵇ_)
open import Data.Nat.Show using () renaming (show to showℕ)
open import Data.Nat.Properties as ℕP using (*-assoc; *-identityˡ)
open import Data.Integer.Base using (ℤ; +_; -[1+_])
open import Data.List.Base as List using (List; []; _∷_; length; foldr)
open import Data.Maybe.Base using (Maybe; just; nothing)
open import Data.Product.Base using (_,_; proj₁; proj₂)
open import Data.String.Base using (String; _++_; intersperse)
open import Data.Unit.Base using (⊤; tt)
open import Relation.Binary.PropositionalEquality using (refl)
open import IO using (Main; run; putStrLn; _>>_; pure)

open import Kernel.Decision
open import Kernel.Observation
open import Kernel.Sequence as Seq using (MonoSeq; tryAppend; elems)
open import Kernel.PrimeLedger as PL using (PrimeBasis; mkBasis; encode; decode; Ledger; genesisLedger; append; entries; code)
open import Kernel.RSA using (PMonoid; module Accumulator)
open import Kernel.Causal as C using (Event; event; pos; checkEdge; classify; Interval)
open import Kernel.Simplicial as Sx using (∂s; ∂; isZeroChain)
open import Kernel.Capability as Cap using (issue; consume; genesisAuth; ledgerAppend)

showList : List ℕ → String
showList xs = "[" ++ intersperse "," (List.map showℕ xs) ++ "]"

showMaybeList : Maybe (List ℕ) → String
showMaybeList (just xs) = "just " ++ showList xs
showMaybeList nothing   = "nothing"

showOutcome : ∀ {A} → Outcome A → String
showOutcome (accept _) = "ACCEPT ok"
showOutcome (reject r) = "REJECT " ++ reasonToken r

showInterval : Interval → String
showInterval C.timelike      = "timelike"
showInterval C.lightlike     = "lightlike"
showInterval C.spacelike     = "spacelike"
showInterval C.indeterminate = "indeterminate"

------------------------------------------------------------------------
-- Observation
f : ℕ → ℤ → ℕ → Maybe UnitTag → RawField
f = field′

obsValid obsUnsorted obsDen0 obsNotReduced obsNoUnit obsEmptyKey obsDupKey : RawObs
obsValid      = obs 1 (f 1 (+ 3) 2 (just microjansky) ∷ f 2 -[1+ 0 ] 1 (just micron) ∷ [])
obsUnsorted   = obs 2 (f 2 (+ 3) 2 (just microjansky) ∷ f 1 (+ 1) 1 (just micron) ∷ [])
obsDen0       = obs 3 (f 1 (+ 3) 0 (just microjansky) ∷ [])
obsNotReduced = obs 4 (f 1 (+ 2) 4 (just microjansky) ∷ [])
obsNoUnit     = obs 5 (f 1 (+ 3) 2 nothing ∷ [])
obsEmptyKey   = obs 6 (f 0 (+ 3) 2 (just kelvin) ∷ [])
obsDupKey     = obs 7 (f 1 (+ 3) 2 (just kelvin) ∷ f 1 (+ 5) 2 (just kelvin) ∷ [])

------------------------------------------------------------------------
-- Sequence
seqRun : List ℕ → MonoSeq → List String
seqRun []       s = ("seq.final " ++ showList (elems s)) ∷ []
seqRun (x ∷ xs) s = ("seq.append " ++ showℕ x ++ " " ++ showOutcome (tryAppend s x)) ∷ seqRun xs (settle s (tryAppend s x))

------------------------------------------------------------------------
-- Prime ledger
basisLines : List String
basisLines with mkBasis (2 ∷ 3 ∷ 5 ∷ 7 ∷ 11 ∷ 13 ∷ []) | mkBasis (2 ∷ 4 ∷ []) | mkBasis (3 ∷ 2 ∷ []) | mkBasis (2 ∷ 3 ∷ [])
... | just B | b2 | b3 | just B2 =
    ("ledger.basis[2,3,5,7,11,13] " ++ ok?) ∷ ("ledger.basis[2,4] " ++ isJ b2) ∷ ("ledger.basis[3,2] " ++ isJ b3)
  ∷ ("ledger.encode[3,1,4,1,5] " ++ showℕ (encode B es))
  ∷ ("ledger.decode(encode[3,1,4,1,5]) " ++ showMaybeList (decode B (encode B es)))
  ∷ ("ledger.decode(14) " ++ showMaybeList (decode B 14))
  ∷ ("ledger.decode(1) " ++ showMaybeList (decode B 1))
  ∷ ledgerRun B es (genesisLedger B)
  List.++ ledgerRun B2 (7 ∷ 8 ∷ 9 ∷ []) (genesisLedger B2)
  where
  ok? = "just"
  es = 3 ∷ 1 ∷ 4 ∷ 1 ∷ 5 ∷ []
  isJ : Maybe PrimeBasis → String
  isJ (just _) = "just"
  isJ nothing  = "nothing"
  ledgerRun : (B : PrimeBasis) → List ℕ → Ledger B → List String
  ledgerRun B []       L = ("ledger.final entries=" ++ showList (entries L) ++ " code=" ++ showℕ (code L)
                            ++ " decode=" ++ showMaybeList (decode B (code L))) ∷ []
  ledgerRun B (e ∷ es) L = ("ledger.append " ++ showℕ e ++ " " ++ showOutcome (append L e)) ∷ ledgerRun B es (settle L (append L e))
... | _ | _ | _ | _ = "ledger.basis FAILED" ∷ []

------------------------------------------------------------------------
-- RSA accumulator over the (insecure) multiplicative monoid of ℕ
ℕ× : PMonoid
ℕ× = record { Carrier = ℕ ; _∙_ = _*_ ; ε = 1 ; assoc = *-assoc ; identityˡ = *-identityˡ ; _≟_ = ℕP._≟_ }

open Accumulator ℕ× 2 using (acc; verify; witness; checkWitness; tryAdd; genesisAcc; members; AccState)

isJustC : ∀ {A : Set} → Maybe A → String
isJustC (just _) = "cert"
isJustC nothing  = "nothing"

S₀ : List ℕ
S₀ = 3 ∷ 5 ∷ 7 ∷ []

rsaLines : List String
rsaLines =
    ("rsa.verify member=5 " ++ showB (verify (acc S₀) 5 (witness S₀ 5)))
  ∷ ("rsa.verify nonmember=11 " ++ showB (verify (acc S₀) 11 (witness S₀ 11)))
  ∷ ("rsa.verify wrongwitness=5 " ++ showB (verify (acc S₀) 5 (witness S₀ 3)))
  ∷ ("rsa.checkWitness member=7 " ++ isJustC (checkWitness (acc S₀) 7 (witness S₀ 7)))
  ∷ ("rsa.checkWitness nonmember=11 " ++ isJustC (checkWitness (acc S₀) 11 (witness S₀ 11)))
  ∷ addRun (3 ∷ 4 ∷ 3 ∷ 5 ∷ []) genesisAcc
  where
  addRun : List ℕ → AccState → List String
  addRun []       s = ("rsa.members " ++ showList (members s)) ∷ []
  addRun (x ∷ xs) s = ("rsa.add " ++ showℕ x ++ " " ++ showOutcome (tryAdd s x)) ∷ addRun xs (settle s (tryAdd s x))

------------------------------------------------------------------------
-- Causal
p : ℤ → ℤ → Maybe C.Pos
p x y = just (pos x y (+ 0))

ev0 evSpace evTime evLight evPast evUnknown : Event
ev0       = event 0 (+ 0)  (p (+ 0) (+ 0))
evSpace   = event 1 (+ 1)  (p (+ 5) (+ 0))
evTime    = event 2 (+ 10) (p (+ 1) (+ 2))
evLight   = event 3 (+ 5)  (p (+ 3) (+ 4))
evPast    = event 4 -[1+ 4 ] (p (+ 0) (+ 0))
evUnknown = event 5 (+ 7)  nothing

edgeLine : String → Event → Event → String
edgeLine n a b = "causal.edge " ++ n ++ " " ++ showInterval (classify a b) ++ " " ++ showOutcome (checkEdge a b)

causalLines : List String
causalLines =
    edgeLine "0->space" ev0 evSpace ∷ edgeLine "0->time" ev0 evTime ∷ edgeLine "0->light" ev0 evLight
  ∷ edgeLine "0->past" ev0 evPast ∷ edgeLine "0->unknown" ev0 evUnknown ∷ []

------------------------------------------------------------------------
-- Simplicial
tetra : List ℕ
tetra = 0 ∷ 1 ∷ 2 ∷ 3 ∷ []

simplicialLines : List String
simplicialLines =
    ("simplicial.boundary(tetra).terms " ++ showℕ (length (∂s tetra)))
  ∷ ("simplicial.boundary(tetra).zero " ++ showB (isZeroChain (∂s tetra)))
  ∷ ("simplicial.dd(tetra).terms " ++ showℕ (length (∂ (∂s tetra))))
  ∷ ("simplicial.dd(tetra).zero " ++ showB (isZeroChain (∂ (∂s tetra))))
  ∷ ("simplicial.ddd(tetra).zero " ++ showB (isZeroChain (∂ (∂ (∂s tetra)))))
  ∷ ("simplicial.dd(triangle).zero " ++ showB (isZeroChain (∂ (∂s (4 ∷ 5 ∷ 6 ∷ [])))))
  ∷ []

------------------------------------------------------------------------
-- Hamiltonian (S = ℕ, E = id, feasible = below 100)
open import Kernel.Hamiltonian {ℕ} (λ n → n) using (module Checked)
open Checked (λ n → n <ᵇ 100) using (hamCheck)

hamLines : List String
hamLines =
    ("ham.check budget=0 5->3 " ++ showOutcome (hamCheck 0 5 3))
  ∷ ("ham.check budget=0 5->200 " ++ showOutcome (hamCheck 0 5 200))
  ∷ ("ham.check budget=1 5->200 " ++ showOutcome (hamCheck 1 5 200))
  ∷ ("ham.check budget=1 5->7 " ++ showOutcome (hamCheck 1 5 7))
  ∷ ("ham.check budget=1 5->5 " ++ showOutcome (hamCheck 1 5 5))
  ∷ ("ham.check budget=1 5->3 " ++ showOutcome (hamCheck 1 5 3))
  ∷ []

------------------------------------------------------------------------
-- Capability
capLines : List String
capLines with issue genesisAuth ledgerAppend
... | c , st₁ with consume st₁ c
...   | o₁ =
    ("cap.consume first " ++ showOutcome o₁)
  ∷ ("cap.consume second " ++ showOutcome (consume (settle st₁ o₁) c))
  ∷ ("cap.consume after-rollback " ++ showOutcome (consume st₁ c))
  ∷ ("cap.consume unissued-authority " ++ showOutcome (consume genesisAuth c))
  ∷ []

------------------------------------------------------------------------
-- Composed kernel (LRD-STATE-v1 envelope + kinds), toy digest = ℕ
import Kernel.State
module St = Kernel.State ℕ ℕP._≟_
open St using (LrdState; lrdState; proposal; Kind)

kindCode : Kind → ℕ
kindCode St.observation      = 1
kindCode St.ledger-append    = 2
kindCode St.hamiltonian-step = 3
kindCode St.capability       = 4
kindCode St.air-proof        = 5

toyHash : LrdState → ℕ
toyHash (lrdState q c k pl) = 7 + q * 1000003 + c * 7919 + kindCode k * 104729 + pl * 31

basis2 : PrimeBasis
basis2 = PL.basis (2 ∷ 3 ∷ []) (fromJustPrime) (PL._∷_ (Data.List.Relation.Unary.All._∷_ (Data.Nat.Base.s≤s (Data.Nat.Base.s≤s (Data.Nat.Base.s≤s Data.Nat.Base.z≤n))) Data.List.Relation.Unary.All.[]) (PL._∷_ Data.List.Relation.Unary.All.[] PL.[]))
  where
  import Data.List.Relation.Unary.All
  import Data.Nat.Base
  open import Data.Nat.Primality using (Prime; prime?)
  open import Relation.Nullary.Decidable using (toWitness)
  fromJustPrime : Data.List.Relation.Unary.All.All Prime (2 ∷ 3 ∷ [])
  fromJustPrime = toWitness {a? = Data.List.Relation.Unary.All.all? prime? (2 ∷ 3 ∷ [])} tt

genesisHead : LrdState
genesisHead = lrdState 0 0 St.observation 0

open import Kernel.AcceptedState ℕ ℕP._≟_ toyHash basis2 ℕ (λ n → n) (λ n → n <ᵇ 100) (λ x → x <ᵇ 10) genesisHead 50 3
  using (genesis; step; next; fullProposal; obsP; ledgerP; hamP; airP; head; KernelState)

kernelLines : List String
kernelLines =
    ("kernel.obs seq=1 " ++ showOutcome (step g (fullProposal (proposal St.observation h0 1 9) (obsP obsValid))))
  ∷ ("kernel.replay seq=1 " ++ showOutcome (step k1 (fullProposal (proposal St.observation h0 1 9) (obsP obsValid))))
  ∷ ("kernel.badprev seq=2 " ++ showOutcome (step k1 (fullProposal (proposal St.observation 12345 2 9) (obsP obsValid))))
  ∷ ("kernel.stale seq=5 " ++ showOutcome (step k1 (fullProposal (proposal St.observation h1 5 9) (obsP obsValid))))
  ∷ ("kernel.wrongkind seq=2 " ++ showOutcome (step k1 (fullProposal (proposal St.observation h1 2 9) (ledgerP 4))))
  ∷ ("kernel.invalidobs seq=2 " ++ showOutcome (step k1 (fullProposal (proposal St.observation h1 2 9) (obsP obsUnsorted))))
  ∷ ("kernel.ledger seq=2 " ++ showOutcome (step k1 (fullProposal (proposal St.ledger-append h1 2 9) (ledgerP 4))))
  ∷ ("kernel.ham seq=2 50->40 " ++ showOutcome (step k1 (fullProposal (proposal St.hamiltonian-step h1 2 9) (hamP 40))))
  ∷ ("kernel.ham seq=2 50->60 " ++ showOutcome (step k1 (fullProposal (proposal St.hamiltonian-step h1 2 9) (hamP 60))))
  ∷ ("kernel.air seq=2 bad " ++ showOutcome (step k1 (fullProposal (proposal St.air-proof h1 2 9) (airP 42))))
  ∷ ("kernel.head.seq after accept=" ++ showℕ (LrdState.seq (head k1)) ++ " after reject=" ++ showℕ (LrdState.seq (head k1′)))
  ∷ []
  where
  g  = genesis
  h0 = toyHash (head g)
  k1 = next g (fullProposal (proposal St.observation h0 1 9) (obsP obsValid))
  h1 = toyHash (head k1)
  k1′ = next k1 (fullProposal (proposal St.observation h0 1 9) (obsP obsValid))

------------------------------------------------------------------------
allLines : List String
allLines =
    ("obs.valid " ++ showB (isValidᵇ obsValid))
  ∷ ("obs.unsorted " ++ showB (isValidᵇ obsUnsorted))
  ∷ ("obs.den0 " ++ showB (isValidᵇ obsDen0))
  ∷ ("obs.not-reduced " ++ showB (isValidᵇ obsNotReduced))
  ∷ ("obs.no-unit " ++ showB (isValidᵇ obsNoUnit))
  ∷ ("obs.empty-key " ++ showB (isValidᵇ obsEmptyKey))
  ∷ ("obs.dup-key " ++ showB (isValidᵇ obsDupKey))
  ∷ seqRun (3 ∷ 5 ∷ 4 ∷ 5 ∷ 9 ∷ []) Seq.empty
  List.++ basisLines List.++ rsaLines List.++ causalLines List.++ simplicialLines
  List.++ hamLines List.++ capLines List.++ kernelLines

main : Main
main = run (foldr (λ s io → putStrLn s >> io) (pure _) allLines)
