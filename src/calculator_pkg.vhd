library ieee;
use ieee.std_logic_1164.all;

package calculator_pkg is

type CALCULATOR_SYMBOL_TYPE is record
	input_value: INTEGER;
	input_type: std_logic;
	input_position: INTEGER;
end record;

component screen is
	port(
	clk   : in  std_logic;
	reset : in  std_logic;
	mode  : in std_logic;
	keyboard_symbol : in CALCULATOR_SYMBOL_TYPE;
	calculation_value : in CALCULATOR_SYMBOL_TYPE;
	 
	hsync_n: out std_logic;
	vsync_n: out std_logic;
	r_0, r_1, r_2: out std_logic;
	g_0, g_1, g_2: out std_logic;
	b_0, b_1, b_2: out std_logic
	);
end component screen;

component communication is
	port(
	clk   : in  std_logic;
   reset : in  std_logic;
   data_to_send: in CALCULATOR_SYMBOL_TYPE;
	uart_rxd : in std_logic;
	uart_rts : in std_logic;
	 	 
	mode  : out std_logic;
	uart_cts : out std_logic;
	uart_txd : out std_logic
	);
end component communication;
	
component calculator is	
	port (
	clk   : in  std_logic;
   reset : in  std_logic;
	mode : in std_logic;
   keyboard_symbol: in CALCULATOR_SYMBOL_TYPE;
	memory_ready : in std_logic;

	calculator_ready  : out std_logic;
	calculation_value : out CALCULATOR_SYMBOL_TYPE;
	expression_and_calculation : out CALCULATOR_SYMBOL_TYPE
	);
end component calculator;

component input is
	port (
   clk   : in  std_logic;
   reset : in  std_logic;
	mode : in std_logic;
	calculator_ready : in std_logic;

	keyboard_symbol : out CALCULATOR_SYMBOL_TYPE
	);
end component input;	

component memory is
    port (
    clk   : in  std_logic;
    reset : in  std_logic;
    mode  : in std_logic;
	 expression_and_calculation : in CALCULATOR_SYMBOL_TYPE;
	 
	 data_to_send: out CALCULATOR_SYMBOL_TYPE;
	 memory_ready: out std_logic);
end component memory;



CONSTANT NUMBER: std_logic:='0';
CONSTANT OPCODE: std_logic:='1';	

CONSTANT R232MODE: std_logic:='1';
CONSTANT CALCMODE: std_logic:='0';

CONSTANT REDBITS : INTEGER :=8;
CONSTANT BLUEBITS : INTEGER :=8;
CONSTANT GREENBITS : INTEGER :=8;

CONSTANT ADD : INTEGER:=0;
CONSTANT SUBT: INTEGER:=1;
CONSTANT MUL: INTEGER:=2;
CONSTANT DIV: INTEGER:=3;
CONSTANT ENTER: INTEGER:=4;
CONSTANT BACKSPACE: INTEGER:=5;
CONSTANT FINISHED: INTEGER:=6;
CONSTANT ERROR: INTEGER:=7;
CONSTANT BUSY: INTEGER:=8;
	 
end calculator_pkg;