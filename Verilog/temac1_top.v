//------------------------------------------------------------------------
//-- $Revision: 1.2.2.4 $ $Date: 2004/08/25 14:55:21 $
//------------------------------------------------------------------------
//-- File       : temac1_top.v  
//-- Author     : Xilinx Inc.
//------------------------------------------------------------------------
//-- Copyright (c) 2003 Xilinx Inc.
//------------------------------------------------------------------------
//-- Description: This is the top level verilog wrapper for the Tri-Mode  
//--              Ethernet MAC core and for the design example provided
//--              with it.
//--           
//--              This design example connects directly to the client 
//--              interface of the Tri-Mode Ethernet MAC core.  Frames
//--              received by the MAC are passed out of the MAC receiver
//--              client interface and passed into the design example.
//--              The design example provides a MAC client loopback 
//--              function so that frames which are received without error
//--              will be looped back to the MAC transmitter client 
//--              interface and transmitted back to the link partner. 
//--              
//--              This wrapper also instantiates IOB flip-flops and input/
//--              output buffers on the PHY side interface of the MAC
//--
//--              This wrapper for the Tri-Mode Ethernet MAC core and its
//--              design example can be synthesised, and if placed on a  
//--              suitable board, could be connected to test equipment to
//--              provide a basic proof of function for the core.
//--
//--
//--
//--    -----------------------------------------------------------
//--    |                                                          |
//--    |                   TOP LEVEL WRAPPER                      |
//--    |                                                          |
//--    |   ---------------------       -----------------------    |
//--    |   |  CLIENT LOOPBACK  |       |  TRI MODE           |    |
//--    |   |  DESIGN EXAMPLE   |       |  ETHERNET MAC       |    |
//--    |   |                   |       |  CORE               |    |
//--    |   |                   |       |                     |    |
//--    |   |          -------->|------>| Tx              Tx  |--------->   	    
//--    |   |          |        |       | client          PHY |    |    
//--    |   |          |        |       | I/F             I/F |    |
//--    |   |          |        |       |                     |    | GMII/MII
//--    |   |          |        |       |                     |    |
//--    |   |          |        |       |                     |    |
//--    |   |          |        |       | Rx              Rx  |    |
//--    |   |          |        |       | client          PHY |    |   
//--    |   |          ---------|<------| I/F             I/F |<---------
//--    |   |                   |       |                     |    |
//--    |   ---------------------       -----------------------    |
//--    |                                                          |
//--    ------------------------------------------------------------



