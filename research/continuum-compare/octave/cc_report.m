% SPDX-License-Identifier: AGPL-3.0-only
% cc_report.m -- apply the PREREG.md criteria (sections 4-7) to the verbatim job outputs; prints REPORT lines.
function cc_report()
  K = cc_const(); zpub = K.zpub; dz_gap = zpub - K.zfort;
  fl = glob('results/jobs/fit_*.out'); S = cc_parse(fl, 'FIT'); nF = numel(S);
  mn = cell(nF,1); cp = zeros(nF,1); sc = cell(nF,1); bw = zeros(nF,1);
  for i = 1:nF, mn{i} = S(i).r.model; cp(i) = str2double(strtok(S(i).r.comp, 'C')); sc{i} = S(i).r.scen; bw(i) = S(i).r.BW; end
  get = @(m, c, s, b) find(strcmp(mn, m) & cp == c & strcmp(sc, s) & bw == b);
  names = {'RM6','RM12','RM20','P0','P1','P2','P3','PL','PLLIN','SPL'};
  printf('REPORT records parsed: %d (expect 180)\n', nF);
  % ---------------- A. D0 table
  printf('\nREPORT A. D0 baseline (BW=12), all 20 models\n');
  printf('REPORT %-6s %-3s %9s %9s %9s %9s %9s %8s %3s %4s %7s %9s %9s %7s %s\n', 'model','C','zJ','hwJ','hwJscal','zHb','zHa','chi2','k','dof','chi2red','AIC','BIC','dBIC','flags');
  M = []; lab = {};
  for c = 1:2, for m = 1:10
    i = get(names{m}, c, 'D0', 12); if isempty(i), continue; end
    r = S(i).r; M(end+1,:) = [r.zJ r.hwJ r.hwJscaled r.zHb r.zHa r.chi2 r.k r.dof r.chi2red r.aic r.bic r.n r.bic_k0 r.edge i]; lab{end+1} = sprintf('%s_%dC', names{m}, c);
  end, end
  [bmin, ib] = min(M(:,11)); dB = M(:,11) - bmin;
  for q = 1:rows(M)
    fl_ = ''; if M(q,14), fl_ = [fl_ ' Z-GRID-EDGE']; end
    if M(q,8) <= 0, fl_ = [fl_ ' DOF<=0']; end
    printf('REPORT %-9s %9.6f %9.6f %9.6f %9.6f %9.6f %8.3f %3d %4d %7.3f %9.3f %9.3f %7.2f%s\n', lab{q}, M(q,1:6), M(q,7), M(q,8), M(q,9), M(q,10), M(q,11), dB(q), fl_);
  end
  % ---------------- B. selection
  [~, ord] = sort(M(:,11)); best = ord(1); run2 = ord(2);
  printf('\nREPORT B. selection by lowest BIC = chi2 + k ln n (n = %d)\n', M(1,12));
  printf('REPORT best=%s BIC=%.3f runner-up=%s dBIC=%.3f\n', lab{best}, M(best,11), lab{run2}, dB(run2));
  if dB(run2) >= 6, sel = 'selected'; elseif dB(run2) >= 2, sel = 'weakly selected'; else, sel = 'not distinguishable'; end
  printf('REPORT selection status: %s\n', sel);
  indist = find(dB < 2); adm = find(dB <= 10);
  printf('REPORT indistinguishable set (dBIC<2): %s\n', strjoin(lab(indist), ' '));
  printf('REPORT admissible set (dBIC<=10): %s\n', strjoin(lab(adm), ' '));
  cmin = min(M(M(:,8) > 0, 9)); Q = M(:,6) / cmin + M(:,7) .* log(M(:,12)); [~, qb] = min(Q);
  printf('REPORT QBIC (EXPLORATORY) c_hat=%.4f best=%s ; BIC and QBIC pick the same model: %d  => %s\n', cmin, lab{qb}, qb == best, ifelse_(qb == best, 'robust', 'NOT ROBUST'));
  printf('REPORT BIC with k_cont=0 for RM (EXPLORATORY) best=%s\n', lab{find(M(:,13) == min(M(:,13)), 1)});
  % selection persistence at D1
  M1 = []; lab1 = {};
  for c = 1:2, for m = 1:10
    i = get(names{m}, c, 'D1', 12); if isempty(i), continue; end
    r = S(i).r; M1(end+1,:) = [r.bic r.zJ]; lab1{end+1} = sprintf('%s_%dC', names{m}, c);
  end, end
  [b1, i1] = min(M1(:,1));
  printf('REPORT D1 best BIC model=%s (BIC=%.3f) ; D0 best=%s ; selection persistent: %d\n', lab1{i1}, b1, lab{best}, strcmp(lab1{i1}, lab{best}));
  % ---------------- C. stability
  printf('\nREPORT C. stability |z(D1)-z(D0)| < sigma_J(D0), plus shifts in units of sigma_J(D0)\n');
  printf('REPORT %-9s %9s %9s %8s %8s %8s %8s %8s %8s %8s %6s\n', 'model','zJ(D0)','sigma','D1','D2','D3','D4','ERRALL','ERREDGE','BW8/BW6','STABLE');
  stab = false(rows(M),1); zall = [];
  for q = 1:rows(M)
    nm = lab{q}; m = strtok(nm, '_'); c = str2double(nm(end-1)); z0 = M(q,1); sg = M(q,2); zs = zeros(1,9);
    sl = {'D1','D2','D3','D4','ERRALL','ERREDGE'}; for t = 1:6, i = get(m, c, sl{t}, 12); if isempty(i), zs(t) = NaN; else, zs(t) = S(i).r.zJ; end, end
    i = get(m, c, 'D0', 8); zs(7) = ifnan_(i, S); i = get(m, c, 'D0', 6); zs(8) = ifnan_(i, S);
    stab(q) = abs(zs(1) - z0) < sg;
    printf('REPORT %-9s %9.6f %9.6f %+8.2f %+8.2f %+8.2f %+8.2f %+8.2f %+8.2f %+8.2f/%+.2f %6d\n', nm, z0, sg, (zs(1:6) - z0) / sg, (zs(7) - z0)/sg, (zs(8) - z0)/sg, stab(q));
    zall = [zall; z0 zs(1:8)];
  end
  if dB(run2) >= 2, set_ = best; else, set_ = indist; end
  printf('REPORT model-selected set for the stability statement: %s\n', strjoin(lab(set_), ' '));
  printf('REPORT every member stable (PREREG sec. 5): %d ; members stable: %s\n', all(stab(set_)), mat2str(stab(set_)'));
  printf('REPORT number of the 20 models that are stable: %d/20\n', sum(stab));
  % ---------------- D. gap
  printf('\nREPORT D. gap to published z=%.4f (Fortran centroid %.5f, dz=%.5f = %.1f km/s)\n', zpub, K.zfort, dz_gap, K.ckms * dz_gap / (1 + zpub));
  R1 = [min(M(:,1)) max(M(:,1))]; R2 = [min(M(adm,1)) max(M(adm,1))];
  zs3 = zall(:); zs3 = zs3(isfinite(zs3)); R3 = [min(zs3) max(zs3)];
  rr = {R1, R2, R3}; rn = {'R1 (20 models, D0)', 'R2 (admissible set, D0)', 'R3 (20 models x 7 scenarios + BW8/6)'};
  for t = 1:3
    R = rr{t}; inside = zpub >= R(1) && zpub <= R(2); dist = min(abs(zpub - R));
    printf('REPORT %s: [%.6f, %.6f] width=%.6f ; published %.4f inside: %d ; distance to nearest edge=%.6f (%.1f x median sigma_J(D0)=%.6f)\n', rn{t}, R, R(2) - R(1), zpub, inside, dist, dist / median(M(:,2)), median(M(:,2)));
  end
  [zmx, imx] = max(M(:,1)); printf('REPORT highest D0 z: %s zJ=%.6f (hwJ=%.6f, %.2f sigma from 7.0451)\n', lab{imx}, zmx, M(imx,2), (zpub - zmx) / M(imx,2));
  for q = 1:rows(M), nsg(q) = (zpub - M(q,1)) / M(q,2); end
  printf('REPORT D0 models within 3 sigma_J of 7.0451: %s\n', strjoin(lab(abs(nsg) <= 3), ' '));
  % ---------------- E. LOO
  printf('\nREPORT E. Halpha leave-one-out at D0 (influential: |dz| >= 0.5 sigma_J)\n');
  lf = glob('results/jobs/loo_*.out'); L = cc_parse(lf, 'LOO'); drv = zeros(1, 429);
  for q = 1:rows(M)
    nm = lab{q}; m = strtok(nm, '_'); c = nm(end-1) - '0'; sg = M(q,2);
    dzs = []; px = []; zfull = M(q,1);
    for t = 1:numel(L), r = L(t).r; if strcmp(r.model, m) && strcmp(r.comp, sprintf('%dC', c)) && isfield(r, 'drop'), px(end+1) = r.drop; dzs(end+1) = r.zJ - zfull; end, end
    if isempty(dzs), printf('REPORT %-9s no LOO records\n', nm); continue; end
    mm = numel(dzs); zl = zfull + dzs; jk = sqrt((mm - 1) / mm * sum((zl - mean(zl)).^2));
    infl = px(abs(dzs) >= 0.5 * sg); [~, im] = max(abs(dzs)); drv(px(im)) += 1;
    printf('REPORT %-9s m=%d jackknifeSD=%.6f (%.2f sigma) max|dz|=%.3e at px %d (%.2f sigma) influential px: %s\n', nm, mm, jk, jk / sg, dzs(im), px(im), dzs(im) / sg, mat2str(infl));
  end
  [cnt, dpx] = max(drv); printf('REPORT driver: pixel %d has the largest |dz_i| in %d of %d model fits; full tally: %s\n', dpx, cnt, rows(M), mat2str([find(drv > 0); drv(drv > 0)]));
  % ---------------- F. synthetic
  printf('\nREPORT F. SYNTHETIC controls (generated from the P1/1C fit; NOT data)\n');
  nf = cc_parse(glob('results/jobs/syn_noisefree_*.out'), 'SYNTHETIC'); ed = cc_parse(glob('results/jobs/syn_edge_*.out'), 'SYNTHETIC');
  fam = {'P1','P2','P3','SPL','PLLIN'};
  for t = 1:numel(nf), r = nf(t).r; if isfield(r, 'kind') && strcmp(r.kind, 'noisefree'), printf('REPORT SYNTHETIC noisefree %-6s %s bias=%+.3e family=%d\n', r.model, r.comp, r.bias, any(strcmp(r.model, fam))); end, end
  for t = 1:numel(ed), r = ed(t).r; if isfield(r, 'kind') && strcmp(r.kind, 'edge'), printf('REPORT SYNTHETIC edge-deficit %-6s %s bias=%+.3e chi2=%.3f\n', r.model, r.comp, r.bias, r.chi2); end, end
end
function s = ifelse_(c, a, b), if c, s = a; else, s = b; end, end
function v = ifnan_(i, S), if isempty(i), v = NaN; else, v = S(i).r.zJ; end, end
