#!/bin/sh
# SPDX-License-Identifier: AGPL-3.0-only. Also subject to the SnapKitty Opaque License (dual license).
# Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
#
# TASK 012 tests for the Curry LRD research engine (curry/).
# Prints one line per test: PASS <name> | FAIL <name> <why> | UNAVAILABLE <name> <reason>.
# Lines starting with '#' are information (paths, sha256 of traces).
# Exit status is nonzero only if some test FAILs.
#
# Environment:
#   PAKCS              path to the pakcs binary (else PATH, else the pinned tools dir)
#   LRD_REAL_DATA_DIR  checkout holding the real t001 outputs, read-only
#                      (default /workspace/jwst-lrd-integration)
#   LRD_CURRY_KEEP     if set, keep the scratch directory with all traces
#
# Does not read or depend on curry/causal/ (HCALC Alloy's causal track).
set -u
root=$(cd "$(dirname "$0")/../.." && pwd)
cdir=$root/curry
fx=$cdir/fixtures/SYNTHETIC_lrd_obs_manifest
real=${LRD_REAL_DATA_DIR:-/workspace/jwst-lrd-integration}
out=$(mktemp -d "${TMPDIR:-/tmp}/lrd-curry-tests.XXXXXX")
fails=0
pass() { echo "PASS $1"; }
fail() { echo "FAIL $1 $2"; fails=$((fails + 1)); }
unav() { echo "UNAVAILABLE $1 $2"; }
cleanup() { [ -n "${LRD_CURRY_KEEP:-}" ] || rm -rf "$out"; }
trap cleanup EXIT

# status and grade of hypothesis $2 in the summary of search trace $1
hstat() {
  awk -v h="$2" '
    $0 ~ "^ *\\(name " h "\\)$" { f = 1; next }
    f && /\(status / { gsub(/[()]/, ""); st = $2 }
    f && /\(grade /  { gsub(/[()]/, ""); print st, $2; exit }' "$1"
}

# ---- toolchain -------------------------------------------------------------
want=$(sed -n 's/^pakcs_numeric_version=//p' "$cdir/CURRY_VERSION")
wantswi=$(sed -n 's/^swipl_version=//p' "$cdir/CURRY_VERSION")
pakcs=${PAKCS:-}
if [ -z "$pakcs" ]; then
  if command -v pakcs >/dev/null 2>&1; then pakcs=$(command -v pakcs)
  else pakcs=/workspace/jwst-lrd-tools/curry/pakcs-3.10.0/bin/pakcs; fi
fi
names="build kv2rec-reproducible lrdrec-roundtrip lrdrec-rejects-malformed synthetic-labelled hypothesis-search bounded-search contradiction-detection compare-explanations no-confirmed-status graph-export trace-reproducible real-t001-ingest real-t001-queries real-t001-trace-reproducible"
if [ ! -x "$pakcs" ]; then
  unav curry-version "pakcs not found (looked at \$PAKCS, PATH, $pakcs); run curry/install-pakcs.sh"
  for n in $names; do unav "$n" "no Curry compiler"; done
  exit 0
fi
have=$("$pakcs" --numeric-version 2>/dev/null)
haveswi=$(swipl --version 2>/dev/null | awk '{print $3}')
if [ "$have" = "$want" ] && [ "$haveswi" = "$wantswi" ]; then
  pass curry-version
  echo "# pakcs $have ($pakcs), SWI-Prolog $haveswi"
else
  fail curry-version "pakcs=$have (pinned $want) swipl=$haveswi (pinned $wantswi)"
fi

# ---- build -----------------------------------------------------------------
if PAKCS=$pakcs "$cdir/build.sh" >"$out/build.out" 2>&1 && [ -x "$cdir/build/lrd-engine" ]; then
  pass build
else
  fail build "see curry/build/pakcs-build.log"
  for n in $names; do [ "$n" = build ] || unav "$n" "engine did not build"; done
  exit 1
fi
E=$cdir/build/lrd-engine
run() { "$E" "$@" </dev/null; }

# ---- LRD-REC-v1 ------------------------------------------------------------
if run kv2rec "$fx.kv" >"$out/fx.lrdrec" 2>"$out/kv2rec.err" && cmp -s "$out/fx.lrdrec" "$fx.lrdrec"; then
  pass kv2rec-reproducible
else
  fail kv2rec-reproducible "kv2rec output differs from committed $fx.lrdrec"
fi
F=$fx.lrdrec
run validate "$F" >"$out/validate.sx" 2>&1
if grep -q '(canonical-roundtrip ok)' "$out/validate.sx"; then pass lrdrec-roundtrip
else fail lrdrec-roundtrip "$(tr '\n' ' ' <"$out/validate.sx")"; fi

bad=0
printf 'LRD-REC-v1\n4:kind1:x2:id1:y\n' >"$out/unsorted.rec"     # keys out of order
printf 'LRD-REC-v1\n2:id1:a2:id1:b\n' >"$out/dup.rec"            # duplicate key
printf 'LRD-REC-v1\n0:1:x2:id1:a\n' >"$out/emptykey.rec"         # empty key (v1.1)
printf 'LRD-REC-v1\n2:id01:a\n' >"$out/leadzero.rec"             # non-canonical length
printf 'LRD-REC-v1\n2:id5:a\n' >"$out/short.rec"                 # truncated value
for b in unsorted dup emptykey leadzero short; do
  if run validate "$out/$b.rec" >/dev/null 2>&1; then bad="$bad $b"; fi
done
if [ "$bad" = 0 ]; then pass lrdrec-rejects-malformed
else fail lrdrec-rejects-malformed "accepted:${bad#0}"; fi

case "$(basename "$F")" in
  *SYNTHETIC*) n=$(grep -c '^LRD-REC-v1$' "$F")
               s=$(sed -n 's/^ *(synthetic-records \([0-9]*\))$/\1/p' "$out/validate.sx")
               if [ "$n" = "$s" ] && head -c 2000 "$F" | grep -q 'SYNTHETIC FIXTURE - NOT REAL DATA'; then
                 pass synthetic-labelled
               else fail synthetic-labelled "records=$n synthetic-records=$s or header missing"; fi ;;
  *) fail synthetic-labelled "fixture name lacks SYNTHETIC" ;;
