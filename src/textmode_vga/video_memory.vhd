-------------------------------------------------------------------------
--
-- Filename: video_memory.vhd
-- =========
--
-- Short Description:
-- ==================
--   Video memory entity declaraton
--
-------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity video_memory is
  generic
  (
    DATA_WIDTH     : integer;
    ROW_ADDR_WIDTH : integer;
    COL_ADDR_WIDTH : integer
  );
  port
  (
    vga_clk : in  std_logic;    
    vga_row_address    : in  std_logic_vector(ROW_ADDR_WIDTH - 1 downto 0);
    vga_col_address    : in  std_logic_vector(COL_ADDR_WIDTH - 1 downto 0);
    vga_data           : out std_logic_vector(DATA_WIDTH - 1 downto 0);
    sm_row_address  : in  std_logic_vector(ROW_ADDR_WIDTH - 1 downto 0);
    sm_col_address  : in  std_logic_vector(COL_ADDR_WIDTH - 1 downto 0);
    sm_data         : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
    sm_wr           : in  std_logic;
    sm_scroll_address     : in  std_logic_vector(ROW_ADDR_WIDTH - 1 downto 0)
  );
end entity video_memory;
