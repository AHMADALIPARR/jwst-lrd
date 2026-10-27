"Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
 SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque

 JWST-LRD Self observatory: Morphic (ui2) widgets.
   lrdTextMorph  - lines of text drawn on the canvas
   lrdPlotMorph  - x/y plot of LRD-ARR-v1 series; click picks a sample
   lrdPanel      - a titled panel; buttons send lrdAction: to it
 Widgets display what the observatory hands them; they compute nothing."

lobby _AddSlots: (| lrdUI = (|
  parent* = traits oddball.
  fontCache <- nil. boldCache <- nil. monoCache <- nil.
  font = ( fontCache isNil ifTrue: [fontCache: fontSpec copyName: 'helvetica' Size: 12 Style: '']. fontCache ).
  bold = ( boldCache isNil ifTrue: [boldCache: fontSpec copyName: 'helvetica' Size: 12 Style: 'bold']. boldCache ).
  mono = ( monoCache isNil ifTrue: [monoCache: fontSpec copyName: 'courier' Size: 12 Style: '']. monoCache ).
  ink: n = ( paint named: n ).
  rgb: r G: g B: b = ( paint copyRed: r Green: g Blue: b ).
  panelColor = ( rgb: 0.94 G: 0.95 B: 0.97 ).
  titleColor = ( rgb: 0.16 G: 0.24 B: 0.42 ).
  okColor = ( rgb: 0.0 G: 0.45 B: 0.1 ).
  badColor = ( rgb: 0.75 G: 0.0 B: 0.0 ).
  warnColor = ( rgb: 0.7 G: 0.4 B: 0.0 ).
  synthColor = ( rgb: 0.55 G: 0.2 B: 0.6 ).
  dimColor = ( rgb: 0.35 G: 0.35 B: 0.35 ).
  button: lbl Target: t Action: a = ( | b |
    b: ui2Button copyColor: (rgb: 0.82 G: 0.86 B: 0.93) Target: t.
    b script: 'target lrdAction: \'', a, '\''.
    b label: lbl.
    b).
|) |).

lobby _AddSlots: (| lrdTextMorph = morph copy |).
lrdTextMorph _AddSlots: (|
  lines <- nil. lineH <- 14. bg <- nil. charW <- 7.
  copyW: w H: h = ( | m | m: copy. m lines: list copyRemoveAll. m setWidth: w Height: h.
    m bg: lrdUI ink: 'white'. m color: m bg. m ).
  clear = ( lines: list copyRemoveAll. changed. self ).
  add: s = ( add: s Color: (lrdUI ink: 'black') ).
  add: s Color: c = ( | v | v: vector copySize: 3. v at: 0 Put: s. v at: 1 Put: c. v at: 2 Put: lrdUI font.
    lines addLast: v. self ).
  addBold: s Color: c = ( | v | v: vector copySize: 3. v at: 0 Put: s. v at: 1 Put: c. v at: 2 Put: lrdUI bold.
    lines addLast: v. self ).
  addMono: s Color: c = ( | v | v: vector copySize: 3. v at: 0 Put: s. v at: 1 Put: c. v at: 2 Put: lrdUI mono.
    lines addLast: v. self ).
  baseDrawOn: cv = ( | o. y. maxC. b |
    b: baseBounds. o: b origin.
    cv fillRectangle: b Color: bg.
    maxC: (b width - 8) / charW.
    y: 12.
    lines do: [|:l. s|
      y < b height ifTrue: [
        s: l at: 0.
        s size > maxC ifTrue: [s: (s copyFrom: 0 UpTo: (maxC - 1) max: 1), '~'].
        cv text: s At: (o x + 4) @ (o y + y) FontSpec: (l at: 2) Color: (l at: 1)].
      y: y + lineH].
    self).
  leftMouseDown: evt = ( self ).
|).

