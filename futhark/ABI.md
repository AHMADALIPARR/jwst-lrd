<!-- SPDX-License-Identifier: AGPL-3.0-only; also subject to SNAPKITTY_OPAQUE_LICENSE.md (see LICENSE). -->
# Futhark subsystem ABI

## 1. Files: LRD-ARR-v1 (from research/CONTRACTS.md, followed exactly)

- `<p>.f64`: raw little-endian IEEE-754 binary64 values, no header.
- `<p>.hdr`: lines `key=value`. Required: `format=LRD-ARR-v1`, `name`, `length`, `unit`.
  Optional: `source_sha256`. zgrid outputs carry `caveat=no LSF, fixed line widths, test kernel, not a redshift measurement`.
  This track also writes `note=SYNTHETIC` on every
  synthetic array it generates, and the Fortran ref adds `producer=...`.
  Readers ignore keys they don't know.
- Readers reject a file when `format` is wrong, `length` is not a decimal
  integer, `name` or `unit` is missing, or the `.f64` size is not `8*length`.
- Scalar results are written as `length=1` arrays.
- Unit strings this track uses: `Angstrom`, `um`, `erg/s/cm2/A`,
  `erg/s/cm2/Hz`, `1` (dimensionless), `arbitrary`.

## 2. Futhark boundary: binary value format

Compiled programs (`futhark/build/lrd-c`, `futhark/build/lrd-multicore`) get
their arguments on stdin and return their results on stdout (with `-b`) in the
Futhark binary value format:

| bytes | content |
|---|---|
| 1 | `'b'` (0x62) |
| 1 | version, 2 |
| 1 | rank (0 = scalar, 1 = 1-D array) |
| 4 | type, `" f64"` |
| 8*rank | each dimension as an i64, little endian |
| 8*N | data, f64 little endian |

On output, each value is followed by one `\n`; the reader skips it. Scalar
inputs (z, amplitudes, the `fit_cont` bool, and so on) go in as Futhark text
(e.g. `6.123 `, `true `) ahead of the binary arrays. The value reader accepts
text and binary values mixed this way.

The converters are written in POSIX sh, in `futhark/lrdarr.sh`:

- `lrd_to_fut P`: LRD-ARR-v1 to a rank-1 binary value. It writes the header with `printf` and copies the `.f64` file.
- `lrd_zeros_fut N`: a binary value of N zeros (used when there is no wavelength uncertainty).
- `lrd_from_fut STREAM P1:UNIT1 P2:UNIT2 ...`: splits the output stream into LRD-ARR-v1 files. It reads with `od`, `tail` and `head`.

## 3. Entry points (futhark/lrd.fut). All values are f64.

```
entry vac_to_air     [n] (lam_vac_A: [n]f64) : [n]f64
entry air_to_vac     [n] (lam_air_A: [n]f64) : [n]f64
entry um_to_angstrom [n] (lam_um: [n]f64) : [n]f64
entry angstrom_to_um [n] (lam_A: [n]f64) : [n]f64
entry rest_frame     [n] (z: f64) (lam_obs: [n]f64) : [n]f64
entry obs_frame      [n] (z: f64) (lam_rest: [n]f64) : [n]f64
entry flam_to_fnu    [n] (lam_A: [n]f64) (sig_lam_A: [n]f64) (flam: [n]f64) (sig_flam: [n]f64) : ([n]f64, [n]f64)
entry fnu_to_flam    [n] (lam_A: [n]f64) (sig_lam_A: [n]f64) (fnu: [n]f64) (sig_fnu: [n]f64) : ([n]f64, [n]f64)
entry jy_to_flam     [n] (lam_A: [n]f64) (sig_lam_A: [n]f64) (f_jy: [n]f64) (sig_jy: [n]f64) : ([n]f64, [n]f64)   -- erg/s/cm2/A
entry residuals      [n] (data: [n]f64) (model: [n]f64) : [n]f64
entry chi2           [n] (data: [n]f64) (model: [n]f64) (sigma: [n]f64) : f64
entry gauss_model    [n] (amp: f64) (center: f64) (sigma: f64) (cont: f64) (lam: [n]f64) : [n]f64
entry zgrid_search   [n][k][m] (lam: [n]f64) (flux: [n]f64) (sigma: [n]f64)
                     (centers: [k]f64) (widths: [k]f64) (fit_cont: bool) (zgrid: [m]f64)
                     : ([m]f64, [2]f64, [k+1]f64)     -- chi2 per z, [best_z, best_index], [amp_1..amp_k, cont]
-- harness helpers (not science kernels):
entry synth_spectrum [k] (n: i64) (l0: f64) (l1: f64) (z: f64) (centers: [k]f64) (widths: [k]f64)
                     (amps: [k]f64) (cont: f64) (noise: f64) (seed: i64) : ([n]f64, [n]f64, [n]f64)
entry compare_arrays [n] (atol: f64) (rtol: f64) (a: [n]f64) (b: [n]f64) : [3]f64   -- [ok, max_abs, max_ratio]
entry ident          [n] (a: [n]f64) : [n]f64
```

