{-# OPTIONS --safe --without-K #-}
-- Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
-- Dual-licensed: AGPL-3.0-or-later plus SnapKitty Opaque License.
-- SPDX-License-Identifier: AGPL-3.0-or-later AND LicenseRef-SnapKitty-Opaque
--
-- JWST-LRD Mission QSO1-DCBH-001, role 07: growth-transition invariants.
--
-- Model (mirrors fortran/growth/src/lrd_growth.f90). For constant
-- (eps, lam, duty) the hole grows as dM/dt = rate * M with
--   rate = duty * (1 - eps)/eps * lam / t_Edd,
-- so over a total exponent E = rate * Dt the continuous growth factor is
-- exp(E). This file certifies, over the rationals:
--
--   * an EXACT SYMBOLIC THRESHOLD for the stepped (Euler) growth factor
--     factorOf step n = step ^ n: a seed reaches the target in the stepped
--     model iff seed * factor >= target (sufficiency AND necessity are the
--     same rational expression; no numerical constant is baked in);
--   * monotonicity: larger seeds end larger; any certified lower bound on
--     the factor turns into a sufficient seed condition;
--   * a CERTIFIED NUMERICAL BOUND for the directive's benchmark tuple
--     (Benchmark submodule): with the declared rational bounds
--       Dt >= 576/1000 Gyr   (solver: 0.5760588... Gyr, Planck 2018)
--       t_Edd <= 4505/10000 Gyr (CODATA 2018: 0.45049041... Gyr)
--     the total exponent obeys E >= 23/2, the 64-step Euler factor at
--     E = 23/2 is a closed rational, and 1300 * factor >= 5e7 is checked
--     by the decidable rational order. Hence, under assumption A-GR-1
--     below, any seed >= 1300 Msun reaches 5e7 Msun for the benchmark
--     tuple. (64 steps is a deliberate coarseness: finer discretizations
--     (512, 1024 steps) make Agda's conversion checker exhaust its heap
--     normalizing the rational arithmetic on this machine -- observed,
--     see agda/growth/STATUS.md -- while 64 steps keeps the certified
--     numbers small. The Euler factor underestimates exp(E) more at
--     fewer steps, so the certified seed is conservative: the solver's
--     numerical threshold is ~502 Msun.)
--     The solver's numerical minimum (~502 Msun) and the directive's
--     (~497 Msun) both lie below this certified sufficient bound, as they
--     must; 497 is NOT used anywhere in this file.
--
-- Assumption A-GR-1 (bridge to the Fortran solver, stated like A-ST-1 in
-- agda/Core/State.agda): for E <= E_true and n >= 1,
--   (1 + E/n) ^ n <= exp(E_true) = G,
-- the solver's growth factor. This is the standard Euler/exponential
-- inequality (each Euler step underestimates the exponential for a
-- non-negative rate, and exp is monotone). It is a PARAMETER of
-- Benchmark.verify, not a hidden postulate: the certificate is explicitly
-- conditional on it, and on the two declared input bounds above.

module Growth where

open import Data.Nat using (ℕ; zero; suc; _+_)
open import Data.Unit using (tt)
open import Data.Integer using (+_)
open import Data.Rational using (ℚ; _*_; _≤_; _<_; 0ℚ; 1ℚ; _/_; nonNegative)
open import Data.Rational.Properties
  using (*-comm; *-assoc; *-identityˡ; *-identityʳ; ≤-trans; ≤-refl;
         *-monoˡ-≤-nonNeg; *-monoʳ-≤-nonNeg; _≤?_)
open import Relation.Binary.PropositionalEquality
  using (_≡_; refl; cong; cong₂; sym; trans; subst; module ≡-Reasoning)
open import Relation.Nullary.Decidable using (True; toWitness)

open ≡-Reasoning

-- | An equality of rationals as an inequality (either direction via sym).
eq≤ : ∀ {a b} → a ≡ b → a ≤ b
eq≤ refl = ≤-refl

0≤1 : 0ℚ ≤ 1ℚ
0≤1 = toWitness tt

------------------------------------------------------------------------------
-- Stepped growth factor

-- | Rational power by repeated multiplication.
pow : ℚ → ℕ → ℚ
pow x zero    = 1ℚ
pow x (suc n) = x * pow x n

pow-add : ∀ x m n → pow x (m + n) ≡ pow x m * pow x n
pow-add x zero    n = sym (*-identityˡ (pow x n))
pow-add x (suc m) n = begin
  x * pow x (m + n)       ≡⟨ cong (x *_) (pow-add x m n) ⟩
  x * (pow x m * pow x n) ≡⟨ sym (*-assoc x (pow x m) (pow x n)) ⟩
  (x * pow x m) * pow x n ∎

-- | The stepped growth factor for per-step multiplier `step` over `n` steps.
factorOf : ℚ → ℕ → ℚ
factorOf step n = pow step n

-- | Squaring chain: sqPow x k = x ^ (2 ^ k), computed with k squarings.
-- Same value as `pow x (2 ^ k)` (proven below as sqPow≡pow), but Agda's
-- normalizer evaluates it with k rational multiplications instead of 2 ^ k,
-- which is what makes the benchmark certificate below feasible to check.
sqPow : ℚ → ℕ → ℚ
sqPow x zero    = x
sqPow x (suc k) = sqPow x k * sqPow x k

pow2 : ℕ → ℕ
pow2 zero    = 1
pow2 (suc k) = pow2 k + pow2 k

sqPow≡pow : ∀ x k → sqPow x k ≡ pow x (pow2 k)
sqPow≡pow x zero    = sym (*-identityʳ x)
sqPow≡pow x (suc k) = begin
  sqPow x k * sqPow x k     ≡⟨ cong₂ _*_ (sqPow≡pow x k) (sqPow≡pow x k) ⟩
  pow x (pow2 k) * pow x (pow2 k) ≡⟨ sym (pow-add x (pow2 k) (pow2 k)) ⟩
  pow x (pow2 k + pow2 k)   ∎

-- | Final mass of a seed under a growth factor.
grow : ℚ → ℚ → ℚ
grow factor seed = seed * factor

------------------------------------------------------------------------------
-- Factor bounds and monotonicity

factor≥1 : ∀ {step n} → 1ℚ ≤ step → 1ℚ ≤ factorOf step n
factor≥1 {step} {zero}  _      = ≤-refl
factor≥1 {step} {suc n} 1≤step =
  ≤-trans 1≤step
    (≤-trans (eq≤ (sym (*-identityʳ step)))
             (*-monoˡ-≤-nonNeg step (nonNegative (≤-trans 0≤1 1≤step))
                                (factor≥1 1≤step)))

factor≥0 : ∀ {step n} → 1ℚ ≤ step → 0ℚ ≤ factorOf step n
factor≥0 1≤step = ≤-trans 0≤1 (factor≥1 1≤step)

-- | Monotonicity in the seed: a larger seed ends at least as large.
grow-mono : ∀ {factor a b} → 0ℚ ≤ factor → a ≤ b → grow factor a ≤ grow factor b
grow-mono {factor} factor≥0 a≤b =
  *-monoʳ-≤-nonNeg factor (nonNegative factor≥0) a≤b

------------------------------------------------------------------------------
-- The exact symbolic threshold

-- | SUFFICIENCY, in threshold form. If fLo is a certified lower bound on
-- the true factor and seed * fLo already reaches the target, the seed
-- reaches the target. The threshold seed* = target / fLo is this statement
-- read backwards; it stays symbolic (target and fLo are parameters).
sufficient : ∀ {seed target fLo factor}
           → 0ℚ ≤ seed → fLo ≤ factor → target ≤ seed * fLo
           → target ≤ grow factor seed
sufficient {seed} seed≥0 fLo≤factor bound =
  ≤-trans bound (*-monoˡ-≤-nonNeg seed (nonNegative seed≥0) fLo≤factor)

-- | NECESSITY for the stepped model itself: if seed * factor < target the
-- seed does not reach the target in the stepped model. Together with
-- `sufficient` at fLo = factor this makes target / factor the EXACT
-- threshold of the stepped model, not an approximation.
necessary : ∀ {seed target factor}
          → seed * factor < target → grow factor seed < target
necessary lt = lt

------------------------------------------------------------------------------
-- Benchmark certificate (directive tuple: z_obs = 7.04221, target 5e7 Msun,
-- z_form = 20, eps = 0.1, lam = 1, duty = 1)

module Benchmark where

  -- Declared rational input bounds (see the file header for provenance).
  dtLo   : ℚ
  dtLo   = + 576 / 1000        -- <= Dt = 0.5760588... Gyr (solver, Planck 2018)
  tEddHi : ℚ
  tEddHi = + 4505 / 10000      -- >= t_Edd = 0.45049041... Gyr (CODATA 2018)

  -- Total exponent lower bound: E = 9 * Dt / t_Edd >= 23/2, proven in
  -- cross-multiplied form (all quantities positive):
  --   (23/2) * tEddHi <= 9 * dtLo.
  eLo : ℚ
  eLo = + 23 / 2

  eLo-cert : eLo * tEddHi ≤ (+ 9 / 1) * dtLo
  eLo-cert = toWitness tt

  -- Per-step multiplier at E = eLo in 64 steps: 1 + (23/2)/64 = 151/128.
  step : ℚ
  step = + 151 / 128

  step≥1 : 1ℚ ≤ step
  step≥1 = toWitness tt

  -- The certified Euler factor (closed rational; Agda normalizes it).
  factorCert : ℚ
  factorCert = factorOf step 64

  -- The same factor computed by the squaring chain (6 multiplications
  -- instead of 64); the closed check below is done on this form.
  factorCertFast : ℚ
  factorCertFast = sqPow step 6

  factorCert≡fast : factorCert ≡ factorCertFast
  factorCert≡fast = sym (sqPow≡pow step 6)

  -- The certified sufficient seed: 1300 Msun.
  seedBound : ℚ
  seedBound = + 1300 / 1

  target : ℚ
  target = + 50000000 / 1

  -- Closed check, decided by Agda's normalization: 5e7 <= 1300 * factorCert.
  certFast : target ≤ seedBound * factorCertFast
  certFast = toWitness tt

  cert : target ≤ seedBound * factorCert
  cert = subst (λ f → target ≤ seedBound * f) (sym factorCert≡fast) certFast

  -- | The certificate, conditional on bridge assumption A-GR-1 (a caller
  -- supplied proof that factorCert lower-bounds the solver's continuous
  -- growth factor G) and on the seed being at least the certified bound:
  -- the seed reaches the target under G.
  verify : ∀ {G seed}
         → factorCert ≤ G            -- A-GR-1 for the benchmark tuple
         → seedBound ≤ seed
         → 0ℚ ≤ seed
         → target ≤ grow G seed
  verify {G} {seed} bridge seed≥bound seed≥0 =
    sufficient seed≥0 bridge
      (≤-trans cert (*-monoʳ-≤-nonNeg factorCert
                       (nonNegative (factor≥0 step≥1)) seed≥bound))
