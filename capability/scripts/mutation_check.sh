#!/usr/bin/env bash
# SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
# Dual-licensed (intentionally): AGPL-3.0-only plus the SnapKitty Opaque License.
# Mutation check: copies the crate to a temp dir (sources here are never modified), disables one
# authority check at a time, and requires the adversarial suite to FAIL. Prints PASS/FAIL lines.
set -uo pipefail
SRC="$(cd "$(dirname "$0")/.." && pwd)"
tmp="$(mktemp -d /tmp/lrdcap-mut.XXXXXX)"; trap 'rm -rf "$tmp"' EXIT
fails=0
mut() { # name perl-substitution
  local name="$1" expr="$2" d="$tmp/$1"
  mkdir -p "$d"; cp -r "$SRC/Cargo.toml" "$SRC/PROTOCOL.md" "$SRC/build.rs" "$SRC/src" "$SRC/tests" "$SRC/abi" "$SRC/fixtures" "$d/"
  cp "$d/src/authority.rs" "$d/orig.rs"
  perl -0pi -e "$expr" "$d/src/authority.rs"
  if cmp -s "$d/src/authority.rs" "$d/orig.rs"; then echo "FAIL mutation_$name not_applied"; fails=$((fails+1)); return; fi
  if CARGO_TARGET_DIR="$tmp/target" nice -n 19 cargo test --release --offline --manifest-path "$d/Cargo.toml" --test adversarial >"$d/out.txt" 2>&1; then
    echo "FAIL mutation_$name survived (suite still green)"; fails=$((fails+1))
  else
    echo "PASS mutation_$name detected ($(grep -c 'FAILED$' "$d/out.txt" | tr -d ' ') failing tests: $(grep 'FAILED$' "$d/out.txt" | sed 's/^test //; s/ \.\.\. FAILED//' | tr '\n' ' '))"
  fi
}
mut no_bad_prev_check   's/if prev != head \{/if false \&\& prev != head {/'
mut no_consumption      's/self\.retire\(idx, CapStatus::Consumed\);/\/\/ mutated/'
mut mac_always_ok       's/if !cap\.mac_ok\(&self\.key\) \{/if false {/'
mut no_witness_check    's/if !verify_witness\(&self\.params, DOMAIN_STATE, &self\.acc_states\.value, prev\.as_bytes\(\), &w\) \{/if false {/'
mut no_stale_seq_check  's/if seq <= head_seq \{/if false {/'
mut no_scope_check      's/if cap\.scope != Scope::Transition \{\n            return self\.reject\(&tag, "bad_scope"/if false {\n            return self.reject(&tag, "bad_scope"/'
mut no_expiry_check     's/if now\(\) > cap\.expiry \{/if false {/'
mut no_cap_binding      's/if cap\.seq != seq \|\| cap\.prev != prev \{/if false {/'
exit $fails
