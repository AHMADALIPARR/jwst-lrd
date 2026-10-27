# SPDX-License-Identifier: AGPL-3.0-only
# compare.awk -- summarise tagged MF/MFJ/BOOT lines (from the run log) against the Fortran value and the published value.
# run: awk -f compare.awk -v PXHA=<pixel width at Halpha, A> run.log   (all numbers are parsed from the log; none typed here)
#   ZF, ZFE = Fortran 7.04221 +- 0.00027 (fortran/STATUS.md);  ZP, ZPE = published 7.0451 +- 0.0005 (Furtak+2024)
function kv(s, key,   m, a, i, p) { m = split(s, a, " "); for (i = 1; i <= m; i++) { p = index(a[i], "="); if (p > 0 && substr(a[i], 1, p - 1) == key) return substr(a[i], p + 1) } return "" }
function dv(dz, z) { return 299792.458 * dz / (1 + z) }
BEGIN { if (ZF == "") ZF = 7.04221; if (ZFE == "") ZFE = 0.00027; if (ZP == "") ZP = 7.0451; if (ZPE == "") ZPE = 0.0005
  printf "%-26s %-9s %-6s %-12s %-10s %-10s | %-9s %-9s | %-10s %-9s %-8s %-7s\n", "run(tag)", "joint/line", "est", "z", "dz1_hw", "scaled_hw", "z-ZF[e-5]", "z-ZP[e-5]", "z-ZP[km/s]", "z-ZP[A@Ha]", "[px]", "sigmas" }
/^MFJ / && /joint=HbHa/ {
  z = kv($0, "fine_z"); hw = kv($0, "dz1_halfwidth"); sh = kv($0, "scaled_halfwidth")
  sg = (sh != "NA" && sh + 0 > 0) ? sprintf("%.1f", (ZP - z) / sqrt(sh * sh + ZPE * ZPE)) : "NA"
  printf "%-26s %-9s %-6s %-12s %-10s %-10s | %+9.1f %+9.1f | %+10.1f %+9.2f %+8.3f %-7s\n", kv($0, "tag"), "joint-HbHa", kv($0, "est"), z, hw, sh, (z - ZF) * 1e5, (z - ZP) * 1e5, dv(z - ZP, z), (z - ZP) * 6564.632, (z - ZP) * 6564.632 / PXHA, sg
}
/^MF / && /line=Halpha/ && /fine_z=/ {
  z = kv($0, "fine_z"); hw = kv($0, "dz1_halfwidth"); sh = kv($0, "scaled_halfwidth")
  printf "%-26s %-9s %-6s %-12s %-10s %-10s | %+9.1f %+9.1f | %+10.1f %+9.2f %+8.3f\n", kv($0, "tag"), "Halpha", kv($0, "est"), z, hw, sh, (z - ZF) * 1e5, (z - ZP) * 1e5, dv(z - ZP, z), (z - ZP) * 6564.632, (z - ZP) * 6564.632 / PXHA
}
/^MF / && /line=Hbeta/ && /fine_z=/ {
  z = kv($0, "fine_z"); hw = kv($0, "dz1_halfwidth"); sh = kv($0, "scaled_halfwidth")
  printf "%-26s %-9s %-6s %-12s %-10s %-10s | %+9.1f %+9.1f | %+10.1f\n", kv($0, "tag"), "Hbeta", kv($0, "est"), z, hw, sh, (z - ZF) * 1e5, (z - ZP) * 1e5, dv(z - ZP, z)
}
