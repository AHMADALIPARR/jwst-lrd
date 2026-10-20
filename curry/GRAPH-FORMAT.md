<!-- SPDX-License-Identifier: AGPL-3.0-only. Also subject to SNAPKITTY_OPAQUE_LICENSE.md (dual license). -->
<!-- Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited -->
# curry/GRAPH-FORMAT.md: LRD evidence graph and trace format (LRD-TRACE-SEXP-v1)

This is the machine-readable interface of the Curry research engine (TASK 012) for the
Self Morphic console and any other consumer. Everything is plain UTF-8 text on stdout:

* **input**: an LRD-REC-v1 *stream* (records concatenated, each starting with the
  `LRD-REC-v1` line; `research/CONTRACTS.md` defines one record);
* **output**: one s-expression per command, format tag `LRD-TRACE-SEXP-v1`.

Outputs are deterministic. Every list of results is sorted by its own rendered text and
all numbers are exact rationals, so the same input and parameters always give the same
bytes (tested by `tests/curry/run.sh`, `trace-reproducible` and `real-t001-trace-reproducible`).

## 1. Commands

| command | output root | purpose |
|---|---|---|
| `lrd-engine kv2rec F.kv` | LRD-REC-v1 stream | converts `key=value` source (blank line between records, `#` comments) |
| `lrd-engine ingest-t001 MANIFEST.rec REFERENCE.rec` | LRD-REC-v1 stream | converts real t001 outputs into a KB (section 6) |
| `lrd-engine validate F` | `(lrd-validate ...)` | parses, checks references, checks the canonical round trip |
| `lrd-engine rules` | `(lrd-rulebase ...)` | rules, counter-rules, assumptions, literature, exclusive pairs |
| `lrd-engine search F OBS DEPTH K` | `(lrd-trace ... (query hypothesis-search) ...)` | every hypothesis for one observation |
| `lrd-engine compare F FEATURE-ID DEPTH K` | `(lrd-trace ... (compare ...))` | competing explanations for one spectral-feature record |
| `lrd-engine contradictions F DEPTH K` | `(lrd-trace ... (contradictions ...))` | contradictions, all observations |
| `lrd-engine graph F DEPTH K` | `(lrd-trace ... (lrd-graph ...))` | full evidence graph |

`DEPTH` is a positive integer, the maximum rule-nesting depth of a derivation. `K` is a
positive LRD-REC rational (`2`, `5/2`), the number of standard deviations used to grade
evidence. K is a methodological choice of the person running the query, not a literature
value. Errors go to stderr with a nonzero exit status (PAKCS `error`). The process reads
nothing from stdin, so run it with `</dev/null`.

## 2. Grammar (EBNF)

```
sexpr   = atom | string | list ;
list    = "(" , [ sexpr , { ws , sexpr } ] , ")" ;
atom    = achar , { achar } ;                    (* achar: A-Z a-z 0-9 - _ . : / + < > = * *)
string  = '"' , { char - ('"' | "\") | '\"' | "\\" } , '"' ;
ws      = ( " " | "\n" ) , { " " } ;             (* layout only; see below *)
```

Layout: a list that fits in 100 columns is printed on one line. A longer list prints its head
and then one element per line, indented two spaces more. Layout carries no meaning;
consumers must tokenise and not split on lines. Numbers are atoms in LRD-REC rational form
(`-37/100`, `2000`); string attributes carry the original record text.

```
trace      = "(lrd-trace" , header , body , ")" ;
header     = "(format LRD-TRACE-SEXP-v1)" "(engine lrd-curry-engine" version ")"
             "(compiler" compiler runtime ")" "(query" query ")"
             "(params (k-sigma" Q ") (depth-bound" N "))"
             "(input (path" string ") (records" N ") (synthetic" ("yes"|"no") "))"
             "(epistemic-note" string ")" ;
graph      = "(lrd-graph (nodes" { node } ") (edges" { edge } "))" ;
node       = "(node (id" ID ") (kind" node-kind ")" { node-field } ")" ;
edge       = "(edge (from" ID ") (to" ID ") (kind" edge-kind ")" { edge-field } ")" ;
```

## 3. Node kinds

| `kind` | ids | fields |
|---|---|---|
| `observation` | record `id` (`OBS-...`) | `(attrs (attr KEY "VALUE")...)` copies every field of the input record verbatim; `(uncertainty (measure F (value Q) (sigma Q))...)`; `(synthetic yes\|no)` |
| `spectral-feature` | record `id` (`FEAT-...`) | same as observation |
| `provenance` | input provenance records (`PROV-...`) and cited papers (`LIT-...`) | `attrs`; for `LIT-*`: `source literature`, `ref`, `arxiv`, `verified_on` |
| `black-hole-model`, `stellar-model`, `dust-model`, `composite-model` | `HYP:<obs>:<hypothesis>` | `(status S)`, `(grade robust\|marginal\|n/a)`, `(epistemic derivable-is-not-confirmation)`, `(claim "...")`, `(assumptions A...)`, `(rules R...)` |
| `counterevidence` | `CE:<counter-rule>:<obs>:<record>` | `(attacks A)`, `(claim ...)`, `(evidence "...")`, `(grade ...)`, `(citation ...)` |
| `proof-obligation` | `OBL-...` | `(obligation-kind K)`, `(text "...")` |

