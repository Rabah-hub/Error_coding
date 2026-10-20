library IEEE;
use IEEE.std_logic_1164.all;

ENTITY decoder1511 IS
	PORT  (clk, res, sin 	: IN STD_LOGIC;
               	 dout       : OUT STD_LOGIC_VECTOR(10 downto 0));   
END decoder1511;
 
ARCHITECTURE behaviour OF decoder1511 IS
SIGNAL   control 	: STD_LOGIC_VECTOR(14 downto 0);	   -- Internal signals
SIGNAL   rxlss   	: STD_LOGIC_VECTOR(4 downto 1);
SIGNAL   sipo    	: STD_LOGIC_VECTOR(14 downto 0);
SIGNAL   errorcode 	: STD_LOGIC_VECTOR(3 downto 0);
 
BEGIN
	errorcode <= sipo(14 downto 11);

PROCESS
	BEGIN
	    WAIT UNTIL (clk'EVENT AND clk = '1');
        
 		IF (res = '1') THEN 		 
			control	<= '1' & (13 downto 0 => '0');      -- "100000000000000"
			rxlss 	<= (others => '0');             	-- "0000" 
		    sipo	<= (others => '0');                 -- "000000000000000"
            
        ELSIF (res = '0') THEN       -- Normal Behaviour     
	   		rxlss(1) <= (sin XOR rxlss(4) XOR rxlss(3)) AND NOT(control(0)); 
   	   		rxlss(2) <= rxlss(1) AND NOT(control(0));
	  		rxlss(3) <= rxlss(2) AND NOT (control(0));
            rxlss(4) <= rxlss(3) AND NOT (control(0));
            
 	  		sipo     <= (sin XOR rxlss(4) XOR rxlss(3)) & sipo(14 downto 1); 
 
		IF control(14)= '1' THEN     -- Assessor and Corrector
	      		CASE (errorcode) IS
                    WHEN  "0001"      => dout <= (sipo(10 downto 0)) XOR "11101011001";
 	                WHEN  "0011"      => dout <= (sipo(10 downto 0)) XOR "11010110010";
	                WHEN  "0111"      => dout <= (sipo(10 downto 0)) XOR "10101100100";
	                WHEN  "1111"      => dout <= (sipo(10 downto 0)) XOR "01011001000";
	                WHEN  "1110"      => dout <= (sipo(10 downto 0)) XOR "10110010000";
                	WHEN  "1101"      => dout <= (sipo(10 downto 0)) XOR "01100100000";
                	WHEN  "1010"      => dout <= (sipo(10 downto 0)) XOR "11001000000";
                	WHEN  "0101"      => dout <= (sipo(10 downto 0)) XOR "10010000000";
                	WHEN  "1011"      => dout <= (sipo(10 downto 0)) XOR "00100000000";
                	WHEN  "0110"      => dout <= (sipo(10 downto 0)) XOR "01000000000";
                	WHEN  "1100"      => dout <= (sipo(10 downto 0)) XOR "10000000000";
                	WHEN OTHERS       => dout <= sipo(10 downto 0);  
 
          		END CASE;
	 	END IF;
        
		control <= (control(0))& (control(14 downto 1));
        
        END IF;
END PROCESS;  
END behaviour;
