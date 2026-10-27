<!-- SPDX-License-Identifier: AGPL-3.0-only. Also subject to SNAPKITTY_OPAQUE_LICENSE.md (dual license). -->
<!-- Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited -->
# curry/STATUS.md: TASK 012, Curry functional-logic research engine

Branch `t012-curry`. Author: Nova Parr.

**Code head the runs below were made on: `3e98870`** (full hash
`3e988709fcae7de746444e566afbedd0697b19af`). This file is added by the commit that follows
`3e98870`; no file under `curry/src/`, `curry/*.sh` or `tests/curry/` changed between
the runs and this commit, so the engine tested is the engine on the branch tip. A commit
cannot contain its own hash: the tip hash (the commit that adds this file) is the output of
`git rev-parse t012-curry`,, reported to the project owner with the push.

Toolchain (pinned in `curry/CURRY_VERSION`): PAKCS 3.10.0 on SWI-Prolog 9.2.9, installed
outside the repository by `curry/install-pakcs.sh` (checksum verified). Only Curry and
POSIX shell are used.

## What is real, what is not

| item | state |
|---|---|
| Curry system | REAL, PAKCS 3.10.0 built and run here |
| engine (`curry/src/*.curry`) | REAL: LRD-REC-v1 I/O, exact rationals, Horn-style rules (`Rules.curry`), nondeterministic hypothesis search with `?` and free-variable unification, depth-bounded search, counterevidence and contradiction detection, explanation comparison, s-expression evidence graph |
| real observation data | REAL: c0b87857 (obsid 230168921) t001 manifest and Fortran reference results, read from the `integration` branch checkout (read-only) |
| SYNTHETIC fixture | `curry/fixtures/SYNTHETIC_lrd_obs_manifest.*`, invented values, labelled `SYNTHETIC` in the file name, a header record and every record; used only to exercise rule paths the real data cannot reach |
| model-claim rules | each cites a paper (`LIT-*`, locator string in the rule) or is an open Proof obligation (`OBL-CITE-XRAYWEAK`, `OBL-CITE-GRAYDUST`). No literature numbers other than those printed in the cited paper |

Literature (title/identity confirmed against arxiv.org on 2026-10-26; thresholds spot-checked
in the full text: Greene+2024 FWHM > 2000 km/s, Kocevski+2024 beta_opt > 0, beta_UV < -0.37, brown-dwarf cut beta_UV > -2.8):
arXiv:2309.05714 (Greene+2024), 2306.05448 (Matthee+2024), 2404.03576 (Kocevski+2024),
2401.08782 (Perez-Gonzalez+2024), 2409.07805 (Inayoshi & Maiolino 2024).
`arXiv:2407.10760` (Li+2024) is known only second-hand and is deliberately an open obligation.

Epistemic rule: the engine's only positive status is `derivable-under-assumptions`.
There is no "confirmed" status anywhere (`no-confirmed-status` test).

## Real finding, stated plainly

On the real QSO1 record (c0b87857) **every hypothesis is `not-derivable`**. The reason is in the
data, not the physics: the t001 Fortran kernel reports no FWHM uncertainty, so the engine
refuses to use `fwhm_kms` (rule `R-BLR-01` needs an explicit sigma), and the V-shape, X-ray
and MIRI records are not in the t001 outputs. This is recorded as proof obligations
(`OBL-UNCERTAINTY:...`, `OBL-LSF:...`). It is not evidence against an AGN.

## Test run (verbatim output of `sh tests/curry/run.sh`, run 2026-10-26 on code head 3e98870)

Summary: 16 PASS, 0 FAIL, 0 UNAVAILABLE. Wall time 3 min 49 s.

