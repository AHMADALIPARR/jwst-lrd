% Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
% Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
% SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
%
% JWST-LRD Mission QSO1-DCBH-001, role 09 (independent validation):
% validate the role-04 Fortran sweep dataset (fixtures/growth/
% feasible_grid.csv) by closed-form re-derivation. Prints one
% PASS/FAIL matlab.<name> line per check (research/CONTRACTS.md) and
% MATLAB_GROWTH_DONE when every check passes. Engine note: this file is
% MATLAB source. When it is executed by GNU Octave instead, the runner
% (tests/matlab/run.sh) labels the run "GNU Octave (NOT MATLAB)" --
% Octave is not MATLAB (mission role 09).
%
% Checks (expectations derived from the model, not from solver output):
%   rows_1200               dataset shape
%   dt_matches_fortran      analytic Dt vs the Fortran grid Dt, per row
%   seed_simple_matches     closed-form min seed vs dataset, simple model
%   seed_sat_matches        same, saturated model
%   mdot_is_lam_over_eps    the dataset's mdot column is lam/eps
%   feasibility_agrees      recomputed feasibility flags equal the
%                           dataset's outside a 0.1% boundary guard band
%                           (CSV carries 9 significant digits; rows inside
%                           the band are reported, not silently passed)
%   benchmark_seed_window   benchmark tuple seed in (480, 525) Msun
%   target_mass_linearity   seed(2*M) = 2*seed(M): the exact propagation
%                           law for the target-mass uncertainty
%   h0_response_monotone    sensitivity probe (NOT an uncertainty):
%                           +1% H0 must strictly increase the benchmark
%                           seed (younger universe, less growth time)
function ok = validate_growth_grid()
  here = fileparts(mfilename('fullpath'));
  csv_path = fullfile(here, '..', 'fixtures', 'growth', 'feasible_grid.csv');
  D = dlmread(csv_path, ',', 1, 0);
  lam = D(:, 1); eps_ = D(:, 2); zf = D(:, 3); duty = D(:, 4);
  dt_myr = D(:, 5); mdot = D(:, 6);
  seed_s = D(:, 9); seed_t = D(:, 10);
  feas_s = D(:, 11); feas_t = D(:, 12);

  results = {};
  results{end + 1} = check('rows_1200', size(D, 1) == 1200);

  [~, dt_gyr] = lrd_growth_factor(lam, eps_, zf, duty, 'simple');
  reldt = max(abs(dt_gyr * 1000 - dt_myr) ./ dt_myr);
  results{end + 1} = check(sprintf('dt_matches_fortran max_rel_dev=%.3e', reldt), reldt < 1e-4);

  my_s = lrd_min_seed(lam, eps_, zf, duty, 'simple');
  rel_s = max(abs(my_s - seed_s) ./ seed_s);
  results{end + 1} = check(sprintf('seed_simple_matches max_rel_dev=%.3e', rel_s), rel_s < 1e-4);

  my_t = lrd_min_seed(lam, eps_, zf, duty, 'saturated');
  rel_t = max(abs(my_t - seed_t) ./ seed_t);
  results{end + 1} = check(sprintf('seed_sat_matches max_rel_dev=%.3e', rel_t), rel_t < 1e-4);

  rel_m = max(abs(mdot - lam ./ eps_) ./ (lam ./ eps_));
  results{end + 1} = check(sprintf('mdot_is_lam_over_eps max_rel_dev=%.3e', rel_m), rel_m < 1e-7);

  % Feasibility, as defined by the dataset's generator
  % (fortran/growth/app/lrd_growth_sweep.f90): a tuple is feasible iff
  % the required minimum seed does not exceed 1e5 Msun. There is no
  % lower bound -- needing a smaller seed is never infeasible in a
  % minimum-seed dataset; the 10 Msun scale belongs to the hypothesis
  % channels (role 08), not to feasibility.
  inrange = @(s) s <= 1e5;
  band = @(s) abs(s / 1e5 - 1) < 1e-3;
  mism_s = sum(inrange(my_s) ~= (feas_s == 1) & ~band(seed_s));
  mism_t = sum(inrange(my_t) ~= (feas_t == 1) & ~band(seed_t));
  nband = sum(band(seed_s) | band(seed_t));
  fprintf('INFO matlab.feasibility guard_band_rows=%d\n', nband);
  results{end + 1} = check('feasibility_agrees', mism_s == 0 && mism_t == 0);

  bench = lrd_min_seed(1, 0.1, 20, 1, 'simple');
  results{end + 1} = check(sprintf('benchmark_seed_window seed=%.2f', bench), ...
                           bench > 480 && bench < 525);

  s1 = lrd_min_seed(1, 0.1, 20, 1, 'simple', 5e7);
  s2 = lrd_min_seed(1, 0.1, 20, 1, 'simple', 1e8);
  results{end + 1} = check('target_mass_linearity', abs(s2 / s1 - 2) < 1e-12);

  seed_up = seed_with_H0(1.01);
  results{end + 1} = check(sprintf('h0_response_monotone seed=%.2f seed_H0plus1pct=%.2f', bench, seed_up), ...
                           seed_up > bench);

  ok = all([results{:}]);
  if ok
    fprintf('MATLAB_GROWTH_DONE\n');
  else
    fprintf('MATLAB_GROWTH_FAILURES\n');
  end
end

function s = seed_with_H0(scale)
  % Benchmark seed with H0 scaled (sensitivity probe only).
  H0 = 67.36 * scale; Om = 0.3153; Ol = 0.6847;
  tEdd = 0.45049041223042019;
  dt = lrd_age_gyr(7.04221, H0, Om, Ol) - lrd_age_gyr(20, H0, Om, Ol);
  s = 5e7 / exp((1 - 0.1) / 0.1 * 1 * dt / tEdd);
end

function r = check(name, cond)
  if cond
    fprintf('PASS matlab.%s\n', name);
  else
    fprintf('FAIL matlab.%s assertion_false\n', name);
  end
  r = cond;
end
