! SPDX-License-Identifier: AGPL-3.0-only
! Also subject to SNAPKITTY_OPAQUE_LICENSE.md (dual license, see repository root).
!
! Fortran side of the explicit ISO_C_BINDING boundary to CFITSIO (see lrd_fits_shim.c).
module lrd_fits
  use, intrinsic :: iso_c_binding, only: c_char, c_int, c_long, c_double, c_null_char
  use, intrinsic :: iso_fortran_env, only: real64
  implicit none
  private
  public :: fits_nrows, fits_read_dcol, fits_read_key, fits_nrows_ext, fits_read_dcol_ext

  interface
    function c_nrows(path, nrows) bind(C, name="lrd_fits_nrows") result(rc)
      import :: c_char, c_long, c_int
      character(kind=c_char), intent(in) :: path(*)
      integer(c_long), intent(out) :: nrows
      integer(c_int) :: rc
    end function
    function c_read_dcol(path, col, n, out, unit, unitlen) bind(C, name="lrd_fits_read_dcol") result(rc)
      import :: c_char, c_long, c_int, c_double
      character(kind=c_char), intent(in) :: path(*), col(*)
      integer(c_long), value :: n
      real(c_double), intent(out) :: out(*)
      character(kind=c_char), intent(out) :: unit(*)
      integer(c_int), value :: unitlen
      integer(c_int) :: rc
    end function
    function c_read_key(path, key, out, outlen) bind(C, name="lrd_fits_read_key") result(rc)
      import :: c_char, c_int
      character(kind=c_char), intent(in) :: path(*), key(*)
      character(kind=c_char), intent(out) :: out(*)
      integer(c_int), value :: outlen
      integer(c_int) :: rc
    end function
    function c_nrows_ext(path, ext, nrows) bind(C, name="lrd_fits_nrows_ext") result(rc)
      import :: c_char, c_long, c_int
      character(kind=c_char), intent(in) :: path(*), ext(*)
      integer(c_long), intent(out) :: nrows
      integer(c_int) :: rc
    end function
    function c_read_dcol_ext(path, ext, col, n, out, unit, unitlen) bind(C, name="lrd_fits_read_dcol_ext") result(rc)
      import :: c_char, c_long, c_int, c_double
      character(kind=c_char), intent(in) :: path(*), ext(*), col(*)
      integer(c_long), value :: n
      real(c_double), intent(out) :: out(*)
      character(kind=c_char), intent(out) :: unit(*)
      integer(c_int), value :: unitlen
      integer(c_int) :: rc
    end function
  end interface

contains

  pure function cstr(s) result(c)
    character(len=*), intent(in) :: s
    character(kind=c_char, len=len_trim(s)+1) :: c
    c = trim(s) // c_null_char
  end function

  function from_c(buf) result(s)
    character(kind=c_char), intent(in) :: buf(:)
    character(len=:), allocatable :: s
    integer :: i, n
    n = 0
    do i = 1, size(buf)
      if (buf(i) == c_null_char) exit
      n = i
    end do
    allocate(character(len=n) :: s)
    do i = 1, n
      s(i:i) = buf(i)
    end do
  end function

  integer function fits_nrows(path, n) result(rc)
    character(len=*), intent(in) :: path
    integer, intent(out) :: n
    integer(c_long) :: nl
    rc = int(c_nrows(cstr(path), nl))
    n = int(nl)
  end function

  integer function fits_read_dcol(path, col, v, unit) result(rc)
    character(len=*), intent(in) :: path, col
    real(real64), intent(out) :: v(:)
    character(len=:), allocatable, intent(out) :: unit
    character(kind=c_char) :: ubuf(72)
    rc = int(c_read_dcol(cstr(path), cstr(col), int(size(v), c_long), v, ubuf, int(size(ubuf), c_int)))
    unit = from_c(ubuf)
  end function

  integer function fits_read_key(path, key, val) result(rc)
    character(len=*), intent(in) :: path, key
    character(len=:), allocatable, intent(out) :: val
    character(kind=c_char) :: vbuf(72)
    vbuf = c_null_char
    rc = int(c_read_key(cstr(path), cstr(key), vbuf, int(size(vbuf), c_int)))
    val = from_c(vbuf)
  end function
  integer function fits_nrows_ext(path, ext, n) result(rc)
    character(len=*), intent(in) :: path, ext
    integer, intent(out) :: n
    integer(c_long) :: nl
    rc = int(c_nrows_ext(cstr(path), cstr(ext), nl))
    n = int(nl)
  end function

  integer function fits_read_dcol_ext(path, ext, col, v, unit) result(rc)
    character(len=*), intent(in) :: path, ext, col
    real(real64), intent(out) :: v(:)
    character(len=:), allocatable, intent(out) :: unit
    character(kind=c_char) :: ubuf(72)
    rc = int(c_read_dcol_ext(cstr(path), cstr(ext), cstr(col), int(size(v), c_long), v, ubuf, int(size(ubuf), c_int)))
    unit = from_c(ubuf)
  end function
end module lrd_fits
