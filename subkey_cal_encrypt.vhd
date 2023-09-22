library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity subkey_cal_encrypt is
	port(
		--inputs
	  subkey_clk			:in std_logic;
		subkkey_level			:in std_logic;
		
		subkey_key_valid	:in std_logic;
		subkey_key_word		:in std_logic_vector(127 downto 0);
		subkey_set_1 	:out std_logic_vector(31 downto 0);
		subkey_set_2 	:out std_logic_vector(31 downto 0));
end subkey_cal_encrypt;




architecture func of subkey_cal_encrypt is
	signal selection_1			:std_logic_vector(1 downto 0);
	signal selection_2			:std_logic_vector(1 downto 0);
	signal sum_1			:std_logic_vector(31 downto 0) := "00000000000000000000000000000000"; --set up 32 bit empty value
	signal sum_2			:std_logic_vector(31 downto 0) := X"9E3779B9"; --DELTA VALUE
	signal selected_key_for_cal_1:std_logic_vector(31 downto 0);
	signal selected_key_for_cal_2:std_logic_vector(31 downto 0);
	
	
	
	
	
begin
  -- this will assign a value to sub key set 1 that is made up of the value held by sum1+seleteckeyfor_cal1 
	subkey_set_1 <= std_logic_vector( unsigned(selected_key_for_cal_1) + unsigned(sum_1));
	
	-- this does the same thing for the second calculation
	subkey_set_2 <= std_logic_vector( unsigned(selected_key_for_cal_2) + unsigned(sum_2));
	
	--this covers the but that adds delta + the sum1
	sum_2 <= std_logic_vector( unsigned(sum_1) + X"9E3779B9");
	
	--this but sets selection1 to the first bit of sum 1 and selection2 to the last bit of sum 2
	selection_1 <= sum_1(1 downto 0);
	
	selection_2 <= sum_2(12 downto 11);
	
	
	
	-- move each part of the subkey key word into the calculation value in turn when selection 1 is in correct config
	--basically FSM
	with selection_1 select
		  selected_key_for_cal_1 <= subkey_key_word(31 downto 0)	when "00", 
									              subkey_key_word(63 downto 32)  when "01",
									              subkey_key_word(95 downto 64)  when "10",
									              subkey_key_word(127 downto 96) when others;
	
	with selection_2 select
	  	selected_key_for_cal_2 <= subkey_key_word(31 downto 0)	 when "00", 
								              	subkey_key_word(63 downto 32)  when "01",
								              	subkey_key_word(95 downto 64)  when "10",
									              subkey_key_word(127 downto 96) when others;
	
	process(subkey_clk)
	  
	   begin
	  
		    if rising_edge(subkey_clk) then
		  
			   if subkey_key_valid ='1' then
			  
			   	if sum_1 = X"28B7BD67" then --clear sum if your in first ecn cycle
				  
				    	sum_1 <= "00000000000000000000000000000000";
					
			   	else
 -- set sum 1 to delta plus sum 1 if your in second cycle				  
				    	sum_1 <= std_logic_vector(unsigned(sum_1) + X"9E3779B9");
					
			   end if;
				
			        else --sorts out error found make sure its 0
				        sum_1 <= "00000000000000000000000000000000";
			      end if;
		   end if;
	end process;
end func;