lobby _AddSlots: (| lrdPlotMorph = morph copy |).
lrdPlotMorph _AddSlots: (|
  series <- nil. xmin <- 0.0. xmax <- 1.0. ymin <- 0.0. ymax <- 1.0.
  cursorX <- nil. panel <- nil. labels <- nil. margin <- 6. hlines <- nil.
  copyW: w H: h = ( | m | m: copy. m series: list copyRemoveAll. m labels: list copyRemoveAll.
    m hlines: list copyRemoveAll. m setWidth: w Height: h. m color: lrdUI ink: 'white'. m ).
  "xs, ys: vectors of floats or nil (nil = not plotted).  style: 'line' or 'bar'"
  addXs: xs Ys: ys Color: c Style: st = ( | v | v: vector copySize: 4.
    v at: 0 Put: xs. v at: 1 Put: ys. v at: 2 Put: c. v at: 3 Put: st. series addLast: v. self ).
  addXs: xs Lo: lo Hi: hi Color: c = ( | v | v: vector copySize: 5.
    v at: 0 Put: xs. v at: 1 Put: lo. v at: 2 Put: c. v at: 3 Put: 'band'. v at: 4 Put: hi. series addLast: v. self ).
  label: s At: corner = ( | v | v: vector copySize: 2. v at: 0 Put: s. v at: 1 Put: corner. labels addLast: v. self ).
  autoRange = ( autoRangeFrom: 0 To: nil ).
  autoRangeFrom: a To: b = ( | first <- true |
    series do: [|:s. xs. ys|
      xs: s at: 0. ys: s at: 1.
      a upTo: (b isNil ifTrue: [xs size] False: [b + 1]) Do: [|:i. x. y|
        x: xs at: i. y: ys at: i.
        (x isNil not) && [y isNil not] ifTrue: [
          first ifTrue: [xmin: x. xmax: x. ymin: y. ymax: y. first: false] False: [
            xmin: xmin min: x. xmax: xmax max: x. ymin: ymin min: y. ymax: ymax max: y]]]].
    xmax <= xmin ifTrue: [xmax: xmin + 1.0].
    ymax <= ymin ifTrue: [ymax: ymin + 1.0].
    self).
  px: x = ( | b | b: baseBounds.
    (b origin x + margin) + ((((x - xmin) / (xmax - xmin)) * ((b width - (2 * margin)) asFloat)) asInteger) ).
  py: y = ( | b. t | b: baseBounds.
    t: (y - ymin) / (ymax - ymin).
    t: (t max: -0.05) min: 1.05.
    (b corner y - margin) - ((t * ((b height - (2 * margin)) asFloat)) asInteger) ).
  inX: x = ( (x >= xmin) && [x <= xmax] ).
  baseDrawOn: cv = ( | b |
    b: baseBounds.
    cv fillRectangle: b Color: color.
    cv rectangle: b Width: 1 Color: (lrdUI ink: 'gray').
    hlines do: [|:h. yy| ((h at: 0) >= ymin) && [(h at: 0) <= ymax] ifTrue: [
      yy: py: (h at: 0).
      cv line: (b origin x + margin) @ yy To: (b corner x - margin) @ yy Color: (h at: 1)]].
    series do: [|:s. xs. ys. c. st. prev|
      xs: s at: 0. ys: s at: 1. c: s at: 2. st: s at: 3.
      0 upTo: xs size Do: [|:i. x. y. p|
        x: xs at: i. y: ys at: i.
        (x isNil) || [y isNil] || [(inX: x) not] ifTrue: [prev: nil] False: [
          st = 'band' ifTrue: [| hi |
            hi: (s at: 4) at: i.
            hi isNil ifFalse: [cv line: (px: x) @ (py: y) To: (px: x) @ (py: hi) Color: c]]
          False: [
            p: (px: x) @ (py: y).
            st = 'bar' ifTrue: [cv line: p To: (px: x) @ (py: 0.0) Color: c] False: [
              prev isNil ifFalse: [cv line: prev To: p Color: c]].
            prev: p]]]].
    cursorX isNil ifFalse: [ (inX: cursorX) ifTrue: [| xx |
      xx: px: cursorX.
      cv line: xx @ (b origin y + 2) To: xx @ (b corner y - 2) Color: (lrdUI ink: 'red')]].
    labels do: [|:l. s. k. pt|
      s: l at: 0. k: l at: 1.
      k = 'tl' ifTrue: [pt: (b origin x + 8) @ (b origin y + 16)].
      k = 'bl' ifTrue: [pt: (b origin x + 8) @ (b corner y - 8)].
      k = 'br' ifTrue: [pt: ((b corner x - 8) - (7 * s size)) @ (b corner y - 8)].
      k = 'tr' ifTrue: [pt: ((b corner x - 8) - (7 * s size)) @ (b origin y + 16)].
      cv text: s At: pt FontSpec: lrdUI font Color: (lrdUI ink: 'darkGray')].
    self).
  leftMouseDown: evt = ( | lx. b. f |
    b: baseBounds.
    lx: (evt cursorPoint x - globalPosition x) - margin.
    f: lx asFloat / ((b width - (2 * margin)) asFloat).
    f: (f max: 0.0) min: 1.0.
    panel isNil ifFalse: [panel pickX: xmin + (f * (xmax - xmin))].
    self).
|).

