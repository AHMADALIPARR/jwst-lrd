{-# OPTIONS --safe --without-K #-}
-- Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
-- Dual-licensed: AGPL-3.0-or-later plus SnapKitty Opaque License.
-- SPDX-License-Identifier: AGPL-3.0-or-later AND LicenseRef-SnapKitty-Opaque
--
-- JWST-LRD Sovereign Scientific Runtime -- TASK 011: Agda verified core.
-- Root of the verified core: importing this module type-checks every core module.
-- tests/agda/run.sh checks that every agda/Core/*.agda file is imported here.

module Core.All where

import Core.Observation
import Core.Sequence
import Core.PrimeLedger
import Core.Causal
import Core.Boundary
import Core.Hamiltonian
import Core.Capability
import Core.State
import Core.Preservation
