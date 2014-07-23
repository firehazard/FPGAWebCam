library verilog;
use verilog.vl_types.all;
entity temac1_top is
    port(
        reset           : in     vl_logic;
        rx_clk          : out    vl_logic;
        tx_clk          : out    vl_logic;
        tx_ifg_delay    : in     vl_logic_vector(7 downto 0);
        pause_req       : in     vl_logic;
        pause_val       : in     vl_logic_vector(15 downto 0);
        gtx_clk         : in     vl_logic;
        gmii_txd        : out    vl_logic_vector(3 downto 0);
        gmii_tx_en      : out    vl_logic;
        gmii_tx_er      : out    vl_logic;
        gmii_tx_clk     : out    vl_logic;
        gmii_rxd        : in     vl_logic_vector(3 downto 0);
        gmii_rx_dv      : in     vl_logic;
        gmii_rx_er      : in     vl_logic;
        gmii_rx_clk     : in     vl_logic;
        gmii_col        : in     vl_logic;
        gmii_crs        : in     vl_logic;
        mii_tx_clk      : in     vl_logic;
        phy_reset       : out    vl_logic;
        clk100          : in     vl_logic;
        led_0           : out    vl_logic;
        led_1           : out    vl_logic;
        led_2           : out    vl_logic;
        led_3           : out    vl_logic
    );
end temac1_top;
