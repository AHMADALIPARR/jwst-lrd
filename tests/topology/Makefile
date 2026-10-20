# Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
# SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
# Licensed under AGPL-3.0-only plus the SnapKitty Opaque License (dual license, intentional).
#
# make test   -> runs ./run.sh (PASS/FAIL/UNAVAILABLE lines; nonzero exit only on FAIL)
FC     := /usr/bin/gfortran
FFLAGS := -std=f2018 -Wall -Wextra -fcheck=all -g -O1
TOPO   := ../../fortran/topology
.PHONY: test driver lib clean
test:
	nice -n 19 ./run.sh
lib:
	nice -n 19 $(MAKE) -C $(TOPO)
driver: lib
	mkdir -p build
	nice -n 19 $(FC) $(FFLAGS) -I$(TOPO)/build -Jbuild test_topology.f90 $(TOPO)/build/libtopology.a -o build/test_topology
clean:
	rm -rf build
