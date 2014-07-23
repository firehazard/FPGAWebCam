module edge_detect(clk, in, out);

	input clk;
	input in;
	output out;

	wire in_reg;

	dff dff1(.clk(clk),.d(in), .q(in_reg));

	// "out" is high only if "in" wasn't
	// high in the previous cycle.
	assign out = in & (~in_reg);

endmodule