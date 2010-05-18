-------------------------------------------------------------------------
--
-- Filename: ps2_keyboard_controller_beh.vhd
-- =========
--
-- Short Description:
-- ==================
--   Behavioral implementation of the PS/2 keyboard controller.
--
-------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.ps2_transceiver_pkg.all;

architecture beh of ps2_keyboard_controller is
  type KEYBOARD_STATE_TYPE is
  (
    INIT, INIT_WAIT_ACK, INIT_WAIT_BAT, SET_INDICATORS_CMD, SET_INDICATORS_CMD_WAIT_ACK, SET_INDICATORS_VALUE,
    SET_INDICATORS_VALUE_WAIT_ACK, ENABLE, ENABLE_WAIT_ACK, OPERATIONAL, NEW_DATA_AVAILABLE,
    ERROR
  );
  signal keyboard_state, keyboard_state_next : KEYBOARD_STATE_TYPE;  
  
  signal keyboard_data : std_logic_vector(7 downto 0);
  signal keyboard_new_data : std_logic;
  
  signal input_data : std_logic_vector(7 downto 0);
  signal input_data_send_ok, input_data_send_finished, send_request : std_logic;
  
  signal new_data_next : std_logic;
  signal data_next, data_internal : std_logic_vector(7 downto 0);
begin
  ps2_transceiver_inst : ps2_transceiver
    generic map
    (
      CLK_FREQ => CLK_FREQ,
      SYNC_STAGES => SYNC_STAGES
    )
    port map
    (
      sys_clk => sys_clk,
      sys_res_n => sys_res_n,
      ps2_clk => ps2_clk,
      ps2_data => ps2_data,
      send_request => send_request,
      input_data => input_data,
      input_data_send_ok => input_data_send_ok,
      input_data_send_finished => input_data_send_finished,
      output_data => keyboard_data,
      new_data => keyboard_new_data
    );

  process(keyboard_state, keyboard_new_data, keyboard_data, input_data_send_ok, input_data_send_finished)
  begin
    keyboard_state_next <= keyboard_state;
    
    case keyboard_state is
      when INIT =>
        if input_data_send_finished = '1' then
          if input_data_send_ok = '1' then
            keyboard_state_next <= INIT_WAIT_ACK;
          else
            keyboard_state_next <= ERROR;
          end if;
        end if;

      when INIT_WAIT_ACK =>
        if keyboard_new_data = '1' then
          if keyboard_data = x"FA" then
            keyboard_state_next <= INIT_WAIT_BAT;
          else
            keyboard_state_next <= ERROR;
          end if;
        end if;

      when INIT_WAIT_BAT =>
        if keyboard_new_data = '1' then
          if keyboard_data = x"AA" then
            keyboard_state_next <= SET_INDICATORS_CMD;
          else
            keyboard_state_next <= ERROR;
          end if;
        end if;
        
      when SET_INDICATORS_CMD =>
        if input_data_send_finished = '1' then
          if input_data_send_ok = '1' then
            keyboard_state_next <= SET_INDICATORS_CMD_WAIT_ACK;
          else
            keyboard_state_next <= ERROR;
          end if;
        end if;
      when SET_INDICATORS_CMD_WAIT_ACK =>
        if keyboard_new_data = '1' then
          if keyboard_data = x"FA" then
            keyboard_state_next <= SET_INDICATORS_VALUE;
          else
            keyboard_state_next <= ERROR;
          end if;          
        end if;
      when SET_INDICATORS_VALUE =>
        if input_data_send_finished = '1' then
          if input_data_send_ok = '1' then
            keyboard_state_next <= SET_INDICATORS_VALUE_WAIT_ACK;
          else
            keyboard_state_next <= ERROR;
          end if;
        end if;
      when SET_INDICATORS_VALUE_WAIT_ACK =>
        if keyboard_new_data = '1' then
          if keyboard_data = x"FA" then
            keyboard_state_next <= ENABLE;
          else
            keyboard_state_next <= ERROR;
          end if;
        end if;
        
      when ENABLE =>
        if input_data_send_finished = '1' then
          if input_data_send_ok = '1' then
            keyboard_state_next <= ENABLE_WAIT_ACK;
          else
            keyboard_state_next <= ERROR;
          end if;
        end if;
      when ENABLE_WAIT_ACK =>
        if keyboard_new_data = '1' then
          if keyboard_data = x"FA" then
            keyboard_state_next <= OPERATIONAL;
          else
            keyboard_state_next <= ERROR;
          end if;
        end if;        

      when OPERATIONAL =>
        if keyboard_new_data = '1' then
          keyboard_state_next <= NEW_DATA_AVAILABLE;
        end if;
        
      when NEW_DATA_AVAILABLE =>
        keyboard_state_next <= OPERATIONAL;
        
      when ERROR =>
        null;
    end case;
  end process;
  
  process(keyboard_state, keyboard_data, data_internal)
  begin
    send_request <= '0';
    input_data <= x"00";
    new_data_next <= '0';
    data_next <= data_internal;
    
    case keyboard_state is
      when INIT =>
        send_request <= '1';
        input_data <= x"FF";
      when INIT_WAIT_ACK =>
        null;
      when INIT_WAIT_BAT =>
        null;
      when SET_INDICATORS_CMD =>
        send_request <= '1';
        input_data <= x"ED";
      when SET_INDICATORS_CMD_WAIT_ACK =>
        null;
      when SET_INDICATORS_VALUE =>
        send_request <= '1';
        input_data <= x"02";
      when SET_INDICATORS_VALUE_WAIT_ACK =>
        null;
      when ENABLE =>
        send_request <= '1';
        input_data <= x"F4";
      when ENABLE_WAIT_ACK =>
        null;
      when OPERATIONAL =>
        null;
      when NEW_DATA_AVAILABLE =>
        new_data_next <= '1';
        data_next <= keyboard_data;
      when ERROR =>
    end case;
  end process;

  process(sys_clk, sys_res_n)
  begin
    if sys_res_n = '0' then
      keyboard_state <= INIT;
      new_data <= '0';
      data_internal <= (others => '0');
    elsif rising_edge(sys_clk) then
      keyboard_state <= keyboard_state_next;
      new_data <= new_data_next;
      data_internal <= data_next;
    end if;
  end process;
  data <= data_internal;
end architecture beh;
