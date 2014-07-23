library verilog;
use verilog.vl_types.all;
entity sccb is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        sccb_d          : inout  vl_logic;
        sccb_c          : out    vl_logic;
        read_request    : in     vl_logic;
        write_request   : in     vl_logic;
        write_data      : in     vl_logic_vector(7 downto 0);
        write_addr      : in     vl_logic_vector(7 downto 0);
        read_addr       : in     vl_logic_vector(7 downto 0);
        read_data       : out    vl_logic_vector(7 downto 0);
        done            : out    vl_logic
    );
end sccb;
