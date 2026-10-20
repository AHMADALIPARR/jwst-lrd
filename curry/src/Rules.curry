-- Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
-- SPDX-License-Identifier: AGPL-3.0-only. Also subject to the SnapKitty Opaque License (dual license).
-- See LICENSE and SNAPKITTY_OPAQUE_LICENSE.md (repository root and curry/).
--
-- The rule base. Every model-claim rule carries either a citation to a paper
-- that was actually read (arXiv abstract/HTML page fetched on 2026-10-19, see
-- curry/STATUS.md) or an OpenCitation, which the engine turns into a Proof
-- obligation node. Numeric thresholds are only those stated verbatim in the
-- cited paper; the locator string says where.
--
-- The rule base is written as a *nondeterministic* nullary operation
-- `anyRule`, i.e. a set of clauses in logic-programming style. `ruleFor`
-- selects the clauses whose head unifies with a (possibly free) hypothesis.

module Rules
  ( literature, assumptions, rules, counterRules, exclusivePairs
  , anyRule, ruleFor, assumptionText, citationObligations
  ) where

import Evidence
import Qty

literature :: [Literature]
literature =
  [ Literature "LIT-GREENE2024"
      "Greene, J. E. et al. 2024, ApJ 964, 39: UNCOVER spectroscopy confirms a surprising ubiquity of AGN in red galaxies at z>5"
      "arXiv:2309.05714" "2026-10-19"
  , Literature "LIT-MATTHEE2024"
      "Matthee, J. et al. 2024, ApJ 963, 129: Little Red Dots: an abundant population of faint AGN at z~5 revealed by the EIGER and FRESCO JWST surveys"
      "arXiv:2306.05448" "2026-10-19"
  , Literature "LIT-KOCEVSKI2024"
      "Kocevski, D. D. et al. 2024 (arXiv preprint): The Rise of Faint, Red AGN at z>4: A Sample of Little Red Dots in the JWST Extragalactic Legacy Fields"
      "arXiv:2404.03576" "2026-10-19"
  , Literature "LIT-PEREZGONZALEZ2024"
      "Perez-Gonzalez, P. G. et al. 2024 (arXiv preprint): What is the nature of Little Red Dots and what is not, MIRI SMILES edition"
      "arXiv:2401.08782" "2026-10-19"
  , Literature "LIT-INAYOSHI-MAIOLINO2024"
      "Inayoshi, K. & Maiolino, R. 2024 (arXiv preprint): Extremely Dense Gas around Little Red Dots and High-redshift AGNs: A Non-stellar Origin of the Balmer Break and Absorption Features"
      "arXiv:2409.07805" "2026-10-19"
  ]

assumptions :: [Assumption]
assumptions =
  [ Assumption "A-LINE-ID"
      "the broad line is Halpha at the catalogued redshift (not a Paschen line of a lower-z interloper)"
  , Assumption "A-BLR-KINEMATICS"
      "the broad component traces broad-line-region gas, not star-formation- or AGN-driven outflows or supernovae"
  , Assumption "A-EXTRAGALACTIC"
      "the source is extragalactic (not a brown-dwarf contaminant)"
  , Assumption "A-AGN-TEMPLATE"
      "the intrinsic AGN continuum follows the assumed template and is reddened by an SMC-like curve, extending into the rest-NIR"
  , Assumption "A-XRAY-STANDARD"
      "the AGN has a typical X-ray-to-optical luminosity ratio"
  , Assumption "A-STARS-DOMINATE-OPTICAL"
      "stellar light dominates the rest-UV-to-optical continuum"
  , Assumption "A-IMF"
      "a universal Chabrier IMF applies"
  , Assumption "A-NIR-STELLAR-BUMP"
      "the rest-NIR flattening is the 1.6 micron stellar bump"
  , Assumption "A-HOST-UV"
      "the rest-UV is host-galaxy star light rather than scattered or leaked AGN light"
  , Assumption "A-DENSE-GAS"
      "dense neutral gas surrounds the accretion disk with enough n=2 hydrogen to absorb blueward of the Balmer limit"
  , Assumption "A-TORUS-TEMPLATE"
      "the rest-NIR follows a hot-dust AGN torus template"
  , Assumption "A-GRAY-CURVE"
      "the dust attenuation curve is gray in the rest-UV"
  , Assumption "A-SUPER-EDDINGTON"
      "accretion is super-Eddington, suppressing intrinsic X-ray emission"
  ]

