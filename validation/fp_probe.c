/* SPDX-License-Identifier: AGPL-3.0-only
 * Also licensed under the SnapKitty Opaque License; see LICENSE and
 * SNAPKITTY_OPAQUE_LICENSE.md at the repository root.
 * Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 *
 * fp_probe: checks the FP environment assumed by validation/FP_POLICY.md when
 * built with the policy flags: binary64 (53-bit mantissa), FLT_EVAL_METHOD 0
 * (no extended-precision intermediates), round-to-nearest-even active, and a
 * round-to-nearest-even tie case. Prints "ok" or the first violation; exit 0/1.
 */
#include <fenv.h>
#include <float.h>
#include <stdio.h>

int main(void) {
  volatile double one = 1.0, tie = 0x1p-53, tie3 = 0x1.8p-52;
  if (DBL_MANT_DIG != 53) { printf("DBL_MANT_DIG=%d\n", DBL_MANT_DIG); return 1; }
  if (FLT_EVAL_METHOD != 0) { printf("FLT_EVAL_METHOD=%d\n", (int)FLT_EVAL_METHOD); return 1; }
  if (fegetround() != FE_TONEAREST) { printf("rounding mode is not FE_TONEAREST\n"); return 1; }
  /* 1 + 2^-53 is a tie between 1 and 1+2^-52: ties-to-even gives 1. */
  if (one + tie != 1.0) { printf("tie 1+2^-53 not rounded to even\n"); return 1; }
  /* 1 + 1.5*2^-52 is a tie between 1+2^-52 and 1+2^-51: even is 1+2^-51. */
  if (one + tie3 != 1.0 + 0x1p-51) { printf("tie 1+1.5*2^-52 not rounded to even\n"); return 1; }
  printf("ok\n");
  return 0;
}
