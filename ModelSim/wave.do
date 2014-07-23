view structure																												
view signals																												
view wave																										     
																															     
onerror {resume}																											     
quietly WaveActivateNextPane {} 0																							     
add wave -noupdate -divider {System Signals}
add wave -noupdate -format Logic /testbench/gtx_clk
add wave -noupdate -divider {Tx Client Interface}
add wave -noupdate -format Logic /testbench/dut/tx_clk_int
add wave -noupdate -format Logic /testbench/dut/tx_ack_int
add wave -noupdate -format Logic -hex /testbench/dut/tx_data_valid_int
add wave -noupdate -format Literal -hex /testbench/dut/tx_data_int
add wave -noupdate -divider {Rx Client Interface}
add wave -noupdate -format Logic /testbench/dut/rx_clk_int
add wave -noupdate -format Logic /testbench/dut/rx_data_valid_int
add wave -noupdate -format Literal -hex /testbench/dut/rx_data_int
add wave -noupdate -format Logic /testbench/dut/rx_good_frame_int
add wave -noupdate -format Logic /testbench/dut/rx_bad_frame_int
add wave -noupdate -divider {Tx GMII/MII Interface}
add wave -noupdate -format Logic /testbench/gmii_tx_clk
add wave -noupdate -format Logic /testbench/gmii_tx_en
add wave -noupdate -format Logic /testbench/gmii_tx_er
add wave -noupdate -format Literal -hex /testbench/gmii_txd
add wave -noupdate -divider {Rx GMII/MII Interface}
add wave -noupdate -format Logic /testbench/gmii_rx_clk
add wave -noupdate -format Logic /testbench/gmii_rx_dv
add wave -noupdate -format Logic /testbench/gmii_rx_er
add wave -noupdate -format Literal -hex /testbench/gmii_rxd
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
WaveRestoreZoom {0 ps} {4310754 ps}
