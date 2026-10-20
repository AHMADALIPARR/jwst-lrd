! SPDX-License-Identifier: AGPL-3.0-only
! Also subject to the SnapKitty Opaque License; see LICENSE and
! SNAPKITTY_OPAQUE_LICENSE.md at the repository root.
!
! Fortran 2018 reference implementation of the JWST-LRD Futhark kernels
! (futhark/lrd.fut).  Same formulas, units, masking and degenerate-column
! rules; used only for differential testing of the Futhark code.
module lrd_kernels
  use, intrinsic :: iso_fortran_env, only: real64, int64
  use, intrinsic :: ieee_arithmetic, only: ieee_is_nan, ieee_is_finite, &
       ieee_value, ieee_quiet_nan
  implicit none
  private
  integer, parameter :: dp = real64
  real(dp), parameter, public :: air_vac_min_A = 2000.0_dp
  real(dp), parameter, public :: c_A_per_s = 2.99792458e18_dp   ! c in Angstrom/s
  real(dp), parameter, public :: A_per_um = 1.0e4_dp
  real(dp), parameter, public :: jy_cgs = 1.0e-23_dp           ! erg s^-1 cm^-2 Hz^-1 per Jy
  public :: vac2air, air2vac, um_to_angstrom, angstrom_to_um, rest_frame, &
       obs_frame, flam_to_fnu, fnu_to_flam, jy_to_flam, residuals, chi2, gauss_model, &
       zgrid_search, solve_spd