esac

# ---- queries on the SYNTHETIC fixture -----------------------------------------
for o in A B C D; do run search "$F" "OBS-SYN-$o" 4 2 >"$out/search-$o.sx" 2>"$out/search-$o.err"; done
a=$(hstat "$out/search-A.sx" bh-broad-line-region)
b=$(hstat "$out/search-B.sx" bh-broad-line-region)
c=$(hstat "$out/search-C.sx" bh-broad-line-region)
cs=$(hstat "$out/search-C.sx" stellar-compact-dusty-starburst)
if [ "$a" = "derivable-under-assumptions robust" ] && [ "$b" = "derivable-under-assumptions marginal" ] \
   && [ "$c" = "not-derivable n/a" ] && [ "$cs" = "derivable-under-assumptions robust" ] \
   && grep -q '(rule R-BLR-01)' "$out/search-A.sx"; then
  pass hypothesis-search
else
  fail hypothesis-search "A:[$a] B:[$b] C:[$c] C-starburst:[$cs]"
fi

for d in 2 3; do run search "$F" OBS-SYN-A "$d" 2 >"$out/bound-$d.sx" 2>&1; done
b2=$(hstat "$out/bound-2.sx" composite-reddened-agn-plus-host-uv)
b3=$(hstat "$out/bound-3.sx" composite-reddened-agn-plus-host-uv)
if [ "$b2" = "undecided-at-bound n/a" ] && [ "$b3" = "derivable-under-assumptions robust" ] \
   && grep -q '(id OBL-BOUND:OBS-SYN-A:composite-reddened-agn-plus-host-uv)' "$out/bound-2.sx" \
   && grep -q '(cut-at-bound' "$out/bound-2.sx" \
   && ! grep -q 'OBL-BOUND' "$out/bound-3.sx"; then
  pass bounded-search
else
  fail bounded-search "depth2:[$b2] depth3:[$b3]"
fi

