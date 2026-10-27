%% SPDX-License-Identifier: AGPL-3.0-only
%% Pure verification latch: step(Env, State, Event) -> {State', Decision}.
%% No I/O, no clock, no randomness. Erlang owns the decision; evidence producers
%% (including MATLAB/Octave) only supply measurements.
%%
%% Per-revision derived latch (severity order):
%%   block       any critical latched FAIL (or invalid status)
%%   quarantine  any non-critical latched FAIL, or any critical UNAVAILABLE
%%   candidate   every required check has a PASS and nothing above applies
%%               (RELEASE_CANDIDATE is NOT final authorization)
%%   pending     none of the above yet (no latch decision published)
%%
%% Rules implemented (each exercised by test/latch_core_tests.erl):
%%  R1 dedupe by event id (checked first) -> DUPLICATE, no change
%%  R2 sequence tracked per stream key (subject), never globally;
%%     seq =< last seen for that stream -> STALE_EVENT, no change
%%  R3 invalid/missing status -> latched critical failure (BLOCK)
%%  R4 PASS never clears a latched FAIL (PASS_IGNORED)
%%  R5 a FAIL clears only via a signed repair event for the SAME revision+check;
%%     afterwards the check is unverified and needs a fresh PASS
%%  R6 UNAVAILABLE on a critical event -> QUARANTINE; resolved only by a later PASS
%%     for that same check on that same revision (explicit rule, not a FAIL clear)
%%  R7 non-critical UNAVAILABLE is recorded but changes no latch
%%  R8 non-critical FAIL -> QUARANTINE (latched like a FAIL; needs signed repair)
%%  R9 malformed envelope (no id/revision/check/stream/seq) -> MALFORMED, no change
-module(latch_core).
-export([new/0, step/3, normalize/1, rev_latch/3, state_hash/1, summary/2,
         revisions/1]).

-type decision() :: map().

new() -> #{seen => #{}, last_seq => #{}, revs => #{}}.

empty_rev() -> #{passed => #{}, failed => #{}, unavail => #{}}.

revisions(#{revs := R}) -> lists:sort(maps:keys(R)).

%%--------------------------------------------------------------------
%% normalize: raw (JSON-decoded, binary keys) -> {ok, Ev} | {error, Why}
%%--------------------------------------------------------------------
normalize(M) when is_map(M) ->
    try
        Kind = case maps:get(<<"kind">>, M, <<"evidence">>) of
                   K when K =:= <<"evidence">>; K =:= <<"repair">> -> K;
                   _ -> throw(bad_kind)
               end,
        Status = case maps:get(<<"status">>, M, undefined) of
                     <<"PASS">> -> pass;
                     <<"FAIL">> -> fail;
                     <<"UNAVAILABLE">> -> unavailable;
                     _ -> invalid
                 end,
        {ok, #{id => req_bin(<<"id">>, M),
               revision => req_bin(<<"revision">>, M),
               check => req_bin(<<"check">>, M),
               stream => req_bin(<<"stream">>, M),
               seq => req_int(<<"seq">>, M),
               kind => Kind,
               status => Status,
               %% fail-closed: anything but an explicit false is critical
               critical => maps:get(<<"critical">>, M, true) =/= false,
               evidence_sha256 => opt_bin(<<"evidence_sha256">>, M),
               sig => opt_bin(<<"sig">>, M)}}
    catch throw:Why -> {error, Why}
    end;
normalize(_) -> {error, not_a_map}.

req_bin(Key, M) ->
    case maps:get(Key, M, undefined) of
        B when is_binary(B), byte_size(B) > 0 -> B;
        _ -> throw({missing_or_bad, Key})
    end.
req_int(Key, M) ->
    case maps:get(Key, M, undefined) of
        I when is_integer(I), I >= 0 -> I;
        _ -> throw({missing_or_bad, Key})
    end.
opt_bin(Key, M) ->
    case maps:get(Key, M, <<>>) of B when is_binary(B) -> B; _ -> <<>> end.

%%--------------------------------------------------------------------
%% step
%%--------------------------------------------------------------------
-spec step(map(), map(), term()) -> {map(), decision()}.
step(Env, State, Raw) ->
    case normalize(Raw) of
        {error, Why} ->
            Id = case is_map(Raw) of
                     true -> maps:get(<<"id">>, Raw, undefined);
                     false -> undefined
                 end,
            {State, #{result => 'MALFORMED', reason => Why, event_id => Id,
                      revision => undefined, check => undefined,
                      prev_latch => undefined, latch => undefined,
                      state_changed => false}};
        {ok, Ev} ->
            step_ev(Env, State, Ev)
    end.

step_ev(Env, State, #{id := Id, stream := Stream, seq := Seq, revision := Rev} = Ev) ->
    Prev = rev_latch(Env, State, Rev),
    #{seen := Seen, last_seq := Last} = State,
    case maps:is_key(Id, Seen) of
        true ->
            {State, dec('DUPLICATE', event_already_processed, Ev, Prev, Prev, false)};
        false ->
            case Seq =< maps:get(Stream, Last, -1) of
                true ->
                    {State, dec('STALE_EVENT',
                                {seq_not_after_last_for_stream, Stream,
                                 maps:get(Stream, Last)},
                                Ev, Prev, Prev, false)};
                false ->
                    step_kind(Env, State, Ev, Prev)
            end
    end.

%% ---- repair ---------------------------------------------------------
step_kind(Env, State, #{kind := <<"repair">>, revision := Rev, check := Check,
                        id := Id, sig := Sig, evidence_sha256 := Sha} = Ev, Prev) ->
    KeyFun = maps:get(key, Env),
    Msg = latch_sig:repair_message(Rev, Check, Id, Sha),
    case latch_sig:verify(KeyFun, Msg, Sig) of
        false ->
            {State, dec('REPAIR_REJECTED', bad_signature, Ev, Prev, Prev, false)};
        true ->
            RS = rev_state(State, Rev),
            case maps:is_key(Check, maps:get(failed, RS)) of
                false ->
                    {State, dec('REPAIR_REJECTED',
                                no_latched_failure_for_this_revision_and_check,
                                Ev, Prev, Prev, false)};
                true ->
                    RS1 = RS#{failed := maps:remove(Check, maps:get(failed, RS))},
                    State1 = put_rev(mark(State, Ev), Rev, RS1),
                    Now = rev_latch(Env, State1, Rev),
                    {State1, dec('REPAIR_ACCEPTED', failure_cleared_check_needs_fresh_pass,
                                 Ev, Prev, Now, true)}
            end
    end;

