{-# OPTIONS --safe --without-K #-}
-- Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
-- Dual-licensed: AGPL-3.0-or-later plus SnapKitty Opaque License.
-- SPDX-License-Identifier: AGPL-3.0-or-later AND LicenseRef-SnapKitty-Opaque
--
-- JWST-LRD Sovereign Scientific Runtime -- TASK 011: Agda verified core.
-- Obligation group LED: Godel prime ledger, list/exponent model, and bijective base-256.
--
-- LIST/EXPONENT MODEL (same abstraction as research/alloy/GodelLedger.als): a Godel code
--   G = prod_i p_i ^ e_i
-- is represented by its exponent list [e_0, e_1, ...] (position i <-> i-th prime). The integer
-- product is never computed, so the fundamental theorem of arithmetic is not needed here
-- (assumption A-LED-1). Symbols are naturals s (indices into a symbol table) and are written as
-- the exponent suc s, so exponent 0 never encodes a symbol (Alloy A5).
--
-- Proved:
--   decode-append       : decode (append L x) ≡ map (_++ [ x ]) (decode L)          for ALL L
--   decode-append-valid : decode L ≡ just xs → decode (append L x) ≡ just (xs ++ [ x ])
--   decode-encode       : decode (encode xs) ≡ just xs
--   encode-decode       : decode L ≡ just xs → encode xs ≡ L
--   (so encode is a bijection between symbol lists and the decodable exponent lists)
--
-- BIJECTIVE BASE-256: digit d : Fin 256 denotes the value suc (toℕ d) ∈ {1..256}, little-endian.
--   b256-decode-encode : ∀ n  → b256-decode (b256-encode n) ≡ n
--   b256-encode-decode : ∀ ds → b256-encode (b256-decode ds) ≡ ds
--   i.e. a genuine bijection ℕ ≃ List (Fin 256) (both round trips, no side conditions).

module Core.PrimeLedger where

open import Data.Nat using (ℕ; zero; suc; _+_; _*_; _%_; _<_)
open import Data.Nat.Properties as ℕP using (suc-injective; +-comm; *-comm; *-suc; +-cancelˡ-≡; *-cancelˡ-≡)
open import Data.Nat.DivMod using ([m+kn]%n≡m%n; m<n⇒m%n≡m)
open import Data.Fin using (Fin; toℕ; lower₁; #_) renaming (zero to fz; suc to fs)
open import Data.Fin.Properties using (toℕ-injective; toℕ<n; toℕ-lower₁)
open import Data.List using (List; []; _∷_; _++_; [_]; map)
open import Data.Maybe using (Maybe; just; nothing; _>>=_) renaming (map to mmap)
open import Relation.Binary.PropositionalEquality hiding ([_])
open import Relation.Nullary using (yes; no)

------------------------------------------------------------------------
-- Ledger in the list/exponent model

Symbol : Set
Symbol = ℕ

Ledger : Set
Ledger = List ℕ          -- exponent of p_0, p_1, ...

symExp : Symbol → ℕ
symExp s = suc s

expSym : ℕ → Maybe Symbol
expSym zero    = nothing  -- exponent 0 is malformed
expSym (suc s) = just s

encode : List Symbol → Ledger
encode = map symExp

decode : Ledger → Maybe (List Symbol)
decode []       = just []
decode (e ∷ es) = expSym e >>= λ s → mmap (s ∷_) (decode es)

-- append L x puts the code of x on the next unused prime p_n, n = length L.
append : Ledger → Symbol → Ledger
append L x = L ++ [ symExp x ]

decode-append : ∀ L x → decode (append L x) ≡ mmap (_++ [ x ]) (decode L)
decode-append []           x = refl
decode-append (zero  ∷ es) x = refl
decode-append (suc s ∷ es) x with decode es | decode-append es x
... | just ys | eq rewrite eq = refl
... | nothing | eq rewrite eq = refl

decode-append-valid : ∀ L x {xs} → decode L ≡ just xs → decode (append L x) ≡ just (xs ++ [ x ])
decode-append-valid L x {xs} d rewrite decode-append L x | d = refl

decode-encode : ∀ xs → decode (encode xs) ≡ just xs
decode-encode []       = refl
decode-encode (x ∷ xs) rewrite decode-encode xs = refl

encode-decode : ∀ L {xs} → decode L ≡ just xs → encode xs ≡ L
encode-decode []           refl = refl
encode-decode (zero  ∷ es) ()
encode-decode (suc s ∷ es) d with decode es in eq
encode-decode (suc s ∷ es) refl | just ys = cong (suc s ∷_) (encode-decode es eq)
encode-decode (suc s ∷ es) ()   | nothing

------------------------------------------------------------------------
-- Bijective base-256 numeration

Digit : Set
Digit = Fin 256

-- value of a digit string: digit d stands for suc (toℕ d) ∈ {1..256}, least significant first
b256-decode : List Digit → ℕ
b256-decode []       = 0
b256-decode (d ∷ ds) = suc (toℕ d) + 256 * b256-decode ds

-- successor on digit strings (digit 256 rolls over to digit 1 with a carry)
bump : (d : Digit) → toℕ d ≢ 255 → Digit
bump d ne = lower₁ (fs d) (λ eq → ne (sym (suc-injective eq)))

toℕ-bump : ∀ d ne → toℕ (bump d ne) ≡ suc (toℕ d)
toℕ-bump d ne = toℕ-lower₁ (fs d) (λ eq → ne (sym (suc-injective eq)))

inc : List Digit → List Digit
inc []       = fz ∷ []
inc (d ∷ ds) with toℕ d ℕP.≟ 255
... | yes _  = fz ∷ inc ds
... | no  ne = bump d ne ∷ ds

b256-encode : ℕ → List Digit
b256-encode zero    = []
b256-encode (suc n) = inc (b256-encode n)

decode-inc : ∀ ds → b256-decode (inc ds) ≡ suc (b256-decode ds)
decode-inc []       = refl
decode-inc (d ∷ ds) with toℕ d ℕP.≟ 255
... | yes eq rewrite eq | decode-inc ds = cong suc (*-suc 256 (b256-decode ds))
... | no  ne = cong (λ k → suc k + 256 * b256-decode ds) (toℕ-bump d ne)

b256-decode-encode : ∀ n → b256-decode (b256-encode n) ≡ n
b256-decode-encode zero    = refl
b256-decode-encode (suc n) rewrite decode-inc (b256-encode n) = cong suc (b256-decode-encode n)

-- uniqueness of the low digit
low-digit : ∀ a b x y → a < 256 → b < 256 → a + 256 * x ≡ b + 256 * y → a ≡ b
low-digit a b x y a< b< eq = begin
  a                    ≡⟨ sym (m<n⇒m%n≡m a<) ⟩
  a % 256              ≡⟨ sym ([m+kn]%n≡m%n a x 256) ⟩
  (a + x * 256) % 256  ≡⟨ cong (λ k → (a + k) % 256) (*-comm x 256) ⟩
  (a + 256 * x) % 256  ≡⟨ cong (_% 256) eq ⟩
  (b + 256 * y) % 256  ≡⟨ cong (λ k → (b + k) % 256) (*-comm 256 y) ⟩
  (b + y * 256) % 256  ≡⟨ [m+kn]%n≡m%n b y 256 ⟩
  b % 256              ≡⟨ m<n⇒m%n≡m b< ⟩
  b                    ∎
  where open ≡-Reasoning

b256-decode-injective : ∀ ds es → b256-decode ds ≡ b256-decode es → ds ≡ es
b256-decode-injective []       []       _  = refl
b256-decode-injective []       (e ∷ es) ()
b256-decode-injective (d ∷ ds) []       ()
b256-decode-injective (d ∷ ds) (e ∷ es) eq = cong₂ _∷_ d≡e (b256-decode-injective ds es tl)
  where
  eq′ : toℕ d + 256 * b256-decode ds ≡ toℕ e + 256 * b256-decode es
  eq′ = suc-injective eq
  td≡te : toℕ d ≡ toℕ e
  td≡te = low-digit (toℕ d) (toℕ e) (b256-decode ds) (b256-decode es) (toℕ<n d) (toℕ<n e) eq′
  d≡e : d ≡ e
  d≡e = toℕ-injective td≡te
  tl : b256-decode ds ≡ b256-decode es
  tl = *-cancelˡ-≡ (b256-decode ds) (b256-decode es) 256 (+-cancelˡ-≡ (toℕ d) (256 * b256-decode ds) (256 * b256-decode es) (trans eq′ (cong (_+ 256 * b256-decode es) (sym td≡te))))

b256-encode-decode : ∀ ds → b256-encode (b256-decode ds) ≡ ds
b256-encode-decode ds =
  b256-decode-injective _ _ (b256-decode-encode (b256-decode ds))

------------------------------------------------------------------------
-- Sanity computations (checked by normalisation)
-- 256 = digit value 256 (Fin index 255); 257 = 1 + 256·1 (two digits of value 1)
b256-256 : b256-encode 256 ≡ (# 255) ∷ []
b256-256 = refl

b256-257 : b256-encode 257 ≡ fz ∷ fz ∷ []
b256-257 = refl

ledger-example : decode (append (encode (3 ∷ 0 ∷ [])) 7) ≡ just (3 ∷ 0 ∷ 7 ∷ [])
ledger-example = refl
