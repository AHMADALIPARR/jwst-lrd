<!-- SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque -->
<!-- Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited.
     Licensed under AGPL-3.0-only plus the SnapKitty Opaque License (dual license, intentional). -->
# FORMAT.md: LRD-CAUSAL-GRAPH-v1 (causal graph serialization)

This file describes what the code in `fortran/causal/src` writes and accepts. It was written
by reading `causal_lrdrec.f90`, `causal_hexfloat.f90`, `causal_sha256.f90`,
`causal_serial.f90`, and the helper name tables in `causal_events.f90`, `causal_frames.f90`
and `causal_classify.f90`. Where this file and the code disagree, the code is the
implementation and this file is wrong; please report it.

The format has four layers:

1. **LRD-REC-v1**: a canonical key/value record (generic; defined in `research/CONTRACTS.md`
   and implemented in `causal_lrdrec.f90`).
2. **LRD-COMMIT-v1**: a SHA-256 commitment over the serialized record.
3. **Hex-float**: the canonical text form of every real number (`causal_hexfloat.f90`).
4. **LRD-CAUSAL-GRAPH-v1**: the key schema that puts one causal graph into one record
   (`causal_serial.f90`).

The Curry reader (`curry/causal/CausalGraph.curry`) and the Self reader
(`self/causal/causalGraph.self`) read the same bytes. Their headers say they parse the record
strictly. `tests/causal/run.sh` runs both against the Fortran-written SYNTHETIC fixture
(26 Curry checks, 25 Self checks) when the toolchains are present.

## 1. LRD-REC-v1 framing

```
record  = "LRD-REC-v1" LF  field*
field   = klen ":" key  vlen ":" value  LF
klen    = decimal byte length of key        (no sign, no leading zeros; "0" alone is the zero length)
vlen    = decimal byte length of value      (same rules)
```

* Fields appear in **bytewise-ascending key order** (comparison by byte value, a shorter key
  that is a prefix of a longer key sorts first). Insertion order is ignored by the writer.
