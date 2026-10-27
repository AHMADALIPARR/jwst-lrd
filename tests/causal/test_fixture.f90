! Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
! Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
! SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
!
! Writes the SYNTHETIC causal fixture for the Curry and Self consumers:
!   out/SYNTHETIC_causal_fixture.lrdrec         (LRD-REC-v1, LRD-CAUSAL-GRAPH-v1)
!   out/SYNTHETIC_causal_fixture.lrdrec.commit  (commitment hex + LF)
! then reloads it from disk and checks commitment and canonical round trip, and that
! graph_load refuses a missing, malformed, all-zero or mismatched .commit sidecar, each
! with its own error text.  The negative cases write their own copies under out/neg_*.
program test_fixture
  use causal_graph
  use causal_serial
  use causal_lrdrec, only: read_bytes, write_bytes
  use fixture_graph
  use test_util
  implicit none

  type(causal_graph_t) :: g, g2
  integer :: codes(N_PROPOSALS)
  logical :: ok
  character(len=64) :: c1, c2
  character(len=:), allocatable :: err, buf, bad
  character(len=*), parameter :: path = 'out/SYNTHETIC_causal_fixture.lrdrec'
  character(len=*), parameter :: npath = 'out/neg_fixture.lrdrec'

  call set_suite('fortran.fixture_file')
  call ensure_dir('out')
  call build_fixture(g, codes, ok)
  call check('built', ok .and. all(codes == EXPECTED_CODES))
  call graph_save(g, path, c1, ok)
  call check('saved', ok)
  call graph_load(path, g2, ok, err, c2)
  call check('reloaded_canonical', ok, 'err=' // err)
  call check('reloaded_commitment_equal', c1 == c2)
  write (*, '(A)') '# fixture ' // path // ' commitment ' // c1

  ! ---- sidecar verification (review L2) ------------------------------------------------
  call read_bytes(path, buf, ok)
  call check('neg_setup_read_fixture', ok)
  ! copy without any sidecar: use a name nothing ever writes a sidecar for
  call write_bytes('out/neg_nosidecar.lrdrec', buf, ok)
  call graph_load('out/neg_nosidecar.lrdrec', g2, ok, err, c2)
  call check('sidecar_missing_refused', (.not. ok) .and. err == 'commit_sidecar_missing' .and. c2 == c1)
  call write_bytes(npath, buf, ok)
  ! all-zero sidecar
  call write_bytes(npath // '.commit', repeat('0', 64) // achar(10), ok)
  call graph_load(npath, g2, ok, err, c2)
  call check('sidecar_all_zero_refused', (.not. ok) .and. err == 'commit_sidecar_zero')
  ! mismatched sidecar (last hex digit changed)
  bad = c1
  if (bad(64:64) == '0') then
    bad(64:64) = '1'
  else
    bad(64:64) = '0'
  end if
  call write_bytes(npath // '.commit', bad // achar(10), ok)
  call graph_load(npath, g2, ok, err, c2)
  call check('sidecar_mismatch_refused', (.not. ok) .and. err == 'commit_mismatch')
  ! sidecar of a different record (a valid commitment, wrong file)
  call write_bytes(npath // '.commit', 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855' // achar(10), ok)
  call graph_load(npath, g2, ok, err, c2)
  call check('sidecar_other_digest_refused', (.not. ok) .and. err == 'commit_mismatch')
  ! malformed sidecars
  call write_bytes(npath // '.commit', c1(1:63) // achar(10), ok)
  call graph_load(npath, g2, ok, err, c2)
  call check('sidecar_short_refused', (.not. ok) .and. err == 'commit_sidecar_malformed')
  call write_bytes(npath // '.commit', '', ok)
  call graph_load(npath, g2, ok, err, c2)
  call check('sidecar_empty_refused', (.not. ok) .and. err == 'commit_sidecar_malformed')
  bad = c1
  bad(1:1) = 'G'
  call write_bytes(npath // '.commit', bad // achar(10), ok)
  call graph_load(npath, g2, ok, err, c2)
  call check('sidecar_non_hex_refused', (.not. ok) .and. err == 'commit_sidecar_malformed')
  call write_bytes(npath // '.commit', c1 // achar(13) // achar(10), ok)
  call graph_load(npath, g2, ok, err, c2)
  call check('sidecar_crlf_refused', (.not. ok) .and. err == 'commit_sidecar_malformed')
  ! tampered record with the ORIGINAL sidecar: refused by the commitment, not by the parser
  bad = buf
  bad(len(bad):len(bad)) = 'X'
  call write_bytes(npath, bad, ok)
  call write_bytes(npath // '.commit', c1 // achar(10), ok)
  call graph_load(npath, g2, ok, err, c2)
  call check('tampered_record_with_old_sidecar_refused', (.not. ok) .and. err == 'commit_mismatch' .and. c2 /= c1)
  ! positives: the correct sidecar with and without its trailing LF
  call write_bytes(npath, buf, ok)
  call write_bytes(npath // '.commit', c1 // achar(10), ok)
  call graph_load(npath, g2, ok, err, c2)
  call check('sidecar_correct_with_lf_accepted', ok .and. c2 == c1)
  call write_bytes(npath // '.commit', c1, ok)
  call graph_load(npath, g2, ok, err, c2)
  call check('sidecar_correct_without_lf_accepted', ok .and. c2 == c1)
  ! a missing record is still read_failed
  call graph_load('out/neg_does_not_exist.lrdrec', g2, ok, err, c2)
  call check('record_missing_read_failed', (.not. ok) .and. err == 'read_failed')
  call finish('test_fixture')
end program test_fixture
