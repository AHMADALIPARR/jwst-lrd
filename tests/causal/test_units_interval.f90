! Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
! Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
! SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
!
! Units, dimension checks and interval arithmetic (analytic expectations).
program test_units_interval
  use causal_units
  use causal_interval
  use causal_coords
  use test_util
  implicit none
  real(dp) :: v
  logical :: ok
  type(quantity) :: r
  type(interval) :: a, b, s
  type(stcoord) :: c
  type(quantity) :: zero_t, xs(3), xu(3)

  call set_suite('fortran.units')
  call check('c_exact', eq_bits(C_LIGHT, 299792458.0_dp) .and. int(C_LIGHT) == 299792458)
  call to_si(q(1.0_dp, U_LS), DIM_LENGTH, v, ok)
  call check('light_second_is_c_metres', ok .and. eq_bits(v, 299792458.0_dp))
  call to_si(q(2.5_dp, U_KM), DIM_LENGTH, v, ok)
  call check('km_to_m', ok .and. eq_bits(v, 2500.0_dp))
  call to_si(q(1.0_dp, U_AU), DIM_LENGTH, v, ok)
  call check('au_iau2012_exact', ok .and. eq_bits(v, 149597870700.0_dp))
  call to_si(q(2.0_dp, U_DAY), DIM_TIME, v, ok)
  call check('day_to_s', ok .and. eq_bits(v, 172800.0_dp))
  call to_si(q(1.0_dp, U_S), DIM_LENGTH, v, ok)
  call check('time_refused_as_length', .not. ok)
  call to_si(q(7.0_dp, U_REDSHIFT), DIM_LENGTH, v, ok)
  call check('redshift_refused_as_length', .not. ok)
  call to_si(q(7.0_dp, U_REDSHIFT), DIM_TIME, v, ok)
  call check('redshift_refused_as_time', .not. ok)
  call convert_unit(q(7.0_dp, U_REDSHIFT), U_M, r, ok)
  call check('redshift_no_conversion_to_m', .not. ok)
  call convert_unit(q(3000.0_dp, U_M), U_KM, r, ok)
  call check('m_to_km', ok .and. eq_bits(r%v, 3.0_dp) .and. r%unit == U_KM)
  call check('unit_name_roundtrip', unit_from_name(unit_name(U_AU)) == U_AU .and. &
             unit_from_name('furlong') == U_INVALID)

  ! a coordinate cannot be built from a redshift posing as a position
  zero_t = q(0.0_dp, U_S)
  xs = [q(7.0_dp, U_REDSHIFT), q(0.0_dp, U_M), q(0.0_dp, U_M)]
  xu = [q(0.0_dp, U_M), q(0.0_dp, U_M), q(0.0_dp, U_M)]
  call make_coord(1, zero_t, zero_t, xs, xu, c, ok)
  call check('coord_refuses_redshift_position', .not. ok)
  xs = [q(1.0_dp, U_LS), q(2.0_dp, U_KM), q(0.0_dp, U_AU)]
  call make_coord(1, q(3.0_dp, U_DAY), q(1.0_dp, U_S), xs, xu, c, ok)
  call check('coord_units_converted', ok .and. eq_bits(c%x(1)%lo, C_LIGHT) .and. eq_bits(c%x(2)%hi, 2000.0_dp) &
             .and. iv_contains(c%t, 259200.0_dp) .and. c%t%lo < 259199.0_dp + 1.0e-6_dp)
  call make_coord(1, q(3.0_dp, U_S), q(-1.0_dp, U_S), xs, xu, c, ok)
  call check('coord_refuses_negative_uncertainty', .not. ok)

  call set_suite('fortran.interval')
  a = iv_make(-2.0_dp, 3.0_dp)
  s = iv_sqr(a)
  call check('sqr_straddling_zero', eq_bits(s%lo, 0.0_dp) .and. iv_contains(s, 9.0_dp) .and. s%hi < 9.0_dp + 1.0e-12_dp)
  s = iv_sqr(iv_make(-3.0_dp, -2.0_dp))
  call check('sqr_negative', iv_contains(s, 4.0_dp) .and. iv_contains(s, 9.0_dp) .and. s%lo > 3.99_dp)
  b = iv_make(1.0_dp, 2.0_dp)
  s = a + b
  call check('add_encloses', iv_contains(s, -1.0_dp) .and. iv_contains(s, 5.0_dp))
  s = a - b
  call check('sub_encloses', iv_contains(s, -4.0_dp) .and. iv_contains(s, 2.0_dp) .and. &
             .not. iv_contains(s, 2.1_dp))
  s = iv_mul(a, b)
  call check('mul_encloses', iv_contains(s, -4.0_dp) .and. iv_contains(s, 6.0_dp))
  s = iv_scale(b, -2.0_dp)
  call check('scale_negative_flips', iv_contains(s, -4.0_dp) .and. iv_contains(s, -2.0_dp) .and. s%hi < 0.0_dp)
  s = iv_point(0.1_dp) + iv_point(0.2_dp)
  call check('outward_rounding_encloses_exact_sum', s%lo < s%hi .and. s%lo <= 0.3_dp .and. 0.3_dp <= s%hi)
  call check('inverted_interval_invalid', .not. iv_valid(iv_make(1.0_dp, 0.0_dp)))
  s = iv_point(1.0_dp) + iv_point(2.0_dp)
  call check('exact_sum_not_widened', eq_bits(s%lo, 3.0_dp) .and. eq_bits(s%hi, 3.0_dp))
  s = iv_point(5.0_dp) - iv_point(5.0_dp)
  call check('exact_difference_zero_not_widened', eq_bits(s%lo, 0.0_dp) .and. eq_bits(s%hi, 0.0_dp))
  s = iv_sqr(iv_point(3.0_dp))
  call check('exact_square_not_widened', eq_bits(s%lo, 9.0_dp) .and. eq_bits(s%hi, 9.0_dp))
  s = iv_scale(iv_point(0.1_dp), 3.0_dp)
  call check('inexact_product_widened_one_side', s%lo < s%hi .and. (eq_bits(s%lo, 0.1_dp * 3.0_dp) .or. &
             eq_bits(s%hi, 0.1_dp * 3.0_dp)))
  call finish('test_units_interval')
end program test_units_interval
