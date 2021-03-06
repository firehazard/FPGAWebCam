library verilog;
use verilog.vl_types.all;
entity dffrei is
    generic(
        width           : integer := 1
    );
    port(
        d               : in     vl_logic_vector;
        en              : in     vl_logic;
        r               : in     vl_logic;
        clk             : in     vl_logic;
        q               : out    vl_logic_vector;
        initval         : in     vl_logic_vector
    );
end dffrei;
