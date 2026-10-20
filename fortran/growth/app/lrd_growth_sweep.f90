! SPDX-License-Identifier: AGPL-3.0-only
! Also subject to SNAPKITTY_OPAQUE_LICENSE.md (dual license, see repository root).
!
! lrd_growth_sweep: QSO1 growth-constraint driver (Mission QSO1-DCBH-001, role 04).
!
! Modes:
!   benchmark           the directive's analytical benchmark tuple, printed as
!                       key=value lines for the test suite to check.
!   sweep <csv> <rec>   the full parameter grid; writes a CSV dataset and an
!                       LRD-REC-v1 record (format LRD-GROWTH-v1) plus its
!                       commitment file <rec>.commit.
!
! Fixed inputs ( declared, not fitted ):
!   z_obs    = 7.04221       this repo's measured redshift (fortran kernel,
!                            fortran/STATUS.md), the directive's benchmark value.
!   m_target = 5.0e7 Msun    Juodzbalis et al. 2026 dynamical mass, "~50 million
!                            solar masses" (research/CITATIONS.md). The retrieved
!                            text carries NO published uncertainty, so no error
!                            bar is invented here; seed masses scale exactly
!                            linearly with m_target (see STATUS.md).
!   cosmology: Planck 2018 (H0=67.36, Om=0.3153, Ol=0.6847), as in the kernel.
program lrd_growth_sweep
  use lrd_const
  use lrd_cosmo, only: age_gyr
  use lrd_growth
  use causal_lrdrec
  implicit none

  real(dp), parameter :: h0 = 67.36_dp, om = 0.3153_dp, ol = 0.6847_dp
  real(dp), parameter :: z_obs = 7.04221_dp
  real(dp), parameter :: m_target = 5.0e7_dp
  real(dp), parameter :: seed_range_lo = 10.0_dp, seed_range_hi = 1.0e5_dp
  integer, parameter :: nstep = 200

  character(len=64) :: mode
  integer :: nargs

  nargs = command_argument_count()
  if (nargs < 1) then
    write (*, '(A)') 'usage: lrd_growth_sweep benchmark | sweep <csv> <rec>'
    stop 1
  end if
  call get_command_argument(1, mode)
  select case (trim(mode))
  case ('benchmark')
    call do_benchmark()
  case ('selfcheck')
    call do_selfcheck()
  case ('sweep')
    call do_sweep()
  case default
    write (*, '(A)') 'unknown mode: ' // trim(mode)
    stop 1
  end select

