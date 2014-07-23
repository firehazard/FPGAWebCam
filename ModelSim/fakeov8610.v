`timescale 1 ns / 10 ps 
// OV8610 timing

// HACK TODO
// MAKE THIS MATCH UP WITH VSYNC AND HSYNC TIMING OUT OF FPGA
// I.E., href should occur at correct time relative to
// incoming vsync and hsync
// TRICK -- using a 40MHz input clock. Can't sim a 2x DLL easily
// All tick counts are doubled.
// Note: All we care about is the href timing. vsync and hsync are inputs. 

// One important note: This file came out of a larger system in which we
// were driving timing signals *to* the ov8610. That's why this timer
// resets on a vsync input. You all are going to use ov_vs and ov_hs, the
// generated vsyncs and hsyncs.
//
// That said, we should all double check and make sure the ov_vs and ov_hs
// signals generated by this module match the spec. 
//
//

// Hey tom, 
//   I played with these constants a little bit to match yours, but they don't
//   match up exactly if you were counting on something working for your side
//   of the Modelsim -Travis
`define OV_TICKS_PER_LINE      12'd2055 //2055
`define OV_HS_START            12'd40
`define OV_HS_STOP             12'd168
// TODO: These should be double-checked. 
`define OV_HREF_START          12'd593 //593
`define OV_HREF_STOP           12'd793    //12'd1233     //1873   ///

`define OV_VS_START            12'd1
`define OV_VS_STOP             12'd2  // 2
`define OV_VS_LINE_START       10'd5  // 640
`define OV_VS_LINE_STOP        10'd6  // 643

// For simulation, sometimes it is convenient to speed things
// up by making the frames tinier and more frequent.

//`ifdef SIMULATION
 `define OV_FRONT_PORCH         10'd2
 `define OV_BACK_PORCH         10'd4 // 17
 `define OV_LINES_PER_FRAME     10'd7 // 23
 `define OV_STARTING_LINE_COUNT 10'd0 //18
//`else
// `define OV_FRONT_PORCH         10'd106 //106  128
// `define OV_BACK_PORCH          10'd206 //10'd346	//586  256
// `define OV_LINES_PER_FRAME     10'd649
// `define OV_STARTING_LINE_COUNT 10'd0
//`endif 

