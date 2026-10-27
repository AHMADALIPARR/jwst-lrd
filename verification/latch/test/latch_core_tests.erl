%% SPDX-License-Identifier: AGPL-3.0-only
%% Unit tests for latch_core. Usable two ways:
%%   eunit:test(latch_core_tests)            -- standard eunit
%%   latch_test_runner:run()                 -- same cases, PASS/FAIL/UNAVAILABLE counts
%% A test that throws {unavailable, Why} is counted UNAVAILABLE by the runner.
-module(latch_core_tests).
-include_lib("eunit/include/eunit.hrl").
-export([tests/0]).

-define(REQ, [<<"runner.suite">>, <<"agda.kernel">>]).
-define(R1, <<"rev-1111">>).
-define(R2, <<"rev-2222">>).

key() -> latch_sig:key_from_bytes(<<"unit-test-key-0123456789abcdef">>).
other_key() -> latch_sig:key_from_bytes(<<"a-different-key-0123456789abcd">>).
env() -> #{key => key(), required => ?REQ}.

ev(Id, Check, Rev, Status, Stream, Seq) -> ev(Id, Check, Rev, Status, Stream, Seq, true).
ev(Id, Check, Rev, Status, Stream, Seq, Crit) ->
    #{<<"id">> => Id, <<"check">> => Check, <<"revision">> => Rev,
      <<"status">> => Status, <<"stream">> => Stream, <<"seq">> => Seq,
      <<"critical">> => Crit}.

repair(Id, Check, EnvelopeRev, SignedRev, Stream, Seq, KeyFun) ->
    Sha = <<"0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef">>,
    Sig = latch_sig:sign(KeyFun, latch_sig:repair_message(SignedRev, Check, Id, Sha)),
    #{<<"id">> => Id, <<"check">> => Check, <<"revision">> => EnvelopeRev,
      <<"kind">> => <<"repair">>, <<"stream">> => Stream, <<"seq">> => Seq,
      <<"evidence_sha256">> => Sha, <<"sig">> => Sig}.

fold(Events) -> fold(env(), latch_core:new(), Events, []).
fold(_Env, S, [], Acc) -> {S, lists:reverse(Acc)};
fold(Env, S, [E | T], Acc) ->
    {S1, D} = latch_core:step(Env, S, E),
    fold(Env, S1, T, [D | Acc]).

res(D) -> maps:get(result, D).
lat(D) -> maps:get(latch, D).
last(L) -> lists:last(L).

%%--------------------------------------------------------------------
tests() ->
    [{"stale event returns STALE_EVENT, state unchanged", fun t_stale/0},
     {"duplicate id returns DUPLICATE, state unchanged", fun t_dup/0},
     {"PASS cannot clear a latched FAIL", fun t_pass_cannot_clear/0},
     {"FAIL non-critical -> QUARANTINE; critical -> BLOCK", fun t_fail_crit_noncrit/0},
     {"invalid status latches (BLOCK)", fun t_invalid_status/0},
     {"repair with wrong revision rejected (valid sig for other rev)", fun t_repair_wrong_rev/0},
     {"repair with envelope rev != signed rev rejected (bad signature)", fun t_repair_rev_mismatch_sig/0},
     {"repair with bad signature rejected (wrong key / tampered)", fun t_repair_bad_sig/0},
     {"repair with right revision and signature clears; fresh PASS needed", fun t_repair_good/0},
     {"critical UNAVAILABLE -> QUARANTINE, resolved by same-check PASS same revision", fun t_unavail_resolved/0},
     {"UNAVAILABLE not resolved by other check / other revision PASS", fun t_unavail_not_resolved/0},
     {"non-critical UNAVAILABLE recorded, no latch change", fun t_unavail_noncrit/0},
     {"UNAVAILABLE cannot weaken a latched FAIL", fun t_unavail_vs_fail/0},
     {"per-stream sequences are independent (not global)", fun t_per_stream_seq/0},
     {"latch state keyed by revision", fun t_keyed_by_revision/0},
     {"malformed envelope -> MALFORMED, state unchanged", fun t_malformed/0},
     {"RELEASE_CANDIDATE only when all required checks PASS", fun t_candidate/0},
     {"replay of the same log (with redelivered duplicates) -> identical state hash", fun t_replay_identical/0},
     {"signing key never appears in state or decisions", fun t_key_not_leaked/0}].

