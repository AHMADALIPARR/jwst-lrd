<!-- SPDX-License-Identifier: AGPL-3.0-only. Also subject to SNAPKITTY_OPAQUE_LICENSE.md (dual license). -->
# ingest/STATUS.md — TASK 002 (MAST ingestion)

**This is archive polling of the public MAST API, not telemetry.** Nothing here receives
spacecraft or instrument telemetry; it queries the archive and downloads already-calibrated
public products.

## Target and citation
- Abell 2744-QSO1, image A. Coordinates as printed in Table 1 of
  Furtak, L. J., Zitrin, A., Plat, A., et al. 2023, ApJ 952, 142,
  "JWST UNCOVER: Extremely Red and Compact Object at z_phot ≃ 7.6 Triply Imaged by A2744",
  doi:10.3847/1538-4357/acdc9d, arXiv:2212.10531 (v4):
  `Image A (8296)  R.A. 00:14:19.161  Dec. -30:24:05.664`
  → converted by awk to RA 3.5798375°, Dec −30.4015733°.
- The spectrum paper, Furtak, L. J., Labbé, I., Zitrin, A., et al. 2024, Nature 628, 57–61,
  doi:10.1038/s41586-024-07184-8, arXiv:2308.05735, uses the UNCOVER (GO-2561) NIRSpec prism
  data and points to the 2023 paper for the image positions.

## Pipeline (sh + curl + jq for discovery JSON; C + libcurl for download; C + CFITSIO for parsing)
1. `Mast.Caom.Cone` at the cited position, r = 0.0006° (2.16″) → 1367 rows, 126 NIRSPEC/MSA obs_ids.
2. `Mast.Caom.Filtered` on those obs_ids + JWST, NIRSPEC/MSA, proposal 2561, calib_level 3,
   PUBLIC, spectrum → keep source-level (`_s<id>_`) observations whose footprint box contains
   the target: `jw02561-o002_s000013123` and `jw02561-o006_s000024175`.
3. `Mast.Caom.Products` → the public `X1D` product.
4. `https://mast.stsci.edu/api/v0.1/Download/file?uri=...` via `lrd_fetch` (libcurl, streaming,
   6 retries, HTTP Range resume, rejects servers that ignore Range), SHA-256 (OpenSSL EVP).
5. Raw ID = sha256; stored at `fixtures/raw/<sha>.fits`, mode 0444.
6. `lrd_fitsx` (CFITSIO): keywords and WAVELENGTH/FLUX/FLUX_ERROR with TUNITn →
   LRD-ARR-v1 arrays; `lrd_rec` writes the LRD-REC-v1 manifest + LRD-COMMIT-v1 commitment.
   `SEL_OBS_ID` in `ingest/target.conf` selects the primary; it must be among the discovered candidates.

## Products (both committed to git)
| role | obsid | file | sha256 | bytes | DATE-OBS | rows |
|---|---|---|---|---|---|---|
| PRIMARY (fixtures/ingest/CURRENT) | 230168921 | jw02561-o006_s000024175_nirspec_clear-prism_x1d.fits | `c0b878576d7d7ec723c5ee526d29715fb672d81e45bc8ba4e02598ce8b9c5ee7` | 6347520 | 2024-07-31 | 429 |
| secondary | 300843505 | jw02561-o002_s000013123_nirspec_clear-prism_x1d.fits | `09bcd9077647ebf4fdaa766807de832bf6a94b92e3ed73fdb8a3c0281ae50c31` | 10941120 | 2023-07-31 | 421 |

MAST URIs: `mast:JWST/product/<file>`. Both are NIRSPEC, EXP_TYPE NRS_MSASPEC, GRATING PRISM, FILTER CLEAR,
CAL_VER 3.0.0, CRDS_CTX jwst_1584.pmap, TUNIT: WAVELENGTH um, FLUX Jy, FLUX_ERROR Jy.
BUNIT is absent from both the primary and EXTRACT1D headers (written as `ABSENT`, not invented).
TARGNAME is present but empty (`''`) in o006; o002 has `uncover_nircam`. RA_TARG/DEC_TARG are absent;
JWST uses TARG_RA/TARG_DEC (the MSA pointing target), which are also recorded.

