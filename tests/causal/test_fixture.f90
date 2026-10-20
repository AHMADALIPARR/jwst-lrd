! Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
! Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
! SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
!
! Writes the SYNTHETIC causal fixture for the Curry and Self consumers:
!   out/SYNTHETIC_causal_fixture.lrdrec         (LRD-REC-v1, LRD-CAUSAL-GRAPH-v1)
!   out/SYNTHETIC_causal_fixture.lrdrec.commit  (commitment hex + LF)
! then reloads it from disk and checks commitment and canonical round trip.
program test_fixture
  use causal_graph
  use causal_serial
  use fixture_graph
  use test_util
  implicit none
  type(causal_graph_t) :: g, g2
  integer :: codes(N_PROPOSALS)
  logical :: ok
  character(len=64) :: c1, c2
  character(len=:), allocatable :: err
  character(len=*), parameter :: path = 'out/SYNTHETIC_causal_fixture.lrdrec'

  call set_suite('fortran.fixture_file')
  call build_fixture(g, codes, ok)
  call check('built', ok .and. all(codes == EXPECTED_CODES))
  call graph_save(g, path, c1, ok)
  call check('saved', ok)
  call graph_load(path, g2, ok, err, c2)
  call check('reloaded_canonical', ok, 'err=' // err)
  call check('reloaded_commitment_equal', c1 == c2)
  write (*, '(A)') '# fixture ' // path // ' commitment ' // c1
  call finish('test_fixture')
end program test_fixture
