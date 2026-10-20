-- Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
-- SPDX-License-Identifier: AGPL-3.0-only. Also subject to the SnapKitty Opaque License (dual license).
-- See LICENSE and SNAPKITTY_OPAQUE_LICENSE.md (repository root and curry/).
--
-- Command-line front end of the Curry LRD research engine (TASK 012).
-- All output is plain text on stdout: LRD-REC-v1 streams or s-expressions
-- (curry/GRAPH-FORMAT.md). Errors are raised with `error`, which PAKCS reports on stderr with a nonzero exit status.
--
--   lrd-engine kv2rec FILE.kv                 key=value source -> LRD-REC-v1 stream
--   lrd-engine validate FILE                  parse, check round trip and references
--   lrd-engine ingest-t001 MANIFEST.rec REFERENCE.rec   real t001 outputs -> KB stream
--   lrd-engine rules                          rule base, counter-rules, literature
--   lrd-engine search FILE OBS DEPTH K        hypothesis search (free-variable head)
--   lrd-engine compare FILE FEATURE DEPTH K   compare explanations for one feature
--   lrd-engine contradictions FILE DEPTH K    contradiction detection, all observations
--   lrd-engine graph FILE DEPTH K             full evidence graph

module LrdEngine where

import Curry.Compiler.Distribution
import Data.Char (isSpace, isDigit)
import Data.List (isPrefixOf, nub, intercalate)
import System.Environment (getArgs)
import System.IO
import Evidence
import Engine
import LrdRec
import Qty
import Rules
import SExpr
import T001

engineVersion :: String
engineVersion = "0.1.0"

compilerId :: String
compilerId = curryCompiler ++ "-" ++ show curryCompilerMajorVersion ++ "."
          ++ show curryCompilerMinorVersion ++ "." ++ show curryCompilerRevisionVersion

runtimeId :: String
runtimeId = curryRuntime ++ "-" ++ show curryRuntimeMajorVersion ++ "."
         ++ show curryRuntimeMinorVersion

die :: String -> IO ()
die msg = error ("lrd-engine: " ++ msg)

main :: IO ()
main = do
  args <- getArgs
  case args of
    ["kv2rec", f]                 -> cmdKv2Rec f
    ["validate", f]               -> cmdValidate f
    ["rules"]                     -> putStr (render rulesSX)
    ["ingest-t001", m, r]         -> cmdIngestT001 m r
    ["search", f, o, d, k]        -> withKB f d k (\cfg kb n -> cmdSearch f n cfg kb o)
    ["compare", f, fid, d, k]     -> withKB f d k (\cfg kb n -> cmdCompare f n cfg kb fid)
    ["contradictions", f, d, k]   -> withKB f d k (\cfg kb n -> cmdContra f n cfg kb)
    ["graph", f, d, k]            -> withKB f d k (\cfg kb n -> cmdGraph f n cfg kb)
    _ -> die "usage: kv2rec F | ingest-t001 MANIFEST REFERENCE | validate F | rules | search F OBS DEPTH K | compare F FEAT DEPTH K | contradictions F DEPTH K | graph F DEPTH K"

------------------------------------------------------------------------------
-- Input

-- | key=value source: one field per line, records separated by blank lines,
--   lines starting with '#' are comments.
parseKV :: String -> Either String [Record]
parseKV s = mapM toRec (groups (filter (not . isComment) (lines s)))
 where
  isComment l = "#" `isPrefixOf` l
  groups ls = case dropWhile blank ls of
    [] -> []
    ls' -> let (g, rest) = break blank ls' in g : groups rest
  blank l = all isSpace l
  toRec ls = do
    fs <- mapM kv ls
    let ks = map fst fs
    if length (nub ks) /= length ks then Left "duplicate key in kv record" else Right fs
  kv l = case break (== '=') l of
    (k, '=' : v) | not (null k) -> Right (k, v)
    _ -> Left ("bad kv line: " ++ l)

cmdKv2Rec :: String -> IO ()
cmdKv2Rec f = do
  s <- readFile f
  case parseKV s of
    Left e   -> die e
    Right rs -> putStr (serializeStream rs)

loadRecords :: String -> IO (Either String (String, [Record]))
loadRecords f = do
  s <- readFile f
  return (fmap (\rs -> (s, rs)) (parseStream s))

withKB :: String -> String -> String -> (Cfg -> KB -> Int -> IO ()) -> IO ()
withKB f ds ks act =
  case (parseNatS ds, parseQ ks) of
    (Just d, Just k) | d > 0 && gtQ k (mkQ 0 1) -> do
      r <- loadRecords f
      case r of
        Left e -> die ("parse error: " ++ e)
        Right (_, rs) -> case buildKB rs of
          Left e   -> die ("invalid knowledge base: " ++ e)
          Right kb -> act (Cfg k d) kb (length rs)
    _ -> die "DEPTH must be a positive integer and K a positive LRD-REC rational"

