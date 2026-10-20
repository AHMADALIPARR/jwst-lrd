! SPDX-License-Identifier: AGPL-3.0-only
! Also subject to the SnapKitty Opaque License; see LICENSE and
! SNAPKITTY_OPAQUE_LICENSE.md at the repository root.
!
! lrdref: Fortran reference CLI with the same kernel names and argument
! order as futhark/lrd-fut (see futhark/ABI.md).
program lrdref
  use, intrinsic :: iso_fortran_env, only: real64
  use lrd_kernels
  use lrd_io
  implicit none
  integer, parameter :: dp = real64
  character(:), allocatable :: k
  real(dp), allocatable :: a(:), b(:), c(:), d(:), e(:), o1(:), o2(:), zg(:), chis(:), params(:)
  character(:), allocatable :: ua, ub, uc, ud, ue, uz
  real(dp) :: z, amp, cen, sig, cont, best(2)
  integer :: n

  if (command_argument_count() < 1) call die('usage: lrdref KERNEL ARGS...')
  k = arg(1)
  select case (k)
  case ('vac2air', 'air2vac', 'a2um', 'um2a')
    call nargs(3)
    call read_lrd(arg(2), a, ua)
    select case (k)
    case ('vac2air'); call need(ua, 'Angstrom'); call write_lrd(arg(3), vac2air(a), 'Angstrom')
    case ('air2vac'); call need(ua, 'Angstrom'); call write_lrd(arg(3), air2vac(a), 'Angstrom')
    case ('a2um');    call need(ua, 'Angstrom'); call write_lrd(arg(3), angstrom_to_um(a), 'um')
    case ('um2a');    call need(ua, 'um');       call write_lrd(arg(3), um_to_angstrom(a), 'Angstrom')
    end select
  case ('rest', 'obs')
    call nargs(4)
    z = num(arg(2))
    call read_lrd(arg(3), a, ua)
    if (k == 'rest') then
      call write_lrd(arg(4), rest_frame(z, a), ua)
    else
      call write_lrd(arg(4), obs_frame(z, a), ua)
    end if
  case ('flam2fnu', 'fnu2flam')
    call nargs(6)
    call read_lrd(arg(2), a, ua); call need(ua, 'Angstrom')
    n = size(a)
    if (arg(3) == '-') then
      allocate (b(n)); b = 0.0_dp
    else
      call read_lrd(arg(3), b, ub); call need(ub, 'Angstrom')
    end if
    call read_lrd(arg(4), c, uc)
    call read_lrd(arg(5), d, ud)
    if (size(b) /= n .or. size(c) /= n .or. size(d) /= n) call die('length mismatch')
    allocate (o1(n), o2(n))
    if (k == 'flam2fnu') then
      call flam_to_fnu(a, b, c, d, o1, o2)
      call write_lrd(arg(6), o1, 'erg/s/cm2/Hz'); call write_lrd(arg(6) // '_sigma', o2, 'erg/s/cm2/Hz')
    else
      call fnu_to_flam(a, b, c, d, o1, o2)
      call write_lrd(arg(6), o1, 'erg/s/cm2/A'); call write_lrd(arg(6) // '_sigma', o2, 'erg/s/cm2/A')
    end if
  case ('resid')
    call nargs(4)
    call read_lrd(arg(2), a, ua); call read_lrd(arg(3), b, ub)
    if (size(a) /= size(b)) call die('length mismatch')
    call write_lrd(arg(4), residuals(a, b), ua)
  case ('chi2')
    call nargs(5)
    call read_lrd(arg(2), a, ua); call read_lrd(arg(3), b, ub); call read_lrd(arg(4), c, uc)
    if (size(a) /= size(b) .or. size(a) /= size(c)) call die('length mismatch')
    call write_lrd(arg(5), [chi2(a, b, c)], '1')
  case ('gauss')
    call nargs(7)
    amp = num(arg(2)); cen = num(arg(3)); sig = num(arg(4)); cont = num(arg(5))
    call read_lrd(arg(6), a, ua)
    call write_lrd(arg(7), gauss_model(amp, cen, sig, cont, a), 'arbitrary')
  case ('zgrid')
    call nargs(9)
    call read_lrd(arg(2), a, ua); call read_lrd(arg(3), b, ub); call read_lrd(arg(4), c, uc)
    call read_lrd(arg(5), d, ud); call read_lrd(arg(6), e, ue); call read_lrd(arg(8), zg, uz)
    if (size(a) /= size(b) .or. size(a) /= size(c) .or. size(d) /= size(e)) call die('length mismatch')
    if (arg(7) /= '0' .and. arg(7) /= '1') call die('FITCONT must be 0 or 1')
    allocate (chis(size(zg)), params(size(d) + 1))
    call zgrid_search(a, b, c, d, e, arg(7) == '1', zg, chis, best, params)
    call write_lrd(arg(9) // '_chi2', chis, '1')
    call write_lrd(arg(9) // '_best', best, '1')
    call write_lrd(arg(9) // '_params', params, ub)
  case default
    call die('unknown kernel ' // k)
  end select

contains
  function arg(i) result(s)
    integer, intent(in) :: i
    character(:), allocatable :: s
    integer :: l
    call get_command_argument(i, length=l)
    allocate (character(l) :: s)
    call get_command_argument(i, s)
  end function arg

  subroutine nargs(m)
    integer, intent(in) :: m
    if (command_argument_count() /= m) call die('wrong number of arguments for ' // k)
  end subroutine nargs

  subroutine need(u, want)
    character(*), intent(in) :: u, want
    if (u /= want) call die('unit is ' // u // ', kernel requires ' // want)
  end subroutine need

  real(dp) function num(s)
    character(*), intent(in) :: s
    integer :: ios
    read (s, *, iostat=ios) num
    if (ios /= 0) call die('bad number ' // s)
  end function num
end program lrdref
