#!/usr/bin/env bash
# SPDX-License-Identifier: AGPL-3.0-only
# JetStream demo: durable consumer, explicit acks, kill -9 / restart, cold replay.
# All scripted events are SYNTHETIC (revisions scripted-rev-*); the Octave events are real inputs.
set -uo pipefail
cd "$(dirname "$0")/.."
PORT=${NATS_PORT:-14222}; export NATS_PORT=$PORT
BIN=./bin/nats-server
[ -x "$BIN" ] || { echo "UNAVAILABLE: nats-server binary missing"; exit 3; }
./scripts/build.sh >/dev/null
rm -rf run/js run/*.state run/*.state.tmp run/*.log run/nats.log
mkdir -p run
[ -f run/hmac.key ] || { umask 077; openssl rand -hex 32 > run/hmac.key; }
chmod 600 run/hmac.key
KEY=run/hmac.key

./scripts/run_octave.sh > run/octave.log 2>&1 || { echo "octave step failed"; cat run/octave.log; exit 4; }

$BIN -js -a 127.0.0.1 -p $PORT -sd "$PWD/run/js" > run/nats.log 2>&1 &
NPID=$!
trap 'kill $NPID 2>/dev/null; kill -9 ${SPID:-0} 2>/dev/null' EXIT
for i in $(seq 1 50); do (echo > /dev/tcp/127.0.0.1/$PORT) 2>/dev/null && break; sleep 0.1; done
echo "nats-server $($BIN --version) pid=$NPID port=$PORT jetstream on"

idle_count() { grep -c "IDLE" "$1" 2>/dev/null || true; }
wait_idle() { # logfile, previous idle count
  for i in $(seq 1 200); do [ "$(idle_count "$1")" -gt "$2" ] && return 0; sleep 0.2; done
  echo "TIMEOUT waiting for IDLE in $1"; return 1; }
start_service() { # logfile consumer statefile [extra env]
  ./scripts/lc.sh serve $KEY "$3" "$2" >> "$1" 2>&1 &
  SPID=$!; }
hash_of() { grep "IDLE" "$1" | tail -1 | sed 's/.*state_hash=//'; }

./scripts/lc.sh setup

echo; echo "######## PHASE 1: publish scripted batch 1, start service (durable consumer 'latch')"
./scripts/lc.sh pub-batch 1 $KEY
: > run/svc.log
start_service run/svc.log latch run/latch.state
wait_idle run/svc.log 0
echo "--- service log so far:"; cat run/svc.log
H1=$(hash_of run/svc.log)
echo; echo ">>> kill -9 service (pid $SPID)"; kill -9 $SPID; wait $SPID 2>/dev/null
echo "state file persisted: $(stat -c %s run/latch.state) bytes"

echo; echo "######## PHASE 2: publish batch 2 + Octave evidence while the service is DOWN"
./scripts/lc.sh pub-batch 2 $KEY
./scripts/lc.sh pub-file run/octave_events.ndjson
echo ">>> restart service: durable consumer must resume (unacked messages only), state from snapshot"
N0=$(wc -l < run/svc.log)
start_service run/svc.log latch run/latch.state
wait_idle run/svc.log 1
tail -n +$((N0+1)) run/svc.log
H2=$(hash_of run/svc.log)
echo; echo ">>> kill -9 service (pid $SPID)"; kill -9 $SPID; wait $SPID 2>/dev/null

echo; echo "######## PHASE 3: batch 3 (repairs, invalid status). Fault injection: service halts after"
echo "######## persisting state but BEFORE acking event S1-repair-good (LATCH_CRASH_AFTER_EVENT)"
./scripts/lc.sh pub-batch 3 $KEY
N0=$(wc -l < run/svc.log)
LATCH_CRASH_AFTER_EVENT=S1-repair-good ./scripts/lc.sh serve $KEY run/latch.state latch >> run/svc.log 2>&1 &
SPID=$!; wait $SPID; echo ">>> service exited with status $? (137 = injected halt)"
tail -n +$((N0+1)) run/svc.log
echo; echo ">>> restart service WITHOUT fault: unacked repair is redelivered after ack_wait (3s)"
N0=$(wc -l < run/svc.log)
I0=$(idle_count run/svc.log)
start_service run/svc.log latch run/latch.state
for i in $(seq 1 100); do tail -n +$((N0+1)) run/svc.log | grep -q "S1-repair-good -> DUPLICATE" && break; sleep 0.2; done
wait_idle run/svc.log $((I0+1))
tail -n +$((N0+1)) run/svc.log
H3=$(hash_of run/svc.log)
kill -9 $SPID; wait $SPID 2>/dev/null

echo; echo "######## COLD REPLAY: new empty state, new durable consumer 'latch-replay' (deliver all), no publishing"
./scripts/lc.sh serve $KEY run/replay.state latch-replay --no-publish --exit-when-idle > run/replay.log 2>&1
grep -v "^\[latch\] js_seq" run/replay.log
HR=$(hash_of run/replay.log)
echo; echo "######## OFFLINE PURE FOLD over the whole VERIFY stream (STREAM.MSG.GET, no consumer)"
./scripts/lc.sh fold-stream $KEY | tee run/fold.log
HF=$(grep -o 'state_hash=[0-9a-f]*' run/fold.log | head -1 | cut -d= -f2)

echo; echo "######## HASH COMPARISON"
echo "after phase1 (pre-kill)            $H1"
echo "after phase2 (restart #1)          $H2"
echo "after phase3 (crash+redelivery)    $H3"
echo "cold replay from empty state       $HR"
echo "offline fold of stream             $HF"
[ "$H3" = "$HR" ] && [ "$H3" = "$HF" ] && echo "RESULT: replay state IDENTICAL to live service state" || echo "RESULT: MISMATCH"

echo; echo "######## OUTPUT STREAM VERIFYOUT (decisions published by the Erlang latch)"
./scripts/lc.sh dump-out | tee run/out_dump.log | grep -E "verify.latch" 
echo "audit messages: $(grep -c 'verify.audit.decision' run/out_dump.log)  latch messages: $(grep -c 'verify.latch' run/out_dump.log)"
echo; echo "######## KEY LEAK CHECK"
KEYTXT=$(cat $KEY)
if grep -rqF -- "$KEYTXT" run/*.log run/*.ndjson 2>/dev/null; then echo "KEY FOUND IN OUTPUT (BAD)"; else echo "key not present in any log/output file"; fi
