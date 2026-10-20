# Blind competing-model analysis of Abell 2744-QSO1 (v1)

Licensed AGPL-3.0-only plus the SnapKitty Opaque License. Protocol owner: Hilbert. Directive from Ahmad, 2026-10-19.

Charter: preserve observations exactly. Verify computations independently. Keep competing explanations alive. Never confuse mathematical proof with empirical discovery.

## Data (frozen)
- Primary: fixtures/raw/c0b878576d7d7ec723c5ee526d29715fb672d81e45bc8ba4e02598ce8b9c5ee7.fits (obsid 230168921, jw02561-o006_s000024175_nirspec_clear-prism_x1d.fits, NIRSpec PRISM/CLEAR).
- Arrays: the LRD-ARR-v1 WAVELENGTH (um), FLUX (Jy) and FLUX_ERROR (Jy) exported by ingest, on the `integration` branch.
- Excluded: 09bcd907... (all-negative FLUX). It is kept only as provenance.
- Nobody edits, rescales or cleans the raw arrays. Every transformation (unit conversion, masking, resampling) is a logged step with its own LRD-ARR-v1 output and sha256.

## Shared likelihood (identical for all fitters)
- Gaussian likelihood, using the diagonal FLUX_ERROR and the Fortran kernel's log-likelihood routine (fortran/, t001), invoked through its CLI.
- Mask: pixels with non-finite flux or error, or error <= 0, are excluded. Anything else that is excluded must be justified and listed.
- The prism line-spread function must be modelled. Use the published JDox / NIRSpec prism resolution curve (cite the source and its version) and convolve the models with it. Fixed-width lines are not allowed.
- Report: chi-square, the number of free parameters k, the number of pixels used n, ln L_max, AIC, BIC, residuals per wavelength region (rest-UV, Balmer break, Hbeta/[OIII], Halpha), and parameter posteriors or profile-likelihood intervals.

## Models and fitters (blind to one another)
| Model | Fitter | Branch |
|---|---|---|
| A. Stellar population only (with dust) | Foundry J Spec | blind-a-stellar |
| B. Obscured (dust-reddened) AGN plus a minor host | Foundry J Core | blind-b-agn |
| C. Black-hole dominated / direct-collapse-style (negligible stellar host, dense-gas Balmer absorption and break) | Alapeno RTL | blind-c-bhstar |
| D. Composite: stellar plus AGN with free fractions | Alapeno Spec | blind-d-composite |

- Allowed open template and physics codes: FSPS (Fortran), BPASS outputs, and Cloudy (C). Any other open code must be compiled locally, with its version and sha256 pinned. No Python.
- Priors and physics claims must cite a DOI or arXiv ID that the fitter actually retrieved. No numbers from memory. If a needed source cannot be retrieved, that part is UNAVAILABLE.

## Blinding (commit and reveal)
1. Each fitter works only on its own branch and does not read the other blind-* branches or the fit outputs of other models.
2. When a fit is final, the fitter computes the sha256 of its result bundle (an LRD-REC-v1 summary plus its arrays) and sends only that hash to Hilbert.
3. Hilbert records all four hashes in research/BLIND-COMMITS.md and appends them as a ledger transition. Only after all four are recorded do fitters reveal their bundles. Any change after the reveal is a new, labelled fit and does not replace the original.
4. The comparison (HCALC Spec's Curry engine, plus an independent re-run by Foundry J Verify) happens after the reveal.

## Reporting
The output is a model ranking with its delta-BIC, AIC and likelihood-ratio values, together with where each model fails (its residual structure). A model that is best under these assumptions is "preferred under these assumptions". It is not "confirmed". A logically derivable hypothesis in Curry is not empirical confirmation.
