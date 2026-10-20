! Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
! SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
! Licensed under AGPL-3.0-only plus the SnapKitty Opaque License (dual license, intentional).
! See LICENSE and SNAPKITTY_OPAQUE_LICENSE.md at the repository root.
!
! topo_homology: simplicial homology over a declared coefficient field.
!   betti_k = dim C_k - rank d_k - rank d_{k+1}, ranks exact over the field.
! NOTE: field coefficients do not see integer torsion as such.  Over GF(p) a Z/p
! torsion summand of H_{k} contributes to both b_k and b_{k+1}; over Q it is
! invisible.  Integer homology (Smith normal form) is NOT computed here.
module topo_homology
  use, intrinsic :: iso_fortran_env, only: int64
  use topo_field
  use topo_complex
  implicit none
  private
  public :: compute_betti, compute_ranks, homology_reps, euler_char

contains

  !> ranks(k) = rank of d_k over the field, k = 0..MAXD+1 (rank d_0 = 0).
  subroutine compute_ranks(c, f, ranks, err)
    type(complex_t), intent(in) :: c
    type(field_t), intent(in) :: f
    integer, intent(out) :: ranks(0:MAXD+1)
    integer, intent(out) :: err
    integer(int64), allocatable :: b(:,:)
    integer :: k, e
    ranks = 0; err = 0
    do k = 1, MAXD
      if (count_dim(c, k) == 0) cycle
      call boundary_matrix(c, k, b)
      ranks(k) = rank_over(b, f, e)
      if (e /= 0) then
        err = e; return
      end if
    end do
  end subroutine compute_ranks

  subroutine compute_betti(c, f, betti, err)
    type(complex_t), intent(in) :: c
    type(field_t), intent(in) :: f
    integer, intent(out) :: betti(0:MAXD)
    integer, intent(out) :: err
    integer :: ranks(0:MAXD+1), k
    call compute_ranks(c, f, ranks, err)
    do k = 0, MAXD
      betti(k) = count_dim(c, k) - ranks(k) - ranks(k+1)
    end do
  end subroutine compute_betti

  integer function euler_char(c) result(chi)
    type(complex_t), intent(in) :: c
    integer :: k
    chi = 0
    do k = 0, MAXD
      chi = chi + (1 - 2 * mod(k, 2)) * count_dim(c, k)
    end do
  end function euler_char

  !> Homology representatives over GF(p): columns of reps (n_k x b_k) are cycles of
  !> ker d_k whose classes form a basis of H_k = ker d_k / im d_{k+1}.  Greedy:
  !> a kernel basis vector is kept iff it raises rank([im d_{k+1} | kept]).
  subroutine homology_reps(c, k, p, reps)
    type(complex_t), intent(in) :: c
    integer, intent(in) :: k
    integer(int64), intent(in) :: p
    integer(int64), allocatable, intent(out) :: reps(:,:)
    integer(int64), allocatable :: dk(:,:), dk1(:,:), z(:,:), acc(:,:), trial(:,:)
    integer :: nk, j, r0, nkept, ncols
    nk = count_dim(c, k)
    if (k == 0) then
      allocate(dk(1, nk)); dk = 0     ! d_0 = 0: every 0-chain is a cycle
    else
      call boundary_matrix(c, k, dk)
    end if
    call nullspace_modp(dk, p, z)
    if (count_dim(c, k + 1) > 0) then
      call boundary_matrix(c, k + 1, dk1)
    else
      allocate(dk1(nk, 0))
    end if
    ncols = size(dk1, 2)
    allocate(acc(nk, ncols + size(z, 2)))
    acc = 0
    if (ncols > 0) acc(:, 1:ncols) = modulo(dk1, p)
    r0 = rank_modp(acc(:, 1:ncols), p)
    nkept = 0
    do j = 1, size(z, 2)
      allocate(trial(nk, ncols + nkept + 1))
      trial(:, 1:ncols + nkept) = acc(:, 1:ncols + nkept)
      trial(:, ncols + nkept + 1) = z(:, j)
      if (rank_modp(trial, p) > r0) then
        nkept = nkept + 1
        acc(:, ncols + nkept) = z(:, j)
        r0 = r0 + 1
      end if
      deallocate(trial)
    end do
    allocate(reps(nk, nkept))
    reps = acc(:, ncols + 1:ncols + nkept)
  end subroutine homology_reps

end module topo_homology
