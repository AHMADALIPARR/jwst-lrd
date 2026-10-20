<!-- Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
     Dual-licensed: AGPL-3.0-or-later plus SnapKitty Opaque License (see LICENSE, SNAPKITTY_OPAQUE_LICENSE.md).
     SPDX-License-Identifier: AGPL-3.0-or-later AND LicenseRef-SnapKitty-Opaque -->
# hamiltonian/OBLIGATIONS.md — proof obligations for `kind=hamiltonian_step`

Contributed by the hamiltonian track (TASK 008) for the Agda track to mirror in
`agda/Core/Hamiltonian.agda` (and to merge into `agda/OBLIGATIONS.md` through
Hilbert). This track does not write `agda/`. Everything below is stated against
the C implementation in `hamiltonian/src/` and is precise enough to formalize;
the C name each definition corresponds to is given in brackets.

Status of every obligation: **stated, tested in C (see STATUS.md), NOT yet
machine-proved.** No Agda proof exists yet.

## 1. Definitions

### 1.1 State space
- `n : ℕ`, `1 ≤ n ≤ 64`; `dom : Fin n → ℕ`, `1 ≤ dom v ≤ 64`.  [`ham_model.n`, `.dom`]
- `S := (v : Fin n) → Fin (dom v)` — finite, `|S| = ∏ dom v`.  [`int assign[]`]
- Rationals `ℚ` are exact, normalized (`den > 0`, `gcd num den = 1`). Text form
  `show q = "p/q"` (zero is `"0/1"`, sign on `p`).  [`mpq_t`, `ham_q_str`]

### 1.2 Model `M`
- Field terms `vt k = (var : Fin n, w : ℚ, V : Fin (dom var) → ℚ)`.  [`ham_vterm`]
- Coupling terms `ct k = (i j : Fin n, i ≢ j, J : ℚ, C : Fin (dom i) → Fin (dom j) → ℚ)`.  [`ham_cterm`]
- Soft constraints `sc k = (name, scope, u : ℚ, viol : scope-values → Bool)`.  [`ham_soft`]
- Hard constraints `hc k = (name, scope, ok : scope-values → Bool)`, where `scope`
  is unary `(i)` or binary `(i, j)` with `i ≢ j`.  [`ham_hard`]
- `H_M : S → ℚ`,
  `H_M s = Σ_k w_k · V_k (s var_k) + Σ_k J_k · C_k (s i_k) (s j_k) + Σ_k (if viol_k (s|scope_k) then u_k else 0)`.
  Hard constraints contribute nothing to `H_M`.  [`ham_energy`]
- `Viol_M s := [ k | k ← 0 … nh−1, ok_k (s|scope_k) ≡ false ]` (ascending list).  [`ham_violations`]
- `Feasible_M s := Viol_M s ≡ []`.
- `commit(M)` : hash of the canonical model record `LRD-HAM-MODEL-v1`.  [`ham_model_commit`]

### 1.3 Configuration
- `Cfg = (B E : ℕ)` with `B ≥ 1` (step budget per epoch) and `E ≥ 1` (epochs
  `0 … E−1`).  [`ham_epoch_cfg.budget`, `.max_epochs`]

### 1.4 Engine state
```
record EState : Set where
  seq     : ℕ
  prev    : Hash          -- LRD-STATE-v1 "commit" (commitment of predecessor; 0^64 at genesis)
  self    : Hash          -- commitment of this state's LRD-STATE-v1 record
  payload : Hash          -- payload_sha256
  model   : Hash          -- commit(M)
  epoch   : ℕ
  used    : ℕ             -- accepted descent steps in the current epoch
  assign  : S
  energy  : ℚ
```
[`ham_state`]. Invariant `Inv_{M,Cfg} σ`:
`Feasible_M σ.assign ∧ σ.energy ≡ H_M σ.assign ∧ σ.used ≤ B ∧ σ.epoch < E ∧ σ.model ≡ commit(M) ∧
 σ.self ≡ commitRec{commit=σ.prev, kind=hamiltonian_step, payload_sha256=σ.payload, seq=σ.seq}`.

