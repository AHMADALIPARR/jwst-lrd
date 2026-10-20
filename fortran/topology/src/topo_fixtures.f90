! Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
! SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
! Licensed under AGPL-3.0-only plus the SnapKitty Opaque License (dual license, intentional).
! See LICENSE and SNAPKITTY_OPAQUE_LICENSE.md at the repository root.
!
! topo_fixtures: SYNTHETIC test complexes (exact combinatorial constructions, not
! observational data).  Every fixture name starts with SYNTHETIC_.
module topo_fixtures
  use, intrinsic :: iso_fortran_env, only: int64
  use topo_complex
  implicit none
  private
  integer, parameter, public :: NFIX = 14
  character(len=40), parameter, public :: FIXTURES(NFIX) = [character(len=40) :: &
    'SYNTHETIC_vertex', 'SYNTHETIC_two_vertices', 'SYNTHETIC_edge', &
    'SYNTHETIC_hollow_triangle', 'SYNTHETIC_filled_triangle', 'SYNTHETIC_tetra_boundary', &
    'SYNTHETIC_solid_tetra', 'SYNTHETIC_hollow_square', 'SYNTHETIC_hollow_triangle_relab', &
    'SYNTHETIC_rp2_6v', 'SYNTHETIC_torus_7v', 'SYNTHETIC_torus_grid3x3', &
    'SYNTHETIC_klein_grid4x4', 'SYNTHETIC_random_seed20261019']
  public :: build_fixture, rp2_triangles, torus7_triangles, lcg_next

