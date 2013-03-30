library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity l2_add_lookup_tb is
end l2_add_lookup_tb;

architecture behavior of l2_add_lookup_tb is

component l3_add_lookup
	port (
		reset			:	in	std_logic;
		clk				:	in	std_logic;
		add_enable		:	in	std_logic;
		new_order		:	in	std_logic_vector (183 downto 0);	-- New order for comparison.
		book_order		:	in	std_logic_vector (183 downto 0); -- Order under test.
		address_final	:	out std_logic;						-- Outgoing flag to indicate address value is final.
		address			:	out	std_logic_vector (31 downto 0)	-- Outgoing address.
	);
end component;

-- inputs
signal clk				: std_logic := '0';
signal reset			: std_logic := '0';
signal add_enable		: std_logic := '1';
signal new_order		: std_logic_vector := (others => '0');
signal book_order		: std_logic_vector := (others => '0');

-- outputs
signal address_final	: std_logic_vector := (others => '0');
signal address			: std_logic_vector := (others => '0');

-- clock period definitions
constant clk_period : time := 20 ns;

begin
-- instantiate unit under test (uut)
l3add: l3_add_lookup port map (
			reset => reset,
			clk => clk,
			add_enable => add_enable,
			new_order => new_order,
			book_order => book_order,
			address_final => address_final,
			address => address		
		);
		
-- clock process definition
clk <= not clk after 1 ns;

process
begin
	-- increment address
	wait for 5 ns;
	new_order <= "10101010101010101010101010101010101010101010101010101010101010101010101010101010" & (101 downto 0 => '0');
	wait for 5 ms;
	key <= "1111";
	-- decrement address
	wait for 10 ms;
	key <= "0111";
	wait for 5 ms;
	key <= "1111";
end process;

end;


