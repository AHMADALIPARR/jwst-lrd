% SPDX-License-Identifier: AGPL-3.0-only
% cc_line.m -- one verbatim FIT record.
function s = cc_line(R, scen, bw)
  bw = strtrim(num2str(bw(:)'));
  cn = {'1C','2C'};
  s = sprintf(['FIT model=%s comp=%s scen=%s BW=%s n=%d nHb=%d nHa=%d k=%d dof=%d zJ=%.6f hwJ=%.6f lo=%.6f hi=%.6f hwJscaled=%.6f chi2=%.4f chi2red=%.4f aic=%.4f bic=%.4f bic_k0=%.4f ' ...
              'zHb=%.6f hwHb=%.6f chi2Hb=%.4f zHa=%.6f hwHa=%.6f chi2Ha=%.4f sigHb=%g sigHa=%g sigHaB=%g edge=%d'], ...
    R.cm.name, cn{R.comp}, scen, bw, R.n, R.nb, R.na, R.k, R.dof, R.rj.z, R.rj.hw, R.rj.lo, R.rj.hi, R.hwscaled, R.rj.chi, R.chired, R.aic, R.bic, R.bic_k0, ...
    R.rb.z, R.rb.hw, R.rb.chi, R.ra.z, R.ra.hw, R.ra.chi, R.sig_b, R.sig_a, R.sig_a2, R.rj.edge || R.rb.edge || R.ra.edge);
end
