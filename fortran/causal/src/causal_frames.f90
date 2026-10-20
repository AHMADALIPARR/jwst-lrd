! Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
! Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
! SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
!
! causal_frames: explicit coordinate frames, registered inertial transforms (Lorentz
! boosts plus translation) and the spacetime-model hook for redshift data.
!
! Frame kinds:
!   FK_INERTIAL         local inertial Minkowski chart, metric diag(-1,+1,+1,+1),
!                       coordinates (c t, x, y, z).
!   FK_COSMO_REDSHIFT   cosmological / redshift-derived quantities.  NOT a Minkowski
!                       chart.  Never compared, never converted implicitly.
!   FK_INVALID          explicitly invalid / unusable frame.
!
! Transforms: X_to = Lambda(beta) X_from + offset, with X = (c t, x, y, z) and beta the
! velocity of frame `to` relative to frame `from` in units of c (|beta| < 1).  Only
! registered transforms between two FK_INERTIAL frames are allowed; the inverse is
! applied automatically.  No other cross-frame comparison exists.
module causal_frames
  use causal_units
  use causal_interval
  use causal_coords
  implicit none
  private

  integer, parameter, public :: FK_INVALID = 0, FK_INERTIAL = 1, FK_COSMO_REDSHIFT = 2

  ! status codes
  integer, parameter, public :: ST_OK = 0, ST_DUP_FRAME = 1, ST_UNKNOWN_FRAME = 2, &
       ST_NOT_INERTIAL = 3, ST_BAD_BETA = 4, ST_NO_SPACETIME_MODEL = 5, &
       ST_MODEL_OUTPUT_NOT_INERTIAL = 6, ST_DUP_TRANSFORM = 7, ST_BAD_ARG = 8

  type, public :: frame
    integer :: id = 0
    integer :: kind = FK_INVALID
    character(len=64) :: name = ''
  end type frame

  type, public :: boost_transform
    integer :: from_id = 0, to_id = 0
    real(dp) :: beta(3) = 0.0_dp
    real(dp) :: offset(4) = 0.0_dp      ! (c t0, x0, y0, z0) in metres, in frame `to`
  end type boost_transform

  type, public :: frame_registry
    integer :: nf = 0, nt = 0
    type(frame), allocatable :: f(:)
    type(boost_transform), allocatable :: tr(:)
  end type frame_registry

  ! ---------------------------------------------------------------- spacetime model hook
  abstract interface
    subroutine redshift_map_iface(z, dir, out_frame_id, c, ok)
      import :: interval, stcoord, dp
      type(interval), intent(in) :: z
      real(dp), intent(in) :: dir(3)
      integer, intent(in) :: out_frame_id
      type(stcoord), intent(out) :: c
      logical, intent(out) :: ok
    end subroutine redshift_map_iface
  end interface

  ! A declared spacetime model must name itself and supply a mapping.  NONE is
  ! implemented in this repository; the default-initialised model is undeclared.
  type, public :: spacetime_model
    character(len=64) :: name = ''
    logical :: declared = .false.
    procedure(redshift_map_iface), pointer, nopass :: map => null()
  end type spacetime_model

  public :: redshift_map_iface
  public :: reg_init, reg_add_frame, reg_add_boost, reg_frame_index, reg_frame_kind, &
            reg_find_transform, boost_matrix, apply_transform, transform_coord, &
            redshift_to_local, frame_kind_name, frame_kind_from_name

