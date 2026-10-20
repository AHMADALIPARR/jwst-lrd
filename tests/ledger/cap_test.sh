#!/bin/sh
# Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
# Dual-licensed: AGPL-3.0-or-later plus SnapKitty Opaque License.
# SPDX-License-Identifier: AGPL-3.0-or-later AND LicenseRef-SnapKitty-Opaque
#
# TASK 010 capability-addressing tests. Called by tests/ledger/run.sh with the build dir as $1.
# Prints PASS/FAIL lines; extra detail goes to stderr (run.sh appends it to ledger/out/run.log).
# Every "rejected" test asserts that the verifier prints decision REJECT with the stated
# reason AND exits 1.
set -u
OUT=$1
V="$OUT/lrd-capverifier"
W="$OUT/lrd-capworker"
REC="$OUT/lrd-rec"
T="$OUT/cap_t"
rm -rf "$T"; mkdir -p "$T"
VD="$T/verifier"     # authority-private directory (mode 0700)
WD="$T/worker"       # worker directory
PUB="$VD/authority.pub"
FAILED=0
pass() { echo "PASS $1"; }
fail() { echo "FAIL $1 $2"; FAILED=1; }
info() { echo "INFO $*" >&2; }
P1=$(printf 'payload-1' | openssl dgst -sha256 -r | cut -c1-64)
P2=$(printf 'payload-2' | openssl dgst -sha256 -r | cut -c1-64)
P3=$(printf 'payload-3' | openssl dgst -sha256 -r | cut -c1-64)
fresh_nonce() { openssl rand -hex 16; }

# expect_reject REASON OUTFILE -- run "$@" after the two args; assert REJECT + reason + exit 1
expect_reject() {
  reason=$1; shift
  "$@" > "$T/last.out" 2>>"$T/last.err"; rc=$?
  if [ $rc -eq 1 ] && grep -qx "8:decision6:REJECT" "$T/last.out" && grep -qx "6:reason${#reason}:$reason" "$T/last.out"; then
    return 0
  fi
  info "expected REJECT $reason, got rc=$rc: $(tr '\n' '|' < "$T/last.out")"
  return 1
}
expect_accept() {
  "$@" > "$T/last.out" 2>>"$T/last.err"; rc=$?
  [ $rc -eq 0 ] && grep -qx "8:decision6:ACCEPT" "$T/last.out" && grep -q "^10:new_commit64:" "$T/last.out" && return 0
  info "expected ACCEPT, got rc=$rc: $(tr '\n' '|' < "$T/last.out")"
  return 1
}
# flip one hex char of the field line whose prefix is $2 (prefix length $3) in file $1 -> $4
flip_field() {
  awk -v pre="$2" -v pl="$3" '{ if (substr($0,1,pl)==pre) { c=substr($0,pl+1,1); n=(c=="0")?"1":"0"; $0=substr($0,1,pl) n substr($0,pl+2) } print }' "$1" > "$4"
}
commit_of_cap() { sed -n 's/^10:new_commit64://p' "$1"; }

# ------------------------------------------------------------------ setup
"$V" init "$VD" >/dev/null 2>>"$T/last.err" && "$W" init "$WD" >/dev/null 2>>"$T/last.err" || { fail cap_setup init_failed; exit 1; }

t=cap_verifier_private_file_modes
m_dir=$(stat -c %a "$VD"); m_key=$(stat -c %a "$VD/authority.key"); m_log=$(stat -c %a "$VD/state.log"); m_pub=$(stat -c %a "$PUB")
info "$t dir=$m_dir key=$m_key log=$m_log pub=$m_pub owner=$(stat -c %U "$VD/state.log") worker_uid=$(id -un)"
[ "$m_dir" = 700 ] && [ "$m_key" = 600 ] && [ "$m_log" = 600 ] && [ "$m_pub" = 644 ] && pass $t || fail $t "modes dir=$m_dir key=$m_key log=$m_log pub=$m_pub"

t=cap_worker_binary_has_no_signing_code
if command -v nm >/dev/null 2>&1; then
  wsig=$(nm -D --undefined-only "$W" | grep -E 'DigestSign|PrivateKey|keygen' | tr '\n' ' ')
  vsig=$(nm -D --undefined-only "$V" | grep -cE 'DigestSign|PrivateKey|keygen')
  info "$t worker_signing_imports='$wsig' verifier_signing_imports=$vsig"
  [ -z "$wsig" ] && [ "$vsig" -gt 0 ] && pass $t || fail $t "worker imports: $wsig (verifier count $vsig)"
else
  echo "UNAVAILABLE $t nm (binutils) not installed"
fi

