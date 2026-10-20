(* Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
   Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
   SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque

   THEOREMS -- AIR Goldilocks field (air/include/air/field.h).

   Each theorem is labelled; the label is the join key used by the
   Liquid Haskell refinement layer (haskell/theorems/) and by
   theorems/README.md. The Coq definitions below model the C code
   line by line over Z, with uint64 wraparound written as (mod 2^64).
   The C contract (field.h header comment) is that field elements are
   kept canonical, i.e. in [0, p); the theorems quantify over
   canonical inputs, matching that contract.

   p = 2^64 - 2^32 + 1 (Goldilocks), EPS = 2^32 - 1 = 2^64 mod p. *)

Require Import ZArith Lia.
Open Scope Z_scope.

Definition M   : Z := 2^64.            (* uint64 modulus *)
Definition P   : Z := 2^64 - 2^32 + 1. (* FP_P *)
Definition EPS : Z := 2^32 - 1.        (* FP_EPS *)

Definition w (x : Z) : Z := x mod M.   (* uint64 wraparound *)

Lemma M_eq : M = P + EPS. Proof. reflexivity. Qed.
Lemma EPS_lt_P : 0 <= EPS < P. Proof. unfold EPS, P; lia. Qed.
Lemma P_pos : 0 < P. Proof. unfold P; lia. Qed.
Lemma M_pos : 0 < M. Proof. unfold M; lia. Qed.

(* Present a value: if x = k*P + r with r canonical, then x mod P = r. *)
Lemma spec_of : forall x r k, 0 <= r < P -> x = k * P + r -> x mod P = r.
Proof.
  intros x r k Hb ->.
  replace (k * P + r) with (r + k * P) by ring.
  rewrite Z.mod_add by (pose proof P_pos; lia).
  apply Z.mod_small. exact Hb.
Qed.

(* Same, for the uint64 wrap. *)
Lemma w_of : forall z r k, 0 <= r < M -> z = k * M + r -> w z = r.
Proof.
  intros z r k Hb ->. unfold w.
  replace (k * M + r) with (r + k * M) by ring.
  rewrite Z.mod_add by (pose proof M_pos; lia).
  apply Z.mod_small. exact Hb.
Qed.

(* Difference form: if (x - r) is a multiple of P and r is canonical,
   then x mod P = r. The finisher tactic tries the small multipliers
   that occur in the case analyses below; unreachable cases are
   discharged from contradictory bounds. *)
Lemma spec_of2 : forall x r, 0 <= r < P -> (x - r) mod P = 0 -> x mod P = r.
Proof.
  intros x r Hb H.
  assert (Hx : x = (x - r) + r) by ring.
  rewrite Hx at 1. rewrite Z.add_mod by (pose proof P_pos; lia).
  rewrite H, Z.add_0_l, (Z.mod_mod r P) by (pose proof P_pos; lia).
  apply Z.mod_small. exact Hb.
Qed.

(* ------------------------------------------------------------------ *)
(* fp_add (field.h):                                                  *)
(*   s = a + b; if (s < a) s += EPS; if (s >= P) s -= P;              *)

Definition fp_add (a b : Z) : Z :=
  let s0 := w (a + b) in
  let s1 := if s0 <? a then w (s0 + EPS) else s0 in
  if s1 >=? P then s1 - P else s1.

(* THM-AIR-FP-ADD-001: fp_add computes (a + b) mod p, canonically. *)
Theorem fp_add_correct :
  forall a b, 0 <= a < P -> 0 <= b < P ->
    fp_add a b = (a + b) mod P /\ 0 <= fp_add a b < P.
