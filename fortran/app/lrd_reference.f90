! SPDX-License-Identifier: AGPL-3.0-only
! Also subject to SNAPKITTY_OPAQUE_LICENSE.md (dual license, see repository root).
!
! lrd_reference <raw.fits> <outdir> <source_sha256>
! Fortran 2018 reference analysis of a NIRSpec x1d (read through the CFITSIO C boundary):
! unit conversion, line finding + identification, centroid redshifts, line fluxes with
! propagated errors, continuum vs continuum+Gaussian model comparison around H-beta and
! H-alpha, and LCDM cosmic time at the measured redshift. Writes LRD-ARR-v1 arrays and a
! key=value scalar file (reference.kv) that the caller serialises as LRD-REC-v1.
program lrd_reference
  use lrd_const
  use lrd_units
  use lrd_cosmo
  use lrd_stats
  use lrd_lines
  use lrd_arr
  use lrd_fits
  use, intrinsic :: ieee_arithmetic, only: ieee_is_finite, ieee_value, ieee_quiet_nan
  implicit none
  character(len=4096) :: path, outdir, sha
  character(len=:), allocatable :: uw, uf, ue, kval
  real(dp), allocatable :: wl_um(:), fnu(:), efnu(:), lam(:), flam(:), eflam(:), maskv(:)
  logical, allocatable :: ok(:)
  integer :: n, rc, u, ipk(256), npk, score, match(nlines), l, info, npix, i, nz
  real(dp) :: zid, flux, eflux, xc, exc, z_l, ez_l, sw, sz, zbar, ezbar, pw, nan
  real(dp), parameter :: h0 = 67.36_dp, om = 0.3153_dp, ol = 0.6847_dp ! Planck 2018 VI Table 2

  if (command_argument_count() /= 3) then
    write(*, '(a)') 'usage: lrd_reference <raw.fits> <outdir> <source_sha256>'
    stop 2
  end if
  call get_command_argument(1, path)
  call get_command_argument(2, outdir)
  call get_command_argument(3, sha)
  nan = ieee_value(1.0_dp, ieee_quiet_nan)

  rc = fits_nrows(trim(path), n)
  if (rc /= 0) error stop 'fits_nrows failed'
  allocate(wl_um(n), fnu(n), efnu(n))
  rc = fits_read_dcol(trim(path), 'WAVELENGTH', wl_um, uw); if (rc /= 0) error stop 'WAVELENGTH'
  rc = fits_read_dcol(trim(path), 'FLUX', fnu, uf);         if (rc /= 0) error stop 'FLUX'
  rc = fits_read_dcol(trim(path), 'FLUX_ERROR', efnu, ue);  if (rc /= 0) error stop 'FLUX_ERROR'
  if (uw /= 'um' .or. uf /= 'Jy' .or. ue /= 'Jy') error stop 'unexpected TUNIT (expected um, Jy, Jy)'

  ok = ieee_is_finite(wl_um) .and. ieee_is_finite(fnu) .and. ieee_is_finite(efnu) .and. efnu > 0
  lam = um_to_ang(wl_um)
  flam = merge(fnu_jy_to_flam(fnu, lam), nan, ok)
  eflam = merge(fnu_jy_to_flam(efnu, lam), nan, ok)
  maskv = merge(1.0_dp, 0.0_dp, ok)

  call arr_write(trim(outdir), 'wavelength_ang', lam, 'Angstrom', trim(sha))
  call arr_write(trim(outdir), 'flam', flam, 'erg s-1 cm-2 Angstrom-1', trim(sha))
  call arr_write(trim(outdir), 'flam_err', eflam, 'erg s-1 cm-2 Angstrom-1', trim(sha))
  call arr_write(trim(outdir), 'mask', maskv, '1', trim(sha))

  open(newunit=u, file=trim(outdir) // '/reference.kv', status='replace', action='write')
  call kv('kernel', 'fortran/lrd_reference (Fortran 2018, gfortran)')
  call kv('source_sha256', trim(sha))
  rc = fits_read_key(trim(path), 'FILENAME', kval); call kv('source_filename', kval)
  call kvi('n_rows', n)
  call kvi('n_valid', count(ok))
  call kv('cosmology', 'flat LCDM H0=67.36 Om=0.3153 OL=0.6847 (Planck 2018 VI Table 2 TT,TE,EE+lowE+lensing); radiation neglected')

  call find_peaks(lam, flam, eflam, ok, 3, 10, 5.0_dp, ipk, npk)
  call kvi('peaks.n', npk)
  call identify_redshift(lam, ipk, npk, line_vac_ang, 0.0_dp, 15.0_dp, 1.5_dp, zid, score, match)
  call kvr('id.z_initial', zid)
  call kvi('id.score', score)

  sw = 0; sz = 0; nz = 0
  do l = 1, nlines
    if (match(l) == 0) then
      call kv('line.' // trim(line_name(l)) // '.status', 'not_matched')
      cycle
    end if
    i = ipk(match(l))
    pw = lam(i + 1) - lam(i)
    call line_measure(lam, flam, eflam, ok, lam(i), 2.5_dp * pw, 6.0_dp * pw, flux, eflux, xc, exc, npix, info)
    if (info /= 0) then
      call kvi('line.' // trim(line_name(l)) // '.measure_info', info)
      cycle
    end if
    z_l = xc / line_vac_ang(l) - 1.0_dp
    ez_l = exc / line_vac_ang(l)
    call kv('line.' // trim(line_name(l)) // '.status', 'matched')
    call kvr('line.' // trim(line_name(l)) // '.rest_vac_ang', line_vac_ang(l))
    call kvr('line.' // trim(line_name(l)) // '.peak_obs_ang', lam(i))
    call kvr('line.' // trim(line_name(l)) // '.centroid_obs_ang', xc)
    call kvr('line.' // trim(line_name(l)) // '.centroid_err_ang', exc)
    call kvr('line.' // trim(line_name(l)) // '.flux_cgs', flux)
    call kvr('line.' // trim(line_name(l)) // '.flux_err_cgs', eflux)
    call kvr('line.' // trim(line_name(l)) // '.z', z_l)
    call kvr('line.' // trim(line_name(l)) // '.z_err', ez_l)
    call kvi('line.' // trim(line_name(l)) // '.npix', npix)
    call kvr('line.' // trim(line_name(l)) // '.pixel_ang', pw)
    if (flux / eflux >= 5.0_dp) then
      sw = sw + 1.0_dp / ez_l**2
      sz = sz + z_l / ez_l**2
      nz = nz + 1
    end if
  end do
  if (nz > 0) then
    zbar = sz / sw
    ezbar = sqrt(1.0_dp / sw)
  else
    zbar = zid
    ezbar = nan
  end if
  call kvi('z.n_lines_used', nz)
  call kvr('z.weighted_mean', zbar)
  call kvr('z.weighted_mean_err', ezbar)
  call kvr('cosmo.age_at_z_gyr', age_gyr(zbar, h0, om, ol))
  call kvr('cosmo.age_now_gyr', age_gyr(0.0_dp, h0, om, ol))
  call kvr('cosmo.lookback_gyr', age_gyr(0.0_dp, h0, om, ol) - age_gyr(zbar, h0, om, ol))

  call compare_models('Hbeta', 2)
  call compare_models('Halpha', 5)
  close(u)

contains
  subroutine kv(k, v)
    character(len=*), intent(in) :: k, v
    write(u, '(a)') k // '=' // v
  end subroutine
  subroutine kvi(k, v)
    character(len=*), intent(in) :: k
    integer, intent(in) :: v
    write(u, '(a,a,i0)') k, '=', v
  end subroutine
  subroutine kvr(k, v)
    character(len=*), intent(in) :: k
    real(dp), intent(in) :: v
    character(len=40) :: b
    write(b, '(es24.16e3)') v
    write(u, '(a)') k // '=' // trim(adjustl(b))
  end subroutine

  ! Model 0: linear continuum (k=2). Model 1: linear continuum + Gaussian (k=5: a, b, A, mu, sigma);
  ! mu and sigma by grid search (mu within +-2 px of the predicted line, sigma 0.3..4 px), the
  ! linear parameters by weighted least squares. Window: +-12 px about (1+z) lambda_rest.
  subroutine compare_models(nm, il)
    character(len=*), intent(in) :: nm
    integer, intent(in) :: il
    real(dp) :: c, px, mu, sg, chi, best, p0(2), c0(2, 2), p1(3), c1(3, 3), bmu, bsg, lnl0, lnl1
    real(dp), allocatable :: x(:), y(:), e(:), a0(:, :), a1(:, :), m0(:), m1(:), mfull(:), rfull(:)
    logical, allocatable :: w(:)
    integer :: m, im, is, ic, inf
    c = line_vac_ang(il) * (1.0_dp + zbar)
    if (c < minval(lam, mask=ok) .or. c > maxval(lam, mask=ok)) then
      call kv('model.' // nm // '.status', 'outside_coverage'); return
    end if
    ic = minloc(abs(lam - c), 1)
    px = lam(min(ic + 1, n)) - lam(max(ic - 1, 1))
    px = 0.5_dp * px
    w = ok .and. abs(lam - c) <= 12.0_dp * px
    m = count(w)
    if (m < 10) then
      call kv('model.' // nm // '.status', 'too_few_pixels'); return
    end if
    allocate(x(m), y(m), e(m))
    x = pack(lam, w) - c; y = pack(flam, w); e = pack(eflam, w)
    allocate(a0(m, 2), a1(m, 3))
    a0(:, 1) = 1; a0(:, 2) = x
    call wlsq(a0, y, e, p0, c0, inf)
    m0 = matmul(a0, p0)
    best = huge(1.0_dp); bmu = 0; bsg = 0
    do im = -40, 40
      mu = im * 0.05_dp * px
      do is = 3, 40
        sg = is * 0.1_dp * px
        a1(:, 1:2) = a0
        a1(:, 3) = gaussian_profile(x, mu, sg)
        call wlsq(a1, y, e, p1, c1, inf)
        if (inf /= 0) cycle
        chi = chi2(y, matmul(a1, p1), e)
        if (chi < best) then
          best = chi; bmu = mu; bsg = sg
        end if
      end do
    end do
    a1(:, 3) = gaussian_profile(x, bmu, bsg)
    call wlsq(a1, y, e, p1, c1, inf)
    m1 = matmul(a1, p1)
    lnl0 = gauss_loglike(y, m0, e); lnl1 = gauss_loglike(y, m1, e)
    call kv('model.' // nm // '.status', 'ok')
    call kvi('model.' // nm // '.n', m)
    call kvr('model.' // nm // '.chi2_cont', chi2(y, m0, e))
    call kvr('model.' // nm // '.chi2_line', chi2(y, m1, e))
    call kvr('model.' // nm // '.delta_chi2', chi2(y, m0, e) - chi2(y, m1, e))
    call kvr('model.' // nm // '.lnL_cont', lnl0)
    call kvr('model.' // nm // '.lnL_line', lnl1)
    call kvr('model.' // nm // '.LR_stat', 2.0_dp * (lnl1 - lnl0))
    call kvr('model.' // nm // '.AIC_cont', aic(lnl0, 2))
    call kvr('model.' // nm // '.AIC_line', aic(lnl1, 5))
    call kvr('model.' // nm // '.BIC_cont', bic(lnl0, 2, m))
    call kvr('model.' // nm // '.BIC_line', bic(lnl1, 5, m))
    call kvr('model.' // nm // '.gauss_amp_cgs', p1(3))
    call kvr('model.' // nm // '.gauss_amp_err_cgs', sqrt(c1(3, 3)))
    call kvr('model.' // nm // '.gauss_mu_obs_ang', c + bmu)
    call kvr('model.' // nm // '.gauss_sigma_ang', bsg)
    call kvr('model.' // nm // '.z_gauss', (c + bmu) / line_vac_ang(il) - 1.0_dp)
    call kvr('model.' // nm // '.fwhm_kms_uncorrected', 2.0_dp * sqrt(2.0_dp * log(2.0_dp)) * bsg / (c + bmu) * c_km_s)
    allocate(mfull(n), rfull(n))
    mfull = nan
    rfull = nan
    mfull = unpack(m1, w, mfull)
    rfull = unpack(residuals(y, m1), w, rfull)
    call arr_write(trim(outdir), 'model_' // nm, mfull, 'erg s-1 cm-2 Angstrom-1', trim(sha))
    call arr_write(trim(outdir), 'resid_' // nm, rfull, 'erg s-1 cm-2 Angstrom-1', trim(sha))
  end subroutine
end program lrd_reference
