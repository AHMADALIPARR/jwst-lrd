! Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
! Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
! SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
!
! causal_interval: closed real intervals [lo,hi] for uncertainty propagation.
!
! Rounding policy (rigorous directed rounding without changing the FPU mode): each
! bound is computed in round-to-nearest, its exact rounding error is recovered with
! an error-free transformation (two_sum / two_prod), and the bound is moved one ulp
! outward (NEAREST intrinsic) only if that error points outward.  Exact results stay
! exact (e.g. coincident events give dt = [0,0]).  Where the error-free
! transformation is not valid (non-finite, |x| > 1e290, |product| < 1e-280) both
! bounds are widened by one ulp unconditionally.  Requires IEEE binary64 arithmetic
! without value-changing optimisations (no -ffast-math).  The error-free
! transformations also require that the compiler does not contract a*b+c into a fused
! multiply-add (that would change the rounding of the split products in two_prod and
! of the two_sum residual); fortran/causal/Makefile therefore passes -ffp-contract=off.
module causal_interval
  use causal_units, only: dp
  use, intrinsic :: ieee_arithmetic, only: ieee_is_nan, ieee_is_finite
  implicit none
  private

  type, public :: interval
    real(dp) :: lo = 0.0_dp
    real(dp) :: hi = 0.0_dp
  end type interval

  public :: iv_point, iv_make, iv_pm, iv_valid, iv_add, iv_sub, iv_neg, iv_scale, &
            iv_sqr, iv_mul, iv_contains, iv_width
  public :: operator(+), operator(-)

  interface operator(+)
    module procedure iv_add
  end interface
  interface operator(-)
    module procedure iv_sub, iv_neg
  end interface

