-- Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
-- Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
-- SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
--
-- JWST-LRD TASK 006: the causal graph exposed to the Curry inference engine.
--
-- Input: one LRD-REC-v1 record in format LRD-CAUSAL-GRAPH-v1, written by the
-- Fortran library (fortran/causal/src/causal_serial.f90, FORMAT.md).  This module
-- parses the record strictly (header, length prefixes, bytewise-sorted unique keys),
-- and exposes facts and relations:
--   event g        nondeterministic: some event id
--   kindOf g i     the event kind of id i
--   edge g x y     direct accepted causal edge (relation; x, y may be free)
--   causalBefore g x y   x precedes y: transitive closure of edge (a path >= 1)
--   ancestor g x y       x is a causal ancestor of y (= causalBefore g x y)
--   classification g x y the Fortran light-cone class of the ordered pair
--   rejected g x y r     a rejected edge proposal and its reason
-- Causality is ONLY derived from accepted edges; timestamps are exposed for
-- inspection (timeLo/timeHi) but no relation here uses them.
-- Values are printable ASCII (the Fortran writer enforces this), so a Curry Char
-- equals one byte and the length prefixes can be checked character-wise.
module CausalGraph
  ( Kind(..), Sep(..), Dir(..), Event(..), Graph(..)
  , parseRecord, parseGraph, loadGraph, parseHexFloat
  , event, eventIds, kindOf, edge, causalBefore, ancestor, descendant
  , classification, rejected, timeLo, timeHi, kahnTopo, kindEdgeAllowed
  , ancestorOf, descendantOf, edgePair, causalPair, rejectedFor, emissionId
  ) where

import Data.Char ( isDigit, ord )
import Data.List ( isPrefixOf, sort, nub )

------------------------------------------------------------------------------
-- LRD-REC-v1

type Record = [(String, String)]

-- | Strict LRD-REC-v1 parser.
parseRecord :: String -> Either String Record
parseRecord s
  | not ("LRD-REC-v1\n" `isPrefixOf` s) = Left "bad_header"
  | otherwise = fields (drop 11 s) Nothing
 where
  -- NOTE: Curry rules overlap nondeterministically, so the empty case is an if.
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

------------------------------------------------------------------------------
-- Graph model

data Kind = Emission | Detection | GroundReceipt | ArchivePublication
  deriving (Eq, Ord, Show)

data Sep = Timelike | Lightlike | Spacelike | Indeterminate | InvalidFrame | InvalidInput
  deriving (Eq, Show)

data Dir = Future | Past | DirIndeterminate | DirNA
  deriving (Eq, Show)

data Event = Event
  { evId :: Int, evKind :: Kind, evLabel :: String, evFrame :: Int
  , evT :: (Float, Float), evHasRedshift :: Bool }
  deriving Show

data Graph = Graph
  { gName :: String, gFixture :: String, gEvents :: [Event], gEdges :: [(Int, Int)]
  , gPairs :: [((Int, Int), (Sep, Dir))], gRejected :: [(Int, Int, String)]
  , gTopo :: [Int], gFrames :: [(Int, String, String)] }

parseKind :: String -> Maybe Kind
parseKind s = lookup s [ ("emission", Emission), ("detection", Detection)
                       , ("ground_receipt", GroundReceipt)
                       , ("archive_publication", ArchivePublication) ]

parseSep :: String -> Maybe Sep
parseSep s = lookup s [ ("timelike", Timelike), ("lightlike", Lightlike)
                      , ("spacelike", Spacelike), ("indeterminate", Indeterminate)
                      , ("invalid_frame", InvalidFrame), ("invalid_input", InvalidInput) ]

parseDir :: String -> Maybe Dir
parseDir s = lookup s [ ("future", Future), ("past", Past)
                      , ("indeterminate", DirIndeterminate), ("na", DirNA) ]

