-- Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
-- SPDX-License-Identifier: AGPL-3.0-only. Also subject to the SnapKitty Opaque License (dual license).
-- See LICENSE and SNAPKITTY_OPAQUE_LICENSE.md (repository root and curry/).
--
-- Exact rational quantities and uncertainty grading.
--
-- All numbers in the engine are exact rationals (LRD-REC-v1 writes them as
-- base-10 integers or `p/q` with q>0, gcd(p,q)=1). No floating point is used,
-- so every comparison and every trace is bit-for-bit reproducible.

module Qty
  ( Q, mkQ, qNum, qDen, parseQ, showQ, isCanonicalQ
  , addQ, subQ, mulQ, negQ, gtQ, ltQ, eqQ
  , Grade(..), gradeGT, gradeLT, minGrade, showGrade
  , disagree, parseDecimal
  ) where

import Data.Char (isDigit)

-- | A rational p/q, always normalised: q > 0 and gcd(|p|,q) = 1.
data Q = Q Int Int
  deriving (Eq, Show)

gcdI :: Int -> Int -> Int
gcdI a b = if b == 0 then abs a else gcdI b (a `mod` b)

mkQ :: Int -> Int -> Q
mkQ p q
  | q == 0    = error "Qty.mkQ: zero denominator"
  | q < 0     = mkQ (negate p) (negate q)
  | otherwise = let g = gcdI p q
                    g' = if g == 0 then 1 else g
                in Q (p `div` g') (q `div` g')

qNum :: Q -> Int
qNum (Q p _) = p

qDen :: Q -> Int
qDen (Q _ q) = q

-- | Parse the LRD-REC-v1 numeric forms `-?[0-9]+` or `-?[0-9]+/[0-9]+`.
--   Non-canonical spellings (leading zeros, q<=0, non-reduced) are rejected,
--   because CONTRACTS.md requires canonical integers and rationals.
parseQ :: String -> Maybe Q
parseQ s = case break (== '/') s of
  (ps, [])      -> do p <- parseInt ps
                      return (Q p 1)
  (ps, '/':qs)  -> do p <- parseInt ps
                      q <- parseNat qs
                      if q > 0 && gcdI p q == 1 && q /= 1
                        then return (Q p q) else Nothing
  _             -> Nothing

parseInt :: String -> Maybe Int
parseInt s = case s of
  ('-':ds) -> do n <- parseNat ds
                 if n == 0 then Nothing else return (negate n)
  ds -> parseNat ds

parseNat :: String -> Maybe Int
parseNat ds
  | null ds                       = Nothing
  | not (all isDigit ds)          = Nothing
  | length ds > 1 && head ds == '0' = Nothing
  | otherwise                     = Just (foldl (\a c -> a * 10 + (fromEnum c - 48)) 0 ds)

isCanonicalQ :: String -> Bool
isCanonicalQ s = case parseQ s of
  Just _  -> True
  Nothing -> False

showQ :: Q -> String
showQ (Q p q) = if q == 1 then show p else show p ++ "/" ++ show q

addQ :: Q -> Q -> Q
addQ (Q a b) (Q c d) = mkQ (a * d + c * b) (b * d)

negQ :: Q -> Q
negQ (Q a b) = Q (negate a) b

subQ :: Q -> Q -> Q
subQ x y = addQ x (negQ y)

mulQ :: Q -> Q -> Q
mulQ (Q a b) (Q c d) = mkQ (a * c) (b * d)

gtQ :: Q -> Q -> Bool
gtQ (Q a b) (Q c d) = a * d > c * b

ltQ :: Q -> Q -> Bool
ltQ x y = gtQ y x

eqQ :: Q -> Q -> Bool
eqQ (Q a b) (Q c d) = a * d == c * b

-- | How strongly an uncertain measurement satisfies a threshold test.
--   `Robust`:   the test holds even after moving the value k*sigma against it.
--   `Marginal`: the central value passes but the k*sigma interval straddles
--               the threshold.
--   Ordering: Marginal is weaker than Robust.
data Grade = Marginal | Robust
  deriving (Eq, Show)

minGrade :: Grade -> Grade -> Grade
minGrade Robust Robust = Robust
minGrade Robust Marginal = Marginal
minGrade Marginal _ = Marginal

showGrade :: Grade -> String
showGrade Robust   = "robust"
showGrade Marginal = "marginal"

-- | value > threshold, graded at k sigma.
gradeGT :: Q -> Q -> Q -> Q -> Maybe Grade
gradeGT k v s thr
  | gtQ (subQ v (mulQ k s)) thr = Just Robust
  | gtQ v thr                   = Just Marginal
  | otherwise                   = Nothing

-- | value < threshold, graded at k sigma.
gradeLT :: Q -> Q -> Q -> Q -> Maybe Grade
gradeLT k v s thr
  | ltQ (addQ v (mulQ k s)) thr = Just Robust
  | ltQ v thr                   = Just Marginal
  | otherwise                   = Nothing

-- | Two measurements (v1 +- s1, v2 +- s2) disagree at k sigma iff
--   (v1-v2)^2 > k^2 (s1^2 + s2^2). Computed exactly (no square roots).
disagree :: Q -> Q -> Q -> Q -> Q -> Bool
disagree k v1 s1 v2 s2 =
  let d = subQ v1 v2
  in gtQ (mulQ d d) (mulQ (mulQ k k) (addQ (mulQ s1 s1) (mulQ s2 s2)))

-- | Exact value of a decimal literal as printed by another tool, e.g. the
--   Fortran kernel's `7.0422058295032448E+000`. Grammar:
--   [+-]? digit+ ( '.' digit* )? ( [eE] [+-]? digit+ )?
--   The result is the exact rational denoted by the digits (no rounding);
--   it says nothing about the precision of the original measurement.
parseDecimal :: String -> Maybe Q
parseDecimal s0 =
  let (sg, s1) = case s0 of
                   ('-':r) -> (negate 1, r)
                   ('+':r) -> (1, r)
                   _       -> (1, s0)
      (ip, s2) = span isDigit s1
      (fp, s3) = case s2 of
                   ('.':r) -> span isDigit r
                   _       -> ("", s2)
      ex = case s3 of
             []      -> Just 0
             (e:r) | e == 'e' || e == 'E' -> expo r
                   | otherwise -> Nothing
  in if null ip then Nothing
     else case ex of
       Nothing -> Nothing
       Just e  ->
         let m = digitsVal (ip ++ fp)
             e' = e - length fp
         in Just (if e' >= 0 then mkQ (sg * m * pow10 e') 1
                             else mkQ (sg * m) (pow10 (negate e')))
 where
  expo r = case r of
    ('-':ds) -> fmap negate (digitsOnly ds)
    ('+':ds) -> digitsOnly ds
    ds       -> digitsOnly ds
  digitsOnly ds = if null ds || not (all isDigit ds) then Nothing else Just (digitsVal ds)
  digitsVal = foldl (\a c -> a * 10 + (fromEnum c - 48)) 0
  pow10 n = if n <= 0 then 1 else 10 * pow10 (n - 1)
