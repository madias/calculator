-------------------------------------------------------------------------
--
-- Filename: interval_beh.vhd
-- =========
--
-- Short Description:
-- ==================
--   Behavioral implementaiton of the interval timer
--
-------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

architecture beh of interval is
  constant CNT_MAX : integer := INTERVAL_TIME_MS * (CLK_FREQ / 1000);
  signal cnt : integer range 0 to CNT_MAX - 1;
  signal active_int : std_logic;
begin
  active <= active_int;
  process(clk, res_n)
  begin
    if res_n = '0' then
      cnt <= 0;
      active_int <= '0';
    elsif rising_edge(clk) then
      if cnt < CNT_MAX - 1 then
        cnt <= cnt + 1;
      else
        cnt <= 0;
        active_int <= not active_int;
      end if;
    end if;
  end process;
end architecture beh;
            