contains
  ! ---- directed rounding via error-free transformations -------------------------
  ! two_sum (Knuth) and two_prod (Dekker/Veltkamp split, no FMA needed) give the
  ! exact rounding error e of s = fl(a op b).  If e == 0 the result is exact and is
  ! NOT widened; otherwise the bound is moved one ulp in the direction of e only.
  ! Where the error-free transformation is not valid (non-finite values, possible
  ! overflow of the split, or underflow), both bounds fall back to one-ulp widening.
  pure subroutine two_sum(a, b, s, e)
    real(dp), intent(in) :: a, b
    real(dp), intent(out) :: s, e
    real(dp) :: bb
    s = a + b
    bb = s - a
    e = (a - (s - bb)) + (b - bb)
  end subroutine two_sum

  pure subroutine split(a, hi, lo)
    real(dp), intent(in) :: a
    real(dp), intent(out) :: hi, lo
    real(dp), parameter :: factor = 134217729.0_dp     ! 2**27 + 1
    real(dp) :: t
    t = factor * a
    hi = t - (t - a)
    lo = a - hi
  end subroutine split

  pure subroutine two_prod(a, b, p, e, exact_ok)
    real(dp), intent(in) :: a, b
    real(dp), intent(out) :: p, e
    logical, intent(out) :: exact_ok
    real(dp) :: ah, al, bh, bl
    p = a * b
    e = 0.0_dp
    exact_ok = .false.
    if (.not. (ieee_is_finite(a) .and. ieee_is_finite(b) .and. ieee_is_finite(p))) return
    if (.not. (abs(a) > 0.0_dp) .or. .not. (abs(b) > 0.0_dp)) then
      exact_ok = .true.          ! exact zero
      return
    end if
    if (abs(a) > 1.0e290_dp .or. abs(b) > 1.0e290_dp) return
    if (abs(p) < 1.0e-280_dp) return
    call split(a, ah, al)
    call split(b, bh, bl)
    e = ((ah * bh - p) + ah * bl + al * bh) + al * bl
    exact_ok = .true.
  end subroutine two_prod

  pure real(dp) function add_dn(a, b)
    real(dp), intent(in) :: a, b
    real(dp) :: s, e
    call two_sum(a, b, s, e)
    if (.not. ieee_is_finite(e)) then
      add_dn = down(s)
    else if (e < 0.0_dp) then
      add_dn = down(s)
    else
      add_dn = s
    end if
  end function add_dn

  pure real(dp) function add_up(a, b)
    real(dp), intent(in) :: a, b
    real(dp) :: s, e
    call two_sum(a, b, s, e)
    if (.not. ieee_is_finite(e)) then
      add_up = up(s)
    else if (e > 0.0_dp) then
      add_up = up(s)
    else
      add_up = s
    end if
  end function add_up

  pure real(dp) function mul_dn(a, b)
    real(dp), intent(in) :: a, b
    real(dp) :: p, e
    logical :: okx
    call two_prod(a, b, p, e, okx)
    if (.not. okx) then
      mul_dn = down(p)
    else if (e < 0.0_dp) then
      mul_dn = down(p)
    else
      mul_dn = p
    end if
  end function mul_dn

  pure real(dp) function mul_up(a, b)
    real(dp), intent(in) :: a, b
    real(dp) :: p, e
    logical :: okx
    call two_prod(a, b, p, e, okx)
    if (.not. okx) then
      mul_up = up(p)
    else if (e > 0.0_dp) then
      mul_up = up(p)
    else
      mul_up = p
    end if
  end function mul_up


  pure real(dp) function down(x)
    real(dp), intent(in) :: x
    if (ieee_is_nan(x)) then
      down = x
    else if (x < -huge(x)) then
      down = x
    else
      down = nearest(x, -1.0_dp)
    end if
  end function down

  pure real(dp) function up(x)
    real(dp), intent(in) :: x
    if (ieee_is_nan(x)) then
      up = x
    else if (x > huge(x)) then
      up = x
    else
      up = nearest(x, 1.0_dp)
    end if
  end function up

  pure function iv_point(x) result(r)
    real(dp), intent(in) :: x
    type(interval) :: r
    r%lo = x
    r%hi = x
  end function iv_point

  ! [lo,hi]; no widening (inputs are taken as exact bounds).
  pure function iv_make(lo, hi) result(r)
    real(dp), intent(in) :: lo, hi
    type(interval) :: r
    r%lo = lo
    r%hi = hi
  end function iv_make

  ! centre +/- halfwidth (halfwidth >= 0), widened outward when halfwidth /= 0.
  pure function iv_pm(c, u) result(r)
    real(dp), intent(in) :: c, u
    type(interval) :: r
    if (.not. (abs(u) > 0.0_dp)) then   ! exact zero half-width
      r = iv_point(c)
    else
      r%lo = add_dn(c, -abs(u))
      r%hi = add_up(c, abs(u))
    end if
  end function iv_pm

  pure logical function iv_valid(a)
    type(interval), intent(in) :: a
    iv_valid = .not. (ieee_is_nan(a%lo) .or. ieee_is_nan(a%hi))
    if (iv_valid) iv_valid = a%lo <= a%hi
  end function iv_valid

  pure function iv_add(a, b) result(r)
    type(interval), intent(in) :: a, b
    type(interval) :: r
    r%lo = add_dn(a%lo, b%lo)
    r%hi = add_up(a%hi, b%hi)
  end function iv_add

  pure function iv_sub(a, b) result(r)
    type(interval), intent(in) :: a, b
    type(interval) :: r
    r%lo = add_dn(a%lo, -b%hi)
    r%hi = add_up(a%hi, -b%lo)
  end function iv_sub

  pure function iv_neg(a) result(r)
    type(interval), intent(in) :: a
    type(interval) :: r
    r%lo = -a%hi
    r%hi = -a%lo
  end function iv_neg

  pure function iv_scale(a, s) result(r)
    type(interval), intent(in) :: a
    real(dp), intent(in) :: s
    type(interval) :: r
    if (s >= 0.0_dp) then
      r%lo = mul_dn(a%lo, s)
      r%hi = mul_up(a%hi, s)
    else
      r%lo = mul_dn(a%hi, s)
      r%hi = mul_up(a%lo, s)
    end if
  end function iv_scale

  ! Exact range of x**2 for x in a (dependency-aware; not a*a).
  pure function iv_sqr(a) result(r)
    type(interval), intent(in) :: a
    type(interval) :: r
    if (a%lo >= 0.0_dp) then
      r%lo = max(0.0_dp, mul_dn(a%lo, a%lo))
      r%hi = mul_up(a%hi, a%hi)
    else if (a%hi <= 0.0_dp) then
      r%lo = max(0.0_dp, mul_dn(a%hi, a%hi))
      r%hi = mul_up(a%lo, a%lo)
    else
      r%lo = 0.0_dp
      r%hi = max(mul_up(a%lo, a%lo), mul_up(a%hi, a%hi))
    end if
  end function iv_sqr

  pure function iv_mul(a, b) result(r)
    type(interval), intent(in) :: a, b
    type(interval) :: r
    r%lo = min(mul_dn(a%lo, b%lo), mul_dn(a%lo, b%hi), mul_dn(a%hi, b%lo), mul_dn(a%hi, b%hi))
    r%hi = max(mul_up(a%lo, b%lo), mul_up(a%lo, b%hi), mul_up(a%hi, b%lo), mul_up(a%hi, b%hi))
  end function iv_mul

  pure logical function iv_contains(a, x)
    type(interval), intent(in) :: a
    real(dp), intent(in) :: x
    iv_contains = a%lo <= x .and. x <= a%hi
  end function iv_contains

  pure real(dp) function iv_width(a)
    type(interval), intent(in) :: a
    iv_width = a%hi - a%lo
  end function iv_width

end module causal_interval
