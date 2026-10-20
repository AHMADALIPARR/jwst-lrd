-- Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
-- SPDX-License-Identifier: AGPL-3.0-only. Also subject to the SnapKitty Opaque License (dual license).
-- See LICENSE and SNAPKITTY_OPAQUE_LICENSE.md (repository root and curry/).
--
-- Adapter for the real t001-ingest-fortran outputs (Foundry J Spec):
--   * fixtures/ingest/<sha>/manifest.rec    LRD-REC-v1 provenance manifest
--   * fixtures/reference/<sha>/reference.rec LRD-REC-v1 Fortran-kernel
--                                            spectral-feature output
-- Both are copied verbatim into two provenance records (prefixes
-- `manifest.` and `reference.`), so nothing is lost. Observation and
-- spectral-feature records are derived from them:
--   * decimals such as `1.4887615668108563E+003` become the exact rational
--     they denote (Qty.parseDecimal); the original text is kept in
--     `<field>_decimal`;
--   * a field gets a `<field>_sigma` only when the kernel reported an error
--     for it (`*_err*` keys). Nothing is estimated or filled in.
-- The two inputs must describe the same raw file (reference.source_sha256 ==
-- manifest.raw.sha256), otherwise ingestion fails.

module T001 (ingestT001) where

import Data.List (isPrefixOf, isSuffixOf, nub, sort)
import LrdRec
import Qty

ingestT001 :: Record -> Record -> Either String [Record]
ingestT001 man ref = do
  rawSha <- req "manifest" "raw.sha256" man
  srcSha <- req "reference" "source_sha256" ref
  if rawSha /= srcSha
    then Left ("reference.source_sha256 " ++ srcSha ++ " /= manifest.raw.sha256 " ++ rawSha)
    else Right ()
  z    <- num "z.weighted_mean"
  zErr <- num "z.weighted_mean_err"
  let tag12  = take 12 rawSha
      provM  = "PROV-T001-MANIFEST-" ++ tag12
      provR  = "PROV-T001-REFERENCE-" ++ tag12
      obs    = "OBS-T001-" ++ tag12
      origin = ("data_origin", "real: t001-ingest-fortran (Foundry J Spec), raw sha256 " ++ rawSha)
      pM = [ ("kind", "provenance"), ("id", provM), origin
           , ("source", "t001-ingest-fortran fixtures/ingest/" ++ rawSha ++ "/manifest.rec (verbatim copy below)") ]
           ++ [ ("manifest." ++ k, v) | (k, v) <- man ]
      pR = [ ("kind", "provenance"), ("id", provR), origin
           , ("source", "t001-ingest-fortran fixtures/reference/" ++ rawSha ++ "/reference.rec (verbatim copy below)") ]
           ++ [ ("reference." ++ k, v) | (k, v) <- ref ]
      ob = [ ("kind", "observation"), ("id", obs), origin, ("provenance", provM)
           , ("derived_with", provR)
           , ("redshift", showQ z), ("redshift_sigma", showQ zErr)
           , ("redshift_decimal", fieldOr "" "z.weighted_mean" ref)
           , ("redshift_sigma_decimal", fieldOr "" "z.weighted_mean_err" ref)
           , ("redshift_method", "Fortran kernel weighted mean over " ++ fieldOr "?" "z.n_lines_used" ref ++ " matched lines") ]
           ++ copyM "target" "target.name" ++ copyM "obs_id" "mast.obs_id"
           ++ copyM "instrument" "fits.hdr.INSTRUME" ++ copyM "grating" "fits.hdr.GRATING"
           ++ copyM "filter" "fits.hdr.FILTER" ++ copyM "date_obs" "fits.hdr.DATE-OBS"
      copyM k mk = maybe [] (\v -> [(k, v)]) (field mk man)
      lineNames  = groupNames "line." ref
      modelNames = groupNames "model." ref
  ls <- mapM (lineRec obs provR origin tag12) lineNames
  ms <- mapM (modelRec obs provR origin tag12) modelNames
  return ([pM, pR, ob] ++ ls ++ concat ms)
 where
  req what k r = maybe (Left (what ++ ": missing " ++ k)) Right (field k r)
  num k = do s <- req "reference" k ref
             maybe (Left ("reference: " ++ k ++ " is not a decimal: " ++ s)) Right (parseDecimal s)
  -- names L that have a `<prefix>L.status` key
  groupNames p r = sort (nub [ takeWhile (/= '.') (drop (length p) k)
                             | (k, _) <- r, p `isPrefixOf` k, ".status" `isSuffixOf` k ])
  -- value (and sigma when an error key exists) of `<prefix><L>.<f>`
  measured pre l f errKey out = do
    case field (pre ++ l ++ "." ++ f) ref of
      Nothing -> Right []
      Just s  -> do
        v <- dec s
        sg <- case errKey >>= \e -> field (pre ++ l ++ "." ++ e) ref of
                Nothing -> Right []
                Just es -> do e' <- dec es
                              Right [(out ++ "_sigma", showQ e'), (out ++ "_sigma_decimal", es)]
        Right ([(out, showQ v), (out ++ "_decimal", s)] ++ sg)
  dec s = maybe (Left ("reference: not a decimal: " ++ s)) Right (parseDecimal s)
  lineRec obs provR origin t l = do
    fs <- fmap concat (mapM (\(f, e, o) -> measured "line." l f e o)
            [ ("flux_cgs", Just "flux_err_cgs", "flux_cgs")
            , ("z", Just "z_err", "z")
            , ("centroid_obs_ang", Just "centroid_err_ang", "centroid_obs_ang")
            , ("rest_vac_ang", Nothing, "rest_vac_ang") ])
    Right ([ ("kind", "spectral_feature"), ("id", "FEAT-T001-" ++ t ++ "-LINE-" ++ l)
           , ("obs", obs), ("feature", "line_" ++ l), ("provenance", provR), origin
           , ("status", fieldOr "?" ("line." ++ l ++ ".status") ref)
           , ("measured_by", "t001 Fortran kernel line matcher (line." ++ l ++ ".*)") ] ++ fs)
  -- Gaussian line model -> broad_<line> feature (FWHM, uncorrected).
  modelRec obs provR origin t l
    | field ("model." ++ l ++ ".status") ref /= Just "ok" = Right []
    | otherwise = do
        fw <- measured "model." l "fwhm_kms_uncorrected" Nothing "fwhm_kms"
        dc <- measured "model." l "delta_chi2" Nothing "delta_chi2"
        Right [ [ ("kind", "spectral_feature"), ("id", "FEAT-T001-" ++ t ++ "-BROAD-" ++ l)
                , ("obs", obs), ("feature", "broad_" ++ lower l), ("provenance", provR), origin
                , ("model_status", "ok")
                , ("fwhm_correction", "uncorrected: instrumental line-spread function not removed")
                , ("uncertainty_note", "the t001 kernel reports no FWHM uncertainty; none is assumed")
                , ("measured_by", "t001 Fortran kernel single-Gaussian fit (model." ++ l ++ ".*)") ]
                ++ fw ++ dc ]
  lower s = case s of
    (c:cs) | c >= 'A' && c <= 'Z' -> toEnum (fromEnum c + 32) : cs
    _ -> s
