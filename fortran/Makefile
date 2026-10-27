# SPDX-License-Identifier: AGPL-3.0-only
# Also subject to SNAPKITTY_OPAQUE_LICENSE.md (dual license, see repository root).
# Fortran 2018 kernel; CFITSIO only behind src/lrd_fits_shim.c (ISO_C_BINDING boundary).
ifeq ($(origin FC),default)
FC := gfortran
endif
# GNU make predefines CC=cc and FC=f77, so a plain "?=" never takes effect; override
# only the built-in default (an environment or command-line value still wins).
ifeq ($(origin CC),default)
CC := gcc
endif
FFLAGS ?= -O2 -Wall -std=f2018 -fimplicit-none
CFLAGS ?= -O2 -Wall -Wextra
B      := ../build/out/fortran
BIN    := ../build/out/bin
MODS   := lrd_const lrd_units lrd_cosmo lrd_stats lrd_lines lrd_arr lrd_fits
OBJS   := $(MODS:%=$(B)/%.o) $(B)/lrd_fits_shim.o

.PHONY: all clean
all: $(BIN)/lrd_reference $(BIN)/lrd_ftest $(BIN)/lrd_zinvest

$(B) $(BIN):
	mkdir -p $@

$(B)/lrd_fits_shim.o: src/lrd_fits_shim.c | $(B)
	$(CC) $(CFLAGS) -c -o $@ $<

# Module dependency chain (compiled in order)
$(B)/lrd_const.o: src/lrd_const.f90 | $(B)
	$(FC) $(FFLAGS) -J$(B) -c -o $@ $<
$(B)/lrd_units.o: src/lrd_units.f90 $(B)/lrd_const.o
	$(FC) $(FFLAGS) -J$(B) -c -o $@ $<
$(B)/lrd_cosmo.o: src/lrd_cosmo.f90 $(B)/lrd_const.o
	$(FC) $(FFLAGS) -J$(B) -c -o $@ $<
$(B)/lrd_stats.o: src/lrd_stats.f90 $(B)/lrd_const.o
	$(FC) $(FFLAGS) -J$(B) -c -o $@ $<
$(B)/lrd_lines.o: src/lrd_lines.f90 $(B)/lrd_stats.o
	$(FC) $(FFLAGS) -J$(B) -c -o $@ $<
$(B)/lrd_arr.o: src/lrd_arr.f90 $(B)/lrd_const.o
	$(FC) $(FFLAGS) -J$(B) -c -o $@ $<
$(B)/lrd_fits.o: src/lrd_fits.f90 | $(B)
	$(FC) $(FFLAGS) -J$(B) -c -o $@ $<

$(BIN)/lrd_reference: app/lrd_reference.f90 $(OBJS) | $(BIN)
	$(FC) $(FFLAGS) -I$(B) -o $@ $< $(OBJS) -lcfitsio

$(BIN)/lrd_zinvest: app/lrd_zinvest.f90 $(OBJS) | $(BIN)
	$(FC) $(FFLAGS) -I$(B) -o $@ $< $(OBJS) -lcfitsio

$(BIN)/lrd_ftest: ../tests/fortran/test_kernel.f90 $(OBJS) | $(BIN)
	$(FC) $(FFLAGS) -I$(B) -o $@ $< $(OBJS) -lcfitsio

clean:
	rm -rf $(B) $(BIN)/lrd_reference $(BIN)/lrd_ftest $(BIN)/lrd_zinvest
