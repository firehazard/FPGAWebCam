//------------------------------------------------------------------------
//-- Title      : Clock Divider
//-- Project    : Tri-Mode Ethernet MAC
//------------------------------------------------------------------------
//-- File       : clk_half.v
//-- Author     : Xilinx Inc.
//------------------------------------------------------------------------
//-- Copyright (c) 2004 Xilinx Inc.
//------------------------------------------------------------------------
//-- Description:  Take CLK input and generate CLK/2 
//--               This is used to generate the core clock signals from 
//--               the GMII/MII clock inputs at 10Mb/s and 100Mb/s.    

module clk_half
  (reset,
   clk,
   clk_div2
    );

  input  reset;
  input  clk;
  output clk_div2;

  // synthesis attribute ASYNC_REG of reg1_out is "TRUE";

  reg  reg1_out;
  wire reg1_out_inv;
  
  always @(posedge clk or posedge reset)
  begin
    if (reset == 1'b1)
      reg1_out    <= 1'b0;
    else
      reg1_out    <= reg1_out_inv;
  end

  assign reg1_out_inv = ~(reg1_out);  
  assign clk_div2     = reg1_out;
  
endmodule