**Why o006 is primary:** the o002 x1d we retrieved has a globally negative FLUX column
(continuum and the Hβ/Hα features are all negative, e.g. −1.37e−06 Jy at 5.279 µm), i.e. an
inverted trace in this reprocessing. o006 (the 2024 repeat of image A) is positive with clear Hβ
and Hα. o002 is kept as a verified fixture for provenance only. The o006 file was downloaded
twice independently (once to /tmp, once by the pipeline) with identical sha256.

## Measured pointing separations (tests/ingest pointing_within_cone_*; haversine, CFITSIO SRCRA/SRCDEC)
    09bcd9077647ebf4fdaa766807de832bf6a94b92e3ed73fdb8a3c0281ae50c31 jw02561-o002_s000013123_nirspec_clear-prism_x1d.fits SRCRA/SRCDEC ra=3.5798285586361156 dec=-30.40156942018814 sep_arcsec=0.031132 cone_arcsec=2.160
    c0b878576d7d7ec723c5ee526d29715fb672d81e45bc8ba4e02598ce8b9c5ee7 jw02561-o006_s000024175_nirspec_clear-prism_x1d.fits SRCRA/SRCDEC ra=3.57983163662 dec=-30.40156918527 sep_arcsec=0.023547 cone_arcsec=2.160

## Layout under fixtures/ (decision: raw FITS committed to git)
- `fixtures/raw/<sha>.fits` — raw products, committed (17.3 MB total). Git does not keep mode 0444, so the
  pipeline, `make fixtures` and the tests re-assert `chmod 0444` before verifying.
- `fixtures/ingest/<sha>/{wavelength,flux,flux_error}.{f64,hdr}` — LRD-ARR-v1 (TUNIT preserved, `source_sha256` set).
- `fixtures/ingest/<sha>/manifest.{kv,rec,commit}` — LRD-REC-v1 manifest and commitment;
  `source.kv`, `header.kv`, `mast/*.json` (discovery evidence).
- `make fixtures` — re-fetches any missing raw file from its recorded MAST URL and verifies sha256 + size
  (with LRD_OFFLINE=1 it only verifies).

Manifest commitments: o006 `0bc8d615fb000a42f70e218a85652edff62a50211b3f264a0c055325bb595854`, o002 `59abe914b5aa2cd8fd80e909b8c236a127c843d06c16ed5fc4aa3f157d56040f`.

## Verified
- Online ingest ran end to end twice against live MAST (2026-10-19 PDT).
- Offline replay (`LRD_OFFLINE=1`, run inside `unshare -rn`, i.e. no network namespace) — verbatim:
```
lrd_ingest: offline replay of 09bcd9077647ebf4fdaa766807de832bf6a94b92e3ed73fdb8a3c0281ae50c31 (no network)
OFFLINE_REPLAY_OK sha256=09bcd9077647ebf4fdaa766807de832bf6a94b92e3ed73fdb8a3c0281ae50c31 commit=59abe914b5aa2cd8fd80e909b8c236a127c843d06c16ed5fc4aa3f157d56040f network_calls=0
lrd_ingest: offline replay of c0b878576d7d7ec723c5ee526d29715fb672d81e45bc8ba4e02598ce8b9c5ee7 (no network)
OFFLINE_REPLAY_OK sha256=c0b878576d7d7ec723c5ee526d29715fb672d81e45bc8ba4e02598ce8b9c5ee7 commit=0bc8d615fb000a42f70e218a85652edff62a50211b3f264a0c055325bb595854 network_calls=0
exit=0
```
- tests/ingest/run.sh — verbatim:
```
PASS build_ingest_tools
PASS sha256_known_answer
PASS fixture_present
PASS checksum_fixture_matches_raw_id
PASS size_matches_mast_metadata
PASS checksum_mismatch_fails_loudly
PASS header_keywords_match_raw_cards
PASS header_required_fields_present
PASS header_extraction_reproducible
PASS lrd_arr_v1_arrays
PASS lrd_rec_v1_vector
PASS lrd_rec_v1_rejects_duplicates
PASS manifest_commitment_reproducible
PASS offline_fetch_refused
PASS range_resume_reproduces_sha256
PASS offline_replay_no_network
PASS pointing_within_cone_09bcd9077647ebf4fdaa766807de832bf6a94b92e3ed73fdb8a3c0281ae50c31
PASS pointing_within_cone_c0b878576d7d7ec723c5ee526d29715fb672d81e45bc8ba4e02598ce8b9c5ee7
exit=0
```

