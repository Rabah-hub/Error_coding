LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Encoder_tb IS
END Encoder_tb;

ARCHITECTURE behav OF Encoder_tb IS
    -- Constants
    	CONSTANT c_Clk_Period : TIME := 20 ns;
    	CONSTANT c_SIM_TIME   : TIME := 600 ns; -- Simulation time
    -- Signals
    	SIGNAL s_clk 			  : STD_LOGIC := '1';
     	SIGNAL s_res 		      : STD_LOGIC := '0';
    	SIGNAL s_Data_in 		  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0001";
    	SIGNAL s_Serial_Data_Out  : STD_LOGIC;
        SIGNAL s_sync_en		  : STD_LOGIC;

    -- Component instantiation
    COMPONENT Encoder
        PORT (clk, res 			: IN STD_LOGIC;
              Data_in			: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
              Serial_Data_Out	: OUT STD_LOGIC;
              sync_en			: OUT STD_LOGIC);
    END COMPONENT;

BEGIN
    -- Instantiate the UUT (Unit Under Test)
    UUT : Encoder
        PORT MAP (clk 				    => s_clk,
            		res 				=> s_res,
            		Data_in 			=> s_Data_in,
            		Serial_Data_Out		=> s_Serial_Data_Out);
                    sync_en			=> s_sync_en);

    CLOCK_PROCESS: PROCESS
    BEGIN
        WHILE NOW < c_SIM_TIME LOOP
               s_clk <= NOT s_clk AFTER c_Clk_Period/2;
               WAIT FOR c_Clk_Period/2;
        END LOOP;
        WAIT;
    END PROCESS;

    STIMULUS_PROCESS: PROCESS
    BEGIN
    -- Apply reset and input data
        s_res 			<= '1';
        s_Data_in		<= "0000";
        WAIT FOR c_Clk_Period;

    -- Remove reset condition 
        s_res 		<= '0';
        WAIT FOR c_Clk_Period/2; -- wait 1/2 a clock cycle so that input is 
                                 -- not changing at the same time as the positive clock edge.
---------------------------------------------------------------------------
     -- 1st test input added   
        s_Data_in		<= "1111";    
        WAIT FOR 7 * c_Clk_Period; 
---------------------------------------------------------------------------
    -- 2nd test input added
        s_Data_in		<= "0111";
        WAIT FOR 7 * c_Clk_Period;
---------------------------------------------------------------------------
     --3rd test input 
        s_Data_in		<= "1001";
        WAIT FOR 7 * c_Clk_Period;
  
        WAIT FOR c_SIM_TIME; -- Stop the simulation after reaching the simulation time
        ASSERT false REPORT "Simulation finished" SEVERITY NOTE;
        WAIT;
    END PROCESS STIMULUS_PROCESS;

END behav;    
