-- Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
-- SPDX-License-Identifier: AGPL-3.0-only. Also subject to the SnapKitty Opaque License (dual license).
-- See LICENSE and SNAPKITTY_OPAQUE_LICENSE.md (repository root and curry/).
--
-- Core vocabulary of the evidence graph: node kinds, hypotheses, premises,
-- Horn-style rules, assumptions, citations and the knowledge base built from
-- ingested LRD-REC-v1 records.

module Evidence
  ( NodeKind(..), showKind
  , Hyp(..), allHyps, hypName, hypKind
  , FactPat(..), Premise(..), Rule(..), CounterRule(..)
  , Citation(..), Literature(..), Assumption(..)
  , KB(..), buildKB, featuresOf, obsIds, recId, isSynthetic
  ) where

import Data.List (nub, isPrefixOf)
import LrdRec
import Qty

-- | The nine node kinds required by TASK 012.
data NodeKind
  = KObservation | KSpectralFeature | KStellarModel | KBlackHoleModel
  | KDustModel | KCompositeModel | KProvenance | KProofObligation
  | KCounterevidence
  deriving (Eq, Show)

showKind :: NodeKind -> String
showKind KObservation     = "observation"
showKind KSpectralFeature = "spectral-feature"
showKind KStellarModel    = "stellar-model"
showKind KBlackHoleModel  = "black-hole-model"
showKind KDustModel       = "dust-model"
showKind KCompositeModel  = "composite-model"
showKind KProvenance      = "provenance"
showKind KProofObligation = "proof-obligation"
showKind KCounterevidence = "counterevidence"

-- | Candidate explanations (model hypotheses). Each one is a node of a model
--   kind once it is instantiated for an observation.
data Hyp
  = HBlr            -- broad Halpha from an AGN broad-line region
  | HRedAgn         -- rest-optical continuum = dust-reddened AGN
  | HDenseGasBreak  -- non-stellar Balmer break from dense gas around the AGN
  | HXrayWeak       -- intrinsically X-ray weak AGN
  | HStarburst      -- stellar-dominated compact dusty starburst
  | HHostUV         -- rest-UV from host-galaxy stars
  | HHotTorus       -- hot-dust torus emission in rest-NIR
  | HGrayDust       -- gray dust attenuation curve produces the V shape
  | HComposite      -- reddened AGN (optical) + host stars (UV)
  deriving (Eq, Show)

allHyps :: [Hyp]
allHyps = [HBlr, HRedAgn, HDenseGasBreak, HXrayWeak, HStarburst, HHostUV,
           HHotTorus, HGrayDust, HComposite]

hypName :: Hyp -> String
hypName HBlr           = "bh-broad-line-region"
hypName HRedAgn        = "bh-reddened-agn-continuum"
hypName HDenseGasBreak = "bh-dense-gas-balmer-break"
hypName HXrayWeak      = "bh-intrinsically-xray-weak"
hypName HStarburst     = "stellar-compact-dusty-starburst"
hypName HHostUV        = "stellar-host-uv"
hypName HHotTorus      = "dust-hot-torus"
hypName HGrayDust      = "dust-gray-attenuation"
hypName HComposite     = "composite-reddened-agn-plus-host-uv"

hypKind :: Hyp -> NodeKind
hypKind HBlr           = KBlackHoleModel
hypKind HRedAgn        = KBlackHoleModel
hypKind HDenseGasBreak = KBlackHoleModel
hypKind HXrayWeak      = KBlackHoleModel
hypKind HStarburst     = KStellarModel
hypKind HHostUV        = KStellarModel
hypKind HHotTorus      = KDustModel
hypKind HGrayDust      = KDustModel
hypKind HComposite     = KCompositeModel

-- | Tests on spectral-feature records of the observation under study.
--   NumGT feature field threshold : value(field) > threshold, graded with
--                                   the record's `<field>_sigma`.
--   NumLT feature field threshold : value(field) < threshold.
--   StatusIs feature status       : categorical field `status` equals value.
data FactPat
  = NumGT String String Q
  | NumLT String String Q
  | StatusIs String String
  deriving (Eq, Show)

