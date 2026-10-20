-- Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
-- Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
-- SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
--
-- JWST-LRD Mission QSO1-DCBH-001, role 08: growth-history classification.
--
-- Input: one LRD-REC-v1 record in format LRD-GROWTH-v1, written by the Fortran
-- growth solver (fortran/growth/app/lrd_growth_sweep.f90). Each row is one
-- swept tuple (lam, eps, z_form, duty) with the minimum feasible seed under
-- the simple and the saturated growth models.
--
-- Classification is NONDETERMINISTIC on purpose (directive item 6: feed
-- feasible solutions to Curry without prematurely eliminating competing
-- hypotheses). `hypothesis t` yields EVERY formation hypothesis consistent
-- with tuple t; `hypothesesOf t` collects them. A hypothesis here means
-- "consistent with this tuple", never "established". Infeasible tuples are
-- counterexamples: `counterexample t` holds when no seed in the swept range
-- reaches the target under either model.
--
-- Hypothesis reading (seed ranges are the swept ranges, not new physics):
--   LightSeed       a seed <= 100 Msun suffices at lam <= 1 (simple model):
--                   ordinary stellar-remnant seed, sub-Eddington growth.
--   HeavySeed       min seed in (100, 1e5] Msun at lam <= 1: direct-collapse
--                   or runaway-merger heavy seed, sub-Eddington growth.
--   SuperEddington  the tuple reaches the target only with lam > 1 in the
--                   simple model, or the saturated model changes feasibility:
--                   growth needs super-Eddington luminosity episodes.
--   PrimordialBH    min seed >= 1e4 Msun with z_form >= 25: an early, massive
--                   seed is required, the range a primordial origin speaks to.
--   Composite       heavy seed AND super-Eddington episodes (saturated model
--                   feasible, lam > 1, min seed > 100): mixed history.
module GrowthClassify
  ( Tuple(..), Hypothesis(..)
  , parseRecord, parseGrowth, loadGrowth
  , hypothesis, hypothesesOf, counterexample, feasible
  ) where

import Data.Char ( isDigit, ord )
import Data.List ( isPrefixOf )

------------------------------------------------------------------------------
-- LRD-REC-v1 (same strict parser shape as CausalGraph.curry)

type Record = [(String, String)]

parseRecord :: String -> Either String Record
parseRecord s
  | not ("LRD-REC-v1\n" `isPrefixOf` s) = Left "bad_header"
  | otherwise = fields (drop 11 s) Nothing
 where
  fields cs prev = if null cs then Right [] else
    case readLen cs of
      Nothing -> Left "bad_key_length"
      Just (nk, r1) ->
        let key = take nk r1
            r2  = drop nk r1
        in if nk == 0 then Left "empty_key" else
           if length key /= nk then Left "truncated_key" else
           case readLen r2 of
             Nothing -> Left "bad_value_length"
             Just (nv, r3) ->
               let val = take nv r3
                   r4  = drop nv r3
               in if length val /= nv then Left "truncated_value" else
                  case r4 of
                    ('\n' : rest) ->
                      if maybe False (>= key) prev
                        then Left ("unsorted_or_duplicate:" ++ key)
                        else if '\n' `elem` val then Left "newline_in_value"
                        else fmap ((key, val) :) (fields rest (Just key))
                    _ -> Left "missing_newline"
  readLen cs =
    let (ds, rest) = span isDigit cs
    in case rest of
         (':' : r) | not (null ds) && not (length ds > 1 && head ds == '0') && length ds < 10
                   -> Just (foldl (\a d -> 10 * a + ord d - ord '0') 0 ds, r)
         _ -> Nothing

