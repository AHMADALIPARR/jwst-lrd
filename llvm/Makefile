# SPDX-License-Identifier: AGPL-3.0-only
# Also licensed under the SnapKitty Opaque License; see LICENSE and
# SNAPKITTY_OPAQUE_LICENSE.md at the repository root.
#
# Builds lrdc and the LRD-IR runtime library into $(OUT) (default llvm/build).
# FP policy (validation/FP_POLICY.md): -ffp-contract=off, never -ffast-math/-Ofast.
HERE   := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
OUT    ?= $(HERE)/build
CC     := /usr/bin/clang
FPFLAGS := -ffp-contract=off -fno-fast-math
CFLAGS := -std=c17 -O2 -Wall -Wextra -Werror $(FPFLAGS)
RT_SRC := runtime/lrd_rt.c runtime/lrd_rec.c runtime/lrd_sha256.c ../abi/lrd_num_abi.c
RT_HDR := runtime/lrd_rt.h runtime/lrd_rec.h runtime/lrd_sha256.h ../abi/lrd_num_abi.h ../ledger/abi/lrd_state.h
RT_OBJ := $(patsubst %.c,$(OUT)/obj/%.o,$(notdir $(RT_SRC)))

all: toolchain $(OUT)/lrdc $(OUT)/liblrdrt.a

toolchain:
	@$(HERE)/check_toolchain.sh >/dev/null || { $(HERE)/check_toolchain.sh; echo "toolchain pin mismatch: refusing to build"; exit 3; }

$(OUT)/obj/%.o: runtime/%.c $(RT_HDR)
	@mkdir -p $(OUT)/obj
	$(CC) $(CFLAGS) -c -o $@ $<
$(OUT)/obj/lrd_num_abi.o: ../abi/lrd_num_abi.c ../abi/lrd_num_abi.h
	@mkdir -p $(OUT)/obj
	$(CC) $(CFLAGS) -c -o $@ $<
$(OUT)/liblrdrt.a: $(RT_OBJ)
	ar rcs $@ $^
$(OUT)/lrdc: lrdc/lrdc.c $(OUT)/liblrdrt.a
	$(CC) $(CFLAGS) -DLRDC_RUNTIME_LIB='"$(OUT)/liblrdrt.a"' -o $@ lrdc/lrdc.c

print-cflags:
	@echo $(CFLAGS)
clean:
	rm -rf $(OUT)
.PHONY: all toolchain clean print-cflags
