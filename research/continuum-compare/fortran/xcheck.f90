! SPDX-License-Identifier: AGPL-3.0-only
! xcheck.f90 -- independent Fortran 2018 joint (Hbeta+Halpha) Gaussian-line fit with a simultaneous polynomial continuum of order 0..3,
! used ONLY to cross-check the Octave engine (PREREG section 8).  Own grids, own template, own linear solver; shares no code with Octave.
! usage: xcheck <cc_input.tsv> <order 0..3> <ndrop>      (cc_input cols: idx wl_A flam eflam ok errJy)
! Model per window: flam = sum_i c_i x^i + A*T(z,sigma_int), A>=0, weights 1/eflam^2, sigma_int profiled on 0..4000 step 100 km/s,
! z grid 7.020..7.065 step 1e-5.  Rest wavelengths: NIST ASD v5.12 Ritz VACUUM (Kramida, Ralchenko, Reader & NIST ASD Team).
program xcheck
  use, intrinsic :: iso_fortran_env, only: real64, int32
  implicit none
  integer, parameter :: dp = real64
  real(dp), parameter :: rest(2) = [4862.691_dp, 6564.632_dp], zref = 7.0422_dp, ckms = 299792.458_dp
  real(dp), parameter :: fw2s = 2.3548200450309493_dp, lsfpx = 2.2_dp
  integer, parameter :: nzg = 4500, nsg = 41
  character(len=512) :: fn, a1, a2
  integer :: n, i, ord, ndrop, ios, k, nv, iz, is, line, nw(2)
  real(dp), allocatable :: lam(:), fl(:), er(:), chi(:,:)
  integer, allocatable :: idx(:), okv(:)
  logical, allocatable :: ok(:)
  integer :: lo(2), hi(2), c
  real(dp) :: z, sg, cmin, a, b, cc, den, zbest, f
  real(dp) :: ctot(nzg), zlo, zhi
  call get_command_argument(1, fn); call get_command_argument(2, a1); call get_command_argument(3, a2)
  read(a1, *) ord; read(a2, *) ndrop
  open(10, file=trim(fn), status='old', action='read', iostat=ios)
  if (ios /= 0) stop 'cannot open input'
  n = 0
  do
    read(10, *, iostat=ios) i, a, b, cc, den, f
    if (ios /= 0) exit
    n = n + 1
  end do
  rewind(10)
  allocate(lam(n), fl(n), er(n), idx(n), okv(n), ok(n))
  do k = 1, n
    read(10, *) idx(k), lam(k), fl(k), er(k), a, f
    okv(k) = nint(a); ok(k) = (okv(k) == 1)
  end do
  close(10)
  nv = count(ok)
  k = 0
  do i = n, 1, -1
    if (k >= ndrop) exit
    if (ok(i)) then; ok(i) = .false.; k = k + 1; end if
  end do
  allocate(chi(nzg, 2))
  do line = 1, 2
    c = minloc(abs(lam - rest(line)*(1.0_dp + zref)), 1)
    if (line == 1) then; lo(1) = c - 12; hi(1) = c + 6; else; lo(2) = c - 12; hi(2) = c + 12; end if
    do iz = 1, nzg
      z = 7.020_dp + 1.0e-5_dp*(iz - 1)
      cmin = huge(1.0_dp)
      do is = 0, nsg - 1
        sg = 100.0_dp*is
        cc = wchi2(line, c, lo(line), hi(line), z, sg)
        if (cc < cmin) cmin = cc
      end do
      chi(iz, line) = cmin
    end do
    nw(line) = count(ok(max(lo(line),2):min(hi(line),n-1)))
  end do
  ctot = chi(:,1) + chi(:,2)
  call peak(ctot, zbest, cmin, zlo, zhi)
  write(*, '(a,i0,a,i0,a,i0,a,i0)', advance='no') 'XCHECK order=', ord, ' ndrop=', ndrop, ' nHb=', nw(1), ' nHa=', nw(2)
  write(*, '(a,f10.6,a,f9.6,a,f9.6,a,f9.4)') ' zJ=', zbest, ' lo=', zlo, ' hi=', zhi, ' chi2=', cmin
  call peak(chi(:,1), zbest, cmin, zlo, zhi)
  write(*, '(a,f10.6,a,f9.4)') 'XCHECK   zHb=', zbest, ' chi2=', cmin
  call peak(chi(:,2), zbest, cmin, zlo, zhi)
  write(*, '(a,f10.6,a,f9.4)') 'XCHECK   zHa=', zbest, ' chi2=', cmin