Genesis `genesis M Cfg a` [`ham_state_genesis`]:
`Feasible_M a → just σ₀` with `seq=0, prev=0^64, epoch=0, used=0, assign=a, energy=H_M a`;
`¬ Feasible_M a → infeasible(report)` and **no** `EState` is produced.

### 1.5 Proposals
A proposal is bytes `p`. `parse p : Maybe Prop` succeeds iff `p` is a canonical
LRD-REC-v1 record with exactly the fields
`assign, epoch, kind, op, payload_sha256, prev_commit, seq`, canonical syntax
(`seq`,`epoch` canonical naturals, hashes 64 lowercase hex, `assign` a canonical
comma list in `S`) and `op ∈ {step, epoch_advance}`.
`payloadHash(M, op, assign, epoch, estep)` = SHA-256 of the canonical record
`{assign, epoch, epoch_step=estep, format=LRD-HAM-PAYLOAD-v1, model=commit(M), op}`,
where `estep = σ.used + 1` for `step` and `0` for `epoch_advance`.  [`ham_payload_sha256`]

### 1.6 Decisions
```
data Reason : Set where
  ok malformed wrong_kind stale_seq bad_prev bad_payload bad_epoch
  epoch_exhausted infeasible energy_not_decreasing : Reason

data Decision : Set where
  accept : (rec : Bytes) → (σ' : EState) → Decision
  reject : (rec : Bytes) → (r : Reason) → r ≢ ok → Decision

decide : Model → Cfg → EState → Bytes → Decision          [ham_decide]
```
(The C function can also return `HAM_ERR_NOMEM`/`HAM_ERR_ARG` with *no*
decision and nothing constructed; this is outside `decide` — model it as
`Err ⊎ Decision` if desired.)

**Normative (ratified by the coordinator, 2026-10-19):** `decide M Cfg σ p` checks in this exact order and returns the first failure. In particular, for `step`, `epoch_exhausted` (row 8) is checked before `infeasible` (row 9), which is checked before `energy_not_decreasing` (row 10). Implementations and proofs must preserve this order; H-9 depends on it.

| # | condition (failure) | reason |
|---|---|---|
| 1 | `parse p` is not a record | `malformed` |
| 2 | `kind ≢ hamiltonian_step` | `wrong_kind` |
| 3 | field set / syntax / `assign ∉ S` / unknown `op` | `malformed` |
| 4 | `seq ≢ σ.seq + 1` | `stale_seq` |
| 5 | `prev_commit ≢ σ.self` | `bad_prev` |
| 6 | `payload_sha256 ≢ payloadHash(M, op, assign, epoch, estep)` | `bad_payload` |
| step 7 | `epoch ≢ σ.epoch` | `bad_epoch` |
| step 8 | `σ.used ≥ B` | `epoch_exhausted` |
| step 9 | `¬ Feasible_M a` | `infeasible` |
| step 10 | `¬ (H_M a < σ.energy)` (exact `ℚ`) | `energy_not_decreasing` |
| adv 7 | `epoch ≢ σ.epoch + 1` or `a ≢ σ.assign` | `bad_epoch` |
| adv 8 | `epoch ≥ E` | `epoch_exhausted` |
| — | otherwise | `ok` → `accept` |

On `accept`, `σ'` is: `seq = σ.seq+1, prev = σ.self, payload = payloadHash(…),
model = σ.model, assign = a, energy = H_M a`, and
`(epoch, used) = (σ.epoch, σ.used+1)` for `step`, `(σ.epoch+1, 0)` for `epoch_advance`;
`σ'.self` = commitment of its LRD-STATE-v1 record, emitted as `new_commit`.

