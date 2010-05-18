-------------------------------------------------------------------------
--
-- Filename: interval.vhd
-- =========
--
-- Short Description:
-- ==================
--   Interval timer entity declaraton.
--
-------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity interval is
  generic
  (
    CLK_FREQ : integer;
    INTERVAL_TIME_MS : integer
  );
  port
  (
    clk : in std_logic;
    res_n : in std_logic;
    active : out std_logic
  );
end entity interval;