```
PASS curry-version
# pakcs 3.10.0 (/workspace/jwst-lrd-tools/curry/pakcs-3.10.0/bin/pakcs), SWI-Prolog 9.2.9
PASS build
PASS kv2rec-reproducible
PASS lrdrec-roundtrip
PASS lrdrec-rejects-malformed
PASS synthetic-labelled
PASS hypothesis-search
PASS bounded-search
PASS contradiction-detection
PASS compare-explanations
PASS graph-export
PASS no-confirmed-status
PASS trace-reproducible
# sha256 20946b6fc8bb3c87370893d123306689f84ea33a9c08aadff1703a3005470781 synthetic-search-A
# sha256 53adf513c721169fca72d19170a2bfc10a6a46161d1ae3b3aac9915233598eaa synthetic-compare
# sha256 fbd8ce135a9a4b468d18f2515bac55af59467e6442e69a2af0e830138c3ceccc synthetic-contradictions
# sha256 3edd270b36c1eb7ce6f3deb3f2cf1196c8971c8f644ad1f90587bbff2a626e24 synthetic-graph-1
# real data: /workspace/jwst-lrd-integration (git ec8ffb7) CURRENT=c0b878576d7d7ec723c5ee526d29715fb672d81e45bc8ba4e02598ce8b9c5ee7
# sha256 18bdb7ced0a897dc8517fdb53b439abbf01dc67ac8cd86f82a57a8c5d197274d manifest.rec
# sha256 d22e9d88cf7bca02280e92b38700e166c3aebe50cca0e333ee09be3e3557ad7b reference.rec
PASS real-t001-ingest
PASS real-t001-queries
PASS real-t001-trace-reproducible
# sha256 584ac9b6d8761a48888e5db2955187b8b8cfcc3cb6d3ff326b9d7bed550a1a9f real.lrdrec
# sha256 47ef525e0763dd5253e6bc98f9086ac7efa35660d68de62355fd7e43b4c5c7b1 real-search.sx
# sha256 11a7bd2040be4cd0e8a3cda843495279cf14f223dcf92287fd4de9b11fad200d real-compare.sx
# sha256 bd6f10d5feefb6bf8297a8a182aef58732ebe156fbe19207c15af55fd8546615 real-graph.sx
```

(The `# sha256` lines are of traces whose `(input (path ...))` header holds the scratch path of that
run, so they differ from the hashes of the files below, which were produced with the
paths shown. The test compares two runs byte for byte within the same scratch directory.)

## Verbatim query traces, real data (c0b87857)

Reproduce (paths as used here; `$R` = `/workspace/jwst-lrd-integration/fixtures`):

```
E=curry/build/lrd-engine        # built by curry/build.sh
cur=$(cat $R/ingest/CURRENT)    # c0b878576d7d7ec723c5ee526d29715fb672d81e45bc8ba4e02598ce8b9c5ee7
$E ingest-t001 $R/ingest/$cur/manifest.rec $R/reference/$cur/reference.rec </dev/null > /tmp/t012/real.lrdrec
$E validate    /tmp/t012/real.lrdrec </dev/null
$E search      /tmp/t012/real.lrdrec OBS-T001-c0b878576d7d 4 2 </dev/null
$E compare     /tmp/t012/real.lrdrec FEAT-T001-c0b878576d7d-BROAD-Halpha 4 2 </dev/null
$E contradictions /tmp/t012/real.lrdrec 4 2 </dev/null
```

Input hashes: `sha256 18bdb7ced0a897dc8517fdb53b439abbf01dc67ac8cd86f82a57a8c5d197274d manifest.rec`,
`d22e9d88cf7bca02280e92b38700e166c3aebe50cca0e333ee09be3e3557ad7b reference.rec`,
generated KB `584ac9b6d8761a48888e5db2955187b8b8cfcc3cb6d3ff326b9d7bed550a1a9f real.lrdrec`
(integration checkout at ec8ffb7).

### validate (real KB)

```
(lrd-validate
  (path "/tmp/t012/real.lrdrec")
  (records 10)
  (observations 1)
  (spectral-features 7)
  (provenance 2)
  (synthetic-records 0)
  (canonical-roundtrip ok))
```

### search: all hypotheses for OBS-T001-c0b878576d7d (depth 4, K=2)

