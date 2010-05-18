-------------------------------------------------------------------------
--
-- Filename: ps2_transceiver_beh.vhd
-- =========
--
-- Short Description:
-- ==================
--   Behavioral implementation of the PS/2 transceiver
--
-------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

architecture beh of ps2_transceiver is
  constant PREPARE_TIMEOUT1_MAX : integer := CLK_FREQ / 5000; -- 200 us
  constant PREPARE_TIMEOUT2_MAX : integer := CLK_FREQ / 100000; -- 10 us
  type PS2_TRANSCEIVER_STATE_TYPE is
  (
    IDLE,

    PREPARE_SEND_ASSIGN_CLK, PREPARE_SEND_WAIT1, PREPARE_SEND_DATA, PREPARE_SEND_WAIT2,
    PREPARE_SEND_RELEASE_CLK, SEND_WAIT_DATA0, SEND_DATA0, SEND_WAIT_DATA1, SEND_DATA1,
    SEND_WAIT_DATA2, SEND_DATA2, SEND_WAIT_DATA3, SEND_DATA3, SEND_WAIT_DATA4, SEND_DATA4,
    SEND_WAIT_DATA5, SEND_DATA5, SEND_WAIT_DATA6, SEND_DATA6, SEND_WAIT_DATA7, SEND_DATA7,
    SEND_WAIT_PARITY, SEND_PARITY, SEND_WAIT_STOP, SEND_STOP, SEND_WAIT_ACK1, SEND_WAIT_ACK2,
    SEND_READ_ACK, SEND_FINISH,
     
    RECEIVE_START, RECEIVE_WAIT_DATA0, RECEIVE_DATA0, RECEIVE_WAIT_DATA1, RECEIVE_DATA1,
    RECEIVE_WAIT_DATA2, RECEIVE_DATA2, RECEIVE_WAIT_DATA3, RECEIVE_DATA3, RECEIVE_WAIT_DATA4,
    RECEIVE_DATA4, RECEIVE_WAIT_DATA5, RECEIVE_DATA5, RECEIVE_WAIT_DATA6, RECEIVE_DATA6,
    RECEIVE_WAIT_DATA7, RECEIVE_DATA7, RECEIVE_WAIT_PARITY, RECEIVE_PARITY, RECEIVE_WAIT_STOP,
    RECEIVE_STOP
  );
  signal ps2_transceiver_state, ps2_transceiver_state_next : PS2_TRANSCEIVER_STATE_TYPE;
  signal ps2_clk_last, ps2_clk_internal, ps2_clk_next, ps2_clk_hz, ps2_clk_hz_next : std_logic;
  signal ps2_data_internal, ps2_data_next, ps2_data_hz, ps2_data_hz_next : std_logic;
  signal ps2_clk_sync, ps2_data_sync : std_logic_vector(1 to SYNC_STAGES);
  signal output_data_next, output_data_internal : std_logic_vector(7 downto 0);
  signal parity, parity_next : std_logic;
  signal new_data_next : std_logic;
  signal prepare_timeout1, prepare_timeout1_next : integer range 0 to PREPARE_TIMEOUT1_MAX;
  signal prepare_timeout2, prepare_timeout2_next : integer range 0 to PREPARE_TIMEOUT2_MAX;
