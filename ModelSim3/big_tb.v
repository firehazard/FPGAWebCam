
//`timescale 1ps / 1ps

// This module is the demonstration testbench
module testbench;


  // Define constants values....



  //--------------------------------------------------------------------
  // types to support frame data
  //--------------------------------------------------------------------

  // Delay to provide setup and hold timing at the GMII/RGMII.
  parameter dly = 6000;  // 4000 ps


  // testbench signals
  reg         reset;                
  wire        tx_clk;               
  reg  [7:0]  tx_ifg_delay;         
  wire        rx_clk;               
  wire [15:0] pause_val;            
  wire        pause_req;            
  reg         gtx_clk;              
  wire        gmii_tx_clk;          
  wire        gmii_tx_en;           
  wire        gmii_tx_er;           
  wire [7:0]  gmii_txd;             
  wire        gmii_rx_clk;          
  reg         gmii_rx_dv;           
  reg         gmii_rx_er;           
  reg  [7:0]  gmii_rxd;

  reg         mii_tx_clk100;
  reg         mii_tx_clk10;
  reg         mii_tx_clk;

  wire        gmii_col;
  wire        gmii_crs;
  
  reg camclk;
  reg clk100;
  
  // testbench control semaphores
  reg  management_config_finished;
  reg  tx_monitor_finished_1G;
  reg  tx_monitor_finished_10M;
  reg  tx_monitor_finished_100M;
  wire test_half_duplex;

  reg [1:0] current_speed;
