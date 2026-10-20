library IEEE;
use IEEE.std_logic_1164.all;

-- Testbench entity has no ports because it is the top-level simulation wrapper
entity decoder74_tb is
end decoder74_tb;

architecture tb of decoder74_tb is
 -- DUT Port Signals
    signal s_clk  : std_logic := '0';               -- Testbench clock signal
    signal s_res  : std_logic := '0';               -- Testbench reset signal
    signal s_sin  : std_logic := '0';               -- Serial input stimulus to decoder
    signal s_dout : std_logic_vector(3 downto 0);   -- Decoder output to be observed

 -- Clock period constant
    constant CLK_PERIOD : time := 20 ns;
    
 -- Component declaration
    COMPONENT decoder74
        PORT (clk, res, sin	: IN STD_LOGIC;
                 dout		: OUT STD_LOGIC_VECTOR(3 downto 0));
    END COMPONENT;

begin
    -- Instantiate the DUT and connect internal testbench signals to its ports
    DUT: decoder74
        port map ( clk  => s_clk,
                   res  => s_res,
                   sin  => s_sin,
                   dout => s_dout );

    clk_process : process
    begin
        s_clk <= '0';
        wait for CLK_PERIOD/2;
        s_clk <= '1';
        wait for CLK_PERIOD/2;
    end process;

    stim_proc : process
        variable data_stream : std_logic_vector(13 downto 0) := "10110001111000";
    begin
        s_res <= '1';
        s_sin <= '0';
            wait for CLK_PERIOD;
        s_res <= '0';  

        for i in data_stream'range loop
            s_sin <= data_stream(i);
            wait for CLK_PERIOD;     
        end loop;
        s_sin <= '0';
            wait for 7*CLK_PERIOD;
            std.env.stop;  -- stop simulation      
        wait;                
    end process;

end tb; 
