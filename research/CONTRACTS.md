# JWST-LRD shared contracts (v1)

Licensed AGPL-3.0 plus the SnapKitty Opaque License. Written by the orchestrator (Hilbert). Change it only through Hilbert.

## Process rules
- Every agent works in its own git worktree on its own branch:
  `git -C /workspace/jwst-lrd worktree add /workspace/jwst-lrd-<branch> -b <branch> main`
  Never switch branches in /workspace/jwst-lrd itself. Hilbert merges.
- Write only in the directories you own.
- Commit author: `Nova Parr <nova-parr@users.noreply.github.com>`. No push, no force, no CI.
- Never use Python, TypeScript, JavaScript, React, Next.js or Tailwind.
- Never invent numbers, PASS results or data. Synthetic fixtures carry `SYNTHETIC` in their name and header.
- Report missing toolchains or licensed software (MATLAB, SAS) as `UNAVAILABLE`, never as `PASS`.
- Each module keeps a `<module>/STATUS.md` covering what built, what ran (verbatim tail of the output), assumptions and blockers.
- HCALC Alloy is the reviewer. A track counts as done only after it signs off.

## Test convention
Each owned module provides an executable `tests/<module>/run.sh`. It builds what it needs and prints one line per test:
`PASS <name>` | `FAIL <name> <why>` | `UNAVAILABLE <name> <reason>`
It exits nonzero only if there is a FAIL. The top-level `make test` runs every `tests/*/run.sh` and aggregates the results.

## LRD-ARR-v1 (numeric arrays)
- Data file: `<name>.f64`, raw little-endian IEEE-754 binary64 values.
- Sidecar header: `<name>.hdr`, lines of the form `key=value`.
  - Required keys: `format=LRD-ARR-v1`, `name`, `length`, `unit`.
  - Optional key: `source_sha256` (the raw FITS product).

## LRD-REC-v1 (canonical records, used for ledger and commitments)
- A record is a sequence of fields `key=value`, with keys sorted bytewise ascending and no duplicates.
- Values are UTF-8 with no newline. Integers are base-10 with no leading zeros. Rationals are written `p/q` with q>0 and gcd(p,q)=1.
- Serialization:
  - First, `LRD-REC-v1\n`.
  - Then, for each field, `<len(key)>:<key><len(value)>:<value>\n`, where lengths are decimal byte counts.
- Commitment: SHA-256 over the bytes `"LRD-COMMIT-v1\0" || serialization`, written as lowercase hex.

## LRD-STATE-v1 (shared state-transition ABI)
State record fields:
- `seq` (natural number)
- `commit` (hex; the commitment of the previous state, or 64 zeros for genesis)
- `kind`
- `payload_sha256`

A transition proposal is an LRD-REC-v1 record with these fields:
- `kind` (one of `observation`, `ledger_append`, `hamiltonian_step`, `capability`, `air_proof`)
- `prev_commit`
- `seq` (must be prev seq + 1)
- `payload_sha256`
- kind-specific fields (each subsystem documents its own)

The decision is an LRD-REC-v1 record:
- `decision` is `ACCEPT` or `REJECT`
- `reason` is a token, e.g. `ok`, `stale_seq`, `bad_prev`, `energy_not_decreasing`, `infeasible`, `bad_proof`
- `new_commit` is set only on ACCEPT

Rejection never constructs a new state. The C header lives at `ledger/abi/lrd_state.h` and is owned by the ledger track. Other tracks include it and do not fork it.

Agda mirrors this ABI in `agda/Core/State.agda`. The proof obligations for each kind are listed in `agda/OBLIGATIONS.md`, which the Agda track owns and other tracks contribute entries to through Hilbert.
