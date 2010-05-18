-------------------------------------------------------------------------------
-- LIBRARIES
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.calculator_pkg.all;
use work.ps2_keyboard_controller_pkg.all;
use work.ps2_transceiver_pkg.all;
-------------------------------------------------------------------------------
-- ENTITY
-------------------------------------------------------------------------------

entity input is
  port (	
	clk   : in  std_logic;
   reset : in  std_logic;
	mode : in std_logic;
	calculator_ready : in std_logic;

	 keyboard_symbol : out CALCULATOR_SYMBOL_TYPE
	);
end input;

-------------------------------------------------------------------------------
-- END ENTITY
-------------------------------------------------------------------------------

architecture behav of input is

--IP-Core
	constant CLK_FREQ : integer := 33330000;
	constant SYNC_STAGES : integer := 2;

	signal new_data_sig : std_logic;
	signal data_sig : std_logic_vector(7 downto 0);
	signal ps2_clk_sig, ps2_data_sig : std_logic;

--module signals
	type INPUT_FSM_STATE_TYPE is (START, NUMBER_PARSED, OPERATOR_PARSED, PAUSE_FOR_RS232, ERROR_STATE);
	signal input_fsm_state, input_fsm_state_next : INPUT_FSM_STATE_TYPE;
begin

--module processes
	next_state : process (input_fsm_state, new_data_sig, mode)
	begin
		input_fsm_state_next <= input_fsm_state;
		if mode='1' then
			input_fsm_state_next <=PAUSE_FOR_RS232;
		end if;
	end process next_state;

	output : process(input_fsm_state)
	begin
		--case screen_fsm_state is
		--	when OPERATOR_PARSED =>
				
	end process output;
	
	sync :  process(clk, reset)
	begin
		if reset = '0' then
			input_fsm_state <= START;
     elsif rising_edge(clk) then
			input_fsm_state <= input_fsm_state_next;
	 end if;
	end process sync;
	
--IP-Core
	ps2_unit: ps2_keyboard_controller
	generic map
	(
	CLK_FREQ => CLK_FREQ,
	SYNC_STAGES => SYNC_STAGES
	)
	port map
	(
	sys_clk => clk,
	sys_res_n => reset,
	new_data => new_data_sig,
	data => data_sig,
	ps2_clk => ps2_clk_sig,
	ps2_data => ps2_data_sig
	);
end behav;

-------------------------------------------------------------------------------
-- END ARCHITECTURE
-------------------------------------------------------------------------------