contains
  ! Morton (2000, ApJS 130, 403), IAU standard, as given in the VALD3 docs:
  ! s = 1e4/lambda_vac[A]; n = 1 + 0.0000834254 + 0.02406147/(130 - s^2)
  !                          + 0.00015998/(38.9 - s^2); lambda_air = lambda_vac/n
  elemental real(dp) function vac2air(l) result(r)
    real(dp), intent(in) :: l
    real(dp) :: s, s2, n
    if (l < air_vac_min_A) then
      r = l
    else
      s = 1.0e4_dp / l
      s2 = s * s
      n = 1.0_dp + 0.0000834254_dp + 0.02406147_dp / (130.0_dp - s2) &
           + 0.00015998_dp / (38.9_dp - s2)
      r = l / n
    end if
  end function vac2air

  ! N. Piskunov inverse (VALD3 docs): s = 1e4/lambda_air[A];
  ! n = 1 + 0.00008336624212083 + 0.02408926869968/(130.1065924522 - s^2)
  !       + 0.0001599740894897/(38.92568793293 - s^2); lambda_vac = lambda_air*n
  elemental real(dp) function air2vac(l) result(r)
    real(dp), intent(in) :: l
    real(dp) :: s, s2, n
    if (l < air_vac_min_A) then
      r = l
    else
      s = 1.0e4_dp / l
      s2 = s * s
      n = 1.0_dp + 0.00008336624212083_dp + 0.02408926869968_dp / (130.1065924522_dp - s2) &
           + 0.0001599740894897_dp / (38.92568793293_dp - s2)
      r = l * n
    end if
  end function air2vac

  elemental real(dp) function um_to_angstrom(l) result(r)
    real(dp), intent(in) :: l
    r = l * A_per_um
  end function um_to_angstrom

  elemental real(dp) function angstrom_to_um(l) result(r)
    real(dp), intent(in) :: l
    r = l / A_per_um
  end function angstrom_to_um

  elemental real(dp) function rest_frame(z, l) result(r)
    real(dp), intent(in) :: z, l
    r = l / (1.0_dp + z)
  end function rest_frame

  elemental real(dp) function obs_frame(z, l) result(r)
    real(dp), intent(in) :: z, l
    r = l * (1.0_dp + z)
  end function obs_frame

  ! f_nu = f_lambda lambda^2/c ; first-order independent-error propagation.
  elemental subroutine flam_to_fnu(l, sl, f, sf, fn, sn)
    real(dp), intent(in) :: l, sl, f, sf
    real(dp), intent(out) :: fn, sn
    real(dp) :: a, t1, t2
    a = l * l / c_A_per_s
    t1 = a * sf
    t2 = 2.0_dp * f * l / c_A_per_s * sl
    fn = f * a
    sn = sqrt(t1 * t1 + t2 * t2)
  end subroutine flam_to_fnu

  elemental subroutine fnu_to_flam(l, sl, f, sf, fl, s)
    real(dp), intent(in) :: l, sl, f, sf
    real(dp), intent(out) :: fl, s
    real(dp) :: a, t1, t2
    a = c_A_per_s / (l * l)
    t1 = a * sf
    t2 = 2.0_dp * f * a / l * sl
    fl = f * a
    s = sqrt(t1 * t1 + t2 * t2)
  end subroutine fnu_to_flam

  ! Jy -> f_lambda [erg s^-1 cm^-2 A^-1]; 1 Jy = 1e-23 erg s^-1 cm^-2 Hz^-1.
  ! Same propagation as fnu_to_flam applied to 1e-23-scaled inputs.
  elemental subroutine jy_to_flam(l, sl, f, sf, fl, s)
    real(dp), intent(in) :: l, sl, f, sf
    real(dp), intent(out) :: fl, s
    call fnu_to_flam(l, sl, jy_cgs * f, jy_cgs * sf, fl, s)
  end subroutine jy_to_flam

  pure function residuals(d, m) result(r)
    real(dp), intent(in) :: d(:), m(:)
    real(dp) :: r(size(d))
    r = d - m
  end function residuals

  pure real(dp) function chi2(d, m, s) result(c)
    real(dp), intent(in) :: d(:), m(:), s(:)
    integer :: i
    real(dp) :: r
    c = 0.0_dp
    do i = 1, size(d)
      if (s(i) > 0.0_dp .and. ieee_is_finite(s(i)) .and. ieee_is_finite(d(i)) &
           .and. ieee_is_finite(m(i))) then
        r = (d(i) - m(i)) / s(i)
        c = c + r * r
      end if
    end do
  end function chi2

  elemental real(dp) function gauss1(amp, center, sigma, x) result(g)
    real(dp), intent(in) :: amp, center, sigma, x
    real(dp) :: u
    u = (x - center) / sigma
    g = amp * exp(-0.5_dp * u * u)
  end function gauss1

  pure function gauss_model(amp, center, sigma, cont, x) result(g)
    real(dp), intent(in) :: amp, center, sigma, cont, x(:)
    real(dp) :: g(size(x))
    g = cont + gauss1(amp, center, sigma, x)
  end function gauss_model

  ! Gauss-Jordan without pivoting on an SPSD normal matrix; a column whose
  ! eliminated pivot is <= 1e-12 * original diagonal (or diagonal <= 0) is
  ! degenerate: parameter fixed to 0, its row/column zeroed.
  pure function solve_spd(a0, b0) result(b)
    real(dp), intent(in) :: a0(:,:), b0(:)
    real(dp) :: b(size(b0))
    real(dp) :: a(size(b0), size(b0)), rowc(size(b0)), diag0(size(b0)), piv, bc, f
    integer :: p, c, i
    p = size(b0)
    a = a0
    b = b0
    do i = 1, p
      diag0(i) = a0(i, i)
    end do
    do c = 1, p
      piv = a(c, c)
      if (.not. (piv > 1.0e-12_dp * diag0(c)) .or. .not. (diag0(c) > 0.0_dp)) then
        a(:, c) = 0.0_dp
        a(c, :) = 0.0_dp
        a(c, c) = 1.0_dp
        b(c) = 0.0_dp
      else
        rowc = a(c, :) / piv
        bc = b(c) / piv
        do i = 1, p
          if (i == c) cycle
          f = a(i, c)
          b(i) = b(i) - f * bc
          a(i, :) = a(i, :) - f * rowc
        end do
        a(c, :) = rowc
        b(c) = bc
      end if
    end do
  end function solve_spd

  ! Weighted linear LSQ of k line amplitudes + continuum at every z.
  ! LIMITATION: no LSF, fixed line widths, test kernel, not a redshift measurement.
  ! params = [amp_1..amp_k, cont]; best = [z_best, index (0-based)].
  subroutine zgrid_search(lam, flux, sigma, centers, widths, fit_cont, zgrid, &
       chis, best, params)
    real(dp), intent(in) :: lam(:), flux(:), sigma(:), centers(:), widths(:), zgrid(:)
    logical, intent(in) :: fit_cont
    real(dp), intent(out) :: chis(size(zgrid)), best(2), params(size(centers) + 1)
    integer :: n, k, p, m, iz, i, j, l, bi
    real(dp), allocatable :: w(:), y(:), xs(:), bm(:,:), a(:), mat(:,:), r(:)
    real(dp) :: z, mval, d, bc
    n = size(lam); k = size(centers); p = k + 1; m = size(zgrid)
    allocate(w(n), y(n), xs(n), bm(p, n), a(p), mat(p, p), r(p))
    do i = 1, n
      if (sigma(i) > 0.0_dp .and. ieee_is_finite(sigma(i)) .and. ieee_is_finite(flux(i)) &
           .and. ieee_is_finite(lam(i))) then
        w(i) = 1.0_dp / (sigma(i) * sigma(i))
        y(i) = flux(i)
        xs(i) = lam(i)
      else
        w(i) = 0.0_dp
        y(i) = 0.0_dp
        xs(i) = 0.0_dp
      end if
    end do
    bi = -1
    bc = huge(1.0_dp)
    do iz = 1, m
      z = zgrid(iz)
      do i = 1, n
        do j = 1, k
          bm(j, i) = gauss1(1.0_dp, centers(j) * (1.0_dp + z), widths(j) * (1.0_dp + z), xs(i))
        end do
        bm(p, i) = merge(1.0_dp, 0.0_dp, fit_cont)
      end do
      do j = 1, p
        do l = 1, p
          mat(j, l) = sum(w * bm(j, :) * bm(l, :))
        end do
        r(j) = sum(w * bm(j, :) * y)
      end do
      a = solve_spd(mat, r)
      chis(iz) = 0.0_dp
      do i = 1, n
        mval = sum(bm(:, i) * a)
        d = y(i) - mval
        chis(iz) = chis(iz) + w(i) * d * d
      end do
      if (.not. ieee_is_nan(chis(iz))) then
        if (bi < 0 .or. chis(iz) < bc) then
          bi = iz - 1
          bc = chis(iz)
          params = a
        end if
      end if
    end do
    if (bi >= 0) then
      best(1) = zgrid(bi + 1)
      best(2) = real(bi, dp)
    else
      best(1) = ieee_value(1.0_dp, ieee_quiet_nan)
      best(2) = -1.0_dp
      params = ieee_value(1.0_dp, ieee_quiet_nan)
    end if
  end subroutine zgrid_search
end module lrd_kernels
