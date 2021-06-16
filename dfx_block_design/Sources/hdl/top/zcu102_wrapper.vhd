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
    -- S_AXI interface for simple_filter (exported signals)
    s_axi_aclk : out STD_LOGIC;
    peripheral_aresetn : out STD_LOGIC_VECTOR ( 0 to 0 );
    M05_AXI_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M05_AXI_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M05_AXI_awvalid : out STD_LOGIC;
    M05_AXI_awready : in STD_LOGIC;
    M05_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M05_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M05_AXI_wvalid : out STD_LOGIC;
    M05_AXI_wready : in STD_LOGIC;
    M05_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M05_AXI_bvalid : in STD_LOGIC;
    M05_AXI_bready : out STD_LOGIC;
    M05_AXI_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M05_AXI_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M05_AXI_arvalid : out STD_LOGIC;
    M05_AXI_arready : in STD_LOGIC;
    M05_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M05_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M05_AXI_rvalid : in STD_LOGIC;
    M05_AXI_rready : out STD_LOGIC
  );
  end component zcu102;
  
  ------------------------------------------
  -- declare simple_filter instance
  ------------------------------------------
  
  -- User needs to copy the PR partition declaration
  component simple_filter is
  generic
  (
    -- ADD USER GENERICS BELOW THIS LINE ---------------
    --USER generics added here
    -- ADD USER GENERICS ABOVE THIS LINE ---------------
  
    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol parameters, do not add to or delete
    C_S_AXI_DATA_WIDTH             : integer              := 32;
    C_S_AXI_ADDR_WIDTH             : integer              := 32;
    C_S_AXI_MIN_SIZE               : std_logic_vector     := X"000001FF";
    C_USE_WSTRB                    : integer              := 0;
    C_DPHASE_TIMEOUT               : integer              := 8;
    C_BASEADDR                     : std_logic_vector     := X"98000000";
    C_HIGHADDR                     : std_logic_vector     := X"9800FFFF";
    C_FAMILY                       : string               := "virtex6";
    C_NUM_REG                      : integer              := 1;
    C_NUM_MEM                      : integer              := 1;
    C_SLV_AWIDTH                   : integer              := 32;
    C_SLV_DWIDTH                   : integer              := 32
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );
  port
  (
    -- ADD USER PORTS BELOW THIS LINE ------------------
    --USER ports added here
    -- ADD USER PORTS ABOVE THIS LINE ------------------
    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol ports, do not add to or delete
    S_AXI_ACLK                     : in  std_logic;
    S_AXI_ARESETN                  : in  std_logic;
    S_AXI_AWADDR                   : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    S_AXI_AWVALID                  : in  std_logic;
    S_AXI_WDATA                    : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    S_AXI_WSTRB                    : in  std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
    S_AXI_WVALID                   : in  std_logic;
    S_AXI_BREADY                   : in  std_logic;
    S_AXI_ARADDR                   : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    S_AXI_ARVALID                  : in  std_logic;
    S_AXI_RREADY                   : in  std_logic;
    S_AXI_ARREADY                  : out std_logic;
    S_AXI_RDATA                    : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    S_AXI_RRESP                    : out std_logic_vector(1 downto 0);
    S_AXI_RVALID                   : out std_logic;
    S_AXI_WREADY                   : out std_logic;
    S_AXI_BRESP                    : out std_logic_vector(1 downto 0);
    S_AXI_BVALID                   : out std_logic;
    S_AXI_AWREADY                  : out std_logic
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );
  end component simple_filter;
  
  ------------------------------------------
  -- external signal declarations
  ------------------------------------------
  -- NONE  
  
  ------------------------------------------
  -- simple_filter signal declarations
  ------------------------------------------
  
  -- User needs to define signal declarations for the PR partition
  signal s_axi_aclk : STD_LOGIC;
  signal peripheral_aresetn : STD_LOGIC_VECTOR ( 0 to 0 );
  -- S_AXI interface
  signal M05_AXI_awaddr : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal M05_AXI_awprot : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal M05_AXI_awvalid : STD_LOGIC;
  signal M05_AXI_awready : STD_LOGIC;
  signal M05_AXI_wdata : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal M05_AXI_wstrb : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal M05_AXI_wvalid : STD_LOGIC;
  signal M05_AXI_wready : STD_LOGIC;
  signal M05_AXI_bresp : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal M05_AXI_bvalid : STD_LOGIC;
  signal M05_AXI_bready : STD_LOGIC;
  signal M05_AXI_araddr : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal M05_AXI_arprot : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal M05_AXI_arvalid : STD_LOGIC;
  signal M05_AXI_arready : STD_LOGIC;
  signal M05_AXI_rdata : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal M05_AXI_rresp : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal M05_AXI_rvalid : STD_LOGIC;
  signal M05_AXI_rready : STD_LOGIC;

