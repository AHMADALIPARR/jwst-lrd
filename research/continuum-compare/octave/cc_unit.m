% SPDX-License-Identifier: AGPL-3.0-only
% cc_unit.m -- unit tests (prints 'UT PASS|FAIL name detail').  GNU Octave.
function cc_unit()
  D = cc_load(); K = cc_const(); M = cc_models(); [ok, ~] = cc_scen(D, 'D0');
  pf = @(c, nm, d) printf('UT %s %s %s\n', ifelse2(c), nm, d);
  % 1 template unit area over a very wide pixel-edge grid
  W = cc_win(D, ok, 'ha', 12); Wf = cc_win(D, ok, 'ha', [2 D.n-1]);
  Wf.lo = Wf.lo(1); Wf.hi = Wf.hi(end); Wf.pwk = 1;
  for sg = [0 500 2000]
    mu = 30000; T = cc_tmpl(Wf, mu, sg, K); pf(abs(T - 1) < 1e-9, sprintf('template_unit_area_sig%d', sg), sprintf('integral=%.12f', T));
  end
  % 2 vectorised chi2 vs brute force at random (z, sigma) for all 10 models x 1C/2C, both lines
  randn('state', 7); rand('state', 7); nbad = 0; maxd = 0; ntest = 0;
  for m = 1:10, for comp = 1:2, for ln = {'hb', 'ha'}
    if strcmp(ln{1}, 'hb') && comp == 2, continue; end
    Wx = cc_win(D, ok, ln{1}, 12); z = 7.025 + 0.035 * rand();
    [chi, s1, s2, bs] = cc_wchi2(Wx, M{m}, comp, z, strcmp(M{m}.type, 'pllin'));
    if strcmp(M{m}.type, 'pllin'), [c0, ib] = min(chi); elseif strcmp(M{m}.type, 'pl'), c0 = chi; ib = bs(1); else, c0 = chi; ib = 1; end
    if strcmp(M{m}.type, 'pllin'), a1 = s1(1, ib); a2 = s2(1, ib); else, a1 = s1(1); a2 = s2(1); end
    if comp == 1, sig = K.sg1(a1); else, sig = [K.sgn(a1) K.sgb(a2)]; end
    cd_ = cc_direct(Wx, M{m}, comp, z, sig, ib); d = abs(c0 - cd_); maxd = max(maxd, d); ntest++;
    if d > 1e-6 * max(1, abs(cd_)), nbad++; end
  end, end, end
  pf(nbad == 0, 'vectorised_vs_bruteforce_chi2', sprintf('%d cases, max|diff|=%.2e', ntest, maxd));
  % 3 NaN/inf handling: no non-finite value in any valid pixel; masked pixels carry zeros (never NaN) in the export
  v = ok; pf(all(isfinite(D.fl(v))) && all(isfinite(D.er(v))) && all(isfinite(D.lam(v))), 'finite_on_valid_pixels', sprintf('valid=%d', sum(v)));
  pf(all(isfinite(D.fl)) && all(isfinite(D.er)), 'export_has_no_nan_inf', sprintf('n=%d', D.n));
  pf(sum(ok) == 408 && D.n == 429 && sum(~ok) == 21, 'pixel_counts_429_408_21', sprintf('n=%d valid=%d masked=%d', D.n, sum(ok), sum(~ok)));
  % 4 mask scenarios
  [o1, ~] = cc_scen(D, 'D1'); [o3, ~] = cc_scen(D, 'D3'); pf(sum(ok) - sum(o1) == 1 && sum(ok) - sum(o3) == 3 && ~o1(420) && o1(419) && ~o3(418) && o3(417), 'drop_last_pixels', 'D1/D3 counts');
  % 5 spline basis reproduces a line exactly
  Wb = cc_win(D, ok, 'ha', 12); [B, kc] = cc_basis(Wb, M{10}); y = 2 + 3 * Wb.xs; cf = B{1} \ y; pf(norm(B{1} * cf - y) < 1e-10, 'spline_contains_linear', sprintf('resid=%.1e', norm(B{1} * cf - y)));
  % 6 PL grid contains beta=0 and PLLIN contains a linear continuum at beta=0
  pf(any(abs(K.beta) < 1e-12), 'beta_grid_contains_zero', '');
  % 7 non-negativity: absorption-like data. unconstrained LS gives A<0; the constrained solution (cc_direct) must have A>=0 and chi2 >= the unconstrained chi2
  Wd = Wb; Wd.f = 0.4 - 0.2 * exp(-((Wd.lam - 52800) / 100).^2); cm = M{5}; z = 7.0405; [B, ~] = cc_basis(Wd, cm); mu = Wd.R * (1 + z); T = cc_tmpl(Wd, mu, 500, K); X = [B{1}, T];
  p = (bsxfun(@times, sqrt(Wd.w), X)) \ (sqrt(Wd.w) .* Wd.f); cu = sum(Wd.w .* (Wd.f - X * p).^2); [cc_, par] = cc_direct(Wd, cm, 1, z, 500, 1);
  pf(p(end) < 0 && par(end) >= 0 && cc_ >= cu - 1e-9, 'amplitude_nonnegative_constraint', sprintf('A_unconstrained=%.4g A_constrained=%.4g chi2_con=%.4f chi2_unc=%.4f', p(end), par(end), cc_, cu));
end
function s = ifelse2(c), if c, s = 'PASS'; else, s = 'FAIL'; end, end
