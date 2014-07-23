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
add wave -noupdate -color Yellow -format Logic -label {TX ACK} /testbench/dut/camera/tx_ack
add wave -noupdate -divider {FIFO SIGNALS}
add wave -noupdate -color Gray80 -format Literal -label {HEADER COUNT} -radix unsigned /testbench/dut/camera/makepackets/addressCount
add wave -noupdate -color Blue -format Literal -label {FIFO WRITE STATE} -radix unsigned /testbench/dut/camera/makepackets/state
add wave -noupdate -color Gold -format Literal -label {FIFO IN DATA} -radix hexadecimal /testbench/dut/camera/fifoindebug
add wave -noupdate -color Gray50 -format Logic -label {FIFO VALID DATA IN} /testbench/dut/camera/fifovalidindebug
add wave -noupdate -color Yellow -format Logic -label {FIFO WRITE ENABLE} /testbench/dut/camera/cam_data_valid_to_fifo
add wave -noupdate -color Aquamarine -format Logic -label HREF /testbench/dut/camera/href
add wave -noupdate -color Aquamarine -format Logic -label VSYNC /testbench/dut/camera/vsync
add wave -noupdate -color {Dark Orchid} -format Logic -label {VSYNC PULSE} /testbench/dut/camera/makepackets/vpulse
add wave -noupdate -color Salmon -format Literal -label {FIFO OUT} -radix hexadecimal /testbench/dut/camera/tx_data
add wave -noupdate -color Yellow -format Logic -label {FIFO READY} /testbench/dut/camera/fifoready
add wave -noupdate -color Blue -format Literal -label {FIFO READ ENABLE STATE} -radix unsigned /testbench/dut/camera/state
add wave -noupdate -format Logic -label {FIFO DRAIN ENABLE} /testbench/dut/camera/readenable
add wave -noupdate -divider Packetizer
add wave -noupdate -color Gold -format Literal -label {DATA FROM CAM} -radix hexadecimal /testbench/dut/camera/makepackets/cameraData
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {137699395 ps} 0}
WaveRestoreZoom {137699395 ps} {169615683 ps}
configure wave -namecolwidth 254
configure wave -valuecolwidth 80
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
