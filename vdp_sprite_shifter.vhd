library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity vpd_sprite_shifter is
Port(
	clk_sys:in  STD_LOGIC;
	ce_pix: in  STD_LOGIC;
	x		: in  std_logic_vector (7 downto 0);
	spr_x	: in  std_logic_vector (7 downto 0);
	load  : in  boolean;
	x248  : in  boolean; -- idem load but for shifted sprites
	wide_n: in  boolean; -- if sprites are wide reg1 bit 0
	spr_d0: in  std_logic_vector (7 downto 0);
	spr_d1: in  std_logic_vector (7 downto 0);
	spr_d2: in  std_logic_vector (7 downto 0);
	spr_d3: in  std_logic_vector (7 downto 0);
	color : out std_logic_vector (3 downto 0);
	active: out std_logic
);
end vpd_sprite_shifter;

architecture Behavioral of vpd_sprite_shifter is
   signal wideclock : boolean := false ;
	signal shift0	: std_logic_vector (7 downto 0) := (others=>'0');
	signal shift1	: std_logic_vector (7 downto 0) := (others=>'0');
	signal shift2	: std_logic_vector (7 downto 0) := (others=>'0');
	signal shift3	: std_logic_vector (7 downto 0) := (others=>'0');

begin

	process (clk_sys)	begin
		if rising_edge(clk_sys) then
			if ce_pix = '1' then
				if (spr_x=x and load) or (spr_x=x+8 and x248) then
					shift0 <= spr_d0;
					shift1 <= spr_d1;
					shift2 <= spr_d2;
					shift3 <= spr_d3;
					wideclock <= false ;
				else
					if (wide_n or wideclock) then
						shift0 <= shift0(6 downto 0)&"0";
						shift1 <= shift1(6 downto 0)&"0";
						shift2 <= shift2(6 downto 0)&"0";
						shift3 <= shift3(6 downto 0)&"0";
					end if ;
					wideclock <= not wideclock ;
				end if;
			end if;
		end if;
	end process;
	
	color <= shift3(7)&shift2(7)&shift1(7)&shift0(7);
	active <= shift3(7) or shift2(7) or shift1(7) or shift0(7);
	
end Behavioral;

