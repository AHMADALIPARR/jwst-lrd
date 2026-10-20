! SPDX-License-Identifier: AGPL-3.0-only
! Also subject to SNAPKITTY_OPAQUE_LICENSE.md (dual license, see repository root).
!
! LCDM (matter + Lambda + curvature; radiation neglected) cosmic time.
!   t(z) = (1/H0) * Integral_0^{a} da' / (a' E(a')),  a = 1/(1+z),
!   E(a)^2 = Om a^-3 + Ok a^-2 + OL,  Ok = 1 - Om - OL.
! Substituting a = u^2 removes the sqrt(a) behaviour at a -> 0:
!   t = (1/H0) * Integral_0^{sqrt(a)} 2 u^2 / sqrt(Om + Ok u^2 + OL u^6) du
! evaluated with composite Gauss-Legendre (5 nodes) on nseg uniform segments.
module lrd_cosmo
  use lrd_const
  implicit none
  private
  public :: hubble_time_gyr, age_gyr, age_flat_lcdm_analytic_gyr, age_eds_analytic_gyr, efunc

  real(dp), parameter :: gl_x(5) = [ -0.906179845938663992797626878299_dp, &
       -0.538469310105683091036314420700_dp, 0.0_dp, 0.538469310105683091036314420700_dp, &
        0.906179845938663992797626878299_dp ]
  real(dp), parameter :: gl_w(5) = [ 0.236926885056189087514264040720_dp, &
        0.478628670499366468041291514836_dp, 0.568888888888888888888888888889_dp, &
        0.478628670499366468041291514836_dp, 0.236926885056189087514264040720_dp ]
contains
  pure real(dp) function hubble_time_gyr(h0_km_s_mpc) result(th)
    real(dp), intent(in) :: h0_km_s_mpc
    th = mpc_km / h0_km_s_mpc / gyr_s
  end function

  pure real(dp) function efunc(z, om, ol) result(e)
    real(dp), intent(in) :: z, om, ol
    real(dp) :: ok
    ok = 1.0_dp - om - ol
    e = sqrt(om * (1.0_dp + z)**3 + ok * (1.0_dp + z)**2 + ol)
  end function

  pure real(dp) function age_gyr(z, h0, om, ol, nseg_in) result(t)
    real(dp), intent(in) :: z, h0, om, ol
    integer, intent(in), optional :: nseg_in
    integer :: nseg, i, k
    real(dp) :: umax, h, u0, u, s, ok
    nseg = 2000
    if (present(nseg_in)) nseg = nseg_in
    ok = 1.0_dp - om - ol
    umax = sqrt(1.0_dp / (1.0_dp + z))
    h = umax / nseg
    s = 0.0_dp
    do i = 0, nseg - 1
      u0 = i * h
      do k = 1, 5
        u = u0 + 0.5_dp * h * (gl_x(k) + 1.0_dp)
        s = s + 0.5_dp * h * gl_w(k) * 2.0_dp * u * u / sqrt(om + ok * u * u + ol * u**6)
      end do
    end do
    t = s * hubble_time_gyr(h0)
  end function

  ! Flat LCDM closed form: t(z) = 2/(3 H0 sqrt(OL)) asinh( sqrt(OL/Om) (1+z)^(-3/2) )
  pure real(dp) function age_flat_lcdm_analytic_gyr(z, h0, om) result(t)
    real(dp), intent(in) :: z, h0, om
    real(dp) :: ol
    ol = 1.0_dp - om
    t = 2.0_dp / (3.0_dp * sqrt(ol)) * asinh(sqrt(ol / om) * (1.0_dp + z)**(-1.5_dp)) * hubble_time_gyr(h0)
  end function

  ! Einstein-de Sitter: t(z) = 2/(3 H0) (1+z)^(-3/2)
  pure real(dp) function age_eds_analytic_gyr(z, h0) result(t)
    real(dp), intent(in) :: z, h0
    t = 2.0_dp / 3.0_dp * hubble_time_gyr(h0) * (1.0_dp + z)**(-1.5_dp)
  end function
end module lrd_cosmo
