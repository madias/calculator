library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.calculator_pkg.all;

entity screen is
  
  port (
    clk   : in  std_logic;
    reset : in  std_logic;
    mode  : in std_logic;
	 keyboard_symbol_type : in CALCULATOR_SYMBOL_TYPE;
	 calculation_value : in CALCULATOR_SYMBOL_TYPE;
	 
	 hsync_n: out std_logic;
	 vsync_n: out std_logic;
	 r: out std_logic_vector(REDBITS-1 downto 0);
	 g: out std_logic_vector(GREENBITS-1 downto 0);
	 b: out std_logic_vector(BLUEBITS-1 downto 0));

end screen;

architecture behav of screen is

begin

end behav;
