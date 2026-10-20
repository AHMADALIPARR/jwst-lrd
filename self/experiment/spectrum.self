"SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
 Read-only LRD-ARR-v1 binary64 reader. Nonfinite samples are explicitly counted."
lobby _AddSlots: (|
  lrdSpectrum = (|
    parent* = traits clonable.
    wavelength <- nil.
    flux <- nil.
    sigma <- nil.
    source <- ''.
    excluded <- 0.
    minFlux <- 0.0.
    maxFlux <- 0.0.
    headerAt: p = ( | d |
      d: dictionary copyRemoveAll.
      (p asFileContents splitOn: '\n') do: [|:l. parts|
        parts: l splitOn: '='.
        (parts size = 2) ifTrue: [ d at: parts first Put: parts last ] ]. d ).
    doubleIn: bytes At: i = ( | b6. b7. exponent. mant <- 1.0. scale <- 0.0625. val |
      b6: (bytes at: i + 6) asByte. b7: (bytes at: i + 7) asByte.
      exponent: ((b7 % 128) * 16) + (b6 / 16).
      exponent = 2047 ifTrue: [ ^ nil ].
      mant: mant + ((b6 % 16) asFloat / 16.0).
      6 reverseDo: [|:k|
        scale: scale / 256.0.
        mant: mant + ((bytes at: i + k) asByte asFloat * scale) ].
      exponent = 0 ifTrue: [ mant: mant - 1.0. exponent: 1 ].
      val: mant.
      exponent >= 1023 ifTrue: [ (exponent - 1023) do: [ val: val * 2.0 ] ]
        False: [ (1023 - exponent) do: [ val: val / 2.0 ] ].
      b7 >= 128 ifTrue: [ 0.0 - val ] False: [ val ] ).
    arrayAt: p Unit: u Source: s = ( | hdr. bytes. arr. n |
      hdr: headerAt: p, '.hdr'.
      ((hdr at: 'format') = 'LRD-ARR-v1') ifFalse: [ error: 'bad array format' ].
      ((hdr at: 'unit') = u) ifFalse: [ error: 'unexpected array unit' ].
      ((hdr at: 'source_sha256') = s) ifFalse: [ error: 'mixed observation provenance' ].
      n: (hdr at: 'length') asInteger.
      bytes: (p, '.f64') asFileContents.
      bytes size = (n * 8) ifFalse: [ error: 'array byte length mismatch' ].
      arr: vector copySize: n.
      n do: [|:i| arr at: i Put: (doubleIn: bytes At: i * 8) ]. arr ).
    copyFromRoot: p = ( | m. dir. first <- true |
      m: copy.
      m source: ((p, '/fixtures/ingest/CURRENT') asFileContents splitOn: '\n') first.
      dir: p, '/fixtures/ingest/', m source, '/'.
      m wavelength: m arrayAt: dir, 'wavelength' Unit: 'um' Source: m source.
      m flux: m arrayAt: dir, 'flux' Unit: 'Jy' Source: m source.
      m sigma: m arrayAt: dir, 'flux_error' Unit: 'Jy' Source: m source.
      ((m flux size = m wavelength size) && [m sigma size = m flux size])
        ifFalse: [ error: 'array lengths differ' ].
      m excluded: 0.
      m flux size do: [|:i. v|
        (m validAt: i) ifTrue: [
          v: m flux at: i.
          first ifTrue: [ m minFlux: v. m maxFlux: v. first: false ].
          m minFlux: m minFlux min: v. m maxFlux: m maxFlux max: v
        ] False: [ m excluded: m excluded + 1 ] ].
      first ifTrue: [ error: 'no finite spectrum samples' ].
      m ).
    validAt: i = ( ((wavelength at: i) = nil) ifTrue: [ ^ false ].
      ((flux at: i) = nil) ifTrue: [ ^ false ].
      ((sigma at: i) = nil) ifTrue: [ ^ false ].
      ((wavelength at: i) > 0.0) && [(sigma at: i) > 0.0] ).
  |).
|).
