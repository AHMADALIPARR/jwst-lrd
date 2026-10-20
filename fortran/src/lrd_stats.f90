! SPDX-License-Identifier: AGPL-3.0-only
! Also subject to SNAPKITTY_OPAQUE_LICENSE.md (dual license, see repository root).
!
! Residuals, chi^2, Gaussian log-likelihood, weighted linear least squares and
! information criteria for model comparison.
!   lnL = -1/2 sum[ ((y-m)/s)^2 + ln(2 pi s^2) ]
!   AIC = 2k - 2 lnL ;  BIC = k ln(n) - 2 lnL ;  LR = 2 (lnL_1 - lnL_0)
module lrd_stats
  use lrd_const
  implicit none
  private
  public :: residuals, chi2, gauss_loglike, aic, bic, wlsq, gaussian_profile

contains
  pure function residuals(y, m) result(r)
    real(dp), intent(in) :: y(:), m(:)
    real(dp) :: r(size(y))
    r = y - m
  end function

  pure real(dp) function chi2(y, m, s) result(c)
    real(dp), intent(in) :: y(:), m(:), s(:)
    c = sum(((y - m) / s)**2)
  end function

  pure real(dp) function gauss_loglike(y, m, s) result(l)
    real(dp), intent(in) :: y(:), m(:), s(:)
    l = -0.5_dp * sum(((y - m) / s)**2 + log(2.0_dp * pi * s * s))
  end function

  pure real(dp) function aic(lnl, k) result(a)
    real(dp), intent(in) :: lnl
    integer, intent(in) :: k
    a = 2.0_dp * k - 2.0_dp * lnl
  end function

  pure real(dp) function bic(lnl, k, n) result(b)
    real(dp), intent(in) :: lnl
    integer, intent(in) :: k, n
    b = k * log(real(n, dp)) - 2.0_dp * lnl
  end function

  pure elemental real(dp) function gaussian_profile(x, mu, sig) result(g)
    real(dp), intent(in) :: x, mu, sig
    g = exp(-0.5_dp * ((x - mu) / sig)**2)
  end function

  ! Weighted linear least squares: minimise sum(((y - A p)/s)^2).
  ! Normal equations solved by Gaussian elimination with partial pivoting.
  ! cov = (A^T W A)^-1. info /= 0 if singular.
  pure subroutine wlsq(a, y, s, p, cov, info)
    real(dp), intent(in) :: a(:, :), y(:), s(:)
    real(dp), intent(out) :: p(size(a, 2)), cov(size(a, 2), size(a, 2))
    integer, intent(out) :: info
    integer :: k, i, j, piv
    real(dp) :: m(size(a, 2), 2 * size(a, 2) + 1), w(size(y)), f, tmp(2 * size(a, 2) + 1)
    k = size(a, 2)
    w = 1.0_dp / (s * s)
    m = 0.0_dp
    do i = 1, k
      do j = 1, k
        m(i, j) = sum(a(:, i) * a(:, j) * w)
      end do
      m(i, k + i) = 1.0_dp
      m(i, 2 * k + 1) = sum(a(:, i) * y * w)
    end do
    info = 0
    do i = 1, k
      piv = i - 1 + maxloc(abs(m(i:k, i)), 1)
      if (abs(m(piv, i)) < tiny(1.0_dp) * 1.0e10_dp) then
        info = 1
        p = 0.0_dp; cov = 0.0_dp
        return
      end if
      if (piv /= i) then
        tmp = m(i, :); m(i, :) = m(piv, :); m(piv, :) = tmp
      end if
      m(i, :) = m(i, :) / m(i, i)
      do j = 1, k
        if (j /= i) then
          f = m(j, i)
          m(j, :) = m(j, :) - f * m(i, :)
        end if
      end do
    end do
    p = m(:, 2 * k + 1)
    cov = m(:, k + 1:2 * k)
  end subroutine
end module lrd_stats
