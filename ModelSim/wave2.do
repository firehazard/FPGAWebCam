onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /testbench/dut/camera/vsync
add wave -noupdate -format Logic /testbench/dut/camera/hsync
add wave -noupdate -format Logic /testbench/dut/camera/href
add wave -noupdate -format Logic /testbench/dut/camera/rx_data_valid
add wave -noupdate -format Logic /testbench/dut/camera/tx_data_valid
add wave -noupdate -format Logic /testbench/dut/camera/client_side_FIFO/rx_data_valid
add wave -noupdate -format Literal /testbench/dut/camera/client_side_FIFO/rx_data
add wave -noupdate -format Literal /testbench/dut/camera/client_side_FIFO/tx_data
add wave -noupdate -format Logic /testbench/dut/camera/client_side_FIFO/tx_reset
add wave -noupdate -format Logic /testbench/dut/camera/client_side_FIFO/rx_reset
add wave -noupdate -format Logic /testbench/dut/camera/client_side_FIFO/frame_in_fifo_held
add wave -noupdate -format Literal {/testbench/dut/camera/client_side_FIFO/tx_data_pipe[0]}
add wave -noupdate -format Logic /testbench/dut/camera/client_side_FIFO/col_no_retransmit
add wave -noupdate -format Logic /testbench/dut/camera/client_side_FIFO/tx_mem_enable
add wave -noupdate -format Literal /testbench/dut/camera/client_side_FIFO/tx_data_int
add wave -noupdate -format Logic /testbench/dut/camera/client_side_FIFO/rx_mem_enable
add wave -noupdate -format Literal /testbench/dut/camera/client_side_FIFO/rx_data_reg
add wave -noupdate -format Logic /testbench/dut/camera/client_side_FIFO/rx_dv_dv
add wave -noupdate -format Logic /testbench/dut/camera/client_side_FIFO/tx_dv_dv
add wave -noupdate -format Logic /testbench/dut/camera/client_side_FIFO/reset
add wave -noupdate -format Literal /testbench/dut/camera/client_side_FIFO/rx_addr
add wave -noupdate -format Literal /testbench/dut/camera/client_side_FIFO/tx_addr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {183679065 ps} 0}
WaveRestoreZoom {0 ps} {1175804721 ps}
configure wave -namecolwidth 357
configure wave -valuecolwidth 98
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
