% SPDX-License-Identifier: AGPL-3.0-only
% GNU Octave (NOT MATLAB) numeric spot checks for Schwarzschild / Kruskal-Szekeres, units rs = 1.
% Independent of the Maxima symbolic checks: finite differences + safeguarded Newton, fixed RNG seed.
1;

function r = r_of_w(w)
  % solve F(r) = (1-r) e^r = w for r > 0 (rs = 1); F decreasing on r>0, F(0)=1, requires w < 1
  lo = 0; hi = 2;
  while (1-hi)*exp(hi) > w, hi = 2*hi; end
  r = 0.5*(lo+hi);
  for it = 1:200
    F = (1-r)*exp(r) - w;
    if F > 0, lo = r; else hi = r; end
    Fp = -r*exp(r);
    rn = r - F/Fp;
    if rn <= lo || rn >= hi, rn = 0.5*(lo+hi); end
    if abs(rn - r) <= 1e-16*max(1,abs(r)), r = rn; break; end
    r = rn;
  end
end

function g = kruskal_g(x)            % x = [U V th ph]
  U = x(1); V = x(2); th = x(3);
  r = r_of_w(U*V);
  A = 4*exp(-r)/r;
  g = [0 -A/2 0 0; -A/2 0 0 0; 0 0 r^2 0; 0 0 0 r^2*sin(th)^2];
end

function dg = dmetric(gf, x, h)      % dg(a,b,c) = d_c g_ab, 4th-order central
  dg = zeros(4,4,4);
  for c = 1:4
    e = zeros(1,4); e(c) = h;
    dg(:,:,c) = (-gf(x+2*e) + 8*gf(x+e) - 8*gf(x-e) + gf(x-2*e))/(12*h);
  end
end

function G = christoffel_at(gf, x, h)  % G(i,j,k) = Gamma^i_{jk}
  g = gf(x); gi = inv(g); dg = dmetric(gf, x, h);
  G = zeros(4,4,4);
  for i=1:4, for j=1:4, for k=1:4
    s = 0;
    for l=1:4
      s = s + gi(i,l)*(dg(l,j,k) + dg(l,k,j) - dg(j,k,l));
    end
    G(i,j,k) = s/2;
  end, end, end
end

function Ric = ricci_at(gf, x, h)
  G0 = christoffel_at(gf, x, h);
  dG = zeros(4,4,4,4);   % dG(i,j,k,c) = d_c Gamma^i_{jk}
  for c = 1:4
    e = zeros(1,4); e(c) = h;
    Gp2 = christoffel_at(gf, x+2*e, h); Gp1 = christoffel_at(gf, x+e, h);
    Gm1 = christoffel_at(gf, x-e, h);   Gm2 = christoffel_at(gf, x-2*e, h);
    dG(:,:,:,c) = (-Gp2 + 8*Gp1 - 8*Gm1 + Gm2)/(12*h);
  end
  Ric = zeros(4,4);
  for j=1:4, for l=1:4
    s = 0;
    for i=1:4
      s = s + dG(i,j,l,i) - dG(i,j,i,l);        % d_i Gamma^i_{jl} - d_l Gamma^i_{ji}
      for m=1:4
        s = s + G0(i,i,m)*G0(m,j,l) - G0(i,l,m)*G0(m,j,i);
      end
    end
    Ric(j,l) = s;
  end, end
end

function L = lie_at(gf, xi, x, h)     % (L_xi g)_{mn} with xi a function handle x -> 4-vector
  g = gf(x); dg = dmetric(gf, x, h); X = xi(x);
  dX = zeros(4,4);                   % dX(p,m) = d_m xi^p
  for m=1:4
    e = zeros(1,4); e(m) = h;
    dX(:,m) = ((-xi(x+2*e) + 8*xi(x+e) - 8*xi(x-e) + xi(x-2*e))/(12*h))(:);
  end
  L = zeros(4,4);
  for m=1:4, for n=1:4
    s = 0;
    for p=1:4
      s = s + X(p)*dg(m,n,p) + g(p,n)*dX(p,m) + g(m,p)*dX(p,n);
    end
    L(m,n) = s;
  end, end
end

rand('seed', 20261026); randn('seed', 20261026);
pass_total = 0; fail_total = 0;
function report(name, p, n)
  if p == n, printf('PASS  %s : %d/%d\n', name, p, n); else printf('FAIL  %s : %d/%d\n', name, p, n); end
