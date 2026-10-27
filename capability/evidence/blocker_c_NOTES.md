<!-- SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque -->
# Blocker (c) — `persist_failed` tests: notes (completed implementation, not a verified integration; requires owner review)

Base: `origin/main` = db089a3 (capability/ layer is on main; `authority.rs` persist_failed sites re-verified there).
Counts (`nice -n 19 bash tests/capability/run.sh`, verbatim in `blocker_c_before_run.log` / `blocker_c_after_run.log`):
BEFORE 67 PASS / 0 FAIL / 0 UNAVAILABLE.  AFTER 77 PASS / 0 FAIL / 0 UNAVAILABLE / 1 OPEN (OPEN is not counted as PASS or FAIL).

## Sites (grep `"persist_failed"` in capability/src/authority.rs at db089a3): exactly 3, no fourth
L330 admin REVOKE (`result=persist_failed detail=`), L400 consume (`reject(&tag,"persist_failed")`), L443 accept. Line numbers unchanged vs BLOCKERS.md.
`ISSUE` (L318) also calls `persist()?` but propagates an `Err` (not the token) — not a `persist_failed` site.

## Fault injection (real I/O; production code untouched)
* consume + admin: directory at `authority.state.tmp` -> `open(tmp)` fails EISDIR (works as root; removable live, same process recovers).
* accept: authority started under `prlimit --fsize=<size+152>` with SIGXFSZ ignored; consume persist fits, accept persist fails EFBIG (short write, no rename).
* read-only-dir / chmod faults were NOT used (ineffective as root, and they fail every persist so cannot hit the accept site alone).

## OPEN / remaining (not fixed, production unchanged)
1. OPEN `persist_failed_consume_site_cap_usable_after_restart`: after a consume-site persist failure the cap is `consumed` in memory (replay) but still `issued` on
   disk, so after an authority restart the same cap is accepted once. Accepted at most once in total (asserted); in-memory vs disk disagree meanwhile. Printed as an OPEN line, not a failure.
2. NOT TESTED (cannot be injected from outside): fsync-of-directory failure AFTER a successful rename at the accept site leaves disk ahead of memory
   (rollback pops the in-memory state but the renamed file already holds it). A directory-fsync fault (dir mode 0300) fails the CONSUME persist first, so the
   accept-only variant needs a hook in production code, which was out of scope.
3. "Byte-identical" is asserted for the file after each failed persist and again after the fault is removed (before the recovery request); after recovery the file legitimately changes.
