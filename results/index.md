---
layout: default
title: QSO1 — Computed growth constraints
---

# What the QSO1 growth constraint tells us

**A 100-solar-mass seed fails under the benchmark Eddington history, but a
higher rate rescues it. This calculation does not uniquely require a heavy seed.**

![Computed seed growth trajectories with the 50-million-solar-mass target](growth-result.svg)

These curves are computed from the accretion model. They are not inferred
red-dot shapes or an observed time series.

## Declared inputs

Target mass **50 million solar masses**, observed redshift **7.04221**,
formation redshift **20**, efficiency **0.1**, duty cycle **1**, and luminosity
ratio **1**. The flat matter+Lambda clock uses H0=67.36, Om=.3153 and
Ol=.6847; radiation is neglected. The target is a published benchmark,
not an independently reconstructed dynamical mass in this calculation.

| Computed quantity | Result |
|---|---:|
| Available growth time | 576.058867 Myr |
| Minimum seed | 502.149751 solar masses |
| Final mass from a 100-solar-mass seed | 9.957189 million solar masses — below target |
| Final mass from a 1,000-solar-mass seed | 99.571890 million solar masses — reaches target |
| Luminosity ratio that rescues the 100-solar-mass seed, simple prescription | 1.140219 |
| Same, saturation prescription | 1.150526 |
| Minimum seed when duty falls to 0.5 | 158,453.42 solar masses |
| Minimum seed when duty falls to 0.25 | 2,814,724.00 solar masses |

## The invariant used in the computation

For constant-rate growth, `I(t) = ln(M(t)/Mseed) - rate*t = 0`.
An independent 2,000-step RK4 calculation tested this identity at every step;
the maximum numerical residual was **1.05e-10**. An analytic cosmological clock
independently reproduced all **1,200** committed Fortran grid rows in both
growth prescriptions, with maximum relative seed difference **4.77e-9**.

The existing Agda proofs establish rational-model mass preservation,
monotonicity and exact epoch composition. Their conservative 9,000-solar-mass
sufficient certificate is separate from the numerical minimum above.
Connecting that rational certificate to continuous growth requires the
documented A-GR-1 bridge. The numerical residual is not a certified error interval.

## Why this does not identify a unique origin

The endpoint constrains a product of growth time, duty, efficiency and
effective luminosity ratio. In the simple prescription, duty=1/lambda=1
and duty=0.5/lambda=2 generate the same entire growth history for the same
seed. The tests execute this degeneracy and both light-seed counterexamples.
Additional observations and gas/feedback constraints are needed to choose
among formation scenarios.

The earlier red-dot/helix video is a geometry demonstration. There is no
implemented observational inference establishing that helix as QSO1 morphology.
The live Self view now shows the computed growth constraint and responds to
efficiency, duty, rate and formation-time controls.

[Open native controls on the NUC](../live/) ·
[Full invariant inventory and research result](https://github.com/AHMADALIPARR/jwst-lrd/blob/frontend/morphic-workspace/research/QSO1-GROWTH-RESULT.md) ·
[Numerical output](growth-result.txt) · [Executed tests](growth-result-tests.txt)

[Official ESA/Webb research story](https://esawebb.org/news/weic2609/) ·
[Back to experiment](../)
