% SPDX-License-Identifier: AGPL-3.0-only
% r_sigma = sigma_computed - sigma_reference, with an explicit absolute tolerance.
% UNAVAILABLE unless computed, reference AND tolerance are all supplied (nothing invented).
function ev = sigma_core(sig_comp, sig_ref, abs_tol)
  ev = struct('sigma_computed', sig_comp, 'sigma_reference', sig_ref, ...
              'sigma_abs_tol', abs_tol, 'r_sigma', NaN);
  if ~all(isfinite([sig_comp sig_ref abs_tol])) || abs_tol < 0
    ev.status = 'UNAVAILABLE';
    ev.disposition = 'reference_sigma_or_tolerance_not_available';
    return;
  end
  ev.r_sigma = sig_comp - sig_ref;
  if abs(ev.r_sigma) <= abs_tol
    ev.status = 'PASS'; ev.disposition = 'within_stated_abs_tol';
  else
    ev.status = 'FAIL'; ev.disposition = 'outside_stated_abs_tol';
  end
end