-- | Canonical hex-float of the Fortran writer: [-]0x1.<13 hex>p(+|-)E,
-- [-]0x0.<13 hex>p-1022, [-]0x0.0000000000000p+0.  Values are reconstructed as
-- (lead*2^52 + m) * 2^(E-52); exact for normal numbers in PAKCS (SWI floats).
parseHexFloat :: String -> Maybe Float
parseHexFloat str = case str of
  ('-' : r) -> fmap negate (pos r)
  r         -> pos r
 where
  pos r = case r of
    ('0' : 'x' : l : '.' : rest)
      | l `elem` "01" && length mant == 13 && all isHex mant ->
          case drop 13 rest of
            ('p' : sg : ds) | sg `elem` "+-" && not (null ds) && all isDigit ds ->
              let e  = (if sg == '-' then negate else id) (readNat ds)
                  m  = foldl (\a c -> 16 * a + hexVal c) 0 mant
                  lead = if l == '1' then 1 else 0
                  sig = lead * 4503599627370496 + m
                  e2 = (if lead == 1 then e else (-1022)) - 52
              in Just (if sig == 0 then 0.0 else scale2 (fromInt sig) e2)
            _ -> Nothing
     where mant = take 13 rest
    _ -> Nothing
  isHex c = isDigit c || c `elem` "abcdef"
  hexVal c = if isDigit c then ord c - ord '0' else ord c - ord 'a' + 10
  readNat = foldl (\a d -> 10 * a + ord d - ord '0') 0
  -- x * 2^k in steps of 2^500 so no intermediate power overflows; intermediates
  -- stay normal, so only the final step rounds (exact for normal results).
  scale2 x k
    | k > 500    = scale2 (x * (2.0 ^ 500)) (k - 500)
    | k < (-500) = scale2 (x / (2.0 ^ 500)) (k + 500)
    | k >= 0     = x * (2.0 ^ k)
    | otherwise  = x / (2.0 ^ (negate k))

pad6 :: Int -> String
pad6 n = let s = show n in replicate (6 - length s) '0' ++ s

need :: Record -> String -> Either String String
need r k = maybe (Left ("missing:" ++ k)) Right (lookup k r)

needInt :: Record -> String -> Either String Int
needInt r k = need r k >>= \v ->
  if not (null v) && all isDigit v && not (length v > 1 && head v == '0')
    then Right (foldl (\a d -> 10 * a + ord d - ord '0') 0 v)
    else Left ("bad_int:" ++ k)

needWith :: (String -> Maybe a) -> Record -> String -> Either String a
needWith p r k = need r k >>= \v -> maybe (Left ("bad_value:" ++ k)) Right (p v)

-- | Build the graph from a parsed record.
parseGraph :: String -> Either String Graph
parseGraph s = do
  r   <- parseRecord s
  fmt <- need r "format"
  if fmt /= "LRD-CAUSAL-GRAPH-v1" then Left "bad_format" else Right ()
  name <- need r "name"
  fx   <- need r "fixture"
  nf   <- needInt r "n_frames"
  ne   <- needInt r "n_events"
  nd   <- needInt r "n_edges"
  nr   <- needInt r "n_rejected"
  frames <- mapM (frameAt r) [1 .. nf]
  evs  <- mapM (eventAt r) [1 .. ne]
  eds  <- mapM (edgeAt r) [1 .. nd]
  rjs  <- mapM (rejAt r) [1 .. nr]
  let ids = map evId evs
  prs  <- mapM (pairAt r) [ (a, b) | a <- ids, b <- ids, a /= b ]
  topo <- need r "topo"
  return (Graph name fx evs eds prs rjs (map readI (splitOn ',' topo)) frames)
 where
  frameAt r i = let p = "frame." ++ pad6 i ++ "." in do
    fid <- needInt r (p ++ "id")
    k   <- need r (p ++ "kind")
    n   <- need r (p ++ "name")
    return (fid, k, n)
  eventAt r i = let p = "event." ++ pad6 i ++ "." in do
    eid <- needInt r (p ++ "id")
    k   <- needWith parseKind r (p ++ "kind")
    lb  <- need r (p ++ "label")
    fr  <- needInt r (p ++ "frame")
    tlo <- needWith parseHexFloat r (p ++ "t_s_lo")
    thi <- needWith parseHexFloat r (p ++ "t_s_hi")
    hz  <- need r (p ++ "has_redshift")
    return (Event eid k lb fr (tlo, thi) (hz == "1"))
  edgeAt r i = let p = "edge." ++ pad6 i ++ "." in do
    a <- needInt r (p ++ "src")
    b <- needInt r (p ++ "dst")
    return (a, b)
  rejAt r i = let p = "rejected." ++ pad6 i ++ "." in do
    a  <- needInt r (p ++ "src")
    b  <- needInt r (p ++ "dst")
    rs <- need r (p ++ "reason")
    return (a, b, rs)
  pairAt r (a, b) = do
    v <- need r ("pair." ++ pad6 a ++ "." ++ pad6 b)
    let (sp, dr) = break (== '/') v
    sep <- maybe (Left ("bad_pair:" ++ v)) Right (parseSep sp)
    dir <- maybe (Left ("bad_pair:" ++ v)) Right (parseDir (drop 1 dr))
    return ((a, b), (sep, dir))
  readI = foldl (\a d -> 10 * a + ord d - ord '0') 0
  splitOn c xs = case break (== c) xs of
    (w, [])       -> [w]
    (w, _ : rest) -> w : splitOn c rest

