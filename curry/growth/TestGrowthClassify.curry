-- Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
-- Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
-- SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
--
-- Checks the LRD-GROWTH-v1 record written by the Fortran growth solver.
-- Expectations below are derived from the solver's stated model by hand
-- (see fortran/growth/STATUS.md), not copied from solver output.
-- Prints one `PASS curry.<name>` / `FAIL curry.<name> <why>` line per check.
module TestGrowthClassify where

import GrowthClassify
import Control.Search.SetFunctions ( set1, sortValues )
import Data.List ( nub, sort )
import System.Environment ( getArgs )

check :: String -> Bool -> IO Bool
check name ok = do
  putStrLn ((if ok then "PASS curry." else "FAIL curry.") ++ name ++
            (if ok then "" else " assertion_false"))
  return ok

near :: Float -> Float -> Bool
near a b = abs (a - b) < 0.000001

findTuple :: [Tuple] -> Float -> Float -> Float -> Float -> Maybe Tuple
findTuple ts lam eps zf du =
  case [ t | t <- ts, near (tLam t) lam, near (tEps t) eps
           , near (tZForm t) zf, near (tDuty t) du ] of
    (t : _) -> Just t
    []      -> Nothing

main :: IO ()
main = do
  args <- getArgs
  case args of
    (p : _) -> mainAt p
    []      -> mainAt "fixtures/growth/feasible_grid.rec"

-- | Entry point with an explicit record path (used by tests/growth/run.sh,
-- which evaluates this with the absolute path in the PAKCS REPL).
mainAt :: String -> IO ()
mainAt path = do
  ts <- loadGrowth path
  let bench = findTuple ts 1.0 0.1 20.0 1.0
      comp  = findTuple ts 1.5 0.2 20.0 1.0
      weak  = findTuple ts 0.5 0.3 12.0 0.1
      pbh   = findTuple ts 0.5 0.05 25.0 0.5
      ndComp = case comp of
                 Just t  -> nub (sortValues (set1 hypothesis t))
                 Nothing -> []
  rs <- sequence
    [ check "row_count_1200" (length ts == 1200)
    , check "benchmark_tuple_found" (case bench of
            Just _  -> True
            Nothing -> False)
    , check "benchmark_seed_near_497" (case bench of
            Just t  -> tSeedSimple t > 480.0 && tSeedSimple t < 525.0
            Nothing -> False)
    , check "benchmark_heavy_seed_only" (case bench of
            Just t  -> hypothesesOf t == [HeavySeed]
            Nothing -> False)
    , check "competing_hypotheses_alive" (case comp of
            Just t  -> hypothesesOf t == [SuperEddington, Composite]
            Nothing -> False)
    , check "nondet_matches_filter" (case comp of
            Just t  -> sort ndComp == sort (hypothesesOf t)
            Nothing -> False)
    , check "weak_tuple_is_counterexample" (case weak of
            Just t  -> counterexample t && hypothesesOf t == []
            Nothing -> False)
    , check "pbh_range_alive" (case pbh of
            Just t  -> PrimordialBH `elem` hypothesesOf t &&
                       HeavySeed `elem` hypothesesOf t
            Nothing -> False)
    , check "light_seed_exists"
            (any (\t -> LightSeed `elem` hypothesesOf t) ts)
    , check "every_feasible_has_hypothesis"
            (all (\t -> not (feasible t) || not (null (hypothesesOf t))) ts)
    , check "no_infeasible_has_hypothesis"
            (all (\t -> feasible t || null (hypothesesOf t)) ts)
    ]
  if and rs then putStrLn "CURRY_GROWTH_DONE" else putStrLn "CURRY_GROWTH_FAILURES"
