# SPDX-License-Identifier: AGPL-3.0-only
# Also licensed under the SnapKitty Opaque License; see LICENSE and
# SNAPKITTY_OPAQUE_LICENSE.md at the repository root.
# Builds the LRD-NUM-ABI static library and its self-test into $(OUT).
CC      = clang
OUT     ?= build
CFLAGS  ?= -std=c17 -O2 -Wall -Wextra -Werror -ffp-contract=off -fno-fast-math
all: $(OUT)/liblrd_num_abi.a $(OUT)/test_lrd_num_abi
$(OUT)/lrd_num_abi.o: lrd_num_abi.c lrd_num_abi.h
	mkdir -p $(OUT)
	$(CC) $(CFLAGS) -c -o $@ lrd_num_abi.c
$(OUT)/liblrd_num_abi.a: $(OUT)/lrd_num_abi.o
	ar rcs $@ $^
$(OUT)/test_lrd_num_abi: test_lrd_num_abi.c $(OUT)/liblrd_num_abi.a
	$(CC) $(CFLAGS) -o $@ test_lrd_num_abi.c $(OUT)/liblrd_num_abi.a
clean:
	rm -rf $(OUT)
.PHONY: all clean
