! SPDX-License-Identifier: AGPL-3.0-only
! Also subject to SNAPKITTY_OPAQUE_LICENSE.md (dual license, see repository root).
!
! lrd_growth: continuous black-hole accretion growth in cosmological time.
! Mission QSO1-DCBH-001, role 04 (growth solver). Directive 2026-10-19/20.
!
! Model. The Eddington luminosity of a hole of mass M is
!   L_Edd = 4 pi G M m_p c / sigma_T.
! lambda_Edd (written lam below) is the LUMINOSITY ratio L / L_Edd. It is NOT
! the physical mass-accretion rate. With radiative efficiency eps, the rest-mass
! accretion rate that produces luminosity L is Mdot_acc = L / (eps c^2), so in
! units of L_Edd / c^2 the physical accretion rate is
!   mdot = lam / eps,
! and the hole retains the non-radiated fraction:
!   dM/dt = (1 - eps) Mdot_acc = duty * (1 - eps)/eps * lam * M / t_Edd,
!   t_Edd = sigma_T c / (4 pi G m_p)  (the Eddington time, ~0.4504 Gyr).
! The duty cycle is the fraction of the interval spent accreting; it enters as a
! straight multiplier on the rate (time-averaged on-fraction).
!
! Super-Eddington caveat (directive item 5): the simple model above lets the
! growth rate rise linearly with lam without bound. In slim-disk flows the
! luminosity saturates logarithmically, L ~ L_Edd (1 + ln mdot-ish), so the
! simple model is an UPPER bound on growth for lam > 1. MODE_SATURATED replaces
! lam by lam_eff = 1 + log(lam) for lam > 1 in the growth rate, giving a lower,
! saturation-motivated estimate. Both are carried through every output; neither
! is hidden. For lam <= 1 the two modes are identical.
!
! Integration: the growth factor G = M(t_obs)/M(t_form) is computed by explicit
! stepping over the cosmological time grid from lrd_cosmo (age_gyr at successive
! redshifts from z_form down to z_obs), accumulating rate*dt step by step. The
! rate is constant for constant (eps, lam, duty), so the stepping reproduces
! exp(rate * Dt) to quadrature accuracy; grow_mass_rk4 integrates dM/dt directly
! in cosmic time as an independent cross-check.
!
! Measured constants (CODATA 2018; these are measured, not exact, so they live
! here and not in lrd_const, which holds only exact/defined values):
!   G       = 6.67430e-11 m^3 kg^-1 s^-2
!   m_p     = 1.67262192369e-27 kg
!   sigma_T = 6.6524587321e-29 m^2
module lrd_growth
  use lrd_const
  use lrd_cosmo, only: age_gyr
  implicit none
  private
  public :: eddington_time_gyr, growth_rate_gyr, lam_effective, mdot_edd, &
            growth_factor, grow_mass_rk4, min_seed_mass, required_lambda, &
            MODE_SIMPLE, MODE_SATURATED

  integer, parameter :: MODE_SIMPLE = 1     ! lam used as-is (upper bound for lam>1)
  integer, parameter :: MODE_SATURATED = 2  ! lam_eff = 1 + log(lam) for lam > 1

  real(dp), parameter :: g_si = 6.67430e-11_dp            ! m^3 kg^-1 s^-2 (CODATA 2018)
  real(dp), parameter :: m_p_si = 1.67262192369e-27_dp    ! kg (CODATA 2018)
  real(dp), parameter :: sigma_t_si = 6.6524587321e-29_dp ! m^2 (CODATA 2018)

