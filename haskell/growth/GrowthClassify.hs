{-# OPTIONS_GHC -fplugin=LiquidHaskell #-}
{-@ LIQUID "--ple" @-}
{-@ LIQUID "--exact-data-cons" @-}
-- Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
-- Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
-- SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
--
-- JWST-LRD Mission QSO1-DCBH-001: the Liquid Haskell refinement of the
-- Curry growth classifier (curry/growth/GrowthClassify.curry, role 08).
-- Per the owner's architecture, the Curry-Howard content of the Curry
-- track is refined here; the runtimes are unchanged. The classifier
-- logic is ported definition-for-definition, with changes of
-- representation only:
--   * numeric fields are Ints in MICRO-UNITS (value x 10^6). The
--     record's fields are short decimals (lam, eps, z_form, duty are
--     exact at <= 6 places in the sweep; the benchmark seeds are
--     exact at 6 places), so micro-units are exact where it matters
--     and the thresholds (1, 100, 1e4) become integers. (Rational was
--     tried first: LH 0.9.6.3's reflection lifts Rational to an
--     uninterpreted Ratio sort over which spec comparisons do not
--     elaborate. Integer was tried second: literals inside reflected
--     Integer functions are encoded as opaque apply-terms that the
--     spec's plain literals never unify with -- verified in the
--     SMT output. Int literals are plain SMT ints on both sides,
--     hence Int. The Curry track's Float carried ~1e-13 relative
--     error at the same thresholds, so exact integer micro-units
--     are strictly more faithful than the Curry port.)
--   * the LRD-REC-v1 parser is not ported (parsing is I/O machinery,
--     not classification content); tuples arrive already parsed.
--   * the logic is factored through a FIELD-LEVEL core
--     (consistentWithF over primitive arguments; the record API
--     below is a one-line definitional wrapper, adding no logic),
--     and the theorems are proved on the BIT-VECTOR form of the
--     classification (hypothesesBitsF / bitOf). Both factorings are
--     LH engineering necessities, found empirically in this
--     environment: PLE does not unfold a reflected function whose
--     branch compares a projected field of a user ADT, and it
--     generates no usable equation for a recursive selection over
--     a symbolic list, so the list form is a definitional
--     projection of the proved bit vector (see the core comment).
-- The tuple type is named GTuple (LH has a built-in Tuple sort) and
-- is positional (Curry field order).
--
-- Theorems (all checked by the plugin + z3; see theorems/README.md):
--   LH-GR-1 counterexampleSound : an infeasible tuple classifies to
--             no hypothesis at all.
--   LH-GR-2 membership          : the bit for h in the
--             classification bit vector is exactly h's consistency
--             predicate (the classifier is its own spec).
--   LH-GR-3 simpleComplete      : every simply-feasible tuple has at
--             least one consistent hypothesis.
--   LH-GR-4 gapChar / gapCharRev: the exact boundary of the
--             classifier -- a feasible tuple classifies to nothing
--             IFF it is saturated-only-feasible at lam <= 1. (Naive
--             completeness "feasible => some hypothesis" is FALSE
--             for this classifier; LH-GR-4 is the true statement.)
--   LH-GR-5 benchmarkHeavy      : the Fortran solver's benchmark row
--             (lam=1, eps=0.1, z_form=20, duty=1; min seed
--             502.149751 Msun under both models, from
--             fixtures/growth/feasible_grid.csv) classifies to
--             exactly [HeavySeed], by computation.

module GrowthClassify where

data Hypothesis = LightSeed | HeavySeed | SuperEddington | PrimordialBH | Composite
  deriving (Eq, Ord, Show)

-- Curry field order: lam eps zForm duty dtMyr mdot seedSimple seedSat
-- feasSimple feasSat. Numerics in micro-units.
data GTuple = GTuple Int Int Int Int Int
                     Int Int Int Bool Bool
  deriving (Eq, Show)

lamOf :: GTuple -> Int
lamOf (GTuple x _ _ _ _ _ _ _ _ _) = x

epsOf :: GTuple -> Int
epsOf (GTuple _ x _ _ _ _ _ _ _ _) = x

zFormOf :: GTuple -> Int
zFormOf (GTuple _ _ x _ _ _ _ _ _ _) = x

