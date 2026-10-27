<!-- SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque -->
Project-local `AGDA_DIR`. `tests/agda/run.sh` exports `AGDA_DIR=<repo>/agda/agda-dir`, so the
user's `~/.config/agda` (or `~/.agda`) is ignored and the only registered library is the pinned
agda-stdlib 2.1 at `/usr/share/agda-stdlib/standard-library.agda-lib` (see `agda/VERSIONS`).
