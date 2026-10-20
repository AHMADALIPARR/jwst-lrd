<!-- SPDX-License-Identifier: AGPL-3.0-only. Also subject to SNAPKITTY_OPAQUE_LICENSE.md (dual license). -->
# Front end: Stereographic 2D Bloch Projection Engine

Status: specification added by the owner 2026-10-20 as the front-end
direction "for now", and as the integration path into the stack. The
specification text below is the owner's, verbatim. The integration
mapping at the end is assistant-added and labelled as such.

---

Stereographic 2D Bloch Projection Engine
 * Coordinate Transformation: Projects complex two-level quantum state vectors from 3D Hilbert space onto a flat 2D viewport plane via stereographic projection, preserving angle integrity while mapping the North and South poles to bounded Euclidean coordinates.
 * Phase-Crystallization Binding: Links the 2D projection matrices directly to deterministic phase states, utilizing parameterized non-commutative torus configurations to eliminate floating-point drift across real-time rendering frames.
 * State-Vector Quantization: Discretizes continuous probability amplitudes into fixed-point coordinate vectors optimized for direct ingestion by spatial hardware rasterization pipelines.
Macro-Assembler Pipeline (MacroEASM)
 * Instruction Unrolling: Converts high-level quantum state transformations into flat, unrolled byte sequences, entirely bypassing intermediate stack frames, garbage collectors, and runtime interpreters.
 * Register-Free Routing: Dispatches projection bytes directly through etched logic gates, avoiding traditional arithmetic logic units in favor of continuous voltage propagation.
 * Deterministic Opcode Mapping: Executes hardware-level macro expansions that map state transitions straight into non-volatile memory lattices without runtime overhead.
Recursive Decoding Subsystem
| Decoding Tier | Execution Mechanism | Hardware Target |
|---|---|---|
| Tier 0: Syndrome Extraction | Bitwise parity checks across compressed memory sectors | Bare-metal FPGA and ASIC fabrics |
| Tier 1: Recursive Unrolling | Self-referential macro expansions for error correction | Stackless recursive processing blocks |
| Tier 2: Spatial Latching | Permanent persistence of corrected states into magnetic core matrices | Non-volatile ferrite storage planes |
VR Spatial Rendering Integration
 * Raymarched Sphere Tracing: Evaluates the 2D Bloch projection equations analytically within custom shader pipelines to render high-framerate immersive volumetric quantum vectors.
 * Zero-Copy Framebuffer Injection: Feeds decoded state arrays straight into the display controller pipeline, bypassing operating system compositors to achieve sub-millisecond motion-to-photon latency.
 * Immersive Telemetry HUD: Overlays real-time register states, memory checksums, and execution flags directly into the virtual reality coordinate space without lagging the primary compute loop.

---

## Integration mapping (assistant-added)

How this front end binds to the existing stack in this repo:

- **Projection engine → the Morphic front end.** `self/growth/`
  (growthMorph.self, growthHistory.self) is the live front end; the
  Bloch projection is its state-view layer: a two-level state from
  the stack is drawn on the 2D viewport by stereographic projection
  instead of ad-hoc chart coordinates, with state-vector
  quantization feeding the same fixed-point arrays the Morphic
  canvas already consumes.
- **MacroEASM → the assembler tracks.** The flat, unrolled byte
  sequences target the same execution surfaces the repo already
  builds: llvm/ (the lrdc compiler and its runtime) and the C ABI
  (abi/lrd_num_abi) — macro expansions land as ordinary state
  transitions over LRD-REC-v1 records (ledger/abi/lrd_state.h),
  so a projection step is a ledger transition like any other.
- **Recursive decoding → the ledger and AIR.** Tier 0 syndrome
  extraction is parity over the WORM hash chain (ledger/); Tier 1
  recursive unrolling is the MacroEASM expansion applied to error
  correction; Tier 2 latching is the persistence the ledger already
  provides (sealed, hash-chained records). The AIR STARK track
  (air/) is the proving layer over the same states.
- **VR rendering → display path only.** Raymarching and zero-copy
  framebuffer injection sit downstream of the decoded state arrays;
  nothing in the compute stack depends on the renderer. The
  telemetry HUD reads register states, checksums and flags — the
  same values the ledger and the test contracts already print.

Nothing in the existing runtimes changes: this is a front-end and
integration specification over them.

## Implementation (merged with the Self front end)

- `self/growth/blochSphere.self` — the state model: integer-only
  quantized state (thetaSteps 0..128, phaseSteps 0..255 — the
  crystallized phase), derived unit vector and probabilities, the
  bounded two-chart stereographic atlas, and fixed-point (milli-unit)
  projected vectors for rasterization.
- `self/growth/blochMorph.self` — the Self Bloch sphere morph: the
  growthMorph layout idiom (460x520) drawing the unit disk, the
  projected state point and phase arm, the rim phase tick, and the
  fixed-point vectors as text.
- `tests/growth/self_headless_bloch.self` — headless checks (poles,
  equator, phase wrap, atlas boundedness sweep), PASS/FAIL +
  SELF_BLOCH_DONE, run on the owner's host like the rest of the Self
  track (the 32-bit Self VM cannot execute on the agent VM).
