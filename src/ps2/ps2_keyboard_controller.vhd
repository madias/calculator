-------------------------------------------------------------------------
--
-- Filename: ps2_keyboard_controller.vhd
-- =========
--
-- Short Description:
-- ==================
--   PS/2 keyboard controller entity declaration.
--
-------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity ps2_keyboard_controller is
  generic
  (
    -- System clock frequency
    CLK_FREQ : integer;
    -- Number of stages used in synchronizers
    SYNC_STAGES : integer
  );
  port
  (
    -- User logic interface
    sys_clk, sys_res_n : in std_logic;
    new_data : out std_logic;
    data : out std_logic_vector(7 downto 0);
    
    -- External PS/2 interface
    ps2_clk, ps2_data : inout std_logic
  );
end entity ps2_keyboard_controller;
