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
		reset			:	in	std_logic;
		clk				:	in	std_logic;
		add_enable		:	in	std_logic;
		new_order		:	in	std_logic_vector (21 downto 0);	-- New order for comparison.
		book_order		:	in	std_logic_vector (21 downto 0); -- Order under test.
		address_final	:	out std_logic;						-- Outgoing flag to indicate address value is final.
		address			:	out	std_logic_vector (31 downto 0)	-- Outgoing address.
	);

end l3_add_lookup;


architecture rtl of l3_add_lookup is

constant l3_offset		: integer := 0; -- L3 memory offset address.
signal price_match		: std_logic;
signal read_enable		: std_logic;
signal calc_addr_final	: std_logic := 0;
signal addr_count		: std_logic_vector (31 downto 0) := 0;
signal new_order_addr	: std_logic_vector (31 downto 0) := 0;

begin

address <= std_logic_vector(addr_count);

process (clk)
begin

	-- Initializations for the testing.
	read_enable <= '1';
	addr_count <= l3_offset;
	price_match <= '0'
	calc_addr_final <= '0';

	while (calc_addr_final = '0') loop	-- Begin iteration loop.
		if (price_match = '0')												
			if (unsigned(book_order(18 downto 13)) = unsigned(new_order(18 downto 13))) then	-- Does the stock symbol match?
				if (unsigned(book_order(22 downto 19)) = unsigned(new_order(22 downto 19))) then	-- Does the price match?
					price_match <= '1';	-- Flag to move to next FSM.
					addr_count++;	-- Increment the address to final value.
				else
					addr_count++;	-- Continue iterative testing.
				end if;
			else
				addr_count++;	-- Continue iterative testing.
			end if;
		else
			switch
			if (book_order(22 downto 19) != new_order(22 downto 19)) or (book_order(18 downto 13) != new_order(18 downto 13))) then	-- Has the count exceeded the price level or the stock symbol changed?
				new_order_addr <= addr_count;	-- Set address count to final addr value.
				calc_addr_final <= '1';	-- Signal that look up is complete.
			else
				addr_count++;	-- If prices still match, continue count.
			end if;
		end if;
	end loop;
end process;

end rtl;
