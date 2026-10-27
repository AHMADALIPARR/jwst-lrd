% SPDX-License-Identifier: AGPL-3.0-only
% cc_tmpl.m -- pixel-integrated unit-area Gaussian templates (npix x nsigma) at observed centre mu (Angstrom).
function T = cc_tmpl(W, mu, sg, K)
  s = sqrt(W.sl^2 + (sg / K.ckms * mu).^2);                      % 1 x ns
  T = bsxfun(@rdivide, 0.5*erfc(-bsxfun(@rdivide, W.hi - mu, s)/sqrt(2)) - 0.5*erfc(-bsxfun(@rdivide, W.lo - mu, s)/sqrt(2)), W.pwk);
end