contains

  pure function frame_kind_name(k) result(s)
    integer, intent(in) :: k
    character(len=:), allocatable :: s
    select case (k)
    case (FK_INERTIAL);       s = 'inertial'
    case (FK_COSMO_REDSHIFT); s = 'cosmological_redshift'
    case default;             s = 'invalid'
    end select
  end function frame_kind_name

  pure integer function frame_kind_from_name(s)
    character(len=*), intent(in) :: s
    select case (s)
    case ('inertial');              frame_kind_from_name = FK_INERTIAL
    case ('cosmological_redshift'); frame_kind_from_name = FK_COSMO_REDSHIFT
    case default;                   frame_kind_from_name = FK_INVALID
    end select
  end function frame_kind_from_name

  subroutine reg_init(reg)
    type(frame_registry), intent(out) :: reg
    allocate(reg%f(4), reg%tr(4))
    reg%nf = 0
    reg%nt = 0
  end subroutine reg_init

  subroutine reg_add_frame(reg, id, kind, name, st)
    type(frame_registry), intent(inout) :: reg
    integer, intent(in) :: id, kind
    character(len=*), intent(in) :: name
    integer, intent(out) :: st
    type(frame), allocatable :: tmp(:)
    if (id <= 0 .or. len_trim(name) > 64) then
      st = ST_BAD_ARG
      return
    end if
    if (reg_frame_index(reg, id) /= 0) then
      st = ST_DUP_FRAME
      return
    end if
    if (reg%nf == size(reg%f)) then
      allocate(tmp(2 * size(reg%f)))
      tmp(1:reg%nf) = reg%f(1:reg%nf)
      call move_alloc(tmp, reg%f)
    end if
    reg%nf = reg%nf + 1
    reg%f(reg%nf) = frame(id, kind, name)
    st = ST_OK
  end subroutine reg_add_frame

  pure integer function reg_frame_index(reg, id)
    type(frame_registry), intent(in) :: reg
    integer, intent(in) :: id
    integer :: i
    reg_frame_index = 0
    do i = 1, reg%nf
      if (reg%f(i)%id == id) then
        reg_frame_index = i
        return
      end if
    end do
  end function reg_frame_index

  ! Kind of a frame id; unknown ids report FK_INVALID and known=.false.
  pure subroutine reg_frame_kind(reg, id, kind, known)
    type(frame_registry), intent(in) :: reg
    integer, intent(in) :: id
    integer, intent(out) :: kind
    logical, intent(out) :: known
    integer :: i
    i = reg_frame_index(reg, id)
    known = i /= 0
    kind = FK_INVALID
    if (known) kind = reg%f(i)%kind
  end subroutine reg_frame_kind

  subroutine reg_add_boost(reg, from_id, to_id, beta, offset, st)
    type(frame_registry), intent(inout) :: reg
    integer, intent(in) :: from_id, to_id
    real(dp), intent(in) :: beta(3), offset(4)
    integer, intent(out) :: st
    integer :: ka, kb, idx
    logical :: kna, knb, inv
    type(boost_transform), allocatable :: tmp(:)
    call reg_frame_kind(reg, from_id, ka, kna)
    call reg_frame_kind(reg, to_id, kb, knb)
    if (.not. (kna .and. knb)) then
      st = ST_UNKNOWN_FRAME
      return
    end if
    if (ka /= FK_INERTIAL .or. kb /= FK_INERTIAL) then
      st = ST_NOT_INERTIAL
      return
    end if
    if (from_id == to_id) then
      st = ST_BAD_ARG
      return
    end if
    if (.not. (sum(beta**2) < 1.0_dp)) then
      st = ST_BAD_BETA
      return
    end if
    call reg_find_transform(reg, from_id, to_id, idx, inv)
    if (idx /= 0) then
      st = ST_DUP_TRANSFORM
      return
    end if
    if (reg%nt == size(reg%tr)) then
      allocate(tmp(2 * size(reg%tr)))
      tmp(1:reg%nt) = reg%tr(1:reg%nt)
      call move_alloc(tmp, reg%tr)
    end if
    reg%nt = reg%nt + 1
    reg%tr(reg%nt) = boost_transform(from_id, to_id, beta, offset)
    st = ST_OK
  end subroutine reg_add_boost

  ! idx=0 if no registered transform links the two frames.
  pure subroutine reg_find_transform(reg, from_id, to_id, idx, inverse)
    type(frame_registry), intent(in) :: reg
    integer, intent(in) :: from_id, to_id
    integer, intent(out) :: idx
    logical, intent(out) :: inverse
    integer :: i
    idx = 0
    inverse = .false.
    do i = 1, reg%nt
      if (reg%tr(i)%from_id == from_id .and. reg%tr(i)%to_id == to_id) then
        idx = i
        return
      end if
      if (reg%tr(i)%from_id == to_id .and. reg%tr(i)%to_id == from_id) then
        idx = i
        inverse = .true.
        return
      end if
    end do
  end subroutine reg_find_transform

  ! Pure boost matrix acting on (c t, x, y, z).
  pure function boost_matrix(beta) result(L)
    real(dp), intent(in) :: beta(3)
    real(dp) :: L(4, 4)
    real(dp) :: b2, g
    integer :: i, j
    b2 = sum(beta**2)
    L = 0.0_dp
    do i = 1, 4
      L(i, i) = 1.0_dp
    end do
    if (.not. (b2 > 0.0_dp)) return     ! identity for beta = 0
    g = 1.0_dp / sqrt(1.0_dp - b2)
    L(1, 1) = g
    do i = 1, 3
      L(1, i + 1) = -g * beta(i)
      L(i + 1, 1) = -g * beta(i)
      do j = 1, 3
        L(i + 1, j + 1) = merge(1.0_dp, 0.0_dp, i == j) + (g - 1.0_dp) * beta(i) * beta(j) / b2
      end do
    end do
  end function boost_matrix

  ! Interval image of a 4-vector of intervals under X' = L X + off (conservative).
  pure function apply_transform(L, off, X) result(Y)
    real(dp), intent(in) :: L(4, 4), off(4)
    type(interval), intent(in) :: X(4)
    type(interval) :: Y(4)
    integer :: i, j
    do i = 1, 4
      Y(i) = iv_point(off(i))
      do j = 1, 4
        if (abs(L(i, j)) > 0.0_dp) Y(i) = Y(i) + iv_scale(X(j), L(i, j))
      end do
    end do
  end function apply_transform

  ! Express coordinate c (in its own frame) in frame to_id using a registered
  ! transform.  ok=.false. if none is registered.
  pure subroutine transform_coord(reg, c, to_id, r, ok)
    type(frame_registry), intent(in) :: reg
    type(stcoord), intent(in) :: c
    integer, intent(in) :: to_id
    type(stcoord), intent(out) :: r
    logical, intent(out) :: ok
    integer :: idx
    logical :: inv
    type(interval) :: X(4), Y(4)
    real(dp) :: L(4, 4), off(4)
    integer :: i
    ok = .false.
    r = c
    if (c%frame_id == to_id) then
      ok = .true.
      return
    end if
    call reg_find_transform(reg, c%frame_id, to_id, idx, inv)
    if (idx == 0) return
    X(1) = iv_scale(c%t, C_LIGHT)
    X(2:4) = c%x
    if (.not. inv) then
      L = boost_matrix(reg%tr(idx)%beta)
      Y = apply_transform(L, reg%tr(idx)%offset, X)
    else
      ! X_from = Lambda(-beta) (X_to - offset)
      L = boost_matrix(-reg%tr(idx)%beta)
      do i = 1, 4
        X(i) = X(i) - iv_point(reg%tr(idx)%offset(i))
      end do
      off = 0.0_dp
      Y = apply_transform(L, off, X)
    end if
    r%frame_id = to_id
    r%t = iv_scale(Y(1), 1.0_dp / C_LIGHT)
    ! 1/c is inexact: widen by one more ulp on each side to stay enclosing.
    r%t = iv_make(nearest(r%t%lo, -1.0_dp), nearest(r%t%hi, 1.0_dp))
    r%x = Y(2:4)
    ok = .true.
  end subroutine transform_coord

  ! The ONLY sanctioned route from a redshift to local Minkowski coordinates.
  ! Requires an explicitly declared spacetime model with a mapping procedure, and the
  ! output frame must be a registered inertial frame.  With no model: rejected.
  subroutine redshift_to_local(reg, model, z, dir, out_frame_id, c, st)
    type(frame_registry), intent(in) :: reg
    type(spacetime_model), intent(in) :: model
    type(interval), intent(in) :: z
    real(dp), intent(in) :: dir(3)
    integer, intent(in) :: out_frame_id
    type(stcoord), intent(out) :: c
    integer, intent(out) :: st
    integer :: k
    logical :: known, ok
    c = stcoord()
    if (.not. model%declared .or. .not. associated(model%map) .or. len_trim(model%name) == 0) then
      st = ST_NO_SPACETIME_MODEL
      return
    end if
    call reg_frame_kind(reg, out_frame_id, k, known)
    if (.not. known) then
      st = ST_UNKNOWN_FRAME
      return
    end if
    if (k /= FK_INERTIAL) then
      st = ST_MODEL_OUTPUT_NOT_INERTIAL
      return
    end if
    call model%map(z, dir, out_frame_id, c, ok)
    if (.not. ok .or. c%frame_id /= out_frame_id .or. .not. coord_valid(c)) then
      st = ST_BAD_ARG
      c = stcoord()
      return
    end if
    st = ST_OK
  end subroutine redshift_to_local

end module causal_frames
