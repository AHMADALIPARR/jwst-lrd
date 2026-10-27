% SPDX-License-Identifier: AGPL-3.0-only
% Portable MATLAB-compatible evaluation core (runs under GNU Octave here; MATLAB is
% unavailable on this box and was NOT used).
% This computes MEASUREMENT EVIDENCE only. It does not decide any latch; Erlang does.
function ev = rz_core(z_meas, sig_meas, z_pub, sig_pub, k)
  % r_z = z_measured - z_published (signed, kept as a measurement signal).
  % Tolerance: |r_z| <= k * sigma_comb, sigma_comb = sqrt(sig_meas^2 + sig_pub^2).
  % sig_pub may be NaN (unknown). Because sigma_comb >= sig_meas, the measured-only ratio
  % |r_z|/sig_meas is an UPPER bound on the true tension. Hence:
  %   |r_z| <= k*sig_meas   -> within tolerance whatever sig_pub is   -> PASS
  %   |r_z| >  k*sig_meas and sig_pub unknown -> not established as within tolerance;
  %        reported FAIL with disposition open_discrepancy plus the smallest published
  %        sigma that would bring it within k sigma (break-even).
  ev = struct();
  ev.z_measured = z_meas; ev.z_measured_sigma = sig_meas;
  ev.z_published = z_pub; ev.z_published_sigma = sig_pub; ev.k_sigma = k;
  if ~all(isfinite([z_meas sig_meas z_pub k])) || sig_meas <= 0 || k <= 0
    ev.status = 'UNAVAILABLE'; ev.disposition = 'missing_or_invalid_inputs';
    ev.r_z = NaN; ev.ratio_measured_only = NaN; ev.tolerance_abs_measured_only = NaN;
    ev.break_even_published_sigma = NaN; ev.ratio_combined = NaN;
    return;
  end
  r = z_meas - z_pub;
  ev.r_z = r;
  ev.ratio_measured_only = abs(r) / sig_meas;
  ev.tolerance_abs_measured_only = k * sig_meas;
  ev.break_even_published_sigma = NaN;
  ev.ratio_combined = NaN;
  if abs(r) <= k * sig_meas
    ev.status = 'PASS'; ev.disposition = 'within_tolerance_for_any_published_sigma';
  elseif isfinite(sig_pub) && sig_pub >= 0
    comb = sqrt(sig_meas^2 + sig_pub^2);
    ev.ratio_combined = abs(r) / comb;
    if abs(r) <= k * comb
      ev.status = 'PASS'; ev.disposition = 'within_tolerance_combined_sigma';
    else
      ev.status = 'FAIL'; ev.disposition = 'out_of_tolerance_combined_sigma';
    end
  else
    ev.status = 'FAIL'; ev.disposition = 'open_discrepancy';
    ev.break_even_published_sigma = sqrt((abs(r) / k)^2 - sig_meas^2);
  end
end
