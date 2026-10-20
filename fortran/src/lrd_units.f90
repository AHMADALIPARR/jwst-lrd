! SPDX-License-Identifier: AGPL-3.0-only
! Also subject to SNAPKITTY_OPAQUE_LICENSE.md (dual license, see repository root).
!
! Wavelength media (vacuum/air) and flux-density unit conversion.
! Air refractive index: Edlen (1966) formula in the form given by Morton (2000, ApJS 130, 403):
!   n - 1 = 8.34254e-5 + 2.406147e-2/(130 - s^2) + 1.5998e-4/(38.9 - s^2),  s = 1e4 / lambda_vac[A]
! valid for lambda > 2000 A. air -> vac is solved by fixed-point iteration of the same formula.
module lrd_units
  use lrd_const
  implicit none
  private
  public :: air_index, vac_to_air, air_to_vac, um_to_ang, fnu_jy_to_flam, flam_to_fnu_jy

contains
  elemental real(dp) function air_index(lam_vac_ang) result(n)
    real(dp), intent(in) :: lam_vac_ang
    real(dp) :: s2
    s2 = (1.0e4_dp / lam_vac_ang)**2
    n = 1.0_dp + 8.34254e-5_dp + 2.406147e-2_dp / (130.0_dp - s2) + 1.5998e-4_dp / (38.9_dp - s2)
  end function

  elemental real(dp) function vac_to_air(lam_vac_ang) result(la)
    real(dp), intent(in) :: lam_vac_ang
    la = lam_vac_ang / air_index(lam_vac_ang)
  end function

  elemental real(dp) function air_to_vac(lam_air_ang) result(lv)
    real(dp), intent(in) :: lam_air_ang
    integer :: i
    lv = lam_air_ang
    do i = 1, 50
      lv = lam_air_ang * air_index(lv)
    end do
  end function

  elemental real(dp) function um_to_ang(x) result(y)
    real(dp), intent(in) :: x
    y = x * 1.0e4_dp
  end function

  ! F_lambda [erg s^-1 cm^-2 A^-1] = F_nu[Jy] * 1e-23 * c[A/s] / lambda[A]^2
  elemental real(dp) function fnu_jy_to_flam(fnu_jy, lam_ang) result(fl)
    real(dp), intent(in) :: fnu_jy, lam_ang
    fl = fnu_jy * jy_cgs * c_ang_s / lam_ang**2
  end function

  elemental real(dp) function flam_to_fnu_jy(flam, lam_ang) result(fn)
    real(dp), intent(in) :: flam, lam_ang
    fn = flam * lam_ang**2 / (c_ang_s * jy_cgs)
  end function
end module lrd_units
