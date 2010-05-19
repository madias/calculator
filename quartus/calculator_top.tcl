# Copyright (C) 1991-2009 Altera Corporation
# Your use of Altera Corporation's design tools, logic functions 
# and other software and tools, and its AMPP partner logic 
# functions, and any output files from any of the foregoing 
# (including device programming or simulation files), and any 
# associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License 
# Subscription Agreement, Altera MegaCore Function License 
# Agreement, or other applicable license agreement, including, 
# without limitation, that your use is for the sole purpose of 
# programming logic devices manufactured by Altera and sold by 
# Altera or its authorized distributors.  Please refer to the 
# applicable agreement for further details.

# Quartus II: Generate Tcl File for Project
# File: calculator_top.tcl
# Generated on: Tue May 18 16:07:25 2010

# Load Quartus II Tcl Project package
package require ::quartus::project

set need_to_close_project 0
set make_assignments 1

# Check that the right project is open
if {[is_project_open]} {
	if {[string compare $quartus(project) "calculator_top"]} {
		puts "Project calculator_top is not open"
		set make_assignments 0
	}
} else {
	# Only open if not already open
	if {[project_exists calculator_top]} {
		project_open -revision calculator_top calculator_top
	} else {
		project_new -revision calculator_top calculator_top
	}
	set need_to_close_project 1
}

