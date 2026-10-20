! SPDX-License-Identifier: AGPL-3.0-only
! Also subject to SNAPKITTY_OPAQUE_LICENSE.md (dual license, see repository root).
!
! Unit tests for the Fortran kernel against analytic results and cited published values.
! Every check prints "PASS <name>" or "FAIL <name> <why>" with the declared tolerance.
! Synthetic inputs are generated in memory and named SYNTHETIC_*.
program test_kernel
  use lrd_const
  use lrd_units
  use lrd_cosmo
  use lrd_stats
  use lrd_lines
  use lrd_arr
  implicit none
  integer :: nfail = 0

  call test_units()
  call test_vacair()
  call test_cosmo()
  call test_stats()
  call test_lines()
  call test_arr()
  if (nfail > 0) error stop 1

contains
  subroutine check(name, got, expect, tol, what)
    character(len=*), intent(in) :: name, what
    real(dp), intent(in) :: got, expect, tol
    character(len=200) :: b
    if (abs(got - expect) <= tol) then
      write(*, '(a)') 'PASS ' // name
    else
      write(b, '(a,es23.15,a,es23.15,a,es10.3,1x,a)') 'got ', got, ' expected ', expect, ' tol ', tol, what
      write(*, '(a)') 'FAIL ' // name // ' ' // trim(b)
      nfail = nfail + 1
    end if
  end subroutine
  subroutine checkl(name, cond, why)
    character(len=*), intent(in) :: name, why
    logical, intent(in) :: cond
    if (cond) then
      write(*, '(a)') 'PASS ' // name
    else
      write(*, '(a)') 'FAIL ' // name // ' ' // why
      nfail = nfail + 1
    end if
  end subroutine

  subroutine test_units()
    ! 1 Jy at 1 um: 1e-23 * 2.99792458e18 / (1e4)^2 = 2.99792458e-13 erg/s/cm2/A (exact by definition)
    call check('units_jy_to_flam_1um', fnu_jy_to_flam(1.0_dp, 1.0e4_dp), 2.99792458e-13_dp, 1.0e-27_dp, 'rel 1e-14')
    call check('units_flam_roundtrip', flam_to_fnu_jy(fnu_jy_to_flam(3.7e-7_dp, 39000.0_dp), 39000.0_dp), &
               3.7e-7_dp, 1.0e-20_dp, 'abs 1e-20 Jy')
    call check('units_um_to_ang', um_to_ang(4.0315_dp), 40315.0_dp, 1.0e-9_dp, 'abs 1e-9 A')
    ! 1 Mpc/(km/s) in Gyr from IAU-defined au, pc and Julian year: 977.79... ; cross-check identity
    call check('units_hubble_time_h100', hubble_time_gyr(100.0_dp) * 100.0_dp, mpc_km / gyr_s, 1.0e-12_dp, 'identity')
  end subroutine

  subroutine test_vacair()
    ! NIST ASD ver. 5.12 Ritz wavelengths (fortran/data/nist): vacuum -> air must reproduce the
    ! tabulated air values. Declared tolerance 0.01 A (NIST quotes 3 decimals for these lines).
    call check('vacair_OIII5008_nist', vac_to_air(5008.240_dp), 5006.843_dp, 0.01_dp, 'A (NIST ASD 5.12)')
    call check('vacair_OIII4960_nist', vac_to_air(4960.295_dp), 4958.911_dp, 0.01_dp, 'A (NIST ASD 5.12)')
    call check('vacair_Halpha_nist', vac_to_air(6564.632_dp), 6562.819_dp, 0.01_dp, 'A (NIST ASD 5.12)')
    call check('vacair_Hbeta_nist', vac_to_air(4862.691_dp), 4861.333_dp, 0.01_dp, 'A (NIST ASD 5.12)')
    call check('vacair_Hgamma_nist', vac_to_air(4341.691_dp), 4340.471_dp, 0.01_dp, 'A (NIST ASD 5.12)')
    call check('vacair_roundtrip_20000A', air_to_vac(vac_to_air(20000.0_dp)), 20000.0_dp, 1.0e-8_dp, 'A')
    call checkl('vacair_index_gt_1', air_index(5000.0_dp) > 1.0_dp .and. air_index(5000.0_dp) < 1.0003_dp, &
                'n(5000A) outside (1, 1.0003)')
  end subroutine

  subroutine test_cosmo()
    real(dp) :: th
    th = hubble_time_gyr(70.0_dp)
    ! Einstein-de Sitter: t0 = 2/(3 H0) exactly; t(z) = t0 (1+z)^(-3/2)
    call check('cosmo_eds_t0', age_gyr(0.0_dp, 70.0_dp, 1.0_dp, 0.0_dp), 2.0_dp / 3.0_dp * th, 1.0e-10_dp * th, 'rel 1e-10')
    call check('cosmo_eds_tz7', age_gyr(7.0451_dp, 70.0_dp, 1.0_dp, 0.0_dp), &
               age_eds_analytic_gyr(7.0451_dp, 70.0_dp), 1.0e-10_dp * th, 'rel 1e-10')
    ! Flat LCDM closed form (asinh)
    call check('cosmo_flat_lcdm_t0_analytic', age_gyr(0.0_dp, 67.36_dp, 0.3153_dp, 0.6847_dp), &
               age_flat_lcdm_analytic_gyr(0.0_dp, 67.36_dp, 0.3153_dp), 1.0e-10_dp * th, 'rel 1e-10')
    call check('cosmo_flat_lcdm_tz7_analytic', age_gyr(7.0451_dp, 67.36_dp, 0.3153_dp, 0.6847_dp), &
               age_flat_lcdm_analytic_gyr(7.0451_dp, 67.36_dp, 0.3153_dp), 1.0e-10_dp * th, 'rel 1e-10')
    ! Open matter-only (Om=0.3, OL=0): t0 = 1/H0 [1/(1-Om) - Om/(2(1-Om)^1.5) acosh(2/Om - 1)]
    call check('cosmo_open_matter_t0_analytic', age_gyr(0.0_dp, 70.0_dp, 0.3_dp, 0.0_dp), &
               th * (1.0_dp / 0.7_dp - 0.3_dp / (2.0_dp * 0.7_dp**1.5_dp) * acosh(2.0_dp / 0.3_dp - 1.0_dp)), &
               1.0e-10_dp * th, 'rel 1e-10')
    ! Planck Collaboration 2020, A&A 641, A6 (arXiv:1807.06209), Table 2, TT,TE,EE+lowE+lensing:
    ! H0 = 67.36, Om = 0.3153, OL = 0.6847, Age = 13.797 +- 0.023 Gyr.
    ! Declared tolerance 0.046 Gyr (2 sigma): our model omits radiation and massive-neutrino detail.
    call check('cosmo_planck2018_age', age_gyr(0.0_dp, 67.36_dp, 0.3153_dp, 0.6847_dp), 13.797_dp, 0.046_dp, &
               'Gyr (Planck 2018 VI Table 2)')
  end subroutine

  subroutine test_stats()
    real(dp) :: x(5), y(5), s(5), a(5, 2), p(2), cov(2, 2), m(5)
    integer :: info
    x = [0, 1, 2, 3, 4]
    y = 2.0_dp + 3.0_dp * x          ! SYNTHETIC_line exact
    s = 1.0_dp
    a(:, 1) = 1; a(:, 2) = x
    call wlsq(a, y, s, p, cov, info)
    call check('stats_wlsq_intercept', p(1), 2.0_dp, 1.0e-12_dp, 'exact data')
    call check('stats_wlsq_slope', p(2), 3.0_dp, 1.0e-12_dp, 'exact data')
    ! Unweighted OLS slope variance for unit errors: 1/sum((x-xbar)^2) = 1/10
    call check('stats_wlsq_slope_var', cov(2, 2), 0.1_dp, 1.0e-12_dp, 'analytic 1/Sxx')
    m = matmul(a, p)
    call check('stats_chi2_zero', chi2(y, m, s), 0.0_dp, 1.0e-20_dp, 'perfect model')
    ! lnL for zero residuals, sigma=1, n=5: -5/2 ln(2 pi)
    call check('stats_lnl_analytic', gauss_loglike(y, m, s), -2.5_dp * log(2.0_dp * pi), 1.0e-12_dp, 'analytic')
    ! residual 2 sigma at one point: chi2 = 4, lnL drops by 2
    m(3) = m(3) + 2.0_dp
    call check('stats_chi2_4', chi2(y, m, s), 4.0_dp, 1.0e-12_dp, 'analytic')
    call check('stats_lnl_shift', gauss_loglike(y, m, s), -2.5_dp * log(2.0_dp * pi) - 2.0_dp, 1.0e-12_dp, 'analytic')
    call check('stats_aic', aic(-10.0_dp, 3), 26.0_dp, 1.0e-12_dp, 'AIC=2k-2lnL')
    call check('stats_bic', bic(-10.0_dp, 3, 100), 3.0_dp * log(100.0_dp) + 20.0_dp, 1.0e-12_dp, 'BIC=k ln n-2lnL')
    call check('stats_residuals', sum(residuals([1.0_dp, 2.0_dp], [0.5_dp, 2.5_dp])), 0.0_dp, 1.0e-15_dp, 'analytic')
  end subroutine

  subroutine test_lines()
    ! SYNTHETIC_spectrum: uniform grid, flat continuum 1.0, Gaussian line amplitude A, sigma sg at
    ! mu = 5008.240*(1+7.0) A; no noise. Integrated line flux = A sg sqrt(2 pi); centroid = mu.
    integer, parameter :: n = 1201
    real(dp) :: x(n), y(n), e(n), mu, sg, amp, flux, eflux, xc, exc, z, ztrue
    logical :: ok(n)
    integer :: i, npix, info, ipk(32), npk, score, match(nlines)
    ztrue = 7.0_dp
    do i = 1, n
      x(i) = 30000.0_dp + (i - 1) * 25.0_dp
    end do
    mu = 5008.240_dp * (1.0_dp + ztrue); sg = 50.0_dp; amp = 2.0_dp
    y = 1.0_dp + amp * gaussian_profile(x, mu, sg)
    e = 0.01_dp
    ok = .true.
    call line_measure(x, y, e, ok, mu, 8.0_dp * sg, 300.0_dp, flux, eflux, xc, exc, npix, info)
    call checkl('lines_measure_info', info == 0, 'info /= 0')
    ! truncation at +-8 sigma leaves < 1e-14 of the flux; rectangle rule on a smooth Gaussian
    call check('lines_flux_gaussian', flux, amp * sg * sqrt(2.0_dp * pi), 1.0e-6_dp, 'analytic A sg sqrt(2pi)')
    call check('lines_centroid_gaussian', xc, mu, 1.0e-6_dp, 'A (symmetric profile)')
    ! error propagation with fixed continuum excluded: sqrt(npix) e dx is a lower bound
    call checkl('lines_flux_err_lower_bound', eflux >= sqrt(real(npix, dp)) * 0.01_dp * 25.0_dp * (1 - 1e-12_dp), &
                'eflux below sqrt(N) e dx')
    z = xc / 5008.240_dp - 1.0_dp
    call check('lines_redshift_from_centroid', z, ztrue, 1.0e-9_dp, 'synthetic')
    ! identification: SYNTHETIC lines Hbeta, OIII4960, OIII5008, Halpha at z=7
    y = 1.0_dp
    do i = 2, nlines
      y = y + gaussian_profile(x, line_vac_ang(i) * (1.0_dp + ztrue), sg)
    end do
    call find_peaks(x, y, e, ok, 3, 10, 5.0_dp, ipk, npk)
    call identify_redshift(x, ipk, npk, line_vac_ang, 0.0_dp, 15.0_dp, 1.5_dp, z, score, match)
    call checkl('lines_identify_score', score == 4, 'expected 4 matched lines')
    call check('lines_identify_z', z, ztrue, 25.0_dp / 5008.240_dp, 'within 1 pixel')
  end subroutine

  subroutine test_arr()
    real(dp), allocatable :: v(:)
    character(len=:), allocatable :: unit
    integer :: info
    call arr_write('.', 'SYNTHETIC_arr', [1.0_dp, -2.5_dp, 3.25_dp], 'um', '')
    call arr_read('.', 'SYNTHETIC_arr', v, unit, info)
    call checkl('arr_roundtrip', info == 0 .and. size(v) == 3 .and. all(v == [1.0_dp, -2.5_dp, 3.25_dp]) &
                .and. unit == 'um', 'LRD-ARR-v1 write/read mismatch')
    block
      integer(1) :: b(8)
      integer :: uu
      call arr_write('.', 'SYNTHETIC_one', [1.0_dp], '1', '')
      open(newunit=uu, file='SYNTHETIC_one.f64', access='stream', form='unformatted', status='old')
      read(uu) b
      close(uu)
      ! IEEE-754 binary64 1.0 = 0x3FF0000000000000, little-endian bytes 00 00 00 00 00 00 F0 3F
      call checkl('arr_little_endian_bytes', all(b(1:6) == 0_1) .and. b(7) == int(z'F0', 1) .and. b(8) == 63_1, &
                  'bytes of 1.0 are not little-endian binary64')
    end block
  end subroutine
end program test_kernel
