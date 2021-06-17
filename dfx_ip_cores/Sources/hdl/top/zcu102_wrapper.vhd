--Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2018.1 (lin64) Build 2188600 Wed Apr  4 18:39:19 MDT 2018
--Date        : Tue Sep 29 14:22:07 2020
--Host        : soc running 64-bit Ubuntu 18.04.5 LTS
--Command     : generate_target zcu102_wrapper.bd
--Design      : zcu102_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

------------------------------------------------------------------------------
-- Entity section
------------------------------------------------------------------------------

entity zcu102_wrapper is
  port (
    LED : out STD_LOGIC_VECTOR ( 7 downto 0 );
    reset : in STD_LOGIC
  );
end zcu102_wrapper;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture STRUCTURE of zcu102_wrapper is

  ------------------------------------------
  -- declare block diagram instance
  ------------------------------------------
  
  component zcu102 is
  port (
    LED : out STD_LOGIC_VECTOR ( 7 downto 0 );
    reset : in STD_LOGIC;
    -- S_AXI clock and reset
    s_axi_aclk : out STD_LOGIC;
    peripheral_aresetn : out STD_LOGIC_VECTOR ( 0 to 0 );
    -- S_AXI interface for Fourier transform (exported signals)
    M07_AXI_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M07_AXI_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M07_AXI_awvalid : out STD_LOGIC;
    M07_AXI_awready : in STD_LOGIC;
    M07_AXI_wdata : out STD_LOGIC_VECTOR ( 63 downto 0 );
    M07_AXI_wstrb : out STD_LOGIC_VECTOR ( 7 downto 0 );
    M07_AXI_wvalid : out STD_LOGIC;
    M07_AXI_wready : in STD_LOGIC;
    M07_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M07_AXI_bvalid : in STD_LOGIC;
    M07_AXI_bready : out STD_LOGIC;
    M07_AXI_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M07_AXI_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M07_AXI_arvalid : out STD_LOGIC;
    M07_AXI_arready : in STD_LOGIC;
    M07_AXI_rdata : in STD_LOGIC_VECTOR ( 63 downto 0 );
    M07_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M07_AXI_rvalid : in STD_LOGIC;
    M07_AXI_rready : out STD_LOGIC
  );
  end component zcu102;
  
  ------------------------------------------
  -- declare fourier transform instance
  ------------------------------------------
  
  -- User needs to copy the PR partition declaration
  component fourier_transform_v1_0 is
  generic (
	-- Users to add parameters here
	-- User parameters ends
	-- Do not modify the parameters beyond this line
	-- Parameters of Axi Slave Bus Interface S00_AXI
	C_S00_AXI_DATA_WIDTH	: integer	:= 64;
	C_S00_AXI_ADDR_WIDTH	: integer	:= 1
  );
  port (
	-- Users to add ports here
	-- User ports ends
	-- Do not modify the ports beyond this line
	-- Ports of Axi Slave Bus Interface S00_AXI
	s00_axi_aclk	: in std_logic;
	s00_axi_aresetn	: in std_logic;
	s00_axi_awaddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
	s00_axi_awprot	: in std_logic_vector(2 downto 0);
	s00_axi_awvalid	: in std_logic;
	s00_axi_awready	: out std_logic;
	s00_axi_wdata	: in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
	s00_axi_wstrb	: in std_logic_vector((C_S00_AXI_DATA_WIDTH/8)-1 downto 0);
	s00_axi_wvalid	: in std_logic;
	s00_axi_wready	: out std_logic;
	s00_axi_bresp	: out std_logic_vector(1 downto 0);
	s00_axi_bvalid	: out std_logic;
	s00_axi_bready	: in std_logic;
	s00_axi_araddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
	s00_axi_arprot	: in std_logic_vector(2 downto 0);
	s00_axi_arvalid	: in std_logic;
	s00_axi_arready	: out std_logic;
	s00_axi_rdata	: out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
	s00_axi_rresp	: out std_logic_vector(1 downto 0);
	s00_axi_rvalid	: out std_logic;
    s00_axi_rready	: in std_logic
  );
  end component fourier_transform_v1_0;

  ------------------------------------------
  -- external signal declarations
  ------------------------------------------
  --NONE  
   
  ------------------------------------------
  -- fourier transform signal declarations
  ------------------------------------------
  
  -- User needs to define signal declarations for the PR partition
  signal s_axi_aclk : STD_LOGIC;
  signal peripheral_aresetn : STD_LOGIC_VECTOR ( 0 to 0 );
  -- S_AXI interface
  signal M07_AXI_awaddr : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal M07_AXI_awprot : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal M07_AXI_awvalid : STD_LOGIC;
  signal M07_AXI_awready : STD_LOGIC;
  signal M07_AXI_wdata : STD_LOGIC_VECTOR ( 63 downto 0 );
  signal M07_AXI_wstrb : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal M07_AXI_wvalid : STD_LOGIC;
  signal M07_AXI_wready : STD_LOGIC;
  signal M07_AXI_bresp : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal M07_AXI_bvalid : STD_LOGIC;
  signal M07_AXI_bready : STD_LOGIC;
  signal M07_AXI_araddr : STD_LOGIC_VECTOR ( 39 downto 0 );
  signal M07_AXI_arprot : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal M07_AXI_arvalid : STD_LOGIC;
  signal M07_AXI_arready : STD_LOGIC;
  signal M07_AXI_rdata : STD_LOGIC_VECTOR ( 63 downto 0 );
  signal M07_AXI_rresp : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal M07_AXI_rvalid : STD_LOGIC;
  signal M07_AXI_rready : STD_LOGIC;    
        
