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


`define DELAY1300 10'd600
// states
`define READ_SLEEP 5'd0
`define READ_INIT_TRANSACTION 5'd1
`define READ_REQ_P1_ID 5'd2
`define READ_REQ_P1_X 5'd3
`define READ_REQ_P2_REG 5'd4
`define READ_REQ_P2_X 5'd5
`define READ_REQ_P2_END 5'd6
`define READ_WAIT_1300 5'd7
`define READ_GET_P1_INIT 5'd8
`define READ_GET_P1_ID 5'd9
`define READ_GET_P1_X 5'd10
`define READ_GET_P2_DATA 5'd11
`define READ_GET_P2_X 5'd12

module sccb(clk, rst, sccb_d, sccb_c, read_request, write_request, write_data,write_addr, read_addr, read_data, done);
	input clk, rst;
	input [7:0] write_data, write_addr, read_addr;
	output [7:0] read_data;
	output done;
	input read_request, write_request;
	inout sccb_d;
	output sccb_c; 
	
	/// Wires
	wire count13done; //1.3 ms counter done
	wire bitcountdone; // bit counter done 
	
	wire write_fsm_en, write_fsm_done;
	wire read_fsm_en, read_fsm_done;
	
	assign write_fsm_en = (mstate == `MWRITE);
	assign read_fsm_en = (mstate == `MREAD);
	
	/// State machines
	// ******** MASTER FSM **********//
	wire mstate;
	reg next_mstatereg;
	wire next_mstate = rst? `MIDLE:next_mstate;
	dff #(4) mstatefsm (.d(next_mstate),.q(mstate),.clk(clk));
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
	    	`WAITREADY: next_mstatereg = count13done? `MIDLE: `WAITREADY;    
	       endcase
	    end
	     
	// *** SCCB WRITE STATE MACHINE **** //
	wire wstate;
	reg next_wstatereg;
	wire next_wstate = rst? `WIDLE:next_wstatereg;
	dff #(3) wstatefsm (.d(next_wstate),.q(wstate),.clk(clk));
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
		endcase
	 end
	 
	 assign write_fsm_done = (wstate == `WRITE_P3_X);
	 
	 //** SCCB READ STATE MACHINE **** //
	wire bit_ctr_en;
	wire [3:0] bit_ctr;
	assign bitcountdone = (bit_ctr==4'd6);
	assign bit_ctr_en = (readstate==`READ_REQ_P1_ID || readstate==`READ_REQ_P2_REG || readstate==`READ_GET_P1_ID || readstate==`READ_GET_P2_DATA
			     || wstate==`WRITE_P1_ID || wstate==`WRITE_P2_SUBADDR || wstate==`WRITE_P3_DATA);
	
	counter #(4) bitcount ( .clk(clk),.rst(rst | bit_ctr==4'd8 ),.en(bit_ctr_en),.count(bit_ctr));
	

	wire [3:0] readstate;
	reg [3:0] nextR;
	wire [3:0] nextrstate;
	assign nextrstate = rst? `READ_SLEEP: nextR;
	dff #(4) read_ff (nextrstate, clk, readstate);
	wire read_done;
	assign read_done = (readstate==`READ_GET_P2_X);
	
	always@(read_fsm_en or bitcountdone or readstate or count13done) begin	
		case(readstate)
			`READ_SLEEP: nextR= read_fsm_en ? `READ_REQ_P1_X : `READ_SLEEP;		
			`READ_REQ_P1_ID: nextR=(bitcountdone ? `READ_REQ_P1_X : `READ_REQ_P1_ID);
			`READ_REQ_P1_X:	nextR=`READ_REQ_P2_REG;
			`READ_REQ_P2_REG: nextR = (bitcountdone ? `READ_REQ_P2_X : `READ_REQ_P2_REG);			
			`READ_REQ_P2_X:	nextR=`READ_REQ_P2_END;
			`READ_REQ_P2_END:nextR=`READ_WAIT_1300;		
			`READ_WAIT_1300: nextR=(count13done ? `READ_GET_P1_INIT : `READ_WAIT_1300);
			`READ_GET_P1_INIT:nextR=`READ_GET_P1_ID;
			`READ_GET_P1_ID: nextR=(bitcountdone ? `READ_GET_P1_X : `READ_GET_P1_ID);
			`READ_GET_P1_X:	nextR=`READ_GET_P2_DATA;		
			`READ_GET_P2_DATA: nextR=(bitcountdone ? `READ_GET_P2_X : `READ_GET_P2_DATA);		
			`READ_GET_P2_X: nextR=`READ_SLEEP;		
			default:nextR=`READ_SLEEP;		
		endcase
	end
	
	assign read_fsm_done = (wstate == `READ_GET_P2_X);
	
	wire [6:0] cam_id_addr = 7'hA0;
	
	// counter to delay 1300 ms
	wire [9:0] wait1300ctr;
	wire wait1300ctrEn;	
	assign wait1300ctrEn = (readstate==READ_WAIT_1300 | mstate==`WAITREADY);	
	assign count13done=wait1300ctr==`DELAY1300;
	counter #(10) counter13ms(.clk(clk),.rst(rst | (wait1300ctr==`DELAY1300+1)), .en(wait1300ctrEn),.counter(wait1300ctr));
	
	wire camid;
	assign camid = (bit_ctr!=3'd7)? cam_id_addr[bit_ctr]: (readstate==`READ_GET_P1_ID);  

		
	reg [7:0] readtemp;
	assign read_data = readtemp;
	
	always @ (posedge clk)
	begin
	    if (rst) readtemp = 8'd0;
	    if (readstate==`READ_GET_P2_DATA) readtemp[bit_ctr] = sccb_d;
	    else readtemp = readtemp;
	end
	
		
	
	assign sccb_d = 
		(mstate==`MSTART_WRITE1 ? 1'b0 :
		(mstate==`MSTART_WRITE2 ? 1'b0 :
		(wstate==`WRITE_P1_ID ? camid:
		(wstate==`WRITE_P2_SUBADDR ? write_addr[bit_ctr] : 
		(wstate==`WRITE_P3_DATA ? write_data[bit_ctr]:
		(readstate==`READ_REQ_P1_ID ? camid:
		(readstate==`READ_REQ_P2_REG ? read_addr[bit_ctr] : 
		(readstate==`READ_REQ_P2_END ? 1'b1 : 
		(readstate==`READ_GET_P1_INIT ? 1'b0: 
		(readstate==`READ_GET_P1_ID ? camid:
		(readstate==`READ_GET_P2_DATA ? 1'bz: 1'b1	 )))))))))));
	
	reg sccb_cr;
	assign sccb_c = sccb_cr;	
	always@(posedge clk) 
		begin
			if(mstate==`MSTART_WRITE1 || mstate==`MSTART_READ1)
				sccb_cr=1'b1;
			else if(mstate==`MSTART_WRITE2 || mstate==`MSTART_READ2)
				sccb_cr=1'b0;
			else if(mstate==`MSTOP1)
				sccb_cr=1'b0;
			else if(mstate==`MSTOP2 || mstate==`MSTOP3)
				sccb_cr=1'b1;
			else   sccb_cr = clk;
		end	
		
		
endmodule