loadGraph :: String -> IO Graph
loadGraph path = do
  s <- readFile path
  case parseGraph s of
    Left err -> error ("CausalGraph.loadGraph " ++ path ++ ": " ++ err)
    Right g  -> return g

------------------------------------------------------------------------------
-- Facts and relations (nondeterministic)

-- | Some event (nondeterministic choice over all events).
event :: Graph -> Event
event g = anyOf (gEvents g)

eventIds :: Graph -> [Int]
eventIds g = map evId (gEvents g)

-- | Kind of an event id (fails if the id is unknown).
kindOf :: Graph -> Int -> Kind
kindOf g i = case [ evKind e | e <- gEvents g, evId e == i ] of
  [k] -> k

timeLo, timeHi :: Graph -> Int -> Float
timeLo g i = case [ fst (evT e) | e <- gEvents g, evId e == i ] of [t] -> t
timeHi g i = case [ snd (evT e) | e <- gEvents g, evId e == i ] of [t] -> t

-- | Direct accepted causal edge; usable with free x and/or y.
edge :: Graph -> Int -> Int -> Bool
edge g x y = (x, y) =:= anyOf (gEdges g)

-- | Causal precedence: a path of length >= 1 along accepted edges.
-- Terminates because the Fortran DAG rejected every cycle.
causalBefore :: Graph -> Int -> Int -> Bool
causalBefore g x y = edge g x y
causalBefore g x y = edge g x z && causalBefore g z y  where z free

-- | x is a causal ancestor of y.
ancestor :: Graph -> Int -> Int -> Bool
ancestor = causalBefore

-- | y is a causal descendant of x.
descendant :: Graph -> Int -> Int -> Bool
descendant g x y = causalBefore g x y

-- | Light-cone class (separation, direction) of an ordered pair, from Fortran.
classification :: Graph -> Int -> Int -> (Sep, Dir)
classification g x y = case lookup (x, y) (gPairs g) of
  Just c -> c

-- | A rejected proposal x -> y with its reason token.
rejected :: Graph -> Int -> Int -> String -> Bool
rejected g x y r = (x, y, r) =:= anyOf (gRejected g)

-- | The direct-edge kind policy (mirrors causal_events.f90 kind_edge_allowed).
kindEdgeAllowed :: Kind -> Kind -> Bool
kindEdgeAllowed a b = (a, b) `elem` [ (Emission, Detection), (Detection, GroundReceipt)
                                    , (GroundReceipt, ArchivePublication) ]

-- | Kahn topological order with the smallest event (insertion) index first;
-- must reproduce the Fortran `topo` field.
kahnTopo :: Graph -> [Int]
kahnTopo g = go (eventIds g) (gEdges g)
 where
  go pending es = if null pending then [] else
    case [ v | v <- pending, null [ () | (_, d) <- es, d == v ] ] of
      []      -> []           -- cycle: cannot happen for a loaded graph
      (v : _) -> v : go (filter (/= v) pending) (filter ((/= v) . fst) es)

------------------------------------------------------------------------------
-- Value-returning query forms.  Each declares its free variables locally, so it
-- can be encapsulated with set functions (PAKCS suspends on free variables
-- introduced by `let .. free` inside getAllValues; these forms avoid that).

-- | Some causal ancestor of y.
ancestorOf :: Graph -> Int -> Int
ancestorOf g y | ancestor g x y = x  where x free

-- | Some causal descendant of x.
descendantOf :: Graph -> Int -> Int
descendantOf g x | descendant g x y = y  where y free

-- | Some accepted direct edge.
edgePair :: Graph -> (Int, Int)
edgePair g | edge g x y = (x, y)  where x, y free

-- | Some pair in the causal order (transitive closure).
causalPair :: Graph -> (Int, Int)
causalPair g | causalBefore g x y = (x, y)  where x, y free

-- | Some rejected proposal with the given reason.
rejectedFor :: Graph -> String -> (Int, Int)
rejectedFor g r | rejected g x y r = (x, y)  where x, y free

-- | Some event id of kind Emission.
emissionId :: Graph -> Int
emissionId g = let e = event g in if evKind e == Emission then evId e else failed
