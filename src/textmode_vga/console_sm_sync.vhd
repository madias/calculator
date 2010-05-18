-------------------------------------------------------------------------
--
-- Filename: console_sm_sync.vhd
-- =========
--
-- Short Description:
-- ==================
--   Entity declaration of the synchronizer for the cosole mode
--   finite state machine.
--
-------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.textmode_vga_pkg.all;
use work.font_pkg.all;

entity console_sm_sync is
  generic
  (
    SYNC_STAGES    : integer
  );
  port
  (
    sys_clk, sys_res_n : in std_logic;
    command_sys : in std_logic_vector(COMMAND_SIZE - 1 downto 0);
    command_data_sys : in std_logic_vector(3 * COLOR_SIZE + CHAR_SIZE - 1 downto 0);
    free_sys : out std_logic;
    
    vga_clk, vga_res_n : in std_logic;
    command_vga : out std_logic_vector(COMMAND_SIZE - 1 downto 0);
    command_data_vga : out std_logic_vector(3 * COLOR_SIZE + CHAR_SIZE - 1 downto 0);
    command_req_vga : out std_logic;
    ack_vga : in std_logic
  );
end entity console_sm_sync;
