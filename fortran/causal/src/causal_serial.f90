! Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
! Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
! SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
!
! causal_serial: the causal graph as ONE LRD-REC-v1 record (format LRD-CAUSAL-GRAPH-v1,
! documented in fortran/causal/FORMAT.md).  All reals are canonical hex-floats
! (causal_hexfloat) so values round-trip bit-exactly.  Derived fields (pair
! classifications, topological order) are recomputed on load and the load fails
! unless re-serialising the loaded graph reproduces the input byte-for-byte.
! Accepted edges are re-validated (light cone + kinds + DAG) on load: a file cannot
! smuggle in an edge that the classifier would reject.
module causal_serial
  use causal_units
  use causal_interval
  use causal_coords
  use causal_frames
  use causal_events
  use causal_classify
  use causal_digraph
  use causal_graph
  use causal_hexfloat
  use causal_lrdrec
  implicit none
  private

  character(len=*), parameter, public :: GRAPH_FORMAT = 'LRD-CAUSAL-GRAPH-v1'
  integer, parameter :: MAX_ID = 999999

  public :: graph_to_record, graph_serialize, graph_save, graph_load, graph_parse

contains

  pure function pad6(i) result(s)
    integer, intent(in) :: i
    character(len=6) :: s
    write (s, '(I6.6)') i
  end function pad6

  subroutine put(r, k, v, ok)
    type(lrd_record), intent(inout) :: r
    character(len=*), intent(in) :: k, v
    logical, intent(inout) :: ok
    logical :: o
    call rec_set(r, k, v, o)
    ok = ok .and. o
  end subroutine put

  subroutine put_iv(r, k, a, ok)
    type(lrd_record), intent(inout) :: r
    character(len=*), intent(in) :: k
    type(interval), intent(in) :: a
    logical, intent(inout) :: ok
    call put(r, k // '_hi', fmt_hexfloat(a%hi), ok)
    call put(r, k // '_lo', fmt_hexfloat(a%lo), ok)
  end subroutine put_iv

  subroutine graph_to_record(g, r, ok)
    type(causal_graph_t), intent(in) :: g
    type(lrd_record), intent(out) :: r
    logical, intent(out) :: ok
    integer :: i, j, k, s, d
    character(len=:), allocatable :: p, topo
    integer :: order(g%n_ev)
    logical :: tok
    type(classification) :: c
    type(boost_transform) :: t

    call rec_init(r)
    ok = .true.
    call put(r, 'format', GRAPH_FORMAT, ok)
    call put(r, 'name', trim(g%name), ok)
    if (g%synthetic) then
      call put(r, 'fixture', 'SYNTHETIC', ok)
    else
      call put(r, 'fixture', 'none', ok)
    end if
    call put(r, 'units', 't=s;x=m;s2=m2;c=299792458m/s(exact);signature=-+++', ok)
    call put(r, 'opt.abs_tol_m2', fmt_hexfloat(g%opts%abs_tol), ok)
    call put(r, 'opt.rel_tol', fmt_hexfloat(g%opts%rel_tol), ok)
    call put(r, 'n_frames', itoa(g%reg%nf), ok)
    call put(r, 'n_transforms', itoa(g%reg%nt), ok)
    call put(r, 'n_events', itoa(g%n_ev), ok)
    call put(r, 'n_edges', itoa(g%dg%m), ok)
    call put(r, 'n_rejected', itoa(g%n_rej), ok)

    do i = 1, g%reg%nf
      p = 'frame.' // pad6(i) // '.'
      call put(r, p // 'id', itoa(g%reg%f(i)%id), ok)
      call put(r, p // 'kind', frame_kind_name(g%reg%f(i)%kind), ok)
      call put(r, p // 'name', trim(g%reg%f(i)%name), ok)
    end do
    do i = 1, g%reg%nt
      t = g%reg%tr(i)
      p = 'transform.' // pad6(i) // '.'
      call put(r, p // 'from', itoa(t%from_id), ok)
      call put(r, p // 'to', itoa(t%to_id), ok)
      call put(r, p // 'type', 'lorentz_boost_plus_offset', ok)
      do j = 1, 3
        call put(r, p // 'beta' // itoa(j), fmt_hexfloat(t%beta(j)), ok)
      end do
      do j = 1, 4
        call put(r, p // 'offset' // itoa(j - 1) // '_m', fmt_hexfloat(t%offset(j)), ok)
      end do
    end do
    do i = 1, g%n_ev
      if (g%ev(i)%id > MAX_ID) ok = .false.
      p = 'event.' // pad6(i) // '.'
      call put(r, p // 'id', itoa(g%ev(i)%id), ok)
      call put(r, p // 'kind', kind_name(g%ev(i)%kind), ok)
      call put(r, p // 'label', trim(g%ev(i)%label), ok)
      call put(r, p // 'frame', itoa(g%ev(i)%c%frame_id), ok)
      call put_iv(r, p // 't_s', g%ev(i)%c%t, ok)
      do j = 1, 3
        call put_iv(r, p // 'x' // itoa(j) // '_m', g%ev(i)%c%x(j), ok)
      end do
      call put(r, p // 'has_redshift', merge('1', '0', g%ev(i)%c%has_z), ok)
      call put_iv(r, p // 'redshift', g%ev(i)%c%z, ok)
    end do
    do k = 1, g%dg%m
      call cg_edge(g, k, s, d)
      p = 'edge.' // pad6(k) // '.'
      call put(r, p // 'src', itoa(s), ok)
      call put(r, p // 'dst', itoa(d), ok)
      call put(r, p // 'sep', sep_name(g%ecls(k)%sep), ok)
      call put(r, p // 'dir', dir_name(g%ecls(k)%dir), ok)
      call put_iv(r, p // 's2_m2', g%ecls(k)%s2, ok)
    end do
    do k = 1, g%n_rej
      p = 'rejected.' // pad6(k) // '.'
      call put(r, p // 'src', itoa(g%rsrc(k)), ok)
      call put(r, p // 'dst', itoa(g%rdst(k)), ok)
      call put(r, p // 'reason', edge_code_name(g%rcode(k)), ok)
    end do
    ! all ordered pairs of distinct events, keyed by event ids
    do i = 1, g%n_ev
      do j = 1, g%n_ev
        if (i == j) cycle
        c = classify(g%reg, g%ev(i), g%ev(j), g%opts)
        call put(r, 'pair.' // pad6(g%ev(i)%id) // '.' // pad6(g%ev(j)%id), &
                 sep_name(c%sep) // '/' // dir_name(c%dir), ok)
      end do
    end do
    call cg_topo(g, order, tok)
    if (.not. tok) ok = .false.
    topo = ''
    do i = 1, g%n_ev
      if (i > 1) topo = topo // ','
      topo = topo // itoa(order(i))
    end do
    call put(r, 'topo', topo, ok)
  end subroutine graph_to_record

  subroutine graph_serialize(g, buf, ok)
    type(causal_graph_t), intent(in) :: g
    character(len=:), allocatable, intent(out) :: buf
    logical, intent(out) :: ok
    type(lrd_record) :: r
    call graph_to_record(g, r, ok)
    call rec_serialize(r, buf)
  end subroutine graph_serialize

  ! Writes <path> (the record) and <path>.commit (commitment hex + LF).
  subroutine graph_save(g, path, commit, ok)
    type(causal_graph_t), intent(in) :: g
    character(len=*), intent(in) :: path
    character(len=64), intent(out) :: commit
    logical, intent(out) :: ok
    character(len=:), allocatable :: buf
    logical :: o
    commit = ''
    call graph_serialize(g, buf, ok)
    if (.not. ok) return
    commit = rec_commitment(buf)
    call write_bytes(path, buf, o)
    ok = ok .and. o
    call write_bytes(path // '.commit', commit // achar(10), o)
    ok = ok .and. o
  end subroutine graph_save

  ! ------------------------------------------------------------------ loading
  subroutine need(r, k, v, ok, err)
    type(lrd_record), intent(in) :: r
    character(len=*), intent(in) :: k
    character(len=:), allocatable, intent(out) :: v
    logical, intent(inout) :: ok
    character(len=:), allocatable, intent(inout) :: err
    logical :: f
    call rec_get(r, k, v, f)
    if (.not. f .and. ok) then
      ok = .false.
      err = 'missing:' // k
    end if
  end subroutine need

  subroutine need_int(r, k, n, ok, err)
    type(lrd_record), intent(in) :: r
    character(len=*), intent(in) :: k
    integer, intent(out) :: n
    logical, intent(inout) :: ok
    character(len=:), allocatable, intent(inout) :: err
    character(len=:), allocatable :: v
    integer :: ios
    n = 0
    call need(r, k, v, ok, err)
    if (.not. ok) return
    if (len(v) == 0 .or. verify(v, '-0123456789') /= 0) then
      ok = .false.
      err = 'bad_int:' // k
      return
    end if
    read (v, *, iostat=ios) n
    if (ios /= 0 .or. itoa(n) /= v) then
      ok = .false.
      err = 'bad_int:' // k
    end if
  end subroutine need_int

  subroutine need_real(r, k, x, ok, err)
    type(lrd_record), intent(in) :: r
    character(len=*), intent(in) :: k
    real(dp), intent(out) :: x
    logical, intent(inout) :: ok
    character(len=:), allocatable, intent(inout) :: err
    character(len=:), allocatable :: v
    logical :: o
    x = 0.0_dp
    call need(r, k, v, ok, err)
    if (.not. ok) return
    call parse_hexfloat(v, x, o)
    if (.not. o) then
      ok = .false.
      err = 'bad_hexfloat:' // k
    end if
  end subroutine need_real

  subroutine need_iv(r, k, a, ok, err)
    type(lrd_record), intent(in) :: r
    character(len=*), intent(in) :: k
    type(interval), intent(out) :: a
    logical, intent(inout) :: ok
    character(len=:), allocatable, intent(inout) :: err
    call need_real(r, k // '_lo', a%lo, ok, err)
    call need_real(r, k // '_hi', a%hi, ok, err)
  end subroutine need_iv

  subroutine graph_parse(buf, g, ok, err)
    character(len=*), intent(in) :: buf
    type(causal_graph_t), intent(out) :: g
    logical, intent(out) :: ok
    character(len=:), allocatable, intent(out) :: err
    type(lrd_record) :: r
    character(len=:), allocatable :: v, p, buf2
    integer :: nf, nt, ne, nd, nr, i, j, id, kind, st, s, d, code
    real(dp) :: beta(3), off(4)
    type(event) :: e
    logical :: o

    call rec_parse(buf, r, ok, err)
    if (.not. ok) return
    err = ''
    call need(r, 'format', v, ok, err)
    if (ok .and. v /= GRAPH_FORMAT) then
      ok = .false.
      err = 'bad_format'
    end if
    call need(r, 'name', v, ok, err)
    if (.not. ok) return
    call cg_init(g, v, .false.)
    call need(r, 'fixture', v, ok, err)
    if (ok) g%synthetic = v == 'SYNTHETIC'
    call need_real(r, 'opt.abs_tol_m2', g%opts%abs_tol, ok, err)
    call need_real(r, 'opt.rel_tol', g%opts%rel_tol, ok, err)
    call need_int(r, 'n_frames', nf, ok, err)
    call need_int(r, 'n_transforms', nt, ok, err)
    call need_int(r, 'n_events', ne, ok, err)
    call need_int(r, 'n_edges', nd, ok, err)
    call need_int(r, 'n_rejected', nr, ok, err)
    if (.not. ok) return

    do i = 1, nf
      p = 'frame.' // pad6(i) // '.'
      call need_int(r, p // 'id', id, ok, err)
      call need(r, p // 'kind', v, ok, err)
      if (.not. ok) return
      kind = frame_kind_from_name(v)
      call need(r, p // 'name', v, ok, err)
      if (.not. ok) return
      call reg_add_frame(g%reg, id, kind, v, st)
      if (st /= ST_OK) then
        ok = .false.
        err = 'frame_rejected:' // p
        return
      end if
    end do
    do i = 1, nt
      p = 'transform.' // pad6(i) // '.'
      call need_int(r, p // 'from', s, ok, err)
      call need_int(r, p // 'to', d, ok, err)
      do j = 1, 3
        call need_real(r, p // 'beta' // itoa(j), beta(j), ok, err)
      end do
      do j = 1, 4
        call need_real(r, p // 'offset' // itoa(j - 1) // '_m', off(j), ok, err)
      end do
      if (.not. ok) return
      call reg_add_boost(g%reg, s, d, beta, off, st)
      if (st /= ST_OK) then
        ok = .false.
        err = 'transform_rejected:' // p
        return
      end if
    end do
    do i = 1, ne
      p = 'event.' // pad6(i) // '.'
      e = event()
      call need_int(r, p // 'id', e%id, ok, err)
      call need(r, p // 'kind', v, ok, err)
      if (.not. ok) return
      e%kind = kind_from_name(v)
      call need(r, p // 'label', v, ok, err)
      if (.not. ok) return
      if (len(v) > len(e%label)) then
        ok = .false.
        err = 'label_too_long:' // p
        return
      end if
      e%label = v
      call need_int(r, p // 'frame', e%c%frame_id, ok, err)
      call need_iv(r, p // 't_s', e%c%t, ok, err)
      do j = 1, 3
        call need_iv(r, p // 'x' // itoa(j) // '_m', e%c%x(j), ok, err)
      end do
      call need(r, p // 'has_redshift', v, ok, err)
      if (.not. ok) return
      e%c%has_z = v == '1'
      call need_iv(r, p // 'redshift', e%c%z, ok, err)
      if (.not. ok) return
      call cg_add_event(g, e, o)
      if (.not. o) then
        ok = .false.
        err = 'event_rejected:' // p
        return
      end if
    end do
    do i = 1, nd
      p = 'edge.' // pad6(i) // '.'
      call need_int(r, p // 'src', s, ok, err)
      call need_int(r, p // 'dst', d, ok, err)
      if (.not. ok) return
      code = cg_add_edge(g, s, d, log=.false.)
      if (code /= EDGE_OK) then
        ok = .false.
        err = 'edge_revalidation_failed:' // p // edge_code_name(code)
        return
      end if
    end do
    do i = 1, nr
      p = 'rejected.' // pad6(i) // '.'
      call need_int(r, p // 'src', s, ok, err)
      call need_int(r, p // 'dst', d, ok, err)
      call need(r, p // 'reason', v, ok, err)
      if (.not. ok) return
      code = edge_code_from_name(v)
      if (code == EDGE_OK .or. edge_code_name(code) /= v) then
        ok = .false.
        err = 'bad_reject_reason:' // p
        return
      end if
      call append_rejection(g, s, d, code)
    end do
    ! canonical check: derived fields and field set must match exactly
    call graph_serialize(g, buf2, o)
    if (.not. o) then
      ok = .false.
      err = 'reserialize_failed'
      return
    end if
    if (len(buf2) /= len(buf)) then
      ok = .false.
      err = 'not_canonical'
      return
    end if
    if (buf2 /= buf) then
      ok = .false.
      err = 'not_canonical'
      return
    end if
    ok = .true.
  end subroutine graph_parse

  subroutine append_rejection(g, s, d, code)
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
  end subroutine append_rejection

  ! graph_load: reads <path>, verifies it against the sidecar <path>.commit, then parses.
  ! The sidecar is checked BEFORE the record is interpreted.  A sidecar must be 64 lowercase
  ! hex characters, optionally followed by exactly one LF (graph_save writes the LF).  Errors
  ! (all with ok = .false.; err text is the contract):
  !   read_failed             <path> cannot be read
  !   commit_sidecar_missing  <path>.commit cannot be opened/read
  !   commit_sidecar_malformed  not 64 lowercase hex characters (+ optional LF)
  !   commit_sidecar_zero     64 x '0' (a placeholder, never a SHA-256 of a record)
  !   commit_mismatch         well-formed sidecar differs from the recomputed commitment
  ! `commit` always returns the commitment recomputed from the bytes of <path> (blank only
  ! when <path> itself could not be read).  Any other err comes from graph_parse.
  subroutine graph_load(path, g, ok, err, commit)
    character(len=*), intent(in) :: path
    type(causal_graph_t), intent(out) :: g
    logical, intent(out) :: ok
    character(len=:), allocatable, intent(out) :: err
    character(len=64), intent(out) :: commit
    character(len=:), allocatable :: buf, side
    logical :: sok
    commit = ''
    call read_bytes(path, buf, ok)
    if (.not. ok) then
      err = 'read_failed'
      return
    end if
    commit = rec_commitment(buf)
    call read_bytes(path // '.commit', side, sok)
    if (.not. sok) then
      ok = .false.
      err = 'commit_sidecar_missing'
      return
    end if
    if (len(side) == 65) then
      if (side(65:65) /= achar(10)) side = ''
    end if
    if (len(side) == 65) side = side(1:64)
    if (len(side) /= 64) then
      ok = .false.
      err = 'commit_sidecar_malformed'
      return
    end if
    if (verify(side, '0123456789abcdef') /= 0) then
      ok = .false.
      err = 'commit_sidecar_malformed'
      return
    end if
    if (verify(side, '0') == 0) then
      ok = .false.
      err = 'commit_sidecar_zero'
      return
    end if
    if (side /= commit) then
      ok = .false.
      err = 'commit_mismatch'
      return
    end if
    call graph_parse(buf, g, ok, err)
  end subroutine graph_load

end module causal_serial
