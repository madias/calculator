-------------------------------------------------------------------------
--
-- Filename: textmode_vga_component_pkg.vhd
-- =========
--
-- Short Description:
-- ==================
--   This package contains the declaration of all componets
--   used within the textmode VGA controller implementation.
--
-------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.math_pkg.all;
use work.textmode_vga_pkg.all;
use work.font_pkg.all;
use work.textmode_vga_platform_dependent_pkg.all;

package textmode_vga_component_pkg is
  component textmode_vga_h_sm is
    port
    (
      sys_clk, sys_res_n : in std_logic;
    
      background_color : in std_logic_vector(RED_BITS + GREEN_BITS + BLUE_BITS - 1 downto 0);

      char_cnt         : out std_logic_vector(log2c(COLUMN_COUNT) - 1 downto 0);
      char_line_cnt    : in  std_logic_vector(log2c(LINE_COUNT) - 1 downto 0);
      cursor_column    : in  std_logic_vector(log2c(COLUMN_COUNT) - 1 downto 0);
      cursor_line      : in  std_logic_vector(log2c(LINE_COUNT) - 1 downto 0);
      cursor_color     : in  std_logic_vector(RED_BITS + GREEN_BITS + BLUE_BITS - 1 downto 0);
      cursor_state     : in  CURSOR_STATE_TYPE;
      decoded_char     : in  std_logic_vector(0 to CHAR_WIDTH - 1);
      color            : in  std_logic_vector(RED_BITS + GREEN_BITS + BLUE_BITS - 1 downto 0);
    
      is_data_line : in std_logic;
      is_eol : out std_logic;
    
      hsync_n : out std_logic;
      rgb : out std_logic_vector(RED_BITS + GREEN_BITS + BLUE_BITS - 1 downto 0);
      blink : in std_logic
    );
  end component textmode_vga_h_sm;
  
  component textmode_vga_v_sm is
    port
    (
      sys_clk, sys_res_n : in std_logic;

      is_data_line : out std_logic;
      char_line_cnt : out std_logic_vector(log2c(LINE_COUNT) - 1 downto 0);
      char_height_pixel : out std_logic_vector(log2c(CHAR_HEIGHT) - 1 downto 0);
      is_eol : in std_logic;
  
      vsync_n : out std_logic
    );
  end component textmode_vga_v_sm;

  component textmode_vga is
    generic
    (
      VGA_CLK_FREQ : integer;
      BLINK_INTERVAL_MS : integer;
      SYNC_STAGES : integer
    );
    port
    (
      sys_clk, sys_res_n : in std_logic;
      command : in std_logic_vector(COMMAND_SIZE - 1 downto 0);
      command_data : in std_logic_vector(3 * COLOR_SIZE + CHAR_SIZE - 1 downto 0);
      free : out std_logic;

      vga_clk, vga_res_n : in std_logic;    
      vsync_n : out std_logic;
      hsync_n : out std_logic;
      r : out std_logic_vector(RED_BITS - 1 downto 0);
      g : out std_logic_vector(GREEN_BITS - 1 downto 0);
      b : out std_logic_vector(BLUE_BITS - 1 downto 0)
    );
  end component textmode_vga;

  component video_memory is
    generic
    (
      DATA_WIDTH     : integer;
      ROW_ADDR_WIDTH : integer;
      COL_ADDR_WIDTH : integer
    );
    port
    (
      vga_clk : in  std_logic;    
      vga_row_address    : in  std_logic_vector(ROW_ADDR_WIDTH - 1 downto 0);
      vga_col_address    : in  std_logic_vector(COL_ADDR_WIDTH - 1 downto 0);
      vga_data           : out std_logic_vector(DATA_WIDTH - 1 downto 0);
      sm_row_address  : in  std_logic_vector(ROW_ADDR_WIDTH - 1 downto 0);
      sm_col_address  : in  std_logic_vector(COL_ADDR_WIDTH - 1 downto 0);
      sm_data         : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
      sm_wr           : in  std_logic;
      sm_scroll_address     : in  std_logic_vector(ROW_ADDR_WIDTH - 1 downto 0)
    );
  end component video_memory;

  component pll is
    port
    (
      inclk0 : in std_logic;
      c0 : out std_logic 
    );
  end component pll;

  component console_sm is
    port
    (
      vga_clk, vga_res_n : in std_logic;
      command : in std_logic_vector(COMMAND_SIZE - 1 downto 0);
      command_data : in std_logic_vector(3 * COLOR_SIZE + CHAR_SIZE - 1 downto 0);
      command_req : in std_logic;
      ack : out std_logic;

      column_address : out std_logic_vector(log2c(COLUMN_COUNT) - 1 downto 0);
      row_address : out std_logic_vector(log2c(LINE_COUNT) - 1 downto 0);
      data : out std_logic_vector(RED_BITS + GREEN_BITS + BLUE_BITS + CHAR_SIZE - 1 downto 0);
      wr : out std_logic;
      scroll_address : out std_logic_vector(log2c(LINE_COUNT) - 1 downto 0);
      background_color : out std_logic_vector(RED_BITS + GREEN_BITS + BLUE_BITS - 1 downto 0);
      cursor_color     : out std_logic_vector(RED_BITS + GREEN_BITS + BLUE_BITS - 1 downto 0);
      cursor_state     : out CURSOR_STATE_TYPE
    ); 
  end component console_sm;

  component font_rom is
    port
    (
      vga_clk : in std_logic;
      char : in std_logic_vector(log2c(CHAR_COUNT) - 1 downto 0);
      char_height_pixel : in std_logic_vector(log2c(CHAR_HEIGHT) - 1 downto 0);
      decoded_char : out std_logic_vector(0 to CHAR_WIDTH - 1)
    );
  end component font_rom;

  component console_sm_sync is
    generic
    (
      SYNC_STAGES    : integer
    );
    port
    (
      sys_clk, sys_res_n : in std_logic;
      command_sys : in std_logic_vector(COMMAND_SIZE - 1 downto 0);
      command_data_sys : in std_logic_vector(3 * COLOR_SIZE + CHAR_SIZE - 1 downto 0);
      free_sys : out std_logic;
      
      vga_clk, vga_res_n : in std_logic;
      command_vga : out std_logic_vector(COMMAND_SIZE - 1 downto 0);
      command_data_vga : out std_logic_vector(3 * COLOR_SIZE + CHAR_SIZE - 1 downto 0);
      command_req_vga : out std_logic;
      ack_vga : in std_logic
    );
  end component console_sm_sync;

  component interval is
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
  end component interval;
end package textmode_vga_component_pkg;