dutyOf :: GTuple -> Int
dutyOf (GTuple _ _ _ x _ _ _ _ _ _) = x

dtMyrOf :: GTuple -> Int
dtMyrOf (GTuple _ _ _ _ x _ _ _ _ _) = x

mdotOf :: GTuple -> Int
mdotOf (GTuple _ _ _ _ _ x _ _ _ _) = x

seedSimpleOf :: GTuple -> Int
seedSimpleOf (GTuple _ _ _ _ _ _ x _ _ _) = x

seedSatOf :: GTuple -> Int
seedSatOf (GTuple _ _ _ _ _ _ _ x _ _) = x

feasSimpleOf :: GTuple -> Bool
feasSimpleOf (GTuple _ _ _ _ _ _ _ _ x _) = x

feasSatOf :: GTuple -> Bool
feasSatOf (GTuple _ _ _ _ _ _ _ _ _ x) = x

----------------------------------------------------------------------
-- Field-level core (the reflected logic). Argument order:
-- feasSimple feasSat lam seedSimple seedSat zForm, micro-units.
-- Thresholds: lam 1 = 1000000; seed 100 = 100000000;
-- seed 1e4 = 10000000000; z_form 25 = 25000000.
--
-- The verified core is the BIT VECTOR of the five consistency
-- predicates (hypothesesBitsF + bitOf). LH 0.9.6.3's PLE generates
-- no usable equation for a recursive selection over a symbolic
-- list (verified empirically in this environment: the step
-- equation for the selection is emitted in selector form but the
-- auxiliary keep/cons equations never reach the constraint), so
-- the theorems are stated and proved on the bit vector, which is
-- the classifier's entire logical content: hypothesis h is in the
-- classification iff bitOf (hypothesesBitsF ...) h. The list API
-- below is a definitional projection of the bit vector (include
-- h iff its bit is set); that projection is plain Haskell, not
-- reflected, and is the only unproved step -- it adds no logic,
-- it only re-presents the five bits as a list.

{-@ reflect allHypotheses @-}
allHypotheses :: [Hypothesis]
allHypotheses = [LightSeed, HeavySeed, SuperEddington, PrimordialBH, Composite]

{-@ reflect consistentWithF @-}
consistentWithF :: Bool -> Bool -> Int -> Int -> Int -> Int -> Hypothesis -> Bool
consistentWithF fs _  lam ss _  _  LightSeed =
  fs && lam <= 1000000 && ss <= 100000000
consistentWithF fs _  lam ss _  _  HeavySeed =
  fs && lam <= 1000000 && ss > 100000000
consistentWithF fs ft lam _  _  _  SuperEddington =
  (fs || ft) && lam > 1000000
consistentWithF fs _  _   ss _  zf PrimordialBH =
  fs && ss >= 10000000000 && zf >= 25000000
consistentWithF _  ft lam _  st _  Composite =
  ft && lam > 1000000 && st > 100000000

-- The classification as a bit vector, in allHypotheses order.
{-@ reflect hypothesesBitsF @-}
hypothesesBitsF :: Bool -> Bool -> Int -> Int -> Int -> Int -> (Bool, Bool, Bool, Bool, Bool)
hypothesesBitsF fs ft lam ss st zf =
  ( consistentWithF fs ft lam ss st zf LightSeed
  , consistentWithF fs ft lam ss st zf HeavySeed
  , consistentWithF fs ft lam ss st zf SuperEddington
  , consistentWithF fs ft lam ss st zf PrimordialBH
  , consistentWithF fs ft lam ss st zf Composite )

{-@ reflect bitOf @-}
bitOf :: (Bool, Bool, Bool, Bool, Bool) -> Hypothesis -> Bool
bitOf (a, _, _, _, _) LightSeed = a
bitOf (_, b, _, _, _) HeavySeed = b
bitOf (_, _, c, _, _) SuperEddington = c
bitOf (_, _, _, d, _) PrimordialBH = d
bitOf (_, _, _, _, e) Composite = e

----------------------------------------------------------------------
-- Theorems

-- LH-GR-1: counterexample soundness (neither model feasible).
{-@ counterexampleSound :: fs:Bool -> ft:Bool -> lam:Int -> ss:Int -> st:Int -> zf:Int
      -> { (not fs && not ft) => hypothesesBitsF fs ft lam ss st zf == (False, False, False, False, False) } @-}
