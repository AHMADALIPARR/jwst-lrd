! Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
! SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
! Licensed under AGPL-3.0-only plus the SnapKitty Opaque License (dual license, intentional).
! See LICENSE and SNAPKITTY_OPAQUE_LICENSE.md at the repository root.
!
! topo_export: deterministic exports.
!
! Geometry export (for the Self Morphic interface), a concatenation of LRD-REC-v1
! records:
!   1. {kind=geometry_header, name, synthetic=SYNTHETIC, field, betti, root,
!       merkle_root, layout, n_vertices, n_edges, n_triangles, n_tetrahedra, schema}
!   2. one {kind=vertex_position, index, label, x, y, z, x2, y2, px, py} per vertex
!   3. the serialized complex (simplex leaf records + complex_root record), byte-
!      identical to the committed serialization, so the export is verifiable.
! Layout (deterministic; depends only on the canonical rank r of a vertex among
! n vertices):
!   2D: theta = 2*pi*r/n, (x2,y2) = (cos theta, sin theta)
!   3D: Fibonacci sphere z = 1-(2r+1)/n, rho = sqrt(1-z^2), phi = r*pi*(3-sqrt 5),
!       (x,y,z) = (rho cos phi, rho sin phi, z)
!   pixels (Morphic, 400x400 box): px = 20+nint(180*(1+x2)), py = 20+nint(180*(1-y2))
!   reals written with format F0.6 (gfortran), i.e. 6 decimals.
!
! Futhark fixtures: Futhark text-format values of canonical vertex tuples and
! orientations per dimension, with the Fortran reference outputs as expected
! values.
module topo_export
  use, intrinsic :: iso_fortran_env, only: int64, real64
  use topo_record
  use topo_field
  use topo_complex
  use topo_commit
  implicit none
  private
  public :: geometry_export, write_bytes, read_bytes, futhark_fixtures, fmt_real

