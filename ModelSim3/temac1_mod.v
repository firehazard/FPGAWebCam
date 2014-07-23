/* $Revision: 1.2.2.1 $ $Date: 2004/08/02 13:07:47 $
 * Title       : Verilog component declaration for temac1 (the tri-mode MAC core)
 * Project     : Tri-Mode Ethernet MAC Core
 * File        : temac1_mod.v
 * Author      : Xilinx Inc.
 * Description : This module holds the Verilog component declaration for temac1 
 * (the Tri-Mode MAC core).
 * Copyright 2003 Xilinx Inc.
 */


/****************************************************************************
 * Component Declaration for trimac (the Tri-Mode MAC core).
 ****************************************************************************/
 module temac1
    ( reset,
      emacphytxd,
      emacphytxen,
      emacphytxer,
      phyemaccrs,
      phyemaccol,
      phyemacrxd,
      phyemacrxdv,
      phyemacrxer,
      
      clientemactxd,
      clientemactxdvld,
      emacclienttxack,
      clientemactxunderrun,
      emacclienttxcollision,
      emacclienttxretransmit,
      clientemactxifgdelay,
      clientemacpausereq,
      clientemacpauseval,

      emacclientrxd,
      emacclientrxdvld,
      emacclientrxgoodframe,
      emacclientrxbadframe,
 
      tieemacconfigvec,
       
      txcoreclk,
      rxcoreclk,
      txgmiimiiclk,
      rxgmiimiiclk,
      speedis100,
      speedis10100,      

      corehassgmii
      );

  // Port declarations

  input           reset;

  output [7:0]    emacphytxd;
  output          emacphytxen;
  output          emacphytxer;
  input           phyemaccrs;
  input           phyemaccol;
  input [7:0]     phyemacrxd;
  input           phyemacrxdv;
  input           phyemacrxer;
      
  input [7:0]     clientemactxd;
  input           clientemactxdvld;
  output          emacclienttxack;
  input           clientemactxunderrun;
  output          emacclienttxcollision;
  output          emacclienttxretransmit;
  input [7:0]     clientemactxifgdelay;
  input           clientemacpausereq;
  input [15:0]    clientemacpauseval;

  output [7:0]    emacclientrxd;
  output          emacclientrxdvld;
  output          emacclientrxgoodframe;
  output          emacclientrxbadframe;
       
  input [66:0]    tieemacconfigvec;
       
  input           txcoreclk;
  input           rxcoreclk;
  input           txgmiimiiclk;
  input           rxgmiimiiclk;
  output          speedis100;
  output          speedis10100;      

  input            corehassgmii;

endmodule // temac1  
   
