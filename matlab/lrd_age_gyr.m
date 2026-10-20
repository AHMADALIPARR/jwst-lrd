% Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
% Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
% SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
%
% JWST-LRD Mission QSO1-DCBH-001, role 09 (independent validation):
% closed-form cosmic age for a flat Lambda-CDM universe,
%   t(z) = 2/(3 H0 sqrt(Ol)) * asinh( sqrt(Ol/Om) * (1+z)^(-3/2) ).
% This is deliberately a DIFFERENT method from the Fortran kernel's
% grid quadrature (fortran/src/lrd_cosmo.f90): role 09 validates role 04
% by independent re-derivation, not by re-running the same numerics.
%
% Inputs: z (scalar or array), H0 [km/s/Mpc], Om, Ol (flat: Om + Ol = 1).
% Output: t [Gyr].
function t = lrd_age_gyr(z, H0, Om, Ol)
  km_per_Mpc = 3.08567758149137e19;   % IAU 2015 parsec definition, in km
  s_per_Gyr  = 1e9 * 365.25 * 86400;  % Julian year
  H0_per_s   = H0 / km_per_Mpc;
  t = (2 ./ (3 .* H0_per_s .* sqrt(Ol))) .* ...
      asinh(sqrt(Ol ./ Om) .* (1 + z) .^ (-1.5)) ./ s_per_Gyr;
end
