# make a library, work
vlib work
vmap unisims_ver C:/Modeltech_5.7a/xilinx_libs/unisims_ver
vmap simprims_ver C:/Modeltech_5.7a/xilinx_libs/simprims_ver
vmap XilinxCoreLib_ver C:/Modeltech_5.7a/xilinx_libs/XilinxCoreLib_ver


vmap work work
vlog -work work \$XILINX/verilog/src/glbl.v


#vsim -L unisims_ver +no_tchk_msg +transport_int_delays +transport_path_delays -t ps work.testbench work.glbl
vsim -L simprims_ver -L unisims_ver -L XilinxCoreLib_ver work.testbench work.glbl

log -r /*