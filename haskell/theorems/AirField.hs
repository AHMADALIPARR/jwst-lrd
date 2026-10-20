{-# OPTIONS_GHC -fplugin=LiquidHaskell #-}
{-@ LIQUID "--ple" @-}
{-@ LIQUID "--exact-data-cons" @-}
-- Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
-- Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
-- SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
--
-- JWST-LRD: the Liquid Haskell refinement of the AIR Goldilocks
-- field theorems (theorems/coq/AirField.v, the proof of record,
-- which models air/include/air/field.h line by line). Per the
-- owner's architecture the Coq-proved theorems are refined here
-- into Liquid Haskell; the runtime (the C code) is unchanged.
-- Each theorem label is the refined type of the operation:
--   THM-AIR-FP-ADD-001    fpAdd
--   THM-AIR-FP-SUB-002    fpSub
--   THM-AIR-FP-NEG-003    fpNeg
--   THM-AIR-FP-RED128-004 fpReduce128
--   THM-AIR-FP-MUL-005    fpMul
-- Verified: LIQUID: SAFE (70 constraints), Liquid Haskell 0.9.6.3,
-- GHC 9.6.6, Z3 4.8.12. Check:
--   ghc -fplugin=LiquidHaskell -package liquidhaskell -c AirField.hs
-- (with z3 on PATH).
--
-- Representation (changes of representation only, as in the Coq
-- development): values are Ints, which Liquid Haskell's logic
-- treats as unbounded mathematical integers -- the same Z-model
-- as the Coq file. These functions are the proof carriers, not a
-- runtime; the C code is the runtime. The constants 2^64, 2^128
-- and p are assembled from 2^32 by multiplication: LH 0.9.6.3
-- encodes big literals inside reflected bodies as opaque terms,
-- and constantsOk below pins the assembled values to the true
-- literals, machine-checked. Correctness is stated as refined
-- types on the operations (the checker path-splits the bodies)
-- because this LH build emits no usable equation for a reflected
-- function whose body is a top-level conditional. fpAdd's body
-- is written in path-split form; it computes the same function
-- as the Coq/C let form. fpReduce128 is decomposed into stage
-- functions whose bodies are the algorithm's own stage
-- expressions (t0Of, t1Of, r1Of) and whose refined types carry
-- the fold congruences of the Coq proof (hiFold, epsSplit,
-- foldWitness, chain): 2^64 === EPS (mod p) and 2^32*EPS = p - 1.
-- prodOf's bounds use the literal values of p and 2^128 (pinned
-- by constantsOk) because Z3's nonlinear solver closes the
-- product bound over literals but does not fold the symbolic
-- constant chain inside nia.

module AirField where

{-@ reflect two32 @-}
two32 :: Int
two32 = 4294967296

{-@ reflect two64 @-}
two64 :: Int
two64 = two32 * two32

{-@ reflect two128 @-}
two128 :: Int
two128 = two64 * two64

{-@ reflect fpP @-}
fpP :: Int
fpP = two64 - two32 + 1

{-@ reflect fpEPS @-}
fpEPS :: Int
fpEPS = two32 - 1

{-@ constantsOk :: { fpP == 18446744069414584321 && fpEPS == 4294967295 && two64 == 18446744073709551616 && two32 == 4294967296 } @-}
constantsOk :: ()
constantsOk = ()

{-@ reflect w @-}
{-@ w :: x:Int -> { v:Int | v == x mod two64 && 0 <= v && v < two64 } @-}
w :: Int -> Int
w x = x `mod` two64

{-@ fpAdd :: a:Int -> b:Int
      -> { v:Int | (0 <= a && a < fpP && 0 <= b && b < fpP)
                   => (v == (a + b) mod fpP && 0 <= v && v < fpP) } @-}
fpAdd :: Int -> Int -> Int
fpAdd a b =
  let s0 = w (a + b)
  in if s0 < a
       then let s1 = w (s0 + fpEPS)
            in if s1 >= fpP then s1 - fpP else s1
       else if s0 >= fpP then s0 - fpP else s0

{-@ fpSub :: a:Int -> b:Int
      -> { v:Int | (0 <= a && a < fpP && 0 <= b && b < fpP)
                   => (v == (a - b) mod fpP && 0 <= v && v < fpP) } @-}
fpSub :: Int -> Int -> Int
fpSub a b = w (w (a - b) + (if a < b then fpP else 0))

{-@ fpNeg :: a:Int
      -> { v:Int | (0 <= a && a < fpP)
                   => (v == (- a) mod fpP && 0 <= v && v < fpP) } @-}
fpNeg :: Int -> Int
fpNeg a = if a == 0 then 0 else fpP - a

{-@ reflect loOf @-}
loOf :: Int -> Int
loOf x = x `mod` two64

{-@ reflect hiOf @-}
hiOf :: Int -> Int
hiOf x = x `div` two64

{-@ reflect hiHiOf @-}
hiHiOf :: Int -> Int
hiHiOf h = h `div` two32

{-@ reflect hiLoOf @-}
hiLoOf :: Int -> Int
hiLoOf h = h `mod` two32

