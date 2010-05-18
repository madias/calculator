-------------------------------------------------------------------------
--
-- Filename: textmode_vga_struct.vhd
-- =========
--
-- Short Description:
-- ==================
--   Structual implementation of the toplevel entity.
--
-------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.math_pkg.all;
use work.textmode_vga_pkg.all;
use work.textmode_vga_component_pkg.all;
use work.font_pkg.all;

architecture struct of textmode_vga is
  signal is_data_line : std_logic;
  signal is_eol : std_logic;
  signal char_line_cnt : std_logic_vector(log2c(LINE_COUNT) - 1 downto 0);
  signal char_height_pixel : std_logic_vector(log2c(CHAR_HEIGHT) - 1 downto 0);
  signal rgb : std_logic_vector(RED_BITS + GREEN_BITS + BLUE_BITS - 1 downto 0);
  signal char_cnt : std_logic_vector(log2c(COLUMN_COUNT) - 1 downto 0);
  
  signal mem_data, char_data : std_logic_vector(RED_BITS + GREEN_BITS + BLUE_BITS + CHAR_SIZE - 1 downto 0);
  signal mem_col_address : std_logic_vector(log2c(COLUMN_COUNT) - 1 downto 0);
  signal mem_row_address : std_logic_vector(log2c(LINE_COUNT) - 1 downto 0);
  signal mem_scroll_address : std_logic_vector(log2c(LINE_COUNT) - 1 downto 0);
  signal mem_wr : std_logic;
  signal ack_vga, command_req_vga : std_logic;
  signal command_vga : std_logic_vector(CHAR_SIZE - 1 downto 0);
  signal command_data_vga : std_logic_vector(3 * COLOR_SIZE + CHAR_SIZE - 1 downto 0);
  signal decoded_char : std_logic_vector(0 to CHAR_WIDTH - 1);
  signal blink : std_logic;
  signal background_color, cursor_color : std_logic_vector(RED_BITS + GREEN_BITS + BLUE_BITS - 1 downto 0);
  signal cursor_state : CURSOR_STATE_TYPE;
begin
  textmode_vga_h_sm_inst :  textmode_vga_h_sm
    port map
    (
      sys_clk => vga_clk,
      sys_res_n => vga_res_n,
      background_color => background_color,
      char_cnt => char_cnt,
      char_line_cnt => char_line_cnt,
      cursor_column => mem_col_address,
      cursor_line => mem_row_address,
      cursor_color => cursor_color,
      cursor_state => cursor_state,
      decoded_char => decoded_char,
      color => char_data(RED_BITS + GREEN_BITS + BLUE_BITS + CHAR_SIZE - 1 downto CHAR_SIZE),
      is_data_line => is_data_line,
      is_eol => is_eol,    
      hsync_n => hsync_n,
      rgb => rgb,
      blink => blink
    );
  r <= rgb(RED_BITS + GREEN_BITS + BLUE_BITS - 1 downto GREEN_BITS + BLUE_BITS);
  g <= rgb(GREEN_BITS + BLUE_BITS - 1 downto BLUE_BITS);
  b <= rgb(BLUE_BITS - 1 downto 0);

  textmode_vga_v_sm_inst : textmode_vga_v_sm
    port map
    (
      sys_clk => vga_clk,
      sys_res_n => vga_res_n,
      is_data_line => is_data_line,
      char_line_cnt => char_line_cnt,
      char_height_pixel => char_height_pixel,
      is_eol => is_eol,
      vsync_n => vsync_n
    );
    
  video_memory_inst : video_memory
    generic map
    (
      DATA_WIDTH => RED_BITS + GREEN_BITS + BLUE_BITS + CHAR_SIZE,
      ROW_ADDR_WIDTH => log2c(LINE_COUNT),
      COL_ADDR_WIDTH => log2c(COLUMN_COUNT)
    )
    port map
    (
      vga_clk => vga_clk,
      vga_col_address => char_cnt,
      vga_row_address => char_line_cnt,
      vga_data => char_data,      
      sm_col_address => mem_col_address,
      sm_row_address => mem_row_address,
      sm_data => mem_data,
      sm_wr => mem_wr,
      sm_scroll_address => mem_scroll_address
    );

  font_rom_inst : font_rom
    port map
    (
      vga_clk => vga_clk,
      char => char_data(CHAR_SIZE - 1 downto 0),
      char_height_pixel => char_height_pixel,
      decoded_char => decoded_char
    );

  console_sm_inst : console_sm
    port map
    (
      vga_clk => vga_clk,
      vga_res_n => vga_res_n,
      command => command_vga,
      command_data => command_data_vga,
      command_req => command_req_vga,
      ack => ack_vga,
      column_address => mem_col_address,
      row_address => mem_row_address,
      data => mem_data,
      wr => mem_wr,
      scroll_address => mem_scroll_address,
      background_color => background_color,
      cursor_color => cursor_color,
      cursor_state => cursor_state
    );
  
  console_sm_sync_inst : console_sm_sync
    generic map
    (
      SYNC_STAGES => SYNC_STAGES
    )
    port map
    (
      sys_clk => sys_clk,
      sys_res_n => sys_res_n,
      command_sys => command,
      command_data_sys => command_data,
      free_sys => free,      
      vga_clk => vga_clk,
      vga_res_n => vga_res_n,
      command_vga => command_vga,
      command_data_vga => command_data_vga,
      command_req_vga => command_req_vga,
      ack_vga => ack_vga
    );

  blink_interval_inst : interval
    generic map
    (
      CLK_FREQ => VGA_CLK_FREQ,
      INTERVAL_TIME_MS => BLINK_INTERVAL_MS
    )
    port map
    (
      clk => vga_clk,
      res_n => vga_res_n,
      active => blink
    );
end architecture struct;
