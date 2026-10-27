# SPDX-License-Identifier: AGPL-3.0-only
# mask.awk -- explicit, logged masking + unit conversion.   run: awk -f common.awk -f mask.awk ...
# in : work/spectrum.tsv  (idx wl_um flux_Jy err_Jy)
# out: -v OUT=file  -> idx wl_A flam eflam ok     (flam in 1e-20 erg s^-1 cm^-2 A^-1; ok=1 valid, 0 masked)
#      -v MASKLOG=file -> one line per masked pixel: idx wl_um reason
# Mask rule (all explicit): masked iff wl non-finite, flux non-finite, err non-finite, or err <= 0.
# Negative flux is NOT masked (it is noise); it is counted and reported.
# F_lambda = F_nu * 1e-23 * c / lambda^2, c = 2.99792458e18 A/s (exact), lambda in A.
BEGIN { OFS = "\t"; C = 2.99792458e18; nmask = 0; nok = 0; nneg = 0
        nwl = 0; nfx = 0; nfe = 0; nle = 0; printf "" > MASKLOG }
{
  idx = $1; wl = $2; fx = $3; fe = $4; reason = ""
  if (!isfin(wl)) { reason = reason "wl_nonfinite;"; nwl++ }
  if (!isfin(fx)) { reason = reason "flux_nonfinite;"; nfx++ }
  if (!isfin(fe)) { reason = reason "err_nonfinite;"; nfe++ }
  else if (fe + 0 <= 0) { reason = reason "err_nonpositive;"; nle++ }
  n++
  if (reason != "") {
    nmask++; print idx, wl, reason >> MASKLOG
    if (isfin(wl)) printf "%d\t%.6f\t0\t0\t0\n", idx, wl * 1e4 > OUT; else printf "%d\t0\t0\t0\t0\n", idx > OUT
    next
  }
  nok++
  if (fx + 0 < 0) nneg++
  lam = wl * 1e4
  printf "%d\t%.6f\t%.10g\t%.10g\t1\n", idx, lam, fx * 1e-23 * C / (lam * lam) * 1e20, fe * 1e-23 * C / (lam * lam) * 1e20 > OUT
}
END {
  printf "MASK pixels_total=%d valid=%d masked=%d\n", n, nok, nmask
  printf "MASK reason_counts: wl_nonfinite=%d flux_nonfinite=%d err_nonfinite=%d err_nonpositive=%d (a pixel may carry >1 reason)\n", nwl, nfx, nfe, nle
  printf "MASK valid_pixels_with_negative_flux_kept=%d (not masked; noise)\n", nneg
  printf "MASK log written: %s\n", MASKLOG
}