```
(lrd-trace
  (format LRD-TRACE-SEXP-v1)
  (engine lrd-curry-engine 0.1.0)
  (compiler pakcs-3.10.0 swi-9.2)
  (query hypothesis-search)
  (params (k-sigma 2) (depth-bound 4))
  (input (path "/tmp/t012/real.lrdrec") (records 10) (synthetic no))
  (epistemic-note "derivable-under-assumptions means the hypothesis follows from the rules, data and listed assumptions; it is not scientific confirmation; not-derivable means no derivation exists from these records within the bound, which is not a refutation")
  (obs OBS-T001-c0b878576d7d)
  (summary
    (hypothesis
      (name bh-broad-line-region)
      (kind black-hole-model)
      (status not-derivable)
      (grade n/a)
      (derivations 0))
    (hypothesis
      (name bh-reddened-agn-continuum)
      (kind black-hole-model)
      (status not-derivable)
      (grade n/a)
      (derivations 0))
    (hypothesis
      (name bh-dense-gas-balmer-break)
      (kind black-hole-model)
      (status not-derivable)
      (grade n/a)
      (derivations 0))
    (hypothesis
      (name bh-intrinsically-xray-weak)
      (kind black-hole-model)
      (status not-derivable)
      (grade n/a)
      (derivations 0))
    (hypothesis
      (name stellar-compact-dusty-starburst)
      (kind stellar-model)
      (status not-derivable)
      (grade n/a)
      (derivations 0))
    (hypothesis
      (name stellar-host-uv)
      (kind stellar-model)
      (status not-derivable)
      (grade n/a)
      (derivations 0))
    (hypothesis
      (name dust-hot-torus)
      (kind dust-model)
      (status not-derivable)
      (grade n/a)
      (derivations 0))
    (hypothesis
      (name dust-gray-attenuation)
      (kind dust-model)
      (status not-derivable)
      (grade n/a)
      (derivations 0))
    (hypothesis
      (name composite-reddened-agn-plus-host-uv)
      (kind composite-model)
      (status not-derivable)
      (grade n/a)
      (derivations 0)))
  (derivations)
  (contradictions)
  (obligations
    (obligation
      (id OBL-CITE-XRAYWEAK)
      (kind open-citation)
      (targets R-XRAYWEAK-01)
      (text "no primary source verified; Kocevski+2024 sec. IV.4.3 only reports that intrinsic X-ray weakness via super-Eddington accretion has been proposed"))
    (obligation
      (id OBL-CITE-GRAYDUST)
      (kind open-citation)
      (targets R-GRAYDUST-01)
      (text "primary source not verified; Li et al. 2024 (arXiv:2407.10760) is only known second-hand from the Inayoshi & Maiolino 2024 reference list"))
    (obligation
      (id OBL-LSF:FEAT-T001-c0b878576d7d-BROAD-Halpha)
      (kind instrumental-broadening-uncorrected)
      (targets FEAT-T001-c0b878576d7d-BROAD-Halpha)
      (text "record states fwhm_correction=uncorrected: instrumental line-spread function not removed; a line width compared with a physical threshold needs the line-spread function removed"))
    (obligation
      (id OBL-LSF:FEAT-T001-c0b878576d7d-BROAD-Hbeta)
      (kind instrumental-broadening-uncorrected)
      (targets FEAT-T001-c0b878576d7d-BROAD-Hbeta)
      (text "record states fwhm_correction=uncorrected: instrumental line-spread function not removed; a line width compared with a physical threshold needs the line-spread function removed"))
    (obligation
      (id OBL-UNCERTAINTY:FEAT-T001-c0b878576d7d-BROAD-Halpha:fwhm_kms)
      (kind missing-uncertainty)
      (targets FEAT-T001-c0b878576d7d-BROAD-Halpha)
      (text "fwhm_kms is present but fwhm_kms_sigma is not; rules testing it cannot use this record until an uncertainty is measured"))))
```

### compare: explanations of the broad Halpha record

