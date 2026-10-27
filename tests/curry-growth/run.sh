#!/bin/sh
# SPDX-License-Identifier: AGPL-3.0-only
# Also subject to SNAPKITTY_OPAQUE_LICENSE.md (dual license, see repository root).
#
# Curry growth-history search tests (Mission QSO1-DCBH-001 role 08, t024-curry-growth).
# Prints PASS <name> | FAIL <name> <why> | UNAVAILABLE <name> <reason> (research/CONTRACTS.md).
# Exits nonzero only if a FAIL was printed. POSIX sh + Curry only.
#
# Every PASS is the result of a check executed in this run. The Curry program
# prints "RESULT PASS|FAIL|UNAVAILABLE <name> ..." lines from its own checks; they
# are relayed here verbatim with the prefix "curry_growth.".
#
# Needs a working Curry system (PAKCS). If none works every Curry check prints UNAVAILABLE.
# Runtime: several minutes (PAKCS is slow; the independent runs execute in parallel).
# LRD_CG_EVIDENCE=1 additionally copies the raw reports into tests/curry-growth/evidence/.
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
cd "$ROOT" || exit 2
OUT=${LRD_CG_OUT:-$ROOT/build/out/curry-growth}
mkdir -p "$OUT" || exit 2
MOD=curry/growth-search/GrowthSearch.curry
CSV=$ROOT/fixtures/growth/feasible_grid.csv
fails=0
pass() { echo "PASS $1"; }
fail() { echo "FAIL $1 $2"; fails=$((fails + 1)); }
unav() { echo "UNAVAILABLE $1 $2"; }

# ---- 0. Curry system probe (a candidate must run `--numeric-version`) -------------------
PAKCS=
for c in "${LRD_PAKCS:-}" "$(command -v pakcs 2>/dev/null)" \
         "$ROOT/build/tools/pakcs-3.10.0/bin/pakcs" \
         /workspace/jwst-lrd/build/tools/pakcs-3.10.0/bin/pakcs; do
  [ -n "$c" ] && [ -x "$c" ] || continue
  if "$c" --numeric-version >/dev/null 2>&1 &&
     "$c" -q :eval "1+1" :quit 2>/dev/null | grep -q '^2$'; then PAKCS=$c; break; fi
done

# ---- 1. Evidence: the committed solver reproduces the committed fixtures -----------------
SW=$ROOT/build/out/bin/lrd_growth_sweep
if [ -x "$SW" ]; then
  if "$SW" sweep "$OUT/g.csv" "$OUT/g.rec" >"$OUT/sweep.log" 2>&1; then
    cmp -s "$OUT/g.csv" "$CSV" && pass cg.solver_reproduces_csv \
      || fail cg.solver_reproduces_csv "solver output differs from fixtures/growth/feasible_grid.csv"
    cmp -s "$OUT/g.rec" "$ROOT/fixtures/growth/feasible_grid.rec" && pass cg.solver_reproduces_rec \
      || fail cg.solver_reproduces_rec "solver output differs from fixtures/growth/feasible_grid.rec"
  else
    fail cg.solver_runs "lrd_growth_sweep exited nonzero (see $OUT/sweep.log)"
  fi
else
  unav cg.solver_reproduces_csv "build/out/bin/lrd_growth_sweep not built; the CSV is used as committed, not re-derived"
fi
if [ -f "$CSV" ]; then
  n=$(wc -l < "$CSV" | tr -d ' ')
  [ "$n" = 1201 ] && pass cg.csv_1200_rows_plus_header || fail cg.csv_1200_rows_plus_header "lines=$n"
else
  fail cg.csv_present "fixtures/growth/feasible_grid.csv missing"
fi

# ---- 2. Claims about missing evidence are checked against the repo ------------------------
# The report states that these roles produced no output. That claim must be true on this tree.
stale=
for b in t022-growth-hamiltonian; do
  if git for-each-ref --format='%(refname)' | grep -q "/$b\$\|^refs/heads/$b\$"; then
    stale="$stale $b(exists)"
  fi