-- | Horn-clause body atoms: a fact test or another hypothesis (sub-goal).
data Premise = Fact FactPat | Sub Hyp
  deriving (Eq, Show)

-- | A literature source that was verified against a real copy (see
--   curry/STATUS.md, "Citations").
data Literature = Literature
  { litId      :: String
  , litRef     :: String
  , litArxiv   :: String
  , litChecked :: String }
  deriving (Eq, Show)

-- | Either verified literature (ids + where in the paper), or an open proof
--   obligation when no source could be verified.
data Citation
  = Cited [String] String
  | OpenCitation String String     -- obligation id, explanation
  deriving (Eq, Show)

data Assumption = Assumption
  { asId   :: String
  , asText :: String }
  deriving (Eq, Show)

-- | head :- body. Derivability of the head is *never* scientific
--   confirmation; it only means the head follows from the body under the
--   listed assumptions.
data Rule = Rule
  { rId          :: String
  , rHead        :: Hyp
  , rBody        :: [Premise]
  , rAssumptions :: [String]
  , rCitation    :: Citation
  , rClaim       :: String }
  deriving (Eq, Show)

-- | Counterevidence rule: if `ceWhen` holds for the observation, it attacks
--   assumption `ceAttacks` of hypothesis `ceTarget`.
data CounterRule = CounterRule
  { ceId       :: String
  , ceTarget   :: Hyp
  , ceAttacks  :: String
  , ceWhen     :: FactPat
  , ceCitation :: Citation
  , ceClaim    :: String }
  deriving (Eq, Show)

-- | Knowledge base: the ingested records, split by `kind`.
data KB = KB
  { kbObs   :: [Record]
  , kbFeats :: [Record]
  , kbProvs :: [Record]
  , kbAll   :: [Record] }

recId :: Record -> String
recId = fieldOr "?" "id"

isSynthetic :: Record -> Bool
isSynthetic r = maybe False ("SYNTHETIC" `isPrefixOf`) (field "synthetic" r)

ofKind :: String -> [Record] -> [Record]
ofKind k = filter (\r -> field "kind" r == Just k)

-- | Build and validate the KB. Every record needs `kind` and `id`; ids are
--   unique; observations and features must reference existing provenance
--   records; features must reference an existing observation.
buildKB :: [Record] -> Either String KB
buildKB rs = do
  mapM_ need rs
  let ids = map recId rs
  if length (nub ids) /= length ids then Left "duplicate record id" else Right ()
  let kb = KB (ofKind "observation" rs) (ofKind "spectral_feature" rs)
              (ofKind "provenance" rs) rs
      provIds = map recId (kbProvs kb)
      obIds   = map recId (kbObs kb)
  mapM_ (refTo "provenance" provIds) (kbObs kb ++ kbFeats kb)
  mapM_ (refTo "obs" obIds) (kbFeats kb)
  mapM_ (needF "feature") (kbFeats kb)
  return kb
 where
  need r = case (field "kind" r, field "id" r) of
    (Just _, Just _) -> Right ()
    _                -> Left "record without kind/id"
  needF f r = maybe (Left (recId r ++ ": missing " ++ f)) (const (Right ())) (field f r)
  refTo f ids r = case field f r of
    Just v | v `elem` ids -> Right ()
    Just v  -> Left (recId r ++ ": " ++ f ++ "=" ++ v ++ " does not resolve")
    Nothing -> Left (recId r ++ ": missing " ++ f)

featuresOf :: KB -> String -> String -> [Record]
featuresOf kb o fe =
  filter (\r -> field "obs" r == Just o && field "feature" r == Just fe) (kbFeats kb)

obsIds :: KB -> [String]
obsIds kb = map recId (kbObs kb)
