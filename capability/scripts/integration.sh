#!/usr/bin/env bash
# SPDX-License-Identifier: AGPL-3.0-or-later OR LicenseRef-SnapKitty-Opaque
# Dual-licensed (intentionally): AGPL-3.0-or-later plus the SnapKitty Opaque License.
# End-to-end bash scenario with two real processes: lrd-authority serve (own directory) and
# lrd-worker (untrusted). Includes the ACCEPTANCE test: worker memory + state file corrupted with a
# valid-format forged commitment; the separately running authority refuses it.
# usage: integration.sh BIN_DIR LOG_DIR      Prints PASS/FAIL lines; exit = number of FAILs.
set -uo pipefail
BIN="$1"; LOG="$2"; mkdir -p "$LOG"
A="$BIN/lrd-authority"; W="$BIN/lrd-worker"
root="$(mktemp -d /tmp/lrdcap-int.XXXXXX)"
AD="$root/authority"; WD="$root/worker"; SOCK="$root/w.sock"; ADM="$AD/admin.sock"
mkdir -p "$WD"
fails=0; apid=""
cleanup() { [ -n "$apid" ] && kill "$apid" 2>/dev/null; wait 2>/dev/null; rm -rf "$root"; }
trap cleanup EXIT
pass() { echo "PASS $1"; }
fail() { echo "FAIL $1 $2"; fails=$((fails+1)); }
start() {
  rm -f "$SOCK"
  nice -n 19 "$A" serve --dir "$AD" --sock "$SOCK" 2>>"$LOG/authority.log" & apid=$!
  for _ in $(seq 200); do [ -S "$SOCK" ] && "$A" admin --admin-sock "$ADM" STATUS >/dev/null 2>&1 && return 0; sleep 0.05; done
  return 1
}
stop() { kill "$apid" 2>/dev/null; wait "$apid" 2>/dev/null; apid=""; }
issue() { "$A" admin --admin-sock "$ADM" ISSUE scope="$1" ttl=60 > "$WD/$2"; }
wk() { "$W" --sock "$SOCK" --state "$WD/worker.state" --modulus "$WD/modulus.hex" "$@" 2>>"$LOG/worker.log"; }
field() { tr ' ' '\n' | sed -n "s/^$1=//p"; }
status() { "$A" admin --admin-sock "$ADM" STATUS | field "$1"; }

: > "$LOG/authority.log"; : > "$LOG/worker.log"
bash "$(dirname "$0")/gen_modulus.sh" "$WD/modulus.hex" 2048
"$A" init --dir "$AD" --modulus "$WD/modulus.hex" > "$LOG/init.out" 2>&1 || fail init "$(cat "$LOG/init.out")"
start || { fail authority_start "did not come up"; exit 1; }
echo "authority pid=$apid worker_sees_dir=$WD (authority dir $AD is never passed to the worker)" >> "$LOG/worker.log"

# positive control
issue read r0.cap && wk sync --cap "$WD/r0.cap" >/dev/null
ok=1
for i in 1 2; do issue transition t$i.cap; out=$(wk transition --cap "$WD/t$i.cap" --payload "honest-$i") || ok=0; done
[ $ok = 1 ] && [ "$(status seq)" = 2 ] && pass e2e_positive_control_honest_transitions_accepted || fail e2e_positive_control_honest_transitions_accepted "seq=$(status seq)"
HEAD_BEFORE=$(status head); SEQ_BEFORE=$(status seq)

# ACCEPTANCE: corrupt worker memory + state file, authority must refuse
echo "=== ACCEPTANCE corrupt-memory attack ===" >> "$LOG/worker.log"
issue transition t3.cap
out=$(wk transition --cap "$WD/t3.cap" --payload forged --attack corrupt-memory); rc=$?
echo "$out" > "$LOG/acceptance_decision.rec"
FORGED=$(field head_commit < "$WD/worker.state")
if [ $rc -ne 0 ] && echo "$out" | grep -q 'decision=REJECT' && echo "$out" | grep -q 'reason=bad_prev' \
   && ! echo "$out" | grep -q new_commit= && [ "$FORGED" != "$HEAD_BEFORE" ] \
   && [ "$(status head)" = "$HEAD_BEFORE" ] && [ "$(status seq)" = "$SEQ_BEFORE" ] \
   && grep -q 'REJECT reason=bad_prev' "$LOG/authority.log"; then
  pass e2e_ACCEPTANCE_corrupted_worker_state_refused_by_authority
else fail e2e_ACCEPTANCE_corrupted_worker_state_refused_by_authority "rc=$rc out=$out"; fi

# state file forged by an external editor (sed), valid format
issue read r1.cap && wk sync --cap "$WD/r1.cap" >/dev/null
sed -i "s/head_commit=[0-9a-f]*/head_commit=$(printf 'deadbeef%.0s' 1 2 3 4 5 6 7 8)/" "$WD/worker.state"
issue transition t4.cap
out=$(wk transition --cap "$WD/t4.cap" --payload forged2); echo "$out" | grep -q 'reason=bad_prev' && pass e2e_sed_forged_state_file_refused || fail e2e_sed_forged_state_file_refused "$out"

# replay after restart
issue read r2.cap && wk sync --cap "$WD/r2.cap" >/dev/null
issue transition t5.cap; wk transition --cap "$WD/t5.cap" --payload honest-3 >/dev/null
cp "$WD/worker.last_proposal" "$WD/replay.line"
stop; start
[ "$(status seq)" = 3 ] && pass e2e_counter_persisted_across_restart || fail e2e_counter_persisted_across_restart "seq=$(status seq)"
out=$(wk raw --file "$WD/replay.line"); echo "$out" | grep -q 'reason=replay' && pass e2e_replay_after_restart_rejected || fail e2e_replay_after_restart_rejected "$out"

# historical read cannot transition
issue historical_read h1.cap
wk history --cap "$WD/h1.cap" --seq 1 >/dev/null && grep -q 'local_witness_check=true' "$LOG/worker.log" && pass e2e_historical_read_works_with_witness || fail e2e_historical_read_works_with_witness ""
out=$(wk transition --cap "$WD/h1.cap" --payload x); echo "$out" | grep -q 'reason=bad_scope' && pass e2e_historical_read_cannot_transition || fail e2e_historical_read_cannot_transition "$out"

# rollback, forged MAC, bad witness
issue transition t6.cap; out=$(wk transition --cap "$WD/t6.cap" --payload x --attack rollback-seq); echo "$out" | grep -q 'reason=stale_seq' && pass e2e_rollback_rejected || fail e2e_rollback_rejected "$out"
issue transition t7.cap; out=$(wk transition --cap "$WD/t7.cap" --payload x --attack forge-mac); echo "$out" | grep -q 'reason=bad_mac' && pass e2e_forged_mac_rejected || fail e2e_forged_mac_rejected "$out"
issue transition t8.cap; out=$(wk transition --cap "$WD/t8.cap" --payload x --attack bad-witness); echo "$out" | grep -q 'reason=bad_witness' && pass e2e_bad_witness_rejected || fail e2e_bad_witness_rejected "$out"
[ "$(status seq)" = 3 ] && pass e2e_no_state_created_by_any_rejection || fail e2e_no_state_created_by_any_rejection "seq=$(status seq)"

# honest progress still possible
issue transition t9.cap; wk transition --cap "$WD/t9.cap" --payload honest-4 >/dev/null && [ "$(status seq)" = 4 ] && pass e2e_positive_control_after_attacks || fail e2e_positive_control_after_attacks "seq=$(status seq)"
cp "$AD/authority.state" "$LOG/authority.state.final" 2>/dev/null
exit $fails
