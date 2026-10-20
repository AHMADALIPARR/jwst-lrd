/* Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
   Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
   SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque

   JWST-LRD Mission QSO1-DCBH-001, role 09 (independent validation):
   validate the role-04 Fortran sweep dataset by closed-form
   re-derivation in SAS. SAS is licensed and is not installed on the
   repo host or the CI VM; this program is the track's source
   deliverable, and tests/sas/run.sh reports the section UNAVAILABLE
   wherever no SAS runtime exists (mission role 09). Nothing in this
   file has been executed by its author; it is written against the
   SAS language reference and marked as such in sas/STATUS.md.

   Method (independent of the Fortran grid integration): cosmic age in
   closed form for flat Lambda-CDM,
     t(z) = 2/(3*H0*sqrt(Ol)) * arsinh( sqrt(Ol/Om) * (1+z)^(-3/2) ),
   growth factor = exp(rate * Dt), rate = duty*(1-eps)/eps*lam/t_Edd,
   with lam the luminosity ratio and mdot = lam/eps the physical
   accretion rate (distinct quantities, as in fortran/growth).
   Declared inputs: Planck 2018 (H0=67.36, Om=0.3153, Ol=0.6847),
   CODATA 2018 t_Edd = 0.45049041223042019 Gyr, z_obs = 7.04221,
   M_target = 5e7 Msun. */

/* ---- closed-form age difference Dt(z_form -> z_obs), in Myr ------- */
%macro age_diff_myr(zform);
  ( (2/(3*0.0688899*sqrt(0.6847))) *
    ( arsinh(sqrt(0.6847/0.3153) * (1+7.04221)**(-1.5))
    - arsinh(sqrt(0.6847/0.3153) * (1+&zform)**(-1.5)) ) * 1000 )
%mend;
/* H0 in 1/Gyr: 67.36 km/s/Mpc = 0.0688899 /Gyr (Julian year).          */

/* ---- read the role-04 dataset ------------------------------------- */
data grid;
  infile "fixtures/growth/feasible_grid.csv" dlm="," firstobs=2;
  input lam eps z_form duty dt_myr mdot_edd growth_simple
        growth_saturated min_seed_simple_msun min_seed_saturated_msun
        feasible_simple feasible_saturated;
run;

/* ---- closed-form re-derivation per row ---------------------------- */
data check;
  set grid;
  tEdd = 0.45049041223042019;              /* Gyr */
  dt_my = %age_diff_myr(z_form) / 1000;    /* back to Gyr */
  lam_eff_s = lam;
  if lam > 1 then lam_eff_t = 1 + log(lam); else lam_eff_t = lam;
  f_s = exp(duty*(1-eps)/eps*lam_eff_s/tEdd * dt_my);
  f_t = exp(duty*(1-eps)/eps*lam_eff_t/tEdd * dt_my);
  seed_s = 5e7 / f_s;
  seed_t = 5e7 / f_t;
  rel_dt = abs(dt_my*1000 - dt_myr) / dt_myr;
  rel_s  = abs(seed_s - min_seed_simple_msun) / min_seed_simple_msun;
  rel_t  = abs(seed_t - min_seed_saturated_msun)
           / min_seed_saturated_msun;
  rel_m  = abs(mdot_edd - lam/eps) / (lam/eps);
  /* Feasibility as defined by the dataset's generator
     (fortran/growth/app/lrd_growth_sweep.f90): seed <= 1e5 Msun.
     No lower bound: in a minimum-seed dataset, needing a smaller
     seed is never infeasible. */
  feas_s_my = (seed_s <= 1e5);
  feas_t_my = (seed_t <= 1e5);
  /* guard band: CSV carries 9 significant digits; rows within 0.1%
     of the 1e5 boundary are reported, not silently passed */
  band = (abs(min_seed_simple_msun/1e5 - 1) < 1e-3)
       | (abs(min_seed_saturated_msun/1e5 - 1) < 1e-3);
  mism_s = (feas_s_my ne feasible_simple) and not band;
  mism_t = (feas_t_my ne feasible_saturated) and not band;
run;

/* ---- checks, printed as PASS/FAIL sas.<name> lines ---------------- */
proc sql noprint;
  select count(*) into :n from check;
  select max(rel_dt) into :maxdt from check;
  select max(rel_s)  into :maxs  from check;
  select max(rel_t)  into :maxt  from check;
  select max(rel_m)  into :maxm  from check;
  select sum(mism_s) + sum(mism_t) into :mism from check;
  select sum(band) into :nband from check;
quit;

%macro report(name, cond);
  %if &cond %then %put PASS sas.&name;
  %else %put FAIL sas.&name assertion_false;
%mend;

%report(rows_1200, %sysevalf(&n = 1200))
%put INFO sas.max_rel_dev dt=&maxdt seed_simple=&maxs seed_sat=&maxt mdot=&maxm;
%report(dt_matches_fortran, %sysevalf(&maxdt < 1e-4))
%report(seed_simple_matches, %sysevalf(&maxs < 1e-4))
%report(seed_sat_matches, %sysevalf(&maxt < 1e-4))
%report(mdot_is_lam_over_eps, %sysevalf(&maxm < 1e-7))
%put INFO sas.feasibility guard_band_rows=&nband;
%report(feasibility_agrees, %sysevalf(&mism = 0))

/* benchmark tuple by direct evaluation (seed in (480, 525) Msun) */
data _null_;
  tEdd = 0.45049041223042019;
  dt = %age_diff_myr(20) / 1000;
  seed = 5e7 / exp((1-0.1)/0.1 * dt / tEdd);
  if 480 < seed < 525 then put "PASS sas.benchmark_seed_window";
  else put "FAIL sas.benchmark_seed_window assertion_false";
  /* exact propagation law: seed scales linearly with M_target */
  seed2 = 1e8 / exp((1-0.1)/0.1 * dt / tEdd);
  if abs(seed2/seed - 2) < 1e-12
    then put "PASS sas.target_mass_linearity";
    else put "FAIL sas.target_mass_linearity assertion_false";
run;
