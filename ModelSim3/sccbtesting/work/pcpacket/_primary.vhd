library verilog;
use verilog.vl_types.all;
entity pcpacket is
    port(
        rxclk           : in     vl_logic;
        rxreset         : in     vl_logic;
        rx_data         : in     vl_logic_vector(7 downto 0);
        rx_valid        : in     vl_logic;
        fifoover        : out    vl_logic;
        sccb_d          : out    vl_logic;
        sccb_c          : out    vl_logic;
        readenpack      : in     vl_logic;
        camclk          : in     vl_logic;
        outfifodata     : out    vl_logic_vector(7 downto 0);
        outfifoready    : out    vl_logic
    );
end pcpacket;
