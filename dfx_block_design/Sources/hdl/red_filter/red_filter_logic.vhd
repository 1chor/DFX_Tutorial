library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity filter_logic is
  generic(
    -- Width of S_AXI data bus
    C_S_AXI_DATA_WIDTH	: integer	:= 32
  );
  port(
    clk 	    : in std_logic;
    rst         : in std_logic;
    regin   	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    regout   	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0)
  );
end filter_logic;

architecture IMP of filter_logic is
begin
  process (clk, rst)
  begin
	if rst = '1' then

		regout <= (others => '0');

	elsif rising_edge(clk) then
	
		regout(15 downto 0) <= (others => '0');
		regout(23 downto 16) <= regin(23 downto 16);
		regout(C_S_AXI_DATA_WIDTH-1 downto 24) <= (others => '0');
	end if;
  end process;
end IMP;