### 1.7 Ledger ABI mapping (`ledger/abi/lrd_state.h`, main 627fda7)
- `ham_state_view : EState → lrd_state_t` gives `seq, commit = σ.prev, kind = LRD_KIND_HAMILTONIAN_STEP, payload_sha256`.
- `ham_decide_abi` serializes an `lrd_proposal_t` (common fields + `extra`) to LRD-REC-v1 and returns
  exactly `decide` on those bytes (bytes that cannot be serialized — duplicate keys, NUL/newline — are
  decided as the empty input, i.e. `reject malformed`). It satisfies the `lrd_transition_fn` contract
  (ACCEPT writes `*next` and `new_commit`; REJECT writes neither and leaves `new_commit = ""`) with the
  engine context passed explicitly, because `lrd_transition_fn` has no context parameter.

## 2. Obligations

**H-1 (rejection never constructs a state).**
`∀ M Cfg σ p. decide M Cfg σ p ≡ reject rec r _ → ` no `EState` is produced.
In Agda this holds by construction of `Decision` (the `reject` constructor has no
`EState` field); the C-side refinement is: on REJECT `*next` is not written and
the construction counter `ham_states_constructed()` is unchanged; likewise
`genesis` on an infeasible assignment. The decision record of a `reject` has no
`new_commit` field.

**H-2 (determinism of the decision).**
`decide` is a total function of `(commit(M), Cfg, σ, p)`; moreover the decision
bytes are a function of those inputs: `p₁ ≡ p₂ → σ₁ ≡ σ₂ → M₁ ≡ M₂ → Cfg₁ ≡ Cfg₂ →
bytes(decide M₁ Cfg₁ σ₁ p₁) ≡ bytes(decide M₂ Cfg₂ σ₂ p₂)` (byte-identical
LRD-REC-v1 serialization; keys sorted, rationals canonical). No randomness, clock,
address or floating-point value enters the record.

**H-3 (step soundness).**
`decide M Cfg σ p ≡ accept rec σ'` with `op = step` implies
`Feasible_M σ'.assign ∧ H_M σ'.assign < H_M σ.assign ∧ σ.used < B ∧
 σ'.used ≡ σ.used + 1 ∧ σ'.epoch ≡ σ.epoch ∧ σ'.seq ≡ σ.seq + 1 ∧ σ'.prev ≡ σ.self`.

**H-4 (step completeness).** If checks 1–7 pass for a `step` proposal and
`σ.used < B ∧ Feasible_M a ∧ H_M a < σ.energy`, then `decide` returns `accept`.
(Acceptance is *iff* feasible ∧ strictly lower energy ∧ budget remains, given a
well-formed envelope.)

**H-5 (explicit epoch transitions).**
`decide M Cfg σ p ≡ accept rec σ'` with `op = epoch_advance` implies
`σ'.epoch ≡ σ.epoch + 1 ∧ σ'.epoch < E ∧ σ'.used ≡ 0 ∧ σ'.assign ≡ σ.assign ∧
 σ'.energy ≡ σ.energy ∧ σ'.seq ≡ σ.seq + 1 ∧ σ'.prev ≡ σ.self`, and `rec` contains
`op=epoch_advance` and `new_commit = σ'.self`. The epoch counter changes **only**
through such an accepted, recorded `epoch_advance`; a `step` never changes it.

**H-6 (invariant preservation).** `Inv σ → decide M Cfg σ p ≡ accept _ σ' → Inv σ'`,
and `genesis` yields `Inv σ₀`.

**H-7 (bounded-epoch strict descent).** Let `σ₀ →p₁ σ₁ →p₂ … →p_k σ_k` be an
accepted run (each `decide M Cfg σ_{t−1} p_t ≡ accept _ σ_t`, `Inv σ₀`). Then:
(a) for any maximal segment of consecutive `step` accepts `σ_a → … → σ_b` (all with
equal `epoch`), `H_M σ_a.assign > H_M σ_{a+1}.assign > … > H_M σ_b.assign` and
`b − a ≤ B`;
(b) the number of `epoch_advance` accepts is `≤ E − 1` and the number of `step`
accepts is `≤ E · B`; hence `k ≤ E·B + E − 1`;
(c) `H_M` is non-increasing along the whole run (strict on `step`, equal on
`epoch_advance`).

