library verilog;
use verilog.vl_types.all;
entity video_timer is
    port(
        clk             : in     vl_logic;
        ticks_per_line  : in     vl_logic_vector(11 downto 0);
        lines_per_frame : in     vl_logic_vector(9 downto 0);
        hs_pix_start    : in     vl_logic_vector(11 downto 0);
        hs_pix_stop     : in     vl_logic_vector(11 downto 0);
        vs_pix_start    : in     vl_logic_vector(11 downto 0);
        vs_pix_stop     : in     vl_logic_vector(11 downto 0);
        vs_line_start   : in     vl_logic_vector(9 downto 0);
        vs_line_stop    : in     vl_logic_vector(9 downto 0);
        starting_line   : in     vl_logic_vector(9 downto 0);
        active_high_syncs: in     vl_logic;
        vsync           : out    vl_logic;
        hsync           : out    vl_logic;
        pix_counter     : out    vl_logic_vector(11 downto 0);
        line_counter    : out    vl_logic_vector(9 downto 0);
        reset_timer     : in     vl_logic;
        reset_b         : in     vl_logic
    );
end video_timer;