assumptionText :: String -> String
assumptionText a = case filter ((== a) . asId) assumptions of
  (x:_) -> asText x
  []    -> "(unknown assumption)"

-- Fact patterns shared by several rules (thresholds are from the papers).
broadHalpha :: FactPat
broadHalpha = NumGT "broad_halpha" "fwhm_kms" (mkQ 2000 1)

redOptical :: FactPat
redOptical = NumGT "sed_vshape" "beta_opt" (mkQ 0 1)

blueUV :: FactPat
blueUV = NumLT "sed_vshape" "beta_uv" (mkQ (-37) 100)

notBrownDwarf :: FactPat
notBrownDwarf = NumGT "sed_vshape" "beta_uv" (mkQ (-14) 5)

vShape :: [Premise]
vShape = [Fact redOptical, Fact blueUV, Fact notBrownDwarf]

rules :: [Rule]
rules =
  [ Rule "R-BLR-01" HBlr [Fact broadHalpha]
      ["A-LINE-ID", "A-BLR-KINEMATICS", "A-EXTRAGALACTIC"]
      (Cited ["LIT-GREENE2024", "LIT-MATTHEE2024"]
        "Greene+2024 sec. IV.2 (broad Halpha requires two-component FWHM>2000 km/s); Matthee+2024 sec. IV.1 (case for an AGN origin of broad Halpha)")
      "broad Halpha is emitted by an AGN broad-line region"
  , Rule "R-REDAGN-01" HRedAgn (Sub HBlr : vShape)
      ["A-AGN-TEMPLATE", "A-XRAY-STANDARD", "A-EXTRAGALACTIC"]
      (Cited ["LIT-GREENE2024", "LIT-KOCEVSKI2024"]
        "Greene+2024 sec. VI.1 (rest-optical dominated by a dusty broad-line AGN continuum); Kocevski+2024 sec. III.1 (V-shape: beta_opt>0, beta_UV<-0.37; brown-dwarf cut beta_UV>-2.8)")
      "the red rest-optical continuum is a dust-reddened AGN continuum"
  , Rule "R-DENSEGAS-01" HDenseGasBreak
      [Sub HBlr, Fact (StatusIs "balmer_break" "detected"), Fact (StatusIs "balmer_absorption" "detected")]
      ["A-DENSE-GAS"]
      (Cited ["LIT-INAYOSHI-MAIOLINO2024"]
        "Inayoshi & Maiolino 2024 abstract and sec. II-III (Balmer break and Balmer absorption from dense gas, no stellar component needed)")
      "the Balmer break is non-stellar, imprinted by dense gas around the AGN"
  , Rule "R-XRAYWEAK-01" HXrayWeak
      [Sub HRedAgn, Fact (StatusIs "xray" "not_detected")]
      ["A-SUPER-EDDINGTON"]
      (OpenCitation "OBL-CITE-XRAYWEAK"
        "no primary source verified; Kocevski+2024 sec. IV.4.3 only reports that intrinsic X-ray weakness via super-Eddington accretion has been proposed")
      "the AGN is intrinsically X-ray weak"
  , Rule "R-STARBURST-01" HStarburst
      (vShape ++ [Fact (StatusIs "miri_nir_slope" "flat")])
      ["A-STARS-DOMINATE-OPTICAL", "A-IMF", "A-NIR-STELLAR-BUMP", "A-EXTRAGALACTIC"]
      (Cited ["LIT-PEREZGONZALEZ2024"]
        "Perez-Gonzalez+2024 abstract and sec. VI (rest-NIR flattening consistent with a 1.6 micron stellar bump; UV-to-optical of most LRDs favoured stellar-dominated)")
      "the continuum is dominated by a compact dusty starburst"
  , Rule "R-HOSTUV-01" HHostUV [Fact blueUV, Fact notBrownDwarf]
      ["A-HOST-UV", "A-EXTRAGALACTIC"]
      (Cited ["LIT-GREENE2024", "LIT-KOCEVSKI2024"]
        "Greene+2024 sec. VI.1 (UV from host star formation cannot be ruled out); Kocevski+2024 abstract (rest-UV from host galaxies for the X-ray detected LRDs)")
      "the blue rest-UV is host-galaxy star light"
  , Rule "R-TORUS-01" HHotTorus
      [Sub HBlr, Fact (StatusIs "miri_nir_slope" "rising")]
      ["A-TORUS-TEMPLATE"]
      (Cited ["LIT-PEREZGONZALEZ2024"]
        "Perez-Gonzalez+2024 sec. III.1 (obscured-AGN torus templates predict a steep rest-NIR rise)")
      "rest-NIR emission is hot dust from an AGN torus"
  , Rule "R-GRAYDUST-01" HGrayDust vShape
      ["A-GRAY-CURVE"]
      (OpenCitation "OBL-CITE-GRAYDUST"
        "primary source not verified; Li et al. 2024 (arXiv:2407.10760) is only known second-hand from the Inayoshi & Maiolino 2024 reference list")
      "a gray attenuation curve produces the V-shaped SED"
  , Rule "R-COMPOSITE-01" HComposite [Sub HRedAgn, Sub HHostUV]
      ["A-AGN-TEMPLATE", "A-HOST-UV"]
      (Cited ["LIT-KOCEVSKI2024", "LIT-GREENE2024"]
        "Kocevski+2024 abstract (reddened AGN dominates rest-optical, host dominates rest-UV); Greene+2024 sec. VI.1")
      "a reddened AGN (optical) plus host stars (UV) composite"
  ]

