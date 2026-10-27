! Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
! Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
! SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
!
! Hex-float exactness, SHA-256 known answers, LRD-REC-v1 canonical form and parser
! strictness, and bit-exact round trip of the SYNTHETIC causal graph.
program test_serial
  use, intrinsic :: iso_fortran_env, only: int64
  use causal_units
  use causal_interval
  use causal_classify
  use causal_graph
  use causal_hexfloat
  use causal_sha256
  use causal_lrdrec
  use causal_serial
  use fixture_graph
  use test_util
  implicit none
  real(dp) :: vals(16), y
  integer :: i, k, codes(N_PROPOSALS), out1(16), out2(16), k1, k2
  logical :: ok, all_ok
  character(len=:), allocatable :: s, buf, buf2, err, v
  type(lrd_record) :: r
  type(causal_graph_t) :: g, g2
  character(len=64) :: c1, c2

  call set_suite('fortran.hexfloat')
  vals = [0.0_dp, -0.0_dp, 1.0_dp, -1.0_dp, 0.1_dp, 3.141592653589793_dp, C_LIGHT, AU_M, &
          huge(1.0_dp), tiny(1.0_dp), transfer(1_int64, 1.0_dp), transfer(int(z'000FFFFFFFFFFFFF', int64), 1.0_dp), &
          -2.5_dp, 1.0e-300_dp, transfer(int(z'7FF0000000000000', int64), 1.0_dp), &
          transfer(int(z'FFF0000000000000', int64), 1.0_dp)]
  all_ok = .true.
  do i = 1, size(vals)
    s = fmt_hexfloat(vals(i))
    call parse_hexfloat(s, y, ok)
    if (.not. ok .or. transfer(y, 0_int64) /= transfer(vals(i), 0_int64) .or. fmt_hexfloat(y) /= s) &
      all_ok = .false.
  end do
  call check('roundtrip_bit_exact_16_values', all_ok)
  call check('known_1', fmt_hexfloat(1.0_dp) == '0x1.0000000000000p+0')
  call check('known_0.1', fmt_hexfloat(0.1_dp) == '0x1.999999999999ap-4')
  call check('known_minus_2.5', fmt_hexfloat(-2.5_dp) == '-0x1.4000000000000p+1')
  call check('known_c', fmt_hexfloat(C_LIGHT) == '0x1.1de784a000000p+28', fmt_hexfloat(C_LIGHT))
  call check('known_neg_zero', fmt_hexfloat(-0.0_dp) == '-0x0.0000000000000p+0')
  call check('known_min_subnormal', fmt_hexfloat(transfer(1_int64, 1.0_dp)) == '0x0.0000000000001p-1022')
  call parse_hexfloat('0x1.0p+0', y, ok);                  call check('reject_short_mantissa', .not. ok)
  call parse_hexfloat('0x2.0000000000000p+0', y, ok);      call check('reject_bad_lead', .not. ok)
  call parse_hexfloat('0x1.0000000000000p+01', y, ok);     call check('reject_leading_zero_exp', .not. ok)
  call parse_hexfloat('0x1.0000000000000p+1024', y, ok);   call check('reject_exp_overflow', .not. ok)
  call parse_hexfloat('0x0.0000000000000p-1022', y, ok);   call check('reject_noncanonical_zero', .not. ok)
  call parse_hexfloat('0x1.000000000000Ap+0', y, ok);      call check('reject_uppercase_hex', .not. ok)
  call parse_hexfloat('1.5', y, ok);                       call check('reject_decimal', .not. ok)

  call set_suite('fortran.sha256')
  call check('empty', sha256_hex('') == 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855')
  call check('abc', sha256_hex('abc') == 'ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad')
  call check('448bit', sha256_hex('abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq') == &
             '248d6a61d20638b8e5c026930c3e6039a33ce45964ff2167f6ecedd419db06c1')
  call check('896bit', sha256_hex('abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmn' // &
             'hijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu') == &
             'cf5b16a778af8380036ce59e7b0492370b249b11e8f07a51afac45037afee9d1')

  call set_suite('fortran.lrdrec')
  call ensure_dir('out')
  call rec_init(r)
  call rec_set(r, 'b', '2', ok)
  call rec_set(r, 'aa', 'x', ok)
  call rec_set(r, 'a', '1', ok)
  call rec_set(r, 'a', 'dup', ok)
  call check('duplicate_key_refused', .not. ok .and. r%n == 3)
  call rec_set(r, '', 'v', ok)
  call check('empty_key_refused_on_write', .not. ok .and. r%n == 3)
  call rec_set(r, 'Upper', 'v', ok)
  call check('invalid_key_refused', .not. ok)
  call rec_set(r, 'nl', 'a' // achar(10) // 'b', ok)
  call check('newline_value_refused', .not. ok)
  call rec_serialize(r, buf)
  call check('canonical_bytes_sorted', buf == 'LRD-REC-v1' // achar(10) // '1:a1:1' // achar(10) // &
             '2:aa1:x' // achar(10) // '1:b1:2' // achar(10))
  call check('commitment_domain_separated', rec_commitment(buf) == &
             sha256_hex('LRD-COMMIT-v1' // achar(0) // buf) .and. rec_commitment(buf) /= sha256_hex(buf))
  call write_bytes('out/SYNTHETIC_lrdrec_small.lrdrec', buf, ok)
  call write_bytes('out/SYNTHETIC_lrdrec_small.lrdrec.commit', rec_commitment(buf) // achar(10), ok)
  call check('small_record_written', ok)
  call rec_parse(buf, r, ok, err)
  call check('parse_canonical', ok .and. r%n == 3)
  call rec_parse('LRD-REC-v2' // achar(10), r, ok, err);                 call check('reject_bad_header', .not. ok)
  call rec_parse('LRD-REC-v1' // achar(10) // '1:b1:2' // achar(10) // '1:a1:1' // achar(10), r, ok, err)
  call check('reject_unsorted', .not. ok .and. err(1:9) == 'unsorted_')
  call rec_parse('LRD-REC-v1' // achar(10) // '1:a1:1' // achar(10) // '1:a1:2' // achar(10), r, ok, err)
  call check('reject_duplicate', .not. ok)
  call rec_parse('LRD-REC-v1' // achar(10) // '0:1:x' // achar(10), r, ok, err)
  call check('reject_empty_key_on_parse', .not. ok .and. err(1:7) == 'bad_key')
  call rec_parse('LRD-REC-v1' // achar(10) // '01:a1:1' // achar(10), r, ok, err)
  call check('reject_leading_zero_length', .not. ok)
  call rec_parse('LRD-REC-v1' // achar(10) // '1:a3:1' // achar(10), r, ok, err)
  call check('reject_truncated', .not. ok)
  call rec_parse('LRD-REC-v1' // achar(10) // '1:a1:1' // achar(10) // 'x', r, ok, err)
  call check('reject_trailing_junk', .not. ok)
  call rec_parse('LRD-REC-v1' // achar(10) // '1:a1:1', r, ok, err)
  call check('reject_missing_final_newline', .not. ok)

  call set_suite('fortran.serial')
  call build_fixture(g, codes, ok)
  call graph_serialize(g, buf, ok)
  call check('fixture_serializes', ok)
  call graph_parse(buf, g2, ok, err)
  call check('fixture_parses', ok, 'err=' // err)
  call graph_serialize(g2, buf2, ok)
  call check('roundtrip_byte_identical', ok .and. buf2 == buf .and. len(buf2) == len(buf))
  c1 = rec_commitment(buf)
  c2 = rec_commitment(buf2)
  call check('roundtrip_commitment_equal', c1 == c2)
  all_ok = g2%n_ev == g%n_ev
  do i = 1, min(g%n_ev, g2%n_ev)
    all_ok = all_ok .and. g2%ev(i)%id == g%ev(i)%id .and. g2%ev(i)%kind == g%ev(i)%kind .and. &
             same_iv(g2%ev(i)%c%t, g%ev(i)%c%t) .and. same_iv(g2%ev(i)%c%x(1), g%ev(i)%c%x(1)) .and. &
             same_iv(g2%ev(i)%c%x(2), g%ev(i)%c%x(2)) .and. same_iv(g2%ev(i)%c%x(3), g%ev(i)%c%x(3)) .and. &
             g2%ev(i)%c%frame_id == g%ev(i)%c%frame_id .and. (g2%ev(i)%c%has_z .eqv. g%ev(i)%c%has_z) .and. &
             same_iv(g2%ev(i)%c%z, g%ev(i)%c%z) .and. g2%ev(i)%label == g%ev(i)%label
  end do
  call check('roundtrip_event_values_bit_exact', all_ok)
  call check('roundtrip_edges_and_log', cg_n_edges(g2) == cg_n_edges(g) .and. g2%n_rej == g%n_rej .and. &
             all(g2%rcode(1:g2%n_rej) == g%rcode(1:g%n_rej)) .and. g2%synthetic)
  call cg_ancestors(g, 4, out1, k1)
  call cg_ancestors(g2, 4, out2, k2)
  call check('roundtrip_queries_equal', k1 == k2 .and. all(out1(1:k1) == out2(1:k2)))

  ! tamper 1: forge an accepted edge 1 -> 5 (spacelike)
  call graph_to_record(g, r, ok)
  call set_field(r, 'n_edges', '7')
  call rec_set(r, 'edge.000007.src', '1', ok)
  call rec_set(r, 'edge.000007.dst', '5', ok)
  call rec_set(r, 'edge.000007.sep', 'timelike', ok)
  call rec_set(r, 'edge.000007.dir', 'future', ok)
  call rec_set(r, 'edge.000007.s2_m2_lo', '-0x1.0000000000000p+0', ok)
  call rec_set(r, 'edge.000007.s2_m2_hi', '-0x1.0000000000000p+0', ok)
  call rec_serialize(r, buf2)
  call graph_parse(buf2, g2, ok, err)
  call check('tamper_forged_spacelike_edge_rejected', .not. ok .and. index(err, 'edge_revalidation_failed') == 1, &
             'err=' // err)
  ! tamper 2: falsify a derived pair classification
  call graph_to_record(g, r, ok)
  call set_field(r, 'pair.000001.000005', 'timelike/future')
  call rec_serialize(r, buf2)
  call graph_parse(buf2, g2, ok, err)
  call check('tamper_pair_class_rejected', .not. ok .and. err == 'not_canonical', 'err=' // err)
  ! tamper 3: move event 2 off the light cone of event 1 (edge 1->2 must fail)
  call graph_to_record(g, r, ok)
  call rec_get(r, 'event.000002.t_s_lo', v, ok)
  call set_field(r, 'event.000002.t_s_lo', fmt_hexfloat(9.0_dp))
  call set_field(r, 'event.000002.t_s_hi', fmt_hexfloat(9.0_dp))
  call rec_serialize(r, buf2)
  call graph_parse(buf2, g2, ok, err)
  call check('tamper_moved_event_breaks_edge', .not. ok .and. index(err, 'edge_revalidation_failed') == 1, &
             'err=' // err)
  k = 0
  call finish('test_serial')

contains

  pure logical function same_iv(a, b)
    type(interval), intent(in) :: a, b
    same_iv = transfer(a%lo, 0_int64) == transfer(b%lo, 0_int64) .and. &
              transfer(a%hi, 0_int64) == transfer(b%hi, 0_int64)
  end function same_iv

  subroutine set_field(rr, key, val)
    type(lrd_record), intent(inout) :: rr
    character(len=*), intent(in) :: key, val
    integer :: j
    do j = 1, rr%n
      if (rr%k(j)%s == key) rr%v(j)%s = val
    end do
  end subroutine set_field

end program test_serial