reg gmii_rx_dv2;
reg [7:0] gmii_rxd2;
  assign test_half_duplex = 1'b0;
	wire phy_reset;
  //--------------------------------------------------------------------
  // Wire up Device Under Test
  //--------------------------------------------------------------------
  temac1_top dut
     (.reset(~reset), //ok
      //------------------------------------------------------------------------
      //-- Receiver Interface.
      //------------------------------------------------------------------------
      .rx_clk(rx_clk), //ok
      //.rx_statistics_vector(rx_statistics_vector),
      //.rx_statistics_valid(rx_statistics_valid),  
      //------------------------------------------------------------------------
      //-- Transmitter Interface
      //------------------------------------------------------------------------
      .tx_clk(tx_clk), //ok
      .tx_ifg_delay(tx_ifg_delay),        
      //.tx_statistics_vector(tx_statistics_vector),
      //.tx_statistics_valid(tx_statistics_valid), 
      //------------------------------------------------------------------------
      //-- Flow Control
      //------------------------------------------------------------------------
      .pause_req(pause_req), //ok
      .pause_val(pause_val), //ok
      //------------------------------------------------------------------------
      //-- GMII Interface
      //------------------------------------------------------------------------
      .gtx_clk(1'b0), //ok

      .gmii_txd(gmii_txd), //ok
      .gmii_tx_en(gmii_tx_en), //ok
      .gmii_tx_er(gmii_tx_er), //ok
      .gmii_tx_clk(gmii_tx_clk), //ok
      .gmii_rxd(gmii_rxd2), //ok
      .gmii_rx_dv(gmii_rx_dv2), //ok
      .gmii_rxd2(gmii_rxd), //ok
      .gmii_rx_dv2(gmii_rx_dv), //ok
      .gmii_rx_er(1'b0), //changed from gmii_rx_er -td
      .gmii_rx_clk(gmii_rx_clk), //ok
      .gmii_crs(gmii_crs), // changed from gmii_crs
      .gmii_col(1'b0), //changed from gmii_col
      .mii_tx_clk(mii_tx_clk), //ok     
       .phy_reset(phy_reset),
       .clk100(clk100)
//       .camclk(camclk)
       );
  
  
  //--------------------------------------------------------------------
  // Flow Control held inactive
  //--------------------------------------------------------------------
  assign pause_req = 1'b0;
  assign pause_val = 16'h0;
  
  integer I;
  initial
  begin
	 gmii_rx_dv = 0;
	gmii_rxd = 8'd0;

  	gmii_rx_dv=1'b0;
  	gmii_rx_er=1'b0;
        // Adding the preamble field
          #401000;
      for (I = 0; I < 7; I = I + 1)
      begin
        #20000; 
        gmii_rxd   <= 8'h55;
        gmii_rx_dv <= 1'b1;
        @(posedge gmii_rx_clk);
      end

      // Adding the Start of Frame Delimiter (SFD)
      @(posedge gmii_rx_clk);
      gmii_rxd   <= 8'hD5;
      gmii_rx_dv <= 1'b1;
      @(posedge gmii_rx_clk); #1000;
      
 
     gmii_rx_dv=1'b1;
     gmii_rxd = 8'h0E;
     gmii_rx_er=1'b0;
     @(posedge gmii_rx_clk);  #1000;
     @(posedge gmii_rx_clk); #1000;
     
     
     gmii_rxd = 8'hDA;         
          @(posedge gmii_rx_clk); #1000;
          @(posedge gmii_rx_clk); #1000;
     gmii_rxd = 8'h02;
          @(posedge gmii_rx_clk); #1000;
          @(posedge gmii_rx_clk); #1000;
     gmii_rxd = 8'h03;
          @(posedge gmii_rx_clk); #1000;
          @(posedge gmii_rx_clk); #1000;
     gmii_rxd = 8'h04;
          @(posedge gmii_rx_clk); #1000;
          @(posedge gmii_rx_clk); #1000;
     gmii_rxd = 8'h05;
          @(posedge gmii_rx_clk); #1000;
          @(posedge gmii_rx_clk); #1000;
     gmii_rxd = 8'h06;
          @(posedge gmii_rx_clk); #1000;
          @(posedge gmii_rx_clk); #1000;
     gmii_rxd = 8'h5A;
          @(posedge gmii_rx_clk); #1000;
          @(posedge gmii_rx_clk); #1000;
     gmii_rxd = 8'h02;
          @(posedge gmii_rx_clk); #1000;
          @(posedge gmii_rx_clk); #1000;
     gmii_rxd = 8'h03;
          @(posedge gmii_rx_clk); #1000;
          @(posedge gmii_rx_clk); #1000;
     gmii_rxd = 8'h04;
          @(posedge gmii_rx_clk); #1000;
          @(posedge gmii_rx_clk); #1000;
     gmii_rxd = 8'h05;
          @(posedge gmii_rx_clk); #1000;
          @(posedge gmii_rx_clk); #1000;
     gmii_rxd = 8'd06;
          @(posedge gmii_rx_clk); #1000;
          @(posedge gmii_rx_clk); #1000;
     gmii_rxd = 8'd00;
          @(posedge gmii_rx_clk); #1000;
          @(posedge gmii_rx_clk); #1000;
     gmii_rxd = 8'h2E;		// Length/Type = Length = 46     
          @(posedge gmii_rx_clk); #1000;
          @(posedge gmii_rx_clk); #1000;
     gmii_rxd = 8'hFF;
        @(posedge gmii_rx_clk); #1000;
        @(posedge gmii_rx_clk); #1000;
          // REAL DATA STARTS HERE (?)
          // read/write byte
     gmii_rxd = 8'hFF;
          @(posedge gmii_rx_clk); #1000;
          @(posedge gmii_rx_clk); #1000;
          // address
     gmii_rxd = 8'hAA;
          @(posedge gmii_rx_clk); #1000;
          @(posedge gmii_rx_clk); #1000;
          // data
     gmii_rxd = 8'hDD;
          @(posedge gmii_rx_clk); #1000;
          @(posedge gmii_rx_clk); #1000;
	// zero pad
     gmii_rxd = 8'h00;
          @(posedge gmii_rx_clk); #1000;
          @(posedge gmii_rx_clk); #1000;
     #400000;          
     gmii_rx_dv=1'b0;
     
  end


  //--------------------------------------------------------------------
  // Clock drivers
  //--------------------------------------------------------------------

 
  
    initial                   // drives camclk at 40MHz
 begin
  camclk <= 1'b0;
    #12500;
    forever
    begin	 
      camclk <= 1'b0;
      #12500;
      camclk <= 1'b1;
      #12500;
    end
  end
  

  initial                   // drives mii_tx_clk at 25 MHz
  begin
    mii_tx_clk <= 1'b0;
    #20000;
    forever
    begin
      mii_tx_clk <= 1'b0;
      #20000;
      mii_tx_clk <= 1'b1;
      #20000;
    end
  end


 initial                   // drives mii_tx_clk at 100 MHz
  begin
    clk100 <= 1'b0;
    #5000;
    forever
    begin
      clk100 <= 1'b0;
      #5000;
      clk100 <= 1'b1;
      #5000;
    end
  end


  
  assign gmii_rx_clk = gmii_tx_clk;
  

  assign gmii_col = (gmii_tx_en | gmii_tx_er) & (gmii_rx_dv | gmii_rx_er);
  assign gmii_crs = (gmii_tx_en | gmii_tx_er) | (gmii_rx_dv | gmii_rx_er);

  initial
  begin : p_management        
    reset <= 1'b1;
    #200000;

    reset <= 1'b0;

  end // p_management
  


endmodule