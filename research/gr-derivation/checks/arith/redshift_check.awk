# SPDX-License-Identifier: AGPL-3.0-only
# mawk/awk double-precision redshift arithmetic; compares to reference values computed with bc (scale 20, redshift_table.bc).
# Inputs are ASSUMPTIONS, not measurements.
function sq(x) { return sqrt(x) }
function zg(rho) { return 1/sq(1-1/rho) - 1 }
function chk(name, got, want, tol,   ok) {
  ok = (got - want <= tol*want && want - got <= tol*want)
  n++; if (ok) p++
  printf("   %-46s got=%.12g want=%.12g %s\n", name, got, want, ok ? "ok" : "MISMATCH")
}
BEGIN {
  c = 299792.458; gmsun = 1.32712440018e20; cm = 299792458
  rssun = 2*gmsun/(cm*cm)
  chk("rs(1 Msun) [m]", rssun, 2953.25007650080347943526, 1e-12)
  chk("z_exact(rho=1e3)", zg(1e3), 0.00050037531277368382, 1e-9)
  chk("c z_exact(1e3) [km/s]", c*zg(1e3), 150.00874493894147, 1e-9)
  chk("c z_exact(1e4) [km/s]", c*zg(1e4), 14.99074721541084, 1e-9)
  chk("c z_exact(1e5) [km/s]", c*zg(1e5), 1.498973532310863, 1e-9)
  chk("rs/c for 1e7 Msun [s]", rssun*1e7/cm, 98.50981896618638, 1e-9)
  chk("rs/c for 1e8 Msun [s]", rssun*1e8/cm, 985.0981896618638, 1e-9)
  chk("r=1e3 rs, M=1e7 [light-days]", 1e3*rssun*1e7/cm/86400, 1.1401599417382683, 1e-9)
  chk("r=1e5 rs, M=1e8 [light-days]", 1e5*rssun*1e8/cm/86400, 1140.1599417382683, 1e-9)
  zc = 7.04221; zo = 7.0451
  zgc = (1+zo)/(1+zc) - 1
  chk("z_grav(cond)", zgc, 0.00035935395867553819, 1e-9)
  chk("c z_grav(cond) [km/s]", c*zgc, 107.73160656337002, 1e-9)
  chk("rho_weak = 1/(2z)", 1/(2*zgc), 1391.385813148789, 1e-9)
  chk("rho_exact", 1/(1-1/((1+zgc)^2)), 1392.135858059964, 1e-9)
  if (p == n) printf("PASS  awk-01 double-precision redshift arithmetic vs bc reference values : %d/%d\n", p, n)
  else printf("FAIL  awk-01 double-precision redshift arithmetic vs bc reference values : %d/%d\n", p, n)
}
