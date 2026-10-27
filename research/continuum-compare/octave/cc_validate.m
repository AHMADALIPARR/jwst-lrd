% SPDX-License-Identifier: AGPL-3.0-only
% cc_validate.m -- engine validation against awk-sp (PREREG section 8): awk-sp window rule (q+-5 raw pixels around ip: Hb 258, Ha 417), no-drop.
function cc_validate()
  D = cc_load(); M = cc_models(); [ok, ~] = cc_scen(D, 'D0'); rw = [253 263 412 422];
  nm = {'RM12', 'P1', 'P2'}; mi = [2 5 6];
  for t = 1:3
    R = cc_fit(D, ok, M{mi(t)}, 1, rw);
    printf('VAL awkwindow model=%s zJ=%.6f hwJ=%.6f chi2=%.3f zHb=%.6f zHa=%.6f nHb=%d nHa=%d\n', nm{t}, R.rj.z, R.rj.hw, R.rj.chi, R.rb.z, R.ra.z, R.nb, R.na);
  end
  C = dlmread('work/cont12.tsv', '\t'); c12 = cc_runmed(D.fl, D.er, ok, 12); v = find(ok);
  printf('VAL runmed12 octave-vs-awk(continuum.awk) maxabsdiff=%.3e over %d valid pixels\n', max(abs(c12(v) - C(v,6))), numel(v));
end
