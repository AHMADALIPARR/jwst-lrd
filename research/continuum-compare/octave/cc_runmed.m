% SPDX-License-Identifier: AGPL-3.0-only
% cc_runmed.m -- iterative sigma-clipped running median, a line-by-line port of awk/continuum.awk (HALF in valid pixels, CLIP=3, NITER=6).
function C = cc_runmed(F, E, ok, HALF)
  CLIP = 3; NITER = 6;
  v = find(ok); nv = numel(v); f = F(v); e = E(v);
  CL = false(nv,1); Cj = zeros(nv,1);
  for it = 0:NITER
    for j = 1:nv
      lo = max(1, j-HALF); hi = min(nv, j+HALF);
      sel = lo:hi; use = sel(~CL(sel));
      if numel(use) < 3, use = sel; end
      Cj(j) = median(f(use));
    end
    changed = 0;
    for j = 1:nv
      c = ((f(j) - Cj(j)) / e(j) > CLIP);
      if c ~= CL(j) && it < NITER, changed++; end
      if it < NITER, CL(j) = c; end
    end
    if changed == 0 && it > 0, break; end
    if it == 0 && changed == 0, break; end
  end
  C = zeros(size(F)); C(v) = Cj;
end
