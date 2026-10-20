! SPDX-License-Identifier: AGPL-3.0-only
! Also subject to the SnapKitty Opaque License; see LICENSE and
! SNAPKITTY_OPAQUE_LICENSE.md at the repository root.
!
! LRD-ARR-v1 reader/writer (research/CONTRACTS.md): <p>.f64 raw
! little-endian binary64 + <p>.hdr key=value (format, name, length, unit).
module lrd_io
  use, intrinsic :: iso_fortran_env, only: real64, int64, error_unit
  implicit none
  private
  integer, parameter :: dp = real64
  public :: read_lrd, write_lrd, hdr_get, die
contains
  ! Raw .f64 files are little-endian; stream I/O uses native order, so
  ! refuse to run on a big-endian host rather than silently byte-swap.
  subroutine require_little_endian()
    use, intrinsic :: iso_fortran_env, only: int8, int32
    integer(int8) :: bytes(4)
    bytes = transfer(1_int32, bytes)
    if (bytes(1) /= 1_int8) call die('big-endian host not supported')
  end subroutine require_little_endian

  subroutine die(msg)
    character(*), intent(in) :: msg
    write (error_unit, '(a)') 'lrdref: ' // msg
    error stop 2
  end subroutine die

  function hdr_get(prefix, key) result(val)
    character(*), intent(in) :: prefix, key
    character(:), allocatable :: val
    character(len=4096) :: line
    integer :: u, ios, eq
    logical :: ex
    val = ''
    inquire (file=prefix // '.hdr', exist=ex)
    if (.not. ex) call die('missing ' // prefix // '.hdr')
    open (newunit=u, file=prefix // '.hdr', status='old', action='read', iostat=ios)
    if (ios /= 0) call die('cannot open ' // prefix // '.hdr')
    do
      read (u, '(a)', iostat=ios) line
      if (ios /= 0) exit
      eq = index(line, '=')
      if (eq > 1) then
        if (line(1:eq-1) == key) then
          val = trim(line(eq+1:))
          exit
        end if
      end if
    end do
    close (u)
  end function hdr_get

  subroutine read_lrd(prefix, a, unit)
    character(*), intent(in) :: prefix
    real(dp), allocatable, intent(out) :: a(:)
    character(:), allocatable, intent(out) :: unit
    character(:), allocatable :: s
    integer(int64) :: n, sz
    integer :: u, ios
    logical :: ex
    call require_little_endian()
    if (hdr_get(prefix, 'format') /= 'LRD-ARR-v1') call die(prefix // '.hdr: format is not LRD-ARR-v1')
    s = hdr_get(prefix, 'length')
    if (len(s) == 0 .or. verify(s, '0123456789') /= 0) call die(prefix // '.hdr: bad length')
    read (s, *) n
    if (len(hdr_get(prefix, 'name')) == 0) call die(prefix // '.hdr: missing name')
    unit = hdr_get(prefix, 'unit')
    inquire (file=prefix // '.f64', exist=ex, size=sz)
    if (.not. ex) call die('missing ' // prefix // '.f64')
    if (sz /= 8_int64 * n) call die(prefix // ': data size /= 8*length')
    allocate (a(n))
    if (n > 0) then
      open (newunit=u, file=prefix // '.f64', access='stream', form='unformatted', &
           status='old', action='read', iostat=ios)
      if (ios /= 0) call die('cannot open ' // prefix // '.f64')
      read (u, iostat=ios) a
      if (ios /= 0) call die('short read ' // prefix // '.f64')
      close (u)
    end if
  end subroutine read_lrd

  subroutine write_lrd(prefix, a, unit)
    character(*), intent(in) :: prefix, unit
    real(dp), intent(in) :: a(:)
    integer :: u, i, slash
    call require_little_endian()
    open (newunit=u, file=prefix // '.f64', access='stream', form='unformatted', &
         status='replace', action='write')
    write (u) a
    close (u)
    slash = 0
    do i = len(prefix), 1, -1
      if (prefix(i:i) == '/') then
        slash = i
        exit
      end if
    end do
    open (newunit=u, file=prefix // '.hdr', status='replace', action='write')
    write (u, '(a)') 'format=LRD-ARR-v1'
    write (u, '(a)') 'name=' // prefix(slash+1:)
    write (u, '(a,i0)') 'length=', size(a)
    write (u, '(a)') 'unit=' // unit
    write (u, '(a)') 'producer=tests/futhark/fortran-ref/lrdref'
    close (u)
  end subroutine write_lrd
end module lrd_io
