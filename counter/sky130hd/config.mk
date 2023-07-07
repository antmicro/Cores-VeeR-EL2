export DESIGN_NICKNAME  = counter
export DESIGN_NAME      = counter
export PLATFORM         = sky130hd

# Path relative to third_party/OpenROAD-flow-scripts/flow
export VERILOG_FILES    = ../../../counter/counter.sv
export SDC_FILE         = ../../../counter/$(PLATFORM)/constraint.sdc

export CORE_UTILIZATION = 40
export PLACE_DENSITY    = 0.6
export TNS_END_PERCENT  = 100

