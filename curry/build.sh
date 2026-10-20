#!/bin/sh
# SPDX-License-Identifier: AGPL-3.0-only. Also subject to the SnapKitty Opaque License (dual license).
# Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
#
# Build curry/build/lrd-engine from curry/src with the pinned PAKCS.
# Touches only curry/src/.curry (compiler cache) and curry/build/.
#   PAKCS=/path/to/bin/pakcs curry/build.sh
set -eu
here=$(cd "$(dirname "$0")" && pwd)
pakcs=${PAKCS:-}
if [ -z "$pakcs" ]; then
  if command -v pakcs >/dev/null 2>&1; then pakcs=$(command -v pakcs)
  else pakcs=/workspace/jwst-lrd-tools/curry/pakcs-3.10.0/bin/pakcs; fi
fi
[ -x "$pakcs" ] || { echo "build.sh: pakcs not found ($pakcs)" >&2; exit 3; }
want=$(sed -n 's/^pakcs_numeric_version=//p' "$here/CURRY_VERSION")
have=$("$pakcs" --numeric-version)
[ "$have" = "$want" ] || { echo "build.sh: pakcs $have, pinned $want" >&2; exit 3; }
mkdir -p "$here/build"
cd "$here/src"
rm -f LrdEngine
"$pakcs" --nocypm :set -time :load LrdEngine :save :quit </dev/null > "$here/build/pakcs-build.log" 2>&1
[ -x LrdEngine ] || { cat "$here/build/pakcs-build.log" >&2; exit 1; }
mv LrdEngine "$here/build/lrd-engine"