# ------------------------------------------------------------------ valid chain of 3
t=cap_valid_chain_accepted
ok=1
i=1
for P in $P1 $P2 $P3; do
  "$W" propose "$WD" capA "$P" "$T/p$i" 2>>"$T/last.err" || ok=0
  expect_accept "$V" submit "$VD" "$T/p$i" "$T/c$i" || ok=0
  "$W" accept "$WD" "$PUB" "$T/c$i" >/dev/null 2>>"$T/last.err" || ok=0
  i=$((i+1))
done
vhead=$("$V" head "$VD"); whead="$(sed -n 's/^3:seq1://p' "$WD/state") $(sed -n 's/^11:head_commit64://p' "$WD/state")"
info "$t verifier_head='$vhead' worker_head='$whead'"
[ $ok -eq 1 ] && [ "$vhead" = "$whead" ] && [ "$vhead" = "3 $(commit_of_cap "$T/c3")" ] && pass $t || fail $t "chain ok=$ok vhead='$vhead' whead='$whead'"

t=cap_independent_witness_verifier_accepts_valid
ok=1; for i in 1 2 3; do "$W" verify-cap "$PUB" "$T/c$i" >/dev/null 2>>"$T/last.err" || ok=0; done
[ $ok -eq 1 ] && pass $t || fail $t "independent verify-cap rejected a valid capability"

t=cap_check_current_accepts_head
expect_accept "$V" check "$VD" "$T/c3" --current && pass $t || fail $t "head capability not accepted"

# ------------------------------------------------------------------ forgery / alteration
t=cap_forged_signature_rejected
flip_field "$T/c3" "3:sig128:" 9 "$T/forged_sig.cap"
if expect_reject bad_sig "$V" check "$VD" "$T/forged_sig.cap" && ! "$W" verify-cap "$PUB" "$T/forged_sig.cap" >/dev/null 2>&1; then pass $t; else fail $t "forged signature accepted"; fi

t=cap_altered_commitment_rejected
flip_field "$T/c3" "10:new_commit64:" 16 "$T/altered.cap"
if expect_reject bad_sig "$V" check "$VD" "$T/altered.cap" && ! "$W" verify-cap "$PUB" "$T/altered.cap" >/dev/null 2>&1; then pass $t; else fail $t "altered commitment accepted"; fi

t=cap_foreign_authority_rejected
"$V" init "$T/rogue" >/dev/null 2>&1; "$W" init "$T/w2" >/dev/null 2>&1
"$W" propose "$T/w2" capA "$P1" "$T/rp1" 2>/dev/null; "$V" submit "$T/rogue" "$T/rp1" "$T/rc1" >/dev/null 2>&1
if expect_reject bad_sig "$V" check "$VD" "$T/rc1" && ! "$W" verify-cap "$PUB" "$T/rc1" >/dev/null 2>&1; then pass $t; else fail $t "capability from another authority accepted"; fi

# ------------------------------------------------------------------ replay / rollback / staleness
t=cap_replayed_proposal_rejected
ok=1; for i in 1 2 3; do expect_reject replay_nonce "$V" submit "$VD" "$T/p$i" "$T/replay.cap" || ok=0; done
[ $ok -eq 1 ] && [ ! -e "$T/replay.cap" ] && pass $t || fail $t "replayed proposal accepted or capability issued"

C1=$(commit_of_cap "$T/c1"); C2=$(commit_of_cap "$T/c2"); C3=$(commit_of_cap "$T/c3")
t=cap_stale_seq_rejected
"$REC" make cap_id=capA kind=capability nonce=$(fresh_nonce) payload_sha256=$P1 prev_commit=$C1 seq=2 > "$T/stale.prop"
expect_reject stale_seq "$V" submit "$VD" "$T/stale.prop" "$T/x.cap" && pass $t || fail $t "old seq with fresh nonce accepted"

t=cap_rollback_bad_prev_rejected
"$REC" make cap_id=capA kind=capability nonce=$(fresh_nonce) payload_sha256=$P1 prev_commit=$C2 seq=4 > "$T/rb.prop"
expect_reject bad_prev "$V" submit "$VD" "$T/rb.prop" "$T/x.cap" && pass $t || fail $t "next seq built on older commit accepted"

t=cap_seq_gap_rejected
"$REC" make cap_id=capA kind=capability nonce=$(fresh_nonce) payload_sha256=$P1 prev_commit=$C3 seq=5 > "$T/gap.prop"
expect_reject seq_gap "$V" submit "$VD" "$T/gap.prop" "$T/x.cap" && pass $t || fail $t "seq gap accepted"

t=cap_stale_capability_not_current
ok=1
for i in 1 2; do
  expect_reject stale_seq "$V" check "$VD" "$T/c$i" --current || ok=0
  expect_accept "$V" check "$VD" "$T/c$i" || ok=0      # still a valid HISTORICAL capability
done
[ $ok -eq 1 ] && pass $t || fail $t "old capability accepted as current or rejected as historical"

