module pcpacket(rxclk, camclk, rxreset, camreset, rx_data, rx_valid, pccamvalid, pccamdata, fifoOver);
   input rxclk, camclk, rx_valid, rxreset, camreset;
   input [7:0] rx_data;
   output pccamvalid;
   output [7:0] pccamdata;
   output fifoOver;
   wire valid_pulse;
   
   wire validin;
       
   wire fifowriteen;
   
   assign validin=rx_valid; 
   
   wire fifoOverflow;
   assign fifoOver=fifoOverflow;
   wire fifoEmpty;   
 	   
   wire countserialen;
   wire [5:0] cpackcount12;
     wire[4:0] serialCount;
      
   counter #(6) count(.clk(rxclk),.rst(valid_pulse|rxreset),.en(validin & cpackcount12!=6'd63),.count(cpackcount12));
   
   synchronizer syncpackcount(.clk1(rxclk),.clk2(camclk),.rst(rxreset),.in((cpackcount12>6'd30)),.out(countserialen));
   
   counter #(5) countSerial(.clk(camclk), .rst(camreset|serialCount==12), .en(~fifoEmpty & countserialen), .count(serialCount));
   			// was 15
   assign fifowriteen = (cpackcount12>6'd13) & (cpackcount12<6'd25) & validin; //valid control data range (might need to change)
   
   assign pccamvalid = (serialCount>5'd0 && ~fifoEmpty);
   
   wire intemp;
   dffr detectvalidedge(.clk(rxclk), .r(rxreset), .d(validin), .q(intemp));
   assign valid_pulse = validin & (~intemp);

	smallfifo fifoshift(
		.din(rx_data),
		.wr_en(fifowriteen),
		.wr_clk(rxclk),
		.rd_en(pccamvalid),
		.rd_clk(camclk),
		.ainit(rxreset | cpackcount12==6'd5),
		.dout(pccamdata),
		.full(fifoOverflow),
		.empty(fifoEmpty)
	);
	
	
endmodule