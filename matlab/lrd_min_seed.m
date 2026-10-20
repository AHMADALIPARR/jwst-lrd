% Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
% Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
% SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
%
% JWST-LRD Mission QSO1-DCBH-001, role 09 (independent validation):
% minimum seed mass [Msun] for target mass M_target [Msun] (default
% 5e7 Msun, Juodzbalis et al. 2026 as carried by the repo) under the
% closed-form growth factor. seed = M_target / factor exactly, so every
% seed in the dataset scales linearly with M_target (the propagation
% law for the target-mass uncertainty, whose published value the repo
% could not retrieve; see fortran/growth/STATUS.md OPEN item 1).
function seed = lrd_min_seed(lam, eps, zform, duty, model, M_target)
  if nargin < 6
    M_target = 5e7;
  end
  factor = lrd_growth_factor(lam, eps, zform, duty, model);
  seed = M_target ./ factor;
end
