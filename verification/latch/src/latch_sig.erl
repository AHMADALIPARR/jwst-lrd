%% SPDX-License-Identifier: AGPL-3.0-only
%% Repair-evidence signatures: HMAC-SHA256 (Erlang crypto), key read from a file.
%% The key is only ever held inside a closure (fun() -> Key end) so it does not
%% appear in decisions, audit records, logs or crash terms.
-module(latch_sig).
-export([load_key/1, key_from_bytes/1, repair_message/4, sign/2, verify/3]).

%% Returns a closure; returns {error, Reason} if the file cannot be read or is empty.
load_key(Path) ->
    case file:read_file(Path) of
        {ok, Raw} ->
            Key = string:trim(Raw),
            case byte_size(Key) >= 16 of
                true -> {ok, key_from_bytes(Key)};
                false -> {error, key_too_short}
            end;
        {error, R} -> {error, {key_file, R}}
    end.

key_from_bytes(Key) when is_binary(Key) -> fun() -> Key end.

%% Canonical signed message. Ties the signature to the revision, the repaired check,
%% the repair event id and the digest of the repair evidence.
repair_message(Revision, Check, Id, EvidenceSha) ->
    iolist_to_binary([<<"repair/v1\n">>, Revision, <<"\n">>, Check, <<"\n">>,
                      Id, <<"\n">>, EvidenceSha]).

sign(KeyFun, Msg) ->
    Mac = crypto:mac(hmac, sha256, KeyFun(), Msg),
    binary:encode_hex(Mac, lowercase).

verify(KeyFun, Msg, SigHex) when is_binary(SigHex) ->
    Expected = sign(KeyFun, Msg),
    byte_size(Expected) =:= byte_size(SigHex)
        andalso crypto:hash_equals(Expected, SigHex);
verify(_, _, _) -> false.
