! Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
! Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
! SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
!
! causal_graph: the causal poset.  Events (with unique positive ids) are DAG nodes;
! an edge a -> b is inserted ONLY after validate_edge accepted it (closed future
! light cone, valid frames, allowed kinds) AND the DAG accepted it (no self-loop,
! duplicate or cycle).  Every rejected attempt is logged with its reason code.
! causalBefore(a,b) := b reachable from a (transitive closure of accepted edges).
module causal_graph
  use causal_units
  use causal_frames
  use causal_events
  use causal_classify
  use causal_digraph
  implicit none
  private

  type, public :: causal_graph_t
    character(len=96) :: name = ''
    logical :: synthetic = .false.
    type(frame_registry) :: reg
    type(classify_opts) :: opts
    integer :: n_ev = 0, n_rej = 0
    type(event), allocatable :: ev(:)
    type(digraph) :: dg
    type(classification), allocatable :: ecls(:)     ! classification of accepted edge k
    integer, allocatable :: rsrc(:), rdst(:), rcode(:)
  end type causal_graph_t

  public :: cg_init, cg_add_event, cg_index, cg_add_edge, cg_causal_before, &
            cg_ancestors, cg_descendants, cg_topo, cg_closure, cg_n_edges, cg_edge

contains

  subroutine cg_init(g, name, synthetic)
    type(causal_graph_t), intent(out) :: g
    character(len=*), intent(in) :: name
    logical, intent(in) :: synthetic
    g%name = name
    g%synthetic = synthetic
    call reg_init(g%reg)
    g%opts = classify_opts()
    g%n_ev = 0
    g%n_rej = 0
    allocate(g%ev(8), g%ecls(8), g%rsrc(8), g%rdst(8), g%rcode(8))
    call dg_init(g%dg, 0)
  end subroutine cg_init

  pure integer function cg_index(g, id)
    type(causal_graph_t), intent(in) :: g
    integer, intent(in) :: id
    integer :: i
    cg_index = 0
    do i = 1, g%n_ev
      if (g%ev(i)%id == id) then
        cg_index = i
        return
      end if
    end do
  end function cg_index

  ! ok=.false. for non-positive/duplicate id, invalid kind, or over-long label.
  subroutine cg_add_event(g, e, ok)
    type(causal_graph_t), intent(inout) :: g
    type(event), intent(in) :: e
    logical, intent(out) :: ok
    type(event), allocatable :: tmp(:)
    ok = .false.
    if (e%id <= 0) return
    if (e%kind < EV_EMISSION .or. e%kind > EV_ARCHIVE_PUBLICATION) return
    if (cg_index(g, e%id) /= 0) return
    if (g%n_ev == size(g%ev)) then
      allocate(tmp(2 * size(g%ev)))
      tmp(1:g%n_ev) = g%ev(1:g%n_ev)
      call move_alloc(tmp, g%ev)
    end if
    g%n_ev = g%n_ev + 1
    g%ev(g%n_ev) = e
    call dg_add_node(g%dg)
    ok = .true.
  end subroutine cg_add_event

  pure integer function cg_n_edges(g)
    type(causal_graph_t), intent(in) :: g
    cg_n_edges = g%dg%m
  end function cg_n_edges

  ! k-th accepted edge as event ids.
  pure subroutine cg_edge(g, k, src_id, dst_id)
    type(causal_graph_t), intent(in) :: g
    integer, intent(in) :: k
    integer, intent(out) :: src_id, dst_id
    src_id = g%ev(g%dg%src(k))%id
    dst_id = g%ev(g%dg%dst(k))%id
  end subroutine cg_edge

  subroutine log_rejection(g, s, d, code)
    type(causal_graph_t), intent(inout) :: g
    integer, intent(in) :: s, d, code
    integer, allocatable :: t(:)
    integer :: n
    if (g%n_rej == size(g%rsrc)) then
      n = 2 * size(g%rsrc)
      allocate(t(n)); t(1:g%n_rej) = g%rsrc(1:g%n_rej); call move_alloc(t, g%rsrc)
      allocate(t(n)); t(1:g%n_rej) = g%rdst(1:g%n_rej); call move_alloc(t, g%rdst)
      allocate(t(n)); t(1:g%n_rej) = g%rcode(1:g%n_rej); call move_alloc(t, g%rcode)
    end if
    g%n_rej = g%n_rej + 1
    g%rsrc(g%n_rej) = s
    g%rdst(g%n_rej) = d
    g%rcode(g%n_rej) = code
  end subroutine log_rejection

  ! Propose a direct causal edge between event ids.  Returns EDGE_OK or a rejection
  ! code; rejected proposals are logged (log=.false. suppresses the log entry).
  integer function cg_add_edge(g, src_id, dst_id, log) result(code)
    type(causal_graph_t), intent(inout) :: g
    integer, intent(in) :: src_id, dst_id
    logical, intent(in), optional :: log
    integer :: ia, ib, dcode
    type(classification) :: cls
    type(classification), allocatable :: tmp(:)
    logical :: do_log
    do_log = .true.
    if (present(log)) do_log = log
    ia = cg_index(g, src_id)
    ib = cg_index(g, dst_id)
    if (ia == 0 .or. ib == 0) then
      code = EDGE_REJ_UNKNOWN_EVENT
    else
      call validate_edge(g%reg, g%ev(ia), g%ev(ib), g%opts, cls, code)
      if (code == EDGE_OK) then
        dcode = dg_add_edge(g%dg, ia, ib)
        select case (dcode)
        case (DG_OK)
          if (g%dg%m > size(g%ecls)) then
            allocate(tmp(2 * size(g%ecls)))
            tmp(1:g%dg%m - 1) = g%ecls(1:g%dg%m - 1)
            call move_alloc(tmp, g%ecls)
          end if
          g%ecls(g%dg%m) = cls
        case (DG_SELF)
          code = EDGE_REJ_SELF
        case (DG_DUP)
          code = EDGE_REJ_DUPLICATE
        case default
          code = EDGE_REJ_CYCLE
        end select
      end if
    end if
    if (code /= EDGE_OK .and. do_log) call log_rejection(g, src_id, dst_id, code)
  end function cg_add_edge

  pure logical function cg_causal_before(g, a_id, b_id)
    type(causal_graph_t), intent(in) :: g
    integer, intent(in) :: a_id, b_id
    cg_causal_before = dg_reachable(g%dg, cg_index(g, a_id), cg_index(g, b_id))
  end function cg_causal_before

  ! Ids of all causal ancestors / descendants, in ascending node (insertion) order.
  pure subroutine cg_ancestors(g, id, out, k)
    type(causal_graph_t), intent(in) :: g
    integer, intent(in) :: id
    integer, intent(out) :: out(:)
    integer, intent(out) :: k
    integer :: idx(g%n_ev), i
    k = 0
    if (cg_index(g, id) == 0) return
    call dg_ancestors(g%dg, cg_index(g, id), idx, k)
    do i = 1, k
      out(i) = g%ev(idx(i))%id
    end do
  end subroutine cg_ancestors

  pure subroutine cg_descendants(g, id, out, k)
    type(causal_graph_t), intent(in) :: g
    integer, intent(in) :: id
    integer, intent(out) :: out(:)
    integer, intent(out) :: k
    integer :: idx(g%n_ev), i
    k = 0
    if (cg_index(g, id) == 0) return
    call dg_descendants(g%dg, cg_index(g, id), idx, k)
    do i = 1, k
      out(i) = g%ev(idx(i))%id
    end do
  end subroutine cg_descendants

  pure subroutine cg_topo(g, out, ok)
    type(causal_graph_t), intent(in) :: g
    integer, intent(out) :: out(:)
    logical, intent(out) :: ok
    integer :: idx(g%n_ev), i
    call dg_toposort(g%dg, idx, ok)
    if (.not. ok) return
    do i = 1, g%n_ev
      out(i) = g%ev(idx(i))%id
    end do
  end subroutine cg_topo

  ! closure(i,j) over node indices (event insertion order).
  pure subroutine cg_closure(g, closure)
    type(causal_graph_t), intent(in) :: g
    logical, intent(out) :: closure(:, :)
    call dg_closure(g%dg, closure)
  end subroutine cg_closure

end module causal_graph
