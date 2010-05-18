-------------------------------------------------------------------------
--
-- Filename: ps2_keyboard_controller_pkg.vhd
-- =========
--
-- Short Description:
-- ==================
--   Component declaration of the PS/2 keyboard controller
--
-------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

package ps2_keyboard_controller_pkg is
  component ps2_keyboard_controller is
    generic
    (
      CLK_FREQ : integer;
      SYNC_STAGES : integer
    );
    port
    (
      sys_clk, sys_res_n : in std_logic;
      
      ps2_clk, ps2_data : inout std_logic;
      new_data : out std_logic;
      data : out std_logic_vector(7 downto 0)
    );
  end component ps2_keyboard_controller;
end package ps2_keyboard_controller_pkg;
