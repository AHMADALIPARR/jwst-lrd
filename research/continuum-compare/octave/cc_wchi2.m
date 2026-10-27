% SPDX-License-Identifier: AGPL-3.0-only
% cc_wchi2.m -- chi^2(z) of ONE window on the z grid, continuum parameters + amplitudes (>=0) solved linearly (Schur complement),
% sigma_int profiled over its grid by exhaustive minimisation.  comp = 1 (single Gaussian) or 2 (narrow+broad, shared centroid).
%   chi  : nz x nb   (nb = 1 except for 'pllin' where the shared-beta axis is kept for the joint minimisation)
%   si1/si2 : nz x nb  index of the minimising sigma grid element (si2 only for comp==2)
% For cm.type=='pl' the beta axis is minimised inside this function (beta is per window).
function [chi, si1, si2, bsel] = cc_wchi2(W, cm, comp, zg, keepb)
  K = cc_const(); if nargin < 5, keepb = strcmp(cm.type, 'pllin'); end
  [B, kc, nb] = cc_basis(W, cm);
  w = W.w; f = W.f;
  if strcmp(cm.type, 'rm'), d = f - W.rm(:, cm.hi); else d = f; end
  wd = w .* d;
  % ---- per-b continuum-only quantities
  CCi = cell(kc, kc); cb = cell(kc, 1); chi0 = zeros(nb, 1);
  for i = 1:kc, cb{i} = zeros(nb,1); for j = 1:kc, CCi{i,j} = zeros(nb,1); end, end
  Cstack = zeros(nb*kc, W.n);
  chi0all = sum(w .* d.^2);
  for b = 1:nb
    if kc == 0, chi0(b) = chi0all; continue; end
    Cb = B{b}; CC = Cb' * bsxfun(@times, w, Cb); CD = Cb' * wd;
    CCinv = inv(CC); c = CCinv * CD;
    chi0(b) = chi0all - CD' * c;
    for i = 1:kc, cb{i}(b) = c(i); for j = 1:kc, CCi{i,j}(b) = CCinv(i,j); end, end
    Cstack((b-1)*kc + (1:kc), :) = Cb';
  end
  nz = numel(zg); chi = zeros(nz, nb); si1 = zeros(nz, nb); si2 = zeros(nz, nb);
  sq2 = sqrt(2);
  if comp == 1, sgA = K.sg1; else sgA = K.sgn; end
  sgB = K.sgb;
  for iz = 1:nz
    mu = W.R * (1 + zg(iz));
    T1 = cc_tmpl(W, mu, sgA, K);                                   % npix x nA
    WT1 = bsxfun(@times, w, T1);
    TT1 = sum(WT1 .* T1, 1); TD1 = wd' * T1;
    if kc > 0
      CT1 = Cstack * WT1; CT1i = cell(kc,1);                       % (nb*kc) x nA
      for i = 1:kc, CT1i{i} = CT1(i:kc:end, :); end                % nb x nA
      v1 = zeros(nb, numel(sgA)); q1 = v1;
      for i = 1:kc
        v1 += bsxfun(@times, CT1i{i}, cb{i});
        for j = 1:kc, q1 += bsxfun(@times, CT1i{i} .* CT1i{j}, CCi{i,j}); end
      end
      s11 = bsxfun(@minus, TT1, q1); b1 = bsxfun(@minus, TD1, v1);
    else
      s11 = repmat(TT1, nb, 1); b1 = repmat(TD1, nb, 1);
    end
    if comp == 1
      ok1 = s11 > 1e-12 * max(TT1, 1e-300);
      dch = zeros(size(s11)); m = ok1 & b1 > 0; dch(m) = b1(m).^2 ./ s11(m);
      [dm, ix] = max(dch, [], 2);
      chi(iz, :) = (chi0 - dm)'; si1(iz, :) = ix';
    else
      T2 = cc_tmpl(W, mu, sgB, K); nB = numel(sgB); nA = numel(sgA);
      WT2 = bsxfun(@times, w, T2);
      TT2 = sum(WT2 .* T2, 1); TD2 = wd' * T2; X12 = WT1' * T2;    % nA x nB
      if kc > 0
        CT2 = Cstack * WT2; CT2i = cell(kc,1);
        for i = 1:kc, CT2i{i} = CT2(i:kc:end, :); end
        v2 = zeros(nb, nB); q2 = v2; q12 = zeros(nb, nA, nB);
        for i = 1:kc
          v2 += bsxfun(@times, CT2i{i}, cb{i});
          for j = 1:kc
            q2 += bsxfun(@times, CT2i{i} .* CT2i{j}, CCi{i,j});
            q12 += bsxfun(@times, bsxfun(@times, reshape(CT1i{i}, nb, nA, 1), reshape(CT2i{j}, nb, 1, nB)), CCi{i,j});
          end
        end
        s22 = bsxfun(@minus, TT2, q2); b2 = bsxfun(@minus, TD2, v2);
        s12 = bsxfun(@minus, reshape(X12, 1, nA, nB), q12);
      else
        s22 = repmat(TT2, nb, 1); b2 = repmat(TD2, nb, 1); s12 = repmat(reshape(X12, 1, nA, nB), nb, 1, 1);
      end
      S11 = repmat(s11, [1 1 nB]); S22 = repmat(reshape(s22, nb, 1, nB), [1 nA 1]);
      B1 = repmat(b1, [1 1 nB]);   B2 = repmat(reshape(b2, nb, 1, nB), [1 nA 1]);
      det = S11 .* S22 - s12.^2;
      good = S11 > 1e-12*max(TT1) & S22 > 1e-12*max(TT2) & det > 1e-10 * S11 .* S22;
      A1 = zeros(size(det)); A2 = A1; dju = zeros(size(det));
      A1(good) = (B1(good) .* S22(good) - B2(good) .* s12(good)) ./ det(good);
      A2(good) = (B2(good) .* S11(good) - B1(good) .* s12(good)) ./ det(good);
      dju(good) = (B1(good).^2 .* S22(good) - 2 * B1(good) .* B2(good) .* s12(good) + B2(good).^2 .* S11(good)) ./ det(good);
      feas = good & A1 >= 0 & A2 >= 0;
      d1 = zeros(size(det)); m = S11 > 0 & B1 > 0; d1(m) = B1(m).^2 ./ S11(m);
      d2 = zeros(size(det)); m = S22 > 0 & B2 > 0; d2(m) = B2(m).^2 ./ S22(m);
      dch = max(d1, d2); dch(feas) = dju(feas);
      [dm, ix] = max(reshape(dch, nb, nA*nB), [], 2);
      chi(iz, :) = (chi0 - dm)';
      si1(iz, :) = (mod(ix - 1, nA) + 1)'; si2(iz, :) = (floor((ix - 1) / nA) + 1)';
    end
  end
  bsel = ones(nz, 1);
  if ~keepb && nb > 1
    [chi, ib] = min(chi, [], 2);
    idx = sub2ind([nz nb], (1:nz)', ib);
    s1 = si1; si1 = s1(idx); if comp == 2, s2 = si2; si2 = s2(idx); end
    bsel = ib;
  end
end
