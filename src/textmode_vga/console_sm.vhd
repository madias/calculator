-------------------------------------------------------------------------
--
-- Filename: console_sm.vhd
-- =========
--
-- Short Description:
-- ==================
--   Console mode finite state machine entity declaration
--
-------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.textmode_vga_pkg.all;
use work.textmode_vga_platform_dependent_pkg.all;
use work.font_pkg.all;
use work.math_pkg.all;

entity console_sm is
  port
  (
    vga_clk, vga_res_n : in std_logic;
    command : in std_logic_vector(COMMAND_SIZE - 1 downto 0);
    command_data : in std_logic_vector(3 * COLOR_SIZE + CHAR_SIZE - 1 downto 0);
    command_req : in std_logic;
    ack : out std_logic;

    column_address : out std_logic_vector(log2c(COLUMN_COUNT) - 1 downto 0);
    row_address : out std_logic_vector(log2c(LINE_COUNT) - 1 downto 0);
    data : out std_logic_vector(RED_BITS + GREEN_BITS + BLUE_BITS + CHAR_SIZE - 1 downto 0);
    wr : out std_logic;
    scroll_address : out std_logic_vector(log2c(LINE_COUNT) - 1 downto 0);
    background_color     : out std_logic_vector(RED_BITS + GREEN_BITS + BLUE_BITS - 1 downto 0);
    cursor_color     : out std_logic_vector(RED_BITS + GREEN_BITS + BLUE_BITS - 1 downto 0);
    cursor_state     : out CURSOR_STATE_TYPE
  ); 
end entity console_sm;