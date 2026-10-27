%% SPDX-License-Identifier: AGPL-3.0-only
%% Minimal NATS text-protocol client over gen_tcp (no third-party deps), with the
%% pieces of JetStream needed here, spoken through $JS.API.* request/reply:
%%   stream create, durable pull-consumer create, pull fetch, ack, JS publish,
%%   stream msg get / info.
%% Not a general client: no TLS, no auth, no reconnect, no cluster discovery.
-module(nats_min).
-behaviour(gen_server).
-export([connect/2, close/1, pub/3, pub/4, sub/2, unsub/2, flush/1, request/4,
         js_api/3, js_publish/4, js_fetch_one/4, ack/2, inbox/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2]).

-record(st, {sock, buf = <<>>, subs = #{}, next = 1, pongs = []}).

connect(Host, Port) ->
    gen_server:start(?MODULE, {Host, Port}, []).
close(C) -> catch gen_server:stop(C), ok.

pub(C, Subj, Payload) -> pub(C, Subj, Payload, []).
%% Headers: [{Name, Value}] binaries; uses HPUB when non-empty.
pub(C, Subj, Payload, Headers) -> gen_server:call(C, {pub, Subj, undefined, Headers, Payload}).
sub(C, Subj) -> gen_server:call(C, {sub, Subj, self()}).
unsub(C, Sid) -> gen_server:call(C, {unsub, Sid}).
flush(C) -> gen_server:call(C, flush, 10000).

inbox() ->
    <<"_INBOX.", (binary:encode_hex(crypto:strong_rand_bytes(8)))/binary>>.

%% request/reply; returns {ok, Msg} | {error, timeout}
request(C, Subj, Payload, TimeoutMs) ->
    In = inbox(),
    Sid = sub(C, In),
    ok = gen_server:call(C, {pub, Subj, In, [], Payload}),
    R = receive {nats_msg, Sid, Msg} -> {ok, Msg} after TimeoutMs -> {error, timeout} end,
    unsub(C, Sid),
    R.

%% JetStream API call: Suffix e.g. <<"STREAM.CREATE.VERIFY">>, Body a map -> {ok, Map} | {error, Why}
js_api(C, Suffix, Body) ->
    Payload = case Body of undefined -> <<>>; _ -> iolist_to_binary(json:encode(Body)) end,
    case request(C, <<"$JS.API.", Suffix/binary>>, Payload, 5000) of
        {ok, #{payload := P, status := 503}} -> {error, {no_responders, P}};
        {ok, #{payload := P}} ->
            Map = json:decode(P),
            case maps:find(<<"error">>, Map) of
                {ok, E} -> {error, E};
                error -> {ok, Map}
            end;
        {error, T} -> {error, T}
    end.

%% Publish into a stream and wait for the PubAck.
js_publish(C, Subj, Headers, Payload) ->
    In = inbox(),
    Sid = sub(C, In),
    ok = gen_server:call(C, {pub, Subj, In, Headers, Payload}),
    R = receive
            {nats_msg, Sid, #{payload := P}} ->
                Map = json:decode(P),
                case maps:find(<<"error">>, Map) of
                    {ok, E} -> {error, E};
                    error -> {ok, Map}
                end
        after 5000 -> {error, timeout}
        end,
    unsub(C, Sid),
    R.

%% Pull one message from a durable consumer. Returns {ok, Msg} | none (expired/none).
js_fetch_one(C, Stream, Consumer, ExpiresMs) ->
    In = inbox(),
    Sid = sub(C, In),
    Req = iolist_to_binary(json:encode(#{batch => 1, expires => ExpiresMs * 1000000})),
    ok = gen_server:call(C, {pub, <<"$JS.API.CONSUMER.MSG.NEXT.", Stream/binary, ".", Consumer/binary>>,
                             In, [], Req}),
    R = receive
            {nats_msg, Sid, #{status := undefined} = M} -> {ok, M};
            {nats_msg, Sid, #{status := S}} when S =:= 408; S =:= 404; S =:= 409 -> none;
            {nats_msg, Sid, #{status := S}} -> {error, {status, S}}
        after ExpiresMs + 3000 -> none
        end,
    unsub(C, Sid),
    R.

ack(C, #{reply := Reply}) -> pub(C, Reply, <<"+ACK">>).

%%--------------------------------------------------------------------
init({Host, Port}) ->
    {ok, Sock} = gen_tcp:connect(Host, Port, [binary, {active, false}, {nodelay, true}], 5000),
    {ok, Info} = gen_tcp:recv(Sock, 0, 5000),
    <<"INFO ", _/binary>> = Info,
    Connect = json:encode(#{verbose => false, pedantic => false, headers => true,
                            no_responders => true, lang => <<"erlang">>,
                            version => <<"0.1">>, protocol => 1}),
    ok = gen_tcp:send(Sock, [<<"CONNECT ">>, Connect, <<"\r\nPING\r\n">>]),
    Buf = await_pong(Sock, <<>>),
    ok = inet:setopts(Sock, [{active, once}]),
    {ok, parse(Buf, #st{sock = Sock})}.

handle_call({pub, Subj, Reply, Headers, Payload}, _From, #st{sock = S} = St) ->
    R = case Reply of undefined -> <<>>; _ -> <<" ", Reply/binary>> end,
    Pl = iolist_to_binary(Payload),
    Frame = case Headers of
                [] ->
                    [<<"PUB ">>, Subj, R, <<" ">>, integer_to_binary(byte_size(Pl)), <<"\r\n">>, Pl, <<"\r\n">>];
                _ ->
                    H = iolist_to_binary([<<"NATS/1.0\r\n">>,
                                          [[K, <<": ">>, V, <<"\r\n">>] || {K, V} <- Headers], <<"\r\n">>]),
                    [<<"HPUB ">>, Subj, R, <<" ">>, integer_to_binary(byte_size(H)), <<" ">>,
                     integer_to_binary(byte_size(H) + byte_size(Pl)), <<"\r\n">>, H, Pl, <<"\r\n">>]
            end,
    {reply, gen_tcp:send(S, Frame), St};
handle_call({sub, Subj, Pid}, _From, #st{sock = S, subs = Subs, next = N} = St) ->
    ok = gen_tcp:send(S, [<<"SUB ">>, Subj, <<" ">>, integer_to_binary(N), <<"\r\n">>]),
    {reply, N, St#st{subs = Subs#{N => Pid}, next = N + 1}};
handle_call({unsub, Sid}, _From, #st{sock = S, subs = Subs} = St) ->
    gen_tcp:send(S, [<<"UNSUB ">>, integer_to_binary(Sid), <<"\r\n">>]),
    {reply, ok, St#st{subs = maps:remove(Sid, Subs)}};
handle_call(flush, From, #st{sock = S, pongs = P} = St) ->
    ok = gen_tcp:send(S, <<"PING\r\n">>),
    {noreply, St#st{pongs = P ++ [From]}}.

handle_cast(_, St) -> {noreply, St}.

handle_info({tcp, Sock, Data}, #st{sock = Sock, buf = B} = St) ->
    St1 = parse(<<B/binary, Data/binary>>, St),
    inet:setopts(Sock, [{active, once}]),
    {noreply, St1};
handle_info({tcp_closed, _}, St) -> {stop, normal, St};
handle_info({tcp_error, _, R}, St) -> {stop, {tcp_error, R}, St};
handle_info(_, St) -> {noreply, St}.

terminate(_, #st{sock = S}) -> gen_tcp:close(S), ok.

%%--------------------------------------------------------------------
parse(Buf, St) ->
    case binary:split(Buf, <<"\r\n">>) of
        [Line, Rest] ->
            case line(binary:split(Line, <<" ">>, [global, trim_all]), Rest, St) of
                {more, St1} -> St1#st{buf = Buf};
                {ok, Rest1, St1} -> parse(Rest1, St1)
            end;
        [_] -> St#st{buf = Buf}
    end.

line([<<"PING">>], Rest, #st{sock = S} = St) -> gen_tcp:send(S, <<"PONG\r\n">>), {ok, Rest, St};
line([<<"PONG">>], Rest, #st{pongs = [From | T]} = St) ->
    gen_server:reply(From, ok), {ok, Rest, St#st{pongs = T}};
line([<<"PONG">>], Rest, St) -> {ok, Rest, St};
line([<<"+OK">>], Rest, St) -> {ok, Rest, St};
line([<<"INFO">> | _], Rest, St) -> {ok, Rest, St};
line([<<"-ERR">> | E], Rest, St) -> io:format(standard_error, "nats -ERR ~p~n", [E]), {ok, Rest, St};
line([<<"MSG">>, Subj, Sid, Len], Rest, St) -> msg(Subj, Sid, undefined, 0, Len, Rest, St);
line([<<"MSG">>, Subj, Sid, Reply, Len], Rest, St) -> msg(Subj, Sid, Reply, 0, Len, Rest, St);
line([<<"HMSG">>, Subj, Sid, HL, TL], Rest, St) -> msg(Subj, Sid, undefined, HL, TL, Rest, St);
line([<<"HMSG">>, Subj, Sid, Reply, HL, TL], Rest, St) -> msg(Subj, Sid, Reply, HL, TL, Rest, St);
line(Other, Rest, St) -> io:format(standard_error, "nats: unparsed ~p~n", [Other]), {ok, Rest, St}.

%% For MSG: HL = 0 and TL = payload len. For HMSG both given.
msg(Subj, SidB, Reply, HL0, TL0, Rest, #st{subs = Subs} = St) ->
    {HL, TL} = case HL0 of
                   0 -> {0, binary_to_integer(TL0)};
                   _ -> {binary_to_integer(HL0), binary_to_integer(TL0)}
               end,
    case byte_size(Rest) >= TL + 2 of
        false -> {more, St};
        true ->
            <<Body:TL/binary, "\r\n", Rest1/binary>> = Rest,
            <<Hdr:HL/binary, Payload/binary>> = Body,
            Sid = binary_to_integer(SidB),
            Status = status(Hdr),
            case maps:find(Sid, Subs) of
                {ok, Pid} ->
                    Pid ! {nats_msg, Sid, #{subject => Subj, reply => Reply, headers => Hdr,
                                            status => Status, payload => Payload}};
                error -> ok
            end,
            {ok, Rest1, St}
    end.

status(<<>>) -> undefined;
status(Hdr) ->
    [First | _] = binary:split(Hdr, <<"\r\n">>),
    case binary:split(First, <<" ">>, [global, trim_all]) of
        [<<"NATS/1.0">>, Code | _] -> binary_to_integer(Code);
        _ -> undefined
    end.

%% Wait for the PONG answering our handshake PING; the server may interleave INFO lines.
%% Returns whatever follows the PONG so it is fed to the normal parser.
await_pong(Sock, Acc) ->
    case binary:match(Acc, <<"PONG\r\n">>) of
        {Pos, Len} ->
            <<_:Pos/binary, _:Len/binary, Rest/binary>> = Acc, Rest;
        nomatch ->
            {ok, D} = gen_tcp:recv(Sock, 0, 5000),
            await_pong(Sock, <<Acc/binary, D/binary>>)
    end.
