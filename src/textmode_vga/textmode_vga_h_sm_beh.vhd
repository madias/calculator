-------------------------------------------------------------------------
--
-- Filename: textmode_vga_h_sm_beh.vhd
-- =========
--
-- Short Description:
-- ==================
--   Behavioural implementation of the horizontal VGA timing finite state machine
--
-------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.math_pkg.all;
use work.textmode_vga_pkg.all;
use work.font_pkg.all;

architecture beh of textmode_vga_h_sm is
  type TEXTMODE_VGA_H_SM_STATE_TYPE is
  (
    HSYNC_FIRST, HSYNC, HBACK_FIRST, HBACK, BLACK_CHAR_NEW,
    BLACK_PIXEL, CHAR_NEW_FG, PIXEL_FG, CHAR_NEW_BG, PIXEL_BG,
    HFRONT_FIRST, HFRONT, HFRONT_LAST, CHAR_NEW_CURSOR, PIXEL_CURSOR
  );
  signal textmode_vga_h_sm_state, textmode_vga_h_sm_state_next : TEXTMODE_VGA_H_SM_STATE_TYPE;
  signal hcnt, hcnt_next : integer range 0 to max(HSYNC_CYCLES, HBACK_CYCLES, HFRONT_CYCLES);
  signal current_char, current_char_next : std_logic_vector(0 to CHAR_WIDTH - 1);
  signal current_color, current_color_next : std_logic_vector(RED_BITS + GREEN_BITS + BLUE_BITS - 1 downto 0);
  signal char_width_pixel, char_width_pixel_next : integer range 0 to CHAR_WIDTH;
  signal char_cnt_int, char_cnt_next : integer range 0 to COLUMN_COUNT;
