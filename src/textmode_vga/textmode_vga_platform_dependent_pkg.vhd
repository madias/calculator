-------------------------------------------------------------------------
--
-- Filename: textmode_vga_platform_dependent_pkg.vhd
-- =========
--
-- Short Description:
-- ==================
--   Platform depnded declarations used within the textmode
--   VGA controller implementation.
--
-------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

package textmode_vga_platform_dependent_pkg is
  constant RED_BITS : integer := 3;
  constant GREEN_BITS : integer := 3;
  constant BLUE_BITS : integer := 2;  
end package textmode_vga_platform_dependent_pkg;