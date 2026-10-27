"Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
 SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque

 JWST-LRD Self observatory: SHA-256 (FIPS 180-4) written in Self.
 Self smallInts are 30-bit tagged, so every 32-bit word is held as a
 pair of 16-bit halves (hi, lo).  Used only to recompute LRD-COMMIT-v1
 commitments of LRD-REC-v1 records read from other tracks."

lobby _AddSlots: (| lrdSha256 = (|
  parent* = traits oddball.
  kHex = '428a2f98 71374491 b5c0fbcf e9b5dba5 3956c25b 59f111f1 923f82a4 ab1c5ed5 d807aa98 12835b01 243185be 550c7dc3 72be5d74 80deb1fe 9bdc06a7 c19bf174 e49b69c1 efbe4786 0fc19dc6 240ca1cc 2de92c6f 4a7484aa 5cb0a9dc 76f988da 983e5152 a831c66d b00327c8 bf597fc7 c6e00bf3 d5a79147 06ca6351 14292967 27b70a85 2e1b2138 4d2c6dfc 53380d13 650a7354 766a0abb 81c2c92e 92722c85 a2bfe8a1 a81a664b c24b8b70 c76c51a3 d192e819 d6990624 f40e3585 106aa070 19a4c116 1e376c08 2748774c 34b0bcb5 391c0cb3 4ed8aa4a 5b9cca4f 682e6ff3 748f82ee 78a5636f 84c87814 8cc70208 90befffa a4506ceb bef9a3f7 c67178f2'.
  hHex = '6a09e667 bb67ae85 3c6ef372 a54ff53a 510e527f 9b05688c 1f83d9ab 5be0cd19'.
  hexDigits = '0123456789abcdef'.
  "Shifts are written as multiplication/division by powers of two: on the
   i386 VM built here (russellallen/self abb0d5c) the optimizing compiler
   returns wrong results for smallInt >> 16 once a method is recompiled
   (see tests/self: vm_shift_bug).  Values are always nonnegative."
  pow2Cache <- nil.
  pow2 = ( | v |
    pow2Cache isNil ifFalse: [^ pow2Cache].
    v: vector copySize: 31 FillingWith: 1.
    1 upTo: 31 Do: [|:i| v at: i Put: (v at: i - 1) * 2].
    pow2Cache: v. v).

  hexVal: b = (
    (b >= 48) && [b <= 57] ifTrue: [^ b - 48].
    (b >= 97) && [b <= 102] ifTrue: [^ b - 87].
    (b >= 65) && [b <= 70] ifTrue: [^ b - 55].
    error: 'bad hex digit').
  hex16: s At: i = ( | v <- 0 |
    i upTo: i + 4 Do: [|:j| v: (v * 16) + (hexVal: (s byteAt: j))].
    v).
  wordsFromHex: s = ( | toks. hi. lo |
    toks: s asTokensSeparatedByWhiteSpace asVector.
    hi: vector copySize: toks size FillingWith: 0.
    lo: vector copySize: toks size FillingWith: 0.
    toks do: [|:t. :i| hi at: i Put: (hex16: t At: 0). lo at: i Put: (hex16: t At: 4)].
    (vector copyAddFirst: hi) copyAddLast: lo).

  "32-bit word helpers on (hi, lo) halves; results returned in a 2-vector"
  rotrHi: h Lo: l By: n Into: out = ( | a. b. m. hi. lo |
    n >= 16 ifTrue: [a: l. b: h. m: n - 16] False: [a: h. b: l. m: n].
    m = 0 ifTrue: [out at: 0 Put: a. out at: 1 Put: b. ^ out].
    hi: (a / (pow2 at: m)) || ((b && ((pow2 at: m) - 1)) * (pow2 at: 16 - m)).
    lo: (b / (pow2 at: m)) || ((a && ((pow2 at: m) - 1)) * (pow2 at: 16 - m)).
    out at: 0 Put: hi. out at: 1 Put: lo. out).
  shrHi: h Lo: l By: n Into: out = (
    n >= 16 ifTrue: [out at: 0 Put: 0. out at: 1 Put: h / (pow2 at: n - 16). ^ out].
    out at: 0 Put: h / (pow2 at: n).
    out at: 1 Put: (l / (pow2 at: n)) || ((h && ((pow2 at: n) - 1)) * (pow2 at: 16 - n)).
    out).

  digestOfString: s = ( | bytes |
    bytes: vector copySize: s size FillingWith: 0.
    0 upTo: s size Do: [|:i| bytes at: i Put: (s byteAt: i)].
    digestOfBytes: bytes).
  "Mutable working state lives in vectors held by a per-digest context
   object; loops call methods instead of assigning outer block temporaries."
  ctxProto = (| parent* = traits clonable.
     kh. kl. hh. hl. wh. wl. sh. sl. t. padded |).

  digestOfBytes: msg = ( | k. c. n. total. bitLen. out |
    c: ctxProto clone.
    k: wordsFromHex: kHex.  c kh: k at: 0. c kl: k at: 1.
    k: wordsFromHex: hHex.  c hh: (k at: 0) copy. c hl: (k at: 1) copy.
    n: msg size.
    total: ((n + 9 + 63) / 64) * 64.
    c padded: vector copySize: total FillingWith: 0.
    0 upTo: n Do: [|:i| c padded at: i Put: (msg at: i)].
    c padded at: n Put: 128.
    "message length in bits, big-endian, in the last 8 bytes.  Only the low
     4 bytes can be nonzero here (n < 2^26); x86 shifts wrap mod 32, so we
     never shift by 32 or more."
    bitLen: n * 8.
    0 upTo: 4 Do: [|:i| c padded at: total - 1 - i Put: ((bitLen / (pow2 at: 8 * i)) && 255)].
    c wh: vector copySize: 64 FillingWith: 0.
    c wl: vector copySize: 64 FillingWith: 0.
    c sh: vector copySize: 8 FillingWith: 0.
    c sl: vector copySize: 8 FillingWith: 0.
    c t: vector copySize: 2 FillingWith: 0.
    0 upTo: total / 64 Do: [|:blk| compress: c Base: blk * 64].
    out: ''.
    0 upTo: 8 Do: [|:i| out: out, (hex4: (c hh at: i)), (hex4: (c hl at: i))].
    out).

  compress: c Base: base = (
    0 upTo: 16 Do: [|:i| loadWord: c Index: i Base: base].
    16 upTo: 64 Do: [|:i| scheduleWord: c Index: i].
    0 upTo: 8 Do: [|:i| c sh at: i Put: (c hh at: i). c sl at: i Put: (c hl at: i)].
    0 upTo: 64 Do: [|:i| round: c Index: i].
    0 upTo: 8 Do: [|:i| addInto: c hh And: c hl At: i Hi: (c sh at: i) Lo: (c sl at: i)].
    self).

  loadWord: c Index: i Base: base = ( | p |
    p: base + (4 * i).
    c wh at: i Put: (((c padded at: p) * 256) || (c padded at: p + 1)).
    c wl at: i Put: (((c padded at: p + 2) * 256) || (c padded at: p + 3)).
    self).

  scheduleWord: c Index: i = ( | t. xh. xl. s0h. s0l. s1h. s1l. lo. hi |
    t: c t.
    xh: c wh at: i - 15. xl: c wl at: i - 15.
    rotrHi: xh Lo: xl By: 7 Into: t. s0h: t at: 0. s0l: t at: 1.
    rotrHi: xh Lo: xl By: 18 Into: t. s0h: s0h ^^ (t at: 0). s0l: s0l ^^ (t at: 1).
    shrHi: xh Lo: xl By: 3 Into: t. s0h: s0h ^^ (t at: 0). s0l: s0l ^^ (t at: 1).
    xh: c wh at: i - 2. xl: c wl at: i - 2.
    rotrHi: xh Lo: xl By: 17 Into: t. s1h: t at: 0. s1l: t at: 1.
    rotrHi: xh Lo: xl By: 19 Into: t. s1h: s1h ^^ (t at: 0). s1l: s1l ^^ (t at: 1).
    shrHi: xh Lo: xl By: 10 Into: t. s1h: s1h ^^ (t at: 0). s1l: s1l ^^ (t at: 1).
    lo: (c wl at: i - 16) + s0l + (c wl at: i - 7) + s1l.
    hi: (c wh at: i - 16) + s0h + (c wh at: i - 7) + s1h + (lo / 65536).
    c wh at: i Put: (hi && 65535).
    c wl at: i Put: (lo && 65535).
    self).

  round: c Index: i = ( | t. sh. sl. ah. al. bh. bl. ch. cl. eh. el. fh. fl. gh. gl.
                          s1h. s1l. chh. chl. t1h. t1l. s0h. s0l. mjh. mjl. t2h. t2l. lo |
    t: c t. sh: c sh. sl: c sl.
    ah: sh at: 0. al: sl at: 0. bh: sh at: 1. bl: sl at: 1. ch: sh at: 2. cl: sl at: 2.
    eh: sh at: 4. el: sl at: 4. fh: sh at: 5. fl: sl at: 5. gh: sh at: 6. gl: sl at: 6.
    rotrHi: eh Lo: el By: 6 Into: t. s1h: t at: 0. s1l: t at: 1.
    rotrHi: eh Lo: el By: 11 Into: t. s1h: s1h ^^ (t at: 0). s1l: s1l ^^ (t at: 1).
    rotrHi: eh Lo: el By: 25 Into: t. s1h: s1h ^^ (t at: 0). s1l: s1l ^^ (t at: 1).
    chh: (eh && fh) ^^ ((eh ^^ 65535) && gh).
    chl: (el && fl) ^^ ((el ^^ 65535) && gl).
    lo: (sl at: 7) + s1l + chl + (c kl at: i) + (c wl at: i).
    t1h: ((sh at: 7) + s1h + chh + (c kh at: i) + (c wh at: i) + (lo / 65536)) && 65535.
    t1l: lo && 65535.
    rotrHi: ah Lo: al By: 2 Into: t. s0h: t at: 0. s0l: t at: 1.
    rotrHi: ah Lo: al By: 13 Into: t. s0h: s0h ^^ (t at: 0). s0l: s0l ^^ (t at: 1).
    rotrHi: ah Lo: al By: 22 Into: t. s0h: s0h ^^ (t at: 0). s0l: s0l ^^ (t at: 1).
    mjh: ((ah && bh) ^^ (ah && ch)) ^^ (bh && ch).
    mjl: ((al && bl) ^^ (al && cl)) ^^ (bl && cl).
    lo: s0l + mjl.
    t2h: (s0h + mjh + (lo / 65536)) && 65535.
    t2l: lo && 65535.
    "h<-g, g<-f, f<-e, e<-d+T1, d<-c, c<-b, b<-a, a<-T1+T2"
    sh at: 7 Put: gh. sl at: 7 Put: gl.
    sh at: 6 Put: fh. sl at: 6 Put: fl.
    sh at: 5 Put: eh. sl at: 5 Put: el.
    lo: (sl at: 3) + t1l.
    sh at: 4 Put: (((sh at: 3) + t1h + (lo / 65536)) && 65535). sl at: 4 Put: (lo && 65535).
    sh at: 3 Put: ch. sl at: 3 Put: cl.
    sh at: 2 Put: bh. sl at: 2 Put: bl.
    sh at: 1 Put: ah. sl at: 1 Put: al.
    lo: t1l + t2l.
    sh at: 0 Put: ((t1h + t2h + (lo / 65536)) && 65535). sl at: 0 Put: (lo && 65535).
    self).

  addInto: hh And: hl At: i Hi: h Lo: l = ( | lo |
    lo: (hl at: i) + l.
    hh at: i Put: (((hh at: i) + h + (lo / 65536)) && 65535).
    hl at: i Put: (lo && 65535).
    self).

  hex4: v = (
    (hexDigits at: (v / 4096) && 15), (hexDigits at: (v / 256) && 15),
    (hexDigits at: (v / 16) && 15), (hexDigits at: v && 15)).
|) |).
