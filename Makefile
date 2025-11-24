VERILATOR ?= verilator
TOP       ?= alu_tb

SRC_RTL   := rtl/top_alu_16.v rtl/74181.v rtl/74182_CLA.v
SRC_TB    := tb/alu_if.sv tb/alu_tb.sv
C_SOURCES := sim_main.cpp

OBJ_DIR   := obj_dir
EXE       := $(OBJ_DIR)/V$(TOP)

.PHONY: all run build clean

all: run

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

build: $(EXE)

$(EXE): $(SRC_RTL) $(SRC_TB) $(C_SOURCES) | $(OBJ_DIR)
	$(VERILATOR) -Wall -sv --cc $(SRC_RTL) $(SRC_TB) \
	  -Wno-DECLFILENAME -Wno-TIMESCALEMOD -Wno-GENUNNAMED \
	  -Wno-UNUSEDPARAM -Wno-UNUSEDSIGNAL -Wno-EOFNEWLINE \
	  --top-module $(TOP) \
	  --exe $(C_SOURCES)
	$(MAKE) -C $(OBJ_DIR) -f V$(TOP).mk -j$$(nproc)

run: $(EXE)
	$(EXE)

clean:
	rm -rf $(OBJ_DIR)