all_test_() -> [{N, F} || {N, F} <- tests()].

%%--------------------------------------------------------------------
t_stale() ->
    {S1, [_, D1]} = fold([ev(<<"a">>, <<"runner.suite">>, ?R1, <<"PASS">>, <<"s">>, 5),
                          ev(<<"b">>, <<"agda.kernel">>, ?R1, <<"PASS">>, <<"s">>, 4)]),
    ?assertEqual('STALE_EVENT', res(D1)),
    ?assertEqual(false, maps:get(state_changed, D1)),
    {S2, [D2]} = fold(env(), S1, [ev(<<"c">>, <<"agda.kernel">>, ?R1, <<"PASS">>, <<"s">>, 5)], []),
    ?assertEqual('STALE_EVENT', res(D2)),  %% equal seq is also stale
    ?assertEqual(S1, S2),
    %% state after stale equals state that never saw it
    {S3, _} = fold([ev(<<"a">>, <<"runner.suite">>, ?R1, <<"PASS">>, <<"s">>, 5)]),
    ?assertEqual(S3, S1).

t_dup() ->
    E = ev(<<"a">>, <<"runner.suite">>, ?R1, <<"FAIL">>, <<"s">>, 1),
    {S1, [D0, D1]} = fold([E, E]),
    ?assertEqual('ACCEPTED', res(D0)),
    ?assertEqual('DUPLICATE', res(D1)),
    {S0, _} = fold([E]),
    ?assertEqual(S0, S1),
    %% duplicate wins even if seq would also be stale
    {_, [_, _, D2]} = fold([E, ev(<<"z">>, <<"x">>, ?R1, <<"PASS">>, <<"s">>, 9), E]),
    ?assertEqual('DUPLICATE', res(D2)).

t_pass_cannot_clear() ->
    {S, Ds} = fold([ev(<<"1">>, <<"runner.suite">>, ?R1, <<"FAIL">>, <<"s">>, 1),
                    ev(<<"2">>, <<"runner.suite">>, ?R1, <<"PASS">>, <<"s">>, 2),
                    ev(<<"3">>, <<"runner.suite">>, ?R1, <<"PASS">>, <<"s">>, 3),
                    ev(<<"4">>, <<"agda.kernel">>, ?R1, <<"PASS">>, <<"t">>, 1)]),
    ?assertEqual(['ACCEPTED', 'PASS_IGNORED', 'PASS_IGNORED', 'ACCEPTED'], [res(D) || D <- Ds]),
    ?assertEqual(block, latch_core:rev_latch(env(), S, ?R1)).

t_fail_crit_noncrit() ->
    {_, [Dn]} = fold([ev(<<"1">>, <<"c1">>, ?R1, <<"FAIL">>, <<"s">>, 1, false)]),
    ?assertEqual(quarantine, lat(Dn)),
    {_, [Dc]} = fold([ev(<<"1">>, <<"c1">>, ?R1, <<"FAIL">>, <<"s">>, 1, true)]),
    ?assertEqual(block, lat(Dc)),
    %% non-critical fail then critical fail on another check escalates to block
    {_, Ds} = fold([ev(<<"1">>, <<"c1">>, ?R1, <<"FAIL">>, <<"s">>, 1, false),
                    ev(<<"2">>, <<"c2">>, ?R1, <<"FAIL">>, <<"s">>, 2, true)]),
    ?assertEqual([quarantine, block], [lat(D) || D <- Ds]),
    %% a non-critical FAIL is still a latched failure: PASS does not clear it
    {_, Ds2} = fold([ev(<<"1">>, <<"c1">>, ?R1, <<"FAIL">>, <<"s">>, 1, false),
                     ev(<<"2">>, <<"c1">>, ?R1, <<"PASS">>, <<"s">>, 2, false)]),
    ?assertEqual(['ACCEPTED', 'PASS_IGNORED'], [res(D) || D <- Ds2]),
    ?assertEqual(quarantine, lat(last(Ds2))).

