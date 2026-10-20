#!/bin/sh
# CompCert sweep over every C file in the repo (excluding build/).
# CompCert 3.14 (built from source in ~/workspace/tools-build).
# PASS = the file compiles under CompCert's verified C subset, i.e. the
# compilation is semantics-preserving by CompCert's correctness theorem.
# Shims (theorems/compcert/shim/) replace glibc headers that use language
# features outside CompCert's subset (long double in mathcalls) and add
# the POSIX ssize_t typedef; they declare interfaces only.
CCOMP=${CCOMP:-$HOME/workspace/tools-build/CompCert-3.14/ccomp}
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
SHIM=$ROOT/theorems/compcert/shim
cd "$ROOT" || exit 1
pass=0; fail=0
for f in $(find . -name '*.c' -not -path './build/*' | sort); do
  inc="-Iabi -Iledger/abi -Iledger/include -Iair/include -Ihamiltonian/include"
  case $f in
    ./air/*) inc="$inc -Iair/include";;
    ./hamiltonian/*) inc="$inc -Ihamiltonian/include";;
  esac
  if $CCOMP -c -I$SHIM $inc -include $SHIM/ssize_shim.h -o /tmp/ccsweep.o "$f" 2>/tmp/ccsweep.err; then
    echo "PASS $f"; pass=$((pass+1))
  else
    echo "FAIL $f :: $(grep -m1 'error' /tmp/ccsweep.err | cut -c1-90)"; fail=$((fail+1))
  fi
done
echo "SUMMARY pass=$pass fail=$fail"
