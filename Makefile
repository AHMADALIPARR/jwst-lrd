# SPDX-License-Identifier: AGPL-3.0-only
# Also subject to SNAPKITTY_OPAQUE_LICENSE.md (dual license, see repository root).
#
# Top-level build for the JWST-LRD Sovereign Scientific Runtime.
#   make toolchain  detect (and with LRD_INSTALL=1 install) tools, write build/TOOLCHAIN.lock
#   make build      build C ingestion tools and the Fortran kernel into build/out/
#   make test       run every tests/*/run.sh via tests/run_all.sh
#   make clean      remove build/out (never touches fixtures/ or build/tools)
#   make rebuild    clean + build
CC      ?= gcc
FC      ?= gfortran
CFLAGS  ?= -O2 -Wall -Wextra
FFLAGS  ?= -O2 -Wall -std=f2018 -fimplicit-none
OUT     := build/out
BIN     := $(OUT)/bin

INGEST_BINS := $(BIN)/lrd_fetch $(BIN)/lrd_sha256 $(BIN)/lrd_rec $(BIN)/lrd_fitsx

.PHONY: all toolchain build ingest fortran test clean rebuild
all: build

toolchain:
	sh build/toolchain.sh

build: ingest fortran

ingest: $(INGEST_BINS)

$(BIN):
	mkdir -p $@

$(BIN)/lrd_fetch: ingest/src/lrd_fetch.c | $(BIN)
	$(CC) $(CFLAGS) -std=c11 -D_POSIX_C_SOURCE=200809L -o $@ $< -lcurl -lcrypto

$(BIN)/sha256.o: ingest/src/lrd_fetch.c | $(BIN)
	$(CC) $(CFLAGS) -std=c11 -D_POSIX_C_SOURCE=200809L -DLRD_NO_MAIN -c -o $@ $<

$(BIN)/lrd_sha256: ingest/src/lrd_sha256.c $(BIN)/sha256.o | $(BIN)
	$(CC) $(CFLAGS) -std=c11 -o $@ $^ -lcrypto

$(BIN)/lrd_rec: ingest/src/lrd_rec.c | $(BIN)
	$(CC) $(CFLAGS) -std=c11 -D_POSIX_C_SOURCE=200809L -o $@ $< -lcrypto

$(BIN)/lrd_fitsx: ingest/src/lrd_fitsx.c | $(BIN)
	$(CC) $(CFLAGS) -std=c11 -o $@ $< -lcfitsio -lm

fortran:
	@if [ -f fortran/Makefile ]; then $(MAKE) -C fortran FC="$(FC)" CC="$(CC)"; fi

test: build
	sh tests/run_all.sh

clean:
	rm -rf $(OUT)
	@if [ -f fortran/Makefile ]; then $(MAKE) -C fortran clean; fi

rebuild: clean
	$(MAKE) build
