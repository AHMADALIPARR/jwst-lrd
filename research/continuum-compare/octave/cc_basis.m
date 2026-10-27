% SPDX-License-Identifier: AGPL-3.0-only
% cc_basis.m -- continuum basis columns for model cm on window W. Returns cell array B{b} (npix x kc) over the nuisance grid b.
%   cm.type: 'rm' (kc=0) | 'poly' | 'pl' (beta per window, profiled in the window) | 'pllin' (beta shared across windows) | 'spl'
function [B, kc, nb] = cc_basis(W, cm)
  K = cc_const();
  switch cm.type
    case 'rm'
      B = {zeros(W.n,0)}; kc = 0; nb = 1;
    case 'poly'
      B = {bsxfun(@power, W.xs, 0:cm.p)}; kc = cm.p + 1; nb = 1;
    case {'pl','pllin'}
      nb = numel(K.beta); B = cell(nb,1); L = log(W.lam / W.lamc);
      for b = 1:nb
        col = exp(K.beta(b) * L);
        if strcmp(cm.type, 'pl'), B{b} = col; else B{b} = [col, W.xs]; end
      end
      kc = size(B{1}, 2);
    case 'spl'
      m = W.n; x = W.xs;
      kn = x(round(1 + (m-1) * [0 1/3 2/3 1])); K4 = kn(4);
      dk = @(k) (max(x - kn(k), 0).^3 - max(x - K4, 0).^3) / (K4 - kn(k));
      B = {[ones(m,1), x, dk(1) - dk(3), dk(2) - dk(3)]}; kc = 4; nb = 1;
    otherwise
      error('cc_basis: type %s', cm.type);
  end
end