t=cap_historical_reads
ok=1
"$V" state-at "$VD" 0 > "$T/s0" 2>>"$T/last.err" && grep -qx "12:state_commit64:0000000000000000000000000000000000000000000000000000000000000000" "$T/s0" || ok=0
for i in 1 2 3; do
  "$V" state-at "$VD" $i > "$T/s$i" 2>>"$T/last.err" || ok=0
  grep -qx "12:state_commit64:$(commit_of_cap "$T/c$i")" "$T/s$i" || ok=0
  # independently recompute the LRD-STATE-v1 state commitment from the returned fields
  prev=$(sed -n 's/^6:commit64://p' "$T/s$i"); pay=$(sed -n 's/^14:payload_sha25664://p' "$T/s$i")
  "$REC" make commit=$prev kind=capability payload_sha256=$pay seq=$i > "$T/st$i.rec"
  [ "$("$REC" commit "$T/st$i.rec")" = "$(commit_of_cap "$T/c$i")" ] || ok=0
done
expect_reject unknown_seq "$V" state-at "$VD" 4 || ok=0
[ $ok -eq 1 ] && pass $t || fail $t "historical state mismatch"

t=cap_noncanonical_proposal_rejected
printf 'LRD-REC-v1\n3:seq1:4\n6:cap_id4:capA\n' > "$T/nc.prop"
expect_reject bad_record "$V" submit "$VD" "$T/nc.prop" "$T/x.cap" && pass $t || fail $t "non-canonical proposal accepted"

t=cap_wrong_kind_rejected
"$REC" make cap_id=capA kind=observation nonce=$(fresh_nonce) payload_sha256=$P1 prev_commit=$C3 seq=4 > "$T/wk.prop"
expect_reject bad_kind "$V" submit "$VD" "$T/wk.prop" "$T/x.cap" && pass $t || fail $t "wrong kind accepted"

t=cap_reject_decision_has_no_new_commit
expect_reject replay_nonce "$V" submit "$VD" "$T/p1" "$T/x.cap"
if ! grep -q "new_commit" "$T/last.out" && [ "$("$V" head "$VD")" = "3 $C3" ]; then pass $t; else fail $t "REJECT carried new_commit or changed state"; fi

# ------------------------------------------------------------------ retirement
t=cap_retired_rejected
ok=1
"$W" propose "$WD" capB "$P1" "$T/p4" 2>>"$T/last.err"
expect_accept "$V" submit "$VD" "$T/p4" "$T/c4" || ok=0
"$W" accept "$WD" "$PUB" "$T/c4" >/dev/null 2>&1 || ok=0
"$V" retire "$VD" capB >/dev/null 2>>"$T/last.err" || ok=0
expect_reject retired "$V" check "$VD" "$T/c4" --current || ok=0
expect_reject retired "$V" check "$VD" "$T/c4" || ok=0
"$W" propose "$WD" capB "$P2" "$T/p5" 2>>"$T/last.err"
expect_reject retired "$V" submit "$VD" "$T/p5" "$T/x.cap" || ok=0
"$W" propose "$WD" capA "$P2" "$T/p5a" 2>>"$T/last.err"
expect_accept "$V" submit "$VD" "$T/p5a" "$T/c5" || ok=0    # other capabilities still live
"$W" accept "$WD" "$PUB" "$T/c5" >/dev/null 2>&1 || ok=0
[ $ok -eq 1 ] && pass $t || fail $t "retired capability accepted"

# ------------------------------------------------------------------ adversarial: tamper worker state + replay
t=cap_adversarial_worker_state_tamper_and_replay
ok=1
LOGSUM=$(openssl dgst -sha256 -r "$VD/state.log" | cut -c1-64); HEAD0=$("$V" head "$VD")
# (a) privileged test process rolls the worker's local state back to seq 1
"$REC" make head_commit=$C1 seq=1 > "$WD/state"
"$W" propose "$WD" capA "$P3" "$T/adv1.prop" 2>>"$T/last.err"
expect_reject stale_seq "$V" submit "$VD" "$T/adv1.prop" "$T/x.cap" || ok=0
# (b) worker state forged to the right seq but a fabricated commit
"$REC" make head_commit=$(openssl rand -hex 32) seq=5 > "$WD/state"
"$W" propose "$WD" capA "$P3" "$T/adv2.prop" 2>>"$T/last.err"
expect_reject bad_prev "$V" submit "$VD" "$T/adv2.prop" "$T/x.cap" || ok=0
# (c) worker state pushed ahead
"$REC" make head_commit=$C3 seq=9 > "$WD/state"
"$W" propose "$WD" capA "$P3" "$T/adv3.prop" 2>>"$T/last.err"
expect_reject seq_gap "$V" submit "$VD" "$T/adv3.prop" "$T/x.cap" || ok=0
# (d) worker state file garbage: worker itself refuses
printf 'garbage' > "$WD/state"
"$W" propose "$WD" capA "$P3" "$T/adv4.prop" 2>/dev/null && ok=0
# (e) replay every old capability as current and every old proposal
for i in 1 2 3; do expect_reject stale_seq "$V" check "$VD" "$T/c$i" --current || ok=0; done
for i in 1 2 3 4 5a; do
  case $i in 4) r=retired;; *) r=replay_nonce;; esac
  expect_reject $r "$V" submit "$VD" "$T/p$i" "$T/x.cap" || ok=0
