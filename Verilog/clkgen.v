module clkgen(clk100,camclk);
    input clk100;
    output camclk;

       

	wire clk_i;
	wire clk_div5;
	wire clk40;
	wire dcm1_locked;

	assign camclk = clk_i; 

	// Instantiate DCM to generate 40MHz clock from 100MHz input
	// Later, we will change this to a 20MHz clock. 
	DCM clk_dcm_inst1 (
 	 .CLK0     (clk_i),       // O   // Main output
  	.CLK180   (),            // O
  	.CLK270   (),            // O
  	.CLK2X    (),            // O
  	.CLK2X180 (),            // O
  	.CLK90    (),            // O
  	.CLKDV    (clk_div5),    // O  // Divide by 5 output
  	.CLKFB    (clk_i),       // I  // bufg should be inferred for feedback
  	.CLKFX    (clk40),       // O
  	.CLKFX180 (),            // O
  	.CLKIN    (clk100),      // I   // CLK in
  	.DSSEN    (1'b0),        // I
  	.LOCKED   (dcm1_locked), // O   // reset to the rest of the circuit
  	.PSCLK    (1'b0),        // I
  	.PSDONE   (),            // O
  	.PSEN     (1'b0),        // I
  	.PSINCDEC (1'b0),        // I
  	.RST      (1'b0),        // I   // DCMs start upon programming
  	.STATUS   ()             // O
  	);
    // synthesis attribute CLKDV_DIVIDE       of clk_dcm_inst1 is "5"
    // synthesis attribute CLKFX_MULTIPLY     of clk_dcm_inst1 is "2"
    // synthesis attribute DLL_FREQUENCY_MODE of clk_dcm_inst1 is "LOW"
    // synthesis attribute DFS_FREQUENCY_MODE of clk_dcm_inst1 is "LOW"
    // synthesis attribute CLKIN_PERIOD       of clk_dcm_inst1 is "10"

   /* synthesis translate_off */
   // Set the clock multiplier ratio for the CPU
   	defparam clk_dcm_inst1.CLKFX_MULTIPLY = 2;
   	defparam clk_dcm_inst1.CLKFX_DIVIDE = 5;
   	defparam clk_dcm_inst1.DLL_FREQUENCY_MODE = "LOW";
   	defparam clk_dcm_inst1.DFS_FREQUENCY_MODE = "LOW";
   	defparam clk_dcm_inst1.CLKIN_PERIOD = 10;
   /* synthesis translate_on */
endmodule