contains

  ! Eddington time t_Edd = sigma_T c / (4 pi G m_p), in Gyr.
  pure real(dp) function eddington_time_gyr() result(t)
    t = sigma_t_si * c_m_s / (4.0_dp * pi * g_si * m_p_si) / gyr_s
  end function eddington_time_gyr

  ! Luminosity ratio lam -> growth-effective ratio under the chosen mode.
  pure real(dp) function lam_effective(lam, mode) result(le)
    real(dp), intent(in) :: lam
    integer, intent(in) :: mode
    if (mode == MODE_SATURATED .and. lam > 1.0_dp) then
      le = 1.0_dp + log(lam)
    else
      le = lam
    end if
  end function lam_effective

  ! Physical mass-accretion rate in units of L_Edd / c^2: mdot = lam / eps.
  ! This is the quantity that must not be conflated with lam itself.
  pure real(dp) function mdot_edd(lam, eps) result(m)
    real(dp), intent(in) :: lam, eps
    m = lam / eps
  end function mdot_edd

  ! e-folding rate (per Gyr) of dM/dt = rate * M.
  pure real(dp) function growth_rate_gyr(eps, lam, duty, mode) result(r)
    real(dp), intent(in) :: eps, lam, duty
    integer, intent(in) :: mode
    r = duty * (1.0_dp - eps) / eps * lam_effective(lam, mode) / eddington_time_gyr()
  end function growth_rate_gyr

  ! Growth factor G = M(z_obs) / M(z_form) by explicit stepping over the
  ! cosmological time grid: nstep uniform steps in redshift from z_form down
  ! to z_obs, dt from lrd_cosmo age_gyr differences, exponent accumulated.
  real(dp) function growth_factor(z_form, z_obs, eps, lam, duty, mode, &
                                  h0, om, ol, nstep) result(g)
    real(dp), intent(in) :: z_form, z_obs, eps, lam, duty, h0, om, ol
    integer, intent(in) :: mode, nstep
    integer :: i
    real(dp) :: r, z_prev, z_cur, t_prev, t_cur, expo
    r = growth_rate_gyr(eps, lam, duty, mode)
    expo = 0.0_dp
    z_prev = z_form
    t_prev = age_gyr(z_prev, h0, om, ol)
    do i = 1, nstep
      z_cur = z_form + (z_obs - z_form) * real(i, dp) / real(nstep, dp)
      t_cur = age_gyr(z_cur, h0, om, ol)
      expo = expo + r * (t_cur - t_prev)
      z_prev = z_cur
      t_prev = t_cur
    end do
    g = exp(expo)
  end function growth_factor

  ! Independent cross-check: RK4 integration of dM/dt = rate * M in cosmic
  ! time, t from age(z_form) to age(z_obs), nstep uniform steps in t.
  real(dp) function grow_mass_rk4(seed, z_form, z_obs, eps, lam, duty, mode, &
                                  h0, om, ol, nstep) result(m)
    real(dp), intent(in) :: seed, z_form, z_obs, eps, lam, duty, h0, om, ol
    integer, intent(in) :: mode, nstep
    integer :: i
    real(dp) :: r, t0, t1, h, k1, k2, k3, k4
    r = growth_rate_gyr(eps, lam, duty, mode)
    t0 = age_gyr(z_form, h0, om, ol)
    t1 = age_gyr(z_obs, h0, om, ol)
    h = (t1 - t0) / real(nstep, dp)
    m = seed
    do i = 1, nstep
      k1 = r * m
      k2 = r * (m + 0.5_dp * h * k1)
      k3 = r * (m + 0.5_dp * h * k2)
      k4 = r * (m + h * k3)
      m = m + h * (k1 + 2.0_dp * k2 + 2.0_dp * k3 + k4) / 6.0_dp
    end do
  end function grow_mass_rk4

  ! Minimum seed that reaches m_target: seed_min = m_target / G (linear ODE).
  pure real(dp) function min_seed_mass(m_target, g) result(s)
    real(dp), intent(in) :: m_target, g
    s = m_target / g
  end function min_seed_mass

  ! Required luminosity ratio (MODE_SIMPLE) for a given seed to reach
  ! m_target over [z_form, z_obs]: inverts the exponent analytically.
  real(dp) function required_lambda(m_target, seed, eps, z_form, z_obs, duty, &
                                    h0, om, ol) result(lam)
    real(dp), intent(in) :: m_target, seed, eps, z_form, z_obs, duty, h0, om, ol
    real(dp) :: dt
    dt = age_gyr(z_obs, h0, om, ol) - age_gyr(z_form, h0, om, ol)
    lam = log(m_target / seed) * eps / (1.0_dp - eps) * eddington_time_gyr() &
          / (duty * dt)
  end function required_lambda

end module lrd_growth
