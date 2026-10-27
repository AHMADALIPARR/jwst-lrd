! Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
! Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
! SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
!
! test_util: one output line per check, in the tests/causal/run.sh convention:
!   PASS <name>  |  FAIL <name> <why>
! finish() prints a '#' summary line and stops with code 1 if any check failed.
module test_util
  use, intrinsic :: iso_fortran_env, only: real64, int64
  implicit none
  private
  integer, public :: n_pass = 0, n_fail = 0
  character(len=64), public :: suite = 'fortran'
  public :: check, finish, set_suite, eq_bits, ensure_dir
contains
  ! Exact equality via bit patterns (intentional exactness checks; avoids
  ! -Wcompare-reals noise while stating the intent).
  pure logical function eq_bits(a, b)
    real(real64), intent(in) :: a, b
    eq_bits = transfer(a, 0_int64) == transfer(b, 0_int64)
  end function eq_bits

  subroutine set_suite(s)
    character(len=*), intent(in) :: s
    suite = s
  end subroutine set_suite

  subroutine check(name, cond, why)
    character(len=*), intent(in) :: name
    logical, intent(in) :: cond
    character(len=*), intent(in), optional :: why
    if (cond) then
      n_pass = n_pass + 1
      write (*, '(A)') 'PASS ' // trim(suite) // '.' // name
    else
      n_fail = n_fail + 1
      if (present(why)) then
        write (*, '(A)') 'FAIL ' // trim(suite) // '.' // name // ' ' // why
      else
        write (*, '(A)') 'FAIL ' // trim(suite) // '.' // name // ' assertion_false'
      end if
    end if
  end subroutine check

  ! Creates a directory (mkdir -p) so a test never depends on an untracked out/ directory.
  ! Silent on success; on failure it emits FAIL <suite>.out_dir_unavailable with the reason.
  subroutine ensure_dir(dir)
    character(len=*), intent(in) :: dir
    integer :: es, cs
    es = 0
    cs = 0
    call execute_command_line('mkdir -p ' // dir, wait=.true., exitstat=es, cmdstat=cs)
    if (cs /= 0 .or. es /= 0) call check('out_dir_unavailable', .false., 'out_dir_missing_and_mkdir_failed:' // dir)
  end subroutine ensure_dir

  subroutine finish(prog)
    character(len=*), intent(in) :: prog
    character(len=16) :: a, b
    write (a, '(I0)') n_pass
    write (b, '(I0)') n_fail
    write (*, '(A)') '# ' // prog // ': ' // trim(a) // ' passed, ' // trim(b) // ' failed'
    if (n_fail > 0) error stop 1
  end subroutine finish
end module test_util