contains

  function fmt_real(x) result(s)
    real(real64), intent(in) :: x
    character(len=:), allocatable :: s
    character(len=32) :: b
    real(real64) :: y
    y = x
    if (abs(y) < 5.0e-7_real64) y = 0.0_real64      ! avoid "-0.000000"
    write(b, '(f0.6)') y
    s = trim(adjustl(b))
    if (s(1:1) == '.') s = '0' // s
    if (len(s) >= 2) then
      if (s(1:2) == '-.') s = '-0' // s(2:)
    end if
  end function fmt_real

  subroutine write_bytes(path, s)
    character(len=*), intent(in) :: path, s
    integer :: u
    open(newunit=u, file=path, access='stream', form='unformatted', status='replace', action='write')
    write(u) s
    close(u)
  end subroutine write_bytes

  subroutine read_bytes(path, s, ok)
    character(len=*), intent(in) :: path
    character(len=:), allocatable, intent(out) :: s
    logical, intent(out) :: ok
    integer :: u, sz, ios
    inquire(file=path, size=sz)
    ok = .false.
    if (sz < 0) return
    allocate(character(len=sz) :: s)
    open(newunit=u, file=path, access='stream', form='unformatted', status='old', action='read', iostat=ios)
    if (ios /= 0) return
    if (sz > 0) read(u, iostat=ios) s
    close(u)
    ok = (ios == 0)
  end subroutine read_bytes

  function geometry_export(c, f, betti, name) result(s)
    type(complex_t), intent(in) :: c
    type(field_t), intent(in) :: f
    integer, intent(in) :: betti(0:MAXD)
    character(len=*), intent(in) :: name
    character(len=:), allocatable :: s
    real(real64), parameter :: PI = 3.14159265358979323846_real64
    type(sbuf_t) :: b
    type(rec_t) :: h, r
    integer, allocatable :: vidx(:)
    character(len=64) :: root, mroot
    real(real64) :: th, x2, y2, z, rho, phi, x, y
    integer :: i, n
    call complex_root(c, f, betti, root, mroot)
    call canonical_order(c, 0, vidx)
    n = size(vidx)
    call rec_set(h, 'betti', betti_string(c, betti))
    call rec_set(h, 'field', field_name(f))
    call rec_set(h, 'kind', 'geometry_header')
    call rec_set(h, 'layout', 'circle2d+fibonacci3d/v1')
    call rec_set(h, 'merkle_root', mroot)
    call rec_set(h, 'n_edges', itoa(count_dim(c, 1)))
    call rec_set(h, 'n_tetrahedra', itoa(count_dim(c, 3)))
    call rec_set(h, 'n_triangles', itoa(count_dim(c, 2)))
    call rec_set(h, 'n_vertices', itoa(n))
    call rec_set(h, 'name', name)
    call rec_set(h, 'root', root)
    call rec_set(h, 'schema', 'jwst-lrd/topology/geometry/v1')
    call rec_set(h, 'synthetic', 'SYNTHETIC')
    call sbuf_add(b, rec_serialize(h))
    do i = 1, n
      th = 2.0_real64 * PI * real(i - 1, real64) / real(n, real64)
      x2 = cos(th); y2 = sin(th)
      z = 1.0_real64 - real(2 * (i - 1) + 1, real64) / real(n, real64)
      rho = sqrt(max(0.0_real64, 1.0_real64 - z * z))
      phi = real(i - 1, real64) * PI * (3.0_real64 - sqrt(5.0_real64))
      x = rho * cos(phi); y = rho * sin(phi)
      r%n = 0
      call rec_set(r, 'index', itoa(i - 1))
      call rec_set(r, 'kind', 'vertex_position')
      call rec_set(r, 'label', itoa(c%verts(0, vidx(i))))
      call rec_set(r, 'px', itoa(20 + nint(180.0_real64 * (1.0_real64 + x2))))
      call rec_set(r, 'py', itoa(20 + nint(180.0_real64 * (1.0_real64 - y2))))
      call rec_set(r, 'x', fmt_real(x)); call rec_set(r, 'y', fmt_real(y))
      call rec_set(r, 'z', fmt_real(z))
      call rec_set(r, 'x2', fmt_real(x2)); call rec_set(r, 'y2', fmt_real(y2))
      call sbuf_add(b, rec_serialize(r))
    end do
    call sbuf_add(b, serialize_complex(c, f, betti))
    s = sbuf_str(b)
  end function geometry_export

  function fut_verts(c, idx, d) result(s)
    type(complex_t), intent(in) :: c
    integer, intent(in) :: idx(:), d
    character(len=:), allocatable :: s
    type(sbuf_t) :: b
    integer :: i, j
    call sbuf_add(b, '[')
    do i = 1, size(idx)
      if (i > 1) call sbuf_add(b, ', ')
      call sbuf_add(b, '[')
      do j = 0, d
        if (j > 0) call sbuf_add(b, ', ')
        call sbuf_add(b, itoa(c%verts(j, idx(i))) // 'i64')
      end do
      call sbuf_add(b, ']')
    end do
    call sbuf_add(b, ']')
    s = sbuf_str(b)
  end function fut_verts

  function fut_orient(c, idx) result(s)
    type(complex_t), intent(in) :: c
    integer, intent(in) :: idx(:)
    character(len=:), allocatable :: s
    type(sbuf_t) :: b
    integer :: i
    call sbuf_add(b, '[')
    do i = 1, size(idx)
      if (i > 1) call sbuf_add(b, ', ')
      call sbuf_add(b, itoa(c%orient(idx(i))) // 'i32')
    end do
    call sbuf_add(b, ']')
    s = sbuf_str(b)
  end function fut_orient

  function fut_matrix(a) result(s)
    integer(int64), intent(in) :: a(:,:)
    character(len=:), allocatable :: s
    type(sbuf_t) :: b
    integer :: i, j
    call sbuf_add(b, '[')
    do i = 1, size(a, 1)
      if (i > 1) call sbuf_add(b, ',' // char(10))
      call sbuf_add(b, '[')
      do j = 1, size(a, 2)
        if (j > 1) call sbuf_add(b, ', ')
        call sbuf_add(b, itoa(int(a(i, j))) // 'i32')
      end do
      call sbuf_add(b, ']')
    end do
    call sbuf_add(b, ']')
    s = sbuf_str(b)
  end function fut_matrix

  !> Writes, for every k >= 1 with n_{k-1}, n_k > 0:
  !>   <dir>/<name>_d<k>.bnd.in / .bnd.out    boundary matrix
  !>   <dir>/<name>_d<k>.gf2.in / .gf2.out    rank over GF(2)
  !>   <dir>/<name>_d<k>.gf3.in / .gf3.out    rank over GF(3)
  !> and for k >= 2: <name>_d<k>.dd.in / .dd.out (nnz and max|.| of d_{k-1} d_k).
  !> Appends one line per file stem to 'manifest' (stem, entry point).
  subroutine futhark_fixtures(c, name, dir, manifest)
    type(complex_t), intent(in) :: c
    character(len=*), intent(in) :: name, dir
    type(sbuf_t), intent(inout) :: manifest
    integer, allocatable :: i0(:), i1(:), i2(:)
    integer(int64), allocatable :: b(:,:)
    character(len=:), allocatable :: stem, lvl
    integer :: k, nnz
    integer(int64) :: mx
    do k = 1, MAXD
      if (count_dim(c, k) == 0 .or. count_dim(c, k - 1) == 0) cycle
      call canonical_order(c, k - 1, i0)
      call canonical_order(c, k, i1)
      call boundary_matrix(c, k, b)
      stem = dir // '/' // trim(name) // '_d' // itoa(k)
      lvl = fut_verts(c, i0, k - 1) // char(10) // fut_orient(c, i0) // char(10) // &
            fut_verts(c, i1, k) // char(10) // fut_orient(c, i1) // char(10)
      call write_bytes(stem // '.bnd.in', lvl)
      call write_bytes(stem // '.bnd.out', fut_matrix(b) // char(10))
      call write_bytes(stem // '.gf2.in', '2i64' // char(10) // lvl)
      call write_bytes(stem // '.gf2.out', itoa(rank_modp(b, 2_int64)) // 'i64' // char(10))
      call write_bytes(stem // '.gf3.in', '3i64' // char(10) // lvl)
      call write_bytes(stem // '.gf3.out', itoa(rank_modp(b, 3_int64)) // 'i64' // char(10))
      call sbuf_add(manifest, trim(name) // '_d' // itoa(k) // ' boundary' // char(10))
      call sbuf_add(manifest, trim(name) // '_d' // itoa(k) // ' rank_gfp gf2' // char(10))
      call sbuf_add(manifest, trim(name) // '_d' // itoa(k) // ' rank_gfp gf3' // char(10))
      if (k >= 2) then
        if (count_dim(c, k - 2) > 0) then
          call canonical_order(c, k - 2, i2)
          call dd_check(c, k, nnz, mx)
          call write_bytes(stem // '.dd.in', fut_verts(c, i2, k - 2) // char(10) // &
               fut_orient(c, i2) // char(10) // lvl)
          call write_bytes(stem // '.dd.out', itoa(nnz) // 'i64 ' // itoa(mx) // 'i64' // char(10))
          call sbuf_add(manifest, trim(name) // '_d' // itoa(k) // ' ddcheck' // char(10))
        end if
      end if
    end do
  end subroutine futhark_fixtures

end module topo_export
