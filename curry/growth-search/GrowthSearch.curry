-- Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
-- Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
-- SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
--
-- JWST-LRD Mission QSO1-DCBH-001, role 08 (t024-curry-growth):
-- bounded nondeterministic search over black-hole growth-history
-- candidate families for Abell 2744-QSO1, with Horn-clause style rules,
-- contradiction detection and inference traces.
--
-- Self-contained: depends on no other curry/ module (not curry/causal/,
-- not curry/growth/). Evidence = the Fortran growth solver's sweep CSV
-- (fixtures/growth/feasible_grid.csv). Nothing is filled in where
-- evidence is missing: such checks are UNAVAILABLE and say what is missing.
--
-- Vocabulary:
--   Viable   "viable under assumptions" ONLY. Never "confirmed".
--   Reject   a counterexample: the rule body failed on solver evidence, with reason.
--   Unavail  a rule body needs evidence that is not in the repo (open proof obligation).
module GrowthSearch where

import Data.Char ( isDigit, ord )
import Data.List ( intercalate, sortBy, isPrefixOf, groupBy )
import Control.Search.SetFunctions ( set1, sortValues )

------------------------------------------------------------------------------
-- Data

data Family = LightSeed | HeavySeed | SuperEddington | PrimordialBH | Composite
  deriving (Eq, Ord, Show)

