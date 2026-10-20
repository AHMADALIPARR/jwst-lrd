! Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
! Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
! SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
!
! JWST-LRD Sovereign Scientific Runtime -- TASK 006 causal poset.
! causal_units: working precision, exact physical constants, unit-tagged quantities.
!
! Internal (SI) representation: time in seconds (s), length in metres (m), squared
! interval in square metres (m2).  Every quantity entering the subsystem carries an
! explicit unit tag and is converted to SI exactly once, with a dimension check.
! The dimensionless redshift tag U_REDSHIFT has NO conversion to time or length:
! a redshift is never silently turned into a Minkowski coordinate.
module causal_units
  use, intrinsic :: iso_fortran_env, only: real64, int64
  implicit none
  private

  integer, parameter, public :: dp = real64

  ! Exact by definition of the SI metre (since 1983).
  real(dp), parameter, public :: C_LIGHT = 299792458.0_dp      ! m / s
  ! Exact by IAU 2012 Resolution B2.
  real(dp), parameter, public :: AU_M = 149597870700.0_dp      ! m
  ! Exact (86400 SI seconds; no leap-second semantics implied).
  real(dp), parameter, public :: DAY_S = 86400.0_dp            ! s

  ! Dimensions
  integer, parameter, public :: DIM_NONE = 0, DIM_TIME = 1, DIM_LENGTH = 2, &
                                DIM_AREA = 3, DIM_REDSHIFT = 4

  ! Unit tags
  integer, parameter, public :: U_INVALID = 0, U_S = 1, U_DAY = 2, U_M = 3, U_KM = 4, &
                                U_AU = 5, U_LS = 6, U_M2 = 7, U_REDSHIFT = 8
  integer, parameter, public :: N_UNITS = 8

  type, public :: quantity
    real(dp) :: v = 0.0_dp
    integer  :: unit = U_INVALID
  end type quantity

  public :: q, unit_dim, unit_name, unit_from_name, to_si, convert_unit

contains

  pure function q(v, unit) result(r)
    real(dp), intent(in) :: v
    integer, intent(in)  :: unit
    type(quantity) :: r
    r%v = v
    r%unit = unit
  end function q

  pure integer function unit_dim(u)
    integer, intent(in) :: u
    select case (u)
    case (U_S, U_DAY);             unit_dim = DIM_TIME
    case (U_M, U_KM, U_AU, U_LS);  unit_dim = DIM_LENGTH
    case (U_M2);                   unit_dim = DIM_AREA
    case (U_REDSHIFT);             unit_dim = DIM_REDSHIFT
    case default;                  unit_dim = DIM_NONE
    end select
  end function unit_dim

  pure function unit_name(u) result(s)
    integer, intent(in) :: u
    character(len=:), allocatable :: s
    select case (u)
    case (U_S);        s = 's'
    case (U_DAY);      s = 'd'
    case (U_M);        s = 'm'
    case (U_KM);       s = 'km'
    case (U_AU);       s = 'au'
    case (U_LS);       s = 'ls'
    case (U_M2);       s = 'm2'
    case (U_REDSHIFT); s = 'z'
    case default;      s = 'invalid'
    end select
  end function unit_name

  pure integer function unit_from_name(s)
    character(len=*), intent(in) :: s
    integer :: u
    unit_from_name = U_INVALID
    do u = 1, N_UNITS
      if (unit_name(u) == s) then
        unit_from_name = u
        return
      end if
    end do
  end function unit_from_name

  ! Factor converting one unit to its SI base unit within the same dimension.
  ! Returns ok=.false. for redshift / invalid units (no physical conversion exists).
  pure subroutine si_factor(u, f, ok)
    integer, intent(in) :: u
    real(dp), intent(out) :: f
    logical, intent(out) :: ok
    ok = .true.
    select case (u)
    case (U_S);   f = 1.0_dp
    case (U_DAY); f = DAY_S
    case (U_M);   f = 1.0_dp
    case (U_KM);  f = 1000.0_dp
    case (U_AU);  f = AU_M
    case (U_LS);  f = C_LIGHT        ! one light-second in metres, exact
    case (U_M2);  f = 1.0_dp
    case default
      f = 0.0_dp
      ok = .false.
    end select
  end subroutine si_factor

  ! Convert to the SI base unit of the expected dimension.
  ! ok=.false. if the dimension differs (e.g. a redshift offered as a length).
  pure subroutine to_si(x, expected_dim, v, ok)
    type(quantity), intent(in) :: x
    integer, intent(in) :: expected_dim
    real(dp), intent(out) :: v
    logical, intent(out) :: ok
    real(dp) :: f
    v = 0.0_dp
    ok = .false.
    if (unit_dim(x%unit) /= expected_dim) return
    call si_factor(x%unit, f, ok)
    if (.not. ok) return
    v = x%v * f
  end subroutine to_si

  pure subroutine convert_unit(x, target, r, ok)
    type(quantity), intent(in) :: x
    integer, intent(in) :: target
    type(quantity), intent(out) :: r
    logical, intent(out) :: ok
    real(dp) :: fa, fb
    logical :: oka, okb
    r = quantity(0.0_dp, U_INVALID)
    ok = .false.
    if (unit_dim(x%unit) /= unit_dim(target)) return
    call si_factor(x%unit, fa, oka)
    call si_factor(target, fb, okb)
    if (.not. (oka .and. okb)) return
    if (x%unit == target) then
      r = x
    else
      r = quantity(x%v * fa / fb, target)
    end if
    ok = .true.
  end subroutine convert_unit

end module causal_units
