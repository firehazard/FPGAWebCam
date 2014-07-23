library verilog;
use verilog.vl_types.all;
entity outputfifo is
    port(
        din             : in     vl_logic_vector(7 downto 0);
        wr_en           : in     vl_logic;
        wr_clk          : in     vl_logic;
        rd_en           : in     vl_logic;
        rd_clk          : in     vl_logic;
        ainit           : in     vl_logic;
        dout            : out    vl_logic_vector(7 downto 0);
        full            : out    vl_logic;
        empty           : out    vl_logic;
        rd_count        : out    vl_logic_vector(6 downto 0)
    );
end outputfifo;
