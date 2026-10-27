! Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
! Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
! SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
!
! causal_classify: light-cone classification with interval uncertainty, and causal
! edge validation.
!
! Sign convention: metric signature (-,+,+,+);
!     s2 = -c^2 dt^2 + |dx|^2      (m^2),   dt = t_b - t_a,  dx = x_b - x_a,
! evaluated in ONE inertial frame (b's frame; a is transformed if needed).
! With each of dt, dx_i an interval, s2 is enclosed by
!     S = -(c dt)^2 + sum_i (dx_i)^2
! using the exact interval square, so S is the exact range up to outward rounding
! (each variable occurs once).
!
! Tolerance:  tol = abs_tol + rel_tol * scale,   scale = hi((c dt)^2) + sum_i hi(dx_i^2)
!   defaults rel_tol = 1e-12, abs_tol = 0 m^2.
! Decision rule on S = [lo, hi]:
!   hi < -tol                    -> TIMELIKE
!   lo > +tol                    -> SPACELIKE
!   -tol <= lo  and  hi <= +tol  -> LIGHTLIKE
!   otherwise                    -> INDETERMINATE (S straddles a tolerance boundary)
! Direction from dt = [lo, hi]: lo > 0 FUTURE, hi < 0 PAST, else INDETERMINATE.
! (For SPACELIKE pairs the coordinate time order is frame dependent and carries no
! causal meaning; it is reported but never used.)
! Frame policy (-> INVALID_FRAME): unknown frame id, either frame of kind invalid or
! cosmological/redshift, or distinct inertial frames with no registered transform.
! Non-finite or inverted intervals -> INVALID_INPUT.
!
! Scope of the classification (read before relying on an accepted edge):
!   * Cone membership is NECESSARY but NOT SUFFICIENT for causation.  An accepted edge a -> b
!     means only that (i) b lies in the closed future light cone of a in the stated inertial
!     frame, within the tolerance and uncertainty below, and (ii) the event kinds are in the
!     allowed order.  Whether a influenced b is an assertion made by whoever proposed the
!     edge; nothing here establishes it.  A spacelike or past-directed pair can never be
!     causal under this model, but a timelike future pair need not be.
!   * The model is flat Minkowski space, one inertial frame at a time.  Cosmological
!     redshift frames are refused (INVALID_FRAME); a redshift reaches this module only
!     through redshift_to_local with an explicitly declared spacetime model.
!
! Why rel_tol = 1e-12 (an engineering margin from the arithmetic below, not a proven bound):
!   * The interval S itself already encloses its own rounding: every +, -, * on the bounds
!     in causal_interval is widened outward, so S needs no tolerance for its own arithmetic.
!   * What S does not enclose is the error of the frame transform: boost_matrix entries
!     (gamma from sqrt and division, beta_i*beta_j/b2) are plain round-to-nearest doubles,
!     and apply_transform treats them as exact.  Each term of S is as large as `scale`
!     while s2 can be near zero, so an entry error of a few units in the last place
!     (epsilon(1.0_dp) = 2.2e-16) leaves an error in s2 of a few epsilon times `scale`.
!   * Measured: tests/causal/test_boost.f90 compares s2 in two inertial frames for 200
!     deterministic pseudo-random pairs; the worst |s2_L - s2_B| / scale it printed was
!     2.6064e-15.  rel_tol = 1e-12 is about 380 times that, and about 4500 epsilon.
!     The margin is generous on purpose; it is not derived from a worst-case bound, and a
!     boost with beta very close to 1 (large gamma) has not been characterised here.
!   * Effect on the decision: for a nearly lightlike pair with spatial distance r,
!     |s2| = |r - c|dt|| (r + c|dt|) ~ 2 r |r - c|dt||, and tol ~ 2e-12 r^2, so a pair is
!     labelled LIGHTLIKE when r and c|dt| differ by up to about 1e-12 of r.  Such a pair is
!     accepted as an edge (closed cone) even if it is marginally spacelike in exact
!     arithmetic.  That is the intended behaviour of the decision rule above.
module causal_classify
  use causal_units
  use causal_interval
  use causal_coords
  use causal_frames
  use causal_events
  use, intrinsic :: ieee_arithmetic, only: ieee_is_finite
  implicit none
  private

  integer, parameter, public :: SEP_TIMELIKE = 1, SEP_LIGHTLIKE = 2, SEP_SPACELIKE = 3, &
       SEP_INDETERMINATE = 4, SEP_INVALID_FRAME = 5, SEP_INVALID_INPUT = 6
  integer, parameter, public :: DIR_NA = 0, DIR_FUTURE = 1, DIR_PAST = 2, DIR_INDETERMINATE = 3

  integer, parameter, public :: R_OK = 0, R_UNKNOWN_FRAME = 1, R_INVALID_FRAME_KIND = 2, &
       R_COSMOLOGICAL_FRAME = 3, R_NO_TRANSFORM = 4, R_BAD_INPUT = 5

  integer, parameter, public :: EDGE_OK = 0, EDGE_REJ_SPACELIKE = 1, EDGE_REJ_INDETERMINATE = 2, &
       EDGE_REJ_PAST = 3, EDGE_REJ_DIR_INDETERMINATE = 4, EDGE_REJ_INVALID_FRAME = 5, &
       EDGE_REJ_KIND = 6, EDGE_REJ_SELF = 7, EDGE_REJ_CYCLE = 8, EDGE_REJ_DUPLICATE = 9, &
       EDGE_REJ_UNKNOWN_EVENT = 10, EDGE_REJ_INVALID_INPUT = 11

  type, public :: classify_opts
    real(dp) :: rel_tol = 1.0e-12_dp
    real(dp) :: abs_tol = 0.0_dp          ! m^2
  end type classify_opts

  type, public :: classification
    integer :: sep = SEP_INVALID_INPUT
    integer :: dir = DIR_NA
    integer :: reason = R_BAD_INPUT
    type(interval) :: s2                  ! m^2
    type(interval) :: dt                  ! s
    real(dp) :: tol = 0.0_dp              ! m^2
  end type classification

  public :: classify, classify_coords, validate_edge, sep_name, dir_name, edge_code_name, &
            sep_from_name, dir_from_name, edge_code_from_name

contains

  pure function sep_name(k) result(s)
    integer, intent(in) :: k
    character(len=:), allocatable :: s
    select case (k)
    case (SEP_TIMELIKE);      s = 'timelike'
    case (SEP_LIGHTLIKE);     s = 'lightlike'
    case (SEP_SPACELIKE);     s = 'spacelike'
    case (SEP_INDETERMINATE); s = 'indeterminate'
    case (SEP_INVALID_FRAME); s = 'invalid_frame'
    case default;             s = 'invalid_input'
    end select
  end function sep_name

  pure integer function sep_from_name(s)
    character(len=*), intent(in) :: s
    integer :: k
    sep_from_name = SEP_INVALID_INPUT
    do k = 1, 6
      if (sep_name(k) == s) sep_from_name = k
    end do
  end function sep_from_name

  pure function dir_name(k) result(s)
    integer, intent(in) :: k
    character(len=:), allocatable :: s
    select case (k)
    case (DIR_FUTURE);        s = 'future'
    case (DIR_PAST);          s = 'past'
    case (DIR_INDETERMINATE); s = 'indeterminate'
    case default;             s = 'na'
    end select
  end function dir_name

  pure integer function dir_from_name(s)
    character(len=*), intent(in) :: s
    integer :: k
    dir_from_name = DIR_NA
    do k = 1, 3
      if (dir_name(k) == s) dir_from_name = k
    end do
  end function dir_from_name

  pure function edge_code_name(k) result(s)
    integer, intent(in) :: k
    character(len=:), allocatable :: s
    select case (k)
    case (EDGE_OK);                    s = 'ok'
    case (EDGE_REJ_SPACELIKE);         s = 'spacelike'
    case (EDGE_REJ_INDETERMINATE);     s = 'indeterminate'
    case (EDGE_REJ_PAST);              s = 'past_directed'
    case (EDGE_REJ_DIR_INDETERMINATE); s = 'direction_indeterminate'
    case (EDGE_REJ_INVALID_FRAME);     s = 'invalid_frame'
    case (EDGE_REJ_KIND);              s = 'kind_order'
    case (EDGE_REJ_SELF);              s = 'self_edge'
    case (EDGE_REJ_CYCLE);             s = 'cycle'
    case (EDGE_REJ_DUPLICATE);         s = 'duplicate'
    case (EDGE_REJ_UNKNOWN_EVENT);     s = 'unknown_event'
    case default;                      s = 'invalid_input'
    end select
  end function edge_code_name

  pure integer function edge_code_from_name(s)
    character(len=*), intent(in) :: s
    integer :: k
    edge_code_from_name = EDGE_REJ_INVALID_INPUT
    do k = 0, 11
      if (edge_code_name(k) == s) edge_code_from_name = k
    end do
  end function edge_code_from_name

  pure function classify_coords(reg, ca, cb, opts) result(r)
    type(frame_registry), intent(in) :: reg
    type(stcoord), intent(in) :: ca, cb
    type(classify_opts), intent(in) :: opts
    type(classification) :: r
    integer :: ka, kb, i, idx
    logical :: kna, knb, ok, inv
    type(stcoord) :: a
    type(interval) :: cdt2, dx2, s2
    real(dp) :: scale

    r = classification()
    call reg_frame_kind(reg, ca%frame_id, ka, kna)
    call reg_frame_kind(reg, cb%frame_id, kb, knb)
    r%sep = SEP_INVALID_FRAME
    r%dir = DIR_NA
    if (.not. (kna .and. knb)) then
      r%reason = R_UNKNOWN_FRAME
      return
    end if
    if (ka == FK_COSMO_REDSHIFT .or. kb == FK_COSMO_REDSHIFT) then
      r%reason = R_COSMOLOGICAL_FRAME
      return
    end if
    if (ka /= FK_INERTIAL .or. kb /= FK_INERTIAL) then
      r%reason = R_INVALID_FRAME_KIND
      return
    end if
    if (ca%frame_id /= cb%frame_id) then
      call reg_find_transform(reg, ca%frame_id, cb%frame_id, idx, inv)
      if (idx == 0) then
        r%reason = R_NO_TRANSFORM
        return
      end if
    end if
    if (.not. (coord_valid(ca) .and. coord_valid(cb))) then
      r%sep = SEP_INVALID_INPUT
      r%reason = R_BAD_INPUT
      return
    end if
    call transform_coord(reg, ca, cb%frame_id, a, ok)
    if (.not. ok) then
      r%reason = R_NO_TRANSFORM
      return
    end if

    r%dt = cb%t - a%t
    cdt2 = iv_sqr(iv_scale(r%dt, C_LIGHT))
    s2 = -cdt2
    scale = cdt2%hi
    do i = 1, 3
      dx2 = iv_sqr(cb%x(i) - a%x(i))
      s2 = s2 + dx2
      scale = scale + dx2%hi
    end do
    r%s2 = s2
    r%tol = opts%abs_tol + opts%rel_tol * scale
    if (.not. (ieee_is_finite(s2%lo) .and. ieee_is_finite(s2%hi) .and. ieee_is_finite(r%tol))) then
      r%sep = SEP_INVALID_INPUT
      r%reason = R_BAD_INPUT
      return
    end if
    r%reason = R_OK
    if (s2%hi < -r%tol) then
      r%sep = SEP_TIMELIKE
    else if (s2%lo > r%tol) then
      r%sep = SEP_SPACELIKE
    else if (s2%lo >= -r%tol .and. s2%hi <= r%tol) then
      r%sep = SEP_LIGHTLIKE
    else
      r%sep = SEP_INDETERMINATE
    end if
    if (r%dt%lo > 0.0_dp) then
      r%dir = DIR_FUTURE
    else if (r%dt%hi < 0.0_dp) then
      r%dir = DIR_PAST
    else
      r%dir = DIR_INDETERMINATE
    end if
  end function classify_coords

  pure function classify(reg, a, b, opts) result(r)
    type(frame_registry), intent(in) :: reg
    type(event), intent(in) :: a, b
    type(classify_opts), intent(in) :: opts
    type(classification) :: r
    r = classify_coords(reg, a%c, b%c, opts)
  end function classify

  ! Physical + kind validation of a proposed DIRECT causal edge a -> b.
  ! Accept iff b lies in the closed future light cone of a: TIMELIKE or LIGHTLIKE,
  ! direction FUTURE (dt surely > 0), valid inertial frame(s), and the kind pair is
  ! allowed.  Timestamp order is never sufficient on its own.
  ! Structural checks (cycle, duplicate) are done by the graph.
  pure subroutine validate_edge(reg, a, b, opts, cls, code)
    type(frame_registry), intent(in) :: reg
    type(event), intent(in) :: a, b
    type(classify_opts), intent(in) :: opts
    type(classification), intent(out) :: cls
    integer, intent(out) :: code
    cls = classification()
    if (a%id == b%id) then
      code = EDGE_REJ_SELF
      return
    end if
    cls = classify(reg, a, b, opts)
    select case (cls%sep)
    case (SEP_INVALID_FRAME)
      code = EDGE_REJ_INVALID_FRAME
      return
    case (SEP_INVALID_INPUT)
      code = EDGE_REJ_INVALID_INPUT
      return
    case (SEP_SPACELIKE)
      code = EDGE_REJ_SPACELIKE
      return
    case (SEP_INDETERMINATE)
      code = EDGE_REJ_INDETERMINATE
      return
    end select
    ! TIMELIKE or LIGHTLIKE
    select case (cls%dir)
    case (DIR_FUTURE)
      continue
    case (DIR_PAST)
      code = EDGE_REJ_PAST
      return
    case default
      code = EDGE_REJ_DIR_INDETERMINATE
      return
    end select
    if (.not. kind_edge_allowed(a%kind, b%kind)) then
      code = EDGE_REJ_KIND
      return
    end if
    code = EDGE_OK
  end subroutine validate_edge

end module causal_classify