begin
  char_cnt <= std_logic_vector(to_unsigned(char_cnt_int, log2c(COLUMN_COUNT)));
  
  h_sm_next_state : process(textmode_vga_h_sm_state, hcnt, is_data_line, decoded_char, char_width_pixel, current_char, char_cnt_int, char_line_cnt, blink, cursor_line, cursor_column, cursor_state)
  begin
    textmode_vga_h_sm_state_next <= textmode_vga_h_sm_state;
    case textmode_vga_h_sm_state is
      when HSYNC_FIRST =>
        textmode_vga_h_sm_state_next <= HSYNC;
      when HSYNC =>
        if hcnt = HSYNC_CYCLES - 1 then
          textmode_vga_h_sm_state_next <= HBACK_FIRST;
        end if;
      when HBACK_FIRST =>
        textmode_vga_h_sm_state_next <= HBACK;
      when HBACK =>
        if hcnt = HBACK_CYCLES - 1 then
          if is_data_line = '0' then
            textmode_vga_h_sm_state_next <= BLACK_CHAR_NEW;
          else
            if (cursor_state = CURSOR_ON or
               (cursor_state = CURSOR_BLINK and blink = '0')) and
               char_line_cnt = cursor_line and
               std_logic_vector(to_unsigned(char_cnt_int, log2c(COLUMN_COUNT))) = cursor_column then
              textmode_vga_h_sm_state_next <= CHAR_NEW_CURSOR;
            elsif decoded_char(0) = '1' then
              textmode_vga_h_sm_state_next <= CHAR_NEW_FG;
            else
              textmode_vga_h_sm_state_next <= CHAR_NEW_BG;
            end if;
          end if;
        end if;
      when BLACK_CHAR_NEW =>
        textmode_vga_h_sm_state_next <= BLACK_PIXEL;
      when BLACK_PIXEL =>
        if char_width_pixel = CHAR_WIDTH - 1 then
          if char_cnt_int = COLUMN_COUNT then
            textmode_vga_h_sm_state_next <= HFRONT_FIRST;
          else
            textmode_vga_h_sm_state_next <= BLACK_CHAR_NEW;
          end if;
        end if;
      when CHAR_NEW_FG =>
        if decoded_char(1) = '1' then
          textmode_vga_h_sm_state_next <= PIXEL_FG;
        else
          textmode_vga_h_sm_state_next <= PIXEL_BG;
        end if;
      when CHAR_NEW_CURSOR =>
        textmode_vga_h_sm_state_next <= PIXEL_CURSOR;
      when PIXEL_FG =>
        if char_width_pixel = CHAR_WIDTH - 1 then
          if char_cnt_int = COLUMN_COUNT then
            textmode_vga_h_sm_state_next <= HFRONT_FIRST;  
          else
            if (cursor_state = CURSOR_ON or
               (cursor_state = CURSOR_BLINK and blink = '0')) and
               char_line_cnt = cursor_line and
               std_logic_vector(to_unsigned(char_cnt_int, log2c(COLUMN_COUNT))) = cursor_column then
              textmode_vga_h_sm_state_next <= CHAR_NEW_CURSOR;
            elsif decoded_char(0) = '1' then
              textmode_vga_h_sm_state_next <= CHAR_NEW_FG;  
            else
              textmode_vga_h_sm_state_next <= CHAR_NEW_BG;  
            end if;
          end if;
        else
          if current_char(char_width_pixel + 1) = '1' then
            textmode_vga_h_sm_state_next <= PIXEL_FG;
          else
            textmode_vga_h_sm_state_next <= PIXEL_BG;
          end if;
        end if;
      when PIXEL_CURSOR =>
        if char_width_pixel = CHAR_WIDTH - 1 then
          if char_cnt_int = COLUMN_COUNT then
            textmode_vga_h_sm_state_next <= HFRONT_FIRST;  
          else
            if decoded_char(0) = '1' then
              textmode_vga_h_sm_state_next <= CHAR_NEW_FG;  
            else
              textmode_vga_h_sm_state_next <= CHAR_NEW_BG;  
            end if;
          end if;
        end if;
      when CHAR_NEW_BG =>
        if decoded_char(1) = '1' then
          textmode_vga_h_sm_state_next <= PIXEL_FG;
        else
          textmode_vga_h_sm_state_next <= PIXEL_BG;
        end if;
      when PIXEL_BG =>
        if char_width_pixel = CHAR_WIDTH - 1 then
          if char_cnt_int = COLUMN_COUNT then
            textmode_vga_h_sm_state_next <= HFRONT_FIRST;  
          else
            if (cursor_state = CURSOR_ON or
               (cursor_state = CURSOR_BLINK and blink = '0')) and
               char_line_cnt = cursor_line and
              std_logic_vector(to_unsigned(char_cnt_int, log2c(COLUMN_COUNT))) = cursor_column then
              textmode_vga_h_sm_state_next <= CHAR_NEW_CURSOR;
            elsif decoded_char(0) = '1' then
              textmode_vga_h_sm_state_next <= CHAR_NEW_FG;  
            else
              textmode_vga_h_sm_state_next <= CHAR_NEW_BG;  
            end if;
          end if;
        else
          if current_char(char_width_pixel + 1) = '1' then
            textmode_vga_h_sm_state_next <= PIXEL_FG;
          else
            textmode_vga_h_sm_state_next <= PIXEL_BG;
          end if;
        end if;
      when HFRONT_FIRST =>
        textmode_vga_h_sm_state_next <= HFRONT;
      when HFRONT =>
        if hcnt = HFRONT_CYCLES - 2 then
          textmode_vga_h_sm_state_next <= HFRONT_LAST;
        end if;
      when HFRONT_LAST =>
        textmode_vga_h_sm_state_next <= HSYNC_FIRST;
    end case;
  end process h_sm_next_state;
  
  h_sm_output : process(textmode_vga_h_sm_state, decoded_char, current_char, background_color, hcnt, char_cnt_int, char_width_pixel, current_color, color, cursor_color)
  begin
    hsync_n <= '1';
    rgb <= COLOR_BLACK(3 * COLOR_SIZE - 1 downto 3 * COLOR_SIZE - RED_BITS) &
           COLOR_BLACK(2 * COLOR_SIZE - 1 downto 2 * COLOR_SIZE - GREEN_BITS) &
           COLOR_BLACK(COLOR_SIZE - 1 downto COLOR_SIZE - BLUE_BITS);
    is_eol <= '0';
    hcnt_next <= hcnt;
    char_cnt_next <= char_cnt_int;
    char_width_pixel_next <= char_width_pixel;
    current_char_next <= current_char;
    current_color_next <= current_color;

    case textmode_vga_h_sm_state is
      when HSYNC_FIRST =>
        hsync_n <= '0';
        hcnt_next <= 0;
        char_cnt_next <= 0;
      when HSYNC =>
        hsync_n <= '0';
        hcnt_next <= hcnt + 1;
      when HBACK_FIRST =>
        hcnt_next <= 0;
      when HBACK =>
        hcnt_next <= hcnt + 1;
      when BLACK_CHAR_NEW =>
        char_cnt_next <= char_cnt_int + 1;
        char_width_pixel_next <= 1;
      when BLACK_PIXEL =>
        char_width_pixel_next <= char_width_pixel + 1;
      when CHAR_NEW_FG =>
        rgb <= color;
        char_cnt_next <= char_cnt_int + 1;
        char_width_pixel_next <= 1;
        current_char_next <= decoded_char;
        current_color_next <= color;
      when PIXEL_FG =>
        rgb <= current_color;
        char_width_pixel_next <= char_width_pixel + 1;
      when CHAR_NEW_CURSOR =>
        rgb <= cursor_color;
        char_cnt_next <= char_cnt_int + 1;
        char_width_pixel_next <= 1;
        current_char_next <= decoded_char;
        current_color_next <= color;
      when PIXEL_CURSOR =>
        rgb <= cursor_color;
        char_width_pixel_next <= char_width_pixel + 1;
      when CHAR_NEW_BG =>
        rgb <= background_color;
        char_cnt_next <= char_cnt_int + 1;
        char_width_pixel_next <= 1;
        current_char_next <= decoded_char;
        current_color_next <= color;
      when PIXEL_BG =>
        rgb <= background_color;
        char_width_pixel_next <= char_width_pixel + 1;
      when HFRONT_FIRST =>
        hcnt_next <= 0;
      when HFRONT =>
        hcnt_next <= hcnt + 1;
      when HFRONT_LAST =>
        is_eol <= '1';
    end case;
  end process h_sm_output;

  sync : process(sys_clk, sys_res_n)
  begin
    if sys_res_n = '0' then
      textmode_vga_h_sm_state <= HSYNC_FIRST;
      hcnt <= 0;
      char_cnt_int <= 0;
      char_width_pixel <= 0;
      current_char <= (others => '0');
      current_color <= COLOR_WHITE(3 * COLOR_SIZE - 1 downto 3 * COLOR_SIZE - RED_BITS) &
                       COLOR_WHITE(2 * COLOR_SIZE - 1 downto 2 * COLOR_SIZE - GREEN_BITS) &
                       COLOR_WHITE(COLOR_SIZE - 1 downto COLOR_SIZE - BLUE_BITS);
    elsif rising_edge(sys_clk) then
      textmode_vga_h_sm_state <= textmode_vga_h_sm_state_next;
      hcnt <= hcnt_next;
      char_cnt_int <= char_cnt_next;
      char_width_pixel <= char_width_pixel_next;
      current_char <= current_char_next;
      current_color <= current_color_next;
    end if;
  end process sync;
end architecture beh;
