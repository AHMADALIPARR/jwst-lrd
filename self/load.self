"Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
 SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque

 Files in the JWST-LRD Self observatory from source text.  LRD_SELF_DIR must
 name this directory (self/ of the t015-self worktree)."

[| d |
  d: os environmentAt: 'LRD_SELF_DIR' IfFail: '.'.
  ('sha256 reader catalog widgets observatory' asTokensSeparatedByWhiteSpace) do: [|:f|
    (d, '/lrd/', f, '.self') runScript].
  lrdObservatory selfDir: d.
] value.
