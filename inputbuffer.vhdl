library IEEE;
use IEEE.std_logic_1164.all;

entity register_3 is
	port (	clk			: in	std_logic;

		sensor_l_buffer_in	: in	std_logic;
		sensor_m_buffer_in	: in	std_logic;
		sensor_r_buffer_in	: in	std_logic;

		sensor_l_buffer_out	: out	std_logic;
		sensor_m_buffer_out	: out	std_logic;
		sensor_r_buffer_out	: out	std_logic
	);
end entity register_3;

architecture memory of register_3 is
begin
	process (clk)
	begin
		if (rising_edge (clk)) then
			sensor_l_buffer_out <= sensor_l_buffer_in;
			sensor_m_buffer_out <= sensor_m_buffer_in;
			sensor_r_buffer_out <= sensor_r_buffer_in;					
		end if;
	end process;

end architecture memory;

library IEEE;
use IEEE.std_logic_1164.all;

entity inputbuffer is
	port (	clk		: in	std_logic;

		sensor_l_in	: in	std_logic;
		sensor_m_in	: in	std_logic;
		sensor_r_in	: in	std_logic;

		sensor_l_out	: out	std_logic;
		sensor_m_out	: out	std_logic;
		sensor_r_out	: out	std_logic
	);
end entity inputbuffer;

architecture structural of inputbuffer is

component register_3 is
	port (	clk			: in	std_logic;

		sensor_l_buffer_in	: in	std_logic;
		sensor_m_buffer_in	: in	std_logic;
		sensor_r_buffer_in	: in	std_logic;

		sensor_l_buffer_out	: out	std_logic;
		sensor_m_buffer_out	: out	std_logic;
		sensor_r_buffer_out	: out	std_logic
		);
end component register_3;

signal l1, m1, r1 : std_logic;

begin 
	
	rg1: register_3 port map (	clk => clk, 
					sensor_l_buffer_in => sensor_l_in,
					sensor_m_buffer_in => sensor_m_in,
					sensor_r_buffer_in => sensor_r_in,
					sensor_l_buffer_out => l1,
					sensor_m_buffer_out => m1,
					sensor_r_buffer_out => r1
				); 
	rg2: register_3 port map (	clk => clk, 
					sensor_l_buffer_in => l1,
					sensor_m_buffer_in => m1,
					sensor_r_buffer_in => r1,
					sensor_l_buffer_out => sensor_l_out,
					sensor_m_buffer_out => sensor_m_out,
					sensor_r_buffer_out => sensor_r_out
				); 

end architecture structural;