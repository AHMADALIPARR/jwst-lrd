! Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
! SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
! Licensed under AGPL-3.0-only plus the SnapKitty Opaque License (dual license, intentional).
! See LICENSE and SNAPKITTY_OPAQUE_LICENSE.md at the repository root.
!
! topo_field: declared coefficient fields and exact linear algebra over them.
!   FIELD_GFP : GF(p) for a prime p (GF(2) is p = 2), p < 2**31 so products fit int64.
!   FIELD_Q   : the rationals, by fraction-free (Bareiss) elimination in 128-bit
!               integers with every multiply overflow-checked and every division
!               checked for exactness. Overflow is reported, never silently wrapped.
module topo_field
  use, intrinsic :: iso_fortran_env, only: int64
  implicit none
  private
  integer, parameter, public :: i128 = selected_int_kind(38)
  integer, parameter, public :: FIELD_GFP = 1, FIELD_Q = 2
  integer, parameter, public :: FERR_OK = 0, FERR_NOT_PRIME = 8, FERR_OVERFLOW = 10

  type, public :: field_t
    integer :: kind = FIELD_GFP
    integer(int64) :: p = 2
  end type field_t

  public :: is_prime, make_gfp, make_q, field_name, rank_over, rank_modp, rank_q, &
            nullspace_modp, inv_modp, modp

