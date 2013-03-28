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
		new_order		:	in	std_logic_vector (175 downto 0);	-- New order for comparison.
		book_order		:	in	std_logic_vector (175 downto 0); -- Order under test.
		address_final	:	out std_logic;						-- Outgoing flag to indicate address value is final.
		address			:	out	std_logic_vector (31 downto 0)	-- Outgoing address.
	);

end l3_add_lookup;


architecture rtl of l3_add_lookup is

constant l3_offset		: signed (31 downto 0) := (others => '0'); -- L3 memory offset address.
signal price_match		: std_logic;
signal calc_addr_final	: std_logic;
signal addr_count		: signed (31 downto 0);
signal new_order_addr	: signed (31 downto 0);

begin

address <= std_logic_vector(addr_count);

process (clk)
begin
if rising_edge(clk) then
if (reset = '1') then
	address_final <= '0';
	price_match <= '0';
	calc_addr_final <= '0';
	addr_count <= l3_offset;
	new_order_addr <= l3_offset;
else
if (add_enable = '1') then
	-- Initializations for the testing.
	price_match <= '0';
	calc_addr_final <= '0';
	addr_count <= l3_offset;
	new_order_addr <= l3_offset;

	if (calc_addr_final = '0') then	-- Begin iterations.
		address <= std_logic_vector(addr_count);
		if (price_match = '0') then									
			if (unsigned(book_order(135 downto 95)) = unsigned(new_order(135 downto 95))) then-- Does stock match?
				if (unsigned(book_order(175 downto 143)) = unsigned(new_order(175 downto 143))) then-- Does price match?
					price_match <= '1';	-- Flag to move to next FSM.
					addr_count <= addr_count + 1;	-- Increment the address to final value.
				else
					addr_count <= addr_count + 1;	-- Continue iterative testing.
				end if;
			else
				addr_count <= addr_count + 1;	-- Continue iterative testing.
			end if;
		else
			if ((book_order(175 downto 143) /= new_order(175 downto 143)) or (book_order(135 downto 95) /= new_order(135 downto 95))) then	-- Has the count exceeded the price level or the stock symbol changed?
				new_order_addr <= addr_count;	-- Set address count to final addr value.
				address <= std_logic_vector(new_order_addr);
				calc_addr_final <= '1';	-- Signal that look up is complete.
			else
				addr_count <= addr_count + 1;	-- If prices still match, continue count.
			end if;
		end if;
	end if;
end if;
end if;
end if;
end process;

end rtl;
