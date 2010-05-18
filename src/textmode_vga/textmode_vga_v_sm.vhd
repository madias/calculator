-------------------------------------------------------------------------
--
-- Filename: textmode_vga_v_sm.vhd
-- =========
--
-- Short Description:
-- ==================
--   Entity declaration of the vertical VGA timing finite state machine
--
-------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.math_pkg.all;
use work.textmode_vga_pkg.all;
use work.font_pkg.all;

entity textmode_vga_v_sm is
  port
  (
    sys_clk, sys_res_n : in std_logic;
       
    is_data_line : out std_logic;
    char_line_cnt : out std_logic_vector(log2c(LINE_COUNT) - 1 downto 0);
    char_height_pixel : out std_logic_vector(log2c(CHAR_HEIGHT) - 1 downto 0);
    is_eol : in std_logic;
    
    vsync_n : out std_logic
  );
end entity textmode_vga_v_sm;
