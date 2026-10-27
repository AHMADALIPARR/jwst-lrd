%% SPDX-License-Identifier: AGPL-3.0-only
%% Command line driver (invoked via scripts/lc.sh): setup, publish, serve, fold, dump.
-module(latch_ctl).
-export([main/0]).

-define(HOST, "127.0.0.1").

main() ->
    Args = [list_to_binary(A) || A <- init:get_plain_arguments()],
    Port = list_to_integer(os:getenv("NATS_PORT", "14222")),
    try cmd(Args, Port) of
        _ -> halt(0)
    catch Class:Reason:St ->
            io:format(standard_error, "latch_ctl error: ~p:~p ~p~n", [Class, Reason, lists:sublist(St, 4)]),
            halt(2)
    end.

conn(Port) -> {ok, C} = nats_min:connect(?HOST, Port), C.
key(Path) -> {ok, K} = latch_sig:load_key(binary_to_list(Path)), K.

cmd([<<"setup">>], Port) ->
    C = conn(Port), ok = latch_service:ensure_streams(C), io:format("streams VERIFY, VERIFYOUT ready~n");
cmd([<<"pub-batch">>, N, KeyPath], Port) ->
    C = conn(Port),
    Evs = latch_scenario:batch(binary_to_integer(N), key(KeyPath)),
    lists:foreach(fun({Subj, E}) -> pub(C, Subj, E) end, Evs),
    io:format("published scripted batch ~s (~p events)~n", [N, length(Evs)]);
cmd([<<"pub-file">>, File], Port) ->
    C = conn(Port),
    {ok, Bin} = file:read_file(File),
    Lines = [L || L <- binary:split(Bin, <<"\n">>, [global, trim_all]),
                  binary:first(L) =/= $#],
    lists:foreach(fun(L) ->
                          E = json:decode(L),
                          Subj = maps:get(<<"subject">>, E),
                          {ok, Ack} = nats_min:js_publish(C, Subj, [], L),
                          io:format("published ~s id=~s -> stream seq ~p~n",
                                    [Subj, maps:get(<<"id">>, E), maps:get(<<"seq">>, Ack)])
                  end, Lines);
cmd([<<"serve">>, KeyPath, StateFile, Consumer | Flags], Port) ->
    latch_service:run(#{port => Port, key_path => binary_to_list(KeyPath),
                        state_file => binary_to_list(StateFile), consumer => Consumer,
                        publish => not lists:member(<<"--no-publish">>, Flags),
                        exit_when_idle => lists:member(<<"--exit-when-idle">>, Flags)});
cmd([<<"fold-stream">>, KeyPath], Port) ->
    %% Offline pure fold over the whole VERIFY stream via STREAM.MSG.GET (no consumer).
    C = conn(Port),
    {ok, #{<<"state">> := #{<<"last_seq">> := Last}}} = nats_min:js_api(C, <<"STREAM.INFO.VERIFY">>, undefined),
    Env = #{key => key(KeyPath), required => latch_service:default_required()},
    S = lists:foldl(
          fun(Seq, St) ->
                  {ok, #{<<"message">> := M}} =
                      nats_min:js_api(C, <<"STREAM.MSG.GET.VERIFY">>, #{seq => Seq}),
                  Subj = maps:get(<<"subject">>, M),
                  Raw = case catch json:decode(base64:decode(maps:get(<<"data">>, M))) of
                            X when is_map(X) -> X#{<<"stream">> => Subj};
                            _ -> undefined
                        end,
                  {St1, _} = latch_core:step(Env, St, Raw), St1
          end, latch_core:new(), lists:seq(1, Last)),
    io:format("[fold-stream] messages=~p state_hash=~s~n~s",
              [Last, latch_core:state_hash(S), latch_core:summary(Env, S)]);
cmd([<<"dump-out">>], Port) ->
    C = conn(Port),
    {ok, #{<<"state">> := #{<<"last_seq">> := Last}}} = nats_min:js_api(C, <<"STREAM.INFO.VERIFYOUT">>, undefined),
    lists:foreach(
      fun(Seq) ->
              {ok, #{<<"message">> := M}} = nats_min:js_api(C, <<"STREAM.MSG.GET.VERIFYOUT">>, #{seq => Seq}),
              io:format("out#~p ~s ~s~n", [Seq, maps:get(<<"subject">>, M), base64:decode(maps:get(<<"data">>, M))])
      end, lists:seq(1, Last));
cmd(Other, _) -> io:format(standard_error, "unknown command ~p~n", [Other]), halt(64).

pub(C, Subj, E) ->
    {ok, Ack} = nats_min:js_publish(C, Subj, [], json:encode(E)),
    io:format("  pub ~s id=~s -> stream seq ~p~n", [Subj, maps:get(<<"id">>, E), maps:get(<<"seq">>, Ack)]).
