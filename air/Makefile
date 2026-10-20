# SPDX-License-Identifier: AGPL-3.0-only
# Additional terms: SnapKitty Opaque License (SNAPKITTY_OPAQUE_LICENSE.md, repository root).
# Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
#
# Build of the AIR + STARK subsystem. Outputs go to $(BUILD) (default air/build, git-ignored).
# TODO(t009-air): replace -Iabi_mirror with -I../ledger/abi once t004-ledger is merged.
CC      ?= cc
BUILD   ?= build
SAN     ?=
CFLAGS  ?= -O2
override CFLAGS  += -std=c17 -Wall -Wextra -Werror -Iinclude -Iabi_mirror $(SAN)
override LDLIBS  += -lcrypto -lm
override LDFLAGS += $(SAN)

SRCS := src/field.c src/poly.c src/crypto.c src/rec.c src/stark.c src/proof.c src/arr.c src/state.c
OBJS := $(SRCS:src/%.c=$(BUILD)/%.o)
HDRS := $(wildcard include/air/*.h) abi_mirror/lrd_state.h

all: $(BUILD)/libair.a $(BUILD)/air_cli $(BUILD)/gen_synthetic $(BUILD)/test_air

$(BUILD):
	mkdir -p $(BUILD)
$(BUILD)/%.o: src/%.c $(HDRS) | $(BUILD)
	$(CC) $(CFLAGS) -c $< -o $@
$(BUILD)/libair.a: $(OBJS)
	$(AR) rcs $@ $^
$(BUILD)/air_cli: tools/air_cli.c $(BUILD)/libair.a $(HDRS)
	$(CC) $(CFLAGS) $< $(BUILD)/libair.a $(LDFLAGS) $(LDLIBS) -o $@
$(BUILD)/gen_synthetic: tools/gen_synthetic.c | $(BUILD)
	$(CC) $(CFLAGS) $< $(LDFLAGS) -o $@
$(BUILD)/test_air: ../tests/air/test_air.c $(BUILD)/libair.a $(HDRS)
	$(CC) $(CFLAGS) $< $(BUILD)/libair.a $(LDFLAGS) $(LDLIBS) -o $@
clean:
	rm -rf $(BUILD)
.PHONY: all clean
