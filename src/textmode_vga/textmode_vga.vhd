-------------------------------------------------------------------------
--
-- Filename: textmode_vga.vhd
-- =========
--
-- Short Description:
-- ==================
--   Toplevel entity of the textmode VGA controller.
--
-------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.textmode_vga_pkg.all;
use work.textmode_vga_platform_dependent_pkg.all;

entity textmode_vga is
  generic
  (
    -- Clock frequency used as basis for the VGA timing
    VGA_CLK_FREQ : integer;
    -- Blink interval of the cursor give in miliseconds
    BLINK_INTERVAL_MS : integer;
    -- Number of stages used in synchronizers
    SYNC_STAGES : integer
  );
  port
  (
    -- Interface to user logic
    sys_clk, sys_res_n : in std_logic;  
    command : in std_logic_vector(COMMAND_SIZE - 1 downto 0);
    command_data : in std_logic_vector(3 * COLOR_SIZE + CHAR_SIZE - 1 downto 0);
    free : out std_logic;

    -- External VGA interface
    vga_clk, vga_res_n : in std_logic;    
    vsync_n : out std_logic;
    hsync_n : out std_logic;
    r : out std_logic_vector(RED_BITS - 1 downto 0);
    g : out std_logic_vector(GREEN_BITS - 1 downto 0);
    b : out std_logic_vector(BLUE_BITS - 1 downto 0)
  );
end entity textmode_vga;
