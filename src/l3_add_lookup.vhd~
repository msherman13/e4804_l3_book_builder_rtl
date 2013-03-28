-------------------------------------------------------------------------------
--
-- Module:		l3_add_lookup
-- Description:	Algorithm to lookup address for new order addition in L3 book.
--
-- Author:		Miles Sherman
-- Contact:		ms4543@columbia.edu
--
-- Last Update: 03/28/2013
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity l3_add_lookup is
	port (
		reset		:	in	std_logic;
		clk			:	in	std_logic;
		new_order	:	in	std_logic_vector (21 downto 0); -- New order for comparison.
		book_order	:	in	std_logic_vector (21 downto 0); -- Order under test.
		address		:	out	std_logic_vector (31 downto 0) -- Outgoing address.
	);

end l3_add_lookup;


architecture rtl of l3_add_lookup is
  
constant CIRCLE_RADIUS : integer := 25;

signal clk25 : std_logic;

begin

process (clk)
begin

end process;
end rtl;
