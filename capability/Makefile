# SPDX-License-Identifier: AGPL-3.0-or-later OR LicenseRef-SnapKitty-Opaque
# Dual-licensed (intentionally): AGPL-3.0-or-later plus the SnapKitty Opaque License.
.PHONY: build test unit e2e clean
build:
	nice -n 19 cargo build --release --offline
unit:
	nice -n 19 cargo test --release --offline
e2e: build
	bash scripts/integration.sh target/release evidence/e2e
test:
	bash ../tests/capability/run.sh
clean:
	cargo clean