-- Assumption sets (declared, uncited priors on the swept parameters).
-- AFid : eps = 0.1, duty = 1 (the benchmark tuple's values in fortran/growth/STATUS.md)
-- AGrid: the solver's whole swept grid (eps 0.05..0.30, duty 0.1..1)
data Aset = AFid | AGrid
  deriving (Eq, Ord, Show)

data Model = Simple | Saturated
  deriving (Eq, Ord, Show)

data Row = Row
  { rIdx :: Int
  , rLam :: Float, rEps :: Float, rZf :: Float, rDuty :: Float
  , rSeedS :: Float, rSeedT :: Float          -- min seed, simple / saturated model
  , rSeedSRaw :: String, rSeedTRaw :: String   -- verbatim solver text
  , rFeasS :: Int, rFeasT :: Int }
  deriving (Eq, Ord, Show)

-- Provenance of a rule: every model claim cites a paper, a solver artefact,
-- is a definition, a declared (uncited) assumption, or an open proof obligation.
data Prov = Cited String | Solver String | Defn String | Assume String | OpenPO String
  deriving (Eq, Ord, Show)

data Goal
  = LamLE Float
  | LamGT Float
  | ModelsAgree
  | ReachCand Float String       -- min seed (candidate's model) <= bound ; label
  | Missing String String        -- obligation id, what is missing
  deriving (Eq, Ord, Show)

data Rule = Rule String Family [Prov] [Goal]

data Cand = Cand Int Aset Family Model Row

data Verdict
  = Reject Float String          -- ratio min_seed/bound (> 1), reason
  | Viable Float                 -- ratio min_seed/bound (<= 1)
  | Unavail String String        -- obligation id, what is missing
  deriving (Eq, Ord, Show)

data Outcome = Outcome Int Aset Family Model Verdict Row [String]
  deriving (Eq, Ord, Show)

oIdx :: Outcome -> Int
oIdx (Outcome i _ _ _ _ _ _) = i
oAset :: Outcome -> Aset
oAset (Outcome _ a _ _ _ _ _) = a
oFam :: Outcome -> Family
oFam (Outcome _ _ f _ _ _ _) = f
oModel :: Outcome -> Model
oModel (Outcome _ _ _ m _ _ _) = m
oVerdict :: Outcome -> Verdict
oVerdict (Outcome _ _ _ _ v _ _) = v
oRow :: Outcome -> Row
oRow (Outcome _ _ _ _ _ r _) = r
oTrace :: Outcome -> [String]
oTrace (Outcome _ _ _ _ _ _ t) = t

------------------------------------------------------------------------------
-- Constants named once (each with its source)

-- M_target = 5.0e7 Msun: Juodzbalis et al. 2026, doi:10.1038/s41586-026-10579-4,
-- arXiv:2508.21748 ("Keplerian rotation around a point mass of 50 million Solar
-- masses"). It is carried inside the solver's min-seed columns, not used here.

lightSeedMsun :: Float
lightSeedMsun = 150.0   -- arXiv:2308.05735v2 Discussion (DELPHI seed assumption)

heavySeedHiMsun :: Float
heavySeedHiMsun = 1.0e6 -- arXiv:2308.05735v2 Discussion: heavier seeds 10^(4-6) Msun

------------------------------------------------------------------------------
-- Rule base (Horn-clause style:  head :- body1, body2, ...)

rules :: [Rule]
rules =
  [ Rule "R-LIGHT-1" LightSeed
      [ Cited "arXiv:2308.05735v2 (Furtak+ 2024, Nature 628, 57) Discussion: DELPHI model assumes a seed mass of 150 Msun from metal-free stars (a model assumption of that paper, used here only as the reference light-seed mass)"
      , Defn "light seed = the single cited reference mass 150 Msun; no range is invented"
      , Defn "at or below Eddington luminosity: lam <= 1 (lam is L/L_Edd, fortran/growth/STATUS.md)"
      , Solver "min seed from fixtures/growth/feasible_grid.csv; constant (lam, eps, duty) from z_form to z_obs = 7.04221; M_target = 5e7 Msun (Juodzbalis+ 2026)" ]
      [ LamLE 1.0, ModelsAgree, ReachCand lightSeedMsun "light seed 150 Msun" ]
  , Rule "R-HEAVY-1" HeavySeed
      [ Cited "arXiv:2308.05735v2 Discussion: hydrodynamic simulations 'typically starting with heavier seeds (10^(4-6) Msun)'; upper end 1e6 Msun used. Direct collapse is named in arXiv:2508.21748v2 as 'direct collapse of massive pristine clouds' without a mass range"
      , Defn "heavy seed = any seed up to 1e6 Msun; reach test uses the upper end, so 'viable' means some seed in range suffices"
      , Defn "at or below Eddington luminosity: lam <= 1"
      , OpenPO "PO-DCBH-1: DCBH-specific formation conditions, mass range, gas supply, metallicity (role 05, t021-dcbh) are not in the repo; this family is 'heavy seed', DCBH is one possible origin"
      , Solver "min seed from fixtures/growth/feasible_grid.csv" ]
      [ LamLE 1.0, ModelsAgree, ReachCand heavySeedHiMsun "heavy seed upper end 1e6 Msun" ]
  , Rule "R-SEDD-1" SuperEddington
      [ Cited "arXiv:2508.21748v2 main text: QSO1 'may still have experienced previous super-Eddington bursts' (qualitative; no rate or duration given)"
      , Defn "super-Eddington: lam > 1"
      , Defn "light reference seed 150 Msun rescued by lam > 1 growth"
      , OpenPO "PO-SAT-1: the saturated model lam_eff = 1 + ln(lam) is a prescription with no paper cited in fortran/growth (STATUS.md OPEN 2); the simple model (growth linear in lam) is an upper bound by construction"
      , Solver "min seed under the candidate's model from fixtures/growth/feasible_grid.csv" ]
      [ LamGT 1.0, ReachCand lightSeedMsun "light seed 150 Msun with lam > 1" ]
  , Rule "R-PBH-1" PrimordialBH
      [ OpenPO "PO-PBH-1: no PBH abundance or mass-function source in the repo; the only PBH mass statement found (preferred ~1e6 Msun scale, ref 35 = Carr & Kuhnel 2020, quoted in arXiv:2508.21748v2) is a secondary citation, the primary paper was not retrieved"
      , Defn "the classifier in curry/growth/GrowthClassify.curry labels PrimordialBH by (seed >= 1e4 and z_form >= 25); that threshold has no cited source and is NOT used here" ]
      [ Missing "PO-PBH-1" "PBH mass/abundance source (primary paper) not retrieved; no abundance in repo" ]
  , Rule "R-COMP-1" Composite
      [ OpenPO "PO-COMP-1: a composite history (e.g. heavy seed plus super-Eddington episodes) needs time-varying (lam, eps, duty); the solver sweeps constants only (fortran/growth/STATUS.md OPEN 3)" ]
      [ Missing "PO-COMP-1" "time-varying growth history; solver only sweeps constant (lam, eps, duty)" ]
  ]

ruleFor :: Family -> Rule
ruleFor f = head [ r | r@(Rule _ h _ _) <- rules, h == f ]

ruleId :: Rule -> String
ruleId (Rule i _ _ _) = i

provText :: Prov -> String
provText (Cited s)  = "CITED " ++ s
provText (Solver s) = "SOLVER " ++ s
provText (Defn s)   = "DEFINITION " ++ s
provText (Assume s) = "ASSUMPTION(uncited) " ++ s
provText (OpenPO s) = "OPEN-PROOF-OBLIGATION " ++ s

asetProv :: Aset -> String
asetProv AFid  = "ASSUMPTION(uncited) AFid: eps = 0.1 and duty = 1 (benchmark values of fortran/growth/STATUS.md; no paper cited for them)"
asetProv AGrid = "ASSUMPTION(uncited) AGrid: the solver's whole swept grid (eps 0.05..0.30, duty 0.1..1); the ranges are the solver's, not literature priors"

------------------------------------------------------------------------------
-- Numbers and CSV

pow10 :: Int -> Float
pow10 n = if n <= 0 then 1.0 else 10.0 * pow10 (n - 1)

scaleBy :: Int -> Int -> Float
scaleBy m ex = if ex >= 0 then fromInt m * pow10 ex else fromInt m / pow10 (negate ex)

digitsToInt :: String -> Maybe Int
digitsToInt ds
  | not (null ds) && all isDigit ds = Just (foldl (\a d -> 10 * a + ord d - ord '0') 0 ds)
  | otherwise = Nothing

-- "5.00000000E-001" (solver ES15.8E3). PAKCS 'reads' rejects the Fortran
-- "E+007" exponent, so decimals are parsed by hand: mantissa digits as an
-- Int, then one scaling.
parseSci :: String -> Maybe Float
parseSci s0 =
  let s = trim s0
      (mant, ex) = break (\c -> c == 'E' || c == 'e') s
      (ip, fp0) = break (== '.') mant
      fp = drop 1 fp0
  in do m <- digitsToInt (ip ++ fp)
        e <- expOf ex
        return (scaleBy m (e - length fp))

-- Overlapping rules are nondeterministic in Curry, so every deterministic
-- helper here uses mutually exclusive patterns or an explicit case.
expOf :: String -> Maybe Int
expOf [] = Just 0
expOf (_ : r) = case r of
  []      -> Nothing
  (c : ds) -> if c == '-' then fmap negate (digitsToInt ds)
              else if c == '+' then digitsToInt ds
              else digitsToInt r

trim :: String -> String
trim = reverse . dropWhile (== ' ') . reverse . dropWhile (== ' ')

splitOn :: Char -> String -> [String]
splitOn c s = case break (== c) s of
  (a, [])       -> [a]
  (a, _ : rest) -> a : splitOn c rest

csvHeader :: String
csvHeader = "lam,eps,z_form,duty,dt_myr,mdot_edd,growth_simple,growth_saturated,min_seed_simple_msun,min_seed_saturated_msun,feasible_simple,feasible_saturated"

parseRow :: Int -> String -> Either String Row
parseRow i ln = case map trim (splitOn ',' ln) of
  [a, b, c, d, _, _, _, _, s1, s2, f1, f2] ->
    case (parseSci a, parseSci b, parseSci c, parseSci d, parseSci s1, parseSci s2,
          digitsToInt f1, digitsToInt f2) of
      (Just lam, Just eps, Just zf, Just du, Just ss, Just st, Just fs, Just ft) ->
        Right (Row i lam eps zf du ss st s1 s2 fs ft)
      _ -> Left ("row " ++ show i ++ ": unparsable field")
  _ -> Left ("row " ++ show i ++ ": expected 12 fields")

-- Lines starting with '#' are comments (used by SYNTHETIC fixtures).
parseCsv :: String -> Either String [Row]
parseCsv txt =
  case filter (\l -> not (null l) && not ("#" `isPrefixOf` l)) (lines txt) of
    []         -> Left "empty"
    (h : body) -> if h /= csvHeader then Left "bad_header" else rowsOf 1 body
 where
  rowsOf _ [] = Right []
  rowsOf i (l : ls) = case parseRow i l of
                        Left e  -> Left e
                        Right r -> fmap (r :) (rowsOf (i + 1) ls)

loadRows :: String -> IO [Row]
loadRows path = do
  s <- readFile path
  case parseCsv s of
    Left e   -> error ("GrowthSearch.loadRows " ++ path ++ ": " ++ e)
    Right rs -> return rs

near :: Float -> Float -> Bool
near a b = abs (a - b) < 1.0e-9

-- Display a grid value (lam, eps, z_form, duty) with <= 4 decimals.
fmt4 :: Float -> String
fmt4 x =
  let n  = round (x * 10000.0) :: Int
      ip = n `div` 10000
      fp = n `mod` 10000
      fs = show fp
      fs' = replicate (4 - length fs) '0' ++ fs
      tr = reverse (dropWhile (== '0') (reverse fs'))
  in if null tr then show ip else show ip ++ "." ++ tr

tupleText :: Row -> String
tupleText r = "lam=" ++ fmt4 (rLam r) ++ " eps=" ++ fmt4 (rEps r)
              ++ " z_form=" ++ fmt4 (rZf r) ++ " duty=" ++ fmt4 (rDuty r)

------------------------------------------------------------------------------
-- Candidate space (bounded, enumerated deterministically; searched nondeterministically)

-- Does the family's definition apply to this row? Does the assumption set admit it?
applies :: Family -> Row -> Bool
applies LightSeed      r = rLam r <= 1.0
applies HeavySeed      r = rLam r <= 1.0
applies SuperEddington r = rLam r > 1.0
applies PrimordialBH   _ = True
applies Composite      _ = True

admits :: Aset -> Row -> Bool
admits AFid  r = near (rEps r) 0.1 && near (rDuty r) 1.0
admits AGrid _ = True

modelsOf :: Family -> [Model]
modelsOf SuperEddington = [Simple, Saturated]
modelsOf LightSeed      = [Simple]
modelsOf HeavySeed      = [Simple]
modelsOf PrimordialBH   = [Simple]
modelsOf Composite      = [Simple]

allFamilies :: [Family]
allFamilies = [LightSeed, HeavySeed, SuperEddington, PrimordialBH, Composite]

candidates :: [Row] -> [Cand]
candidates rows =
  [ Cand i a f m r
  | (i, (a, f, m, r)) <- zip [0 ..]
      [ (a, f, m, r) | a <- [AFid, AGrid], f <- allFamilies, m <- modelsOf f
                     , r <- rows, applies f r, admits a r ] ]

-- Nondeterministic choice.
member :: [a] -> a
member (x : xs) = x ? member xs

------------------------------------------------------------------------------
-- Goal evaluation and the inference trace

data GR = Holds String | Fails Float String | Unav String String

modelSeed :: Model -> Row -> Float
modelSeed Simple    r = rSeedS r
modelSeed Saturated r = rSeedT r

modelRaw :: Model -> Row -> String
modelRaw Simple    r = "min_seed_simple=" ++ trim (rSeedSRaw r) ++ " Msun"
modelRaw Saturated r = "min_seed_saturated=" ++ trim (rSeedTRaw r) ++ " Msun"

goalText :: Goal -> String
goalText (LamLE b)       = "lam <= " ++ fmt4 b
goalText (LamGT b)       = "lam > " ++ fmt4 b
goalText ModelsAgree     = "simple and saturated min seeds agree (solver: identical for lam <= 1)"
goalText (ReachCand _ l) = "reach M_target with " ++ l
goalText (Missing i _)   = "evidence for " ++ i

evalGoal :: Cand -> Goal -> GR
evalGoal (Cand _ _ _ _ r) (LamLE b)
  | rLam r <= b = Holds ("lam=" ++ fmt4 (rLam r) ++ " <= " ++ fmt4 b)
  | otherwise   = Fails 1.0 ("lam=" ++ fmt4 (rLam r) ++ " > " ++ fmt4 b)
evalGoal (Cand _ _ _ _ r) (LamGT b)
  | rLam r > b  = Holds ("lam=" ++ fmt4 (rLam r) ++ " > " ++ fmt4 b)
  | otherwise   = Fails 1.0 ("lam=" ++ fmt4 (rLam r) ++ " <= " ++ fmt4 b)
evalGoal (Cand _ _ _ _ r) ModelsAgree
  | abs (rSeedS r - rSeedT r) <= 1.0e-9 * rSeedS r =
      Holds ("min_seed_simple=" ++ trim (rSeedSRaw r) ++ " equals min_seed_saturated=" ++ trim (rSeedTRaw r))
  | otherwise =
      Fails 1.0 ("CONTRADICTION: models differ at lam <= 1: simple=" ++ trim (rSeedSRaw r)
                 ++ " saturated=" ++ trim (rSeedTRaw r)
                 ++ " (fortran/growth/STATUS.md states they are identical there)")
evalGoal (Cand _ _ _ m r) (ReachCand b l)
  | s <= b    = Holds (modelRaw m r ++ " <= " ++ l ++ " [ratio " ++ ratioText (s / b) ++ "]")
  | otherwise = Fails (s / b)
      (modelRaw m r ++ " > " ++ l ++ " [ratio " ++ ratioText (s / b)
       ++ "]: the seed cannot reach M_target=5e7 Msun by z_obs under constant ("
       ++ tupleText r ++ "), model " ++ show m)
 where s = modelSeed m r
evalGoal _ (Missing i d) = Unav i d

-- ratio shown to 4 significant-ish decimals (deterministic text)
ratioText :: Float -> String
ratioText x = if x >= 100.0 then show (round x :: Int) else
              let n = round (x * 10000.0) :: Int
                  ip = n `div` 10000
                  fp = n `mod` 10000
                  fs = show fp
              in show ip ++ "." ++ replicate (4 - length fs) '0' ++ fs

-- body evaluation, left to right, stopping at the first goal that does not hold
runGoals :: Cand -> [Goal] -> ([String], Verdict)
runGoals _ [] = ([], Viable 0.0)
runGoals c (g : gs) =
  case evalGoal c g of
    Holds d  -> let (t, v) = runGoals c gs
                in (("  GOAL " ++ goalText g ++ " => HOLDS: " ++ d) : t, bump g c v)
    Fails x d -> (["  GOAL " ++ goalText g ++ " => FAILS: " ++ d], Reject x d)
    Unav i d -> (["  GOAL " ++ goalText g ++ " => UNAVAILABLE: " ++ i ++ " missing: " ++ d],
                 Unavail i d)
 where
  -- the Viable ratio is the ReachCand ratio (min seed / bound)
  bump (ReachCand b _) (Cand _ _ _ m r) v = case v of { Viable _ -> Viable (modelSeed m r / b); _ -> v }
  bump (LamLE _) _ v = v
  bump (LamGT _) _ v = v
  bump ModelsAgree _ v = v
  bump (Missing _ _) _ v = v

evaluate :: Cand -> Outcome
evaluate c@(Cand i a f m r) =
  let rule@(Rule _ _ provs body) = ruleFor f
      hdr = [ "CANDIDATE #" ++ show i ++ " family=" ++ show f ++ " aset=" ++ show a
              ++ " model=" ++ show m ++ " row=" ++ show (rIdx r) ++ " " ++ tupleText r
            , "  RULE " ++ ruleId rule ++ ": " ++ headText f ++ " :- " ++ intercalate ", " (map goalText body) ]
      pv = map (\p -> "  PROV " ++ provText p) provs ++ ["  PROV " ++ asetProv a]
      (steps, v) = runGoals c body
      concl = case v of
                Viable x   -> "  => VIABLE UNDER ASSUMPTIONS (" ++ show a ++ ") [seed ratio "
                              ++ ratioText x ++ "]; not confirmed"
                Reject _ d -> "  => REJECTED (counterexample): " ++ d
                Unavail k d -> "  => UNAVAILABLE " ++ k ++ ": " ++ d
  in Outcome i a f m v r (hdr ++ pv ++ steps ++ [concl])

headText :: Family -> String
headText f = "viable(" ++ show f ++ ", Tuple)"

------------------------------------------------------------------------------
-- The bounded nondeterministic search

-- One nondeterministic evaluation: choose any candidate, evaluate it.
searchOne :: [Cand] -> Outcome
searchOne cs = evaluate (member cs)

-- Bound = maximum number of candidates examined (the first `bound` in the
-- fixed enumeration order). The set of results is sorted by candidate index,
-- so the output is reproducible byte for byte.
runSearch :: Int -> [Cand] -> [Outcome]
runSearch bound cs = sortValues (set1 searchOne (take bound cs))

-- Deterministic cross-check of the nondeterministic search.
runDeterministic :: Int -> [Cand] -> [Outcome]
runDeterministic bound cs = map evaluate (take bound cs)

isViable, isReject, isUnavail :: Outcome -> Bool
isViable  o = case oVerdict o of { Viable _ -> True;    _ -> False }
isReject  o = case oVerdict o of { Reject _ _ -> True;  _ -> False }
isUnavail o = case oVerdict o of { Unavail _ _ -> True; _ -> False }

ratioOf :: Outcome -> Float
ratioOf o = case oVerdict o of { Viable x -> x; Reject x _ -> x; _ -> 0.0 }

------------------------------------------------------------------------------
-- Contradiction detection over the evidence (internal consistency of the solver data)
-- Each returns the list of violations found. All invariants are mathematical
-- consequences of the solver's stated ODE (fortran/growth/STATUS.md):
--   M(t_obs) = M_seed * exp(E), E = duty*(1-eps)/eps * lam_eff * dt / t_Edd,
--   min seed = M_target / exp(E); dt grows with z_form; lam_eff is
--   nondecreasing in lam.  So the min seed must be
--     strictly decreasing in z_form, lam, duty and strictly increasing in eps.

keyOf :: Int -> Row -> [Float]
keyOf 0 r = [rEps r, rDuty r, rLam r]      -- vary z_form
keyOf 1 r = [rEps r, rDuty r, rZf r]       -- vary lam
keyOf 2 r = [rEps r, rLam r, rZf r]        -- vary duty
keyOf 3 r = [rDuty r, rLam r, rZf r]       -- vary eps

varOf :: Int -> Row -> Float
varOf 0 = rZf
varOf 1 = rLam
varOf 2 = rDuty
varOf 3 = rEps

-- sign: -1 means seed must strictly decrease as the variable increases, +1 increase
monoViolations :: String -> Int -> Int -> (Row -> Float) -> [Row] -> [String]
monoViolations name which sign seedOf rows =
  let sorted = sortBy (\a b -> (keyOf which a ++ [varOf which a]) <= (keyOf which b ++ [varOf which b])) rows
      pairs = zip sorted (drop 1 sorted)
  in [ name ++ ": rows " ++ show (rIdx a) ++ "->" ++ show (rIdx b) ++ " (" ++ tupleText a ++ " -> "
       ++ tupleText b ++ ") seed " ++ show (seedOf a) ++ " -> " ++ show (seedOf b)
     | (a, b) <- pairs, keyOf which a == keyOf which b
     , not (if sign < 0 then seedOf b < seedOf a else seedOf b > seedOf a) ]

modelViolations :: [Row] -> [String]
modelViolations rows =
  [ "C-MODELS-AGREE: row " ++ show (rIdx r) ++ " " ++ tupleText r ++ " simple=" ++ trim (rSeedSRaw r)
    ++ " saturated=" ++ trim (rSeedTRaw r)
  | r <- rows, rLam r <= 1.0, abs (rSeedS r - rSeedT r) > 1.0e-9 * rSeedS r ]

monoAll :: [Row] -> [String]
monoAll rows =
  concat [ monoViolations ("C-MONO-ZFORM-" ++ show m) 0 (-1) (modelSeed m) rows
         ++ monoViolations ("C-MONO-LAM-" ++ show m) 1 (-1) (modelSeed m) rows
         ++ monoViolations ("C-MONO-DUTY-" ++ show m) 2 (-1) (modelSeed m) rows
         ++ monoViolations ("C-MONO-EPS-" ++ show m) 3 1 (modelSeed m) rows
         | m <- [Simple, Saturated] ]

-- Feasibility flags must equal (min seed <= 1e5 Msun), the solver's swept seed range top.
flagViolations :: [Row] -> [String]
flagViolations rows =
  [ "C-FEAS-FLAG: row " ++ show (rIdx r) ++ " " ++ tupleText r ++ " flags=" ++ show (rFeasS r) ++ "," ++ show (rFeasT r)
    ++ " seeds " ++ trim (rSeedSRaw r) ++ "," ++ trim (rSeedTRaw r)
  | r <- rows, (rFeasS r == 1) /= (rSeedS r <= 1.0e5) || (rFeasT r == 1) /= (rSeedT r <= 1.0e5) ]

-- The solver's STATUS.md states 464/1200 (simple) and 382/1200 (saturated).
countViolations :: [Row] -> [String]
countViolations rows =
  let fs = length (filter (\r -> rFeasS r == 1) rows)
      ft = length (filter (\r -> rFeasT r == 1) rows)
  in [ "C-STATUS-COUNTS: fortran/growth/STATUS.md states 464 simple / 382 saturated feasible of 1200; data has "
       ++ show fs ++ " / " ++ show ft ++ " of " ++ show (length rows)
     | fs /= 464 || ft /= 382 || length rows /= 1200 ]

allViolations :: [Row] -> [String]
allViolations rows = modelViolations rows ++ monoAll rows ++ flagViolations rows

------------------------------------------------------------------------------
-- Static evidence ledger (what is missing)

unavailable :: [(String, String)]
unavailable =
  [ ("evidence.t018-dynmass-independent-mass", "independent dynamical-mass reproduction (role 02): branch t018-dynmass has no commits beyond main; M_target = 5e7 Msun is the published value (Juodzbalis+ 2026), not reproduced here")
  , ("evidence.t019-formation-window", "cosmological clock and seed-formation window (role 03): t019-clock has no clock output of its own; z_form is a swept grid value (12..30), not a derived window")
  , ("evidence.t021-dcbh-scenario-models", "direct-collapse scenario models (role 05): branch t021-dcbh has no commits beyond main; no formation conditions, mass range, gas supply or metallicity model is in the repo")
  , ("evidence.t022-hamiltonian-feasibility", "Foundry J Verify Hamiltonian growth feasibility (role 06): no branch t022-growth-hamiltonian exists locally or on origin; /workspace/foundry-j/verify holds the J property harness (no growth results); hamiltonian/ (t008) is a generic engine with no growth model")
  , ("evidence.dcbh-baryon-cap", "arXiv:2508.21748v2 states DCBH growth is limited by the baryon fraction in an atomically cooling halo, upper limit M_BH/M_dyn ~ 0.1, more than 1 dex below its inferred lower limit (refs 33,34 there). That is a published claim, NOT reproduced here: it needs t018 (independent M_dyn) and t021 (halo model)")
  , ("evidence.m-target-uncertainty", "no published uncertainty on M_target = 5e7 Msun is available to the repo (research/CITATIONS.md); solver gives 'minimum seed to reach >= target' only, so overshoot of the observed mass cannot be tested")
  , ("evidence.current-eddington-ratio-link", "observed current L/L_Edd (about 0.03 in arXiv:2508.21748v2, about 0.3 in arXiv:2308.05735v2, 10x apart, no uncertainties) cannot be tied to the solver's constant-lam history without a duty-cycle/episode model; no verdict")
  , ("evidence.pbh-abundance-mass", "PBH mass function and abundance source: none in the repo (open proof obligation PO-PBH-1)")
  , ("evidence.composite-time-varying", "time-varying growth histories (open proof obligation PO-COMP-1)")
  , ("evidence.saturation-prescription-citation", "paper for the lam_eff = 1 + ln(lam) saturation prescription (open proof obligation PO-SAT-1)")
  , ("evidence.parameter-priors", "literature priors for eps and duty cycle (AFid/AGrid are declared uncited assumptions; adversary/PLAN.md cites 1911.05791 for them but that paper is not retrieved in this repo)")
  ]

------------------------------------------------------------------------------
-- Reporting

pad :: Int -> String -> String
pad n s = s ++ replicate (n - length s) ' '

groupKey :: Outcome -> (Aset, Family, Model)
groupKey o = (oAset o, oFam o, oModel o)

groups :: [Outcome] -> [[Outcome]]
groups = groupBy (\a b -> groupKey a == groupKey b)

statusOf :: [Outcome] -> String
statusOf os
  | all isUnavail os = "UNAVAILABLE"
  | any isViable os  = "VIABLE_UNDER_ASSUMPTIONS"
  | all isReject os  = "REJECTED"
  | otherwise        = "MIXED"

reasonOf :: Outcome -> String
reasonOf o = case oVerdict o of
  Reject _ d  -> d
  Unavail k d -> k ++ " missing: " ++ d
  Viable x    -> "viable, seed ratio " ++ ratioText x

shortReject :: Outcome -> String
shortReject o = pad 15 (show (oFam o)) ++ " " ++ pad 9 (show (oModel o))
  ++ " #" ++ pad 5 (show (oIdx o)) ++ " " ++ tupleText (oRow o)
  ++ " | " ++ reasonOf o

printGroupSummary :: [Outcome] -> IO ()
printGroupSummary os = do
  let (a, f, m) = groupKey (head os)
  putStrLn ("GROUP aset=" ++ show a ++ " family=" ++ pad 14 (show f) ++ " model=" ++ pad 9 (show m)
            ++ " candidates=" ++ pad 5 (show (length os))
            ++ " viable=" ++ pad 5 (show (length (filter isViable os)))
            ++ " rejected=" ++ pad 5 (show (length (filter isReject os)))
            ++ " unavailable=" ++ pad 5 (show (length (filter isUnavail os)))
            ++ " status=" ++ statusOf os)

selectBy :: [Outcome] -> Aset -> Family -> Model -> Float -> Float -> Float -> Float -> [Outcome]
selectBy os a f m lam eps zf du =
  [ o | o <- os, oAset o == a, oFam o == f, oModel o == m
      , near (rLam (oRow o)) lam, near (rEps (oRow o)) eps
      , near (rZf (oRow o)) zf, near (rDuty (oRow o)) du ]

printTrace :: [Outcome] -> IO ()
printTrace os = case os of
  []      -> putStrLn "  (candidate not in the evaluated set)"
  (o : _) -> mapM_ putStrLn (oTrace o)

-- Full report. bound = maximum candidates examined.
mainAt :: String -> Int -> IO ()
mainAt path bound = do
  rows <- loadRows path
  let cs    = candidates rows
      total = length cs
      os    = runSearch bound cs
      exhaustive = bound >= total
  putStrLn "GROWTH-SEARCH v1 (Mission QSO1-DCBH-001 role 08, t024-curry-growth)"
  putStrLn ("input=" ++ path)
  putStrLn ("rows=" ++ show (length rows) ++ " candidates_total=" ++ show total
            ++ " bound=" ++ show bound ++ " evaluated=" ++ show (length os)
            ++ " exhaustive=" ++ (if exhaustive then "yes" else "NO"))
  if exhaustive then return ()
    else putStrLn "BOUND_REACHED: search stopped at the bound; the verdicts below cover only the evaluated candidates and are NOT exhaustive"
  putStrLn ""
  putStrLn "SECTION RULES"
  mapM_ (\(Rule i f ps body) -> do
           putStrLn ("RULE " ++ i ++ ": " ++ headText f ++ " :- " ++ intercalate ", " (map goalText body))
           mapM_ (\p -> putStrLn ("  PROV " ++ provText p)) ps) rules
  putStrLn ("ASET " ++ asetProv AFid)
  putStrLn ("ASET " ++ asetProv AGrid)
  putStrLn ""
  putStrLn "SECTION FAMILY VERDICTS (status VIABLE_UNDER_ASSUMPTIONS never means confirmed)"
  mapM_ printGroupSummary (groups os)
  putStrLn ""
  putStrLn "SECTION VIABLE UNDER ASSUMPTIONS (aset=AFid, every viable candidate)"
  mapM_ (\o -> putStrLn (pad 15 (show (oFam o)) ++ " " ++ pad 9 (show (oModel o)) ++ " #" ++ pad 5 (show (oIdx o))
                         ++ " " ++ tupleText (oRow o) ++ " | " ++ reasonOf o ++ " | viable under assumptions (AFid); not confirmed"))
        [ o | o <- os, oAset o == AFid, isViable o ]
  putStrLn ""
  putStrLn "SECTION REJECTED CANDIDATES (aset=AFid, every rejected candidate with its reason)"
  mapM_ (putStrLn . shortReject) [ o | o <- os, oAset o == AFid, isReject o ]
  putStrLn ""
  putStrLn "SECTION REJECTED CANDIDATES (aset=AGrid): closest miss per family/model, then count"
  mapM_ (\g -> let rs = sortBy (\x y -> (ratioOf x, oIdx x) <= (ratioOf y, oIdx y))
                              [ o | o <- g, isReject o ]
               in if null rs then return ()
                  else do putStrLn ("CLOSEST_MISS " ++ shortReject (head rs))
                          putStrLn ("  rejected_in_group=" ++ show (length rs)))
        [ g | g <- groups os, oAset (head g) == AGrid ]
  putStrLn ""
  putStrLn "SECTION UNAVAILABLE (rule bodies blocked by missing evidence)"
  mapM_ (\g -> if statusOf g == "UNAVAILABLE"
                 then putStrLn ("UNAVAILABLE_FAMILY aset=" ++ show (oAset (head g)) ++ " family=" ++ show (oFam (head g))
                                ++ " candidates=" ++ show (length g) ++ " | " ++ reasonOf (head g))
                 else return ()) (groups os)
  mapM_ (\(k, d) -> putStrLn ("UNAVAILABLE_EVIDENCE " ++ k ++ " | " ++ d)) unavailable
  putStrLn ""
  putStrLn "SECTION CONTRADICTION DETECTION (internal consistency of the evidence)"
  let viol = allViolations rows ++ countViolations rows
  if null viol then putStrLn "NO_CONTRADICTION in the evaluated evidence (models agree at lam<=1; min seed monotone in z_form, lam, duty, eps for both models; flags = (seed<=1e5); status counts 464/382)"
    else mapM_ (putStrLn . ("CONTRADICTION " ++)) (take 20 viol)
  putStrLn ("CONTRADICTION_COUNT " ++ show (length viol))
  putStrLn ""
  putStrLn "SECTION INFERENCE TRACES (selected candidates, verbatim from the evaluated set)"
  putStrLn "TRACE light seed, benchmark tuple (expected: rejected)"
  printTrace (selectBy os AFid LightSeed Simple 1.0 0.1 20.0 1.0)
  putStrLn "TRACE light seed, z_form 30 (expected: viable under assumptions)"
  printTrace (selectBy os AFid LightSeed Simple 1.0 0.1 30.0 1.0)
  putStrLn "TRACE heavy seed, lam 0.5 z_form 12 (expected: rejected)"
  printTrace (selectBy os AFid HeavySeed Simple 0.5 0.1 12.0 1.0)
  putStrLn "TRACE heavy seed, benchmark tuple (expected: viable under assumptions)"
  printTrace (selectBy os AFid HeavySeed Simple 1.0 0.1 20.0 1.0)
  putStrLn "TRACE super-Eddington, simple model, lam 1.5 z_form 12"
  printTrace (selectBy os AFid SuperEddington Simple 1.5 0.1 12.0 1.0)
  putStrLn "TRACE super-Eddington, saturated model, lam 1.5 z_form 12"
  printTrace (selectBy os AFid SuperEddington Saturated 1.5 0.1 12.0 1.0)
  putStrLn "TRACE primordial black hole, benchmark tuple (expected: unavailable)"
  printTrace (selectBy os AFid PrimordialBH Simple 1.0 0.1 20.0 1.0)
  putStrLn "TRACE composite, benchmark tuple (expected: unavailable)"
  printTrace (selectBy os AFid Composite Simple 1.0 0.1 20.0 1.0)
  putStrLn ""
  putStrLn "SECTION SELF-CHECKS (expectations derived by hand from the solver ODE, not copied from solver output)"
  selfChecks rows cs bound os viol
  putStrLn "GROWTH_SEARCH_DONE"

------------------------------------------------------------------------------
-- Self-checks. Each prints RESULT PASS|FAIL <name> <why>

res :: String -> Bool -> String -> IO ()
res name ok why = putStrLn ("RESULT " ++ (if ok then "PASS " else "FAIL ") ++ name
                            ++ (if ok then "" else " " ++ why))

inWin :: Float -> Float -> Float -> Bool
inWin x lo hi = x >= lo && x <= hi

selfChecks :: [Row] -> [Cand] -> Int -> [Outcome] -> [String] -> IO ()
selfChecks rows cs bound os viol = do
  let exhaustive = bound >= length cs
      sel a f m lam eps zf du = selectBy os a f m lam eps zf du
      viableFid f m = [ o | o <- os, oAset o == AFid, oFam o == f, oModel o == m, isViable o ]
      rejectedFid f m = [ o | o <- os, oAset o == AFid, oFam o == f, oModel o == m, isReject o ]
  res "row_count_1200" (length rows == 1200) ("rows=" ++ show (length rows))
  if not exhaustive
    then putStrLn "RESULT UNAVAILABLE exhaustive_family_checks search bound reached before the whole candidate space was evaluated"
    else do
      -- by hand: benchmark (lam 1, eps 0.1, z_form 20, duty 1): E = 9*576.059/450.49 = 11.51; seed = 5e7/e^E ~ 502 > 150
      res "light_benchmark_rejected"
        (case sel AFid LightSeed Simple 1.0 0.1 20.0 1.0 of
           [o] -> isReject o && inWin (rSeedS (oRow o)) 480.0 525.0
           _   -> False) "benchmark tuple should be rejected with min seed 480..525 Msun"
      -- by hand: need E >= ln(5e7/150) = 12.72; lam=1, z_form 30: E = 9*655.289/450.49 = 13.09 (ok);
      -- z_form 25: E = 12.49 (fails); lam=0.75 at z_form 30: E = 9.82 (fails). Exactly one viable.
      res "light_viable_exactly_lam1_zform30"
        (case viableFid LightSeed Simple of
           [o] -> near (rLam (oRow o)) 1.0 && near (rZf (oRow o)) 30.0
           _   -> False) "AFid light seed should be viable only at lam=1, z_form=30"
      -- by hand: lam 0.5, z_form 12: E = 9*0.5*387.513/450.49 = 3.871, exp = 48.0, seed = 1.04e6 > 1e6
      res "heavy_rejected_only_lam05_zform12"
        (case rejectedFid HeavySeed Simple of
           [o] -> near (rLam (oRow o)) 0.5 && near (rZf (oRow o)) 12.0
                  && inWin (ratioOf o) 1.03 1.05
           _   -> False) "AFid heavy seed should be rejected only at lam=0.5, z_form=12 (ratio 1.03..1.05)"
      res "heavy_fid_14_viable_of_15" (length (viableFid HeavySeed Simple) == 14)
          ("viable=" ++ show (length (viableFid HeavySeed Simple)))
      -- by hand: lam 1.5, z_form 12 simple: E = 9*1.5*387.513/450.49 = 11.612, seed ~ 453 Msun (> 150)
      res "supereddington_simple_hand_value"
        (case sel AFid SuperEddington Simple 1.5 0.1 12.0 1.0 of
           [o] -> isReject o && inWin (rSeedS (oRow o)) 448.0 458.0
           _   -> False) "simple-model min seed at (1.5, 0.1, 12, 1) should be 448..458 Msun"
      -- saturated: lam_eff = 1 + ln 1.5 = 1.4055, E = 10.88, seed ~ 941 Msun
      res "supereddington_saturated_hand_value"
        (case sel AFid SuperEddington Saturated 1.5 0.1 12.0 1.0 of
           [o] -> isReject o && inWin (rSeedT (oRow o)) 930.0 950.0
           _   -> False) "saturated-model min seed at (1.5, 0.1, 12, 1) should be 930..950 Msun"
      res "pbh_all_unavailable"
        (let ps = [ o | o <- os, oFam o == PrimordialBH ] in not (null ps) && all isUnavail ps)
        "every PBH candidate must be UNAVAILABLE (no cited mass/abundance source)"
      res "composite_all_unavailable"
        (let ps = [ o | o <- os, oFam o == Composite ] in not (null ps) && all isUnavail ps)
        "every composite candidate must be UNAVAILABLE (no time-varying history)"
      res "no_family_confirmed"
        (all (\o -> case oVerdict o of { Viable _ -> any ("VIABLE UNDER ASSUMPTIONS" `isIn`) (oTrace o); _ -> True }) os)
        "a viable candidate lacks the 'viable under assumptions' label"
      res "every_rejection_has_reason"
        (all (\o -> case oVerdict o of { Reject _ d -> not (null d); _ -> True }) os)
        "a rejection without a reason"
      res "nondet_search_equals_deterministic"
        (runSearch bound cs == runDeterministic bound cs) "set-function search differs from the deterministic evaluation"
  -- contradiction detector: silent on the real evidence
  res "contradiction_detector_silent_on_real_data" (null viol)
      (intercalate "; " (take 3 viol))
  -- bounded search: a tiny bound must evaluate exactly that many and be flagged non-exhaustive
  let small = runSearch 7 cs
  res "bounded_search_honours_bound" (length small == 7 && length cs > 7) ("evaluated=" ++ show (length small))
 where
  isIn pat s = any (pat `isPrefixOf`) (tails' s)
  tails' [] = [[]]
  tails' l@(_ : t) = l : tails' t

------------------------------------------------------------------------------
-- Detector self-test on a SYNTHETIC input: the detector must FIRE.
-- (The synthetic CSV is built by tests/curry-growth/run.sh.)
mainSynthetic :: String -> IO ()
mainSynthetic path = do
  rows <- loadRows path
  let mv = modelViolations rows
      mo = monoAll rows
  mapM_ (putStrLn . ("DETECTED " ++)) (take 10 (mv ++ mo))
  putStrLn ("DETECTED_MODELS_AGREE " ++ show (length mv))
  putStrLn ("DETECTED_MONOTONE " ++ show (length mo))
  res "contradiction_detector_fires_on_synthetic" (not (null mv) && not (null mo))
      ("models=" ++ show (length mv) ++ " monotone=" ++ show (length mo))
  putStrLn "GROWTH_SEARCH_SYNTHETIC_DONE"

-- Write every rejection of the AGrid/AFid sets, one line each (a TSV-ish dump).
mainRejected :: String -> IO ()
mainRejected path = do
  rows <- loadRows path
  let cs = candidates rows
      os = runSearch (length cs) cs
  mapM_ (putStrLn . shortReject) [ o | o <- os, isReject o ]
  putStrLn ("REJECTED_COUNT " ++ show (length [ o | o <- os, isReject o ]))

-- Full trace of every candidate (used to check reproducibility by hash).
mainTraces :: String -> IO ()
mainTraces path = do
  rows <- loadRows path
  let cs = candidates rows
      os = runSearch (length cs) cs
  mapM_ (\o -> mapM_ putStrLn (oTrace o)) os
  putStrLn ("TRACES_COUNT " ++ show (length os))
