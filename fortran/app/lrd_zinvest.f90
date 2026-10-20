! SPDX-License-Identifier: AGPL-3.0-only
! Also subject to SNAPKITTY_OPAQUE_LICENSE.md (dual license, see repository root).
!
! lrd_zinvest <raw x1d.fits> <jwst_nirspec_prism_disp.fits> <out.kv>
! Investigation of the redshift offset between the kernel (centroids) and Furtak et al. 2024.
!  (a) z from H-beta alone, H-alpha alone and jointly, for three estimators:
!      centroid (lrd_lines), point-sampled Gaussian, and LSF-convolved pixel-integrated Gaussian
!      (profile chi^2 over z, intrinsic width profiled out; Delta chi^2 = 1 intervals).
!  (b) H-alpha red-edge tests: pixel validity next to the line, centroid half-width scan,
!      fit-window scan, red-side truncation, and noise-free injection-recovery on the real
!      pixel grid and mask.
!  (c) LSF: R(lambda) from the JDox PRISM dispersion file (linear interpolation, sigma = lambda/R/2.3548),
!      model integrated over pixel bins (edges at midpoints of the x1d wavelength grid).
program lrd_zinvest
  use lrd_const
  use lrd_units
  use lrd_stats
  use lrd_lines
  use lrd_fits
  use, intrinsic :: ieee_arithmetic, only: ieee_is_finite
  implicit none
  character(len=4096) :: path, dpath, outp
  character(len=:), allocatable :: uw, uf, ue, u1, u2
  real(dp), allocatable :: wl(:), fnu(:), efnu(:), lam(:), fl(:), efl(:), lo(:), hi(:), dw(:), dr(:)
  real(dp), allocatable :: ysyn(:)
  logical, allocatable :: ok(:)
  integer :: n, nd, rc, u, i, j, k, ip
  real(dp), parameter :: zpub = 7.0451_dp, zref = 7.042_dp
  real(dp), parameter :: zlo = 7.020_dp, zhi = 7.065_dp, dz = 1.0e-5_dp
  integer, parameter :: ilb = 2, ila = 5   ! H-beta, H-alpha indices in lrd_lines
  real(dp) :: hws(6) = [1.5_dp, 2.0_dp, 2.5_dp, 3.0_dp, 3.5_dp, 4.0_dp]
  real(dp) :: zb, zbl, zbh, sib, fb, za, zal, zah, sia, fa, zj, zjl, zjh, px, cont(2)
  real(dp) :: flux, eflux, xc, exc, chimin
  integer :: npix, info, nwin

  call get_command_argument(1, path); call get_command_argument(2, dpath); call get_command_argument(3, outp)
  rc = fits_nrows(trim(path), n); if (rc /= 0) error stop 'x1d rows'
  allocate(wl(n), fnu(n), efnu(n))
  rc = fits_read_dcol(trim(path), 'WAVELENGTH', wl, uw)
  rc = fits_read_dcol(trim(path), 'FLUX', fnu, uf)
  rc = fits_read_dcol(trim(path), 'FLUX_ERROR', efnu, ue)
  rc = fits_nrows_ext(trim(dpath), 'TABLE', nd); if (rc /= 0) error stop 'disp rows'
  allocate(dw(nd), dr(nd))
  rc = fits_read_dcol_ext(trim(dpath), 'TABLE', 'WAVELENGTH', dw, u1); if (rc /= 0) error stop 'disp WAVELENGTH'
  rc = fits_read_dcol_ext(trim(dpath), 'TABLE', 'R', dr, u2); if (rc /= 0) error stop 'disp R'
  if (u1 /= 'MICRONS') error stop 'disp unit'
  dw = dw * 1.0e4_dp
  ok = ieee_is_finite(wl) .and. ieee_is_finite(fnu) .and. ieee_is_finite(efnu) .and. efnu > 0
  lam = um_to_ang(wl)
  fl = merge(fnu_jy_to_flam(fnu, lam), 0.0_dp, ok)
  efl = merge(fnu_jy_to_flam(efnu, lam), 1.0_dp, ok)
  allocate(lo(n), hi(n))
  do i = 1, n
    if (i > 1) then; lo(i) = 0.5_dp * (lam(i) + lam(i - 1)); else; lo(i) = lam(1) - 0.5_dp * (lam(2) - lam(1)); end if
    if (i < n) then; hi(i) = 0.5_dp * (lam(i) + lam(i + 1)); else; hi(i) = lam(n) + 0.5_dp * (lam(n) - lam(n - 1)); end if
  end do

  open(newunit=u, file=trim(outp), status='replace', action='write')
  call kv('lsf.source', 'JDox jwst_nirspec_prism_disp.fits (TABLE: WAVELENGTH MICRONS, R), 2.2-pixel resolution element')
  call kvr('lsf.R_at_Hbeta_obs', rinterp(line_vac_ang(ilb) * (1 + zref)))
  call kvr('lsf.R_at_Halpha_obs', rinterp(line_vac_ang(ila) * (1 + zref)))
  call kvr('lsf.fwhm_kms_at_Hbeta', c_km_s / rinterp(line_vac_ang(ilb) * (1 + zref)))
  call kvr('lsf.fwhm_kms_at_Halpha', c_km_s / rinterp(line_vac_ang(ila) * (1 + zref)))
  call kvr('pix.width_ang_at_Hbeta', pixw(line_vac_ang(ilb) * (1 + zref)))
  call kvr('pix.width_ang_at_Halpha', pixw(line_vac_ang(ila) * (1 + zref)))
  px = line_vac_ang(ilb) * (1 + zref)
  call kvr('lsf.fwhm_pix_at_Hbeta', px / rinterp(px) / pixw(px))
  px = line_vac_ang(ila) * (1 + zref)
  call kvr('lsf.fwhm_pix_at_Halpha', px / rinterp(px) / pixw(px))

  ! ---------------- (a) estimators, data
  call profile(fl, ilb, 12, 12, .true., zb, zbl, zbh, sib, fb, chimin, nwin)
  call kvz('a.lsf.Hbeta', zb, zbl, zbh, sib, chimin, nwin)
  call profile(fl, ila, 12, 12, .true., za, zal, zah, sia, fa, chimin, nwin)
  call kvz('a.lsf.Halpha', za, zal, zah, sia, chimin, nwin)
  call joint(fl, .true., zj, zjl, zjh, chimin)
  call kvz('a.lsf.joint', zj, zjl, zjh, -1.0_dp, chimin, -1)
  call profile(fl, ilb, 12, 12, .false., zb, zbl, zbh, sib, fb, chimin, nwin)
  call kvz('a.point.Hbeta', zb, zbl, zbh, sib, chimin, nwin)
  call profile(fl, ila, 12, 12, .false., za, zal, zah, sia, fa, chimin, nwin)
  call kvz('a.point.Halpha', za, zal, zah, sia, chimin, nwin)
  call joint(fl, .false., zj, zjl, zjh, chimin)
  call kvz('a.point.joint', zj, zjl, zjh, -1.0_dp, chimin, -1)
  do k = 1, 2
    j = merge(ilb, ila, k == 1)
    ip = minloc(abs(lam - line_vac_ang(j) * (1 + zref)), 1, mask=ok)
    ip = peak_near(fl, ip)
    px = lam(ip + 1) - lam(ip)
    call line_measure(lam, fl, efl, ok, lam(ip), 2.5_dp * px, 6.0_dp * px, flux, eflux, xc, exc, npix, info)
    call kvr('a.centroid.' // trim(line_name(j)) // '.z', xc / line_vac_ang(j) - 1)
    call kvr('a.centroid.' // trim(line_name(j)) // '.z_err', exc / line_vac_ang(j))
  end do

  ! ---------------- (b) H-alpha red edge
  ip = peak_near(fl, minloc(abs(lam - line_vac_ang(ila) * (1 + zref)), 1, mask=ok))
  call kvr('b.Halpha.peak_obs_ang', lam(ip))
  do i = ip - 6, min(ip + 8, n)
    call kv('b.Halpha.pix' // itoa(i - ip) // '', trim(rtoa(lam(i))) // ' ok=' // trim(merge('T', 'F', ok(i))) // &
            ' sn=' // trim(rtoa(merge(fl(i) / efl(i), 0.0_dp, ok(i)))))
  end do
  i = ip
  do while (i < n .and. ok(i + 1))
    i = i + 1
  end do
  call kvi('b.Halpha.valid_pix_redward_of_peak', i - ip)
  call kvr('b.Halpha.last_valid_obs_ang', lam(i))
  px = lam(ip + 1) - lam(ip)
  do k = 1, size(hws)
    call line_measure(lam, fl, efl, ok, lam(ip), hws(k) * px, 6.0_dp * px, flux, eflux, xc, exc, npix, info)
    if (info == 0) then
      call kvr('b.Halpha.centroid_hw' // trim(rtoa1(hws(k))) // '.z', xc / line_vac_ang(ila) - 1)
      call kvi('b.Halpha.centroid_hw' // trim(rtoa1(hws(k))) // '.npix', npix)
    else
      call kvi('b.Halpha.centroid_hw' // trim(rtoa1(hws(k))) // '.info', info)
    end if
  end do
  do k = 6, 12, 3
    call profile(fl, ila, k, k, .true., za, zal, zah, sia, fa, chimin, nwin)
    call kvz('b.Halpha.lsf_win' // itoa(k), za, zal, zah, sia, chimin, nwin)
    call profile(fl, ilb, k, k, .true., zb, zbl, zbh, sib, fb, chimin, nwin)
    call kvz('b.Hbeta.lsf_win' // itoa(k), zb, zbl, zbh, sib, chimin, nwin)
  end do
  call profile(fl, ila, 12, 1, .true., za, zal, zah, sia, fa, chimin, nwin)
  call kvz('b.Halpha.lsf_red_trunc1', za, zal, zah, sia, chimin, nwin)
  call profile(fl, ila, 12, 0, .true., za, zal, zah, sia, fa, chimin, nwin)
  call kvz('b.Halpha.lsf_red_trunc0', za, zal, zah, sia, chimin, nwin)

  ! ---------------- (b)+(c) noise-free injection-recovery at z = zpub on the real grid and mask
  do k = 1, 2
    j = merge(ilb, ila, k == 1)
    call profile(fl, j, 12, 12, .true., za, zal, zah, sia, fa, chimin, nwin, cont)
    allocate(ysyn(n))
    ysyn = 0
    do i = 1, n
      if (abs(lam(i) - line_vac_ang(j) * (1 + zref)) < 40 * px) &
        ysyn(i) = cont(1) + cont(2) * (lam(i) - line_vac_ang(j) * (1 + zref)) + &
                  fa * binned(i, line_vac_ang(j) * (1 + zpub), sqrt(lsfs(line_vac_ang(j) * (1 + zpub))**2 + &
                  (sia / c_km_s * line_vac_ang(j) * (1 + zpub))**2))
    end do
    call kv('inj.' // trim(line_name(j)) // '.model', 'SYNTHETIC: fitted continuum + LSF(JDox)*Gaussian(sigma_int fitted), ' // &
            'pixel-integrated, noise-free, z_true=7.0451')
    call profile(ysyn, j, 12, 12, .true., za, zal, zah, sia, fa, chimin, nwin)
    call kvr('inj.' // trim(line_name(j)) // '.lsf_fit.z_minus_true', za - zpub)
    call profile(ysyn, j, 12, 12, .false., za, zal, zah, sia, fa, chimin, nwin)
    call kvr('inj.' // trim(line_name(j)) // '.point_fit.z_minus_true', za - zpub)
    ip = peak_near(ysyn, minloc(abs(lam - line_vac_ang(j) * (1 + zpub)), 1, mask=ok))
    px = lam(ip + 1) - lam(ip)
    do i = 1, size(hws)
      call line_measure(lam, ysyn, efl, ok, lam(ip), hws(i) * px, 6.0_dp * px, flux, eflux, xc, exc, npix, info)
      if (info == 0) call kvr('inj.' // trim(line_name(j)) // '.centroid_hw' // trim(rtoa1(hws(i))) // '.z_minus_true', &
                              xc / line_vac_ang(j) - 1 - zpub)
    end do
    deallocate(ysyn)
  end do
  close(u)

contains
  real(dp) function rinterp(x) result(r)
    real(dp), intent(in) :: x
    integer :: m
    if (x <= dw(1)) then; r = dr(1); return; end if
    if (x >= dw(nd)) then; r = dr(nd); return; end if
    m = 1
    do while (dw(m + 1) < x)
      m = m + 1
    end do
    r = dr(m) + (dr(m + 1) - dr(m)) * (x - dw(m)) / (dw(m + 1) - dw(m))
  end function
  real(dp) function lsfs(x) result(s)
    real(dp), intent(in) :: x
    s = x / rinterp(x) / (2.0_dp * sqrt(2.0_dp * log(2.0_dp)))
  end function
  real(dp) function pixw(x) result(w)
    real(dp), intent(in) :: x
    integer :: m
    m = minloc(abs(lam - x), 1)
    w = hi(m) - lo(m)
  end function
  ! unit-flux Gaussian integrated over pixel i, divided by the pixel width (flux density)
  real(dp) function binned(i, mu, s) result(b)
    integer, intent(in) :: i
    real(dp), intent(in) :: mu, s
    b = 0.5_dp * (erf((hi(i) - mu) / (s * sqrt(2.0_dp))) - erf((lo(i) - mu) / (s * sqrt(2.0_dp)))) / (hi(i) - lo(i))
  end function
  integer function peak_near(y, i0) result(ip)
    real(dp), intent(in) :: y(:)
    integer, intent(in) :: i0
    integer :: m
    ip = i0
    do m = max(1, i0 - 3), min(n, i0 + 3)
      if (ok(m) .and. y(m) > y(ip)) ip = m
    end do
  end function

  ! chi^2 of continuum(2) + line for line il at redshift z with intrinsic sigma sint [km/s];
  ! window: valid pixels within -nb..+nr pixels of the fixed reference centre (zref).
  subroutine fit1(y, il, z, sint, nb, nr, lsf, chi, f, m, cc)
    real(dp), intent(in) :: y(:), z, sint
    integer, intent(in) :: il, nb, nr
    logical, intent(in) :: lsf
    real(dp), intent(out) :: chi, f
    integer, intent(out) :: m
    real(dp), intent(out), optional :: cc(2)
    integer :: i0, i, kk, inf
    real(dp) :: c0, mu, s, a(64, 3), yy(64), ee(64), p(3), cv(3, 3)
    c0 = line_vac_ang(il) * (1 + zref)
    i0 = minloc(abs(lam - c0), 1)
    mu = line_vac_ang(il) * (1 + z)
    m = 0
    do i = max(1, i0 - nb), min(n, i0 + nr)
      if (.not. ok(i)) cycle
      m = m + 1
      if (lsf) then
        s = sqrt(lsfs(mu)**2 + (sint / c_km_s * mu)**2)
        a(m, 3) = binned(i, mu, s)
      else
        s = max(sint / c_km_s * mu, 1.0_dp)
        a(m, 3) = exp(-0.5_dp * ((lam(i) - mu) / s)**2)
      end if
      a(m, 1) = 1; a(m, 2) = lam(i) - c0
      yy(m) = y(i); ee(m) = efl(i)
    end do
    call wlsq(a(1:m, :), yy(1:m), ee(1:m), p, cv, inf)
    chi = huge(1.0_dp); f = 0
    if (inf /= 0) return
    chi = 0
    do kk = 1, m
      chi = chi + ((yy(kk) - sum(a(kk, :) * p)) / ee(kk))**2
    end do
    f = p(3)
    if (present(cc)) cc = p(1:2)
  end subroutine

  ! profile chi^2(z) = min over sigma_int; returns best z, Delta chi^2 = 1 interval, sigma_int, flux.
  subroutine profile(y, il, nb, nr, lsf, zbest, zl, zh, sbest, fbest, chimin, m, cc)
    real(dp), intent(in) :: y(:)
    integer, intent(in) :: il, nb, nr
    logical, intent(in) :: lsf
    real(dp), intent(out) :: zbest, zl, zh, sbest, fbest, chimin
    integer, intent(out) :: m
    real(dp), intent(out), optional :: cc(2)
    integer :: nzg, iz, is
    real(dp), allocatable :: prof(:)
    real(dp) :: z, chi, f, best
    nzg = nint((zhi - zlo) / dz) + 1
    allocate(prof(nzg))
    chimin = huge(1.0_dp)
    do iz = 1, nzg
      z = zlo + (iz - 1) * dz
      best = huge(1.0_dp)
      do is = 0, 80
        call fit1(y, il, z, is * 50.0_dp, nb, nr, lsf, chi, f, m)
        if (chi < best) best = chi
        if (chi < chimin) then
          chimin = chi; zbest = z; sbest = is * 50.0_dp; fbest = f
        end if
      end do
      prof(iz) = best
    end do
    call interval(prof, chimin, zl, zh)
    if (present(cc)) call fit1(y, il, zbest, sbest, nb, nr, lsf, chi, f, m, cc)
    call fit1(y, il, zbest, sbest, nb, nr, lsf, chi, f, m)
  end subroutine

  subroutine joint(y, lsf, zbest, zl, zh, chimin)
    real(dp), intent(in) :: y(:)
    logical, intent(in) :: lsf
    real(dp), intent(out) :: zbest, zl, zh, chimin
    integer :: nzg, iz, is, l, m
    real(dp), allocatable :: prof(:)
    real(dp) :: z, chi, f, best, tot
    nzg = nint((zhi - zlo) / dz) + 1
    allocate(prof(nzg))
    chimin = huge(1.0_dp)
    do iz = 1, nzg
      z = zlo + (iz - 1) * dz
      tot = 0
      do l = 1, 2
        best = huge(1.0_dp)
        do is = 0, 80
          call fit1(y, merge(ilb, ila, l == 1), z, is * 50.0_dp, 12, 12, lsf, chi, f, m)
          best = min(best, chi)
        end do
        tot = tot + best
      end do
      prof(iz) = tot
      if (tot < chimin) then
        chimin = tot; zbest = z
      end if
    end do
    call interval(prof, chimin, zl, zh)
  end subroutine

  subroutine interval(prof, chimin, zl, zh)
    real(dp), intent(in) :: prof(:), chimin
    real(dp), intent(out) :: zl, zh
    integer :: iz, i1, i2
    i1 = 0; i2 = 0
    do iz = 1, size(prof)
      if (prof(iz) <= chimin + 1.0_dp) then
        if (i1 == 0) i1 = iz
        i2 = iz
      end if
    end do
    zl = zlo + (i1 - 1) * dz; zh = zlo + (i2 - 1) * dz
  end subroutine

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
    write(u, '(a)') k // '=' // trim(rtoa(v))
  end subroutine
  subroutine kvz(k, z, zl, zh, s, chi, m)
    character(len=*), intent(in) :: k
    real(dp), intent(in) :: z, zl, zh, s, chi
    integer, intent(in) :: m
    call kvr(k // '.z', z)
    call kvr(k // '.z_lo_dchi2_1', zl)
    call kvr(k // '.z_hi_dchi2_1', zh)
    if (s >= 0) call kvr(k // '.sigma_int_kms', s)
    call kvr(k // '.chi2_min', chi)
    if (m >= 0) call kvi(k // '.npix', m)
    if (zl <= zlo + dz .or. zh >= zhi - dz) call kv(k // '.warning', 'interval_hits_z_grid_edge')
  end subroutine
  function rtoa(v) result(s)
    real(dp), intent(in) :: v
    character(len=32) :: s
    write(s, '(es16.8e2)') v
    s = adjustl(s)
  end function
  function rtoa1(v) result(s)
    real(dp), intent(in) :: v
    character(len=8) :: s
    write(s, '(f3.1)') v
  end function
  function itoa(v) result(s)
    integer, intent(in) :: v
    character(len=:), allocatable :: s
    character(len=12) :: b
    write(b, '(i0)') v
    s = trim(b)
  end function
end program lrd_zinvest
