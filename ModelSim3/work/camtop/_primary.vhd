library verilog;
use verilog.vl_types.all;
entity camtop is
    port(
        reset           : in     vl_logic;
        tx_data         : out    vl_logic_vector(7 downto 0);
        tx_data_valid   : out    vl_logic;
        tx_ack          : in     vl_logic;
        tx_clk          : in     vl_logic;
        rx_data         : in     vl_logic_vector(7 downto 0);
        rx_data_valid   : in     vl_logic;
        rx_clk          : in     vl_logic;
        overflow        : out    vl_logic;
        camclkin        : in     vl_logic;
        goo             : out    vl_logic;
        stopo           : out    vl_logic;
        pccamvalid      : out    vl_logic;
        fifoover        : out    vl_logic;
        sccb_c          : out    vl_logic;
        sccb_d          : out    vl_logic
    );
end camtop;
