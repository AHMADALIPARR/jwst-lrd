! Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
! Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
! SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
!
! Light-cone classification against analytically known separations.
! s2 = -c^2 dt^2 + |dx|^2 (signature -+++).
program test_classify
  use causal_units
  use causal_interval
  use causal_coords
  use causal_frames
  use causal_classify
  use test_util
  implicit none
  type(frame_registry) :: reg
  type(classify_opts) :: opts
  type(classification) :: r
  type(stcoord) :: o, p
  type(spacetime_model) :: model
  integer :: st
  real(dp) :: d, nan
  real(dp), parameter :: c = C_LIGHT

  call set_suite('fortran.classify')
  call reg_init(reg)
  call reg_add_frame(reg, 1, FK_INERTIAL, 'SYNTHETIC-local-inertial-L', st)
  call reg_add_frame(reg, 2, FK_INERTIAL, 'SYNTHETIC-unlinked-inertial-U', st)
  call reg_add_frame(reg, 3, FK_COSMO_REDSHIFT, 'LRD-redshift-not-minkowski', st)
  call reg_add_frame(reg, 4, FK_INVALID, 'explicitly-invalid', st)
  call check('frame_registration', reg%nf == 4)
  call reg_add_frame(reg, 1, FK_INERTIAL, 'dup', st)
  call check('duplicate_frame_refused', st == ST_DUP_FRAME)
  o = pt(1, 0.0_dp, 0.0_dp, 0.0_dp, 0.0_dp)

  ! 1. light pulse over d = c * 1 s, dt = 1 s : exactly null
  r = classify_coords(reg, o, pt(1, 1.0_dp, c, 0.0_dp, 0.0_dp), opts)
  call check('lightlike_one_light_second', r%sep == SEP_LIGHTLIKE .and. r%dir == DIR_FUTURE &
             .and. iv_contains(r%s2, 0.0_dp), detail(r))
  ! 2. d = 1 au, dt = d/c (inexact division, absorbed by the tolerance)
  d = AU_M
  r = classify_coords(reg, o, pt(1, d / c, d, 0.0_dp, 0.0_dp), opts)
  call check('lightlike_one_au_dt_d_over_c', r%sep == SEP_LIGHTLIKE .and. r%dir == DIR_FUTURE, detail(r))
  ! 3. 3-4-5 null vector off-axis: dx = (3c, 4c, 0) m, dt = 5 s
  r = classify_coords(reg, o, pt(1, 5.0_dp, 3.0_dp * c, 4.0_dp * c, 0.0_dp), opts)
  call check('lightlike_345_diagonal', r%sep == SEP_LIGHTLIKE .and. r%dir == DIR_FUTURE, detail(r))
  ! 4. dt = 2 s > d/c with d = c : s2 = -3 c^2
  r = classify_coords(reg, o, pt(1, 2.0_dp, c, 0.0_dp, 0.0_dp), opts)
  call check('timelike_dt_gt_d_over_c', r%sep == SEP_TIMELIKE .and. r%dir == DIR_FUTURE .and. &
             iv_contains(r%s2, -3.0_dp * c * c), detail(r))
  ! 5. dt = 0.5 s < d/c with d = c : s2 = +0.75 c^2
  r = classify_coords(reg, o, pt(1, 0.5_dp, c, 0.0_dp, 0.0_dp), opts)
  call check('spacelike_dt_lt_d_over_c', r%sep == SEP_SPACELIKE .and. iv_contains(r%s2, 0.75_dp * c * c), &
             detail(r))
  ! 6. tolerance does not swallow a relative 1e-9 deviation from the cone
  r = classify_coords(reg, o, pt(1, (d / c) * (1.0_dp + 1.0e-9_dp), d, 0.0_dp, 0.0_dp), opts)
  call check('timelike_just_inside_cone_1e-9', r%sep == SEP_TIMELIKE, detail(r))
  r = classify_coords(reg, o, pt(1, (d / c) * (1.0_dp - 1.0e-9_dp), d, 0.0_dp, 0.0_dp), opts)
  call check('spacelike_just_outside_cone_1e-9', r%sep == SEP_SPACELIKE, detail(r))
  ! 7. same place, different times
  r = classify_coords(reg, pt(1, 10.0_dp, 5.0_dp, 6.0_dp, 7.0_dp), pt(1, 20.0_dp, 5.0_dp, 6.0_dp, 7.0_dp), opts)
  call check('same_place_later_timelike_future', r%sep == SEP_TIMELIKE .and. r%dir == DIR_FUTURE &
             .and. iv_contains(r%s2, -100.0_dp * c * c), detail(r))
  r = classify_coords(reg, pt(1, 20.0_dp, 5.0_dp, 6.0_dp, 7.0_dp), pt(1, 10.0_dp, 5.0_dp, 6.0_dp, 7.0_dp), opts)
  call check('same_place_earlier_timelike_past', r%sep == SEP_TIMELIKE .and. r%dir == DIR_PAST, detail(r))
  ! 8. simultaneous, separated by 1 m
  r = classify_coords(reg, pt(1, 3.0_dp, 0.0_dp, 0.0_dp, 0.0_dp), pt(1, 3.0_dp, 0.0_dp, 1.0_dp, 0.0_dp), opts)
  call check('simultaneous_separated_spacelike', r%sep == SEP_SPACELIKE .and. iv_contains(r%s2, 1.0_dp), &
             detail(r))
  ! 9. uncertainty straddling the cone: d = 20 c m, t = 20 s +/- 0.5 s
  p = pt(1, 20.0_dp, 20.0_dp * c, 0.0_dp, 0.0_dp)
  p%t = iv_pm(20.0_dp, 0.5_dp)
  r = classify_coords(reg, o, p, opts)
  call check('uncertainty_straddles_cone_indeterminate', r%sep == SEP_INDETERMINATE .and. &
             r%s2%lo < 0.0_dp .and. r%s2%hi > 0.0_dp .and. r%dir == DIR_FUTURE, detail(r))
  ! 9b. same geometry, uncertainty entirely inside the cone -> still timelike
  p = pt(1, 30.0_dp, 20.0_dp * c, 0.0_dp, 0.0_dp)
  p%t = iv_pm(30.0_dp, 0.5_dp)
  r = classify_coords(reg, o, p, opts)
  call check('uncertainty_inside_cone_timelike', r%sep == SEP_TIMELIKE, detail(r))
  ! 9c. time uncertainty straddling dt = 0 at one place: direction indeterminate
  p = pt(1, 0.0_dp, 0.0_dp, 0.0_dp, 0.0_dp)
  p%t = iv_pm(0.0_dp, 1.0_dp)
  r = classify_coords(reg, o, p, opts)
  call check('dt_straddles_zero_direction_indeterminate', r%dir == DIR_INDETERMINATE, detail(r))
  ! 10. cross-frame without a registered transform
  r = classify_coords(reg, o, pt(2, 10.0_dp, 0.0_dp, 0.0_dp, 0.0_dp), opts)
  call check('cross_frame_no_transform_invalid', r%sep == SEP_INVALID_FRAME .and. r%reason == R_NO_TRANSFORM, &
             detail(r))
  ! 11. redshift-derived frame: invalid even when its numbers would look timelike
  r = classify_coords(reg, pt(3, 0.0_dp, 0.0_dp, 0.0_dp, 0.0_dp), pt(1, 1.0e9_dp, 1.0_dp, 0.0_dp, 0.0_dp), opts)
  call check('redshift_frame_source_invalid', r%sep == SEP_INVALID_FRAME .and. &
             r%reason == R_COSMOLOGICAL_FRAME, detail(r))
  r = classify_coords(reg, o, make_coord_redshift(3, iv_pm(7.0_dp, 0.1_dp)), opts)
  call check('redshift_frame_target_invalid', r%sep == SEP_INVALID_FRAME .and. &
             r%reason == R_COSMOLOGICAL_FRAME, detail(r))
  r = classify_coords(reg, pt(3, 0.0_dp, 0.0_dp, 0.0_dp, 0.0_dp), pt(3, 1.0e9_dp, 1.0_dp, 0.0_dp, 0.0_dp), opts)
  call check('redshift_frame_both_invalid', r%sep == SEP_INVALID_FRAME, detail(r))
  ! 12. explicitly invalid frame kind, and an unregistered frame id
  r = classify_coords(reg, pt(4, 0.0_dp, 0.0_dp, 0.0_dp, 0.0_dp), pt(4, 10.0_dp, 0.0_dp, 0.0_dp, 0.0_dp), opts)
  call check('invalid_frame_kind_invalid', r%sep == SEP_INVALID_FRAME .and. r%reason == R_INVALID_FRAME_KIND, &
             detail(r))
  r = classify_coords(reg, o, pt(99, 10.0_dp, 0.0_dp, 0.0_dp, 0.0_dp), opts)
  call check('unknown_frame_id_invalid', r%sep == SEP_INVALID_FRAME .and. r%reason == R_UNKNOWN_FRAME, detail(r))
  ! 13. non-finite input
  nan = transfer(int(z'7FF8000000000000', kind(1_8)), 1.0_dp)
  p = pt(1, 1.0_dp, 0.0_dp, 0.0_dp, 0.0_dp)
  p%x(1) = iv_point(nan)
  r = classify_coords(reg, o, p, opts)
  call check('nan_coordinate_invalid_input', r%sep == SEP_INVALID_INPUT, detail(r))
  ! 14. redshift -> Minkowski hook: refused without a declared spacetime model
  call redshift_to_local(reg, model, iv_pm(7.0_dp, 0.1_dp), [1.0_dp, 0.0_dp, 0.0_dp], 1, p, st)
  call check('redshift_hook_no_model_rejected', st == ST_NO_SPACETIME_MODEL)
  model%declared = .true.
  model%name = 'declared-but-no-mapping'
  call redshift_to_local(reg, model, iv_pm(7.0_dp, 0.1_dp), [1.0_dp, 0.0_dp, 0.0_dp], 1, p, st)
  call check('redshift_hook_declared_without_map_rejected', st == ST_NO_SPACETIME_MODEL)
  ! 15. symmetry of the interval class
  r = classify_coords(reg, pt(1, 5.0_dp, 3.0_dp * c, 4.0_dp * c, 0.0_dp), o, opts)
  call check('lightlike_reverse_is_past', r%sep == SEP_LIGHTLIKE .and. r%dir == DIR_PAST, detail(r))
  call finish('test_classify')

contains

  function pt(f, t, x, y, z) result(cc)
    integer, intent(in) :: f
    real(dp), intent(in) :: t, x, y, z
    type(stcoord) :: cc
    cc = make_coord_si(f, iv_point(t), [iv_point(x), iv_point(y), iv_point(z)])
  end function pt

  function detail(rr) result(s)
    type(classification), intent(in) :: rr
    character(len=:), allocatable :: s
    character(len=160) :: b
    write (b, '(A,1X,A,1X,ES12.4,1X,ES12.4,1X,ES10.2)') sep_name(rr%sep), dir_name(rr%dir), &
          rr%s2%lo, rr%s2%hi, rr%tol
    s = 'got=' // trim(adjustl(b))
    do while (index(s, ' ') > 0)
      s(index(s, ' '):index(s, ' ')) = '_'
    end do
  end function detail

end program test_classify