```
(lrd-trace
  (format LRD-TRACE-SEXP-v1)
  (engine lrd-curry-engine 0.1.0)
  (compiler pakcs-3.10.0 swi-9.2)
  (query compare-explanations)
  (params (k-sigma 2) (depth-bound 4))
  (input (path "/tmp/t012/real.lrdrec") (records 10) (synthetic no))
  (epistemic-note "derivable-under-assumptions means the hypothesis follows from the rules, data and listed assumptions; it is not scientific confirmation; not-derivable means no derivation exists from these records within the bound, which is not a refutation")
  (compare
    (feature-record FEAT-T001-c0b878576d7d-BROAD-Halpha)
    (feature broad_halpha)
    (obs OBS-T001-c0b878576d7d)
    (candidates 7)
    (explanation
      (hypothesis bh-broad-line-region)
      (kind black-hole-model)
      (status not-derivable)
      (grade n/a)
      (uses-this-record no)
      (diagnosis
        (rule R-BLR-01
          (fact
            (test broad_halpha fwhm_kms > 2000)
            (record FEAT-T001-c0b878576d7d-BROAD-Halpha missing-uncertainty:fwhm_kms_sigma))))
      (counterevidence)
      (rule-assumes A-LINE-ID A-BLR-KINEMATICS A-EXTRAGALACTIC)
      (all-assumptions))
    (explanation
      (hypothesis bh-reddened-agn-continuum)
      (kind black-hole-model)
      (status not-derivable)
      (grade n/a)
      (uses-this-record no)
      (diagnosis
        (rule R-REDAGN-01
          (goal bh-broad-line-region not-derivable)
          (fact (test sed_vshape beta_opt > 0) no-record)
          (fact (test sed_vshape beta_uv < -37/100) no-record)
          (fact (test sed_vshape beta_uv > -14/5) no-record)))
      (counterevidence)
      (rule-assumes A-AGN-TEMPLATE A-XRAY-STANDARD A-EXTRAGALACTIC)
      (all-assumptions))
    (explanation
      (hypothesis bh-dense-gas-balmer-break)
      (kind black-hole-model)
      (status not-derivable)
      (grade n/a)
      (uses-this-record no)
      (diagnosis
        (rule R-DENSEGAS-01
          (goal bh-broad-line-region not-derivable)
          (fact (test balmer_break status = detected) no-record)
          (fact (test balmer_absorption status = detected) no-record)))
      (counterevidence)
      (rule-assumes A-DENSE-GAS)
      (all-assumptions))
    (explanation
      (hypothesis bh-intrinsically-xray-weak)
      (kind black-hole-model)
      (status not-derivable)
      (grade n/a)
      (uses-this-record no)
      (diagnosis
        (rule R-XRAYWEAK-01
          (goal bh-reddened-agn-continuum not-derivable)
          (fact (test xray status = not_detected) no-record)))
      (counterevidence)
      (rule-assumes A-SUPER-EDDINGTON)
      (all-assumptions))
    (explanation
      (hypothesis stellar-compact-dusty-starburst)
      (kind stellar-model)
      (status not-derivable)
      (grade n/a)
      (uses-this-record no)
      (diagnosis
        (rule R-STARBURST-01
          (fact (test sed_vshape beta_opt > 0) no-record)
          (fact (test sed_vshape beta_uv < -37/100) no-record)
          (fact (test sed_vshape beta_uv > -14/5) no-record)
          (fact (test miri_nir_slope status = flat) no-record)))
      (counterevidence)
      (rule-assumes A-STARS-DOMINATE-OPTICAL A-IMF A-NIR-STELLAR-BUMP A-EXTRAGALACTIC)
      (all-assumptions))
    (explanation
      (hypothesis dust-hot-torus)
      (kind dust-model)
      (status not-derivable)
      (grade n/a)
      (uses-this-record no)
      (diagnosis
        (rule R-TORUS-01
          (goal bh-broad-line-region not-derivable)
          (fact (test miri_nir_slope status = rising) no-record)))
      (counterevidence)
      (rule-assumes A-TORUS-TEMPLATE)
      (all-assumptions))
    (explanation
      (hypothesis composite-reddened-agn-plus-host-uv)
      (kind composite-model)
      (status not-derivable)
      (grade n/a)
      (uses-this-record no)
      (diagnosis
        (rule R-COMPOSITE-01
          (goal bh-reddened-agn-continuum not-derivable)
          (goal stellar-host-uv not-derivable)))
      (counterevidence)
      (rule-assumes A-AGN-TEMPLATE A-HOST-UV)
      (all-assumptions))
    (exclusive bh-reddened-agn-continuum stellar-compact-dusty-starburst "origin of the rest-optical continuum")
    (exclusive composite-reddened-agn-plus-host-uv stellar-compact-dusty-starburst "origin of the rest-optical continuum")
    (exclusive dust-hot-torus stellar-compact-dusty-starburst "origin of the rest-NIR emission")))
```

### contradictions (real KB)

```
(lrd-trace
  (format LRD-TRACE-SEXP-v1)
  (engine lrd-curry-engine 0.1.0)
  (compiler pakcs-3.10.0 swi-9.2)
  (query contradiction-detection)
  (params (k-sigma 2) (depth-bound 4))
  (input (path "/tmp/t012/real.lrdrec") (records 10) (synthetic no))
  (epistemic-note "derivable-under-assumptions means the hypothesis follows from the rules, data and listed assumptions; it is not scientific confirmation; not-derivable means no derivation exists from these records within the bound, which is not a refutation")
  (contradictions))
```