**H-8 (exactness).** Every comparison in checks 9–10 is decidable equality/order on
`ℚ` (GMP `mpq_cmp` on canonical values); no approximation is used. In particular
`1/3+1/3+1/3 = 1` and `1/10+2/10 = 3/10` are equalities (→ `energy_not_decreasing`).

**H-9 (reason precedence).** The reason is exactly the first failing row of the
table in §1.6 (so each input has exactly one reason).

**H-10 (satisfiability and conflicts)** [`ham_sat`, `ham_conflict`].
For an active subset `A` of hard constraints: `ham_sat` returning `sat w` implies
`w ∈ S ∧ ∀ k ∈ A. ok_k(w)` (and `w` is the lexicographically least such state);
returning `unsat` implies `∀ s ∈ S. ∃ k ∈ A. ¬ ok_k(s)`; returning `search_limit`
makes no claim. `ham_conflict` returning `C` (on unsat) implies `C` is unsatisfiable
and irreducible: `∀ c ∈ C. C ∖ {c}` is satisfiable.

**H-11 (infeasibility reports).** For `s ∈ S`, the report's `violated` field lists
exactly `Viol_M s` (names, ascending index), `violated_count = |Viol_M s|`, and for
each violated `k`, `witness.<name_k>` gives the values of `s` on `scope_k`.

**H-12 (ABI adapter faithfulness).** For every `lrd_proposal_t` `π` that serializes to bytes `p`,
`ham_decide_abi M Cfg σ π` yields the same decision record bytes as `decide M Cfg σ p`, and
`out.decision`/`out.reason`/`out.new_commit` are projections of that record; H-1 holds for both `next`
and `next_view`.

## 3. Why descent is bounded per epoch (and not assumed to terminate on its own)

`(ℚ, <)` restricted to a set with a lower bound is **not** well-founded:
`1, 1/2, 1/3, …` is strictly decreasing, bounded below by `0`, and infinite. So
"energy is bounded below" does not imply that strict descent terminates. Strict
descent terminates only if (i) the set of reachable energies is finite, or (ii)
every accepted step decreases energy by at least a fixed `δ > 0`.

Here `S` is finite, so `H_M(S)` is finite and (i) happens to hold — any strictly
descending chain has length `≤ |H_M(S)| − 1 ≤ |S| − 1`. But `|S|` can be up to
`64^64`, so that bound is useless operationally, and the engine is designed not
to depend on it (it must stay sound if the domain is later made unbounded). The
engine therefore guarantees exactly H-7: at most `B` strict-descent steps per
epoch, at most `E` epochs, each epoch change an explicit recorded transition, and
therefore at most `E·B + E − 1` accepted transitions in total for a given `Cfg`.
It does **not** guarantee reaching a minimum of `H_M`, and does not guarantee any
minimum decrement per step.

## 4. Suggested Agda surface (`agda/Core/Hamiltonian.agda`)
```
open import Data.Rational using (ℚ; _<_)
record Model : Set      -- §1.2
H        : Model → S → ℚ
Feasible : Model → S → Set           -- decidable
record Cfg : Set where field B E : ℕ ; B≥1 : 1 ≤ B ; E≥1 : 1 ≤ E
record EState : Set     -- §1.4
data Reason : Set       -- §1.6
data Decision : Set     -- §1.6 (reject carries no EState)
decide : Model → Cfg → EState → Bytes → Decision
-- H-1 … H-12 as above; H-7 by induction on the run with measure (E − epoch , B − used)
```
The lexicographic measure `(E − σ.epoch, B − σ.used)` strictly decreases on every
accepted transition (`step`: second component; `epoch_advance`: first component),
which is the intended proof of H-7(b).