* Keys are **unique** and **non-empty**, and consist only of the bytes `a-z`, `0-9`, `.`, `_`.
  This is stricter than the contract (the code comment says "stricter than the contract, never
  looser").
* Values may be empty, and consist only of printable ASCII, bytes `0x20` to `0x7E`. So a value
  never contains LF, and byte length equals character count (needed by the Curry and Self
  readers).
* There is no separator or terminator other than the LF after each field. A record with no
  fields is the header line alone.
* A length is at most 9 decimal digits.

`rec_parse` rejects the following (error text in parentheses): input shorter than the header
line (`short`); wrong header (`bad_header`); a length that is non-numeric, empty, has a
leading zero, has more than 9 digits, or is not followed by `:` before the input ends
(`bad_key_length`, `bad_value_length`); key or value running past the end of input
(`truncated_key`, `truncated_value`); no LF after a value (`missing_newline`); a key outside
the allowed alphabet or empty (`bad_key:<key>`); a value byte outside `0x20..0x7E`
(`bad_value_bytes:<key>`); a key not strictly greater than the previous one
(`unsorted_or_duplicate:<key>`). Trailing bytes after the last field are parsed as another
field, so trailing junk ends in one of the errors above.

## 2. LRD-COMMIT-v1 commitment

```
commitment = lowercase hex ( SHA-256( "LRD-COMMIT-v1" 0x00 serialization ) )     (64 characters)
```

`serialization` is the full byte string of section 1, including the header line.
`graph_save(g, path, commit, ok)` writes two files:

* `<path>`: the record;
* `<path>.commit`: the 64-character commitment followed by one LF (65 bytes).

`graph_load` computes the commitment from the bytes it read and returns it; it does not read
`<path>.commit` and does not compare against it. A caller that wants verification must
compare the returned commitment with the sidecar itself.

SHA-256 is FIPS 180-4 over bytes (one byte per Fortran character), in `causal_sha256.f90`.

## 3. Hex-float (every real in the graph record)

binary64 values are written from the bit pattern, always with 13 lowercase hex digits:

| class | text | value |
|---|---|---|
| normal | `[-]0x1.hhhhhhhhhhhhhp(+\|-)E` | (1 + h/2^52) · 2^E, E in -1022..1023, no leading zeros in E |
| subnormal | `[-]0x0.hhhhhhhhhhhhhp-1022` | (h/2^52) · 2^-1022, h not zero |
| zero | `[-]0x0.0000000000000p+0` | signed zero is preserved |
| infinity | `inf`, `-inf` | |
| NaN | `nan` | one form only; payload and sign are not preserved |

`parse_hexfloat` accepts exactly this grammar and nothing else (for example `-nan`, an
upper-case digit, a missing sign on the exponent, a leading zero in the exponent, an
out-of-range exponent, or a subnormal with any exponent other than `-1022` are all rejected).
Hence format, then parse, then format is the identity on bit patterns, NaN payloads
excepted. The reason for the custom writer is in the source: gfortran 14 does not implement the
Fortran 2018 `EX` edit descriptor.

## 4. LRD-CAUSAL-GRAPH-v1 schema

Integers are written as plain decimal (`I0`: no `+`, no padding). On reading, an integer must
consist of digits and `-` only and must re-format to the identical text.
`NNNNNN` below is the 1-based **position** (index in insertion order, zero-padded to 6 digits)
and is not the event id.
`<iv>` means an interval written as two keys, `<iv>_hi` and `<iv>_lo`, each a hex-float.

### Header fields

| key | value |
|---|---|
| `format` | `LRD-CAUSAL-GRAPH-v1` |
| `name` | graph name (trailing blanks trimmed) |
| `fixture` | `SYNTHETIC` if the graph is flagged synthetic, otherwise `none` |
| `units` | the literal text `t=s;x=m;s2=m2;c=299792458m/s(exact);signature=-+++` |
| `opt.abs_tol_m2` | hex-float, absolute tolerance in m² |
| `opt.rel_tol` | hex-float, relative tolerance |
| `n_frames`, `n_transforms`, `n_events`, `n_edges`, `n_rejected` | integer counts of the groups below |

### Indexed groups

Frames, `NNNNNN` = 1..n_frames, prefix `frame.NNNNNN.`:

| suffix | value |
|---|---|
| `id` | integer frame id |
| `kind` | `inertial` or `cosmological_redshift` |
| `name` | frame name (trailing blanks trimmed) |

Transforms, `NNNNNN` = 1..n_transforms, prefix `transform.NNNNNN.`:

| suffix | value |
|---|---|
| `from`, `to` | integer frame ids |
| `type` | the literal `lorentz_boost_plus_offset` (written; the reader does not read it, see section 5) |
| `beta1`, `beta2`, `beta3` | hex-float: velocity of frame `to` relative to frame `from`, in units of c (`|beta| < 1`) |
| `offset0_m` .. `offset3_m` | hex-float, in metres, in frame `to`: (c·t0, x0, y0, z0). The transform is X_to = Λ(beta) X_from + offset with X = (c·t, x, y, z) (`causal_frames.f90`) |

Events, `NNNNNN` = 1..n_events, prefix `event.NNNNNN.`:

| suffix | value |
|---|---|
| `id` | integer event id (the writer reports failure if an id exceeds 999999) |
| `kind` | `emission`, `detection`, `ground_receipt`, `archive_publication` |
| `label` | text, at most 64 characters (trailing blanks trimmed on writing) |
| `frame` | integer frame id of the event's coordinates |
| `t_s` | `<iv>`: time in seconds |
| `x1_m`, `x2_m`, `x3_m` | `<iv>` each: position in metres |
| `has_redshift` | `1` or `0` |
| `redshift` | `<iv>`: written for every event (zero interval when there is none) |

Accepted edges, `NNNNNN` = 1..n_edges in acceptance order, prefix `edge.NNNNNN.`:

| suffix | value |
|---|---|
| `src`, `dst` | integer event ids |
| `sep` | classification of the pair: `timelike`, `lightlike`, `spacelike`, `indeterminate`, `invalid_frame` (the name table also has `invalid_input`) |
| `dir` | `future`, `past`, `indeterminate` (`na` for anything else) |
| `s2_m2` | `<iv>`: the interval s² in m², signature (-,+,+,+) |

Rejected proposals, `NNNNNN` = 1..n_rejected in log order, prefix `rejected.NNNNNN.`:

| suffix | value |
|---|---|
| `src`, `dst` | integers, as proposed |
| `reason` | one of `spacelike`, `indeterminate`, `past_directed`, `direction_indeterminate`, `invalid_frame`, `kind_order`, `self_edge`, `cycle`, `duplicate`, `unknown_event` (and `invalid_input` from the same name table) |

### Derived fields

| key | value |
|---|---|
| `pair.AAAAAA.BBBBBB` | for every ordered pair of distinct events: `<sep>/<dir>` as above. `AAAAAA` and `BBBBBB` are the two **event ids**, zero-padded to 6 digits. Computed with the graph's own tolerance options. |
| `topo` | event ids in the unique topological order, comma-separated, no spaces. Kahn's algorithm; among ready nodes the one with the smallest position (insertion index) is emitted first. |

For the SYNTHETIC fixture (11 events, 6 edges, 10 rejections) the topological order printed by
`topo` is `1,2,3,5,6,4,7,8,9,10,11`.

## 5. Reading and validating (`graph_parse`, `graph_load`)

`graph_parse` is stricter than "parse the record":

1. `rec_parse` succeeds (section 1).
2. `format` equals `LRD-CAUSAL-GRAPH-v1` (otherwise `bad_format`). Missing keys give `missing:<key>`.
3. Counts, frames, transforms, events, edges and rejections are read by index
   (`bad_int:`, `bad_hexfloat:`, `label_too_long:` on malformed input).
4. Frames go through `reg_add_frame`, transforms through `reg_add_boost`, events through
   `cg_add_event` (which refuses an id that is not positive, a duplicate id, and an event kind
   outside 1..4), so `frame_rejected:`, `transform_rejected:` and `event_rejected:` are possible.
   An unknown kind name becomes the invalid kind and is therefore refused.
5. **Every accepted edge is re-validated** by `cg_add_edge` (light cone, kind order, no cycle,
   no duplicate) with logging off. A file cannot add an edge the classifier would refuse
   (`edge_revalidation_failed:<key><code>`).
6. Rejected proposals are read back as logged: the reason must be a known code name other than
   `ok`, else `bad_reject_reason:`.
7. **Canonical check**: the loaded graph is serialized again and must equal the input
   byte-for-byte (`reserialize_failed`, `not_canonical`).

Consequences, from reading the code:

* `type`, `units`, the per-edge `sep`, `dir`, `s2_m2`, all `pair.*` keys and `topo` are
  **not read**; they are recomputed. A file whose derived fields disagree with the recomputed
  ones fails at step 7, as would any extra or missing key.
* Labels and names that carry trailing blanks do not survive: the writer trims them.
* `fixture` is read as `SYNTHETIC` or anything else, and anything other than `SYNTHETIC`
  loads as non-synthetic; step 7 then requires the key to be `none`.

## 6. Reference values

The SYNTHETIC fixture (`tests/causal/fixture_graph.f90`, written by `tests/causal/test_fixture.f90`
to `tests/causal/out/SYNTHETIC_causal_fixture.lrdrec`) is 15039 bytes in the run this document
was written from. Its commitment, printed by `test_fixture`, was
`1d8a8390637cf6b386d31beade096ce092be5f58b6acc0213d14c03e3c2be2e4`. These values are observed,
not specified; a change to the fixture changes them. The fixture contains no observational
data.

## 7. What this format does not say

* It records a caller's assertion of causation that passed a light-cone check; it is not
  evidence of physical causation. See the header of `causal_classify.f90`.
* It has no version negotiation: `format` must equal the one string above.
* Error strings in this file are the Fortran implementation's. Nothing here says the Curry or
  Self readers produce the same texts.
