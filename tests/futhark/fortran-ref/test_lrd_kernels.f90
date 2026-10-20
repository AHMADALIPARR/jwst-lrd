! SPDX-License-Identifier: AGPL-3.0-only
! Also subject to the SnapKitty Opaque License; see LICENSE and
! SNAPKITTY_OPAQUE_LICENSE.md at the repository root.
!
! Analytic unit tests for the Fortran reference kernels.  Prints one line
! per test: PASS <name> | FAIL <name> <why>.  Exit status 1 on any FAIL.
! Tolerances match tests/futhark/unit.fut.
program test_lrd_kernels
  use, intrinsic :: iso_fortran_env, only: real64
  use, intrinsic :: ieee_arithmetic, only: ieee_is_nan
  use lrd_kernels
  implicit none
  integer, parameter :: dp = real64
  real(dp), parameter :: pi = acos(-1.0_dp)
  integer :: nfail = 0, i
  real(dp), allocatable :: x(:), y(:), s(:), d(:), f(:), fn(:), sn(:), f2(:), s2(:), zr(:)
  real(dp) :: e, cs(3), ws(3), am(3), zg(401), chis(401), best(2), p(4), c2(3), p3(3)
  real(dp), parameter :: zs(4) = [0.0_dp, 0.5_dp, 6.123_dp, 12.0_dp]
  real(dp) :: n5, lw(1), fw(1), sw(1), o1(1), o2(1), sf

  ! Gaussian integral (trapezoid, +-33 sigma, step sigma/300): A sigma sqrt(2 pi)
  x = linspace(20001, 4900.0_dp, 5100.0_dp)
  y = gauss_model(2.5_dp, 5000.0_dp, 3.0_dp, 0.0_dp, x)
  call check('gauss_integral', relerr(trapz(x, y), 2.5_dp * 3.0_dp * sqrt(2.0_dp * pi)), 1.0e-10_dp)

  ! chi2 of exact model = 0, residuals = 0
  x = linspace(1000, 40000.0_dp, 50000.0_dp)
  y = gauss_model(3.0_dp, 45000.0_dp, 20.0_dp, 1.0_dp, x)
  s = 0.1_dp + 0.001_dp * x
  call check('chi2_exact_model', chi2(y, y, s) + maxval(abs(residuals(y, y))), 0.0_dp)

  ! data = model + 2 sigma -> chi2 = 4n
  s = 0.25_dp + 1.0e-5_dp * x
  d = y + 2.0_dp * s
  call check('chi2_known', max(relerr(chi2(d, y, s), 4000.0_dp), &
       maxval(abs(residuals(d, y) - 2.0_dp * s) / (2.0_dp * s))), 1.0e-12_dp)

  ! masking
  call check('chi2_mask', abs(chi2([1.0_dp, 5.0_dp, nan(), 3.0_dp], [0.0_dp, 0.0_dp, 0.0_dp, 1.0_dp], &
       [1.0_dp, 0.0_dp, 1.0_dp, 2.0_dp]) - 2.0_dp), 0.0_dp)

  ! rest-frame exact inverse
  x = linspace(5000, 6000.0_dp, 53000.0_dp)
  e = 0.0_dp
  do i = 1, 4
    e = max(e, maxval(abs(obs_frame(zs(i), rest_frame(zs(i), x)) - x) / x))
  end do
  call check('rest_inverse', e, 1.0e-15_dp)

  ! micron / Angstrom
  x = linspace(10000, 0.6_dp, 5.3_dp)
  call check('um_angstrom', maxval(abs(angstrom_to_um(um_to_angstrom(x)) - x) / x), 1.0e-15_dp)

  ! vacuum/air round trip 2001..100000 A
  x = linspace(98000, 2001.0_dp, 100000.0_dp)
  call check('vac_air_roundtrip', max(maxval(abs(air2vac(vac2air(x)) - x) / x), &
       maxval(abs(vac2air(air2vac(x)) - x) / x)), 1.0e-9_dp)
  call check('vac_air_passthrough', maxval(abs(vac2air([900.0_dp, 1999.999_dp]) - [900.0_dp, 1999.999_dp])), 0.0_dp)
  n5 = 1.0_dp + 0.0000834254_dp + 0.02406147_dp / 126.0_dp + 0.00015998_dp / 34.9_dp
  call check('vac_air_formula', relerr(vac2air(5000.0_dp), 5000.0_dp / n5), 1.0e-15_dp)

  ! f_lambda <-> f_nu
  x = linspace(2000, 6000.0_dp, 53000.0_dp)
  f = 1.0e-18_dp * (1.0_dp + sin(x / 1000.0_dp) * 0.5_dp)
  s = 0.05_dp * f
  allocate (zr(2000)); zr = 0.0_dp
  allocate (fn(2000), sn(2000), f2(2000), s2(2000))
  call flam_to_fnu(x, zr, f, s, fn, sn)
  call fnu_to_flam(x, zr, fn, sn, f2, s2)
  call check('fnu_flam_roundtrip', max(maxval(abs(f2 - f) / f), maxval(abs(s2 - s) / s)), 1.0e-14_dp)
  lw = 1.0e4_dp; fw = 1.0_dp; sw = 0.1_dp
  call flam_to_fnu(lw, [0.0_dp], fw, sw, o1, o2)
  call check('fnu_known', max(relerr(o1(1), 1.0e8_dp / 2.99792458e18_dp), &
       relerr(o2(1), 0.1_dp * 1.0e8_dp / 2.99792458e18_dp)), 1.0e-15_dp)
  sf = 2.0_dp * 4.0e-19_dp * 2.0_dp / 20000.0_dp
  call flam_to_fnu([20000.0_dp], [2.0_dp], [4.0e-19_dp], [sf], o1, o2)
  call check('fnu_combined_error', relerr(o2(1), sqrt(2.0_dp) * sf * 20000.0_dp**2 / 2.99792458e18_dp), 1.0e-15_dp)

  ! noiseless grid search, z on the grid (index 225 -> z = 6.25)
  cs = [6564.61_dp, 4862.68_dp, 5008.24_dp]; ws = 2.5_dp; am = [3.0_dp, 1.0_dp, 2.0_dp]
  zg = linspace(401, 4.0_dp, 8.0_dp)
  x = linspace(4000, 25000.0_dp, 53000.0_dp)
  y = 0.4_dp + sum_lines(x, cs, ws, am, zg(226))
  s = [(1.0_dp, i = 1, 4000)]
  call zgrid_search(x, y, s, cs, ws, .true., zg, chis, best, p)
  e = maxval(abs(p - [am, 0.4_dp]) / [am, 0.4_dp])
  if (best(1) == zg(226) .and. best(2) == 225.0_dp .and. chis(226) <= 1.0e-16_dp) then
    call check('zgrid_noiseless', e, 1.0e-9_dp)
  else
    call check('zgrid_noiseless', huge(1.0_dp), 1.0e-9_dp)
  end if

  ! degenerate column (Ly-alpha far outside coverage), no continuum
  x = linspace(2000, 40000.0_dp, 50000.0_dp)
  y = sum_lines(x, cs(1:1), [3.0_dp], [5.0_dp], 6.0_dp)
  s = [(0.1_dp, i = 1, 2000)]
  call zgrid_search(x, y, s, [6564.61_dp, 1215.67_dp], [3.0_dp, 3.0_dp], .false., &
       [5.9_dp, 6.0_dp, 6.1_dp], c2, best, p3)
  if (.not. any(ieee_is_nan(c2)) .and. .not. any(ieee_is_nan(p3)) .and. best(1) == 6.0_dp &
       .and. p3(2) == 0.0_dp .and. p3(3) == 0.0_dp) then
    call check('zgrid_degenerate', relerr(p3(1), 5.0_dp), 1.0e-9_dp)
  else
    call check('zgrid_degenerate', huge(1.0_dp), 1.0e-9_dp)
  end if

  if (nfail > 0) stop 1

