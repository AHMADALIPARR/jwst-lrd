% SPDX-License-Identifier: AGPL-3.0-only
% cc_synth.m -- SYNTHETIC spectrum (NOT data): P1 (linear-per-window) continuum + one Gaussian per line at z_true, built from the
% P1/1C joint best-fit parameters of the REAL data at D0, on the REAL grid, REAL errors and REAL mask.  Raw arrays are not modified
% (a new flux vector is returned).  Returns Fs0 (no deficit), Fs1 (pixel-420 deficit: line removed at pixel 420), and parameters.
function S = cc_synth(D, ok, ztrue)
  K = cc_const(); M = cc_models(); zg = K.zg;
  R = cc_fit(D, ok, M{5}, 1, 12);
  z0 = zg(R.rj.g);
  [~, pb] = cc_direct(R.Wb, M{5}, 1, z0, R.sig_b);            % [c0 c1 A]
  [~, pa] = cc_direct(R.Wa, M{5}, 1, z0, R.sig_a);
  Wfb = cc_win(D, ok, 'hb', [2 D.n-1]); Wfa = cc_win(D, ok, 'ha', [2 D.n-1]);
  base = zeros(D.n, 1); line = zeros(D.n, 1);
  vb = find(ok & D.idx <= 340); va = find(ok & D.idx > 340);
  xb = (D.lam(vb) - Wfb.lamc) / Wfb.pwc / 12; xa = (D.lam(va) - Wfa.lamc) / Wfa.pwc / 12;
  base(vb) = pb(1) + pb(2) * xb; base(va) = pa(1) + pa(2) * xa;
  Tb = cc_tmpl(Wfb, K.Rhb * (1 + ztrue), R.sig_b, K); Ta = cc_tmpl(Wfa, K.Rha * (1 + ztrue), R.sig_a, K);
  line(Wfb.p) = pb(3) * Tb; line(Wfa.p) = line(Wfa.p) + pa(3) * Ta;
  S.base = base; S.line = line; S.Fs0 = D.fl; S.Fs0(ok) = base(ok) + line(ok);
  S.Fs1 = S.Fs0; lastv = find(ok, 1, 'last'); S.Fs1(lastv) = base(lastv); S.lastv = lastv;
  S.pb = pb; S.pa = pa; S.sig_b = R.sig_b; S.sig_a = R.sig_a; S.z0 = z0; S.ztrue = ztrue;
end
