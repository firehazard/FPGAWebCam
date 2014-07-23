library verilog;
use verilog.vl_types.all;
entity dffar is
    generic(
        width           : integer := 1
    );
    port(
        d               : in     vl_logic_vector;
        r               : in     vl_logic;
        clk             : in     vl_logic;
        q               : out    vl_logic_vector
    );
end dffar;
