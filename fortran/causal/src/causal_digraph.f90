! Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
! Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
! SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
!
! causal_digraph: structural directed acyclic graph on nodes 1..n.
! Edge insertion rejects self-loops, duplicates and any edge that would close a cycle
! (u -> v is refused iff v already reaches u).  Queries: reachability, ancestors,
! descendants (ascending node order), deterministic topological sort (Kahn,
! smallest ready node first) and the transitive closure matrix.
! This layer knows nothing about physics; causal_graph is its only user that adds
! causal edges, and it validates light-cone membership first.
module causal_digraph
  implicit none
  private

  integer, parameter, public :: DG_OK = 0, DG_SELF = 1, DG_DUP = 2, DG_CYCLE = 3, DG_RANGE = 4

  type, public :: digraph
    integer :: n = 0, m = 0
    integer, allocatable :: src(:), dst(:)
  end type digraph

  public :: dg_init, dg_add_node, dg_add_edge, dg_has_edge, dg_reachable, &
            dg_descendants, dg_ancestors, dg_toposort, dg_closure, dg_successors

contains

  subroutine dg_init(g, n)
    type(digraph), intent(out) :: g
    integer, intent(in) :: n
    g%n = n
    g%m = 0
    allocate(g%src(8), g%dst(8))
  end subroutine dg_init

  subroutine dg_add_node(g)
    type(digraph), intent(inout) :: g
    g%n = g%n + 1
  end subroutine dg_add_node

  pure logical function dg_has_edge(g, u, v)
    type(digraph), intent(in) :: g
    integer, intent(in) :: u, v
    integer :: k
    dg_has_edge = .false.
    do k = 1, g%m
      if (g%src(k) == u .and. g%dst(k) == v) then
        dg_has_edge = .true.
        return
      end if
    end do
  end function dg_has_edge

  integer function dg_add_edge(g, u, v) result(code)
    type(digraph), intent(inout) :: g
    integer, intent(in) :: u, v
    integer, allocatable :: t1(:), t2(:)
    if (u < 1 .or. v < 1 .or. u > g%n .or. v > g%n) then
      code = DG_RANGE
      return
    end if
    if (u == v) then
      code = DG_SELF
      return
    end if
    if (dg_has_edge(g, u, v)) then
      code = DG_DUP
      return
    end if
    if (dg_reachable(g, v, u)) then
      code = DG_CYCLE
      return
    end if
    if (g%m == size(g%src)) then
      allocate(t1(2 * g%m), t2(2 * g%m))
      t1(1:g%m) = g%src(1:g%m)
      t2(1:g%m) = g%dst(1:g%m)
      call move_alloc(t1, g%src)
      call move_alloc(t2, g%dst)
    end if
    g%m = g%m + 1
    g%src(g%m) = u
    g%dst(g%m) = v
    code = DG_OK
  end function dg_add_edge

  ! Direct successors of u, ascending.
  pure subroutine dg_successors(g, u, out, k)
    type(digraph), intent(in) :: g
    integer, intent(in) :: u
    integer, intent(out) :: out(:)
    integer, intent(out) :: k
    logical :: mark(g%n)
    integer :: e, i
    mark = .false.
    do e = 1, g%m
      if (g%src(e) == u) mark(g%dst(e)) = .true.
    end do
    k = 0
    do i = 1, g%n
      if (mark(i)) then
        k = k + 1
        out(k) = i
      end if
    end do
  end subroutine dg_successors

  ! Nodes reachable from u by a path of length >= 1 (forward=.true.) or that reach u.
  pure subroutine reach_set(g, u, forward, mark)
    type(digraph), intent(in) :: g
    integer, intent(in) :: u
    logical, intent(in) :: forward
    logical, intent(out) :: mark(:)
    integer :: queue(g%n), head, tail, x, e, y
    mark = .false.
    head = 1
    tail = 0
    tail = tail + 1
    queue(tail) = u
    do while (head <= tail)
      x = queue(head)
      head = head + 1
      do e = 1, g%m
        if (forward) then
          if (g%src(e) /= x) cycle
          y = g%dst(e)
        else
          if (g%dst(e) /= x) cycle
          y = g%src(e)
        end if
        if (.not. mark(y)) then
          mark(y) = .true.
          if (tail < g%n) then
            tail = tail + 1
            queue(tail) = y
          end if
        end if
      end do
    end do
  end subroutine reach_set

  ! .true. iff there is a directed path of length >= 1 from u to v.
  pure logical function dg_reachable(g, u, v)
    type(digraph), intent(in) :: g
    integer, intent(in) :: u, v
    logical :: mark(g%n)
    dg_reachable = .false.
    if (u < 1 .or. u > g%n .or. v < 1 .or. v > g%n) return
    call reach_set(g, u, .true., mark)
    dg_reachable = mark(v)
  end function dg_reachable

  pure subroutine dg_descendants(g, u, out, k)
    type(digraph), intent(in) :: g
    integer, intent(in) :: u
    integer, intent(out) :: out(:)
    integer, intent(out) :: k
    logical :: mark(g%n)
    integer :: i
    call reach_set(g, u, .true., mark)
    k = 0
    do i = 1, g%n
      if (mark(i)) then
        k = k + 1
        out(k) = i
      end if
    end do
  end subroutine dg_descendants

  pure subroutine dg_ancestors(g, u, out, k)
    type(digraph), intent(in) :: g
    integer, intent(in) :: u
    integer, intent(out) :: out(:)
    integer, intent(out) :: k
    logical :: mark(g%n)
    integer :: i
    call reach_set(g, u, .false., mark)
    k = 0
    do i = 1, g%n
      if (mark(i)) then
        k = k + 1
        out(k) = i
      end if
    end do
  end subroutine dg_ancestors

  ! Kahn's algorithm; among ready nodes the smallest index is emitted first, so the
  ! order is unique for a given graph.  ok=.false. would indicate a cycle (cannot
  ! happen through dg_add_edge).
  pure subroutine dg_toposort(g, order, ok)
    type(digraph), intent(in) :: g
    integer, intent(out) :: order(:)
    logical, intent(out) :: ok
    integer :: indeg(g%n), i, e, k, pick
    logical :: done(g%n)
    indeg = 0
    do e = 1, g%m
      indeg(g%dst(e)) = indeg(g%dst(e)) + 1
    end do
    done = .false.
    do k = 1, g%n
      pick = 0
      do i = 1, g%n
        if (.not. done(i) .and. indeg(i) == 0) then
          pick = i
          exit
        end if
      end do
      if (pick == 0) then
        ok = .false.
        return
      end if
      done(pick) = .true.
      order(k) = pick
      do e = 1, g%m
        if (g%src(e) == pick) indeg(g%dst(e)) = indeg(g%dst(e)) - 1
      end do
    end do
    ok = .true.
  end subroutine dg_toposort

  ! closure(i,j) = .true. iff j is reachable from i by a path of length >= 1.
  pure subroutine dg_closure(g, closure)
    type(digraph), intent(in) :: g
    logical, intent(out) :: closure(:, :)
    integer :: i
    logical :: mark(g%n)
    do i = 1, g%n
      call reach_set(g, i, .true., mark)
      closure(i, 1:g%n) = mark
    end do
  end subroutine dg_closure

end module causal_digraph
