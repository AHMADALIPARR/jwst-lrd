% SPDX-License-Identifier: AGPL-3.0-only
% Checks of rz_core / sigma_core on SYNTHETIC inputs plus the real-input verdict.
% Runs under GNU Octave here (NOT MATLAB). Prints PASS/FAIL per check and counts.
function test_evidence()
  n_pass = 0; n_fail = 0;
  [n_pass, n_fail] = chk('real inputs: r_z = z_meas - z_pub', ...
      abs(rz_core(7.04221, 0.00027, 7.0451, NaN, 3).r_z - (-0.00289)) < 1e-12, n_pass, n_fail);
  e = rz_core(7.04221, 0.00027, 7.0451, NaN, 3);
  [n_pass, n_fail] = chk('real inputs: ratio_measured_only about 10.7', ...
      abs(e.ratio_measured_only - 10.7037) < 1e-3, n_pass, n_fail);
  [n_pass, n_fail] = chk('real inputs: not PASS, open_discrepancy (published sigma unknown)', ...
      strcmp(e.status, 'FAIL') && strcmp(e.disposition, 'open_discrepancy'), n_pass, n_fail);
  [n_pass, n_fail] = chk('real inputs: break-even published sigma consistent', ...
      abs(abs(e.r_z) - 3 * hypot(0.00027, e.break_even_published_sigma)) < 1e-12, n_pass, n_fail);
  % synthetic
  e = rz_core(7.0, 0.001, 7.002, NaN, 3);
  [n_pass, n_fail] = chk('synthetic: |r|=2 sigma within k=3 -> PASS (any published sigma)', ...
      strcmp(e.status, 'PASS'), n_pass, n_fail);
  e = rz_core(7.0, 0.001, 7.005, 0.004, 3);
  [n_pass, n_fail] = chk('synthetic: with published sigma 0.004, 0.005/0.00412 < 3 -> PASS', ...
      strcmp(e.status, 'PASS') && strcmp(e.disposition, 'within_tolerance_combined_sigma'), n_pass, n_fail);
  e = rz_core(7.0, 0.001, 7.02, 0.001, 3);
  [n_pass, n_fail] = chk('synthetic: out of tolerance with known published sigma -> FAIL', ...
      strcmp(e.status, 'FAIL') && strcmp(e.disposition, 'out_of_tolerance_combined_sigma'), n_pass, n_fail);
  e = rz_core(NaN, 0.001, 7.0, NaN, 3);
  [n_pass, n_fail] = chk('missing z_measured -> UNAVAILABLE', strcmp(e.status, 'UNAVAILABLE'), n_pass, n_fail);
  e = sigma_core(0.00027, NaN, NaN);
  [n_pass, n_fail] = chk('sigma: no reference/tolerance -> UNAVAILABLE', strcmp(e.status, 'UNAVAILABLE'), n_pass, n_fail);
  e = sigma_core(0.00027, 0.00026, 0.00002);
  [n_pass, n_fail] = chk('synthetic sigma: r=1e-5 within 2e-5 -> PASS', strcmp(e.status, 'PASS'), n_pass, n_fail);
  e = sigma_core(0.00027, 0.00020, 0.00002);
  [n_pass, n_fail] = chk('synthetic sigma: r=7e-5 outside 2e-5 -> FAIL', strcmp(e.status, 'FAIL'), n_pass, n_fail);
  fprintf('SUMMARY (octave evidence checks, Octave, NOT MATLAB): PASS=%d FAIL=%d UNAVAILABLE=0\n', n_pass, n_fail);
  if n_fail > 0, exit(1); end
end

function [p, f] = chk(name, ok, p, f)
  if ok, fprintf('PASS      %s\n', name); p = p + 1;
  else fprintf('FAIL      %s\n', name); f = f + 1; end
end
