! Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
! Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
! SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
!
! fixture_graph: the SYNTHETIC known causal graph used by the Fortran, Curry and Self
! tests.  All numbers are synthetic (chosen for analytic answers); none is an
! observation.  Distances are given in light-seconds (ls) and times in seconds.
!
! Frames: 1 SYNTHETIC-local-inertial-L (inertial)
!         2 SYNTHETIC-boosted-inertial-B (inertial; registered boost 1->2, beta=(0.6,0,0))
!         3 LRD-redshift-not-minkowski (cosmological_redshift)
!         4 SYNTHETIC-unlinked-inertial-U (inertial; NO transform registered)
!         5 SYNTHETIC-explicitly-invalid (invalid)
! Events (id kind frame t[s] x[ls]):
!   1 emission            1    0        0
!   2 detection           1   10       10        (1->2 null: dt = d/c)
!   3 ground_receipt      1   20       12
!   4 archive_publication 1 1000       12
!   5 detection           1   15       30        (t1 < t5 but spacelike from 1)
!   6 ground_receipt      1   40       31
!   7 emission            3   redshift z = 7.0 +/- 0.1 only
!   8 detection           1   20+/-0.5 20        (straddles the cone of 1)
!   9 detection           4   50        0
!  10 ground_receipt      2  105        5        (in B; event 2 is (5 s, 5 ls) in B)
!  11 emission            5    0        0
! Edge proposals, in order, with the expected outcome:
!   1->2 ok, 2->3 ok, 3->4 ok, 1->5 spacelike, 5->6 ok, 6->4 ok, 7->2 invalid_frame,
!   1->8 indeterminate, 1->9 invalid_frame, 2->10 ok (via boost), 3->2 past_directed,
!   4->1 past_directed, 11->2 invalid_frame, 1->3 kind_order, 2->4 kind_order,
!   1->2 duplicate
module fixture_graph
  use causal_units
  use causal_interval
  use causal_coords
  use causal_frames
  use causal_events
  use causal_classify
  use causal_graph
  implicit none
  private
  public :: build_fixture, FIXTURE_NAME, N_PROPOSALS, PROPOSALS, EXPECTED_CODES

  character(len=*), parameter :: FIXTURE_NAME = 'SYNTHETIC-causal-fixture-v1'
  integer, parameter :: N_PROPOSALS = 16
  integer, parameter :: PROPOSALS(2, N_PROPOSALS) = reshape([ &
       1, 2,  2, 3,  3, 4,  1, 5,  5, 6,  6, 4,  7, 2,  1, 8, &
       1, 9,  2, 10, 3, 2,  4, 1,  11, 2, 1, 3,  2, 4,  1, 2], [2, N_PROPOSALS])
  integer, parameter :: EXPECTED_CODES(N_PROPOSALS) = [ &
       EDGE_OK, EDGE_OK, EDGE_OK, EDGE_REJ_SPACELIKE, EDGE_OK, EDGE_OK, EDGE_REJ_INVALID_FRAME, &
       EDGE_REJ_INDETERMINATE, EDGE_REJ_INVALID_FRAME, EDGE_OK, EDGE_REJ_PAST, EDGE_REJ_PAST, &
       EDGE_REJ_INVALID_FRAME, EDGE_REJ_KIND, EDGE_REJ_KIND, EDGE_REJ_DUPLICATE]

