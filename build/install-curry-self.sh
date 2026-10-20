#!/bin/sh
# SPDX-License-Identifier: AGPL-3.0-only
# Also subject to SNAPKITTY_OPAQUE_LICENSE.md (dual license, see repository root).
#
# Installs PAKCS (Curry, binary distribution on SWI-Prolog) and builds the Self VM
# (32-bit i386, no X11) from https://github.com/russellallen/self into $TOOLS.
# Replaces the earlier worker's build/tools-install-extra.sh (which failed on an
# apt lock and on a shallow Self clone without tags). Run under nohup; logs in build/logs.
set -eu
ROOT=$(cd "$(dirname "$0")/.." && pwd)
TOOLS=${LRD_TOOLS_DIR:-$ROOT/build/tools}
LOGS=$ROOT/build/logs
PAKCS_VER=3.10.0
PAKCS_TGZ=pakcs-$PAKCS_VER-amd64-Linux.tar.gz
PAKCS_URL=https://www.curry-lang.org/pakcs/download/$PAKCS_TGZ
mkdir -p "$TOOLS" "$LOGS"
sudo dpkg --add-architecture i386
sudo apt-get update -qq
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y swi-prolog-nox cmake gcc-multilib g++-multilib \
  libncurses-dev:i386 libncurses-dev git
if [ ! -x "$TOOLS/pakcs-$PAKCS_VER/bin/pakcs" ]; then
  cd "$TOOLS"
  [ -f "$PAKCS_TGZ" ] || curl -fL --retry 5 -C - -o "$PAKCS_TGZ" "$PAKCS_URL"
  rm -rf "pakcs-$PAKCS_VER" && tar xzf "$PAKCS_TGZ" && cd "pakcs-$PAKCS_VER"
  make > "$LOGS/pakcs-make.log" 2>&1
fi
if [ ! -x "$TOOLS/self-src/build32/vm/Self" ]; then
  cd "$TOOLS"
  [ -d self-src ] || git clone https://github.com/russellallen/self.git self-src
  cd self-src && git fetch --tags --unshallow -q 2>/dev/null || git fetch --tags -q
  rm -rf build32 && mkdir build32 && cd build32
  cmake -DSELF_X11=OFF -DCMAKE_BUILD_TYPE=Release .. > "$LOGS/self-cmake.log" 2>&1
  make -j6 > "$LOGS/self-make.log" 2>&1
fi
echo "install-curry-self: done"
