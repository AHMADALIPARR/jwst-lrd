"Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
 Licensed under AGPL-3.0-only plus the SnapKitty Opaque License (dual license, intentional).
 See LICENSE and SNAPKITTY_OPAQUE_LICENSE.md at the repository root.

 simplicialComplex: read-only Self model of a geometry export written by the
 Fortran reference (fortran/topology/src/topo_export.f90).  The export is a
 concatenation of LRD-REC-v1 records: one geometry_header, one vertex_position
 per vertex, the committed simplex leaf records, and the complex_root record.
 This object never recomputes homology; it exposes the committed incidence
 (faces / cofaces), the committed Betti vector and the commitment root, and it
 cross-checks incidence symmetry and the Euler characteristic.  Headless."

lobby _AddSlots: (|
  simplicialComplex = (|
    parent* = traits clonable.
    path <- ''.
    header <- nil.
    rootRecord <- nil.
    positions <- nil.
    simplices <- nil.
    pointByLabel <- nil.

    recordHeader = ( 'LRD-REC-v1\n' ).

    readLengthIn: s At: p Into: blk IfFail: fb = ( | n <- 0. q |
      q: p.
      [(s at: q) = ':'] whileFalse: [
        (s at: q) isDigit ifFalse: [ ^ fb value: 'LRD-REC-v1: bad length at ', q printString ].
        n: (n * 10) + ((s at: q) asByte - '0' asByte).
        q: q + 1 ].
      blk value: n With: q + 1 ).

    parseRecords: s = ( parseRecords: s IfFail: [|:m| error: m ] ).

    "fb receives a message string; CONTRACTS v1.1: empty keys are rejected"
    parseRecords: s IfFail: fb = ( | pos <- 0. recs. hdr. |
      hdr: recordHeader.
      recs: list copyRemoveAll.
      [pos < s size] whileTrue: [ | rec |
        ((s copyFrom: pos UpTo: pos + hdr size) = hdr)
          ifFalse: [ ^ fb value: 'LRD-REC-v1: bad header at ', pos printString ].
        pos: pos + hdr size.
        rec: dictionary copyRemoveAll.
        [(pos < s size) && [(s at: pos) isDigit]] whileTrue: [ | k. v |
          readLengthIn: s At: pos Into: [|:n. :q| k: s copyFrom: q UpTo: q + n. pos: q + n ] IfFail: [|:m| ^ fb value: m ].
          k isEmpty ifTrue: [ ^ fb value: 'LRD-REC-v1: empty key rejected (CONTRACTS v1.1) at ', pos printString ].
          readLengthIn: s At: pos Into: [|:n. :q| v: s copyFrom: q UpTo: q + n. pos: q + n ] IfFail: [|:m| ^ fb value: m ].
          ((s at: pos) = '\n') ifFalse: [ ^ fb value: 'LRD-REC-v1: missing newline at ', pos printString ].
          pos: pos + 1.
          rec at: k Put: v ].
        recs add: rec ].
      recs ).

    intFrom: t = (
      ((t at: 0) = '-')
        ifTrue: [ 0 - (t copyFrom: 1 UpTo: t size) asInteger ]
         False: [ t asInteger ] ).

    intList: s = ( | r |
      r: list copyRemoveAll.
      s isEmpty ifTrue: [ ^ r asVector ].
      (s splitOn: ',') do: [|:t| r add: (intFrom: t asString) ].
      r asVector ).

    copyFromFile: p = ( | c. recs. sl. pl |
      c: clone.
      c path: p.
      recs: c parseRecords: p asFileContents.
      sl: list copyRemoveAll.
      pl: list copyRemoveAll.
      recs do: [|:r. k|
        k: r at: 'kind'.
        k = 'geometry_header' ifTrue: [ c header: r ].
        k = 'vertex_position' ifTrue: [ pl add: r ].
        k = 'simplex' ifTrue: [ sl add: r ].
        k = 'complex_root' ifTrue: [ c rootRecord: r ] ].
      c simplices: sl asVector.
      c positions: pl asVector.
      c pointByLabel: dictionary copyRemoveAll.
      c positions do: [|:r|
        c pointByLabel at: (r at: 'label') asInteger
                     Put: ((r at: 'px') asInteger @ (r at: 'py') asInteger) ].
      c ).

    "--- queries ---"
    name = ( header at: 'name' ).
    root = ( header at: 'root' ).
    field = ( rootRecord at: 'field' ).
    size = ( simplices size ).
    simplexAt: i = ( simplices at: i ).
    dimOf: i = ( ((simplexAt: i) at: 'dim') asInteger ).
    idOf: i = ( (simplexAt: i) at: 'id' ).
    orientationOf: i = ( intFrom: ((simplexAt: i) at: 'orientation') ).
    vertices: i = ( intList: ((simplexAt: i) at: 'vertices') ).
    faces: i = ( intList: ((simplexAt: i) at: 'faces') ).
    faceSigns: i = ( intList: ((simplexAt: i) at: 'face_signs') ).
    cofaces: i = ( intList: ((simplexAt: i) at: 'cofaces') ).
    indexOfId: s = (
      0 upTo: size Do: [|:i| ((idOf: i) = s) ifTrue: [ ^ i ] ].
      -1 ).
    facesOfId: s = ( (faces: (indexOfId: s)) asList mapBy: [|:i| idOf: i ] ).
    cofacesOfId: s = ( (cofaces: (indexOfId: s)) asList mapBy: [|:i| idOf: i ] ).
    idsString: l = ( | s <- '' | l do: [|:x| s isEmpty ifTrue: [ s: x ] False: [ s: s, ' ', x ] ]. s ).
    facesOfIdString: s = ( idsString: (facesOfId: s) ).
    cofacesOfIdString: s = ( idsString: (cofacesOfId: s) ).
    betti = ( intList: (rootRecord at: 'betti') ).
    bettiAt: k = ( (k < betti size) ifTrue: [ betti at: k ] False: [ 0 ] ).
    indicesOfDim: k = ( | r |
      r: list copyRemoveAll.
      0 upTo: size Do: [|:i| ((dimOf: i) = k) ifTrue: [ r add: i ] ].
      r ).
    countDim: k = ( (indicesOfDim: k) size ).
    maxDim = ( | m <- -1 | 0 upTo: size Do: [|:i| m: m max: (dimOf: i) ]. m ).
    eulerCharacteristic = ( | chi <- 0 |
      0 upTo: maxDim + 1 Do: [|:k|
        (k % 2) = 0 ifTrue: [ chi: chi + (countDim: k) ] False: [ chi: chi - (countDim: k) ] ].
      chi ).
    alternatingBettiSum = ( | s <- 0 |
      0 upTo: betti size Do: [|:k|
        (k % 2) = 0 ifTrue: [ s: s + (betti at: k) ] False: [ s: s - (betti at: k) ] ].
      s ).
    pointOfLabel: l = ( pointByLabel at: l ).

    "Every face lists the simplex as a coface and vice versa; a k-simplex (k>0)
     has k+1 faces with coefficients in {-1,+1}; indices are in range."
    incidenceIsConsistent = (
      0 upTo: size Do: [|:i. fs|
        fs: faces: i.
        ((dimOf: i) = 0)
          ifTrue: [ fs isEmpty ifFalse: [ ^ false ] ]
           False: [ (fs size = ((dimOf: i) + 1)) ifFalse: [ ^ false ].
                    (faceSigns: i) do: [|:g| ((g = 1) || [g = -1]) ifFalse: [ ^ false ] ] ].
        fs do: [|:f|
          ((f < 0) || [f >= size]) ifTrue: [ ^ false ].
          ((dimOf: f) = ((dimOf: i) - 1)) ifFalse: [ ^ false ].
          ((cofaces: f) includes: i) ifFalse: [ ^ false ] ].
        (cofaces: i) do: [|:g|
          ((g < 0) || [g >= size]) ifTrue: [ ^ false ].
          ((faces: g) includes: i) ifFalse: [ ^ false ] ] ].
      true ).

    headerMatchesRoot = (
      ((header at: 'merkle_root') = (rootRecord at: 'merkle_root'))
        && [ (header at: 'betti') = (rootRecord at: 'betti') ] ).

    listString: v = ( | s <- '' |
      v do: [|:x| s isEmpty ifTrue: [ s: x printString ] False: [ s: s, ',', x printString ] ].
      '(', s, ')' ).

    countsString = ( | v |
      v: list copyRemoveAll.
      0 upTo: maxDim + 1 Do: [|:k| v add: (countDim: k) ].
      listString: v ).

    summary = (
      'SELF ', name,
      ' field=', field,
      ' counts=', countsString,
      ' betti=', (listString: betti),
      ' chi=', eulerCharacteristic printString,
      ' altsum=', alternatingBettiSum printString,
      ' incidence_ok=', incidenceIsConsistent printString,
      ' header_ok=', headerMatchesRoot printString,
      ' root=', root ).
  |).
|).
