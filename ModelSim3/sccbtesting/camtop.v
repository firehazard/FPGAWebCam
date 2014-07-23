`define IDLE 2'b00
`define WAIT_ACK 2'b01
`define GETFIRST 2'b10
`define DRAIN_FIFO 2'b11

`define FIFO_READY 16'd20

module camtop(
   // asynchronous reset     
   reset,

   // direct connection to the core's transmitter client interface.
   tx_data,
   tx_data_valid,
  // tx_underrun,
   tx_ack,
   tx_clk,

   // direct connection to the core's receiver client interface.
   rx_data,
   rx_data_valid,
   rx_clk,

   // An overflow (error condition) has occured in the FIFO.
   overflow,
  // tx_retransmit,
 //  tx_collision,
   camclkin,
   goo, stopo , 
   pccamvalid	,
   fifoOver,
   sccb_c,
   sccb_d
);

   input        camclkin; //40MHZ
   input        reset;
   output [7:0] tx_data;
   output       tx_data_valid;
   //output       tx_underrun;
   input        tx_ack;
   input        tx_clk;
   input  [7:0] rx_data;
   input        rx_data_valid;
   input        rx_clk;
   output       overflow;
  // input        tx_retransmit;
  // input        tx_collision;
   output goo, stopo;
   output fifoOver;

   output sccb_c, sccb_d;
      	
  //------------------------------------------------------------------
  // internal signals used in this design example.
  //------------------------------------------------------------------
  
  // intermediate connections between fake cam module and FIFO
  wire [8:0] cam_data_to_fifo;
  wire       cam_data_valid_to_fifo;
  wire stop;


   wire camclk20, camclk40;
   wire href, vsync;
   wire [7:0] pixel; 
   //wire pccamvalid;
   output pccamvalid;
   wire [7:0] pccamdata;
   
  wire tx_reset;
  wire rx_reset;
  wire reset40;
  wire reset20;

  // synthesis attribute ASYNC_REG of rx_pre_reset is "TRUE";
  // synthesis attribute ASYNC_REG of tx_pre_reset is "TRUE";
  
  //Create 20MHz clk
  reg camclk20reg;
  assign camclk20=reset? 1'b0: camclk20reg; 
  always @(posedge camclk40)
  begin
     camclk20reg = ~camclk20;
  end
  
// Synchronize Resets
  resetsync stxreset(.clk(tx_clk),.r1(reset),.r2(tx_reset));
  resetsync srxreset(.clk(rx_clk),.r1(reset),.r2(rx_reset));
  resetsync sreset40(.clk(camclk40),.r1(reset),.r2(reset40));
  resetsync sreset20(.clk(camclk20),.r1(reset),.r2(reset20));
   
 wire [7:0]  	cameraStatusBits;
 wire [7:0]	  controlDataRequest;
  wire go; // global start/stop

/*
  fakeov8610 fakecamera(
		     .xclk(camclkin),      // double the regular clock, 40MHz
		     .pclk(camclk40),      // output fake pclk 
		     .href(href),           // Fake data -- href high when data valid
		     .ov_vs(vsync),
		     //.ov_hs(hsync),
//		     .vsync(1'b0),          // output vsync signal to sensor
		     //.hsync(1'b0),          // output hsync signal to sensor
		     .y(pixel),             // Fake data -- pixel values
		     .reset_b(!reset40),      // async reset for all flops
		     .serial_write_en(pccamvalid),
		     .serialIn(pccamdata),				       
		     .cameraStatusBits(cameraStatusBits),
		     .controlDataRequest(controlDataRequest),
		     .go(go),
		     .stop(stop) 
	      );
*/	 
	      
   assign goo=go;
   assign stopo = stop;

  wire outfifohasdata;
  wire packetizer_ready;

  pcpacket incoming (.rxclk(rx_clk),
		     .rxreset(rx_reset),
   		     .camclk(camclk40),
   		     .rx_data(rx_data),
   		     .rx_valid(rx_data_valid),
		     .pccamvalid(pccamvalid),
		     .outfifodata(cameraStatusBits),
		     .fifoOver(fifoOver),
		     .sccb_d(sccb_d),
		     .sccb_c(sbbc_c),
		     .readenpack(packetizer_ready),
		     .outfifoready(outfifohasdata)
   		     );

  packetizer makepackets(
		.clk(camclk40),
		.cameraData(pixel),
		.camera_href(href),
		.cameraVSync(vsync),
		.rst(reset40),
		.outFifo(cam_data_to_fifo),
		.FIFOdata_valid(cam_data_valid_to_fifo),
		.cameraStatusBits(cameraStatusBits),
		.go(go),
		.stop(stop),
		.outfifoready(outfifohasdata),
		.outfifoenable(packetizer_ready)
	);
    
 
      wire [8:0] fifout;
      wire validfifodata, fifoready;
      wire empty, readenable;
      wire[1:0] state, next_state;
      reg [1:0] next_state1;
      
      assign next_state = reset? `IDLE: next_state1; 
      
      //dont even need the empty signal
      always@(empty or validfifodata or tx_ack or fifoready or state)
	begin
		case(state) 
			`IDLE: next_state1 = (fifoready)?  `WAIT_ACK:`IDLE;
			`WAIT_ACK: next_state1 = tx_ack?  `GETFIRST:`WAIT_ACK;
			`GETFIRST: next_state1 = `DRAIN_FIFO;
			`DRAIN_FIFO: next_state1 = (empty | ~validfifodata)? `IDLE:`DRAIN_FIFO;
			default: next_state1=`IDLE;
		endcase
	end


	 assign readenable = (state==`DRAIN_FIFO) | (state==`GETFIRST);
	 assign tx_data_valid = (state==`WAIT_ACK) | (state==`DRAIN_FIFO) | (state==`GETFIRST);
      dffr #(2) state_reg(.clk(tx_clk),.r(tx_reset),.d(next_state),.q(state));
      
       	 
  //-------------------------------------------------------------------
  // Instantiate the FIFO		
  // QUESTION: All the data is coming at 40MHz to the FIFO. However
  // the write clock is set to 20MHz, is this ok?						 
  //-------------------------------------------------------------------

 assign tx_data = fifout[7:0];
 wire [15:0] fifodatacount;
 assign validfifodata = fifout[8];
 assign fifoready = (fifodatacount>`FIFO_READY);

bigfifo myfifo(
	.din(cam_data_to_fifo),
	.wr_en(cam_data_valid_to_fifo & go), // CHANGED -TS  CHECK THIS
	.wr_clk(camclk40),	 // 20
	.rd_en(readenable),
	.rd_clk(tx_clk),
	.ainit(reset40),		 // 20
	.dout(fifout),
	.full(overflow),
	.empty(empty),
	.wr_count(fifodatacount)
	);



endmodule