counterexampleSound :: Bool -> Bool -> Int -> Int -> Int -> Int -> ()
counterexampleSound _ _ _ _ _ _ = ()

-- LH-GR-2: membership characterization -- the bit for h in the
-- classification is exactly h's consistency predicate.
{-@ membership :: fs:Bool -> ft:Bool -> lam:Int -> ss:Int -> st:Int -> zf:Int -> h:Hypothesis
      -> { bitOf (hypothesesBitsF fs ft lam ss st zf) h <=> consistentWithF fs ft lam ss st zf h } @-}
membership :: Bool -> Bool -> Int -> Int -> Int -> Int -> Hypothesis -> ()
membership _ _ _ _ _ _ LightSeed = ()
membership _ _ _ _ _ _ HeavySeed = ()
membership _ _ _ _ _ _ SuperEddington = ()
membership _ _ _ _ _ _ PrimordialBH = ()
membership _ _ _ _ _ _ Composite = ()

-- LH-GR-3: simple-model completeness.
{-@ simpleComplete :: fs:Bool -> ft:Bool -> lam:Int -> ss:Int -> st:Int -> zf:Int
      -> { fs => hypothesesBitsF fs ft lam ss st zf /= (False, False, False, False, False) } @-}
simpleComplete :: Bool -> Bool -> Int -> Int -> Int -> Int -> ()
simpleComplete _ _ _ _ _ _ = ()

-- LH-GR-4: the gap characterization, both directions.
{-@ gapChar :: fs:Bool -> ft:Bool -> lam:Int -> ss:Int -> st:Int -> zf:Int
      -> { ((fs || ft) && hypothesesBitsF fs ft lam ss st zf == (False, False, False, False, False)) => (ft && not fs && lam <= 1000000) } @-}
gapChar :: Bool -> Bool -> Int -> Int -> Int -> Int -> ()
gapChar _ _ _ _ _ _ = ()

{-@ gapCharRev :: fs:Bool -> ft:Bool -> lam:Int -> ss:Int -> st:Int -> zf:Int
      -> { (ft && not fs && lam <= 1000000) => hypothesesBitsF fs ft lam ss st zf == (False, False, False, False, False) } @-}
gapCharRev :: Bool -> Bool -> Int -> Int -> Int -> Int -> ()
gapCharRev _ _ _ _ _ _ = ()

-- LH-GR-5: the solver's benchmark row classifies to exactly
-- [HeavySeed] -- bit vector (False, True, False, False, False) --
-- by computation (feasSimple, feasSat, lam, seedSimple, seedSat,
-- zForm in micro-units).
{-@ benchmarkHeavy :: { hypothesesBitsF True True 1000000 502149751 502149751 20000000 == (False, True, False, False, False) } @-}
benchmarkHeavy :: ()
benchmarkHeavy = ()

----------------------------------------------------------------------
-- List API (definitional projection of the bit vector; plain
-- Haskell, not reflected -- see the core comment above).

hypothesesOfF :: Bool -> Bool -> Int -> Int -> Int -> Int -> [Hypothesis]
hypothesesOfF fs ft lam ss st zf =
  let (a, b, c, d, e) = hypothesesBitsF fs ft lam ss st zf
  in  (if a then [LightSeed] else [])
      ++ (if b then [HeavySeed] else [])
      ++ (if c then [SuperEddington] else [])
      ++ (if d then [PrimordialBH] else [])
      ++ (if e then [Composite] else [])

----------------------------------------------------------------------
-- Record API (definitional wrappers over the core; no added logic).

feasible :: GTuple -> Bool
feasible t = feasSimpleOf t || feasSatOf t

consistentWith :: GTuple -> Hypothesis -> Bool
consistentWith t h =
  consistentWithF (feasSimpleOf t) (feasSatOf t) (lamOf t)
                  (seedSimpleOf t) (seedSatOf t) (zFormOf t) h

hypothesesOf :: GTuple -> [Hypothesis]
hypothesesOf t =
  hypothesesOfF (feasSimpleOf t) (feasSatOf t) (lamOf t)
                (seedSimpleOf t) (seedSatOf t) (zFormOf t)

counterexample :: GTuple -> Bool
counterexample t = not (feasible t)
