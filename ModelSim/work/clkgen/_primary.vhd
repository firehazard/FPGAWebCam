library verilog;
use verilog.vl_types.all;
entity clkgen is
    port(
        clk100          : in     vl_logic;
        camclk          : out    vl_logic
    );
end clkgen;
