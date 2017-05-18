library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity motorcontrol is
	port (	clk		: in	std_logic;
		reset		: in	std_logic;
		direction	: in	std_logic;
		count_in	: in	std_logic_vector (19 downto 0);

		pwm		: out	std_logic
	);
end entity motorcontrol;

architecture behavioural of motorcontrol is

	type 	motor_controller_state is	(	reset_state,
							pwm_high,
							pwm_low);

	signal	state, new_state:	motor_controller_state;

begin

	process(clk)
	begin
		if(rising_edge (clk)) then
			if (reset = '1') then --reset when the reset signal is high.
				state <= reset_state;
			else 
				state <= new_state;
			end if;
		end if;
	end process;

	process (reset,count_in)
	begin
		case state is
			
			when reset_state =>
				pwm <= '0';
				new_state <= pwm_high;

			when pwm_high =>
				pwm <= '1';
				--set the pwm to low when the direction is '0' and 1 ms has passed.
				if(direction = '0' and unsigned(count_in) >= 50000) then
					new_state <= pwm_low;
				--set the pwm to low when the direction is '1' and 2 ms have passed.
				elsif(direction = '1' and unsigned(count_in) >= 100000) then
					new_state <= pwm_low;
				else 
					new_state <= pwm_high;
				end if;
				
			--stay in the low state untill a reset is called.
			when pwm_low =>
				pwm <= '0';
				new_state <= pwm_low;

		end case;
	end process;
end architecture behavioural;


