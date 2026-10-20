<!-- SPDX-License-Identifier: AGPL-3.0-or-later OR LicenseRef-SnapKitty-Opaque -->
<!-- Dual-licensed (intentionally): AGPL-3.0-or-later plus the SnapKitty Opaque License. -->
# lrd-authority line protocol (v1)

Transport: Unix stream socket. The worker socket path is given by `--sock`. The admin socket
defaults to `<authority dir>/admin.sock`. Both are created with mode 0600.

Framing: each request is one line terminated by `\n`, and each response is one line. A line is an
LRD-REC-v1 field set in wire form: `key=value` tokens separated by single spaces. Keys match
`[a-z0-9_]+`, values are non-empty and contain no space or newline, and duplicate keys are
rejected. Canonical hashing always uses the LRD-REC-v1 *serialization* (CONTRACTS.md), never the
wire line. A connection may carry several requests. The maximum line length is 64 KiB.

## Capability record
`cap_expiry cap_id cap_mac cap_nonce cap_prev cap_scope cap_seq`
- `cap_scope` is one of `transition`, `read` or `historical_read`.
- `cap_mac = HMAC-SHA256(K_auth, "LRD-CAP-v1\0" || LRD-REC-v1{the other six fields})`.

## Worker socket
| op | request fields | ACCEPT response fields |
|---|---|---|
| `SUBMIT` | LRD-STATE-v1 proposal: `kind=capability prev_commit seq payload_sha256`; kind-specific: all `cap_*` fields, `prev_witness` (hex) and optionally `claimed_commit` | `decision=ACCEPT reason=ok new_commit seq cap_nonce new_witness acc_states` |
| `HEAD` | a `read` or `historical_read` capability | head state record + `state_commit witness acc_states head_seq` |
| `HISTORY` | a `historical_read` capability + `seq` (at most `cap_seq`) | the state record at `seq` + `state_commit witness acc_states head_seq` |
| `VERIFY` | `acc=state\|retired element witness` | `decision=ACCEPT reason=ok` |
| `RETIRED_PROOF` | `cap_id` | `witness acc_retired` |
| `PARAMS` | none | `modulus` |

Every REJECT has the form `decision=REJECT reason=<token> head_seq=<n>` and has **no** `new_commit`.
The reason tokens are `ok`, `stale_seq`, `bad_prev`, `bad_proof`-family (`bad_witness`), and the
capability tokens `bad_mac`, `unknown_cap`, `bad_scope`, `replay`, `retired`, `expired`,
`cap_binding`, `seq_gap`, `bad_commit`, `bad_kind`, `malformed`, `out_of_range`, `not_retired`,
`bad_op` and `persist_failed`.

## Admin socket (operator only)
`op=ISSUE scope=<scope> ttl=<secs>` returns the capability record + `result=ok`.
`op=REVOKE cap_id=..` returns `result=ok status=revoked`.
`op=STATUS` returns `result=ok seq head persisted_seq`.
`op=SHUTDOWN` exits the authority.

## Accepted state record (LRD-STATE-v1, kind=capability)
`{cap_nonce, commit=<prev commitment, 64 zeros at genesis>, kind=capability, payload_sha256, seq}`.
Its commitment is `SHA-256("LRD-COMMIT-v1\0" || LRD-REC-v1 serialization)`. The genesis record
(seq 0) uses `payload_sha256 = SHA-256("")` and a fresh authority nonce.
