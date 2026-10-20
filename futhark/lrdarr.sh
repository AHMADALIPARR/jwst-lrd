# SPDX-License-Identifier: AGPL-3.0-only
# Also subject to the SnapKitty Opaque License; see LICENSE and
# SNAPKITTY_OPAQUE_LICENSE.md at the repository root.
#
# POSIX sh library: LRD-ARR-v1 <-> Futhark binary value format.
# Source it:  . futhark/lrdarr.sh
#
# LRD-ARR-v1 (research/CONTRACTS.md): <p>.f64 raw little-endian binary64,
# <p>.hdr lines key=value with format=LRD-ARR-v1, name, length, unit.
#
# Futhark binary value: 'b', version byte 2, rank byte, 4-byte type
# " f64", rank x i64 little-endian dims, then the raw data.  Compiled
# Futhark programs emit one '\n' after every value; we skip it.

lrd_die() { echo "lrdarr: $*" >&2; exit 2; }

# lrd_hdr_get PREFIX KEY  -> value on stdout (first match)
lrd_hdr_get() {
  sed -n "s/^$2=//p" "$1.hdr" | head -n 1
}

# lrd_check PREFIX  -> validates header and data size; prints length
lrd_check() {
  [ -f "$1.hdr" ] || lrd_die "missing $1.hdr"
  [ -f "$1.f64" ] || lrd_die "missing $1.f64"
  _fmt=$(lrd_hdr_get "$1" format)
  [ "$_fmt" = "LRD-ARR-v1" ] || lrd_die "$1.hdr: format is '$_fmt', want LRD-ARR-v1"
  _len=$(lrd_hdr_get "$1" length)
  case "$_len" in ''|*[!0-9]*) lrd_die "$1.hdr: bad length '$_len'";; esac
  [ -n "$(lrd_hdr_get "$1" name)" ] || lrd_die "$1.hdr: missing name"
  grep -q '^unit=' "$1.hdr" || lrd_die "$1.hdr: missing unit"
  _sz=$(wc -c < "$1.f64" | tr -d ' ')
  [ "$_sz" -eq $((_len * 8)) ] || lrd_die "$1: size $_sz != 8*length ($_len)"
  echo "$_len"
}

# lrd_require_unit PREFIX UNIT
lrd_require_unit() {
  _u=$(lrd_hdr_get "$1" unit)
  [ "$_u" = "$2" ] || lrd_die "$1: unit is '$_u', kernel requires '$2'"
}

# lrd_le64 N  -> 8 bytes little-endian of non-negative integer N
lrd_le64() {
  _n=$1; _i=0
  while [ $_i -lt 8 ]; do
    _b=$(( (_n >> (8 * _i)) & 255 ))
    printf "\\$(printf '%03o' "$_b")"
    _i=$((_i + 1))
  done
}

# lrd_to_fut PREFIX  -> Futhark binary rank-1 f64 array on stdout
lrd_to_fut() {
  _len=$(lrd_check "$1") || exit 2
  printf 'b\002\001 f64'
  lrd_le64 "$_len"
  cat "$1.f64"
}

# lrd_zeros_fut N -> Futhark binary rank-1 f64 array of N zeros
lrd_zeros_fut() {
  printf 'b\002\001 f64'
  lrd_le64 "$1"
  head -c $(($1 * 8)) /dev/zero
}

# lrd_write_hdr PREFIX LENGTH UNIT [extra key=value lines...]
lrd_write_hdr() {
  _p=$1; _l=$2; _u=$3; shift 3
  {
    echo "format=LRD-ARR-v1"
    echo "name=$(basename "$_p")"
    echo "length=$_l"
    echo "unit=$_u"
    for _kv in "$@"; do echo "$_kv"; done
  } > "$_p.hdr"
}

_lrd_u8() { od -An -tu1 -j "$2" -N 1 "$1" | tr -d ' \n'; }
_lrd_i64() { od -An -td8 -j "$2" -N 8 "$1" | tr -d ' \n'; }

# lrd_from_fut STREAMFILE OUTSPEC...
#   OUTSPEC = prefix:unit  ; consumes successive f64 values (rank 0 or 1)
#   from the Futhark binary output stream; a rank-0 scalar becomes a
#   length-1 LRD-ARR-v1 array.  Extra header lines from $LRD_EXTRA_HDR
#   (newline separated key=value) are appended to every header.
lrd_from_fut() {
  _f=$1; shift
  _total=$(wc -c < "$_f" | tr -d ' ')
  _off=0
  for _spec in "$@"; do
    _p=${_spec%%:*}; _unit=${_spec#*:}
    # skip whitespace between values
    while [ "$_off" -lt "$_total" ]; do
      _c=$(_lrd_u8 "$_f" "$_off")
      case "$_c" in 10|32|9|13) _off=$((_off + 1));; *) break;; esac
    done
    [ "$_off" -lt "$_total" ] || lrd_die "stream ended before value for $_p"
    [ "$(_lrd_u8 "$_f" "$_off")" = 98 ] || lrd_die "not a binary value at offset $_off"
    [ "$(_lrd_u8 "$_f" $((_off + 1)))" = 2 ] || lrd_die "unsupported binary version"
    _rank=$(_lrd_u8 "$_f" $((_off + 2)))
    _ty=$(od -An -c -j $((_off + 3)) -N 4 "$_f" | tr -d ' \n')
    [ "$_ty" = f64 ] || lrd_die "value for $_p has type '$_ty', want f64"
    _off=$((_off + 7))
    case "$_rank" in
      0) _len=1 ;;
      1) _len=$(_lrd_i64 "$_f" "$_off"); _off=$((_off + 8)) ;;
      *) lrd_die "rank $_rank not supported for $_p" ;;
    esac
    tail -c +$((_off + 1)) "$_f" | head -c $((_len * 8)) > "$_p.f64"
    _off=$((_off + _len * 8))
    if [ -n "${LRD_EXTRA_HDR:-}" ]; then
      # shellcheck disable=SC2086
      _old_ifs=$IFS; IFS='
'
      lrd_write_hdr "$_p" "$_len" "$_unit" $LRD_EXTRA_HDR
      IFS=$_old_ifs
    else
      lrd_write_hdr "$_p" "$_len" "$_unit"
    fi
    lrd_check "$_p" > /dev/null
  done
}