t_invalid_status() ->
    lists:foreach(
      fun(Bad) ->
              {S, [D]} = fold([ev(<<"1">>, <<"c1">>, ?R1, Bad, <<"s">>, 1)]),
              ?assertEqual(block, lat(D)),
              ?assertEqual(invalid_status_latched, maps:get(reason, D)),
              %% PASS afterwards does not clear it
              {_, [D2]} = fold(env(), S, [ev(<<"2">>, <<"c1">>, ?R1, <<"PASS">>, <<"s">>, 2)], []),
              ?assertEqual('PASS_IGNORED', res(D2))
      end, [<<"MAYBE">>, <<"pass">>, <<>>, 42, null]),
    %% missing status key entirely
    M = maps:remove(<<"status">>, ev(<<"1">>, <<"c1">>, ?R1, <<"PASS">>, <<"s">>, 1)),
    {_, [D3]} = fold([M]),
    ?assertEqual(block, lat(D3)).

failed_rev1() -> ev(<<"f">>, <<"runner.suite">>, ?R1, <<"FAIL">>, <<"s">>, 1).

t_repair_wrong_rev() ->
    %% repair is validly signed, but for revision R2; failure is on R1.
    Rep = repair(<<"r1">>, <<"runner.suite">>, ?R2, ?R2, <<"rep">>, 1, key()),
    {S, [_, D]} = fold([failed_rev1(), Rep]),
    ?assertEqual('REPAIR_REJECTED', res(D)),
    ?assertEqual(no_latched_failure_for_this_revision_and_check, maps:get(reason, D)),
    ?assertEqual(block, latch_core:rev_latch(env(), S, ?R1)).

t_repair_rev_mismatch_sig() ->
    %% envelope says R1 (where the failure is) but the signature covers R2
    Rep = repair(<<"r1">>, <<"runner.suite">>, ?R1, ?R2, <<"rep">>, 1, key()),
    {S, [_, D]} = fold([failed_rev1(), Rep]),
    ?assertEqual('REPAIR_REJECTED', res(D)),
    ?assertEqual(bad_signature, maps:get(reason, D)),
    ?assertEqual(block, latch_core:rev_latch(env(), S, ?R1)).

