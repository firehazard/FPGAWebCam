`define	WIDLE		      3'd0
`define	WRITE_P1_ID           3'd1
`define	WRITE_P1_X            3'd2
`define	WRITE_P2_SUBADDR      3'd3
`define	WRITE_P2_X            3'd4
`define	WRITE_P3_DATA         3'd5
`define	WRITE_P3_X            3'd6

`define	MIDLE		4'd0
`define	MSTART_WRITE1		4'd1 
`define	MSTART_WRITE2   4'd2
`define	MSTART_READ1    4'd3
`define	MSTART_READ2    4'd4
`define	MWRITE		4'd5
`define	MREAD		4'd6
`define	MSTOP1		4'd7
`define	MSTOP2		4'd8
`define MSTOP3 			4'd9
`define	WAITREADY  		4'd10
`define	ASSERT_DONE  		4'd11

`define CLOCKCOUNTMAX 7'd32
`define DELAY1300 10'd20 //10'd600 

// states
`define READ_SLEEP 4'd0
`define READ_REQ_P1_ID 4'd1
`define READ_REQ_P1_X 4'd2
`define READ_REQ_P2_REG 4'd3
`define READ_REQ_P2_X 4'd4
`define READ_REQ_P2_END1 4'd5
`define READ_REQ_P2_END2 4'd6
`define READ_REQ_P2_END3 4'd7
`define READ_WAIT_1300 4'd8
`define READ_GET_P1_INIT1 4'd9
`define READ_GET_P1_INIT2 4'd10
`define READ_GET_P1_ID 4'd11
`define READ_GET_P1_X 4'd12
`define READ_GET_P2_DATA 4'd13
`define READ_GET_P2_X 4'd14

module sccb(clk, rst, sccb_d, sccb_c, read_request, write_request, write_data,write_addr, read_addr, read_data, done, request_ack);
	input clk, rst;
	input [7:0] write_data, write_addr, read_addr;
	output [7:0] read_data;
	output done, request_ack;
	input read_request, write_request;
	inout sccb_d;
	output sccb_c; 
	
	/// Wires
	wire count13done; //1.3 ms counter done
	wire bitcountdone; // bit counter done
	
		
	wire write_fsm_en, write_fsm_done;
	wire read_fsm_en, read_fsm_done;
	
	assign write_fsm_en = (next_mstate == `MWRITE);
	assign read_fsm_en = (next_mstate == `MREAD);
	
	wire [6:0] clockcounter;
	wire enable800_s, enable400;
