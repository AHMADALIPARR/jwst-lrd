#!/usr/bin/env bash
# SPDX-License-Identifier: AGPL-3.0-or-later OR LicenseRef-SnapKitty-Opaque
# Dual-licensed (intentionally): AGPL-3.0-or-later plus the SnapKitty Opaque License.
# Cross-checks the vendored bigint modexp and hash-to-prime against openssl 3.
# Prints PASS/FAIL lines. usage: openssl_crosscheck.sh PATH_TO_lrd-authority
set -uo pipefail
A="$1"; tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
hexof() { od -An -v -tx1 "$1" | tr -d ' \n'; }
strip0() { sed 's/^0*//'; }
fails=0
for i in 1 2 3; do
  openssl genrsa -out "$tmp/k.pem" 2048 2>/dev/null
  openssl rsa -in "$tmp/k.pem" -pubout -out "$tmp/pub.pem" 2>/dev/null
  N=$(openssl rsa -in "$tmp/k.pem" -noout -modulus | sed 's/^Modulus=//' | tr A-F a-f)
  D=$(openssl rsa -in "$tmp/k.pem" -noout -text 2>/dev/null | awk '/^privateExponent:/{f=1;next} /^prime1:/{f=0} f' | tr -d ' :\n')
  { printf '\x00'; head -c 255 /dev/urandom; } > "$tmp/m.bin"
  M=$(hexof "$tmp/m.bin" | strip0)
  openssl pkeyutl -encrypt -pubin -inkey "$tmp/pub.pem" -pkeyopt rsa_padding_mode:none -in "$tmp/m.bin" -out "$tmp/c.bin"
  C_ossl=$(hexof "$tmp/c.bin" | strip0)
  C_ours=$("$A" selftest-modexp "$M" 10001 "$N")
  if [ "$C_ossl" = "$C_ours" ]; then echo "PASS openssl_modexp_public_e65537_$i"; else echo "FAIL openssl_modexp_public_e65537_$i mismatch"; fails=$((fails+1)); fi
  M_ours=$("$A" selftest-modexp "$C_ours" "$D" "$N")
  openssl pkeyutl -decrypt -inkey "$tmp/k.pem" -pkeyopt rsa_padding_mode:none -in "$tmp/c.bin" -out "$tmp/d.bin"
  M_ossl=$(hexof "$tmp/d.bin" | strip0)
  if [ "$M_ours" = "$M" ] && [ "$M_ossl" = "$M" ]; then echo "PASS openssl_modexp_private_2048bit_exponent_$i"; else echo "FAIL openssl_modexp_private_2048bit_exponent_$i mismatch"; fails=$((fails+1)); fi
done
for d in alpha beta gamma delta epsilon; do
  P=$("$A" selftest-h2p LRD-ACC-STATE-v1 "$d" | cut -d' ' -f1)
  if openssl prime -hex "$P" | grep -q "is prime"; then echo "PASS openssl_prime_confirms_h2p_$d"; else echo "FAIL openssl_prime_confirms_h2p_$d $P"; fails=$((fails+1)); fi
done
exit $fails
