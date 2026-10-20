"SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque"
((os environmentAt: 'LRD_ROOT' IfFail: '.'), '/self/experiment/live.self') runScript.
(lrdRoot, '/self/experiment/exportDemo.self') runScript.
lrdDemo run.
_Quit
