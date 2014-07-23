library verilog;
use verilog.vl_types.all;
entity resetsync is
    port(
        clk             : in     vl_logic;
        r1              : in     vl_logic;
        r2              : out    vl_logic
    );
end resetsync;
