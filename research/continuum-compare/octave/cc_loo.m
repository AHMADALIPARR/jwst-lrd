% SPDX-License-Identifier: AGPL-3.0-only
% cc_loo.m -- Halpha leave-one-out at D0 (PREREG section 7). usage: cc_loo(model_idx, comp)
function cc_loo(mi, comp)
  D = cc_load(); M = cc_models(); [ok, ~] = cc_scen(D, 'D0');
  R0 = cc_fit(D, ok, M{mi}, comp, 12);
  cache = struct('chb', R0.chb, 'sb1', R0.sb1, 'sb2', R0.sb2);
  printf('LOO model=%s comp=%dC full zJ=%.6f hwJ=%.6f nHa=%d\n', M{mi}.name, comp, R0.rj.z, R0.rj.hw, R0.na);
  for p = R0.Wa.idx(:)'
    ok2 = ok; ok2(D.idx == p) = false;
    R = cc_fit(D, ok2, M{mi}, comp, 12, cache);
    printf('LOO model=%s comp=%dC drop=%d zJ=%.6f hwJ=%.6f dz=%+.3e\n', M{mi}.name, comp, p, R.rj.z, R.rj.hw, R.rj.z - R0.rj.z);
  end
end
