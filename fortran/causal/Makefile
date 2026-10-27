# Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
# Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
# SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
#
# TASK 006 causal poset -- Fortran 2018 library and test programs.
#   make            build build/libcausal.a and all test programs
#   make test       run tests/causal/run.sh (Fortran + Curry + Self); nonzero on any FAIL
#   make ftest      run only the Fortran test programs; nonzero on any FAIL
#   make clean
FC      := /usr/bin/gfortran
FFLAGS  := -std=f2018 -Wall -Wextra -fcheck=all -g -O1 -fimplicit-none
NICE    := nice -n 19
BLD     := build
TESTSRC := ../../tests/causal

SRCS := causal_units causal_interval causal_coords causal_frames causal_events \
        causal_classify causal_digraph causal_graph causal_sha256 causal_hexfloat \
        causal_lrdrec causal_serial
OBJS := $(addprefix $(BLD)/,$(addsuffix .o,$(SRCS)))
LIB  := $(BLD)/libcausal.a

TESTS := test_units_interval test_classify test_edges test_dag test_boost test_serial \
         test_fixture
TBIN  := $(addprefix $(BLD)/,$(TESTS))

.PHONY: all test ftest clean
all: $(LIB) $(TBIN)

$(BLD):
	mkdir -p $(BLD)

# Modules are compiled strictly in dependency order (the SRCS order above).
$(BLD)/causal_units.o:    src/causal_units.f90 | $(BLD)
$(BLD)/causal_interval.o: src/causal_interval.f90 $(BLD)/causal_units.o
$(BLD)/causal_coords.o:   src/causal_coords.f90 $(BLD)/causal_interval.o
$(BLD)/causal_frames.o:   src/causal_frames.f90 $(BLD)/causal_coords.o
$(BLD)/causal_events.o:   src/causal_events.f90 $(BLD)/causal_coords.o
$(BLD)/causal_classify.o: src/causal_classify.f90 $(BLD)/causal_frames.o $(BLD)/causal_events.o
$(BLD)/causal_digraph.o:  src/causal_digraph.f90 | $(BLD)
$(BLD)/causal_graph.o:    src/causal_graph.f90 $(BLD)/causal_classify.o $(BLD)/causal_digraph.o
$(BLD)/causal_sha256.o:   src/causal_sha256.f90 | $(BLD)
$(BLD)/causal_hexfloat.o: src/causal_hexfloat.f90 | $(BLD)
$(BLD)/causal_lrdrec.o:   src/causal_lrdrec.f90 $(BLD)/causal_sha256.o
$(BLD)/causal_serial.o:   src/causal_serial.f90 $(BLD)/causal_graph.o $(BLD)/causal_hexfloat.o $(BLD)/causal_lrdrec.o

$(BLD)/%.o: src/%.f90
	$(NICE) $(FC) $(FFLAGS) -J$(BLD) -c $< -o $@

$(LIB): $(OBJS)
	rm -f $@
	ar rcs $@ $(OBJS)

$(BLD)/test_util.o: $(TESTSRC)/test_util.f90 | $(BLD)
	$(NICE) $(FC) $(FFLAGS) -J$(BLD) -c $< -o $@

$(BLD)/fixture_graph.o: $(TESTSRC)/fixture_graph.f90 $(LIB) | $(BLD)
	$(NICE) $(FC) $(FFLAGS) -J$(BLD) -c $< -o $@

$(BLD)/test_%: $(TESTSRC)/test_%.f90 $(LIB) $(BLD)/test_util.o $(BLD)/fixture_graph.o
	$(NICE) $(FC) $(FFLAGS) -I$(BLD) $< $(BLD)/test_util.o $(BLD)/fixture_graph.o $(LIB) -o $@

ftest: all
	@mkdir -p $(TESTSRC)/out
	@fail=0; for t in $(TESTS); do (cd $(TESTSRC) && $(NICE) ../../fortran/causal/$(BLD)/$$t) || fail=1; done; exit $$fail

test: all
	$(NICE) bash $(TESTSRC)/run.sh

clean:
	rm -rf $(BLD)
