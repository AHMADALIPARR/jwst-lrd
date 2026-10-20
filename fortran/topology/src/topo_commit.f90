! Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
! SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
! Licensed under AGPL-3.0-only plus the SnapKitty Opaque License (dual license, intentional).
! See LICENSE and SNAPKITTY_OPAQUE_LICENSE.md at the repository root.
!
! topo_commit: authenticated complex commitments.
!  * One LRD-REC-v1 leaf record per alive simplex, in global canonical order
!    (dimension ascending, then lexicographic vertex tuple).  Index = 0-based
!    position in that order.  Fields:
!      cofaces      comma list of coface indices, ascending ("" if none)
!      dim          k
!      face_signs   comma list of incidence coefficients [sigma:face_i], i = 0..k
!      faces        comma list of face indices, face i omits sorted vertex i
!      id           canonical ID "k:v0,...,vk"
!      index        0-based global canonical index
!      kind         simplex
!      orientation  1 | -1  (parity of stored vertex order vs ascending)
!      schema       jwst-lrd/topology/simplex/v1
!      vertices     ascending comma list of vertex labels
!  * Leaf commitment = LRD-COMMIT-v1 commitment of the leaf record.
!  * Merkle tree: parent = commitment of record {kind=merkle_node,left,right};
!    an odd last node is promoted unchanged (no duplication); empty tree =
!    commitment of {kind=merkle_empty}.
!  * Root record {betti, counts, field, field_kind, field_p, kind=complex_root,
!    leaves, max_dim, merkle_root, schema}; its commitment is THE complex commitment.
!  * Serialized complex = leaf record serializations (in order) || root record
!    serialization.  Betti numbers are part of the root but never stand in for it.
module topo_commit
  use, intrinsic :: iso_fortran_env, only: int64
  use topo_sha256
  use topo_record
  use topo_field
  use topo_complex
  use topo_homology
  implicit none
  private
  public :: complex_root, serialize_complex, merkle_root, leaf_records, verify_serialized, &
            join_ints, rebuild_from_records, betti_string

