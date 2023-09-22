library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity xtea_tean_encrypt is -- this existis inside xtea encryption aswell
	port(
		encrypt_clk 					:in std_logic;
		encrypt_data_valid			:in std_logic;
		encrypt_data_word			:in std_logic_vector(63 downto 0);
		encrypt_subkey				:in std_logic_vector(31 downto 0);
		
		encrypt_ciphertext_word	:out std_logic_vector(63 downto 0));
end xtea_tean_encrypt;


    architecture func of xtea_tean_encrypt is
      
	   signal value_half_1			: std_logic_vector(31 downto 0);
	   signal value_half_2			: std_logic_vector(31 downto 0);
	   
	   signal shifted_half	: std_logic_vector(31 downto 0);
	   
    	signal left_shifted_a	: std_logic_vector(31 downto 0);
	   signal right_shifted_b	: std_logic_vector(31 downto 0);
	   signal encryption_value_half		: std_logic_vector(31 downto 0);
	
           begin	
             --left shift 2nd current half value by 4
	               left_shifted_a <=std_logic_vector(shift_left(unsigned(value_half_2), 4));
	               
	               
	               right_shifted_b <=std_logic_vector(shift_right(unsigned(value_half_2), 5));		
	
	               shifted_half <= std_logic_vector(unsigned((left_shifted_a xor right_shifted_b)) + unsigned(value_half_2));
	               encryption_value_half <= std_logic_vector(unsigned(shifted_half xor encrypt_subkey) + unsigned(value_half_1));

	               value_half_1 <= encrypt_data_word(31 downto 0) when encrypt_data_valid = '1';
	               value_half_2 <= encrypt_data_word(63 downto 32) when encrypt_data_valid = '1';
	
	               encrypt_ciphertext_word(31 downto 0)  <= value_half_2;
	               encrypt_ciphertext_word(63 downto 32) <= encryption_value_half;
end func;