! SPDX-License-Identifier: AGPL-3.0-only
! Also subject to SNAPKITTY_OPAQUE_LICENSE.md (dual license, see repository root).
!
! LRD-ARR-v1 writer/reader: <name>.f64 raw little-endian binary64, <name>.hdr key=value.
module lrd_arr
  use lrd_const
  implicit none
  private
  public :: arr_write, arr_read, host_little_endian

contains
  logical function host_little_endian()
    integer(1) :: b(4)
    b = transfer(1_4, b)
    host_little_endian = (b(1) == 1_1)
  end function

  subroutine swap8(v)
    real(dp), intent(inout) :: v(:)
    integer(1) :: b(8)
    integer :: i
    do i = 1, size(v)
      b = transfer(v(i), b)
      b = b(8:1:-1)
      v(i) = transfer(b, v(i))
    end do
  end subroutine

  subroutine arr_write(dir, name, v, unit, source_sha256)
    character(len=*), intent(in) :: dir, name, unit, source_sha256
    real(dp), intent(in) :: v(:)
    real(dp), allocatable :: w(:)
    integer :: u
    w = v
    if (.not. host_little_endian()) call swap8(w)
    open(newunit=u, file=dir // '/' // name // '.f64', access='stream', form='unformatted', &
         status='replace', action='write')
    write(u) w
    close(u)
    open(newunit=u, file=dir // '/' // name // '.hdr', status='replace', action='write')
    write(u, '(a)') 'format=LRD-ARR-v1'
    write(u, '(a)') 'name=' // name
    write(u, '(a,i0)') 'length=', size(v)
    write(u, '(a)') 'unit=' // unit
    if (len_trim(source_sha256) > 0) write(u, '(a)') 'source_sha256=' // trim(source_sha256)
    close(u)
  end subroutine

  subroutine arr_read(dir, name, v, unit, info)
    character(len=*), intent(in) :: dir, name
    real(dp), allocatable, intent(out) :: v(:)
    character(len=:), allocatable, intent(out) :: unit
    integer, intent(out) :: info
    character(len=512) :: line
    integer :: u, n, ios, eq
    logical :: fmt_ok
    n = -1; unit = ''; fmt_ok = .false.; info = 0
    open(newunit=u, file=dir // '/' // name // '.hdr', status='old', action='read', iostat=ios)
    if (ios /= 0) then
      info = 1; return
    end if
    do
      read(u, '(a)', iostat=ios) line
      if (ios /= 0) exit
      eq = index(line, '=')
      if (eq == 0) cycle
      select case (line(1:eq - 1))
      case ('format'); fmt_ok = (trim(line(eq + 1:)) == 'LRD-ARR-v1')
      case ('length'); read(line(eq + 1:), *) n
      case ('unit'); unit = trim(line(eq + 1:))
      end select
    end do
    close(u)
    if (.not. fmt_ok .or. n < 0) then
      info = 2; return
    end if
    allocate(v(n))
    open(newunit=u, file=dir // '/' // name // '.f64', access='stream', form='unformatted', &
         status='old', action='read', iostat=ios)
    if (ios /= 0) then
      info = 3; return
    end if
    read(u, iostat=ios) v
    close(u)
    if (ios /= 0) info = 4
    if (.not. host_little_endian()) call swap8(v)
  end subroutine
end module lrd_arr
