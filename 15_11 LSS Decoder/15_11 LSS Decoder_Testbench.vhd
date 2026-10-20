library IEEE;
use IEEE.std_logic_1164.all;

entity decoder1511_tb is
end decoder1511_tb;

architecture tb of decoder1511_tb is
 -- DUT Port Signals
    signal s_clk  : std_logic := '0';
    signal s_res  : std_logic := '0';
    signal s_sin  : std_logic := '0';
    signal s_dout : std_logic_vector(10 downto 0);

 -- Clock period constant
    constant CLK_PERIOD : time := 20 ns;
    CONSTANT c_SIM_TIME : TIME := 940 ns; -- Simulation time

    
 -- Component instantiation
    COMPONENT decoder1511
        PORT (clk, res, sin	: IN STD_LOGIC;
                 dout		: OUT STD_LOGIC_VECTOR(10 downto 0));
    END COMPONENT;

begin
    DUT: decoder1511
        port map ( clk  => s_clk,
                   res  => s_res,
                   sin  => s_sin,
                   dout => s_dout );

    
        -- Clock process
    CLOCK_PROCESS: PROCESS
    BEGIN
        WHILE NOW < c_SIM_TIME LOOP
                      s_clk <= NOT s_clk AFTER CLK_PERIOD/2;
                     WAIT FOR CLK_PERIOD/2;
        END LOOP;
        WAIT;
    END PROCESS;
      

    stim_proc : process
        variable data_valid       : std_logic_vector(14 downto 0) := "110101000000000";
        variable data_1biterror   : std_logic_vector(14 downto 0) := "111101000000000";
    begin
        s_res <= '1';
        s_sin <= '0';
        wait for CLK_PERIOD;
        s_res <= '0';  

        for i in data_valid'range loop
            s_sin <= data_valid(i);
            wait for CLK_PERIOD;     
        end loop;
        
        for i in data_1biterror'range loop
            s_sin <= data_1biterror(i); 
            wait for CLK_PERIOD;
        end loop; 
        
        s_sin <= '0';
        wait for 15*CLK_PERIOD;  -- allow last frame to fully update dout
        std.env.stop;       
        wait; 
        
    end process;

end tb; 