{-@ reflect hiFold @-}
{-@ hiFold :: x:Int
      -> { v:Int | v == loOf x + hiOf x * fpEPS
                   && ((0 <= x && x < two128) => v mod fpP == x mod fpP) } @-}
hiFold :: Int -> Int
hiFold x = loOf x + hiOf x * fpEPS

{-@ reflect epsSplit @-}
{-@ epsSplit :: hi:Int
      -> { v:Int | v == hiLoOf hi * fpEPS - hiHiOf hi
                   && ((0 <= hi && hi < two64) => v mod fpP == (hi * fpEPS) mod fpP) } @-}
epsSplit :: Int -> Int
epsSplit hi = hiLoOf hi * fpEPS - hiHiOf hi

{-@ reflect foldWitness @-}
{-@ foldWitness :: x:Int
      -> { v:Int | v == loOf x + epsSplit (hiOf x)
                   && ((0 <= x && x < two128) => v mod fpP == x mod fpP) } @-}
foldWitness :: Int -> Int
foldWitness x =
  let _hf = hiFold x
  in loOf x + epsSplit (hiOf x)

{-@ reflect t0Of @-}
{-@ t0Of :: lo:Int -> hiHi:Int
      -> { v:Int | (0 <= lo && lo < two64 && 0 <= hiHi && hiHi < two32)
                   => (v mod fpP == (lo - hiHi) mod fpP && (v - (lo - hiHi) == 0 || v - (lo - hiHi) == fpP) && 0 <= v && v < two64) } @-}
t0Of :: Int -> Int -> Int
t0Of lo hiHi = w (lo - hiHi - (if lo < hiHi then fpEPS else 0))

{-@ reflect t1Of @-}
{-@ t1Of :: hiLo:Int
      -> { v:Int | v == hiLo * fpEPS
                   && (0 <= hiLo && hiLo < two32) => (0 <= v && v < two64 - two32) } @-}
t1Of :: Int -> Int
t1Of hiLo = hiLo * fpEPS

{-@ reflect r1Of @-}
{-@ r1Of :: t0:Int -> t1:Int
      -> { v:Int | (0 <= t0 && t0 < two64 && 0 <= t1 && t1 < two64 - two32)
                   => (v mod fpP == (t0 + t1) mod fpP && (v - (t0 + t1) == 0 || v - (t0 + t1) == - fpP) && 0 <= v && v < two64) } @-}
r1Of :: Int -> Int -> Int
r1Of t0 t1 =
  let r0 = w (t0 + t1)
  in if r0 < t1 then w (r0 + fpEPS) else r0


{-@ reflect chain @-}
{-@ chain :: x:Int -> lo:Int -> hiHi:Int -> hiLo:Int -> t0:Int -> t1:Int -> r1:Int
      -> { v:Int | v == r1
                   && (0 <= x && x < two128
                       && lo == loOf x && hiHi == hiHiOf (hiOf x) && hiLo == hiLoOf (hiOf x)
                       && (t0 - (lo - hiHi) == 0 || t0 - (lo - hiHi) == fpP)
                       && t1 == hiLo * fpEPS
                       && (r1 - (t0 + t1) == 0 || r1 - (t0 + t1) == - fpP)
                       && 0 <= r1 && r1 < two64)
                   => r1 mod fpP == x mod fpP } @-}
chain :: Int -> Int -> Int -> Int -> Int -> Int -> Int -> Int
chain x lo hiHi hiLo t0 t1 r1 =
  let _fw = foldWitness x
  in r1

{-@ fpReduce128 :: x:Int
      -> { v:Int | (0 <= x && x < two128)
                   => (v == x mod fpP && 0 <= v && v < fpP) } @-}
fpReduce128 :: Int -> Int
fpReduce128 x =
  let lo = loOf x
      hi = hiOf x
      hiHi = hiHiOf hi
      hiLo = hiLoOf hi
      t0 = t0Of lo hiHi
      t1 = t1Of hiLo
      r1 = r1Of t0 t1
      r1c = chain x lo hiHi hiLo t0 t1 r1
  in if r1c >= fpP then r1c - fpP else r1c


-- Product bound, stated with the literal values of p and 2^128
-- (pinned by constantsOk above): z3's nonlinear solver closes the
-- product bound over literals but does not fold the symbolic
-- constant chain (p via 2^64 via 2^32*2^32) inside nia.
{-@ prodOf :: a:Int -> b:Int
      -> { v:Int | v == a * b
                   && ((0 <= a && a < 18446744069414584321 && 0 <= b && b < 18446744069414584321)
                      => (0 <= v && v < two128)) } @-}
prodOf :: Int -> Int -> Int
prodOf a b = a * b

{-@ fpMul :: a:Int -> b:Int
      -> { v:Int | (0 <= a && a < fpP && 0 <= b && b < fpP)
                   => (v == (a * b) mod fpP && 0 <= v && v < fpP) } @-}
fpMul :: Int -> Int -> Int
fpMul a b = fpReduce128 (prodOf a b)
