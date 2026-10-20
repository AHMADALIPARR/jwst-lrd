# SPDX-License-Identifier: AGPL-3.0-only
# Also subject to SNAPKITTY_OPAQUE_LICENSE.md (dual license, see repository root).
# QSO1 growth solver (Mission QSO1-DCBH-001 role 04). Reuses the kernel modules
# lrd_const/lrd_cosmo and the causal track's LRD-REC-v1 writer + SHA-256
# (linked, not modified; fortran/causal is owned by its own track).
FC     ?= gfortran
FFLAGS ?= -O2 -Wall -std=f2018 -fimplicit-none
B      := ../../build/out/growth
BIN    := ../../build/out/bin

.PHONY: all clean
all: $(BIN)/lrd_growth_sweep

$(B) $(BIN):
	mkdir -p $@

$(B)/lrd_const.o: ../src/lrd_const.f90 | $(B)
	$(FC) $(FFLAGS) -J$(B) -c -o $@ $<
$(B)/lrd_cosmo.o: ../src/lrd_cosmo.f90 $(B)/lrd_const.o
	$(FC) $(FFLAGS) -J$(B) -c -o $@ $<
$(B)/causal_sha256.o: ../causal/src/causal_sha256.f90 | $(B)
	$(FC) $(FFLAGS) -J$(B) -c -o $@ $<
$(B)/causal_lrdrec.o: ../causal/src/causal_lrdrec.f90 $(B)/causal_sha256.o
	$(FC) $(FFLAGS) -J$(B) -c -o $@ $<
$(B)/lrd_growth.o: src/lrd_growth.f90 $(B)/lrd_const.o $(B)/lrd_cosmo.o
	$(FC) $(FFLAGS) -J$(B) -c -o $@ $<

$(BIN)/lrd_growth_sweep: app/lrd_growth_sweep.f90 $(B)/lrd_const.o $(B)/lrd_cosmo.o \
		$(B)/causal_sha256.o $(B)/causal_lrdrec.o $(B)/lrd_growth.o | $(BIN)
	$(FC) $(FFLAGS) -I$(B) -o $@ $< $(B)/lrd_const.o $(B)/lrd_cosmo.o \
		$(B)/causal_sha256.o $(B)/causal_lrdrec.o $(B)/lrd_growth.o

clean:
	rm -rf $(B) $(BIN)/lrd_growth_sweep
