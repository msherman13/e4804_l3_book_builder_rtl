-------------------------------------------------------------------------------
--
-- Module:		order_ref_num_cam
-- Description:	CAM for address determination based on order reference number.
--
-- Author:		Miles Sherman
-- Contact:		ms4543@columbia.edu
--
-- Last Update: 03/29/2013
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity order_ref_num_cam is
	generic (cam_width : positive := 65);
	port( 
		clk				: in std_logic;
		reset			: in std_logic;
		cam_enable		: in std_logic;
		search_enable	: in std_logic;
		order_disable	: in std_logic;
		order_num		: in std_logic_vector (cam_width-2 downto 0);
		cam_addr_in	: in std_logic_vector (15 downto 0);
		l3_offset		: in std_logic_vector (15 downto 0);
		addr_valid		: out std_logic;
		cam_address 	: out std_logic_vector (15 downto 0);
		address			: out std_logic_vector (15 downto 0)
		);
end entity order_ref_num_cam;

architecture rtl of order_ref_num_cam is

	type cam_type is array (0 to 16383) of std_logic_vector (cam_width-1 downto 0);
	signal cam			: cam_type;
	signal i			: integer;
	signal cam_match	: std_logic;
	signal temp			: unsigned (15 downto 0);
	signal temp2		: unsigned (15 downto 0);
	signal temp3		: unsigned (15 downto 0);
	signal temp4		: integer;
	--SIGNAL top : natural;

begin

	process (clk) 
	begin
		if (reset = '1') then
			cam_match <= '0';
			address <= (others => '0');
			cam_address <= (others => '0');
			addr_valid <= '0';
		else
			if (cam_enable = '1') then
				if (search_enable = '1') then -- Search mode
					cam_match <= '0';
					addr_valid <= '0';
					while (cam_match <= '0') loop
						if (order_num = cam(i)(cam_width-2 downto 0) and cam(i)(cam_width-1) = '1') then
							cam_match <= '1';
							temp <= to_unsigned(i, cam_address'length);
							cam_address <= std_logic_vector(temp);
						else
							i <= i + 1;
						end if;
					end loop;
					temp2 <= temp + unsigned(l3_offset);
					address <= std_logic_vector (temp2);
					addr_valid <= '1';
				else -- Add a new entry, either order number or an address deactivation.
					if (order_disable = '0') then
						temp3 <= unsigned(cam_addr_in);
						temp4 <= to_integer(temp3);
						cam(temp4) <= order_num;
					else
						temp3 <= unsigned(cam_addr_in);
						temp4 <= to_integer(temp3);
						cam(temp4)(cam_width-1) <= '0';
					end if;
				end if;
			end if;
		end if;
	end process;
end rtl;
