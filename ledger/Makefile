# Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
# Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
# SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
#
# Ledger track build (C17, GMP, OpenSSL libcrypto). Outputs go to ledger/out/ (git-ignored).

CC      ?= cc
CFLAGS  ?= -std=c17 -Wall -Wextra -O2
CFLAGS  += -Iinclude
LDLIBS_GMP    = -lgmp
LDLIBS_CRYPTO = -lcrypto
OUT     = out
TESTS   = ../tests/ledger

BINS = $(OUT)/test_godel $(OUT)/lrd-rec $(OUT)/test_env

all: $(BINS)

$(OUT):
	mkdir -p $(OUT)

$(OUT)/lrd_rec.o: src/lrd_rec.c include/lrd_rec.h abi/lrd_state.h | $(OUT)
	$(CC) $(CFLAGS) -c -o $@ $<

$(OUT)/lrd_env.o: src/lrd_env.c include/lrd_env.h | $(OUT)
	$(CC) $(CFLAGS) -c -o $@ $<

$(OUT)/lrd_godel.o: src/lrd_godel.c include/lrd_godel.h include/lrd_rec.h | $(OUT)
	$(CC) $(CFLAGS) -c -o $@ $<

$(OUT)/test_godel: $(TESTS)/test_godel.c $(OUT)/lrd_godel.o $(OUT)/lrd_rec.o $(OUT)/lrd_env.o | $(OUT)
	$(CC) $(CFLAGS) -o $@ $^ $(LDLIBS_GMP) $(LDLIBS_CRYPTO)

$(OUT)/lrd-rec: src/lrd_rec_tool.c $(OUT)/lrd_rec.o $(OUT)/lrd_env.o | $(OUT)
	$(CC) $(CFLAGS) -o $@ $^ $(LDLIBS_CRYPTO)

clean:
	rm -rf $(OUT)

.PHONY: all clean

$(OUT)/test_env: $(TESTS)/test_env.c $(OUT)/lrd_env.o | $(OUT)
	$(CC) $(CFLAGS) -o $@ $^ $(LDLIBS_CRYPTO)