contains

  pure logical function is_prime(n)
    integer(int64), intent(in) :: n
    integer(int64) :: d
    is_prime = .false.
    if (n < 2) return
    if (n < 4) then
      is_prime = .true.; return
    end if
    if (mod(n, 2_int64) == 0) return
    d = 3
    do while (d * d <= n)
      if (mod(n, d) == 0) return
      d = d + 2
    end do
    is_prime = .true.
  end function is_prime

  !> Declare GF(p). Rejects non-primes and p >= 2**31 with FERR_NOT_PRIME.
  subroutine make_gfp(p, f, err)
    integer(int64), intent(in) :: p
    type(field_t), intent(out) :: f
    integer, intent(out) :: err
    f%kind = FIELD_GFP
    f%p = p
    err = FERR_OK
    if (.not. is_prime(p) .or. p >= 2147483648_int64) then
      err = FERR_NOT_PRIME
      f%p = 0
    end if
  end subroutine make_gfp

  function make_q() result(f)
    type(field_t) :: f
    f%kind = FIELD_Q
    f%p = 0
  end function make_q

  function field_name(f) result(s)
    type(field_t), intent(in) :: f
    character(len=:), allocatable :: s
    character(len=32) :: buf
    if (f%kind == FIELD_Q) then
      s = 'Q'
    else
      write(buf, '(i0)') f%p
      s = 'GF(' // trim(buf) // ')'
    end if
  end function field_name

  pure integer(int64) function modp(a, p)
    integer(int64), intent(in) :: a, p
    modp = modulo(a, p)
  end function modp

  !> Modular inverse by extended Euclid; a must be nonzero mod p.
  pure integer(int64) function inv_modp(a, p)
    integer(int64), intent(in) :: a, p
    integer(int64) :: t, nt, r, nr, q, tmp
    t = 0; nt = 1; r = p; nr = modulo(a, p)
    do while (nr /= 0)
      q = r / nr
      tmp = t - q * nt; t = nt; nt = tmp
      tmp = r - q * nr; r = nr; nr = tmp
    end do
    inv_modp = modulo(t, p)
  end function inv_modp

  !> Exact rank of an integer matrix reduced mod p (Gaussian elimination).
  integer function rank_modp(a, p) result(r)
    integer(int64), intent(in) :: a(:,:)
    integer(int64), intent(in) :: p
    integer(int64), allocatable :: m(:,:), tmp(:)
    integer(int64) :: inv, fac
    integer :: nr, nc, row, col, i, piv
    nr = size(a, 1); nc = size(a, 2)
    r = 0
    if (nr == 0 .or. nc == 0) return
    m = modulo(a, p)
    allocate(tmp(nc))
    row = 1
    do col = 1, nc
      if (row > nr) exit
      piv = 0
      do i = row, nr
        if (m(i, col) /= 0) then
          piv = i; exit
        end if
      end do
      if (piv == 0) cycle
      if (piv /= row) then
        tmp = m(row, :); m(row, :) = m(piv, :); m(piv, :) = tmp
      end if
      inv = inv_modp(m(row, col), p)
      m(row, :) = modulo(m(row, :) * inv, p)
      do i = row + 1, nr
        if (m(i, col) /= 0) then
          fac = m(i, col)
          m(i, col:) = modulo(m(i, col:) - fac * m(row, col:), p)
        end if
      end do
      row = row + 1
    end do
    r = row - 1
  end function rank_modp

  !> checked 128-bit multiply
  subroutine cmul(a, b, c, ok)
    integer(i128), intent(in) :: a, b
    integer(i128), intent(out) :: c
    logical, intent(inout) :: ok
    if (a /= 0 .and. abs(b) > huge(a) / abs(a)) then
      ok = .false.; c = 0; return
    end if
    c = a * b
  end subroutine cmul

  !> Exact rank over Q by Bareiss fraction-free elimination (Sylvester identity
  !> guarantees exact divisions; this is asserted at run time).
  integer function rank_q(a, err) result(r)
    integer(int64), intent(in) :: a(:,:)
    integer, intent(out) :: err
    integer(i128), allocatable :: m(:,:), tmp(:)
    integer(i128) :: prev, x, y, num
    integer :: nr, nc, row, col, i, j, piv
    logical :: ok
    err = FERR_OK
    nr = size(a, 1); nc = size(a, 2)
    r = 0
    if (nr == 0 .or. nc == 0) return
    allocate(m(nr, nc), tmp(nc))
    m = int(a, i128)
    prev = 1
    row = 1
    ok = .true.
    do col = 1, nc
      if (row > nr) exit
      piv = 0
      do i = row, nr
        if (m(i, col) /= 0) then
          piv = i; exit
        end if
      end do
      if (piv == 0) cycle
      if (piv /= row) then
        tmp = m(row, :); m(row, :) = m(piv, :); m(piv, :) = tmp
      end if
      do i = row + 1, nr
        do j = col + 1, nc
          call cmul(m(i, j), m(row, col), x, ok)
          call cmul(m(i, col), m(row, j), y, ok)
          if (.not. ok) then
            err = FERR_OVERFLOW; return
          end if
          num = x - y
          if (mod(num, prev) /= 0) then
            err = FERR_OVERFLOW; return   ! cannot happen for exact Bareiss; treat as failure
          end if
          m(i, j) = num / prev
        end do
        m(i, col) = 0
      end do
      prev = m(row, col)
      row = row + 1
    end do
    r = row - 1
  end function rank_q

  integer function rank_over(a, f, err) result(r)
    integer(int64), intent(in) :: a(:,:)
    type(field_t), intent(in) :: f
    integer, intent(out) :: err
    err = FERR_OK
    if (f%kind == FIELD_Q) then
      r = rank_q(a, err)
    else
      if (.not. is_prime(f%p)) then
        err = FERR_NOT_PRIME; r = -1; return
      end if
      r = rank_modp(a, f%p)
    end if
  end function rank_over

  !> Basis of the right null space {x : A x = 0 mod p}; columns of z (nc x nullity).
  subroutine nullspace_modp(a, p, z)
    integer(int64), intent(in) :: a(:,:)
    integer(int64), intent(in) :: p
    integer(int64), allocatable, intent(out) :: z(:,:)
    integer(int64), allocatable :: m(:,:), tmp(:)
    integer, allocatable :: pivcol(:)
    logical, allocatable :: ispiv(:)
    integer(int64) :: inv, fac
    integer :: nr, nc, row, col, i, piv, nfree, kfree, rk
    nr = size(a, 1); nc = size(a, 2)
    allocate(ispiv(nc), pivcol(max(nr,1)))
    ispiv = .false.
    rk = 0
    if (nr > 0 .and. nc > 0) then
      m = modulo(a, p)
      allocate(tmp(nc))
      row = 1
      do col = 1, nc
        if (row > nr) exit
        piv = 0
        do i = row, nr
          if (m(i, col) /= 0) then
            piv = i; exit
          end if
        end do
        if (piv == 0) cycle
        if (piv /= row) then
          tmp = m(row, :); m(row, :) = m(piv, :); m(piv, :) = tmp
        end if
        inv = inv_modp(m(row, col), p)
        m(row, :) = modulo(m(row, :) * inv, p)
        do i = 1, nr
          if (i /= row .and. m(i, col) /= 0) then
            fac = m(i, col)
            m(i, :) = modulo(m(i, :) - fac * m(row, :), p)
          end if
        end do
        ispiv(col) = .true.; pivcol(row) = col
        row = row + 1
      end do
      rk = row - 1
    end if
    nfree = nc - rk
    allocate(z(nc, nfree))
    z = 0
    kfree = 0
    do col = 1, nc
      if (ispiv(col)) cycle
      kfree = kfree + 1
      z(col, kfree) = 1
      do i = 1, rk
        z(pivcol(i), kfree) = modulo(-m(i, col), p)
      end do
    end do
  end subroutine nullspace_modp

end module topo_field
