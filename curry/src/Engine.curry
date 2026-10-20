-- Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
-- SPDX-License-Identifier: AGPL-3.0-only. Also subject to the SnapKitty Opaque License (dual license).
-- See LICENSE and SNAPKITTY_OPAQUE_LICENSE.md (repository root and curry/).
--
-- Inference engine: nondeterministic, depth-bounded backward chaining over
-- the Horn rules in Rules.curry, evaluation of counterevidence, contradiction
-- detection, proof-obligation generation, and trace / graph extraction.
--
-- Epistemic rule enforced throughout: the strongest status any hypothesis can
-- reach is `derivable-under-assumptions`. There is no "confirmed" status.

module Engine
  ( Cfg(..), Deriv(..), PremProof(..)
  , derive, derivations, searchAll, summarize, Summary(..)
  , counterFindings, contradictions, obligations
  , sxDeriv, sxSummary, sxContradiction, sxObligation, sxRule, sxCounterRule
  , sxLiterature, sxAssumption, compareFeature, graphSX, statusName
  ) where

import Control.Search.SetFunctions
import Data.List (nub, sortBy, isPrefixOf, intercalate)
import Data.Maybe (isJust)
import Evidence
import LrdRec
import Qty
import Rules
import SExpr

-- | Engine parameters. cK: number of sigmas for uncertainty grading and for
--   data-consistency tests (a methodological choice, not a literature value).
--   cDepth: maximal height of a derivation tree (bounded search).
data Cfg = Cfg { cK :: Q, cDepth :: Int }

data PremProof
  = PFact String FactPat String Grade  -- feature record id, test, evidence, grade
  | PSub Deriv                          -- proved sub-hypothesis
  | PCut Hyp                            -- sub-goal cut off by the depth bound

data Deriv = Deriv String Hyp String [PremProof]   -- rule id, head, obs id, body

------------------------------------------------------------------------------
-- Fact tests (nondeterministic over the matching feature records)

proveFact :: Q -> KB -> String -> FactPat -> (String, String, Grade)
proveFact k kb o p = case p of
  NumGT fe fl thr -> numTest (anyOf (featuresOf kb o fe)) fl (gradeGT k) thr
  NumLT fe fl thr -> numTest (anyOf (featuresOf kb o fe)) fl (gradeLT k) thr
  StatusIs fe st  -> statusTest (anyOf (featuresOf kb o fe)) st

numTest :: Record -> String -> (Q -> Q -> Q -> Maybe Grade) -> Q -> (String, String, Grade)
numTest r fl g thr =
  case (field fl r >>= parseQ, field (fl ++ "_sigma") r >>= parseQ) of
    (Just v, Just s) -> case g v s thr of
      Just gr -> (recId r, fl ++ "=" ++ showQ v ++ " sigma=" ++ showQ s, gr)
      Nothing -> failed
    _ -> failed

statusTest :: Record -> String -> (String, String, Grade)
statusTest r st
  | field "status" r == Just st = (recId r, "status=" ++ st, Robust)
  | otherwise                   = failed

------------------------------------------------------------------------------
-- Backward chaining

