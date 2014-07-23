`define IDLE 3'd0
`define GET1 3'd1
`define GET2 3'd2
`define GET3 3'd3
`define WAIT_DONE 3'd4
`define UPDATE_FIFO1 3'd5
`define UPDATE_FIFO2 3'd6



module pcpacket(rxclk, rxreset, rx_data, rx_valid, fifoOver, sccb_d, sccb_c, readenpack, camclk, outfifodata, outfifoready);
   input rxclk, rx_valid, rxreset;
   input [7:0] rx_data;
   output fifoOver, sccb_d, sccb_c;
   output [7:0] outfifodata;
   input readenpack, camclk;
   output outfifoready;
   
   wire valid_pulse;
   wire fifowriteen;
   wire fifoEmpty;   
   wire [5:0] cpackcount12;
   wire [9:0] fifocount;
   wire donepulse;
   
   wire [7:0] fifo_out;
   wire iswrite, set_iswrite;
   
   wire done, request_ack, write_request, read_request;
   wire [7:0] read_data, write_data;
   wire [7:0] address;
   
   wire [2:0] state, nextstate;
   reg [2:0] nextstater;
   assign nextstate = rxreset? `IDLE: nextstater;
   dff #(3) masterfsm(.d(nextstate),.q(state),.clk(rxclk));
  
   
   dffre readrqff(.clk(rxclk),.d(~set_iswrite),.q(read_request),.r(rxreset | request_ack),.en(state==`GET1));
   dffre writerqff(.clk(rxclk),.d(set_iswrite),.q(write_request),.r(rxreset | request_ack),.en(state==`GET1));
   dffre #(8) addr_ff(.clk(rxclk),.d(fifo_out),.q(address),.r(rxreset),.en(state==`GET2));
   dffre #(8) writedataff(.clk(rxclk),.d(fifo_out),.q(write_data),.en(state==`GET3), .r(rxreset));
   

  
  wire fifoready = fifocount>10'd2; 
   
  always @ (state or fifoready or donepulse or iswrite)
  begin
  	case(state) 
  		`IDLE: nextstater = fifoready? `GET1: `IDLE;
  		`GET1: nextstater = `GET2;
  		`GET2: nextstater = `GET3;
  		`GET3: nextstater = `WAIT_DONE;
  		`WAIT_DONE: nextstater = (~donepulse)? `WAIT_DONE: iswrite? `IDLE: `UPDATE_FIFO1;
  		`UPDATE_FIFO1: nextstater = `UPDATE_FIFO2;
  		`UPDATE_FIFO2: nextstater = `IDLE;
  		default: nextstater = `IDLE;  
    	endcase
  end
  
   
   assign set_iswrite = fifo_out[0];
   dffre setwriteff(.clk(rxclk),.d(set_iswrite),.q(iswrite),.en(state==`GET1),.r(rxreset | donepulse));
   
  
  
  wire fiforeaden = (nextstate==`GET1) || (nextstate==`GET2) || (nextstate==`GET3);
  
  edge_detect done_edge(.clk(rxclk),.in(done),.out(donepulse));
  
    
  sccb controlsccb(.clk(rxclk),
                   .rst(rxreset),
                   .sccb_d(sccb_d), 
                   .sccb_c(sccb_c),
                   .read_request(read_request),
                   .write_request(write_request),
                   .write_data(write_data),
                   .write_addr(address),
                   .read_addr(address),
                   .read_data(read_data),
                   .done(done), 
                   .request_ack(request_ack)
                   );
   
  inputfifo infifo(
	.clk(rxclk),
	.sinit(rxreset),
	.din(rx_data),
	.wr_en(fifowriteen),
	.rd_en(fiforeaden),
	.dout(fifo_out),
	.full(fifoOver),
	.empty(fifoEmpty),
	.data_count(fifocount)
	);
	
   wire [7:0] outfifoin = (state==`UPDATE_FIFO1)? address: read_data; 
   wire outfifoen = (state==`UPDATE_FIFO1) || (state==`UPDATE_FIFO2);

   wire [6:0] outfifocount;

   
   assign outfifoready = outfifocount>7'd1;

   outputfifo outfifo(
	.din(outfifoin),
	.wr_en(outfifoen),
	.wr_clk(rxclk),
	.rd_en(readenpack),
	.rd_clk(camclk),
	.ainit(rxreset),
	.dout(outfifodata),
	.full(),
	.empty(),
	.rd_count(outfifocount)	
	);

   counter #(6) count(.clk(rxclk),.rst(valid_pulse|rxreset),.en(rx_valid & cpackcount12!=6'd63),.count(cpackcount12));
   assign fifowriteen = (cpackcount12>6'd13) & (cpackcount12<6'd17) & rx_valid; 
   
   edge_detect valid_edge(.clk(rxclk),.in(rx_valid),.out(valid_pulse));
	
endmodule