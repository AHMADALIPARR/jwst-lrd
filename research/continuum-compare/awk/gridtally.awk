# SPDX-License-Identifier: AGPL-3.0-only
# gridtally.awk -- count FIT records whose sigma_int grid values sit on a grid boundary (reads FIT lines; mawk).
# grids (octave/cc_const.m): 1C sigma 0:100:4000; 2C narrow 0:100:600; 2C broad 900:100:3000.
/^FIT /{ for(i=1;i<=NF;i++){split($i,a,"="); v[a[1]]=a[2]}
  n++; c=v["comp"]
  if(c=="2C"){ n2++; if(v["sigHaB"]==900)bl++; if(v["sigHaB"]==3000)bh++; if(v["sigHa"]==600)nh++; if(v["sigHa"]==0)nl++ }
  else { if(v["sigHa"]==0)l1++; if(v["sigHa"]==4000)h1++ }
  if(v["sigHb"]==0)hl++; if(v["sigHb"]==4000)hh++ }
END{ printf "GRIDTALLY FIT records=%d (2C=%d)\n", n, n2
  printf "GRIDTALLY 2C broad sigma at lower bound 900: %d ; at upper bound 3000: %d (of %d)\n", bl, bh, n2
  printf "GRIDTALLY 2C narrow sigma at lower bound 0: %d ; at upper bound 600: %d (of %d)\n", nl, nh, n2
  printf "GRIDTALLY 1C Halpha sigma at 0: %d ; at 4000: %d ; Hbeta at 0: %d ; at 4000: %d\n", l1, h1, hl, hh }
