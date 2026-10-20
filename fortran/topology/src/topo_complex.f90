! Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
! SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
! Licensed under AGPL-3.0-only plus the SnapKitty Opaque License (dual license, intentional).
! See LICENSE and SNAPKITTY_OPAQUE_LICENSE.md at the repository root.
!
! topo_complex: canonical simplex identifiers and oriented simplicial complexes.
!
! Conventions (documented in fortran/topology/STATUS.md):
!  * A vertex label is a non-negative int64.
!  * A k-simplex is given as an ordered list of k+1 labels.  Its canonical form is the
!    ascending tuple; its canonical ID is the string "k:v0,v1,...,vk" of that tuple.
!  * orientation = +1 if the given order is an even permutation of the ascending
!    tuple, -1 if odd.  The stored oriented simplex is orientation * [v0<...<vk].
!  * face(i) of a simplex is the canonical (k-1)-simplex omitting sorted vertex i,
!    i = 0..k.  The incidence coefficient [sigma : face_i] is
!       (-1)**i * orient(sigma) * orient(face_i),
!    i.e. the boundary of the stored oriented simplex expressed in the stored
!    orientations of its faces.  This keeps d o d = 0 for any choice of orientations.
!  * Every simplex keeps its complete vertex list, its face slots and its coface slots.
module topo_complex
  use, intrinsic :: iso_fortran_env, only: int64
  implicit none
  private

  integer, parameter, public :: MAXD = 7
  integer, parameter, public :: TERR_OK = 0, TERR_DUPLICATE = 1, TERR_DEGENERATE = 2, &
       TERR_UNKNOWN_VERTEX = 3, TERR_MISSING_FACE = 4, TERR_DIM_MISMATCH = 5, &
       TERR_HAS_COFACES = 6, TERR_NOT_FOUND = 7, TERR_BAD_VERTEX_ID = 9

  type, public :: ilist
    integer :: n = 0
    integer, allocatable :: v(:)
  end type ilist

  type, public :: complex_t
    integer :: n = 0          ! slots used (alive or dead)
    integer :: cap = 0
    integer :: nalive = 0
    integer, allocatable :: dimv(:), orient(:)
    integer(int64), allocatable :: verts(:,:)   ! (0:MAXD, cap) ascending; unused = -1
    logical, allocatable :: alive(:)
    integer, allocatable :: face(:,:)           ! (0:MAXD, cap) slot of face i; unused = 0
    type(ilist), allocatable :: cof(:)
    integer, allocatable :: ht(:)               ! hash table of slots, -1 empty, -2 tombstone
    integer :: htfill = 0
  end type complex_t

  public :: complex_init, canon_sort, simplex_id, find_simplex, add_simplex, add_closure, &
            remove_simplex, canonical_order, global_order, count_dim, max_dim, &
            boundary_matrix, dd_check, incidence_sign, err_name, n_alive_cofaces, lex_less

