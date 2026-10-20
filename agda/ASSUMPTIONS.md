<!-- SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque -->
# Explicit assumptions

The legacy core parameterizes its mathematical state machine as follows:

| Identifier | Parameter / abstraction |
|---|---|
| A-ST-1 | `commitOf : State → Digest`; its implementation is outside the generic machine |
| A-ST-2 | `KindOK` and `kindOK?`; a caller supplies the kind-specific predicate and its decision procedure |
| A-ST-3 | Proposal extra fields are a list of string pairs; this is not a verified canonical byte serializer |
| A-ST-4 | Genesis kind and payload are supplied explicitly |
| A-ST-5 | Digests are vectors of 64 hexadecimal digit values; ASCII decoding is external |
| A-GR-1 | The stepped benchmark factor lower-bounds the continuous solver factor |

`Kernel.Assumptions.Crypto` and `Kernel.Assumptions.Runtime` define the newer
kernel's exact security and runtime obligations. They do not assert these
obligations as axioms. Bridge theorems receive evidence as parameters.
In particular, `RuntimeBridge.trace-invariant` requires genesis equality and
`TransitionRefinement`; the capability-log theorem additionally requires
the runtime log to equal the model's retired IDs. Commitment binding requires
the stated collision-resistance assumption.

No checked theorem should be advertised as unconditional evidence about
external storage, a telescope, a FITS product or a running authority.
