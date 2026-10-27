# SPDX-License-Identifier: AGPL-3.0-only
# restwl_report.awk -- print the three rest-wavelength sets and the air->vacuum conversion check.  run with -f common.awk
BEGIN {
  printf "REST set A = values exactly as given in the task: Hbeta 4861.35, [OIII] 4958.9 / 5006.8, Halpha 6562.8 (the task calls them vacuum)\n"
  printf "REST NOTE: these are the conventional AIR wavelengths (standard air, e.g. Halpha 6562.8, Hbeta 4861.3, [OIII] 4958.9/5006.8). JWST x1d wavelengths are vacuum.\n"
  printf "REST set B = NIST ASD v5.12 Ritz vacuum wavelengths used by the Fortran kernel (fortran/src/lrd_lines.f90 line_vac_ang; raw queries in fortran/data/nist/*.csv)\n"
  printf "REST set C = set A converted air->vacuum here with Edlen(1966)/Morton(1991, ApJS 77, 119) refractivity, air2vac() in common.awk\n"
  printf "%-10s %12s %12s %14s %14s %14s\n", "line", "A(air,given)", "B(NIST vac)", "C=air2vac(A)", "B-C [A]", "(1+z)ratio B/A"
  for (L = 1; L <= 4; L++) printf "%-10s %12.4f %12.4f %14.4f %14.4f %14.8f\n", linename(L), restwl("A", L), restwl("B", L), restwl("C", L), restwl("B", L) - restwl("C", L), restwl("B", L) / restwl("A", L)
  printf "REST consequence: for a fixed observed line, z_A - z_B = (1+z)*(R_B/R_A - 1) (smaller rest wavelength => larger z); R_B/R_A-1 at Halpha = %.3e => z_A is higher than z_B by about %.5f at (1+z)=8.04\n", restwl("B", 4) / restwl("A", 4) - 1, 8.04 * (restwl("B", 4) / restwl("A", 4) - 1)
}
