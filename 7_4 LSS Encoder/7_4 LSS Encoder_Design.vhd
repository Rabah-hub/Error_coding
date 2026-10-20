library IEEE;
use IEEE.STD_LOGIC_1164.all;

ENTITY Encoder IS
    PORT (
        clk, res           : IN STD_LOGIC;                    -- clock and reset
        Data_in            : IN STD_LOGIC_VECTOR(3 downto 0); -- 4-bit input data
        Serial_Data_Out    : OUT STD_LOGIC;                   -- encoded serial output
        sync_en            : OUT STD_LOGIC                    -- indicates data load
    );
END Encoder;
 
ARCHITECTURE behav of Encoder is
SIGNAL Enc_input   : STD_LOGIC_VECTOR(3 downto 0) := (others => '0'); -- shift register for input data
SIGNAL Enc_Control : STD_LOGIC_VECTOR(6 downto 0) := (others => '0'); -- 7-bit timing/control register
SIGNAL Enc_txlss   : STD_LOGIC_VECTOR(3 downto 1) := (others => '0'); -- LSS shift register
SIGNAL Enc_sync    : STD_LOGIC := '0';                                -- sync flag

BEGIN
PROCESS
BEGIN  
    WAIT UNTIL (clk'EVENT AND clk = '1');

    IF res = '1' THEN 
        -- reset all registers
        Enc_input   <= (others => '0');
        Enc_Control <= "1000000";  -- initialise control sequence
        Enc_txlss   <= (others => '0');
        Enc_sync    <= '0';

    ELSE 
        -- rotate control register (7-cycle sequence)
        Enc_Control <= Enc_Control(0) & Enc_Control(6 DOWNTO 1);

        -- shift LSS register
        Enc_txlss <= Enc_txlss(2 downto 1) & Enc_input(0);
        
        -- load new data at start of frame
        IF (Enc_control(0) = '1') THEN
            Enc_input <= Data_in;   -- parallel load
            Enc_sync  <= '1';       -- indicate new data valid
        ELSE 
            Enc_input <= '0' & Enc_input(3 downto 1); -- shift right
        END IF;
        
        -- LSS encoding: x + D^2x + D^3x
        Serial_Data_Out <= Enc_input(0) XOR Enc_txlss(2) XOR Enc_txlss(3);

        sync_en <= Enc_sync;  -- output sync signal
    END IF;

END PROCESS;
 		 	 
END behav;
