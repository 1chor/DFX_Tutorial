####################################################################################
#///////////////////////////////////////////////////////////////////////////////
#// Copyright (c) 2005-2016 Xilinx, Inc.
#// This design is confidential and proprietary of Xilinx, Inc.
#// All Rights Reserved.
#///////////////////////////////////////////////////////////////////////////////
#//		 __________    	___    ___ 	  ____                      ____
#//		|		   |   |   |  |   |	  \   \	       ____		   /   /
#//		|___    ___|   |   |  |   |	   \   \	  /    \	  /   /
#//			|  | 	   |   |  |   |	    \   \	 /      \    /   /
#//			|  | 	   |   |  |   |		 \	 \  /   __	 \  /   /
#//			|  | 	   |   |  |   |		  \   \/   /  \   \/   /
#//			|  | 	   |   |__|   |		   \	  /	   \	  /
#//			|  | 	   |          |		    \	 /	    \	 /
#//			|__| 	   |__________|			 \__/		 \__/
#//
#// Author: Andreas Dejmek
#// Vivado Version: 2020.2
#// Application: Dynamic Function eXchange
#// Filename: top_io.xdc
#// Date Last Modified: 03 JUN 2021
#// Device: Zynq UltraScale+ MPSoC ZCU102 Evaluation Kit
#// Design Name: led_shift_shift
#// Purpose: Dynamic Function eXchange Tutorial
#///////////////////////////////////////////////////////////////////////////////

###############################################################################
# User Time Names / User Time Groups / Time Specs
###############################################################################
create_clock -period 5.000 -name clk_p [get_ports clk_p]


#CLK_125MHZ_P - ZCU102 - G21/LVDS_25
set_property PACKAGE_PIN G21 [get_ports clk_p]
set_property IOSTANDARD LVDS_25 [get_ports clk_p]

#CLK_125MHZ_N - ZCU102 - F21/LVDS_25
set_property PACKAGE_PIN F21 [get_ports clk_n]
set_property IOSTANDARD LVDS_25 [get_ports clk_n]


#GPIO_SW_C (SW15) - ZCU102 - AG13/LVCMOS33
set_property PACKAGE_PIN AG13 [get_ports rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]


#GPIO_LED_0 - ZCU102 - AG14/LVCMOS33
set_property PACKAGE_PIN AG14 [get_ports {shift_low_out[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {shift_low_out[3]}]

#GPIO_LED_1 - ZCU102 - AF13/LVCMOS33
set_property PACKAGE_PIN AF13 [get_ports {shift_low_out[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {shift_low_out[2]}]

#GPIO_LED_2 - ZCU102 - AE13/LVCMOS33
set_property PACKAGE_PIN AE13 [get_ports {shift_low_out[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {shift_low_out[1]}]

#GPIO_LED_3 - ZCU102 - AJ14/LVCMOS33
set_property PACKAGE_PIN AJ14 [get_ports {shift_low_out[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {shift_low_out[0]}]

#GPIO_LED_4 - ZCU102 - AJ15/LVCMOS33
set_property PACKAGE_PIN AJ15 [get_ports {shift_high_out[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {shift_high_out[0]}]

#GPIO_LED_5 - ZCU102 - AH13/LVCMOS33
set_property PACKAGE_PIN AH13 [get_ports {shift_high_out[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {shift_high_out[1]}]

#GPIO_LED_6 - ZCU102 - AH14/LVCMOS33
set_property PACKAGE_PIN AH14 [get_ports {shift_high_out[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {shift_high_out[2]}]

#GPIO_LED_7 - ZCU102 - AL12/LVCMOS33
set_property PACKAGE_PIN AL12 [get_ports {shift_high_out[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {shift_high_out[3]}]