## Verbatim query traces, SYNTHETIC fixture (invented values, NOT real data)

These show the rule paths the real data cannot reach: a derivable hypothesis, grading
by uncertainty, bounded search and contradictions. Every value in these records is invented.

```
E=curry/build/lrd-engine
F=curry/fixtures/SYNTHETIC_lrd_obs_manifest.lrdrec
$E search $F OBS-SYN-A 4 2 </dev/null
$E search $F OBS-SYN-A 2 2 </dev/null
$E compare $F FEAT-SYN-A-HALPHA 4 2 </dev/null
$E contradictions $F 4 2 </dev/null
```

### search OBS-SYN-A, depth 4: summary section (lines 1-64 of the output, verbatim)

```
(lrd-trace
  (format LRD-TRACE-SEXP-v1)
  (engine lrd-curry-engine 0.1.0)
  (compiler pakcs-3.10.0 swi-9.2)
  (query hypothesis-search)
  (params (k-sigma 2) (depth-bound 4))
  (input (path "curry/fixtures/SYNTHETIC_lrd_obs_manifest.lrdrec") (records 23) (synthetic yes))
  (epistemic-note "derivable-under-assumptions means the hypothesis follows from the rules, data and listed assumptions; it is not scientific confirmation; not-derivable means no derivation exists from these records within the bound, which is not a refutation")
  (obs OBS-SYN-A)
  (summary
    (hypothesis
      (name bh-broad-line-region)
      (kind black-hole-model)
      (status derivable-under-assumptions)
      (grade robust)
      (derivations 1))
    (hypothesis
      (name bh-reddened-agn-continuum)
      (kind black-hole-model)
      (status derivable-under-assumptions)
      (grade robust)
      (derivations 1))
    (hypothesis
      (name bh-dense-gas-balmer-break)
      (kind black-hole-model)
      (status derivable-under-assumptions)
      (grade robust)
      (derivations 1))
    (hypothesis
      (name bh-intrinsically-xray-weak)
      (kind black-hole-model)
      (status derivable-under-assumptions)
      (grade robust)
      (derivations 1))
    (hypothesis
      (name stellar-compact-dusty-starburst)
      (kind stellar-model)
      (status derivable-under-assumptions)
      (grade robust)
      (derivations 1))
    (hypothesis
      (name stellar-host-uv)
      (kind stellar-model)
      (status derivable-under-assumptions)
      (grade robust)
      (derivations 1))
    (hypothesis
      (name dust-hot-torus)
      (kind dust-model)
      (status not-derivable)
      (grade n/a)
      (derivations 0))
    (hypothesis
      (name dust-gray-attenuation)
      (kind dust-model)
      (status derivable-under-assumptions)
      (grade robust)
      (derivations 1))
    (hypothesis
      (name composite-reddened-agn-plus-host-uv)
      (kind composite-model)
      (status derivable-under-assumptions)
      (grade robust)
      (derivations 1)))
```

### search OBS-SYN-A, depth 2: summary section (lines 1-64 verbatim) and bound obligations (lines 442-end verbatim)

