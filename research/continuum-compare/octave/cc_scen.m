% SPDX-License-Identifier: AGPL-3.0-only
% cc_scen.m -- explicit pixel mask for a scenario (PREREG section 3). Returns logical valid-vector + a log string.
%   'D0'..'D4' : drop last D valid pixels;  'ERRALL' / 'ERREDGE' : flux_error rule (1.5 x median err_Jy of valid px 380-404)
%   'X<idx>'   : D0 with extra pixel idx masked (leave-one-out);  'X<a>,<b>' several.
function [ok, logs] = cc_scen(D, name)
  K = cc_const();
  ok = D.ok; v = find(ok); logs = '';
  if numel(name) >= 2 && name(1) == 'D' && all(isdigit(name(2:end)))
    d = str2double(name(2:end));
    if d > 0, ok(v(end-d+1:end)) = false; logs = sprintf('dropped idx %s', mat2str(D.idx(v(end-d+1:end))')); end
  elseif strcmp(name, 'ERRALL') || strcmp(name, 'ERREDGE')
    ref = ok & D.idx >= K.errref(1) & D.idx <= K.errref(2);
    thr = K.errthr * median(D.ejy(ref));
    bad = ok & D.ejy > thr;
    if strcmp(name, 'ERREDGE')
      e = false(D.n,1); j = numel(v);
      while j >= 1 && D.ejy(v(j)) > thr, e(v(j)) = true; j--; end
      bad = e;
    end
    ok(bad) = false;
    logs = sprintf('thr_Jy=%.6e ref_median_Jy=%.6e masked idx %s', thr, thr/K.errthr, mat2str(D.idx(bad)'));
  elseif name(1) == 'X'
    ix = str2num(['[' name(2:end) ']']); %#ok<ST2NM>
    for t = ix(:)', ok(D.idx == t) = false; end
    logs = sprintf('extra masked idx %s', mat2str(ix(:)'));
  else
    error('cc_scen: unknown scenario %s', name);
  end
end
