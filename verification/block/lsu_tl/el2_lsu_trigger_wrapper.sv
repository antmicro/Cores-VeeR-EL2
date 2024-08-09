// Copyright (c) 2023 Antmicro
// SPDX-License-Identifier: Apache-2.0
module el2_lsu_trigger_wrapper
  import el2_pkg::*;
#(
    `include "el2_param.vh"
) (
    // Unpacked [3:0] trigger_pkt_t
    input logic [3:0] select,
    input logic [3:0] match,
    input logic [3:0] store,
    input logic [3:0] load,
    input logic [3:0] execute,
    input logic [3:0] m,

    // Fields from lsu_pkt_m relevant in this test
    input logic word,
    input logic half,
    input logic dma,
    input logic valid,
    input logic store,

    input logic [31:0] lsu_addr_m,         // address
    input logic [31:0] store_data_m,       // store data

    output logic [3:0] lsu_trigger_match_m // match result
);

  // Pack triggers
  el2_trigger_pkt_t [3:0] trigger_pkt_any;
  for (genvar i = 0; i < 4; i++) begin : g_trigger_assigns
    assign trigger_pkt_any[i].select  = select[i];
    assign trigger_pkt_any[i].match   = match[i];
    assign trigger_pkt_any[i].store   = store[i];
    assign trigger_pkt_any[i].load    = load[i];
    assign trigger_pkt_any[i].execute = execute[i];
    assign trigger_pkt_any[i].m       = m[i];
    assign trigger_pkt_any[i].tdata2  = tdata[i];
  end

  // Pack lsu_pkt_m
  el2_lsu_pkt_t lsu_pkt_m
  assing lsu_pkt_m.word  = word;
  assing lsu_pkt_m.half  = half;
  assing lsu_pkt_m.dma   = dma;
  assing lsu_pkt_m.valid = valid;
  assing lsu_pkt_m.store = store;

  // The trigger unit
  el2_lsu_trigger tu (
      .lsu_i0_pc_d(lsu_i0_pc_d[31:1]),
      .*
  );

endmodule
