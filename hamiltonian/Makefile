# Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
# Dual-licensed: AGPL-3.0-or-later plus SnapKitty Opaque License (see LICENSE, SNAPKITTY_OPAQUE_LICENSE.md).
# SPDX-License-Identifier: AGPL-3.0-or-later AND LicenseRef-SnapKitty-Opaque
#
# Frustration Hamiltonian Action-WORM engine (TASK 008).
#   make            -> build/std/libham.a + build/std/test_ham   (-Werror)
#   make asan       -> build/asan/test_ham  (ASan + UBSan, -Werror)
#   make clang      -> build/clang/test_ham (clang, -Werror)
#   make test       -> ../tests/hamiltonian/run.sh (the CONTRACTS.md runner)

CC      ?= gcc
CSTD     = -std=c17
WARN     = -Wall -Wextra -Werror -Wpedantic -Wshadow -Wstrict-prototypes -Wformat=2
OPT      = -O2 -g

# Shared LRD-STATE-v1 header owned by the ledger track (merged on main at 627fda7).
# Included, never forked; the build fails loudly if it is missing.
ABI_DIR := ../ledger/abi
ifeq ($(wildcard $(ABI_DIR)/lrd_state.h),)
$(error ledger/abi/lrd_state.h not found: rebase on main >= 627fda7)
endif

CPPFLAGS = -Iinclude -I$(ABI_DIR)
LDLIBS   = -lgmp
SRCS     = src/ham_sha256.c src/ham_q.c src/ham_rec.c src/ham_model.c src/ham_engine.c
TEST_SRC = ../tests/hamiltonian/test_ham.c
HDRS     = include/ham.h $(ABI_DIR)/lrd_state.h

SAN      = -fsanitize=address,undefined -fno-sanitize-recover=all -fno-omit-frame-pointer

.PHONY: all std asan clang test clean
all: std
std:   build/std/test_ham
asan:  build/asan/test_ham
clang: build/clang/test_ham

build/std/libham.a: $(SRCS) $(HDRS)
	@mkdir -p build/std/obj
	@for s in $(SRCS); do o=build/std/obj/$$(basename $$s .c).o; \
	  $(CC) $(CSTD) $(WARN) $(OPT) $(CPPFLAGS) -c $$s -o $$o || exit 1; done
	ar rcs $@ build/std/obj/*.o

build/std/test_ham: build/std/libham.a $(TEST_SRC) $(HDRS)
	$(CC) $(CSTD) $(WARN) $(OPT) $(CPPFLAGS) $(TEST_SRC) build/std/libham.a $(LDLIBS) -o $@

build/asan/test_ham: $(SRCS) $(TEST_SRC) $(HDRS)
	@mkdir -p build/asan
	$(CC) $(CSTD) $(WARN) -O1 -g $(SAN) $(CPPFLAGS) $(SRCS) $(TEST_SRC) $(LDLIBS) -o $@

build/clang/test_ham: $(SRCS) $(TEST_SRC) $(HDRS)
	@mkdir -p build/clang
	clang $(CSTD) $(WARN) $(OPT) $(CPPFLAGS) $(SRCS) $(TEST_SRC) $(LDLIBS) -o $@

test:
	../tests/hamiltonian/run.sh

clean:
	rm -rf build
