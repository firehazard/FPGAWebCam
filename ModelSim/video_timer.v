`timescale 1ns/10ps

//
// Generic video timer
// Inputs: 
//   - clk
//   - lines per frame
//   - ticks per line
//   - hs_start, hs_stop
//   - vs_start, vs_stop
//   - vs_line_start, vs_line_stop
//   - starting_line
//   - active high or low syncs
//
// Outputs:
//   - vsync
//   - hsync
//   - line_counter
//   - pix_counter
//


// hsync, vsync state machine defs
`define HS_IDLE      1'b0 
`define HS_ACTIVE    1'b1 
`define VS_IDLE      1'b0 
`define VS_ACTIVE    1'b1 
`define TICK #0

module video_timer(
		    clk,               // system clock, 27MHz
		    ticks_per_line,    // clock ticks per line
		    lines_per_frame,   // lines per video frame
		    hs_pix_start,      // offset from line start to hs start, in ticks
		    hs_pix_stop,       // offset from line start to hs stop, in ticks
		    vs_pix_start,      // offset from line start to vs start, in ticks
		    vs_pix_stop,       // offset from line start to vs stop, in ticks
		    vs_line_start,      // offset from line start to vs start, in lines
		    vs_line_stop,       // offset from line start to vs stop, in lines
		    starting_line,     // which line in frame to start from
		    active_high_syncs, // 1 = active high syncs, 0 = active low
		    vsync,         // output vsync
		    hsync,         // output hsync
		    pix_counter,   // output pix_counter
		    line_counter,  // output line_counter
 		    reset_timer,       // sync reset all state (vsync, hysnc counters, etc.)
		    reset_b            // async reset for all flops
		   );

   input 	  clk;
   input [11:0]	  ticks_per_line;
   input [9:0]	  lines_per_frame;
   input [11:0]	  hs_pix_start;
   input [11:0]	  hs_pix_stop;
   input [11:0]	  vs_pix_start;
   input [11:0]	  vs_pix_stop;
   input [9:0]	  vs_line_start;
   input [9:0]	  vs_line_stop;
   input [9:0]	  starting_line;
   input 	  active_high_syncs;
   output 	  vsync;
   output 	  hsync;
   output [11:0]  pix_counter;
   output [9:0]	  line_counter;
   input 	  reset_timer;
   input 	  reset_b;
   
   wire 	  clk;
   wire [11:0]	  ticks_per_line;
   wire [9:0]	  lines_per_frame;
   wire [11:0]	  hs_pix_start;
   wire [11:0]	  hs_pix_stop;
   wire [11:0]	  vs_pix_start;
   wire [11:0]	  vs_pix_stop;
   wire [9:0]	  vs_line_start;
   wire [9:0]	  vs_line_stop;
   wire [9:0] 	  starting_line;
   wire 	  active_high_syncs;
   reg 		  vsync;
   reg 		  hsync;
   reg [11:0] 	  pix_counter;
   reg [9:0]	  line_counter;
   wire 	  reset_timer;
   wire 	  reset_b;

   
   // Local register declarations

   // State machine registers
   reg hs_state;
   reg vs_state;
   reg next_hs_state;
   reg next_vs_state;

   // Output register next-state registers
   reg [11:0] next_pix_counter;   
   reg [9:0]  next_line_counter;  
   reg next_hsync;
   reg next_vsync;
   
   wire      hs_start;
   wire      hs_stop;
   wire      vs_start;
   wire      vs_stop;
   wire      at_vs_line_start;
   wire      at_vs_line_stop;
   //wire      end_of_frame;
   
   // Flags
   assign    hs_start = (pix_counter[11:0] == hs_pix_start);
   assign    hs_stop  = (pix_counter[11:0] == hs_pix_stop);
   assign    vs_start = (pix_counter[11:0] == vs_pix_start);
   assign    vs_stop  = (pix_counter[11:0] == vs_pix_stop);
   assign    at_vs_line_start  = (line_counter[9:0] == vs_line_start);
   assign    at_vs_line_stop  = (line_counter[9:0] == vs_line_stop);
  // assign    end_of_frame = (line_counter[9:0] == lines_per_frame);

   // Synchronous Logic
   always @(posedge clk or negedge reset_b) begin
      if(!reset_b) begin  
	 pix_counter <= `TICK 12'b0;
	 line_counter <= `TICK 10'd0;	   
	 hsync <= `TICK 1'b0;
	 vsync <= `TICK 1'b0;
	 hs_state <= `TICK `HS_IDLE;
	 vs_state <= `TICK `VS_IDLE;
      end
      else begin  // Normal operation, not RESET
	 pix_counter <= `TICK next_pix_counter;
	 line_counter <= `TICK next_line_counter;
	 hs_state <= `TICK next_hs_state;
	 vs_state <= `TICK next_vs_state;
	 hsync <= `TICK next_hsync;
	 vsync <= `TICK next_vsync;
      end // else: !if(reset)
   end // always @ (clk)

   
   // Combinational logic for pixel and line counters and sync flags.
   // After ticks_per_line pixels counted, pix_counter is reset.
   // After lines_per_frame lines are counted, the line_counter is reset.
   always @(pix_counter or line_counter or reset_timer or starting_line or
	    ticks_per_line or lines_per_frame)
     begin
	if(reset_timer) begin
	   next_pix_counter = 12'b0;
	   next_line_counter = starting_line;
	end
	else begin
	   if(pix_counter[11:0]==ticks_per_line) begin
	      next_pix_counter = 12'b0;
	      if(line_counter[9:0]==lines_per_frame) 
		next_line_counter = 10'b0;
	      else 
		next_line_counter = line_counter+1'b1;
	   end
	   else begin
	      next_pix_counter = pix_counter+1'b1;
	      next_line_counter = line_counter;
	   end
	end
     end

   // hsync generation

   always @(hs_start or hs_stop or hs_state or reset_timer or
	    active_high_syncs) begin
      if(reset_timer) begin
	next_hs_state = `HS_IDLE;
	next_hsync = ~active_high_syncs;
      end
      else begin
	 case(hs_state)	
	   `HS_IDLE:
	     begin
		if (hs_start) next_hs_state = `HS_ACTIVE;
		else          next_hs_state = `HS_IDLE;
		next_hsync = ~active_high_syncs;
	     end
	   `HS_ACTIVE:
	     begin
		if(hs_stop) next_hs_state = `HS_IDLE;
		else next_hs_state = `HS_ACTIVE;
		next_hsync = active_high_syncs;
	     end
		default:
	     begin
		if (hs_start) next_hs_state = `HS_ACTIVE;
		else          next_hs_state = `HS_IDLE;
		next_hsync = ~active_high_syncs;
	     end
	 endcase // case(hs_state)
      end
   end 

   
   // Vsync Generation
   always @(vs_start or vs_stop or vs_state or reset_timer 
	    or active_high_syncs or at_vs_line_start or 
	    at_vs_line_stop) 
     begin
	if(reset_timer) begin
	   next_vs_state = `VS_IDLE;
	   next_vsync = ~active_high_syncs;
	end
	else begin
	   case(vs_state)	
	     `VS_IDLE:
	       begin
		  next_vsync = ~active_high_syncs;
		  if(vs_start && at_vs_line_start)
		     next_vs_state = `VS_ACTIVE;
		  else 
		     next_vs_state = `VS_IDLE;
	       end

	     `VS_ACTIVE:
	       begin
		  next_vsync = active_high_syncs;
		  if(vs_stop && at_vs_line_stop) next_vs_state = `VS_IDLE;
		  else next_vs_state = `VS_ACTIVE;
	       end
		 default:
	         begin
    		    next_vsync = ~active_high_syncs;
		    if(vs_start && at_vs_line_start)
		      next_vs_state = `VS_ACTIVE;
		    else 
		    next_vs_state = `VS_IDLE;
	     end
	 endcase // case(vs_state)
	end 
     end // always @ (vs_start or vs_stop or vs_state ...
   
endmodule // video_timer