run contradictions "$F" 4 2 >"$out/contradictions.sx" 2>&1
ck() { grep -c "$1" "$out/contradictions.sx"; }
if [ "$(ck '(kind assumption-attacked)')" -ge 1 ] && [ "$(ck '(kind exclusive-both-derivable)')" -ge 1 ] \
   && [ "$(ck '(kind data-inconsistent)')" -ge 1 ] \
   && grep -q '(records FEAT-SYN-D-HALPHA-R1 FEAT-SYN-D-HALPHA-R2)' "$out/contradictions.sx" \
   && grep -q '(counter-rule CE-XRAY-01)' "$out/contradictions.sx" \
   && ! grep -q '(obs OBS-SYN-B)' "$out/contradictions.sx"; then
  pass contradiction-detection
else
  fail contradiction-detection "attacked=$(ck assumption-attacked) exclusive=$(ck exclusive-both) data=$(ck data-inconsistent)"
fi

run compare "$F" FEAT-SYN-A-HALPHA 4 2 >"$out/compare.sx" 2>&1
nder=$(grep -c '(status derivable-under-assumptions)' "$out/compare.sx")
if grep -q '(candidates 7)' "$out/compare.sx" && [ "$nder" -ge 2 ] \
   && grep -q '(kind black-hole-model)' "$out/compare.sx" && grep -q '(kind stellar-model)' "$out/compare.sx" \
   && grep -q 'finding CE-BROADLINE-01 FEAT-SYN-A-HALPHA' "$out/compare.sx" \
   && grep -q '(exclusive bh-reddened-agn-continuum stellar-compact-dusty-starburst' "$out/compare.sx"; then
  pass compare-explanations
else
  fail compare-explanations "derivable=$nder"
fi

run graph "$F" 4 2 >"$out/graph-1.sx" 2>&1
G=$out/graph-1.sx
gok=1; why=""
for k in observation spectral-feature stellar-model black-hole-model dust-model composite-model provenance proof-obligation counterevidence; do
  grep -q "^ *(kind $k)$" "$G" || { gok=0; why="$why missing-node-kind:$k"; }
done
sed -n '/^    (nodes/,/^    (edges/p' "$G" | sed -n 's/^ *(node (id \([^)]*\)).*/\1/p; s/^ *(id \([^)]*\))$/\1/p' | sort -u >"$out/ids"
grep -o '(from [^)]*)\|(to [^)]*)' "$G" | sed 's/^(from //; s/^(to //; s/)$//' | sort -u >"$out/ends"
dang=$(comm -13 "$out/ids" "$out/ends" | head -3 | tr '\n' ' ')
[ -z "$dang" ] || { gok=0; why="$why dangling-edge-endpoints:$dang"; }
nh=$(grep -c '(epistemic derivable-is-not-confirmation)' "$G")
[ "$nh" = 36 ] || { gok=0; why="$why hyp-nodes-with-epistemic-tag=$nh"; }
grep -q '^  (lrd-graph$' "$G" || { gok=0; why="$why no-lrd-graph"; }
if [ $gok = 1 ]; then pass graph-export; else fail graph-export "$why"; fi

