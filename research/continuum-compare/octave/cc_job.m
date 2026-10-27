% SPDX-License-Identifier: AGPL-3.0-only
% cc_job.m -- run one job and print its verbatim FIT record.   usage: octave --eval "cc_job(model_idx, comp, 'SCEN', bw)"
function cc_job(mi, comp, scen, bw)
  D = cc_load(); M = cc_models(); [ok, lg] = cc_scen(D, scen);
  R = cc_fit(D, ok, M{mi}, comp, bw);
  printf('%s\n', cc_line(R, scen, bw));
  if ~isempty(lg), printf('MASKLOG scen=%s %s\n', scen, lg); end
end
