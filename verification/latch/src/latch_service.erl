%% SPDX-License-Identifier: AGPL-3.0-only
%% Imperative shell around the pure latch_core: JetStream durable pull consumer with
%% explicit acks. Per message, in this order:
%%   1. latch_core:step (pure)
%%   2. publish decision(s) to verify.audit.decision / verify.latch.* with a
%%      Nats-Msg-Id header (JetStream de-duplicates re-publication after a crash)
%%   3. atomically persist the state snapshot (tmp file + fsync + rename)
%%   4. ack
%% A crash between 3 and 4 causes redelivery, which latch_core answers with DUPLICATE
%% (state unchanged). A crash between 2 and 3 re-runs step from the old snapshot, yields
%% the same decision, and the re-publication is dropped by Nats-Msg-Id de-duplication.
-module(latch_service).
-export([run/1, default_required/0, ensure_streams/1, latch_subject/1]).

default_required() ->
    [<<"runner.suite">>, <<"agda.kernel">>, <<"futhark.diff">>, <<"hamiltonian.suite">>,
     <<"ledger.abi">>, <<"license.spdx">>, <<"ingest.replay">>,
     <<"redshift.z_residual">>, <<"qso1.fixture">>].

-define(IN, <<"VERIFY">>).
-define(OUT, <<"VERIFYOUT">>).
-define(NS, 1000000000).

ensure_streams(C) ->
    {ok, _} = nats_min:js_api(C, <<"STREAM.CREATE.", ?IN/binary>>,
              #{name => ?IN, subjects => [<<"verify.signal.*">>, <<"verify.evidence.*">>],
                storage => file, retention => limits}),
    {ok, _} = nats_min:js_api(C, <<"STREAM.CREATE.", ?OUT/binary>>,
              #{name => ?OUT, subjects => [<<"verify.latch.*">>, <<"verify.audit.*">>],
                storage => file, retention => limits, duplicate_window => 3600 * ?NS}),
    ok.

latch_subject(block) -> <<"verify.latch.blocked">>;
latch_subject(quarantine) -> <<"verify.latch.quarantine">>;
latch_subject(candidate) -> <<"verify.latch.candidate">>;
latch_subject(_) -> undefined.

latch_label(block) -> <<"BLOCK">>;
latch_label(quarantine) -> <<"QUARANTINE">>;
latch_label(candidate) -> <<"RELEASE_CANDIDATE">>;
latch_label(pending) -> <<"PENDING">>;
latch_label(undefined) -> null.

%% Opts: host port key_path state_file consumer publish exit_when_idle required
run(Opts) ->
    Host = maps:get(host, Opts, "127.0.0.1"),
    Port = maps:get(port, Opts, 14222),
    Consumer = maps:get(consumer, Opts, <<"latch">>),
    StateFile = maps:get(state_file, Opts),
    {ok, KeyFun} = latch_sig:load_key(maps:get(key_path, Opts)),
    Env = #{key => KeyFun, required => maps:get(required, Opts, default_required())},
    {ok, C} = nats_min:connect(Host, Port),
    ok = ensure_streams(C),
    {ok, _} = nats_min:js_api(C, <<"CONSUMER.CREATE.", ?IN/binary, ".", Consumer/binary>>,
              #{stream_name => ?IN,
                config => #{durable_name => Consumer, ack_policy => explicit,
                            deliver_policy => all, ack_wait => 3 * ?NS,
                            max_deliver => -1}}),
    State0 = load(StateFile),
    io:format("[latch] start consumer=~s state_file=~s events_seen=~p state_hash=~s~n",
              [Consumer, filename:basename(StateFile),
               map_size(maps:get(seen, State0)), latch_core:state_hash(State0)]),
    Crash = case os:getenv("LATCH_CRASH_AFTER_EVENT") of false -> none; V -> list_to_binary(V) end,
    Ctx = #{conn => C, env => Env, consumer => Consumer, state_file => StateFile,
            publish => maps:get(publish, Opts, true), crash => Crash},
    loop(Ctx, State0, 0, false, maps:get(exit_when_idle, Opts, false)).

