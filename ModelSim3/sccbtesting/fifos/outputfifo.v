/*******************************************************************************
*     This file is owned and controlled by Xilinx and must be used             *
*     solely for design, simulation, implementation and creation of            *
*     design files limited to Xilinx devices or technologies. Use              *
*     with non-Xilinx devices or technologies is expressly prohibited          *
*     and immediately terminates your license.                                 *
*                                                                              *
*     XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"            *
*     SOLELY FOR USE IN DEVELOPING PROGRAMS AND SOLUTIONS FOR                  *
*     XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION          *
*     AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE, APPLICATION              *
*     OR STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS                *
*     IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,                  *
*     AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE         *
*     FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY                 *
*     WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE                  *
*     IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR           *
*     REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF          *
*     INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS          *
*     FOR A PARTICULAR PURPOSE.                                                *
*                                                                              *
*     Xilinx products are not intended for use in life support                 *
*     appliances, devices, or systems. Use in such applications are            *
*     expressly prohibited.                                                    *
*                                                                              *
*     (c) Copyright 1995-2004 Xilinx, Inc.                                     *
*     All rights reserved.                                                     *
*******************************************************************************/
// The synopsys directives "translate_off/translate_on" specified below are
// supported by XST, FPGA Compiler II, Mentor Graphics and Synplicity synthesis
// tools. Ensure they are correct for your synthesis tool(s).

// You must compile the wrapper file outputfifo.v when simulating
// the core, outputfifo. When compiling the wrapper file, be sure to
// reference the XilinxCoreLib Verilog simulation library. For detailed
// instructions, please refer to the "CORE Generator Guide".

module outputfifo (
	din,
	wr_en,
	wr_clk,
	rd_en,
	rd_clk,
	ainit,
	dout,
	full,
	empty,
	rd_count);

input [7 : 0] din;
input wr_en;
input wr_clk;
input rd_en;
input rd_clk;
input ainit;
output [7 : 0] dout;
output full;
output empty;
output [6 : 0] rd_count;

// synopsys translate_off

	ASYNC_FIFO_V6_0 #(
		8,	// c_data_width
		0,	// c_enable_rlocs
		127,	// c_fifo_depth
		0,	// c_has_almost_empty
		0,	// c_has_almost_full
		0,	// c_has_rd_ack
		1,	// c_has_rd_count
		0,	// c_has_rd_err
		0,	// c_has_wr_ack
		0,	// c_has_wr_count
		0,	// c_has_wr_err
		0,	// c_rd_ack_low
		7,	// c_rd_count_width
		0,	// c_rd_err_low
		1,	// c_use_blockmem
		0,	// c_wr_ack_low
		2,	// c_wr_count_width
		0)	// c_wr_err_low
	inst (
		.DIN(din),
		.WR_EN(wr_en),
		.WR_CLK(wr_clk),
		.RD_EN(rd_en),
		.RD_CLK(rd_clk),
		.AINIT(ainit),
		.DOUT(dout),
		.FULL(full),
		.EMPTY(empty),
		.RD_COUNT(rd_count),
		.ALMOST_FULL(),
		.ALMOST_EMPTY(),
		.WR_COUNT(),
		.RD_ACK(),
		.RD_ERR(),
		.WR_ACK(),
		.WR_ERR());


// synopsys translate_on

endmodule

