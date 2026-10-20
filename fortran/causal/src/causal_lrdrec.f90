! Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
! Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
! SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
!
! causal_lrdrec: LRD-REC-v1 canonical records (research/CONTRACTS.md).
!   serialization = "LRD-REC-v1\n" then, for each field in bytewise-ascending key
!                   order, "<len(key)>:<key><len(value)>:<value>\n"
!   commitment    = lowercase hex SHA-256("LRD-COMMIT-v1\0" || serialization)
! Restrictions of this implementation (stricter than the contract, never looser):
!   keys   : non-empty (CONTRACTS v1.1: empty keys rejected), bytes [a-z0-9._] only;
!   values : printable ASCII 0x20..0x7E only (so byte length = character count for
!            the Curry and Self readers).
! The parser rejects: wrong header, malformed or leading-zero lengths, unsorted or
! duplicate keys, newline inside a value, bytes outside the restrictions, trailing junk.
module causal_lrdrec
  use causal_sha256
  implicit none
  private

  character(len=*), parameter, public :: REC_HEADER = 'LRD-REC-v1'
  character(len=*), parameter, public :: COMMIT_DOMAIN = 'LRD-COMMIT-v1'

  type, public :: str_t
    character(len=:), allocatable :: s
  end type str_t

  type, public :: lrd_record
    integer :: n = 0
    type(str_t), allocatable :: k(:), v(:)
  end type lrd_record

  public :: rec_init, rec_set, rec_get, rec_has, rec_serialize, rec_commitment, rec_parse, &
            key_less, valid_key, valid_value, write_bytes, read_bytes, itoa

