#!/usr/bin/env bash
# SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
# Dual-licensed (intentionally): AGPL-3.0-only plus the SnapKitty Opaque License.
# (also: persist_failed fault-injection cases, BLOCKERS.md (c))
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

# ---- persist_failed (BLOCKERS.md c): REAL I/O faults against the unmodified binaries ----------------
#  consume / admin sites: a directory at authority.state.tmp (open of the temp file fails: EISDIR), removed live;
#  accept site: authority restarted under `prlimit --fsize` (SIGXFSZ ignored) so the 2nd persist of one SUBMIT fails (EFBIG).
sha() { sha256sum "$AD/authority.state" | cut -d' ' -f1; }
TMPF="$AD/authority.state.tmp"
start_limited() {
  rm -f "$SOCK"
  nice -n 19 prlimit --fsize="$1" -- sh -c 'trap "" XFSZ; exec "$@"' sh "$A" serve --dir "$AD" --sock "$SOCK" 2> >(cat >>"$LOG/authority.log") & apid=$!
  for _ in $(seq 200); do [ -S "$SOCK" ] && "$A" admin --admin-sock "$ADM" STATUS >/dev/null 2>&1 && return 0; sleep 0.05; done
  return 1
}
capid() { field cap_id < "$WD/$1"; }
recover_ok() {  # fresh capability ACCEPTed, persisted_seq == seq == $1+1 (fault already removed by caller)
  issue read rr.cap && wk sync --cap "$WD/rr.cap" >/dev/null
  issue transition rc.cap; local o; o=$(wk transition --cap "$WD/rc.cap" --payload "recovered-$1")
  echo "$o" | grep -q 'decision=ACCEPT' && [ "$(status seq)" = $(($1+1)) ] && [ "$(status persisted_seq)" = "$(status seq)" ] \
    && [ "$(head -1 "$AD/authority.state" | field seq)" = $(($1+1)) ]
}
recovered=1; pf_ok=1
issue read rp.cap && wk sync --cap "$WD/rp.cap" >/dev/null

# consume site
issue transition pc1.cap; S0=$(status seq); H0=$(sha); P0=$(status persisted_seq)
mkdir "$TMPF"
out=$(wk transition --cap "$WD/pc1.cap" --payload pf-consume); out2=$(wk transition --cap "$WD/pc1.cap" --payload pf-consume-again)
if echo "$out" | grep -q 'decision=REJECT' && [ "$(echo "$out" | field reason)" = persist_failed ] && ! echo "$out" | grep -q 'new_commit=' \
   && [ "$(echo "$out" | field head_seq)" = "$S0" ] && [ "$(status seq)" = "$S0" ] && [ "$(status persisted_seq)" = "$P0" ] && [ "$(sha)" = "$H0" ] \
   && grep "cap_id=$(capid pc1.cap) " "$AD/authority.state" | grep -q 'status=issued' && [ "$(echo "$out2" | field reason)" = replay ] \
   && grep -q 'REJECT reason=persist_failed' "$LOG/authority.log" && grep -q 'Is a directory' "$LOG/authority.log"; then
  pass persist_failed_consume_site; else fail persist_failed_consume_site "out=$out out2=$out2 seq=$(status seq)"; fi
rmdir "$TMPF"; [ "$(sha)" = "$H0" ] || { fail persist_failed_consume_site_file_unchanged "sha changed"; pf_ok=0; }
recover_ok "$S0" || { recovered=0; echo "recover consume: seq=$(status seq) persisted=$(status persisted_seq)" >&2; }

# admin site
issue transition pa1.cap; S1=$(status seq); H1=$(sha)
mkdir "$TMPF"
out=$("$A" admin --admin-sock "$ADM" REVOKE cap_id="$(capid pa1.cap)")
if [ "$(echo "$out" | field result)" = persist_failed ] && echo "$out" | grep -q 'detail=Is_a_directory' && [ "$(status seq)" = "$S1" ] && [ "$(sha)" = "$H1" ]; then
  pass persist_failed_admin_site; else fail persist_failed_admin_site "out=$out"; fi
rmdir "$TMPF"; recover_ok "$S1" || { recovered=0; echo "recover admin: seq=$(status seq)" >&2; }

# accept site: limit = current size + 152 (consume persist adds ~55 bytes, accept adds a >190-byte state line)
issue read rq.cap && wk sync --cap "$WD/rq.cap" >/dev/null; issue transition pw1.cap
S2=$(status seq); H2=$(sha); SZ=$(stat -c %s "$AD/authority.state")
stop; start_limited $((SZ+152)) || fail persist_failed_accept_site "limited authority did not start"
out=$(wk transition --cap "$WD/pw1.cap" --payload pf-accept); out2=$(wk transition --cap "$WD/pw1.cap" --payload pf-accept-again)
if echo "$out" | grep -q 'decision=REJECT' && [ "$(echo "$out" | field reason)" = persist_failed ] && ! echo "$out" | grep -q 'new_commit=' \
   && [ "$(echo "$out" | field head_seq)" = "$S2" ] && [ "$(status seq)" = "$S2" ] && [ "$(head -1 "$AD/authority.state" | field seq)" = "$S2" ] \
   && [ "$(sha)" != "$H2" ] && grep "cap_id=$(capid pw1.cap) " "$AD/authority.state" | grep -q 'status=consumed' \
   && [ "$(echo "$out2" | field reason)" = replay ] && grep -q 'File too large' "$LOG/authority.log"; then
  pass persist_failed_accept_site; else fail persist_failed_accept_site "out=$out out2=$out2 seq=$(status seq)"; fi
stop; start
out=$(wk transition --cap "$WD/pw1.cap" --payload pf-after-restart)
echo "$out" | grep -Eq 'reason=(replay|retired)' || { fail persist_failed_accept_cap_stays_consumed "$out"; pf_ok=0; }
recover_ok "$S2" || { recovered=0; echo "recover accept: seq=$(status seq)" >&2; }
[ $recovered = 1 ] && [ $pf_ok = 1 ] && pass persist_failed_recovers || fail persist_failed_recovers "recovered=$recovered pf_ok=$pf_ok"

# token list in PROTOCOL.md vs authority.rs (shell-level grep)
miss=""; for t in $(grep -o 'reject(&tag, "[a-z_]*"' "$(dirname "$0")/../src/authority.rs" | sed 's/.*"\(.*\)"/\1/' | sort -u) persist_failed; do
  grep -q "\`$t\`" "$(dirname "$0")/../PROTOCOL.md" || miss="$miss $t"; done
[ -z "$miss" ] && [ "$(grep -c '"persist_failed"' "$(dirname "$0")/../src/authority.rs")" = 3 ] && pass e2e_persist_failed_token || fail e2e_persist_failed_token "missing in PROTOCOL.md:$miss or site count != 3"
cp "$AD/authority.state" "$LOG/authority.state.final" 2>/dev/null
exit $fails
