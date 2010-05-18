-------------------------------------------------------------------------
--
-- Filename: console_sm_sync_beh.vhd
-- =========
--
-- Short Description:
-- ==================
--   Behavioral implementation of the synchronizer for the cosole mode
--   finite state machine. It synchronizes all signal crossing
--   from the system and the VGA clock domain and vice versa.
--
-------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.textmode_vga_pkg.all;
use work.textmode_vga_platform_dependent_pkg.all;
use work.font_pkg.all;

architecture beh of console_sm_sync is
  type SYNC_STATE_TYPE is (STATE_IDLE, STATE_WAIT_ACK, STATE_FINISHED, STATE_WAIT_ACK_RELEASE);
  signal sync_state, sync_state_next : SYNC_STATE_TYPE;
  signal command_req_sync : std_logic_vector(0 to SYNC_STAGES - 1);
  signal command_req_sys : std_logic;
  signal ack_sync : std_logic_vector(0 to SYNC_STAGES - 1);
  signal ack_sys : std_logic;
  signal command_latched, command_latched_next : std_logic_vector(COMMAND_SIZE - 1 downto 0);
  signal command_data_latched, command_data_latched_next : std_logic_vector(3 * COLOR_SIZE + CHAR_SIZE - 1 downto 0);
  signal command_req_next : std_logic;
begin
  command_vga <= command_latched;
  command_data_vga <= command_data_latched;
  command_req_vga <= command_req_sync(SYNC_STAGES - 1);
  synchronizer_sys_vga : process(vga_clk, vga_res_n)
  begin
    if vga_res_n = '0' then
      command_req_sync <= (others => '0');
    elsif rising_edge(vga_clk) then
      command_req_sync(0) <= command_req_sys;
      for i in 1 to SYNC_STAGES - 1 loop
        command_req_sync(i) <= command_req_sync(i - 1);
      end loop;
    end if;
  end process synchronizer_sys_vga;

  ack_sys <= ack_sync(SYNC_STAGES - 1);
  synchronizer_vga_sys : process(sys_clk, sys_res_n)
  begin
    if sys_res_n = '0' then
      ack_sync <= (others => '0');
    elsif rising_edge(sys_clk) then
      ack_sync(0) <= ack_vga;
      for i in 1 to SYNC_STAGES - 1 loop
        ack_sync(i) <= ack_sync(i - 1);
      end loop;
    end if;
  end process synchronizer_vga_sys;

  process(sync_state, command_sys, ack_sys)
  begin
    sync_state_next <= sync_state;
    
    case sync_state is
      when STATE_IDLE =>
        if command_sys /= COMMAND_NOP then
          if ack_sys = '0' then
            sync_state_next <= STATE_WAIT_ACK;
          else
            sync_state_next <= STATE_WAIT_ACK_RELEASE;
          end if;
        end if;
      when STATE_WAIT_ACK =>
        if ack_sys = '1' then
          sync_state_next <= STATE_FINISHED;
        end if;
      when STATE_FINISHED =>
        sync_state_next <= STATE_IDLE;
      when STATE_WAIT_ACK_RELEASE =>
        if ack_sys = '0' then
          sync_state_next <= STATE_WAIT_ACK;
        end if;
    end case;
  end process;
  
  process(sync_state, command_latched, command_data_latched, command_sys, command_data_sys)
  begin
    command_latched_next <= command_latched;
    command_data_latched_next <= command_data_latched;
    command_req_next <= '0';
    free_sys <= '0';
    
    case sync_state is
      when STATE_IDLE =>
        command_latched_next <= command_sys;
        command_data_latched_next <= command_data_sys;
        free_sys <= '1';
      when STATE_WAIT_ACK =>
        command_req_next <= '1';
      when STATE_FINISHED =>
        null;
      when STATE_WAIT_ACK_RELEASE =>
        null;
    end case;
  end process;
  
  process(sys_clk, sys_res_n)
  begin
    if sys_res_n = '0' then
      command_latched <= COMMAND_NOP;
      command_data_latched <= COLOR_BLACK & CHAR_NULL;
      sync_state <= STATE_IDLE;
      command_req_sys <= '0';
    elsif rising_edge(sys_clk) then
      command_latched <= command_latched_next;
      command_data_latched <= command_data_latched_next;
      sync_state <= sync_state_next;
      command_req_sys <= command_req_next;
    end if;
  end process;
end architecture beh;
