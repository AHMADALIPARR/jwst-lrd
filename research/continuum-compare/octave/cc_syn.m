% SPDX-License-Identifier: AGPL-3.0-only
% cc_syn.m -- SYNTHETIC controls.  usage: cc_syn('noisefree'|'edge'|'noisy', model_idx, comp [, N])
%   Every printed line starts with 'SYNTHETIC' so it cannot be mistaken for a data fit.
function cc_syn(kind, mi, comp, N)
  D = cc_load(); M = cc_models(); K = cc_const(); [ok, ~] = cc_scen(D, 'D0'); zt = K.zpub;
  S = cc_synth(D, ok, zt);
  printf('SYNTHETIC setup z_true=%.5f P1-params Hb[c0 c1 A]=[%.6g %.6g %.6g] Ha[c0 c1 A]=[%.6g %.6g %.6g] sigHb=%g sigHa=%g (from real-data P1/1C fit at z=%.5f)\n', zt, S.pb, S.pa, S.sig_b, S.sig_a, S.z0);
  Ds = D;
  switch kind
    case {'noisefree', 'edge'}
      if strcmp(kind, 'edge'), Ds.fl = S.Fs1; else, Ds.fl = S.Fs0; end
      R = cc_fit(Ds, ok, M{mi}, comp, 12);
      printf('SYNTHETIC kind=%s model=%s comp=%dC z_true=%.5f zJ=%.6f bias=%+.3e hwJ=%.6f chi2=%.4f zHb=%.6f zHa=%.6f\n', kind, M{mi}.name, comp, zt, R.rj.z, R.rj.z - zt, R.rj.hw, R.rj.chi, R.rb.z, R.ra.z);
    case 'noisy'
      randn('state', 1000 + 10 * mi + comp);
      zs = zeros(N, 1); hw = zs;
      for r = 1:N
        Ds.fl = S.Fs0; Ds.fl(ok) = S.Fs0(ok) + randn(sum(ok), 1) .* D.er(ok);
        R = cc_fit(Ds, ok, M{mi}, comp, 12);
        zs(r) = R.rj.z; hw(r) = R.rj.hw;
        printf('SYNTHETIC kind=noisy model=%s comp=%dC run=%d zJ=%.6f hwJ=%.6f chi2=%.3f\n', M{mi}.name, comp, r, zs(r), hw(r), R.rj.chi);
      end
      cov = sum(abs(zs - zt) < hw);
      printf('SYNTHETIC SUMMARY kind=noisy model=%s comp=%dC N=%d z_true=%.5f mean_bias=%+.3e sd=%.3e mean_hw=%.3e coverage_1sigma=%d/%d\n', M{mi}.name, comp, N, zt, mean(zs) - zt, std(zs), mean(hw), cov, N);
  end
end