contains

  function join_ints(a) result(s)
    integer(int64), intent(in) :: a(:)
    character(len=:), allocatable :: s
    type(sbuf_t) :: b
    integer :: i
    do i = 1, size(a)
      if (i > 1) call sbuf_add(b, ',')
      call sbuf_add(b, itoa(a(i)))
    end do
    s = sbuf_str(b)
  end function join_ints

  function betti_string(c, betti) result(s)
    type(complex_t), intent(in) :: c
    integer, intent(in) :: betti(0:MAXD)
    character(len=:), allocatable :: s
    integer :: md
    md = max_dim(c)
    if (md < 0) then
      s = ''
    else
      s = join_ints(int(betti(0:md), int64))
    end if
  end function betti_string

  subroutine leaf_records(c, recs)
    type(complex_t), intent(in) :: c
    type(rec_t), allocatable, intent(out) :: recs(:)
    integer, allocatable :: idx(:), pos(:), cl(:)
    integer(int64), allocatable :: fi(:), fsg(:)
    integer :: g, s, d, i, j, t
    call global_order(c, idx, pos)
    allocate(recs(size(idx)))
    do g = 1, size(idx)
      s = idx(g); d = c%dimv(s)
      if (d >= 1) then
        allocate(fi(d + 1), fsg(d + 1))
        do i = 0, d
          fi(i + 1) = pos(c%face(i, s)) - 1
          fsg(i + 1) = incidence_sign(c, s, i)
        end do
      else
        allocate(fi(0), fsg(0))
      end if
      allocate(cl(c%cof(s)%n))
      do i = 1, c%cof(s)%n
        cl(i) = pos(c%cof(s)%v(i)) - 1
      end do
      do i = 2, size(cl)
        j = i
        do while (j > 1)
          if (cl(j-1) <= cl(j)) exit
          t = cl(j); cl(j) = cl(j-1); cl(j-1) = t; j = j - 1
        end do
      end do
      call rec_set(recs(g), 'cofaces', join_ints(int(cl, int64)))
      call rec_set(recs(g), 'dim', itoa(d))
      call rec_set(recs(g), 'face_signs', join_ints(fsg))
      call rec_set(recs(g), 'faces', join_ints(fi))
      call rec_set(recs(g), 'id', simplex_id(c%verts(:, s), d))
      call rec_set(recs(g), 'index', itoa(g - 1))
      call rec_set(recs(g), 'kind', 'simplex')
      call rec_set(recs(g), 'orientation', itoa(c%orient(s)))
      call rec_set(recs(g), 'schema', 'jwst-lrd/topology/simplex/v1')
      call rec_set(recs(g), 'vertices', join_ints(c%verts(0:d, s)))
      deallocate(fi, fsg, cl)
    end do
  end subroutine leaf_records

  function merkle_root(leaves, n) result(root)
    character(len=64), intent(in) :: leaves(:)
    integer, intent(in) :: n
    character(len=64) :: root
    character(len=64), allocatable :: lv(:)
    type(rec_t) :: r
    integer :: m, i, k
    if (n == 0) then
      call rec_set(r, 'kind', 'merkle_empty')
      root = rec_commit(r); return
    end if
    lv = leaves(1:n)
    m = n
    do while (m > 1)
      k = 0
      do i = 1, m, 2
        k = k + 1
        if (i + 1 <= m) then
          r%n = 0
          call rec_set(r, 'kind', 'merkle_node')
          call rec_set(r, 'left', lv(i))
          call rec_set(r, 'right', lv(i + 1))
          lv(k) = rec_commit(r)
        else
          lv(k) = lv(i)
        end if
      end do
      m = k
    end do
    root = lv(1)
  end function merkle_root

  function root_record(c, f, betti, mroot) result(r)
    type(complex_t), intent(in) :: c
    type(field_t), intent(in) :: f
    integer, intent(in) :: betti(0:MAXD)
    character(len=64), intent(in) :: mroot
    type(rec_t) :: r
    integer(int64) :: counts(0:MAXD)
    integer :: k, md
    md = max_dim(c)
    do k = 0, MAXD
      counts(k) = count_dim(c, k)
    end do
    call rec_set(r, 'betti', betti_string(c, betti))
    if (md >= 0) then
      call rec_set(r, 'counts', join_ints(counts(0:md)))
    else
      call rec_set(r, 'counts', '')
    end if
    call rec_set(r, 'field', field_name(f))
    if (f%kind == FIELD_Q) then
      call rec_set(r, 'field_kind', 'Q'); call rec_set(r, 'field_p', '0')
    else
      call rec_set(r, 'field_kind', 'GFP'); call rec_set(r, 'field_p', itoa(f%p))
    end if
    call rec_set(r, 'kind', 'complex_root')
    call rec_set(r, 'leaves', itoa(c%nalive))
    call rec_set(r, 'max_dim', itoa(md))
    call rec_set(r, 'merkle_root', mroot)
    call rec_set(r, 'schema', 'jwst-lrd/topology/complex/v1')
  end function root_record

  !> Complex commitment given the declared field and the Betti vector to bind.
  subroutine complex_root(c, f, betti, root, mroot)
    type(complex_t), intent(in) :: c
    type(field_t), intent(in) :: f
    integer, intent(in) :: betti(0:MAXD)
    character(len=64), intent(out) :: root
    character(len=64), intent(out), optional :: mroot
    type(rec_t), allocatable :: recs(:)
    character(len=64), allocatable :: lc(:)
    character(len=64) :: mr
    integer :: i
    call leaf_records(c, recs)
    allocate(lc(size(recs)))
    do i = 1, size(recs)
      lc(i) = rec_commit(recs(i))
    end do
    mr = merkle_root(lc, size(recs))
    root = rec_commit(root_record(c, f, betti, mr))
    if (present(mroot)) mroot = mr
  end subroutine complex_root

  function serialize_complex(c, f, betti) result(s)
    type(complex_t), intent(in) :: c
    type(field_t), intent(in) :: f
    integer, intent(in) :: betti(0:MAXD)
    character(len=:), allocatable :: s
    type(rec_t), allocatable :: recs(:)
    character(len=64), allocatable :: lc(:)
    type(sbuf_t) :: b
    integer :: i
    call leaf_records(c, recs)
    allocate(lc(size(recs)))
    do i = 1, size(recs)
      lc(i) = rec_commit(recs(i))
      call sbuf_add(b, rec_serialize(recs(i)))
    end do
    call sbuf_add(b, rec_serialize(root_record(c, f, betti, merkle_root(lc, size(recs)))))
    s = sbuf_str(b)
  end function serialize_complex

  subroutine parse_int_list(s, a, ok)
    character(len=*), intent(in) :: s
    integer(int64), allocatable, intent(out) :: a(:)
    logical, intent(out) :: ok
    integer :: i, n, st, ios
    ok = .true.
    if (len(s) == 0) then
      allocate(a(0)); return
    end if
    n = 1
    do i = 1, len(s)
      if (s(i:i) == ',') n = n + 1
    end do
    allocate(a(n))
    st = 1; n = 0
    do i = 1, len(s) + 1
      if (i > len(s)) then
        n = n + 1; read(s(st:), *, iostat=ios) a(n)
        if (ios /= 0) ok = .false.
      else if (s(i:i) == ',') then
        n = n + 1; read(s(st:i-1), *, iostat=ios) a(n)
        if (ios /= 0 .or. i == st) ok = .false.
        st = i + 1
      end if
    end do
  end subroutine parse_int_list

  !> Rebuild a complex from parsed simplex records (attachment rules enforced).
  subroutine rebuild_from_records(recs, nrec, c, ok)
    type(rec_t), intent(in) :: recs(:)
    integer, intent(in) :: nrec
    type(complex_t), intent(out) :: c
    logical, intent(out) :: ok
    integer(int64), allocatable :: v(:)
    integer(int64) :: t
    integer :: i, d, o, err, ios
    logical :: okl
    character(len=:), allocatable :: tmps
    ok = .true.
    call complex_init(c, max(nrec, 8))
    do i = 1, nrec
      if (rec_get(recs(i), 'kind') /= 'simplex') cycle
      tmps = rec_get(recs(i), 'dim')
      read(tmps, *, iostat=ios) d
      if (ios /= 0) then
        ok = .false.; return
      end if
      tmps = rec_get(recs(i), 'orientation')
      read(tmps, *, iostat=ios) o
      if (ios /= 0 .or. abs(o) /= 1) then
        ok = .false.; return
      end if
      call parse_int_list(rec_get(recs(i), 'vertices'), v, okl)
      if (.not. okl .or. size(v) < 1) then
        ok = .false.; return
      end if
      if (o == -1) then
        if (size(v) < 2) then
          ok = .false.; return
        end if
        t = v(1); v(1) = v(2); v(2) = t
      end if
      call add_simplex(c, d, v, err)
      if (err /= TERR_OK) then
        ok = .false.; return
      end if
    end do
  end subroutine rebuild_from_records

  !> Verify a serialized complex.
  !>  merkle_ok : Merkle root over the commitments of the STORED leaf bytes equals the
  !>              root record's merkle_root (detects any edited leaf byte).
  !>  struct_ok : rebuilding the complex from (dim, vertices, orientation) and
  !>              re-serializing reproduces the input byte-for-byte (stored incidence,
  !>              indices, Betti vector and counts are all consistent).
  !>  root_ok   : commitment of the stored root record equals the trusted root.
  subroutine verify_serialized(s, f, trusted_root, merkle_ok, struct_ok, root_ok)
    character(len=*), intent(in) :: s
    type(field_t), intent(in) :: f
    character(len=64), intent(in) :: trusted_root
    logical, intent(out) :: merkle_ok, struct_ok, root_ok
    type(rec_t), allocatable :: recs(:)
    integer, allocatable :: st(:), en(:)
    character(len=64), allocatable :: lc(:)
    type(complex_t) :: c
    integer :: nrec, i, nleaf, betti(0:MAXD), err
    logical :: ok
    merkle_ok = .false.; struct_ok = .false.; root_ok = .false.
    call parse_records(s, recs, nrec, st, en, ok)
    if (.not. ok .or. nrec < 1) return
    if (rec_get(recs(nrec), 'kind') /= 'complex_root') return
    nleaf = nrec - 1
    allocate(lc(max(nleaf, 1)))
    do i = 1, nleaf
      lc(i) = commit_bytes(s(st(i):en(i)))
    end do
    merkle_ok = (merkle_root(lc, nleaf) == rec_get(recs(nrec), 'merkle_root'))
    root_ok = (commit_bytes(s(st(nrec):en(nrec))) == trusted_root)
    call rebuild_from_records(recs, nleaf, c, ok)
    if (.not. ok) return
    call compute_betti(c, f, betti, err)
    if (err /= 0) return
    block
      character(len=:), allocatable :: s2
      s2 = serialize_complex(c, f, betti)
      struct_ok = (len(s2) == len(s))
      if (struct_ok) struct_ok = (s2 == s)
    end block
  end subroutine verify_serialized

end module topo_commit
