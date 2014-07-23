library verilog;
use verilog.vl_types.all;
entity counter is
    generic(
        n               : integer := 3
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        en              : in     vl_logic;
        count           : out    vl_logic_vector
    );
end counter;