Proof.
  intros a b Ha Hb.
  pose proof M_eq as HM. pose proof EPS_lt_P as HEP. pose proof P_pos as HP.
  assert (Hw : (a + b < M /\ w (a + b) = a + b)
            \/ (M <= a + b /\ w (a + b) = a + b - M)).
  { destruct (Z_le_gt_dec M (a + b)) as [H1 | H1].
    - right. split; [ lia | ]. apply (w_of _ _ 1); [ unfold M in *; lia | ring ].
    - left. split; [ lia | ]. apply (w_of _ _ 0); [ unfold M in *; lia | ring ]. }
  unfold fp_add. cbv zeta.
  destruct Hw as [[Hc Hw] | [Hc Hw]].
  - (* no carry *)
    assert (Hlt : (w (a + b) <? a) = false).
    { rewrite Hw. apply Z.ltb_ge. lia. }
    rewrite Hlt, Hw.
    destruct (Z.geb_spec (a + b) P) as [Hg | Hg].
    + split; [ | lia]. symmetry. apply spec_of2; [ lia | ].
      replace (a + b - (a + b - P)) with (1 * P) by ring.
      rewrite Z.mod_mul by lia. reflexivity.
    + split; [ | lia]. symmetry. apply spec_of2; [ lia | ].
      replace (a + b - (a + b)) with 0 by ring.
      apply Z.mod_0_l. lia.
  - (* carry *)
    assert (Hlt : (w (a + b) <? a) = true).
    { rewrite Hw. apply Z.ltb_lt. unfold M in *. lia. }
    rewrite Hlt.
    assert (Hs1 : w (w (a + b) + EPS) = a + b - P).
    { rewrite Hw. apply (w_of _ _ 0); [ unfold M in *; lia | rewrite HM; ring ]. }
    rewrite Hs1.
    destruct (Z.geb_spec (a + b - P) P) as [Hg | Hg].
    + split; [ | lia]. symmetry. apply spec_of2; [ lia | ].
      replace (a + b - (a + b - P - P)) with (2 * P) by ring.
      rewrite Z.mod_mul by lia. reflexivity.
    + split; [ | lia]. symmetry. apply spec_of2; [ lia | ].
      replace (a + b - (a + b - P)) with (1 * P) by ring.
      rewrite Z.mod_mul by lia. reflexivity.
Qed.

(* ------------------------------------------------------------------ *)
(* fp_sub (field.h):                                                  *)
(*   d = a - b; if (a < b) d += P;   (all in uint64)                  *)

Definition fp_sub (a b : Z) : Z :=
  w (w (a - b) + (if a <? b then P else 0)).

(* THM-AIR-FP-SUB-002: fp_sub computes (a - b) mod p, canonically. *)
Theorem fp_sub_correct :
  forall a b, 0 <= a < P -> 0 <= b < P ->
    fp_sub a b = (a - b) mod P /\ 0 <= fp_sub a b < P.
Proof.
  intros a b Ha Hb.
  pose proof M_eq as HM. pose proof EPS_lt_P as HEP. pose proof P_pos as HP.
  unfold fp_sub.
  destruct (Z.ltb_spec a b) as [Hc | Hc].
  - assert (Hval : w (w (a - b) + P) = a - b + P).
    { assert (Hw1 : w (a - b) = a - b + M).
      { apply (w_of _ _ (-1)); [ unfold M in *; lia | rewrite HM; ring ]. }
      rewrite Hw1. apply (w_of _ _ 1); [ unfold M in *; lia | rewrite HM; ring ]. }
    rewrite Hval. split; [ | lia]. symmetry. apply spec_of2; [ lia | ].
    replace (a - b - (a - b + P)) with (-1 * P) by ring.
    rewrite Z.mod_mul by lia. reflexivity.
  - assert (Hval : w (w (a - b) + 0) = a - b).
    { assert (Hw1 : w (a - b) = a - b).
      { apply (w_of _ _ 0); [ unfold M in *; lia | ring ]. }
      rewrite Hw1. apply (w_of _ _ 0); [ unfold M in *; lia | ring ]. }
    rewrite Hval. split; [ | lia]. symmetry. apply spec_of2; [ lia | ].
    replace (a - b - (a - b)) with 0 by ring.
    apply Z.mod_0_l. lia.
Qed.

(* ------------------------------------------------------------------ *)
(* fp_neg (field.h):  a ? P - a : 0                                   *)

Definition fp_neg (a : Z) : Z := if a =? 0 then 0 else P - a.

(* THM-AIR-FP-NEG-003: fp_neg computes (-a) mod p, canonically. *)
Theorem fp_neg_correct :
  forall a, 0 <= a < P ->
    fp_neg a = (- a) mod P /\ 0 <= fp_neg a < P.