begin

  ------------------------------------------
  -- instantiate block diagram instance
  ------------------------------------------

  zcu102_i: component zcu102
    port map (
      LED(7 downto 0) => LED(7 downto 0),
      M07_AXI_araddr(39 downto 0) => M07_AXI_araddr(39 downto 0),
      M07_AXI_arprot(2 downto 0) => M07_AXI_arprot(2 downto 0),
      M07_AXI_arready => M07_AXI_arready,
      M07_AXI_arvalid => M07_AXI_arvalid,
      M07_AXI_awaddr(39 downto 0) => M07_AXI_awaddr(39 downto 0),
      M07_AXI_awprot(2 downto 0) => M07_AXI_awprot(2 downto 0),
      M07_AXI_awready => M07_AXI_awready,
      M07_AXI_awvalid => M07_AXI_awvalid,
      M07_AXI_bready => M07_AXI_bready,
      M07_AXI_bresp(1 downto 0) => M07_AXI_bresp(1 downto 0),
      M07_AXI_bvalid => M07_AXI_bvalid,
      M07_AXI_rdata(63 downto 0) => M07_AXI_rdata(63 downto 0),
      M07_AXI_rready => M07_AXI_rready,
      M07_AXI_rresp(1 downto 0) => M07_AXI_rresp(1 downto 0),
      M07_AXI_rvalid => M07_AXI_rvalid,
      M07_AXI_wdata(63 downto 0) => M07_AXI_wdata(63 downto 0),
      M07_AXI_wready => M07_AXI_wready,
      M07_AXI_wstrb(7 downto 0) => M07_AXI_wstrb(7 downto 0),
      M07_AXI_wvalid => M07_AXI_wvalid,      
      peripheral_aresetn(0) => peripheral_aresetn(0),
      reset => reset,
      s_axi_aclk => s_axi_aclk
    );
    
  ------------------------------------------
  -- instantiate fourier transform instance
  ------------------------------------------
    
  -- User needs to instantiate the PR partition
  fourier_transform_0: component fourier_transform_v1_0
    generic map(	  
	  C_S00_AXI_DATA_WIDTH => 64,
	  C_S00_AXI_ADDR_WIDTH => 1
	)
	port map (
	  s00_axi_aclk => s_axi_aclk,
	  s00_axi_aresetn => peripheral_aresetn(0),
	  s00_axi_awaddr => M07_AXI_awaddr(0 downto 0),
	  s00_axi_awprot => M07_AXI_awprot(2 downto 0),
	  s00_axi_awvalid => M07_AXI_awvalid,
	  s00_axi_awready => M07_AXI_awready,
	  s00_axi_wdata => M07_AXI_wdata(63 downto 0),
	  s00_axi_wstrb => M07_AXI_wstrb(7 downto 0),
	  s00_axi_wvalid => M07_AXI_wvalid,
	  s00_axi_wready => M07_AXI_wready,
	  s00_axi_bresp => M07_AXI_bresp(1 downto 0),
	  s00_axi_bvalid => M07_AXI_bvalid,
	  s00_axi_bready => M07_AXI_bready,
	  s00_axi_araddr => M07_AXI_araddr(0 downto 0),
	  s00_axi_arprot => M07_AXI_arprot(2 downto 0),
	  s00_axi_arvalid => M07_AXI_arvalid,
	  s00_axi_arready => M07_AXI_arready,
	  s00_axi_rdata => M07_AXI_rdata(63 downto 0),
	  s00_axi_rresp => M07_AXI_rresp(1 downto 0),
	  s00_axi_rvalid => M07_AXI_rvalid,
	  s00_axi_rready => M07_AXI_rready
	);
		
end STRUCTURE;
