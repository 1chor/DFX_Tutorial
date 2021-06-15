*************************************************************************
   ____  ____ 
  /   /\/   / 
 /___/  \  /   
 \   \   \/    © Copyright 2020 Xilinx, Inc. All rights reserved.
  \   \        This file contains confidential and proprietary 
  /   /        information of Xilinx, Inc. and is protected under U.S. 
 /___/   /\    and international copyright and other intellectual 
 \   \  /  \   property laws. 
  \___\/\___\ 
 
*************************************************************************
  __________     ___    ___ 	  ____                      ____
 | 		    |   |   |  |   |	  \   \	       ____		   /   /
 |___    ___|   |   |  |   |	   \   \	  /    \	  /   /
	 |  | 	    |   |  |   |	    \   \	 /      \    /   /
	 |  | 	    |   |  |   |		 \	 \  /   __	 \  /   /
	 |  | 	    |   |  |   |		  \   \/   /  \   \/   /
	 |  | 	    |   |__|   |		   \	  /	   \	  /
	 |  | 	    |          |		    \	 /	    \	 /
 	 |__| 	    |__________|			 \__/		 \__/
  
This Tutorial was adapted by Andreas Dejmek.

*************************************************************************

Vendor: Xilinx 
Current readme.txt Version: 1.0
Date Last Modified:  15 JUN 2021
Date Created: 15 JUN 2021

Associated Filename: UG947
Associated Document: Dynamic Function eXchange Tutorial for Vivado

Supported Device(s): ZCU102
Target Devices as delivered: xczu9eg-ffvb1156-2-e

   
*************************************************************************

Disclaimer: 

      This disclaimer is not a license and does not grant any rights to 
      the materials distributed herewith. Except as otherwise provided in 
      a valid license issued to you by Xilinx, and to the maximum extent 
      permitted by applicable law: (1) THESE MATERIALS ARE MADE AVAILABLE 
      "AS IS" AND WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL 
      WARRANTIES AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, 
      INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, 
      NON-INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and 
      (2) Xilinx shall not be liable (whether in contract or tort, 
      including negligence, or under any other theory of liability) for 
      any loss or damage of any kind or nature related to, arising under 
      or in connection with these materials, including for any direct, or 
      any indirect, special, incidental, or consequential loss or damage 
      (including loss of data, profits, goodwill, or any type of loss or 
      damage suffered as a result of any action brought by a third party) 
      even if such damage or loss was reasonably foreseeable or Xilinx 
      had been advised of the possibility of the same.

Critical Applications:

      Xilinx products are not designed or intended to be fail-safe, or 
      for use in any application requiring fail-safe performance, such as 
      life-support or safety devices or systems, Class III medical 
      devices, nuclear facilities, applications related to the deployment 
      of airbags, or any other applications that could lead to death, 
      personal injury, or severe property or environmental damage 
      (individually and collectively, "Critical Applications"). Customer 
      assumes the sole risk and liability of any use of Xilinx products 
      in Critical Applications, subject only to applicable laws and 
      regulations governing limitations on product liability.

THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS 
FILE AT ALL TIMES.

*************************************************************************

This readme file contains these sections:

1. REVISION HISTORY
2. OVERVIEW
3. SOFTWARE TOOLS AND SYSTEM REQUIREMENTS
4. DESIGN FILE HIERARCHY
5. INSTALLATION AND OPERATING INSTRUCTIONS
6. OTHER INFORMATION (OPTIONAL)
7. SUPPORT


1. REVISION HISTORY 

            Readme  
Date        Version      Revision Description
=========================================================================
15JUN2021	1.0	Initial Tutorial release (Xilinx Version: 1.41)
=========================================================================


2. OVERVIEW

This readme describes how to use the files that come with this tutorial.

This design targets only the XIlinx ZCU102 Evaluation Kit and is used to 
highlight the project-based software flow for Dynamic Function eXchange.  


3. SOFTWARE TOOLS AND SYSTEM REQUIREMENTS

This tutorial requires Xilinx Vivado 2020.2 or newer. 


4. DESIGN FILE HIERARCHY

The directory structure underneath this top-level folder is described below:

\Sources
 |
 +-----  \hdl
 |       Verilog source code is located within these folders.  There are folders
 |       for static logic (top) and each reconfigurable module variant
 |    
 |           +--\shift_left
 |           +--\shift_left_slow
 |           +--\shift_right
 |           +--\shift_right_slow
 |           +--\top
 |
 +-----  \xdc 
 |        This folder contains the design constraint files.
 |           top_io.xdc contains pinout and clocking constraints


5. INSTALLATION AND OPERATING INSTRUCTIONS 

Follow the instructions provided in Lab 1 to run the tutorial.

This lab steps through the project support within the Vivado IDE.  There is no
automation within this lab.  Select the appropriate constraint file(s) to target one
of the listed supported boards.


6. OTHER INFORMATION 

For more information on Dynamic Function eXchange in Vivado, please consult UG909.


7. SUPPORT

To obtain technical support for this reference design, go to 
www.xilinx.com/support to locate answers to known issues in the Xilinx
Answers Database or to create a WebCase.  
