-------------------------------------------------------------------------
--
-- Filename: ps2_transceiver.vhd
-- =========
--
-- Short Description:
-- ==================
--   PS/2 transceiver entity
--
-------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity ps2_transceiver is
  generic
  (
    CLK_FREQ : integer;
    SYNC_STAGES : integer
  );
  port
  (
    sys_clk, sys_res_n       : in    std_logic;
    
    ps2_clk, ps2_data        : inout std_logic;
    
    send_request             : in    std_logic;
    input_data               : in    std_logic_vector(7 downto 0);
    input_data_send_ok       : out   std_logic;
    input_data_send_finished : out   std_logic;
    
    output_data              : out   std_logic_vector(7 downto 0);
    new_data                 : out   std_logic
  );
end entity ps2_transceiver;
