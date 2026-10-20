#!/bin/sh
# SPDX-License-Identifier: AGPL-3.0-only. Also subject to the SnapKitty Opaque License (dual license).
# Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
#
# Fetch, verify and build the pinned PAKCS (see CURRY_VERSION) outside the
# repository. Needs: curl, sha256sum, tar, make, swipl 9.2.9.
#   usage: curry/install-pakcs.sh [PREFIX]   (default /workspace/jwst-lrd-tools/curry)
set -eu
here=$(cd "$(dirname "$0")" && pwd)
pin() { sed -n "s/^$1=//p" "$here/CURRY_VERSION"; }
prefix=${1:-/workspace/jwst-lrd-tools/curry}
url=$(pin pakcs_tarball); sum=$(pin pakcs_tarball_sha256); ver=$(pin pakcs_numeric_version)
mkdir -p "$prefix"; cd "$prefix"
tgz=$(basename "$url")
[ -f "$tgz" ] || curl -fL --retry 3 -o "$tgz" "$url"
echo "$sum  $tgz" | sha256sum -c -
[ -d "pakcs-$ver" ] || tar xzf "$tgz"
cd "pakcs-$ver"
make > "$prefix/pakcs-make.log" 2>&1
bin/pakcs --numeric-version