contains

  function err_name(e) result(s)
    integer, intent(in) :: e
    character(len=:), allocatable :: s
    select case (e)
    case (TERR_OK); s = 'OK'
    case (TERR_DUPLICATE); s = 'DUPLICATE'
    case (TERR_DEGENERATE); s = 'DEGENERATE'
    case (TERR_UNKNOWN_VERTEX); s = 'UNKNOWN_VERTEX'
    case (TERR_MISSING_FACE); s = 'MISSING_FACE'
    case (TERR_DIM_MISMATCH); s = 'DIM_MISMATCH'
    case (TERR_HAS_COFACES); s = 'HAS_COFACES'
    case (TERR_NOT_FOUND); s = 'NOT_FOUND'
    case (TERR_BAD_VERTEX_ID); s = 'BAD_VERTEX_ID'
    case default; s = 'UNKNOWN_ERROR'
    end select
  end function err_name

  subroutine complex_init(c, cap0)
    type(complex_t), intent(out) :: c
    integer, intent(in), optional :: cap0
    integer :: cap
    cap = 64
    if (present(cap0)) cap = max(cap0, 8)
    c%cap = cap; c%n = 0; c%nalive = 0
    allocate(c%dimv(cap), c%orient(cap), c%verts(0:MAXD, cap), c%alive(cap), &
             c%face(0:MAXD, cap), c%cof(cap))
    c%verts = -1; c%face = 0; c%alive = .false.; c%dimv = -1; c%orient = 0
    allocate(c%ht(4*cap)); c%ht = -1; c%htfill = 0
  end subroutine complex_init

  subroutine grow(c)
    type(complex_t), intent(inout) :: c
    integer, allocatable :: i1(:), i2(:), f(:,:)
    integer(int64), allocatable :: vv(:,:)
    logical, allocatable :: al(:)
    type(ilist), allocatable :: cf(:)
    integer :: nc, i
    nc = 2 * c%cap
    allocate(i1(nc), i2(nc), vv(0:MAXD, nc), al(nc), f(0:MAXD, nc), cf(nc))
    i1 = -1; i2 = 0; vv = -1; al = .false.; f = 0
    i1(1:c%n) = c%dimv(1:c%n); i2(1:c%n) = c%orient(1:c%n)
    vv(:, 1:c%n) = c%verts(:, 1:c%n); al(1:c%n) = c%alive(1:c%n); f(:, 1:c%n) = c%face(:, 1:c%n)
    do i = 1, c%n
      cf(i) = c%cof(i)
    end do
    call move_alloc(i1, c%dimv); call move_alloc(i2, c%orient); call move_alloc(vv, c%verts)
    call move_alloc(al, c%alive); call move_alloc(f, c%face); call move_alloc(cf, c%cof)
    c%cap = nc
    call rehash(c, 4 * nc)
  end subroutine grow

  pure integer function hkey(vs, d, m)
    integer(int64), intent(in) :: vs(0:)
    integer, intent(in) :: d, m
    integer(int64), parameter :: MOD31 = 2147483647_int64
    integer(int64) :: h
    integer :: i
    h = int(d, int64) + 7
    do i = 0, d
      h = mod(h * 1000003_int64 + mod(vs(i), MOD31), MOD31)
    end do
    hkey = int(mod(h, int(m, int64))) + 1
  end function hkey

  subroutine rehash(c, m)
    type(complex_t), intent(inout) :: c
    integer, intent(in) :: m
    integer :: s, h
    deallocate(c%ht); allocate(c%ht(m)); c%ht = -1; c%htfill = 0
    do s = 1, c%n
      if (.not. c%alive(s)) cycle
      h = hkey(c%verts(:, s), c%dimv(s), m)
      do while (c%ht(h) /= -1)
        h = mod(h, m) + 1
      end do
      c%ht(h) = s; c%htfill = c%htfill + 1
    end do
  end subroutine rehash

  !> Sort a vertex list ascending; returns permutation parity sign and degeneracy flag.
  pure subroutine canon_sort(vin, vs, sgn, degenerate)
    integer(int64), intent(in) :: vin(:)
    integer(int64), intent(out) :: vs(0:size(vin)-1)
    integer, intent(out) :: sgn
    logical, intent(out) :: degenerate
    integer(int64) :: t
    integer :: i, j
    vs = vin
    sgn = 1
    do i = 1, size(vin) - 1
      j = i
      do while (j > 0)
        if (vs(j-1) <= vs(j)) exit
        t = vs(j); vs(j) = vs(j-1); vs(j-1) = t
        sgn = -sgn
        j = j - 1
      end do
    end do
    degenerate = .false.
    do i = 1, size(vin) - 1
      if (vs(i) == vs(i-1)) degenerate = .true.
    end do
  end subroutine canon_sort

  !> Canonical ID string "k:v0,...,vk" (ascending labels).
  function simplex_id(vs, d) result(s)
    integer(int64), intent(in) :: vs(0:)
    integer, intent(in) :: d
    character(len=:), allocatable :: s
    character(len=24) :: b
    integer :: i
    write(b, '(i0)') d
    s = trim(b) // ':'
    do i = 0, d
      write(b, '(i0)') vs(i)
      if (i > 0) s = s // ','
      s = s // trim(b)
    end do
  end function simplex_id

  integer function find_simplex(c, vs, d) result(slot)
    type(complex_t), intent(in) :: c
    integer(int64), intent(in) :: vs(0:)
    integer, intent(in) :: d
    integer :: h, m, s
    slot = 0
    if (.not. allocated(c%ht)) return
    m = size(c%ht)
    h = hkey(vs, d, m)
    do
      s = c%ht(h)
      if (s == -1) return
      if (s > 0) then
        if (c%dimv(s) == d) then
          if (all(c%verts(0:d, s) == vs(0:d))) then
            slot = s; return
          end if
        end if
      end if
      h = mod(h, m) + 1
    end do
  end function find_simplex

  !> Attach a simplex of declared dimension d with ordered vertex labels vin.
  !> Rules (checked in this order):
  !>   DIM_MISMATCH  d < 0, d > MAXD, or size(vin) /= d+1
  !>   BAD_VERTEX_ID a negative label
  !>   DEGENERATE    a repeated vertex
  !>   DUPLICATE     a simplex with the same vertex set already exists
  !>   UNKNOWN_VERTEX (d >= 1) some vertex is not a 0-simplex of the complex
  !>   MISSING_FACE  (d >= 1) some (d-1)-face is absent (closure rule)
  subroutine add_simplex(c, d, vin, err, slot)
    type(complex_t), intent(inout) :: c
    integer, intent(in) :: d
    integer(int64), intent(in) :: vin(:)
    integer, intent(out) :: err
    integer, intent(out), optional :: slot
    integer(int64) :: vs(0:MAXD), fv(0:MAXD)
    integer :: sgn, i, j, s, fs(0:MAXD), h, m
    logical :: deg
    err = TERR_OK
    if (present(slot)) slot = 0
    if (d < 0 .or. d > MAXD .or. size(vin) /= d + 1) then
      err = TERR_DIM_MISMATCH; return
    end if
    if (any(vin < 0)) then
      err = TERR_BAD_VERTEX_ID; return
    end if
    vs = -1
    call canon_sort(vin, vs(0:d), sgn, deg)
    if (deg) then
      err = TERR_DEGENERATE; return
    end if
    if (find_simplex(c, vs, d) /= 0) then
      err = TERR_DUPLICATE; return
    end if
    fs = 0
    if (d >= 1) then
      do i = 0, d
        fv = -1; fv(0) = vs(i)
        if (find_simplex(c, fv, 0) == 0) then
          err = TERR_UNKNOWN_VERTEX; return
        end if
      end do
      do i = 0, d
        fv = -1
        m = 0
        do j = 0, d
          if (j == i) cycle
          fv(m) = vs(j); m = m + 1
        end do
        fs(i) = find_simplex(c, fv, d - 1)
        if (fs(i) == 0) then
          err = TERR_MISSING_FACE; return
        end if
      end do
    end if
    if (c%n + 1 > c%cap) call grow(c)
    if (4 * (c%htfill + 1) > 2 * size(c%ht)) call rehash(c, 2 * size(c%ht))
    c%n = c%n + 1; s = c%n
    c%dimv(s) = d; c%orient(s) = sgn; c%verts(:, s) = vs; c%alive(s) = .true.
    c%face(:, s) = fs
    c%cof(s)%n = 0
    if (allocated(c%cof(s)%v)) deallocate(c%cof(s)%v)
    allocate(c%cof(s)%v(4))
    if (d >= 1) then
      do i = 0, d
        call ilist_push(c%cof(fs(i)), s)
      end do
    end if
    m = size(c%ht)
    h = hkey(vs, d, m)
    do while (c%ht(h) > 0)
      h = mod(h, m) + 1
    end do
    if (c%ht(h) == -1) c%htfill = c%htfill + 1
    c%ht(h) = s
    c%nalive = c%nalive + 1
    if (present(slot)) slot = s
  end subroutine add_simplex

  subroutine ilist_push(l, x)
    type(ilist), intent(inout) :: l
    integer, intent(in) :: x
    integer, allocatable :: t(:)
    if (.not. allocated(l%v)) allocate(l%v(4))
    if (l%n == size(l%v)) then
      allocate(t(2 * size(l%v))); t(1:l%n) = l%v(1:l%n); call move_alloc(t, l%v)
    end if
    l%n = l%n + 1; l%v(l%n) = x
  end subroutine ilist_push

  subroutine ilist_remove(l, x)
    type(ilist), intent(inout) :: l
    integer, intent(in) :: x
    integer :: i
    do i = 1, l%n
      if (l%v(i) == x) then
        l%v(i:l%n-1) = l%v(i+1:l%n); l%n = l%n - 1; return
      end if
    end do
  end subroutine ilist_remove

  integer function n_alive_cofaces(c, s) result(k)
    type(complex_t), intent(in) :: c
    integer, intent(in) :: s
    k = c%cof(s)%n
  end function n_alive_cofaces

  !> Add a simplex together with every missing face (faces get canonical orientation +1).
  recursive subroutine add_closure(c, vin, err)
    type(complex_t), intent(inout) :: c
    integer(int64), intent(in) :: vin(:)
    integer, intent(out) :: err
    integer(int64) :: vs(0:MAXD), fv(0:MAXD)
    integer :: d, sgn, i, j, m, e2
    logical :: deg
    d = size(vin) - 1
    err = TERR_OK
    if (d < 0 .or. d > MAXD) then
      err = TERR_DIM_MISMATCH; return
    end if
    vs = -1
    call canon_sort(vin, vs(0:d), sgn, deg)
    if (deg) then
      err = TERR_DEGENERATE; return
    end if
    if (find_simplex(c, vs, d) /= 0) return
    if (d >= 1) then
      do i = 0, d
        fv = -1; m = 0
        do j = 0, d
          if (j == i) cycle
          fv(m) = vs(j); m = m + 1
        end do
        if (find_simplex(c, fv, d - 1) == 0) then
          call add_closure(c, fv(0:d-1), e2)
          if (e2 /= TERR_OK) then
            err = e2; return
          end if
        end if
      end do
    end if
    call add_simplex(c, d, vin, err)
  end subroutine add_closure

  !> Remove a simplex; allowed only if it has no cofaces.
  subroutine remove_simplex(c, vin, err)
    type(complex_t), intent(inout) :: c
    integer(int64), intent(in) :: vin(:)
    integer, intent(out) :: err
    integer(int64) :: vs(0:MAXD)
    integer :: d, sgn, s, i, h, m
    logical :: deg
    d = size(vin) - 1
    err = TERR_OK
    if (d < 0 .or. d > MAXD) then
      err = TERR_DIM_MISMATCH; return
    end if
    vs = -1
    call canon_sort(vin, vs(0:d), sgn, deg)
    if (deg) then
      err = TERR_DEGENERATE; return
    end if
    s = find_simplex(c, vs, d)
    if (s == 0) then
      err = TERR_NOT_FOUND; return
    end if
    if (c%cof(s)%n > 0) then
      err = TERR_HAS_COFACES; return
    end if
    if (d >= 1) then
      do i = 0, d
        call ilist_remove(c%cof(c%face(i, s)), s)
      end do
    end if
    m = size(c%ht)
    h = hkey(vs, d, m)
    do while (c%ht(h) /= s)
      h = mod(h, m) + 1
    end do
    c%ht(h) = -2
    c%alive(s) = .false.
    c%nalive = c%nalive - 1
  end subroutine remove_simplex

  pure logical function lex_less(c, a, b)
    type(complex_t), intent(in) :: c
    integer, intent(in) :: a, b
    integer :: i
    lex_less = .false.
    if (c%dimv(a) /= c%dimv(b)) then
      lex_less = c%dimv(a) < c%dimv(b); return
    end if
    do i = 0, c%dimv(a)
      if (c%verts(i, a) /= c%verts(i, b)) then
        lex_less = c%verts(i, a) < c%verts(i, b); return
      end if
    end do
  end function lex_less

  recursive subroutine msort(c, a, tmp, lo, hi)
    type(complex_t), intent(in) :: c
    integer, intent(inout) :: a(:), tmp(:)
    integer, intent(in) :: lo, hi
    integer :: mid, i, j, k
    if (hi - lo < 1) return
    mid = (lo + hi) / 2
    call msort(c, a, tmp, lo, mid)
    call msort(c, a, tmp, mid + 1, hi)
    i = lo; j = mid + 1; k = lo
    do while (i <= mid .and. j <= hi)
      if (lex_less(c, a(j), a(i))) then
        tmp(k) = a(j); j = j + 1
      else
        tmp(k) = a(i); i = i + 1
      end if
      k = k + 1
    end do
    do while (i <= mid)
      tmp(k) = a(i); i = i + 1; k = k + 1
    end do
    do while (j <= hi)
      tmp(k) = a(j); j = j + 1; k = k + 1
    end do
    a(lo:hi) = tmp(lo:hi)
  end subroutine msort

  !> Slots of the alive d-simplices in canonical (lexicographic) order.
  subroutine canonical_order(c, d, idx)
    type(complex_t), intent(in) :: c
    integer, intent(in) :: d
    integer, allocatable, intent(out) :: idx(:)
    integer, allocatable :: tmp(:)
    integer :: s, k
    k = count_dim(c, d)
    allocate(idx(k), tmp(k))
    k = 0
    do s = 1, c%n
      if (c%alive(s) .and. c%dimv(s) == d) then
        k = k + 1; idx(k) = s
      end if
    end do
    if (k > 1) call msort(c, idx, tmp, 1, k)
  end subroutine canonical_order

  !> Global canonical order (dimension ascending, then lexicographic) and its inverse.
  subroutine global_order(c, idx, pos)
    type(complex_t), intent(in) :: c
    integer, allocatable, intent(out) :: idx(:), pos(:)
    integer, allocatable :: part(:)
    integer :: d, k, i
    allocate(idx(c%nalive), pos(max(c%n, 1)))
    pos = 0
    k = 0
    do d = 0, MAXD
      call canonical_order(c, d, part)
      do i = 1, size(part)
        k = k + 1; idx(k) = part(i); pos(part(i)) = k
      end do
    end do
  end subroutine global_order

  integer function count_dim(c, d) result(k)
    type(complex_t), intent(in) :: c
    integer, intent(in) :: d
    integer :: s
    k = 0
    do s = 1, c%n
      if (c%alive(s) .and. c%dimv(s) == d) k = k + 1
    end do
  end function count_dim

  integer function max_dim(c) result(m)
    type(complex_t), intent(in) :: c
    integer :: s
    m = -1
    do s = 1, c%n
      if (c%alive(s)) m = max(m, c%dimv(s))
    end do
  end function max_dim

  pure integer function incidence_sign(c, s, i)
    type(complex_t), intent(in) :: c
    integer, intent(in) :: s, i
    incidence_sign = (1 - 2 * mod(i, 2)) * c%orient(s) * c%orient(c%face(i, s))
  end function incidence_sign

  !> Dense boundary matrix d_k : C_k -> C_{k-1}, rows/cols in canonical order.
  !> For k = 0 the result has 0 rows (augmentation is not used).
  subroutine boundary_matrix(c, k, b)
    type(complex_t), intent(in) :: c
    integer, intent(in) :: k
    integer(int64), allocatable, intent(out) :: b(:,:)
    integer, allocatable :: rows(:), cols(:), rpos(:)
    integer :: j, i
    if (k <= 0) then
      allocate(b(0, count_dim(c, max(k, 0)))); return
    end if
    call canonical_order(c, k - 1, rows)
    call canonical_order(c, k, cols)
    allocate(b(size(rows), size(cols)), rpos(max(c%n, 1)))
    b = 0; rpos = 0
    do i = 1, size(rows)
      rpos(rows(i)) = i
    end do
    do j = 1, size(cols)
      do i = 0, k
        b(rpos(c%face(i, cols(j))), j) = incidence_sign(c, cols(j), i)
      end do
    end do
  end subroutine boundary_matrix

  !> Exact integer check of d_{k-1} o d_k = 0. Returns the number of nonzero entries
  !> of the product and its max |entry| (both 0 on success).
  subroutine dd_check(c, k, nnz, maxabs)
    type(complex_t), intent(in) :: c
    integer, intent(in) :: k
    integer, intent(out) :: nnz
    integer(int64), intent(out) :: maxabs
    integer(int64), allocatable :: b1(:,:), b2(:,:), p(:,:)
    nnz = 0; maxabs = 0
    if (k < 2) return
    call boundary_matrix(c, k - 1, b1)
    call boundary_matrix(c, k, b2)
    if (size(b1, 1) == 0 .or. size(b2, 2) == 0) return
    p = matmul(b1, b2)
    nnz = count(p /= 0)
    maxabs = maxval(abs(p))
  end subroutine dd_check

end module topo_complex
