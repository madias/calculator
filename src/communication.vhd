library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.calculator_pkg.all;

entity communication is
  
  port (
    clk   : in  std_logic;
    reset : in  std_logic;
    data_to_send: in CALCULATOR_SYMBOL_TYPE;
	 uart_rxd : in std_logic;
	 uart_rts : in std_logic;
	 	 
	 mode  : out std_logic;
	 uart_cts : out std_logic;
	 uart_txd : out std_logic
	);

end communication;

architecture behav of communication is
type COMMUNICATION_FSM_STATE_TYPE is (START, IDLE, TRANSFER_REQUEST, TRANSFER_READY, DATA, STOP);
signal communication_fsm_state, communication_fsm_state_next : COMMUNICATION_FSM_STATE_TYPE; 
begin
	
end behav;