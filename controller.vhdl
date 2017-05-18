library IEEE;
use IEEE.std_logic_1164.all;


entity controller is
	port (	clk			: in	std_logic;
		reset			: in	std_logic;

		sensor_l		: in	std_logic;
		sensor_m		: in	std_logic;
		sensor_r		: in	std_logic;

		count_in		: in	std_logic_vector (19 downto 0);
		count_reset		: out	std_logic;

		motor_l_reset		: out	std_logic;
		motor_l_direction	: out	std_logic;

		motor_r_reset		: out	std_logic;
		motor_r_direction	: out	std_logic
	);
end entity controller;

architecture control of controller is

	type control_state is	(	reset_state,
					state0,
					state1,
					state2,
					state3,
					state4,
					state5,
					state6,
					state7
				);

	signal state, next_state:	control_state;

begin

	process(clk)
	begin
		if(rising_edge (clk)) then
			if (reset = '1' or count_in >= "11110100001001000000") then
				state <= reset_state;
			else 
				state <= next_state;
			end if;
		end if;
	end process;

	process(reset,count_in,sensor_l,sensor_m,sensor_r,state)
	begin
		case state is
			
			when reset_state =>
				motor_l_direction 	<= '1';
				motor_r_direction 	<= '1';
				motor_l_reset 		<= '1';
				motor_r_reset		<= '1';
				count_reset		<= '1';

				--select next state

				--state 0
				if(sensor_l = '0' and sensor_m = '0' and sensor_r = '0') then
					next_state <= state0;
				--state 1
				elsif(sensor_l = '0' and sensor_m = '0' and sensor_r = '1') then
					next_state <= state1;
				--state 2
				elsif(sensor_l = '0' and sensor_m = '1' and sensor_r = '0') then
					next_state <= state2;
				--state 3
				elsif(sensor_l = '0' and sensor_m = '1' and sensor_r = '1') then
					next_state <= state3;
				--state 4
				elsif(sensor_l = '1' and sensor_m = '0' and sensor_r = '0') then
					next_state <= state4;
				--state 5
				elsif(sensor_l = '1' and sensor_m = '0' and sensor_r = '1') then
					next_state <= state5;
				--state 6	
				elsif(sensor_l = '1' and sensor_m = '1' and sensor_r = '0') then
					next_state <= state6;
				--state 7
				elsif(sensor_l = '1' and sensor_m = '1' and sensor_r = '1') then
					next_state <= state7;
				--If everything fails
				else next_state <= reset_state;
				end if;

			when state0 =>
				--go forward
				motor_l_direction 	<= '1';
				motor_r_direction 	<= '0';
				motor_l_reset		<= '0';
				motor_r_reset		<= '0';
				count_reset		<= '0';
				next_state 		<= state0;				

			when state1 =>
				--go left
				motor_l_direction 	<= '1';
				motor_r_direction	<= '0';
				motor_l_reset		<= '0';
				motor_r_reset		<= '1';
				count_reset		<= '0';
				next_state 		<= state1;

			when state2 => 
				--go forward
				motor_l_direction 	<= '1';
				motor_r_direction 	<= '0';
				motor_l_reset		<= '0';
				motor_r_reset		<= '0';
				count_reset		<= '0';
				next_state 		<= state2;

			when state3 => 
				--go hard left
				motor_l_direction 	<= '0';
				motor_r_direction	<= '0';
				motor_l_reset		<= '0';
				motor_r_reset		<= '0';
				count_reset		<= '0';
				next_state 		<= state3;

			when state4 =>
				--go right
				motor_l_direction 	<= '1';
				motor_r_direction	<= '0';
				motor_l_reset		<= '0';
				motor_r_reset		<= '1';
				count_reset		<= '0';
				next_state 		<= state4;

			when state5 =>
				--go forward
				motor_l_direction 	<= '1';
				motor_r_direction 	<= '0';
				motor_l_reset		<= '0';
				motor_r_reset		<= '0';
				count_reset		<= '0';
				next_state 		<= state5;

			when state6 =>
				--go hard right
				motor_l_direction 	<= '1';
				motor_r_direction	<= '1';
				motor_l_reset		<= '0';
				motor_r_reset		<= '0';
				count_reset		<= '0';
				next_state 		<= state6;

			when state7 =>
				--go forward
				motor_l_direction 	<= '1';
				motor_r_direction 	<= '0';
				motor_l_reset		<= '0';
				motor_r_reset		<= '0';
				count_reset		<= '0';
				next_state 		<= state7;
				
					
		end case;
	end process;
end architecture control;
