%% SPDX-License-Identifier: AGPL-3.0-only
%% Runs latch_core_tests:tests() and prints PASS/FAIL/UNAVAILABLE counts.
-module(latch_test_runner).
-export([run/0, main/0]).

main() ->
    case run() of
        {_, 0, _} -> halt(0);
        _ -> halt(1)
    end.

run() ->
    Tests = latch_core_tests:tests(),
    Results = [{N, run_one(F)} || {N, F} <- Tests],
    lists:foreach(fun({N, R}) -> io:format("~-9s ~s~n", [label(R), N]),
                                 report(R) end, Results),
    P = length([x || {_, pass} <- Results]),
    F = length([x || {_, {fail, _}} <- Results]),
    U = length([x || {_, {unavailable, _}} <- Results]),
    io:format("~nSUMMARY (latch_core eunit cases): PASS=~p FAIL=~p UNAVAILABLE=~p TOTAL=~p~n",
              [P, F, U, length(Results)]),
    {P, F, U}.

run_one(F) ->
    try F(), pass
    catch throw:{unavailable, Why} -> {unavailable, Why};
          Class:Reason:St -> {fail, {Class, Reason, lists:sublist(St, 3)}}
    end.

label(pass) -> "PASS";
label({fail, _}) -> "FAIL";
label({unavailable, _}) -> "UNAVAIL".

report({fail, Info}) -> io:format("          ~p~n", [Info]);
report({unavailable, Why}) -> io:format("          ~p~n", [Why]);
report(_) -> ok.
