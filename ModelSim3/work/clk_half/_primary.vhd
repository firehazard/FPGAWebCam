library verilog;
use verilog.vl_types.all;
entity clk_half is
    port(
        reset           : in     vl_logic;
        clk             : in     vl_logic;
        clk_div2        : out    vl_logic
    );
end clk_half;
