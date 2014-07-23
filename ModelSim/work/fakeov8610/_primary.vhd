library verilog;
use verilog.vl_types.all;
entity fakeov8610 is
    port(
        xclk            : in     vl_logic;
        pclk            : out    vl_logic;
        href            : out    vl_logic;
        ov_vs           : out    vl_logic;
        ov_hs           : out    vl_logic;
        y               : out    vl_logic_vector(7 downto 0);
        reset_b         : in     vl_logic;
        serialin        : in     vl_logic_vector(7 downto 0);
        serial_write_en : in     vl_logic;
        camerastatusbits: out    vl_logic_vector(7 downto 0);
        controldatarequest: in     vl_logic_vector(7 downto 0);
        go              : out    vl_logic;
        stop            : out    vl_logic
    );
end fakeov8610;
