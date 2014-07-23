onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Literal /testbench/dut/gmii_txd
add wave -noupdate -format Literal -radix unsigned /testbench/dut/tx_data_int
add wave -noupdate -format Logic /testbench/dut/tx_data_valid_int
add wave -noupdate -format Logic /testbench/dut/tx_underrun_int
add wave -noupdate -format Logic /testbench/dut/tx_retransmit_int
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
WaveRestoreZoom {119020567 ps} {120044567 ps}
configure wave -namecolwidth 202
configure wave -valuecolwidth 48
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