```
(lrd-trace
  (format LRD-TRACE-SEXP-v1)
  (engine lrd-curry-engine 0.1.0)
  (compiler pakcs-3.10.0 swi-9.2)
  (query hypothesis-search)
  (params (k-sigma 2) (depth-bound 2))
  (input (path "curry/fixtures/SYNTHETIC_lrd_obs_manifest.lrdrec") (records 23) (synthetic yes))
  (epistemic-note "derivable-under-assumptions means the hypothesis follows from the rules, data and listed assumptions; it is not scientific confirmation; not-derivable means no derivation exists from these records within the bound, which is not a refutation")
  (obs OBS-SYN-A)
  (summary
    (hypothesis
      (name bh-broad-line-region)
      (kind black-hole-model)
      (status derivable-under-assumptions)
      (grade robust)
      (derivations 1))
    (hypothesis
      (name bh-reddened-agn-continuum)
      (kind black-hole-model)
      (status derivable-under-assumptions)
      (grade robust)
      (derivations 1))
    (hypothesis
      (name bh-dense-gas-balmer-break)
      (kind black-hole-model)
      (status derivable-under-assumptions)
      (grade robust)
      (derivations 1))
    (hypothesis
      (name bh-intrinsically-xray-weak)
      (kind black-hole-model)
      (status undecided-at-bound)
      (grade n/a)
      (derivations 1))
    (hypothesis
      (name stellar-compact-dusty-starburst)
      (kind stellar-model)
      (status derivable-under-assumptions)
      (grade robust)
      (derivations 1))
    (hypothesis
      (name stellar-host-uv)
      (kind stellar-model)
      (status derivable-under-assumptions)
      (grade robust)
      (derivations 1))
    (hypothesis
      (name dust-hot-torus)
      (kind dust-model)
      (status not-derivable)
      (grade n/a)
      (derivations 0))
    (hypothesis
      (name dust-gray-attenuation)
      (kind dust-model)
      (status derivable-under-assumptions)
      (grade robust)
      (derivations 1))
    (hypothesis
      (name composite-reddened-agn-plus-host-uv)
      (kind composite-model)
      (status undecided-at-bound)
      (grade n/a)
      (derivations 1)))
...
    (obligation
      (id OBL-ASSUME:OBS-SYN-A:dust-gray-attenuation:A-GRAY-CURVE)
      (kind unverified-assumption)
      (targets HYP:OBS-SYN-A:dust-gray-attenuation)
      (text "the dust attenuation curve is gray in the rest-UV"))
    (obligation
      (id OBL-BOUND:OBS-SYN-A:bh-intrinsically-xray-weak)
      (kind search-bound-reached)
      (targets HYP:OBS-SYN-A:bh-intrinsically-xray-weak)
      (text "derivation needs depth > 2; rerun with a larger bound"))
    (obligation
      (id OBL-BOUND:OBS-SYN-A:composite-reddened-agn-plus-host-uv)
      (kind search-bound-reached)
      (targets HYP:OBS-SYN-A:composite-reddened-agn-plus-host-uv)
      (text "derivation needs depth > 2; rerun with a larger bound"))))
```

### contradictions, SYNTHETIC fixture

```
(lrd-trace
  (format LRD-TRACE-SEXP-v1)
  (engine lrd-curry-engine 0.1.0)
  (compiler pakcs-3.10.0 swi-9.2)
  (query contradiction-detection)
  (params (k-sigma 2) (depth-bound 4))
  (input (path "curry/fixtures/SYNTHETIC_lrd_obs_manifest.lrdrec") (records 23) (synthetic yes))
  (epistemic-note "derivable-under-assumptions means the hypothesis follows from the rules, data and listed assumptions; it is not scientific confirmation; not-derivable means no derivation exists from these records within the bound, which is not a refutation")
  (contradictions
    (contradiction
      (kind assumption-attacked)
      (obs OBS-SYN-A)
      (hypothesis bh-reddened-agn-continuum)
      (counter-rule CE-XRAY-01)
      (attacks A-XRAY-STANDARD)
      (evidence FEAT-SYN-A-XRAY "status=not_detected")
      (grade robust)
      (resolution none-engine-does-not-adjudicate))
    (contradiction
      (kind assumption-attacked)
      (obs OBS-SYN-A)
      (hypothesis bh-reddened-agn-continuum)
      (counter-rule CE-MIRI-01)
      (attacks A-AGN-TEMPLATE)
      (evidence FEAT-SYN-A-MIRI "status=flat")
      (grade robust)
      (resolution none-engine-does-not-adjudicate))
    (contradiction
      (kind assumption-attacked)
      (obs OBS-SYN-A)
      (hypothesis stellar-compact-dusty-starburst)
      (counter-rule CE-BROADLINE-01)
      (attacks A-STARS-DOMINATE-OPTICAL)
      (evidence FEAT-SYN-A-HALPHA "fwhm_kms=3100 sigma=250")
      (grade robust)
      (resolution none-engine-does-not-adjudicate))
    (contradiction
      (kind exclusive-both-derivable)
      (obs OBS-SYN-A)
      (hypotheses bh-reddened-agn-continuum stellar-compact-dusty-starburst)
      (role "origin of the rest-optical continuum")
      (resolution underdetermined-by-current-evidence))
    (contradiction
      (kind exclusive-both-derivable)
      (obs OBS-SYN-A)
      (hypotheses composite-reddened-agn-plus-host-uv stellar-compact-dusty-starburst)
      (role "origin of the rest-optical continuum")
      (resolution underdetermined-by-current-evidence))
    (contradiction
      (kind data-inconsistent)
      (obs OBS-SYN-D)
      (feature broad_halpha)
      (field fwhm_kms)
      (records FEAT-SYN-D-HALPHA-R1 FEAT-SYN-D-HALPHA-R2)
      (values "3500 sigma=200" "1500 sigma=200")
      (k-sigma 2)
      (resolution none-engine-does-not-adjudicate))))
```

