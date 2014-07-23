`define CHILL		      3'b001
`define SEND_ADDRS 	  3'b000
`define SEND_DATA  	  3'b010
`define SEND_CONTROL  3'b011
`define SEND_DUMMY    3'b100
`define SEND_DPTYPE    3'b101
`define SEND_CPTYPE    3'b110
`define WAIT_NOT_VSYNC	3'b111


`define ADDR_COUNT_MAX 5'd25  
`define CONTROL_COUNT_MAX 8'd201 
`define DUMMY_COUNT_MAX 2'd1

module packetizer(clk, rst,cameraData,camera_href,	cameraVSync, outFifo,	
		   FIFOdata_valid,	cameraStatusBits, controlDataRequest, go, stop);  
	input clk;
	input rst;	
	input [7:0] cameraData;
	input camera_href;
	input cameraVSync;
	input go, stop;

	output [8:0] outFifo; // output fifo data
	output FIFOdata_valid;
	            
     input [7:0] cameraStatusBits; // temporary until lab3 when we have SCCB.
     output [7:0] controlDataRequest;
   

	////////////////////
	//      FSMs      //
	////////////////////

	wire stop_pulse;

	wire [2:0] state;	
	wire [2:0] nextStateWire;
	reg [2:0] nextState;		   
	
	assign nextStateWire = rst? `SEND_ADDRS: stop_pulse? `SEND_DUMMY:nextState;

	dffr #(3) ffone(nextStateWire, rst, clk, state);
	
	wire [4:0] addressCount;
	wire [7:0] controlCount; // added more bits -T
	wire [1:0] dummyCount;
	
	wire dummyCounten;
	assign dummyCounten = (state==`SEND_DUMMY) | (state==`SEND_CPTYPE) | (state==`SEND_DPTYPE);

	counter #(5) addresscounter(.clk(clk),.rst(rst | (addressCount==`ADDR_COUNT_MAX+1)),.en(state==`SEND_ADDRS),.count(addressCount));
	counter #(8) controlcounter(.clk(clk),.rst(rst | (controlCount==`CONTROL_COUNT_MAX+1)),.en(state==`SEND_CONTROL),.count(controlCount));
	counter #(2) dummycounter(.clk(clk),.rst(rst | (dummyCount==`DUMMY_COUNT_MAX+1)),.en(dummyCounten),.count(dummyCount));
	
	wire vpulse;
	
	edge_detect vsyncpulse(.clk(clk),.in(cameraVSync),.out(vpulse));
	
	wire [3:0] vpcount;	
	counter #(4) vpcounter(clk,  rst|vpulse, (vpcount!=4'b1111), vpcount);		

/*
	reg vpulse;
	always@() begin
	   if(!vpulse & cameraVSync

	end
	*/

	//assign vpulse=cameraVSync;
	edge_detect stoppulse(.clk(clk),.in(stop),.out(stop_pulse));

         always @(camera_href or rst or addressCount or controlCount or dummyCount or state or vpulse or go or stop_pulse) 
         begin
         		case(state)		
			//				
			`CHILL : nextState = (vpulse & go)? `WAIT_NOT_VSYNC : (camera_href & go)? `SEND_DPTYPE: `CHILL;
			`SEND_ADDRS : nextState = (addressCount==(`ADDR_COUNT_MAX))? `CHILL : `SEND_ADDRS;
			`SEND_DPTYPE: nextState = (dummyCount==(`DUMMY_COUNT_MAX))? `SEND_DATA: `SEND_DPTYPE;
			`SEND_CPTYPE: nextState = (dummyCount==(`DUMMY_COUNT_MAX))? `SEND_CONTROL: `SEND_CPTYPE;
			`SEND_DATA : nextState = camera_href ? `SEND_DATA: `SEND_DUMMY;
			`SEND_CONTROL:	nextState = (controlCount==(`CONTROL_COUNT_MAX)) ? `SEND_DUMMY : `SEND_CONTROL;
			`SEND_DUMMY: 	nextState = (dummyCount==(`DUMMY_COUNT_MAX)) ? `SEND_ADDRS : `SEND_DUMMY;
			`WAIT_NOT_VSYNC: nextState = (cameraVSync ? `WAIT_NOT_VSYNC : `SEND_CPTYPE); 
			default:	nextState=`SEND_ADDRS;
	   	endcase	 
	 end
	
	assign controlDataRequest[7:0] = {3'b000, controlCount[5:1]}; //take out last bit to account for half clk - td
								    /*
	assign outFifo = (state == `CHILL ? 9'b0 :
			 (state == `SEND_ADDRS ? {1'b1, headerStart[addressCount[4:1]]} :
			 (state == `SEND_DPTYPE? {9'b111111111}:
			 (state == `SEND_CPTYPE? {9'b100000000}:					
			 (state == `SEND_DATA ? {1'b1, cameraData} : 
			 (state == `SEND_CONTROL ? {1'b1, cameraStatusBits} : 
			 (state == `SEND_DUMMY? 9'd0: 9'd0)))))));
			 */

	wire [7:0] addressMuxOut;
	assign outFifo = (state == `CHILL ? 9'b0 :
			 (state == `SEND_ADDRS ? {1'b1, addressMuxOut } :
			 (state == `SEND_DPTYPE? {1'b1, 8'hFF}:
			 (state == `SEND_CPTYPE? {1'b1, 8'h00}:					
			 (state == `SEND_DATA ?  {1'b1, cameraData} :  	//8'hDD} : 
			 (state == `SEND_CONTROL?{1'b1, cameraStatusBits}: 
			 (state == `SEND_DUMMY?  {1'b0, 8'h00}: 9'd0)))))));	
	
	wire [1:0]flip;
	/*
	reg [1:0] halfClk;
	always @(posedge clk)
		case({rst, halfClk}) begin
			  3'1xx: halfClk=2'b01;
			  3'000: halfClk=2'b01;
			  3'001: halfClk=2'b10;
			  3'010: halfClk=2'b11;
			  3'011: halfClk=2'b00;
		endcase	

	//asssign flip=halfClk[1];	   
	
	*/

	//dffr #(2) flipcount(flip+2'b01,rst,clk,flip);
	  
	//counter #(2) flipcount(clk, rst, 1'b1, flip); 
	assign FIFOdata_valid = ~flip[1] & (state!=`CHILL) & (state!=`WAIT_NOT_VSYNC) & !rst & (state!=`SEND_ADDRS | addressCount[4:1]!=4'b0000);
	//assign FIFOdata_valid = (state!=`CHILL) & !rst;

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