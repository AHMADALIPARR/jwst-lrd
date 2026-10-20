<!-- SPDX-License-Identifier: AGPL-3.0-only -->
<!-- Also subject to SNAPKITTY_OPAQUE_LICENSE.md (dual license, see repository root). -->
# adversary/PLAN.md: Agent 11 (t026-adversary), mission QSO1-DCBH-001

Owner: QSO1 Adversary. Branch: `t026-adversary`. Writes only under `adversary/` and `tests/adversary/`.
Charter (CONTRACTS.md): preserve observations exactly, verify computations independently, keep competing
explanations alive, never confuse mathematical proof with empirical discovery.

## Method
For each preferred explanation (PE), list the inferential chain, then perturb each assumption within a
range taken from a retrieved source (arXiv ID + section/table, see `adversary/params/*.nml` and README).
A PE **survives** an assumption if its stated conclusion holds over the whole cited range. It **breaks**
if some cited value flips it; the harness reports the flipping value and the break-even value. Where no
cited range exists the item is a `TODO-SOURCE` and is not perturbed (no guessed numbers). Nothing here
tests or claims anything about LambdaCDM itself: cosmology is a declared input only.

## Inputs (state at f83eb5b, 2026-10-19 22:56 PDT)
Mission branches t017-obsrecon, t018-dynmass, t020-growth, t021-dcbh, t023-agda-growth and
qso1-dcbh-001-growth exist locally (not on origin) with **no commits beyond main and no uncommitted
files**. t019, t022, t024, t025 do not exist. So no agent-produced PE exists yet; the PEs below come from
the published literature and are the claims the module agents are expected to reproduce. The harness is
scaffolded so the same tests can be re-run on agent outputs once they land (see "Interfaces").

## Preferred explanations to attack
| ID | Preferred explanation | Source (retrieved) | Owner agent that should reproduce it |
|---|---|---|---|
| PE1 | Keplerian rotation about a point mass, log M_BH = 7.7 +- 0.3 at i = 52 +- 2 deg | Juodzbalis+ arXiv:2508.21748v2 (Nature 2026, doi:10.1038/s41586-026-10579-4), main text + Methods "Rotation curve analysis" | 02 (t018) |
| PE2 | BH dominates the system: M_BH/M_* > 2 ("naked" BH); M_BH/M_dyn = 0.15-1.2 | 2508.21748 Methods "Dynamic upper limit on the stellar mass"; D'Eugenio+ arXiv:2503.11752v2 Sec. 3.1, Table 2 | 02 (t018) |
| PE3 | Currently sub-Eddington (L/L_Edd ~ 0.03) vs. high/super-Eddington (0.24-0.3; v1 of 2503.11752 gave 0.7-1.6, superseded by v2 0.09) | 2508.21748 main text; Furtak+ arXiv:2308.05735 Methods; Ji+ arXiv:2501.13082 Sec. 5; 2503.11752v2 Table 2 | 04 (growth) |
| PE4 | Heavy seed (DCBH/PBH) needed: growth-time argument | Inayoshi+ arXiv:1911.05791 Eq. 1 framework; 2308.05735 (DELPHI light seeds 150 Msun at z>13 under-predict) | 04/05/06 |
| PE5 | Heavy seed needed: "naked" argument leaves only DCBH or PBH | 2508.21748 main text and Methods | 05 (t021), 08 |
| PE6 | DCBH tension: DCBH models cap M_BH/M_dyn at ~0.1, >1 dex below the inferred limit | 2508.21748 main text (refs 33,34 there) | 05 (t021) |
| PE7 | Non-stellar Balmer break from dense gas (n_H ~ 1e10 cm^-3) | Ji+ 2501.13082 abstract, Sec. 6 | blind fitters (not read), 08 |

