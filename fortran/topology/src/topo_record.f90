! Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
! SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
! Licensed under AGPL-3.0-only plus the SnapKitty Opaque License (dual license, intentional).
! See LICENSE and SNAPKITTY_OPAQUE_LICENSE.md at the repository root.
!
! topo_record: LRD-REC-v1 canonical records (research/CONTRACTS.md).
!   serialization = "LRD-REC-v1\n" then, keys sorted bytewise ascending,
!                   "<len(key)>:<key><len(value)>:<value>\n" per field
!   commitment    = lowercase hex SHA-256( "LRD-COMMIT-v1" // NUL // serialization )
module topo_record
  use, intrinsic :: iso_fortran_env, only: int64
  use topo_sha256
  implicit none
  private

  type, public :: kv_t
    character(len=:), allocatable :: k, v
  end type kv_t

  type, public :: rec_t
    integer :: n = 0
    logical :: bad = .false.     ! set when an empty or otherwise invalid key was offered
    type(kv_t), allocatable :: f(:)
  end type rec_t

  type, public :: sbuf_t
    integer :: n = 0
    character(len=:), allocatable :: s
  end type sbuf_t

  public :: rec_ok, rec_set, rec_get, rec_has, rec_serialize, rec_commit, commit_bytes, &
            sbuf_add, sbuf_str, parse_records, itoa, byte_less

contains

  function itoa(i) result(s)
    class(*), intent(in) :: i
    character(len=:), allocatable :: s
    character(len=40) :: b
    select type (i)
    type is (integer)
      write(b, '(i0)') i
    type is (integer(int64))
      write(b, '(i0)') i
    class default
      b = '?'
    end select
    s = trim(b)
  end function itoa

  pure logical function byte_less(a, b)
    character(len=*), intent(in) :: a, b
    integer :: i
    do i = 1, min(len(a), len(b))
      if (ichar(a(i:i)) /= ichar(b(i:i))) then
        byte_less = ichar(a(i:i)) < ichar(b(i:i)); return
      end if
    end do
    byte_less = len(a) < len(b)
  end function byte_less

  !> Set (insert or replace) a field.
  subroutine rec_set(r, k, v)
    type(rec_t), intent(inout) :: r
    character(len=*), intent(in) :: k, v
    type(kv_t), allocatable :: t(:)
    integer :: i
    if (len(k) == 0) then
      r%bad = .true.; return        ! CONTRACTS v1.1: empty keys are rejected
    end if
    if (.not. allocated(r%f)) allocate(r%f(16))
    do i = 1, r%n
      if (r%f(i)%k == k .and. len(r%f(i)%k) == len(k)) then
        r%f(i)%v = v; return
      end if
    end do
    if (r%n == size(r%f)) then
      allocate(t(2 * size(r%f)))
      do i = 1, r%n
        t(i) = r%f(i)
      end do
      call move_alloc(t, r%f)
    end if
    r%n = r%n + 1
    r%f(r%n)%k = k
    r%f(r%n)%v = v
  end subroutine rec_set

  !> .true. iff no invalid (empty) key was ever offered to rec_set.
  logical function rec_ok(r)
    type(rec_t), intent(in) :: r
    rec_ok = .not. r%bad
  end function rec_ok

  logical function rec_has(r, k)
    type(rec_t), intent(in) :: r
    character(len=*), intent(in) :: k
    integer :: i
    rec_has = .false.
    do i = 1, r%n
      if (len(r%f(i)%k) == len(k)) then
        if (r%f(i)%k == k) then
          rec_has = .true.; return
        end if
      end if
    end do
  end function rec_has

  function rec_get(r, k) result(v)
    type(rec_t), intent(in) :: r
    character(len=*), intent(in) :: k
    character(len=:), allocatable :: v
    integer :: i
    v = ''
    do i = 1, r%n
      if (len(r%f(i)%k) == len(k)) then
        if (r%f(i)%k == k) then
          v = r%f(i)%v; return
        end if
      end if
    end do
  end function rec_get

  subroutine sbuf_add(b, s)
    type(sbuf_t), intent(inout) :: b
    character(len=*), intent(in) :: s
    character(len=:), allocatable :: t
    integer :: need, cap
    if (.not. allocated(b%s)) allocate(character(len=1024) :: b%s)
    need = b%n + len(s)
    if (need > len(b%s)) then
      cap = max(2 * len(b%s), need)
      allocate(character(len=cap) :: t)
      t(1:b%n) = b%s(1:b%n)
      call move_alloc(t, b%s)
    end if
    b%s(b%n+1:need) = s
    b%n = need
  end subroutine sbuf_add

  function sbuf_str(b) result(s)
    type(sbuf_t), intent(in) :: b
    character(len=:), allocatable :: s
    if (b%n == 0) then
      s = ''
    else
      s = b%s(1:b%n)
    end if
  end function sbuf_str

  function rec_serialize(r) result(s)
    type(rec_t), intent(in) :: r
    character(len=:), allocatable :: s
    integer, allocatable :: ord(:)
    integer :: i, j, t
    type(sbuf_t) :: b
    allocate(ord(r%n))
    ord = [(i, i = 1, r%n)]
    do i = 2, r%n
      j = i
      do while (j > 1)
        if (.not. byte_less(r%f(ord(j))%k, r%f(ord(j-1))%k)) exit
        t = ord(j); ord(j) = ord(j-1); ord(j-1) = t
        j = j - 1
      end do
    end do
    call sbuf_add(b, 'LRD-REC-v1' // char(10))
    do i = 1, r%n
      call sbuf_add(b, itoa(len(r%f(ord(i))%k)) // ':' // r%f(ord(i))%k // &
                       itoa(len(r%f(ord(i))%v)) // ':' // r%f(ord(i))%v // char(10))
    end do
    s = sbuf_str(b)
  end function rec_serialize

  function commit_bytes(ser) result(h)
    character(len=*), intent(in) :: ser
    character(len=64) :: h
    h = sha256_hex('LRD-COMMIT-v1' // char(0) // ser)
  end function commit_bytes

  function rec_commit(r) result(h)
    type(rec_t), intent(in) :: r
    character(len=64) :: h
    h = commit_bytes(rec_serialize(r))
  end function rec_commit

  !> Parse a concatenation of LRD-REC-v1 serializations.  Also returns each
  !> record's exact byte span so commitments can be recomputed over stored bytes.
  !> ok = .false. on any malformed input (including unsorted or duplicate keys).
  subroutine parse_records(s, recs, nrec, starts, ends, ok)
    character(len=*), intent(in) :: s
    type(rec_t), allocatable, intent(out) :: recs(:)
    integer, intent(out) :: nrec
    integer, allocatable, intent(out) :: starts(:), ends(:)
    logical, intent(out) :: ok
    character(len=*), parameter :: HDR = 'LRD-REC-v1' // char(10)
    type(rec_t), allocatable :: tr(:)
    integer, allocatable :: ts(:)
    integer :: pos, kl, vl, i
    character(len=:), allocatable :: key, val, lastkey
    ok = .true.; nrec = 0
    allocate(recs(64), starts(64), ends(64))
    pos = 1
    do while (pos <= len(s))
      if (pos + len(HDR) - 1 > len(s)) then
        ok = .false.; return
      end if
      if (s(pos:pos+len(HDR)-1) /= HDR) then
        ok = .false.; return
      end if
      if (nrec == size(recs)) then
        allocate(tr(2*nrec))
        do i = 1, nrec
          tr(i) = recs(i)
        end do
        call move_alloc(tr, recs)
        allocate(ts(2*nrec)); ts(1:nrec) = starts(1:nrec); call move_alloc(ts, starts)
        allocate(ts(2*nrec)); ts(1:nrec) = ends(1:nrec); call move_alloc(ts, ends)
      end if
      nrec = nrec + 1
      starts(nrec) = pos
      recs(nrec)%n = 0
      pos = pos + len(HDR)
      lastkey = ''
      do
        if (pos > len(s)) exit
        if (s(pos:pos) < '0' .or. s(pos:pos) > '9') exit      ! next record header
        call read_len(kl); if (.not. ok) return
        if (pos + kl - 1 > len(s)) then
          ok = .false.; return
        end if
        if (kl == 0) then
          ok = .false.; return          ! CONTRACTS v1.1: empty keys are rejected
        end if
        key = s(pos:pos+kl-1); pos = pos + kl
        call read_len(vl); if (.not. ok) return
        if (pos + vl > len(s)) then
          ok = .false.; return
        end if
        val = s(pos:pos+vl-1); pos = pos + vl
        if (s(pos:pos) /= char(10)) then
          ok = .false.; return
        end if
        pos = pos + 1
        if (recs(nrec)%n > 0) then
          if (.not. byte_less(lastkey, key)) then
            ok = .false.; return
          end if
        end if
        lastkey = key
        call rec_set(recs(nrec), key, val)
      end do
      ends(nrec) = pos - 1
    end do
  contains
    subroutine read_len(l)
      integer, intent(out) :: l
      integer :: st
      st = pos
      l = 0
      do while (pos <= len(s))
        if (s(pos:pos) == ':') exit
        if (s(pos:pos) < '0' .or. s(pos:pos) > '9' .or. pos - st > 9) then
          ok = .false.; return
        end if
        l = 10 * l + (ichar(s(pos:pos)) - ichar('0'))
        pos = pos + 1
      end do
      if (pos > len(s) .or. pos == st) then
        ok = .false.; return
      end if
      if (s(st:st) == '0' .and. pos - st > 1) then
        ok = .false.; return
      end if
      pos = pos + 1
    end subroutine read_len
  end subroutine parse_records

end module topo_record