begin

  ------------------------------------------
  -- instantiate block diagram instance
  ------------------------------------------

  zcu102_i: component zcu102
    port map (
      LED(7 downto 0) => LED(7 downto 0),
      M05_AXI_araddr(31 downto 0) => M05_AXI_araddr(31 downto 0),
      M05_AXI_arprot(2 downto 0) => M05_AXI_arprot(2 downto 0),
      M05_AXI_arready => M05_AXI_arready,
      M05_AXI_arvalid => M05_AXI_arvalid,
      M05_AXI_awaddr(31 downto 0) => M05_AXI_awaddr(31 downto 0),
      M05_AXI_awprot(2 downto 0) => M05_AXI_awprot(2 downto 0),
      M05_AXI_awready => M05_AXI_awready,
      M05_AXI_awvalid => M05_AXI_awvalid,
      M05_AXI_bready => M05_AXI_bready,
      M05_AXI_bresp(1 downto 0) => M05_AXI_bresp(1 downto 0),
      M05_AXI_bvalid => M05_AXI_bvalid,
      M05_AXI_rdata(31 downto 0) => M05_AXI_rdata(31 downto 0),
      M05_AXI_rready => M05_AXI_rready,
      M05_AXI_rresp(1 downto 0) => M05_AXI_rresp(1 downto 0),
      M05_AXI_rvalid => M05_AXI_rvalid,
      M05_AXI_wdata(31 downto 0) => M05_AXI_wdata(31 downto 0),
      M05_AXI_wready => M05_AXI_wready,
      M05_AXI_wstrb(3 downto 0) => M05_AXI_wstrb(3 downto 0),
      M05_AXI_wvalid => M05_AXI_wvalid,
      peripheral_aresetn(0) => peripheral_aresetn(0),
      reset => reset,
      s_axi_aclk => s_axi_aclk
    );
    
  ------------------------------------------
  -- instantiate simple_filter instance
  ------------------------------------------
  
  -- User needs to instantiate the PR partition
  simple_filter_0: component simple_filter
    generic map (
      C_S_AXI_DATA_WIDTH => 32,
      C_S_AXI_ADDR_WIDTH => 32,
      C_S_AXI_MIN_SIZE => X"000001FF",
      C_USE_WSTRB => 0,
      C_DPHASE_TIMEOUT => 8,
      C_BASEADDR => X"98000000",
      C_HIGHADDR => X"9800FFFF",
      C_FAMILY => "virtex6",
      C_NUM_REG => 1,
      C_NUM_MEM => 1,
      C_SLV_AWIDTH => 32,
      C_SLV_DWIDTH => 32
    )
    port map (
      S_AXI_ACLK => s_axi_aclk,
      S_AXI_ARESETN => peripheral_aresetn(0),
      S_AXI_AWADDR(31 downto 0) => M05_AXI_awaddr(31 downto 0),
      S_AXI_AWVALID => M05_AXI_awvalid,
      S_AXI_WDATA(31 downto 0) => M05_AXI_wdata(31 downto 0),
      S_AXI_WSTRB(3 downto 0) => M05_AXI_wstrb(3 downto 0),
      S_AXI_WVALID => M05_AXI_wvalid,
      S_AXI_BREADY => M05_AXI_bready, 
      S_AXI_ARADDR(31 downto 0) => M05_AXI_araddr(31 downto 0),                   
      S_AXI_ARVALID => M05_AXI_arvalid,                 
      S_AXI_RREADY => M05_AXI_rready,                  
      S_AXI_ARREADY => M05_AXI_arready,                 
      S_AXI_RDATA(31 downto 0) => M05_AXI_rdata(31 downto 0),                   
      S_AXI_RRESP(1 downto 0) => M05_AXI_rresp(1 downto 0),                    
      S_AXI_RVALID => M05_AXI_rvalid,            
      S_AXI_WREADY => M05_AXI_wready,               
      S_AXI_BRESP(1 downto 0) => M05_AXI_bresp(1 downto 0),                    
      S_AXI_BVALID => M05_AXI_bvalid,                  
      S_AXI_AWREADY => M05_AXI_awready
    );
 
end STRUCTURE;
