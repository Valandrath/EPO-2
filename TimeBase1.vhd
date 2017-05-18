library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

--TIMEBASE
entity timebase is
	port (	clk		: in	std_logic;
		reset		: in	std_logic;

		count_out	: out	std_logic_vector (19 downto 0)
	);
end entity timebase;

architecture counter of timebase is

signal new_count1, count1 : unsigned(19 downto 0);

begin

	--counter component
	process(count1)
	begin
			new_count1 <= count1 + 1;
	end process;

	-- storage component
	process (clk)
	begin
		if (rising_edge (clk)) then
			if (reset = '1') then
				--Set the counter to 0 when the reset signal is high.
				count1 <= (others => '0');
			else 
				count1 <= new_count1;
			end if;
		end if;
	end process;

	count_out <= std_logic_vector(count1);

end architecture counter; 



	