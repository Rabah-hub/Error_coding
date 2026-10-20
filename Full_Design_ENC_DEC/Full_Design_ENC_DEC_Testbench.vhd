LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Full_Enc_Dec_74_tb IS
END Full_Enc_Dec_74_tb;

ARCHITECTURE behav OF Full_Enc_Dec_74_tb IS
    -- Constants
    	CONSTANT c_Clk_Period : TIME := 20 ns;
    	CONSTANT c_SIM_TIME   : TIME := 620 ns; -- Simulation time
    -- Signals
    	SIGNAL s_clk 			: STD_LOGIC := '1';
   	SIGNAL s_res 		        : STD_LOGIC := '0';
    	SIGNAL s_Data_in 		: STD_LOGIC_VECTOR(3 DOWNTO 0) 	:= "0001";
       	SIGNAL s_Error_bit  	: STD_LOGIC;
        	SIGNAL s_sync		: STD_LOGIC;
        	SIGNAL s_Data_Out	: STD_LOGIC_VECTOR(3 downto 0);

    -- Component instantiation
    COMPONENT Full_Enc_Dec_74
        PORT (clk, res    	: IN STD_LOGIC;
          Data_in			: IN STD_LOGIC_VECTOR(3 downto 0);
          Error_bit			: IN STD_LOGIC := '0';
          sync				: OUT STD_LOGIC;
          Data_Out			: OUT STD_LOGIC_VECTOR(3 downto 0));
    END COMPONENT;

BEGIN
    -- Instantiate the UUT (Unit Under Test)
    UUT : Full_Enc_Dec_74
        PORT MAP (  clk 			=> s_clk,
            		res 			=> s_res,
            		Data_in 		=> s_Data_in,
                    Error_bit   	=> s_Error_bit,
                    sync		    => s_sync,
            		Data_Out		=> s_Data_Out);

    -- Clock process
    CLOCK_PROCESS: PROCESS
    BEGIN
        WHILE NOW < c_SIM_TIME LOOP
                      s_clk <= NOT s_clk AFTER c_Clk_Period/2;
                     WAIT FOR c_Clk_Period/2;
        END LOOP;
        WAIT;
    END PROCESS;

    -- Stimulus process
       STIMULUS_PROCESS: PROCESS
    BEGIN
------------------------------------------------------------------------------------------------
    -- Apply reset and input added
        s_res 		<= '1';
        s_Data_in		<= "0010";
        s_Error_bit 	<= '0';
        WAIT FOR c_Clk_Period;
    -- Remove reset condition 
        s_res 		<= '0';
------------------------------------------------------------------------------------------------
    -- 1st test input added
        s_Data_in	<= "1111";
        WAIT FOR 7 * c_Clk_Period;                                 
------------------------------------------------------------------------------------------------
     -- 2nd test input added   
        s_Data_in		<= "0111"; -- apply input data 
        WAIT FOR 1 * c_Clk_Period;
        s_Error_bit <= '1';        -- induce an error bit 
        WAIT FOR 1 * c_Clk_Period;
        s_Error_bit <= '0';  
        WAIT FOR 4 * c_Clk_Period;
------------------------------------------------------------------------------------------------
     --3rd test input 
        s_Data_in	<= "1001";
        WAIT FOR 20 * c_Clk_Period;
------------------------------------------------------------------------------------------------  
        
              std.env.stop;       
        wait;                
    END PROCESS;
      
END behav;    


