odd=$(grep -ho "(status [^)]*)" "$out"/*.sx | sort -u | grep -v -x "(status \(derivable-under-assumptions\|undecided-at-bound\|not-derivable\))")
if grep -il confirmed "$out"/*.sx >/dev/null 2>&1 || [ -n "$odd" ]; then
  fail no-confirmed-status "an output uses confirmed or an unknown status: $odd"
else
  pass no-confirmed-status
fi

# reproducibility: second run of every query, byte-compared
rok=1
run search "$F" OBS-SYN-A 4 2 >"$out/search-A.2.sx" 2>&1;            cmp -s "$out/search-A.sx" "$out/search-A.2.sx" || rok=0
run compare "$F" FEAT-SYN-A-HALPHA 4 2 >"$out/compare.2.sx" 2>&1;    cmp -s "$out/compare.sx" "$out/compare.2.sx" || rok=0
run contradictions "$F" 4 2 >"$out/contradictions.2.sx" 2>&1;       cmp -s "$out/contradictions.sx" "$out/contradictions.2.sx" || rok=0
run graph "$F" 4 2 >"$out/graph-2.sx" 2>&1;                          cmp -s "$out/graph-1.sx" "$out/graph-2.sx" || rok=0
if [ $rok = 1 ]; then pass trace-reproducible; else fail trace-reproducible "second run differs"; fi
for t in search-A compare contradictions graph-1; do echo "# sha256 $(sha256sum "$out/$t.sx" | cut -d' ' -f1) synthetic-$t"; done

# ---- real t001 data (read-only) ----------------------------------------------
cur=""
[ -r "$real/fixtures/ingest/CURRENT" ] && cur=$(tr -d ' \n' <"$real/fixtures/ingest/CURRENT")
man=$real/fixtures/ingest/$cur/manifest.rec
ref=$real/fixtures/reference/$cur/reference.rec
if [ -z "$cur" ]; then
  why="missing or unreadable $real/fixtures/ingest/CURRENT"
  for n in real-t001-ingest real-t001-queries real-t001-trace-reproducible; do unav "$n" "$why"; done
elif [ ! -r "$man" ] || [ ! -r "$ref" ]; then
  why="missing or unreadable:"; [ -r "$man" ] || why="$why $man"; [ -r "$ref" ] || why="$why $ref"
  for n in real-t001-ingest real-t001-queries real-t001-trace-reproducible; do unav "$n" "$why"; done
else
  echo "# real data: $real (git $(git -C "$real" rev-parse --short HEAD 2>/dev/null || echo n/a)) CURRENT=$cur"
  echo "# sha256 $(sha256sum "$man" | cut -d' ' -f1) manifest.rec"
  echo "# sha256 $(sha256sum "$ref" | cut -d' ' -f1) reference.rec"
  R=$out/real.lrdrec
  if run ingest-t001 "$man" "$ref" >"$R" 2>"$out/real-ingest.err" \
     && run validate "$R" >"$out/real-validate.sx" 2>&1 \
     && grep -q '(canonical-roundtrip ok)' "$out/real-validate.sx" \
     && grep -q '(synthetic-records 0)' "$out/real-validate.sx" \
     && grep -q "raw.sha256" "$R"; then
    pass real-t001-ingest
    o=OBS-T001-$(printf %s "$cur" | cut -c1-12)
    fh=FEAT-T001-$(printf %s "$cur" | cut -c1-12)-BROAD-Halpha
    run search "$R" "$o" 4 2 >"$out/real-search.sx" 2>&1
    run compare "$R" "$fh" 4 2 >"$out/real-compare.sx" 2>&1
    run graph "$R" 4 2 >"$out/real-graph.sx" 2>&1
    if grep -q '(synthetic no)' "$out/real-search.sx" && grep -q "(obs $o)" "$out/real-search.sx" \
       && [ "$(grep -c '^    (hypothesis$' "$out/real-search.sx")" = 9 ] \
       && grep -q "(feature-record $fh)" "$out/real-compare.sx" \
       && grep -q '^  (lrd-graph$' "$out/real-graph.sx" \
       && ! grep -qi confirmed "$out/real-search.sx" "$out/real-compare.sx" "$out/real-graph.sx"; then
      pass real-t001-queries
    else
      fail real-t001-queries "see $out/real-*.sx"
    fi
    run search "$R" "$o" 4 2 >"$out/real-search.2.sx" 2>&1
    run compare "$R" "$fh" 4 2 >"$out/real-compare.2.sx" 2>&1
    run ingest-t001 "$man" "$ref" >"$out/real.2.lrdrec" 2>&1
    if cmp -s "$R" "$out/real.2.lrdrec" && cmp -s "$out/real-search.sx" "$out/real-search.2.sx" \
       && cmp -s "$out/real-compare.sx" "$out/real-compare.2.sx"; then
      pass real-t001-trace-reproducible
    else
      fail real-t001-trace-reproducible "second run differs"
    fi
    for t in real.lrdrec real-search.sx real-compare.sx real-graph.sx; do echo "# sha256 $(sha256sum "$out/$t" | cut -d' ' -f1) $t"; done
  else
    fail real-t001-ingest "$(head -c 300 "$out/real-ingest.err" | tr '\n' ' ')"
    unav real-t001-queries "ingest failed"; unav real-t001-trace-reproducible "ingest failed"
  fi
fi

[ -z "${LRD_CURRY_KEEP:-}" ] || echo "# traces kept in $out"
[ "$fails" = 0 ]