Proof.
  intros a Ha. pose proof P_pos as HP.
  unfold fp_neg.
  destruct (Z.eqb_spec a 0) as [Hz | Hz].
  - subst a. split; [ | lia].
    rewrite Z.mod_small by lia. ring_simplify. reflexivity.
  - split; [ | lia]. symmetry. apply spec_of2; [ lia | ].
    replace (- a - (P - a)) with (-1 * P) by ring.
    rewrite Z.mod_mul by lia. reflexivity.
Qed.

(* ------------------------------------------------------------------ *)
(* fp_reduce128 (field.h): reduce x < 2^128 modulo p via              *)
(*   2^64 = EPS (mod p), 2^96 = -1 (mod p):                           *)
(*   lo = x mod 2^64; hi = x / 2^64; hi_hi = hi / 2^32;               *)
(*   hi_lo = hi mod 2^32;                                             *)
(*   t0 = lo - hi_hi (uint64; on borrow also -EPS);                   *)
(*   t1 = hi_lo * EPS;                                                *)
(*   r  = t0 + t1 (uint64; on carry also +EPS);                       *)
(*   if (r >= P) r -= P;                                              *)

Definition fp_reduce128 (x : Z) : Z :=
  let lo    := x mod M in
  let hi    := x / M in
  let hi_hi := hi / 2^32 in
  let hi_lo := hi mod 2^32 in
  let t0    := w (lo - hi_hi - (if lo <? hi_hi then EPS else 0)) in
  let t1    := hi_lo * EPS in
  let r0    := w (t0 + t1) in
  let r1    := if r0 <? t1 then w (r0 + EPS) else r0 in
  if r1 >=? P then r1 - P else r1.

(* Leaf finisher for the fp_reduce128 case tree (the names hi_hi and
   hi_lo are the proof-local ones at the use site). Reachable leaves
   close by exhibiting the multiplier of P in (x - result); unreachable
   leaves have contradictory bounds and fall to exfalso;nia. *)
Ltac leaf q0 :=
  split; [ symmetry; apply spec_of2; [ lia | ]
         | lia ];
  apply (proj2 (Z.mod_divide _ P ltac:(pose proof P_pos; lia)));
  first [ exfalso; nia
        | exists (q0 - 1); nia
        | exists q0; nia
        | exists (q0 + 1); nia
        | exists (q0 + 2); nia ].

(* THM-AIR-FP-RED128-004: fp_reduce128 computes x mod p, canonically,
   for every 128-bit input x. *)
Theorem fp_reduce128_correct :
  forall x, 0 <= x < 2^128 ->
    fp_reduce128 x = x mod P /\ 0 <= fp_reduce128 x < P.
