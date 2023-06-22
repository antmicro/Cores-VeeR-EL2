export DESIGN_NICKNAME  = counter
export DESIGN_NAME      = counter
export PLATFORM         = asap7

# Path relative to third_party/OpenROAD-flow-scripts/flow
export VERILOG_FILES    = ../../../counter/counter.v
export SDC_FILE         = ../../../counter/$(PLATFORM)/constraint.sdc

export CORE_UTILIZATION = 40
export PLACE_DENSITY    = 0.61
export TNS_END_PERCENT  = 100

