! Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
! SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
! Licensed under AGPL-3.0-only plus the SnapKitty Opaque License (dual license, intentional).
! See LICENSE and SNAPKITTY_OPAQUE_LICENSE.md at the repository root.
!
! topo_incremental: incremental topology updates over GF(p) with an append-only,
! hash-chained update log.
!
! For each k >= 1 we keep an echelon basis of the column space of d_k over GF(p);
! vectors are sparse, indexed by (k-1)-simplex SLOT (stable across updates), and
! the pivot of a vector is its largest slot (as in the standard persistence
! reduction).  rank d_k = number of basis vectors of dimension k.
!   add k-simplex s:   reduce d(s) against the basis; if nonzero it becomes a new
!                      basis vector (rank d_k += 1, so b_{k-1} -= 1), else b_k += 1.
!                      The new row of d_{k+1} is zero (s has no cofaces yet).
!   remove k-simplex:  allowed only if s has no cofaces, so its row of d_{k+1} is
!                      zero and rank d_{k+1} is unchanged; the dimension-k basis is
!                      rebuilt from the remaining k-columns (only that dimension).
! Q coefficients are not supported incrementally (use the from-scratch path).
!
! Update log record (LRD-REC-v1), one per ACCEPTED update; rejected updates do not
! construct a new state and are not chained:
!   kind=topology_update, seq, op=add|remove, simplex=<canonical id>,
!   orientation, field, prev_commit (64 zeros for genesis), prev_root, new_root,
!   betti, schema=jwst-lrd/topology/update/v1
! The entry commitment is its LRD-COMMIT-v1 commitment; the next entry's
! prev_commit must equal it.
module topo_incremental
  use, intrinsic :: iso_fortran_env, only: int64
  use topo_record
  use topo_field
  use topo_complex
  use topo_commit
  implicit none
  private

  type :: svec_t
    integer :: n = 0
    integer, allocatable :: idx(:)
    integer(int64), allocatable :: val(:)
    integer :: dim = 0
    logical :: live = .false.
  end type svec_t

  type, public :: inc_t
    type(complex_t) :: c
    type(field_t) :: f
    integer :: rank(0:MAXD+1) = 0
    integer :: nb = 0
    type(svec_t), allocatable :: basis(:)
    integer, allocatable :: owner(:)          ! owner(slot) = basis vector with pivot at slot
    ! update log
    integer :: seq = 0
    character(len=64) :: head = repeat('0', 64)
    character(len=64) :: root = repeat('0', 64)
    type(sbuf_t) :: log
  end type inc_t

  public :: inc_init, inc_add, inc_remove, inc_betti, verify_log

