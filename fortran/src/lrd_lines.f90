! SPDX-License-Identifier: AGPL-3.0-only
! Also subject to SNAPKITTY_OPAQUE_LICENSE.md (dual license, see repository root).
!
! Emission-line measurement and identification on a 1-D spectrum.
! Rest wavelengths: NIST Atomic Spectra Database ver. 5.12 (Kramida, Ralchenko, Reader and
! NIST ASD Team), Ritz vacuum wavelengths, retrieved 2026-10-19; raw query outputs are kept
! in fortran/data/nist/*.csv. H I values are the blended n-n' multiplet entries.
module lrd_lines
  use lrd_const
  use lrd_stats, only: wlsq
  implicit none
  private
  public :: nlines, line_name, line_vac_ang, line_measure, find_peaks, identify_redshift, &
            local_continuum

  integer, parameter :: nlines = 5
  character(len=10), parameter :: line_name(nlines) = &
       [character(len=10) :: 'Hgamma', 'Hbeta', 'OIII4960', 'OIII5008', 'Halpha']
  real(dp), parameter :: line_vac_ang(nlines) = &
       [4341.691_dp, 4862.691_dp, 4960.295_dp, 5008.240_dp, 6564.632_dp]

contains
  ! Linear continuum fitted by weighted least squares to the side bands
  ! [c-hw-sw, c-hw) and (c+hw, c+hw+sw]; returns intercept/slope about x0=c and covariance.
  subroutine local_continuum(x, y, e, ok, c, hw, sw, p, cov, nside, info)
    real(dp), intent(in) :: x(:), y(:), e(:), c, hw, sw
    logical, intent(in) :: ok(:)
    real(dp), intent(out) :: p(2), cov(2, 2)
    integer, intent(out) :: nside, info
    logical :: side(size(x))
    real(dp), allocatable :: a(:, :)
    side = ok .and. ((x >= c - hw - sw .and. x < c - hw) .or. (x > c + hw .and. x <= c + hw + sw))
    nside = count(side)
    if (nside < 3) then
      info = 2; p = 0; cov = 0; return
    end if
    allocate(a(nside, 2))
    a(:, 1) = 1.0_dp
    a(:, 2) = pack(x, side) - c
    call wlsq(a, pack(y, side), pack(e, side), p, cov, info)
  end subroutine

  ! Continuum-subtracted flux-weighted centroid and integrated flux in |x-c| <= hw.
  ! Bin widths dx_i from midpoints. Errors: first-order propagation of the per-pixel
  ! errors e_i (independent) and of the continuum covariance.
  !   F = sum f_i dx_i,  f_i = y_i - cont_i,   var F = sum (e_i dx_i)^2 + g^T Ccont g
  !   xc = sum x_i f_i dx_i / F,   var xc = sum ((x_i - xc) dx_i / F)^2 (e_i^2 + var cont_i)
  subroutine line_measure(x, y, e, ok, c, hw, sw, flux, eflux, xc, exc, npix, info)
    real(dp), intent(in) :: x(:), y(:), e(:), c, hw, sw
    logical, intent(in) :: ok(:)
    real(dp), intent(out) :: flux, eflux, xc, exc
    integer, intent(out) :: npix, info
    real(dp) :: p(2), cov(2, 2), dx(size(x)), f(size(x)), vc(size(x)), g(2)
    logical :: inl(size(x))
    integer :: i, n, nside
    n = size(x)
    flux = 0; eflux = 0; xc = 0; exc = 0; npix = 0
    call local_continuum(x, y, e, ok, c, hw, sw, p, cov, nside, info)
    if (info /= 0) return
    do i = 1, n
      if (i == 1) then
        dx(i) = x(2) - x(1)
      else if (i == n) then
        dx(i) = x(n) - x(n - 1)
      else
        dx(i) = 0.5_dp * (x(i + 1) - x(i - 1))
      end if
    end do
    inl = ok .and. abs(x - c) <= hw
    npix = count(inl)
    if (npix < 2) then
      info = 3; return
    end if
    f = y - (p(1) + p(2) * (x - c))
    vc = cov(1, 1) + 2 * cov(1, 2) * (x - c) + cov(2, 2) * (x - c)**2
    flux = sum(f * dx, mask=inl)
    g(1) = -sum(dx, mask=inl)
    g(2) = -sum((x - c) * dx, mask=inl)
    eflux = sqrt(sum((e * dx)**2, mask=inl) + dot_product(g, matmul(cov, g)))
    if (flux <= 0) then
      info = 4; return
    end if
    xc = sum(x * f * dx, mask=inl) / flux
    exc = sqrt(sum((((x - xc) * dx / flux)**2) * (e**2 + vc), mask=inl))
  end subroutine

  ! Peaks: pixels that are local maxima of (y - local continuum)/e with S/N >= snmin.
  ! Local continuum for pixel i: weighted linear fit to pixels i-ko..i-ki and i+ki..i+ko.
  subroutine find_peaks(x, y, e, ok, ki, ko, snmin, ipk, npk)
    real(dp), intent(in) :: x(:), y(:), e(:), snmin
    logical, intent(in) :: ok(:)
    integer, intent(in) :: ki, ko
    integer, intent(out) :: ipk(:), npk
    real(dp) :: sn(size(x)), p(2), cov(2, 2)
    real(dp), allocatable :: a(:, :), yy(:), ee(:)
    logical :: sel(size(x))
    integer :: i, j, n, m, info
    n = size(x)
    sn = -huge(1.0_dp)
    do i = 1 + ko, n - ko
      if (.not. ok(i)) cycle
      sel = .false.
      do j = i - ko, i - ki
        sel(j) = ok(j)
      end do
      do j = i + ki, i + ko
        sel(j) = ok(j)
      end do
      m = count(sel)
      if (m < 4) cycle
      allocate(a(m, 2), yy(m), ee(m))
      a(:, 1) = 1; a(:, 2) = pack(x, sel) - x(i)
      yy = pack(y, sel); ee = pack(e, sel)
      call wlsq(a, yy, ee, p, cov, info)
      if (info == 0) sn(i) = (y(i) - p(1)) / sqrt(e(i)**2 + cov(1, 1))
      deallocate(a, yy, ee)
    end do
    npk = 0
    do i = 2, n - 1
      if (sn(i) >= snmin .and. sn(i) >= sn(i - 1) .and. sn(i) > sn(i + 1)) then
        if (npk < size(ipk)) then
          npk = npk + 1
          ipk(npk) = i
        end if
      end if
    end do
  end subroutine

  ! Identification: every (peak, line) pair proposes z = x_peak/lambda_rest - 1 in [zmin, zmax].
  ! A proposal's score is the number of catalogue lines whose redshifted wavelength lies within
  ! tol_pix local pixel widths of some peak; best = highest score, ties -> smallest summed
  ! squared offset (in pixels). Returns the best z and the matched peak index per line (0 = none).
  subroutine identify_redshift(x, ipk, npk, lrest, zmin, zmax, tol_pix, zbest, score, match)
    real(dp), intent(in) :: x(:), lrest(:), zmin, zmax, tol_pix
    integer, intent(in) :: ipk(:), npk
    real(dp), intent(out) :: zbest
    integer, intent(out) :: score, match(size(lrest))
    integer :: a, b, l, k, s, m(size(lrest)), j
    real(dp) :: z, cost, best_cost, pred, d, pw, dbest
    score = 0; zbest = -1; best_cost = huge(1.0_dp); match = 0
    do a = 1, npk
      do b = 1, size(lrest)
        z = x(ipk(a)) / lrest(b) - 1.0_dp
        if (z < zmin .or. z > zmax) cycle
        s = 0; cost = 0; m = 0
        do l = 1, size(lrest)
          pred = lrest(l) * (1.0_dp + z)
          dbest = huge(1.0_dp)
          do k = 1, npk
            j = ipk(k)
            pw = merge(x(j + 1) - x(j), x(j) - x(j - 1), j < size(x))
            d = abs(x(j) - pred) / pw
            if (d <= tol_pix .and. d < dbest) then
              dbest = d; m(l) = k
            end if
          end do
          if (m(l) > 0) then
            s = s + 1; cost = cost + dbest**2
          end if
        end do
        if (s > score .or. (s == score .and. cost < best_cost)) then
          score = s; best_cost = cost; zbest = z; match = m
        end if
      end do
    end do
  end subroutine
end module lrd_lines