Library users can `import "futhark/lrd"` and call these as ordinary functions.

## 4. Command-line interface (same for `futhark/lrd-fut` and `tests/futhark/fortran-ref/build/lrdref`)

Arguments are LRD-ARR-v1 prefixes (paths without `.f64`/`.hdr`) or decimal scalars.

```
vac2air IN OUT | air2vac IN OUT   IN unit Angstrom -> Angstrom
um2a IN OUT                       IN unit um -> Angstrom
a2um IN OUT                       IN unit Angstrom -> um
rest Z IN OUT | obs Z IN OUT      keeps the IN unit
flam2fnu LAM SIGLAM|- FLAM SIGFLAM OUT   -> OUT, OUT_sigma (erg/s/cm2/Hz); "-" = zero lambda error
fnu2flam LAM SIGLAM|- FNU SIGFNU OUT     -> OUT, OUT_sigma (erg/s/cm2/A)
jy2flam LAM SIGLAM|- FJY SIGJY OUT       -> OUT, OUT_sigma (erg/s/cm2/A); FJY, SIGJY must have unit=Jy
resid DATA MODEL OUT
chi2 DATA MODEL SIGMA OUT                -> OUT length 1, unit 1
gauss AMP CENTER SIGMA CONT LAM OUT
zgrid LAM FLUX SIGMA CENTERS WIDTHS FITCONT(0|1) ZGRID OUT
                                         -> OUT_chi2, OUT_best=[z,index], OUT_params=[amps...,cont]
                                         LIMITATION: no LSF, fixed line widths, test kernel, not a redshift measurement.
                                         Every zgrid output header carries
                                         caveat=no LSF, fixed line widths, test kernel, not a redshift measurement
                                         and both CLIs print the same statement on stderr.
```

Front-end only (`lrd-fut`): `synth`, `mk OUT UNIT v1 v2 ...`, `cmp ATOL RTOL A B`, `dump A`.
`LRD_FUT_BIN=futhark/build/lrd-multicore` picks the multicore build.
Exit status: 0 on success, 2 on an ABI or usage error. `cmp` exits 1 when the arrays differ.

## 5. Semantics shared by both implementations

- `chi2` and `zgrid_search` mask a pixel (weight 0) when sigma <= 0 or when
  sigma, data/flux, the model, or (in zgrid) the wavelength is non-finite.
- In `zgrid_search`, the observed line i has center `centers[i]*(1+z)` and
  Gaussian sigma `widths[i]*(1+z)`. Both are in the units of `lam`. At each z
  the amplitudes and continuum come from a weighted linear least-squares fit:
  normal equations, then Gauss-Jordan elimination without pivoting. A
  degenerate column (eliminated pivot <= 1e-12 times its original diagonal) is
  fixed to 0. With `fit_cont = false` the continuum is 0.
- The best z is the one with the lowest chi2, ties going to the lowest index.
  NaN chi2 values never win.
- `jy_to_flam`: 1 Jy = 1e-23 erg s⁻¹ cm⁻² Hz⁻¹, and f_λ = 1e-23 f_Jy c/λ² (λ in Å, c = 2.99792458e18 Å/s).
  The σ propagation is the same as `fnu_to_flam`'s, applied to the 1e-23-scaled flux and σ,
  including the wavelength error term.
- **zgrid_search limitation:** no LSF, fixed line widths, test kernel, not a redshift measurement.
  The widths are fixed inputs: there is no instrumental line-spread function and no width
  fit. Only the linear amplitudes and the continuum are fitted. The output is a
  differential/regression test artifact, and its best z must not be quoted as a redshift.