### compare FEAT-SYN-A-HALPHA, SYNTHETIC fixture

```
(lrd-trace
  (format LRD-TRACE-SEXP-v1)
  (engine lrd-curry-engine 0.1.0)
  (compiler pakcs-3.10.0 swi-9.2)
  (query compare-explanations)
  (params (k-sigma 2) (depth-bound 4))
  (input (path "curry/fixtures/SYNTHETIC_lrd_obs_manifest.lrdrec") (records 23) (synthetic yes))
  (epistemic-note "derivable-under-assumptions means the hypothesis follows from the rules, data and listed assumptions; it is not scientific confirmation; not-derivable means no derivation exists from these records within the bound, which is not a refutation")
  (compare
    (feature-record FEAT-SYN-A-HALPHA)
    (feature broad_halpha)
    (obs OBS-SYN-A)
    (candidates 7)
    (explanation
      (hypothesis bh-broad-line-region)
      (kind black-hole-model)
      (status derivable-under-assumptions)
      (grade robust)
      (uses-this-record yes)
      (diagnosis
        (rule R-BLR-01 (fact (test broad_halpha fwhm_kms > 2000) (record FEAT-SYN-A-HALPHA robust))))
      (counterevidence)
      (rule-assumes A-LINE-ID A-BLR-KINEMATICS A-EXTRAGALACTIC)
      (all-assumptions A-LINE-ID A-BLR-KINEMATICS A-EXTRAGALACTIC))
    (explanation
      (hypothesis bh-reddened-agn-continuum)
      (kind black-hole-model)
      (status derivable-under-assumptions)
      (grade robust)
      (uses-this-record yes)
      (diagnosis
        (rule R-REDAGN-01
          (goal bh-broad-line-region derivable-under-assumptions)
          (fact (test sed_vshape beta_opt > 0) (record FEAT-SYN-A-SED robust))
          (fact (test sed_vshape beta_uv < -37/100) (record FEAT-SYN-A-SED robust))
          (fact (test sed_vshape beta_uv > -14/5) (record FEAT-SYN-A-SED robust))))
      (counterevidence
        (finding CE-XRAY-01 FEAT-SYN-A-XRAY "status=not_detected" robust A-XRAY-STANDARD)
        (finding CE-MIRI-01 FEAT-SYN-A-MIRI "status=flat" robust A-AGN-TEMPLATE))
      (rule-assumes A-AGN-TEMPLATE A-XRAY-STANDARD A-EXTRAGALACTIC)
      (all-assumptions A-AGN-TEMPLATE A-XRAY-STANDARD A-EXTRAGALACTIC A-LINE-ID A-BLR-KINEMATICS))
    (explanation
      (hypothesis bh-dense-gas-balmer-break)
      (kind black-hole-model)
      (status derivable-under-assumptions)
      (grade robust)
      (uses-this-record yes)
      (diagnosis
        (rule R-DENSEGAS-01
          (goal bh-broad-line-region derivable-under-assumptions)
          (fact (test balmer_break status = detected) (record FEAT-SYN-A-BREAK holds))
          (fact (test balmer_absorption status = detected) (record FEAT-SYN-A-BABS holds))))
      (counterevidence)
      (rule-assumes A-DENSE-GAS)
      (all-assumptions A-DENSE-GAS A-LINE-ID A-BLR-KINEMATICS A-EXTRAGALACTIC))
    (explanation
      (hypothesis bh-intrinsically-xray-weak)
      (kind black-hole-model)
      (status derivable-under-assumptions)
      (grade robust)
      (uses-this-record yes)
      (diagnosis
        (rule R-XRAYWEAK-01
          (goal bh-reddened-agn-continuum derivable-under-assumptions)
          (fact (test xray status = not_detected) (record FEAT-SYN-A-XRAY holds))))
      (counterevidence)
      (rule-assumes A-SUPER-EDDINGTON)
      (all-assumptions A-SUPER-EDDINGTON A-AGN-TEMPLATE A-XRAY-STANDARD A-EXTRAGALACTIC A-LINE-ID A-BLR-KINEMATICS))
    (explanation
      (hypothesis stellar-compact-dusty-starburst)
      (kind stellar-model)
      (status derivable-under-assumptions)
      (grade robust)
      (uses-this-record no)
      (diagnosis
        (rule R-STARBURST-01
          (fact (test sed_vshape beta_opt > 0) (record FEAT-SYN-A-SED robust))
          (fact (test sed_vshape beta_uv < -37/100) (record FEAT-SYN-A-SED robust))
          (fact (test sed_vshape beta_uv > -14/5) (record FEAT-SYN-A-SED robust))
          (fact (test miri_nir_slope status = flat) (record FEAT-SYN-A-MIRI holds))))
      (counterevidence
        (finding CE-BROADLINE-01 FEAT-SYN-A-HALPHA "fwhm_kms=3100 sigma=250" robust A-STARS-DOMINATE-OPTICAL))
      (rule-assumes A-STARS-DOMINATE-OPTICAL A-IMF A-NIR-STELLAR-BUMP A-EXTRAGALACTIC)
      (all-assumptions A-STARS-DOMINATE-OPTICAL A-IMF A-NIR-STELLAR-BUMP A-EXTRAGALACTIC))
    (explanation
      (hypothesis dust-hot-torus)
      (kind dust-model)
      (status not-derivable)
      (grade n/a)
      (uses-this-record no)
      (diagnosis
        (rule R-TORUS-01
          (goal bh-broad-line-region derivable-under-assumptions)
          (fact (test miri_nir_slope status = rising) (record FEAT-SYN-A-MIRI fails:status=flat))))
      (counterevidence (finding CE-MIRI-02 FEAT-SYN-A-MIRI "status=flat" robust A-TORUS-TEMPLATE))
      (rule-assumes A-TORUS-TEMPLATE)
      (all-assumptions))
    (explanation
      (hypothesis composite-reddened-agn-plus-host-uv)
      (kind composite-model)
      (status derivable-under-assumptions)
      (grade robust)
      (uses-this-record yes)
      (diagnosis
        (rule R-COMPOSITE-01
          (goal bh-reddened-agn-continuum derivable-under-assumptions)
          (goal stellar-host-uv derivable-under-assumptions)))
      (counterevidence)
      (rule-assumes A-AGN-TEMPLATE A-HOST-UV)
      (all-assumptions A-AGN-TEMPLATE A-HOST-UV A-XRAY-STANDARD A-EXTRAGALACTIC A-LINE-ID A-BLR-KINEMATICS))
    (exclusive bh-reddened-agn-continuum stellar-compact-dusty-starburst "origin of the rest-optical continuum")
    (exclusive composite-reddened-agn-plus-host-uv stellar-compact-dusty-starburst "origin of the rest-optical continuum")
    (exclusive dust-hot-torus stellar-compact-dusty-starburst "origin of the rest-NIR emission")))
```

## Graph interface

`lrd-engine graph F DEPTH K` emits the full evidence graph; format in `GRAPH-FORMAT.md`.
Its excerpts there were checked against the output of the commands above (section 7).

## Known limits

* Real data coverage: only the t001 outputs exist for c0b87857, so only `broad_halpha`,
  `broad_hbeta` and line records are present. Records for SED slopes, X-ray, MIRI and the
  Balmer break are not in the real KB, so those rules have no premises to use.
* K (the sigma multiple) is a user parameter, not a literature value.
* A rule is only as good as its cited locator; assumptions stay open obligations
  (`OBL-ASSUME:...`) and are never discharged by the engine.
* Query time on the real KB: about 8 s per search (PAKCS on SWI-Prolog); the test script takes about 4 min.
* The real-data tests read `$LRD_REAL_DATA_DIR` (default `/workspace/jwst-lrd-integration`). If
  absent they print UNAVAILABLE. The integration fixtures were not merged into this branch.
