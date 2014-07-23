onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Top Level Signals}
add wave -noupdate -format Logic -label {MASTER RESET (ACTIVE LOW)} /testbench/dut/reset
add wave -noupdate -format Logic -label {GMII RX CLK} /testbench/gmii_rx_clk
add wave -noupdate -format Logic -label {RX CORE CLK} /testbench/dut/rx_clk
add wave -noupdate -format Logic -label {TX CORE CLK} /testbench/dut/tx_clk
add wave -noupdate -format Logic -label {CLK 100} /testbench/dut/clk100
add wave -noupdate -format Logic -label {CAM CLK 20} /testbench/dut/camera/camclk20
add wave -noupdate -format Logic -label {CAM CLK 40} /testbench/dut/camclk
add wave -noupdate -color Gold -format Literal -label {RX DATA IN} -radix hexadecimal /testbench/dut/gmii_rxd_reg
add wave -noupdate -color Gold -format Logic -label {RX DATA VALID IN} /testbench/dut/gmii_rx_dv_reg
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
add wave -noupdate -format Literal -label {DATA IN TO OUTPUT FIFO} -radix hexadecimal /testbench/dut/camera/cam_data_to_fifo
add wave -noupdate -color Yellow -format Logic -label {FIFO WRITE ENABLE} /testbench/dut/camera/cam_data_valid_to_fifo
add wave -noupdate -format Literal -label {OUTPUT FIFO DATA COUNT} -radix unsigned /testbench/dut/camera/fifodatacount
add wave -noupdate -color Aquamarine -format Logic -label HREF /testbench/dut/camera/href
add wave -noupdate -format Logic -label VSYNC /testbench/dut/camera/vsync
add wave -noupdate -color {Dark Orchid} -format Logic -label {VSYNC PULSE} /testbench/dut/camera/makepackets/vpulse
add wave -noupdate -color Salmon -format Literal -label {FIFO OUT} -radix hexadecimal /testbench/dut/camera/tx_data
add wave -noupdate -color Yellow -format Logic -label {FIFO READY} /testbench/dut/camera/fifoready
add wave -noupdate -color Blue -format Literal -label {FIFO READ ENABLE STATE} -radix unsigned /testbench/dut/camera/state
add wave -noupdate -format Logic -label {FIFO DRAIN ENABLE} /testbench/dut/camera/readenable
add wave -noupdate -color Gold -format Literal -label {DATA FROM CAM} -radix hexadecimal /testbench/dut/camera/makepackets/cameraData
add wave -noupdate -divider {PC PACKET SIGNALS}
add wave -noupdate -format Logic -label {RX RESET} /testbench/dut/camera/incoming/rxreset
add wave -noupdate -format Logic -label {RX CLK} /testbench/dut/camera/incoming/rxclk
add wave -noupdate -format Logic -label CAMCLK /testbench/dut/camera/incoming/camclk
add wave -noupdate -format Logic -label RX_VALID /testbench/dut/camera/incoming/rx_valid
add wave -noupdate -format Logic -label RX_VALID_PULSE /testbench/dut/camera/incoming/valid_pulse
add wave -noupdate -format Literal -label STATE -radix unsigned /testbench/dut/camera/incoming/state
add wave -noupdate -format Logic -label {FIFO TO PACKETIZER READY} /testbench/dut/camera/incoming/outfifoready
add wave -noupdate -format Literal -label {PACKET COUNTER} -radix unsigned /testbench/dut/camera/incoming/cpackcount12
add wave -noupdate -format Logic -label SCCB_DONE /testbench/dut/camera/incoming/done
add wave -noupdate -format Logic -label SCCB_DONE_PULSE /testbench/dut/camera/incoming/donepulse
add wave -noupdate -format Logic -label ISWRITE /testbench/dut/camera/incoming/iswrite
add wave -noupdate -format Logic -label SET_ISWRITE /testbench/dut/camera/incoming/set_iswrite
add wave -noupdate -divider {SCCB SIGNALS}
add wave -noupdate -format Logic -label {SCCB D} /testbench/dut/camera/sccb_d
add wave -noupdate -format Logic -label {SCCB C} /testbench/dut/camera/sbbc_c
add wave -noupdate -format Logic -label {WRITE REQUEST} /testbench/dut/camera/incoming/write_request
add wave -noupdate -format Literal -label {WRITE DATA} -radix hexadecimal /testbench/dut/camera/incoming/write_data
add wave -noupdate -format Literal -label ADDRESS -radix hexadecimal /testbench/dut/camera/incoming/address
add wave -noupdate -format Logic -label {READ REQUEST} /testbench/dut/camera/incoming/read_request
add wave -noupdate -format Literal -label {READ DATA} -radix hexadecimal /testbench/dut/camera/incoming/read_data
add wave -noupdate -format Logic -label REQUEST_ACK /testbench/dut/camera/incoming/request_ack
add wave -noupdate -divider {PC TO PCPACKET FIFO}
add wave -noupdate -format Literal -label RX_DATA -radix hexadecimal /testbench/dut/camera/incoming/rx_data
add wave -noupdate -format Logic -label {WRITE ENABLE} /testbench/dut/camera/incoming/fifowriteen
add wave -noupdate -format Literal -label {FIFO COUNT} -radix unsigned /testbench/dut/camera/incoming/fifocount
add wave -noupdate -format Logic -label {FIFO COUNT > 2} /testbench/dut/camera/incoming/fifoready
add wave -noupdate -format Literal -label {DATA OUT} -radix hexadecimal /testbench/dut/camera/incoming/fifo_out
add wave -noupdate -format Logic -label {READ ENABLE} /testbench/dut/camera/incoming/fiforeaden
add wave -noupdate -divider {PCPACKET TO PACKETIZER FIFO}
add wave -noupdate -format Literal -label {FIFO DATA IN } -radix hexadecimal /testbench/dut/camera/incoming/outfifoin
add wave -noupdate -format Logic -label {FIFO WRITE ENABLE} /testbench/dut/camera/incoming/outfifoen
add wave -noupdate -format Literal -label {OUT FIFO COUNT} -radix unsigned /testbench/dut/camera/incoming/outfifocount
add wave -noupdate -format Literal -label {FIFO DATA OUT} -radix hexadecimal /testbench/dut/camera/incoming/outfifodata
add wave -noupdate -format Logic -label {FIFO READ ENABLE} /testbench/dut/camera/incoming/readenpack
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {25124626 ps} 0}
WaveRestoreZoom {0 ps} {315 us}
configure wave -namecolwidth 296
configure wave -valuecolwidth 65
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
bookmark add wave firstpacket {{2955621 ps} {3532544 ps}} 0
bookmark add wave packet2 {{205833474 ps} {206457312 ps}} 0
