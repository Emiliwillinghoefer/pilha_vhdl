library IEEE;
use IEEE.std_logic_1164.all;

entity pilha is
  Port ( 
			CLK: in std_logic;
			RESET: in std_logic;
			DATA_IN : in std_logic_vector(7 downto 0);
			POP : in std_logic;
			PUSH : in std_logic;
			DATA_OUT : out std_logic_vector(7 downto 0));
end entity;

architecture principal of pilha is
	type DATA_ARRAY is array (integer range <>) of std_logic_vector(0 to 7);
	signal DATA: DATA_ARRAY (0 to 7);
	SIGNAL estado : INTEGER RANGE 3 DOWNTO 0;
	SIGNAL aux_ptr: INTEGER RANGE 0 TO 8;
	
BEGIN
	PROCESS (CLK, RESET)
	variable PTR: integer range 0 to 8;
		BEGIN
			IF RESET = '0' THEN -- estado inicial
				estado <= 0;
				PTR:= 0;
				DATA <=(others =>(others => '0'));
				DATA_OUT <=(others => '0');
				
			ELSIF (CLK'EVENT and CLK ='1') THEN -- ciclo de estados
				CASE estado IS
							
					WHEN 0 => -- INTERMEDIARIO	
						IF PUSH = '1' THEN 
							estado <= 1;
						ELSIF POP = '1' THEN 
							estado <= 2; 		
						else estado<=0;
						END IF;

					WHEN 1 => -- Estado de Push						
						IF PTR /= 7 THEN
							DATA(PTR) <= DATA_IN;
							PTR := (PTR+1);
							estado <= 3;
						ELSE estado <= 0;
						END IF;
						
					WHEN 2 => -- Estado de Pop	
						IF PTR /= 0 THEN
							PTR := (PTR-1);
							estado <= 3;
						ELSIF PTR = 0 THEN 
							DATA(PTR) <= (others => '0');
						ELSE estado <= 0;
						END IF;
						
					WHEN 3 => 	
						IF PUSH = '1' THEN	
							estado <= 3;
						ELSIF POP = '1' THEN
							estado <= 3;
						ELSIF PUSH = '0' AND POP = '0' THEN
							estado <= 0;
						END IF;
		
				END CASE;
			END IF;
			DATA_OUT <= DATA(PTR);
		END PROCESS;
		--DATA_OUT <= DATA(aux_ptr);
end architecture;