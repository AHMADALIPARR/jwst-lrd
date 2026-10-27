"Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
 SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque

 JWST-LRD Self observatory: readers for the shared file formats of
 research/CONTRACTS.md (v1):
   LRD-ARR-v1   <name>.hdr (key=value lines) + <name>.f64 (raw LE binary64)
   LRD-REC-v1   canonical records, LRD-COMMIT-v1 commitment (SHA-256)
   LRD-STATE-v1 state records, transition proposals and decisions
 Nothing here produces data; it only reads files written by other tracks.

 binary64 values are decoded exactly (sign, 52-bit fraction, exponent as
 Self integers/bigInts).  Decimal strings are derived from the exact value
 by integer arithmetic.  Self floats on this VM have a very small range
 (measured: about 1e-9 .. 1e10; exponent literals such as 1.0e15 parse
 to inf), so floats are used only for plot coordinates after rescaling by a power of ten, never for printed numbers.  Shifts are avoided
 (see sha256.self for the VM >> bug)."

lobby _AddSlots: (| lrdF64 = (|
  parent* = traits clonable.
  sign <- 0. biasedExp <- 0. fraction <- 0. rawBytes.
  hexDigits = '0123456789abcdef'.

  kind = (
    biasedExp = 2047 ifTrue: [^ fraction = 0 ifTrue: 'inf' False: 'nan'].
    biasedExp = 0 ifTrue: [^ fraction = 0 ifTrue: 'zero' False: 'subnormal'].
    'normal').
  isNaN = ( kind = 'nan' ).
  isFinite = ( biasedExp != 2047 ).
  mantissa = ( biasedExp = 0 ifTrue: [fraction] False: [fraction + (2 power: 52)] ).
  exp2 = ( biasedExp = 0 ifTrue: [-1074] False: [biasedExp - 1075] ).

  rawHex = ( | s <- '' |
    "big-endian rendering of the 8 stored bytes (file order is little-endian)"
    0 upTo: 8 Do: [|:j. b| b: rawBytes at: 7 - j.
      s: s, (hexDigits at: b / 16), (hexDigits at: b % 16)].
    s).

  "Exact value = N / 10^k with integers N >= 0, k >= 0."
  exactN = ( exp2 >= 0 ifTrue: [mantissa * (2 power: exp2)] False: [mantissa * (5 power: 0 - exp2)] ).
  exactK = ( exp2 >= 0 ifTrue: [0] False: [0 - exp2] ).

  "Returns a 2-vector: (digit string of n significant digits, decimal exponent)
   rounded half-up from the exact value.  Only for finite nonzero values."
  sig: n = ( | bigN. k. ds. d. dexp. q. r. p. out |
    bigN: exactN. k: exactK.
    ds: bigN printString. d: ds size.
    dexp: (d - 1) - k.
    d > n ifTrue: [
      p: 10 power: d - n.
      q: bigN / p. r: bigN % p.
      (r * 2) >= p ifTrue: [q: q + 1].
      q = (10 power: n) ifTrue: [q: 10 power: n - 1. dexp: dexp + 1].
      ds: q printString]
    False: [
      [ds size < n] whileTrue: [ds: ds, '0']].
    out: vector copySize: 2.
    out at: 0 Put: ds. out at: 1 Put: dexp.
    out).

  decimal: n = ( | v. ds. e. es. s |
    kind = 'nan' ifTrue: [^ 'NaN'].
    kind = 'inf' ifTrue: [^ sign = 1 ifTrue: '-Inf' False: '+Inf'].
    kind = 'zero' ifTrue: [^ sign = 1 ifTrue: '-0' False: '0'].
    v: sig: n. ds: v at: 0. e: v at: 1.
    es: e absoluteValue printString.
    es size < 2 ifTrue: [es: '0', es].
    s: sign = 1 ifTrue: '-' False: ''.
    s, (ds copyFrom: 0 UpTo: 1), '.', (ds copyFrom: 1 UpTo: ds size), 'e', (e < 0 ifTrue: '-' False: '+'), es).

  "Full exact decimal expansion of the stored binary64 value."
  exactDecimal = ( | ds. k. s |
    isFinite ifFalse: [^ decimal: 7].
    ds: exactN printString. k: exactK.
    k = 0 ifTrue: [s: ds] False: [
      [ds size <= k] whileTrue: [ds: '0', ds].
      s: (ds copyFrom: 0 UpTo: ds size - k), '.', (ds copyFrom: ds size - k UpTo: ds size).
      [(s byteAt: s size - 1) = 48] whileTrue: [s: s copyFrom: 0 UpTo: s size - 1].
      (s byteAt: s size - 1) = 46 ifTrue: [s: s copyFrom: 0 UpTo: s size - 1]].
    (sign = 1 ifTrue: '-' False: ''), s).

  decimalExponent = ( (kind = 'normal') || [kind = 'subnormal'] ifTrue: [(sig: 7) at: 1] False: [0] ).

  "Float approximation of value / 10^p, for plot coordinates only.
   Returns nil when not finite or when outside the VM float range."
  scaledFloat: p = ( | m. t. twos. tens. f. guard <- 0 |
    "Binary scaling with float ops kept inside the VM float range; the
     only bigInt operation is one division of the 53-bit mantissa."
    isFinite ifFalse: [^ nil].
    kind = 'zero' ifTrue: [^ 0.0].
    m: mantissa.
    m >= (2 power: 29) ifTrue: [t: m / (2 power: 29). twos: exp2 + 29] False: [t: m. twos: exp2].
    f: t asFloat. tens: 0 - p.
    [(twos != 0) || [tens != 0]] whileTrue: [| big. small |
      guard: guard + 1. guard > 4000 ifTrue: [^ nil].
      big: f >= 1000000.0. small: f < 0.000001.
      big ifTrue: [
        twos < 0 ifTrue: [f: f * 0.5. twos: twos + 1] False: [
        tens < 0 ifTrue: [f: f / 10.0. tens: tens + 1] False: [
        twos > 0 ifTrue: [f: f * 2.0. twos: twos - 1] False: [f: f * 10.0. tens: tens - 1]]]]
      False: [ small ifTrue: [
        twos > 0 ifTrue: [f: f * 2.0. twos: twos - 1] False: [
        tens > 0 ifTrue: [f: f * 10.0. tens: tens - 1] False: [
        twos < 0 ifTrue: [f: f * 0.5. twos: twos + 1] False: [f: f / 10.0. tens: tens + 1]]]]
      False: [
        twos > 0 ifTrue: [f: f * 2.0. twos: twos - 1] False: [
        twos < 0 ifTrue: [f: f * 0.5. twos: twos + 1] False: [
        tens > 0 ifTrue: [f: f * 10.0. tens: tens - 1] False: [f: f / 10.0. tens: tens + 1]]]]].
      (f > 100000000.0) || [(f < 0.00000001) && [f != 0.0]] ifTrue: [^ nil]].
    sign = 1 ifTrue: [f: 0.0 - f].
    f).
|) |).