counterRules :: [CounterRule]
counterRules =
  [ CounterRule "CE-XRAY-01" HRedAgn "A-XRAY-STANDARD"
      (StatusIs "xray" "not_detected")
      (Cited ["LIT-MATTHEE2024", "LIT-KOCEVSKI2024"]
        "Matthee+2024 sec. IV.1 (no X-ray counterparts); Kocevski+2024 sec. IV.4.3 (X-ray undetected LRDs weaker than expected)")
      "X-ray non-detection is in tension with a typical AGN X-ray-to-optical ratio"
  , CounterRule "CE-MIRI-01" HRedAgn "A-AGN-TEMPLATE"
      (StatusIs "miri_nir_slope" "flat")
      (Cited ["LIT-PEREZGONZALEZ2024"]
        "Perez-Gonzalez+2024 sec. III.1 (MIRI photometry below obscured-QSO torus templates)")
      "a flat rest-NIR is in tension with an AGN template extending into the NIR"
  , CounterRule "CE-MIRI-02" HHotTorus "A-TORUS-TEMPLATE"
      (StatusIs "miri_nir_slope" "flat")
      (Cited ["LIT-PEREZGONZALEZ2024"] "Perez-Gonzalez+2024 sec. III.1")
      "a flat rest-NIR is in tension with hot-dust torus emission"
  , CounterRule "CE-BROADLINE-01" HStarburst "A-STARS-DOMINATE-OPTICAL"
      broadHalpha
      (Cited ["LIT-GREENE2024"]
        "Greene+2024 sec. IV (broad Balmer lines as the accepted signature of broad-line-region gas)")
      "a broad Halpha line is in tension with a purely stellar optical continuum"
  ]

-- | Pairs that claim the same physical role and cannot both be the dominant
--   explanation. Both being derivable is reported as a contradiction
--   (underdetermination), never resolved by the engine.
exclusivePairs :: [(Hyp, Hyp, String)]
exclusivePairs =
  [ (HRedAgn, HStarburst, "origin of the rest-optical continuum")
  , (HComposite, HStarburst, "origin of the rest-optical continuum")
  , (HHotTorus, HStarburst, "origin of the rest-NIR emission")
  ]

-- | Nondeterministic clause selection.
anyRule :: Rule
anyRule = foldr1 (?) rules

-- | A rule whose head unifies with h. h may be a free variable: then the
--   search enumerates every hypothesis that has a clause.
ruleFor :: Hyp -> Rule
ruleFor h = (rHead r =:= h) &> r
 where r = anyRule

citationObligations :: [(String, String, String)]
citationObligations = concatMap obl rules
 where
  obl r = case rCitation r of
    OpenCitation o why -> [(o, rId r, why)]
    Cited _ _          -> []