%% ---- evidence -------------------------------------------------------
step_kind(Env, State, #{kind := <<"evidence">>, revision := Rev, check := Check,
                        status := Status, critical := Crit, id := Id} = Ev, Prev) ->
    RS = rev_state(State, Rev),
    #{passed := P, failed := F, unavail := U} = RS,
    {Result, Reason, RS1} =
        case Status of
            pass ->
                case maps:is_key(Check, F) of
                    true ->
                        {'PASS_IGNORED', cannot_clear_latched_failure, RS};
                    false ->
                        case maps:is_key(Check, U) of
                            true ->
                                {'UNAVAILABLE_RESOLVED', same_check_pass_on_same_revision,
                                 RS#{unavail := maps:remove(Check, U),
                                     passed := P#{Check => Id}}};
                            false ->
                                {'ACCEPTED', pass_recorded, RS#{passed := P#{Check => Id}}}
                        end
                end;
            fail ->
                OldCrit = case maps:find(Check, F) of
                              {ok, #{critical := C}} -> C; error -> false end,
                {'ACCEPTED', fail_latched,
                 RS#{failed := F#{Check => #{critical => Crit orelse OldCrit,
                                             reason => fail, event => Id}},
                     passed := maps:remove(Check, P),
                     unavail := maps:remove(Check, U)}};
            invalid ->
                {'ACCEPTED', invalid_status_latched,
                 RS#{failed := F#{Check => #{critical => true,
                                             reason => invalid_status, event => Id}},
                     passed := maps:remove(Check, P),
                     unavail := maps:remove(Check, U)}};
            unavailable ->
                case maps:is_key(Check, F) of
                    true ->
                        {'ACCEPTED', unavailable_ignored_failure_stays_latched, RS};
                    false ->
                        {'ACCEPTED',
                         case Crit of
                             true -> critical_unavailable_quarantines;
                             false -> noncritical_unavailable_recorded
                         end,
                         RS#{unavail := U#{Check => #{critical => Crit, event => Id}},
                             passed := maps:remove(Check, P)}}
                end
        end,
    State1 = put_rev(mark(State, Ev), Rev, RS1),
    Now = rev_latch(Env, State1, Rev),
    {State1, dec(Result, Reason, Ev, Prev, Now, true)}.

mark(#{seen := Seen, last_seq := Last} = S, #{id := Id, stream := St, seq := Seq}) ->
    S#{seen := Seen#{Id => true}, last_seq := Last#{St => Seq}}.

rev_state(#{revs := R}, Rev) -> maps:get(Rev, R, empty_rev()).
put_rev(#{revs := R} = S, Rev, RS) -> S#{revs := R#{Rev => RS}}.

dec(Result, Reason, #{id := Id, revision := Rev, check := Check}, Prev, Now, Changed) ->
    #{result => Result, reason => Reason, event_id => Id, revision => Rev,
      check => Check, prev_latch => Prev, latch => Now, state_changed => Changed}.

%%--------------------------------------------------------------------
%% derived latch for a revision
%%--------------------------------------------------------------------
rev_latch(Env, State, Rev) ->
    #{passed := P, failed := F, unavail := U} = rev_state(State, Rev),
    Required = maps:get(required, Env, []),
    AnyCritFail = lists:any(fun(#{critical := C}) -> C end, maps:values(F)),
    AnyCritUnav = lists:any(fun(#{critical := C}) -> C end, maps:values(U)),
    if AnyCritFail -> block;
       map_size(F) > 0 -> quarantine;
       AnyCritUnav -> quarantine;
       true ->
           case Required =/= [] andalso lists:all(fun(C) -> maps:is_key(C, P) end, Required) of
               true -> candidate;
               false -> pending
           end
    end.

%% Deterministic digest of the complete state (seen ids, per-stream seqs, per-rev evidence).
state_hash(State) ->
    binary:encode_hex(crypto:hash(sha256, term_to_binary(State, [deterministic])), lowercase).

summary(Env, #{revs := Revs, last_seq := Last} = State) ->
    RevLines = [begin
                    #{passed := P, failed := F, unavail := U} = maps:get(R, Revs),
                    io_lib:format("  rev ~s latch=~s passed=~p failed=~p unavailable=~p~n",
                                  [R, string:uppercase(atom_to_list(rev_latch(Env, State, R))),
                                   lists:sort(maps:keys(P)), lists:sort(maps:keys(F)),
                                   lists:sort(maps:keys(U))])
                end || R <- lists:sort(maps:keys(Revs))],
    SeqLines = [io_lib:format("  stream ~s last_seq=~p~n", [S, N])
                || {S, N} <- lists:sort(maps:to_list(Last))],
    iolist_to_binary([RevLines, SeqLines,
                      io_lib:format("  events_seen=~p~n", [map_size(maps:get(seen, State))])]).
