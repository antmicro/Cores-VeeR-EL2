export DESIGN_NICKNAME  = el2_veer_wrapper
export DESIGN_NAME      = el2_veer_wrapper
export PLATFORM         = sky130hd

# Path relative to third_party/OpenROAD-flow-scripts/flow
export VERILOG_INCLUDE_DIRS = ../../../tools/openroad/build/inc
export VERILOG_FILES    = \
                          ../../../tools/openroad/build/src/el2_pic_ctrl.sv \
                          ../../../tools/openroad/build/src/lib/el2_lib.sv \
                          ../../../tools/openroad/build/src/lib/beh_lib.sv \
                          ../../../tools/openroad/build/src/lib/ahb_to_axi4.sv \
                          ../../../tools/openroad/build/src/lib/axi4_to_ahb.sv \
                          ../../../tools/openroad/build/src/lib/mem_lib.sv \
                          ../../../tools/openroad/build/src/el2_veer_wrapper.sv \
                          ../../../tools/openroad/build/src/dbg/el2_dbg.sv \
                          ../../../tools/openroad/build/src/ifu/el2_ifu_iccm_mem.sv \
                          ../../../tools/openroad/build/src/ifu/el2_ifu_ic_mem.sv \
                          ../../../tools/openroad/build/src/ifu/el2_ifu_aln_ctl.sv \
                          ../../../tools/openroad/build/src/ifu/el2_ifu_ifc_ctl.sv \
                          ../../../tools/openroad/build/src/ifu/el2_ifu_bp_ctl.sv \
                          ../../../tools/openroad/build/src/ifu/el2_ifu.sv \
                          ../../../tools/openroad/build/src/ifu/el2_ifu_mem_ctl.sv \
                          ../../../tools/openroad/build/src/ifu/el2_ifu_compress_ctl.sv \
                          ../../../tools/openroad/build/src/lsu/el2_lsu_stbuf.sv \
                          ../../../tools/openroad/build/src/lsu/el2_lsu_addrcheck.sv \
                          ../../../tools/openroad/build/src/lsu/el2_lsu_dccm_mem.sv \
                          ../../../tools/openroad/build/src/lsu/el2_lsu_bus_buffer.sv \
                          ../../../tools/openroad/build/src/lsu/el2_lsu_clkdomain.sv \
                          ../../../tools/openroad/build/src/lsu/el2_lsu_ecc.sv \
                          ../../../tools/openroad/build/src/lsu/el2_lsu.sv \
                          ../../../tools/openroad/build/src/lsu/el2_lsu_dccm_ctl.sv \
                          ../../../tools/openroad/build/src/lsu/el2_lsu_trigger.sv \
                          ../../../tools/openroad/build/src/lsu/el2_lsu_bus_intf.sv \
                          ../../../tools/openroad/build/src/lsu/el2_lsu_lsc_ctl.sv \
                          ../../../tools/openroad/build/src/el2_dma_ctrl.sv \
                          ../../../tools/openroad/build/src/el2_veer.sv \
                          ../../../tools/openroad/build/src/el2_mem.sv \
                          ../../../tools/openroad/build/src/dec/el2_dec_gpr_ctl.sv \
                          ../../../tools/openroad/build/src/dec/el2_dec.sv \
                          ../../../tools/openroad/build/src/dec/el2_dec_tlu_ctl.sv \
                          ../../../tools/openroad/build/src/dec/el2_dec_trigger.sv \
                          ../../../tools/openroad/build/src/dec/el2_dec_ib_ctl.sv \
                          ../../../tools/openroad/build/src/dec/el2_dec_decode_ctl.sv \
                          ../../../tools/openroad/build/src/exu/el2_exu_mul_ctl.sv \
                          ../../../tools/openroad/build/src/exu/el2_exu.sv \
                          ../../../tools/openroad/build/src/exu/el2_exu_alu_ctl.sv \
                          ../../../tools/openroad/build/src/exu/el2_exu_div_ctl.sv \
                          ../../../tools/openroad/build/src/include/el2_def.sv \
                          ../../../tools/openroad/build/src/dmi/dmi_wrapper.v \
                          ../../../tools/openroad/build/src/dmi/rvjtag_tap.v \
                          ../../../tools/openroad/build/src/dmi/dmi_jtag_to_core_sync.v \


export SDC_FILE         = ../../../tools/openroad/configs/$(PLATFORM)/constraint.sdc

export CORE_UTILIZATION = 40
export PLACE_DENSITY    = 0.6
export TNS_END_PERCENT  = 100