done
for b in t018-dynmass t021-dcbh; do
  ref=$(git for-each-ref --format='%(refname)' | grep "/$b\$" | head -1)
  if [ -n "$ref" ] && git rev-parse --verify -q origin/main >/dev/null 2>&1; then
    k=$(git rev-list --count "origin/main..$ref" 2>/dev/null)
    [ "$k" = 0 ] || stale="$stale $b(+$k commits)"
  fi
done
if [ -z "$stale" ]; then pass cg.missing_evidence_claims_match_repo
else fail cg.missing_evidence_claims_match_repo "report says these have no output, but:$stale"; fi

# ---- 3. Repo hygiene of this module --------------------------------------------------------
base=$(git merge-base HEAD origin/main 2>/dev/null)
if [ -n "$base" ]; then
  changed=$( { git diff --name-only "$base"; git ls-files --others --exclude-standard; } | sort -u)
  bad=$(echo "$changed" | grep -v '^curry/growth-search/' | grep -v '^tests/curry-growth/' | grep -v '^$')
  [ -z "$bad" ] && pass cg.scope_only_own_dirs || fail cg.scope_only_own_dirs "touched: $(echo $bad)"
  echo "$changed" | grep -q '^curry/causal/' && fail cg.curry_causal_untouched "curry/causal changed" \
    || pass cg.curry_causal_untouched
else
  unav cg.scope_only_own_dirs "no origin/main ref to diff against"
fi
if grep -rn --exclude=run.sh "or-later" curry/growth-search tests/curry-growth >/dev/null 2>&1; then
  fail cg.licence_wording "a forbidden licence suffix appears in the module (licence is AGPL-3.0-only)"
else pass cg.licence_wording; fi
badlang=$(find curry/growth-search tests/curry-growth \( -name '*.py' -o -name '*.ts' -o -name '*.js' -o -name '*.mjs' \) 2>/dev/null)
[ -z "$badlang" ] && pass cg.no_python_ts_js || fail cg.no_python_ts_js "$badlang"

# ---- 4. Curry search (needs a Curry system) -----------------------------------------------
if [ -z "$PAKCS" ]; then
  for k in search_exhaustive report_deterministic contradiction_detector_synthetic bounded_run; do
    unav "curry_growth.$k" "no working Curry system (PAKCS --numeric-version probe failed); nothing was run"
  done
  [ "$fails" = 0 ]; exit $?
fi
echo "# curry system: $PAKCS ($("$PAKCS" --numeric-version 2>/dev/null))" >&2

# synthetic negative control: real rows with two deliberately corrupted fields
SYN=$OUT/SYNTHETIC_models_and_monotone.csv
awk 'BEGIN{FS=OFS=","}
     NR==1{print "# SYNTHETIC negative-control fixture: real rows with two deliberately corrupted min-seed fields"; print; next}
     NR==4{$10="9.99999999E+009"} NR==40{$9="1.00000000E-009"} {print}' "$CSV" > "$SYN"

# compile once (serial) so the parallel runs do not race on the .curry cache
"$PAKCS" -q :load "$MOD" :quit >"$OUT/compile.log" 2>&1 \
  || { fail curry_growth.compile "see $OUT/compile.log"; exit 1; }

run() { # name expression
  "$PAKCS" -q :load "$MOD" :eval "$2" :quit >"$OUT/$1.txt" 2>&1
  echo "$?" > "$OUT/$1.rc"
}
run reportA "mainAt \"$CSV\" 100000" &
run reportB "mainAt \"$CSV\" 100000" &
run bounded "mainAt \"$CSV\" 25" &
run synthetic "mainSynthetic \"$SYN\"" &
run rejected "mainRejected \"$CSV\"" &
wait

relay() { # file
  grep '^RESULT ' "$1" | sed 's/^RESULT //' | while IFS= read -r l; do
    st=${l%% *}; rest=${l#* }; nm=${rest%% *}; why=${rest#"$nm"}
    case "$st" in
      PASS) echo "PASS curry_growth.$nm" ;;
      FAIL) echo "FAIL curry_growth.$nm$why" ;;
      UNAVAILABLE) echo "UNAVAILABLE curry_growth.$nm$why" ;;
    esac
  done
}

