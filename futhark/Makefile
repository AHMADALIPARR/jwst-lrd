# SPDX-License-Identifier: AGPL-3.0-only
# Also subject to the SnapKitty Opaque License; see LICENSE and
# SNAPKITTY_OPAQUE_LICENSE.md at the repository root.
FUTHARK ?= futhark
B = build

all: $(B)/lrd-c

multicore: $(B)/lrd-multicore

$(B)/lrd-c: lrd.fut
	mkdir -p $(B)
	$(FUTHARK) c --safe -o $@ lrd.fut

$(B)/lrd-multicore: lrd.fut
	mkdir -p $(B)
	$(FUTHARK) multicore --safe -o $@ lrd.fut

check:
	$(FUTHARK) check lrd.fut

clean:
	rm -rf $(B)

.PHONY: all multicore check clean
