! Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
! Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
! SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
!
! causal_coords: typed spacetime coordinates.  A coordinate is ALWAYS tagged with the
! integer id of the frame it is expressed in; the numbers alone carry no meaning.
! Internal storage: t in seconds, x(1:3) in metres, each as an uncertainty interval.
! A coordinate may additionally carry a redshift interval (has_z) for events whose
! only known "position" is cosmological; such a redshift is metadata, never a
! coordinate.
module causal_coords
  use causal_units
  use causal_interval
  implicit none
  private

  type, public :: stcoord
    integer :: frame_id = 0
    type(interval) :: t                 ! s
    type(interval) :: x(3)              ! m
    logical :: has_z = .false.
    type(interval) :: z                 ! dimensionless redshift (metadata only)
  end type stcoord

  public :: make_coord, make_coord_si, make_coord_redshift, coord_valid

contains

  ! Build a coordinate from unit-tagged values and unit-tagged 1-sigma-style
  ! half-widths (interpreted as hard bounds: value +/- halfwidth).
  ! ok=.false. if any time value is not a time or any position is not a length
  ! (in particular U_REDSHIFT is refused as a length or time).
  pure subroutine make_coord(frame_id, t, t_unc, x, x_unc, c, ok)
    integer, intent(in) :: frame_id
    type(quantity), intent(in) :: t, t_unc, x(3), x_unc(3)
    type(stcoord), intent(out) :: c
    logical, intent(out) :: ok
    real(dp) :: tv, tu, xv, xu
    logical :: o1, o2
    integer :: i
    c%frame_id = frame_id
    call to_si(t, DIM_TIME, tv, o1)
    call to_si(t_unc, DIM_TIME, tu, o2)
    ok = o1 .and. o2
    if (.not. ok) return
    if (tu < 0.0_dp) then
      ok = .false.
      return
    end if
    c%t = iv_pm(tv, tu)
    do i = 1, 3
      call to_si(x(i), DIM_LENGTH, xv, o1)
      call to_si(x_unc(i), DIM_LENGTH, xu, o2)
      if (.not. (o1 .and. o2)) then
        ok = .false.
        return
      end if
      if (xu < 0.0_dp) then
        ok = .false.
        return
      end if
      c%x(i) = iv_pm(xv, xu)
    end do
    ok = coord_valid(c)
  end subroutine make_coord

  ! Convenience: SI values (s, m) given directly as intervals.
  pure function make_coord_si(frame_id, t, x) result(c)
    integer, intent(in) :: frame_id
    type(interval), intent(in) :: t, x(3)
    type(stcoord) :: c
    c%frame_id = frame_id
    c%t = t
    c%x = x
  end function make_coord_si

  ! An event whose only location is a redshift in a cosmological frame.
  ! t and x are set to point zeros and MUST NOT be read as Minkowski values;
  ! the classifier refuses any frame of kind cosmological regardless.
  pure function make_coord_redshift(frame_id, z) result(c)
    integer, intent(in) :: frame_id
    type(interval), intent(in) :: z
    type(stcoord) :: c
    c%frame_id = frame_id
    c%has_z = .true.
    c%z = z
  end function make_coord_redshift

  pure logical function coord_valid(c)
    type(stcoord), intent(in) :: c
    integer :: i
    coord_valid = iv_valid(c%t)
    do i = 1, 3
      coord_valid = coord_valid .and. iv_valid(c%x(i))
    end do
    if (c%has_z) coord_valid = coord_valid .and. iv_valid(c%z)
  end function coord_valid

end module causal_coords
