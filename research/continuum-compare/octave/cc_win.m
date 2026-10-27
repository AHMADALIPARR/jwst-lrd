% SPDX-License-Identifier: AGPL-3.0-only
% cc_win.m -- build one fit window (PREREG section 1). line: 'hb' | 'ha'.  bw: blue half-width for Ha (Hb fixed -12..+6).
function W = cc_win(D, ok, line, bw)
  % bw scalar: Ha blue half-width.  bw = [lo hi]: ABSOLUTE raw pixel range (engine-validation test only).
  K = cc_const();
  if strcmp(line, 'hb'), R = K.Rhb; else R = K.Rha; end
  [~, c] = min(abs(D.lam - R*(1+K.zref)));
  if numel(bw) == 2, rng = bw(1):bw(2); elseif strcmp(line, 'hb'), rng = (c-12):(c+6); else rng = (c-bw):(c+12); end
  rng = rng(rng >= 2 & rng <= D.n-1);
  p = rng(ok(rng)); p = p(:);
  W.line = line; W.R = R; W.c = c; W.p = p; W.n = numel(p); W.idx = D.idx(p);
  W.lam = D.lam(p); W.f = D.fl(p); W.e = D.er(p); W.w = 1 ./ (W.e.^2);
  W.lo = (D.lam(p-1) + D.lam(p)) / 2; W.hi = (D.lam(p) + D.lam(p+1)) / 2; W.pwk = (D.lam(p+1) - D.lam(p-1)) / 2;
  W.pwc = (D.lam(c+1) - D.lam(c-1)) / 2; W.lamc = D.lam(c);
  W.sl = K.lsfpx * W.pwc / K.fw2s;                       % sigma_LSF (Angstrom), from the window-centre pixel width
  W.xs = (W.lam - W.lamc) / W.pwc / 12;                  % scaled pixel coordinate
  W.rm = zeros(W.n, numel(K.rmH));
  for h = 1:numel(K.rmH)
    C = cc_runmed(D.fl, D.er, ok, K.rmH(h)); W.rm(:,h) = C(p);
  end
end
