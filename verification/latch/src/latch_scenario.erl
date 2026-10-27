%% SPDX-License-Identifier: AGPL-3.0-only
%% SCRIPTED, SYNTHETIC event batches used only to exercise the latch over JetStream.
%% These are NOT verification results of the jwst-lrd project. Revisions are labelled
%% scripted-rev-*. Each element: {Subject, EventMap}.
-module(latch_scenario).
-export([batch/2]).

sig_ev(Src, Check, Rev, Status, Seq, Id) ->
    {<<"verify.signal.", Src/binary>>,
     #{<<"id">> => Id, <<"source">> => Src, <<"check">> => Check, <<"revision">> => Rev,
       <<"status">> => Status, <<"critical">> => true, <<"seq">> => Seq,
       <<"kind">> => <<"evidence">>, <<"scripted">> => true}}.

repair(KeyFun, Id, Check, EnvelopeRev, SignedRev, Seq) ->
    Sha = binary:encode_hex(crypto:hash(sha256, [<<"scripted repair evidence ">>, Id]), lowercase),
    Sig = latch_sig:sign(KeyFun, latch_sig:repair_message(SignedRev, Check, Id, Sha)),
    {<<"verify.evidence.repair">>,
     #{<<"id">> => Id, <<"source">> => <<"repair">>, <<"check">> => Check,
       <<"revision">> => EnvelopeRev, <<"kind">> => <<"repair">>, <<"seq">> => Seq,
       <<"evidence_sha256">> => Sha, <<"sig">> => Sig, <<"scripted">> => true}}.

-define(S1, <<"scripted-rev-S1">>).
-define(S2, <<"scripted-rev-S2">>).

%% Batch 1: before the first kill -9.
batch(1, _K) ->
    [sig_ev(<<"runner">>, <<"runner.suite">>, ?S1, <<"PASS">>, 1, <<"S1-runner-pass">>),
     sig_ev(<<"agda">>, <<"agda.kernel">>, ?S1, <<"PASS">>, 1, <<"S1-agda-pass">>),
     sig_ev(<<"futhark">>, <<"futhark.diff">>, ?S1, <<"PASS">>, 1, <<"S1-futhark-pass">>),
     sig_ev(<<"ledger">>, <<"ledger.abi">>, ?S1, <<"UNAVAILABLE">>, 1, <<"S1-ledger-unavail">>),
     sig_ev(<<"hamiltonian">>, <<"hamiltonian.suite">>, ?S1, <<"PASS">>, 1, <<"S1-ham-pass-1">>)];
%% Batch 2: published while the service is DOWN.
batch(2, _K) ->
    Fail = sig_ev(<<"hamiltonian">>, <<"hamiltonian.suite">>, ?S1, <<"FAIL">>, 2, <<"S1-ham-fail">>),
    [sig_ev(<<"ledger">>, <<"ledger.abi">>, ?S1, <<"PASS">>, 2, <<"S1-ledger-pass">>),
     Fail,
     sig_ev(<<"hamiltonian">>, <<"hamiltonian.suite">>, ?S1, <<"PASS">>, 3, <<"S1-ham-pass-2">>),
     Fail,                                                           %% redelivered duplicate
     sig_ev(<<"runner">>, <<"runner.suite">>, ?S1, <<"PASS">>, 0, <<"S1-runner-stale">>),  %% stale
     sig_ev(<<"license">>, <<"license.spdx">>, ?S1, <<"PASS">>, 1, <<"S1-license-pass">>),
     sig_ev(<<"ingest">>, <<"ingest.replay">>, ?S1, <<"PASS">>, 1, <<"S1-ingest-pass">>),
     sig_ev(<<"redshift">>, <<"redshift.z_residual">>, ?S1, <<"PASS">>, 1, <<"S1-redshift-pass">>),
     sig_ev(<<"qso1">>, <<"qso1.fixture">>, ?S1, <<"PASS">>, 1, <<"S1-qso1-pass">>)];
%% Batch 3: repairs (one is crash-injected before ack), invalid status.
batch(3, K) ->
    [sig_ev(<<"qso1">>, <<"qso1.fixture">>, ?S2, <<"MAYBE">>, 2, <<"S2-qso1-invalid">>),
     corrupt_sig(repair(K, <<"S1-repair-badsig">>, <<"hamiltonian.suite">>, ?S1, ?S1, 1)),
     repair(K, <<"S1-repair-wrongrev">>, <<"hamiltonian.suite">>, ?S2, ?S2, 2),
     repair(K, <<"S1-repair-good">>, <<"hamiltonian.suite">>, ?S1, ?S1, 3),
     sig_ev(<<"hamiltonian">>, <<"hamiltonian.suite">>, ?S1, <<"PASS">>, 4, <<"S1-ham-pass-3">>)].

corrupt_sig({Subj, #{<<"sig">> := Sig} = E}) ->
    [H | T] = binary_to_list(Sig),
    Flipped = case H of $0 -> $1; _ -> $0 end,
    {Subj, E#{<<"sig">> := list_to_binary([Flipped | T])}}.