// State defs
`define OV_HREF_IDLE    2'b00
`define OV_HREF_TRIGGER 2'b01
`define OV_HREF_ACTIVE  2'b10


module fakeov8610(
		     xclk,              // double the regular clock, 40MHz
		     pclk,              // output fake pclk 
		     href,              // Fake data -- href high when data valid
		     ov_vs,
		     ov_hs,
	//	     vsync,             // output vsync signal to sensor
	//	     hsync,             // output hsync signal to sensor
		     y,                 // Fake data -- pixel values
// 		     reset_timer,       // sync reset all state (vsync, hysnc counters, etc.)
		     reset_b,             // async reset for all flops
		     serialIn, serial_write_en,

		     cameraStatusBits,
		     controlDataRequest,
		     go,  //start/stop signal
		     stop
		     
	      );
   output go,stop;				   			  
   input xclk;
   output pclk;
  // input  vsync;
   output href;
   output ov_hs;
   output ov_vs;
   output [7:0] y;
//   input 	reset_timer;
   input 	reset_b;


   input [7:0] serialIn; 
   input serial_write_en;  
   

 	output [7:0]  	cameraStatusBits;
	input [7:0]   controlDataRequest;
	
	
   wire   xclk;
   wire   pclk;
   wire   vsync;
  // wire   hsync;
   wire   href;
   wire [7:0] y;
  // wire       reset_timer;      
   wire       reset_b;
   
   // unused signals
   wire       ov_hs;
   wire       ov_vs;
   wire [11:0] ov_pix_cntr;
   wire [9:0]  ov_line_cntr;

   // HACK to pass 40MHz clock to FPGA as pclk
   assign      pclk = xclk;
   
   video_timer ovtimer(.clk(xclk),
		       .ticks_per_line(`OV_TICKS_PER_LINE),
		       .lines_per_frame(`OV_LINES_PER_FRAME),
		       .hs_pix_start(`OV_HS_START),
		       .hs_pix_stop(`OV_HS_STOP),
		       .vs_pix_start(`OV_VS_START),
		       .vs_pix_stop(`OV_VS_STOP),
		       .vs_line_start(`OV_VS_LINE_START),
		       .vs_line_stop(`OV_VS_LINE_STOP),
		       .starting_line(10'd0),
		       .active_high_syncs(1'd1),
		       .vsync(ov_vs),
		       .hsync(ov_hs),
		       .pix_counter(ov_pix_cntr),
		       .line_counter(ov_line_cntr),
		       //.reset_timer(vsync),
			  //.reset_timer(~reset_b),
			  .reset_timer(~reset_b),
		       .reset_b(reset_b)
		       );

   
// HREF generation
   reg 	       href_reg;
   reg 	       next_href_reg;
   reg [1:0] href_state;
   reg [1:0] next_href_state;
   wire        href_start;
   wire        href_stop;
   wire        href_front_porch;
   wire        href_back_porch;

	// fake camera fsm signals
	wire [10:0] ov_href_start; 
	wire [10:0] ov_href_stop;
	wire [9:0]  ov_front_porch;
	wire [9:0]  ov_back_porch; 
	wire start_signal, stop_signal;	

/*
   assign      href_start = (ov_pix_cntr[10:0] == ov_href_start);
   //assign      href_start = (ov_pix_cntr[10:0] > ov_href_start && ov_pix_cntr[10:0] <ov_href_start+5);
   //assign      href_stop  = (ov_pix_cntr[10:0] > ov_href_stop && ov_pix_cntr[10:0] < ov_href_stop+5);
   assign      href_stop  = (ov_pix_cntr[10:0] == ov_href_stop);
   assign      href_front_porch = (ov_line_cntr[9:0] == ov_front_porch);
   assign      href_back_porch =  (ov_line_cntr[9:0] == ov_back_porch);
*/

   assign      href_start = (ov_pix_cntr[10:0] == 11'd100); //ov_href_start);
   assign      href_stop  = (ov_pix_cntr[10:0] == 12'd300); //ov_href_stop);
   assign      href_front_porch = (ov_line_cntr[9:0] == 10'd2);// ov_front_porch);
   assign      href_back_porch =  (ov_line_cntr[9:0] == 10'd4); //ov_back_porch);
  

// USE THIS ONE FOR CUSTOM VALUES!!! 
/*
   assign      href_start = (ov_pix_cntr[10:0] == ov_href_start);
   assign      href_stop  = (ov_pix_cntr[10:0] == ov_href_stop);
   assign      href_front_porch = (ov_line_cntr[9:0] == ov_front_porch);
   assign      href_back_porch =  (ov_line_cntr[9:0] == ov_back_porch);
*/
							  
/*
 assign      href_start = (ov_pix_cntr[10:0] == `OV_HREF_START);
   assign      href_stop  = (ov_pix_cntr[10:0] == `OV_HREF_STOP);
   assign      href_front_porch = (ov_line_cntr[9:0] == `OV_FRONT_PORCH);
   assign      href_back_porch =  (ov_line_cntr[9:0] == `OV_BACK_PORCH);
  */
   
   // HREF generation
   always @(href_start or href_stop or href_state or
            href_front_porch or href_back_porch or vsync) begin
      if (vsync && 0) begin   // ADDED -TS
         next_href_state = `OV_HREF_IDLE;
         next_href_reg = 1'b0;
      end
      else 
      begin
         case(href_state)
           `OV_HREF_IDLE:
             begin
                if (href_front_porch)
                  next_href_state = `OV_HREF_TRIGGER;
                else
                  next_href_state = `OV_HREF_IDLE;
                next_href_reg = 1'b0;
             end
           `OV_HREF_TRIGGER:
             begin
                if(href_back_porch) begin
                   next_href_state = `OV_HREF_IDLE;
                end
                else begin
                   if(href_start) next_href_state = `OV_HREF_ACTIVE;
                   else next_href_state = `OV_HREF_TRIGGER;
                end
                next_href_reg = 1'b0;
             end
           `OV_HREF_ACTIVE:
             begin
                if(href_stop)
                  next_href_state = `OV_HREF_TRIGGER;
                else
                  next_href_state = `OV_HREF_ACTIVE;
                next_href_reg = 1'b1;
             end
           default:
             begin
                next_href_state = `OV_HREF_IDLE;
                next_href_reg = 1'b0;
             end
         endcase // case(href_state)
      end // not sync_reset
   end

   always @(posedge xclk or negedge reset_b) begin
      /* GS - what is this ... just comment out
      if(!reset_b) begin
	 href_state <= `TICK `HREF_IDLE_MPEG;
	 href_reg <= `TICK `HREF_IDLE_MPEG;
      end
      else begin
	 href_state <= `TICK next_href_state;
	 href_reg <= `TICK next_href_reg;
      end
      */
      if(!reset_b) begin
      	 href_state <= `OV_HREF_IDLE;
	 href_reg <= 1'b0;
      end
      else begin
	 href_state <= next_href_state;
	 href_reg <= next_href_reg;
      end
   end
   
   assign href = href_reg;

   assign	y[7:0] = ov_pix_cntr[7:0];







// additions
	wire [7:0] from_ethernet;	
	assign from_ethernet[7:0] = serialIn[7:0];
	wire [7:0] enCtr;
				   wire resetFF;
				   assign resetFF = ~reset_b;
	dffrei #(3) ffxstart1(from_ethernet[2:0],(serial_write_en&enCtr==8'd1), resetFF, xclk, ov_href_start[10:8],3'b010);  // 010	// 010
	dffrei #(8) ffxstart2(from_ethernet, (serial_write_en&enCtr==8'd2), resetFF, xclk, ov_href_start[7:0],8'd0);    // 01010001  // 0
	dffrei #(3) ffxend1(from_ethernet[2:0],(serial_write_en&enCtr==8'd3), resetFF, xclk, ov_href_stop[10:8],3'b011);  // 111 	  100
	dffrei #(8) ffxend2(from_ethernet, (serial_write_en&enCtr==8'd4), resetFF, xclk, ov_href_stop[7:0],8'd0);   // 0101001		  0

	dffrei #(2) ffystart1(from_ethernet[1:0],(serial_write_en&enCtr==8'd5), resetFF, xclk, ov_front_porch[9:8], 2'd0); //0		   0
	dffrei #(8) ffystart2(from_ethernet, (serial_write_en&enCtr==8'd6), resetFF, xclk, ov_front_porch[7:0],8'd128);  //106		   128
	dffrei #(2) ffyend1(from_ethernet[1:0],(serial_write_en&enCtr==8'd7), resetFF, xclk, ov_back_porch[9:8],2'b00);  //10		    01
	dffrei #(8) ffyend2(from_ethernet, (serial_write_en&enCtr==8'd8), resetFF, xclk, ov_back_porch[7:0],8'd228); //01001010		  0

	dffrei #(1) ffstart(|from_ethernet, (serial_write_en&enCtr==8'd9), resetFF, xclk, start_signal,1'b1);
	dffrei #(1) ffstop(|from_ethernet,  (serial_write_en&enCtr==8'd10), resetFF, xclk, stop_signal,1'b0);
	
	dffre #(8) serialCount(enCtr+8'd1, serial_write_en, resetFF|~serial_write_en, xclk, enCtr);
	
		// this is messy but will do until we have sccb in lab 3. -TS
	assign cameraStatusBits = ( 	       
				  (controlDataRequest==8'd0 ? { 5'd0, ov_href_start[10:8]} : 
				  (controlDataRequest==8'd1 ? ov_href_start[7:0] :
				  (controlDataRequest==8'd2 ? {5'd0, ov_href_stop[10:8]} : 				  
				  (controlDataRequest==8'd3 ? ov_href_stop[7:0] :
				  (controlDataRequest==8'd4 ? {6'd0, ov_front_porch[9:8]} : 
				  (controlDataRequest==8'd5 ? ov_front_porch[7:0] : 
  				  (controlDataRequest==8'd6 ? {6'd0, ov_back_porch[9:8]} : 
				  (controlDataRequest==8'd7 ? ov_back_porch[7:0] : 
				  	8'hEE
				  ))))))))); // this line looks like LISP :)
	//dffre #(1) ffgo(start_signal, ov_vs|resetFF, resetFF, xclk, go);

	// Tom - will we regret this [use href to start/stop] later? -TS
	dffr #(1) ffgodff(.d(start_signal),.r(resetFF),.clk(xclk),.q(go));
	dffr #(1) ffstopdff(.d(stop_signal),.r(resetFF),.clk(xclk),.q(stop));
	

endmodule // camera_timing