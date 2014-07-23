library verilog;
use verilog.vl_types.all;
entity pcpacket is
    port(
        rxclk           : in     vl_logic;
        camclk          : in     vl_logic;
        rxreset         : in     vl_logic;
        camreset        : in     vl_logic;
        rx_data         : in     vl_logic_vector(7 downto 0);
        rx_valid        : in     vl_logic;
        pccamvalid      : out    vl_logic;
        pccamdata       : out    vl_logic_vector(7 downto 0);
        fifoover        : out    vl_logic
    );
end pcpacket;
