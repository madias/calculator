library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.calculator_pkg.all;

entity calculator is
  
  port (
    sys_clk   : in  std_logic;
    sys_res_n : in  std_logic;
	 mode : in std_logic;
    keyboard_symbol: in CALCULATOR_SYMBOL_TYPE;
	 memory_ready : in std_logic;

	 calculator_ready  : out std_logic;
	 calculation_value : out CALCULATOR_SYMBOL_TYPE;
	 expression_and_calculation : out CALCULATOR_SYMBOL_TYPE
	);

end calculator;

architecture behav of calculator is
 type CALCULATOR_FSM_STATE_TYPE is (START, NUMBER_PARSED, OPERATOR_PARSED, PAUSE_FOR_RS232, ERROR);
 signal calculator_fsm_state, calculator_fsm_state_next : CALCULATOR_FSM_STATE;
 signal operand : integer;
 signal result : integer;
 signal operator : integer;
 signal dummy_result: integer;
begin
	next_state : process (calcular_fsm_state, keyboard_symbol, mode, memory_ready)
	begin
		calculator_fsm_state_next <= calculator_fsm_state;
		case calculator_fsm_state is
			when START =>
			 if mode='1' then
					calculator_fsm_state <= PAUSE_FOR_RS232;
			 elsif keyboard_symbol.input_type=NUMBER then
					operand <= keyboard_symbol.input_value;
					operator <= -1;
			      calculator_fsm_state_next <= NUMBER_PARSED;
			 elsif keyboard_symbol.input_type=OPCODE then
					 if keyboard_symbol.input_value=SUB;
						calculator_fsm_state_next <= NUMBER_PARSED;
					 else 
					   calculator_fsm_state_next <= ERROR;
					 end if;
			 end if;
			when NUMBER_PARSED =>
			 if mode='1' then
					calculator_fsm_state_next <= PAUSE_FOR_RS232;
			  elsif keyboard_symbol.input_type=NUMBER then
					operand <= operand * 10 + keyboard_symbol.input_value;
			      calculator_fsm_state_next <= NUMBER_PARSED;
			elsif keyboard_symbol.input_type=OPCODE then
			      result <= operand;
					dummy_result <= operand;
					
				   operator <= keyboard_symbol.input_value;
			      calculator_fsm_state_next <= OPERATOR_PARSED;
			 end if;
			when OPERATOR_PARSED =>
			 if mode='1' then
					calculator_fsm_state_next <= PAUSE_FOR_RS232;
			 elsif keyboard_symbol.input_type=NUMBER then
			      operator <=  keyboard_symbol.input_value;
				   calculator_fsm_state_next <= NUMBER_PARSED;
			 elsif keyboard_symbol.input_type=OPCODE then
			      calculator_fsm_state_next <= OPERATOR_PARSED;
			 end if;
			when PAUSE_FOR_RS232 =>
				if mode='1' then
					calculator_fsm_state_next <= PAUSE_FOR_RS232;
			   else
					calculator_fsm_state_next <=START;
				end if;
			end case;
	end process next_state;
	
	output : process(calculator_fsm_state)
	begin
		case calculator_fsm_state is
		 when OPERATOR_PARSED
	end process output;
	
	sync :  process(sys_clk, sys_res_n)
	begin
		if sys_res_n = '0' then
			calculator_fsm_state <= START;
     elsif rising_edge(sys_clk) then
      calculator_fsm_state <= calculator_fsm_state_next;
	 end if;
	end process sync;
end behav;