contains

  subroutine add(g, id, kind, f, t, tu, xls, label, ok)
    type(causal_graph_t), intent(inout) :: g
    integer, intent(in) :: id, kind, f
    real(dp), intent(in) :: t, tu, xls
    character(len=*), intent(in) :: label
    logical, intent(inout) :: ok
    type(stcoord) :: c
    type(quantity) :: xs(3), xu(3)
    logical :: o
    xs = [q(xls, U_LS), q(0.0_dp, U_LS), q(0.0_dp, U_LS)]
    xu = [q(0.0_dp, U_M), q(0.0_dp, U_M), q(0.0_dp, U_M)]
    call make_coord(f, q(t, U_S), q(tu, U_S), xs, xu, c, o)
    ok = ok .and. o
    call cg_add_event(g, make_event(id, kind, label, c), o)
    ok = ok .and. o
  end subroutine add

  ! codes(k) receives the outcome of proposal k.
  subroutine build_fixture(g, codes, ok)
    type(causal_graph_t), intent(out) :: g
    integer, intent(out) :: codes(N_PROPOSALS)
    logical, intent(out) :: ok
    integer :: st, k
    logical :: o
    ok = .true.
    call cg_init(g, FIXTURE_NAME, .true.)
    call reg_add_frame(g%reg, 1, FK_INERTIAL, 'SYNTHETIC-local-inertial-L', st);   ok = ok .and. st == ST_OK
    call reg_add_frame(g%reg, 2, FK_INERTIAL, 'SYNTHETIC-boosted-inertial-B', st); ok = ok .and. st == ST_OK
    call reg_add_frame(g%reg, 3, FK_COSMO_REDSHIFT, 'LRD-redshift-not-minkowski', st); ok = ok .and. st == ST_OK
    call reg_add_frame(g%reg, 4, FK_INERTIAL, 'SYNTHETIC-unlinked-inertial-U', st); ok = ok .and. st == ST_OK
    call reg_add_frame(g%reg, 5, FK_INVALID, 'SYNTHETIC-explicitly-invalid', st);  ok = ok .and. st == ST_OK
    call reg_add_boost(g%reg, 1, 2, [0.6_dp, 0.0_dp, 0.0_dp], [0.0_dp, 0.0_dp, 0.0_dp, 0.0_dp], st)
    ok = ok .and. st == ST_OK

    call add(g, 1, EV_EMISSION, 1, 0.0_dp, 0.0_dp, 0.0_dp, 'SYNTHETIC E1 local calibration pulse', ok)
    call add(g, 2, EV_DETECTION, 1, 10.0_dp, 0.0_dp, 10.0_dp, 'SYNTHETIC D1 detector exposure', ok)
    call add(g, 3, EV_GROUND_RECEIPT, 1, 20.0_dp, 0.0_dp, 12.0_dp, 'SYNTHETIC G1 downlink receipt', ok)
    call add(g, 4, EV_ARCHIVE_PUBLICATION, 1, 1000.0_dp, 0.0_dp, 12.0_dp, 'SYNTHETIC A1 archive release', ok)
    call add(g, 5, EV_DETECTION, 1, 15.0_dp, 0.0_dp, 30.0_dp, 'SYNTHETIC D2 later but spacelike to E1', ok)
    call add(g, 6, EV_GROUND_RECEIPT, 1, 40.0_dp, 0.0_dp, 31.0_dp, 'SYNTHETIC G2 downlink of D2', ok)
    call cg_add_event(g, make_event(7, EV_EMISSION, 'SYNTHETIC E2 LRD emission redshift only', &
                      make_coord_redshift(3, iv_pm(7.0_dp, 0.1_dp))), o)
    ok = ok .and. o
    call add(g, 8, EV_DETECTION, 1, 20.0_dp, 0.5_dp, 20.0_dp, 'SYNTHETIC D3 timing straddles cone', ok)
    call add(g, 9, EV_DETECTION, 4, 50.0_dp, 0.0_dp, 0.0_dp, 'SYNTHETIC D4 unlinked frame', ok)
    call add(g, 10, EV_GROUND_RECEIPT, 2, 105.0_dp, 0.0_dp, 5.0_dp, 'SYNTHETIC G3 receipt in boosted frame', ok)
    call add(g, 11, EV_EMISSION, 5, 0.0_dp, 0.0_dp, 0.0_dp, 'SYNTHETIC E3 invalid frame', ok)

    do k = 1, N_PROPOSALS
      codes(k) = cg_add_edge(g, PROPOSALS(1, k), PROPOSALS(2, k))
    end do
  end subroutine build_fixture

end module fixture_graph