loop(#{conn := C, consumer := Consumer, env := Env} = Ctx, State, N, Idle, ExitIdle) ->
    case nats_min:js_fetch_one(C, ?IN, Consumer, 1500) of
        {ok, Msg} ->
            State1 = handle(Ctx, State, Msg),
            loop(Ctx, State1, N + 1, false, ExitIdle);
        none ->
            case Idle of
                true -> ok;
                false ->
                    io:format("[latch] IDLE processed_this_run=~p state_hash=~s~n~s",
                              [N, latch_core:state_hash(State), latch_core:summary(Env, State)])
            end,
            case ExitIdle of
                true -> nats_min:close(C), {State, latch_core:state_hash(State)};
                false -> loop(Ctx, State, N, true, ExitIdle)
            end;
        {error, E} ->
            io:format("[latch] fetch error ~p~n", [E]), timer:sleep(500),
            loop(Ctx, State, N, Idle, ExitIdle)
    end.

handle(#{conn := C, env := Env, state_file := File, publish := Pub, crash := Crash} = _Ctx,
       State, #{subject := Subject, payload := Payload, reply := Reply} = Msg) ->
    {Delivered, StreamSeq} = ack_meta(Reply),
    Raw = case catch json:decode(Payload) of
              M when is_map(M) -> M#{<<"stream">> => Subject};   %% sequence key = subject
              _ -> undefined
          end,
    {State1, Dec} = latch_core:step(Env, State, Raw),
    #{result := Result, event_id := EvId} = Dec,
    Meta = #{stream_seq => StreamSeq, delivered => Delivered, subject => Subject},
    case Pub of
        true -> publish_outputs(C, Dec, Meta);
        false -> ok
    end,
    case maps:get(state_changed, Dec) of
        true -> persist(File, State1);
        false -> ok
    end,
    io:format("[latch] js_seq=~p delivered=~p ~s id=~s -> ~s (~s) latch ~s -> ~s~n",
              [StreamSeq, Delivered, Subject, bin(EvId), Result, reason_bin(maps:get(reason, Dec)),
               latch_label(maps:get(prev_latch, Dec)), latch_label(maps:get(latch, Dec))]),
    case Crash =/= none andalso EvId =:= Crash andalso Delivered =:= 1 of
        true ->
            io:format("[latch] FAULT INJECTION: halting after persist, BEFORE ack of ~s~n", [bin(EvId)]),
            erlang:halt(137);
        false -> ok
    end,
    nats_min:ack(C, Msg),
    ok = nats_min:flush(C),
    State1.

ack_meta(Reply) ->
    %% $JS.ACK.<stream>.<consumer>.<delivered>.<stream_seq>.<consumer_seq>.<ts>.<pending>
    %% (newer servers prepend domain/account tokens, so parse from the end)
    T = lists:reverse(binary:split(Reply, <<".">>, [global])),
    [_Pending, _Ts, _CSeq, SSeq, Deliv | _] = T,
    {binary_to_integer(Deliv), binary_to_integer(SSeq)}.

publish_outputs(C, Dec, Meta) ->
    #{result := Result, event_id := EvId, latch := Latch, prev_latch := Prev,
      revision := Rev} = Dec,
    Audit = #{event_id => bin(EvId), revision => nullable(Rev), check => nullable(maps:get(check, Dec)),
              result => atom_to_binary(Result), reason => reason_bin(maps:get(reason, Dec)),
              prev_latch => latch_label(Prev), latch => latch_label(Latch),
              state_changed => maps:get(state_changed, Dec),
              stream_seq => maps:get(stream_seq, Meta), delivered => maps:get(delivered, Meta),
              subject => maps:get(subject, Meta)},
    AuditId = iolist_to_binary(["audit:", integer_to_binary(maps:get(stream_seq, Meta)), ":", atom_to_binary(Result)]),
    {ok, _} = nats_min:js_publish(C, <<"verify.audit.decision">>,
                                  [{<<"Nats-Msg-Id">>, AuditId}], json:encode(Audit)),
    case maps:get(state_changed, Dec) andalso Latch =/= Prev andalso latch_subject(Latch) of
        Subj when is_binary(Subj) ->
            Body = #{revision => Rev, latch => latch_label(Latch), prev_latch => latch_label(Prev),
                     cause_event_id => bin(EvId),
                     note => <<"RELEASE_CANDIDATE is not final authorization">>},
            {ok, _} = nats_min:js_publish(C, Subj,
                       [{<<"Nats-Msg-Id">>, iolist_to_binary(["latch:", Rev, ":", latch_label(Latch), ":", bin(EvId)])}],
                       json:encode(Body)),
            ok;
        _ -> ok
    end.

nullable(undefined) -> null;
nullable(X) -> X.
bin(undefined) -> <<"(none)">>;
bin(B) when is_binary(B) -> B;
bin(X) -> iolist_to_binary(io_lib:format("~0p", [X])).
reason_bin(R) when is_atom(R) -> atom_to_binary(R);
reason_bin(R) -> iolist_to_binary(io_lib:format("~0p", [R])).

%%--------------------------------------------------------------------
load(File) ->
    {module, latch_core} = code:ensure_loaded(latch_core),  %% atoms must exist for [safe]
    case file:read_file(File) of
        {ok, Bin} -> binary_to_term(Bin, [safe]);
        {error, enoent} -> latch_core:new()
    end.

persist(File, State) ->
    Tmp = File ++ ".tmp",
    {ok, Fd} = file:open(Tmp, [write, raw, binary]),
    ok = file:write(Fd, term_to_binary(State, [deterministic])),
    ok = file:sync(Fd),
    ok = file:close(Fd),
    ok = file:rename(Tmp, File).