if grep -q '^GROWTH_SEARCH_DONE$' "$OUT/reportA.txt"; then
  relay "$OUT/reportA.txt" > "$OUT/relay_A.txt"
  cat "$OUT/relay_A.txt"
  fails=$((fails + $(grep -c '^FAIL' "$OUT/relay_A.txt")))
  grep -q '^exhaustive=yes\|exhaustive=yes' "$OUT/reportA.txt" \
    && pass curry_growth.search_exhaustive \
    || fail curry_growth.search_exhaustive "main report is not exhaustive"
  # missing-evidence ledger -> UNAVAILABLE lines
  grep '^UNAVAILABLE_FAMILY aset=AFid' "$OUT/reportA.txt" | while IFS= read -r l; do
    fam=${l#*family=}; fam=${fam%% *}
    echo "UNAVAILABLE curry_growth.family.$fam ${l#*| }"
  done
  grep '^UNAVAILABLE_EVIDENCE ' "$OUT/reportA.txt" | while IFS= read -r l; do
    k=${l#UNAVAILABLE_EVIDENCE }; k=${k%% *}
    echo "UNAVAILABLE curry_growth.$k ${l#*| }"
  done
else
  fail curry_growth.search_exhaustive "report A did not finish (rc=$(cat "$OUT/reportA.rc")); see $OUT/reportA.txt"
fi

# determinism: two independent runs must be byte-identical
if grep -q '^GROWTH_SEARCH_DONE$' "$OUT/reportB.txt" && cmp -s "$OUT/reportA.txt" "$OUT/reportB.txt"; then
  pass curry_growth.report_deterministic
else
  fail curry_growth.report_deterministic "two runs of the same search differ (or run B failed)"
fi

# synthetic negative control: the contradiction detector must fire
if grep -q '^RESULT PASS contradiction_detector_fires_on_synthetic' "$OUT/synthetic.txt"; then
  pass curry_growth.contradiction_detector_synthetic
else
  fail curry_growth.contradiction_detector_synthetic "detector did not fire on the SYNTHETIC fixture; see $OUT/synthetic.txt"
fi

# bounded run: must flag itself non-exhaustive
if grep -q '^BOUND_REACHED' "$OUT/bounded.txt" && grep -q 'exhaustive=NO' "$OUT/bounded.txt" \
   && grep -q '^GROWTH_SEARCH_DONE$' "$OUT/bounded.txt"; then
  pass curry_growth.bounded_run
else
  fail curry_growth.bounded_run "bound-25 run did not report BOUND_REACHED / exhaustive=NO"
fi

# every rejection in the full dump carries a reason
if grep -q '^REJECTED_COUNT ' "$OUT/rejected.txt"; then
  n=$(grep -c ' | .*cannot reach M_target' "$OUT/rejected.txt")
  t=$(sed -n 's/^REJECTED_COUNT //p' "$OUT/rejected.txt")
  [ "$n" = "$t" ] && [ "$t" -gt 0 ] && pass curry_growth.every_rejection_has_reason_full_dump \
    || fail curry_growth.every_rejection_has_reason_full_dump "reasons=$n rejected=$t"
else
  fail curry_growth.every_rejection_has_reason_full_dump "rejected dump did not finish"
fi

if [ "${LRD_CG_EVIDENCE:-0}" = 1 ]; then
  E=$ROOT/tests/curry-growth/evidence
  mkdir -p "$E"
  cp "$OUT/reportA.txt" "$E/report_exhaustive.txt"
  cp "$OUT/bounded.txt" "$E/report_bound25.txt"
  cp "$OUT/synthetic.txt" "$E/synthetic_detector.txt"
  cp "$OUT/rejected.txt" "$E/rejected_all.txt"
fi

[ "$fails" = 0 ]