//	assign clk400 = (clockcounter==7'd0) || (clockcounter==7'd16) ;
	assign enable400 = (clockcounter==7'd0);
	assign enable800_s = (clockcounter==7'd8) || (clockcounter==7'd24);
	
	counter #(7) clk400counter(.clk(clk),.rst(rst | (clockcounter==`CLOCKCOUNTMAX)), .en(1'b1),.count(clockcounter));
	
	/// State machines
	// ******** MASTER FSM **********//
	wire [3:0] mstate;
	reg [3:0] next_mstatereg;
	wire [3:0] next_mstate = rst? `MIDLE:next_mstatereg;
	dffre #(4) mstatefsm (.d(next_mstate),.q(mstate),.clk(clk), .r(rst),.en(enable400));
	always @ (mstate or write_request or read_request or write_fsm_done or read_fsm_done or count13done)
	   begin
	       case(mstate)
	    	`MIDLE: next_mstatereg = write_request? `MSTART_WRITE1: read_request? `MSTART_READ1:`MIDLE;
	    	`MSTART_WRITE1: next_mstatereg =`MSTART_WRITE2;
	    	`MSTART_WRITE2: next_mstatereg =`MWRITE;
	    	`MSTART_READ1: next_mstatereg =`MSTART_READ2;
	    	`MSTART_READ2: next_mstatereg =`MREAD;
	    	`MWRITE: next_mstatereg = write_fsm_done? `MSTOP1: `MWRITE;
	    	`MREAD:  next_mstatereg = read_fsm_done? `MSTOP1: `MREAD;
	    	`MSTOP1: next_mstatereg =`MSTOP2;
	    	`MSTOP2: next_mstatereg = `MSTOP3;
	    	`MSTOP3: next_mstatereg =`WAITREADY;
	    	`WAITREADY: next_mstatereg = count13done? `ASSERT_DONE: `WAITREADY;
	    	`ASSERT_DONE: next_mstatereg = `MIDLE;
	    	default: next_mstatereg = `MIDLE;    
	       endcase
	    end
	
	assign request_ack = (mstate==`MSTART_WRITE1) || (mstate==`MSTART_READ1);
	assign done = (mstate==`ASSERT_DONE);
	    
	// *** SCCB WRITE STATE MACHINE **** //
	wire [2:0] wstate;
	reg [2:0] next_wstatereg;
	wire [2:0] next_wstate = rst? `WIDLE:next_wstatereg;
	dffre #(3) wstatefsm (.d(next_wstate),.q(wstate),.clk(clk),.r(rst),.en(enable400));
	always @ (wstate or bitcountdone or write_fsm_en)
	   begin
		case (wstate)
		   `WIDLE: next_wstatereg = write_fsm_en? `WRITE_P1_ID: `WIDLE;
		   `WRITE_P1_ID: next_wstatereg= bitcountdone? `WRITE_P1_X : `WRITE_P1_ID;
		   `WRITE_P1_X: next_wstatereg = `WRITE_P2_SUBADDR;
		   `WRITE_P2_SUBADDR: next_wstatereg = bitcountdone? `WRITE_P2_X: `WRITE_P2_SUBADDR;
		   `WRITE_P2_X: next_wstatereg = `WRITE_P3_DATA;
		   `WRITE_P3_DATA: next_wstatereg = bitcountdone ? `WRITE_P3_X : `WRITE_P3_DATA;
		   `WRITE_P3_X: next_wstatereg = `WIDLE;	
		   default: next_wstatereg = `WIDLE;
		endcase
	 end
	 
	 assign write_fsm_done = (wstate == `WRITE_P3_X);
	 
	 //** SCCB READ STATE MACHINE **** //
	wire bit_ctr_en;
	wire [3:0] bit_ctr;
	assign bitcountdone = (bit_ctr==4'd7);
	assign bit_ctr_en = (readstate==`READ_REQ_P1_ID || readstate==`READ_REQ_P2_REG || readstate==`READ_GET_P1_ID || readstate==`READ_GET_P2_DATA
			     || wstate==`WRITE_P1_ID || wstate==`WRITE_P2_SUBADDR || wstate==`WRITE_P3_DATA);
	
	counter #(4) bitcount ( .clk(clk),.rst(rst | (bit_ctr==4'd7 & enable400)),.en(bit_ctr_en & enable400),.count(bit_ctr));
	

	wire [3:0] readstate;
	reg [3:0] nextR;
	wire [3:0] nextrstate;
	assign nextrstate = rst? `READ_SLEEP: nextR;
	dffre #(4) read_ff (.d(nextrstate),.clk(clk),.q(readstate),.en(enable400),.r(rst));
	wire read_done;
	assign read_done = (readstate==`READ_GET_P2_X);
	
	always@(read_fsm_en or bitcountdone or readstate or count13done) begin	
		case(readstate)
			`READ_SLEEP: nextR= read_fsm_en ? `READ_REQ_P1_ID : `READ_SLEEP;		
			`READ_REQ_P1_ID: nextR=(bitcountdone ? `READ_REQ_P1_X : `READ_REQ_P1_ID);
			`READ_REQ_P1_X:	nextR=`READ_REQ_P2_REG;
			`READ_REQ_P2_REG: nextR = (bitcountdone ? `READ_REQ_P2_X : `READ_REQ_P2_REG);			
			`READ_REQ_P2_X:	nextR=`READ_REQ_P2_END1;
			`READ_REQ_P2_END1:nextR=`READ_REQ_P2_END2;
			`READ_REQ_P2_END2:nextR=`READ_REQ_P2_END3;
			`READ_REQ_P2_END3:nextR=`READ_WAIT_1300;
			`READ_WAIT_1300: nextR=(count13done ? `READ_GET_P1_INIT1 : `READ_WAIT_1300);
			`READ_GET_P1_INIT1:nextR=`READ_GET_P1_INIT2;
			`READ_GET_P1_INIT2:nextR=`READ_GET_P1_ID;		
			`READ_GET_P1_ID: nextR=(bitcountdone ? `READ_GET_P1_X : `READ_GET_P1_ID);
			`READ_GET_P1_X:	nextR=`READ_GET_P2_DATA;		
			`READ_GET_P2_DATA: nextR=(bitcountdone ? `READ_GET_P2_X : `READ_GET_P2_DATA);		
			`READ_GET_P2_X: nextR=`READ_SLEEP;		
			default:nextR=`READ_SLEEP;		
		endcase
	end
	
	assign read_fsm_done = (readstate == `READ_GET_P2_X);
	
	wire [6:0] cam_id_addr = 7'b0000101;
		
	// counter to delay 1300 ms
	wire [9:0] wait1300ctr;
	wire wait1300ctrEn;	
	assign wait1300ctrEn = (readstate==`READ_WAIT_1300 | mstate==`WAITREADY);	
	assign count13done=(wait1300ctr==`DELAY1300);
	counter #(10) counter13ms(.clk(clk),.rst(rst | (wait1300ctr==`DELAY1300+1 & enable400)), .en(wait1300ctrEn & enable400),.count(wait1300ctr));
	
	wire camid;
	assign camid = (bit_ctr!=3'd7)? cam_id_addr[bit_ctr]: (readstate==`READ_GET_P1_ID);  

		
	reg [7:0] readtemp;
	assign read_data = readtemp;
	
	always @ (posedge clk)
	begin
	    if (rst) readtemp = 8'd0;
	    if (readstate==`READ_GET_P2_DATA && enable400) readtemp[3'd7-bit_ctr] = sccb_d;
	    else readtemp = readtemp;
	end
	
	wire sccb_d_pre, sccb_c_pre;
	dff antidataglitch(.clk(clk),.d(sccb_d_pre),.q(sccb_d));
	dff anticontrolglitch(.clk(clk),.d(sccb_c_pre),.q(sccb_c));
		
	assign sccb_d_pre = 
		(mstate==`MSTART_WRITE1 || mstate==`MSTART_READ1)? 1'b0 :
		(mstate==`MSTART_WRITE2 || mstate==`MSTART_READ2)? 1'b0 :
		(mstate==`MSTOP1)? 1'b0:
		(mstate==`MSTOP2)? 1'b0:
		(mstate==`MSTOP3)? 1'b1:
		(wstate==`WRITE_P1_ID) ? camid:
		(wstate==`WRITE_P2_SUBADDR) ? write_addr[3'd7-bit_ctr] : 
		(wstate==`WRITE_P3_DATA) ? write_data[3'd7-bit_ctr]:
		(readstate==`READ_REQ_P1_ID) ? camid:
		(readstate==`READ_REQ_P2_REG) ? read_addr[3'd7-bit_ctr] : 
		(readstate==`READ_REQ_P2_END1 || readstate==`READ_REQ_P2_END2) ? 1'b0 :
		(readstate==`READ_REQ_P2_END3) ? 1'b1 :
		(readstate==`READ_GET_P1_INIT1) ? 1'b0:
		(readstate==`READ_GET_P1_INIT2) ? 1'b0:  
		(readstate==`READ_GET_P1_ID) ? camid:
		(readstate==`READ_GET_P2_DATA) ? 1'bz: 1'b1;
	

	wire shifted_clk;
	dffre sccbshifter (.clk(clk),.d(~shifted_clk),.q(shifted_clk),.en(enable800_s),.r(rst));
	
	assign sccb_c_pre = (mstate==`MSTART_WRITE1 || mstate==`MSTART_READ1)? 1'b1:
			(mstate==`MSTART_WRITE2 || mstate==`MSTART_READ2)? 1'b0:
			(mstate==`MSTOP1)? 1'b0:
			(mstate==`MSTOP2 || mstate==`MSTOP3)? 1'b1:
			(mstate==`MIDLE)? 1'b1: 
			(mstate==`WAITREADY)? 1'b1:
			(readstate==`READ_REQ_P2_END1) ? 1'b0 :
			(readstate==`READ_REQ_P2_END2 || readstate==`READ_REQ_P2_END3) ? 1'b1:
			(readstate==`READ_GET_P1_INIT1) ? 1'b1:
			(readstate==`READ_GET_P1_INIT2) ? 1'b0: 
			(readstate==`READ_WAIT_1300)? 1'b1:
			(mstate==`MWRITE || mstate==`MREAD)? shifted_clk: 1'b1;

endmodule