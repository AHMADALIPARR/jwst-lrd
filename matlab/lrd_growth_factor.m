% Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
% Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
% SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
%
% JWST-LRD Mission QSO1-DCBH-001, role 09 (independent validation):
% growth factor and minimum seed for the role-04 growth model, recomputed
% in closed form. Same DECLARED inputs as fortran/growth (Planck 2018
% cosmology; CODATA 2018 t_Edd = 0.45049041223042019 Gyr; z_obs = 7.04221;
% M_target = 5e7 Msun) but an independent method: the Fortran solver
% steps the ODE over a cosmological time grid, here the factor is
% exp(rate * Dt) with Dt from the analytic age (lrd_age_gyr).
%
% Definitions (kept distinct, as in fortran/growth/STATUS.md):
%   lam  = L/L_Edd, the luminosity ratio.
%   mdot = lam/eps, the physical mass-accretion rate in units of L_Edd/c^2.
%   rate = duty * (1-eps)/eps * lam / t_Edd.
% Models: 'simple' uses lam directly (upper bound); 'saturated' uses
% lam_eff = 1 + log(lam) for lam > 1 (slim-disk saturation), else lam.
function [factor, dt_gyr] = lrd_growth_factor(lam, eps, zform, duty, model)
  H0 = 67.36; Om = 0.3153; Ol = 0.6847;      % Planck 2018 (declared)
  tEdd = 0.45049041223042019;                % Gyr, CODATA 2018
  zobs = 7.04221;                            % this repo's measured z
  dt_gyr = lrd_age_gyr(zobs, H0, Om, Ol) - lrd_age_gyr(zform, H0, Om, Ol);
  switch model
    case 'simple'
      lam_eff = lam;
    case 'saturated'
      lam_eff = lam;
      big = lam > 1;
      lam_eff(big) = 1 + log(lam(big));
    otherwise
      error('lrd_growth_factor: unknown model %s', model);
  end
  rate = duty .* (1 - eps) ./ eps .* lam_eff ./ tEdd;
  factor = exp(rate .* dt_gyr);
end