done
LOGSUM2=$(openssl dgst -sha256 -r "$VD/state.log" | cut -c1-64); HEAD1=$("$V" head "$VD")
info "$t verifier head before='$HEAD0' after='$HEAD1' log_sha256 before=$LOGSUM after=$LOGSUM2"
[ "$LOGSUM" = "$LOGSUM2" ] && [ "$HEAD0" = "$HEAD1" ] || ok=0
[ $ok -eq 1 ] && pass $t || fail $t "tampered worker state or replay accepted / verifier state changed"

# ------------------------------------------------------------------ adversarial: tamper verifier log
t=cap_adversarial_verifier_log_tamper_detected
ok=1
cp "$VD/state.log" "$T/log.bak"
# (a) edit one character inside entry 1 (nonce)
awk 'NR==1 { i=index($0,"nonce=")+6; c=substr($0,i,1); n=(c=="0")?"1":"0"; $0=substr($0,1,i-1) n substr($0,i+1) } { print }' "$T/log.bak" > "$VD/state.log"
"$V" head "$VD" >/dev/null 2>>"$T/last.err"; [ $? -eq 3 ] || ok=0
# (b) delete a middle entry
sed '2d' "$T/log.bak" > "$VD/state.log"
"$V" head "$VD" >/dev/null 2>>"$T/last.err"; [ $? -eq 3 ] || ok=0
# (c) append a forged entry (no authority key)
cp "$T/log.bak" "$VD/state.log"
echo "A seq=6 cap_id=capA nonce=$(fresh_nonce) payload_sha256=$P1 prev_commit=$(commit_of_cap "$T/c5") new_commit=$C1 chain=$C1 sig=$(openssl rand -hex 64)" >> "$VD/state.log"
"$V" head "$VD" >/dev/null 2>>"$T/last.err"; [ $? -eq 3 ] || ok=0
# (d) append a semantically valid entry with a correctly recomputed (unkeyed) chain hash but
#     no authority signature: only the Ed25519 log signature can catch this one
cp "$T/log.bak" "$VD/state.log"
C5=$(commit_of_cap "$T/c5")
"$REC" make commit=$C5 kind=capability payload_sha256=$P1 seq=6 > "$T/forge6.rec"
NC6=$("$REC" commit "$T/forge6.rec")
BODY="A seq=6 cap_id=capA nonce=$(fresh_nonce) payload_sha256=$P1 prev_commit=$C5 new_commit=$NC6"
PCH=$(tail -n 1 "$T/log.bak" | sed 's/.* chain=\([0-9a-f]*\) sig=.*/\1/')
CH=$( { printf 'LRD-CAPLOG-v1\000%s %s' "$PCH" "$BODY"; } | openssl dgst -sha256 -r | cut -c1-64)
echo "$BODY chain=$CH sig=$(openssl rand -hex 64)" >> "$VD/state.log"
"$V" head "$VD" >/dev/null 2>>"$T/last.err"; [ $? -eq 3 ] || ok=0
# a corrupt log also blocks submissions (no state is constructed)
"$W" init "$T/w3" >/dev/null 2>&1; "$W" propose "$T/w3" capA "$P1" "$T/adv5.prop" 2>/dev/null
"$V" submit "$VD" "$T/adv5.prop" "$T/x5.cap" >/dev/null 2>>"$T/last.err"; [ $? -eq 3 ] && [ ! -e "$T/x5.cap" ] || ok=0
cp "$T/log.bak" "$VD/state.log"
[ "$("$V" head "$VD")" = "$HEAD1" ] || ok=0
[ $ok -eq 1 ] && pass $t || fail $t "verifier operated on a tampered log"

# Known limitation, recorded as INFO (not a PASS): truncating the log to a valid prefix.
head -n 2 "$T/log.bak" > "$VD/state.log"
trunc=$("$V" head "$VD" 2>&1); trc=$?
info "limitation: log truncated to 2 valid entries -> verifier exit=$trc head='$trunc' (truncation to a valid prefix is NOT detectable without an external monotonic anchor)"
cp "$T/log.bak" "$VD/state.log"

exit $FAILED