contains

  pure function itoa(i) result(s)
    integer, intent(in) :: i
    character(len=:), allocatable :: s
    character(len=24) :: b
    write (b, '(I0)') i
    s = trim(b)
  end function itoa

  subroutine rec_init(r)
    type(lrd_record), intent(out) :: r
    r%n = 0
    allocate(r%k(64), r%v(64))
  end subroutine rec_init

  pure logical function key_less(a, b)
    character(len=*), intent(in) :: a, b
    integer :: i
    do i = 1, min(len(a), len(b))
      if (iachar(a(i:i)) /= iachar(b(i:i))) then
        key_less = iachar(a(i:i)) < iachar(b(i:i))
        return
      end if
    end do
    key_less = len(a) < len(b)
  end function key_less

  pure logical function valid_key(s)
    character(len=*), intent(in) :: s
    integer :: i, c
    valid_key = len(s) > 0
    do i = 1, len(s)
      c = iachar(s(i:i))
      if (.not. ((c >= iachar('a') .and. c <= iachar('z')) .or. (c >= iachar('0') .and. &
          c <= iachar('9')) .or. s(i:i) == '.' .or. s(i:i) == '_')) valid_key = .false.
    end do
  end function valid_key

  pure logical function valid_value(s)
    character(len=*), intent(in) :: s
    integer :: i, c
    valid_value = .true.
    do i = 1, len(s)
      c = iachar(s(i:i))
      if (c < 32 .or. c > 126) valid_value = .false.
    end do
  end function valid_value

  ! ok=.false. on invalid key/value or duplicate key.
  subroutine rec_set(r, key, val, ok)
    type(lrd_record), intent(inout) :: r
    character(len=*), intent(in) :: key, val
    logical, intent(out) :: ok
    type(str_t), allocatable :: tk(:), tv(:)
    integer :: i
    ok = valid_key(key) .and. valid_value(val)
    if (.not. ok) return
    do i = 1, r%n
      if (r%k(i)%s == key .and. len(r%k(i)%s) == len(key)) then
        ok = .false.
        return
      end if
    end do
    if (r%n == size(r%k)) then
      allocate(tk(2 * r%n), tv(2 * r%n))
      do i = 1, r%n
        call move_alloc(r%k(i)%s, tk(i)%s)
        call move_alloc(r%v(i)%s, tv(i)%s)
      end do
      call move_alloc(tk, r%k)
      call move_alloc(tv, r%v)
    end if
    r%n = r%n + 1
    r%k(r%n)%s = key
    r%v(r%n)%s = val
  end subroutine rec_set

  pure logical function rec_has(r, key)
    type(lrd_record), intent(in) :: r
    character(len=*), intent(in) :: key
    integer :: i
    rec_has = .false.
    do i = 1, r%n
      if (len(r%k(i)%s) == len(key)) then
        if (r%k(i)%s == key) rec_has = .true.
      end if
    end do
  end function rec_has

  subroutine rec_get(r, key, val, found)
    type(lrd_record), intent(in) :: r
    character(len=*), intent(in) :: key
    character(len=:), allocatable, intent(out) :: val
    logical, intent(out) :: found
    integer :: i
    found = .false.
    val = ''
    do i = 1, r%n
      if (len(r%k(i)%s) == len(key)) then
        if (r%k(i)%s == key) then
          val = r%v(i)%s
          found = .true.
          return
        end if
      end if
    end do
  end subroutine rec_get

  ! Canonical serialization (fields sorted bytewise by key; insertion order ignored).
  subroutine rec_serialize(r, buf)
    type(lrd_record), intent(in) :: r
    character(len=:), allocatable, intent(out) :: buf
    integer :: perm(r%n), i, j, t, total, p
    character(len=:), allocatable :: line
    do i = 1, r%n
      perm(i) = i
    end do
    ! insertion sort by bytewise key order (n is small; deterministic)
    do i = 2, r%n
      t = perm(i)
      j = i - 1
      do while (j >= 1)
        if (.not. key_less(r%k(t)%s, r%k(perm(j))%s)) exit
        perm(j + 1) = perm(j)
        j = j - 1
      end do
      perm(j + 1) = t
    end do
    total = len(REC_HEADER) + 1
    do i = 1, r%n
      total = total + len(itoa(len(r%k(i)%s))) + 1 + len(r%k(i)%s) + &
              len(itoa(len(r%v(i)%s))) + 1 + len(r%v(i)%s) + 1
    end do
    allocate(character(len=total) :: buf)
    buf(1:len(REC_HEADER) + 1) = REC_HEADER // achar(10)
    p = len(REC_HEADER) + 2
    do i = 1, r%n
      j = perm(i)
      line = itoa(len(r%k(j)%s)) // ':' // r%k(j)%s // itoa(len(r%v(j)%s)) // ':' // &
             r%v(j)%s // achar(10)
      buf(p:p + len(line) - 1) = line
      p = p + len(line)
    end do
  end subroutine rec_serialize

  pure function rec_commitment(buf) result(hex)
    character(len=*), intent(in) :: buf
    character(len=64) :: hex
    hex = sha256_hex(COMMIT_DOMAIN // achar(0) // buf)
  end function rec_commitment

  ! Parse a decimal length at buf(p:), terminated by ':'; no leading zeros.
  pure subroutine parse_len(buf, p, n, ok)
    character(len=*), intent(in) :: buf
    integer, intent(inout) :: p
    integer, intent(out) :: n
    logical, intent(out) :: ok
    integer :: start, d
    ok = .false.
    n = 0
    start = p
    do while (p <= len(buf))
      if (buf(p:p) == ':') exit
      d = index('0123456789', buf(p:p)) - 1
      if (d < 0) return
      if (p - start >= 9) return
      n = 10 * n + d
      p = p + 1
    end do
    if (p > len(buf) .or. p == start) return
    if (buf(start:start) == '0' .and. p - start > 1) return
    p = p + 1       ! skip ':'
    ok = .true.
  end subroutine parse_len

  subroutine rec_parse(buf, r, ok, err)
    character(len=*), intent(in) :: buf
    type(lrd_record), intent(out) :: r
    logical, intent(out) :: ok
    character(len=:), allocatable, intent(out) :: err
    integer :: p, nk, nv
    character(len=:), allocatable :: key, val, prev
    logical :: o
    call rec_init(r)
    ok = .false.
    err = ''
    if (len(buf) < len(REC_HEADER) + 1) then
      err = 'short'
      return
    end if
    if (buf(1:len(REC_HEADER) + 1) /= REC_HEADER // achar(10)) then
      err = 'bad_header'
      return
    end if
    p = len(REC_HEADER) + 2
    prev = ''
    do while (p <= len(buf))
      call parse_len(buf, p, nk, o)
      if (.not. o) then
        err = 'bad_key_length'
        return
      end if
      if (p + nk - 1 > len(buf)) then
        err = 'truncated_key'
        return
      end if
      key = buf(p:p + nk - 1)
      p = p + nk
      call parse_len(buf, p, nv, o)
      if (.not. o) then
        err = 'bad_value_length'
        return
      end if
      if (p + nv > len(buf)) then
        err = 'truncated_value'
        return
      end if
      val = buf(p:p + nv - 1)
      p = p + nv
      if (buf(p:p) /= achar(10)) then
        err = 'missing_newline'
        return
      end if
      p = p + 1
      if (.not. valid_key(key)) then
        err = 'bad_key:' // key
        return
      end if
      if (.not. valid_value(val)) then
        err = 'bad_value_bytes:' // key
        return
      end if
      if (r%n > 0) then
        if (.not. key_less(prev, key)) then
          err = 'unsorted_or_duplicate:' // key
          return
        end if
      end if
      call rec_set(r, key, val, o)
      if (.not. o) then
        err = 'set_failed:' // key
        return
      end if
      prev = key
    end do
    ok = .true.
  end subroutine rec_parse

  subroutine write_bytes(path, buf, ok)
    character(len=*), intent(in) :: path, buf
    logical, intent(out) :: ok
    integer :: u, ios
    open (newunit=u, file=path, access='stream', form='unformatted', status='replace', &
          action='write', iostat=ios)
    ok = ios == 0
    if (.not. ok) return
    write (u, iostat=ios) buf
    ok = ios == 0
    close (u)
  end subroutine write_bytes

  subroutine read_bytes(path, buf, ok)
    character(len=*), intent(in) :: path
    character(len=:), allocatable, intent(out) :: buf
    logical, intent(out) :: ok
    integer :: u, ios, sz
    ok = .false.
    open (newunit=u, file=path, access='stream', form='unformatted', status='old', &
          action='read', iostat=ios)
    if (ios /= 0) return
    inquire (unit=u, size=sz)
    if (sz < 0) then
      close (u)
      return
    end if
    allocate(character(len=sz) :: buf)
    ios = 0
    if (sz > 0) read (u, iostat=ios) buf
    close (u)
    ok = ios == 0
  end subroutine read_bytes

end module causal_lrdrec
