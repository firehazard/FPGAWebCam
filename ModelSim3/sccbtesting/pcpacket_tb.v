`define C #800;

module pcpacket_testbench;

  // testbench signals
  reg clk, camclk, rst;
  reg sccb_dr;
  assign sccb_d = sccb_dr;
 
  reg [7:0] datain;
  reg datainvalid, fifoenable;
  wire [7:0] dataout;
  

  pcpacket dut
  	(.rxclk(clk),
  	 .rxreset(rst),
  	 .rx_data(datain),
  	 .rx_valid(datainvalid),
  	 .fifoOver(),
  	 .sccb_d(sccb_d),
  	 .sccb_c(),
  	 .readenpack(fifoenable),
  	 .camclk(camclk),
  	 .outfifodata(dataout),
  	 .outfifoready()
  	 
  	 );


 initial                   // drives clk at 12.5MHz
    begin
    
  forever
    begin	 
      clk <= 1'b1;
    	#400;
      clk <= 1'b0;
      	#400;
    end
  end
  
 initial                   // drives clk at 40MHz
    begin
    forever
   begin	 
      camclk <= 1'b1;
    	#125;
      camclk <= 1'b0;
      	#125;
   end
end

initial
begin
fifoenable=1'b0;
#6000000
fifoenable=1'b1;
`C
`C
`C
fifoenable=1'b0;
end


integer i;
  initial
  begin
	rst=1'b1;
	datain=8'd0;
	datainvalid=1'b0;
	sccb_dr = 1'bZ;
	`C `C
	rst=1'b0;
	`C
	datain=8'h50;
	datainvalid=1'b1;
	for (i=0;i<12;i=i+1) `C
	datain=8'hEE; //type length
	`C
	datain=8'hBB; //type length
	`C
	`C
	datain=8'hFF; //is a write
	`C
	datain=8'h13;
	`C
	datain=8'hCC;
	`C
	datainvalid=1'd0;
	`C
	`C
	datain=8'h50;
	datainvalid=1'b1;
	for (i=0;i<12;i=i+1) `C
	datain=8'hEE; //type length
	`C
	datain=8'hBB; //type length
	`C
	`C
	datain=8'h00; //is a read
	`C
	datain=8'h13;
	`C
	datain=8'hCC;
	`C
	datainvalid=1'd0;
	`C
	`C
	datain=8'h50;
	datainvalid=1'b1;
	for (i=0;i<12;i=i+1) `C
	datain=8'hEE; //type length
	`C
	datain=8'hBB; //type length
	`C
	`C
	datain=8'hFF; //is a write
	`C
	datain=8'h13;
	`C
	datain=8'hCC;
	`C
	datainvalid=1'd0;
	`C
	
	end

endmodule
