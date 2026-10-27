% SPDX-License-Identifier: AGPL-3.0-only
% cc_fit.m -- joint + per-line fit of one model/comp on one pixel mask.  cache (optional) = struct with .chb (Hbeta chi from an earlier call).
function R = cc_fit(D, ok, cm, comp, bw, cache)
  K = cc_const(); zg = K.zg;
  if numel(bw) == 4, Wb = cc_win(D, ok, 'hb', bw(1:2)); Wa = cc_win(D, ok, 'ha', bw(3:4)); else, Wb = cc_win(D, ok, 'hb', 12); Wa = cc_win(D, ok, 'ha', bw); end
  shared = strcmp(cm.type, 'pllin');
  if nargin >= 6 && ~isempty(cache), chb = cache.chb; sb1 = cache.sb1; sb2 = cache.sb2;
  else, [chb, sb1, sb2] = cc_wchi2(Wb, cm, 1, zg, shared); end   % Hbeta is always a single Gaussian (PREREG section 1)
  [cha, sa1, sa2] = cc_wchi2(Wa, cm, comp, zg, shared);
  R.chb = chb; R.sb1 = sb1; R.sb2 = sb2; R.cha = cha; R.sa1 = sa1; R.sa2 = sa2;
  if shared
    J = chb + cha; [Jm, jb] = min(J, [], 2); rj = cc_peak(zg, Jm);
    rb = cc_peak(zg, min(chb, [], 2)); ra = cc_peak(zg, min(cha, [], 2));
    gj = rj.g; bj = jb(gj);                                         % shared beta index at the joint minimum
    ib_b = bj; ib_a = bj;
    [~, ib_bb] = min(chb(rb.g, :)); [~, ib_aa] = min(cha(ra.g, :));
  else
    rj = cc_peak(zg, chb + cha); rb = cc_peak(zg, chb); ra = cc_peak(zg, cha);
    gj = rj.g; ib_b = 1; ib_a = 1;
  end
  R.rj = rj; R.rb = rb; R.ra = ra; R.nb = Wb.n; R.na = Wa.n; R.n = Wb.n + Wa.n;
  % sigma at the joint minimum (grid element)
  if comp == 1
    R.sig_b = K.sg1(sb1(gj, ib_b)); R.sig_a = K.sg1(sa1(gj, ib_a)); R.sig_a2 = NaN;
  else
    R.sig_b = K.sg1(sb1(gj, ib_b)); R.sig_a = K.sgn(sa1(gj, ib_a)); R.sig_a2 = K.sgb(sa2(gj, ib_a));
  end
  % parameter count (PREREG section 4)
  nlin_amp = 1 + comp; nnl = 1 + 1 + comp;                          % z, sigma_Hb, sigma_Ha(1 or 2)
  switch cm.type
    case 'rm', kcont = ceil(Wb.n/(2*cm.H+1)) + ceil(Wa.n/(2*cm.H+1)); knl_c = 0; kcont0 = 0;
    case 'poly', kcont = 2*(cm.p+1); knl_c = 0;
    case 'pl', kcont = 2; knl_c = 2;
    case 'pllin', kcont = 4; knl_c = 1;
    case 'spl', kcont = 8; knl_c = 0;
  end
  R.k = nnl + knl_c + kcont + nlin_amp; R.kcont = kcont;
  R.dof = R.n - R.k;
  R.aic = rj.chi + 2*R.k; R.bic = rj.chi + R.k*log(R.n);
  if strcmp(cm.type, 'rm'), R.bic_k0 = rj.chi + (R.k - kcont)*log(R.n); else R.bic_k0 = R.bic; end
  if R.dof > 0, R.chired = rj.chi / R.dof; else R.chired = NaN; end
  R.hwscaled = rj.hw * sqrt(max(R.chired, 1));
  R.Wb = Wb; R.Wa = Wa; R.cm = cm; R.comp = comp;
  R.ibj = ib_b;
end
