// Amazon FPGA Hardware Development Kit
//
// Copyright 2016 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//
// Licensed under the Amazon Software License (the "License"). You may not use
// this file except in compliance with the License. A copy of the License is
// located at
//
//    http://aws.amazon.com/asl/
//
// or in the "license" file accompanying this file. This file is distributed on
// an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, express or
// implied. See the License for the specific language governing permissions and
// limitations under the License.

`define MAT_MAX 2047     // 8 * 32 * 32 - 1
`define VEC_MAX 127  // 8 * 32 - 1
`define DIMENSION 16

module test_hello_world();

import tb_type_defines_pkg::*;
`include "cl_common_defines.vh" // CL Defines with register addresses

// AXI ID
parameter [5:0] AXI_ID = 6'h0;

logic [31:0] rdata;
logic [15:0] vdip_value;
logic [15:0] vled_value;


   initial begin

      tb.power_up();

      tb.set_virtual_dip_switch(.dip(0));

      vdip_value = tb.get_virtual_dip_switch();

    //  $display ("value of vdip:%0x", vdip_value);

    //  $display ("Writing 0xDEAD_BEEF to address 0x%x", `HELLO_WORLD_REG_ADDR);
      for (int i = 0; i < `DIMENSION * `DIMENSION * 8 / 32; i=i+1)begin
          tb.poke(.addr(`HELLO_WORLD_REG_ADDR), .data(32'h00000001), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL)); // write register
      end
      for (int j = 0; j < `DIMENSION * 8 / 32; j = j+1)begin
          tb.poke(.addr(`HELLO_WORLD_REG_ADDR), .data(32'h02020202), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL)); // write register
      end
      tb.poke(.addr(`HELLO_WORLD_REG_ADDR), .data(32'h00000003), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL)); 

      #3;

      for (int k = 0; k < `DIMENSION * 8 / 32; k = k+1)begin
          tb.peek(.addr(`HELLO_WORLD_REG_ADDR), .data(rdata), .id(AXI_ID), .size(DataSize::UINT16), .intf(AxiPort::PORT_OCL));         // start read & write
          $display ("Reading 0x%x from address 0x%x", rdata, `HELLO_WORLD_REG_ADDR);
      end

      tb.kernel_reset();

      tb.power_down();
      
      $finish;
   end

endmodule // test_hello_world
