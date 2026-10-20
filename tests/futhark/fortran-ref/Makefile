# SPDX-License-Identifier: AGPL-3.0-only
# Also subject to the SnapKitty Opaque License; see LICENSE and
# SNAPKITTY_OPAQUE_LICENSE.md at the repository root.
# make predefines FC=f77; use gfortran unless FC is set explicitly
ifeq ($(origin FC),default)
FC = gfortran
endif
FFLAGS ?= -std=f2018 -O2 -Wall -Wextra -fimplicit-none -ffp-contract=off -Wno-compare-reals -ffpe-summary=none
B ?= build

all: $(B)/lrdref $(B)/test_lrd_kernels

$(B)/lrd_kernels.o: lrd_kernels.f90
	mkdir -p $(B)
	$(FC) $(FFLAGS) -J$(B) -c -o $@ lrd_kernels.f90

$(B)/lrd_io.o: lrd_io.f90
	mkdir -p $(B)
	$(FC) $(FFLAGS) -J$(B) -c -o $@ lrd_io.f90

$(B)/lrdref: lrdref.f90 $(B)/lrd_kernels.o $(B)/lrd_io.o
	$(FC) $(FFLAGS) -J$(B) -o $@ lrdref.f90 $(B)/lrd_kernels.o $(B)/lrd_io.o

$(B)/test_lrd_kernels: test_lrd_kernels.f90 $(B)/lrd_kernels.o
	$(FC) $(FFLAGS) -J$(B) -o $@ test_lrd_kernels.f90 $(B)/lrd_kernels.o

clean:
	rm -rf $(B)

.PHONY: all clean
