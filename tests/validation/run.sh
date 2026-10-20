#!/bin/bash
# SPDX-License-Identifier: AGPL-3.0-only
# Also licensed under the SnapKitty Opaque License; see LICENSE and
# SNAPKITTY_OPAQUE_LICENSE.md at the repository root.
# tests/validation/run.sh - runs the cross-language differential harness.
exec bash "$(cd "$(dirname "$0")/../.." && pwd)/validation/harness.sh" "$@"
