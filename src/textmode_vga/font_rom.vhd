-------------------------------------------------------------------------
--
-- Filename: font_rom.vhd
-- =========
--
-- Short Description:
-- ==================
--   Font ROM entity declaraton
--
-------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.font_pkg.all;
use work.math_pkg.all;

entity font_rom is
  port
  (
    vga_clk : in std_logic;
    char : in std_logic_vector(log2c(CHAR_COUNT) - 1 downto 0);
    char_height_pixel : in std_logic_vector(log2c(CHAR_HEIGHT) - 1 downto 0);
    decoded_char : out std_logic_vector(0 to CHAR_WIDTH - 1)
  );
end entity font_rom;
