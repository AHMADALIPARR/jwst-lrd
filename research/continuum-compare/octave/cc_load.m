% SPDX-License-Identifier: AGPL-3.0-only
% cc_load.m -- read work/cc_input.tsv (idx wl_A flam eflam ok errJy), produced by awk from the sha-verified arrays. Raw arrays untouched.
function D = cc_load(f)
  if nargin < 1, f = 'work/cc_input.tsv'; end
  M = dlmread(f, '\t');
  D.idx = M(:,1); D.lam = M(:,2); D.fl = M(:,3); D.er = M(:,4); D.ok = (M(:,5) == 1); D.ejy = M(:,6); D.n = rows(M);
end
