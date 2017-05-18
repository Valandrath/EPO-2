library IEEE;
use IEEE.std_logic_1164.all;

entity top_level is
	port(	clk		: in std_logic;
		reset		: in std_logic; 
		sensor_l_top	: in std_logic;
		sensor_m_top	: in std_logic; 
		sensor_r_top	: in std_logic;
	
		motor_l		: out std_logic; 
		motor_r		: out std_logic
		);
end top_level;

architecture behaviour of top_level is
	
	--inputbuffer component
	component inputbuffer is
		port(clk, sensor_l_in, sensor_m_in, sensor_r_in: in std_logic;
		sensor_l_out, sensor_m_out, sensor_r_out: out std_logic);
	end component inputbuffer;

	--controller component
	component controller is
		port(clk, reset, sensor_l, sensor_m, sensor_r: in std_logic;
		count_in: in std_logic_vector (19 downto 0);
		count_reset, motor_l_reset, motor_l_direction, motor_r_reset, motor_r_direction: out std_logic);
	end component controller;
	
	--timebase component
	component timebase is
		port(clk, reset: in std_logic;
		count_out: out std_logic_vector (19 downto 0));
	end component timebase;

	--motorcontroller component
	component motorcontrol is
		port(clk, reset, direction: in std_logic;
		count_in: in std_logic_vector (19 downto 0);
		pwm: out std_logic);
	end component motorcontrol;
	
signal IB_Controller_l, IB_Controller_m, IB_Controller_r, Controller_MC_l_direction, Controller_MC_l_reset, Controller_MC_r_direction, Controller_MC_r_reset, Timebase_MC_l, Timebase_MC_R, counter_reset : std_logic;
signal Timebase_Out: std_logic_vector(19 downto 0);

begin
	--Inputbuffer
	IB: inputbuffer port map (clk => clk,
					sensor_l_in => sensor_l_top, sensor_m_in => sensor_m_top, sensor_r_in => sensor_r_top,
					sensor_l_out => IB_Controller_l, sensor_m_out => IB_Controller_m, sensor_r_out => IB_Controller_r);
	
	--Timebase
	T: timebase port map (clk => clk, reset => counter_reset, count_out => Timebase_Out);

	--Controller
	C: controller port map (clk => clk, reset => reset,
					sensor_l => IB_Controller_l, sensor_m => IB_Controller_m, sensor_r => IB_Controller_r,
					count_in => Timebase_Out,
					count_reset => counter_reset, 
					motor_l_reset => Controller_MC_l_reset, motor_l_direction => Controller_MC_l_direction,
					motor_r_reset => Controller_MC_r_reset, motor_r_direction => Controller_MC_r_direction);

	--Motors
	Ml: motorcontrol port map (clk => clk, reset => Controller_MC_l_reset, direction => Controller_MC_l_direction, count_in => Timebase_Out, pwm => motor_l);
	Mr: motorcontrol port map (clk => clk, reset => Controller_MC_r_reset, direction => Controller_MC_r_direction, count_in => Timebase_Out, pwm => motor_r);

end architecture behaviour;
