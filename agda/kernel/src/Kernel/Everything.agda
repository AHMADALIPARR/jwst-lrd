-- Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
-- JWST-LRD Sovereign Scientific Runtime -- formal verification kernel (Agda).
-- Dual-licensed, intentionally: AGPL-3.0-only AND SnapKitty Opaque License.
-- SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
--
-- Module boundary: VERIFIED CORE aggregate (--safe --without-K).
-- Type-checking this module type-checks every core and assumption-
-- statement module.  Used by scripts/check.sh.
{-# OPTIONS --safe --without-K #-}
module Kernel.Everything where

import Kernel.Assumptions.Crypto
import Kernel.Assumptions.Runtime
import Kernel.Decision
import Kernel.Observation
import Kernel.Sequence
import Kernel.PrimeLedger
import Kernel.RSA
import Kernel.Causal
import Kernel.Simplicial
import Kernel.Hamiltonian
import Kernel.Capability
import Kernel.State
import Kernel.AcceptedState
