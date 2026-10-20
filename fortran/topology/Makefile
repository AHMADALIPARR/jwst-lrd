# Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
# SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
# Licensed under AGPL-3.0-only plus the SnapKitty Opaque License (dual license, intentional).
#
# Fortran 2018 reference implementation of the simplicial topology ledger.
FC      := /usr/bin/gfortran
FFLAGS  ?= -std=f2018 -Wall -Wextra -fcheck=all -g -O1
BUILD   := build
SRC     := src
MODS    := topo_sha256 topo_field topo_complex topo_homology topo_record topo_commit \
           topo_incremental topo_fixtures topo_export
OBJS    := $(addprefix $(BUILD)/,$(addsuffix .o,$(MODS)))
LIB     := $(BUILD)/libtopology.a

.PHONY: all clean
all: $(LIB)

$(BUILD):
	mkdir -p $(BUILD)

$(BUILD)/%.o: $(SRC)/%.f90 | $(BUILD)
	$(FC) $(FFLAGS) -J$(BUILD) -c $< -o $@

# module dependency order
$(BUILD)/topo_field.o: $(BUILD)/topo_sha256.o
$(BUILD)/topo_complex.o: $(BUILD)/topo_field.o
$(BUILD)/topo_homology.o: $(BUILD)/topo_complex.o $(BUILD)/topo_field.o
$(BUILD)/topo_record.o: $(BUILD)/topo_sha256.o
$(BUILD)/topo_commit.o: $(BUILD)/topo_record.o $(BUILD)/topo_homology.o
$(BUILD)/topo_incremental.o: $(BUILD)/topo_commit.o
$(BUILD)/topo_fixtures.o: $(BUILD)/topo_complex.o
$(BUILD)/topo_export.o: $(BUILD)/topo_commit.o

$(LIB): $(OBJS)
	ar rcs $@ $^

clean:
	rm -rf $(BUILD)
