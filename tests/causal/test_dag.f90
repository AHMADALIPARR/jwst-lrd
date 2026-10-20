! Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
! Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
! SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
!
! DAG construction, cycle rejection, topological order, reachability, ancestors,
! descendants and transitive closure on graphs with known answers.
program test_dag
  use causal_classify
  use causal_events
  use causal_digraph
  use causal_graph
  use fixture_graph
  use test_util
  implicit none
  type(digraph) :: d
  type(causal_graph_t) :: g
  integer :: order(64), out(64), k, i, j, n, pos(64), codes(N_PROPOSALS)
  logical :: ok, clo(6, 6), expect(6, 6), bigclo(50, 50), valid
  character(len=:), allocatable :: s

  call set_suite('fortran.dag')
  call dg_init(d, 6)
  call check('edge_1_2', dg_add_edge(d, 1, 2) == DG_OK)
  call check('edge_1_3', dg_add_edge(d, 1, 3) == DG_OK)
  call check('edge_2_4', dg_add_edge(d, 2, 4) == DG_OK)
  call check('edge_3_4', dg_add_edge(d, 3, 4) == DG_OK)
  call check('edge_4_5', dg_add_edge(d, 4, 5) == DG_OK)
  call check('cycle_5_1_rejected', dg_add_edge(d, 5, 1) == DG_CYCLE)
  call check('cycle_4_2_rejected', dg_add_edge(d, 4, 2) == DG_CYCLE)
  call check('two_cycle_2_1_rejected', dg_add_edge(d, 2, 1) == DG_CYCLE)
  call check('self_loop_rejected', dg_add_edge(d, 3, 3) == DG_SELF)
  call check('duplicate_rejected', dg_add_edge(d, 1, 2) == DG_DUP)
  call check('out_of_range_rejected', dg_add_edge(d, 1, 7) == DG_RANGE)
  call check('edge_count_after_rejections', d%m == 5)
  call dg_toposort(d, order, ok)
  call check('toposort_known_order', ok .and. all(order(1:6) == [1, 2, 3, 4, 5, 6]))
  call check('reach_1_5', dg_reachable(d, 1, 5))
  call check('no_reach_5_1', .not. dg_reachable(d, 5, 1))
  call check('no_reach_2_3_siblings', .not. dg_reachable(d, 2, 3))
  call check('no_reach_isolated_6', .not. dg_reachable(d, 1, 6) .and. .not. dg_reachable(d, 6, 1))
  call check('no_reflexive_reach', .not. dg_reachable(d, 1, 1))
  call dg_ancestors(d, 4, out, k)
  call check('ancestors_of_4', k == 3 .and. all(out(1:3) == [1, 2, 3]))
  call dg_descendants(d, 1, out, k)
  call check('descendants_of_1', k == 4 .and. all(out(1:4) == [2, 3, 4, 5]))
  call dg_closure(d, clo)
  expect = .false.
  expect(1, 2:5) = .true.
  expect(2, 4:5) = .true.
  expect(3, 4:5) = .true.
  expect(4, 5) = .true.
  call check('transitive_closure_matches_analytic', all(clo .eqv. expect) .and. count(clo) == 9)

  ! chain of 50: closing edge rejected; closure has 50*49/2 pairs
  call dg_init(d, 50)
  valid = .true.
  do i = 1, 49
    j = dg_add_edge(d, i, i + 1)
    valid = valid .and. j == DG_OK
  end do
  call check('chain50_built', valid)
  call check('chain50_closing_edge_rejected', dg_add_edge(d, 50, 1) == DG_CYCLE)
  call check('chain50_shortcut_allowed', dg_add_edge(d, 1, 50) == DG_OK)
  call dg_closure(d, bigclo)
  call check('chain50_closure_count', count(bigclo) == 1225)

  ! ---------------------------------------------------------------- causal fixture
  call set_suite('fortran.fixture')
  call build_fixture(g, codes, ok)
  call check('fixture_built', ok .and. g%n_ev == 11)
  do k = 1, N_PROPOSALS
    s = 'proposal_' // itoa2(PROPOSALS(1, k)) // '_to_' // itoa2(PROPOSALS(2, k)) // '_' // &
        edge_code_name(EXPECTED_CODES(k))
    call check(s, codes(k) == EXPECTED_CODES(k), 'got=' // edge_code_name(codes(k)))
  end do
  call check('accepted_edge_count', cg_n_edges(g) == 6)
  call check('rejected_log_count', g%n_rej == 10)
  call cg_topo(g, order, ok)
  call check('fixture_topological_order', ok .and. all(order(1:11) == [1, 2, 3, 5, 6, 4, 7, 8, 9, 10, 11]))
  ! every accepted edge respects the order
  n = g%n_ev
  do i = 1, n
    pos(order(i)) = i
  end do
  valid = .true.
  do k = 1, cg_n_edges(g)
    call cg_edge(g, k, i, j)
    valid = valid .and. pos(i) < pos(j)
  end do
  call check('fixture_topological_order_respects_edges', valid)
  call cg_ancestors(g, 4, out, k)
  call check('ancestors_of_archive_4', k == 5 .and. all(out(1:5) == [1, 2, 3, 5, 6]))
  call cg_descendants(g, 1, out, k)
  call check('descendants_of_emission_1', k == 4 .and. all(out(1:4) == [2, 3, 4, 10]))
  call cg_ancestors(g, 10, out, k)
  call check('ancestors_of_boosted_receipt_10', k == 2 .and. all(out(1:2) == [1, 2]))
  call check('causal_before_1_4', cg_causal_before(g, 1, 4))
  call check('not_causal_before_1_5_despite_t1_lt_t5', .not. cg_causal_before(g, 1, 5) .and. &
             g%ev(1)%c%t%hi < g%ev(5)%c%t%lo)
  call check('not_causal_before_4_1', .not. cg_causal_before(g, 4, 1))
  call check('not_causal_before_7_anything', .not. any([(cg_causal_before(g, 7, i), i = 1, 11)]))
  call check('not_causal_before_1_8_indeterminate', .not. cg_causal_before(g, 1, 8))
  call cg_descendants(g, 7, out, k)
  call check('redshift_emission_isolated', k == 0)
  call finish('test_dag')

contains
  function itoa2(i) result(r)
    integer, intent(in) :: i
    character(len=:), allocatable :: r
    character(len=12) :: b
    write (b, '(I0)') i
    r = trim(b)
  end function itoa2
end program test_dag
