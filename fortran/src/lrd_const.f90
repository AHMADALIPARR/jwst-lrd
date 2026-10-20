! SPDX-License-Identifier: AGPL-3.0-only
! Also subject to SNAPKITTY_OPAQUE_LICENSE.md (dual license, see repository root).
!
! Physical constants. Only exact/defined values are used:
!   c = 299792458 m/s (SI definition)
!   au = 149597870700 m (IAU 2012 Resolution B2); pc = (648000/pi) au (IAU 2015 Resolution B2)
!   Julian year = 365.25 d of 86400 s (IAU)
!   1 Jy = 1e-26 W m^-2 Hz^-1 = 1e-23 erg s^-1 cm^-2 Hz^-1 (definition)
module lrd_const
  use, intrinsic :: iso_fortran_env, only: real64
  implicit none
  integer, parameter :: dp = real64
  real(dp), parameter :: pi = 3.14159265358979323846264338327950288_dp
  real(dp), parameter :: c_m_s = 299792458.0_dp
  real(dp), parameter :: c_km_s = c_m_s / 1000.0_dp
  real(dp), parameter :: c_ang_s = c_m_s * 1.0e10_dp
  real(dp), parameter :: au_km = 149597870.7_dp
  real(dp), parameter :: pc_km = 648000.0_dp / pi * au_km
  real(dp), parameter :: mpc_km = 1.0e6_dp * pc_km
  real(dp), parameter :: gyr_s = 1.0e9_dp * 365.25_dp * 86400.0_dp
  real(dp), parameter :: jy_cgs = 1.0e-23_dp
end module lrd_const