contains
  subroutine check(name, metric, tol)
    character(*), intent(in) :: name
    real(dp), intent(in) :: metric, tol
    if (metric <= tol) then
      write (*, '(a)') 'PASS fortran-ref-unit-' // name
    else
      write (*, '(a,es12.4,a,es12.4)') 'FAIL fortran-ref-unit-' // name // ' metric=', metric, ' tol=', tol
      nfail = nfail + 1
    end if
  end subroutine check

  pure real(dp) function relerr(a, b)
    real(dp), intent(in) :: a, b
    relerr = abs(a - b) / abs(b)
  end function relerr

  real(dp) function nan()
    use, intrinsic :: ieee_arithmetic, only: ieee_value, ieee_quiet_nan
    nan = ieee_value(1.0_dp, ieee_quiet_nan)
  end function nan

  pure function linspace(n, a, b) result(v)
    integer, intent(in) :: n
    real(dp), intent(in) :: a, b
    real(dp) :: v(n)
    integer :: j
    do j = 1, n
      v(j) = a + (b - a) * real(j - 1, dp) / real(n - 1, dp)
    end do
  end function linspace

  pure real(dp) function trapz(xx, yy)
    real(dp), intent(in) :: xx(:), yy(:)
    integer :: j
    trapz = 0.0_dp
    do j = 1, size(xx) - 1
      trapz = trapz + 0.5_dp * (xx(j+1) - xx(j)) * (yy(j+1) + yy(j))
    end do
  end function trapz

  pure function sum_lines(xx, c, w, a, z) result(v)
    real(dp), intent(in) :: xx(:), c(:), w(:), a(:), z
    real(dp) :: v(size(xx))
    integer :: j
    v = 0.0_dp
    do j = 1, size(c)
      v = v + gauss_model(a(j), c(j) * (1.0_dp + z), w(j) * (1.0_dp + z), 0.0_dp, xx)
    end do
  end function sum_lines
end program test_lrd_kernels