t_repair_bad_sig() ->
    Wrong = repair(<<"r1">>, <<"runner.suite">>, ?R1, ?R1, <<"rep">>, 1, other_key()),
    Good = repair(<<"r2">>, <<"runner.suite">>, ?R1, ?R1, <<"rep">>, 2, key()),
    Tampered = Good#{<<"id">> => <<"r3">>, <<"seq">> => 3},          %% sig covers id r2
    NoSig = maps:remove(<<"sig">>, Good#{<<"id">> => <<"r4">>, <<"seq">> => 4}),
    Short = Good#{<<"id">> => <<"r5">>, <<"seq">> => 5, <<"sig">> => <<"abcd">>},
    NonBin = Good#{<<"id">> => <<"r6">>, <<"seq">> => 6, <<"sig">> => 12345},
    {S, Ds} = fold([failed_rev1(), Wrong, Tampered, NoSig, Short, NonBin]),
    ?assertEqual(['ACCEPTED' | lists:duplicate(5, 'REPAIR_REJECTED')], [res(D) || D <- Ds]),
    ?assertEqual(lists:duplicate(5, bad_signature), [maps:get(reason, D) || D <- tl(Ds)]),
    ?assertEqual(block, latch_core:rev_latch(env(), S, ?R1)),
    %% rejected repairs leave no trace: state identical to failure-only state
    {S0, _} = fold([failed_rev1()]),
    ?assertEqual(S0, S).

t_repair_good() ->
    Good = repair(<<"r1">>, <<"runner.suite">>, ?R1, ?R1, <<"rep">>, 1, key()),
    {S, Ds} = fold([failed_rev1(),
                    ev(<<"p0">>, <<"agda.kernel">>, ?R1, <<"PASS">>, <<"t">>, 1),
                    Good]),
    ?assertEqual('REPAIR_ACCEPTED', res(last(Ds))),
    %% cleared, but runner.suite has no PASS yet -> pending, not candidate
    ?assertEqual(pending, lat(last(Ds))),
    {_, [D]} = fold(env(), S, [ev(<<"p1">>, <<"runner.suite">>, ?R1, <<"PASS">>, <<"s">>, 2)], []),
    ?assertEqual(candidate, lat(D)),
    %% same repair replayed -> DUPLICATE (cannot be replayed to clear a later failure)
    {S2, [D2]} = fold(env(), S, [Good], []),
    ?assertEqual('DUPLICATE', res(D2)), ?assertEqual(S, S2),
    %% a new FAIL after repair latches again, and the OLD repair cannot clear it
    {_, Ds3} = fold(env(), S, [ev(<<"f2">>, <<"runner.suite">>, ?R1, <<"FAIL">>, <<"s">>, 3), Good], []),
    ?assertEqual([block, block], [lat(D3) || D3 <- Ds3]),
    ?assertEqual('DUPLICATE', res(last(Ds3))).

t_unavail_resolved() ->
    {S, Ds} = fold([ev(<<"1">>, <<"runner.suite">>, ?R1, <<"UNAVAILABLE">>, <<"s">>, 1)]),
    ?assertEqual(quarantine, lat(hd(Ds))),
    {_, [D]} = fold(env(), S, [ev(<<"2">>, <<"runner.suite">>, ?R1, <<"PASS">>, <<"s">>, 2)], []),
    ?assertEqual('UNAVAILABLE_RESOLVED', res(D)),
    ?assertEqual(pending, lat(D)),
    %% with all required passing it goes to candidate
    {_, Ds2} = fold([ev(<<"1">>, <<"runner.suite">>, ?R1, <<"UNAVAILABLE">>, <<"s">>, 1),
                     ev(<<"2">>, <<"agda.kernel">>, ?R1, <<"PASS">>, <<"t">>, 1),
                     ev(<<"3">>, <<"runner.suite">>, ?R1, <<"PASS">>, <<"s">>, 2)]),
    ?assertEqual([quarantine, quarantine, candidate], [lat(X) || X <- Ds2]).

t_unavail_not_resolved() ->
    {S, _} = fold([ev(<<"1">>, <<"runner.suite">>, ?R1, <<"UNAVAILABLE">>, <<"s">>, 1)]),
    {_, [DOther]} = fold(env(), S, [ev(<<"2">>, <<"agda.kernel">>, ?R1, <<"PASS">>, <<"t">>, 1)], []),
    ?assertEqual(quarantine, lat(DOther)),
    {S2, [DRev]} = fold(env(), S, [ev(<<"3">>, <<"runner.suite">>, ?R2, <<"PASS">>, <<"u">>, 1)], []),
    ?assertEqual(quarantine, latch_core:rev_latch(env(), S2, ?R1)),
    ?assertEqual(pending, lat(DRev)).

t_unavail_noncrit() ->
    {_, [D]} = fold([ev(<<"1">>, <<"c1">>, ?R1, <<"UNAVAILABLE">>, <<"s">>, 1, false)]),
    ?assertEqual(pending, lat(D)),
    ?assertEqual(noncritical_unavailable_recorded, maps:get(reason, D)).

t_unavail_vs_fail() ->
    {_, Ds} = fold([ev(<<"1">>, <<"c1">>, ?R1, <<"FAIL">>, <<"s">>, 1),
                    ev(<<"2">>, <<"c1">>, ?R1, <<"UNAVAILABLE">>, <<"s">>, 2)]),
    ?assertEqual([block, block], [lat(D) || D <- Ds]).

t_per_stream_seq() ->
    %% stream a is at seq 100; stream b starts at seq 1 and must be accepted.
    {_, Ds} = fold([ev(<<"1">>, <<"runner.suite">>, ?R1, <<"PASS">>, <<"a">>, 100),
                    ev(<<"2">>, <<"agda.kernel">>, ?R1, <<"PASS">>, <<"b">>, 1),
                    ev(<<"3">>, <<"agda.kernel">>, ?R1, <<"PASS">>, <<"b">>, 2),
                    ev(<<"4">>, <<"x">>, ?R1, <<"PASS">>, <<"a">>, 99),     %% stale in a
                    ev(<<"5">>, <<"y">>, ?R1, <<"PASS">>, <<"b">>, 3)]),   %% fresh in b
    ?assertEqual(['ACCEPTED', 'ACCEPTED', 'ACCEPTED', 'STALE_EVENT', 'ACCEPTED'],
                 [res(D) || D <- Ds]).

t_keyed_by_revision() ->
    {S, _} = fold([ev(<<"1">>, <<"runner.suite">>, ?R1, <<"FAIL">>, <<"s">>, 1),
                   ev(<<"2">>, <<"runner.suite">>, ?R2, <<"PASS">>, <<"s">>, 2),
                   ev(<<"3">>, <<"agda.kernel">>, ?R2, <<"PASS">>, <<"t">>, 1)]),
    ?assertEqual(block, latch_core:rev_latch(env(), S, ?R1)),
    ?assertEqual(candidate, latch_core:rev_latch(env(), S, ?R2)).

t_malformed() ->
    Base = ev(<<"1">>, <<"c">>, ?R1, <<"PASS">>, <<"s">>, 1),
    Bads = [maps:remove(<<"id">>, Base), maps:remove(<<"revision">>, Base),
            maps:remove(<<"check">>, Base), maps:remove(<<"stream">>, Base),
            maps:remove(<<"seq">>, Base), Base#{<<"seq">> => -1},
            Base#{<<"seq">> => <<"1">>}, Base#{<<"kind">> => <<"other">>}, not_a_map, 7],
    lists:foreach(fun(B) ->
                          {S, [D]} = fold([B]),
                          ?assertEqual('MALFORMED', res(D)),
                          ?assertEqual(latch_core:new(), S)
                  end, Bads).

t_candidate() ->
    {_, Ds} = fold([ev(<<"1">>, <<"runner.suite">>, ?R1, <<"PASS">>, <<"s">>, 1),
                    ev(<<"2">>, <<"agda.kernel">>, ?R1, <<"PASS">>, <<"t">>, 1)]),
    ?assertEqual([pending, candidate], [lat(D) || D <- Ds]),
    %% extra passes of non-required checks do not matter; empty required never yields candidate
    {_, [D]} = fold(#{key => key(), required => []}, latch_core:new(),
                    [ev(<<"1">>, <<"c">>, ?R1, <<"PASS">>, <<"s">>, 1)], []),
    ?assertEqual(pending, lat(D)).

t_replay_identical() ->
    Evs = [ev(<<"1">>, <<"runner.suite">>, ?R1, <<"UNAVAILABLE">>, <<"s">>, 1),
           ev(<<"2">>, <<"agda.kernel">>, ?R1, <<"FAIL">>, <<"t">>, 1),
           ev(<<"3">>, <<"agda.kernel">>, ?R1, <<"PASS">>, <<"t">>, 2),
           repair(<<"r1">>, <<"agda.kernel">>, ?R1, ?R1, <<"rep">>, 1, key()),
           ev(<<"4">>, <<"agda.kernel">>, ?R1, <<"PASS">>, <<"t">>, 3),
           ev(<<"5">>, <<"runner.suite">>, ?R1, <<"PASS">>, <<"s">>, 2)],
    {S1, _} = fold(Evs),
    %% at-least-once redelivery: duplicates interleaved
    Dups = lists:flatmap(fun(E) -> [E, E] end, Evs),
    {S2, _} = fold(Dups),
    %% restart in the middle: persist state, reload, continue
    {Head, Tail} = lists:split(3, Evs),
    {Sm, _} = fold(Head),
    Reloaded = binary_to_term(term_to_binary(Sm)),
    {S3, _} = fold(env(), Reloaded, Tail, []),
    H = latch_core:state_hash(S1),
    ?assertEqual(H, latch_core:state_hash(S2)),
    ?assertEqual(H, latch_core:state_hash(S3)),
    ?assertEqual(candidate, latch_core:rev_latch(env(), S1, ?R1)).

t_key_not_leaked() ->
    {S, Ds} = fold([failed_rev1(), repair(<<"r1">>, <<"runner.suite">>, ?R1, ?R1, <<"rep">>, 1, key())]),
    Blob = term_to_binary({S, Ds}),
    ?assertEqual(nomatch, binary:match(Blob, <<"unit-test-key-0123456789abcdef">>)).
