`define C #25000;
`define CHALF #12500;
`define CHALF2 #400;
module sccb_testbench;


  // testbench signals
  	reg clk, rst;
  	wire sccb_d;
  	reg read_req, write_req;
  	reg [7:0] write_data, write_addr, read_addr;
  	wire sccb_c;
  	wire [7:0] read_data; 
  	wire done;
  	
  reg sccb_dr;
  assign sccb_d = sccb_dr;
  reg clk100;
  wire ack;
  	
  sccb awesome_sccb(
  	.clk(clk100),
  	.rst(rst),
  	.sccb_d(sccb_d), 
  	.sccb_c(sccb_c), 
 	.read_request(read_req),
  	.write_request(write_req),
  	.write_data(write_data),
  	.write_addr(write_addr),
  	.read_addr(read_addr),
  	.read_data(read_data),
  	.done(done),
  	.request_ack(ack) 
  	);


 initial                   // drives clk at 40MHz
 begin
  clk100 <= 1'b0;
    forever
    begin	 
      clk100 <= 1'b0;
    	`CHALF2
      clk100 <= 1'b1;
      	`CHALF2
    end
  end 

//-------------------------------------
// SCCB Testbench cases
//-------------------------------------

// wires we can change:
//	reg clk, rst;
//  	reg sccb_d;
//  	reg read_req, write_req;
//  	reg [7:0] write_data, write_addr, read_addr;

  initial
  begin
  	rst=0;
  	sccb_dr=1'bZ;
  	read_req=0;
  	write_req=0;
  	write_data=8'h00;
  	write_addr=8'h00;
  	read_addr=8'h00;
	`C
	rst=1;
	`C
	rst=0;
	`C
	`C
	`C
	`C
	write_req=1;
	write_data=8'hFF;
	write_addr=8'h22;
	wait(ack==1);
	write_req=0;
	wait(done==1);
	`C
	`C
	write_req=1;
	write_data=8'hEE;
	write_addr=8'h33;
	`C
	write_req=0;
	wait(done==1);
	`C
	`C
	read_req=1;
	read_addr=8'h13;
	wait(ack==1);
	read_req=0;
	wait(done==1);
	
	
  end

endmodule