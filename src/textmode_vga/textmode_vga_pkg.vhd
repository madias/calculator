-------------------------------------------------------------------------
--
-- Filename: textmode_vga_pkg.vhd
-- =========
--
-- Short Description:
-- ==================
--   Global declaration needed by the VGA interface.
--   This package contains the declaration of the VGA timing values,
--   the VGA dimensions and the supported commands.
--
-------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.textmode_vga_platform_dependent_pkg.all;
--
-- 640x480x60Hz
--
--     >=144           <784
--   >=33 ---------------
--        |             |
--        |             |
--        |             |
--   <513 ---------------
--
-- PixelClock: 25,175 MHz
--
-- HSync   96
-- BackP   48
-- Data   640
-- FrontP  16
--        ---
--        800
--
-- Vsync    2
-- BackP   31
-- Data   480
-- FrontP  11
--        ---
--        524
--

package textmode_vga_pkg is
  constant COLOR_SIZE : integer := 8;
  constant CHAR_SIZE : integer := 8;

  constant COLOR_BLACK : std_logic_vector(3 * COLOR_SIZE - 1 downto 0) := (others => '0');
  constant COLOR_WHITE : std_logic_vector(3 * COLOR_SIZE - 1 downto 0) := (others => '1');

  constant PIXEL_WIDTH : integer := 640;
  constant PIXEL_HEIGHT : integer := 480;
  constant HSYNC_CYCLES : integer := 96;
  constant HBACK_CYCLES : integer := 48;
  constant HFRONT_CYCLES : integer := 16;
  constant VSYNC_LINES : integer := 2;
  constant VBACK_LINES : integer := 31;
  constant VFRONT_LINES : integer := 11;

  subtype COLOR_RANGE is natural range COLOR_SIZE + CHAR_SIZE - 1 downto CHAR_SIZE;
  subtype VGA_MEMORY_RANGE is natural range COLOR_SIZE + CHAR_SIZE - 1 downto 0;
  
  constant COMMAND_SIZE : integer := 8;
  constant COMMAND_NOP : std_logic_vector(COMMAND_SIZE - 1 downto 0) := x"00";
  constant COMMAND_SET_CHAR : std_logic_vector(COMMAND_SIZE - 1 downto 0) := x"01";
  constant COMMAND_SET_BACKGROUND : std_logic_vector(COMMAND_SIZE - 1 downto 0) := x"02";
  constant COMMAND_SET_CURSOR_STATE : std_logic_vector(COMMAND_SIZE - 1 downto 0) := x"03";
  constant COMMAND_SET_CURSOR_COLOR : std_logic_vector(COMMAND_SIZE - 1 downto 0) := x"04";
  constant COMMAND_SET_CURSOR_COLUMN : std_logic_vector(COMMAND_SIZE - 1 downto 0) := x"05";
  constant COMMAND_SET_CURSOR_LINE : std_logic_vector(COMMAND_SIZE - 1 downto 0) := x"06";
  
  constant CHAR_NEW_LINE : std_logic_vector(CHAR_SIZE - 1 downto 0) := x"0A";
  constant CHAR_CARRIAGE_RETURN : std_logic_vector(CHAR_SIZE - 1 downto 0) := x"0D";
  constant CHAR_NULL : std_logic_vector(CHAR_SIZE - 1 downto 0) := x"00";
  
  type CURSOR_STATE_TYPE is (CURSOR_OFF, CURSOR_ON, CURSOR_BLINK);
  constant CURSOR_BLINK_INTERVAL_MS : integer := 500;
end package textmode_vga_pkg;
