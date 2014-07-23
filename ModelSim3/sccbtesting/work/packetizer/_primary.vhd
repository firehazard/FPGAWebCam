library verilog;
use verilog.vl_types.all;
entity packetizer is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        cameradata      : in     vl_logic_vector(7 downto 0);
        camera_href     : in     vl_logic;
        cameravsync     : in     vl_logic;
        outfifo         : out    vl_logic_vector(8 downto 0);
        fifodata_valid  : out    vl_logic;
        camerastatusbits: in     vl_logic_vector(7 downto 0);
        go              : in     vl_logic;
        stop            : in     vl_logic;
        outfifoready    : in     vl_logic;
        outfifoenable   : out    vl_logic
    );
end packetizer;