contains

  subroutine do_benchmark()
    real(dp) :: z_form, eps, lam, duty, dt, g, smin, lam_req, t1, t2
    z_form = 20.0_dp; eps = 0.1_dp; lam = 1.0_dp; duty = 1.0_dp
    t1 = age_gyr(z_obs, h0, om, ol)
    t2 = age_gyr(z_form, h0, om, ol)
    dt = t1 - t2
    g = growth_factor(z_form, z_obs, eps, lam, duty, MODE_SIMPLE, h0, om, ol, nstep)
    smin = min_seed_mass(m_target, g)
    lam_req = required_lambda(m_target, 100.0_dp, eps, z_form, z_obs, duty, h0, om, ol)
    write (*, '(A,ES24.16E3)') 't_edd_myr=', eddington_time_gyr() * 1.0e3_dp
    write (*, '(A,ES24.16E3)') 'age_obs_gyr=', t1
    write (*, '(A,ES24.16E3)') 'age_form_gyr=', t2
    write (*, '(A,ES24.16E3)') 'dt_myr=', dt * 1.0e3_dp
    write (*, '(A,ES24.16E3)') 'growth_factor=', g
    write (*, '(A,ES24.16E3)') 'min_seed_msun=', smin
    write (*, '(A,ES24.16E3)') 'required_lambda_seed100=', lam_req
    write (*, '(A,ES24.16E3)') 'mdot_edd_benchmark=', mdot_edd(lam, eps)
  end subroutine do_benchmark

  subroutine do_selfcheck()
    ! Cross-checks printed as key=value for the test suite:
    !  rk4_rel_diff:    RK4 integration of dM/dt vs the stepped growth factor,
    !                   relative difference at the benchmark tuple.
    !  step_rel_diff:   growth factor at nstep=50 vs nstep=800 (convergence).
    !  sat_rel_diff:    saturated vs simple growth factor at lam=3 (must be < 0:
    !                   saturation grows strictly slower when lam > 1).
    !  sub_rel_diff:    saturated vs simple at lam=0.5 (must be 0: identical
    !                   at or below Eddington).
    real(dp) :: g200, g50, g800, m_rk4, g_sat, g_sim, g_sat_sub, g_sim_sub
    g200 = growth_factor(20.0_dp, z_obs, 0.1_dp, 1.0_dp, 1.0_dp, MODE_SIMPLE, &
                         h0, om, ol, 200)
    m_rk4 = grow_mass_rk4(1.0_dp, 20.0_dp, z_obs, 0.1_dp, 1.0_dp, 1.0_dp, &
                          MODE_SIMPLE, h0, om, ol, 2000)
    g50 = growth_factor(20.0_dp, z_obs, 0.1_dp, 1.0_dp, 1.0_dp, MODE_SIMPLE, &
                        h0, om, ol, 50)
    g800 = growth_factor(20.0_dp, z_obs, 0.1_dp, 1.0_dp, 1.0_dp, MODE_SIMPLE, &
                         h0, om, ol, 800)
    g_sim = growth_factor(20.0_dp, z_obs, 0.1_dp, 3.0_dp, 1.0_dp, MODE_SIMPLE, &
                          h0, om, ol, 200)
    g_sat = growth_factor(20.0_dp, z_obs, 0.1_dp, 3.0_dp, 1.0_dp, MODE_SATURATED, &
                          h0, om, ol, 200)
    g_sim_sub = growth_factor(20.0_dp, z_obs, 0.1_dp, 0.5_dp, 1.0_dp, MODE_SIMPLE, &
                              h0, om, ol, 200)
    g_sat_sub = growth_factor(20.0_dp, z_obs, 0.1_dp, 0.5_dp, 1.0_dp, &
                              MODE_SATURATED, h0, om, ol, 200)
    write (*, '(A,ES24.16E3)') 'rk4_rel_diff=', abs(m_rk4 - g200) / g200
    write (*, '(A,ES24.16E3)') 'step_rel_diff=', abs(g800 - g50) / g800
    write (*, '(A,ES24.16E3)') 'sat_ratio_lam3=', g_sat / g_sim
    write (*, '(A,ES24.16E3)') 'sat_ratio_lam05=', g_sat_sub / g_sim_sub
  end subroutine do_selfcheck

  subroutine do_sweep()
    character(len=256) :: csv_path, rec_path
    real(dp) :: lams(8), epss(6), zfs(5), duties(5)
    integer :: il, ie, iz, id, row, u, ios
    real(dp) :: dt, g_s, g_t, s_s, s_t
    type(lrd_record) :: r
    character(len=:), allocatable :: buf
    character(len=64) :: commit
    logical :: ok

    if (command_argument_count() < 3) then
      write (*, '(A)') 'usage: lrd_growth_sweep sweep <csv> <rec>'
      stop 1
    end if
    call get_command_argument(2, csv_path)
    call get_command_argument(3, rec_path)

    lams = [0.5_dp, 0.75_dp, 1.0_dp, 1.5_dp, 2.0_dp, 2.5_dp, 3.0_dp, 5.0_dp]
    epss = [0.05_dp, 0.10_dp, 0.15_dp, 0.20_dp, 0.25_dp, 0.30_dp]
    zfs = [12.0_dp, 15.0_dp, 20.0_dp, 25.0_dp, 30.0_dp]
    duties = [0.1_dp, 0.25_dp, 0.5_dp, 0.75_dp, 1.0_dp]

    call rec_init(r)
    call set_field(r, 'format', 'LRD-GROWTH-v1')
    call set_field(r, 'z_obs', fmt_real(z_obs))
    call set_field(r, 'm_target_msun', fmt_real(m_target))
    call set_field(r, 't_edd_myr', fmt_real(eddington_time_gyr() * 1.0e3_dp))
    call set_field(r, 'h0', fmt_real(h0))
    call set_field(r, 'om', fmt_real(om))
    call set_field(r, 'ol', fmt_real(ol))
    call set_field(r, 'seed_range_lo_msun', fmt_real(seed_range_lo))
    call set_field(r, 'seed_range_hi_msun', fmt_real(seed_range_hi))

    open (newunit=u, file=trim(csv_path), status='replace', action='write', iostat=ios)
    if (ios /= 0) then
      write (*, '(A)') 'cannot open csv: ' // trim(csv_path)
      stop 1
    end if
    write (u, '(A)') 'lam,eps,z_form,duty,dt_myr,mdot_edd,growth_simple,' // &
                     'growth_saturated,min_seed_simple_msun,min_seed_saturated_msun,' // &
                     'feasible_simple,feasible_saturated'

    row = 0
    do il = 1, size(lams)
      do ie = 1, size(epss)
        do iz = 1, size(zfs)
          do id = 1, size(duties)
            row = row + 1
            dt = age_gyr(z_obs, h0, om, ol) - age_gyr(zfs(iz), h0, om, ol)
            g_s = growth_factor(zfs(iz), z_obs, epss(ie), lams(il), duties(id), &
                                MODE_SIMPLE, h0, om, ol, nstep)
            g_t = growth_factor(zfs(iz), z_obs, epss(ie), lams(il), duties(id), &
                                MODE_SATURATED, h0, om, ol, nstep)
            s_s = min_seed_mass(m_target, g_s)
            s_t = min_seed_mass(m_target, g_t)
            write (u, '(ES16.8E3,",",ES16.8E3,",",ES16.8E3,",",ES16.8E3,",",ES16.8E3,",",' // &
                      'ES16.8E3,",",ES16.8E3,",",ES16.8E3,",",ES16.8E3,",",ES16.8E3,",",I1,",",I1)') &
              lams(il), epss(ie), zfs(iz), duties(id), dt * 1.0e3_dp, &
              mdot_edd(lams(il), epss(ie)), g_s, g_t, s_s, s_t, &
              merge(1, 0, s_s <= seed_range_hi), merge(1, 0, s_t <= seed_range_hi)
            call set_row(r, row, 'lam', fmt_real(lams(il)))
            call set_row(r, row, 'eps', fmt_real(epss(ie)))
            call set_row(r, row, 'zform', fmt_real(zfs(iz)))
            call set_row(r, row, 'duty', fmt_real(duties(id)))
            call set_row(r, row, 'dt_myr', fmt_real(dt * 1.0e3_dp))
            call set_row(r, row, 'mdot', fmt_real(mdot_edd(lams(il), epss(ie))))
            call set_row(r, row, 'seed_simple', fmt_real(s_s))
            call set_row(r, row, 'seed_sat', fmt_real(s_t))
            call set_row(r, row, 'feas_simple', trim(itoa(merge(1, 0, s_s <= seed_range_hi))))
            call set_row(r, row, 'feas_sat', trim(itoa(merge(1, 0, s_t <= seed_range_hi))))
          end do
        end do
      end do
    end do
    close (u)

    call set_field(r, 'n_rows', trim(itoa(row)))
    call rec_serialize(r, buf)
    commit = rec_commitment(buf)
    call write_bytes(trim(rec_path), buf, ok)
    if (.not. ok) then
      write (*, '(A)') 'cannot write rec: ' // trim(rec_path)
      stop 1
    end if
    open (newunit=u, file=trim(rec_path) // '.commit', status='replace', action='write')
    write (u, '(A)') commit
    close (u)
    write (*, '(A,I0)') 'rows=', row
    write (*, '(A,A)') 'commit=', commit
  end subroutine do_sweep

  subroutine set_field(r, key, val)
    type(lrd_record), intent(inout) :: r
    character(len=*), intent(in) :: key, val
    logical :: ok
    call rec_set(r, key, val, ok)
    if (.not. ok) then
      write (*, '(A)') 'rec_set failed: ' // key
      stop 1
    end if
  end subroutine set_field

  subroutine set_row(r, row, field, val)
    type(lrd_record), intent(inout) :: r
    integer, intent(in) :: row
    character(len=*), intent(in) :: field, val
    character(len=16) :: rn
    write (rn, '(I6.6)') row
    call set_field(r, 'row.' // trim(rn) // '.' // field, val)
  end subroutine set_row

  pure function fmt_real(x) result(s)
    real(dp), intent(in) :: x
    character(len=:), allocatable :: s
    character(len=32) :: b
    write (b, '(ES24.16E3)') x
    s = trim(b)
  end function fmt_real

end program lrd_growth_sweep