Hypothesis **status** has three values and nothing else:
* `derivable-under-assumptions`: a complete derivation exists within the depth bound. It
  holds *only under the listed assumptions* and is **not** scientific confirmation.
* `undecided-at-bound`: derivations exist only if a sub-goal is cut at the depth bound
  (`(cut-at-bound H)` in traces, plus an `OBL-BOUND:` obligation).
* `not-derivable`: no derivation exists from these records within the bound. This is
  not a refutation; it often means data are missing (see the `diagnosis` in `compare`).

**Grade** (uncertainty): a numeric premise `v > t` is `robust` if `v - K*sigma > t` and
`marginal` if only `v > t` holds (and symmetrically for `<`). Categorical premises
(`status=...`) are `robust`. A derivation takes the worst grade of its premises, and a
hypothesis takes the best grade of its derivations. A numeric field **without**
`<field>_sigma` never supports a premise: the uncertainty must be explicit
(`OBL-UNCERTAINTY:` obligation).

Obligation kinds: `open-citation` (a rule's model claim has no verified primary source),
`unverified-assumption` (`OBL-ASSUME:<obs>:<hyp>:<A>`, one per assumption of each derivable
hypothesis), `search-bound-reached` (`OBL-BOUND:<obs>:<hyp>`), `missing-uncertainty`
(`OBL-UNCERTAINTY:<record>:<field>`), `instrumental-broadening-uncorrected`
(`OBL-LSF:<record>`, for records with `fwhm_correction=uncorrected...`).

## 4. Edge kinds

| `kind` | from → to | extra fields | meaning |
|---|---|---|---|
| `observed-in` | feature → observation | | the feature was measured in that observation |
| `has-provenance` | observation/feature → provenance | | its `provenance` field |
| `cites` | hypothesis → `LIT-*` | | literature behind the rule(s) of that hypothesis |
| `supports` | feature → hypothesis | `(rule R)` `(grade G)` | the record satisfied a premise in a complete derivation |
| `depends-on` | hypothesis → hypothesis | `(rule R)` | sub-goal used in a complete derivation |
| `attacks` | counterevidence → hypothesis | `(assumption A)` | evidence in tension with an assumption of a derivable hypothesis |
| `derived-from` | counterevidence → feature | | the record that triggered the counter-rule |
| `excludes` | hypothesis → hypothesis | `(role "...")` | both are derivable but compete for the same role |
| `obligates` | obligation → hypothesis/feature | | what the open obligation applies to |

## 5. Input stream schema (LRD-REC-v1 fields read by the engine)

Every record has `kind` and `id` (unique). Other kinds (for example `fixture_header`) are
carried through and ignored by rules.
* `kind=provenance`: free fields.
* `kind=observation`: `provenance` (must resolve). Optional `redshift`, `redshift_sigma`, ...
* `kind=spectral_feature`: `obs` and `provenance` (both must resolve), `feature`, and then:
  * `broad_halpha`: `fwhm_kms`, `fwhm_kms_sigma`;
  * `sed_vshape`: `beta_uv`, `beta_uv_sigma`, `beta_opt`, `beta_opt_sigma`;
  * `xray`, `miri_nir_slope`, `balmer_break`, `balmer_absorption`: `status`.
* `synthetic`: if it starts with `SYNTHETIC`, the record is synthetic (`(synthetic yes)`).

Two numeric records of the same feature and observation that differ by more than K sigma,
`(v1-v2)^2 > K^2 (s1^2+s2^2)` exactly, give a `data-inconsistent` contradiction.

## 6. Real t001 adapter (`ingest-t001`)

It reads `fixtures/ingest/<sha>/manifest.rec` and `fixtures/reference/<sha>/reference.rec`
from t001-ingest-fortran (Foundry J Spec) and refuses unless `reference.source_sha256 ==
manifest.raw.sha256`. It writes:
* `PROV-T001-MANIFEST-<sha12>` and `PROV-T001-REFERENCE-<sha12>`, which copy every input
  field verbatim (prefixes `manifest.` and `reference.`);
* `OBS-T001-<sha12>`: target, obs_id, instrument, grating, filter, date and
  `redshift` = `z.weighted_mean` (exact rational of the printed decimal, original in
  `redshift_decimal`);
* `FEAT-T001-<sha12>-LINE-<L>` (`feature=line_<L>`, `status`, flux/z/centroid with `_sigma` from
  the kernel's `*_err*` keys) and `FEAT-T001-<sha12>-BROAD-<L>` (`feature=broad_<l>`,
  `fwhm_kms` = `fwhm_kms_uncorrected`, **no sigma** because the kernel reports none,
  `fwhm_correction=uncorrected...`).

## 7. Worked example (verbatim excerpts of real runs)

From `lrd-engine graph real.lrdrec 4 2`, real QSO1 data (raw sha256 c0b87857...):

```
      (node
        (id FEAT-T001-c0b878576d7d-BROAD-Halpha)
        (kind spectral-feature)
        (attrs
          (attr data_origin "real: t001-ingest-fortran (Foundry J Spec), raw sha256 c0b878576d7d7ec723c5ee526d29715fb672d81e45bc8ba4e02598ce8b9c5ee7")
          (attr delta_chi2 "7918519319047307/2500000000000")
          (attr delta_chi2_decimal "3.1674077276189228E+003")
          (attr feature "broad_halpha")
          (attr fwhm_correction "uncorrected: instrumental line-spread function not removed")
          (attr fwhm_kms "14887615668108563/10000000000000")
          (attr fwhm_kms_decimal "1.4887615668108563E+003")
          (attr id "FEAT-T001-c0b878576d7d-BROAD-Halpha")
          (attr kind "spectral_feature")
          (attr measured_by "t001 Fortran kernel single-Gaussian fit (model.Halpha.*)")
          (attr model_status "ok")
          (attr obs "OBS-T001-c0b878576d7d")
          (attr provenance "PROV-T001-REFERENCE-c0b878576d7d")
          (attr uncertainty_note "the t001 kernel reports no FWHM uncertainty; none is assumed"))
        (synthetic no))
      (node
        (id HYP:OBS-T001-c0b878576d7d:bh-broad-line-region)
        (kind black-hole-model)
        (status not-derivable)
        (grade n/a)
        (epistemic derivable-is-not-confirmation)
        (claim "broad Halpha is emitted by an AGN broad-line region")
        (assumptions A-LINE-ID A-BLR-KINEMATICS A-EXTRAGALACTIC)
        (rules R-BLR-01))
      (node
        (id OBL-UNCERTAINTY:FEAT-T001-c0b878576d7d-BROAD-Halpha:fwhm_kms)
        (kind proof-obligation)
        (obligation-kind missing-uncertainty)
        (text "fwhm_kms is present but fwhm_kms_sigma is not; rules testing it cannot use this record until an uncertainty is measured"))
```

How to read it: the measured FWHM is kept exactly (both as a rational and as the kernel's
decimal text). Because no uncertainty was reported, `R-BLR-01` cannot use the record, so
the broad-line-region hypothesis is `not-derivable` from this record set. That is a data
gap recorded as an obligation, not evidence against an AGN.

From `lrd-engine graph fixtures/SYNTHETIC_lrd_obs_manifest.lrdrec 4 2` (SYNTHETIC values):

```
        (id FEAT-SYN-B-HALPHA)
        (kind spectral-feature)
        (attrs
          (attr feature "broad_halpha")
          (attr fwhm_kms "2300")
          (attr fwhm_kms_sigma "250")
          (attr id "FEAT-SYN-B-HALPHA")
          (attr kind "spectral_feature")
          (attr obs "OBS-SYN-B")
          (attr provenance "PROV-SYN-1")
          (attr synthetic "SYNTHETIC: invented line width"))
        (uncertainty (measure fwhm_kms (value 2300) (sigma 250)))
        (synthetic yes))
...
        (id HYP:OBS-SYN-B:bh-broad-line-region)
        (kind black-hole-model)
        (status derivable-under-assumptions)
        (grade marginal)
        (epistemic derivable-is-not-confirmation)
        (claim "broad Halpha is emitted by an AGN broad-line region")
        (assumptions A-LINE-ID A-BLR-KINEMATICS A-EXTRAGALACTIC)
        (rules R-BLR-01))
...
      (edge
        (from CE:CE-BROADLINE-01:OBS-SYN-A:FEAT-SYN-A-HALPHA)
        (to HYP:OBS-SYN-A:stellar-compact-dusty-starburst)
        (kind attacks)
        (assumption A-STARS-DOMINATE-OPTICAL))
      (edge
        (from HYP:OBS-SYN-A:bh-reddened-agn-continuum)
        (to HYP:OBS-SYN-A:stellar-compact-dusty-starburst)
        (kind excludes)
        (role "origin of the rest-optical continuum"))
      (edge
        (from FEAT-SYN-A-BABS)
        (to HYP:OBS-SYN-A:bh-dense-gas-balmer-break)
        (kind supports)
        (rule R-DENSEGAS-01)
        (grade robust))
      (edge (from HYP:OBS-SYN-A:bh-broad-line-region) (to LIT-GREENE2024) (kind cites))
```

`2300 > 2000` holds but `2300 - 2*250 = 1800` does not, so at K=2 the hypothesis is
derivable with grade `marginal`. In OBS-SYN-A both the reddened-AGN and the
compact-starburst explanations are derivable. They are linked by `excludes` and both are
kept: the engine does not adjudicate between them.