Proof.
  intros x Hx.
  pose proof M_eq as HM. pose proof EPS_lt_P as HEP. pose proof P_pos as HP.
  assert (HEv : EPS = 2^32 - 1) by reflexivity.
  assert (HM96 : M * 2^32 = 2^96) by (unfold M; ring).
  assert (H96 : 2^96 = (2^32 + 1) * P - 1) by (unfold P; ring).
  unfold fp_reduce128. cbv zeta.
  set (lo := x mod M). set (hi := x / M).
  set (hi_hi := hi / 2^32). set (hi_lo := hi mod 2^32).
  set (t0 := w (lo - hi_hi - (if lo <? hi_hi then EPS else 0))).
  set (t1 := hi_lo * EPS).
  set (r0 := w (t0 + t1)).
  set (r1 := if r0 <? t1 then w (r0 + EPS) else r0).
  assert (Hlo : 0 <= lo < M) by (unfold lo; apply Z.mod_pos_bound; unfold M; lia).
  assert (Hhi : 0 <= hi < M).
  { unfold hi. split.
    - apply Z.div_pos; unfold M in *; lia.
    - apply Z.div_lt_upper_bound; unfold M in *; nia. }
  assert (Hdecomp : x = lo + M * hi).
  { unfold lo, hi.
    pose proof (Z.div_mod x M ltac:(unfold M; lia)) as E. lia. }
  assert (Hhidec : hi = hi_hi * 2^32 + hi_lo).
  { unfold hi_hi, hi_lo.
    pose proof (Z.div_mod hi (2^32) ltac:(lia)) as E. lia. }
  assert (Hhihi : 0 <= hi_hi < 2^32).
  { unfold hi_hi. split; [ apply Z.div_pos; lia | ].
    apply Z.div_lt_upper_bound; lia. }
  assert (Hhilo : 0 <= hi_lo < 2^32) by (apply Z.mod_pos_bound; lia).
  assert (Ht1eq : t1 = hi_lo * EPS) by reflexivity.
  assert (Ht1M : 0 <= t1 < M) by (rewrite Ht1eq; unfold M in *; nia).
  assert (Hxv : x = (lo - hi_hi + hi_lo * EPS)
                  + (hi_hi * (2^32 + 1) + hi_lo) * P).
  { rewrite Hdecomp, Hhidec. nia. }
  assert (Ht0v : (lo < hi_hi /\ t0 = lo - hi_hi + P)
              \/ (hi_hi <= lo /\ t0 = lo - hi_hi)).
  { unfold t0. destruct (Z.ltb_spec lo hi_hi) as [Hb | Hb].
    - left. split; [ exact Hb | ].
      apply (w_of _ _ (-1)); [ unfold M in *; lia | rewrite HM; ring ].
    - right. split; [ exact Hb | ].
      apply (w_of _ _ 0); [ unfold M in *; lia | ring ]. }
  assert (Ht0b : 0 <= t0 < M) by (apply Z.mod_pos_bound; unfold M; lia).
  assert (Hr0v : (M <= t0 + t1 /\ r0 = t0 + t1 - M)
              \/ (t0 + t1 < M /\ r0 = t0 + t1)).
  { unfold r0. destruct (Z_le_gt_dec M (t0 + t1)) as [H1 | H1].
    - left. split; [ exact H1 | ]. apply (w_of _ _ 1); [ unfold M in *; lia | ring ].
    - right. split; [ lia | ]. apply (w_of _ _ 0); [ unfold M in *; lia | ring ]. }
  assert (Hr0b : 0 <= r0 < M) by (apply Z.mod_pos_bound; unfold M; lia).
  assert (Hr1v : (r0 < t1 /\ ((M <= r0 + EPS /\ r1 = r0 + EPS - M)
                           \/ (r0 + EPS < M /\ r1 = r0 + EPS)))
              \/ (t1 <= r0 /\ r1 = r0)).
  { unfold r1. destruct (Z.ltb_spec r0 t1) as [Hc | Hc].
    - left. split; [ exact Hc | ].
      destruct (Z_le_gt_dec M (r0 + EPS)) as [H1 | H1].
      + left. split; [ exact H1 | ].
        apply (w_of _ _ 1); [ unfold M in *; lia | ring ].
      + right. split; [ lia | ].
        apply (w_of _ _ 0); [ unfold M in *; lia | ring ].
    - right. split; [ exact Hc | reflexivity ]. }
  destruct (Z.geb_spec r1 P) as [Hg | Hg];
    destruct Ht0v as [[Hc0 He0] | [Hc0 He0]];
    destruct Hr0v as [[Hc1 He1] | [Hc1 He1]];
    destruct Hr1v as [[Hc2 [[Hc2' He2] | [Hc2' He2]]] | [Hc2 He2]];
    leaf (hi_hi * (2^32 + 1) + hi_lo).
Qed.

(* ------------------------------------------------------------------ *)
(* fp_mul (field.h):  fp_reduce128 ((unsigned __int128) a * b)        *)

Definition fp_mul (a b : Z) : Z := fp_reduce128 (a * b).

(* THM-AIR-FP-MUL-005: fp_mul computes (a * b) mod p, canonically. *)
Theorem fp_mul_correct :
  forall a b, 0 <= a < P -> 0 <= b < P ->
    fp_mul a b = (a * b) mod P /\ 0 <= fp_mul a b < P.
Proof.
  intros a b Ha Hb. unfold fp_mul.
  assert (HP64 : P < 2^64) by (unfold P; lia).
  apply fp_reduce128_correct. nia.
Qed.