contains

  subroutine addc(c, v, ok)
    type(complex_t), intent(inout) :: c
    integer(int64), intent(in) :: v(:)
    logical, intent(inout) :: ok
    integer :: e
    call add_closure(c, v, e)
    if (e /= TERR_OK) ok = .false.
  end subroutine addc

  function rp2_triangles() result(t)
    integer(int64) :: t(3, 10)
    ! minimal 6-vertex RP^2 (hemi-icosahedron), labels 1..6
    t = reshape(int([1,2,4, 1,2,6, 1,3,5, 1,3,6, 1,4,5, 2,3,4, 2,3,5, 2,5,6, 3,4,6, 4,5,6], &
                int64), [3, 10])
  end function rp2_triangles

  function torus7_triangles() result(t)
    integer(int64) :: t(3, 14)
    integer :: i
    ! Moebius-Csaszar 7-vertex torus: {i,i+1,i+3}, {i,i+2,i+3} mod 7
    do i = 0, 6
      t(:, 2*i+1) = int([i, mod(i+1,7), mod(i+3,7)], int64)
      t(:, 2*i+2) = int([i, mod(i+2,7), mod(i+3,7)], int64)
    end do
  end function torus7_triangles

  !> minstd LCG: x <- 48271 x mod (2^31-1)
  integer(int64) function lcg_next(x)
    integer(int64), intent(inout) :: x
    x = mod(48271_int64 * x, 2147483647_int64)
    lcg_next = x
  end function lcg_next

  integer(int64) function gid(i, j, n, m, flip)
    integer, intent(in) :: i, j, n, m
    logical, intent(in) :: flip
    integer :: ii, jj
    ii = modulo(i, n); jj = j
    if (jj >= m) then
      jj = jj - m
      if (flip) ii = modulo(n - ii, n)
    end if
    gid = int(jj * n + ii, int64)
  end function gid

  subroutine grid_surface(c, n, m, flip, ok)
    type(complex_t), intent(inout) :: c
    integer, intent(in) :: n, m
    logical, intent(in) :: flip
    logical, intent(inout) :: ok
    integer :: i, j
    do j = 0, m - 1
      do i = 0, n - 1
        call addc(c, [gid(i,j,n,m,flip), gid(i+1,j,n,m,flip), gid(i+1,j+1,n,m,flip)], ok)
        call addc(c, [gid(i,j,n,m,flip), gid(i,j+1,n,m,flip), gid(i+1,j+1,n,m,flip)], ok)
      end do
    end do
  end subroutine grid_surface

  subroutine build_fixture(name, c, ok)
    character(len=*), intent(in) :: name
    type(complex_t), intent(out) :: c
    logical, intent(out) :: ok
    integer(int64) :: t3(3, 10), t7(3, 14), x
    integer :: i, j, k, nt
    integer(int64), parameter :: NV = 24
    ok = .true.
    call complex_init(c, 64)
    select case (trim(name))
    case ('SYNTHETIC_vertex')
      call addc(c, [0_int64], ok)
    case ('SYNTHETIC_two_vertices')
      call addc(c, [0_int64], ok); call addc(c, [1_int64], ok)
    case ('SYNTHETIC_edge')
      call addc(c, [0_int64, 1_int64], ok)
    case ('SYNTHETIC_hollow_triangle')
      call addc(c, [0_int64, 1_int64], ok); call addc(c, [1_int64, 2_int64], ok)
      call addc(c, [0_int64, 2_int64], ok)
    case ('SYNTHETIC_hollow_triangle_relab')
      call addc(c, [0_int64, 1_int64], ok); call addc(c, [1_int64, 3_int64], ok)
      call addc(c, [0_int64, 3_int64], ok)
    case ('SYNTHETIC_hollow_square')
      call addc(c, [0_int64, 1_int64], ok); call addc(c, [1_int64, 2_int64], ok)
      call addc(c, [2_int64, 3_int64], ok); call addc(c, [0_int64, 3_int64], ok)
    case ('SYNTHETIC_filled_triangle')
      call addc(c, [0_int64, 1_int64, 2_int64], ok)
    case ('SYNTHETIC_tetra_boundary')
      call addc(c, [0_int64, 1_int64, 2_int64], ok); call addc(c, [0_int64, 1_int64, 3_int64], ok)
      call addc(c, [0_int64, 2_int64, 3_int64], ok); call addc(c, [1_int64, 2_int64, 3_int64], ok)
    case ('SYNTHETIC_solid_tetra')
      call addc(c, [0_int64, 1_int64, 2_int64, 3_int64], ok)
    case ('SYNTHETIC_rp2_6v')
      t3 = rp2_triangles()
      do i = 1, 10
        call addc(c, t3(:, i), ok)
      end do
    case ('SYNTHETIC_torus_7v')
      t7 = torus7_triangles()
      do i = 1, 14
        call addc(c, t7(:, i), ok)
      end do
    case ('SYNTHETIC_torus_grid3x3')
      call grid_surface(c, 3, 3, .false., ok)
    case ('SYNTHETIC_klein_grid4x4')
      call grid_surface(c, 4, 4, .true., ok)
    case ('SYNTHETIC_random_seed20261019')
      ! 24 vertices; each triangle {i<j<k} kept with probability ~0.04;
      ! plus 4 random tetrahedra; closure added.  Seed 20261019.
      x = 20261019_int64
      do i = 0, int(NV) - 1
        call addc(c, [int(i, int64)], ok)
      end do
      do i = 0, int(NV) - 3
        do j = i + 1, int(NV) - 2
          do k = j + 1, int(NV) - 1
            if (lcg_next(x) < 85899346_int64) then   ! 0.04 * (2^31-1)
              call addc(c, int([i, j, k], int64), ok)
            end if
          end do
        end do
      end do
      nt = 0
      do while (nt < 4)
        i = int(mod(lcg_next(x), NV)); j = int(mod(lcg_next(x), NV))
        k = int(mod(lcg_next(x), NV))
        block
          integer :: l
          l = int(mod(lcg_next(x), NV))
          if (i /= j .and. i /= k .and. i /= l .and. j /= k .and. j /= l .and. k /= l) then
            call addc(c, int([i, j, k, l], int64), ok)
            nt = nt + 1
          end if
        end block
      end do
    case default
      ok = .false.
    end select
  end subroutine build_fixture

end module topo_fixtures
