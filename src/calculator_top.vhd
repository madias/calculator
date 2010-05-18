-------------------------------------------------------------------------------
-- LIBRARIES
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

use work.calculator_pkg.all;

-------------------------------------------------------------------------------
-- ENTITY
-------------------------------------------------------------------------------

entity calculator_top is
  port(
-- input pins from PCB board  
       clk_pin : in  std_logic;         -- clock pin
       reset_pin : in  std_logic;         -- reset pins (from switch)
-- output pins to RGB connector / VGA screen
       r0_pin, r1_pin, r2_pin : out std_logic;         -- to RGB connector "red"
       g0_pin, g1_pin, g2_pin : out std_logic;         -- to RGB connector "green"
       b0_pin, b1_pin , b2_pin : out std_logic;         -- to RGB connector "blue"
       hsync_pin : out std_logic;         -- to RGB connector "Hsync"
       vsync_pin: out std_logic         -- to RGB connector "Vsync"
	);
	
end calculator_top;

-------------------------------------------------------------------------------
-- END ENTITY
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- ARCHITECTURE
-------------------------------------------------------------------------------

architecture behav of calculator_top is

signal r_0_sig, r_1_sig, r_2_sig, b_0_sig, b_1_sig, b_2_sig, g_0_sig, g_1_sig, g_2_sig  : std_logic;
signal hsync_sig, vsync_sig : std_logic;

signal mode_sig, memory_ready_sig, caluclator_ready_sig: std_logic;
signal keyboard_symbol_sig, calculation_value_sig, data_to_send_sig, expression_and_calculation_sig: CALCULATOR_SYMBOL_TYPE;

signal uart_rxd_sig, uart_rts_sig, uart_cts_sig, uart_txd_sig : std_logic;


begin

--------WIRING THE UNITS-------------

--communication unit
	communication_unit: communication
	port map (
		clk => clk_pin,
		reset =>reset_pin,
		data_to_send => data_to_send_sig,
		uart_rxd => uart_rxd_sig,
		uart_rts => uart_rts_sig,
	 	mode => mode_sig,
		uart_cts => uart_cts_sig,
		uart_txd => uart_txd_sig
	);

--screen unit
	screen_unit : screen
	port map (
		clk => clk_pin,
		reset => reset_pin,
		mode => mode_sig,
		keyboard_symbol => keyboard_symbol_sig,
		calculation_value => calculation_value_sig,
		vsync_n => vsync_sig,
		hsync_n => hsync_sig,
		r_0 => r_0_sig,
		r_1 => r_1_sig,
		r_2  => r_2_sig,
		g_0 => g_0_sig,
		g_1 => g_1_sig,
		g_2 => g_2_sig,
		b_0 => b_0_sig,
		b_1 => b_1_sig,
		b_2 => b_2_sig
	);

--calculator_unit
calculator_unit: calculator
	port map (
		clk => clk_pin,
		reset =>reset_pin,
		keyboard_symbol => keyboard_symbol_sig,
		calculation_value => calculation_value_sig,
	 	mode => mode_sig,
		memory_ready => memory_ready_sig,
		calculator_ready => caluclator_ready_sig,
		expression_and_calculation => expression_and_calculation_sig
	);
	
--input_unit
input_unit: input
	port map (
		clk => clk_pin,
		reset =>reset_pin,
		keyboard_symbol => keyboard_symbol_sig,
	 	mode => mode_sig,
		calculator_ready => caluclator_ready_sig
	);
	
--memory_unit
memory_unit: memory
	port map (
		clk => clk_pin,
		reset =>reset_pin,
	 	mode => mode_sig,
		expression_and_calculation => expression_and_calculation_sig,
		data_to_send => data_to_send_sig,
		memory_ready => memory_ready_sig
	);
	
	
------------WIRING THE PINS---------------------
	
-- make the wiring for RGB pins
r0_pin <= r_0_sig; r1_pin <= r_1_sig; r2_pin <= r_2_sig;
g0_pin <= g_0_sig; g1_pin <= g_1_sig; g2_pin <= g_2_sig;
b0_pin <= b_0_sig; b1_pin <= b_1_sig; b2_pin <= b_2_sig; 

-- make the wiring for hsync and vsync pins 
vsync_pin <= vsync_sig;
hsync_pin <= hsync_sig;

end behav;

-------------------------------------------------------------------------------
-- END ARCHITECTURE
-------------------------------------------------------------------------------