"Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
 Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
 SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque

 GUI entry: file in the sources, then open the observatory world once the
 scheduler runs (the desktop needs the scheduler)."

((os environmentAt: 'LRD_SELF_DIR' IfFail: '.'), '/load.self') runScript.
snapshotAction addSchedulerInitialMessage: (message copy receiver: lrdObservatory Selector: 'open').
