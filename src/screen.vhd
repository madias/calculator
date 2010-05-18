library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.calculator_pkg.all;
use work.textmode_vga_component_pkg.all;
use work.textmode_vga_pkg.all;
use work.textmode_vga_platform_dependent_pkg.all; 

-------------------------------------------------------------------------------
-- ENTITY
-------------------------------------------------------------------------------

entity screen is
   port (
	clk   : in  std_logic;
   reset : in  std_logic;
   mode  : in std_logic;
	keyboard_symbol: in CALCULATOR_SYMBOL_TYPE;
	calculation_value : in CALCULATOR_SYMBOL_TYPE;
	 
	hsync_n: out std_logic;
	vsync_n: out std_logic;
	r_0, r_1, r_2: out std_logic;
	g_0, g_1, g_2: out std_logic;
	b_0, b_1, b_2: out std_logic
	);
end screen;

-------------------------------------------------------------------------------
-- END ENTITY
-------------------------------------------------------------------------------


architecture behav of screen is
	
--IP-Core
	constant VGA_CLK_FREQ : integer := 25175000;
	constant BLINK_INTERVAL_MS : integer := 10;
   constant SYNC_STAGES : integer := 2; 
	
	signal command_sync : std_logic_vector(COMMAND_SIZE - 1 downto 0);
	signal command_data_sync : std_logic_vector(3*COLOR_SIZE + CHAR_SIZE - 1 downto 0);
	signal free_sync : std_logic;
	signal vga_clk_sync : std_logic;
	signal vga_res_n_sync : std_logic;
	signal vga_vsync_n_sync : std_logic;
	signal vga_hsync_n_sync : std_logic;
	signal vga_r0_sync : std_logic;
	signal vga_r1_sync : std_logic;
	signal vga_r2_sync : std_logic;
	signal vga_g0_sync : std_logic;
	signal vga_g1_sync : std_logic;
	signal vga_g2_sync : std_logic;
	signal vga_b0_sync : std_logic;
	signal vga_b1_sync : std_logic; 
	
--module signals
	type SCREEN_FSM_STATE_TYPE is (START, NUMBER_PARSED, OPERATOR_PARSED, PAUSE_FOR_RS232, ERROR_STATE);
	signal screen_fsm_state, screen_fsm_state_next : SCREEN_FSM_STATE_TYPE;
begin

--module processes
	next_state : process (screen_fsm_state, keyboard_symbol, mode, calculation_value)
	begin
	end process next_state;

	output : process(screen_fsm_state)
	begin
		--case screen_fsm_state is
		--	when OPERATOR_PARSED =>
				
	end process output;
	
	sync :  process(clk, reset)
	begin
		if reset = '0' then
			screen_fsm_state <= START;
     elsif rising_edge(clk) then
			screen_fsm_state <= screen_fsm_state_next;
	 end if;
	end process sync;

--IP-Core
	vga_unit : textmode_vga
	generic map
	(
	VGA_CLK_FREQ => VGA_CLK_FREQ,
	BLINK_INTERVAL_MS => BLINK_INTERVAL_MS,
	SYNC_STAGES => SYNC_STAGES
	)
	port map
	(
-- internal user interface.
    sys_clk => clk,
    sys_res_n => reset,
	command => command_sync,
	command_data => command_data_sync,
	free => free_sync,
	-- external vga interface.
	vga_clk => vga_clk_sync,
	vga_res_n => vga_res_n_sync,
	vsync_n => vga_vsync_n_sync,
	hsync_n => vga_hsync_n_sync,
	r(0) => vga_r0_sync,
	r(1) => vga_r1_sync,
	r(2) => vga_r2_sync,
	g(0) => vga_g0_sync,
	g(1) => vga_g1_sync,
	g(2) => vga_g2_sync,
	b(0) => vga_b0_sync,
	b(1) => vga_b1_sync
); 

r_0 <= vga_r0_sync; r_1 <=vga_r1_sync; r_2 <=vga_r2_sync; g_0 <=vga_g0_sync; g_1 <= vga_g1_sync; g_2 <= vga_g2_sync; b_0 <=vga_b0_sync; b_1 <=vga_b1_sync;
hsync_n <= vga_hsync_n_sync; vsync_n <=vga_vsync_n_sync;

end behav;
