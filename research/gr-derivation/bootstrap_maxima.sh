#!/usr/bin/env bash
# SPDX-License-Identifier: AGPL-3.0-only
# Optional, user-space (no root) install of Debian's Maxima 5.47 (GCL build) into $HOME/tools/maxroot.
# Used on the box where Maxima was not on PATH. Needs network access to deb.debian.org via apt-get download.
set -euo pipefail
R="${MAXROOT:-$HOME/tools/maxroot}"
T="$(mktemp -d)"
cd "$T"
apt-get download maxima maxima-share
mkdir -p "$R"
for d in ./*.deb; do dpkg -x "$d" "$R"; done
echo "installed to $R ; run with MAXIMA_PREFIX=$R/usr $R/usr/bin/maxima"