begin

  process(ps2_transceiver_state, ps2_clk_sync(SYNC_STAGES), ps2_clk_last, ps2_data_sync(SYNC_STAGES), send_request, prepare_timeout1, prepare_timeout2, output_data_internal)
  begin
    ps2_transceiver_state_next <= ps2_transceiver_state;
   
    case ps2_transceiver_state is
      when IDLE =>        
        if ps2_clk_sync(SYNC_STAGES) = '1' and ps2_clk_last = '0' then
          if ps2_data_sync(SYNC_STAGES) = '0' then
            ps2_transceiver_state_next <= RECEIVE_START;
          end if;
        elsif send_request = '1' then
          ps2_transceiver_state_next <= PREPARE_SEND_ASSIGN_CLK;
        end if;


      when PREPARE_SEND_ASSIGN_CLK =>
        ps2_transceiver_state_next <= PREPARE_SEND_WAIT1;
      when PREPARE_SEND_WAIT1 =>
        if prepare_timeout1 = PREPARE_TIMEOUT1_MAX - 1 then
          ps2_transceiver_state_next <= PREPARE_SEND_DATA;
        end if;
      when PREPARE_SEND_DATA =>
        ps2_transceiver_state_next <= PREPARE_SEND_WAIT2;
      when PREPARE_SEND_WAIT2 =>
        if prepare_timeout2 = PREPARE_TIMEOUT2_MAX - 1 then
          ps2_transceiver_state_next <= PREPARE_SEND_RELEASE_CLK;
        end if;
      when PREPARE_SEND_RELEASE_CLK =>
        ps2_transceiver_state_next <= SEND_WAIT_DATA0;
      when SEND_WAIT_DATA0 =>
        if ps2_clk_sync(SYNC_STAGES) = '0' and ps2_clk_last = '1' then
          ps2_transceiver_state_next <= SEND_DATA0;
        end if;
      when SEND_DATA0 =>
        ps2_transceiver_state_next <= SEND_WAIT_DATA1;
      when SEND_WAIT_DATA1 =>
        if ps2_clk_sync(SYNC_STAGES) = '0' and ps2_clk_last = '1' then
          ps2_transceiver_state_next <= SEND_DATA1;
        end if;
      when SEND_DATA1 =>
        ps2_transceiver_state_next <= SEND_WAIT_DATA2;
      when SEND_WAIT_DATA2 =>
        if ps2_clk_sync(SYNC_STAGES) = '0' and ps2_clk_last = '1' then
          ps2_transceiver_state_next <= SEND_DATA2;
        end if;
      when SEND_DATA2 =>
        ps2_transceiver_state_next <= SEND_WAIT_DATA3;
      when SEND_WAIT_DATA3 =>
        if ps2_clk_sync(SYNC_STAGES) = '0' and ps2_clk_last = '1' then
          ps2_transceiver_state_next <= SEND_DATA3;
        end if;
      when SEND_DATA3 =>
        ps2_transceiver_state_next <= SEND_WAIT_DATA4;
      when SEND_WAIT_DATA4 =>
        if ps2_clk_sync(SYNC_STAGES) = '0' and ps2_clk_last = '1' then
          ps2_transceiver_state_next <= SEND_DATA4;
        end if;
      when SEND_DATA4 =>
        ps2_transceiver_state_next <= SEND_WAIT_DATA5;
      when SEND_WAIT_DATA5 =>
        if ps2_clk_sync(SYNC_STAGES) = '0' and ps2_clk_last = '1' then
          ps2_transceiver_state_next <= SEND_DATA5;
        end if;
      when SEND_DATA5 =>
        ps2_transceiver_state_next <= SEND_WAIT_DATA6;
      when SEND_WAIT_DATA6 =>
        if ps2_clk_sync(SYNC_STAGES) = '0' and ps2_clk_last = '1' then
          ps2_transceiver_state_next <= SEND_DATA6;
        end if;
      when SEND_DATA6 =>
        ps2_transceiver_state_next <= SEND_WAIT_DATA7;
      when SEND_WAIT_DATA7 =>
        if ps2_clk_sync(SYNC_STAGES) = '0' and ps2_clk_last = '1' then
          ps2_transceiver_state_next <= SEND_DATA7;
        end if;
      when SEND_DATA7 =>
        ps2_transceiver_state_next <= SEND_WAIT_PARITY;
      when SEND_WAIT_PARITY =>
        if ps2_clk_sync(SYNC_STAGES) = '0' and ps2_clk_last = '1' then
          ps2_transceiver_state_next <= SEND_PARITY;
        end if;
      when SEND_PARITY =>
        ps2_transceiver_state_next <= SEND_WAIT_STOP;
      when SEND_WAIT_STOP =>
        if ps2_clk_sync(SYNC_STAGES) = '0' and ps2_clk_last = '1' then
          ps2_transceiver_state_next <= SEND_STOP;
        end if;
      when SEND_STOP =>
        ps2_transceiver_state_next <= SEND_WAIT_ACK1;      
      when SEND_WAIT_ACK1 =>
        if ps2_clk_sync(SYNC_STAGES) = '0' and ps2_clk_last = '1' then -- ACK is written by device
          ps2_transceiver_state_next <= SEND_WAIT_ACK2;
        end if;
      when SEND_WAIT_ACK2 =>
        if ps2_clk_sync(SYNC_STAGES) = '1' and ps2_clk_last = '0' then -- ACK is valid
          ps2_transceiver_state_next <= SEND_READ_ACK;
        end if;
      when SEND_READ_ACK =>
        ps2_transceiver_state_next <= SEND_FINISH;
      when SEND_FINISH =>
        ps2_transceiver_state_next <= IDLE;

      
      
      when RECEIVE_START =>
        ps2_transceiver_state_next <= RECEIVE_WAIT_DATA0;
      when RECEIVE_WAIT_DATA0 =>
        if ps2_clk_sync(SYNC_STAGES) = '0' and ps2_clk_last = '1' then
          ps2_transceiver_state_next <= RECEIVE_DATA0;
        end if;
      when RECEIVE_DATA0 =>
        ps2_transceiver_state_next <= RECEIVE_WAIT_DATA1;
      when RECEIVE_WAIT_DATA1 =>
        if ps2_clk_sync(SYNC_STAGES) = '0' and ps2_clk_last = '1' then
          ps2_transceiver_state_next <= RECEIVE_DATA1;
        end if;
      when RECEIVE_DATA1 =>
        ps2_transceiver_state_next <= RECEIVE_WAIT_DATA2;
      when RECEIVE_WAIT_DATA2 =>
        if ps2_clk_sync(SYNC_STAGES) = '0' and ps2_clk_last = '1' then
          ps2_transceiver_state_next <= RECEIVE_DATA2;
        end if;
      when RECEIVE_DATA2 =>
        ps2_transceiver_state_next <= RECEIVE_WAIT_DATA3;
      when RECEIVE_WAIT_DATA3 =>
        if ps2_clk_sync(SYNC_STAGES) = '0' and ps2_clk_last = '1' then
          ps2_transceiver_state_next <= RECEIVE_DATA3;
        end if;
      when RECEIVE_DATA3 =>
        ps2_transceiver_state_next <= RECEIVE_WAIT_DATA4;
      when RECEIVE_WAIT_DATA4 =>
        if ps2_clk_sync(SYNC_STAGES) = '0' and ps2_clk_last = '1' then
          ps2_transceiver_state_next <= RECEIVE_DATA4;
        end if;
      when RECEIVE_DATA4 =>
        ps2_transceiver_state_next <= RECEIVE_WAIT_DATA5;
      when RECEIVE_WAIT_DATA5 =>
        if ps2_clk_sync(SYNC_STAGES) = '0' and ps2_clk_last = '1' then
          ps2_transceiver_state_next <= RECEIVE_DATA5;
        end if;
      when RECEIVE_DATA5 =>
        ps2_transceiver_state_next <= RECEIVE_WAIT_DATA6;
      when RECEIVE_WAIT_DATA6 =>
        if ps2_clk_sync(SYNC_STAGES) = '0' and ps2_clk_last = '1' then
          ps2_transceiver_state_next <= RECEIVE_DATA6;
        end if;
      when RECEIVE_DATA6 =>
        ps2_transceiver_state_next <= RECEIVE_WAIT_DATA7;
      when RECEIVE_WAIT_DATA7 =>
        if ps2_clk_sync(SYNC_STAGES) = '0' and ps2_clk_last = '1' then
          ps2_transceiver_state_next <= RECEIVE_DATA7;
        end if;
      when RECEIVE_DATA7 =>
        ps2_transceiver_state_next <= RECEIVE_WAIT_PARITY;
      when RECEIVE_WAIT_PARITY =>
        if ps2_clk_sync(SYNC_STAGES) = '0' and ps2_clk_last = '1' then
          ps2_transceiver_state_next <= RECEIVE_PARITY;
        end if;
      when RECEIVE_PARITY =>
        ps2_transceiver_state_next <= RECEIVE_WAIT_STOP;
      when RECEIVE_WAIT_STOP =>     
        if ps2_clk_sync(SYNC_STAGES) = '0' and ps2_clk_last = '1' then
          ps2_transceiver_state_next <= RECEIVE_STOP;
        end if;
      when RECEIVE_STOP =>
        ps2_transceiver_state_next <= IDLE;
    end case;
  end process;
  
  process(ps2_transceiver_state, ps2_data_internal, ps2_clk_internal, parity, input_data, ps2_data_sync(SYNC_STAGES), output_data_internal, prepare_timeout1, prepare_timeout2, ps2_clk_hz, ps2_data_hz)
  begin
    input_data_send_ok <= '0';
    input_data_send_finished <= '0';
    ps2_data_next <= ps2_data_internal;
    ps2_data_hz_next <= ps2_data_hz;
    ps2_clk_next <= ps2_clk_internal;
    ps2_clk_hz_next <= ps2_clk_hz;
    parity_next <= parity;
    output_data_next <= output_data_internal;
    new_data_next <= '0';
    prepare_timeout1_next <= prepare_timeout1;
    prepare_timeout2_next <= prepare_timeout2;
    
    case ps2_transceiver_state is
      when IDLE =>        
        ps2_clk_next <= '1';
        ps2_clk_hz_next <= '1';
        ps2_data_next <= '1';
        ps2_data_hz_next <= '1';

      when PREPARE_SEND_ASSIGN_CLK =>
        ps2_clk_next <= '0';
        ps2_clk_hz_next <= '0';
        parity_next <= '1';
        prepare_timeout1_next <= 0;
      when PREPARE_SEND_WAIT1 =>
        prepare_timeout1_next <= prepare_timeout1 + 1;
      when PREPARE_SEND_DATA =>
        ps2_data_next <='0';
        ps2_data_hz_next <= '0';
        prepare_timeout2_next <= 0;
      when PREPARE_SEND_WAIT2 =>
        prepare_timeout2_next <= prepare_timeout2 + 1;
      when PREPARE_SEND_RELEASE_CLK =>
        ps2_clk_next <= '1';
        ps2_clk_hz_next <= '1';
      when SEND_WAIT_DATA0 =>
        null;
      when SEND_DATA0 =>
        ps2_data_next <= input_data(0);
        parity_next <= parity xor input_data(0);
      when SEND_WAIT_DATA1 =>
        null;
      when SEND_DATA1 =>
        ps2_data_next <=input_data(1);
        parity_next <= parity xor input_data(1);
      when SEND_WAIT_DATA2 =>
        null;
      when SEND_DATA2 =>
        ps2_data_next <=input_data(2);
        parity_next <= parity xor input_data(2);
      when SEND_WAIT_DATA3 =>
        null;
      when SEND_DATA3 =>
        ps2_data_next <=input_data(3);
        parity_next <= parity xor input_data(3);
      when SEND_WAIT_DATA4 =>
        null;
      when SEND_DATA4 =>
        ps2_data_next <=input_data(4);
        parity_next <= parity xor input_data(4);
      when SEND_WAIT_DATA5 =>
        null;
      when SEND_DATA5 =>
        ps2_data_next <=input_data(5);
        parity_next <= parity xor input_data(5);
      when SEND_WAIT_DATA6 =>
        null;
      when SEND_DATA6 =>
        ps2_data_next <=input_data(6);
        parity_next <= parity xor input_data(6);
      when SEND_WAIT_DATA7 =>
        null;
      when SEND_DATA7 =>
        ps2_data_next <=input_data(7);
        parity_next <= parity xor input_data(7);
      when SEND_WAIT_PARITY =>
        null;
      when SEND_PARITY =>
        ps2_data_next <= parity;
      when SEND_WAIT_STOP =>
        null;
      when SEND_STOP =>
        ps2_data_next <='1';
        ps2_data_hz_next <='1';
      when SEND_WAIT_ACK1 =>
        null;
      when SEND_WAIT_ACK2 =>
        null;
      when SEND_READ_ACK =>
        input_data_send_ok <= not ps2_data_sync(SYNC_STAGES);
        input_data_send_finished <= '1';
      when SEND_FINISH =>
            
      when RECEIVE_START =>
        null;
      when RECEIVE_WAIT_DATA0 =>
        null;
      when RECEIVE_DATA0 =>
        output_data_next <= ps2_data_sync(SYNC_STAGES) & output_data_internal(7 downto 1);
      when RECEIVE_WAIT_DATA1 =>
        null;
      when RECEIVE_DATA1 =>
        output_data_next <= ps2_data_sync(SYNC_STAGES) & output_data_internal(7 downto 1);
      when RECEIVE_WAIT_DATA2 =>
        null;
      when RECEIVE_DATA2 =>
        output_data_next <= ps2_data_sync(SYNC_STAGES) & output_data_internal(7 downto 1);
      when RECEIVE_WAIT_DATA3 =>
        null;
      when RECEIVE_DATA3 =>
        output_data_next <= ps2_data_sync(SYNC_STAGES) & output_data_internal(7 downto 1);
      when RECEIVE_WAIT_DATA4 =>
        null;
      when RECEIVE_DATA4 =>
        output_data_next <= ps2_data_sync(SYNC_STAGES) & output_data_internal(7 downto 1);
      when RECEIVE_WAIT_DATA5 =>
        null;
      when RECEIVE_DATA5 =>
        output_data_next <= ps2_data_sync(SYNC_STAGES) & output_data_internal(7 downto 1);
      when RECEIVE_WAIT_DATA6 =>
        null;
      when RECEIVE_DATA6 =>
        output_data_next <= ps2_data_sync(SYNC_STAGES) & output_data_internal(7 downto 1);
      when RECEIVE_WAIT_DATA7 =>
        null;
      when RECEIVE_DATA7 =>
        output_data_next <= ps2_data_sync(SYNC_STAGES) & output_data_internal(7 downto 1);
      when RECEIVE_WAIT_PARITY =>
        null;
      when RECEIVE_PARITY =>
        null; -- Currently igonring parity
      when RECEIVE_WAIT_STOP =>
        null;
      when RECEIVE_STOP =>
        new_data_next <= '1';
    end case;
  end process;
  
  process(sys_clk, sys_res_n)
  begin
    if sys_res_n = '0' then
      ps2_transceiver_state <= IDLE;
      ps2_clk_last <= '1';
      ps2_clk_internal <= '1';
      ps2_clk_hz <= '1';
      ps2_data_internal <= '1';
      ps2_data_hz <= '1';
      output_data_internal <= (others => '0');
      parity <= '0';
      new_data <= '0';
      prepare_timeout1 <= 0;
      prepare_timeout2 <= 0;
      ps2_clk_sync <= (others => '1');
      ps2_data_sync <= (others => '1');
    elsif rising_edge(sys_clk) then
      ps2_transceiver_state <= ps2_transceiver_state_next;
      ps2_clk_last <= ps2_clk_sync(SYNC_STAGES);
      ps2_clk_internal <= ps2_clk_next;
      ps2_clk_hz <= ps2_clk_hz_next;
      ps2_data_internal <= ps2_data_next;
      ps2_data_hz <= ps2_data_hz_next;
      output_data_internal <= output_data_next;
      parity <= parity_next;
      new_data <= new_data_next;
      prepare_timeout1 <= prepare_timeout1_next;
      prepare_timeout2 <= prepare_timeout2_next;
      ps2_clk_sync(1) <= ps2_clk;
      ps2_data_sync(1) <= ps2_data;
      for i in 2 to SYNC_STAGES loop
        ps2_clk_sync(i) <= ps2_clk_sync(i - 1);
        ps2_data_sync(i) <= ps2_data_sync(i - 1);
      end loop;
    end if;
  end process;
  ps2_clk <= ps2_clk_internal when ps2_clk_hz = '0'
             else 'Z';
  ps2_data <= ps2_data_internal when ps2_data_hz = '0'
             else 'Z';
  output_data <= output_data_internal;
end architecture beh;
