onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Top Level Signals}
add wave -noupdate -format Logic -label {MASTER RESET (ACTIVE LOW)} /testbench/dut/reset
add wave -noupdate -format Logic -label {GMII RX CLK} /testbench/gmii_rx_clk
add wave -noupdate -format Logic -label {RX CORE CLK} /testbench/dut/rx_clk
add wave -noupdate -format Logic -label {TX CORE CLK} /testbench/dut/tx_clk
add wave -noupdate -format Logic -label {CAM CLK 40 MHz} /testbench/dut/camera/camclk40
add wave -noupdate -format Logic -label {CAM CLK 20 MHz} /testbench/dut/camera/camclk20
add wave -noupdate -color Gold -format Literal -label {RX DATA IN} -radix hexadecimal /testbench/dut/gmii_rxd_reg
add wave -noupdate -color Gold -format Logic -label {RX DATA VALID IN} /testbench/dut/gmii_rx_dv_reg
add wave -noupdate -format Logic -label {RX DATA ERROR IN} /testbench/dut/gmii_rx_er_reg
add wave -noupdate -format Literal -label {RX DATA OUT} -radix hexadecimal /testbench/dut/rx_data_int
add wave -noupdate -color Gray60 -format Logic -label {RX DATA VALID OUT} /testbench/dut/rx_data_valid_int
add wave -noupdate -color Gold -format Literal -label {TX_DATA OUT} -radix hexadecimal /testbench/dut/gmii_txd
add wave -noupdate -color Gold -format Logic -label {TX_DATA OUT VALID} /testbench/dut/gmii_tx_en
add wave -noupdate -color {Lime Green} -format Literal -label {TX DATA IN} -radix hexadecimal /testbench/dut/tx_data_int
add wave -noupdate -format Logic -label {TX DATA VALID IN} /testbench/dut/tx_data_valid_int
add wave -noupdate -divider {Camera Top Signals}
add wave -noupdate -format Logic -label {FIFO DRAIN ENABLE} /testbench/dut/camera/readenable
add wave -noupdate -color Salmon -format Literal -label {DATA FROM FIFO} -radix hexadecimal /testbench/dut/camera/tx_data
add wave -noupdate -color Gold -format Literal -label {PACKETIZER DATA TO FIFO} -radix hexadecimal /testbench/dut/camera/cam_data_to_fifo
add wave -noupdate -color Gold -format Logic -label {PACKETIZER DATA TO FIFO VALID} /testbench/dut/camera/cam_data_valid_to_fifo
add wave -noupdate -color Aquamarine -format Logic -label HREF /testbench/dut/camera/href
add wave -noupdate -color Aquamarine -format Logic -label HSYNC /testbench/dut/camera/hsync
add wave -noupdate -color Aquamarine -format Logic -label VSYNC /testbench/dut/camera/vsync
add wave -noupdate -divider Packetizer
add wave -noupdate -color Gold -format Literal -label {DATA FROM CAM} -radix hexadecimal /testbench/dut/camera/makepackets/cameraData
add wave -noupdate -color Gold -format Literal -label {DATA TO FIFO} -radix hexadecimal /testbench/dut/camera/makepackets/outFifo
add wave -noupdate -color Gold -format Logic -label {DATA TO FIFO VALID} /testbench/dut/camera/makepackets/FIFOdata_valid
add wave -noupdate -color {Medium Blue} -format Literal -label {Current State} -radix decimal /testbench/dut/camera/makepackets/currentState
add wave -noupdate -color Blue -format Literal -label {Next State} -radix unsigned /testbench/dut/camera/makepackets/nextState
add wave -noupdate -color Gray40 -format Literal -label {Data Length} -radix unsigned /testbench/dut/camera/makepackets/data_length
add wave -noupdate -color Gray80 -format Literal -label {Address Count} -radix unsigned /testbench/dut/camera/makepackets/addressCount
add wave -noupdate -format Logic -label {Reset Counter} /testbench/dut/camera/makepackets/resetCounter
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {352897 ps} 0}
WaveRestoreZoom {181125 ps} {1153824 ps}
configure wave -namecolwidth 247
configure wave -valuecolwidth 40
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
