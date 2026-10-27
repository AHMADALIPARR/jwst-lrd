! SPDX-License-Identifier: AGPL-3.0-only
! Fortran 2018 numeric checks: gravitational redshift arithmetic, Einstein-Rosen throat, and a
! Monte-Carlo ILLUSTRATION (not a proof) of the non-traversability theorem. Units rs = 1 unless stated.
module gr_util
  use, intrinsic :: iso_fortran_env, only: dp => real64, qp => real128
  implicit none
  real(dp), parameter :: pi = 3.14159265358979323846_dp
contains
  ! solve (r-1) e^r = X^2 for r >= 1 (T=0 slice of Kruskal), safeguarded Newton
  function r_of_x(x) result(r)
    real(dp), intent(in) :: x
    real(dp) :: r, lo, hi, f, fp, rn, w
    integer :: it
    w = x*x; lo = 1.0_dp; hi = 2.0_dp
    do while ((hi-1.0_dp)*exp(hi) < w); hi = 2.0_dp*hi; end do
    r = 0.5_dp*(lo+hi)
    do it = 1, 200
      f = (r-1.0_dp)*exp(r) - w; fp = r*exp(r)
      if (f > 0.0_dp) then; hi = r; else; lo = r; end if
      rn = r - f/fp
      if (rn <= lo .or. rn >= hi) rn = 0.5_dp*(lo+hi)
      if (abs(rn-r) <= 1.0e-16_dp*max(1.0_dp,abs(r))) then; r = rn; exit; end if
      r = rn
    end do
  end function
  pure function zgrav(rho) result(z)      ! static emitter at rho = r_e/r_s, observer at infinity
    real(dp), intent(in) :: rho
    real(dp) :: z
    z = 1.0_dp/sqrt(1.0_dp - 1.0_dp/rho) - 1.0_dp
  end function
  pure function l_of_r(r) result(l)       ! proper radial distance from the throat, r >= 1
    real(dp), intent(in) :: r
    real(dp) :: l
    l = sqrt(r*(r-1.0_dp)) + log(sqrt(r) + sqrt(r-1.0_dp))
  end function
end module gr_util

