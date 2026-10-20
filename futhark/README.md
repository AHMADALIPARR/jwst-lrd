<!-- SPDX-License-Identifier: AGPL-3.0-only; also subject to SNAPKITTY_OPAQUE_LICENSE.md (see LICENSE). -->
# futhark/: JWST-LRD Futhark kernels

`lrd.fut` holds the f64 kernels, `lrd-fut` is the LRD-ARR-v1 command-line
front end, and `lrdarr.sh` has the sh converters. ABI.md documents the ABI
and TOOLCHAIN.txt the toolchain. The tests live in `tests/futhark/`.

```
make -C futhark            # c backend   -> futhark/build/lrd-c
make -C futhark multicore  # multicore   -> futhark/build/lrd-multicore
tests/futhark/run.sh       # all gates
```

## Formulas and sources

**Vacuum to air.** Uses Morton (2000, ApJS 130, 403), the IAU standard
refractive index, taken from Birch & Downs (1994, Metrologia 31, 315). It
applies to dry air at 1 atm and 15 °C with 0.045% CO2. The coefficients are
copied from the VALD3 documentation page
<https://www.astro.uu.se/valdwiki/Air-to-vacuum%20conversion>:

    s = 1e4 / lambda_vac   (Angstrom)
    n = 1 + 0.0000834254 + 0.02406147 / (130 - s^2) + 0.00015998 / (38.9 - s^2)
    lambda_air = lambda_vac / n

**Air to vacuum.** Uses N. Piskunov's inverse, from the same page:

    s = 1e4 / lambda_air
    n = 1 + 0.00008336624212083 + 0.02408926869968 / (130.1065924522 - s^2)
          + 0.0001599740894897 / (38.92568793293 - s^2)
    lambda_vac = lambda_air * n

Following VALD, the conversion is applied only at wavelengths >= 2000 Å.
Below that the input comes back unchanged (vacuum is the convention there,
and the formula has poles near 877 Å and 1603 Å). Ciddor (1996) is **not**
implemented.

Measured round trip (vacuum to air to vacuum and the reverse) over
2001–100000 Å: the maximum relative error was 2.7e-12. That figure comes from
`t_vac_air_roundtrip` during development, and the declared gate is 1e-9. The
round trip is restricted to vacuum >= 2001 Å because vacuum 2000 Å maps to
about 1999.35 Å in air, which falls in the pass-through region, so the trip is
deliberately not invertible within about 0.65 Å of the 2000 Å boundary.

No published reference wavelength pair is used as a gate. The formula check
(`t_vac_air_formula`) re-evaluates the published expression by hand at 5000 Å.

**Units.** 1 µm = 1e4 Å exactly. The rest frame is `lambda_rest = lambda_obs / (1+z)`.

**Flux density.** c = 299 792 458 m/s (exact SI) = 2.99792458e18 Å/s. λ is in
Å, f_λ in erg s⁻¹ cm⁻² Å⁻¹, and f_ν in erg s⁻¹ cm⁻² Hz⁻¹. Then f_ν = f_λ λ²/c,
and to first order, assuming independent errors (no covariance),
σ_fν² = (λ²/c σ_fλ)² + (2 f_λ λ/c σ_λ)². The inverse is analogous. If no
wavelength uncertainty is available, pass `-` (CLI) or zeros (entry point).
JWST x1d FLUX is in Jy, and 1 Jy = 1e-23 erg s⁻¹ cm⁻² Hz⁻¹. The caller has to
scale to cgs first, because these kernels do not convert Jy.

**χ².** χ² = Σ (d−m)²/σ² over the valid pixels, and residual = d − m.

**Gaussian.** g(x) = cont + A exp(−½((x−μ)/σ)²). The line integral is A σ √(2π).

**Redshift grid search.** For each z, this is a weighted linear least-squares
fit of the line amplitudes plus the continuum (see ABI.md §5). The grid is
batched with `map` over z.
