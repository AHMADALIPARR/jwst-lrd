#!/usr/bin/env bash
# SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
# Dual-licensed (intentionally): AGPL-3.0-only plus the SnapKitty Opaque License.
# TEST-ONLY trusted-setup stand-in: generate an RSA modulus with openssl and delete the private
# key. This is NOT a trustworthy ceremony: the factors existed in this process's memory and on
# disk (tmpfs/disk, not shredded securely). Anyone who saw them can forge accumulator witnesses.
# usage: gen_modulus.sh OUT_HEX_FILE [BITS=2048]
set -euo pipefail
out="$1"; bits="${2:-2048}"
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
openssl genrsa -out "$tmp/k.pem" "$bits" 2>/dev/null
openssl rsa -in "$tmp/k.pem" -noout -modulus | sed 's/^Modulus=//' | tr 'A-F' 'a-f' > "$out"
rm -f "$tmp/k.pem"
