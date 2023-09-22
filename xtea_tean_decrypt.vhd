library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity xtea_tean_decrypt is -- this existis inside xtea encryption aswell
	port(
		decrypt_clk 					:in std_logic;
		decrypt_data_valid			:in std_logic;
		decrypt_data_word			:in std_logic_vector(63 downto 0);
		decrypt_subkey				:in std_logic_vector(31 downto 0);
		decrypt_ciphertext_word	:out std_logic_vector(63 downto 0));
		
		
end xtea_tean_decrypt;


    architecture func of xtea_tean_decrypt is
      
	   signal value_half_1			: std_logic_vector(31 downto 0); 
	   
	   signal value_half_2			: std_logic_vector(31 downto 0); 
	   
	   signal shifted_half	: std_logic_vector(31 downto 0);
	   
    	signal left_shifted_a	: std_logic_vector(31 downto 0);
	   signal right_shifted_b	: std_logic_vector(31 downto 0);
	   signal decryption_value_half		: std_logic_vector(31 downto 0);
	
           begin	
             
             
             
             --left shift 2nd current half value by 4
	               left_shifted_a <=std_logic_vector(shift_left(unsigned(value_half_1), 4));
	               
	               
	               right_shifted_b <=std_logic_vector(shift_right(unsigned(value_half_1), 5));		
	
	               shifted_half <= std_logic_vector(unsigned((left_shifted_a XOR right_shifted_b)) + unsigned(value_half_1));
	               decryption_value_half <= std_logic_vector(unsigned(value_half_2) - unsigned(shifted_half XOR decrypt_subkey));

	               value_half_1 <= decrypt_data_word(31 downto 0) when decrypt_data_valid = '1';
	               value_half_2 <= decrypt_data_word(63 downto 32) when decrypt_data_valid = '1';
	
	               
	               
	               
	               
	               decrypt_ciphertext_word(31 downto 0)  <= decryption_value_half;
	               
	               	  decrypt_ciphertext_word(63 downto 32) <= value_half_1;
end func;