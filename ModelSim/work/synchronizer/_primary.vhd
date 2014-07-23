library verilog;
use verilog.vl_types.all;
entity synchronizer is
    generic(
        w               : integer := 1
    );
    port(
        clk1            : in     vl_logic;
        clk2            : in     vl_logic;
        rst             : in     vl_logic;
        \in\            : in     vl_logic_vector;
        \out\           : out    vl_logic_vector
    );
end synchronizer;
