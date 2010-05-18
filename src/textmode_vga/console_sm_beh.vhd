-------------------------------------------------------------------------
--
-- Filename: console_sm_beh.vhd
-- =========
--
-- Short Description:
-- ==================
--   Console mode finite state machine behavioral implementation
--
-------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.textmode_vga_pkg.all;
use work.textmode_vga_platform_dependent_pkg.all;

architecture beh of console_sm is
  type STATE_TYPE is
  (
    STATE_IDLE, STATE_ACK_UNKNOWN, STATE_WAIT_REQ_RELEASE, STATE_NEW_LINE_SIMPLE,
    STATE_NEW_LINE_SCROLL, STATE_CARRIAGE_RETURN, STATE_SET_CHAR,
    STATE_SET_CHAR_NEW_LINE_AND_CARRIAGE_RETURN_SIMPLE,
    STATE_SET_CHAR_NEW_LINE_AND_CARRIAGE_RETURN_SCROLL,
    STATE_SET_BACKGROUND, STATE_SCROLL_NEXT, STATE_SCROLL_TOP,
    STATE_SCROLL_CLEAR_LINE, STATE_SCROLL_CLEAR_LINE_LOOP,
    STATE_SCROLL_CLEAR_LINE_FINISH, STATE_SET_CURSOR_STATE,
    STATE_SET_CURSOR_COLOR, STATE_SET_CURSOR_COLUMN,
    STATE_SET_CURSOR_LINE, STATE_SET_CURSOR_STATE_OFF,
    STATE_SET_CURSOR_STATE_ON, STATE_SET_CURSOR_STATE_BLINK
  );

  signal state, state_next : STATE_TYPE;
  signal line_int : integer range 0 to LINE_COUNT - 1;
  signal line_next : integer range 0 to LINE_COUNT;
  signal column_int : integer range 0 to COLUMN_COUNT - 1;
  signal column_save, column_save_next : integer range 0 to COLUMN_COUNT - 1;
  signal column_next : integer range 0 to COLUMN_COUNT;
  signal scroll_int : integer range 0 to LINE_COUNT - 1;
  signal scroll_next : integer range 0 to LINE_COUNT;  
  signal ack_next : std_logic;  
  signal background_color_int, background_color_next : std_logic_vector(RED_BITS + GREEN_BITS + BLUE_BITS - 1 downto 0);
  signal cursor_color_int, cursor_color_next : std_logic_vector(RED_BITS + GREEN_BITS + BLUE_BITS - 1 downto 0);
  signal cursor_state_int, cursor_state_next : CURSOR_STATE_TYPE;