-- | Decimal float as written by the Fortran solver (ES24.16E3, e.g.
-- " 5.0214975104612182E+002"; leading blanks allowed). Parsed by hand:
-- PAKCS's `reads` delegates to SWI-Prolog number_codes, which rejects the
-- Fortran "E+002" exponent form outright (illegal_number), so `reads`
-- cannot be used on this record at all. Accumulating the mantissa in
-- Float costs ~1e-13 relative error, immaterial for the classification
-- thresholds (100, 1e4, 1e5, and the (480, 525) benchmark window).
parseDecimal :: String -> Maybe Float
parseDecimal str =
  let s = dropWhile (== ' ') (dropWhileEnd' str)
  in case s of
       ('-' : r) -> fmap (\x -> 0.0 - x) (posDecimal r)
       ('+' : r) -> posDecimal r
       _         -> posDecimal s
 where
  dropWhileEnd' = foldr (\c acc -> if c == ' ' && null acc then [] else c : acc) []
  posDecimal r =
    let (mant, expo) = break (\c -> c == 'E' || c == 'e') r
    in do m <- mantissa mant
          e <- case expo of
                 []        -> Just 0
                 (_ : es)  -> expValue es
          return (scale10 m e)
  expValue es = case es of
                  ('-' : ds) -> fmap (0 -) (digitsValue ds)
                  ('+' : ds) -> digitsValue ds
                  ds         -> digitsValue ds
  digitsValue ds
    | not (null ds) && all isDigit ds =
        Just (foldl (\a d -> 10 * a + ord d - ord '0') 0 ds)
    | otherwise = Nothing
  mantissa m =
    let (ip, fp) = break (== '.') m
    in if null ip || not (all isDigit ip) then Nothing
       else let intVal = foldl (\a d -> a * 10.0 + fromInt (ord d - ord '0')) 0.0 ip
            in case fp of
                 [] -> Just intVal
                 ('.' : fds)
                   | all isDigit fds ->
                       let fracVal = foldr (\d a -> (fromInt (ord d - ord '0') + a) / 10.0) 0.0 fds
                       in Just (intVal + fracVal)
                   | otherwise -> Nothing
                 _ -> Nothing
  scale10 x e
    | e == 0 = x
    | e > 0  = scale10 (x * 10.0) (e - 1)
    | otherwise = scale10 (x / 10.0) (e + 1)

------------------------------------------------------------------------------
-- Growth tuples

data Tuple = Tuple
  { tLam :: Float, tEps :: Float, tZForm :: Float, tDuty :: Float
  , tDtMyr :: Float, tMdot :: Float
  , tSeedSimple :: Float, tSeedSat :: Float
  , tFeasSimple :: Bool, tFeasSat :: Bool }
  deriving Show

data Hypothesis = LightSeed | HeavySeed | SuperEddington | PrimordialBH | Composite
  deriving (Eq, Ord, Show)

need :: Record -> String -> Either String String
need r k = maybe (Left ("missing:" ++ k)) Right (lookup k r)

needInt :: Record -> String -> Either String Int
needInt r k = need r k >>= \v ->
  if not (null v) && all isDigit v
    then Right (foldl (\a d -> 10 * a + ord d - ord '0') 0 v)
    else Left ("bad_int:" ++ k)

parseGrowth :: String -> Either String [Tuple]
parseGrowth s = do
  r <- parseRecord s
  fmt <- need r "format"
  if fmt /= "LRD-GROWTH-v1" then Left "bad_format" else Right ()
  n <- needInt r "n_rows"
  let ts = entriesToTuples r
  if length ts == n then Right ts else Left "row_count_mismatch"

-- | Single pass over the bytewise-sorted entries, grouping each row's
-- fields (an earlier version did ten full-list lookups per row, which is
-- quadratic in the record size and too slow at 1200 rows).
entriesToTuples :: Record -> [Tuple]
entriesToTuples r = finish (foldl step (Nothing, [], []) r)
 where
  step (cur, fields, done) (k, v)
    | "row." `isPrefixOf` k =
        let (idx, dotField) = span (/= '.') (drop 4 k)
        in case cur of
             Just ci | ci == idx -> (cur, (drop 1 dotField, v) : fields, done)
             _ -> (Just idx, [(drop 1 dotField, v)], closeRow fields done)
    | otherwise = (cur, fields, done)
  finish (_, fields, done) = reverse (closeRow fields done)
  closeRow fields done = case tupleOfFields fields of
                           Just t  -> t : done
                           Nothing -> done
  tupleOfFields fs = do
    lam <- fieldFloat fs "lam"
    eps <- fieldFloat fs "eps"
    zf  <- fieldFloat fs "zform"
    du  <- fieldFloat fs "duty"
    dt  <- fieldFloat fs "dt_myr"
    md  <- fieldFloat fs "mdot"
    ss  <- fieldFloat fs "seed_simple"
    st  <- fieldFloat fs "seed_sat"
    fsb <- fieldBool fs "feas_simple"
    ftb <- fieldBool fs "feas_sat"
    return (Tuple lam eps zf du dt md ss st fsb ftb)
  fieldFloat fs k = lookup k fs >>= parseDecimal
  fieldBool fs k = fmap (== "1") (lookup k fs)

loadGrowth :: String -> IO [Tuple]
loadGrowth path = do
  s <- readFile path
  case parseGrowth s of
    Left err -> error ("GrowthClassify.loadGrowth " ++ path ++ ": " ++ err)
    Right ts -> return ts

------------------------------------------------------------------------------
-- Classification (nondeterministic: every consistent hypothesis)

feasible :: Tuple -> Bool
feasible t = tFeasSimple t || tFeasSat t

allHypotheses :: [Hypothesis]
allHypotheses = [LightSeed, HeavySeed, SuperEddington, PrimordialBH, Composite]

-- | Deterministic consistency check: is hypothesis h consistent with tuple t?
consistentWith :: Tuple -> Hypothesis -> Bool
consistentWith t LightSeed =
  tFeasSimple t && tLam t <= 1.0 && tSeedSimple t <= 100.0
consistentWith t HeavySeed =
  tFeasSimple t && tLam t <= 1.0 && tSeedSimple t > 100.0
consistentWith t SuperEddington =
  feasible t && tLam t > 1.0
consistentWith t PrimordialBH =
  tFeasSimple t && tSeedSimple t >= 10000.0 && tZForm t >= 25.0
consistentWith t Composite =
  tFeasSat t && tLam t > 1.0 && tSeedSat t > 100.0

-- | Some hypothesis consistent with the tuple (nondeterministic choice over
-- every consistent one; competing hypotheses are NOT eliminated).
hypothesis :: Tuple -> Hypothesis
hypothesis t = anyOf [ h | h <- allHypotheses, consistentWith t h ]

-- | All hypotheses consistent with the tuple.
hypothesesOf :: Tuple -> [Hypothesis]
hypothesesOf t = [ h | h <- allHypotheses, consistentWith t h ]

-- | A tuple no seed in range satisfies under either model: a counterexample
-- to growth under exactly these parameters.
counterexample :: Tuple -> Bool
counterexample t = not (feasible t)