contains

  subroutine inc_init(st, f)
    type(inc_t), intent(out) :: st
    type(field_t), intent(in) :: f
    integer :: b(0:MAXD)
    call complex_init(st%c, 64)
    st%f = f
    allocate(st%basis(64), st%owner(64))
    st%owner = 0
    st%nb = 0
    st%rank = 0
    b = 0
    call complex_root(st%c, st%f, b, st%root)
  end subroutine inc_init

  subroutine inc_betti(st, b)
    type(inc_t), intent(in) :: st
    integer, intent(out) :: b(0:MAXD)
    integer :: k
    do k = 0, MAXD
      b(k) = count_dim(st%c, k) - st%rank(k) - st%rank(k+1)
    end do
  end subroutine inc_betti

  subroutine ensure_owner(st)
    type(inc_t), intent(inout) :: st
    integer, allocatable :: t(:)
    if (size(st%owner) < st%c%cap) then
      allocate(t(st%c%cap)); t = 0; t(1:size(st%owner)) = st%owner
      call move_alloc(t, st%owner)
    end if
  end subroutine ensure_owner

  !> v <- v - a*w (mod p), sparse sorted merge
  subroutine axpy(v, a, w, p)
    type(svec_t), intent(inout) :: v
    integer(int64), intent(in) :: a, p
    type(svec_t), intent(in) :: w
    integer, allocatable :: ni(:)
    integer(int64), allocatable :: nv(:)
    integer :: i, j, k
    integer(int64) :: x
    allocate(ni(v%n + w%n), nv(v%n + w%n))
    i = 1; j = 1; k = 0
    do while (i <= v%n .or. j <= w%n)
      if (j > w%n) then
        x = v%val(i); k = k + 1; ni(k) = v%idx(i); nv(k) = x; i = i + 1
      else if (i > v%n) then
        x = modulo(-a * w%val(j), p)
        if (x /= 0) then
          k = k + 1; ni(k) = w%idx(j); nv(k) = x
        end if
        j = j + 1
      else if (v%idx(i) < w%idx(j)) then
        k = k + 1; ni(k) = v%idx(i); nv(k) = v%val(i); i = i + 1
      else if (v%idx(i) > w%idx(j)) then
        x = modulo(-a * w%val(j), p)
        if (x /= 0) then
          k = k + 1; ni(k) = w%idx(j); nv(k) = x
        end if
        j = j + 1
      else
        x = modulo(v%val(i) - a * w%val(j), p)
        if (x /= 0) then
          k = k + 1; ni(k) = v%idx(i); nv(k) = x
        end if
        i = i + 1; j = j + 1
      end if
    end do
    v%n = k
    v%idx = ni(1:k); v%val = nv(1:k)
  end subroutine axpy

  !> Boundary column of slot s as a sparse vector over face slots (mod p).
  subroutine column(st, s, v)
    type(inc_t), intent(in) :: st
    integer, intent(in) :: s
    type(svec_t), intent(out) :: v
    integer :: d, i, j, ti
    integer(int64) :: tv
    d = st%c%dimv(s)
    allocate(v%idx(d + 1), v%val(d + 1))
    do i = 0, d
      v%idx(i + 1) = st%c%face(i, s)
      v%val(i + 1) = modulo(int(incidence_sign(st%c, s, i), int64), st%f%p)
    end do
    v%n = d + 1
    do i = 2, v%n
      j = i
      do while (j > 1)
        if (v%idx(j-1) <= v%idx(j)) exit
        ti = v%idx(j); v%idx(j) = v%idx(j-1); v%idx(j-1) = ti
        tv = v%val(j); v%val(j) = v%val(j-1); v%val(j-1) = tv
        j = j - 1
      end do
    end do
    v%dim = d
  end subroutine column

  !> Reduce and insert a column; returns .true. if rank increased.
  logical function insert_column(st, s) result(newrank)
    type(inc_t), intent(inout) :: st
    integer, intent(in) :: s
    type(svec_t) :: v
    type(svec_t), allocatable :: tb(:)
    integer :: low, o, i
    integer(int64) :: a
    call column(st, s, v)
    newrank = .false.
    do while (v%n > 0)
      low = v%idx(v%n)
      o = st%owner(low)
      if (o == 0) exit
      a = modulo(v%val(v%n) * inv_modp(st%basis(o)%val(st%basis(o)%n), st%f%p), st%f%p)
      call axpy(v, a, st%basis(o), st%f%p)
    end do
    if (v%n == 0) return
    if (st%nb == size(st%basis)) then
      allocate(tb(2 * st%nb))
      do i = 1, st%nb
        tb(i) = st%basis(i)
      end do
      call move_alloc(tb, st%basis)
    end if
    st%nb = st%nb + 1
    v%live = .true.
    st%basis(st%nb) = v
    st%owner(v%idx(v%n)) = st%nb
    newrank = .true.
  end function insert_column

  subroutine rebuild_dim(st, k)
    type(inc_t), intent(inout) :: st
    integer, intent(in) :: k
    integer :: i, s
    logical :: dummy
    do i = 1, st%nb
      if (st%basis(i)%live .and. st%basis(i)%dim == k) then
        st%owner(st%basis(i)%idx(st%basis(i)%n)) = 0
        st%basis(i)%live = .false.
      end if
    end do
    st%rank(k) = 0
    do s = 1, st%c%n
      if (st%c%alive(s) .and. st%c%dimv(s) == k) then
        dummy = insert_column(st, s)
        if (dummy) st%rank(k) = st%rank(k) + 1
      end if
    end do
  end subroutine rebuild_dim

  subroutine log_append(st, op, sid, orient)
    type(inc_t), intent(inout) :: st
    character(len=*), intent(in) :: op, sid
    integer, intent(in) :: orient
    type(rec_t) :: r
    integer :: b(0:MAXD)
    character(len=64) :: newroot
    call inc_betti(st, b)
    call complex_root(st%c, st%f, b, newroot)
    st%seq = st%seq + 1
    call rec_set(r, 'betti', betti_string(st%c, b))
    call rec_set(r, 'field', field_name(st%f))
    call rec_set(r, 'kind', 'topology_update')
    call rec_set(r, 'new_root', newroot)
    call rec_set(r, 'op', op)
    call rec_set(r, 'orientation', itoa(orient))
    call rec_set(r, 'prev_commit', st%head)
    call rec_set(r, 'prev_root', st%root)
    call rec_set(r, 'schema', 'jwst-lrd/topology/update/v1')
    call rec_set(r, 'seq', itoa(st%seq))
    call rec_set(r, 'simplex', sid)
    call sbuf_add(st%log, rec_serialize(r))
    st%head = rec_commit(r)
    st%root = newroot
  end subroutine log_append

  subroutine inc_add(st, d, vin, err)
    type(inc_t), intent(inout) :: st
    integer, intent(in) :: d
    integer(int64), intent(in) :: vin(:)
    integer, intent(out) :: err
    integer :: s
    call add_simplex(st%c, d, vin, err, s)
    if (err /= TERR_OK) return
    call ensure_owner(st)
    if (d >= 1) then
      if (insert_column(st, s)) st%rank(d) = st%rank(d) + 1
    end if
    call log_append(st, 'add', simplex_id(st%c%verts(:, s), d), st%c%orient(s))
  end subroutine inc_add

  subroutine inc_remove(st, vin, err)
    type(inc_t), intent(inout) :: st
    integer(int64), intent(in) :: vin(:)
    integer, intent(out) :: err
    integer(int64) :: vs(0:MAXD)
    integer :: d, sgn, s, o
    logical :: deg
    d = size(vin) - 1
    vs = -1
    if (d >= 0 .and. d <= MAXD) call canon_sort(vin, vs(0:d), sgn, deg)
    call remove_simplex(st%c, vin, err)
    if (err /= TERR_OK) return
    s = 0
    o = 0
    if (d >= 1) call rebuild_dim(st, d)
    call log_append(st, 'remove', simplex_id(vs, d), o)
  end subroutine inc_remove

  !> Verify an update log: every entry's prev_commit equals the previous entry's
  !> commitment, seq increments by 1, prev_root equals the previous new_root.
  !> Returns the index of the first bad entry (0 if the whole chain verifies).
  subroutine verify_log(s, genesis_root, nent, first_bad, head)
    character(len=*), intent(in) :: s
    character(len=64), intent(in) :: genesis_root
    integer, intent(out) :: nent, first_bad
    character(len=64), intent(out) :: head
    type(rec_t), allocatable :: recs(:)
    integer, allocatable :: st(:), en(:)
    character(len=64) :: prevroot
    character(len=:), allocatable :: seqs
    logical :: ok
    integer :: i
    head = repeat('0', 64); prevroot = genesis_root
    first_bad = 0
    call parse_records(s, recs, nent, st, en, ok)
    if (.not. ok) then
      first_bad = -1; return
    end if
    do i = 1, nent
      seqs = itoa(i)
      if (rec_get(recs(i), 'prev_commit') /= head .or. rec_get(recs(i), 'seq') /= seqs &
          .or. rec_get(recs(i), 'prev_root') /= prevroot) then
        first_bad = i; return
      end if
      head = commit_bytes(s(st(i):en(i)))
      prevroot = rec_get(recs(i), 'new_root')
    end do
  end subroutine verify_log

end module topo_incremental
