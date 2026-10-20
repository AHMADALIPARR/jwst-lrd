! Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
! Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
! SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
!
! causal_hexfloat: exact, canonical text form of IEEE-754 binary64 values.
! (gfortran 14 does not implement the Fortran 2018 EX edit descriptor, so the form is
! produced from the bit pattern.)  Canonical grammar, always 13 lowercase hex digits:
!   normal     [-]0x1.hhhhhhhhhhhhhp(+|-)E     value = (1 + h/2^52) * 2^E, E in -1022..1023
!   subnormal  [-]0x0.hhhhhhhhhhhhhp-1022      value = (h/2^52) * 2^-1022, h /= 0
!   zero       [-]0x0.0000000000000p+0
!   inf / -inf / nan
! E is written without leading zeros.  parse_hexfloat accepts exactly this grammar,
! so format -> parse -> format is the identity on bit patterns (NaN payloads excepted).
module causal_hexfloat
  use, intrinsic :: iso_fortran_env, only: int64, real64
  implicit none
  private
  public :: fmt_hexfloat, parse_hexfloat

  character(len=16), parameter :: HEXD = '0123456789abcdef'

contains

  pure function fmt_hexfloat(x) result(s)
    real(real64), intent(in) :: x
    character(len=:), allocatable :: s
    integer(int64) :: bits, m
    integer :: e, i
    character(len=13) :: mh
    character(len=8) :: eb
    character(len=1) :: sg
    bits = transfer(x, bits)
    sg = ''
    if (btest(bits, 63)) sg = '-'
    e = int(ibits(bits, 52, 11))
    m = ibits(bits, 0, 52)
    if (e == 2047) then
      if (m == 0) then
        s = trim(sg) // 'inf'
      else
        s = 'nan'
      end if
      return
    end if
    do i = 1, 13
      mh(i:i) = HEXD(int(ibits(m, 4 * (13 - i), 4)) + 1:int(ibits(m, 4 * (13 - i), 4)) + 1)
    end do
    if (e == 0) then
      if (m == 0) then
        s = trim(sg) // '0x0.' // mh // 'p+0'
      else
        s = trim(sg) // '0x0.' // mh // 'p-1022'
      end if
    else
      write (eb, '(SP,I0)') e - 1023
      s = trim(sg) // '0x1.' // mh // 'p' // trim(eb)
    end if
  end function fmt_hexfloat

  pure subroutine parse_hexfloat(s, x, ok)
    character(len=*), intent(in) :: s
    real(real64), intent(out) :: x
    logical, intent(out) :: ok
    integer(int64) :: bits, m
    integer :: p, i, d, e, esign, lead
    logical :: neg
    x = 0.0_real64
    ok = .false.
    bits = 0_int64
    p = 1
    neg = .false.
    if (len(s) >= 1) then
      if (s(1:1) == '-') then
        neg = .true.
        p = 2
      end if
    end if
    if (s(p:) == 'inf') then
      bits = shiftl(2047_int64, 52)
      if (neg) bits = ibset(bits, 63)
      x = transfer(bits, x)
      ok = .true.
      return
    end if
    if (s == 'nan') then
      bits = ior(shiftl(2047_int64, 52), shiftl(1_int64, 51))
      x = transfer(bits, x)
      ok = .true.
      return
    end if
    if (len(s) < p + 19) return
    if (s(p:p + 1) /= '0x') return
    if (s(p + 2:p + 2) == '1') then
      lead = 1
    else if (s(p + 2:p + 2) == '0') then
      lead = 0
    else
      return
    end if
    if (s(p + 3:p + 3) /= '.') return
    m = 0
    do i = p + 4, p + 16
      d = index(HEXD, s(i:i)) - 1
      if (d < 0) return
      m = ior(shiftl(m, 4), int(d, int64))
    end do
    if (s(p + 17:p + 17) /= 'p') return
    if (s(p + 18:p + 18) == '+') then
      esign = 1
    else if (s(p + 18:p + 18) == '-') then
      esign = -1
    else
      return
    end if
    if (len(s) < p + 19 .or. len(s) > p + 22) return
    e = 0
    do i = p + 19, len(s)
      d = index('0123456789', s(i:i)) - 1
      if (d < 0) return
      if (i == p + 19 .and. d == 0 .and. len(s) > p + 19) return   ! leading zero
      e = 10 * e + d
    end do
    e = esign * e
    if (lead == 1) then
      if (e < -1022 .or. e > 1023) return
      bits = ior(shiftl(int(e + 1023, int64), 52), m)
    else
      if (m == 0) then
        if (s(p + 18:) /= '+0') return
      else
        if (e /= -1022) return
      end if
      bits = m
    end if
    if (neg) bits = ibset(bits, 63)
    x = transfer(bits, x)
    ok = .true.
  end subroutine parse_hexfloat

end module causal_hexfloat
