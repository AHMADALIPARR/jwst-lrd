! Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
! SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
! Licensed under AGPL-3.0-only plus the SnapKitty Opaque License (dual license, intentional).
! See LICENSE and SNAPKITTY_OPAQUE_LICENSE.md at the repository root.
!
! Fortran reference test driver for the simplicial topology ledger.
! usage: test_topology <evidence_dir> <futhark_fixture_dir> <geometry_dir>
! Prints "PASS <name>" / "FAIL <name> <why>" per test; exit status 1 on any FAIL.
program test_topology
  use, intrinsic :: iso_fortran_env, only: int64
  use topo_sha256
  use topo_field
  use topo_complex
  use topo_homology
  use topo_record
  use topo_commit
  use topo_incremental
  use topo_fixtures
  use topo_export
  implicit none

  character(len=512) :: evd, futd, geod
  integer :: npass = 0, nfail = 0
  type(sbuf_t) :: ev_betti, ev_dd, ev_commit, ev_sha, ev_inc, ev_inv, ev_tamper, ev_reps, &
                  manifest, ev_geom
  type(field_t) :: gf2, gf3, gf5, fq

  call get_command_argument(1, evd)
  call get_command_argument(2, futd)
  call get_command_argument(3, geod)
  if (len_trim(evd) == 0) evd = '.'
  if (len_trim(futd) == 0) futd = '.'
  if (len_trim(geod) == 0) geod = '.'

  call setup_fields()
  call test_sha256()
  call test_fields()
  call test_records()
  call test_fixtures()
  call test_invalid()
  call test_commitments()
  call test_tamper_and_roundtrip()
  call test_incremental('SYNTHETIC_torus_7v', gf2)
  call test_incremental('SYNTHETIC_torus_7v', gf3)
  call test_incremental('SYNTHETIC_rp2_6v', gf2)
  call test_incremental('SYNTHETIC_rp2_6v', gf3)
  call test_incremental('SYNTHETIC_random_seed20261019', gf2)
  call test_reps()
  call test_exports()

  call write_bytes(trim(evd) // '/betti_table.txt', sbuf_str(ev_betti))
  call write_bytes(trim(evd) // '/ddcheck.txt', sbuf_str(ev_dd))
  call write_bytes(trim(evd) // '/commitments.txt', sbuf_str(ev_commit))
  call write_bytes(trim(evd) // '/sha256_vectors.txt', sbuf_str(ev_sha))
  call write_bytes(trim(evd) // '/incremental.txt', sbuf_str(ev_inc))
  call write_bytes(trim(evd) // '/invalid_attachments.txt', sbuf_str(ev_inv))
  call write_bytes(trim(evd) // '/tamper.txt', sbuf_str(ev_tamper))
  call write_bytes(trim(evd) // '/homology_reps.txt', sbuf_str(ev_reps))
  call write_bytes(trim(evd) // '/geometry_exports.txt', sbuf_str(ev_geom))
  call write_bytes(trim(futd) // '/manifest.txt', sbuf_str(manifest))

  write(*, '(a,i0,a,i0)') 'FORTRAN SUMMARY pass=', npass, ' fail=', nfail
  if (nfail > 0) error stop 1

contains

  subroutine check(name, cond, why)
    character(len=*), intent(in) :: name, why
    logical, intent(in) :: cond
    if (cond) then
      npass = npass + 1
      write(*, '(a)') 'PASS ' // name
    else
      nfail = nfail + 1
      write(*, '(a)') 'FAIL ' // name // ' ' // why
    end if
  end subroutine check

  subroutine setup_fields()
    integer :: e
    call make_gfp(2_int64, gf2, e)
    call make_gfp(3_int64, gf3, e)
    call make_gfp(5_int64, gf5, e)
    fq = make_q()
  end subroutine setup_fields

  subroutine test_sha256()
    character(len=:), allocatable :: m
    character(len=64) :: h
    integer :: i
    h = sha256_hex('abc')
    call sbuf_add(ev_sha, 'abc ' // h // char(10))
    call check('sha256_nist_abc', h == 'ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad', h)
    h = sha256_hex('')
    call sbuf_add(ev_sha, 'empty ' // h // char(10))
    call check('sha256_nist_empty', h == 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855', h)
    h = sha256_hex('abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq')
    call sbuf_add(ev_sha, 'nist448 ' // h // char(10))
    call check('sha256_nist_448bit', h == '248d6a61d20638b8e5c026930c3e6039a33ce45964ff2167f6ecedd419db06c1', h)
    allocate(character(len=1000000) :: m)
    do i = 1, 1000000
      m(i:i) = 'a'
    end do
    h = sha256_hex(m)
    call sbuf_add(ev_sha, 'million_a ' // h // char(10))
    call check('sha256_nist_million_a', h == 'cdc76e5c9914fb9281a1c7e284d73e67f1809a48a497200e046d39ccc7112cd0', h)
  end subroutine test_sha256

  subroutine test_records()
    type(rec_t) :: r
    type(rec_t), allocatable :: recs(:)
    integer, allocatable :: st(:), en(:)
    integer :: n
    logical :: ok
    character(len=1), parameter :: NL = char(10)
    call rec_set(r, 'kind', 'simplex'); call rec_set(r, 'dim', '0')
    call check('lrdrec_golden_sorted_serialization', rec_serialize(r) == 'LRD-REC-v1' // NL // &
         '3:dim1:0' // NL // '4:kind7:simplex' // NL, 'unexpected bytes')
    call rec_set(r, '', 'x')
    call check('lrdrec_rec_set_rejects_empty_key', (.not. rec_ok(r)) .and. r%n == 2, 'empty key accepted')
    call parse_records('LRD-REC-v1' // NL // '0:3:abc' // NL, recs, n, st, en, ok)
    call check('lrdrec_parse_rejects_empty_key', .not. ok, 'empty key parsed')
    call parse_records('LRD-REC-v1' // NL // '1:a1:x' // NL, recs, n, st, en, ok)
    call check('lrdrec_parse_accepts_minimal', ok .and. n == 1, 'valid record rejected')
    call parse_records('LRD-REC-v1' // NL // '1:b1:x' // NL // '1:a1:y' // NL, recs, n, st, en, ok)
    call check('lrdrec_parse_rejects_unsorted_keys', .not. ok, 'unsorted accepted')
    call parse_records('LRD-REC-v1' // NL // '1:a1:x' // NL // '1:a1:y' // NL, recs, n, st, en, ok)
    call check('lrdrec_parse_rejects_duplicate_keys', .not. ok, 'duplicate accepted')
    call parse_records('LRD-REC-v1' // NL // '01:a1:x' // NL, recs, n, st, en, ok)
    call check('lrdrec_parse_rejects_leading_zero_length', .not. ok, 'leading zero accepted')
  end subroutine test_records

  subroutine test_fields()
    type(field_t) :: f
    integer :: e, i
    integer(int64), parameter :: good(6) = [2_int64, 3_int64, 5_int64, 7_int64, 101_int64, 2147483647_int64]
    integer(int64), parameter :: bad(7) = [-3_int64, 0_int64, 1_int64, 4_int64, 9_int64, 561_int64, 2147483648_int64]
    logical :: ok
    ok = .true.
    do i = 1, size(good)
      call make_gfp(good(i), f, e)
      if (e /= FERR_OK) ok = .false.
    end do
    call check('field_accepts_primes', ok, 'a prime was rejected')
    ok = .true.
    do i = 1, size(bad)
      call make_gfp(bad(i), f, e)
      if (e /= FERR_NOT_PRIME) ok = .false.
    end do
    call check('field_rejects_nonprimes', ok, 'a non-prime (or p>=2^31) was accepted')
  end subroutine test_fields

  function bstr(b, md) result(s)
    integer, intent(in) :: b(0:MAXD), md
    character(len=:), allocatable :: s
    if (md < 0) then
      s = '()'
    else
      s = '(' // join_ints(int(b(0:md), int64)) // ')'
    end if
  end function bstr

  !> expected Betti strings over GF(2), GF(3), Q ('' = no a-priori expectation)
  subroutine expected(name, e2, e3, eq)
    character(len=*), intent(in) :: name
    character(len=:), allocatable, intent(out) :: e2, e3, eq
    select case (trim(name))
    case ('SYNTHETIC_vertex'); e2 = '(1)'
    case ('SYNTHETIC_two_vertices'); e2 = '(2)'
    case ('SYNTHETIC_edge'); e2 = '(1,0)'
    case ('SYNTHETIC_hollow_triangle', 'SYNTHETIC_hollow_square', 'SYNTHETIC_hollow_triangle_relab')
      e2 = '(1,1)'
    case ('SYNTHETIC_filled_triangle'); e2 = '(1,0,0)'
    case ('SYNTHETIC_tetra_boundary'); e2 = '(1,0,1)'
    case ('SYNTHETIC_solid_tetra'); e2 = '(1,0,0,0)'
    case ('SYNTHETIC_torus_7v', 'SYNTHETIC_torus_grid3x3'); e2 = '(1,2,1)'
    case ('SYNTHETIC_rp2_6v'); e2 = '(1,1,1)'; e3 = '(1,0,0)'; eq = '(1,0,0)'; return
    case ('SYNTHETIC_klein_grid4x4'); e2 = '(1,2,1)'; e3 = '(1,1,0)'; eq = '(1,1,0)'; return
    case default; e2 = ''
    end select
    e3 = e2; eq = e2
  end subroutine expected

  subroutine test_fixtures()
    type(complex_t) :: c
    integer :: i, k, b2(0:MAXD), b3(0:MAXD), b5(0:MAXD), bq(0:MAXD), e, md, nnz, chi, alt
    integer(int64) :: mx
    logical :: ok, ddok, pm
    character(len=:), allocatable :: e2, e3, eq, nm, line
    call sbuf_add(ev_betti, '# fixture | counts n_0..n_d | chi | GF(2) | GF(3) | GF(5) | Q' // char(10))
    call sbuf_add(ev_dd, '# fixture k nnz(d_{k-1} d_k) max|entry|  (exact int64 matmul)' // char(10))
    do i = 1, NFIX
      nm = trim(FIXTURES(i))
      call build_fixture(nm, c, ok)
      call check('build_' // nm, ok, 'fixture construction hit an attachment error')
      md = max_dim(c)
      call compute_betti(c, gf2, b2, e)
      call compute_betti(c, gf3, b3, e)
      call compute_betti(c, gf5, b5, e)
      call compute_betti(c, fq, bq, e)
      call check('rank_q_no_overflow_' // nm, e == 0, 'Bareiss overflow')
      chi = euler_char(c)
      line = nm // ' | ('
      do k = 0, md
        if (k > 0) line = line // ','
        line = line // itoa(count_dim(c, k))
      end do
      line = line // ') | ' // itoa(chi) // ' | ' // bstr(b2, md) // ' | ' // bstr(b3, md) // &
             ' | ' // bstr(b5, md) // ' | ' // bstr(bq, md)
      call sbuf_add(ev_betti, line // char(10))
      call expected(nm, e2, e3, eq)
      if (len(e2) > 0) then
        call check('betti_gf2_' // nm, bstr(b2, md) == e2, 'got ' // bstr(b2, md) // ' want ' // e2)
        call check('betti_gf3_' // nm, bstr(b3, md) == e3, 'got ' // bstr(b3, md) // ' want ' // e3)
        call check('betti_q_' // nm, bstr(bq, md) == eq, 'got ' // bstr(bq, md) // ' want ' // eq)
      end if
      ! Euler-Poincare: chi = sum (-1)^k b_k over every field
      ok = .true.
      alt = 0
      do k = 0, MAXD
        alt = alt + (1 - 2 * mod(k, 2)) * b2(k)
      end do
      if (alt /= chi) ok = .false.
      alt = 0
      do k = 0, MAXD
        alt = alt + (1 - 2 * mod(k, 2)) * bq(k)
      end do
      if (alt /= chi) ok = .false.
      alt = 0
      do k = 0, MAXD
        alt = alt + (1 - 2 * mod(k, 2)) * b3(k)
      end do
      if (alt /= chi) ok = .false.
      call check('euler_poincare_' // nm, ok, 'alternating Betti sum /= chi')
      ddok = .true.
      do k = 2, max(md, 2)
        call dd_check(c, k, nnz, mx)
        call sbuf_add(ev_dd, nm // ' ' // itoa(k) // ' ' // itoa(nnz) // ' ' // itoa(mx) // char(10))
        if (nnz /= 0) ddok = .false.
      end do
      call check('dd_zero_' // nm, ddok, 'nonzero entry in d_{k-1} d_k')
      if (index(nm, 'torus') > 0 .or. index(nm, 'klein') > 0 .or. index(nm, 'rp2') > 0 &
          .or. nm == 'SYNTHETIC_tetra_boundary') then
        pm = .true.
        do k = 1, c%n
          if (c%alive(k) .and. c%dimv(k) == 1) then
            if (c%cof(k)%n /= 2) pm = .false.
          end if
        end do
        call check('closed_surface_' // nm, pm, 'some edge is not in exactly 2 triangles')
      end if
    end do
    call build_fixture('SYNTHETIC_torus_7v', c, ok)
    call check('counts_torus_7v', count_dim(c,0) == 7 .and. count_dim(c,1) == 21 .and. count_dim(c,2) == 14, &
               'expected (7,21,14)')
    call build_fixture('SYNTHETIC_rp2_6v', c, ok)
    call check('counts_rp2_6v', count_dim(c,0) == 6 .and. count_dim(c,1) == 15 .and. count_dim(c,2) == 10, &
               'expected (6,15,10)')
    call compute_betti(c, gf2, b2, e); call compute_betti(c, gf3, b3, e); call compute_betti(c, fq, bq, e)
    call check('field_dependence_rp2_b1_gf2_1_gf3_0_q_0', b2(1) == 1 .and. b3(1) == 0 .and. bq(1) == 0, &
               'b1(GF2)=' // itoa(b2(1)) // ' b1(GF3)=' // itoa(b3(1)) // ' b1(Q)=' // itoa(bq(1)))
  end subroutine test_fixtures

  subroutine try_add(c, label, d, v, want)
    type(complex_t), intent(inout) :: c
    character(len=*), intent(in) :: label
    integer, intent(in) :: d, want
    integer(int64), intent(in) :: v(:)
    integer :: e, b(0:MAXD)
    character(len=64) :: r0, r1
    b = 0
    call complex_root(c, gf2, b, r0)
    call add_simplex(c, d, v, e)
    call complex_root(c, gf2, b, r1)
    call sbuf_add(ev_inv, label // ' dim=' // itoa(d) // ' verts=' // join_ints(v) // ' -> ' // &
                  err_name(e) // char(10))
    call check('reject_' // label, e == want .and. r0 == r1, 'got ' // err_name(e) // ' want ' // &
               err_name(want) // ' (or complex changed)')
  end subroutine try_add

  subroutine test_invalid()
    type(complex_t) :: c
    integer :: e, b(0:MAXD)
    character(len=64) :: r0, r1
    call complex_init(c)
    call add_simplex(c, 0, [0_int64], e); call add_simplex(c, 0, [1_int64], e)
    call add_simplex(c, 0, [2_int64], e); call add_simplex(c, 1, [0_int64, 1_int64], e)
    call check('accept_edge_with_faces', e == TERR_OK, err_name(e))
    call try_add(c, 'missing_face_triangle', 2, [0_int64, 1_int64, 2_int64], TERR_MISSING_FACE)
    call try_add(c, 'tetra_with_absent_vertex', 3, [0_int64, 1_int64, 2_int64, 3_int64], TERR_UNKNOWN_VERTEX)
    block
      type(complex_t) :: t
      integer :: e2
      call complex_init(t)
      call add_closure(t, [0_int64, 1_int64, 2_int64], e2); call add_closure(t, [0_int64, 1_int64, 3_int64], e2)
      call add_closure(t, [0_int64, 2_int64, 3_int64], e2); call add_closure(t, [1_int64, 2_int64], e2)
      call add_closure(t, [1_int64, 3_int64], e2); call add_closure(t, [2_int64, 3_int64], e2)
      call try_add(t, 'missing_face_tetra_triangle_123_absent', 3, [0_int64, 1_int64, 2_int64, 3_int64], &
                   TERR_MISSING_FACE)
    end block
    call try_add(c, 'duplicate_edge_reordered', 1, [1_int64, 0_int64], TERR_DUPLICATE)
    call try_add(c, 'duplicate_vertex', 0, [2_int64], TERR_DUPLICATE)
    call try_add(c, 'degenerate_edge', 1, [1_int64, 1_int64], TERR_DEGENERATE)
    call try_add(c, 'degenerate_triangle', 2, [0_int64, 1_int64, 0_int64], TERR_DEGENERATE)
    call try_add(c, 'unknown_vertex', 1, [0_int64, 9_int64], TERR_UNKNOWN_VERTEX)
    call try_add(c, 'dim_mismatch', 2, [0_int64, 2_int64], TERR_DIM_MISMATCH)
    call try_add(c, 'dim_too_large', MAXD + 1, [(int(e, int64), e = 0, MAXD + 1)], TERR_DIM_MISMATCH)
    call try_add(c, 'negative_label', 0, [-5_int64], TERR_BAD_VERTEX_ID)
    b = 0
    call complex_root(c, gf2, b, r0)
    call remove_simplex(c, [0_int64], e)
    call complex_root(c, gf2, b, r1)
    call sbuf_add(ev_inv, 'remove vertex 0 (has coface 1:0,1) -> ' // err_name(e) // char(10))
    call check('reject_remove_with_cofaces', e == TERR_HAS_COFACES .and. r0 == r1, err_name(e))
    call remove_simplex(c, [1_int64, 2_int64], e)
    call sbuf_add(ev_inv, 'remove absent edge 1:1,2 -> ' // err_name(e) // char(10))
    call check('reject_remove_not_found', e == TERR_NOT_FOUND, err_name(e))
    call remove_simplex(c, [1_int64, 0_int64], e)
    call sbuf_add(ev_inv, 'remove edge 1:0,1 (no cofaces) -> ' // err_name(e) // char(10))
    call check('accept_remove_free_edge', e == TERR_OK .and. c%cof(1)%n == 0, err_name(e))
  end subroutine test_invalid

  !> Rebuild a complex in a different insertion order (dimension ascending, reverse
  !> lexicographic within a dimension), preserving orientations.
  subroutine rebuild_reversed(c, out)
    type(complex_t), intent(in) :: c
    type(complex_t), intent(out) :: out
    integer, allocatable :: idx(:)
    integer(int64), allocatable :: v(:)
    integer(int64) :: t
    integer :: d, i, s, e
    call complex_init(out, 16)
    do d = 0, MAXD
      call canonical_order(c, d, idx)
      do i = size(idx), 1, -1
        s = idx(i)
        v = c%verts(0:d, s)
        if (c%orient(s) == -1) then
          t = v(1); v(1) = v(2); v(2) = t
        end if
        call add_simplex(out, d, v, e)
        if (e /= TERR_OK) write(*, '(a)') 'internal: rebuild_reversed attach error ' // err_name(e)
      end do
    end do
  end subroutine rebuild_reversed

  subroutine test_commitments()
    type(complex_t) :: a, b, c, d
    integer :: ba(0:MAXD), bb(0:MAXD), bc(0:MAXD), e, i
    character(len=64) :: ra, rb, rc, rd, ra3
    logical :: ok
    do i = 1, NFIX
      call build_fixture(trim(FIXTURES(i)), a, ok)
      call compute_betti(a, gf2, ba, e)
      call complex_root(a, gf2, ba, ra)
      call compute_betti(a, gf3, bb, e)
      call complex_root(a, gf3, bb, ra3)
      call compute_betti(a, fq, bc, e)
      call complex_root(a, fq, bc, rc)
      call sbuf_add(ev_commit, trim(FIXTURES(i)) // ' GF(2) ' // ra // char(10))
      call sbuf_add(ev_commit, trim(FIXTURES(i)) // ' GF(3) ' // ra3 // char(10))
      call sbuf_add(ev_commit, trim(FIXTURES(i)) // ' Q ' // rc // char(10))
    end do
    ! insertion-order independence
    call build_fixture('SYNTHETIC_torus_7v', a, ok)
    call rebuild_reversed(a, b)
    call compute_betti(a, gf2, ba, e); call compute_betti(b, gf2, bb, e)
    call complex_root(a, gf2, ba, ra); call complex_root(b, gf2, bb, rb)
    call check('commit_insertion_order_independent', ra == rb, ra // ' vs ' // rb)
    ! equal Betti, different complexes
    call build_fixture('SYNTHETIC_hollow_triangle', a, ok)
    call build_fixture('SYNTHETIC_hollow_triangle_relab', b, ok)
    call build_fixture('SYNTHETIC_hollow_square', c, ok)
    call compute_betti(a, gf2, ba, e); call compute_betti(b, gf2, bb, e); call compute_betti(c, gf2, bc, e)
    call complex_root(a, gf2, ba, ra); call complex_root(b, gf2, bb, rb); call complex_root(c, gf2, bc, rc)
    call sbuf_add(ev_commit, '# equal-Betti comparison over GF(2): betti a=' // bstr(ba, 1) // &
         ' b=' // bstr(bb, 1) // ' c=' // bstr(bc, 1) // char(10))
    call sbuf_add(ev_commit, 'hollow_triangle        ' // ra // char(10))
    call sbuf_add(ev_commit, 'hollow_triangle_relab  ' // rb // char(10))
    call sbuf_add(ev_commit, 'hollow_square          ' // rc // char(10))
    call check('equal_betti_relabeled_distinct_root', all(ba == bb) .and. ra /= rb, 'roots equal or betti differ')
    call check('equal_betti_nonisomorphic_distinct_root', all(ba == bc) .and. ra /= rc .and. rb /= rc, &
               'roots equal or betti differ')
    ! orientation flip of one edge: same Betti, different root
    call complex_init(d)
    call add_simplex(d, 0, [0_int64], e); call add_simplex(d, 0, [1_int64], e); call add_simplex(d, 0, [2_int64], e)
    call add_simplex(d, 1, [1_int64, 0_int64], e)   ! reversed orientation
    call add_simplex(d, 1, [1_int64, 2_int64], e); call add_simplex(d, 1, [0_int64, 2_int64], e)
    call compute_betti(d, gf2, bb, e)
    call complex_root(d, gf2, bb, rd)
    call sbuf_add(ev_commit, 'hollow_triangle_edge01_flipped ' // rd // ' betti=' // bstr(bb, 1) // char(10))
    call check('orientation_flip_same_betti_distinct_root', all(ba == bb) .and. ra /= rd, 'not distinguished')
    ! field declaration is bound: torus has equal Betti over GF(2) and GF(3)
    call build_fixture('SYNTHETIC_torus_7v', a, ok)
    call compute_betti(a, gf2, ba, e); call compute_betti(a, gf3, bb, e)
    call complex_root(a, gf2, ba, ra); call complex_root(a, gf3, bb, rb)
    call check('field_declaration_bound_in_root', all(ba == bb) .and. ra /= rb, 'field not committed')
    ! Betti vector is bound: same complex, wrong claimed Betti -> different root
    bc = ba; bc(1) = bc(1) + 1
    call complex_root(a, gf2, bc, rc)
    call check('betti_vector_bound_in_root', ra /= rc, 'betti not committed')
  end subroutine test_commitments

  !> Replace the first occurrence of pat at or after position from.
  function replace_after(s, from, pat, rep, found) result(t)
    character(len=*), intent(in) :: s, pat, rep
    integer, intent(in) :: from
    logical, intent(out) :: found
    character(len=:), allocatable :: t
    integer :: p
    p = index(s(from:), pat)
    found = (p > 0)
    if (.not. found) then
      t = s; return
    end if
    p = p + from - 1
    t = s(1:p-1) // rep // s(p+len(pat):)
  end function replace_after

  !> Find key (e.g. "5:faces") at or after from; increment (mod 10) the first digit
  !> of its value.  Same length, so only the content changes.
  function bump_value_digit(s, from, key) result(t)
    character(len=*), intent(in) :: s, key
    integer, intent(in) :: from
    character(len=:), allocatable :: t
    integer :: p, q, dg
    t = s
    p = index(s(from:), key // '')
    if (p == 0) return
    p = p + from - 1 + len(key)
    q = p + index(s(p:), ':')
    dg = ichar(s(q:q)) - ichar('0')
    if (dg < 0 .or. dg > 9) return
    t(q:q) = achar(ichar('0') + mod(dg + 1, 10))
  end function bump_value_digit

  subroutine tamper_bytes(label, t, f, troot, btrue)
    character(len=*), intent(in) :: label, t
    type(field_t), intent(in) :: f
    character(len=64), intent(in) :: troot
    integer, intent(in) :: btrue(0:MAXD)
    call tamper_case(label, t, 1, 'LRD-REC-v1', 'LRD-REC-v1', f, troot, btrue)
  end subroutine tamper_bytes

  subroutine tamper_case(label, s, from, pat, rep, f, troot, btrue)
    character(len=*), intent(in) :: label, s, pat, rep
    integer, intent(in) :: from
    type(field_t), intent(in) :: f
    character(len=64), intent(in) :: troot
    integer, intent(in) :: btrue(0:MAXD)
    character(len=:), allocatable :: t
    logical :: found, mok, sok, rok, ok
    type(rec_t), allocatable :: recs(:)
    integer, allocatable :: st(:), en(:)
    integer :: nrec, e, bt(0:MAXD)
    type(complex_t) :: c
    character(len=:), allocatable :: bnote
    t = replace_after(s, from, pat, rep, found)
    if (.not. found) then
      call check('tamper_' // label, .false., 'pattern not found: ' // pat); return
    end if
    call verify_serialized(t, f, troot, mok, sok, rok)
    bnote = 'n/a(unrebuildable)'
    call parse_records(t, recs, nrec, st, en, ok)
    if (ok) then
      call rebuild_from_records(recs, nrec - 1, c, ok)
      if (ok) then
        call compute_betti(c, f, bt, e)
        bnote = bstr(bt, max_dim(c))
        if (all(bt == btrue)) bnote = bnote // '(UNCHANGED)'
      end if
    end if
    call sbuf_add(ev_tamper, label // ': merkle_ok=' // lstr(mok) // ' struct_ok=' // lstr(sok) // &
         ' root_ok=' // lstr(rok) // ' betti_after=' // bnote // char(10))
    call check('tamper_' // label, (.not. mok) .and. (.not. (mok .and. sok .and. rok)), &
               'leaf edit not detected by the Merkle check')
  end subroutine tamper_case

  function lstr(l) result(s)
    logical, intent(in) :: l
    character(len=1) :: s
    s = 'F'
    if (l) s = 'T'
  end function lstr

  subroutine test_tamper_and_roundtrip()
    type(complex_t) :: c, c2
    integer :: b(0:MAXD), b2(0:MAXD), e, p0, nrec, i
    character(len=64) :: root, root2
    character(len=:), allocatable :: s, s2, t
    logical :: ok, mok, sok, rok, found
    type(rec_t), allocatable :: recs(:)
    integer, allocatable :: st(:), en(:)
    type(rec_t) :: rr
    character(len=64), allocatable :: lc(:)
    call build_fixture('SYNTHETIC_torus_7v', c, ok)
    call compute_betti(c, gf2, b, e)
    call complex_root(c, gf2, b, root)
    s = serialize_complex(c, gf2, b)
    call write_bytes(trim(evd) // '/torus_7v_gf2.lrdrec', s)
    call write_bytes(trim(evd) // '/torus_7v_gf2.root', root // char(10))
    call write_bytes(trim(evd) // '/torus_7v_gf2.fortran_sha256', sha256_hex(s) // char(10))
    ! round trip through the filesystem
    call read_bytes(trim(evd) // '/torus_7v_gf2.lrdrec', s2, ok)
    call check('roundtrip_read_identical_bytes', ok .and. len(s2) == len(s) .and. s2 == s, 'bytes differ')
    call verify_serialized(s2, gf2, root, mok, sok, rok)
    call check('roundtrip_verify_untampered', mok .and. sok .and. rok, 'm=' // lstr(mok) // ' s=' // &
               lstr(sok) // ' r=' // lstr(rok))
    call parse_records(s2, recs, nrec, st, en, ok)
    call rebuild_from_records(recs, nrec - 1, c2, ok)
    call compute_betti(c2, gf2, b2, e)
    call complex_root(c2, gf2, b2, root2)
    call check('roundtrip_rebuild_same_root_and_betti', ok .and. root2 == root .and. all(b == b2), root2)
    t = serialize_complex(c2, gf2, b2)
    call check('roundtrip_reserialize_identical', len(t) == len(s2) .and. t == s2, 'reserialization differs')
    call sbuf_add(ev_tamper, '# torus_7v GF(2) trusted root ' // root // char(10))
    ! locate the first edge record (dim 1) and the first triangle record (dim 2)
    p0 = index(s, '3:dim1:1')
    ! T1 orientation flip of an edge
    call tamper_case('orientation_flip_edge', s, p0, '11:orientation1:1' // char(10), &
         '11:orientation2:-1' // char(10), gf2, root, b)
    ! T2 face-sign change (incidence) of an edge
    call tamper_case('incidence_sign_edge', s, p0, '10:face_signs4:1,-1', '10:face_signs4:-1,1', gf2, root, b)
    ! T3 face index change (incidence) of the first triangle
    p0 = index(s, '3:dim1:2')
    call tamper_case('incidence_face_order_edge', s, index(s, '3:dim1:1'), '5:faces3:1,0', '5:faces3:0,1', &
         gf2, root, b)
    t = bump_value_digit(s, p0, '5:faces')
    call tamper_bytes('incidence_face_index_triangle', t, gf2, root, b)
    ! T4 vertex label change in a triangle: 0,1,3 -> 0,1,4 (a different, valid-looking triangle)
    call tamper_case('vertex_label_triangle', s, 1, '8:vertices5:0,1,3', '8:vertices5:0,1,4', gf2, root, b)
    ! T5 coface list change of a vertex
    t = bump_value_digit(s, 1, '7:cofaces')
    call tamper_bytes('coface_list_vertex', t, gf2, root, b)
    ! T6 attacker edits an edge orientation AND recomputes the Merkle root and root record
    p0 = index(s, '3:dim1:1')
    t = replace_after(s, p0, '11:orientation1:1' // char(10), '11:orientation2:-1' // char(10), found)
    call parse_records(t, recs, nrec, st, en, ok)
    allocate(lc(nrec - 1))
    do i = 1, nrec - 1
      lc(i) = commit_bytes(t(st(i):en(i)))
    end do
    rr = recs(nrec)
    call rec_set(rr, 'merkle_root', merkle_root(lc, nrec - 1))
    t = t(1:st(nrec)-1) // rec_serialize(rr)
    call verify_serialized(t, gf2, root, mok, sok, rok)
    call sbuf_add(ev_tamper, 'orientation_flip_with_recomputed_merkle: merkle_ok=' // lstr(mok) // &
         ' struct_ok=' // lstr(sok) // ' root_ok=' // lstr(rok) // char(10))
    call check('tamper_recomputed_merkle_still_detected', mok .and. (.not. rok), &
               'expected merkle_ok=T root_ok=F')
    ! T7: same with consistent incidence (a fully re-derived orientation-flipped complex)
    ! is a different, valid complex: root must differ from the trusted root
    call complex_init(c2)
    call rebuild_reversed(c, c2)
    block
      integer :: sl
      sl = find_simplex(c2, [0_int64, 1_int64, (-1_int64, i = 2, MAXD)], 1)
      c2%orient(sl) = -c2%orient(sl)
    end block
    call compute_betti(c2, gf2, b2, e)
    call complex_root(c2, gf2, b2, root2)
    call verify_serialized(serialize_complex(c2, gf2, b2), gf2, root, mok, sok, rok)
    call sbuf_add(ev_tamper, 'consistent_reoriented_complex: betti=' // bstr(b2, 2) // ' merkle_ok=' // &
         lstr(mok) // ' struct_ok=' // lstr(sok) // ' root_ok=' // lstr(rok) // ' root=' // root2 // char(10))
    call check('tamper_consistent_reorientation_root_differs', all(b == b2) .and. mok .and. sok .and. &
               (.not. rok), 'expected same Betti, internally valid, untrusted root')
  end subroutine test_tamper_and_roundtrip

  subroutine oriented(c, s, v)
    type(complex_t), intent(in) :: c
    integer, intent(in) :: s
    integer(int64), allocatable, intent(out) :: v(:)
    integer(int64) :: t
    v = c%verts(0:c%dimv(s), s)
    if (c%orient(s) == -1) then
      t = v(1); v(1) = v(2); v(2) = t
    end if
  end subroutine oriented

  subroutine inc_compare(st, label, okall, nsteps)
    type(inc_t), intent(in) :: st
    character(len=*), intent(in) :: label
    logical, intent(inout) :: okall
    integer, intent(inout) :: nsteps
    integer :: bi(0:MAXD), bs(0:MAXD), bf(0:MAXD), e
    type(complex_t) :: fresh
    character(len=64) :: ri, rf
    call inc_betti(st, bi)
    call compute_betti(st%c, st%f, bs, e)
    call rebuild_reversed(st%c, fresh)
    call compute_betti(fresh, st%f, bf, e)
    call complex_root(st%c, st%f, bi, ri)
    call complex_root(fresh, st%f, bf, rf)
    nsteps = nsteps + 1
    call sbuf_add(ev_inc, label // ' step=' // itoa(nsteps) // ' inc=' // bstr(bi, max(max_dim(st%c), 0)) // &
         ' scratch=' // bstr(bf, max(max_dim(st%c), 0)) // ' root=' // ri(1:16) // &
         ' match=' // lstr(all(bi == bs) .and. all(bi == bf) .and. ri == rf .and. ri == st%root) // char(10))
    if (.not. (all(bi == bs) .and. all(bi == bf) .and. ri == rf .and. ri == st%root)) okall = .false.
  end subroutine inc_compare

  subroutine test_incremental(fname, f)
    character(len=*), intent(in) :: fname
    type(field_t), intent(in) :: f
    type(complex_t) :: src
    type(inc_t) :: st
    integer, allocatable :: idx(:)
    integer(int64), allocatable :: v(:)
    integer :: d, i, e, nsteps, nent, bad, b0(0:MAXD), nrem, s
    logical :: ok, okall, rejok
    character(len=:), allocatable :: label, lg, t
    character(len=64) :: head, genesis
    label = fname // '@' // field_name(f)
    call build_fixture(fname, src, ok)
    call inc_init(st, f)
    genesis = st%root
    b0 = 0
    okall = .true.; nsteps = 0; rejok = .true.
    ! add every simplex: dimension ascending, canonical order, original orientation
    do d = 0, max_dim(src)
      call canonical_order(src, d, idx)
      do i = 1, size(idx)
        call oriented(src, idx(i), v)
        call inc_add(st, d, v, e)
        if (e /= TERR_OK) okall = .false.
        call inc_compare(st, label // ' add ' // simplex_id(src%verts(:, idx(i)), d), okall, nsteps)
      end do
    end do
    ! rejected updates leave the state and the log head untouched
    head = st%head
    call canonical_order(st%c, 1, idx)
    call oriented(st%c, idx(1), v)
    call inc_remove(st, v, e)
    if (e /= TERR_HAS_COFACES .and. max_dim(st%c) >= 2) rejok = .false.
    call inc_add(st, 1, v, e)
    if (e /= TERR_DUPLICATE) rejok = .false.
    if (st%head /= head) rejok = .false.
    call check('incremental_rejects_' // label, rejok, 'rejected update changed state or wrong code')
    ! remove up to 3 top simplices, then a now-free edge, then re-add them
    nrem = 0
    call canonical_order(st%c, max_dim(st%c), idx)
    do i = 1, min(3, size(idx))
      call oriented(st%c, idx(i), v)
      call inc_remove(st, v, e)
      if (e /= TERR_OK) okall = .false.
      call inc_compare(st, label // ' remove ' // simplex_id(v, size(v) - 1), okall, nsteps)
      nrem = nrem + 1
    end do
    call canonical_order(st%c, 1, idx)
    do i = 1, size(idx)
      s = idx(i)
      if (st%c%cof(s)%n == 0) then
        call oriented(st%c, s, v)
        call inc_remove(st, v, e)
        if (e /= TERR_OK) okall = .false.
        call inc_compare(st, label // ' remove free edge ' // simplex_id(st%c%verts(:, s), 1), okall, nsteps)
        call inc_add(st, 1, v, e)
        if (e /= TERR_OK) okall = .false.
        call inc_compare(st, label // ' re-add edge', okall, nsteps)
        exit
      end if
    end do
    call canonical_order(src, max_dim(src), idx)
    do i = 1, nrem
      call oriented(src, idx(i), v)
      call inc_add(st, size(v) - 1, v, e)
      if (e /= TERR_OK) okall = .false.
      call inc_compare(st, label // ' re-add ' // simplex_id(src%verts(:, idx(i)), size(v) - 1), okall, nsteps)
    end do
    call check('incremental_equals_recompute_' // label, okall, 'mismatch, see incremental.txt')
    ! update-log hash chain
    lg = sbuf_str(st%log)
    call verify_log(lg, genesis, nent, bad, head)
    call check('update_log_chain_verifies_' // label, bad == 0 .and. nent == st%seq .and. head == st%head, &
               'first_bad=' // itoa(bad))
    ! tamper: change one byte inside the 2nd entry's simplex field
    t = replace_after(lg, index(lg, '2:op') + 1, '7:simplex', '7:simplez', ok)
    call verify_log(t, genesis, nent, bad, head)
    call sbuf_add(ev_inc, label // ' log entries=' // itoa(st%seq) // ' head=' // st%head // &
         ' tampered_first_bad=' // itoa(bad) // char(10))
    call check('update_log_tamper_detected_' // label, ok .and. bad > 0, 'tamper not detected')
    if (fname == 'SYNTHETIC_torus_7v' .and. f%p == 2) &
      call write_bytes(trim(evd) // '/update_log_torus_7v_gf2.lrdrec', lg)
  end subroutine test_incremental

  subroutine test_reps()
    character(len=40), parameter :: names(4) = [character(len=40) :: 'SYNTHETIC_hollow_triangle', &
         'SYNTHETIC_torus_7v', 'SYNTHETIC_rp2_6v', 'SYNTHETIC_klein_grid4x4']
    integer(int64), parameter :: ps(2) = [2_int64, 3_int64]
    type(complex_t) :: c
    type(field_t) :: f
    integer(int64), allocatable :: reps(:,:), d1(:,:), prod(:,:)
    integer, allocatable :: idx(:)
    integer :: i, j, ip, b(0:MAXD), e, r
    logical :: ok
    character(len=:), allocatable :: line
    do i = 1, size(names)
      call build_fixture(trim(names(i)), c, ok)
      call boundary_matrix(c, 1, d1)
      call canonical_order(c, 1, idx)
      do ip = 1, 2
        call make_gfp(ps(ip), f, e)
        call compute_betti(c, f, b, e)
        call homology_reps(c, 1, ps(ip), reps)
        ok = (size(reps, 2) == b(1))
        if (size(reps, 2) > 0) then
          prod = modulo(matmul(d1, reps), ps(ip))
          if (any(prod /= 0)) ok = .false.
        end if
        call check('h1_reps_' // trim(names(i)) // '_' // field_name(f), ok, &
                   'reps=' // itoa(size(reps, 2)) // ' b1=' // itoa(b(1)))
        do r = 1, size(reps, 2)
          line = trim(names(i)) // ' ' // field_name(f) // ' H1 rep ' // itoa(r) // ':'
          do j = 1, size(reps, 1)
            if (reps(j, r) /= 0) line = line // ' ' // itoa(reps(j, r)) // '*[' // &
                 simplex_id(c%verts(:, idx(j)), 1) // ']'
          end do
          call sbuf_add(ev_reps, line // char(10))
        end do
      end do
    end do
  end subroutine test_reps

  subroutine test_exports()
    type(complex_t) :: c
    integer :: i, b(0:MAXD), e
    logical :: ok
    character(len=:), allocatable :: g, ser
    character(len=64) :: root
    do i = 1, NFIX
      call build_fixture(trim(FIXTURES(i)), c, ok)
      call compute_betti(c, gf2, b, e)
      call complex_root(c, gf2, b, root)
      g = geometry_export(c, gf2, b, trim(FIXTURES(i)))
      ser = serialize_complex(c, gf2, b)
      ok = len(g) > len(ser)
      if (ok) ok = (g(len(g) - len(ser) + 1:) == ser)
      call check('geometry_embeds_committed_serialization_' // trim(FIXTURES(i)), ok, 'tail mismatch')
      call write_bytes(trim(geod) // '/' // trim(FIXTURES(i)) // '.geom.lrdrec', g)
      call sbuf_add(ev_geom, trim(FIXTURES(i)) // '.geom.lrdrec bytes=' // itoa(len(g)) // ' sha256=' // &
                    sha256_hex(g) // ' root=' // root // char(10))
      call futhark_fixtures(c, trim(FIXTURES(i)), trim(futd), manifest)
    end do
  end subroutine test_exports

end program test_topology
