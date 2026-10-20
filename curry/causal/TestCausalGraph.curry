-- Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
-- Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
-- SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
--
-- Loads the SYNTHETIC fixture written by the Fortran tests and checks answers that
-- are known analytically (see tests/causal/fixture_graph.f90).  Prints one
-- `PASS curry.<name>` / `FAIL curry.<name> <why>` line per check.
module TestCausalGraph where

import CausalGraph
import Control.Search.SetFunctions ( set1, set2, sortValues, isEmpty )
import Data.List ( nub )
import System.Environment ( getArgs )

check :: String -> Bool -> IO Bool
check name ok = do
  putStrLn ((if ok then "PASS curry." else "FAIL curry.") ++ name ++ (if ok then "" else " assertion_false"))
  return ok

main :: IO ()
main = do
  args <- getArgs
  let path = case args of
               (p : _) -> p
               []      -> "out/SYNTHETIC_causal_fixture.lrdrec"
  g <- loadGraph path
  let anc4     = nub (sortValues (set2 ancestorOf g 4))
      desc1    = nub (sortValues (set2 descendantOf g 1))
      pairs    = nub (sortValues (set1 causalPair g))
      emis     = nub (sortValues (set1 emissionId g))
      edgesAll = nub (sortValues (set1 edgePair g))
      rejSpace = nub (sortValues (set2 rejectedFor g "spacelike"))
      before15 = not (1 `elem` nub (sortValues (set2 ancestorOf g 5)))
  rs <- sequence
    [ check "fixture_is_synthetic" (gFixture g == "SYNTHETIC" && take 9 (gName g) == "SYNTHETIC")
    , check "eleven_events" (length (gEvents g) == 11)
    , check "four_kinds_distinct" (length (nub (map evKind (gEvents g))) == 4)
    , check "kind_of_1_emission" (kindOf g 1 == Emission)
    , check "kind_of_4_archive_publication" (kindOf g 4 == ArchivePublication)
    , check "edges_six" (edgesAll == [(1,2),(2,3),(2,10),(3,4),(5,6),(6,4)])
    , check "ancestors_of_4" (anc4 == [1,2,3,5,6])
    , check "descendants_of_1" (desc1 == [2,3,4,10])
    , check "causal_before_closure_size" (length pairs == 11)
    , check "emissions" (emis == [1,7,11])
    , check "not_causal_before_1_5" before15
    , check "t1_lt_t5_yet_not_causal" (timeHi g 1 < timeLo g 5 && before15)
    , check "class_1_2_lightlike_future" (classification g 1 2 == (Lightlike, Future))
    , check "class_1_5_spacelike" (fst (classification g 1 5) == Spacelike)
    , check "class_1_8_indeterminate" (fst (classification g 1 8) == Indeterminate)
    , check "class_7_2_invalid_frame" (classification g 7 2 == (InvalidFrame, DirNA))
    , check "class_2_10_timelike_future_via_boost" (classification g 2 10 == (Timelike, Future))
    , check "rejected_spacelike_1_5" (rejSpace == [(1,5)])
    , check "every_edge_future_cone" (all (\(a,b) -> fst (classification g a b) `elem` [Timelike, Lightlike]
                                                     && snd (classification g a b) == Future) edgesAll)
    , check "every_edge_kind_allowed" (all (\(a,b) -> kindEdgeAllowed (kindOf g a) (kindOf g b)) edgesAll)
    , check "topo_matches_fortran" (kahnTopo g == gTopo g && gTopo g == [1,2,3,5,6,4,7,8,9,10,11])
    , check "redshift_event_7_isolated" (null [ () | (a,b) <- edgesAll, a == 7 || b == 7 ])
    , check "parser_rejects_unsorted" (isLeft (parseRecord "LRD-REC-v1\n1:b1:2\n1:a1:1\n"))
    , check "parser_rejects_empty_key" (parseRecord "LRD-REC-v1\n0:1:x\n" == Left "empty_key")
    , check "parser_rejects_leading_zero" (isLeft (parseRecord "LRD-REC-v1\n01:a1:1\n"))
    , check "hexfloat_c" (parseHexFloat "0x1.1de784a000000p+28" == Just 299792458.0)
    ]
  putStrLn ("# curry: " ++ show (length (filter id rs)) ++ " passed, "
            ++ show (length (filter not rs)) ++ " failed")
 where
  isLeft e = case e of
    Left _  -> True
    Right _ -> False
