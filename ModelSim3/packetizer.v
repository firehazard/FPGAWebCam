`define SEND_ADDRS 	  4'd0
`define CHILL		      4'd1
`define SEND_DATA  	  4'd2
`define SEND_CONTROL  4'd3
`define SEND_DUMMY    4'd4
`define SEND_DPTYPE    4'd5
`define SEND_CPTYPE    4'd6
`define WRITE_ADDR     4'd7
`define WRITE_DATA     4'd8
`define PAD_WITH_ZEROS 4'd9


`define ADDR_COUNT_MAX 5'd25   
`define DUMMY_COUNT_MAX 2'd1

module packetizer(clk, rst,cameraData,camera_href,	cameraVSync, outFifo,	
		   FIFOdata_valid,	cameraStatusBits, go, stop, outfifoready,outfifoenable);  
	input clk;
	input rst;
	input outfifoready; //the output fifo has more than 1 element so it's ready to send data to PC	
	input [7:0] cameraData;
	input camera_href;
	input cameraVSync;
	input go, stop;
	

	output outfifoenable; //packetizer is ready to take data from the outfifo data to send the PC
	
	output [8:0] outFifo; // output fifo data
	output FIFOdata_valid;
	            
     input [7:0] cameraStatusBits; // temporary until lab3 when we have SCCB.
   

	////////////////////
	//      FSMs      //
	////////////////////

	wire stop_pulse;

	wire [3:0] state;	
	wire [3:0] nextStateWire;
	reg [3:0] nextState;		   
	
	assign nextStateWire = rst? `SEND_ADDRS: stop_pulse? `SEND_DUMMY:nextState;

	dffr #(4) ffone(nextStateWire, rst, clk, state);
	
	wire [4:0] addressCount;
	wire [6:0] cdatacounter; // added more bits -T
	wire [1:0] dummyCount;
	
	wire dummyCounten;
	assign dummyCounten = (state==`SEND_DUMMY) | (state==`SEND_CPTYPE) | (state==`SEND_DPTYPE);
	wire cdatacounteren = (state==`WRITE_ADDR) | (state==`WRITE_DATA) | (state==`PAD_WITH_ZEROS);

	counter #(5) addresscounter(.clk(clk),.rst(rst | (addressCount==`ADDR_COUNT_MAX+1)),.en(state==`SEND_ADDRS),.count(addressCount));
	counter #(7) cdatacountercounter(.clk(clk),.rst(rst | (cdatacounter==7'd127) | (state==`SEND_DUMMY) ),.en(cdatacounteren),.count(cdatacounter));
	counter #(2) dummycounter(.clk(clk),.rst(rst | (dummyCount==`DUMMY_COUNT_MAX+1)),.en(dummyCounten),.count(dummyCount));
	
	wire vpulse;
	
	assign outfifoenable = (state==`WRITE_ADDR) || (state==`WRITE_DATA);
	
	edge_detect vsyncpulse(.clk(clk),.in(cameraVSync),.out(vpulse));
	edge_detect stoppulse(.clk(clk),.in(stop),.out(stop_pulse));

         always @(camera_href or rst or addressCount or cdatacounter or dummyCount or state or vpulse or go or stop_pulse or outfifoready) 
         begin
         		case(state)						
			`CHILL : nextState = (vpulse & go)? `SEND_CPTYPE : (camera_href & go)? `SEND_DPTYPE: `CHILL;
			`SEND_ADDRS : nextState = (addressCount==(`ADDR_COUNT_MAX))? `CHILL : `SEND_ADDRS;
			`SEND_DPTYPE: nextState = (dummyCount==(`DUMMY_COUNT_MAX))? `SEND_DATA: `SEND_DPTYPE;
			`SEND_CPTYPE: nextState = (dummyCount==(`DUMMY_COUNT_MAX))? `SEND_CONTROL: `SEND_CPTYPE;
			`SEND_DATA : nextState = camera_href ? `SEND_DATA: `SEND_DUMMY;
			`SEND_CONTROL:	nextState = (outfifoready)? `WRITE_ADDR: `PAD_WITH_ZEROS;
			`WRITE_ADDR: nextState = `WRITE_DATA;
			`WRITE_DATA: nextState = (outfifoready)? `WRITE_ADDR:`PAD_WITH_ZEROS;
			`PAD_WITH_ZEROS: nextState = (cdatacounter<7'd110)? `PAD_WITH_ZEROS: `SEND_DUMMY; 
			`SEND_DUMMY: 	nextState = (dummyCount==(`DUMMY_COUNT_MAX)) ? `SEND_ADDRS : `SEND_DUMMY; 
			default:	nextState=`SEND_ADDRS;
	   	endcase	 
	 end
	
	wire [7:0] addressMuxOut;
	assign outFifo = state == `CHILL ? 9'b0 :
			 state == `SEND_ADDRS ? {1'b1, addressMuxOut } :
			 state == `SEND_DPTYPE? {1'b1, 8'hFF}:
			 state == `SEND_CPTYPE? {1'b1, 8'h00}:					
			 state == `SEND_DATA ?  {1'b1, cameraData} :  	//8'hDD} : 
			 state == `SEND_CONTROL?{1'b1, cameraStatusBits}:
			 state == `WRITE_ADDR ? {1'b1, cameraStatusBits}:
			 state == `WRITE_DATA ? {1'b1, cameraStatusBits}: 
			 state == `PAD_WITH_ZEROS ? {1'b1, 8'd0}:  
			 state == `SEND_DUMMY?  {1'b0, 8'h00}: 9'd0;	
	
	wire [1:0]flip;

									//What does this part do? -td
	assign FIFOdata_valid = ~flip[1] & (state!=`CHILL) & !rst & (state!=`SEND_ADDRS | addressCount[4:1]!=4'b0000) & (state!=`SEND_CONTROL);

	reg camclk20reg;
  	assign camclk20=rst? 1'b0: camclk20reg; 
  	always @(posedge clk)
  		begin
     		camclk20reg = ~camclk20;
  		end
	assign flip={2{camclk20reg}};


	assign addressMuxOut = 
			(addressCount[4:1]==4'b0000 ? 8'h0D :
			(addressCount[4:1]==4'b0001 ? 8'h0A :
			(addressCount[4:1]==4'b0010 ? 8'h01 :
			(addressCount[4:1]==4'b0011 ? 8'h02 :
			(addressCount[4:1]==4'b0100 ? 8'h03 :
			(addressCount[4:1]==4'b0101 ? 8'h04 :
			(addressCount[4:1]==4'b0110 ? 8'h05 :
			(addressCount[4:1]==4'b0111 ? 8'h0A :
			(addressCount[4:1]==4'b1000 ? 8'h01 :
			(addressCount[4:1]==4'b1001 ? 8'h02 :
			(addressCount[4:1]==4'b1010 ? 8'h03 :
			(addressCount[4:1]==4'b1011 ? 8'h04 :
			(addressCount[4:1]==4'b1100 ? 8'hCC :
			(addressCount[4:1]==4'b1101 ? 8'hCC : 8'hAF
			))))))))))))));
endmodule