<!-- SPDX-License-Identifier: AGPL-3.0-only. Also licensed under the SnapKitty Opaque License; see LICENSE and SNAPKITTY_OPAQUE_LICENSE.md at the repository root. -->
# t014 toolchain (pinned)

Recorded on the shared box, 2026-10-19 (America/Los_Angeles). Nothing was installed via apt.
Every tool below was already in /usr/bin.

| command | first line of output |
|---|---|
| `clang --version` | `Debian clang version 19.1.7 (3+b1)` |
| `llc --version` | `Debian LLVM version 19.1.7` |
| `llvm-config --version` | `19.1.7` |
| `llvm-as --version` | `Debian LLVM version 19.1.7` |
| `opt --version` | `Debian LLVM version 19.1.7` |

The pin is machine-readable in `llvm/toolchain.pin`. `llvm/check_toolchain.sh` compares the exact
first line of each command and prints `UNAVAILABLE toolchain_<tool> ...` on a mismatch or a missing
binary. `make -C llvm` refuses to build in that case, and `tests/llvm/run.sh` / `validation/harness.sh` print
UNAVAILABLE instead of PASS.

Other tools used (not pinned, recorded for provenance): `gfortran`, `futhark` (validation
references only), `objdump` (FMA check), `sha256sum`, GNU make, bash.
SHA-256 is implemented in `llvm/runtime/lrd_sha256.c`. libcrypto is not used.

## Flags
- runtime / abi / helpers: `clang -std=c17 -O2 -Wall -Wextra -Werror -ffp-contract=off -fno-fast-math`
- generated code: `llc -O2 --fp-contract=off -relocation-model=pic -filetype=obj`,
  linked by `clang -ffp-contract=off -fno-fast-math ... liblrdrt.a -lm`
- target: llc default `x86_64-pc-linux-gnu` (no `-mcpu`, so no FMA instructions are available)
