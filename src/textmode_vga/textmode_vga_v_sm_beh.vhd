-------------------------------------------------------------------------
--
-- Filename: textmode_vga_v_sm_beh.vhd
-- =========
--
-- Short Description:
-- ==================
--   Behavioural implementation of the vertical VGA timing finite state machine
--
-------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.math_pkg.all;
use work.textmode_vga_pkg.all;

architecture beh of textmode_vga_v_sm is
  type TEXTMODE_VGA_V_SM_STATE_TYPE is
  (
    VSYNC_FIRST, VSYNC, VSYNC_NEXT,
    VBACK_FIRST, VBACK, VBACK_NEXT,
    VDATA_FIRST, VDATA, VDATA_NEXTLINE, VDATA_NEXTCHAR,
    VFRONT_FIRST, VFRONT, VFRONT_NEXT    
  );
  signal textmode_vga_v_sm_state, textmode_vga_v_sm_state_next : TEXTMODE_VGA_V_SM_STATE_TYPE;
  signal vcnt, vcnt_next : integer range 0 to max(VSYNC_LINES, VBACK_LINES, VFRONT_LINES);
  signal char_height_pixel_int, char_height_pixel_int_next : integer range 0 to CHAR_HEIGHT;
  signal char_line_cnt_int, char_line_cnt_int_next : integer range 0 to LINE_COUNT;
begin
  char_height_pixel <= std_logic_vector(to_unsigned(char_height_pixel_int, log2c(CHAR_HEIGHT)));
  char_line_cnt <= std_logic_vector(to_unsigned(char_line_cnt_int, log2c(LINE_COUNT)));
  
  v_sm_next_state : process(textmode_vga_v_sm_state, is_eol, vcnt, char_height_pixel_int, char_line_cnt_int)
  begin
    textmode_vga_v_sm_state_next <= textmode_vga_v_sm_state;
    
    case textmode_vga_v_sm_state is
      when VSYNC_FIRST =>
        textmode_vga_v_sm_state_next <= VSYNC;
      when VSYNC =>
        if is_eol = '1' then
          if vcnt = VSYNC_LINES - 1 then
            textmode_vga_v_sm_state_next <= VBACK_FIRST;
          else
            textmode_vga_v_sm_state_next <= VSYNC_NEXT;
          end if;
        end if;
      when VSYNC_NEXT =>
        textmode_vga_v_sm_state_next <= VSYNC;
      when VBACK_FIRST =>
        textmode_vga_v_sm_state_next <= VBACK;
      when VBACK =>
        if is_eol = '1' then
          if vcnt = VBACK_LINES - 1 then
            textmode_vga_v_sm_state_next <= VDATA_FIRST;
          else
            textmode_vga_v_sm_state_next <= VBACK_NEXT;
          end if;
        end if;
      when VBACK_NEXT =>
        textmode_vga_v_sm_state_next <= VBACK;
      when VDATA_FIRST =>
        textmode_vga_v_sm_state_next <= VDATA;
      when VDATA =>
        if is_eol = '1' then
          if char_height_pixel_int = CHAR_HEIGHT - 1 then
            if char_line_cnt_int = LINE_COUNT - 1 then
              textmode_vga_v_sm_state_next <= VFRONT_FIRST;
            else
              textmode_vga_v_sm_state_next <= VDATA_NEXTCHAR;
            end if;
          else
            textmode_vga_v_sm_state_next <= VDATA_NEXTLINE;
          end if;
        end if;
      when VDATA_NEXTLINE =>
        textmode_vga_v_sm_state_next <= VDATA;
      when VDATA_NEXTCHAR =>
        textmode_vga_v_sm_state_next <= VDATA;
      when VFRONT_FIRST =>
        textmode_vga_v_sm_state_next <= VFRONT;
      when VFRONT =>
        if is_eol = '1' then
          if vcnt = VFRONT_LINES - 1 then
            textmode_vga_v_sm_state_next <= VSYNC_FIRST;
          else
            textmode_vga_v_sm_state_next <= VFRONT_NEXT;
          end if;
        end if;
      when VFRONT_NEXT =>
        textmode_vga_v_sm_state_next <= VFRONT;
    end case;
  end process v_sm_next_state;

  v_sm_output : process(textmode_vga_v_sm_state, vcnt, char_height_pixel_int, char_line_cnt_int)
  begin
    vcnt_next <= vcnt;
    is_data_line <= '0';
    vsync_n <= '1';
    char_height_pixel_int_next <= char_height_pixel_int;
    char_line_cnt_int_next <= char_line_cnt_int;
    
    case textmode_vga_v_sm_state is
      when VSYNC_FIRST =>
        vsync_n <= '0';
        vcnt_next <= 0;
      when VSYNC =>
        vsync_n <= '0';
      when VSYNC_NEXT =>
        vsync_n <= '0';
        vcnt_next <= vcnt + 1;
      when VBACK_FIRST =>
        vcnt_next <= 0;        
      when VBACK =>
        null;
      when VBACK_NEXT =>
        vcnt_next <= vcnt + 1;
      when VDATA_FIRST =>
        is_data_line <= '1';
        char_height_pixel_int_next <= 0;
        char_line_cnt_int_next <= 0;
      when VDATA =>
        is_data_line <= '1';
      when VDATA_NEXTLINE =>
        is_data_line <= '1';
        char_height_pixel_int_next <= char_height_pixel_int + 1;
      when VDATA_NEXTCHAR =>
        is_data_line <= '1';
        char_height_pixel_int_next <= 0;
        char_line_cnt_int_next <= char_line_cnt_int + 1;
      when VFRONT_FIRST =>
        vcnt_next <= 0;
      when VFRONT =>
        null;
      when VFRONT_NEXT =>
        vcnt_next <= vcnt + 1;
    end case;
  end process v_sm_output;
  
  sync : process(sys_clk, sys_res_n)
  begin
    if sys_res_n = '0' then
      textmode_vga_v_sm_state <= VSYNC_FIRST;
      vcnt <= 0;
      char_height_pixel_int <= 0;      
      char_line_cnt_int <= 0;
    elsif rising_edge(sys_clk) then
      textmode_vga_v_sm_state <= textmode_vga_v_sm_state_next;
      vcnt <= vcnt_next;
      char_height_pixel_int <= char_height_pixel_int_next;
      char_line_cnt_int <= char_line_cnt_int_next;
    end if;
  end process sync;
end architecture beh;
