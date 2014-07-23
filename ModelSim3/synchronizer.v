module synchronizer(clk1, clk2, rst, in, out);
parameter w=1;
	input clk1;
	input clk2;
	input rst;
	input [w-1:0] in;
	output [w-1:0] out;
	wire  [w-1:0] q1;
	dffr #(w) flopOne   (in, rst, clk1, q1);
	dffr #(w) flopTwo   (q1, rst, clk2, out);
endmodule