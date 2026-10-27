# SPDX-License-Identifier: AGPL-3.0-only
# export.awk -- join the logged mask output (idx wl_A flam eflam ok) with the native-unit flux_error (Jy) so the
# Octave engine has ONE purely numeric input file: idx wl_A flam eflam ok errJy.  usage: awk -f export.awk spectrum.tsv masked0.tsv
BEGIN { OFS = "\t"; FS = "\t" }
FNR == NR { ejy[$1] = $4; next }
{ e = ($5 == 1) ? ejy[$1] : 0; print $1, $2, $3, $4, $5, e }
