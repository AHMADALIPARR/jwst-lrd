! Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
! Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
! SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
!
! Causal-edge validation: closed future light cone, frames, kind order.
! Causality is NEVER inferred from timestamp order alone.
program test_edges
  use causal_units
  use causal_interval
  use causal_coords
  use causal_frames
  use causal_events
  use causal_classify
  use causal_graph
  use test_util
  implicit none
  type(frame_registry) :: reg
  type(classify_opts) :: opts
  type(classification) :: cls
  type(causal_graph_t) :: g
  type(event) :: a, b
  integer :: st, code, ka, kb, n_allowed
  logical :: ok, all_match
  real(dp), parameter :: c = C_LIGHT
  character(len=8) :: tag

  call set_suite('fortran.edges')
  call reg_init(reg)
  call reg_add_frame(reg, 1, FK_INERTIAL, 'SYNTHETIC-local-inertial-L', st)
  call reg_add_frame(reg, 2, FK_INERTIAL, 'SYNTHETIC-unlinked-inertial-U', st)
  call reg_add_frame(reg, 3, FK_COSMO_REDSHIFT, 'LRD-redshift-not-minkowski', st)

  a = ev(1, EV_EMISSION, 1, 0.0_dp, 0.0_dp)
  ! lightlike future: accepted
  b = ev(2, EV_DETECTION, 1, 10.0_dp, 10.0_dp * c)
  call validate_edge(reg, a, b, opts, cls, code)
  call check('lightlike_future_accepted', code == EDGE_OK .and. cls%sep == SEP_LIGHTLIKE)
  ! timelike future: accepted
  b = ev(2, EV_DETECTION, 1, 10.0_dp, 3.0_dp * c)
  call validate_edge(reg, a, b, opts, cls, code)
  call check('timelike_future_accepted', code == EDGE_OK .and. cls%sep == SEP_TIMELIKE)
  ! t_a < t_b but spacelike: REJECTED (timestamp order is not causality)
  b = ev(2, EV_DETECTION, 1, 10.0_dp, 11.0_dp * c)
  call validate_edge(reg, a, b, opts, cls, code)
  call check('ta_lt_tb_but_spacelike_rejected', code == EDGE_REJ_SPACELIKE .and. cls%dir == DIR_FUTURE &
             .and. a%c%t%hi < b%c%t%lo)
  ! past-directed timelike: rejected
  call validate_edge(reg, ev(2, EV_DETECTION, 1, 10.0_dp, 0.0_dp), ev(3, EV_GROUND_RECEIPT, 1, 5.0_dp, 0.0_dp), &
                     opts, cls, code)
  call check('past_directed_timelike_rejected', code == EDGE_REJ_PAST)
  ! past-directed lightlike: rejected
  call validate_edge(reg, ev(2, EV_DETECTION, 1, 10.0_dp, 10.0_dp * c), a, opts, cls, code)
  call check('past_directed_lightlike_rejected', code == EDGE_REJ_PAST)
  ! indeterminate (uncertainty straddles the cone): rejected
  b = ev(2, EV_DETECTION, 1, 20.0_dp, 20.0_dp * c)
  b%c%t = iv_pm(20.0_dp, 0.5_dp)
  call validate_edge(reg, a, b, opts, cls, code)
  call check('indeterminate_rejected', code == EDGE_REJ_INDETERMINATE)
  ! coincident events (null, dt straddles 0): direction indeterminate -> rejected
  call validate_edge(reg, a, ev(2, EV_DETECTION, 1, 0.0_dp, 0.0_dp), opts, cls, code)
  call check('coincident_events_direction_indeterminate_rejected', code == EDGE_REJ_DIR_INDETERMINATE)
  ! cross-frame without transform: rejected
  call validate_edge(reg, a, ev(2, EV_DETECTION, 2, 1000.0_dp, 0.0_dp), opts, cls, code)
  call check('cross_frame_rejected', code == EDGE_REJ_INVALID_FRAME)
  ! redshift-frame emission (numbers would be timelike in a naive reading): rejected
  call validate_edge(reg, ev(7, EV_EMISSION, 3, 0.0_dp, 0.0_dp), ev(2, EV_DETECTION, 1, 1.0e9_dp, 0.0_dp), &
                     opts, cls, code)
  call check('redshift_emission_rejected', code == EDGE_REJ_INVALID_FRAME .and. cls%reason == R_COSMOLOGICAL_FRAME)
  ! self edge
  call validate_edge(reg, a, a, opts, cls, code)
  call check('self_edge_rejected', code == EDGE_REJ_SELF)

  ! kind matrix on a geometry that is surely timelike and future-directed
  n_allowed = 0
  all_match = .true.
  do ka = EV_EMISSION, EV_ARCHIVE_PUBLICATION
    do kb = EV_EMISSION, EV_ARCHIVE_PUBLICATION
      call validate_edge(reg, ev(1, ka, 1, 0.0_dp, 0.0_dp), ev(2, kb, 1, 100.0_dp, 0.0_dp), opts, cls, code)
      if (code == EDGE_OK) n_allowed = n_allowed + 1
      if ((code == EDGE_OK) .neqv. (kb == ka + 1)) all_match = .false.
      write (tag, '(I0,A,I0)') ka, '_', kb
      call check('kind_matrix_' // kind_name(ka) // '_to_' // kind_name(kb), &
                 (code == EDGE_OK) .eqv. (kb == ka + 1), 'code=' // edge_code_name(code))
    end do
  end do
  call check('kind_matrix_exactly_three_allowed', n_allowed == 3 .and. all_match)

  ! same rules through the graph API, including the rejection log
  call cg_init(g, 'SYNTHETIC-edge-test', .true.)
  call reg_add_frame(g%reg, 1, FK_INERTIAL, 'SYNTHETIC-local-inertial-L', st)
  call cg_add_event(g, ev(1, EV_EMISSION, 1, 0.0_dp, 0.0_dp), ok)
  call cg_add_event(g, ev(2, EV_DETECTION, 1, 10.0_dp, 11.0_dp * c), ok)
  call cg_add_event(g, ev(3, EV_DETECTION, 1, 10.0_dp, 10.0_dp * c), ok)
  call cg_add_event(g, ev(1, EV_DETECTION, 1, 0.0_dp, 0.0_dp), ok)
  call check('duplicate_event_id_refused', .not. ok .and. g%n_ev == 3)
  code = cg_add_edge(g, 1, 2)
  call check('graph_spacelike_edge_rejected_and_logged', code == EDGE_REJ_SPACELIKE .and. &
             cg_n_edges(g) == 0 .and. g%n_rej == 1 .and. .not. cg_causal_before(g, 1, 2))
  code = cg_add_edge(g, 1, 3)
  call check('graph_lightlike_edge_accepted', code == EDGE_OK .and. cg_causal_before(g, 1, 3))
  code = cg_add_edge(g, 1, 3)
  call check('graph_duplicate_edge_rejected', code == EDGE_REJ_DUPLICATE)
  code = cg_add_edge(g, 3, 1)
  call check('graph_reverse_edge_rejected_past', code == EDGE_REJ_PAST)
  code = cg_add_edge(g, 1, 42)
  call check('graph_unknown_event_rejected', code == EDGE_REJ_UNKNOWN_EVENT .and. g%n_rej == 4)
  call finish('test_edges')

contains

  function ev(id, kind, f, t, x) result(e)
    integer, intent(in) :: id, kind, f
    real(dp), intent(in) :: t, x
    type(event) :: e
    e = make_event(id, kind, 'SYNTHETIC', make_coord_si(f, iv_point(t), &
                   [iv_point(x), iv_point(0.0_dp), iv_point(0.0_dp)]))
  end function ev

end program test_edges
