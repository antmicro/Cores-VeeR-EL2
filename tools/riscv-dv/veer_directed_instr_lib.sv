// SPDX-License-Identifier: Apache-2.0
// Copyright (c) 2018 Google LLC
// Copyright (c) 2020 Andes Technology Co., Ltd.
// Copyright (c) 2024 Antmicro <www.antmicro.com>
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

class veer_load_store_rand_addr_instr_stream extends riscv_load_store_base_instr_stream;

  rand bit [XLEN-1:0] addr_offset;

  // Find an unused 4K page from address 1M onward
  constraint addr_offset_c {
    |addr_offset[XLEN-1:20] == 1'b1;
    addr_offset[XLEN-1:26] == 0;
    addr_offset[11:0] == 0;
  }

  constraint legal_c {
    num_load_store inside {[5:10]};
    num_mixed_instr inside {[5:10]};
  }

  `uvm_object_utils(veer_load_store_rand_addr_instr_stream)
  `uvm_object_new

   virtual function void randomize_offset();
    int offset_, addr_;
    offset = new[num_load_store];
    addr = new[num_load_store];
    for (int i=0; i<num_load_store; i++) begin
      if (!std::randomize(offset_) with {
          offset_ inside {[-2048:2047]};
        }
      ) begin
        `uvm_fatal(`gfn, "Cannot randomize load/store offset")
      end
      offset[i] = offset_;
      addr[i] = addr_offset + offset_;
    end
  endfunction

  virtual function void add_rs1_init_la_instr(riscv_reg_t gpr, int id, int base = 0);
    riscv_instr instr[$];
    riscv_pseudo_instr li_instr;
    riscv_instr store_instr;
    riscv_instr add_instr;
    int min_offset[$];
    int max_offset[$];
    min_offset = offset.min();
    max_offset = offset.max();
    // Use LI to initialize the address offset
    li_instr = riscv_pseudo_instr::type_id::create("li_instr");
    `DV_CHECK_RANDOMIZE_WITH_FATAL(li_instr,
       pseudo_instr_name == LI;
       rd inside {cfg.gpr};
       rd != gpr;
    )
    li_instr.imm_str = $sformatf("0x%0x", addr_offset);
    // Add offset to the base address
    add_instr = riscv_instr::get_instr(ADD);
    `DV_CHECK_RANDOMIZE_WITH_FATAL(add_instr,
       rs1 == gpr;
       rs2 == li_instr.rd;
       rd  == gpr;
    )
    instr.push_back(li_instr);
    instr.push_back(add_instr);
    // Create SW instruction template
    store_instr = riscv_instr::get_instr(SB);
    `DV_CHECK_RANDOMIZE_WITH_FATAL(store_instr,
       instr_name == SB;
       rs1 == gpr;
    )
    // Initialize the location which used by load instruction later
    foreach (load_store_instr[i]) begin
      if (load_store_instr[i].category == LOAD) begin
        riscv_instr store;
        store = riscv_instr::type_id::create("store");
        store.copy(store_instr);
        store.rs2 = riscv_reg_t'(i % 32);
        store.imm_str = load_store_instr[i].imm_str;
        // TODO: C_FLDSP is in both rv32 and rv64 ISA
        case (load_store_instr[i].instr_name) inside
          LB, LBU : store.instr_name = SB;
          LH, LHU : store.instr_name = SH;
          LW, C_LW, C_LWSP, FLW, C_FLW, C_FLWSP : store.instr_name = SW;
          LD, C_LD, C_LDSP, FLD, C_FLD, LWU     : store.instr_name = SD;
          default : `uvm_fatal(`gfn, $sformatf("Unexpected op: %0s",
                                               load_store_instr[i].convert2asm()))
        endcase
        instr.push_back(store);
      end
    end
    instr_list = {instr, instr_list};
    super.add_rs1_init_la_instr(gpr, id, 0);
  endfunction

endclass
