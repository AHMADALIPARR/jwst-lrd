{-# OPTIONS --safe --without-K #-}
-- SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
-- Negative control: this file MUST NOT typecheck.
module BadGrowth where
open import Growth
open import Data.Integer using (+_)
open import Data.Rational using (_/_; _≤_)
open import Data.Unit using (tt)
false-certificate : Benchmark.target ≤ (+ 1 / 1)
false-certificate = checked Benchmark.target (+ 1 / 1) tt
