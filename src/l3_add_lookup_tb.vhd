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
		new_order		:	in	std_logic_vector (175 downto 0);	-- New order for comparison.
		book_order		:	in	std_logic_vector (175 downto 0); -- Order under test.
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
L1: lab1 port map (
			clk => clk,
			key => key,
			hex0 => hex0,
			hex1 => hex1,
			hex2 => hex2		
		);
		
-- clock process definition

clk <= not clk after 20 ns;

process
begin
	-- increment address
	wait for 20 ms;
	key <= "1101";
	wait for 5 ms;
	key <= "1111";
	-- decrement address
	wait for 10 ms;
	key <= "0111";
	wait for 5 ms;
	key <= "1111";
	-- increment data
	wait for 10 ms;
	key <= "1110";
	wait for 5 ms;
	key <= "1111";
	-- decrement data
	wait for 10 ms;
	key <= "1011";
	wait for 5 ms;
	key <= "1111";
   -- key bouncing start
	wait for 20 ms;
	key <= "1110";
	wait for 10 ms;
	key <= "1111";	
	wait for 100 ns;
	key <= "1110";
	wait for 100 ns;
	key <= "1111";
	wait for 100 ns;
	key <= "1110";
	wait for 100 ns;
	key <= "1111";
	-- key bounding end
	-- several keys pressed
	wait for 20 ms;
	key <= "0101";
	wait for 5 ms;
	key <= "1111";
	wait for 5 ms;
	key <= "1000";
	wait for 5 ms;
	key <= "1101";
	wait for 5 ms;
	key <= "1111";
	-- final tests
	wait for 20 ms;
	key <= "1101";
	wait for 1 ms;
	key <= "1110";
	wait for 1 ms;
	key <= "1101";
	wait for 1 ms;
	key <= "1111";
	wait;
end process;

end;