## Open issues
- The o002 inverted-trace product: cause not investigated beyond inspecting the FLUX values.
- Retry/resume against a real interrupted HTTP transfer is not tested automatically; Range resume is
  tested over file://. The HTTP 200-on-Range fallback path is untested.
- The cone uses the image-A position only; images B and C were not ingested.
- License header: the user said AGPL-3.0-only; SNAPKITTY_OPAQUE_LICENSE.md mentions AGPL-3.0-or-later for
  modified portions. Files carry `AGPL-3.0-only` + a pointer to the SnapKitty license; Hilbert should reconcile.
- CONTRACTS/brief mention docs/STATUS; there is no docs/ in the repo and I do not own it, so the
  "archive polling, not telemetry" statement is here at the top.

## LRD-STATE-v1 observation transitions (added after merging main @ fe40382, header from 7c0c393)
- `ingest/src/lrd_obs.c` includes `ledger/abi/lrd_state.h` unmodified. It implements an `lrd_transition_fn`
  for `kind=observation`, with the fixtures directory bound as context (CONTRACTS v1.1 wrapper rule).
- Chain (`ingest/emit_obs_chain.sh`, plan `ingest/obs_chain.plan`, in ingestion order), files under
  `fixtures/state/observation/`:
  - `0001.{proposal,decision,state}.rec`: payload 09bcd907… (o002), `obs_science_use=provenance_only`,
    `obs_quality_flag=flux_globally_negative`, new_commit 2bd1c79e23141f7bb24d985c822edfbd47499d57202105e94f370324eb3fdece
  - `0002.{proposal,decision,state}.rec`: payload c0b87857… (o006), `obs_science_use=primary`, `obs_quality_flag=none`,
    new_commit 0de2e8bc22c14fa0040c6664ff5c6514bf6e0a5ef4495af7d68ea082c8391dfb (= `HEAD`)
- payload_sha256 = sha256 of the raw FITS (the raw ID). Kind-specific fields: `obs_manifest_commit`, `obs_mast_obsid`,
  `obs_product`, `obs_quality_flag`, `obs_science_use` (exactly these, each once).
- new_commit = LRD-REC-v1 commitment of `{commit=prev_commit, kind, payload_sha256, seq}` (v1.1).
- Check order: malformed → wrong_kind → stale_seq → bad_prev → bad_payload (raw file missing or hash differs, or
  manifest commitment differs) → ACCEPT/ok. A REJECT never writes a state file.
- **Assumption to confirm with the ledger owner:** genesis is a virtual state with seq 0 whose commitment is 64 zeros,
  so the first proposal has `prev_commit=0^64, seq=1`. This matches the ledger track's own test (`test_godel.c`).
- Tests (tests/ingest): reproducibility, commitments re-derived independently with `lrd_rec`, flags,
  and rejections (stale_seq ×2, bad_prev, bad_payload ×2, wrong_kind, malformed ×2) plus an accept control.
