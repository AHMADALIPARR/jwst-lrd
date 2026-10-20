! Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
! Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
! SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
!
! Lorentz boosts between registered inertial frames: analytic images, time dilation,
! inverse round trip, invariance of s2 and of the causal class.
program test_boost
  use causal_units
  use causal_interval
  use causal_coords
  use causal_frames
  use causal_classify
  use test_util
  implicit none
  type(frame_registry) :: reg
  type(classify_opts) :: opts
  type(classification) :: r1, r2
  type(stcoord) :: a, b, a2, b2, back
  integer :: st, i, n_inv, n_cls, nsamp
  logical :: ok
  real(dp), parameter :: c = C_LIGHT
  real(dp) :: s1, s2v, seed, worst, v(8)

  call set_suite('fortran.boost')
  call reg_init(reg)
  call reg_add_frame(reg, 1, FK_INERTIAL, 'SYNTHETIC-L', st)
  call reg_add_frame(reg, 2, FK_INERTIAL, 'SYNTHETIC-B-x0.6', st)
  call reg_add_frame(reg, 3, FK_INERTIAL, 'SYNTHETIC-B-oblique', st)
  call reg_add_frame(reg, 4, FK_COSMO_REDSHIFT, 'LRD-redshift-not-minkowski', st)
  call reg_add_boost(reg, 1, 2, [0.6_dp, 0.0_dp, 0.0_dp], [0.0_dp, 0.0_dp, 0.0_dp, 0.0_dp], st)
  call check('register_boost_x', st == ST_OK)
  call reg_add_boost(reg, 1, 3, [0.3_dp, -0.4_dp, 0.5_dp], [7.0_dp, 1.0_dp, 2.0_dp, 3.0_dp], st)
  call check('register_boost_oblique_with_offset', st == ST_OK)
  call reg_add_boost(reg, 2, 3, [1.0_dp, 0.0_dp, 0.0_dp], [0.0_dp, 0.0_dp, 0.0_dp, 0.0_dp], st)
  call check('beta_ge_1_rejected', st == ST_BAD_BETA)
  call reg_add_boost(reg, 1, 4, [0.1_dp, 0.0_dp, 0.0_dp], [0.0_dp, 0.0_dp, 0.0_dp, 0.0_dp], st)
  call check('boost_into_redshift_frame_rejected', st == ST_NOT_INERTIAL)
  call reg_add_boost(reg, 2, 1, [0.1_dp, 0.0_dp, 0.0_dp], [0.0_dp, 0.0_dp, 0.0_dp, 0.0_dp], st)
  call check('duplicate_transform_rejected', st == ST_DUP_TRANSFORM)

  ! (t = 10 s, x = 10 ls) in L -> (5 s, 5 ls) in B (gamma = 1.25)
  call transform_coord(reg, pt(1, 10.0_dp, 10.0_dp * c, 0.0_dp, 0.0_dp), 2, b2, ok)
  call check('analytic_image_10_10_to_5_5', ok .and. b2%frame_id == 2 .and. &
             iv_contains(b2%t, 5.0_dp) .and. iv_contains(b2%x(1), 5.0_dp * c) .and. &
             abs(b2%t%hi - 5.0_dp) < 1.0e-12_dp .and. abs(b2%x(1)%hi / c - 5.0_dp) < 1.0e-12_dp)
  ! time dilation: a clock at rest in L ticks 1 s; B sees gamma = 1.25 s
  call transform_coord(reg, pt(1, 0.0_dp, 0.0_dp, 0.0_dp, 0.0_dp), 2, a2, ok)
  call transform_coord(reg, pt(1, 1.0_dp, 0.0_dp, 0.0_dp, 0.0_dp), 2, b2, ok)
  call check('time_dilation_gamma_1.25', abs((b2%t%lo - a2%t%lo) - 1.25_dp) < 1.0e-12_dp)
  ! inverse round trip through the oblique boost with offset
  a = pt(1, 123.0_dp, 4.0e8_dp, -2.0e8_dp, 9.0e7_dp)
  call transform_coord(reg, a, 3, a2, ok)
  call transform_coord(reg, a2, 1, back, ok)
  call check('inverse_round_trip', ok .and. back%frame_id == 1 .and. abs(back%t%lo - 123.0_dp) < 1.0e-9_dp &
             .and. abs(back%x(2)%lo + 2.0e8_dp) < 1.0e-3_dp)
  ! cross-frame classify == same-frame classify for the fixture pair D1 -> G3
  r1 = classify_coords(reg, pt(1, 10.0_dp, 10.0_dp * c, 0.0_dp, 0.0_dp), pt(2, 105.0_dp, 5.0_dp * c, 0.0_dp, 0.0_dp), opts)
  call check('cross_frame_via_registered_boost_timelike', r1%sep == SEP_TIMELIKE .and. r1%dir == DIR_FUTURE)
  r2 = classify_coords(reg, pt(2, 105.0_dp, 5.0_dp * c, 0.0_dp, 0.0_dp), pt(1, 10.0_dp, 10.0_dp * c, 0.0_dp, 0.0_dp), opts)
  call check('cross_frame_inverse_direction_past', r2%sep == SEP_TIMELIKE .and. r2%dir == DIR_PAST)

  ! invariance of s2 and of the class over deterministic pseudo-random pairs
  seed = 0.2718281828_dp
  n_inv = 0
  n_cls = 0
  nsamp = 200
  worst = 0.0_dp
  do i = 1, nsamp
    call lcg(v)
    a = pt(1, 100.0_dp * v(1), 100.0_dp * c * (v(2) - 0.5_dp), 100.0_dp * c * (v(3) - 0.5_dp), 0.0_dp)
    b = pt(1, 100.0_dp * v(4), 100.0_dp * c * (v(5) - 0.5_dp), 100.0_dp * c * (v(6) - 0.5_dp), &
           10.0_dp * c * (v(7) - 0.5_dp))
    r1 = classify_coords(reg, a, b, opts)
    call transform_coord(reg, a, 3, a2, ok)
    call transform_coord(reg, b, 3, b2, ok)
    r2 = classify_coords(reg, a2, b2, opts)
    s1 = 0.5_dp * (r1%s2%lo + r1%s2%hi)
    s2v = 0.5_dp * (r2%s2%lo + r2%s2%hi)
    worst = max(worst, abs(s1 - s2v) / (r1%tol / opts%rel_tol))
    if (abs(s1 - s2v) <= 1.0e-12_dp * (r1%tol / opts%rel_tol)) n_inv = n_inv + 1
    if (r1%sep == r2%sep .and. (r1%sep == SEP_SPACELIKE .or. r1%dir == r2%dir)) n_cls = n_cls + 1
  end do
  call check('s2_invariant_200_pairs_rel_1e-12', n_inv == nsamp, 'worst_rel=' // rfmt(worst))
  call check('class_invariant_200_pairs', n_cls == nsamp)
  write (*, '(A)') '# s2 invariance: worst |s2_L - s2_B| / scale = ' // rfmt(worst)
  call finish('test_boost')

contains

  function pt(f, t, x, y, z) result(cc)
    integer, intent(in) :: f
    real(dp), intent(in) :: t, x, y, z
    type(stcoord) :: cc
    cc = make_coord_si(f, iv_point(t), [iv_point(x), iv_point(y), iv_point(z)])
  end function pt

  ! deterministic generator in [0,1): x <- frac(x * 997 + 0.123), no library RNG
  subroutine lcg(out)
    real(dp), intent(out) :: out(:)
    integer :: k
    do k = 1, size(out)
      seed = seed * 997.0_dp + 0.1234567_dp
      seed = seed - aint(seed)
      out(k) = seed
    end do
  end subroutine lcg

  function rfmt(x) result(s)
    real(dp), intent(in) :: x
    character(len=:), allocatable :: s
    character(len=32) :: b
    write (b, '(ES12.4)') x
    s = trim(adjustl(b))
  end function rfmt

end program test_boost
