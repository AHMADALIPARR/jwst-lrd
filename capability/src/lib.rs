// SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
// Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
// Dual-licensed (intentionally): GNU AGPL-3.0-only plus the SnapKitty Opaque License.
//! TASK 010 - cryptographic linear addressing and proof-gated state transitions.
//! Zero external crates. See SECURITY.md (threat model) and STATUS.md (what ran).
pub mod abi;
pub mod accumulator;
pub mod authority;
pub mod bigint;
pub mod cap;
pub mod hmac;
pub mod prime;
pub mod proto;
pub mod rec;
pub mod rng;
pub mod sha256;
