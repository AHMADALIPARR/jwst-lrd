# SPDX-License-Identifier: AGPL-3.0-only
# continuum.awk -- iterative sigma-clipped running-median continuum (valid pixels only).
# in : idx wl_A flam eflam ok   (output of mask.awk, or a synthetic file with the same layout)
# out: -v OUT=file -> idx wl_A flam eflam ok cont clipped
#   HALF   : half-width in VALID pixels (window = 2*HALF+1, truncated at the ends of the valid list)  [default 12]
#   CLIP   : pixels with (flam-cont)/eflam > CLIP are excluded from the median (one-sided: emission) [default 3]
#   NITER  : max clipping iterations                                                                 [default 6]
# Edge windows are truncated (one-sided); every truncated window is counted and listed in the log.
BEGIN { OFS = "\t"; if (HALF == "") HALF = 12; if (CLIP == "") CLIP = 3; if (NITER == "") NITER = 6; nv = 0; n = 0 }
{ n++; I[n] = $1; W[n] = $2; F[n] = $3; E[n] = $4; OK[n] = $5
  if ($5 == 1) { nv++; V[nv] = n } }
END {
  for (j = 1; j <= nv; j++) CL[j] = 0
  for (it = 0; it <= NITER; it++) {
    for (j = 1; j <= nv; j++) {
      lo = j - HALF; if (lo < 1) lo = 1; hi = j + HALF; if (hi > nv) hi = nv
      m = 0
      for (k = lo; k <= hi; k++) if (!CL[k]) { m++; tmp[m] = F[V[k]] }
      if (m < 3) { m = 0; for (k = lo; k <= hi; k++) { m++; tmp[m] = F[V[k]] } }  # fallback if over-clipped
      C[j] = median(tmp, m); NW[j] = hi - lo + 1
    }
    changed = 0; ncl = 0
    for (j = 1; j <= nv; j++) {
      p = V[j]; c = ((F[p] - C[j]) / E[p] > CLIP) ? 1 : 0
      if (c != CL[j] && it < NITER) changed++
      if (it < NITER) CL[j] = c
      ncl += CL[j]
    }
    printf "CONT iter=%d clipped_pixels=%d changed=%d\n", it, ncl, changed
    if (changed == 0 && it > 0) break
    if (it == 0 && changed == 0) break
  }
  list = ""; for (j = 1; j <= nv; j++) if (CL[j]) list = list " " I[V[j]]
  printf "CONT final clipped pixel idx:%s\n", list
  trunc = 0; tl = ""
  for (j = 1; j <= nv; j++) if (NW[j] < 2 * HALF + 1) { trunc++ }
  printf "CONT params HALF=%d (window %d valid px) CLIP=%g NITER=%d; valid=%d; truncated_edge_windows=%d\n", HALF, 2*HALF+1, CLIP, NITER, nv, trunc
  last = V[nv]; printf "CONT last valid pixel idx=%d wl_A=%.3f window_px=%d cont=%.6g flam=%.6g\n", I[last], W[last], NW[nv], C[nv], F[last]
  jj = 0
  for (p = 1; p <= n; p++) {
    if (OK[p] == 1) { jj++; printf "%d\t%s\t%s\t%s\t1\t%.10g\t%d\n", I[p], W[p], F[p], E[p], C[jj], CL[jj] > OUT }
    else printf "%d\t%s\t%s\t%s\t0\t0\t0\n", I[p], W[p], F[p], E[p] > OUT
  }
}
