"Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
 SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque

 JWST-LRD Self observatory (task 015, mission QSO1-DCBH-001 agent 10).
 Builds the Morphic panels from LRD-ARR-v1 / LRD-REC-v1 files found by
 lrdCatalog.  A panel whose producing track has not written files shows
 UNAVAILABLE and the paths it expects.  Mission views without real data show
 records from self/placeholders, labelled SYNTHETIC PLACEHOLDER on screen;
 placeholders are never catalogued and never mixed with real data."

lobby _AddSlots: (| lrdObs = (|
  parent* = traits clonable.
  sha <- ''. copies. primary. rec. commitFile <- ''. arrays. isCurrent <- false.
  dir = ( primary dir ).
  arr: n = ( arrays at: n IfAbsent: [| a | a: lrdReader readArr: dir, '/', n. arrays at: n Put: a. a] ).
  f: k = ( rec at: k IfAbsent: 'ABSENT' ).
|) |).

lobby _AddSlots: (| lrdObservatory = (|
  parent* = traits oddball.
  world <- nil. page <- 'obs'. panels <- nil. obsList <- nil. selObs <- 0. cursor <- 0.
  fieldPage <- 0. lineSel <- 0. state <- nil. signature <- ''. lastChange <- ''. changeLog <- nil.
  selfDir <- ''. loadedExt <- nil. poller <- nil. pollMs <- 60000.
  topoReady <- false. causalNote <- ''.

  "---------- data ----------"
  rootRank: e = ( | n | n: e rootName.
    n = 'jwst-lrd' ifTrue: [^ 0]. n = 'jwst-lrd-integration' ifTrue: [^ 1]. n = 'jwst-lrd-t001' ifTrue: [^ 2]. 3 ).
  better: a Than: b = ( | fa. fb |
    fa: lrdReader string: a rel StartsWith: 'fixtures/'. fb: lrdReader string: b rel StartsWith: 'fixtures/'.
    fa = fb ifFalse: [^ fa].
    (rootRank: a) < (rootRank: b) ).
  currentShas = ( | out |
    out: list copyRemoveAll.
    lrdCatalog roots do: [|:r. s| s: lrdReader readFile: r, '/fixtures/ingest/CURRENT' IfFail: nil.
      s isNil ifFalse: [out addLast: s shrinkwrapped]].
    out).
  buildObservations = ( | d. cur |
    d: dictionary copyRemoveAll.
    lrdCatalog entries do: [|:e. s. o|
      ((e base = 'manifest.rec') && [e under: '/ingest/']) && [e isSynthetic not] ifTrue: [
        s: lrdReader baseName: e dir.
        o: d at: s IfAbsent: [| n | n: lrdObs clone. n sha: s. n copies: list copyRemoveAll.
          n arrays: dictionary copyRemoveAll. d at: s Put: n. n].
        o copies addLast: e.
        (o primary isNil) || [better: e Than: o primary] ifTrue: [o primary: e]]].
    cur: currentShas.
    obsList: list copyRemoveAll.
    d do: [|:o| o rec: lrdReader readRec: o primary path.
      o commitFile: (lrdReader readFile: o dir, '/manifest.commit' IfFail: '') shrinkwrapped.
      o isCurrent: cur includes: o sha.
      obsList addLast: o].
    obsList: (obsList asVector copySortBy: (| element: a Precedes: b = ( (a f: 'mast.obs_id') < (b f: 'mast.obs_id') ) |)) asList.
    selObs >= obsList size ifTrue: [selObs: 0].
    "first time: select the CURRENT observation"
    signature = '' ifTrue: [ 0 upTo: obsList size Do: [|:i| (obsList at: i) isCurrent ifTrue: [selObs: i]]].
    "optional first-open selection by exact MAST obs_id: LRD_OBS (used for screenshots)"
    signature = '' ifTrue: [| w | w: os environmentAt: 'LRD_OBS' IfFail: ''.
      w isEmpty ifFalse: [ 0 upTo: obsList size Do: [|:i| ((obsList at: i) f: 'mast.obs_id') = w ifTrue: [selObs: i]]]].
    self).
  obs = ( obsList isEmpty ifTrue: nil False: [obsList at: selObs] ).
  referenceFor: sha = ( | best |
    lrdCatalog entries do: [|:e| ((e base = 'reference.rec') && [(lrdReader baseName: e dir) = sha]) && [e isSynthetic not] ifTrue: [
      (best isNil) || [better: e Than: best] ifTrue: [best: e]]].
    best).
  st: k = ( state isNil ifTrue: [state: dictionary copyRemoveAll]. state at: k IfAbsent: [| v | v: vector copySize: 2 FillingWith: 0. state at: k Put: v. v] ).

  refresh = ( | sig |
    lrdCatalog scan.
    buildObservations.
    sig: ''.
    lrdCatalog entries do: [|:e| sig: sig, e path, ';'].
    obsList do: [|:o| sig: sig, o commitFile].
    sig = signature ifFalse: [
      signature = '' ifFalse: [
        changeLog addFirst: lrdCatalog lastScanTime, ': catalog changed (', lrdCatalog entries size printString, ' files)'.
        lastChange: lrdCatalog lastScanTime].
      signature: sig].
    self).

  "---------- world ----------"
  open = ( | d |
    state: dictionary copyRemoveAll. changeLog: list copyRemoveAll. loadedExt: list copyRemoveAll.
    refresh.
    d: os environmentAt: 'DISPLAY' IfFail: ':0'.
    preferences desktop initialBounds: (0 @ 0) ## (1912 @ 1172).
    desktop open.
    world: desktop w.
    world safelyDo: [world removeAllMorphs].
    rebuild.
    startPolling.
    self).
  rebuild = ( world safelyDo: [buildPage]. self ).
  removePanels = ( panels isNil ifFalse: [panels do: [|:p| p delete]]. panels: list copyRemoveAll. self ).
  addPanel: k Title: t X: x Y: y W: w H: h = ( | p |
    p: lrdPanel copyKind: k Title: t W: w H: h.
    p observatory: self. p position: x @ y.
    panels addLast: p. world addMorph: p.
    fill: p.
    p).
  buildPage = (
    removePanels.
    addPanel: 'bar' Title: 'JWST-LRD Self observatory' X: 2 Y: 2 W: 1906 H: 30.
    page = 'obs' ifTrue: [
      addPanel: 'archive' Title: 'Archive observation browser' X: 2 Y: 36 W: 470 H: 470.
      addPanel: 'spectrum' Title: 'Spectrum (LRD-ARR-v1 wavelength / flux / flux_error)' X: 476 Y: 36 W: 960 H: 470.
      addPanel: 'fit' Title: 'Redshift and fit inspection' X: 1440 Y: 36 W: 468 H: 470.
      addPanel: 'curry' Title: 'Curry evidence graph' X: 2 Y: 510 W: 474 H: 328.
      addPanel: 'agda' Title: 'Agda proof status' X: 480 Y: 510 W: 474 H: 328.
      addPanel: 'rsa' Title: 'RSA accumulator status' X: 958 Y: 510 W: 474 H: 328.
      addPanel: 'causal' Title: 'Causal poset' X: 1436 Y: 510 W: 472 H: 328.
      addPanel: 'topology' Title: 'Simplicial viewer' X: 2 Y: 842 W: 474 H: 328.
      addPanel: 'hamiltonian' Title: 'Hamiltonian energy' X: 480 Y: 842 W: 474 H: 328.
      addPanel: 'air' Title: 'AIR trace inspector' X: 958 Y: 842 W: 474 H: 328.
      addPanel: 'monitor' Title: 'Archive-update monitoring' X: 1436 Y: 842 W: 472 H: 328].
    page = 'mission' ifTrue: [
      addPanel: 'growth' Title: 'QSO1-DCBH-001: growth histories, seed mass vs z_form' X: 2 Y: 36 W: 952 H: 566.
      addPanel: 'dynmass' Title: 'QSO1-DCBH-001: dynamical-mass fits' X: 958 Y: 36 W: 950 H: 566.
      addPanel: 'provenance' Title: 'QSO1-DCBH-001: causal provenance chain (raw FITS -> transforms -> result)' X: 2 Y: 606 W: 952 H: 564.
      addPanel: 'obligations' Title: 'QSO1-DCBH-001: proof status per obligation' X: 958 Y: 606 W: 950 H: 564].
    self).
  refill: k = ( panels do: [|:p| p kind = k ifTrue: [world safelyDo: [fill: p]]]. self ).
  refillAll = ( panels do: [|:p| world safelyDo: [fill: p]]. self ).

  startPolling = (
    poller isNil ifFalse: [^ self].
    poller: (message copy receiver: self Selector: 'pollLoop') fork.
    poller resume.
    self).
  pollLoop = (
    [true] whileTrue: [
      times delay: pollMs.
      world isNil ifFalse: [world safelyDo: [refresh. refillAll]]].
    self).

  "---------- actions ----------"
  panel: p Action: a = ( | s |
    s: st: p kind.
    a = 'pageObs' ifTrue: [page: 'obs'. ^ rebuild].
    a = 'pageMission' ifTrue: [page: 'mission'. ^ rebuild].
    a = 'rescan' ifTrue: [refresh. ^ refillAll].
    a = 'obsNext' ifTrue: [obsList isEmpty ifFalse: [selObs: (selObs + 1) % obsList size. cursor: 0. fieldPage: 0. lineSel: 0]. ^ refillAll].
    a = 'obsPrev' ifTrue: [obsList isEmpty ifFalse: [selObs: ((selObs + obsList size) - 1) % obsList size. cursor: 0. fieldPage: 0. lineSel: 0]. ^ refillAll].
    a = 'fieldsNext' ifTrue: [fieldPage: fieldPage + 1. ^ refill: 'archive'].
    a = 'fieldsPrev' ifTrue: [fieldPage: (fieldPage - 1) max: 0. ^ refill: 'archive'].
    a = 'c+1' ifTrue: [cursor: cursor + 1. ^ refill: 'spectrum'].
    a = 'c-1' ifTrue: [cursor: (cursor - 1) max: 0. ^ refill: 'spectrum'].
    a = 'c+10' ifTrue: [cursor: cursor + 10. ^ refill: 'spectrum'].
    a = 'c-10' ifTrue: [cursor: (cursor - 10) max: 0. ^ refill: 'spectrum'].
    a = 'lineNext' ifTrue: [lineSel: lineSel + 1. ^ refill: 'fit'].
    a = 'linePrev' ifTrue: [lineSel: (lineSel - 1) max: 0. ^ refill: 'fit'].
    a = 'fileNext' ifTrue: [s at: 0 Put: (s at: 0) + 1. s at: 1 Put: 0. ^ refill: p kind].
    a = 'filePrev' ifTrue: [s at: 0 Put: ((s at: 0) - 1) max: 0. s at: 1 Put: 0. ^ refill: p kind].
    a = 'recNext' ifTrue: [s at: 1 Put: (s at: 1) + 1. ^ refill: p kind].
    self).
  panel: p PickX: x = ( | o. w. best. bd |
    p kind = 'spectrum' ifFalse: [^ self].
    o: obs. o isNil ifTrue: [^ self].
    w: o arr: 'wavelength'.
    w ok ifFalse: [^ self].
    0 upTo: w values size Do: [|:i. f. d| f: (w values at: i) scaledFloat: 0.
      f isNil ifFalse: [d: (f - x) absoluteValue. (bd isNil) || [d < bd] ifTrue: [bd: d. best: i]]].
    best isNil ifFalse: [cursor: best].
    refill: 'spectrum').

  "---------- panel builders ----------"
  "split on |, answers a vector"
  bar: s = ( | out. start |
    out: list copyRemoveAll. start: 0.
    0 upTo: s size Do: [|:i| (s byteAt: i) = 124 ifTrue: [out addLast: (s copyFrom: start UpTo: i). start: i + 1]].
    out addLast: (s copyFrom: start UpTo: s size).
    out asVector).
  text: p X: x Y: y W: w H: h = ( p place: (lrdTextMorph copyW: w H: h) At: x @ y ).
  buttons: specs In: p Y: y = ( | x <- 6 |
    "specs: vector of label/action pairs"
    0 upTo: specs size / 2 Do: [|:i. b|
      b: lrdUI button: (specs at: 2 * i) Target: p Action: (specs at: (2 * i) + 1).
      p place: b At: x @ y.
      x: x + 20 + (((specs at: 2 * i) size * 8) max: (b baseBounds width max: 40))].
    self).
  fill: p = ( | k |
    p removeAllMorphs.
    k: p kind.
    k = 'bar' ifTrue: [^ fillBar: p].
    k = 'archive' ifTrue: [^ fillArchive: p].
    k = 'spectrum' ifTrue: [^ fillSpectrum: p].
    k = 'fit' ifTrue: [^ fillFit: p].
    k = 'monitor' ifTrue: [^ fillMonitor: p].
    k = 'topology' ifTrue: [^ fillTopology: p].
    k = 'causal' ifTrue: [^ fillCausal: p].
    k = 'provenance' ifTrue: [^ fillProvenance: p].
    k = 'curry' ifTrue: [^ fillGeneric: p Frags: (bar: '/curry/') Expect:
      'curry/ (t012-curry): LRD-REC-v1 evidence records; graph rendering needs curry/GRAPH-FORMAT.md' Note: curryNote].
    k = 'agda' ifTrue: [^ fillGeneric: p Frags: (bar: '/agda/') Expect:
      'agda/ (t011-agda, t011-agda-kernel): LRD-REC-v1 proof-status records' Note: ''].
    k = 'rsa' ifTrue: [^ fillGeneric: p Frags: (bar: '/rsaacc/') Expect:
      'ledger/rsaacc/ (t005-rsaacc): LRD-REC-v1 accumulator state / witness records' Note: ''].
    k = 'hamiltonian' ifTrue: [^ fillGeneric: p Frags: (bar: '/hamiltonian/') Expect:
      'hamiltonian/ (t008-hamiltonian): LRD-ARR-v1 energy series or LRD-STATE-v1 hamiltonian_step records' Note: ''].
    k = 'air' ifTrue: [^ fillGeneric: p Frags: (bar: '/air/') Expect:
      'air/ (t009-air): LRD-REC-v1 public / proposal / decision records' Note: ''].
    k = 'growth' ifTrue: [^ fillMission: p Frags: (bar: '/growth/|/dcbh/') Expect:
      'growth/ or dcbh/ (t020-growth, t021-dcbh, t022-growth-hamiltonian)' Placeholder: 'SYNTHETIC_PLACEHOLDER_growth_map.lrdrec'].
    k = 'dynmass' ifTrue: [^ fillMission: p Frags: (bar: '/dynmass/') Expect:
      'dynmass/ (t018-dynmass): LRD-REC-v1 fit records, LRD-ARR-v1 rotation curves' Placeholder: 'SYNTHETIC_PLACEHOLDER_dynmass.lrdrec'].
    k = 'obligations' ifTrue: [^ fillMission: p Frags: (bar: '/obligations/') Expect:
      'agda obligations (t011-agda, t023-agda-growth): LRD-REC-v1 records with an obligation field' Placeholder: 'SYNTHETIC_PLACEHOLDER_obligations.lrdrec'].
    self).
  curryNote = ( | f |
    f: lrdCatalog firstFileNamed: 'curry/GRAPH-FORMAT.md'.
    f isNil ifTrue: ['graph view UNAVAILABLE: curry/GRAPH-FORMAT.md not present in any worktree'] False: ['graph format doc: ', f] ).

  fillBar: p = ( | t |
    buttons: (bar: 'Observatory|pageObs|Mission QSO1-DCBH-001|pageMission|Rescan now|rescan') In: p Y: 4.
    t: text: p X: 470 Y: 4 W: 1430 H: 22.
    t add: 'roots ', lrdCatalog roots size printString, '   LRD files ', lrdCatalog entries size printString,
      '   observations ', obsList size printString, '   scan #', lrdCatalog scanCount printString, ' at ', lrdCatalog lastScanTime,
      '   page: ', page, '   (all values are read from LRD-* files; nothing is computed for display except checks)' Color: lrdUI dimColor.
    self).

  short: s = ( s size > 12 ifTrue: [(s copyFrom: 0 UpTo: 12), '...'] False: [s] ).
  unavailable: t What: w Expect: e = (
    t addBold: 'UNAVAILABLE' Color: lrdUI badColor.
    t add: w Color: lrdUI badColor.
    t add: 'expected: ', e Color: lrdUI dimColor.
    self).
  commitLine: r File: cf On: t = ( | c |
    c: r commitment.
    t addMono: 'commit (Self SHA-256): ', c Color: (lrdUI ink: 'black').
    cf = '' ifTrue: [t add: 'no .commit file beside the record' Color: lrdUI warnColor] False: [
      cf = c ifTrue: [t add: 'MATCHES the producer .commit file' Color: lrdUI okColor]
              False: [t add: 'MISMATCH with .commit file: ', cf Color: lrdUI badColor]].
    self).

  fillArchive: p = ( | t. o. keys. per <- 14 |
    buttons: (bar: '< obs|obsPrev|obs >|obsNext|< fields|fieldsPrev|fields >|fieldsNext') In: p Y: 24.
    t: text: p X: 4 Y: 50 W: p baseBounds width - 8 H: p baseBounds height - 54.
    obsList isEmpty ifTrue: [^ unavailable: t What: 'no ingested observation (manifest.rec) found'
      Expect: '<worktree>/fixtures/ingest/<raw sha256>/manifest.rec (t001-ingest-fortran)'].
    0 upTo: obsList size Do: [|:i. x|
      x: obsList at: i.
      t add: (i = selObs ifTrue: ['> '] False: ['  ']), (x f: 'mast.obs_id'), '  ', (short: x sha),
        (x isCurrent ifTrue: ['  CURRENT'] False: ['']), '  copies ', x copies size printString
        Color: (i = selObs ifTrue: [lrdUI titleColor] False: [lrdUI ink: 'black'])].
    o: obs.
    t add: '' .
    t addBold: (o f: 'target.name'), '   (', (o f: 'mode'), ')' Color: (lrdUI ink: 'black').
    t add: 'MAST obsid ', (o f: 'mast.obsid'), '   file ', (o f: 'mast.product_filename').
    t add: (o f: 'fits.hdr.TELESCOP'), ' ', (o f: 'fits.hdr.INSTRUME'), ' ', (o f: 'fits.hdr.GRATING'), '/', (o f: 'fits.hdr.FILTER'),
      '  program ', (o f: 'fits.hdr.PROGRAM'), '  source ', (o f: 'fits.hdr.SRCNAME').
    t add: 'DATE-OBS ', (o f: 'fits.hdr.DATE-OBS'), ' ', (o f: 'fits.hdr.TIME-OBS'), '   CAL_VER ', (o f: 'fits.hdr.CAL_VER'), '  CRDS ', (o f: 'fits.hdr.CRDS_CTX').
    t add: 'SRCRA ', (o f: 'fits.hdr.SRCRA'), '  SRCDEC ', (o f: 'fits.hdr.SRCDEC').
    t add: 'retrieved ', (o f: 'mast.retrieved_utc'), '   raw size ', (o f: 'raw.size').
    t addMono: 'raw sha256 ', o sha Color: (lrdUI ink: 'black').
    t add: 'record: ', o primary rel, '  [', o primary rootName, ']' Color: lrdUI dimColor.
    t add: 'LRD-REC-v1 fields ', o rec keys size printString, '  valid ', o rec ok printString,
      '  canonical ', (lrdReader isCanonical: o rec) printString Color: ((lrdReader isCanonical: o rec) ifTrue: [lrdUI okColor] False: [lrdUI badColor]).
    commitLine: o rec File: o commitFile On: t.
    o copies size > 1 ifTrue: [| agree <- 0 |
      o copies do: [|:e. c| c: lrdReader readRec: e path. c commitment = o rec commitment ifTrue: [agree: agree + 1]].
      t add: 'copies with identical commitment: ', agree printString, ' / ', o copies size printString
        Color: (agree = o copies size ifTrue: [lrdUI okColor] False: [lrdUI badColor])].
    keys: o rec keys asVector.
    fieldPage: fieldPage min: ((keys size - 1) / per).
    t addBold: 'fields ', ((fieldPage * per) + 1) printString, '-', ((((fieldPage + 1) * per) min: keys size)) printString, ' of ', keys size printString Color: lrdUI titleColor.
    (fieldPage * per) upTo: (((fieldPage + 1) * per) min: keys size) Do: [|:i. k|
      k: keys at: i. t add: k, ' = ', (o rec at: k)].
    self).

  "power of ten used to scale a series for plotting: decimal exponent of its largest magnitude"
  scaleOf: a = ( | best. bm |
    a values do: [|:v| v isFinite && [v kind != 'zero'] ifTrue: [| e | e: v decimalExponent.
      (bm isNil) || [e > bm] ifTrue: [bm: e. best: v]]].
    bm isNil ifTrue: [0] False: [bm] ).
  floats: a Scale: p = ( | out | out: vector copySize: a values size.
    0 upTo: a values size Do: [|:i| out at: i Put: ((a values at: i) scaledFloat: p)]. out ).

  fillSpectrum: p = ( | t. o. w. fl. er. pl. sx. sy. xs. ys. lo. hi. n. i. ok |
    buttons: (bar: '<< 10|c-10|< 1|c-1|1 >|c+1|10 >>|c+10') In: p Y: 24.
    t: text: p X: 4 Y: 370 W: p baseBounds width - 8 H: 96.
    o: obs.
    o isNil ifTrue: [^ unavailable: t What: 'no observation selected' Expect: 'fixtures/ingest/<sha>/{wavelength,flux,flux_error}.{hdr,f64}'].
    w: o arr: 'wavelength'. fl: o arr: 'flux'. er: o arr: 'flux_error'.
    ok: true.
    (vector copyAddFirst: w) , ((vector copyAddFirst: fl) copyAddLast: er) do: [|:a|
      a ok ifFalse: [ok: false. t add: 'ERROR in ', a path, ': ', a errors first Color: lrdUI badColor]].
    ok ifFalse: [^ self].
    (w length = fl length) && [w length = er length] ifFalse: [^ t add: 'array lengths differ' Color: lrdUI badColor].
    n: w length.
    sx: 0. sy: scaleOf: fl.
    xs: floats: w Scale: sx. ys: floats: fl Scale: sy.
    lo: vector copySize: n. hi: vector copySize: n.
    0 upTo: n Do: [|:j. y. e| y: ys at: j. e: (er values at: j) scaledFloat: sy.
      (y isNil not) && [e isNil not] ifTrue: [lo at: j Put: y - e. hi at: j Put: y + e]].
    pl: lrdPlotMorph copyW: p baseBounds width - 8 H: 316.
    pl panel: p.
    pl addXs: xs Lo: lo Hi: hi Color: (lrdUI rgb: 0.75 G: 0.78 B: 0.85).
    pl addXs: xs Ys: ys Color: (lrdUI ink: 'blue') Style: 'line'.
    pl autoRange.
    pl ymin: pl ymin min: 0.0.
    pl hlines addLast: ((vector copyAddFirst: 0.0) copyAddLast: (lrdUI ink: 'gray')).
    cursor: cursor min: n - 1.
    i: cursor.
    pl cursorX: xs at: i.
    pl label: 'flux [', fl unit, '] / 1e', sy printString, '   (band: flux +/- flux_error)   click to inspect a sample' At: 'tl'.
    pl label: 'lambda ', ((w values at: 0) decimal: 4), ' ', w unit At: 'bl'.
    pl label: ((w values at: n - 1) decimal: 4), ' ', w unit At: 'br'.
    p place: pl At: 4 @ 50.
    t addBold: 'sample ', i printString, ' / ', n printString, '   ', (o f: 'mast.obs_id'), '   NaN flux values: ', fl nanCount printString, ' (not plotted)' Color: lrdUI titleColor.
    t addMono: 'wavelength = ', ((w values at: i) decimal: 7), ' ', w unit, '   exact ', (w values at: i) exactDecimal, '   bits ', (w values at: i) rawHex Color: (lrdUI ink: 'black').
    t addMono: 'flux       = ', ((fl values at: i) decimal: 7), ' ', fl unit, '   bits ', (fl values at: i) rawHex Color: (lrdUI ink: 'black').
    t addMono: 'flux_error = ', ((er values at: i) decimal: 7), ' ', er unit, '   bits ', (er values at: i) rawHex Color: (lrdUI ink: 'black').
    t add: 'arrays: ', w path, '.{hdr,f64} (+ flux, flux_error)   source_sha256 ', (short: fl sourceSha) Color: lrdUI dimColor.
    self).

  lineNames: r = ( | out |
    out: list copyRemoveAll.
    r keys do: [|:k| ((lrdReader string: k StartsWith: 'line.') && [lrdReader string: k EndsWith: '.status']) ifTrue: [
      out addLast: (k copyFrom: 5 UpTo: k size - 7)]].
    out asVector).
  fillFit: p = ( | t. o. ref. r. names. ln. g. dir. wa. fa. ma. pl. sy. xs. lo. hi. ctr |
    buttons: (bar: '< line|linePrev|line >|lineNext') In: p Y: 24.
    t: text: p X: 4 Y: 50 W: p baseBounds width - 8 H: 246.
    o: obs.
    o isNil ifTrue: [^ unavailable: t What: 'no observation selected' Expect: 'fixtures/reference/<sha>/reference.rec'].
    ref: referenceFor: o sha.
    ref isNil ifTrue: [^ unavailable: t What: 'no redshift/fit record for ', (o f: 'mast.obs_id')
      Expect: '<worktree>/fixtures/reference/', (short: o sha), '/reference.rec (Fortran reference kernel, t001)'].
    r: lrdReader readRec: ref path.
    r ok ifFalse: [^ t add: 'invalid record: ', r errors first Color: lrdUI badColor].
    t add: 'kernel: ', (r at: 'kernel' IfAbsent: 'ABSENT').
    t addBold: 'z (weighted mean) = ', (r at: 'z.weighted_mean' IfAbsent: 'ABSENT'), ' +/- ', (r at: 'z.weighted_mean_err' IfAbsent: 'ABSENT'),
      '   lines used ', (r at: 'z.n_lines_used' IfAbsent: '?') Color: lrdUI titleColor.
    t add: 'z_initial ', (r at: 'id.z_initial' IfAbsent: 'ABSENT'), '  score ', (r at: 'id.score' IfAbsent: '?'), '  valid px ', (r at: 'n_valid' IfAbsent: '?'), '/', (r at: 'n_rows' IfAbsent: '?').
    t add: 'cosmology (declared input): ', (r at: 'cosmology' IfAbsent: 'ABSENT') Color: lrdUI dimColor.
    t add: 'age at z ', (r at: 'cosmo.age_at_z_gyr' IfAbsent: '?'), ' Gyr   lookback ', (r at: 'cosmo.lookback_gyr' IfAbsent: '?'), ' Gyr'.
    (r at: 'source_sha256' IfAbsent: '') = o sha
      ifTrue: [t add: 'source_sha256 = selected raw FITS sha256' Color: lrdUI okColor]
      False: [t add: 'source_sha256 differs from selected observation' Color: lrdUI badColor].
    commitLine: r File: (lrdReader readFile: ref dir, '/reference.commit' IfFail: '') shrinkwrapped On: t.
    names: lineNames: r.
    names isEmpty ifTrue: [^ self].
    lineSel: lineSel % names size.
    ln: names at: lineSel.
    g: [|:k| r at: 'line.', ln, '.', k IfAbsent: '-'].
    t addBold: 'line ', (lineSel + 1) printString, '/', names size printString, ': ', ln, '  status ', (g value: 'status') Color: lrdUI titleColor.
    t add: 'z = ', (g value: 'z'), ' +/- ', (g value: 'z_err'), '   rest vac ', (g value: 'rest_vac_ang'), ' A'.
    t add: 'centroid ', (g value: 'centroid_obs_ang'), ' +/- ', (g value: 'centroid_err_ang'), ' A'.
    t add: 'flux ', (g value: 'flux_cgs'), ' +/- ', (g value: 'flux_err_cgs'), ' cgs   npix ', (g value: 'npix').
    g: [|:k| r at: 'model.', ln, '.', k IfAbsent: '-'].
    t add: 'model ', (g value: 'status'), '  z_gauss ', (g value: 'z_gauss'), '  FWHM ', (g value: 'fwhm_kms_uncorrected'), ' km/s (uncorr.)'.
    t add: 'delta_chi2 ', (g value: 'delta_chi2'), '  AIC line/cont ', (g value: 'AIC_line'), ' / ', (g value: 'AIC_cont').
    dir: ref dir.
    (lrdReader fileExists: dir, '/model_', ln, '.hdr') ifFalse: [
      ^ t add: 'no model array for ', ln, ' (', dir, '/model_', ln, '.hdr)' Color: lrdUI warnColor].
    wa: lrdReader readArr: dir, '/wavelength_ang'. fa: lrdReader readArr: dir, '/flam'. ma: lrdReader readArr: dir, '/model_', ln.
    (wa ok && [fa ok]) && [ma ok] ifFalse: [^ t add: 'reference arrays unreadable' Color: lrdUI badColor].
    sy: scaleOf: ma.
    xs: floats: wa Scale: 3.
    pl: lrdPlotMorph copyW: p baseBounds width - 8 H: 166.
    "window: samples where the model is finite, widened by 8 pixels"
    lo: nil. hi: nil.
    0 upTo: ma length Do: [|:j| (ma values at: j) isFinite ifTrue: [lo isNil ifTrue: [lo: j]. hi: j]].
    lo isNil ifTrue: [^ t add: 'model array has no finite values' Color: lrdUI warnColor].
    lo: (lo - 8) max: 0. hi: (hi + 8) min: ma length - 1.
    pl addXs: xs Ys: (floats: fa Scale: sy) Color: (lrdUI ink: 'black') Style: 'line'.
    pl addXs: xs Ys: (floats: ma Scale: sy) Color: (lrdUI ink: 'red') Style: 'line'.
    pl autoRangeFrom: lo To: hi.
    ctr: 0.
    pl label: ln, ': flam (black), model (red) / 1e', sy printString At: 'tl'.
    pl label: ((wa values at: lo) decimal: 5), ' A' At: 'bl'.
    pl label: ((wa values at: hi) decimal: 5), ' A' At: 'br'.
    p place: pl At: 4 @ 300.
    self).

  "---------- generic LRD file panels ----------"
  describe: e On: t Selected: sel State: s = ( | recs. r. per <- 9 |
    t add: (sel ifTrue: ['> '] False: ['  ']), (e isSynthetic ifTrue: ['[SYNTHETIC] '] False: ['']), e rel, '  [', e rootName, ']'
      Color: (e isSynthetic ifTrue: [lrdUI synthColor] False: [sel ifTrue: [lrdUI titleColor] False: [lrdUI ink: 'black']]).
    sel ifFalse: [^ self].
    e format = 'LRD-ARR-v1' ifTrue: [| a |
      a: lrdReader readArr: e arrBase.
      a ok ifFalse: [^ t add: '    ARR error: ', a errors first Color: lrdUI badColor].
      t add: '    LRD-ARR-v1 name=', a name, ' length=', a length printString, ' unit=', a unit, '  NaN=', a nanCount printString.
      a length > 0 ifTrue: [t addMono: '    [0] ', ((a values at: 0) decimal: 7), '  [', (a length - 1) printString, '] ', ((a values at: a length - 1) decimal: 7) Color: (lrdUI ink: 'black')].
      a hdrKeys do: [|:k| (k = 'synthetic') ifTrue: [t add: '    ', k, '=', (a hdr at: k) Color: lrdUI synthColor]].
      ^ self].
    recs: lrdReader readRecs: e path.
    recs isEmpty ifTrue: [^ t add: '    empty' Color: lrdUI warnColor].
    s at: 1 Put: (s at: 1) % recs size.
    r: recs at: s at: 1.
    t add: '    record ', ((s at: 1) + 1) printString, '/', recs size printString, '  valid ', r ok printString,
      '  canonical ', (lrdReader isCanonical: r) printString, '  LRD-STATE-v1: ', (lrdReader stateClass: r)
      Color: (r ok ifTrue: [lrdUI okColor] False: [lrdUI badColor]).
    r ok ifFalse: [^ t add: '    ', r errors first Color: lrdUI badColor].
    ((lrdReader stateClass: r) = 'other') ifFalse: [| pr |
      pr: lrdReader stateProblems: r.
      pr isEmpty ifTrue: [t add: '    state checks: well formed' Color: lrdUI okColor]
                 False: [t add: '    state checks: ', pr first, (pr size > 1 ifTrue: [' (+', (pr size - 1) printString, ')'] False: ['']) Color: lrdUI badColor]].
    t addMono: '    commit ', r commitment Color: (lrdUI ink: 'black').
    ((lrdReader stateClass: r) = 'decision') && [(r at: 'decision' IfAbsent: '') = 'ACCEPT'] ifTrue: [| pp |
      pp: e dir, '/proposal.rec'.
      (lrdReader fileExists: pp) ifTrue: [| nc |
        nc: lrdReader newCommitFor: (lrdReader readRec: pp).
        nc = (r at: 'new_commit' IfAbsent: '')
          ifTrue: [t add: '    new_commit = commitment of state built from proposal.rec (v1.1)' Color: lrdUI okColor]
          False: [t add: '    new_commit differs from state built from proposal.rec: ', (short: nc) Color: lrdUI badColor]]].
    r keys asVector do: [|:k. i| per > 0 ifTrue: [t add: '    ', k, ' = ', (r at: k). per: per - 1]].
    self).
  fillGeneric: p Frags: frags Expect: exp Note: note = ( | t. es. s |
    buttons: (bar: '< file|filePrev|file >|fileNext|record >|recNext') In: p Y: 24.
    t: text: p X: 4 Y: 50 W: p baseBounds width - 8 H: p baseBounds height - 54.
    note = '' ifFalse: [t add: note Color: lrdUI warnColor].
    es: lrdCatalog entriesUnder: frags.
    es isEmpty ifTrue: [^ unavailable: t What: 'no LRD-ARR-v1 / LRD-REC-v1 files from this track yet' Expect: exp].
    s: st: p kind.
    s at: 0 Put: (s at: 0) % es size.
    t add: es size printString, ' LRD files under ', (frags at: 0), '  (', exp, ')' Color: lrdUI dimColor.
    0 upTo: es size Do: [|:i| (i - (s at: 0)) absoluteValue < 4 ifTrue: [
      describe: (es at: i) On: t Selected: (i = (s at: 0)) State: s]].
    self).

  "---------- causal / topology: panels written by HCALC Alloy ----------"
  loadExternal: path = (
    loadedExt isNil ifTrue: [loadedExt: list copyRemoveAll].
    (loadedExt includes: path) ifTrue: [^ true].
    path runScriptIfFail: [|:e. :n| ^ false].
    loadedExt addLast: path.
    true).
  hasGlobal: n = ( (reflect: lobby) includesKey: n ).
  fillTopology: p = ( | t. srcs. dir. es. s. e. c. m |
    buttons: (bar: '< complex|filePrev|complex >|fileNext') In: p Y: 24.
    t: text: p X: 4 Y: 50 W: 168 H: p baseBounds height - 54.
    srcs: lrdCatalog filesMatching: 'self/topology/simplicialComplexMorph.self'.
    srcs isEmpty ifTrue: [^ unavailable: t What: 'Self panel not yet available' Expect: '<worktree>/self/topology/*.self (HCALC Alloy)'].
    dir: lrdReader dirName: srcs first.
    topoReady ifFalse: [
      topoReady: (loadExternal: dir, '/simplicialComplex.self') && [loadExternal: dir, '/simplicialComplexMorph.self']].
    topoReady && [(hasGlobal: 'simplicialComplexMorph') && [hasGlobal: 'simplicialComplex']] ifFalse: [
      ^ t add: 'not yet available: could not load ', dir Color: lrdUI badColor].
    es: list copyRemoveAll.
    (lrdCatalog entriesUnder: (bar: '/topology/')) do: [|:x| (lrdReader string: x base EndsWith: '.geom.lrdrec') ifTrue: [es addLast: x]].
    es isEmpty ifTrue: [^ unavailable: t What: 'no .geom.lrdrec exports' Expect: 'self/topology/geometry/*.geom.lrdrec'].
    s: st: p kind. s at: 0 Put: (s at: 0) % es size.
    e: es at: s at: 0.
    t add: 'panel code: ', dir Color: lrdUI dimColor.
    t add: (s at: 0) succ printString, '/', es size printString, ' complexes'.
    t add: e base Color: (e isSynthetic ifTrue: [lrdUI synthColor] False: [lrdUI ink: 'black']).
    e isSynthetic ifTrue: [t addBold: 'SYNTHETIC geometry' Color: lrdUI synthColor].
    t add: '[', e rootName, ']' Color: lrdUI dimColor.
    c: simplicialComplex copyFromFile: e path.
    m: simplicialComplexMorph copyOnComplex: c.
    m setWidth: p baseBounds width - 180 Height: p baseBounds height - 54.
    p place: m At: 176 @ 50.
    self).
  fillCausal: p = ( | t. srcs. es. s. e. g. v |
    buttons: (bar: '< graph|filePrev|graph >|fileNext') In: p Y: 24.
    t: text: p X: 4 Y: 50 W: 200 H: p baseBounds height - 54.
    srcs: lrdCatalog filesMatching: 'self/causal/causalGraph.self'.
    srcs isEmpty ifTrue: [t addBold: 'Self causal panel: not yet available' Color: lrdUI badColor.
                          t add: 'expected: <worktree>/self/causal/causalGraph.self (HCALC Alloy)' Color: lrdUI dimColor].
    es: list copyRemoveAll.
    (lrdCatalog entriesUnder: (bar: '/causal/')) do: [|:x| x format = 'LRD-REC-v1' ifTrue: [| r |
      r: lrdReader readRec: x path.
      (r at: 'format' IfAbsent: '') = 'LRD-CAUSAL-GRAPH-v1' ifTrue: [es addLast: x]]].
    es isEmpty ifTrue: [^ unavailable: t What: 'no LRD-CAUSAL-GRAPH-v1 records' Expect: 'causal outputs (t006-causal), format=LRD-CAUSAL-GRAPH-v1'].
    s: st: p kind. s at: 0 Put: (s at: 0) % es size.
    e: es at: s at: 0.
    t add: (s at: 0) succ printString, '/', es size printString, ' causal graph record(s)'.
    t add: e base Color: (e isSynthetic ifTrue: [lrdUI synthColor] False: [lrdUI ink: 'black']).
    e isSynthetic ifTrue: [t addBold: 'SYNTHETIC fixture' Color: lrdUI synthColor].
    t add: '[', e rootName, ']' Color: lrdUI dimColor.
    t addMono: 'commit ', (short: (lrdReader readRec: e path) commitment) Color: (lrdUI ink: 'black').
    srcs isEmpty ifTrue: [^ self].
    (loadExternal: srcs first) && [hasGlobal: 'causalGraph'] ifFalse: [^ t add: 'not yet available: cannot load ', srcs first Color: lrdUI badColor].
    t add: 'view: ', srcs first Color: lrdUI dimColor.
    g: causalGraph loadFrom: e path.
    g isNil ifTrue: [^ t add: 'causalGraph rejected the record' Color: lrdUI badColor].
    t add: 'topological order: ', (g joinIds: g topoOrder).
    t add: 'closure size: ', g closureSize printString.
    v: g morphicView.
    p place: v At: 210 @ 50.
    self).

  "---------- mission QSO1-DCBH-001 ----------"
  fileSha: path = ( | s | s: lrdReader readFile: path IfFail: nil. s isNil ifTrue: [nil] False: [lrdSha256 digestOfString: s] ).
  check: ok Label: l On: t = ( t add: (ok ifTrue: ['  OK   '] False: ['  FAIL ']), l Color: (ok ifTrue: [lrdUI okColor] False: [lrdUI badColor]). self ).
  fillProvenance: p = ( | t. o. r. ref. rr. raw |
    t: text: p X: 4 Y: 26 W: p baseBounds width - 8 H: p baseBounds height - 30.
    o: obs.
    o isNil ifTrue: [^ unavailable: t What: 'no ingested observation' Expect: 'fixtures/ingest/<sha>/manifest.rec'].
    r: o rec. raw: o sha.
    t addBold: '[1] RAW FITS  ', (o f: 'mast.product_filename'), '   (MAST obsid ', (o f: 'mast.obsid'), ', retrieved ', (o f: 'mast.retrieved_utc'), ')' Color: lrdUI titleColor.
    t addMono: '    raw.sha256 ', (o f: 'raw.sha256'), '   size ', (o f: 'raw.size') Color: (lrdUI ink: 'black').
    check: (o f: 'raw.sha256') = raw Label: 'manifest raw.sha256 equals the fixture directory name' On: t.
    t add: '    (raw FITS bytes are not an LRD file; their hash is checked by the ingest track, not re-hashed here)' Color: lrdUI dimColor.
    t add: '      |  extraction: ingest/lrd_fitsx (C, CFITSIO) -> LRD-ARR-v1' Color: lrdUI dimColor.
    t addBold: '[2] ARRAYS  ', o dir Color: lrdUI titleColor.
    (bar: 'wavelength|flux|flux_error') do: [|:a. h. f. arr|
      arr: o arr: a.
      f: fileSha: o dir, '/', a, '.f64'. h: fileSha: o dir, '/', a, '.hdr'.
      check: (f = (o f: 'arr.', a, '.sha256')) && [h = (o f: 'arr.', a, '.hdr_sha256')]
        Label: a, '.f64/.hdr SHA-256 (Self) = manifest arr.', a, '.sha256 / hdr_sha256   ', (short: f) On: t.
      check: arr sourceSha = raw Label: a, '.hdr source_sha256 = raw sha256' On: t].
    t add: '      |  provenance manifest: ingest/lrd_rec -> LRD-REC-v1' Color: lrdUI dimColor.
    t addBold: '[3] MANIFEST  ', o primary rel Color: lrdUI titleColor.
    check: (lrdReader isCanonical: r) Label: 'canonical LRD-REC-v1 (', r keys size printString, ' fields)' On: t.
    check: r commitment = o commitFile Label: 'LRD-COMMIT-v1 (Self) = manifest.commit  ', (short: r commitment) On: t.
    ref: referenceFor: raw.
    ref isNil ifTrue: [
      t add: '      |' Color: lrdUI dimColor.
      ^ unavailable: t What: '[4] no reference-kernel result for this observation' Expect: 'fixtures/reference/', (short: raw), '/reference.rec'].
    rr: lrdReader readRec: ref path.
    t add: '      |  transform: ', (rr at: 'kernel' IfAbsent: 'ABSENT'), ' -> LRD-REC-v1 + LRD-ARR-v1' Color: lrdUI dimColor.
    t addBold: '[4] REFERENCE FIT  ', ref rel, '  [', ref rootName, ']' Color: lrdUI titleColor.
    check: (rr at: 'source_sha256' IfAbsent: '') = raw Label: 'reference.rec source_sha256 = raw sha256' On: t.
    check: (rr at: 'source_filename' IfAbsent: '') = (o f: 'mast.product_filename') Label: 'source_filename = product filename' On: t.
    check: rr commitment = (lrdReader readFile: ref dir, '/reference.commit' IfFail: '') shrinkwrapped Label: 'LRD-COMMIT-v1 (Self) = reference.commit  ', (short: rr commitment) On: t.
    t add: '      |' Color: lrdUI dimColor.
    t addBold: '[5] RESULT  z = ', (rr at: 'z.weighted_mean' IfAbsent: 'ABSENT'), ' +/- ', (rr at: 'z.weighted_mean_err' IfAbsent: '?'),
      '  (', (rr at: 'z.n_lines_used' IfAbsent: '?'), ' lines; cosmology is a declared input)' Color: lrdUI okColor.
    t add: '      |' Color: lrdUI dimColor.
    t add: '[6] downstream (dynamical mass t018, growth t020-t022, ledger/AIR): ', (downstreamFor: raw) Color: lrdUI warnColor.
    self).
  downstreamFor: raw = ( | n <- 0 |
    lrdCatalog entries do: [|:e| (e format = 'LRD-REC-v1') && [(e base = 'manifest.rec') not] && [(e base = 'reference.rec') not] ifTrue: [
      (lrdReader readRecs: e path) do: [|:r| r ok && [r dict anySatisfy: [|:v| v = raw]] ifTrue: [n: n + 1]]]].
    n = 0 ifTrue: ['UNAVAILABLE - no other LRD record references this raw sha256 yet'] False: [n printString, ' record(s) reference this raw sha256'] ).

  placeholderRecs: name = ( lrdReader readRecs: selfDir, '/placeholders/', name ).
  fillMission: p Frags: frags Expect: exp Placeholder: ph = ( | es. t. recs |
    es: lrdCatalog entriesUnder: frags.
    es isEmpty ifFalse: [^ fillGeneric: p Frags: frags Expect: exp Note: 'real data from the owning track'].
    t: text: p X: 4 Y: 26 W: p baseBounds width - 8 H: 120.
    t addBold: 'SYNTHETIC PLACEHOLDER  -  NOT DATA' Color: lrdUI synthColor.
    t add: 'UNAVAILABLE: no LRD files yet from ', exp Color: lrdUI badColor.
    t add: 'showing ', selfDir, '/placeholders/', ph, ' (every record: synthetic=SYNTHETIC PLACEHOLDER)' Color: lrdUI synthColor.
    t add: 'this view switches to real records automatically when they appear under: ', (frags at: 0) Color: lrdUI dimColor.
    recs: placeholderRecs: ph.
    p kind = 'growth' ifTrue: [| g. n <- 0 |
      g: lrdGridMorph copyW: p baseBounds width - 8 H: p baseBounds height - 154.
      recs do: [|:r| (r at: 'kind' IfAbsent: '') = 'placeholder_cell' ifTrue: [n: n + 1.
        g cols: g cols max: ((r at: 'seed_index') asInteger + 1). g rows: g rows max: ((r at: 'zform_index') asInteger + 1)]].
      g title: 'SYNTHETIC PLACEHOLDER: feasible / excluded map (', n printString, ' cells, all PLACEHOLDER)'.
      g xLabel: 'seed mass axis (layout index only)'. g yLabel: 'z_form axis (layout index only)'.
      ^ p place: g At: 4 @ 150].
    t: text: p X: 4 Y: 150 W: p baseBounds width - 8 H: p baseBounds height - 154.
    t bg: lrdUI rgb: 0.97 G: 0.93 B: 0.98.
    recs do: [|:r| t addBold: 'SYNTHETIC PLACEHOLDER record' Color: lrdUI synthColor.
      r keys do: [|:k| t add: '   ', k, ' = ', (r at: k) Color: lrdUI synthColor]].
    self).

  "---------- monitor ----------"
  fillMonitor: p = ( | t |
    buttons: (bar: 'Rescan now|rescan') In: p Y: 24.
    t: text: p X: 4 Y: 50 W: p baseBounds width - 8 H: p baseBounds height - 54.
    t add: 'scan #', lrdCatalog scanCount printString, ' at ', lrdCatalog lastScanTime, '  (auto every ', (pollMs / 1000) printString, ' s)'.
    t add: lrdCatalog roots size printString, ' worktrees, ', lrdCatalog entries size printString, ' LRD files'.
    t add: 'last change: ', (lastChange = '' ifTrue: ['none since start'] False: [lastChange]).
    lrdCatalog roots do: [|:r. c| c: lrdReader readFile: r, '/fixtures/ingest/CURRENT' IfFail: nil.
      c isNil ifFalse: [t add: (lrdReader baseName: r), ' CURRENT ', (short: c shrinkwrapped)]].
    obsList do: [|:o| t add: (o f: 'mast.obs_id'), '  commit ', ((o rec commitment = o commitFile) ifTrue: ['verified'] False: ['MISMATCH'])
      Color: ((o rec commitment = o commitFile) ifTrue: [lrdUI okColor] False: [lrdUI badColor])].
    (lrdCatalog entriesUnder: (bar: '/ledger/')) do: [|:e| (lrdReader readRecs: e path) do: [|:r|
      t add: 'ledger ', e rel, ': ', (lrdReader stateClass: r), ' seq ', (r at: 'seq' IfAbsent: '-'),
        ((lrdReader stateProblems: r) isEmpty ifTrue: [' ok'] False: [' ', (lrdReader stateProblems: r) first])]].
    changeLog isNil ifFalse: [changeLog do: [|:c| t add: c Color: lrdUI warnColor]].
    self).
|) |).
