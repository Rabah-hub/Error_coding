library IEEE;
use IEEE.STD_LOGIC_1164.all;

ENTITY Full_Enc_Dec_74 IS
    PORT (clk, res    		: IN STD_LOGIC;
          Data_in			: IN STD_LOGIC_VECTOR(3 downto 0);
          Error_bit			: IN STD_LOGIC;
          sync			    : OUT STD_LOGIC;
          Data_Out		    : OUT STD_LOGIC_VECTOR(3 downto 0));

END Full_Enc_Dec_74;
 
ARCHITECTURE behav of Full_Enc_Dec_74 is
SIGNAL Enc_RegIP		: STD_LOGIC_VECTOR(3 downto 0):= (others => '0');
SIGNAL Enc_Control		: STD_LOGIC_VECTOR(6 downto 0):= (others => '0');
SIGNAL Enc_txlss 		: STD_LOGIC_VECTOR(3 downto 1):= (others => '0');
SIGNAL Enc_RegOp		: STD_LOGIC := '0';
SIGNAL Enc_sync 		: STD_LOGIC := '0';   

SIGNAL Received		: STD_LOGIC := '0';

SIGNAL Dec_start		: STD_LOGIC := '0';
SIGNAL Dec_rxlss		: STD_LOGIC_VECTOR(3 downto 1):= (others => '0');
SIGNAL Dec_Control		: STD_LOGIC_VECTOR(6 downto 0):= (others => '0');
SIGNAL Dec_sipo			: STD_LOGIC_VECTOR(6 downto 0):= (others => '0');
SIGNAL Dec_errorcode 	: STD_LOGIC_VECTOR(2 downto 0):= ("000");


BEGIN
---------------------------------------------------------------------------------------------------
Encoder: PROCESS
    BEGIN  
         WAIT UNTIL (clk'EVENT AND clk = '1');
	IF res = '1' THEN 
	    Enc_RegIP 		<= (others => '0');
		Enc_Control 	<= "1000000";
        Enc_txlss   	<= (others => '0');
		Enc_sync	    <= '0';
	ELSE 
	
		Enc_Control  <= Enc_Control(0) & Enc_Control(6 DOWNTO 1);
       	Enc_txlss    <= Enc_txlss(2 downto 1) & Enc_RegIP(0);
        
	  IF (Enc_control(6) ='1') THEN
		 	Enc_RegIP   <= Data_in;  
            Enc_sync	<= '1'; 
      ELSE 
        	Enc_RegIP 	<=  '0' & Enc_RegIP(3 downto 1); 
         
	  END IF;
        
       	Enc_RegOp 	<= Enc_RegIP(0) XOR Enc_txlss(2) XOR Enc_txlss(3);
       	sync 	 	<= Enc_sync;  
    END IF;
END PROCESS;
---------------------------------------------------------------------------------------------------
Induce_Error: PROCESS(Enc_RegOp, Error_bit) 

BEGIN
   Received  <= Enc_RegOp XOR Error_bit;

END PROCESS;
---------------------------------------------------------------------------------------------------
Decoder: PROCESS
BEGIN
	--Dec_errorcode <= Dec_sipo(6 downto 4);

	WAIT UNTIL (clk'EVENT AND clk = '1');
 	   IF (Enc_sync = '1' AND Dec_start = '0' ) THEN 	 
			Dec_control	  	<= "1000000";
			Dec_rxlss 	  	<= "000"; 
			Dec_sipo	  	<= "0000000";
            Dec_errorcode 	<= "000";
           	Dec_start     	<= '1';
            
       ELSE  
	   		Dec_rxlss(1)   <= (Received XOR Dec_rxlss(3) XOR Dec_rxlss(2)) AND NOT(Dec_control(0)); 
   	   		Dec_rxlss(2)   <= Dec_rxlss(1) AND NOT(Dec_control(0));
	   		Dec_rxlss(3)   <= Dec_rxlss(2) AND NOT (Dec_control(0));
 	   		Dec_sipo 	   <= (Received XOR Dec_rxlss(3) XOR Dec_rxlss(2)) & Dec_sipo(6 downto 1); 
            Dec_errorcode  <= (Received XOR Dec_rxlss(3) XOR Dec_rxlss(2)) & Dec_errorcode(2 downto 1);
 
	IF Dec_control(6)= '1' THEN  
	      CASE (Dec_errorcode) IS
              WHEN  "001"    => Data_Out <= (Dec_sipo(3 downto 0)) XOR ("1101");
	          WHEN  "011"    => Data_Out <= (Dec_sipo(3 downto 0)) XOR ("1010");
		      WHEN  "111"    => Data_Out <= (Dec_sipo(3 downto 0)) XOR ("0100");
	          WHEN  "110"    => Data_Out <= (Dec_sipo(3 downto 0)) XOR ("1000");
              WHEN OTHERS 	 => Data_Out <= Dec_sipo(3 downto 0);  
          END CASE;
	 END IF;
     
		Dec_control <= (Dec_control(0)) & (Dec_control(6 downto 1));
        
           END IF;
END PROCESS;
    
END behav;

