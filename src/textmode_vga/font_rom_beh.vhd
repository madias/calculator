-------------------------------------------------------------------------
--
-- Filename: font_rom_beh.vhd
-- =========
--
-- Short Description:
-- ==================
--   Behavioral architecture of the font ROM entity.
--
-------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.font_pkg.all;

architecture beh of font_rom is
begin
  process(vga_clk)
    variable address : std_logic_vector(log2c(CHAR_COUNT) + log2c(CHAR_HEIGHT) - 1 downto 0);
  begin
    if rising_edge(vga_clk) then
      address := char & char_height_pixel;
      decoded_char <= FONT_TABLE(to_integer(unsigned(address)));
    end if;
  end process;
end architecture beh;