parseNatS :: String -> Maybe Int
parseNatS s = case parseQ s of
  Just q | qDen q == 1 -> Just (qNum q)
  _ -> Nothing

------------------------------------------------------------------------------
-- Commands

cmdValidate :: String -> IO ()
cmdValidate f = do
  r <- loadRecords f
  case r of
    Left e -> die ("parse error: " ++ e)
    Right (s, rs) -> do
      let rt = serializeStream rs == s
      case buildKB rs of
        Left e -> die ("invalid knowledge base: " ++ e)
        Right kb -> putStr (render (tag "lrd-validate"
          [ tag "path" [str f], tag "records" [sym (show (length rs))]
          , tag "observations" [sym (show (length (kbObs kb)))]
          , tag "spectral-features" [sym (show (length (kbFeats kb)))]
          , tag "provenance" [sym (show (length (kbProvs kb)))]
          , tag "synthetic-records" [sym (show (length (filter isSynthetic rs)))]
          , tag "canonical-roundtrip" [sym (if rt then "ok" else "mismatch")] ]))
      if rt then return () else die "canonical round trip mismatch"

header :: String -> String -> Int -> Cfg -> KB -> [SX]
header q f n cfg kb =
  [ tag "format" [sym "LRD-TRACE-SEXP-v1"]
  , tag "engine" [sym "lrd-curry-engine", sym engineVersion]
  , tag "compiler" [sym compilerId, sym runtimeId]
  , tag "query" [sym q]
  , tag "params" [tag "k-sigma" [sym (showQ (cK cfg))], tag "depth-bound" [sym (show (cDepth cfg))]]
  , tag "input" [ tag "path" [str f], tag "records" [sym (show n)]
                , tag "synthetic" [sym (if any isSynthetic (kbAll kb) then "yes" else "no")] ]
  , tag "epistemic-note" [str "derivable-under-assumptions means the hypothesis follows from the rules, data and listed assumptions; it is not scientific confirmation; not-derivable means no derivation exists from these records within the bound, which is not a refutation"] ]

cmdSearch :: String -> Int -> Cfg -> KB -> String -> IO ()
cmdSearch f n cfg kb o
  | o `notElem` obsIds kb = die ("unknown observation " ++ o)
  | otherwise = putStr (render (tag "lrd-trace"
      (header "hypothesis-search" f n cfg kb
       ++ [ tag "obs" [sym o]
          , tag "summary" (map (sxSummary . summarize cfg kb o) allHyps)
          , tag "derivations" (map sxDeriv (searchAll cfg kb o))
          , tag "contradictions" (contradictions cfg kb o)
          , tag "obligations" (obligations cfg kb o) ])))

cmdCompare :: String -> Int -> Cfg -> KB -> String -> IO ()
cmdCompare f n cfg kb fid = case compareFeature cfg kb fid of
  Left e   -> die e
  Right sx -> putStr (render (tag "lrd-trace" (header "compare-explanations" f n cfg kb ++ [sx])))

cmdContra :: String -> Int -> Cfg -> KB -> IO ()
cmdContra f n cfg kb = putStr (render (tag "lrd-trace"
  (header "contradiction-detection" f n cfg kb
   ++ [ tag "contradictions" (concatMap (contradictions cfg kb) (obsIds kb)) ])))

cmdGraph :: String -> Int -> Cfg -> KB -> IO ()
cmdGraph f n cfg kb = putStr (render (tag "lrd-trace"
  (header "evidence-graph" f n cfg kb ++ [graphSX cfg kb])))

rulesSX :: SX
rulesSX = tag "lrd-rulebase"
  [ tag "format" [sym "LRD-TRACE-SEXP-v1"]
  , tag "engine" [sym "lrd-curry-engine", sym engineVersion]
  , tag "literature" (map sxLiterature literature)
  , tag "assumptions" (map sxAssumption assumptions)
  , tag "rules" (map sxRule rules)
  , tag "counter-rules" (map sxCounterRule counterRules)
  , tag "exclusive" [ tag "pair" [sym (hypName a), sym (hypName b), str role] | (a, b, role) <- exclusivePairs ] ]

-- | Real-data adapter: t001 manifest + Fortran reference output -> KB stream.
--   Each input must be a single LRD-REC-v1 record.
cmdIngestT001 :: String -> String -> IO ()
cmdIngestT001 mf rf = do
  m <- loadRecords mf
  r <- loadRecords rf
  case (m, r) of
    (Right (_, [man]), Right (_, [ref])) -> case ingestT001 man ref of
      Left e   -> die ("ingest-t001: " ++ e)
      Right rs -> case buildKB rs of
        Left e  -> die ("ingest-t001 produced an invalid knowledge base: " ++ e)
        Right _ -> putStr (serializeStream rs)
    (Left e, _) -> die ("manifest: " ++ e)
    (_, Left e) -> die ("reference: " ++ e)
    _ -> die "ingest-t001: manifest and reference must each hold exactly one record"
