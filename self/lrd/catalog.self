"Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
 SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque

 JWST-LRD Self observatory: discovery of LRD-* files produced by other
 tracks.  Roots are the git worktrees /workspace/jwst-lrd and
 /workspace/jwst-lrd-* (override with LRD_ROOTS, space separated).  A file
 is catalogued when it is an LRD-ARR-v1 header (a line format=LRD-ARR-v1,
 file name *.hdr) or begins with the bytes 'LRD-REC-v1\\n'.  The shell is
 used only to list candidate paths; every byte shown is read by Self.
 tests/self (this track's own synthetic test fixtures) is never catalogued."

lobby _AddSlots: (| lrdEntry = (|
  parent* = traits clonable.
  path <- ''. root <- ''. format <- ''.
  rel = ( path copyFrom: root size + 1 UpTo: path size ).
  dir = ( lrdReader dirName: path ).
  base = ( lrdReader baseName: path ).
  stem = ( | b | b: base. (lrdReader string: b EndsWith: '.hdr') ifTrue: [b copyFrom: 0 UpTo: b size - 4] False: [b] ).
  arrBase = ( dir, '/', stem ).
  rootName = ( lrdReader baseName: root ).
  isSynthetic = ( path includesSubstring: 'SYNTHETIC' ).
  under: frag = ( ('/', rel) includesSubstring: frag ).
|) |).

lobby _AddSlots: (| lrdCatalog = (|
  parent* = traits oddball.
  roots <- nil. entries <- nil. scanCount <- 0. lastScanTime <- ''. lastError <- ''.

  rootsCommand = 'if [ -n "$LRD_ROOTS" ]; then for d in $LRD_ROOTS; do echo "$d"; done; else for d in /workspace/jwst-lrd /workspace/jwst-lrd-*; do [ -e "$d/.git" ] && echo "$d"; done; fi; true'.

  lines: s = ( | out |
    out: list copyRemoveAll.
    (lrdReader splitLines: s) do: [|:l| l isEmpty ifFalse: [out addLast: l]].
    out).
  "outputOfCommand: redirects only the last command, so group the whole line"
  run: cmd = ( os outputOfCommand: '{ ', cmd, '; echo; }' IfFail: [|:e| lastError: e printString. ''] ).

  scan = ( | rs. cmd. found |
    rs: lines: (run: rootsCommand).
    roots: rs.
    entries: list copyRemoveAll.
    rs isEmpty ifTrue: [^ self].
    cmd: 'find'.
    rs do: [|:r| cmd: cmd, ' ', r].
    cmd: cmd, ' \\( -name .git -o -path \'*/tests/self\' -o -path \'*/tests/ui-self\' -o -path \'*/self/placeholders\' -o -name _build -o -name target -o -name node_modules \\) -prune -o -type f -size -8192k -print 2>/dev/null | xargs -r grep -I -l -s -m1 -x -e format=LRD-ARR-v1 -e LRD-REC-v1 2>/dev/null | sort'.
    found: lines: (run: cmd).
    found do: [|:p. e. r. head|
      r: ''.
      rs do: [|:x| (lrdReader string: p StartsWith: x, '/') ifTrue: [r: x]].
      e: lrdEntry clone. e path: p. e root: r.
      (lrdReader string: p EndsWith: '.hdr') ifTrue: [e format: 'LRD-ARR-v1'. entries addLast: e] False: [
        head: lrdReader readHead: p Max: 64.
        (lrdReader isRecText: head) ifTrue: [e format: 'LRD-REC-v1'. entries addLast: e]]].
    scanCount: scanCount + 1.
    lastScanTime: (run: 'date \'+%Y-%m-%d %H:%M:%S %Z\'') shrinkwrapped.
    self).

  entriesUnder: frags = ( | out |
    "frags: list of path fragments such as '/air/'"
    out: list copyRemoveAll.
    entries isNil ifTrue: [^ out].
    entries do: [|:e| (frags anySatisfy: [|:f| e under: f]) ifTrue: [out addLast: e]].
    out).
  firstFileNamed: rel = (
    "first existing <root>/<rel> over all roots, or nil"
    roots isNil ifTrue: [^ nil].
    roots do: [|:r| (lrdReader fileExists: r, '/', rel) ifTrue: [^ r, '/', rel]].
    nil).
  filesMatching: glob = ( | cmd |
    "existing paths <root>/<glob> over all roots (shell glob, listing only)"
    roots isNil ifTrue: [^ list copyRemoveAll].
    cmd: 'ls -1d'.
    roots do: [|:r| cmd: cmd, ' ', r, '/', glob].
    lines: (run: cmd, ' 2>/dev/null')).
|) |).
