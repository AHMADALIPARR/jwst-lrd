% SPDX-License-Identifier: AGPL-3.0-only
% cc_const.m -- pre-registered constants (PREREG.md sections 0-3). GNU Octave (not MATLAB).
function K = cc_const()
  K.sha = 'c0b878576d7d7ec723c5ee526d29715fb672d81e45bc8ba4e02598ce8b9c5ee7';
  K.Rhb = 4862.691;  K.Rha = 6564.632;       % NIST ASD v5.12 Ritz VACUUM (Angstrom), = fortran/src/lrd_lines.f90
  K.zref = 7.0422;                           % only used to pick the window-centre pixel
  K.lsfpx = 2.2;  K.fw2s = 2.3548200450309493;  K.ckms = 299792.458;
  K.zg = (7.020:1e-5:7.065)';                % z grid
  K.sg1 = 0:100:4000;                        % single-Gaussian sigma_int grid (km/s)
  K.sgn = 0:100:600;  K.sgb = 900:100:3000;  % narrow / broad grids (2C)
  K.beta = -10:0.1:10;                       % power-law index grid
  K.rmH = [6 12 20];
  K.bwhb = [12 6];                           % Hbeta window: centre-12 .. centre+6
  K.zpub = 7.0451; K.zfort = 7.04221; K.zfort_err = 0.00027;
  K.errthr = 1.5; K.errref = [380 404];
end