lobby _AddSlots: (| lrdArr = (|
  parent* = traits clonable.
  path <- ''. hdrKeys. hdr. bytes. values. errors. warnings.
  name = ( hdr at: 'name' IfAbsent: '' ).
  unit = ( hdr at: 'unit' IfAbsent: '' ).
  sourceSha = ( hdr at: 'source_sha256' IfAbsent: '' ).
  length = ( values isNil ifTrue: 0 False: [values size] ).
  ok = ( errors isEmpty ).
  isSynthetic = ( (path includesSubstring: 'SYNTHETIC') || [(hdr at: 'synthetic' IfAbsent: '') != ''] ||
                  [(hdr at: 'name' IfAbsent: '') includesSubstring: 'SYNTHETIC'] ).
  finiteCount = ( | c <- 0 | values do: [|:v| v isFinite ifTrue: [c: c + 1]]. c ).
  nanCount = ( | c <- 0 | values do: [|:v| v isNaN ifTrue: [c: c + 1]]. c ).
|) |).

lobby _AddSlots: (| lrdRec = (|
  parent* = traits clonable.
  path <- ''. raw <- ''. keys. dict. errors. commitCache. endPos <- 0.
  ok = ( errors isEmpty ).
  at: k = ( dict at: k IfAbsent: nil ).
  at: k IfAbsent: b = ( dict at: k IfAbsent: b ).
  includes: k = ( dict includesKey: k ).
  commitment = (
    commitCache isNil ifTrue: [commitCache: lrdReader commitmentOf: (lrdReader serializeKeys: keys Dict: dict)].
    commitCache).
|) |).

