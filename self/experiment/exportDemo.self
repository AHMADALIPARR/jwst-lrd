"SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
 Offline vector export of the native Self model. Every geometry point and
 camera frame is computed here; the encoder only rasterizes these SVG files."
lobby _AddSlots: (|
  lrdDemo = (|
    parent* = traits clonable.
    view <- nil.
    out <- ''.
    n: x = ( x printString ).
    pad: i = ( | s | s: i printString. [s size < 4] whileTrue: [ s: '0', s ]. s ).
    circleX: x Y: y Radius: r Fill: col = (
      '<circle cx="', (n: x), '" cy="', (n: y), '" r="', (n: r), '" fill="', col, '"/>' ).
    text: s X: x Y: y Size: size Fill: col = (
      '<text x="', (n: x), '" y="', (n: y), '" font-size="', (n: size), '" fill="', col, '">', s, '</text>' ).
    phasePoints = ( | points <- ''. a. x. y |
      961 do: [|:i|
        a: ((i asFloat / 960.0) * (4.0 * view model sphere pi)) + view phase.
        x: 260.0 + (i asFloat / 2.0). y: 680.0 - (a sin * 40.0).
        points: points, (n: x), ',', (n: y), ' ' ]. points ).
    helixPointAt: t Offset: offset = ( | a |
      a: ((t * 5.0) * view model sphere pi) + view phase + offset.
      (1430.0 + (a cos * 214.5)) @ (242.0 + (t * 460.2) + (a sin * 33.04)) ).
    helixPoints: offset = ( | points <- ''. p |
      721 do: [|:i|
        p: helixPointAt: i asFloat / 720.0 Offset: offset.
        points: points, (n: p x), ',', (n: p y), ' ' ]. points ).
    spectrumPath = ( | path <- ''. move <- true. x. y. s. range |
      s: view spectrum. range: s maxFlux - s minFlux.
      s flux size do: [|:i|
        (s validAt: i) ifTrue: [
          x: 150 + ((((s wavelength at: i) - 0.5) / 5.0) * 1620.0) asInteger.
          y: 930 - ((((s flux at: i) - s minFlux) / range) * 108.0) asInteger.
          ((x >= 150) && [x <= 1770]) ifTrue: [
            path: path, (move ifTrue: 'M' False: 'L'), (n: x), ',', (n: y), ' '. move: false ]
        ] False: [ move: true ] ]. path ).
    blend: a To: b At: t = ( a + ((b - a) * t) ).
    smooth: value = ( | t | t: (value max: 0.0) min: 1.0. (t * t) * (3.0 - (2.0 * t)) ).
    cameraAt: seconds = ( | x <- 960.0. y <- 530.0. z <- 1.0. t |
      seconds >= 3.0 ifTrue: [
        t: smooth: (seconds - 3.0) / 3.0.
        x: blend: 960.0 To: 490.0 At: t. y: blend: 530.0 To: 510.0 At: t.
        z: blend: 1.0 To: 1.65 At: t ].
      seconds >= 10.0 ifTrue: [
        t: smooth: (seconds - 10.0) / 3.0.
        x: blend: 490.0 To: 1430.0 At: t. y: blend: 510.0 To: 470.0 At: t.
        z: blend: 1.65 To: 1.50 At: t ].
      seconds >= 17.0 ifTrue: [
        t: smooth: (seconds - 17.0) / 3.0.
        x: blend: 1430.0 To: 500.0 At: t. y: blend: 470.0 To: 685.0 At: t.
        z: blend: 1.50 To: 2.15 At: t ].
      seconds >= 23.0 ifTrue: [
        t: smooth: (seconds - 23.0) / 2.0.
        x: blend: 500.0 To: 1660.0 At: t. y: blend: 685.0 To: 875.0 At: t.
        z: blend: 2.15 To: 2.0 At: t ].
      seconds >= 26.0 ifTrue: [
        t: smooth: (seconds - 26.0) / 2.0.
        x: blend: 1660.0 To: 960.0 At: t. y: blend: 875.0 To: 530.0 At: t.
        z: blend: 2.0 To: 1.0 At: t ].
      'translate(960 530) scale(', z printString, ') translate(', (0 - x) printString, ' ', (0 - y) printString, ')' ).
    chapterAt: seconds = (
      seconds < 3.0 ifTrue: [ ^ 'NATIVE SELF / VECTOR GEOMETRY' ].
      seconds < 10.0 ifTrue: [ ^ '01 / RED-DOT STATE - 2D CLOSE-UP' ].
      seconds < 17.0 ifTrue: [ ^ '02 / HELIX - PHASE GEOMETRY' ].
      seconds < 23.0 ifTrue: [ ^ '03 / PHASE WAVE - DERIVED MODEL' ].
      seconds < 26.0 ifTrue: [ ^ '04 / ARCHIVED QSO1 SPECTRUM' ].
      'QSO1 / OBSERVATIONS + CHECKED MODEL' ).
    polyline: points Color: col Width: width = (
      '<polyline points="', points, '" fill="none" stroke="', col, '" stroke-width="', width printString,
      '" stroke-linecap="round" stroke-linejoin="round"/>' ).
    svgFrame: i = ( | time. state. xml. a. b. px. py. radius |
      view tick: i % 256. state: view effectiveState. time: i asFloat / 24.0.
      radius: 79.0 + (view phase sin * 8.0).
      xml: '<svg xmlns="http://www.w3.org/2000/svg" width="1920" height="1080" viewBox="0 0 1920 1080">',
        '<defs><radialGradient id="red"><stop offset="0" stop-color="#ff9992"/><stop offset="0.2" stop-color="#ff3c45"/>',
        '<stop offset="0.5" stop-color="#a91a32"/><stop offset="1" stop-color="#080d18" stop-opacity="0"/></radialGradient>',
        '<clipPath id="stage"><rect x="48" y="150" width="1824" height="830" rx="18"/></clipPath></defs>',
        '<rect width="1920" height="1080" fill="#080d18"/>',
        '<g font-family="DejaVu Sans,sans-serif"><g clip-path="url(#stage)"><g transform="', (cameraAt: time), '">',
        '<rect x="70" y="165" width="1010" height="610" rx="18" fill="#0d1525"/>',
        '<rect x="1120" y="165" width="730" height="610" rx="18" fill="#0d1525"/>',
        '<rect x="70" y="790" width="1780" height="190" rx="18" fill="#0d1525"/>',
        (circleX: 500 Y: 450 Radius: 230 Fill: 'url(#red)'),
        (circleX: 500 Y: 450 Radius: radius Fill: '#ff4754'),
        (circleX: 500 Y: 450 Radius: 20 Fill: '#ffe0d8'),
        (text: 'RED-DOT STATE' X: 118 Y: 216 Size: 20 Fill: '#a6b7cb'),
        (text: 'MODEL GEOMETRY' X: 1162 Y: 216 Size: 20 Fill: '#a6b7cb'),
        (text: 'ARCHIVED NIRSPEC SPECTRUM / OBSERVED WAVELENGTH' X: 118 Y: 825 Size: 15 Fill: '#a6b7cb'),
        (polyline: phasePoints Color: '#ff6572' Width: 3.0),
        (polyline: (helixPoints: 0.0) Color: '#56e0ea' Width: 3.0),
        (polyline: (helixPoints: view model sphere pi) Color: '#ff6572' Width: 3.0).
      0 to: 160 By: 8 Do: [|:k|
        a: helixPointAt: k asFloat / 160.0 Offset: 0.0.
        b: helixPointAt: k asFloat / 160.0 Offset: view model sphere pi.
        px: a x. py: a y.
        xml: xml, '<line x1="', (n: px), '" y1="', (n: py), '" x2="',
          (n: b x), '" y2="', (n: b y), '" stroke="#30475e" stroke-width="1.5"/>' ].
      xml: xml, '<path d="', spectrumPath, '" fill="none" stroke="#56e0ea" stroke-width="2"/>',
        (text: 'PHASE WAVE / ILLUSTRATIVE' X: 290 Y: 755 Size: 15 Fill: '#a6b7cb'),
        '</g></g>',
        '<rect x="0" y="0" width="1920" height="144" fill="#080d18"/>',
        (text: 'LITTLE RED DOTS' X: 76 Y: 66 Size: 42 Fill: '#ecf4ff'),
        (text: (chapterAt: time) X: 78 Y: 109 Size: 19 Fill: '#56e0ea'),
        (text: 'SELF / 2D' X: 1650 Y: 64 Size: 22 Fill: '#a6b7cb'),
        '<rect x="0" y="982" width="1920" height="98" fill="#080d18"/>',
        (text: 'Model helix, nucleus and phase wave. Spectrum: archived QSO1 observation.' X: 78 Y: 1016 Size: 18 Fill: '#a6b7cb'),
        (text: ('phase=', (i % 256) printString, '/256   |   atlas radius^2=', state projRadiusSq printString) X: 78 Y: 1048 Size: 16 Fill: '#a6b7cb'),
        (text: 'ABELL 2744-QSO1' X: 1610 Y: 1048 Size: 16 Fill: '#ecf4ff'), '</g></svg>'. xml ).
    exportCutoutAt: file = ( | values <- ''. saved. radius. svg |
      saved: view tick.
      256 do: [|:i|
        view tick: i. radius: 79.0 + (view phase sin * 8.0).
        i > 0 ifTrue: [ values: values, ';' ].
        values: values, radius printString ].
      view tick: saved.
      svg: '<svg xmlns="http://www.w3.org/2000/svg" width="640" height="640" viewBox="0 0 640 640">',
        '<title>Self red-dot model - animated 2D vector cutout</title>',
        '<desc>Transparent model geometry exported by Self. 256 discrete phase states at 24 fps. Not a resolved JWST image.</desc>',
        '<defs><radialGradient id="glow"><stop offset="0" stop-color="#ff9992"/><stop offset="0.2" stop-color="#ff3c45"/>',
        '<stop offset="0.5" stop-color="#a91a32"/><stop offset="1" stop-color="#a91a32" stop-opacity="0"/></radialGradient></defs>',
        '<circle cx="320" cy="320" r="280" fill="url(#glow)"/>',
        '<circle cx="320" cy="320" r="79" fill="#ff4754"><animate attributeName="r" values="', values,
        '" dur="10.6666667s" calcMode="discrete" repeatCount="indefinite"/></circle>',
        '<circle cx="320" cy="320" r="20" fill="#ffe0d8"/></svg>'.
      file setFileContentsTo: svg. self ).
    run = ( | g. s. root. svg |
      root: os environmentAt: 'LRD_ROOT' IfFail: '.'.
      out: os environmentAt: 'LRD_DEMO_OUT' IfFail: '/tmp/lrd-demo'.
      g: lrdExperiment copyFromRoot: root. s: lrdSpectrum copyFromRoot: root.
      view: lrdLiveMorph copy. view model: g. view spectrum: s.
      720 do: [|:i|
        svg: svgFrame: i.
        (out, '/frame-', (pad: i), '.svg') setFileContentsTo: svg.
        (i % 120) = 0 ifTrue: [ ('DEMO_FRAME ', i printString) printLine ] ].
      (out, '/red-dot-detail.svg') setFileContentsTo: (svgFrame: 168).
      (out, '/helix-detail.svg') setFileContentsTo: (svgFrame: 348).
      (out, '/overview.svg') setFileContentsTo: (svgFrame: 0).
      exportCutoutAt: out, '/red-dot-loop.svg'.
      'LRD_VECTOR_DEMO_DONE' printLine. self ).
  |).
|).