contains
  real(dp) function wchi2(line, c, p0, p1, z, sgint) result(r)
    integer, intent(in) :: line, c, p0, p1
    real(dp), intent(in) :: z, sgint
    integer :: np, m, p, j, l, nn
    real(dp) :: mu, pwc, sl, s, x, w, t, d, pw, e1, e2
    real(dp) :: G(5,5), g0(5), sol(5)
    np = ord + 2                         ! ord+1 polynomial coefficients + amplitude
    mu = rest(line)*(1.0_dp + z); pwc = 0.5_dp*(lam(c+1) - lam(c-1)); sl = lsfpx*pwc/fw2s
    s = sqrt(sl**2 + (sgint/ckms*mu)**2)
    G = 0; g0 = 0; r = 0
    nn = 0
    do p = max(p0,2), min(p1,n-1)
      if (.not. ok(p)) cycle
      nn = nn + 1
      w = 1.0_dp/er(p)**2; d = fl(p)
      pw = 0.5_dp*(lam(p+1) - lam(p-1))
      e1 = 0.5_dp*(lam(p-1) + lam(p)); e2 = 0.5_dp*(lam(p) + lam(p+1))
      t = (0.5_dp*erfc(-(e2 - mu)/(s*sqrt(2.0_dp))) - 0.5_dp*erfc(-(e1 - mu)/(s*sqrt(2.0_dp))))/pw
      x = (lam(p) - lam(c))/pwc/12.0_dp
      do j = 1, np
        do l = 1, np
          G(j,l) = G(j,l) + w*basis(j, x, t)*basis(l, x, t)
        end do
        g0(j) = g0(j) + w*basis(j, x, t)*d
      end do
      r = r + w*d*d
    end do
    ! with amplitude (last coordinate)
    sol(1:np) = solve(G(1:np,1:np), g0(1:np), np)
    if (sol(np) >= 0.0_dp) then
      r = r - dot_product(sol(1:np), g0(1:np))
    else
      m = np - 1
      sol(1:m) = solve(G(1:m,1:m), g0(1:m), m)
      r = r - dot_product(sol(1:m), g0(1:m))
    end if
  end function wchi2
  real(dp) function basis(j, x, t) result(b)
    integer, intent(in) :: j
    real(dp), intent(in) :: x, t
    if (j == ord + 2) then; b = t; else; b = x**(j - 1); end if
  end function basis
  function solve(A0, b0, m) result(xv)           ! Gaussian elimination with partial pivoting
    integer, intent(in) :: m
    real(dp), intent(in) :: A0(m,m), b0(m)
    real(dp) :: xv(m), A(m,m+1), tmp(m+1)
    integer :: i, j, kp
    A(:,1:m) = A0; A(:,m+1) = b0
    do i = 1, m
      kp = i - 1 + maxloc(abs(A(i:m,i)), 1)
      if (kp /= i) then; tmp = A(i,:); A(i,:) = A(kp,:); A(kp,:) = tmp; end if
      do j = i + 1, m
        A(j,:) = A(j,:) - A(j,i)/A(i,i)*A(i,:)
      end do
    end do
    do i = m, 1, -1
      xv(i) = (A(i,m+1) - dot_product(A(i,i+1:m), xv(i+1:m)))/A(i,i)
    end do
  end function solve
  subroutine peak(ch, zb, cm, zl, zh)
    real(dp), intent(in) :: ch(nzg)
    real(dp), intent(out) :: zb, cm, zl, zh
    integer :: g, k
    real(dp) :: aa, bb, cq, dn, tg, ff
    g = minloc(ch, 1); zb = 7.020_dp + 1.0e-5_dp*(g - 1); cm = ch(g); zl = -1; zh = -1
    if (g > 1 .and. g < nzg) then
      aa = ch(g-1); bb = ch(g); cq = ch(g+1); dn = aa - 2*bb + cq
      if (dn > 0) then; zb = zb - 0.5e-5_dp*(cq - aa)/dn; cm = bb - (cq - aa)**2/(8*dn); end if
    end if
    tg = cm + 1
    do k = g, 2, -1
      if (ch(k-1) > tg) then; ff = (tg - ch(k))/(ch(k-1) - ch(k)); zl = 7.020_dp + 1.0e-5_dp*(k - 1) - ff*1.0e-5_dp; exit; end if
    end do
    do k = g, nzg - 1
      if (ch(k+1) > tg) then; ff = (tg - ch(k))/(ch(k+1) - ch(k)); zh = 7.020_dp + 1.0e-5_dp*(k - 1) + ff*1.0e-5_dp; exit; end if
    end do
  end subroutine peak
end program xcheck
