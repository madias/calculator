library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.calculator_pkg.all;

entity memory is
  
  port (
    clk   : in  std_logic;
    reset : in  std_logic;
    mode  : in std_logic;
	 expression_and_calculation : in CALCULATOR_SYMBOL_TYPE;
	 
	 data_to_send: out CALCULATOR_SYMBOL_TYPE;
	 memory_ready: out std_logic);

end memory;

architecture behav of memory is

begin

end behav;