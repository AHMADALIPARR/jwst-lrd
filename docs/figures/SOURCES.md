<!-- SPDX-License-Identifier: AGPL-3.0-only -->
# Figure provenance

All four figures plot the public MAST level-3 x1d product `jw02561-o006_s000024175_nirspec_clear-prism_x1d.fits`
(obsid 230168921, sha256 `c0b87857…5ee7`; 429 samples, 408 finite, samples 421-429 flagged NaN).
Flux is in the fitted units of the continuum-compare pipeline (as fitted), not recalibrated.

| File | What it shows |
|---|---|
| `fig_full_spectrum_archived.png` | The full archived spectrum with ±1σ error bars; red dashed line marks Hα at the published z = 7.0451 |
| `figA_spectrum_fits.png` | Hα region, pixels 405-420: data, BIC-selected fits for three edge treatments, residuals; R0 (delivered-identical) vs R3 (forced point source) |
| `figB_edge_zoom_R0_vs_R3.png` | Edge pixels 410-420: flux and S/N per pixel, R0 vs R3 |
| `qso1_z.png` | z(Hα) per reduction variant and edge treatment; bar = min-max of the 20 fitted models, dot = BIC-selected model |

The figures were rendered with gnuplot from fit outputs of the Octave code in `research/continuum-compare/octave`.
The plot scripts, the re-reduction run files and the `jwst` pipeline environment are not in this repository (they live in
scratch directories outside it); the numbers in the README tables are copied from those scratch reports.