lobby _AddSlots: (| lrdReader = (|
  parent* = traits oddball.

  "---------- files ----------"
  readFile: path IfFail: fb = ( | f. sz. s. chunk |
    f: os_file openForReading: path IfFail: [|:e| ^ fb value: e].
    sz: f size.
    s: ''.
    [s size < sz] whileTrue: [
      chunk: f readCount: sz - s size IfFail: [|:e| f close. ^ fb value: e].
      chunk size = 0 ifTrue: [f close. ^ fb value: 'short read'].
      s: s, chunk].
    f close.
    s).
  fileExists: path = ( | f |
    f: os_file openForReading: path IfFail: [^ false].
    f close. true).

  "---------- text helpers (byte based) ----------"
  splitLines: s = ( | out. start |
    out: list copyRemoveAll. start: 0.
    0 upTo: s size Do: [|:i| (s byteAt: i) = 10 ifTrue: [out addLast: (s copyFrom: start UpTo: i). start: i + 1]].
    start < s size ifTrue: [out addLast: (s copyFrom: start UpTo: s size)].
    out).
  indexOfByte: b In: s From: i = (
    i upTo: s size Do: [|:j| (s byteAt: j) = b ifTrue: [^ j]].
    -1).
  bytes: a Less: b = ( | n |
    n: a size min: b size.
    0 upTo: n Do: [|:i| (a byteAt: i) = (b byteAt: i) ifFalse: [^ (a byteAt: i) < (b byteAt: i)]].
    a size < b size).
  string: s EndsWith: x = ( (s size >= x size) && [(s copyFrom: s size - x size UpTo: s size) = x] ).
  string: s StartsWith: x = ( (s size >= x size) && [(s copyFrom: 0 UpTo: x size) = x] ).
  isDigits: s = (
    s isEmpty ifTrue: [^ false].
    0 upTo: s size Do: [|:i| ((s byteAt: i) < 48) || [(s byteAt: i) > 57] ifTrue: [^ false]].
    true).
  isNatural: s = ( (isDigits: s) && [(s size = 1) || [(s byteAt: 0) != 48]] ).
  isHex64: s = (
    s size = 64 ifFalse: [^ false].
    0 upTo: 64 Do: [|:i. b| b: s byteAt: i.
      (((b >= 48) && [b <= 57]) || [(b >= 97) && [b <= 102]]) ifFalse: [^ false]].
    true).
  baseName: p = ( | i <- -1 |
    0 upTo: p size Do: [|:j| (p byteAt: j) = 47 ifTrue: [i: j]].
    p copyFrom: i + 1 UpTo: p size).
  dirName: p = ( | i <- -1 |
    0 upTo: p size Do: [|:j| (p byteAt: j) = 47 ifTrue: [i: j]].
    i < 0 ifTrue: '.' False: [p copyFrom: 0 UpTo: i]).

  "---------- key=value text (LRD-ARR-v1 .hdr) ----------"
  parseKv: s Into: r = ( | keys. d. errs |
    keys: list copyRemoveAll. d: dictionary copyRemoveAll. errs: r errors.
    (splitLines: s) do: [|:line. eq|
      line isEmpty ifFalse: [
        eq: indexOfByte: 61 In: line From: 0.
        eq < 0 ifTrue: [errs addLast: 'line without =: ', line] False: [| k. v |
          k: line copyFrom: 0 UpTo: eq. v: line copyFrom: eq + 1 UpTo: line size.
          (d includesKey: k) ifTrue: [errs addLast: 'duplicate key ', k] False: [
            keys addLast: k. d at: k Put: v]]]].
    r hdrKeys: keys. r hdr: d.
    r).

  "---------- LRD-ARR-v1 ----------"
  "base is the path without extension; reads base.hdr and base.f64"
  readArr: base = ( | r. h. b. len. n |
    r: lrdArr clone. r path: base. r errors: list copyRemoveAll. r warnings: list copyRemoveAll.
    r hdrKeys: list copyRemoveAll. r hdr: dictionary copyRemoveAll.
    h: readFile: base, '.hdr' IfFail: [|:e| r errors addLast: 'cannot read ', base, '.hdr (', e printString, ')'. ^ r].
    parseKv: h Into: r.
    (r hdr at: 'format' IfAbsent: '') = 'LRD-ARR-v1' ifFalse: [r errors addLast: 'format is not LRD-ARR-v1'].
    ('name length unit' asTokensSeparatedByWhiteSpace) do: [|:k|
      (r hdr includesKey: k) ifFalse: [r errors addLast: 'missing required key ', k]].
    len: r hdr at: 'length' IfAbsent: ''.
    (isNatural: len) ifFalse: [r errors addLast: 'length is not a natural number: ', len. ^ r].
    n: len asInteger.
    (r hdr at: 'name' IfAbsent: '') = (baseName: base) ifFalse: [
      r warnings addLast: 'hdr name differs from file name'].
    b: readFile: base, '.f64' IfFail: [|:e| r errors addLast: 'cannot read ', base, '.f64 (', e printString, ')'. ^ r].
    r bytes: b.
    b size = (n * 8) ifFalse: [
      r errors addLast: '.f64 has ', b size printString, ' bytes, header length ', len, ' needs ', (n * 8) printString.
      ^ r].
    r values: vector copySize: n.
    0 upTo: n Do: [|:i| r values at: i Put: (decodeF64: b At: i * 8)].
    r).

  decodeF64: s At: o = ( | b. r. frac |
    b: vector copySize: 8 FillingWith: 0.
    0 upTo: 8 Do: [|:i| b at: i Put: (s byteAt: o + i)].
    r: lrdF64 clone. r rawBytes: b.
    r sign: (b at: 7) / 128.
    r biasedExp: (((b at: 7) % 128) * 16) + ((b at: 6) / 16).
    frac: (b at: 6) % 16.
    0 upTo: 6 Do: [|:j| frac: (frac * 256) + (b at: 5 - j)].
    r fraction: frac.
    r).

  "---------- LRD-REC-v1 ----------"
  readRec: path = ( | r. s |
    s: readFile: path IfFail: [|:e| r: newRec. r path: path. r errors addLast: 'cannot read (', e printString, ')'. ^ r].
    r: parseRec: s. r path: path. r).
  readRecs: path = ( | s. l |
    s: readFile: path IfFail: [|:e. r| r: newRec. r path: path. r errors addLast: 'cannot read (', e printString, ')'.
      l: list copyRemoveAll. l addLast: r. ^ l].
    l: parseRecStream: s. l do: [|:r| r path: path]. l).
  newRec = ( | r | r: lrdRec clone. r keys: list copyRemoveAll. r dict: dictionary copyRemoveAll.
    r errors: list copyRemoveAll. r commitCache: nil. r).
  isRecText: s = ( (s size >= 11) && [(s copyFrom: 0 UpTo: 11) = 'LRD-REC-v1\n'] ).

  "parse '<decimal>:' at pos; answers new position or -1, value stored in cell"
  parseLen: s At: pos Into: cell = ( | colon. ds |
    colon: indexOfByte: 58 In: s From: pos.
    colon < 0 ifTrue: [^ -1].
    ds: s copyFrom: pos UpTo: colon.
    (isNatural: ds) ifFalse: [^ -1].
    cell at: 0 Put: ds asInteger.
    colon + 1).

  "A file may hold one record or a stream of concatenated records."
  parseRecStream: s = ( | out. pos. r |
    out: list copyRemoveAll. pos: 0.
    [pos < s size] whileTrue: [
      r: parseRec: s From: pos.
      out addLast: r.
      r ok ifFalse: [^ out].
      pos: r endPos].
    out).
  startsRec: s At: pos = ( ((pos + 11) <= s size) && [(s copyFrom: pos UpTo: pos + 11) = 'LRD-REC-v1\n'] ).
  parseRec: s = ( parseRec: s From: 0 ).
  parseRec: s From: start = ( | r. pos. cell. prev |
    r: newRec.
    (startsRec: s At: start) ifFalse: [r errors addLast: 'missing LRD-REC-v1 header line'. r endPos: s size. ^ r].
    pos: start + 11. cell: vector copySize: 1.
    [(pos < s size) && [(startsRec: s At: pos) not]] whileTrue: [| k. v. p2 |
      p2: parseLen: s At: pos Into: cell.
      p2 < 0 ifTrue: [r errors addLast: 'bad key length at byte ', pos printString. ^ r].
      (p2 + (cell at: 0)) > s size ifTrue: [r errors addLast: 'key overruns record'. ^ r].
      k: s copyFrom: p2 UpTo: p2 + (cell at: 0).
      k isEmpty ifTrue: [r errors addLast: 'empty key (rejected since contracts v1.1)'].
      pos: p2 + (cell at: 0).
      p2: parseLen: s At: pos Into: cell.
      p2 < 0 ifTrue: [r errors addLast: 'bad value length for key ', k. ^ r].
      (p2 + (cell at: 0)) >= s size ifTrue: [r errors addLast: 'value overruns record for key ', k. ^ r].
      v: s copyFrom: p2 UpTo: p2 + (cell at: 0).
      pos: p2 + (cell at: 0).
      (s byteAt: pos) = 10 ifFalse: [r errors addLast: 'missing newline after field ', k. ^ r].
      pos: pos + 1.
      (indexOfByte: 10 In: v From: 0) >= 0 ifTrue: [r errors addLast: 'newline inside value of ', k].
      prev isNil ifFalse: [
        (bytes: prev Less: k) ifFalse: [r errors addLast: 'keys not strictly ascending at ', k]].
      (r dict includesKey: k) ifTrue: [r errors addLast: 'duplicate key ', k] False: [
        r keys addLast: k. r dict at: k Put: v].
      prev: k].
    r endPos: pos.
    r raw: (s copyFrom: start UpTo: pos).
    r).

  serializeKeys: keys Dict: d = ( | s |
    s: 'LRD-REC-v1\n'.
    keys do: [|:k. v| v: d at: k.
      s: s, k size printString, ':', k, v size printString, ':', v, '\n'].
    s).
  commitmentOf: serialization = (
    lrdSha256 digestOfString: 'LRD-COMMIT-v1', 0 asCharacter, serialization).
  "contracts v1.1: new_commit = commitment of the state record {commit, kind, payload_sha256, seq} built from the proposal"
  newCommitFor: prop = ( | d. ks |
    d: dictionary copyRemoveAll.
    d at: 'commit' Put: (prop at: 'prev_commit' IfAbsent: ''). d at: 'kind' Put: (prop at: 'kind' IfAbsent: '').
    d at: 'payload_sha256' Put: (prop at: 'payload_sha256' IfAbsent: ''). d at: 'seq' Put: (prop at: 'seq' IfAbsent: '').
    ks: list copyRemoveAll. ks addLast: 'commit'. ks addLast: 'kind'. ks addLast: 'payload_sha256'. ks addLast: 'seq'.
    commitmentOf: (serializeKeys: ks Dict: d)).
  isCanonical: r = ( r ok && [(serializeKeys: r keys Dict: r dict) = r raw] ).

  "---------- LRD-STATE-v1 ----------"
  transitionKinds = 'observation ledger_append hamiltonian_step capability air_proof'.
  "classify a record: 'decision', 'proposal', 'state' or 'other'"
  stateClass: r = (
    (r includes: 'decision') ifTrue: [^ 'decision'].
    (r includes: 'prev_commit') ifTrue: [^ 'proposal'].
    ((r includes: 'seq') && [r includes: 'commit']) && [r includes: 'kind'] ifTrue: [^ 'state'].
    'other').
  "answers a list of problems (empty list = well formed per CONTRACTS.md)"
  stateProblems: r = ( | c. p. need |
    p: list copyRemoveAll.
    r ok ifFalse: [p addLast: 'not a valid LRD-REC-v1 record'. ^ p].
    c: stateClass: r.
    c = 'state' ifTrue: [
      ('seq commit kind payload_sha256' asTokensSeparatedByWhiteSpace) do: [|:k| (r includes: k) ifFalse: [p addLast: 'missing ', k]].
      (isNatural: (r at: 'seq' IfAbsent: '')) ifFalse: [p addLast: 'seq not natural'].
      (isHex64: (r at: 'commit' IfAbsent: '')) ifFalse: [p addLast: 'commit not 64 hex'].
      (r includes: 'payload_sha256') && [(isHex64: (r at: 'payload_sha256')) not] ifTrue: [p addLast: 'payload_sha256 not 64 hex']].
    c = 'proposal' ifTrue: [
      ('kind prev_commit seq payload_sha256' asTokensSeparatedByWhiteSpace) do: [|:k| (r includes: k) ifFalse: [p addLast: 'missing ', k]].
      ((transitionKinds asTokensSeparatedByWhiteSpace) includes: (r at: 'kind' IfAbsent: '')) ifFalse: [p addLast: 'unknown kind'].
      (isNatural: (r at: 'seq' IfAbsent: '')) ifFalse: [p addLast: 'seq not natural'].
      (isHex64: (r at: 'prev_commit' IfAbsent: '')) ifFalse: [p addLast: 'prev_commit not 64 hex'].
      (isHex64: (r at: 'payload_sha256' IfAbsent: '')) ifFalse: [p addLast: 'payload_sha256 not 64 hex']].
    c = 'decision' ifTrue: [| d |
      d: r at: 'decision'.
      (d = 'ACCEPT') || [d = 'REJECT'] ifFalse: [p addLast: 'decision not ACCEPT/REJECT'].
      (r includes: 'reason') ifFalse: [p addLast: 'missing reason'].
      (d = 'ACCEPT') && [(r includes: 'new_commit') not] ifTrue: [p addLast: 'ACCEPT without new_commit'].
      (d = 'REJECT') && [r includes: 'new_commit'] ifTrue: [p addLast: 'REJECT carries new_commit'].
      (r includes: 'new_commit') && [(isHex64: (r at: 'new_commit')) not] ifTrue: [p addLast: 'new_commit not 64 hex']].
    c = 'other' ifTrue: [p addLast: 'not an LRD-STATE-v1 record'].
    p).
|) |).