begin
  column_address <= std_logic_vector(to_unsigned(column_int, log2c(COLUMN_COUNT)));
  row_address <= std_logic_vector(to_unsigned(line_int, log2c(LINE_COUNT)));
  scroll_address <= std_logic_vector(to_unsigned(scroll_int, log2c(LINE_COUNT)));
  background_color <= background_color_int;
  cursor_color <= cursor_color_int;
  cursor_state <= cursor_state_int;

  process(state, line_int, column_int, scroll_int, command, command_data, command_req)
  begin
    state_next <= state;
    
    case state is
      when STATE_IDLE =>
        if command_req = '1' then
          if command = COMMAND_SET_CHAR then
            if command_data(CHAR_SIZE - 1 downto 0) = CHAR_NEW_LINE then
              if line_int < LINE_COUNT - 1 then
                state_next <= STATE_NEW_LINE_SIMPLE;
              else  
                state_next <= STATE_NEW_LINE_SCROLL;
              end if;
            elsif command_data(CHAR_SIZE - 1 downto 0) = CHAR_CARRIAGE_RETURN then
              state_next <= STATE_CARRIAGE_RETURN;
            else
              if column_int < COLUMN_COUNT - 1 then
                state_next <= STATE_SET_CHAR;
              else
                if line_int < LINE_COUNT - 1 then
                  state_next <= STATE_SET_CHAR_NEW_LINE_AND_CARRIAGE_RETURN_SIMPLE;
                else
                  state_next <= STATE_SET_CHAR_NEW_LINE_AND_CARRIAGE_RETURN_SCROLL;
                end if;
              end if;
            end if;      
          elsif command = COMMAND_SET_BACKGROUND then
            state_next <= STATE_SET_BACKGROUND;
          elsif command = COMMAND_SET_CURSOR_STATE then
            state_next <= STATE_SET_CURSOR_STATE;
          elsif command = COMMAND_SET_CURSOR_COLOR then
            state_next <= STATE_SET_CURSOR_COLOR;
          elsif command = COMMAND_SET_CURSOR_COLUMN then
            state_next <= STATE_SET_CURSOR_COLUMN;
          elsif command = COMMAND_SET_CURSOR_LINE then
            state_next <= STATE_SET_CURSOR_LINE;
          else
            state_next <= STATE_ACK_UNKNOWN;
          end if;
        end if;
      when STATE_ACK_UNKNOWN =>
        state_next <= STATE_WAIT_REQ_RELEASE;
      when STATE_NEW_LINE_SIMPLE =>
        state_next <= STATE_WAIT_REQ_RELEASE;
      when STATE_NEW_LINE_SCROLL =>
        if scroll_int < LINE_COUNT - 1 then
          state_next <= STATE_SCROLL_NEXT;
        else
          state_next <= STATE_SCROLL_TOP;
        end if;        
      when STATE_CARRIAGE_RETURN =>
        state_next <= STATE_WAIT_REQ_RELEASE;
      when STATE_SET_CHAR =>
        state_next <= STATE_WAIT_REQ_RELEASE;
      when STATE_SET_CHAR_NEW_LINE_AND_CARRIAGE_RETURN_SIMPLE =>
        state_next <= STATE_WAIT_REQ_RELEASE;
      when STATE_SET_CHAR_NEW_LINE_AND_CARRIAGE_RETURN_SCROLL =>
        if scroll_int < LINE_COUNT - 1 then
          state_next <= STATE_SCROLL_NEXT;
        else
          state_next <= STATE_SCROLL_TOP;
        end if;
      when STATE_SCROLL_NEXT =>
        state_next <= STATE_SCROLL_CLEAR_LINE;
      when STATE_SCROLL_TOP =>
        state_next <= STATE_SCROLL_CLEAR_LINE;
      when STATE_SCROLL_CLEAR_LINE =>
        state_next <= STATE_SCROLL_CLEAR_LINE_LOOP;
      when STATE_SCROLL_CLEAR_LINE_LOOP =>
        if column_int = COLUMN_COUNT - 2 then
          state_next <= STATE_SCROLL_CLEAR_LINE_FINISH;
        end if;
      when STATE_SCROLL_CLEAR_LINE_FINISH =>
        state_next <= STATE_WAIT_REQ_RELEASE;
      when STATE_WAIT_REQ_RELEASE =>
        if command_req = '0' then
          state_next <= STATE_IDLE;
        end if;
      when STATE_SET_BACKGROUND =>
        state_next <= STATE_WAIT_REQ_RELEASE;
      when STATE_SET_CURSOR_STATE =>
        if command_data(1 downto 0) = "00" then
          state_next <= STATE_SET_CURSOR_STATE_OFF;
        elsif command_data(1 downto 0) = "01" then
          state_next <= STATE_SET_CURSOR_STATE_ON;
        else
          state_next <= STATE_SET_CURSOR_STATE_BLINK;
        end if;
      when STATE_SET_CURSOR_STATE_OFF =>
        state_next <= STATE_WAIT_REQ_RELEASE;
      when STATE_SET_CURSOR_STATE_ON =>
        state_next <= STATE_WAIT_REQ_RELEASE;
      when STATE_SET_CURSOR_STATE_BLINK =>
        state_next <= STATE_WAIT_REQ_RELEASE;
      when STATE_SET_CURSOR_COLOR =>
        state_next <= STATE_WAIT_REQ_RELEASE;
      when STATE_SET_CURSOR_COLUMN =>
        state_next <= STATE_WAIT_REQ_RELEASE;
      when STATE_SET_CURSOR_LINE =>
        state_next <= STATE_WAIT_REQ_RELEASE;
    end case;
  end process;

  process(state, line_int, column_int, scroll_int, column_save, background_color_int, cursor_color_int, cursor_state_int, command_data)
  begin
    line_next <= line_int;
    column_next <= column_int;
    scroll_next <= scroll_int;
    column_save_next <= column_save;
    data <= std_logic_vector(to_unsigned(0, RED_BITS + GREEN_BITS + BLUE_BITS + CHAR_SIZE));
    ack_next <= '0';
    wr <= '0';
    background_color_next <= background_color_int;
    cursor_color_next <= cursor_color_int;
    cursor_state_next <= cursor_state_int;
        
    case state is
      when STATE_IDLE =>
        null;
      when STATE_ACK_UNKNOWN =>
        ack_next <= '1';
      when STATE_NEW_LINE_SIMPLE =>
        line_next <= line_int + 1;
        ack_next <= '1';
      when STATE_NEW_LINE_SCROLL =>
        null;
      when STATE_CARRIAGE_RETURN =>
        column_next <= 0;
        ack_next <= '1';
      when STATE_SET_CHAR =>
        data <= command_data(CHAR_SIZE + 3 * COLOR_SIZE - 1 downto CHAR_SIZE + 3 * COLOR_SIZE - RED_BITS) &
                command_data(CHAR_SIZE + 2 * COLOR_SIZE - 1 downto CHAR_SIZE + 2 * COLOR_SIZE - GREEN_BITS) &
                command_data(CHAR_SIZE + COLOR_SIZE - 1 downto CHAR_SIZE + COLOR_SIZE - BLUE_BITS) &
                command_data(CHAR_SIZE - 1 downto 0);
        wr <= '1';
        column_next <= column_int + 1;
        ack_next <= '1';
      when STATE_SET_CHAR_NEW_LINE_AND_CARRIAGE_RETURN_SIMPLE =>
        data <= command_data(CHAR_SIZE + 3 * COLOR_SIZE - 1 downto CHAR_SIZE + 3 * COLOR_SIZE - RED_BITS) &
                command_data(CHAR_SIZE + 2 * COLOR_SIZE - 1 downto CHAR_SIZE + 2 * COLOR_SIZE - GREEN_BITS) &
                command_data(CHAR_SIZE + COLOR_SIZE - 1 downto CHAR_SIZE + COLOR_SIZE - BLUE_BITS) &
                command_data(CHAR_SIZE - 1 downto 0);
        wr <= '1';
        line_next <= line_int + 1;
        column_next <= 0;
        ack_next <= '1';
      when STATE_SET_CHAR_NEW_LINE_AND_CARRIAGE_RETURN_SCROLL =>
        data <= command_data(CHAR_SIZE + 3 * COLOR_SIZE - 1 downto CHAR_SIZE + 3 * COLOR_SIZE - RED_BITS) &
                command_data(CHAR_SIZE + 2 * COLOR_SIZE - 1 downto CHAR_SIZE + 2 * COLOR_SIZE - GREEN_BITS) &
                command_data(CHAR_SIZE + COLOR_SIZE - 1 downto CHAR_SIZE + COLOR_SIZE - BLUE_BITS) &
                command_data(CHAR_SIZE - 1 downto 0);
        wr <= '1';
        column_next <= 0;
      when STATE_SCROLL_NEXT =>
        scroll_next <= scroll_int + 1;
      when STATE_SCROLL_TOP =>
        scroll_next <= 0;
      when STATE_SCROLL_CLEAR_LINE =>
        column_save_next <= column_int;
        column_next <= 0;
      when STATE_SCROLL_CLEAR_LINE_LOOP =>
        data <= COLOR_BLACK(3 * COLOR_SIZE - 1 downto 3 * COLOR_SIZE - RED_BITS) &
                COLOR_BLACK(2 * COLOR_SIZE - 1 downto 2 * COLOR_SIZE - GREEN_BITS) &
                COLOR_BLACK(COLOR_SIZE - 1 downto COLOR_SIZE - BLUE_BITS) &
                CHAR_NULL;
        wr <= '1';
        column_next <= column_int + 1;
      when STATE_SCROLL_CLEAR_LINE_FINISH =>
        data <= COLOR_BLACK(3 * COLOR_SIZE - 1 downto 3 * COLOR_SIZE - RED_BITS) &
                COLOR_BLACK(2 * COLOR_SIZE - 1 downto 2 * COLOR_SIZE - GREEN_BITS) &
                COLOR_BLACK(COLOR_SIZE - 1 downto COLOR_SIZE - BLUE_BITS) &
                CHAR_NULL;
        wr <= '1';
        column_next <= column_save;
        ack_next <= '1';
      when STATE_WAIT_REQ_RELEASE =>
        ack_next <= '1';
      when STATE_SET_BACKGROUND =>
        background_color_next <=
          command_data(3 * COLOR_SIZE - 1 downto 3 * COLOR_SIZE - RED_BITS) &
          command_data(2 * COLOR_SIZE - 1 downto 2 * COLOR_SIZE - GREEN_BITS) &
          command_data(COLOR_SIZE - 1 downto COLOR_SIZE - BLUE_BITS);
        ack_next <= '1';
      when STATE_SET_CURSOR_STATE =>
        null;
      when STATE_SET_CURSOR_STATE_OFF =>
        cursor_state_next <= CURSOR_OFF;
        ack_next <= '1';
      when STATE_SET_CURSOR_STATE_ON =>
        cursor_state_next <= CURSOR_ON;
        ack_next <= '1';
      when STATE_SET_CURSOR_STATE_BLINK =>
        cursor_state_next <= CURSOR_BLINK;
        ack_next <= '1';
      when STATE_SET_CURSOR_COLOR =>
        cursor_color_next <=
          command_data(3 * COLOR_SIZE - 1 downto 3 * COLOR_SIZE - RED_BITS) &
          command_data(2 * COLOR_SIZE - 1 downto 2 * COLOR_SIZE - GREEN_BITS) &
          command_data(COLOR_SIZE - 1 downto COLOR_SIZE - BLUE_BITS);
        ack_next <= '1';
      when STATE_SET_CURSOR_COLUMN =>
        column_next <= to_integer(unsigned(command_data(log2c(COLUMN_COUNT) - 1 downto 0)));
        ack_next <= '1';
      when STATE_SET_CURSOR_LINE =>
        line_next <= to_integer(unsigned(command_data(log2c(LINE_COUNT) - 1 downto 0)));
        ack_next <= '1';
    end case;
  end process;

  process(vga_clk, vga_res_n)
  begin
    if vga_res_n = '0' then
      state <= STATE_IDLE;
      line_int <= 0;
      column_int <= 0;
      scroll_int <= 0;
      column_save <= 0;
      ack <= '0';
      background_color_int <= COLOR_BLACK(3 * COLOR_SIZE - 1 downto 3 * COLOR_SIZE - RED_BITS) &
                              COLOR_BLACK(2 * COLOR_SIZE - 1 downto 2 * COLOR_SIZE - GREEN_BITS) &
                              COLOR_BLACK(COLOR_SIZE - 1 downto COLOR_SIZE - BLUE_BITS);
      cursor_color_int <= COLOR_WHITE(3 * COLOR_SIZE - 1 downto 3 * COLOR_SIZE - RED_BITS) &
                          COLOR_WHITE(2 * COLOR_SIZE - 1 downto 2 * COLOR_SIZE - GREEN_BITS) &
                          COLOR_WHITE(COLOR_SIZE - 1 downto COLOR_SIZE - BLUE_BITS);
      cursor_state_int <= CURSOR_BLINK;
    elsif rising_edge(vga_clk) then
      state <= state_next;
      line_int <= line_next;
      column_int <= column_next;
      scroll_int <= scroll_next;
      column_save <= column_save_next;
      ack <= ack_next;
      background_color_int <= background_color_next;
      cursor_color_int <= cursor_color_next;
      cursor_state_int <= cursor_state_next;
    end if;
  end process;
end architecture beh;