program redshift_er
  use gr_util
  implicit none
  integer :: i, np, nt
  real(dp) :: rho, z, zw, rel, rr, x, a, amin, xmin
  real(dp), parameter :: z_cosmo = 7.04221_dp, z_obs = 7.0451_dp
  real(dp) :: zg_cond, cdv, rho_exact, rho_weak

  ! ---- (1) redshift table: exact vs weak-field --------------------------------------------
  np = 0; nt = 0
  do i = 3, 5
    rho = 10.0_dp**i
    z = zgrav(rho); zw = 0.5_dp/rho
    rel = (z - zw)/z
    nt = nt + 1
    ! leading correction is 3/(4 rho) relative to the first-order term z~1/(2 rho)
    if (abs(rel - 0.75_dp/rho) < 2.0_dp/rho**2) np = np + 1
    write(*,'(A,ES10.3,A,ES14.7,A,ES14.7,A,F9.4,A)') '   rho=', rho, '  z_exact=', z, '  z_weak=1/(2rho)=', zw, &
         '  c*z=', 299792.458_dp*z, ' km/s'
  end do
  call rep('f90-01 exact vs weak-field redshift at rho=1e3,1e4,1e5 (relative gap = 3/(4 rho) to O(rho^-2))', np, nt)

  ! ---- (2) composition and conditional characteristic radius ------------------------------
  np = 0; nt = 0
  zg_cond = (1.0_dp + z_obs)/(1.0_dp + z_cosmo) - 1.0_dp
  cdv = 299792.458_dp*zg_cond
  rho_weak = 1.0_dp/(2.0_dp*zg_cond)
  rho_exact = 1.0_dp/(1.0_dp - (1.0_dp+zg_cond)**(-2))
  write(*,'(A,ES13.6,A,F9.4,A,F10.3,A,F10.3)') '   z_grav(cond)=', zg_cond, '  c*z=', cdv, &
       ' km/s  rho_weak=', rho_weak, '  rho_exact=', rho_exact
  nt = nt+1; if (abs((1.0_dp+z_cosmo)*(1.0_dp+zg_cond) - (1.0_dp+z_obs)) < 1.0e-13_dp) np = np+1
  nt = nt+1; if (abs(zgrav(rho_exact) - zg_cond) < 1.0e-12_dp) np = np+1     ! round trip
  nt = nt+1; if (abs(cdv - 107.7_dp) < 0.2_dp) np = np+1                      ! ~108 km/s
  nt = nt+1; if (abs(rho_weak - 1391.0_dp) < 3.0_dp) np = np+1               ! ~1,390
  nt = nt+1; if (abs(rho_exact/rho_weak - 1.0_dp) < 1.0e-3_dp) np = np+1     ! weak-field accurate to <0.1%
  call rep('f90-02 composition, round trip, ~108 km/s, rho~1391 (CONDITIONAL characteristic radius)', np, nt)

  ! ---- (3) Einstein-Rosen throat on T=0 ----------------------------------------------------
  amin = huge(1.0_dp); xmin = 0.0_dp; np = 0; nt = 0
  do i = -4000, 4000
    x = 0.001_dp*real(i, dp)
    rr = r_of_x(x)
    a = 4.0_dp*pi*rr*rr
    if (a < amin) then; amin = a; xmin = x; end if
    nt = nt+1; if (rr >= 1.0_dp - 1.0e-15_dp .and. abs(rr - r_of_x(-x)) < 1.0e-14_dp) np = np+1
  end do
  call rep('f90-03 ER slice: r>=rs and Z2 symmetry X<->-X on 8001 grid points', np, nt)
  np = 0; nt = 2
  if (abs(amin - 4.0_dp*pi) < 1.0e-12_dp) np = np+1
  if (abs(xmin) < 1.0e-12_dp) np = np+1
  write(*,'(A,ES22.15,A,F8.4,A,ES22.15)') '   min area=', amin, '  at X=', xmin, '  4*pi=', 4.0_dp*pi
  call rep('f90-04 ER throat minimum area = 4 pi rs^2 attained at X=0 (2 conditions)', np, nt)

  ! near-throat proper length l ~ 2 sqrt(rs (r-rs)); and l(r) vs numerical quadrature of 1/sqrt(f)
  np = 0; nt = 0
  block
    integer :: k, m
    real(dp) :: eps, q, rtop, dr, s
    do k = 2, 6
      eps = 10.0_dp**(-k)
      nt = nt+1
      if (abs(l_of_r(1.0_dp+eps)/(2.0_dp*sqrt(eps)) - 1.0_dp) < 2.0_dp*eps) np = np+1
    end do
    ! Simpson in u = sqrt(r-1): dl = sqrt(r/(r-1)) dr = 2 sqrt(1+u^2) du, r = 1+u^2
    rtop = 5.0_dp; m = 2000; dr = sqrt(rtop-1.0_dp)/real(m, dp); s = 0.0_dp
    do k = 0, m
      q = 2.0_dp*sqrt(1.0_dp + (real(k,dp)*dr)**2)
      if (k == 0 .or. k == m) then; s = s + q; else if (mod(k,2) == 1) then; s = s + 4.0_dp*q; else; s = s + 2.0_dp*q; end if
    end do
    s = s*dr/3.0_dp
    nt = nt+1; if (abs(s - l_of_r(rtop)) < 1.0e-9_dp) np = np+1
  end block
  call rep('f90-05 proper length: l ~ 2 sqrt(rs(r-rs)) near throat (5 scales) + closed form vs Simpson (1)', np, nt)

  ! ---- (4) Monte-Carlo illustration of the non-traversability theorem ---------------------
  ! Future-directed causal curves have dU>=0 and dV>=0 at every step. Start in region I (U<0,V>0) and
  ! count curves ending in region III (U>0,V<0): must be zero. Control: allow dU>=0, dV<=0 steps
  ! (spacelike) -> some curves do reach III, showing the test can detect crossings.
  block
    integer, parameter :: ncurve = 200000, nstep = 40
    integer :: c, s, nI3, nI3ctrl, nII, nseed
    integer, allocatable :: seed(:)
    real(dp) :: U, V, u1, v1, dU, dV
    nI3 = 0; nI3ctrl = 0; nII = 0
    call random_seed(size=nseed); allocate(seed(nseed)); seed = 20261026 + 37*[(i, i=1,nseed)]; call random_seed(put=seed)
    do c = 1, ncurve
      call random_number(u1); call random_number(v1)
      U = -(0.01_dp + 2.0_dp*u1); V = 0.01_dp + 2.0_dp*v1
      do s = 1, nstep
        call random_number(u1); call random_number(v1)
        dU = 0.2_dp*u1; dV = 0.2_dp*v1
        U = U + dU; V = V + dV
      end do
      if (U > 0.0_dp .and. V < 0.0_dp) nI3 = nI3 + 1
      if (U > 0.0_dp .and. V > 0.0_dp) nII = nII + 1
    end do
    do c = 1, ncurve
      call random_number(u1); call random_number(v1)
      U = -(0.01_dp + 2.0_dp*u1); V = 0.01_dp + 2.0_dp*v1
      do s = 1, nstep
        call random_number(u1); call random_number(v1)
        U = U + 0.2_dp*u1; V = V - 0.2_dp*v1
      end do
      if (U > 0.0_dp .and. V < 0.0_dp) nI3ctrl = nI3ctrl + 1
    end do
    write(*,'(A,I0,A,I0,A,I0)') '   causal curves I->III: ', nI3, ' of ', ncurve, ';  I->II (infall, allowed): ', nII
    write(*,'(A,I0,A,I0)') '   spacelike control I->III: ', nI3ctrl, ' of ', ncurve
    call rep('f90-06 MC illustration: 0 causal I->III crossings out of 200000', merge(1,0,nI3==0), 1)
    call rep('f90-07 MC control: spacelike steps do reach III (detector works)', merge(1,0,nI3ctrl>0), 1)
  end block

contains
  subroutine rep(name, p, n)
    character(len=*), intent(in) :: name
    integer, intent(in) :: p, n
    if (p == n) then
      write(*,'(A,A,A,I0,A,I0)') 'PASS  ', name, ' : ', p, '/', n
    else
      write(*,'(A,A,A,I0,A,I0)') 'FAIL  ', name, ' : ', p, '/', n
    end if
  end subroutine
end program redshift_er
