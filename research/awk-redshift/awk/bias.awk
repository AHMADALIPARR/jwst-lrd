# SPDX-License-Identifier: AGPL-3.0-only
# bias.awk -- from CEN/CENJ lines of a SYNTHETIC centroid scan print z_fixed - ZTRUE per window (parsed, not typed).
function kv(s, key,   m, a, i, p) { m = split(s, a, " "); for (i = 1; i <= m; i++) { p = index(a[i], "="); if (p > 0 && substr(a[i], 1, p - 1) == key) return substr(a[i], p + 1) } return "" }
/^CEN / { z = kv($0, "z_fixed"); w = kv($0, "W_obsA"); l = kv($0, "line"); if (z == "NA" || z == "") printf "BIAS SYNTHETIC line=%s W_obsA=%s z_fixed=NA\n", l, w
  else { printf "BIAS SYNTHETIC line=%s W_obsA=%s z_fixed=%.6f bias_vs_ztrue=%+.6f\n", l, w, z, z - ZTRUE; s[l] += 0; if (!(l in mn) || z - ZTRUE < mn[l]) mn[l] = z - ZTRUE; if (!(l in mx) || z - ZTRUE > mx[l]) mx[l] = z - ZTRUE; nn[l]++ } }
END { for (l in mn) printf "BIASSUM SYNTHETIC line=%s n_windows=%d bias_min=%+.6f bias_max=%+.6f bias_range=%.6f (ztrue=%s)\n", l, nn[l], mn[l], mx[l], mx[l] - mn[l], ZTRUE }
