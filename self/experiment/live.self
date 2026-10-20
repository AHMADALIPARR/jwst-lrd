"SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque"
((os environmentAt: 'LRD_ROOT' IfFail: '.'), '/self/experiment/load.self') runScript.
(lrdRoot, '/self/experiment/liveMorph.self') runScript.
'LRD_LIVE_READY' printLine.