## Assumptions to perturb (each with its cited range; values in adversary/params/)
- Cosmology: Planck 2018 (H0 67.36, Om 0.3153; arXiv:1807.06209 Table 2), SH0ES H0 73.04 +- 1.04
  (arXiv:2112.04510 abstract), the papers' own choices (H0 70/Om 0.3 in 2308.05735; 67.4/0.315 in 2508.21748).
- Lens magnification of image A: 6.15 [5.76, 6.92] 95% (2308.05735 Methods); 5.8 +0.4/-0.2 Bergamini model
  (2501.13082 App.); 5.4 +- 1.1 UNCOVER v2 model (Furtak+ arXiv:2502.07875 Table 1). Tangential shear
  3.52 (2308.05735 Methods; used by 2508.21748); uncertainty on the shear: TODO-SOURCE.
- Inclination: 52 +- 2 deg MOKA3D parametric; 45 +- 10 deg non-parametric shells (2508.21748 Methods, ED Fig. 4).
- LSF: G395H nominal R = 3700 at Halpha, FWHM 81 km/s, sigma_R = 34 km/s (2503.11752v2 Sec. 2); point-source
  resolution up to "nearly a factor 2" higher at short wavelengths, less at long (de Graaff+ arXiv:2308.09742
  App. A, Fig. A.1). The exact factor at 5.28 um is TODO-SOURCE; the harness reports a break-even factor.
- Dust law: SMC (A_V 3.0, A_Hbeta 3.1, A_Halpha 2.1 from decrement 7.4 +- 0.4; 2308.05735 Methods); Calzetti
  k'(lambda) (arXiv:astro-ph/9911459 Eq. 4, R'_V = 4.05); narrow-line A_V = 0.66 +- 0.40 (Maiolino+ 2505.22567,
  as used by 2508.21748 and 2501.13082).
- Eddington ratio: values above; L_Edd from CODATA 2022 m_p, sigma_T (NIST) and IAU 2015 B3 GM_sun (arXiv:1510.07674).
- Radiative efficiency: 0.1 fiducial, ~0.06 non-rotating ISCO, ~0.42 maximal spin, ~0.01 MAD super-Eddington
  (1911.05791 Secs. 1, 3).
- Duty cycle: f_duty ~ 1 required for Eddington growth; ~20-30% for few-times-Eddington (1911.05791 Sec. 1).
- Seed mass / formation: light seed 150 Msun at z > 13 (DELPHI, 2308.05735 Methods); heavy 1e4-1e6 Msun
  (2308.05735 main text). Earliest formation time: bounded by t = 0 (no source needed for an upper bound on time).

## Deliverables and order
1. This PLAN (commit + push first).
2. `adversary/params/*.nml`: Fortran namelists, one per source group, each value with its citation.
3. `adversary/src/`: Fortran 2018 harness `qso1_adv` (cosmology clock and distances, magnification/
   inclination/LSF/dust propagation into M_BH, M_dyn, L_bol, lambda_Edd, Eddington growth / minimum seed).
4. `tests/adversary/run.sh`: PASS/FAIL/UNAVAILABLE lines per CONTRACTS test convention, including
   reproduction tests against published numbers and one survive/break verdict per PE x assumption.
5. `adversary/STATUS.md` (what built, verbatim run tail, assumptions, blockers) and `adversary/README.md`.

## Interfaces
- Outputs: verdict table as LRD-REC-v1-style `key=value` lines (`adversary/out/verdicts.kv`); no ledger
  transition is proposed by this track (no contract defines an adversary transition kind).
- When t018/t020/t021 land, their numeric outputs (LRD-ARR-v1, payload_sha256 = SHA-256 of the .f64 bytes
  only, CONTRACTS v1.2) are to be read via the namelist `&agent_inputs` and re-tested; until then those
  tests report UNAVAILABLE.

## Quarantine note
Before the blind-* restriction reached me I listed /workspace/jwst-lrd-blind-a (top-level dirs, `git log -3`
= f6c4681, the same commit as t001-ingest-fortran; clean status) and grep-matched only ingest/fortran files
identical to t001. No fit outputs or model files were seen or used.
