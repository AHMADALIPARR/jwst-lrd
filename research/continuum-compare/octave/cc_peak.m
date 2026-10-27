% SPDX-License-Identifier: AGPL-3.0-only
% cc_peak.m -- minimum (3-point parabola on the grid), Delta chi^2 = 1 crossings (linear interpolation), edge flag.
function r = cc_peak(zg, chi)
  [cm, g] = min(chi); dz = zg(2) - zg(1); z = zg(g);
  if g > 1 && g < numel(zg)
    a = chi(g-1); b = chi(g); c = chi(g+1); den = a - 2*b + c;
    if den > 0, z = z - 0.5*dz*(c - a)/den; cm = b - (c - a)^2/(8*den); end
  end
  lo = NaN; hi = NaN; tgt = cm + 1;
  for k = g:-1:2, if chi(k-1) > tgt, f = (tgt - chi(k)) / (chi(k-1) - chi(k)); lo = zg(k) - f*dz; break; end, end
  for k = g:(numel(zg)-1), if chi(k+1) > tgt, f = (tgt - chi(k)) / (chi(k+1) - chi(k)); hi = zg(k) + f*dz; break; end, end
  r.z = z; r.chi = cm; r.lo = lo; r.hi = hi; r.hw = (hi - lo)/2; r.g = g; r.edge = (g == 1 || g == numel(zg));
end
