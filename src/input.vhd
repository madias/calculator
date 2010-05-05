library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.calculator_pkg.all;

entity input is
  
  port (
    clk   : in  std_logic;
    reset : in  std_logic;
	 mode : in std_logic;
	 calculator_ready : in std_logic;

	 keyboard_symbol : out CALCULATOR_SYMBOL_TYPE;

	 ps2_clk : inout std_logic;
	 ps2_data : inout std_logic
	);

end input;

architecture behav of input is

begin

end behav;