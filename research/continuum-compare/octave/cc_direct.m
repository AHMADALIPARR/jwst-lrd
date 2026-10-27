% SPDX-License-Identifier: AGPL-3.0-only
% cc_direct.m -- brute-force evaluation of one window at given (z, sigma_int[, sigma_b], beta-index): explicit design matrix,
% weighted least squares by backslash, non-negativity of line amplitudes by enumerating active subsets. Independent of cc_wchi2's
% Schur-complement algebra (used by test.sh to validate it, and to extract best-fit parameters).
function [chi2, par, mdl, cont] = cc_direct(W, cm, comp, z, sig, ib)
  K = cc_const(); if nargin < 6, ib = 1; end
  [B, kc] = cc_basis(W, cm); Cb = B{ib};
  mu = W.R * (1 + z);
  if comp == 1, Tm = cc_tmpl(W, mu, sig(1), K); else Tm = [cc_tmpl(W, mu, sig(1), K), cc_tmpl(W, mu, sig(2), K)]; end
  if strcmp(cm.type, 'rm'), d = W.f - W.rm(:, cm.hi); else d = W.f; end
  sw = sqrt(W.w); na = columns(Tm); best = inf; par = []; mdl = [];
  for mask = 0:(2^na - 1)
    use = logical(bitget(mask, 1:na));
    X = [Cb, Tm(:, use)];
    if isempty(X), p = zeros(0,1); m = zeros(size(d)); else
      p = (bsxfun(@times, sw, X)) \ (sw .* d); m = X * p;
    end
    if any(p(kc+1:end) < 0), continue; end
    c2 = sum(W.w .* (d - m).^2);
    if c2 < best
      best = c2; pf = zeros(kc + na, 1); pf(1:kc) = p(1:kc); pf(kc + find(use)) = p(kc+1:end); par = pf; mdl = m;
    end
  end
  chi2 = best;
  if kc > 0, cont = Cb * par(1:kc); else cont = zeros(size(d)); end
  if strcmp(cm.type, 'rm'), cont = W.rm(:, cm.hi); end
end
