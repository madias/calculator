-------------------------------------------------------------------------
--
-- Filename: textmode_vga_h_sm.vhd
-- =========
--
-- Short Description:
-- ==================
--   Entity declaration of the horizontal VGA timing finite state machine
--
-------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.math_pkg.all;
use work.textmode_vga_pkg.all;
use work.textmode_vga_platform_dependent_pkg.all;
use work.font_pkg.all;

entity textmode_vga_h_sm is
  port
  (
    sys_clk, sys_res_n : in std_logic;
    
    background_color : in  std_logic_vector(RED_BITS + GREEN_BITS + BLUE_BITS - 1 downto 0);

    char_cnt         : out std_logic_vector(log2c(COLUMN_COUNT) - 1 downto 0);
    char_line_cnt    : in  std_logic_vector(log2c(LINE_COUNT) - 1 downto 0);
    cursor_column    : in  std_logic_vector(log2c(COLUMN_COUNT) - 1 downto 0);
    cursor_line      : in  std_logic_vector(log2c(LINE_COUNT) - 1 downto 0);
    cursor_color     : in  std_logic_vector(RED_BITS + GREEN_BITS + BLUE_BITS - 1 downto 0);
    cursor_state     : in  CURSOR_STATE_TYPE;
    decoded_char     : in  std_logic_vector(0 to CHAR_WIDTH - 1);
    color            : in  std_logic_vector(RED_BITS + GREEN_BITS + BLUE_BITS - 1 downto 0);
    
    is_data_line : in std_logic;
    is_eol : out std_logic;
    
    hsync_n : out std_logic;
    rgb : out std_logic_vector(RED_BITS + GREEN_BITS + BLUE_BITS - 1 downto 0);
    blink : in std_logic
  );
end entity textmode_vga_h_sm;