module temac1_top
    ( //-- asynchronous reset     
      reset,   
      //------------------------------------------------------------------
      //-- Client Receiver Interface
      //------------------------------------------------------------------
      rx_clk,
      //------------------------------------------------------------------
      //-- Client Transmitter Interface
      //------------------------------------------------------------------
      tx_clk,    
      tx_ifg_delay,
      //------------------------------------------------------------------
      //-- MAC Control Interface
      //------------------------------------------------------------------
      pause_req,    
      pause_val, 
      //----------------------------------------------------------------
      //-- GMII Interface
      //----------------------------------------------------------------
      gtx_clk,    
      gmii_txd, 
      gmii_tx_en,    
      gmii_tx_er,    
      gmii_tx_clk,    
      
	 gmii_rxd, 
      gmii_rx_dv,  
      
	 gmii_rx_er,    
      gmii_rx_clk,
      gmii_col,
      gmii_crs,
      mii_tx_clk,
      //------------------------------------------------------------------
      //-- Configuration Vector
      //------------------------------------------------------------------
      //configuration_vector,
	 
	 phy_reset,
	 clk100,
	 LED_0,
	 LED_1,
	 LED_2,
	 LED_3
      );

      input  reset;
	 input clk100;                  
      output rx_clk;              
     
	 output phy_reset;
	 
      output tx_clk;    
      input  [7:0] tx_ifg_delay;
      input  pause_req;    
      input  [15:0] pause_val; 
      

      input  gtx_clk;    
      output [7:0] gmii_txd; 
      output gmii_tx_en;    
      output gmii_tx_er;    
      output gmii_tx_clk;    
      input  [7:0] gmii_rxd; 
      input  gmii_rx_dv;    
      
      input  gmii_rx_er;    
      input  gmii_rx_clk;
      input  gmii_col;
      input  gmii_crs;
      input  mii_tx_clk;

	 output LED_0, LED_1, LED_2, LED_3;
	 wire led1,led2,led3,led4;
	 assign LED_0 = ~led1;
	 assign LED_1 = ~led2;
	 assign LED_2 = ~led3;
	 assign LED_3 = ~led4;


 
  //----------------------------------------------------------------------
  //-- internal signals used in this top level wrapper.
  //----------------------------------------------------------------------

  wire gtx_clk_ibufg;                    // gtx_clk routed through an IBUFG.
  wire gmii_tx_clk_int;                  // Internal GMII/MII transmit clock. 
  wire not_gmii_tx_clk_int;              // gmii_tx_clk_int routed through an inverter.
  wire gmii_tx_clk_obuf;                 // gmii_tx_clk_int routed to an OBUF.
  
  wire gmii_tx_en_int;                   // Internal gmii_tx_en signal. 
  wire gmii_tx_er_int;                   // Internal gmii_tx_er signal.
  wire [7:0] gmii_txd_int;               // Internal gmii_txd signal.
  reg gmii_tx_en_reg;                    // gmii_tx_en registered in IOBs.
  reg gmii_tx_er_reg;                    // gmii_tx_er registered in IOBs.
  reg [7:0] gmii_txd_reg;                // gmii_txd registered in IOBs.
  
  wire gmii_rx_clk_ibufg;                // gmii_rx_clk routed through an IBUFG.
  wire gmii_rx_clk_bufg;                 // gmii_rx_clk_ibufg routed through a BUFG.

  
  wire gmii_rx_dv_ibuf;                  // gmii_rx_dv routed through an IBUF. 
  wire gmii_rx_er_ibuf;                  // gmii_rx_er routed through an IBUF.
  wire [7:0] gmii_rxd_ibuf;              // gmii_rxd routed through an IBUF.
  reg gmii_rx_dv_reg;                    // gmii_rx_dv_ibuf registered in IOBs.
  reg gmii_rx_er_reg;                    // gmii_rx_er_ibuf registered in IOBs.
  reg [7:0] gmii_rxd_reg;                // gmii_rxd_ibuf registered in IOBs.
  wire reset_int;                        // Internal reset signal.   
  wire rx_clk_int;                       // Internal receiver core clock signal
  wire rx_good_frame_int;                // rx_good_frame signal routed from MAC to client loopback design example.
  wire rx_bad_frame_int;                 // rx_bad_frame signal routed from MAC to client loopback design example.
  wire [7:0] rx_data_int;                // rx_data signal routed from MAC to client loopback design example.
  wire rx_data_valid_int;                // rx_data_valid signal routed from MAC to client loopback design example.
 
  wire tx_clk_int;                       // Internal transmitter core clock signal.
  wire [7:0] tx_data_int;                // tx_data signal routed from client loopback design example to MAC core.
  wire tx_data_valid_int;                // tx_data_valid signal routed from client loopback design example to MAC core.
  wire tx_underrun_int;                  // tx_underrun signal routed from client loopback design example to MAC core.
  wire tx_ack_int;                       // tx_ack signal routed from client loopback design example to MAC core.
  wire [7:0] tx_ifg_delay_int;           // Internal tx_ifg_delay signal.
 
  wire tx_collision_int;                 // Internal tx_collision signal.
  wire tx_retransmit_int;                // Internal tx_retransmit signal.
  wire pause_req_int;                    // Internal pause_req signal.
  wire[15:0] pause_val_int;              // Internal pause_val signal.
										 

  wire [66:0] configuration_vector_int; // Internal configuration_vector signal.

  wire rx_gmii_mii_clk_int;              // Internal receive gmii/mii clock signal.
  wire tx_gmii_mii_clk_int;              // Internal transmit gmii/mii clock signal.
  wire mii_tx_clk_ibufg;                 // mii_tx_clk routed through an IBUFG.

  wire gmii_col_int;                     // Collision signal from the gmii/mii routed through an IBUF.
  wire gmii_crs_int;                     // Carrier Sense signal from the gmii/mii routed through an IBUF.


  //synthesis attribute max_fanout of rx_clk_int is 1000

  //synthesis attribute keep of tx_data_int       is "true";
  //synthesis attribute keep of tx_data_valid_int is "true";
  //synthesis attribute keep of tx_underrun_int   is "true";

   assign phy_reset= ~reset_int;
  
   wire rxdiv2;
   wire txdiv2;

   clk_half divide (.reset(reset_int),.clk(mii_tx_clk_ibufg),.clk_div2(txdiv2));
   clk_half divide2(.reset(reset_int),.clk(gmii_rx_clk_bufg),.clk_div2(rxdiv2));
   BUFG clkbuff1(.I(mii_tx_clk_ibufg), .O(tx_gmii_mii_clk_int));
   BUFG clkbuff2(.I(rxdiv2), .O(rx_clk_int));
   BUFG clkbuff3(.I(txdiv2), .O(tx_clk_int));

    assign rx_gmii_mii_clk_int=gmii_rx_clk_bufg;
    assign gmii_tx_clk_int = tx_gmii_mii_clk_int;



  //----------------------------------------------------------------------
  //-- gtx_clk Clock Management
  //----------------------------------------------------------------------

   IBUF ibufg_gtx_clk (.I(gtx_clk),           .O(gtx_clk_ibufg));

  //----------------------------------------------------------------------
  //-- GMII Transmitter Clock Management : drive gmii_tx_clk through IOB onto GMII interface
  //----------------------------------------------------------------------

   //-- gmii_tx_clk_int is inverted.  This inversion will take place 
   //-- locally in IOBs.
   INV invert_gmii_tx_clk_int(.I(gmii_tx_clk_int), .O(not_gmii_tx_clk_int));


   //-- Instantiate a DDR output register.  This is a good way to 
   //-- drive GMII_TX_CLK since the clock-to-PAD delay will be the same 
   //-- as that for data driven from IOB Ouput flip-flops eg gmii_rxd[7:0].  
   //-- This is set to produce an inverted clock w.r.t. gmii_tx_clk_int 
   //-- so that the rising edge is centralised within the 
   //-- gmii_rxd[7:0] valid window.
   FDDRRSE gmii_tx_clk_ddr_iob
        (.Q(gmii_tx_clk_obuf), 
         .D0(1'b0),
         .D1(1'b1),
         .C0(gmii_tx_clk_int),
         .C1(not_gmii_tx_clk_int), 
         .CE(1'b1), 
         .R(1'b0), 
         .S(1'b0) 
      );

   //--  drive clock through Output Buffers and onto PADS.
   OBUF drive_gmii_tx_clk(.I(gmii_tx_clk_obuf), .O(gmii_tx_clk));
  //----------------------------------------------------------------------
  //-- GMII Transmitter Logic : drive TX signals through IOBs onto 
  //-- GMII interface
  //----------------------------------------------------------------------
  //-- Infer IOB Output flip-flops.
  always @(posedge gmii_tx_clk_int or posedge reset_int)
  begin
    if (reset_int == 1'b1)
    begin
      gmii_tx_en_reg <= 1'b0;
      gmii_tx_er_reg <= 1'b0;
      gmii_txd_reg   <= 8'h00;
    end
    else
    begin
      gmii_tx_en_reg <= gmii_tx_en_int;
      gmii_tx_er_reg <= gmii_tx_er_int;
      gmii_txd_reg   <= gmii_txd_int;
    end
  end


  //--  drive GMII Tx signals through Output Buffers and onto PADS.
  OBUF drive_gmii_tx_en(.I(gmii_tx_en_reg), .O(gmii_tx_en));
  OBUF drive_gmii_tx_er(.I(gmii_tx_er_reg), .O(gmii_tx_er));

  IBUF drive_gmii_col(.I(gmii_col), .O(gmii_col_int));
  IBUF drive_gmii_crs(.I(gmii_crs), .O(gmii_crs_int));

  OBUF drive_gmii_txd0(.I(gmii_txd_reg[0]), .O(gmii_txd[0]));
  OBUF drive_gmii_txd1(.I(gmii_txd_reg[1]), .O(gmii_txd[1]));
  OBUF drive_gmii_txd2(.I(gmii_txd_reg[2]), .O(gmii_txd[2]));
  OBUF drive_gmii_txd3(.I(gmii_txd_reg[3]), .O(gmii_txd[3]));
  OBUF drive_gmii_txd4(.I(gmii_txd_reg[4]), .O(gmii_txd[4]));
  OBUF drive_gmii_txd5(.I(gmii_txd_reg[5]), .O(gmii_txd[5]));
  OBUF drive_gmii_txd6(.I(gmii_txd_reg[6]), .O(gmii_txd[6]));
  OBUF drive_gmii_txd7(.I(gmii_txd_reg[7]), .O(gmii_txd[7]));

  //----------------------------------------------------------------------
  //-- GMII Receiver Clock Management : receive RX_CLK through IOBs from 
  //-- GMII interface
  //----------------------------------------------------------------------

   //-- Route gmii_rx_clk through an IBUFG and then through a BUFG 
   //-- (onto Global Clock Routing)
   IBUFG ibufg_gmii_rx_clk(.I(gmii_rx_clk),     .O(gmii_rx_clk_ibufg));

   // Route gmii_rx_clk_ibufg through a BUFG and onto global clock routing
   BUFG bufg_gmii_rx_clk (.I(gmii_rx_clk_ibufg), .O(gmii_rx_clk_bufg));

   IBUF ibufg_mii_tx_clk(.I(mii_tx_clk),        .O(mii_tx_clk_ibufg));

  //----------------------------------------------------------------------
  //-- GMII Receiver Logic : receive RX signals through IOBs from GMII interface
  //----------------------------------------------------------------------
   
  //--  Drive input GMII Rx signals from PADS through Input Buffers. 
  IBUF drive_gmii_rx_dv(.I(gmii_rx_dv), .O(gmii_rx_dv_ibuf));
  IBUF drive_gmii_rx_er(.I(gmii_rx_er), .O(gmii_rx_er_ibuf));

  IBUF drive_gmii_rxd0(.I(gmii_rxd[0]), .O(gmii_rxd_ibuf[0]));
  IBUF drive_gmii_rxd1(.I(gmii_rxd[1]), .O(gmii_rxd_ibuf[1]));
  IBUF drive_gmii_rxd2(.I(gmii_rxd[2]), .O(gmii_rxd_ibuf[2]));
  IBUF drive_gmii_rxd3(.I(gmii_rxd[3]), .O(gmii_rxd_ibuf[3]));
  IBUF drive_gmii_rxd4(.I(gmii_rxd[4]), .O(gmii_rxd_ibuf[4]));
  IBUF drive_gmii_rxd5(.I(gmii_rxd[5]), .O(gmii_rxd_ibuf[5]));
  IBUF drive_gmii_rxd6(.I(gmii_rxd[6]), .O(gmii_rxd_ibuf[6]));
  IBUF drive_gmii_rxd7(.I(gmii_rxd[7]), .O(gmii_rxd_ibuf[7]));

  //-- Infer IOB Input flip-flops.
  always @(posedge rx_gmii_mii_clk_int or posedge reset_int)
  begin
    if (reset_int == 1'b1)
	begin
       gmii_rx_dv_reg <= 1'b0;
       gmii_rx_er_reg <= 1'b0;
       gmii_rxd_reg   <= 8'h00;
	end
    else
	begin
       gmii_rx_dv_reg <= gmii_rx_dv_ibuf;
       gmii_rx_er_reg <= gmii_rx_er_ibuf;
       gmii_rxd_reg   <= gmii_rxd_ibuf;
	end
  end
  


  //----------------------------------------------------------------------
  //-- Instantiate the TRIMAC core
  //----------------------------------------------------------------------
  
  temac1 trimac_core( 
      .reset(reset_int),

      .emacphytxd(gmii_txd_int),
      .emacphytxen(gmii_tx_en_int),
      .emacphytxer(gmii_tx_er_int), //
      .phyemaccrs(gmii_crs_int),
      .phyemaccol(gmii_col_int),   //
      .phyemacrxd(gmii_rxd_reg),
      .phyemacrxdv(gmii_rx_dv_reg),
      .phyemacrxer(gmii_rx_er_reg),
      
      .clientemactxd(tx_data_int),
      .clientemactxdvld(tx_data_valid_int),
      .emacclienttxack(tx_ack_int), //
      .clientemactxunderrun(1'b0), //was tx_underrun_int -td
      .emacclienttxcollision(tx_collision_int),
      .emacclienttxretransmit(tx_retransmit_int),
      .clientemactxifgdelay(tx_ifg_delay_int),
      .clientemacpausereq(pause_req_int),
      .clientemacpauseval(pause_val_int),

      .emacclientrxd(rx_data_int),
      .emacclientrxdvld(rx_data_valid_int),
      .emacclientrxgoodframe(rx_good_frame_int),
      .emacclientrxbadframe(rx_bad_frame_int),
       
      .tieemacconfigvec(configuration_vector_int),
       
      .txcoreclk(tx_clk_int),
      .rxcoreclk(rx_clk_int),
      .txgmiimiiclk(tx_gmii_mii_clk_int),
      .rxgmiimiiclk(rx_gmii_mii_clk_int),
      .speedis100(),
      .speedis10100(),      

      .corehassgmii(1'b0)
      );


 clkgen gen40(clk100,camclk);

 assign led3=tx_data_valid_int;
 assign led2=rx_data_valid_int;
 //rx_data_valid_intassign led1=

 camtop camera
    (.reset(reset_int),
     .tx_data(tx_data_int),
     .tx_data_valid(tx_data_valid_int),
     //.tx_underrun(tx_underrun_int),
     .tx_ack(tx_ack_int),
     .tx_clk(tx_clk_int),
     .rx_data(rx_data_int), 
     .rx_data_valid(rx_data_valid_int), 
     .rx_clk(rx_clk_int),
    //.tx_collision(tx_collision_int),
    // .tx_retransmit(tx_retransmit_int),
     .camclkin(camclk),
	.goo(),
	.stopo(),
	.overflow(led4),
	.pccamvalid(),
	.fifoOver(led1)
    );
 
      
  //----------------------------------------------------------------------
  //-- The following logic deals with the remaining client connections 
  //-- to the core.  These are designed to be internal connections within 
  //-- the FPGA fabric.  IOB's are placed on these only for the purpose of
  //-- allowing the core and design example to be implemented in an FPGA 
  //-- device and simulated using the demonstration testbench provided.
  //-- 
  //-- These remaining client connections can be summarised as:
  //--    * Transmitter and Receiver Statistic Vectors
  //--    * Management Interface (or Configuration Vector)
  //--    * Flow Control interface
  //----------------------------------------------------------------------

  wire reset_int_not;
  IBUF reset_i(.I(reset), .O(reset_int_not));
  
  assign reset_int=~reset_int_not;
                         
  OBUF rx_clk_o(.I(rx_clk_int), .O(rx_clk));   

   OBUF tx_clk_o(.I(tx_clk_int), .O(tx_clk));  
         
   IBUF tx_ifg_delay_i0(.I(tx_ifg_delay[0]), .O(tx_ifg_delay_int[0]));
   IBUF tx_ifg_delay_i1(.I(tx_ifg_delay[1]), .O(tx_ifg_delay_int[1]));
   IBUF tx_ifg_delay_i2(.I(tx_ifg_delay[2]), .O(tx_ifg_delay_int[2]));
   IBUF tx_ifg_delay_i3(.I(tx_ifg_delay[3]), .O(tx_ifg_delay_int[3]));
   IBUF tx_ifg_delay_i4(.I(tx_ifg_delay[4]), .O(tx_ifg_delay_int[4]));
   IBUF tx_ifg_delay_i5(.I(tx_ifg_delay[5]), .O(tx_ifg_delay_int[5]));
   IBUF tx_ifg_delay_i6(.I(tx_ifg_delay[6]), .O(tx_ifg_delay_int[6]));
   IBUF tx_ifg_delay_i7(.I(tx_ifg_delay[7]), .O(tx_ifg_delay_int[7]));        
          
   IBUF pause_req_i(.I(pause_req), .O(pause_req_int));  
            
   IBUF pause_val_i0(.I(pause_val[0]), .O(pause_val_int[0]));           
   IBUF pause_val_i1(.I(pause_val[1]), .O(pause_val_int[1]));
   IBUF pause_val_i2(.I(pause_val[2]), .O(pause_val_int[2]));
   IBUF pause_val_i3(.I(pause_val[3]), .O(pause_val_int[3]));
   IBUF pause_val_i4(.I(pause_val[4]), .O(pause_val_int[4]));
   IBUF pause_val_i5(.I(pause_val[5]), .O(pause_val_int[5]));
   IBUF pause_val_i6(.I(pause_val[6]), .O(pause_val_int[6]));
   IBUF pause_val_i7(.I(pause_val[7]), .O(pause_val_int[7]));
   IBUF pause_val_i8(.I(pause_val[8]), .O(pause_val_int[8]));
   IBUF pause_val_i9(.I(pause_val[9]), .O(pause_val_int[9]));
   IBUF pause_val_i10(.I(pause_val[10]), .O(pause_val_int[10]));           
   IBUF pause_val_i11(.I(pause_val[11]), .O(pause_val_int[11]));
   IBUF pause_val_i12(.I(pause_val[12]), .O(pause_val_int[12]));
   IBUF pause_val_i13(.I(pause_val[13]), .O(pause_val_int[13]));
   IBUF pause_val_i14(.I(pause_val[14]), .O(pause_val_int[14]));
   IBUF pause_val_i15(.I(pause_val[15]), .O(pause_val_int[15]));                  

   
   assign configuration_vector_int[47:0]= 48'b0;
   assign configuration_vector_int[49]=1'b0;
   assign configuration_vector_int[50]=1'b1;
   assign configuration_vector_int[51]=1'b0;
   assign configuration_vector_int[52]=1'b0;
   assign configuration_vector_int[53]=1'b0;
   assign configuration_vector_int[54]=1'b0;
   assign configuration_vector_int[55]=1'b0;
   assign configuration_vector_int[56]=1'b0;
   assign configuration_vector_int[57]=1'b1;
   assign configuration_vector_int[58]=1'b0;
   assign configuration_vector_int[59]=1'b1;      
   assign configuration_vector_int[60]=1'b0;
   assign configuration_vector_int[61]=1'b0;
   assign configuration_vector_int[62]=1'b0;
   assign configuration_vector_int[63]=1'b0;
   assign configuration_vector_int[64]=1'b0;

   assign configuration_vector_int[55]=1'b0;
   assign configuration_vector_int[48]=1'b0;
   assign configuration_vector_int[65]=1'b1;
   assign configuration_vector_int[66]=1'b0;

  
endmodule