# Make assignments
if {$make_assignments} {
	set_global_assignment -name FAMILY Stratix
	set_global_assignment -name DEVICE EP1S25F672C6
	set_global_assignment -name ORIGINAL_QUARTUS_VERSION "9.1 SP1"
	set_global_assignment -name PROJECT_CREATION_TIME_DATE "08:41:33  APRIL 27, 2010"
	set_global_assignment -name LAST_QUARTUS_VERSION 9.1
	set_global_assignment -name DEVICE_FILTER_PACKAGE FBGA
	set_global_assignment -name DEVICE_FILTER_PIN_COUNT 672
	set_global_assignment -name DEVICE_FILTER_SPEED_GRADE 6
	set_global_assignment -name ERROR_CHECK_FREQUENCY_DIVISOR 1
	set_global_assignment -name EDA_SIMULATION_TOOL "ModelSim-Altera (VHDL)"
	set_global_assignment -name EDA_OUTPUT_DATA_FORMAT VHDL -section_id eda_simulation
	set_global_assignment -name USE_GENERATED_PHYSICAL_CONSTRAINTS OFF -section_id eda_blast_fpga
	set_global_assignment -name LL_ROOT_REGION ON -section_id "Root Region"
	set_global_assignment -name LL_MEMBER_STATE LOCKED -section_id "Root Region"
	set_global_assignment -name PARTITION_NETLIST_TYPE SOURCE -section_id Top
	set_global_assignment -name PARTITION_COLOR 16764057 -section_id Top
	set_global_assignment -name MISC_FILE /homes/s0726419/Desktop/calculator/quartus/calculator_top.dpf
	set_global_assignment -name VHDL_FILE ../src/ps2/ps2_transceiver_beh.vhd
	set_global_assignment -name VHDL_FILE ../src/ps2/ps2_transceiver.vhd
	set_global_assignment -name VHDL_FILE ../src/ps2/ps2_keyboard_controller_pkg.vhd
	set_global_assignment -name VHDL_FILE ../src/ps2/ps2_keyboard_controller_beh.vhd
	set_global_assignment -name VHDL_FILE ../src/ps2/ps2_keyboard_controller.vhd
	set_global_assignment -name VHDL_FILE ../src/ps2/ps2_transceiver_pkg.vhd
	set_global_assignment -name VHDL_FILE ../src/math/math_pkg.vhd
	set_global_assignment -name VHDL_FILE ../src/textmode_vga/textmode_vga_component_pkg.vhd
	set_global_assignment -name VHDL_FILE ../src/textmode_vga/video_memory_beh.vhd
	set_global_assignment -name VHDL_FILE ../src/textmode_vga/video_memory.vhd
	set_global_assignment -name VHDL_FILE ../src/textmode_vga/textmode_vga_v_sm_beh.vhd
	set_global_assignment -name VHDL_FILE ../src/textmode_vga/textmode_vga_v_sm.vhd
	set_global_assignment -name VHDL_FILE ../src/textmode_vga/textmode_vga_struct.vhd
	set_global_assignment -name VHDL_FILE ../src/textmode_vga/textmode_vga_pkg.vhd
	set_global_assignment -name VHDL_FILE ../src/textmode_vga/textmode_vga_platform_dependent_pkg.vhd
	set_global_assignment -name VHDL_FILE ../src/textmode_vga/textmode_vga_h_sm_beh.vhd
	set_global_assignment -name VHDL_FILE ../src/textmode_vga/textmode_vga_h_sm.vhd
	set_global_assignment -name VHDL_FILE ../src/textmode_vga/textmode_vga.vhd
	set_global_assignment -name VHDL_FILE ../src/textmode_vga/interval_beh.vhd
	set_global_assignment -name VHDL_FILE ../src/textmode_vga/interval.vhd
	set_global_assignment -name VHDL_FILE ../src/textmode_vga/font_rom_beh.vhd
	set_global_assignment -name VHDL_FILE ../src/textmode_vga/font_rom.vhd
	set_global_assignment -name VHDL_FILE ../src/textmode_vga/font_pkg.vhd
	set_global_assignment -name VHDL_FILE ../src/textmode_vga/console_sm_sync_beh.vhd
	set_global_assignment -name VHDL_FILE ../src/textmode_vga/console_sm_sync.vhd
	set_global_assignment -name VHDL_FILE ../src/textmode_vga/console_sm_beh.vhd
	set_global_assignment -name VHDL_FILE ../src/textmode_vga/console_sm.vhd
	set_global_assignment -name VHDL_FILE ../src/calculator_top.vhd
	set_global_assignment -name VHDL_FILE ../src/memory.vhd
	set_global_assignment -name VHDL_FILE ../src/screen.vhd
	set_global_assignment -name VHDL_FILE ../src/calculator_pkg.vhd
	set_global_assignment -name VHDL_FILE ../src/communication.vhd
	set_global_assignment -name VHDL_FILE ../src/calculator.vhd
	set_global_assignment -name VHDL_FILE ../src/input.vhd

#	set_global_assignment -name VHDL_FILE ../src/vga_pll/vga_pll.cmp
#	set_global_assignment -name VHDL_FILE ../src/vga_pll/vga_pll.ppf
#	set_global_assignment -name VHDL_FILE ../src/vga_pll/vga_pll.qip
	set_global_assignment -name VHDL_FILE ../src/vga_pll/vga_pll.vhd
	set_global_assignment -name VHDL_FILE ../src/vga_pll/vga_pll_inst.vhd

	set_global_assignment -name USE_CONFIGURATION_DEVICE ON
	set_instance_assignment -name PARTITION_HIERARCHY root_partition -to | -section_id Top

	# pin assignments for calculator.

	set_location_assignment PIN_N3 -to clk_pin
	set_location_assignment PIN_AF17 -to reset_pin
    set_location_assignment PIN_A3 -to btn_a
    set_location_assignment PIN_A5 -to btn_b

    set_location_assignment PIN_E22 -to r0_pin
    set_location_assignment PIN_T4  -to r1_pin
    set_location_assignment PIN_T7  -to r2_pin
    set_location_assignment PIN_E23 -to g0_pin
    set_location_assignment PIN_T5  -to g1_pin
    set_location_assignment PIN_T24 -to g2_pin
    set_location_assignment PIN_E24 -to b0_pin
    set_location_assignment PIN_T6  -to b1_pin
    set_location_assignment PIN_F1  -to hsync_pin
    set_location_assignment PIN_F2  -to vsync_pin

	# END pin assignments for calculator.

	# Commit assignments
	export_assignments

	# Close project
	if {$need_to_close_project} {
		project_close
	}
}