-- | One derivation of hypothesis h for observation o within depth d.
--   Nondeterministic: alternative clauses and alternative supporting records
--   give alternative derivations; failure means "no derivation here".
--   h may be a free variable (see `searchAll`).
derive :: Cfg -> KB -> Int -> String -> Hyp -> Deriv
derive cfg kb d o h = d > 0 &> (id $!! Deriv (rId r) (rHead r) o (map prove (rBody r)))
 where
  r = ruleFor h
  prove (Fact p) = let (fid, ev, g) = proveFact (cK cfg) kb o p in PFact fid p ev g
  prove (Sub h')
    | d <= 1    = PCut h'
    | otherwise = PSub (derive cfg kb (d - 1) o h')

-- Normal-form forcing needs these instances to be data; derived Show keeps
-- them printable for debugging.

-- | All derivations of h for o, in a canonical (sorted) order.
derivations :: Cfg -> KB -> String -> Hyp -> [Deriv]
derivations cfg kb o h =
  canonical (vals (set5 derive cfg kb (cDepth cfg) o h))

-- | Hypothesis search: the head is a *free variable*, so the search itself
--   enumerates which hypotheses can be derived.
anyDerivation :: Cfg -> KB -> Int -> String -> Deriv
anyDerivation cfg kb d o = derive cfg kb d o h where h free

searchAll :: Cfg -> KB -> String -> [Deriv]
searchAll cfg kb o = canonical (vals (set4 anyDerivation cfg kb (cDepth cfg) o))

-- | Values of a set function as a list (order irrelevant: callers sort).
vals :: Values a -> [a]
vals = sortValuesBy (\_ _ -> True)

canonical :: [Deriv] -> [Deriv]
canonical ds = map snd (dedupSorted fst (sortBy (\a b -> fst a <= fst b) [ (render (sxDeriv d), d) | d <- ds ]))

-- | Drop adjacent duplicates (by key) from a sorted list. Written with a
--   case expression so that it is deterministic (Curry rules overlap).
dedupSorted :: (a -> String) -> [a] -> [a]
dedupSorted key xs = case xs of
  (x:y:zs) -> if key x == key y then dedupSorted key (y:zs)
                                else x : dedupSorted key (y:zs)
  _        -> xs

hasCut :: Deriv -> Bool
hasCut (Deriv _ _ _ ps) = any c ps
 where c p = case p of
         PCut _  -> True
         PSub d' -> hasCut d'
         _       -> False

gradeOfD :: Deriv -> Grade
gradeOfD (Deriv _ _ _ ps) = foldr minGrade Robust (map g ps)
 where g (PFact _ _ _ gr) = gr
       g (PSub d')        = gradeOfD d'
       g (PCut _)         = Marginal

rulesUsed :: Deriv -> [String]
rulesUsed (Deriv rid _ _ ps) = rid : concatMap f ps
 where f p = case p of
         PSub d' -> rulesUsed d'
         _       -> []

assumptionsOf :: Deriv -> [String]
assumptionsOf d = nub (concatMap ruleAs (rulesUsed d))
 where ruleAs rid = concat [ rAssumptions r | r <- rules, rId r == rid ]

recordsUsed :: Deriv -> [String]
recordsUsed (Deriv _ _ _ ps) = concatMap f ps
 where f (PFact fid _ _ _) = [fid]
       f (PSub d')         = recordsUsed d'
       f (PCut _)          = []

------------------------------------------------------------------------------
-- Summaries

data Summary = Summary
  { sObs    :: String
  , sHyp    :: Hyp
  , sStatus :: String       -- derivable-under-assumptions | undecided-at-bound | not-derivable
  , sGrade  :: Maybe Grade  -- best grade among complete derivations
  , sDerivs :: [Deriv] }

statusName :: Summary -> String
statusName = sStatus

summarize :: Cfg -> KB -> String -> Hyp -> Summary
summarize cfg kb o h =
  let ds       = derivations cfg kb o h
      complete = filter (not . hasCut) ds
      st | not (null complete) = "derivable-under-assumptions"
         | not (null ds)       = "undecided-at-bound"
         | otherwise           = "not-derivable"
      gr | null complete = Nothing
         | any ((== Robust) . gradeOfD) complete = Just Robust
         | otherwise = Just Marginal
  in Summary o h st gr ds

isDerivable :: Summary -> Bool
isDerivable s = sStatus s == "derivable-under-assumptions"

------------------------------------------------------------------------------
-- Counterevidence

-- | (counter rule, supporting record id, evidence, grade) for o and hypothesis h.
counterFindings :: Cfg -> KB -> String -> Hyp -> [(CounterRule, String, String, Grade)]
counterFindings cfg kb o h =
  concat [ map (\(fid, ev, g) -> (c, fid, ev, g))
             (sortBy (\(a,_,_) (b,_,_) -> a <= b)
                (vals (set4 proveFact (cK cfg) kb o (ceWhen c))))
         | c <- counterRules, ceTarget c == h ]

------------------------------------------------------------------------------
-- Contradictions

-- | All contradictions for observation o, as s-expressions:
--   * assumption-attacked: a derivable hypothesis has counterevidence
--   * exclusive-both-derivable: two mutually exclusive hypotheses derivable
--   * data-inconsistent: two records disagree beyond k sigma (numeric) or
--     carry different categorical status for the same feature
contradictions :: Cfg -> KB -> String -> [SX]
contradictions cfg kb o = attacked ++ exclusive ++ dataInc
 where
  sums = [ summarize cfg kb o h | h <- allHyps ]
  derivable h = any (\s -> sHyp s == h && isDerivable s) sums
  attacked =
    [ tag "contradiction"
        [ tag "kind" [sym "assumption-attacked"], tag "obs" [sym o]
        , tag "hypothesis" [sym (hypName h)], tag "counter-rule" [sym (ceId c)]
        , tag "attacks" [sym (ceAttacks c)], tag "evidence" [sym fid, str ev]
        , tag "grade" [sym (showGrade g)]
        , tag "resolution" [sym "none-engine-does-not-adjudicate"] ]
    | h <- allHyps, derivable h, (c, fid, ev, g) <- counterFindings cfg kb o h ]
  exclusive =
    [ tag "contradiction"
        [ tag "kind" [sym "exclusive-both-derivable"], tag "obs" [sym o]
        , tag "hypotheses" [sym (hypName a), sym (hypName b)], tag "role" [str role]
        , tag "resolution" [sym "underdetermined-by-current-evidence"] ]
    | (a, b, role) <- exclusivePairs, derivable a, derivable b ]
  feats = filter (\r -> field "obs" r == Just o) (kbFeats kb)
  pairs = [ (x, y) | (i, x) <- zip [0 :: Int ..] feats, (j, y) <- zip [0 ..] feats
                   , i < j, field "feature" x == field "feature" y ]
  dataInc = concatMap pairIssues pairs
  pairIssues (x, y) = numIssues x y ++ statusIssues x y
  numIssues x y =
    [ tag "contradiction"
        [ tag "kind" [sym "data-inconsistent"], tag "obs" [sym o]
        , tag "feature" [sym (fieldOr "?" "feature" x)], tag "field" [sym k]
        , tag "records" [sym (recId x), sym (recId y)]
        , tag "values" [str (showQ v1 ++ " sigma=" ++ showQ s1), str (showQ v2 ++ " sigma=" ++ showQ s2)]
        , tag "k-sigma" [sym (showQ (cK cfg))]
        , tag "resolution" [sym "none-engine-does-not-adjudicate"] ]
    | (k, _) <- x, not ("_sigma" `isSuffix` k), k `notElem` metaKeys
    , Just v1 <- [field k x >>= parseQ], Just s1 <- [field (k ++ "_sigma") x >>= parseQ]
    , Just v2 <- [field k y >>= parseQ], Just s2 <- [field (k ++ "_sigma") y >>= parseQ]
    , disagree (cK cfg) v1 s1 v2 s2 ]
  statusIssues x y =
    [ tag "contradiction"
        [ tag "kind" [sym "data-inconsistent"], tag "obs" [sym o]
        , tag "feature" [sym (fieldOr "?" "feature" x)], tag "field" [sym "status"]
        , tag "records" [sym (recId x), sym (recId y)], tag "values" [str a, str b]
        , tag "resolution" [sym "none-engine-does-not-adjudicate"] ]
    | Just a <- [field "status" x], Just b <- [field "status" y], a /= b ]

metaKeys :: [String]
metaKeys = ["id", "kind", "obs", "feature", "provenance", "synthetic", "status", "note", "unit"]

isSuffix :: String -> String -> Bool
isSuffix suf s = reverse suf `isPrefixOf` reverse s

------------------------------------------------------------------------------
-- Proof obligations

-- | Obligations: open citations (global), unverified assumptions of every
--   derivable hypothesis, and depth-bound cut-offs.
obligations :: Cfg -> KB -> String -> [SX]
obligations cfg kb o = map oblSX (obligationsD cfg kb o)

data Obl = Obl String String [String] String

oblSX :: Obl -> SX
oblSX (Obl i k ts w) = sxObligation i k ts w

oblKey :: Obl -> String
oblKey (Obl i _ _ _) = i

obligationsD :: Cfg -> KB -> String -> [Obl]
obligationsD cfg kb o = obligationsFrom cfg o [ summarize cfg kb o h | h <- allHyps ] ++ uncertaintyObligations kb o

-- | A numeric field that a rule tests but that carries no `<field>_sigma`
--   cannot support a premise (uncertainty must be explicit); each such
--   field is an open obligation on the record.
uncertaintyObligations :: KB -> String -> [Obl]
uncertaintyObligations kb o =
  nubObl [ Obl ("OBL-UNCERTAINTY:" ++ recId fr ++ ":" ++ fl) "missing-uncertainty" [recId fr]
               (fl ++ " is present but " ++ fl ++ "_sigma is not; rules testing it cannot use this record until an uncertainty is measured")
         | r <- rules, Fact p <- rBody r, Just (fe, fl) <- [numPat p]
         , fr <- featuresOf kb o fe, field fl fr /= Nothing, field (fl ++ "_sigma") fr == Nothing ]
 where
  numPat p = case p of
    NumGT fe fl _ -> Just (fe, fl)
    NumLT fe fl _ -> Just (fe, fl)
    _             -> Nothing
  nubObl xs = dedupSorted oblKey (sortOnKey oblKey (xs ++ lsf))
  lsf = [ Obl ("OBL-LSF:" ++ recId fr) "instrumental-broadening-uncorrected" [recId fr]
            ("record states fwhm_correction=" ++ c ++ "; a line width compared with a physical threshold needs the line-spread function removed")
        | fr <- kbFeats kb, field "obs" fr == Just o
        , Just c <- [field "fwhm_correction" fr], "uncorrected" `isPrefixOf` c ]

-- | Obligations for one observation from precomputed summaries.
obligationsFrom :: Cfg -> String -> [Summary] -> [Obl]
obligationsFrom cfg o sums = cites ++ assume ++ bound
 where
  cites = [ Obl oid "open-citation" [rid] why | (oid, rid, why) <- citationObligations ]
  assume =
    [ Obl ("OBL-ASSUME:" ++ o ++ ":" ++ hypName (sHyp s) ++ ":" ++ a) "unverified-assumption"
        ["HYP:" ++ o ++ ":" ++ hypName (sHyp s)] (assumptionText a)
    | s <- sums, isDerivable s
    , a <- nub (concatMap assumptionsOf (filter (not . hasCut) (sDerivs s))) ]
  bound =
    [ Obl ("OBL-BOUND:" ++ o ++ ":" ++ hypName (sHyp s)) "search-bound-reached"
        ["HYP:" ++ o ++ ":" ++ hypName (sHyp s)]
        ("derivation needs depth > " ++ show (cDepth cfg) ++ "; rerun with a larger bound")
    | s <- sums, sStatus s == "undecided-at-bound" ]

sxObligation :: String -> String -> [String] -> String -> SX
sxObligation oid kind targets why =
  tag "obligation" [ tag "id" [sym oid], tag "kind" [sym kind]
                   , tag "targets" (map sym targets), tag "text" [str why] ]

------------------------------------------------------------------------------
-- Trace rendering

sxFact :: FactPat -> SX
sxFact (NumGT fe fl t) = tag "test" [sym fe, sym fl, sym ">", sym (showQ t)]
sxFact (NumLT fe fl t) = tag "test" [sym fe, sym fl, sym "<", sym (showQ t)]
sxFact (StatusIs fe s) = tag "test" [sym fe, sym "status", sym "=", sym s]

sxDeriv :: Deriv -> SX
sxDeriv d@(Deriv rid h o ps) =
  tag "derivation"
    ([ tag "hypothesis" [sym (hypName h)], tag "kind" [sym (showKind (hypKind h))]
     , tag "obs" [sym o], tag "rule" [sym rid]
     , tag "status" [sym (if hasCut d then "undecided-at-bound" else "derivable-under-assumptions")]
     , tag "grade" [sym (if hasCut d then "n/a" else showGrade (gradeOfD d))]
     , tag "rule-assumes" (map sym (concat [ rAssumptions r | r <- rules, rId r == rid ])) ]
     ++ map prem ps)
 where
  prem (PFact fid p ev g) = tag "premise" [sxFact p, tag "record" [sym fid], tag "evidence" [str ev], tag "grade" [sym (showGrade g)]]
  prem (PSub d')          = tag "premise" [sxDeriv d']
  prem (PCut h')          = tag "premise" [tag "cut-at-bound" [sym (hypName h')]]

sxSummary :: Summary -> SX
sxSummary s =
  tag "hypothesis"
    [ tag "name" [sym (hypName (sHyp s))], tag "kind" [sym (showKind (hypKind (sHyp s)))]
    , tag "status" [sym (sStatus s)]
    , tag "grade" [sym (maybe "n/a" showGrade (sGrade s))]
    , tag "derivations" [sym (show (length (sDerivs s)))] ]

sxCitation :: Citation -> SX
sxCitation (Cited ids loc)     = tag "citation" [tag "verified" (map sym ids), tag "locator" [str loc]]
sxCitation (OpenCitation o why) = tag "citation" [tag "open-obligation" [sym o], tag "note" [str why]]

sxPrem :: Premise -> SX
sxPrem (Fact p) = sxFact p
sxPrem (Sub h)  = tag "goal" [sym (hypName h)]

sxRule :: Rule -> SX
sxRule r = tag "rule"
  [ tag "id" [sym (rId r)], tag "head" [sym (hypName (rHead r))]
  , tag "kind" [sym (showKind (hypKind (rHead r)))]
  , tag "body" (map sxPrem (rBody r)), tag "assumes" (map sym (rAssumptions r))
  , tag "claim" [str (rClaim r)], sxCitation (rCitation r) ]

sxCounterRule :: CounterRule -> SX
sxCounterRule c = tag "counter-rule"
  [ tag "id" [sym (ceId c)], tag "target" [sym (hypName (ceTarget c))]
  , tag "attacks" [sym (ceAttacks c)], tag "when" [sxFact (ceWhen c)]
  , tag "claim" [str (ceClaim c)], sxCitation (ceCitation c) ]

sxLiterature :: Literature -> SX
sxLiterature l = tag "literature"
  [ tag "id" [sym (litId l)], tag "ref" [str (litRef l)], tag "arxiv" [sym (litArxiv l)]
  , tag "verified-on" [sym (litChecked l)] ]

sxAssumption :: Assumption -> SX
sxAssumption a = tag "assumption" [tag "id" [sym (asId a)], tag "text" [str (asText a)]]

sxContradiction :: SX -> SX
sxContradiction = id

------------------------------------------------------------------------------
-- Comparing explanations for one observed feature

mentions :: String -> Rule -> Bool
mentions fe r = any m (rBody r)
 where m (Fact p) = patFeature p == fe
       m (Sub h)  = any (mentions fe) (filter ((== h) . rHead) rules)

patFeature :: FactPat -> String
patFeature (NumGT fe _ _) = fe
patFeature (NumLT fe _ _) = fe
patFeature (StatusIs fe _) = fe

-- | Every hypothesis that the feature can bear on (directly, through a
--   sub-goal, or as counterevidence), with status, whether this very record
--   is used, the per-premise diagnosis, counterevidence and assumptions.
compareFeature :: Cfg -> KB -> String -> Either String SX
compareFeature cfg kb fid =
  case filter ((== fid) . recId) (kbFeats kb) of
    [] -> Left ("no spectral_feature record with id " ++ fid)
    (fr:_) ->
      let o  = fieldOr "?" "obs" fr
          fe = fieldOr "?" "feature" fr
          hs = [ h | h <- allHyps
                   , any (mentions fe) (filter ((== h) . rHead) rules)
                     || any (\c -> ceTarget c == h && patFeature (ceWhen c) == fe) counterRules ]
          entry h =
            let s = summarize cfg kb o h
                used = any (elem fid . recordsUsed) (filter (not . hasCut) (sDerivs s))
                ces = counterFindings cfg kb o h
            in tag "explanation"
                 [ tag "hypothesis" [sym (hypName h)], tag "kind" [sym (showKind (hypKind h))]
                 , tag "status" [sym (sStatus s)]
                 , tag "grade" [sym (maybe "n/a" showGrade (sGrade s))]
                 , tag "uses-this-record" [sym (if used then "yes" else "no")]
                 , tag "diagnosis" (concatMap (diagRule o) (filter ((== h) . rHead) rules))
                 , tag "counterevidence"
                     [ tag "finding" [sym (ceId c), sym rf, str ev, sym (showGrade g), sym (ceAttacks c)]
                     | (c, rf, ev, g) <- ces ]
                 , tag "rule-assumes" (map sym (nub (concat [ rAssumptions r | r <- rules, rHead r == h ])))
                 , tag "all-assumptions" (map sym (nub (concatMap assumptionsOf (filter (not . hasCut) (sDerivs s)))))
                 ]
          excl = [ tag "exclusive" [sym (hypName a), sym (hypName b), str role]
                 | (a, b, role) <- exclusivePairs, a `elem` hs, b `elem` hs ]
      in Right (tag "compare"
                  ([ tag "feature-record" [sym fid], tag "feature" [sym fe], tag "obs" [sym o]
                   , tag "candidates" [sym (show (length hs))] ]
                   ++ map entry hs ++ excl))
 where
  diagRule o r = [tag "rule" (sym (rId r) : map (diagPrem o) (rBody r))]
  diagPrem o (Sub h) =
    let s = summarize (Cfg (cK cfg) (cDepth cfg - 1)) kb o h
    in tag "goal" [sym (hypName h), sym (sStatus s)]
  diagPrem o (Fact p) =
    let recs = featuresOf kb o (patFeature p)
    in if null recs then tag "fact" [sxFact p, sym "no-record"]
       else tag "fact" (sxFact p : map (diagRec p) recs)
  diagRec p r = tag "record" [sym (recId r), sym (outcome p r)]
  outcome (NumGT _ fl t) r = numOutcome fl r (gradeGT (cK cfg)) t
  outcome (NumLT _ fl t) r = numOutcome fl r (gradeLT (cK cfg)) t
  outcome (StatusIs _ st) r = case field "status" r of
    Just v  -> if v == st then "holds" else "fails:status=" ++ v
    Nothing -> "missing-field:status"
  numOutcome fl r g t =
    case (field fl r >>= parseQ, field (fl ++ "_sigma") r >>= parseQ) of
      (Just v, Just s) -> maybe "fails" showGrade (g v s t)
      (Nothing, _)     -> "missing-field:" ++ fl
      (_, Nothing)     -> "missing-uncertainty:" ++ fl ++ "_sigma"

------------------------------------------------------------------------------
-- Machine-readable evidence graph for the Self Morphic console

graphSX :: Cfg -> KB -> SX
graphSX cfg kb = tag "lrd-graph"
  [ tag "nodes" (sortSX nodes), tag "edges" (sortSX (nubSX edges)) ]
 where
  os = obsIds kb
  sums = [ summarize cfg kb o h | o <- os, h <- allHyps ]
  hid o h = "HYP:" ++ o ++ ":" ++ hypName h
  recNode kind r = node (recId r) kind (attrs r)
  attrs r = tag "attrs" [ tag "attr" [sym k, str v] | (k, v) <- r ]
            : uncert r ++ [tag "synthetic" [sym (if isSynthetic r then "yes" else "no")]]
  uncert r = [ tag "uncertainty" [ tag "measure" [sym k, tag "value" [sym v], tag "sigma" [sym s]]
                                 | (k, v) <- r, Just s <- [field (k ++ "_sigma") r] ]
             | any (\(k, _) -> isSuffix "_sigma" k) r ]
  node i k extra = tag "node" ([tag "id" [sym i], tag "kind" [sym (showKind k)]] ++ extra)
  litNode l = node (litId l) KProvenance
                [ tag "attrs" [ tag "attr" [sym "source", str "literature"]
                              , tag "attr" [sym "ref", str (litRef l)]
                              , tag "attr" [sym "arxiv", str (litArxiv l)]
                              , tag "attr" [sym "verified_on", str (litChecked l)] ]
                , tag "synthetic" [sym "no"] ]
  hypNode s =
    let h = sHyp s
        rs = filter ((== h) . rHead) rules
    in node (hid (sObs s) h) (hypKind h)
         [ tag "status" [sym (sStatus s)]
         , tag "grade" [sym (maybe "n/a" showGrade (sGrade s))]
         , tag "epistemic" [sym "derivable-is-not-confirmation"]
         , tag "claim" [str (concatMap rClaim (take 1 rs))]
         , tag "assumptions" (map sym (nub (concatMap rAssumptions rs)))
         , tag "rules" (map (sym . rId) rs) ]
  ceNodes = [ (o, c, fid, ev, g) | o <- os, h <- allHyps
            , any (\s -> sObs s == o && sHyp s == h && isDerivable s) sums
            , (c, fid, ev, g) <- counterFindings cfg kb o h ]
  ceId' (o, c, fid, _, _) = "CE:" ++ ceId c ++ ":" ++ o ++ ":" ++ fid
  ceNode x@(_, c, _, ev, g) = node (ceId' x) KCounterevidence
    [ tag "attacks" [sym (ceAttacks c)], tag "claim" [str (ceClaim c)]
    , tag "evidence" [str ev], tag "grade" [sym (showGrade g)], sxCitation (ceCitation c) ]
  isCite (Obl _ k _ _) = k == "open-citation"
  globalCites = [ Obl oid "open-citation" [ hid o h | o <- os, r <- rules, rId r == rid, let h = rHead r ] why
                | (oid, rid, why) <- citationObligations ]
  obls = dedupSorted oblKey (sortBy (\a b -> oblKey a <= oblKey b)
                 (globalCites ++ filter (not . isCite) (concat [ obligationsFrom cfg o (filter ((== o) . sObs) sums) ++ uncertaintyObligations kb o | o <- os ])))
  oblNode (Obl i k _ w) = node i KProofObligation [tag "obligation-kind" [sym k], tag "text" [str w]]
  nodes = map (recNode KObservation) (kbObs kb)
       ++ map (recNode KSpectralFeature) (kbFeats kb)
       ++ map (recNode KProvenance) (kbProvs kb)
       ++ map litNode literature
       ++ map hypNode sums
       ++ map ceNode ceNodes
       ++ map oblNode obls
  edge f t k extra = tag "edge" ([tag "from" [sym f], tag "to" [sym t], tag "kind" [sym k]] ++ extra)
  edges =
       [ edge (recId r) (fieldOr "?" "obs" r) "observed-in" [] | r <- kbFeats kb ]
    ++ [ edge (recId r) (fieldOr "?" "provenance" r) "has-provenance" [] | r <- kbObs kb ++ kbFeats kb ]
    ++ [ edge (hid (sObs s) (sHyp s)) l "cites" []
       | s <- sums, r <- rules, rHead r == sHyp s, Cited ls _ <- [rCitation r], l <- ls ]
    ++ concat [ derivEdges d | s <- sums, d <- sDerivs s, not (hasCut d) ]
    ++ [ edge (ceId' x) (hid o (ceTarget c)) "attacks" [tag "assumption" [sym (ceAttacks c)]]
       | x@(o, c, _, _, _) <- ceNodes ]
    ++ [ edge (ceId' x) fid "derived-from" [] | x@(_, _, fid, _, _) <- ceNodes ]
    ++ [ edge (hid o a) (hid o b) "excludes" [tag "role" [str role]]
       | o <- os, (a, b, role) <- exclusivePairs
       , all (\h -> any (\s -> sObs s == o && sHyp s == h && isDerivable s) sums) [a, b] ]
    ++ [ edge i t "obligates" [] | Obl i _ ts _ <- obls, t <- ts ]
  derivEdges (Deriv rid h o ps) = concatMap pe ps
   where
    pe (PFact fid _ _ g) = [edge fid (hid o h) "supports" [tag "rule" [sym rid], tag "grade" [sym (showGrade g)]]]
    pe (PSub d'@(Deriv _ h' _ _)) = edge (hid o h) (hid o h') "depends-on" [tag "rule" [sym rid]] : derivEdges d'
    pe (PCut _) = []

sortSX :: [SX] -> [SX]
sortSX = sortOnKey render

-- | Sort by a string key, computing each key once (decorate-sort-undecorate).
sortOnKey :: (a -> String) -> [a] -> [a]
sortOnKey k xs = map snd (sortBy (\a b -> fst a <= fst b) [ (k x, x) | x <- xs ])

nubSX :: [SX] -> [SX]
nubSX xs = map snd (dedupSorted fst (sortBy (\a b -> fst a <= fst b) [ (render x, x) | x <- xs ]))
