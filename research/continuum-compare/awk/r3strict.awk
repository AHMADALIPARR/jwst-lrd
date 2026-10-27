# SPDX-License-Identifier: AGPL-3.0-only
# r3strict.awk -- PREREG s6 range R3 computed strictly over the 7 scenarios D0..D4, ERRALL, ERREDGE (no BW8/BW6 sensitivity runs). Reads FIT lines.
/^FIT /{ for(i=1;i<=NF;i++){split($i,a,"="); v[a[1]]=a[2]}
  s=v["scen"]; if(v["BW"]==12 && (s ~ /^D[0-4]$/ || s ~ /^ERR/)){ z=v["zJ"]+0; l=v["model"] "_" v["comp"] "_" s; n++
    if(n==1||z<mn){mn=z; ml=l} if(n==1||z>mx){mx=z; xl=l} } }
END{ pub=7.0451
  printf "R3STRICT records=%d range=[%.6f (%s), %.6f (%s)] width=%.6f\n", n, mn, ml, mx, xl, mx-mn
  printf "R3STRICT published %.4f inside: %d ; distance to nearest edge=%.6f\n", pub, (pub>=mn && pub<=mx), (pub-mx<0?mx-pub:pub-mx) < (pub-mn<0?mn-pub:pub-mn) ? (pub-mx<0?mx-pub:pub-mx) : (pub-mn<0?mn-pub:pub-mn) }