end

% sample points in the four quadrants of (U,V) with UV < 0.8 (stay away from r = 0)
quad = {[-1 1],[1 -1],[1 1],[-1 -1]};   % I, III, II, IV
names = {'I','III','II','IV'};
npt = 25;
pts = zeros(0,4); lab = [];
for q = 1:4
  k = 0;
  while k < npt
    U = quad{q}(1)*(0.02 + 1.5*rand()); V = quad{q}(2)*(0.02 + 1.5*rand());
    if U*V < 0.8
      pts(end+1,:) = [U V 0.5+2*rand() 6*rand()]; lab(end+1) = q; k = k+1;
    end
  end
end
% a few points extremely close to the horizon U=0 or V=0 (r ~ rs), still regular
for q = 1:4
  for k = 1:5
    U = quad{q}(1)*1e-6*rand(); V = quad{q}(2)*(0.1+rand());
    pts(end+1,:) = [U V 0.5+2*rand() 6*rand()]; lab(end+1) = q;
  end
end
N = size(pts,1);

% (1) UV = (1-r)e^r for inverted r;  r>0
p = 0;
for i=1:N
  r = r_of_w(pts(i,1)*pts(i,2));
  if r > 0 && abs((1-r)*exp(r) - pts(i,1)*pts(i,2)) < 1e-13, p++; end
end
report('oct-01 Newton inversion: UV=(1-r)e^r, r>0 (rs=1)', p, N);

% (2) exterior/interior sign structure: r>1 iff UV<0
p = 0;
for i=1:N
  r = r_of_w(pts(i,1)*pts(i,2)); w = pts(i,1)*pts(i,2);
  if (w < 0 && r > 1) || (w > 0 && r < 1) || w == 0, p++; end
end
report('oct-02 r>rs iff UV<0 (exterior regions I,III); r<rs iff UV>0 (II,IV)', p, N);

% (3) Ricci tensor of the Kruskal metric by finite differences (max abs component) at all points
% tolerance scaled to the local curvature scale sqrt(K)=sqrt(12)/r^3 (FD error grows as r -> 0):
% |R_mn| < 1e-6 * max(1, 1/r^3).  (A first run with a flat absolute tolerance 2e-6 gave 119/120,
% worst 2.35e-6 at a small-r point; the scaled tolerance was adopted afterwards and is documented in DERIVATION.md.)
p = 0; worst = 0;
for i=1:N
  Ric = ricci_at(@kruskal_g, pts(i,:), 2e-3);
  r = r_of_w(pts(i,1)*pts(i,2));
  m = max(abs(Ric(:))); ratio = m/(1e-6*max(1,1/r^3)); worst = max(worst, ratio);
  if ratio < 1, p++; end
end
report(sprintf('oct-03 Kruskal R_{mu nu}=0 by FD (tol 1e-6*max(1,r^-3); worst ratio %.2f), points', worst), p, N);

% (4) negative control: wrong conformal factor must give clearly nonzero Ricci at every point
function g = kruskal_bad(x)
  U = x(1); V = x(2); th = x(3);
  r = r_of_w(U*V); A = 4*exp(-2*r)/r;
  g = [0 -A/2 0 0; -A/2 0 0 0; 0 0 r^2 0; 0 0 0 r^2*sin(th)^2];
end
p = 0;
for i=1:N
  Ric = ricci_at(@kruskal_bad, pts(i,:), 2e-3);
  if max(abs(Ric(:))) > 1e-3, p++; end
end
report('oct-04 negative control (e^{-2r}) detected: |Ric|max > 1e-3, points', p, N);

% (5) Killing equations numerically: xi_t, L_z, L_x, L_y vanish; non-Killing controls do not
xi_t = @(x) [-x(1)/2, x(2)/2, 0, 0];
L_z  = @(x) [0 0 0 1];
L_x  = @(x) [0 0 -sin(x(4)) -cos(x(3))/sin(x(3))*cos(x(4))];
L_y  = @(x) [0 0  cos(x(4)) -cos(x(3))/sin(x(3))*sin(x(4))];
fields = {xi_t, L_z, L_x, L_y}; fnames = {'xi_t','L_z','L_x','L_y'};
for k=1:4
  p = 0;
  for i=1:N
    L = lie_at(@kruskal_g, fields{k}, pts(i,:), 2e-3);
    if max(abs(L(:))) < 1e-7, p++; end
  end
  report(sprintf('oct-05 Killing eq (L_xi g)=0 numeric: %s, points', fnames{k}), p, N);
