VERILATOR ?= verilator
TOP       ?= alu_tb

SRC_RTL    := rtl/top_alu_16.v rtl/74181.v rtl/74182_CLA.v
SRC_TB     := tb/alu_if.sv tb/alu_monitor.sv tb/alu_tb.sv
SRC_TESTS  := $(wildcard tests/*.sv)
C_SOURCES  := sim_main.cpp

ERROR_IGNORE := -Wno-DECLFILENAME \
				-Wno-TIMESCALEMOD \
				-Wno-GENUNNAMED \
				-Wno-UNUSEDPARAM \
				-Wno-UNUSEDSIGNAL \
				-Wno-EOFNEWLINE

OBJ_DIR   := obj_dir
EXE       := $(OBJ_DIR)/V$(TOP)

.PHONY: all run build clean

all: run

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

build: $(EXE)

$(EXE): $(SRC_RTL) $(SRC_TB) $(SRC_TESTS) $(C_SOURCES) | $(OBJ_DIR)
	$(VERILATOR) --cc -sv --timing --exe --build --top-module $(TOP) $(SRC_RTL) $(SRC_TB) \
	-Wall $(ERROR_IGNORE) \
	$(C_SOURCES)

run: $(EXE)
	$(EXE)

clean:
	rm -rf $(OBJ_DIR)



