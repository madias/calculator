-------------------------------------------------------------------------
--
-- Filename: video_memory_beh.vhd
-- =========
--
-- Short Description:
-- ==================
--   Behavioral implementation of the video memory. The access time
--   is exactly one clock cycle.
--
-------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.textmode_vga_pkg.all;
use work.font_pkg.all;

architecture beh of video_memory is
  subtype RAM_ENTRY is std_logic_vector(DATA_WIDTH - 1 downto 0);
  type RAM_TYPE is array(0 to (2 ** (ROW_ADDR_WIDTH + COL_ADDR_WIDTH)) - 1) of RAM_ENTRY;
  signal ram : RAM_TYPE :=
  (
    others => (others => '0')
  ); 
begin
  process(vga_clk)
    variable vga_row_address_int, sm_row_address_int : integer range 0 to 2 * LINE_COUNT - 2;
    variable vga_row_address_vector, sm_row_address_vector : std_logic_vector(ROW_ADDR_WIDTH - 1 downto 0);
    variable vga_address, sm_address : std_logic_vector(COL_ADDR_WIDTH + ROW_ADDR_WIDTH - 1 downto 0);
  begin
    if rising_edge(vga_clk) then
      vga_row_address_int := to_integer(unsigned(vga_row_address)) + to_integer(unsigned(sm_scroll_address));
      if vga_row_address_int > LINE_COUNT - 1 then
        vga_row_address_int := vga_row_address_int - LINE_COUNT;
      end if;
      vga_row_address_vector := std_logic_vector(to_unsigned(vga_row_address_int, ROW_ADDR_WIDTH));
      vga_address := vga_row_address_vector & vga_col_address;
      vga_data <= ram(to_integer(unsigned(vga_address)));
      
      if sm_wr = '1' then
        sm_row_address_int := to_integer(unsigned(sm_row_address)) + to_integer(unsigned(sm_scroll_address));
        if sm_row_address_int > LINE_COUNT - 1 then
          sm_row_address_int := sm_row_address_int - LINE_COUNT;
        end if;
        sm_row_address_vector := std_logic_vector(to_unsigned(sm_row_address_int, ROW_ADDR_WIDTH));
        sm_address := sm_row_address_vector & sm_col_address;
        ram(to_integer(unsigned(sm_address))) <= sm_data;
      end if;
    end if;
  end process;
end architecture beh;
