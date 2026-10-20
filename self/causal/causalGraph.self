"Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
 SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque

 JWST-LRD TASK 006: the causal graph exposed to the Self Morphic frontend.
 Loads ONE LRD-REC-v1 record (format LRD-CAUSAL-GRAPH-v1, written by the Fortran
 library, see fortran/causal/FORMAT.md) and offers queries mirroring the Fortran
 ones: kindOf:, successorsOf:, isCausallyBefore:To:, ancestorsOf:, descendantsOf:,
 topoOrder, closureSize, classificationOf:To:.  Causality comes ONLY from the
 accepted edges; timestamps are never consulted.  morphicView builds a Morphic
 column listing nodes and edges; openInWorld adds it to the running desktop.
 Values are printable ASCII (Fortran enforces it), so one character = one byte."

lobby _AddSlots: ( |
  causalRecParser = ( |
    parent* = traits clonable.
    src <- ''.
    pos <- 0.
    lastError <- ''.
    digits = '0123456789'.
    "Read <decimal>':' at pos; nil on error.  No leading zeros, non-empty."
    readLen = ( | start. n <- 0. c |
      start: pos.
      [ (pos < src size) && [ (src at: pos) != ':' ] ] whileTrue: [
        c: src at: pos.
        (digits includes: c) ifFalse: [ ^ nil ].
        n: (n * 10) + (c asByte - '0' asByte).
        pos: pos + 1 ].
      pos >= src size ifTrue: [ ^ nil ].
      pos = start ifTrue: [ ^ nil ].
      (((src at: start) = '0') && [ (pos - start) > 1 ]) ifTrue: [ ^ nil ].
      pos: pos + 1.
      n ).
    "Parse a whole record into a dictionary; nil (and lastError) on failure."
    parse: s = ( | hdr. rec. prev <- nil. |
      src: s.
      hdr: 'LRD-REC-v1\n'.
      s size < hdr size ifTrue: [ lastError: 'short'. ^ nil ].
      (s copyFrom: 0 UpTo: hdr size) = hdr ifFalse: [ lastError: 'bad_header'. ^ nil ].
      pos: hdr size.
      rec: dictionary copyRemoveAll.
      [ pos < s size ] whileTrue: [| nk. nv. key. val |
        nk: readLen.
        nk isNil ifTrue: [ lastError: 'bad_key_length'. ^ nil ].
        nk = 0 ifTrue: [ lastError: 'empty_key'. ^ nil ].
        (pos + nk) > s size ifTrue: [ lastError: 'truncated_key'. ^ nil ].
        key: s copyFrom: pos UpTo: pos + nk.
        pos: pos + nk.
        nv: readLen.
        nv isNil ifTrue: [ lastError: 'bad_value_length'. ^ nil ].
        (pos + nv) >= s size ifTrue: [ lastError: 'truncated_value'. ^ nil ].
        val: s copyFrom: pos UpTo: pos + nv.
        pos: pos + nv.
        (s at: pos) = '\n' ifFalse: [ lastError: 'missing_newline'. ^ nil ].
        pos: pos + 1.
        prev isNil ifFalse: [
          (prev < key) ifFalse: [ lastError: 'unsorted_or_duplicate:', key. ^ nil ] ].
        rec at: key Put: val.
        prev: key ].
      rec ).
  | ).

  causalEvent = ( |
    parent* = traits clonable.
    id <- 0.
    kind <- ''.
    label <- ''.
    frame <- 0.
    tLo <- ''.
    tHi <- ''.
    printString = ( 'event ', id printString, ' ', kind, ' frame ', frame printString, ' ', label ).
  | ).

  causalEdge = ( |
    parent* = traits clonable.
    src <- 0.
    dst <- 0.
    sep <- ''.
    printString = ( 'edge ', src printString, ' -> ', dst printString, ' (', sep, ')' ).
  | ).

  causalGraph = ( |
    parent* = traits clonable.
    name <- ''.
    fixture <- ''.
    events <- nil.
    edges <- nil.
    rejected <- nil.
    rec <- nil.
    lastError <- ''.

    new = ( | g |
      g: copy.
      g events: list copyRemoveAll.
      g edges: list copyRemoveAll.
      g rejected: list copyRemoveAll.
      g ).

    pad6: n = ( | s |
      s: n printString.
      [ s size < 6 ] whileTrue: [ s: '0', s ].
      s ).

    field: k = ( rec at: k IfAbsent: [ lastError: 'missing:', k. nil ] ).

    "Answer a new graph loaded from path, or nil (see lastError)."
    loadFrom: path = ( | s. p. r |
      s: path asFileContents.
      p: causalRecParser copy.
      r: p parse: s.
      r isNil ifTrue: [ lastError: p lastError. ^ nil ].
      fromRecord: r ).

    fromRecord: r = ( | g. ne. nd. nr |
      g: new.
      g rec: r.
      (r at: 'format' IfAbsent: '') = 'LRD-CAUSAL-GRAPH-v1' ifFalse: [ lastError: 'bad_format'. ^ nil ].
      g name: (r at: 'name').
      g fixture: (r at: 'fixture').
      ne: (r at: 'n_events') asInteger.
      nd: (r at: 'n_edges') asInteger.
      nr: (r at: 'n_rejected') asInteger.
      1 to: ne Do: [| :i. p. e |
        p: 'event.', (pad6: i), '.'.
        e: causalEvent copy.
        e id: (r at: p, 'id') asInteger.
        e kind: (r at: p, 'kind').
        e label: (r at: p, 'label').
        e frame: (r at: p, 'frame') asInteger.
        e tLo: (r at: p, 't_s_lo').
        e tHi: (r at: p, 't_s_hi').
        g events add: e ].
      1 to: nd Do: [| :i. p. e |
        p: 'edge.', (pad6: i), '.'.
        e: causalEdge copy.
        e src: (r at: p, 'src') asInteger.
        e dst: (r at: p, 'dst') asInteger.
        e sep: (r at: p, 'sep').
        g edges add: e ].
      1 to: nr Do: [| :i. p. e |
        p: 'rejected.', (pad6: i), '.'.
        e: causalEdge copy.
        e src: (r at: p, 'src') asInteger.
        e dst: (r at: p, 'dst') asInteger.
        e sep: (r at: p, 'reason').
        g rejected add: e ].
      g ).

    eventWithId: i = ( events do: [|:e| e id = i ifTrue: [ ^ e ] ]. nil ).
    kindOf: i = ( (eventWithId: i) kind ).

    successorsOf: i = ( | r |
      r: list copyRemoveAll.
      edges do: [|:e| e src = i ifTrue: [ r add: e dst ] ].
      r ).
    predecessorsOf: i = ( | r |
      r: list copyRemoveAll.
      edges do: [|:e| e dst = i ifTrue: [ r add: e src ] ].
      r ).

    "Reachable set (path length >= 1), forward or backward."
    reachFrom: i Forward: fwd = ( | seen. todo |
      seen: set copyRemoveAll.
      todo: list copyRemoveAll.
      todo add: i.
      [ todo isEmpty ] whileFalse: [| x. nexts |
        x: todo removeFirst.
        nexts: fwd ifTrue: [ successorsOf: x ] False: [ predecessorsOf: x ].
        nexts do: [|:y| (seen includes: y) ifFalse: [ seen add: y. todo add: y ] ] ].
      seen ).

    "Ids in event insertion order (the Fortran node order)."
    inEventOrder: s = ( | r |
      r: list copyRemoveAll.
      events do: [|:e| (s includes: e id) ifTrue: [ r add: e id ] ].
      r ).

    isCausallyBefore: a To: b = ( (reachFrom: a Forward: true) includes: b ).
    descendantsOf: i = ( inEventOrder: (reachFrom: i Forward: true) ).
    ancestorsOf: i = ( inEventOrder: (reachFrom: i Forward: false) ).

    closureSize = ( | n <- 0 |
      events do: [|:e| n: n + (reachFrom: e id Forward: true) size ].
      n ).

    "Kahn, smallest insertion index first (mirrors dg_toposort)."
    topoOrder = ( | done. r |
      done: set copyRemoveAll.
      r: list copyRemoveAll.
      1 to: events size Do: [| :k. pick <- nil |
        events do: [|:e|
          (pick isNil && [ (done includes: e id) not ]) ifTrue: [
            ((predecessorsOf: e id) allSatisfy: [|:p| done includes: p ])
              ifTrue: [ pick: e id ] ] ].
        pick isNil ifFalse: [ done add: pick. r add: pick ] ].
      r ).

    joinIds: l = ( | s <- '' |
      l do: [|:i| s isEmpty ifFalse: [ s: s, ',' ]. s: s, i printString ].
      s ).

    classificationOf: a To: b = ( rec at: 'pair.', (pad6: a), '.', (pad6: b) IfAbsent: 'unknown' ).

    "Morphic: a column of labels, one per node and per edge."
    morphicView = ( | col |
      col: columnMorph copy.
      col addMorph: (labelMorph copyLabel: 'causalGraph ', name, ' [', fixture, ']').
      events do: [|:e| col addMorph: (labelMorph copyLabel: e printString) ].
      edges do: [|:e| col addMorph: (labelMorph copyLabel: e printString) ].
      col ).

    openInWorld = ( | v |
      v: morphicView.
      desktop worlds first addMorph: v.
      v ).
  | ).
| ).
