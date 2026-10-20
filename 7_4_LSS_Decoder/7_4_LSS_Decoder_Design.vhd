-- Include IEEE library for std_logic types
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entity declaration defines the interface of the decoder
ENTITY decoder74 IS
    PORT (
        clk  : IN STD_LOGIC;  -- Clock signal: synchronises all operations (rising edge triggered)
        res  : IN STD_LOGIC;  -- Reset signal: initializes/clears internal registers when active
        sin  : IN STD_LOGIC;  -- Serial input: receives encoded data bit-by-bit
        dout : OUT STD_LOGIC_VECTOR(3 downto 0) -- Parallel output: 4-bit decoded data (original message after error correction)
    );   
END decoder74;
 
ARCHITECTURE behaviour OF decoder74 IS
SIGNAL   control 	: STD_LOGIC_VECTOR(6 downto 0);	   -- Internal signals
SIGNAL   rxlss   	: STD_LOGIC_VECTOR(3 downto 1);
SIGNAL   sipo    	: STD_LOGIC_VECTOR(6 downto 0);
SIGNAL   errorcode 	: STD_LOGIC_VECTOR(2 downto 0);
 
BEGIN
	errorcode <= sipo(6 downto 4);

PROCESS
	BEGIN
	    WAIT UNTIL (clk'EVENT AND clk = '1');
        
 		IF (res = '1') THEN 		 
			control	<= "1000000";
			rxlss 	<= "000"; 
			sipo	<= "0000000";
            
        ELSIF (res = '0') THEN       -- Normal Behaviour     
	   		rxlss(1) <= (sin XOR rxlss(3) XOR rxlss(2)) AND NOT(control(0)); 
   	   		rxlss(2) <= rxlss(1) AND NOT(control(0));
	  		rxlss(3) <= rxlss(2) AND NOT (control(0));
            
 	  		sipo     <= (sin XOR rxlss(3) XOR rxlss(2)) & sipo(6 downto 1); 
 
		IF control(6)= '1' THEN     -- Assessor and Corrector
	      		CASE (errorcode) IS
                    WHEN  "001"    =>    dout <= (sipo(3 downto 0)) XOR ("1101");
	            	WHEN  "011"    =>    dout <= (sipo(3 downto 0)) XOR ("1010");
			        WHEN  "111"    =>    dout <= (sipo(3 downto 0)) XOR ("0100");
	            	WHEN  "110"    =>    dout <= (sipo(3 downto 0)) XOR ("1000");
                	WHEN OTHERS    =>    dout <= sipo(3 downto 0);  
          		END CASE;
	 	END IF;
        
		control <= (control(0))& (control(6 downto 1));
        
        END IF;
END PROCESS;  
END behaviour;