lobby _AddSlots: (| lrdPanel = morph copy |).
lrdPanel _AddSlots: (|
  kind <- ''. title <- ''. observatory <- nil.
  copyKind: k Title: t W: w H: h = ( | m | m: copy. m kind: k. m title: t. m setWidth: w Height: h.
    m color: lrdUI panelColor. m ).
  lrdAction: a = ( observatory panel: self Action: a. self ).
  pickX: x = ( observatory panel: self PickX: x. self ).
  place: m At: p = ( m position: p. addMorph: m. m ).
  baseDrawOn: cv = ( | b |
    b: baseBounds.
    cv fillRectangle: b Color: color.
    cv rectangle: b Width: 1 Color: (lrdUI ink: 'darkGray').
    cv fillRectangle: (b origin # ((b corner x) @ (b origin y + 20))) Color: lrdUI titleColor.
    cv text: title At: (b origin x + 6) @ (b origin y + 15) FontSpec: lrdUI bold Color: (lrdUI ink: 'white').
    self).
  leftMouseDown: evt = ( self ).
|).

lobby _AddSlots: (| lrdGridMorph = morph copy |).
lrdGridMorph _AddSlots: (|
  cols <- 0. rows <- 0. title <- ''. xLabel <- ''. yLabel <- ''.
  copyW: w H: h = ( | m | m: copy. m setWidth: w Height: h. m color: (lrdUI rgb: 0.97 G: 0.93 B: 0.98). m ).
  baseDrawOn: cv = ( | b. ox. oy. cw. ch. ink |
    b: baseBounds. ink: lrdUI synthColor.
    cv fillRectangle: b Color: color.
    cv text: title At: (b origin x + 10) @ (b origin y + 18) FontSpec: lrdUI bold Color: ink.
    (cols = 0) || [rows = 0] ifTrue: [^ self].
    ox: b origin x + 60. oy: b origin y + 34.
    cw: (b width - 80) / cols. ch: (b height - 70) / rows.
    0 upTo: cols Do: [|:i| 0 upTo: rows Do: [|:j. r|
      r: ((ox + (i * cw)) @ (oy + (j * ch))) # (((ox + ((i + 1) * cw)) - 2) @ ((oy + ((j + 1) * ch)) - 2)).
      cv rectangle: r Width: 1 Color: ink.
      cv line: r origin To: r corner Color: (lrdUI rgb: 0.85 G: 0.75 B: 0.88).
      cv text: 'PLACEHOLDER' At: (r origin x + 4) @ (r origin y + 14) FontSpec: lrdUI font Color: ink]].
    cv text: xLabel At: (ox + 10) @ (b corner y - 12) FontSpec: lrdUI font Color: ink.
    cv text: yLabel At: (b origin x + 6) @ (oy - 4) FontSpec: lrdUI font Color: ink.
    self).
  leftMouseDown: evt = ( self ).
|).