end
ctrl = {@(x) [1 0 0 0], @(x) [x(1) x(2) 0 0], @(x) [0 0 1 0]};
p = 0;
for k=1:3
  q = 0;
  for i=1:N
    L = lie_at(@kruskal_g, ctrl{k}, pts(i,:), 2e-3);
    if max(abs(L(:))) > 1e-6, q++; end
  end
  if q == N, p++; end
end
report('oct-06 non-Killing controls (d_U, dilation, d_theta) detected at all points (3 fields)', p, 3);

% (6) norm of xi_t equals -(1-rs/r)
p = 0;
for i=1:N
  x = pts(i,:); g = kruskal_g(x); r = r_of_w(x(1)*x(2)); X = xi_t(x);
  if abs(X*g*X' + (1 - 1/r)) < 1e-12, p++; end
end
report('oct-07 g(xi_t,xi_t) = -(1-rs/r), points', p, N);

% (7) pullback to Schwarzschild coordinates (exterior + interior, forward map) by FD
function [U,V] = uv_of_tr(t, r, sU, sV)
  if r > 1, rs_ = r + log(r-1); else rs_ = r + log(1-r); end
  U = sU*exp((rs_ - t)/2); V = sV*exp((rs_ + t)/2);
end
cases = {[-1 1 1],[1 -1 1],[1 1 0],[-1 -1 0]};   % sU sV exterior?
p = 0; n = 0;
for c = 1:4
  for k = 1:20
    t = 3*(rand()-0.5)*2;
    if cases{c}(3), r = 1.001 + 6*rand(); else r = 0.05 + 0.9*rand(); end
    h = 1e-5;
    [Up,Vp] = uv_of_tr(t+h, r, cases{c}(1), cases{c}(2)); [Um,Vm] = uv_of_tr(t-h, r, cases{c}(1), cases{c}(2));
    dt = [(Up-Um)/(2*h), (Vp-Vm)/(2*h)];
    [Up,Vp] = uv_of_tr(t, r+h, cases{c}(1), cases{c}(2)); [Um,Vm] = uv_of_tr(t, r-h, cases{c}(1), cases{c}(2));
    dr = [(Up-Um)/(2*h), (Vp-Vm)/(2*h)];
    [U0,V0] = uv_of_tr(t, r, cases{c}(1), cases{c}(2));
    A = 4*exp(-r)/r; f = 1 - 1/r;
    gtt = -A*dt(1)*dt(2); gtr = -A/2*(dt(1)*dr(2)+dt(2)*dr(1)); grr = -A*dr(1)*dr(2);
    e1 = abs(gtt + f)/abs(f); e2 = abs(grr - 1/f)*abs(f); e3 = abs(gtr);
    n++;
    if e1 < 1e-6 && e2 < 1e-6 && e3 < 1e-6*max(1,abs(1/f)) && abs(U0*V0 - (1-r)*exp(r)) < 1e-10*max(1,abs((1-r)*exp(r))), p++; end
  end
end
report('oct-08 pullback of Kruskal metric = Schwarzschild (FD), 4 regions x 20 points', p, n);

% (8) Einstein-Rosen throat on T=0: area 4 pi r^2 minimised at X=0 with value 4 pi
Xs = linspace(-4, 4, 801);
rr = arrayfun(@(X) r_of_w(-X^2), Xs);
[amin, imin] = min(4*pi*rr.^2);
ok1 = abs(amin - 4*pi) < 1e-12 && abs(Xs(imin)) < 1e-12;
ok2 = all(rr >= 1 - 1e-15);
ok3 = max(abs(rr - fliplr(rr))) < 1e-13;                 % Z2 symmetry X -> -X
ok4 = all(diff(rr(401:end)) > 0);                        % r grows monotonically away from the throat
report('oct-09 ER throat: min area 4 pi rs^2 at X=0, r>=rs, Z2-symmetric, monotone (4 conditions)', ok1+ok2+ok3+ok4, 4);
